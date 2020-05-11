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
import v1.haocheok.commom.controller.DoCommonController;
import v1.haocheok.commom.entity.InfoEntity;


/**
 * 增加担保人接口
 * @company 010jiage
 * @author zhoukai04171019
 * @date:2017-10-9 下午05:31:30
 */
public class DoGuaranteeController {
	
	private Jdbc db = new Jdbc();
	private Page page = new Page();
	
	public void DoGuarantee(HttpServletRequest request,
			HttpServletResponse response, String RequestJson, InfoEntity info)
			throws ServletException, IOException {
		
		

		String claspath = this.getClass().getName();// 当前类名
		String classname = "APP增加担保人";
		response.setContentType("text/html;charset=UTF-8");
		request.setCharacterEncoding("UTF-8");
		response.setCharacterEncoding("UTF-8");

		PrintWriter out = response.getWriter();
		JSONObject json = new JSONObject();
		ArrayList list = new ArrayList();
		// 定义接收变量值
		String regionalcode = ""; // 区域code
		String rolecode = ""; // 角色code
		String orderid = ""; // 订单id
		String common_info = ""; //备注
		String nodeid = "";     //节点id
		String status_form = ""; //状态
		String processid = "";   //流程id
		
		String responsejson = "";
		
		String username = common.getusernameTouid(info.getUSERID());

		try { // 解析开始

System.out.println("增加担保人接收数据：" + RequestJson);

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
		if (!Page.regex(orderid)) {
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
		
		//业务逻辑
		//1.更新order_sheet 订单表中 担保人数量
		String base_order_sheet = "update order_sheet set guaranteenum = guaranteenum+1 where id = '"+orderid+"'";
		boolean state = db.executeUpdate(base_order_sheet);
		if(state){
			String sql_guarantee = "INSERT INTO f_guarantee (orderid, createtime,createid,updatetime,updateid) VALUES ('"+orderid+"',now(),'"+info.getUSERID()+"',now(),'"+info.getUSERID()+"'); ";
			boolean state1 = db.executeUpdate(sql_guarantee);
			if(state1){
				//业务逻辑完成，业务流程开始
				boolean state2 = DoCommonController.setProcess(info, nodeid, status_form, orderid, processid, common_info);
				if(state2){
					json.put("success", "true");
					json.put("resultCode", "1000");
					json.put("msg", "添加担保人成功");
					//添加操作日志
					Atm.LogSys("添加担保人", "用户添加担保人操作", "预约时间操作者"+info.getUSERID()+"", "0",info.getUSERID(), info.getIp());
				}else{
					json.put("success", "false");
					json.put("resultCode", "2000");
					json.put("msg", "添加担保人失败");
					//添加操作日志
					Atm.LogSys("添加担保人", "用户添加担保人操作", "预约时间操作者"+info.getUSERID()+"", "1",info.getUSERID(), info.getIp());
				}
			}else{
				json.put("success", "false");
				json.put("resultCode", "2000");
				json.put("msg", "添加担保人失败");
				//添加操作日志
				Atm.LogSys("添加担保人", "用户添加担保人操作", "预约时间操作者"+info.getUSERID()+"", "1",info.getUSERID(), info.getIp());
			}
		}else{
			json.put("success", "false");
			json.put("resultCode", "2000");
			json.put("msg", "添加担保人失败");
			//添加操作日志
			Atm.LogSys("添加担保人", "用户添加担保人操作", "预约时间操作者"+info.getUSERID()+"", "1",info.getUSERID(), info.getIp());
		}
		
		
  
		// 记录执行日志
		long ExeTime = Calendar.getInstance().getTimeInMillis()-info.getTimeStart();
		// 记录执行日志
		Atm.AppuseLong(info, username,  claspath, classname, responsejson, ExeTime);
		//返回数据
		responsejson = json.toString();

		// 调用应用层实现类接口
		
		out.println(responsejson);
		// 记录日志
		page.colseDP(db, page);
		out.flush();
		out.close();
	}
	
}
