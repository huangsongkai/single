package v1.web.file;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONObject;

import service.common.SetupConf;
import service.dao.db.Jdbc;
import service.dao.db.Page;
import service.sys.ErrMsg;

import com.jspsmart.upload.File;
import com.jspsmart.upload.Files;
import com.jspsmart.upload.SmartUpload;

/**
 * 
 * @author Administrator
 * @date 2017-8-7
 * @file_name UpFile.java
 * @Remarks   接收pc端  附件
 */

@SuppressWarnings("serial")
public class UpFile extends HttpServlet {

	public void doGet(HttpServletRequest request, HttpServletResponse response)throws ServletException, IOException {
		doPost(request, response);
	}

	// 上传方法
	public void doPost(HttpServletRequest request, HttpServletResponse response)throws ServletException, IOException {

		// 获取资源
		Jdbc db = new Jdbc();
		Page page = new Page();
		
		long TimeStart = new Date().getTime();// 程序开始时间，统计效率
		
		String classname = "pc端-上传附件";
		String claspath = this.getClass().getName();

		// 设置编码格式
		request.setCharacterEncoding("utf-8");
		response.setCharacterEncoding("utf-8");
		PrintWriter out = response.getWriter();

		int time = Math.round(new Date().getTime() / 1000);// 时间戳不带毫秒

		// 获取用户传来的参数
		String ip = request.getHeader("x-real-ip");//ip
		if (ip == null || ip.length() == 0) {
			ip = request.getRemoteAddr();
		}
		
		String AppId = request.getHeader("X-AppId"); // 标明正在运行的是哪个App程序
		String AppKey = request.getHeader("X-AppKey"); // 授权鉴定终端
		String Token=request.getHeader("Token");
		
		String USERID = request.getHeader("X-USERID");  //非登陆用户请求可为空   用户id
		
		String AppKeyType = "";
 
		// 安全过滤
		if (!SetupConf.get("AppId").equals(AppId)) {
			
			ErrMsg.falseErrMsg(request, response, "403", "appid非法的设备请求");
			return;
		}
		if (SetupConf.get("IOSAppKey").equals(AppKey)) {
			AppKeyType = "IOS";
		} else if (SetupConf.get("androidAppKey").equals(AppKey)) {
			AppKeyType = "Android";
		} else if (SetupConf.get("webAppKey").equals(AppKey)) {
			AppKeyType = "WEB";
		} else {
			ErrMsg.falseErrMsg(request, response, "403", "非法的设备请求");
			return;
		}
		
		// token 认证过滤  本资源未登录不可调用 
		int TokenTag = db.Row("SELECT COUNT(1) as row FROM  user_worker WHERE uid ='"+ USERID + "' AND app_token='" + Token + "'");
		
		if (TokenTag != 1) {
			ErrMsg.falseErrMsg(request, response, "403", "请登录！");
			Page.colseDOP(db, out, page);
			return;// 跳出程序只行
		}
        
		JSONObject json = new JSONObject();//返回json 对象
		ArrayList<String> list = new ArrayList<String>();
		
		String URLpath = request.getContextPath();
        String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+URLpath+"/";
        basePath=basePath.replaceAll(":80", "").replaceAll("https", "http");
        
		String attachmentName=""; //附件名称
		
		String up_Path = "";//上传路径
		if(System.getProperty("user.dir").indexOf("dev.e168.cn")!=-1){//外网
			up_Path=SetupConf.get("userIco_path"); // 获得上传路径
		}else{//本地
			up_Path="C:\\Users\\Administrator\\Pictures\\work_test"; // 获得上传路径
		}
		
		// 第一步:新建一个对象
		SmartUpload smart = new SmartUpload();
		// 第二步:初始化
		smart.initialize(super.getServletConfig(), request, response);
		// 第三步:设置上传文件的类型
		smart.setAllowedFilesList("jpg,png,pdf,txt,mp4,mp3");

		try {
			// 第三步:上传文件
			smart.upload();
			// smart.uploadInFile(destFilePathName)
			// 第四步：保存文件
			// smart.save("/imges");
			// 对文件进行重命名
			
			//接收文本值
			 String jsonDate=smart.getRequest().getParameter("json");//帖子数据
			
			
			Files fs = smart.getFiles();// 得到所有的文件
			int fsnum = fs.getCount();//文件个数


			
			for (int i = 0; i < fs.getCount(); i++) {// 对文件个数进行循环
				File f = fs.getFile(i);
				if (f.isMissing() == false) // 判断文件是否存在
				{
					attachmentName = USERID + "_" + System.currentTimeMillis()+ "_" + i + "." + f.getFileExt();
					f.saveAs(up_Path + attachmentName); // 写入文件
					list.add(attachmentName+"?"+i);
					System.out.println("图片保存地址=="+up_Path + attachmentName);
				}
			}
			

		} catch (Exception e) {
			e.printStackTrace();// 报错信息
			int ErrLineNumber = e.getStackTrace()[0].getLineNumber();
			ErrMsg.falseErrMsg(request, response,"500", "图片上传异常");
			db.executeUpdate(" INSERT INTO `log_sys`(`ltype`,`title`,`body`,`uid`,`ip`,`addtime`) VALUES ('系统错误','"+ classname+ "模块系统出错','错误信息详见 "+ claspath+ "请检测第"+ ErrLineNumber+ "行数代码。出错客户端"+AppKeyType+"。','"+ USERID+ "','" + ip + "',now());;");
			json.put("success", true);
			json.put("resultCode", 500);
			json.put("msg", "附件上传出错");
			out.print(json);
			Page.colseDOP(db, out, page);
			return;// 程序关闭
		}

		
		json.put("success", true);
		json.put("resultCode", 1000);
		json.put("msg", "附件上传出错");
		json.put("attachment",list.toString().replaceAll("\\[", "").replaceAll("\\]", "") );
		out.print(json);
		
		
		 //记录日志
//    	long ExeTime = Calendar.getInstance().getTimeInMillis()-TimeStart;
//	    String InsertSQLlog = "INSERT INTO  ec_appuse_log (`uuid`,`Mdels`,`NetMode`,`GPS`,`GPSLocal`,`username`,`did`,`uid`,`ExeTime`,`classpath`,`classname`,`ip`,`logintime`,`requestjson`,`responsejson`) VALUES ('"+UUID+"','"+Mdels+"','"	+NetMode+"','"+GPS+"','"+GPSLocal+"','"	+USERID+"','"+DID+"','"+USERID+"','"+ExeTime+"','"+claspath+"','"+classname+"','"+ip+"',now(),'app上传资料资源标识path="+Path+"','"+"返回的json"+"');";
//	    db.executeUpdate(InsertSQLlog);
		/*
		 * 关闭数据库资源
		 */
		Page.colseDOP(db, out, page);
		return;// 程序关闭
	}

}
