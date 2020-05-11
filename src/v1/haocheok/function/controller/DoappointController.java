package v1.haocheok.function.controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.ResultSet;
import java.sql.SQLException;
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

/**
 * 预约时间
 * @author zhoukai0417
 *
 */
public class DoappointController {
	Jdbc db = new Jdbc();
	Page page = new Page();
	
	public void Doappoint(HttpServletRequest request,
			HttpServletResponse response, String RequestJson, InfoEntity info)
			throws ServletException, IOException {

		

		String claspath = this.getClass().getName();// 当前类名
		String classname = "APP预约时间操作";
		response.setContentType("text/html;charset=UTF-8");
		request.setCharacterEncoding("UTF-8");
		response.setCharacterEncoding("UTF-8");

		PrintWriter out = response.getWriter();
		JSONObject json = new JSONObject();
		ArrayList list = new ArrayList();
		// 定义接收变量值
		String regionalcode = ""; // 区域code
		String rolecode = ""; // 角色code
		String status_form = ""; // 订单状态
		String orderid = ""; // 订单id
		String processid = "";
		String appointime = ""; 
		String common_info = "";
		
		String responsejson = "";
		
		String username = common.getusernameTouid(info.getUSERID());

		try { // 解析开始

System.out.println("预约时间模块接收数据：" + RequestJson);

			JSONArray arr = JSONArray.fromObject("[" + RequestJson + "]");

			for (int i = 0; i < arr.size(); i++) {
				JSONObject obj = arr.getJSONObject(i);
				orderid = obj.get("placeid") + "";
				status_form = obj.get("status") + "";
				processid = obj.get("process") + "";
				appointime = obj.get("appointime") + "";
				common_info = obj.get("common") + "";

			}
			if(common_info==null||common_info.indexOf("null")!=-1 ){common_info="";}
		} catch (Exception e) {
			ErrMsg.falseErrMsg(request, response, "500", "json格式解析异常");
			return;
		}
		// 判断过滤非法字符:
		if (!Page.regex(orderid) || !Page.regex(status_form)) {
			ErrMsg.falseErrMsg(request, response, "500", "数据格式不匹配");
			Page.colseDOP(db, out, page);
			return;// 跳出程序只行
		}

		// token 认证过滤
System.out.println("token 认证过滤==="
+ "SELECT COUNT(*) as row FROM  user_worker WHERE uid ='"
+ info.getUSERID() + "' AND app_token='" + info.getToken()
+ "'");
		int TokenTag = db
				.Row("SELECT COUNT(*) as row FROM  user_worker WHERE uid ='"
						+ info.getUSERID() + "' AND app_token='"
						+ info.getToken() + "'");
		if (TokenTag != 1) {
			ErrMsg.falseErrMsg(request, response, "403", "请登录！");
			Page.colseDOP(db, out, page);
			return;// 跳出程序只行
		}
		
		
		try {
			//判断状态值
			boolean status = false;
			
			//基本信息
			String base_sql = "SELECT * FROM user_worker,zk_user_role,zk_role WHERE user_worker.uid = zk_user_role.sys_user_id AND zk_user_role.sys_role_id = zk_role.id AND uid = '"+info.getUSERID()+"'";
			
			ResultSet basePrs = db.executeQuery(base_sql); 
			if(basePrs.next()){
				rolecode = basePrs.getString("rolecode");
				regionalcode = basePrs.getString("regionalcode");
			}if(basePrs!=null){basePrs.close();}
		   //1.预约时间操作
		   if("1".equals(status_form)){
			   String basesql = "SELECT * FROM t_yewudian , t_yewuxian WHERE t_yewuxian.status_form = '"+status_form+"' and t_yewudian.nodeid = t_yewuxian.nodeid_form AND t_yewudian.t_yewumian_id = '"+processid+"' AND rolecode = '"+rolecode+"';";
			   ResultSet orderSet = db.executeQuery(basesql);
			   while(orderSet.next()){
				   String nodeid_to = orderSet.getString("nodeid_to");
				   //获取角色信息
				   HashMap<String, Object> map = getRoleinfo(nodeid_to);
				   
				   String insertString = "insert into `process_log` (orderid,processid,regionalcode,nodeid,rolecode," +
					"rolename,operatorid,status,common," +
					"creation_date,creation_uid,updatetime,up_uid) " +
					 "VALUES('"+orderid+"','"+processid+"','"+regionalcode+"','"+nodeid_to+"','"+map.get("rolecode")+"','"+map.get("rolename")+"','"+info.getUSERID()+"'," +
					 		" '"+orderSet.getString("status_to")+"','"+common_info+"',now(),'"+info.getUSERID()+"',now(),'"+info.getUSERID()+"');";
				   status =  db.executeUpdate(insertString);
			   }if(orderSet!=null){orderSet.close();}
			   
			   //状态 插入预约时间
			   if(status){
				   String apption_sql = "insert into `homevisits_time` (orderid,processid,userid,appointmenttime,common,withdrawstatus,createtime,createid,updatetime,updateid) " +
				   						"VALUES ('"+orderid+"','"+processid+"','"+info.getUSERID()+"','"+appointime+"','"+common_info+"','0',now(),'"+info.getUSERID()+"',now(),'"+info.getUSERID()+"')"; 
				   boolean appState = db.executeUpdate(apption_sql);
				   if(appState){
					   	json.put("success", "true");
						json.put("resultCode", "1000");
						json.put("msg", "预约时间成功");
						//添加操作日志
						Atm.LogSys("预约时间", "用户预约时间操作", "预约时间操作者"+info.getUSERID()+"", "0",info.getUSERID(), info.getIp());
				   }else{
					   json.put("success", "false");
						json.put("resultCode", "2005");
						json.put("msg", "预约时间出错");
						Page.colseDOP(db, out, page);
						//添加操作日志
						Atm.LogSys("预约时间", "用户预约时间操作", "预约时间操作者"+info.getUSERID()+"", "1",info.getUSERID(), info.getIp());
				   }
				   
			   }else{
				   	json.put("success", "false");
					json.put("resultCode", "2005");
					json.put("msg", "预约时间出错");
					Page.colseDOP(db, out, page);
					//添加操作日志
					Atm.LogSys("预约时间", "用户预约时间操作", "预约时间操作者"+info.getUSERID()+"", "1",info.getUSERID(), info.getIp());
			   }
		   }
			// 记录执行日志
			long ExeTime = Calendar.getInstance().getTimeInMillis()-info.getTimeStart();
			// 记录执行日志
			Atm.AppuseLong(info, username,  claspath, classname, responsejson, ExeTime);
			//返回数据
			responsejson = json.toString();
		} catch (SQLException e) {
			int ErrLineNumber = e.getStackTrace()[0].getLineNumber();
			responsejson = "{\"success\":true,\"resultCode\":\"500\",\"msg\":\"服务器开小差了\"}";
			// 记录执行日志
			long ExeTime = Calendar.getInstance().getTimeInMillis()
					- info.getTimeStart();
			Atm.AppuseLong(info, username, this.getClass().getName(),
					classname, responsejson, ExeTime);
			// 添加操作日志
			Atm.LogSys("系统错误", classname + "模块系统出错", "错误信息详见 "
					+ this.getClass().getName() + "第" + ErrLineNumber + "行",
					"1", info.getUSERID(), info.getIp());
			Page.colseDP(db, page);
		}

		// 调用应用层实现类接口
		
		out.println(responsejson);
		// 记录日志
		page.colseDP(db, page);
		out.flush();
		out.close();
	}
	
	public HashMap<String, Object> getRoleinfo( String nodeid){
		HashMap<String, Object> map = new HashMap<String, Object>();
		String sql = "SELECT * FROM zk_role,t_yewudian WHERE nodeid = '"+nodeid+"' AND zk_role.id = t_yewudian.roleid ";
		ResultSet role_Set = db.executeQuery(sql);
		try {
			if(role_Set.next()){
				map.put("rolecode", role_Set.getString("rolecode"));
				map.put("rolename", role_Set.getString("name"));
				
			}else{
				map.put("rolecode", "");
				map.put("rolename", "");
				
			}if(role_Set!=null){role_Set.close();}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return map;
	}
}
