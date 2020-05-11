package v1.haocheok.list.controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.ResultSet;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import service.dao.db.Jdbc;
import service.dao.db.Page;
import service.sys.Atm;
import service.sys.ErrMsg;
import v1.haocheok.commom.common;
import v1.haocheok.commom.entity.InfoEntity;

public class AppAppointList {
	public void getAppointList(HttpServletRequest request, HttpServletResponse response,String RequestJson,InfoEntity info) throws ServletException, IOException {

		Jdbc db = new Jdbc();
		Page page = new Page();

		
        String claspath=this.getClass().getName();//当前类名
		response.setContentType("text/html;charset=UTF-8");
		request.setCharacterEncoding("UTF-8");
		response.setCharacterEncoding("UTF-8");
    	PrintWriter out = response.getWriter();
	    	
    	
		//定义接收变量值
		String responsejson="";
		String classname="APP预约时间列表";
		String username=common.getusernameTouid(info.getUSERID());
		JSONObject json = new JSONObject();
	    ArrayList list = new ArrayList();
	    String orderid = "";
		  
		//数据接收
		try {
			JSONArray arr = JSONArray.fromObject("[" + RequestJson + "]");
			for (int i = 0; i < arr.size(); i++) {
			   JSONObject obj = arr.getJSONObject(i);
			   orderid = obj.get("placeid") + "";
			}
		} catch (Exception e) {
			ErrMsg.falseErrMsg(request, response, "500", "json格式解析异常");
			return;
		}
		
		System.out.println("RequestJson=="+RequestJson);

			    
		//token 认证过滤
	    System.out.println("token 认证过滤==="+"SELECT COUNT(*) as row FROM  user_worker WHERE uid ='"+info.getUSERID()+"' AND app_token='"+ info.getToken() + "'");
		int TokenTag=db.Row("SELECT COUNT(*) as row FROM  user_worker WHERE uid ='"+info.getUSERID()+"' AND app_token='"+ info.getToken() + "'");
		if(TokenTag!=1){
			ErrMsg.falseErrMsg(request, response, "403", "请登录！");
			Page.colseDOP(db, out, page);
			return;//跳出程序只行 
		}  
		
		/****************************************实现业务开始*****************************************************/
		
		try {
			JSONObject json_appoint = new JSONObject();
		    ArrayList list_appoint = new ArrayList();
			//预约时间列表：
			String sql_appoint = "select appointmenttime,common from homevisits_time where orderid = '"+orderid+"' and userid = '"+info.getUSERID()+"' order by createtime asc" ;
			ResultSet appointPrSet = db.executeQuery(sql_appoint);
			int i = 1;
			while(appointPrSet.next()){
				
				Date date = appointPrSet.getDate("appointmenttime");
				SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm"); 
				sdf.format(date);
				list_appoint.add("第"+i+"次预约 :  "+sdf.format(appointPrSet.getTimestamp("appointmenttime"))+"  "+appointPrSet.getString("common"));
				i++;
			
			}if(appointPrSet!=null){appointPrSet.close();}
			
			JSONObject json_button = new JSONObject();
		    ArrayList list_button = new ArrayList();
			
		    json_button.put("buttonname", "立即预约");
		    json_button.put("buttoncode", "appointment");
		    json_button.put("api", "app/do/appointment");
		    json_button.put("httptype", "post");
		    json_button.put("type", "5");
		    json_button.put("buttonstatus", "1");
		    list_button.add(json_button.toString());
		   
			json.put("success", "true");
			json.put("resultCode", "1000");
			json.put("msg", "获取预约时间列表成功");
			json.put("infotime", list_appoint);
			json.put("button", list_button.toString());
			
			
			responsejson = json.toString();
			
			// 记录执行日志
			long ExeTime = Calendar.getInstance().getTimeInMillis()-info.getTimeStart();
			Atm.AppuseLong(info, username,  this.getClass().getName(), classname, responsejson, ExeTime);
			//添加操作日志
			Atm.LogSys("获取预约时间列表", "用户APP端成功", "用户"+username+"获取预约时间列表", "0",info.getUSERID(), info.getIp());
			
		}catch (Exception e) {
			
			
			int ErrLineNumber = e.getStackTrace()[0].getLineNumber();
			json.put("success", "true");
			json.put("resultCode", "500");
			json.put("msg", "服务器开小差了");
			// 记录执行日志
			long ExeTime = Calendar.getInstance().getTimeInMillis()-info.getTimeStart();
			Atm.AppuseLong(info, username,  this.getClass().getName(), classname, responsejson, ExeTime);
			//添加操作日志
			Atm.LogSys("系统错误", classname+"模块系统出错", "错误信息详见 "+this.getClass().getName()+"第"+ErrLineNumber+"行","1", info.getUSERID(), info.getIp());
			out.println(responsejson);
			Page.colseDP(db, page);
			out.flush();
			out.close();
			return;
			
			
		}
		responsejson = json.toString();
		//返回信息
		out.println(responsejson);
		System.out.println(responsejson);
		//记录日志
		page.colseDP(db, page);
		out.flush();
		out.close();
	}
}
