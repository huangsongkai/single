package v1;

import service.common.SetupConf;
import service.dao.db.Page;
import service.sys.ErrMsg;
import v1.haocheok.commom.entity.InfoEntity;
import v1.moblie.app.cms.GetCmsLan;
import v1.moblie.app.cms.GetCmsWan;
import v1.moblie.app.login.MsgCount;
import v1.moblie.app.login.UserLogin;
import v1.moblie.app.menu.GetMenuSys;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.Calendar;

/**
 * @author LiGaoSong E-mail: 932246@qq.com
 * @version 创建时间：2018-4-1 凌晨03:05:23 类说明 ：app api 接口主入口
 */
@SuppressWarnings("serial")
public class appApi extends HttpServlet {

	public appApi() {
		super();
	}

	public void destroy() {
		super.destroy(); // Just puts "destroy" string in log

	}


	/**
	 * api 接口总入口 接受变量引导
	 */

	public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		System.out.println("appapi 主入口doget输出测试");
			/* 允许跨域的主机地址 */
		response.setHeader("Access-Control-Allow-Origin", "*");
			/* 允许跨域的请求方法GET, POST, HEAD 等 */
		response.setHeader("Access-Control-Allow-Methods", "*");
			/* 重新预检验跨域的缓存时间 (s) */
		response.setHeader("Access-Control-Max-Age", "3600");
			/* 允许跨域的请求头 */
		response.setHeader("Access-Control-Allow-Headers", "*");
			/* 是否携带cookie */
		response.setHeader("Access-Control-Allow-Credentials", "true");

		process(request, response);

	}

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		System.out.println("appapi 主入口doPost输出测试");
			/* 允许跨域的主机地址 */
		response.setHeader("Access-Control-Allow-Origin", "*");
			/* 允许跨域的请求方法GET, POST, HEAD 等 */
		response.setHeader("Access-Control-Allow-Methods", "*");
			/* 重新预检验跨域的缓存时间 (s) */
		response.setHeader("Access-Control-Max-Age", "3600");
			/* 允许跨域的请求头 */
		response.setHeader("Access-Control-Allow-Headers", "*");
			/* 是否携带cookie */
		response.setHeader("Access-Control-Allow-Credentials", "true");

		process(request, response);
	}

	/**
	 * @category 构建一个process方法
	 */
	private void process(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		long TimeStart = Calendar.getInstance().getTimeInMillis();// 性能测试;
		long TimeEnd = 0;

		@SuppressWarnings("unused")
		SetupConf setupConf = new SetupConf();
		Page Page = new Page();

		response.setContentType("text/html;charset=UTF-8");
		request.setCharacterEncoding("UTF-8");
		response.setCharacterEncoding("UTF-8");

		String ip = request.getHeader("x-real-ip");
		if (ip == null || ip.length() == 0) {
			ip = request.getRemoteAddr();
		}

		String Path = request.getParameter("p"); // 资源路径
		String AppId = request.getHeader("X-AppId"); // 标明正在运行的是哪个App程序
		String AppKey = request.getHeader("X-AppKey"); // 授权鉴定终端
		String Token = request.getHeader("Token");

		String UUID = request.getHeader("X-UUID"); // 必填设备串码
		String USERID = request.getHeader("X-USERID"); // 非登陆用户请求可为空
		String DID = request.getHeader("X-DeviceId"); // 设备id
		String Mdels = request.getHeader("X-Mdels"); // 必填 "IOS7.0/安卓4.3"
		String NetMode = request.getHeader("X-NetMode"); // 必填 网络制式
		String ChannelId = request.getHeader("X-NETINFO"); // 区分内网外网标记LAN/WAN
		String GPS = request.getHeader("X-GPS"); // GPS定位信息
		String GPSLocal = request.getHeader("X-GPSLocal"); // GPS定位信息

		String theClassName = "";
		/* 过滤非法字符 */
		if (Path == null) {
			Path = "";
		}
		if (AppId == null) {
			AppId = "";
		}
		if (AppKey == null) {
			AppKey = "";
		}
		if (Token == null) {
			Token = "";
		}
		if (UUID == null) {
			UUID = "";
		}
		if (USERID == null) {
			USERID = "0";
		}
		if (Mdels == null) {
			Mdels = "";
		}
		if (ChannelId == null) {
			ChannelId = "0";
		}
		if (DID == null) {
			DID = "0";
		}

		Path = Path.replaceFirst("/app/", "app/");
		AppId = Page.mysqlCode(AppId);
		AppKey = Page.mysqlCode(AppKey);
		Token = Page.mysqlCode(Token).replaceAll("'", "");
		UUID = Page.mysqlCode(UUID);
		USERID = Page.mysqlCode(USERID).replaceAll("'", "");
		Mdels = Page.mysqlCode(Mdels);
		NetMode = Page.mysqlCode(NetMode);
		ChannelId = Page.mysqlCode(ChannelId);
		GPS = Page.mysqlCode(GPS);
		// GPSLocal=Page.mysqlCode(GPSLocal);
		/* 过滤非法字符 */

		/*
		 * System.out.println("UUID="+UUID); System.out.println("AppId="+AppId);
		 * System.out.println("AppKey="+AppKey);
		 * System.out.println("Token="+Token);
		 */

		String AppKeyType = ""; // AppKey类型
		String RequestJson = "";// 接受json

		/* 验证过滤判断 */
		if (!"8381b915c90c615d66045e54900feeab".equals(AppId) || !"d4df770ef73bd57653b0af59934296ee".equals(AppKey)) {
			ErrMsg.falseErrMsg(request, response, "403", "appid非法的设备请求");
			return;
		}

		/* 验证过滤判断结束 */

		/*
		 * 启动二进制获取发送过来的数据
		 */

		String InputString = null; // 读取请求内容
		try {

			BufferedReader br = new BufferedReader(new InputStreamReader(request.getInputStream(), "UTF-8"));// json进行uf8编码
			String line = null;
			StringBuilder sb = new StringBuilder();

			while ((line = br.readLine()) != null) {
				sb.append(line);
			}
			br.close();// 关闭2进制流

			InputString = sb.toString();
		 
			// 替换sql文敏感字
			RequestJson =InputString.replaceAll("'", "");

			// RequestJson=InputString;

		} catch (Exception e) {
			e.printStackTrace();
		}

		/*
		 * 启动二进制获取发送过来的数据结束
		 */

		// 封装接收收据，保存到日志中的数据
		InfoEntity info = new InfoEntity(UUID, Token, USERID, DID, Mdels, NetMode, ChannelId, ip, GPS, GPSLocal, AppKeyType, TimeStart, RequestJson);
     System.err.println(Path);
		/*
		 * 业务处理模块开始
		 */
		if (Path.indexOf("app/") != -1) { // app 模块判断

			if (Path.equals("app/login/userlogin")) {
				theClassName = "用户登录";
				UserLogin userLogin = new UserLogin();
				userLogin.process(request, response, info, theClassName);
			}

			else if (Path.equals("app/login/msgcount")) {
				theClassName = "APP启动获得本机ip与消息";
				MsgCount msgCount=new MsgCount();
				msgCount.process(request, response, info, theClassName);

			}
			else if (Path.equals("app/cms/GetCmsWan")) {
				theClassName = "获得外网新闻模块";
				GetCmsWan getCmsWan = new GetCmsWan();
				getCmsWan.process(request, response, info, theClassName);

			}
			else if (Path.equals("app/cms/GetCmsLan")) {
				theClassName = "获得内网新闻模块";
				GetCmsLan getCmsLan=new GetCmsLan();
				getCmsLan.process(request, response, info, theClassName);

			}
			else if (Path.equals("app/get/app_menu_sys")) {
				theClassName = "获取教务/学生/个人的菜单";
				GetMenuSys getMenuSys=new GetMenuSys();
				getMenuSys.process(request, response, info, theClassName); 

			}
		 
			
			else {
				ErrMsg.falseErrMsg(request, response, "404", "app模块没有对应的资源路径");
			}

			// 性能debug输出
			TimeEnd = Calendar.getInstance().getTimeInMillis();
			System.out.println();
			System.out.println("===========APP api=================");
			System.out.println("appid 	:" + AppId);
			System.out.println("appkey	:" + AppKey);
			System.out.println("模块           :" + Path);
			System.out.println("模块说明 :" + theClassName);
			System.out.println("业务信息 :" + RequestJson);
			System.out.println("内外网标示 	:" + ChannelId);
			System.out.println("耗时:" + (TimeEnd - TimeStart) + "ms");
			return;
			// app大类模块判断结束
		} else if (Path.indexOf("h5/") != -1) { // H5 大类模块开始

			/*
			 * H5 接口大类模块
			 */
			if (Path.equals("app/user/xxxx")) {
				theClassName = "app用户登录";
				UserLogin userLogin=new UserLogin();
				userLogin.process(request, response, info, theClassName);

			}
			
			else if (Path.equals("app/cms/wan/xxxx")) {
				theClassName = "获得外网新闻分类";
				/*GetCmsWan getCmsWan = new GetCmsWan();
				getCmsWan.process(request, response, info, theClassName);*/

			}
			

			else {
				ErrMsg.falseErrMsg(request, response, "404", "H5模块没有对应的资源路径");
			}
			// 性能debug输出
			TimeEnd = Calendar.getInstance().getTimeInMillis();
			System.out.println();
			System.out.println("===========H5 API=================");
			System.out.println("appid 	:" + AppId);
			System.out.println("appkey	:" + AppKey);
			System.out.println("Token	:" + Token);
			System.out.println("UUID	:" + UUID);
			System.out.println("USERID	:" + USERID);
			System.out.println("模块           :" + Path);
			System.out.println("模块说明 :" + theClassName);
			System.out.println("业务信息 :" + RequestJson);
			System.out.println("内外网标示 	:" + ChannelId);
			System.out.println("耗时:" + (TimeEnd - TimeStart) + "ms");
			return;
			// web 大类模块结束

		} else {// 大类其他情况
			ErrMsg.falseErrMsg(request, response, "404", "主API分类没有对应的资源路径");
		}
		// 性能debug输出
		TimeEnd = Calendar.getInstance().getTimeInMillis();
		System.out.println();
		System.out.println("============================");
		System.out.println("appid 	:" + AppId);
		System.out.println("appkey	:" + AppKey);
		System.out.println("模块           :" + Path);
		System.out.println("业务信息 :" + RequestJson);
		System.out.println("耗时:" + (TimeEnd - TimeStart) + "ms");
	}
}
