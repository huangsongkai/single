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

public class AppCommonList {

	public void getList(HttpServletRequest request, HttpServletResponse response,String RequestJson,InfoEntity info) throws ServletException, IOException {

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
       	String roleid = "";         //角色id
       	String keyword="";      
	    String Dpage = "1";     
		String listnum="10";    
		String buttoncode = "";
		String responsejson="";
		String classname="APP待接单";
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
			   buttoncode = obj.get("buttoncode") + "";
			}
		} catch (Exception e) {
			ErrMsg.falseErrMsg(request, response, "500", "json格式解析异常");
			return;
		}
		
		System.out.println("RequestJson=="+RequestJson);

		//判断过滤非法字符: 
	    /*if(!Page.regex(userid) || !Page.regex(userid)){ 
	    	ErrMsg.falseErrMsg(request, response, "500", "数据格式不匹配");
		    Page.colseDOP(db, out, page);
		    return;//跳出程序只行 
	    }   */ 
			    
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
			String base_sql = "SELECT user_worker.regionalcode AS regionalcode ,zk_role.id AS roleid ,zk_role.rolecode rolecode  " +
							"FROM user_worker,zk_user_role,zk_role " +
							"WHERE user_worker.uid = zk_user_role.sys_user_id AND zk_user_role.sys_role_id = zk_role.id AND uid = '"+info.getUSERID()+"'";
			
			ResultSet basePrs = db.executeQuery(base_sql); 
			if(basePrs.next()){
				roleid = basePrs.getString("roleid");
				rolecode = basePrs.getString("rolecode");
				regionalcode = basePrs.getString("regionalcode");
			}
			
			
			json.put("success", "true");
			json.put("resultCode", "1000");
			json.put("msg", "获取列表成功");
			
			
			//获取状态
			String sql_status = "SELECT id ,buttonstatus FROM z_buttonfuntion_bak WHERE buttoncode = '"+buttoncode+"' ";
			ResultSet statResultSet = db.executeQuery(sql_status);
			String id = ""; 
			String jiestate = "";
			if(statResultSet.next()){
				id = statResultSet.getString("id");
				jiestate = statResultSet.getString("buttonstatus");
			}if(statResultSet!=null){statResultSet.close();}

			
			//1.按钮信息
			JSONObject json_button1 = new JSONObject();
		    ArrayList list_button = new ArrayList();
			String rolebutton = "SELECT buttonname, buttoncode, url,http, buttonstatus,TYPE FROM z_buttonfuntion_bak,z_role_button_bak WHERE z_role_button_bak.roleid = '"+roleid+"' AND z_buttonfuntion_bak.fatherid = '"+id+"' AND z_role_button_bak.buttonid = z_buttonfuntion_bak.id ;";
			
			
			ResultSet roleResultSet = db.executeQuery(rolebutton);
			System.out.println("按钮sql ===="+rolebutton);
			
			while(roleResultSet.next()){
				json_button1.put("buttonname", roleResultSet.getString("buttonname"));
				json_button1.put("buttoncode", roleResultSet.getString("buttoncode"));
				json_button1.put("api", roleResultSet.getString("url"));
				json_button1.put("httptype", roleResultSet.getString("http"));
				json_button1.put("type", roleResultSet.getString("type"));
				json_button1.put("buttonstatus", roleResultSet.getString("buttonstatus"));
				list_button.add(json_button1.toString());
				
			}if(roleResultSet!=null){roleResultSet.close();}
			json.put("button", list_button.toString());
			
			
			//2.订单信息
			String mosaic = "";
			//订单状态为0时，是未接单，其他情况有操作者id；
			if(!"0".equals(jiestate)){
				mosaic = " AND operatorid = '"+info.getUSERID()+"'";
			}
			JSONObject json_order = new JSONObject();
			System.out.println("mosaic====="+mosaic);
			String sql_baseString = "SELECT *                                               "+
								"FROM (SELECT *                                             "+
								"FROM (SELECT *                                             "+
								"FROM process_log                                           "+
								"ORDER BY creation_date DESC) AS `temp`                     "+
								"GROUP BY nodeid,orderid                                    "+
								"ORDER BY orderid) `temp1`,                                 "+
								"order_sheet,                                               "+
								"order_customerfile                                         "+
								"WHERE order_customerfile.customername LIKE '%"+keyword+"%'            "+
								"AND temp1.status = '"+jiestate+"'                                     "+
								"		AND order_sheet.customeruid = order_customerfile.id  "+
								"		AND temp1.orderid = order_sheet.id                   "+
								"		AND temp1.regionalcode LIKE '"+regionalcode+"%'                "+
								"		AND temp1.rolecode = '"+rolecode+"'                  "+
								mosaic+"	LIMIT "+map.get("DQcount2")+","+map.get("listnum2")+";";
			
			System.out.println("订单sql_base===="+sql_baseString);
			ResultSet basePrSet = db.executeQuery(sql_baseString);
			
			
			while(basePrSet.next()){
				json_order.put("orderid", basePrSet.getString("orderid"));
				json_order.put("ordercode",basePrSet.getString("ordercode"));
				json_order.put("nodeid", basePrSet.getString("nodeid"));
				json_order.put("processid", basePrSet.getString("processid"));
				json_order.put("customername",basePrSet.getString("customername"));
				json_order.put("loantype", basePrSet.getString("loantype"));
				json_order.put("financetype", "抵押贷款");
				json_order.put("phone", basePrSet.getString("phonenumber"));
				json_order.put("contactaddress", basePrSet.getString("contactaddress"));
				json_order.put("createtime", basePrSet.getString("order_sheet.createtime"));
				json_order.put("guaranteestate", setguaranteestate(basePrSet.getString("guaranteenum"),buttoncode));
				list.add(json_order.toString());
			}if(basePrSet!=null){basePrSet.close();}
			json.put("info", list.toString());
			
			regionalcode = json.toString();
			
			// 记录执行日志
			long ExeTime = Calendar.getInstance().getTimeInMillis()-info.getTimeStart();
			Atm.AppuseLong(info, username,  this.getClass().getName(), classname, responsejson, ExeTime);
			//添加操作日志
			Atm.LogSys("获取待接单", "用户APP端成功", "用户"+username+"获取待接单成功", "0",info.getUSERID(), info.getIp());
			
		}catch (Exception e) {
			
			
			int ErrLineNumber = e.getStackTrace()[0].getLineNumber();
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
	
	/**
	 * 设置是否增加担保人状态
	 * @param guarantee
	 * @param buttoncode
	 * @return
	 */
	public String setguaranteestate(String guarantee,String buttoncode){
		String state = "";
		if(!"0".equals(guarantee) && "appointmentlist".equals(buttoncode)){
			state = "1";
		}else{
			state = "0";
		}
		return state;
	}
	
}
