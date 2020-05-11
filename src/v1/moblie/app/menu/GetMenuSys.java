package v1.moblie.app.menu;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.ResultSet;
import java.util.Calendar;
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
import v1.haocheok.commom.entity.InfoEntity;

/**
 * @author 李高颂
 * @version 创建时间：2018-4-6 23:24:21
 * @category 获取APP的教务，学生，菜单，我的菜单 通过userid类型来判断是否是家长和学生或教职工 通过classtype=来判断模块。 0
 *           个人中心 ； 1教职工 2学生
 */

public class GetMenuSys {

	@SuppressWarnings("static-access")
	public void process(HttpServletRequest request, HttpServletResponse response, InfoEntity info, String theClassName) throws ServletException, IOException {

		Jdbc db = new Jdbc();
		Page page = new Page();

		response.setContentType("text/html;charset=UTF-8");
		request.setCharacterEncoding("UTF-8");
		response.setCharacterEncoding("UTF-8");

		PrintWriter out = response.getWriter();

		String responsejson = ""; // 读取分类配置文件
		String webstateurl = "";
		String lanip = "";
		String lanipduan = "";
		String formip = info.getIp();
		String menutype="";//菜单类型
		
		try { // 解析开始
			JSONArray arr = JSONArray.fromObject("[" + info.getRequestJson() + "]");
			for (int i = 0; i < arr.size(); i++) {
				JSONObject obj = arr.getJSONObject(i);
				menutype = obj.get("classtype") + "";
			 }
		} catch (Exception e) {
			ErrMsg.falseErrMsg(request, response, "500", "json格式异常");
			Page.colseDOP(db, out, page);
			return;

		}
		if (menutype == null || "null".equals(menutype)) {
			menutype = "";
		} // 解析结束

		if (menutype.length() < 1) {
			ErrMsg.falseErrMsg(request, response, "403", "菜单类型不明-1");
			Page.colseDOP(db, out, page);
			return;
		}

		/**
		 * 取出配置文件 判断内网外网给分配网址
		 */
		try {
			ResultSet Rs = null;

			Rs = db.executeQuery("SELECT  config_value  FROM  sys_config  WHERE id='6';"); // 内网IP特征
			if (Rs.next()) {
				lanipduan = Rs.getString("config_value");
			}

			Rs = db.executeQuery("SELECT  config_value  FROM  sys_config  WHERE id='8';"); // 外部办公网api地址
			if (Rs.next()) {
				webstateurl = Rs.getString("config_value");
			}
			if (Rs != null) {
				Rs.close();
			}

			Rs = db.executeQuery("SELECT  config_value  FROM  sys_config  WHERE id='7';"); //  内部api网址
			if (Rs.next()) {
				lanip = Rs.getString("config_value");
			}
			if (Rs != null) {
				Rs.close();
			}

			// 判断是否是内网
			List<String> ipList = java.util.Arrays.asList(lanipduan.split(","));
			if (page.IPMatch(ipList, formip) == true) {
				webstateurl = lanip; // 如果是内网就给内部网址
			}

			
		     
			System.err.println(info.getIp());
			System.err.println(page.IPMatch(ipList, formip));
			System.err.println("webstateurl=" + webstateurl);

		} catch (Exception e) {
			ErrMsg.falseErrMsg(request, response, "500", " SQL错误见模块" + this.getClass() + "");
			Page.colseDOP(db, out, page);
			return;
		}

		/**
		 * 用户登录名与密码是否正确
		 */

		int LoginTag = 0;
		String userole = "";
		String useroleName = "";
		try {
			String LoginsqlString = "SELECT userole  FROM  user_worker WHERE  uid='" + info.getUSERID() + "' AND app_token='" + info.getToken() + "' limit 1; ";
			ResultSet LoginRs = db.executeQuery(LoginsqlString);

			if (LoginRs.next()) {
				LoginTag = LoginTag + 1;
				userole = LoginRs.getString("userole");
			}
			if (LoginRs != null) {
				LoginRs.close();
			}
			// 判断登录是否
			if (LoginTag == 0) {
				responsejson = "{\"success\":\"true\",\"resultCode\":\"403\",\"msg\":\" 请登录 \"}";
				out.print(responsejson);
				// 记录执行日志
				long ExeTime = Calendar.getInstance().getTimeInMillis() - info.getTimeStart();
				Atm.AppuseLong(info, "0", this.getClass().getName(), theClassName, responsejson, ExeTime);
				// 添加操作日志
				Atm.LogSys("APP获取菜单", "获取菜单失败", "未登录状态用户:" + info.getUUID() + "请求app菜单，因没有登录，被拦截", "0", "0", info.getIp());
				Page.colseDOP(db, out, page);
				return;// 跳出程序只行
			}

			// 判断取值类型
			if ("1".equals(userole)) {
				useroleName = "教职工";
			} else if ("2".equals(userole)) {
				useroleName = "学生";
			} else if ("3".equals(userole)) {
				useroleName = "家长";
			} else if ("4".equals(userole)) {
				useroleName = "管理员";
			} else {
				userole="44444";
				useroleName = "不明身份";
			}
			//如果是管理员给教职工菜单把3和4都标记起来
		    String whereString="userole='" + userole + "' and menutype="+menutype+"  and";
			
			if("4".equals(userole)){ //如果是管理员就把老师的菜单权限也加入进来
				whereString="(userole='1' or userole='4') and menutype="+menutype+" and ";
			}
			if("3".equals(userole)){//如果是家长就把学生角色菜单加入进来
				whereString="(userole='2' or userole='3') and menutype="+menutype+" and ";
			}

			System.out.println("userole=" + userole);
			System.out.println("useroleName=" + useroleName);
			System.out.println("webstateurl=" + webstateurl);

			/**
			 * 获取菜单业务逻辑
			 */

			JSONArray array = new JSONArray();
			JSONObject object = new JSONObject();
			String menulink="",icoString="";
			String sqlString="SELECT  id,menuname,ico,userole,menulink  FROM  app_menu_sys  WHERE "+whereString+" showstate='1' order BY Sortid asc;";
			ResultSet menuRs = db.executeQuery(sqlString); // 找内部网址

			while (menuRs.next()) {
				menulink=menuRs.getString("menulink");
				icoString=menuRs.getString("ico");
				if(menulink.indexOf("http://")==-1){
					menulink="http://"+webstateurl+menulink;
				}
				if(icoString.indexOf("http://")==-1){
					icoString="http://"+webstateurl+icoString;
				}
				object.put("id", menuRs.getString("id"));
				object.put("menu", menuRs.getString("menuname"));
				object.put("ico", icoString);
				object.put("url", menulink);
				array.add(object);
			}
			if (menuRs != null) {
				menuRs.close();
			}
			responsejson = "{\"success\":true,\"resultCode\":\"1000\",\"msg\":\""+useroleName+"菜单接口读取成功\",\"threads\":"+array.toString()+"}";
			out.print(responsejson);
			if(array!=null){array.clear();}
			if(object!=null){object.clear();}
			
			/**
			 * 获取菜单业务结束---------->
			 */
			

		} catch (Exception e) { 
			ErrMsg.falseErrMsg(request, response, "500", " SQL错误见模块" + this.getClass() + " ERR:"+e.getStackTrace()[0].getLineNumber()+"");
			Page.colseDOP(db, out, page);
			return;
		}

		// 记录执行日志
		long ExeTime = Calendar.getInstance().getTimeInMillis() - info.getTimeStart();
		Atm.AppuseLong(info, info.getUSERID(), this.getClass().getName(), theClassName, responsejson, ExeTime);

		Page.colseDOP(db, out, page);

		out.flush();
		out.close();
	}
}
