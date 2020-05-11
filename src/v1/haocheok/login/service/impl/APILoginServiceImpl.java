package v1.haocheok.login.service.impl;

import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.Calendar;

import net.sf.json.JSONObject;
import service.dao.db.Jdbc;
import service.dao.db.Md5;
import service.dao.db.Page;

import service.sys.Atm;
import v1.haocheok.commom.entity.InfoEntity;
import v1.haocheok.login.service.APILoginService;

/**
 * 
 * @author Administrator
 * app端登陆实现类
 */
public class APILoginServiceImpl implements APILoginService {

	@Override
	public String loginVerification(String mobile,String password ,InfoEntity info,String claspath){
		
		Jdbc db = new Jdbc();
		Page page = new Page();
		Md5 md5ac = new Md5();
		
	    String username="";
	    String app_token="";
	    String nickname="";
	    String headimgurl="";
	    String regionalcode = "";
	    String USERID = "";
	   
	    String responsejson="";
	    String classname="APP登录模块";
	    JSONObject json = new JSONObject();
	    ArrayList<Object> list = new ArrayList<Object>();
		
	    try {
				String base_sql = "usermob ='"+mobile+"'"; //用户手机号登陆
				if(!page.regex_num(mobile)){base_sql = "username ='"+mobile+"'";}//用户名登陆
				//用户登录名与密码是否正确
				int LoginTag=db.Row("SELECT COUNT(*) as row FROM  user_worker WHERE "+base_sql+" AND password='"+ password + "'");
				if(LoginTag==0){
					responsejson = "{\"success\":true,\"resultCode\":\"403\",\"msg\":\"用户名密码不正确\"}";
					// 记录执行日志
					long ExeTime = Calendar.getInstance().getTimeInMillis()-info.getTimeStart();
					Atm.AppuseLong(info, username,  claspath, classname, responsejson, ExeTime);
					//添加操作日志
					Atm.LogSys("登陆", "用户APP端登录失败", "用户:"+mobile+" 通过验证app登录失败用户密码错误", "0",info.getUSERID(), info.getIp());
		    	    if (db != null) { db.close(); 	db = null; }
					if (page != null) {page = null;}
				   return responsejson;//跳出程序只行    
			}
			String LoginsqlString = "SELECT *  FROM  user_worker WHERE  "+base_sql+" AND password='"+ password + "' limit 1; ";
		    ResultSet LoginRs = db.executeQuery(LoginsqlString);
 
			if (LoginRs.next()) {
				USERID=LoginRs.getString("uid");
				username = LoginRs.getString("username");
				nickname = LoginRs.getString("nickname");
				headimgurl = LoginRs.getString("headimgurl");
				regionalcode = LoginRs.getString("regionalcode");
				 
			}
			if (LoginRs != null) {
				LoginRs.close();
			}
			//判断是否是手机端角色
			int rolenum = db.Row("select count(1) as row from zk_user_role,zk_role where  zk_user_role.sys_user_id='"+USERID+"' and zk_role.id=zk_user_role.sys_role_id and type!=0");
			if(rolenum==0){
				   // 记录执行日志
					long ExeTime = Calendar.getInstance().getTimeInMillis()-info.getTimeStart();
					Atm.AppuseLong(info, username,  claspath, classname, responsejson, ExeTime);
					//添加操作日志
					Atm.LogSys("登陆", "用户APP端登录失败", "用户:"+mobile+" 手机端没有对应角色", "1",info.getUSERID(), info.getIp());
					Page.colseDP(db, page);
					return Page.returnjson("403", "手机端没有相关角色，与管理员联系");//跳出程序只行 
			}
			
			 
			//1.用户角色信息
			JSONObject json1= new JSONObject();
			if(USERID.length()>0){ 
				app_token= md5ac.md5(USERID+mobile+"app随机时间"+Calendar.getInstance().getTimeInMillis());
				//更新用户token,ip 与其他信息 
				db.executeUpdate(" UPDATE  user_worker SET `app_token`='"+app_token+"',`ip`='"+info.getIp()+"' WHERE usermob='" + mobile + "'");
				db.executeUpdate(" UPDATE  user_device SET `app_token`='"+app_token+"',`uid`='"+info.getUSERID()+"' ,`ip`='"+info.getIp()+"',`mdels`='"+info.getMdels()+"',`netmode`='"+info.getNetMode()+"' ,`channelid`='"+info.getChannelId()+"',`gps`='"+info.getGPS()+"',`gpslocal`='"+info.getGPSLocal()+"',uptime=now() WHERE uuid='" + info.getUUID() + "'");
				json.put("success", "true");
				json.put("resultCode", "1000");
				json.put("msg", "用户登陆成功");
				json.put("Token",""+app_token);
				json.put("USERID", ""+USERID);
				json.put("username", ""+username);
				json.put("nickname", ""+nickname);
				json.put("headimgurl", ""+headimgurl);
				json.put("regionalcode", regionalcode);
				json.put("regionalname", "总部好车帮");
				
				//2.用户角色信息
				String sql_roleString = "select rolecode,name,zk_role.id as roleid,homepage from zk_user_role,zk_role where zk_user_role.sys_user_id='"+USERID+"' and zk_user_role.sys_role_id = zk_role.id and zk_role.type!=0";
				ResultSet rolePrs = db.executeQuery(sql_roleString);
				String rolecode = "",roleid = ""; 
				if(rolePrs.next()){
					rolecode = rolePrs.getString("rolecode");
					roleid = rolePrs.getString("roleid");
					json1.put("name", rolePrs.getString("name"));
					json1.put("rolecode", rolecode);
					json.put("homepage", rolePrs.getString("homepage"));
//					list.add(json1);
				}if(rolePrs!=null){rolePrs.close();}
				
				//放入到json对象中
				json.put("role", json1.toString());
				
				//返回值
				responsejson=json.toString();
				
				
				// 记录执行日志
				long ExeTime = Calendar.getInstance().getTimeInMillis()-info.getTimeStart();
				// 记录执行日志
				Atm.AppuseLong(info, username,  claspath, classname, responsejson, ExeTime);
				//添加操作日志
				Atm.LogSys("登陆", "用户APP端登录", "用户:"+mobile+" 通过验证app登录成功", "0",USERID, info.getIp());
				
			}else {
				//responsejson =  "{\"success\":true,\"resultCode\":\"403\",\"msg\":\"登陆出错，用户名或者密码不对\",\"username\":\"\",\"Token\":\"\"}";
				responsejson =  Page.returnjson("403","登陆出错，用户名或者密码不对");
			}
			
		} catch (Exception e) {
		    int ErrLineNumber = e.getStackTrace()[0].getLineNumber();
		    //final String ltype, final String title,final String body,final String uid,final String ip
		    Atm.LogSys("系统错误", classname+"模块系统出错", "错误信息详见 "+claspath+",第"+ErrLineNumber+"行。", "1",info.getUSERID(), info.getIp());
		    Page.colseDP(db, page);
		    return Page.returnjson("500","服务器开小差啦-"+ErrLineNumber);
		}
		Page.colseDP(db, page);
		return responsejson;
		
	}
	
	
}
