package v1;

import net.sf.json.JSONObject;
import service.dao.db.Page;
import service.sys.ErrMsg;
import v1.grade.GradeService;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.lang.reflect.Method;
import java.util.Calendar;
import java.util.HashMap;
import java.util.Map;

/**
 * @author WangYuxin E-mail: 1325943548@qq.com
 * @version grade api 接口主入口 (成绩管理)
 */
@SuppressWarnings("serial")
public class gradeApi extends HttpServlet {
	public gradeApi() {
		super();
	}

	public void destroy() {
		super.destroy(); // Just puts "destroy" string in log

	}

	/**
	 * api 接口总入口 接受变量引导
	 */

	public void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		System.out.println("appapi 主入口doget输出测试");
		process(request, response);
	}

	public void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		System.out.println("appapi 主入口doPost输出测试");
		process(request, response);
	}
	public void doOptions(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		System.out.println("appapi 主入口doOptions输出测试");
		process(request, response);
	}


	/**
	 * @category 构建一个process方法
	 */
	private void process(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		long TimeStart = Calendar.getInstance().getTimeInMillis();// 性能测试;
		long TimeEnd = 0;

		Page page = new Page();

		request.setCharacterEncoding("UTF-8");

		response.setContentType("application/json;charset=UTF-8");
		response.setCharacterEncoding("UTF-8");

		//允许跨域，开发时方便测试
		response.addHeader("Access-Control-Allow-Origin", "*");
		response.addHeader("Access-Control-Allow-Headers", "origin, content-type, accept, authorization");
		response.addHeader("Access-Control-Allow-Credentials", "true");
		response.addHeader("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, OPTIONS, HEAD");
		response.addHeader("Access-Control-Max-Age", "1209600");

		String ip = request.getHeader("x-real-ip");
		if (ip == null || ip.length() == 0) {
			ip = request.getRemoteAddr();
		}

		String path = request.getParameter("p"); // 资源路径
		String appId = request.getHeader("X-AppId"); // 标明正在运行的是哪个App程序
		String appKey = request.getHeader("X-AppKey"); // 授权鉴定终端
		String token = request.getHeader("Token");

		String UUID = request.getHeader("X-UUID"); // 必填设备串码
//		String userid = request.getHeader("X-USERID"); // 非登陆用户请求可为空
		String userid = "0";
		String DID = request.getHeader("X-DeviceId"); // 设备id
		String Mdels = request.getHeader("X-Mdels"); // 必填 "IOS7.0/安卓4.3"
		String NetMode = request.getHeader("X-NetMode"); // 必填 网络制式
//		String ChannelId = request.getHeader("X-NETINFO"); // 区分内网外网标记LAN/WAN
		String ChannelId ="0";
		String GPS = request.getHeader("X-GPS"); // GPS定位信息
		String GPSLocal = request.getHeader("X-GPSLocal"); // GPS定位信息

		String theClassName = "";
		/* 过滤非法字符 */
		if (path == null) {
			path = "";
		}
		if (appId == null) {
			appId = "";
		}
		if (appKey == null) {
			appKey = "";
		}
		if (token == null) {
			token = "";
		}
		if (UUID == null) {
			UUID = "";
		}
		if (userid == null) {
			userid = "0";
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

		path = path.replaceFirst("/app/", "app/");
		appId = page.mysqlCode(appId);
		appKey = page.mysqlCode(appKey);
		token = page.mysqlCode(token).replaceAll("'", "");
		UUID = page.mysqlCode(UUID);
		userid = page.mysqlCode(userid).replaceAll("'", "");
		Mdels = page.mysqlCode(Mdels);
		NetMode = page.mysqlCode(NetMode);
		ChannelId = page.mysqlCode(ChannelId);
		GPS = page.mysqlCode(GPS);
		// GPSLocal=Page.mysqlCode(GPSLocal);
		/* 过滤非法字符 */

		/*
		 * System.out.println("UUID="+UUID); System.out.println("AppId="+AppId);
		 * System.out.println("AppKey="+AppKey);
		 * System.out.println("Token="+Token);
		 */

		String AppKeyType = ""; // AppKey类型
		String RequestJson = "aaavqsF5UzdkN-ngf6G4w";// 接受json

		/* 验证过滤判断 */
//		if (!"8381b915c90c615d66045e54900feeab".equals(appId)
//				|| !"d4df770ef73bd57653b0af59934296ee".equals(appKey)) {
//			ErrMsg.falseErrMsg(request, response, "403", "appid非法的设备请求");
//			return;
//		}

		/* 验证过滤判断结束 */

		/*
		 * 启动二进制获取发送过来的数据
		 */

		String InputString = null; // 读取请求内容
		try {

			InputString = request.getParameter("context");
			if(InputString==null){
				InputString = "";
			}

			// 替换sql文敏感字！！！！！！
			RequestJson = InputString.replaceAll("'", "");

			// RequestJson=InputString;

		} catch (Exception e) {
			e.printStackTrace();
		}

		/*
		 * 启动二进制获取发送过来的数据结束
		 */

		// 封装接收收据，保存到日志中的数据
//		InfoEntity info = new InfoEntity(UUID, Token, USERID, DID, Mdels,
//				NetMode, ChannelId, ip, GPS, GPSLocal, AppKeyType, TimeStart,
//				RequestJson);
		
		
		System.err.println(path); //p 路径

		/*
		 * -------------------------------------业务处理模块开始--------------------------
		 * 
		 */

		if(path.startsWith("app/grade/")){
			String[] patterns = path.split("/");
			String methodName = patterns[patterns.length-1];
			PrintWriter out = null;
			try {
				out = response.getWriter();
				Method method = null;
				Map<String,Method> methodMap = this.methodMapThreadLocal.get();
				if(methodMap != null){
					method = methodMap.get(methodName);
				}else {
					this.methodMapThreadLocal.set(new HashMap<String, Method>());
				}

				if(method==null){
					method = GradeService.class.getMethod(methodName,String.class);
					this.methodMapThreadLocal.get().put(methodName,method);
				}

				Object context = method.invoke(null,RequestJson);
				JSONObject jsonObject = new JSONObject();
				jsonObject.put("success",true);
				jsonObject.put("resultCode",1000);
				jsonObject.put("result",context);
				out.print(jsonObject.toString());
				out.flush();
			} catch (Exception e) {
				e.printStackTrace();

				ErrMsg.falseErrMsg(request, response, "404", "app模块没有对应的资源路径");
			}finally {
				if (out != null) {
					out.close();
				}
			}
		}
		else {
			ErrMsg.falseErrMsg(request, response, "404", "app模块没有对应的资源路径");
		}

		/*
		 * -------------------------------------业务处理模块结束--------------------------
		 * --
		 */
		// 性能debug输出
		TimeEnd = Calendar.getInstance().getTimeInMillis();
		System.out.println();
		System.out.println("===========APP api=================");
		System.out.println("appid 	:" + appId);
		System.out.println("appkey	:" + appKey);
		System.out.println("模块           :" + path);
		System.out.println("模块说明 :" + theClassName);
		System.out.println("业务信息 :" + RequestJson);
		System.out.println("内外网标示 	:" + ChannelId);
		System.out.println("耗时:" + (TimeEnd - TimeStart) + "ms");
		return;
		// app大类模块判断结束

	}

	private ThreadLocal<Map<String,Method>> methodMapThreadLocal = new ThreadLocal<Map<String, Method>>();
}
