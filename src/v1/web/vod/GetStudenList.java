package v1.web.vod;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Calendar;

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
 *@category 通过班级号获取该班级所有学生
 *@author ligaosong
 *
 */

public class GetStudenList {

	public void getUserList(HttpServletRequest request, HttpServletResponse response,InfoEntity info,String Token,String UUID,String USERID,String DID,String Mdels,String NetMode,String ChannelId,String RequestJson,String ip,String GPS,String GPSLocal,String AppKeyType,long TimeStart,String theClassName) throws ServletException, IOException {
		
		Jdbc db = new Jdbc();
		Page page = new Page();

	    String classname="app  用户修改密码";
        String claspath=this.getClass().getName();
        
		response.setContentType("text/html;charset=UTF-8");
		request.setCharacterEncoding("UTF-8");
		response.setCharacterEncoding("UTF-8");
		
		String journal="";//日志记录内容
		
		PrintWriter out = response.getWriter();
    	JSONObject json = new JSONObject();

	    
		//声明变量；
	    String classroomid = "";//教室id
	   
	    
	    
	    try { // 解析开始
			JSONArray arr = JSONArray.fromObject("[" + RequestJson + "]");
			for (int i = 0; i < arr.size(); i++) {
				JSONObject obj = arr.getJSONObject(i);
				classroomid = obj.get("classroomid") + "";     //教室id
			 }
		} catch (Exception e) {
			  ErrMsg.falseErrMsg(request, response, "500", "json格式解析异常");
			  Page.colseDOP(db, out, page);
			  return;
		}
		
	 
		  //判断过滤非法字符: 
	     if( !page.regex(classroomid) ){ 
	           ErrMsg.falseErrMsg(request, response, "403", "班级id数据格式不对");
			    if (db != null) { db.close(); db = null; }
			    if (page != null) {page = null;}
			    out.flush();
			    out.close();
			   return;//跳出程序只行 
	    }    
	     
	 	// token 认证过滤
			String authSql="SELECT COUNT(*) as row FROM  user_worker WHERE uid ='"+ info.getUSERID() + "' AND (pc_token='" + info.getToken()+ "' or app_token='" + info.getToken()+ "')";
	        //System.out.println("authSql="+authSql);
			int TokenTag = db.Row(authSql);
			if (TokenTag != 1) {
				ErrMsg.falseErrMsg(request, response, "403", "资源被拒绝访问，请登录！");
				Page.colseDOP(db, out, page);
				return;// 跳出程序只行
			}
		
		
		int RegTag=0;
		
		String stuNo = ""; //学生编号
		String stuName="";//学生
	 
 
		 

    String responsejson="";
		try {
		 
			ResultSet user_rs = db.executeQuery("SELECT  stuname,student_number  FROM  student_basic  WHERE classroomid='"+classroomid+"'; ");
			while (user_rs.next()) {
				RegTag = RegTag + 1;
				stuNo = user_rs.getString("student_number");
				stuName = user_rs.getString("stuname");
				responsejson=responsejson+stuNo+"#"+stuName+"\r\n";
				
		}
			if (user_rs != null) {user_rs.close();}
			
			if(RegTag>0){ //如果得到学生编号
				
			 
				
				out.print(responsejson);
				
				
				
		//----------------------------------------		
			}else{ //登录失败
			  	out.print("没有找到!");
		 	}
			
			
			
		} catch (Exception e) {
			out.print(" SQL错误见模块:"	+ this.getClass() + "");
		}
		// 查询用户设备id号end
		
		  
		// 记录执行日志
			long ExeTime = Calendar.getInstance().getTimeInMillis()-info.getTimeStart();
			Atm.AppuseLong(info, info.getUSERID(),this.getClass().getName(),theClassName, responsejson, ExeTime);
			Page.colseDOP(db, out, page);
		 
			
			
		 
	 
		if (db != null) {	db.close(); 	db = null;}
		out.flush();
		out.close();
	}
}
