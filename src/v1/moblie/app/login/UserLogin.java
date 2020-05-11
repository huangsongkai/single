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

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import service.dao.db.Jdbc;
import service.dao.db.Md5;
import service.dao.db.Page;
import service.sys.Atm;
import service.sys.ErrMsg;
import v1.haocheok.commom.entity.InfoEntity;

public class UserLogin {

	public void process(HttpServletRequest request, HttpServletResponse response, InfoEntity info, String theClassName) throws ServletException, IOException {

		Jdbc db = new Jdbc();
		Page page = new Page();

		String claspath = this.getClass().getName();
		response.setContentType("text/html;charset=UTF-8");
		request.setCharacterEncoding("UTF-8");
		response.setCharacterEncoding("UTF-8");
		PrintWriter out = response.getWriter();
		String mobile = "";
		String password = "";
		String responsejson = "";

		try { // 解析开始

			JSONArray arr = JSONArray.fromObject("[" + info.getRequestJson() + "]");

			for (int i = 0; i < arr.size(); i++) {
				JSONObject obj = arr.getJSONObject(i);
				mobile = obj.get("mobile") + "";
				password = obj.get("password") + "";
			}
		} catch (Exception e) {
			ErrMsg.falseErrMsg(request, response, "500", "json格式解析异常");
			Page.colseDOP(db, out, page);
			return;
		}

		// 判断过滤非法字符:
		if (!Page.regex(mobile) || !Page.regex(password)) {
			ErrMsg.falseErrMsg(request, response, "500", "手机或密码格式不匹配");
			Page.colseDOP(db, out, page);
			return;// 跳出程序只行
		}

		if (mobile.length() != 11) {
			ErrMsg.falseErrMsg(request, response, "500", "请输入正确的11位手机号码");
			Page.colseDOP(db, out, page);
			return;// 跳出程序只行
		}
		if (password.length() == 0) {
			ErrMsg.falseErrMsg(request, response, "500", "请输入密码");
			Page.colseDOP(db, out, page);
			return;// 跳出程序只行
		}
		System.err.println(mobile);
		System.err.println(password);

		// ********************业务层实现接口***********************/
		try {

			// 用户登录名与密码是否正确
			int LoginTag = db.Row("SELECT COUNT(*) as row FROM  user_worker WHERE usermob='" + mobile + "' AND password='" + password + "'");
			if (LoginTag == 0) {
				responsejson = "{\"success\":true,\"resultCode\":\"403\",\"msg\":\"用户名密码不正确\"}";
				out.print(responsejson);
				// 记录执行日志
				long ExeTime = Calendar.getInstance().getTimeInMillis() - info.getTimeStart();
				Atm.AppuseLong(info, mobile, claspath, theClassName, responsejson, ExeTime);
				// 添加操作日志
				Atm.LogSys("登陆", "用户APP端登录失败", "用户:" + mobile + " 通过验证app登录失败用户密码错误", "0", info.getUSERID(), info.getIp());
				Page.colseDOP(db, out, page);
				return;// 跳出程序只行
			}

			String userState = ""; // 用户状态 1启用 0为禁用
			String headimgurl = "";// 用户头像
			String USERID = "";// 用户id
			String username = "";// 用户名字
			String app_token = "";// 用户token秘钥
			String useroleCode = ""; // 用户角色代码
			String useroleName = ""; // 用户角色

			String LoginsqlString = "SELECT uid,username,app_token,headimgurl,state,userole  FROM  user_worker WHERE  usermob='" + mobile + "' AND password='" + password + "' limit 1; ";

			ResultSet LoginRs = db.executeQuery(LoginsqlString);
			if (LoginRs.next()) {// 得出学生信息
				USERID = LoginRs.getString("uid");
				username = LoginRs.getString("username");
				app_token = LoginRs.getString("app_token");
				headimgurl = LoginRs.getString("headimgurl");
				userState = LoginRs.getString("state");
				useroleCode = LoginRs.getString("userole");

				if ("1".equals(useroleCode)) {
					useroleName = "老师";
				} else if ("2".equals(useroleCode)) {
					useroleName = "学生";
				} else if ("3".equals(useroleCode)) {
					useroleName = "家长";
				} else if ("4".equals(useroleCode)) {
					useroleName = "管理员";
				} else {
					useroleName = "未知身份";
				}

			}
			if (LoginRs != null) {
				LoginRs.close();
			}

			if ("1".equals(userState)) { // 判断是否账号禁用
				// 更新app token
				String mD5token = Md5.get(USERID + username + "" + Calendar.getInstance().getTimeInMillis()); // 随机生成md5数值
				db.executeUpdate("UPDATE  `user_worker` SET `app_token`='" + mD5token + "' WHERE `uid`='" + USERID + "';");
				// 组装json给手机端
				if (headimgurl.indexOf("http") == -1) {
					if ("LAN".equals(info.getChannelId())) {
						headimgurl="http://hljsfjy.work"+headimgurl;
					}
					else   {
						headimgurl="http://api/hljsfjy.org.cn"+headimgurl;
					}
				}
				JSONObject userJson = new JSONObject();
				userJson.put("success", "true");
				userJson.put("resultCode", "1000");
				userJson.put("msg", "用户登陆成功");
				userJson.put("Token", "" + mD5token);
				userJson.put("USERID", "" + USERID);
				userJson.put("username", "" + username);
				userJson.put("userole", "" + useroleCode);
				userJson.put("useroleName", "" + useroleName);
				userJson.put("headimgurl", "" + headimgurl);
				responsejson = userJson.toString();

				long ExeTime = Calendar.getInstance().getTimeInMillis() - info.getTimeStart();
				Atm.AppuseLong(info, username, claspath, theClassName, responsejson, ExeTime);
				Atm.LogSys("登陆", "用户APP端登录成功", "用户:" + mobile + "登录了系统", "1", info.getUSERID(), info.getIp());

				out.print(responsejson);
				Page.colseDOP(db, out, page);
				return;
			} else {
				JSONObject userJson = new JSONObject();
				userJson.put("success", "true");
				userJson.put("resultCode", "403");
				userJson.put("msg", "用户登陆失败，账号被禁用");
				responsejson = userJson.toString();

				long ExeTime = Calendar.getInstance().getTimeInMillis() - info.getTimeStart();
				Atm.AppuseLong(info, username, claspath, theClassName, responsejson, ExeTime);
				Atm.LogSys("登陆", "用户APP端登录失败", "用户:" + mobile + "备注被禁用", "1", info.getUSERID(), info.getIp());

				ErrMsg.falseErrMsg(request, response, "403", "您的账号被禁用！");
				Page.colseDOP(db, out, page);
				return;
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
