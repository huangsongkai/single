package service.sys;

import java.io.IOException;

import javax.servlet.ServletException;

import service.dao.db.Jdbc;

/**
 * @author LiGaoSong E-mail: 9332246@qq.com
 * @version 创建时间：2016-8-4 下午11:09:14  
 * @记录日志模块
 * @用法Loadd(USERID,username,uid,ip,claspath,clasname)
 * 
 */
public class LogSys {

	/**
	 * 记录系统日志 
	 * @param 日志类型
	 * @param 日志标题
	 * @param 日志内容
	 * @param uid
	 * @param ip
	 * @param addtime
	 * @throws ServletException
	 * @throws IOException
	 * 
	 */
	public void logSys(String ltype, String title,String body,String status,String uid,String ip) throws ServletException, IOException {

		Jdbc db = new Jdbc();
		 
		// 记录系统日志  
	    //添加日志
	    //String logsql=" INSERT INTO `log_sys`(`ltype`,`title`,`body`,`uid`,`ip`,`addtime`) VALUES ('登录','用户APP端登录','用户:"+username+" 通过验证app登录成功','"+USERID+"','"+ip+"',now());;";
		String logsql="INSERT INTO log_sys  (ltype,title,body,uid,ip,status,ADDTIME) VALUES ('"+ltype+"','"+title+"',\""+body+"\",'"+uid+"','"+ip+"','"+status+"',now());";
		//System.out.println(logsql);
	    db.executeUpdate(logsql);

		if (db != null) { db.close(); db = null; }

	}

}
