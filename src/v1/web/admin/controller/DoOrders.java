package v1.web.admin.controller;

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
import v1.haocheok.commom.controller.DoCommonController;
import v1.haocheok.commom.entity.InfoEntity;
import v1.haocheok.commom.entity.UserEntity;

/**
 * web端接单操作
 * @author zhoukai04171019
 * @date:2017-9-8 上午10:38:21
 */
public class DoOrders {
	Jdbc db = new Jdbc();
	Page page = new Page();
	
	public void doOrders(HttpServletRequest request,
			HttpServletResponse response, String RequestJson, InfoEntity info)
			throws ServletException, IOException {


		String claspath = this.getClass().getName();// 当前类名
		String classname = "web接单操作";
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
		String nodeid = "";  //节点id
		String processid = "";
		String common_info = "";     //备注
		
		String responsejson = "";
		
		String username = "";
 
		try { // 解析开始

System.out.println("接单数据：" + RequestJson);

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
		+ info.getUSERID() + "' AND pc_token='" + info.getToken()
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
		
		
System.out.println(common_info);
		try {
			//基本信息
			UserEntity user = (UserEntity)request.getSession().getAttribute("UserList");
			username = user.getUsername();
			rolecode = user.getRolecode();
			regionalcode = user.getRegionalcode();
		   //2.接单操作
		   if("1".equals(status_form)){
			   String basesql = DoCommonController.setBaseSql(processid, nodeid, status_form, rolecode);
			   ResultSet orderSet = db.executeQuery(basesql);
			   while(orderSet.next()){
				   String nodeid_to = orderSet.getString("nodeid_to");
				   //获取角色信息
				   HashMap<String, Object> map =DoCommonController.getRoleinfo(nodeid_to,processid);
				   
				   String insertString = "insert into `process_log` (orderid,processid,regionalcode,nodeid,rolecode," +
					"rolename,operatorid,status,common," +
					"creation_date,creation_uid,updatetime,up_uid) " +
					 "VALUES('"+orderid+"','"+processid+"','"+regionalcode+"','"+nodeid_to+"','"+map.get("rolecode")+"','"+map.get("rolename")+"','"+info.getUSERID()+"'," +
					 		" '"+orderSet.getString("status_to")+"','"+common_info+"',now(),'"+info.getUSERID()+"',now(),'"+info.getUSERID()+"');";
				   boolean status =  db.executeUpdate(insertString);
			   }if(orderSet!=null){orderSet.close();}
			   
		   }
			// 记录执行日志
			long ExeTime = Calendar.getInstance().getTimeInMillis()-info.getTimeStart();
			// 记录执行日志
			Atm.AppuseLong(info, username,  claspath, classname, responsejson, ExeTime);
			//添加操作日志
			Atm.LogSys("接单", "用户接单操作", "接单操作者"+info.getUSERID()+"", "0",info.getUSERID(), info.getIp());
			responsejson = "{\"success\":true,\"resultCode\":\"1000\",\"msg\":\"接单成功\"}";
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
