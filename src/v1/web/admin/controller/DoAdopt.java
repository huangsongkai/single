package v1.web.admin.controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;

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
import v1.haocheok.commom.controller.DoCommonController;
import v1.haocheok.commom.entity.InfoEntity;

/**
 * web 通用通过接口
 * @author zhoukai04171019
 * @date:2017-9-11 下午05:45:58
 */
public class DoAdopt {

	Jdbc db = new Jdbc();
	Page page = new Page();
	
	public void Doadp(HttpServletRequest request,
			HttpServletResponse response, String RequestJson, InfoEntity info)
			throws ServletException, IOException {

		

		String claspath = this.getClass().getName();// 当前类名
		String classname = "web通过功能";
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
		String common_info = "";
		String nodeid = "";
		
		String responsejson = "";
		
		String username = common.getusernameTouid(info.getUSERID());

		try { // 解析开始

System.out.println("通过模块接收数据：" + RequestJson);

			JSONArray arr = JSONArray.fromObject("[" + RequestJson + "]");

			for (int i = 0; i < arr.size(); i++) {
				JSONObject obj = arr.getJSONObject(i);
				orderid = obj.get("placeid") + "";
				status_form = obj.get("status") + "";
				processid = obj.get("process") + "";
				common_info = obj.get("common") + "";
				nodeid = obj.get("nodeid") + "";

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
						+ info.getUSERID() + "' AND pc_token='"
						+ info.getToken() + "'");
		if (TokenTag != 1) {
			ErrMsg.falseErrMsg(request, response, "403", "请登录！");
			Page.colseDOP(db, out, page);
			return;// 跳出程序只行
		}
		
		
		try {
			
			//基本信息
			String base_sql = "SELECT * FROM user_worker,zk_user_role,zk_role WHERE user_worker.uid = zk_user_role.sys_user_id AND zk_user_role.sys_role_id = zk_role.id AND uid = '"+info.getUSERID()+"'";
			
			ResultSet basePrs = db.executeQuery(base_sql); 
			if(basePrs.next()){
				rolecode = basePrs.getString("rolecode");
				regionalcode = basePrs.getString("regionalcode");
			}if(basePrs!=null){basePrs.close();}
			 //1.提交操作
			   if("6".equals(status_form)){
				   String basesql = DoCommonController.setBaseSql(processid, nodeid, status_form, rolecode);
				   
				   ResultSet submit_Prs = db.executeQuery(basesql);
				   while(submit_Prs.next()){
					   String nodeid_form = "";
					   String nodeid_to = "";
					   String status_to = "";
					   nodeid_form = submit_Prs.getString("nodeid_form");
					   nodeid_to = submit_Prs.getString("nodeid_to");
					   status_to = submit_Prs.getString("status_to");
					   String operatorid = "0";
					   //通过时 判断用户，
					   if(!"0".equals(status_to)){
						  operatorid = info.getUSERID();
					   }
					   
					   //1.提交
					   HashMap<String, Object> map = DoCommonController.getRoleinfo(nodeid_to,processid);
					   
					   
					   String insertString = "insert into `process_log` (orderid,processid,regionalcode,nodeid,rolecode," +
											"rolename,operatorid,status,common," +
											"creation_date,creation_uid,updatetime,up_uid) " +
											"VALUES('"+orderid+"','"+processid+"','"+regionalcode+"','"+nodeid_to+"','"+map.get("rolecode")+"','"+map.get("rolename")+"','"+operatorid+"','"+status_to+"','"+common_info+"'," +
											" now(),'"+info.getUSERID()+"',now(),'"+info.getUSERID()+"');";
					   System.out.println(insertString);
					   //判断是否有条件
					   if("".equals(submit_Prs.getString("guize"))){
						   //没有规则时顺序执行
						   boolean status = db.executeUpdate(insertString);
						  
					   }else{
						   //有规则时：
						   boolean status = false;
						   String guize = submit_Prs.getString("guize");
						   if(guize.indexOf("or")==-1){
							   System.out.println(guize);
							   String select_sql = "SELECT COUNT(1) AS ROW FROM process_log WHERE processid = '"+processid+"' AND STATUS='"+status_form+"' AND nodeid = '"+guize+"' AND orderid = '"+orderid+"';";
							   int num = db.Row(select_sql);
							   if(num>=1){
								   status = true;
							   }
							   System.out.println(num);
						   }else{
							   List<String> list1 = Arrays.asList(guize.split("or"));
							   for(int i = 0;i < list1.size() ; i++){
								   String select_sql = "SELECT COUNT(1) AS ROW FROM process_log WHERE processid = '"+processid+"' AND STATUS='"+status_form+"' AND nodeid = '"+list1.get(i)+"' AND orderid = '"+orderid+"';";
								   int num = db.Row(select_sql);
								   if(num>=1){
									   status = true;
								   }
							   }
						   }
						   if(status){
							   boolean tiaojian_state = db.executeUpdate(insertString);
						   }
					   }
					   
					   
				   }
				
				 
			   }
			// 记录执行日志
			long ExeTime = Calendar.getInstance().getTimeInMillis()-info.getTimeStart();
			// 记录执行日志
			Atm.AppuseLong(info, username,  claspath, classname, responsejson, ExeTime);
			//返回数据
			
			String outputString = "{\"success\":\"true\",\"resultCode\": \"1000\",\"msg\": \"成功\"}";
			responsejson = outputString;
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
	
}
