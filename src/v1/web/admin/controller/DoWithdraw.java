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

import org.apache.commons.lang.StringUtils;

import service.dao.db.Jdbc;
import service.dao.db.Page;
import service.sys.Atm;
import service.sys.ErrMsg;
import v1.haocheok.commom.common;
import v1.haocheok.commom.controller.DoCommonController;
import v1.haocheok.commom.entity.InfoEntity;

/**
 * web端 撤回功能
 * @company 010jiage
 * @author zhoukai04171019
 * @date:2017-10-18 下午04:00:52
 */
public class DoWithdraw {
	public void Withdraw(HttpServletRequest request,
			HttpServletResponse response, String RequestJson, InfoEntity info)
			throws ServletException, IOException {
		Jdbc db = new Jdbc();
		Page page = new Page();

		String claspath = this.getClass().getName();// 当前类名
		String classname = "WEB撤回操作";
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
		String common_info = "";     //备注
		String nodeid = "" ;
		
		String responsejson = "";
		
		String username = common.getusernameTouid(info.getUSERID());

		try { // 解析开始

			System.out.println("WEB撤回模块接收数据：" + RequestJson);

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
		/*if (!Page.regex(orderid) || !Page.regex(status_form)) {
			ErrMsg.falseErrMsg(request, response, "500", "数据格式不匹配");
			Page.colseDOP(db, out, page);
			return;// 跳出程序只行
		}*/

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
			
//			String basesql = "SELECT * FROM t_yewudian , t_yewuxian WHERE t_yewuxian.nodeid_form = '"+nodeid+"' and t_yewuxian.status_form = '"+status_form+"' and t_yewudian.nodeid = t_yewuxian.nodeid_form AND t_yewudian.t_yewumian_id = '"+processid+"' AND rolecode = '"+rolecode+"';";
			String basesql = DoCommonController.setBaseSql(processid, nodeid, status_form, rolecode);
			//1.撤回操作
		   if("-2".equals(status_form)){
			   ResultSet orderSet = db.executeQuery(basesql);
			   
			   String tiaojian_status = "";
			   String nodeidList = "";
			   String sql_baseString = "";
			   while(orderSet.next()){
				   if(!"".equals(orderSet.getString("guize"))){
					   String guize = orderSet.getString("guize");
					   if(guize.indexOf("=")!=-1){
						   List<String> list1 = Arrays.asList(guize.split("="));
						   tiaojian_status = list1.get(list1.size()-1);
						   //是否为并行
						   if(list1.get(0).indexOf("and")!=-1){
							   List<String> list2 = Arrays.asList(list1.get(0).split("and"));
							   nodeidList = StringUtils.join(list2, ",");
							   sql_baseString = "SELECT STATUS FROM process_log WHERE orderid='"+orderid+"' AND nodeid IN( "+nodeidList+" ) ORDER BY creation_date DESC LIMIT 1";
						   }else if(list1.get(0).indexOf("or")!=-1){
							   //其中之一的关系
							   List<String> list2 = Arrays.asList(list1.get(0).split("or"));
							   List<String> list3 = new ArrayList<String>();
							   for(int i =0 ; i < list3.size(); i++){
								   list3.add("nodeid="+list2.get(i));
							   }
							   nodeidList = StringUtils.join(list3, " or ");
							   sql_baseString = "SELECT STATUS FROM process_log WHERE orderid='"+orderid+"' AND nodeid = '"+nodeidList+"' ORDER BY creation_date DESC LIMIT 1";
							   
						   }else{
							   //指定关系
							   nodeidList = list1.get(0);
							   sql_baseString = "SELECT STATUS FROM process_log WHERE orderid='"+orderid+"' AND nodeid = '"+nodeidList+"' ORDER BY creation_date DESC LIMIT 1";
						   }
						   //判断是否有接单,有接单直接返回
						   String state_code = "";
						   ResultSet status_Prs = db.executeQuery(sql_baseString);
						   if(status_Prs.next()){
							   state_code = status_Prs.getString("status");
						   }if(status_Prs!=null){status_Prs.close();}
						   if(!"0".equals(state_code) && !"".equals(state_code)){
							   responsejson = "{\"success\":true,\"resultCode\":\"1000\",\"msg\":\"下级已接单不能操作\"}";
							   out.println(responsejson);
								// 记录日志
								page.colseDP(db, page);
								out.flush();
								out.close();
								return;
						   }
					   }
					   
				   }
			   }if(orderSet!=null){orderSet.close();}
			 //如果下级都没有接单
			   ResultSet isnerResultSet = db.executeQuery(basesql);
			   while(isnerResultSet.next()){
				   System.out.println("进来了");
				   String nodeid_to = isnerResultSet.getString("nodeid_to");
				   String userid = "0";
				   if(nodeid_to.equals(nodeid)){
					   userid = info.getUSERID();
				   }
				   //获取角色信息
				   HashMap<String, Object> map = DoCommonController.getRoleinfo(nodeid_to,processid);
				   	String insertString = "insert into `process_log` (orderid,processid,regionalcode,nodeid,rolecode," +
					"rolename,operatorid,status,common," +
					"creation_date,creation_uid,updatetime,up_uid) " +
					 "VALUES('"+orderid+"','"+processid+"','"+regionalcode+"','"+nodeid_to+"','"+map.get("rolecode")+"','"+map.get("rolename")+"','"+userid+"'," +
					 		" '"+isnerResultSet.getString("status_to")+"','"+common_info+"',now(),'"+info.getUSERID()+"',now(),'"+info.getUSERID()+"');";
				   boolean status =  db.executeUpdate(insertString);
				   System.out.println("status==="+status);
			   }if(isnerResultSet!=null){isnerResultSet.close();}
			   
			   
			   
		   }
		   
		   responsejson = "{\"success\":true,\"resultCode\":\"1000\",\"msg\":\"撤单成功\"}";
		   
			// 记录执行日志
			long ExeTime = Calendar.getInstance().getTimeInMillis()-info.getTimeStart();
			// 记录执行日志
			Atm.AppuseLong(info, username,  claspath, classname, responsejson, ExeTime);
			//添加操作日志
			Atm.LogSys("驳回", "用户驳回操作", "驳回操作者"+info.getUSERID()+"", "0",info.getUSERID(), info.getIp());
			
		} catch (SQLException e) {
			int ErrLineNumber = e.getStackTrace()[0].getLineNumber();
			responsejson = "{\"success\":true,\"resultCode\":\"500\",\"msg\":\"服务器开小差了1233\"}";
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
