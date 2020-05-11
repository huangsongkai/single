package v1.moblie.app.login;

/** 
 * @author microfar  E-mail: 932246@qq.com 
 * @version 创建时间：2017-2-27 下午22:58:32 
 * @类说明 :app登录模块
 */

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.ResultSet;
import java.util.Calendar;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import service.dao.db.Jdbc;
import service.dao.db.Page;
import service.sys.Atm;
import v1.haocheok.commom.entity.InfoEntity;

public class MsgCount {

	public void process(HttpServletRequest request, HttpServletResponse response, InfoEntity info, String theClassName) throws ServletException, IOException {

		Jdbc db = new Jdbc();
		Page page = new Page();

		String claspath = this.getClass().getName();
		response.setContentType("text/html;charset=UTF-8");
		request.setCharacterEncoding("UTF-8");
		response.setCharacterEncoding("UTF-8");
		PrintWriter out = response.getWriter();
		String mobile = "";

		String responsejson = "";

		System.err.println(info.getUSERID());
		System.err.println(info.getToken());

		// ********************业务层实现接口***********************/
		try {

			// 用户登录名与密码是否正确
			int LoginTag = 0;
			String uidString = ""; String app_tokenString = "";
			
			String LoginsqlString = "SELECT uid,app_token  FROM  user_worker WHERE  uid='" + info.getUSERID() + "' AND app_token='" + info.getToken() + "' limit 1; ";
			ResultSet LoginRs = db.executeQuery(LoginsqlString);

			if (LoginRs.next()) {
				LoginTag = LoginTag + 1;
				uidString = LoginRs.getString("uid");
				app_tokenString = LoginRs.getString("app_token");
			}
			if (LoginRs != null) {
				LoginRs.close();
			}

			if (LoginTag > 0) {// 如果登录成功找未读消息数

				int msgcount = db.Row("SELECT COUNT(*) as row FROM  msg_push WHERE touid='" + info.getUSERID() + "' AND state='0'");

				responsejson = "{\"success\":\"true\",\"resultCode\":\"1000\",\"msg\":\"用户ip与消息成功\",\"Token\":\""+app_tokenString+"\",\"USERID\":\""+uidString+"\",\"IP\":\"" + info.getIp() + "\",\"msgcount\":\"" + msgcount + "\"}";
				out.print(responsejson);
				// 记录执行日志
				long ExeTime = Calendar.getInstance().getTimeInMillis() - info.getTimeStart();
				Atm.AppuseLong(info, mobile, claspath, theClassName, responsejson, ExeTime);
				// 添加操作日志
				Atm.LogSys("app获取事件", "获取ip与消息数", "未登录状态用户:" + info.getUUID() + "(USERID:" + info.getUSERID() + ")通过获取IP和消息数", "0", info.getUSERID(), info.getIp());
				Page.colseDOP(db, out, page);
				return;// 跳出程序只行

			} else {

				responsejson = "{\"success\":\"true\",\"resultCode\":\"1000\",\"msg\":\"用户ip与消息成功\",\"Token\":\"\",\"USERID\":\"\",\"IP\":\"" + info.getIp() + "\",\"msgcount\":\"0\"}";
				out.print(responsejson);
				// 记录执行日志
				long ExeTime = Calendar.getInstance().getTimeInMillis() - info.getTimeStart();
				Atm.AppuseLong(info, mobile, claspath, theClassName, responsejson, ExeTime);
				// 添加操作日志
				Atm.LogSys("app获取事件", "获取ip与消息数", "未登录状态用户:" + info.getUUID() + "(USERID:" + info.getUSERID() + ")通过获取IP和消息数", "0", info.getUSERID(), info.getIp());
				Page.colseDOP(db, out, page);
				return;// 跳出程序只行

			}

		} catch (Exception e) {
			int ErrLineNumber = e.getStackTrace()[0].getLineNumber();
			Atm.LogSys("系统错误", theClassName + "模块系统出错", "错误信息详见 " + claspath + ",第" + ErrLineNumber + "行。", "1", info.getUSERID(), info.getIp());
			Page.colseDP(db, page);
		}
		Page.colseDOP(db, out, page);

		// ********************业务层实现接口结束***********************

	}

}
