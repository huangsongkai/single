package v1.haocheok.file;

import java.io.IOException;
import java.io.PrintWriter;
import java.net.URLDecoder;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import service.common.SetupConf;
import service.dao.db.Jdbc;
import service.dao.db.Page;
import service.file.FileAc;
import service.sys.Atm;
import service.sys.ErrMsg;

import com.jspsmart.upload.File;
import com.jspsmart.upload.Files;
import com.jspsmart.upload.SmartUpload;


/**
 * 
 * @author Administrator
 * @date 2017-8-7
 * @file_name UpFile.java
 * @Remarks   接收app  附件
 */

@SuppressWarnings("serial")
public class UpFile extends HttpServlet {

	public void doGet(HttpServletRequest request, HttpServletResponse response)throws ServletException, IOException {
		doPost(request, response);
	}
	// 上传方法
	public void doPost(HttpServletRequest request, HttpServletResponse response)throws ServletException, IOException {

		// 设置编码格式
		request.setCharacterEncoding("utf-8");
		response.setCharacterEncoding("utf-8");
		PrintWriter out = response.getWriter();
		
		// 获取资源
		Jdbc db = new Jdbc();
		Page page = new Page();
		long TimeStart = new Date().getTime();// 程序开始时间，统计效率
		
		String classname = "手机端-上传附件";
		String claspath = this.getClass().getName();

		// 获取用户传来的参数
		String ip = request.getHeader("x-real-ip");
		if (ip == null || ip.length() == 0) {ip = request.getRemoteAddr();}
		String Path=request.getParameter("p");        if(Path==null){Path="";}  //资源路径
		String AppId = request.getHeader("X-AppId");  if(AppId==null){AppId="";}  // 标明正在运行的是哪个App程序
		String AppKey = request.getHeader("X-AppKey");if(AppKey==null){AppKey="";}  // 授权鉴定终端
		String Token=request.getHeader("Token");      if(Token==null){Token="";} 
		String UUID = request.getHeader("X-UUID");    if(UUID==null){UUID="";}   //必填设备串码
		String USERID = request.getHeader("X-USERID");if(USERID==null){USERID="";}  //非登陆用户请求可为空   用户id
		String DID = request.getHeader("X-DeviceId"); if(DID==null){DID="0";}  //设备id
		String Mdels=request.getHeader("X-Mdels");    if(Mdels==null){Mdels="";}//必填 "IOS7.0/安卓4.3" 
		String NetMode=request.getHeader("X-NetMode");if(NetMode==null){NetMode="";}  // 必填 网络制式
		String GPS=request.getHeader("X-GPS");        if(GPS==null){GPS="";} // GPS定位信息
		String GPSLocal=request.getHeader("X-GPSLocal");if(GPSLocal==null){GPSLocal="";}   // GPS定位信息
		String AppKeyType = "";
		
 
		// 安全过滤
		if (!SetupConf.get("AppId").equals(AppId)) 	  {ErrMsg.falseErrMsg(request, response, "403", "appid非法的设备请求"); return;}
		if(SetupConf.get("IOSAppKey").equals(AppKey)) {AppKeyType = "IOS";} 
		else if (SetupConf.get("androidAppKey").equals(AppKey)) {AppKeyType = "Android";} 
		else if (SetupConf.get("webAppKey").equals(AppKey)) {AppKeyType = "WEB";} 
		else {ErrMsg.falseErrMsg(request, response, "403", "非法的设备请求");Page.colseDOP(db, out, page); return;};// 跳出程序执行
		if(Path==null){Path="";}
		
		// token 认证过滤  本资源未登录不可调用 
		int TokenTag = db.Row("SELECT COUNT(1) as row FROM  user_worker WHERE uid ='"+ USERID + "' AND app_token='" + Token + "'");
		if (TokenTag != 1) {ErrMsg.falseErrMsg(request, response, "403", "请登录！");Page.colseDOP(db, out, page); return; }// 跳出程序执行
		
		
		JSONObject json = new JSONObject();//返回手机端 json对象
		
		ArrayList<String> up_list = new ArrayList<String>();//上传后的附件地址集合
		String placeid = "",fromName = "",uniquelyid = "";//订单id,表单名称,组件id
		
		String attachmentid="";//查询出已经存在的附件id
		
		String upsql="";//更新附件表sql语句
		boolean up_state=false;//更新附件表sql执行状态
		
		String ny=Page.ym();      //时间年月简写
		int attachmentNum=0;	  //附件数量
		String attachmentName=""; //附件名称
		String up_Path = "";	  //上传路径
		
		ArrayList<String> list_img = new ArrayList<String>();//写入附件数据库语句的集合
		
		String img_lis="";        //当前组件所有图片拼接后
		String jsontemplate="";   //要修改的json串
		boolean up_stat=false;//更新角色表状态
		String up_str="";//修改更新角色表sql语句
		
		up_Path=SetupConf.get("img_path"); // 获得上传路径
		
		//判断有没有改文件夹 没有就创建
		FileAc fileAc = new FileAc();
		fileAc.MDir(up_Path+ny, 0);//创建文件夹
		up_Path=up_Path+ny+"/";
		
		db.executeUpdate_GROUP("SET SESSION group_concat_max_len = 999999999;");
		
		// 第一步:新建一个对象
		SmartUpload smart = new SmartUpload();
		// 第二步:初始化
		smart.initialize(super.getServletConfig(), request, response);
		// 第三步:设置上传文件的类型
		smart.setAllowedFilesList("jpg,jpeg,png,pdf,txt,mp4");

		try {
				// 第三步:上传文件
				smart.upload();
				
				//接收其他文本数据
				String jsonDate=smart.getRequest().getParameter("json");//帖子数据
				jsonDate=URLDecoder.decode(jsonDate, "utf-8");
				//解析json 
				try { // 解析开始
					JSONArray arr = JSONArray.fromObject("[" + jsonDate + "]");
					for (int i = 0; i < arr.size(); i++) {
						JSONObject obj = arr.getJSONObject(i);
						placeid = obj.get("placeid") + "";//订单id
						fromName = obj.get("fromName") + "";//表单名称
						uniquelyid = obj.get("fieldname") + "";//组件名称
						attachmentNum= obj.getInt("attachmentNum") ;
					}
				} catch (Exception e) {
					json.put("success", true);
					json.put("resultCode", 500);
					json.put("msg", "json格式错误"+jsonDate);
					out.print(json);
					System.out.println(json);
					long ExeTime = Calendar.getInstance().getTimeInMillis()-TimeStart;// 记录执行日志
					Atm.AppuseLong2(UUID, USERID, DID, Mdels, NetMode, GPS, GPSLocal, "username", ip, claspath, classname, "json格式错误"+jsonDate, json.toString(), ExeTime);// 记录执行日志
					Atm.LogSys(AppKeyType, "用户APP端附件上传操作", "接单操作者"+USERID+"json 格式错误： {"+jsonDate+"}","1", USERID, ip);//添加操作日志
					Page.colseDOP(db, out, page);
					return;// 程序关闭
				}
				
System.out.println("订单id=="+placeid);
System.out.println("表单名称=="+fromName);
System.out.println("组件名称==="+uniquelyid);
System.out.println("上传附件文件地址===v1.haocheok.file.UpFile");
				/**
				 * 查询出原有的附件
				 */
				ResultSet rs=db.executeQuery("SELECT GROUP_CONCAT(attachmentid  SEPARATOR ',')AS attachmentid  FROM order_attachment WHERE orderid='"+placeid+"' AND  fromname='"+fromName+"' AND   fromid ='"+uniquelyid+"';");
				if(rs.next()){
					attachmentid=rs.getString("attachmentid");
				}if(rs!=null)rs.close();
				
				if(attachmentid==null){
					attachmentid="0";
				}
				Files fs = smart.getFiles();// 得到所有的文件
				int fsnum = fs.getCount();//文件个数
	
				if(attachmentNum!=fsnum){//上传中断
					json.put("success", true);
					json.put("resultCode", 500);
					json.put("msg", "网络异常,接收到的附件数量与json里的附件数量不匹配");
					out.print(json);
					long ExeTime = Calendar.getInstance().getTimeInMillis()-TimeStart;// 记录执行日志
					Atm.AppuseLong2(UUID, USERID, DID, Mdels, NetMode, GPS, GPSLocal, "username", ip, claspath, classname, "接收到的附件数量与json里的附件数量不匹配", json.toString(), ExeTime);// 记录执行日志
					Atm.LogSys(AppKeyType, "用户APP端附件上传操作", "接单操作者"+USERID+"附件上传失败： {网络异常,接收到的附件数量与json里的附件数量不匹配}","1", USERID, ip);//添加操作日志
					Page.colseDOP(db, out, page);
					return;// 程序关闭
				}
				
				for (int i = 0; i < fs.getCount(); i++) {// 对文件个数进行循环
					File f = fs.getFile(i);
					if (f.isMissing() == false) // 判断文件是否存在
					{
						attachmentName = USERID + "_" + System.currentTimeMillis()+ "_" + i + "." + f.getFileExt();
						f.saveAs(up_Path+"/"+attachmentName); // 写入文件
						
						int attachmenttype=0;
						if(f.getFileExt()=="jpg" || f.getFileExt()=="png" ||  f.getFileExt()=="jpeg" ||  f.getFileExt()=="pdf" ){
							attachmenttype=0;
						}else if(f.getFileExt()=="txt"){
							attachmenttype=1;
						}else if(f.getFileExt()=="mp4"){
							attachmenttype=2;
						}
						
						up_list.add(up_Path+"/"+attachmentName);
						//循环生成  插入附件表语句
						list_img.add("( '"+placeid+"', '"+fromName+"', '"+uniquelyid+"', '"+attachmenttype+"', '"+SetupConf.get("img_URL")+ny+"/"+attachmentName+"', '"+attachmentName+"', NOW(), '"+USERID+"', NOW(), '"+USERID+"')");
					}
				}
		}catch(Exception e) {
			e.printStackTrace();// 报错信息
			json.put("success", true);
			json.put("resultCode", 500);
			json.put("msg", "附件上传出错");
			out.print(json);
			long ExeTime = Calendar.getInstance().getTimeInMillis()-TimeStart;// 记录执行日志
			Atm.AppuseLong2(UUID, USERID, DID, Mdels, NetMode, GPS, GPSLocal, "username", ip, claspath, classname, "附件上传出错", json.toString(), ExeTime);// 记录执行日志
			Atm.LogSys(AppKeyType, "用户APP端附件上传操作", "接单操作者"+USERID+"附件上传失败： {"+e+"}","1", USERID, ip);//添加操作日志
			Page.colseDOP(db, out, page);
			return;// 程序关闭
		}
			
		/**
		 * 将图片地址插入附件表
		 */
		
		upsql="INSERT INTO order_attachment " +
						"( orderid, fromname, fromid, attachmenttype, attachmentpath, attachmentname, createtime, createid, updatetime, updateid)" +
					 " VALUES "+
					 list_img.toString().replaceAll("\\[","").replaceAll("\\]","").replaceAll("\\\n","").replaceAll("\\\t","").replaceAll("\\\r","").replaceAll(" ","")+";";
		up_state=db.executeUpdate(upsql);
			
		if(up_state){//保存到附件表成功
			
			//查询jsontemplate是否存在
			String jsontemplate_sql="SELECT GROUP_CONCAT(jsontemplate) AS str FROM "+fromName+" WHERE  orderid='"+placeid+"';";
			String jsontemplate_str=db.executeQuery_str(jsontemplate_sql);
			
			if(jsontemplate_str.length()<1){//第一次
				jsontemplate_sql="SELECT CONCAT('{',GROUP_CONCAT(CONCAT('\"',form_template_confg.strname,'\":','\"\"')),'}')as str  FROM form_template_confg  LEFT JOIN form_name ON form_template_confg.fid=form_name.id WHERE  form_name.datafrom='"+fromName+"';";
				jsontemplate_str=db.executeQuery_str(jsontemplate_sql);
			}
				
			//上传成功后查询本组图片
			String select_img="SELECT GROUP_CONCAT(CONCAT(attachmentpath,'?',attachmentid)SEPARATOR '#')AS str FROM order_attachment WHERE orderid='"+placeid+"' and fromName='"+fromName+"' and  fromid='"+uniquelyid+"';";
			img_lis=db.executeQuery_str(select_img);
			
			//解析替换json里的附件地址
			JSONObject obj_delect = new JSONObject();
			if(jsontemplate_str==null){jsontemplate_str="";}
			try { // 解析开始
				JSONArray arr = JSONArray.fromObject("[" + jsontemplate_str + "]");
				for (int i = 0; i < arr.size(); i++) {
					obj_delect = arr.getJSONObject(i);
					 //直接覆盖原有的值
					obj_delect.put(uniquelyid,img_lis);
				}
			}catch (Exception e) {
				json.put("success", "true");
				json.put("resultCode", "500");
				json.put("msg", "附件上传失败 _解析替换json里的附件地址");
				out.println(json);
				//删除刚刚上传的附件
				for(int l=0;l<up_list.size();l++){
					FileAc.doDeleteEmptyDir(up_list.get(l));
				}
				db.executeUpdate("DELETE FROM order_attachment  WHERE  orderid='"+placeid+"' AND  fromname='"+fromName+"' AND   fromid ='"+uniquelyid+"' AND attachmentid  NOT IN("+attachmentid+") ;");
				//记录日志
				long ExeTime = Calendar.getInstance().getTimeInMillis()-TimeStart;// 记录执行日志
				Atm.AppuseLong2(UUID, USERID, DID, Mdels, NetMode, GPS, GPSLocal, "username", ip, claspath, classname, "附件删除失败 _解析替换json里的附件地址", json.toString(), ExeTime);// 记录执行日志
				Atm.LogSys(AppKeyType, "用户APP端附件上传操作", "接单操作者"+USERID+"附件上传失败：解析替换json里的附件地址{"+jsontemplate+"}","1", USERID, ip);//添加操作日志
				Page.colseDOP(db, out, page);
				return;// 程序关闭;
			}	
			/**
			 * 更新角色表数据
			 */
			int order_stat=db.Row("select count(1)as row from "+fromName+" where orderid = '"+placeid+"' ");
			if(order_stat==0){//第一次上传传
				up_str="INSERT INTO "+fromName+"  ( orderid, "+uniquelyid+", createtime, createid, updatetime, updateid, jsontemplate)VALUES( '"+placeid+"', '"+img_lis+"', now(), '"+USERID+"', now(), '"+USERID+"', '"+obj_delect+"');;";
			}else{
				up_str="UPDATE "+fromName+"  SET  "+uniquelyid+" = '"+img_lis+"' ,jsontemplate ='"+obj_delect+"' WHERE orderid = '"+placeid+"' ;";
			}

			up_stat=db.executeUpdate(up_str);
			if(up_stat){
				json.put("success", "true");
				json.put("resultCode", "1000");
				json.put("msg", "附件上传成功");
				json.put("attachment",img_lis);
			}else{
				json.put("success", "true");
				json.put("resultCode", "500");
				json.put("msg", "附件上传失败 _更新角色表数据");
				out.println(json);
				
				//删除刚刚上传的附件
				for(int l=0;l<up_list.size();l++){
					FileAc.doDeleteEmptyDir(up_list.get(l));
				}
				db.executeUpdate("DELETE FROM order_attachment  WHERE  orderid='"+placeid+"' AND  fromname='"+fromName+"' AND   fromid ='"+uniquelyid+"' AND attachmentid  NOT IN("+attachmentid+") ;");
				//记录日志
				long ExeTime = Calendar.getInstance().getTimeInMillis()-TimeStart;// 记录执行日志
				Atm.AppuseLong2(UUID, USERID, DID, Mdels, NetMode, GPS, GPSLocal, "username", ip, claspath, classname, "附件删除失败 _更新角色表数据", json.toString(), ExeTime);// 记录执行日志
				Atm.LogSys(AppKeyType, "用户APP端附件上传操作", "接单操作者"+USERID+"附件上传失败：更新角色表数据{"+up_str+"}","1", USERID, ip);//添加操作日志
				Page.colseDOP(db, out, page);
				return;// 程序关闭;
			}
			
		}else{
			json.put("success", true);
			json.put("resultCode", 500);
			json.put("msg", "附件上传出错");
			out.print(json);
			long ExeTime = Calendar.getInstance().getTimeInMillis()-TimeStart;// 记录执行日志
			Atm.AppuseLong2(UUID, USERID, DID, Mdels, NetMode, GPS, GPSLocal, "username", ip, claspath, classname, "附件上传出错", json.toString(), ExeTime);// 记录执行日志
			Atm.LogSys(AppKeyType, "用户APP端附件上传操作", "接单操作者"+USERID+"附件上传失败： 更新语句 {"+upsql+"}","1", USERID, ip);//添加操作日志
			Page.colseDOP(db, out, page);
			return;// 程序关闭
		}
		
		//返回数据
		out.println(json);
		// 记录执行日志
		long ExeTime = Calendar.getInstance().getTimeInMillis()-TimeStart;
		// 记录执行日志
		Atm.AppuseLong2(UUID, USERID, DID, Mdels, NetMode, GPS, GPSLocal, "username", ip, claspath, classname, "请求的json", json.toString(), ExeTime);
		//添加操作日志
		Atm.LogSys(AppKeyType, "用户APP端附件上传操作", "接单操作者"+USERID+"附件上传成功","0", USERID, ip);
		//关闭数据库资源
		Page.colseDOP(db, out, page);
		return;// 程序关闭
	}


}
