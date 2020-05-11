package v1.haocheok.list.controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import service.dao.db.Jdbc;
import service.dao.db.Page;
import service.sys.Atm;
import service.sys.ErrMsg;
import v1.haocheok.commom.common;
import v1.haocheok.commom.entity.InfoEntity;
import v1.haocheok.list.service.impl.WaitingServiceImpl;

/**
 * 业务主管 办理中列表
 * @author wo
 *
 */
public class AppSalesmanerList {

	public void SalesmanerList(HttpServletRequest request, HttpServletResponse response,String RequestJson,InfoEntity info) throws ServletException, IOException {

		Jdbc db = new Jdbc();
		Page page = new Page();

		
        String claspath=this.getClass().getName();//当前类名
		response.setContentType("text/html;charset=UTF-8");
		request.setCharacterEncoding("UTF-8");
		response.setCharacterEncoding("UTF-8");
    	PrintWriter out = response.getWriter();
	    	
    	
		//定义接收变量值
		String regionalcode="";      //区域code
       	String rolecode="";         //角色code
       	String keyword="";      
	    String Dpage = "1";     
		String listnum="10";    
		String responsejson="";
		String classname="APP业务主管办理中列表";
		String username=common.getusernameTouid(info.getUSERID());
		JSONObject json = new JSONObject();
	    ArrayList list = new ArrayList();
		  
		//数据接收
		try {
			JSONArray arr = JSONArray.fromObject("[" + RequestJson + "]");
			for (int i = 0; i < arr.size(); i++) {
			   JSONObject obj = arr.getJSONObject(i);
			   keyword= obj.get("keyword") + "";
			   Dpage = obj.get("page") + "";
			   listnum = obj.get("listnum") + "";
			}
		} catch (Exception e) {
			ErrMsg.falseErrMsg(request, response, "500", "json格式解析异常");
			return;
		}
		 
		System.out.println("keyword=========="+keyword);
			    
		//token 认证过滤
	    System.out.println("token 认证过滤==="+"SELECT COUNT(*) as row FROM  user_worker WHERE uid ='"+info.getUSERID()+"' AND app_token='"+ info.getToken() + "'");
		int TokenTag=db.Row("SELECT COUNT(*) as row FROM  user_worker WHERE uid ='"+info.getUSERID()+"' AND app_token='"+ info.getToken() + "'");
		if(TokenTag!=1){
			ErrMsg.falseErrMsg(request, response, "403", "请登录！");
			Page.colseDOP(db, out, page);
			return;//跳出程序只行 
		}  
		
		
		//获取分页信息
		if(Dpage==null || Dpage.indexOf("null")!=-1  ||  Dpage.length()<1){Dpage="1";}
		if(listnum==null || listnum.indexOf("null")!=-1 ||  listnum.length()<1){listnum="10";}
		if(keyword==null || keyword.indexOf("null")!=-1 || keyword.length()==0){keyword="";}

		//分页计算
		HashMap<String, Object> map = common.pagenumMap(Dpage, listnum);
		/****************************************实现业务开始*****************************************************/
		
		try {
			//基本信息
			String base_sql = "SELECT * FROM user_worker,zk_user_role,zk_role WHERE user_worker.uid = zk_user_role.sys_user_id AND zk_user_role.sys_role_id = zk_role.id AND uid = '"+info.getUSERID()+"'";
			
			ResultSet basePrs = db.executeQuery(base_sql); 
			if(basePrs.next()){
				rolecode = basePrs.getString("rolecode");
				regionalcode = basePrs.getString("regionalcode");
			}
			
			String order_sql =  "SELECT order_customerfile.customername,order_customerfile.phonenumber,temp1.orderid AS orderid, " +
								"ordercode,temp1.processid AS processid,loantype,order_sheet.createtime AS createtime,order_sheet.salesmanname as salesmanname FROM " +
								"(SELECT orderid,creation_date,regionalcode,STATUS,rolename,processid FROM " +
								"(SELECT orderid,creation_date,regionalcode,STATUS,rolename,processid FROM process_log ORDER BY creation_date DESC ) " +
								"AS `temp` GROUP BY orderid) " +
								"AS `temp1`,order_sheet,order_customerfile " +
								"WHERE order_customerfile.customername LIKE '%"+keyword+"%' " +
								"AND temp1.orderid = order_sheet.id " +
								"AND order_sheet.customeruid = order_customerfile.id " +
								"AND temp1.regionalcode LIKE '"+regionalcode+"%' " +
								"LIMIT "+map.get("DQcount2")+","+map.get("listnum2")+";";
			
			System.out.println("order_sql"+order_sql);
			
			
			
			JSONObject json_order = new JSONObject();
			ResultSet orderPr = db.executeQuery(order_sql);
			while(orderPr.next()){
				json_order.put("orderid", orderPr.getString("orderid"));
				json_order.put("ordercode",orderPr.getString("ordercode"));
				json_order.put("processid", orderPr.getString("processid"));
				json_order.put("customername",orderPr.getString("customername"));
				json_order.put("loantype", orderPr.getString("loantype"));
				json_order.put("financetype", "抵押贷款");
				json_order.put("phone", orderPr.getString("phonenumber"));
				json_order.put("salesmanname", orderPr.getString("salesmanname"));
				json_order.put("orderstatus", "测试状态-外检师正在办理中");
				json_order.put("timeconsum", "1天2小时");
				json_order.put("createtime", orderPr.getString("order_sheet.createtime"));
				list.add(json_order.toString());
			}
			//放入返回值
			json.put("success", "true");
			json.put("resultCode", "1000");
			json.put("msg", "获取业务员主管办理中列表");
			json.put("info", list.toString());
System.out.println("json::::"+json.toString());
			regionalcode = json.toString();
			
			// 记录执行日志
			long ExeTime = Calendar.getInstance().getTimeInMillis()-info.getTimeStart();
			Atm.AppuseLong(info, username,  this.getClass().getName(), classname, responsejson, ExeTime);
			//添加操作日志
			Atm.LogSys("获取业务主管办理中列表", "用户APP端成功", "用户"+username+"获取主管办理中列表", "0",info.getUSERID(), info.getIp());
			
		}catch (Exception e) {
			
			
			int ErrLineNumber = e.getStackTrace()[0].getLineNumber();
			responsejson = "{\"success\":true,\"resultCode\":\"500\",\"msg\":\"服务器开小差了\"}";
			json.put("success", "true");
			json.put("resultCode", "500");
			json.put("msg", "服务器开小差了");
			// 记录执行日志
			long ExeTime = Calendar.getInstance().getTimeInMillis()-info.getTimeStart();
			Atm.AppuseLong(info, username,  this.getClass().getName(), classname, responsejson, ExeTime);
			//添加操作日志
			Atm.LogSys("系统错误", classname+"模块系统出错", "错误信息详见 "+this.getClass().getName()+"第"+ErrLineNumber+"行","1", info.getUSERID(), info.getIp());
			out.println(responsejson);
			Page.colseDP(db, page);
			out.flush();
			out.close();
			return;
			
			
		}
		responsejson = json.toString();
		//返回信息
		out.println(responsejson);
		System.out.println(responsejson);
		//记录日志
		page.colseDP(db, page);
		out.flush();
		out.close();
	}
	
	
}
