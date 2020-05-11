package service.sys;

import java.io.IOException;

import javax.servlet.ServletException;

import service.dao.db.Jdbc;
import service.dao.db.Page;

/**
 * @author LiGaoSong E-mail: 9332246@qq.com
 * @version 创建时间：2016-8-4 下午11:09:14  
 * @记录日志模块
 * @用法Loadd(USERID,username,uid,ip,claspath,clasname)
 * 
 */
public class AppuseLog {

	/**
	 * @创建手机用户操作模块日志方法
	 * @param UUID
	 * @param DID 设备id   
	 * @param username  用户名
	 * @param USERID 用户id
	 * @param classpath 执行模块path
	 * @param classname 模块名
	 * @param ip ip地址
	 * @param RequestJson 请求数据
	 * @param responsejson 响应数据
	 * @//Token, UUID, USERID,DID, Mdels, NetMode, ChannelId, RequestJson,ip, GPS,GPSLocal
	 */
	
	public void LogAdd(
						String UUID, String USERID,String DID,String Mdels,String NetMode, String GPS, String GPSLocal,String username, String ip,
						String claspath, String classname, String RequestJson,String responsejson,long ExeTime
					  ) throws ServletException, IOException {

		Jdbc db = new Jdbc();
		Page page = new Page();
        
		if(GPSLocal==null){GPSLocal="";}
		if(GPS==null)
		{
			GPS="";
		}else{
			GPS=GPS.replaceAll("％", "\\\\%");
		}
		
	    GPSLocal=java.net.URLDecoder.decode(GPSLocal,"utf-8");
		if(DID==null || "".equals(DID)){
			DID = "0";
		} 
		// 记录登陆成功日志  
		String InsertSQLlog = "INSERT INTO  ec_appuse_log (`uuid`,`Mdels`,`NetMode`,`GPS`,`GPSLocal`,`username`,`did`,`uid`,`ExeTime`,`classpath`,`classname`,`ip`,`logintime`,`requestjson`,`responsejson`) VALUES ('"
			    + UUID
			    + "','"	
			    + Mdels
			    + "','"	
			    + NetMode
			    + "','"
			    + GPS
			    + "','"	
			    + GPSLocal
			    + "','"	
			    + username
				+ "',"
				+ DID
				+ ",'"
				+ USERID
				+ "','"
				+ (int)ExeTime
				+ "','"
				+ claspath
				+ "','"
				+ classname
				+ "','"
				+ ip
				+ "','"
				+ page.getTimeA()
				+ "','" + RequestJson + "','" + responsejson + "');";
		
		 
		db.executeUpdate(InsertSQLlog);// 记录日志end
		

		if (db != null) { db.close(); db = null; }
		if (page != null) { page = null; }

	}

}
