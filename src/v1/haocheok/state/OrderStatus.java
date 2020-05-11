package v1.haocheok.state;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.Map;

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

/**
 * 业务状态（包括业务员状态，业务主管状态，总经理状态）
 * @author zhoukai04171019
 * @date:2017-9-7 上午10:15:35
 */
public class OrderStatus {

	public void OrderStatusList(HttpServletRequest request, HttpServletResponse response,String RequestJson,InfoEntity info) throws ServletException, IOException {

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
       	String orderid = "";
		String responsejson="";
		String classname="APP业务订单状态";
		String username=common.getusernameTouid(info.getUSERID());
		JSONObject json = new JSONObject();
	    ArrayList list = new ArrayList();
		  
		//数据接收
		try {
			JSONArray arr = JSONArray.fromObject("[" + RequestJson + "]");
			for (int i = 0; i < arr.size(); i++) {
			   JSONObject obj = arr.getJSONObject(i);
			   orderid = obj.get("placeid") + "";

			}
		} catch (Exception e) {
			ErrMsg.falseErrMsg(request, response, "500", "json格式解析异常");
			return;
		}
			    
		//token 认证过滤
	    System.out.println("token 认证过滤==="+"SELECT COUNT(*) as row FROM  user_worker WHERE uid ='"+info.getUSERID()+"' AND app_token='"+ info.getToken() + "'");
		int TokenTag=db.Row("SELECT COUNT(*) as row FROM  user_worker WHERE uid ='"+info.getUSERID()+"' AND app_token='"+ info.getToken() + "'");
		if(TokenTag!=1){
			ErrMsg.falseErrMsg(request, response, "403", "请登录！");
			Page.colseDOP(db, out, page);
			return;//跳出程序只行 
		}  
		
		try {
			//基本信息
			String ordercode = "";
			String oderstate = "";
			String base_sql = "SELECT * FROM user_worker,zk_user_role,zk_role WHERE user_worker.uid = zk_user_role.sys_user_id AND zk_user_role.sys_role_id = zk_role.id AND uid = '"+info.getUSERID()+"'";
			
			ResultSet basePrs = db.executeQuery(base_sql); 
			if(basePrs.next()){
				rolecode = basePrs.getString("rolecode");
				regionalcode = basePrs.getString("regionalcode");
			}if(basePrs!=null){basePrs.close();}
			
			
			
			//2.订单信息：
			JSONObject json_order = new JSONObject();
			String sql_order = "SELECT " +
						"od.ordercode AS ordercode,oc.customername AS customname,loantype,oc.phonenumber AS phone , od.createtime AS createtime , od.salesmanid AS salesmanid " +
						"FROM order_sheet AS od,order_customerfile AS oc " +
						"WHERE od.customeruid = oc.id " +
						"AND od.id = '"+orderid+"' ;";
			
			ResultSet orderPre = db.executeQuery(sql_order);
			if(orderPre.next()){
				ordercode = orderPre.getString("customname");
				json_order.put("ordercode",orderPre.getString("ordercode"));
				json_order.put("customername",orderPre.getString("customname"));
				json_order.put("loantype", orderPre.getString("loantype"));
				json_order.put("financetype", "抵押贷款");
				json_order.put("phone", orderPre.getString("phone"));
				json_order.put("salemanname", common.getusernameTouid(orderPre.getString("salesmanid")));
				json_order.put("createtime", orderPre.getString("phone"));
			}if(orderPre!=null){orderPre.close();}
			
			
			//1.base 信息
			JSONObject json_base = new JSONObject();
			json_base.put("ordercode", ordercode);
			
			String base_state = "SELECT rolename ,STATUS ,operatorid  FROM process_log WHERE orderid = '"+orderid+"' ORDER BY id DESC LIMIT 1 ;";
			ResultSet basestateResultSet = db.executeQuery(base_state);
			//订单状态
			if(basestateResultSet.next()){
				if("0".equals(basestateResultSet.getString("status"))){
					oderstate = "未接单";
				}else{
					oderstate = basestateResultSet.getString("rolename");
					oderstate += "【"+ common.getusernameTouid(basestateResultSet.getString("operatorid"))+"】";
					oderstate += common.getDis4info("state",basestateResultSet.getString("status") );
				}
			}
			json_base.put("orderstate", oderstate);
			
			
			
			//3.订单状态：
			JSONObject json_state = new JSONObject();
			ArrayList list_state = new ArrayList();
			String sql_state = "SELECT rolename,rolecode,STATUS,common,creation_date,nodeid,operatorid  " +
								"FROM " +
								"(SELECT rolename,rolecode,STATUS,common,creation_date,nodeid,operatorid FROM process_log WHERE orderid = '"+orderid+"' ORDER BY creation_date DESC) AS `temp` " +
								" GROUP BY nodeid;";
			
			ResultSet statePre = db.executeQuery(sql_state);
System.out.println("sql_state======"+sql_state);
			while(statePre.next()){
				//获取通过时间，接单时间，耗时时间
				Map<String, String> map = common.getStateTime(statePre.getString("rolecode"), orderid);
				
				json_state.put("rolename", statePre.getString("rolename"));
				json_state.put("username", common.getusernameTouid(statePre.getString("operatorid")));
				json_state.put("ordertime", map.get("ordertime"));
				json_state.put("adopttime", map.get("adopttime"));
				json_state.put("time_consuming", map.get("time_consuming"));
				json_state.put("handleopinions", statePre.getString("common"));
				json_state.put("officestate", statePre.getString("status"));
				json_state.put("officestateinfo", common.getDis4info("state", statePre.getString("status")));
				list_state.add(json_state.toString());
			}if(statePre!=null){statePre.close();}
			
			
			json.put("success", "true");
			json.put("resultCode", "1000");
			json.put("msg", "获取业务员订单状态");
			json.put("base",json_base.toString());
			json.put("info", json_order.toString());
			json.put("state",list_state.toString());
			
			// 记录执行日志
			responsejson = json.toString();
			long ExeTime = Calendar.getInstance().getTimeInMillis()-info.getTimeStart();
			Atm.AppuseLong(info, username,  this.getClass().getName(), classname, responsejson, ExeTime);
			//添加操作日志
			Atm.LogSys("查看业务员订单状态", "用户APP端成功", "用户"+username+"查看业务员订单状态接口", "0",info.getUSERID(), info.getIp());
		} catch (Exception e) {
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
		page.colseDP(db, page);
		out.flush();
		out.close();
	}
	
	
}
