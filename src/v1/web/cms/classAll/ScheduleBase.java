package v1.web.cms.classAll;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
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
import v1.haocheok.commom.common;
import v1.haocheok.commom.commonCourse;
import v1.haocheok.commom.entity.InfoEntity;

public class ScheduleBase {

	
	/**
	 * 是否打印
	 * @param request
	 * @param response
	 * @param RequestJson
	 * @param info
	 * @param theClassName
	 * @throws ServletException
	 * @throws IOException
	 */
	public void print(HttpServletRequest request, HttpServletResponse response,String RequestJson,InfoEntity info,String theClassName) throws ServletException, IOException {
		Jdbc db = new Jdbc();
	    Page page = new Page();
       
        response.setContentType("text/html;charset=UTF-8");
		request.setCharacterEncoding("UTF-8");
		response.setCharacterEncoding("UTF-8");
		PrintWriter out = response.getWriter();

	    String classname="获取课表信息按照教师查询";
        String claspath=this.getClass().getName();
        String responsejson=""; //返回客户端数据 
        JSONObject json = new JSONObject();
    //定义json接受字段列表        
         
        
	   
	   common common = new common();
	   
	   String semester = "";			//学期号
	   try { // 解析开始
		   JSONArray arr = JSONArray.fromObject("[" + RequestJson + "]");
		   for (int i = 0; i < arr.size(); i++) {
			   JSONObject obj = arr.getJSONObject(i);
			    //定义json解析字段列表		
			   semester = obj.getString("semester");
			   		
		    }
	    } catch (Exception e) {
	    	ErrMsg.falseErrMsg(request, response, "500", "json格式解析异常");
	     return;
	    }
		
		  //判断过滤非法字符: 
		if(!page.regex(info.getUUID())){ 
			ErrMsg.falseErrMsg(request, response,"403", "数据格式不匹配");
			if (db != null) { db.close(); db = null; }
			if (page != null) {page = null;}
			out.flush();
			out.close();
			return;//跳出程序只行 
		}    
		    

        //token 认证过滤-如果不需要本接口请求授权，可以删掉本代码
	 	int TokenTag=db.Row("SELECT COUNT(*) as row FROM  user_worker WHERE uid ='"+info.getUSERID()+"' AND (app_token='"+info.getToken()+"' OR pc_token='"+info.getToken()+"')");
		if(TokenTag!=1){
			  
				ErrMsg.falseErrMsg(request, response, "403", "未授权请求！请登录。");
			    if (db != null) { db.close(); db = null; }
			    if (page != null) {page = null;}
			    out.flush();
			    out.close();
			   return;//跳出程序只行 
		}
		
		
		
		
		try {
			
			String sql = "select print_state1 from arrage_course where school_number = '"+semester+"'";
			ResultSet set = db.executeQuery(sql);
			String print = "";
			while(set.next()){
				print = set.getString("print_state1");
			}if(set!=null){set.close();}
			
			
			
			json.put("success", true);
			json.put("resultCode", "1000");
			json.put("msg", "请求成功");
			json.put("data",print);
			
			responsejson = json.toString();
			out.print(responsejson);
				 
			//记录日志
			long ExeTime = Calendar.getInstance().getTimeInMillis()-info.getTimeStart();
			String InsertSQLlog = "INSERT INTO  ec_appuse_log (`uuid`,`Mdels`,`NetMode`,`GPS`,`GPSLocal`,`username`,`did`,`uid`,`ExeTime`,`classpath`,`classname`,`ip`,`logintime`,`requestjson`,`responsejson`) VALUES ('"+info.getUUID()+"','"+info.getMdels()+"','"	+info.getNetMode()+"','"+info.getGPS()+"','"+info.getGPSLocal()+"','"	+info.getUSERID()+"','"+info.getDID()+"','"+info.getUSERID()+"','"+ExeTime+"','"+claspath+"','"+classname+"','"+info.getIp()+"',now(),'','');";
			db.executeUpdate(InsertSQLlog);
			// 记录日志end     
			Atm.LogSys("打印是否可用", "打印是否可用", "打印是否可用,操作人:"+common.getusernameTouid(info.getUSERID())+"", "0", info.getUSERID(), info.getIp());
			
			
		} catch (SQLException e) {
			int ErrLineNumber = e.getStackTrace()[0].getLineNumber();
			Atm.LogSys("系统错误", theClassName + "模块系统出错", "错误信息详见 " + claspath + ",第" + ErrLineNumber + "行。", "1", info.getUSERID(), info.getIp());
			Page.colseDP(db, page);
		}
		
		//关闭数据与serlvet.out
		if (db != null) { db.close(); db = null; }
		if (page != null) {page = null;}
				
		out.flush();
		out.close();
	}
	
	
}
