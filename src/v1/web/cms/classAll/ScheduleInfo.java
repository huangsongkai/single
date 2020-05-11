package v1.web.cms.classAll;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang3.StringUtils;
import org.apache.poi.hssf.record.DBCellRecord;

//import com.sun.xml.internal.bind.v2.runtime.unmarshaller.XsiNilLoader.Array;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import service.dao.db.Jdbc;
import service.dao.db.Page;
import service.sys.Atm;
import service.sys.ErrMsg;
import v1.haocheok.commom.common;
import v1.haocheok.commom.commonCourse;
import v1.haocheok.commom.entity.InfoEntity;

/**
 * 获取课表信息
 * @company 010jiage
 * @author zhoukai04171019
 * @date:2018-4-12 下午08:44:22
 */
public class ScheduleInfo {
	/**
	 * 按照班级查询
	 * @param request
	 * @param response
	 * @param RequestJson
	 * @param info
	 * @throws ServletException
	 * @throws IOException
	 */
	public void getScheduleInfo(HttpServletRequest request, HttpServletResponse response,String RequestJson,InfoEntity info,String theClassName) throws ServletException, IOException {
		
		    Jdbc db = new Jdbc();
		    Page page = new Page();
	       
	        response.setContentType("text/html;charset=UTF-8");
			request.setCharacterEncoding("UTF-8");
			response.setCharacterEncoding("UTF-8");
			PrintWriter out = response.getWriter();
	
		    String classname="获取课表信息";
	        String claspath=this.getClass().getName();
	        String responsejson=""; //返回客户端数据 
	        JSONObject json = new JSONObject();
	    //定义json接受字段列表        
	         
	        
	       JSONObject jsonbase = new JSONObject();
	       JSONObject jsonbase1 = new JSONObject();
		   ArrayList list = new ArrayList();
		   ArrayList list1 = new ArrayList();
		   
		   String xueqi = "";
		   String classid = "";
		   String zhouci = "";
		   String kebiaotype = "";//1 有课表  0 无课表
		   
		   commonCourse commonCourse = new commonCourse();
		   common common = new common();
		   
		   try { // 解析开始
			   JSONArray arr = JSONArray.fromObject("[" + RequestJson + "]");
			   for (int i = 0; i < arr.size(); i++) {
				   JSONObject obj = arr.getJSONObject(i);
				    //定义json解析字段列表		
				   xueqi = obj.getString("xueqi");
				   classid = obj.getString("classid");
				   zhouci = obj.getString("zhouci");
				   if(!obj.containsKey("kebiaotype")){
					   	kebiaotype="1";
				   }else{
					   kebiaotype = obj.getString("kebiaotype");
				   }
				   		
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
		  String strleft = "";
		  String strwhere = "";
			  
		  if(!"0".equals(zhouci)){
			  strleft = " 	LEFT JOIN arrage_details_weekly ON arrage_details_weekly.arrage_details_id = arrage_details.id		";
			  strwhere = "			AND arrage_details_weekly.weekly = '"+zhouci+"'			";
		  }
		  
		String select_sqlString = "select																				"+
					"				arrage_coursesystem.id, arrage_coursesystem.timetablestate,                                              "+
					"				  dict_courses.course_name as course_name,                                          "+
					"				  dict_courses.course_code as course_code,                                          "+
					"				  ifnull(marge_class.marge_name,class_grade.class_name) as class_name,	"+
					"				  teacher_name,                                                                     "+
					"				  class_begins_weeks,                                                               "+
					"				arrage_coursesystem.teacher_id as teacher_id,										"+
					"				arrage_details.classroomid as classroomid,										"+
					"				   ifnull(classroom.classroomname,'') classroomname,                                                         "+
					"				   arrage_details.timetable as timetable,                                            "+
					"				ifnull(arrage_details.classtime,'') as classtime,												"+
					"					IFNULL(marge_class.class_grade_number,people_number_nan+people_number_woman)  AS totle	"+
					"				from arrage_coursesystem                                                            "+
					"				  left JOIN arrage_details                                                          "+
					"				    on arrage_coursesystem.id = arrage_details.arrage_coursesystem_id               "+
					"				  left JOIN dict_courses                                                            "+
					"				    on arrage_coursesystem.course_id = dict_courses.id                              "+
					"				  left JOIN teacher_basic                                                           "+
					"				    on arrage_coursesystem.teacher_id = teacher_basic.id                            "+
					"				    left JOIN classroom on arrage_details.classroomid = classroom.id                "+
					"					LEFT JOIN class_grade ON arrage_coursesystem.class_id = class_grade.id			"+
					"					LEFT JOIN marge_class ON arrage_coursesystem.marge_class_id = marge_class.id	"+
					strleft+
					"				where arrage_coursesystem.semester = '"+xueqi+"'                                  "+
					"				    and arrage_coursesystem.class_id = '"+classid +"'" +strwhere+" ;     " ;
		//"				    and arrage_coursesystem.class_id = '"+classid+"'   AND timetablestate = 1     "+strwhere+" ;     " ;
		
		System.out.println("sqlsqlsqlsqlsql==="+select_sqlString);
		ResultSet rest = db.executeQuery(select_sqlString);
		while(rest.next()){
			if(rest.getString("timetablestate").equals("1")){
				
				jsonbase.put("arrage_coursesid",rest.getString("id") );
				jsonbase.put("course_name", rest.getString("course_name"));
				jsonbase.put("course_code", rest.getString("course_code"));
				jsonbase.put("teacher_name", rest.getString("teacher_name"));
				jsonbase.put("class_begins_weeks", rest.getString("class_begins_weeks"));
				jsonbase.put("classroomname", rest.getString("classroomname"));
				jsonbase.put("classroomid", rest.getString("classroomid"));
				jsonbase.put("classname", rest.getString("class_name"));
				jsonbase.put("teacherid", rest.getString("teacher_id"));
				jsonbase.put("classtime", rest.getString("classtime"));
				jsonbase.put("totle", rest.getString("totle"));
				if(!"".equals(rest.getString("timetable"))){
					ArrayList<ArrayList<String>> timeList = commonCourse.toArrayList(rest.getString("timetable"),"*","#");
					jsonbase.put("timetable", timeList.toString());
				}else{
					jsonbase.put("timetable", rest.getString("timetable"));
				}
				list.add(jsonbase.toString());
			}else{
				
				jsonbase1.put("arrage_coursesid",rest.getString("id") );
				jsonbase1.put("course_name", rest.getString("course_name"));
				jsonbase1.put("course_code", rest.getString("course_code"));
				jsonbase1.put("teacher_name", rest.getString("teacher_name"));
				jsonbase1.put("class_begins_weeks", rest.getString("class_begins_weeks"));
				jsonbase1.put("classroomname", rest.getString("classroomname"));
				jsonbase1.put("timetable", rest.getString("timetable"));
				jsonbase1.put("classname", rest.getString("class_name"));
				jsonbase1.put("totle", rest.getString("totle"));
				jsonbase1.put("classtime", rest.getString("classtime"));
				jsonbase1.put("classroomid", rest.getString("classroomid"));
				jsonbase1.put("teacherid", rest.getString("teacher_id"));
				list1.add(jsonbase1.toString());
			}
			
		}if(rest!=null){rest.close();}
					
		//生成json信息
		json.put("success", true);
		json.put("resultCode", "1000");
		json.put("msg", "请求成功");
		json.put("data", list.toString());
		if(kebiaotype.equals("1")){
			json.put("linedata", list.toString());
		}else{
			json.put("linedata", list1.toString());
		}
		
		responsejson = json.toString();
		out.print(responsejson);
			 
	    //记录日志
		long ExeTime = Calendar.getInstance().getTimeInMillis()-info.getTimeStart();
		String InsertSQLlog = "INSERT INTO  ec_appuse_log (`uuid`,`Mdels`,`NetMode`,`GPS`,`GPSLocal`,`username`,`did`,`uid`,`ExeTime`,`classpath`,`classname`,`ip`,`logintime`,`requestjson`,`responsejson`) VALUES ('"+info.getUUID()+"','"+info.getMdels()+"','"	+info.getNetMode()+"','"+info.getGPS()+"','"+info.getGPSLocal()+"','"	+info.getUSERID()+"','"+info.getDID()+"','"+info.getUSERID()+"','"+ExeTime+"','"+claspath+"','"+classname+"','"+info.getIp()+"',now(),'','');";
		db.executeUpdate(InsertSQLlog);
		// 记录日志end     
		Atm.LogSys("获取课表", "按照班级获取课表", "按照班级获取课表完成", "0", info.getUSERID(), info.getIp());
		
		} catch (Exception e) {
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
	
	/**
	 * 按照教室查询
	 * @param request
	 * @param response
	 * @param RequestJson
	 * @param info
	 * @throws ServletException
	 * @throws IOException
	 */
	public void getClassroomInfo(HttpServletRequest request, HttpServletResponse response,String RequestJson,InfoEntity info,String theClassName) throws ServletException, IOException {
		
		    Jdbc db = new Jdbc();
		    Page page = new Page();
	       
	        response.setContentType("text/html;charset=UTF-8");
			request.setCharacterEncoding("UTF-8");
			response.setCharacterEncoding("UTF-8");
			PrintWriter out = response.getWriter();
	
		    String classname="获取课表信息";
	        String claspath=this.getClass().getName();
	        String responsejson=""; //返回客户端数据 
	        JSONObject json = new JSONObject();
	    //定义json接受字段列表        
	         
	        
	       JSONObject jsonbase = new JSONObject();
	       JSONObject jsonbase1 = new JSONObject();
		   ArrayList list = new ArrayList();
		   ArrayList list1 = new ArrayList();
		   
		   String xueqi = "";
		   String classroom = "";
		   String zhouci = "";
		   String kebiaotype = "";//1 有课表  0 无课表
		   
		   commonCourse commonCourse = new commonCourse();
		   common common = new common();
		   
		   try { // 解析开始
			   JSONArray arr = JSONArray.fromObject("[" + RequestJson + "]");
			   for (int i = 0; i < arr.size(); i++) {
				   JSONObject obj = arr.getJSONObject(i);
				    //定义json解析字段列表		
				   xueqi = obj.getString("xueqi");
				   classroom = obj.getString("classroom");
				   zhouci = obj.getString("zhouci");
				   if(!obj.containsKey("kebiaotype")){
					   	kebiaotype="1";
				   }else{
					   kebiaotype = obj.getString("kebiaotype");
				   }
				   		
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
		  String strleft = "";
		  String strwhere = "";
			  
		  if(!"0".equals(zhouci)){
			  strleft = " 	LEFT JOIN arrage_details_weekly ON arrage_details_weekly.arrage_details_id = arrage_details.id		";
			  strwhere = "			AND arrage_details_weekly.weekly = '"+zhouci+"'			";
		  }
		  
		String select_sqlString = "select																				"+
					"				arrage_coursesystem.id, arrage_coursesystem.timetablestate,                                              "+
					"				  dict_courses.course_name as course_name,                                          "+
					"				  dict_courses.course_code as course_code,                                          "+
					"				  ifnull(marge_class.marge_name,class_grade.class_name) as class_name,	"+
					"				  teacher_name,                                                                     "+
					"				  class_begins_weeks,                                                               "+
					"				arrage_coursesystem.teacher_id as teacher_id,										"+
					"				arrage_details.classroomid as classroomid,										"+
					"				   ifnull(classroom.classroomname,'') classroomname,                                                         "+
					"				   arrage_details.timetable as timetable,                                            "+
					"				ifnull(arrage_details.classtime,'') as classtime,												"+
					"					IFNULL(marge_class.class_grade_number,people_number_nan+people_number_woman)  AS totle,	"+
					"				arrage_coursesystem.class_id as class_id "+
					"				from arrage_coursesystem                                                            "+
					"				  left JOIN arrage_details                                                          "+
					"				    on arrage_coursesystem.id = arrage_details.arrage_coursesystem_id               "+
					"				  left JOIN dict_courses                                                            "+
					"				    on arrage_coursesystem.course_id = dict_courses.id                              "+
					"				  left JOIN teacher_basic                                                           "+
					"				    on arrage_coursesystem.teacher_id = teacher_basic.id                            "+
					"				    left JOIN classroom on arrage_details.classroomid = classroom.id                "+
					"					LEFT JOIN class_grade ON arrage_coursesystem.class_id = class_grade.id			"+
					"					LEFT JOIN marge_class ON arrage_coursesystem.marge_class_id = marge_class.id	"+
					strleft+
					"				where arrage_coursesystem.semester = '"+xueqi+"'   AND is_merge_class = 0 AND marge_state = 0                               "+
					"				    and classroom.id = '"+classroom +"'" +strwhere+" ;     " ;
		//"				    and arrage_coursesystem.class_id = '"+classid+"'   AND timetablestate = 1     "+strwhere+" ;     " ;
		
		System.out.println("按教室查询==="+select_sqlString);
		ResultSet rest = db.executeQuery(select_sqlString);
		while(rest.next()){
			if(rest.getString("timetablestate").equals("1")){
				
				jsonbase.put("arrage_coursesid",rest.getString("id") );
				jsonbase.put("course_name", rest.getString("course_name"));
				jsonbase.put("course_code", rest.getString("course_code"));
				jsonbase.put("teacher_name", rest.getString("teacher_name"));
				jsonbase.put("class_begins_weeks", rest.getString("class_begins_weeks"));
				jsonbase.put("classroomname", rest.getString("classroomname"));
				jsonbase.put("classroomid", rest.getString("classroomid"));
				jsonbase.put("classname", rest.getString("class_name"));
				jsonbase.put("teacherid", rest.getString("teacher_id"));
				jsonbase.put("classtime", rest.getString("classtime"));
				jsonbase.put("class_grade_id", rest.getString("class_id"));
				jsonbase.put("totle", rest.getString("totle"));
				if(!"".equals(rest.getString("timetable"))){
					ArrayList<ArrayList<String>> timeList = commonCourse.toArrayList(rest.getString("timetable"),"*","#");
					jsonbase.put("timetable", timeList.toString());
				}else{
					jsonbase.put("timetable", rest.getString("timetable"));
				}
				list.add(jsonbase.toString());
			}else{
				
				jsonbase1.put("arrage_coursesid",rest.getString("id") );
				jsonbase1.put("course_name", rest.getString("course_name"));
				jsonbase1.put("course_code", rest.getString("course_code"));
				jsonbase1.put("teacher_name", rest.getString("teacher_name"));
				jsonbase1.put("class_begins_weeks", rest.getString("class_begins_weeks"));
				jsonbase1.put("classroomname", rest.getString("classroomname"));
				jsonbase1.put("timetable", rest.getString("timetable"));
				jsonbase1.put("classname", rest.getString("class_name"));
				jsonbase1.put("totle", rest.getString("totle"));
				jsonbase1.put("classtime", rest.getString("classtime"));
				jsonbase1.put("classroomid", rest.getString("classroomid"));
				jsonbase1.put("teacherid", rest.getString("teacher_id"));
				list1.add(jsonbase1.toString());
			}
			
		}if(rest!=null){rest.close();}
					
		//生成json信息
		json.put("success", true);
		json.put("resultCode", "1000");
		json.put("msg", "请求成功");
		json.put("data", list.toString());
		if(kebiaotype.equals("1")){
			json.put("linedata", list.toString());
		}else{
			json.put("linedata", list1.toString());
		}
		
		responsejson = json.toString();
		out.print(responsejson);
			 
	    //记录日志
		long ExeTime = Calendar.getInstance().getTimeInMillis()-info.getTimeStart();
		String InsertSQLlog = "INSERT INTO  ec_appuse_log (`uuid`,`Mdels`,`NetMode`,`GPS`,`GPSLocal`,`username`,`did`,`uid`,`ExeTime`,`classpath`,`classname`,`ip`,`logintime`,`requestjson`,`responsejson`) VALUES ('"+info.getUUID()+"','"+info.getMdels()+"','"	+info.getNetMode()+"','"+info.getGPS()+"','"+info.getGPSLocal()+"','"	+info.getUSERID()+"','"+info.getDID()+"','"+info.getUSERID()+"','"+ExeTime+"','"+claspath+"','"+classname+"','"+info.getIp()+"',now(),'','');";
		db.executeUpdate(InsertSQLlog);
		// 记录日志end     
		Atm.LogSys("获取课表", "按照班级获取课表", "按照班级获取课表完成", "0", info.getUSERID(), info.getIp());
		
		} catch (Exception e) {
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
	
	
	/**
	 * 按照教师查询课表
	 * @param request
	 * @param response
	 * @param RequestJson
	 * @param info
	 * @throws ServletException
	 * @throws IOException
	 */
	public void getScheduleTeacherInfo(HttpServletRequest request, HttpServletResponse response,String RequestJson,InfoEntity info,String theClassName) throws ServletException, IOException {
		
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
         
        
       JSONObject jsonbase = new JSONObject();
       JSONObject jsonbase1 = new JSONObject();
	   ArrayList list = new ArrayList();
	   ArrayList list1 = new ArrayList();
	   
	   String xueqi = "";
	   String teacher_id = "";
	   String zhouci = "";
	   String kechengtype = ""; //1 有课 0 无课
	   
	   commonCourse commonCourse = new commonCourse();
	   common common = new common();
	   
	   try { // 解析开始
		   JSONArray arr = JSONArray.fromObject("[" + RequestJson + "]");
		   for (int i = 0; i < arr.size(); i++) {
			   JSONObject obj = arr.getJSONObject(i);
			    //定义json解析字段列表		
			   xueqi = obj.getString("xueqi");
			   teacher_id = obj.getString("teacher_id");
			   zhouci = obj.getString("zhouci");
			   if(!obj.containsKey("kebiaotype")){
				   kechengtype="1";
			   }else{
				   kechengtype = obj.getString("kebiaotype");
			   }
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
//	     	String checkSql ="SELECT COUNT(*) as row FROM  user_worker WHERE uid ='"+info.getUSERID()+"' AND (app_token='"+info.getToken()+"' OR pc_token='"+info.getToken()+"')";
//	     	int TokenTag=db.Row(checkSql);
//		 	if(TokenTag!=1){
//					ErrMsg.falseErrMsg(request, response, "403", "未授权请求！请登录。");
//				    if (db != null) { db.close(); db = null; }
//				    if (page != null) {page = null;}
//				    out.flush();
//				    out.close();
//				   return;//跳出程序只行 
//			}

		  try {   
			  String strleft = "";
			  String strwhere = "";
				  
			  if(!"0".equals(zhouci)){
				  strleft = " 	LEFT JOIN arrage_details_weekly ON arrage_details_weekly.arrage_details_id = arrage_details.id		";
				  strwhere = "			AND arrage_details_weekly.weekly = '"+zhouci+"'			";
			  }
			  
			String select_sqlString = "select																				"+
						"				arrage_coursesystem.id,                                               "+
						"				arrage_coursesystem.teaching_task_id,  arrage_coursesystem.timetablestate,                                             "+
						"				  dict_courses.course_name as course_name,                                          "+
						"				  dict_courses.course_code as course_code,                                          "+
						"				  ifnull(marge_class.marge_name,class_grade.class_name) as class_name,	"+
						"				  teacher_name,                                                                     "+
						"				arrage_coursesystem.teacher_id as teacher_id,										"+
						"				arrage_details.classroomid as classroomid,										"+
						"				  class_begins_weeks,                                                               "+
						"				   ifnull(classroom.classroomname,'') classroomname,                                                         "+
						"				class_grade.id as class_grade_id,	"+
						"				   arrage_details.timetable as timetable,                                            "+
						"				ifnull(arrage_details.classtime,'') as classtime,												"+
						"					IFNULL(marge_class.class_grade_number,people_number_nan+people_number_woman)  AS totle	"+
						"				from arrage_coursesystem                                                            "+
						"				  left JOIN arrage_details                                                          "+
						"				    on arrage_coursesystem.id = arrage_details.arrage_coursesystem_id               "+
						"				  left JOIN dict_courses                                                            "+
						"				    on arrage_coursesystem.course_id = dict_courses.id                              "+
						"				  left JOIN teacher_basic                                                           "+
						"				    on arrage_coursesystem.teacher_id = teacher_basic.id                            "+
						"				    left JOIN classroom on arrage_details.classroomid = classroom.id                "+
						"					LEFT JOIN class_grade ON arrage_coursesystem.class_id = class_grade.id			"+
						"					LEFT JOIN marge_class ON arrage_coursesystem.marge_class_id = marge_class.id	"+
						strleft+
						"				where arrage_coursesystem.semester = '"+xueqi+"'                                  "+
						"				    and arrage_coursesystem.teacher_id = '"+teacher_id+"' "+strwhere+"  AND is_merge_class!=1 AND marge_state !=1   ; " ;
			//"				    and arrage_coursesystem.teacher_id = '"+teacher_id+"'  AND timetablestate = 1      "+strwhere+" ;     " ;
			
			ResultSet rest = db.executeQuery(select_sqlString);
			while(rest.next()){
					if(rest.getString("timetablestate").equals("1")){
						jsonbase.put("arrage_coursesid",rest.getString("id") );
						jsonbase.put("teaching_task_id",rest.getString("teaching_task_id") );
						jsonbase.put("course_name", rest.getString("course_name"));
						jsonbase.put("course_code", rest.getString("course_code"));
						jsonbase.put("teacher_name", rest.getString("teacher_name"));
						jsonbase.put("classroomid", rest.getString("classroomid"));
						jsonbase.put("class_begins_weeks", rest.getString("class_begins_weeks"));
						jsonbase.put("classroomname", rest.getString("classroomname"));
						jsonbase.put("classname", rest.getString("class_name"));
						jsonbase.put("teacherid", rest.getString("teacher_id"));
						jsonbase.put("class_grade_id", rest.getString("class_grade_id"));
						jsonbase.put("classtime", rest.getString("classtime"));
						jsonbase.put("totle", rest.getString("totle"));
						if(!"".equals(rest.getString("timetable"))){
							ArrayList<ArrayList<String>> timeList = commonCourse.toArrayList(rest.getString("timetable"),"*","#");
							jsonbase.put("timetable", timeList.toString());
						}else{
							jsonbase.put("timetable", rest.getString("timetable"));
						}
						list.add(jsonbase.toString());
					}else{
						jsonbase1.put("arrage_coursesid",rest.getString("id") );
						jsonbase1.put("teaching_task_id",rest.getString("teaching_task_id") );
						jsonbase1.put("course_name", rest.getString("course_name"));
						jsonbase1.put("course_code", rest.getString("course_code"));
						jsonbase1.put("teacher_name", rest.getString("teacher_name"));
						jsonbase1.put("class_begins_weeks", rest.getString("class_begins_weeks"));
						jsonbase1.put("classroomname", rest.getString("classroomname"));
						jsonbase1.put("timetable", rest.getString("timetable"));
						jsonbase1.put("classname", rest.getString("class_name"));
						jsonbase1.put("classroomid", rest.getString("classroomid"));
						jsonbase1.put("totle", rest.getString("totle"));
						jsonbase1.put("classtime", rest.getString("classtime"));
						jsonbase1.put("teacherid", rest.getString("teacher_id"));
						jsonbase1.put("class_grade_id", rest.getString("class_grade_id"));
						list1.add(jsonbase1.toString());
					}
				//	list.add(jsonbase.toString());
			
				
				
			}if(rest!=null){rest.close();}
			
			//查询教师备注信息
			String teacher_common_sql = "select remarks from arrage_teacher_special where applystate = 2 AND teacherid='"+teacher_id+"' 	limit 1 ;";
			ResultSet teacher_setResultSet = db.executeQuery(teacher_common_sql);
			String teacher_common = "";
			if(teacher_setResultSet.next()){
				teacher_common = teacher_setResultSet.getString("remarks");
			}if(teacher_setResultSet!=null){teacher_setResultSet.close();}
			
			
			
			//生成json信息
			json.put("success", true);
			json.put("resultCode", "1000");
			json.put("msg", "请求成功");
			if(kechengtype.equals("1")){
				json.put("linedata", list.toString());
			}else{
				json.put("linedata", list1.toString());
			}
			json.put("data", list.toString());
			json.put("remarks", teacher_common);
			
			responsejson = json.toString();
			out.print(responsejson);
				 
		    //记录日志
			long ExeTime = Calendar.getInstance().getTimeInMillis()-info.getTimeStart();
			String InsertSQLlog = "INSERT INTO  ec_appuse_log (`uuid`,`Mdels`,`NetMode`,`GPS`,`GPSLocal`,`username`,`did`,`uid`,`ExeTime`,`classpath`,`classname`,`ip`,`logintime`,`requestjson`,`responsejson`) VALUES ('"+info.getUUID()+"','"+info.getMdels()+"','"	+info.getNetMode()+"','"+info.getGPS()+"','"+info.getGPSLocal()+"','"	+info.getUSERID()+"','"+info.getDID()+"','"+info.getUSERID()+"','"+ExeTime+"','"+claspath+"','"+classname+"','"+info.getIp()+"',now(),'','');";
			db.executeUpdate(InsertSQLlog);
			// 记录日志end     
			Atm.LogSys("获取课表", "按照教师获取课表", "按照教师获取课表完成", "0", info.getUSERID(), info.getIp());
			
			} catch (Exception e) {
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
	
	/**
	 * 获取教师备注信息
	 * @param request
	 * @param response
	 * @param RequestJson
	 * @param info
	 * @param theClassName
	 * @throws ServletException
	 * @throws IOException
	 */
	public void getTeacherCom(HttpServletRequest request, HttpServletResponse response,String RequestJson,InfoEntity info,String theClassName) throws ServletException, IOException {
		
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
	         
	        
		   
		   String xueqi = "";
		   String teacher_id = "";
		   
		   
		   try { // 解析开始
			   JSONArray arr = JSONArray.fromObject("[" + RequestJson + "]");
			   for (int i = 0; i < arr.size(); i++) {
				   JSONObject obj = arr.getJSONObject(i);
				    //定义json解析字段列表		
				   xueqi = obj.getString("xueqi");
				   teacher_id = obj.getString("teacher_id");
				   		
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
				
				//查询教师备注信息
				String teacher_common_sql = "select remarks from arrage_teacher_special where applystate = 2 AND teacherid='"+teacher_id+"' AND semester='"+xueqi+"'	limit 1 ;";
				ResultSet teacher_setResultSet = db.executeQuery(teacher_common_sql);
				String teacher_common = "";
				if(teacher_setResultSet.next()){
					teacher_common = teacher_setResultSet.getString("remarks");
				}if(teacher_setResultSet!=null){teacher_setResultSet.close();}
				
				//生成json信息
				json.put("success", true);
				json.put("resultCode", "1000");
				json.put("msg", teacher_common);
				
				responsejson = json.toString();
				out.print(responsejson);
					 
			    //记录日志
				long ExeTime = Calendar.getInstance().getTimeInMillis()-info.getTimeStart();
				String InsertSQLlog = "INSERT INTO  ec_appuse_log (`uuid`,`Mdels`,`NetMode`,`GPS`,`GPSLocal`,`username`,`did`,`uid`,`ExeTime`,`classpath`,`classname`,`ip`,`logintime`,`requestjson`,`responsejson`) VALUES ('"+info.getUUID()+"','"+info.getMdels()+"','"	+info.getNetMode()+"','"+info.getGPS()+"','"+info.getGPSLocal()+"','"	+info.getUSERID()+"','"+info.getDID()+"','"+info.getUSERID()+"','"+ExeTime+"','"+claspath+"','"+classname+"','"+info.getIp()+"',now(),'','');";
				db.executeUpdate(InsertSQLlog);
				// 记录日志end     
				Atm.LogSys("获取教师备注信息", "获取教师备注信息", "获取教师备注信息", "0", info.getUSERID(), info.getIp());
				
				} catch (Exception e) {
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
	
	
	
	
	
	/**
	 * 课表调整 按照班级调整
	 * @param request
	 * @param response
	 * @param RequestJson
	 * @param info
	 * @param theClassName
	 * @throws ServletException
	 * @throws IOException
	 */
	public void timetableAdjustment(HttpServletRequest request, HttpServletResponse response,String RequestJson,InfoEntity info,String theClassName) throws ServletException, IOException {
		
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
	         
	        
	       JSONObject jsonbase = new JSONObject();
	       JSONObject jsonbase1 = new JSONObject();
		   ArrayList list = new ArrayList();
		   ArrayList list1 = new ArrayList();
		   
		   String arrage_coursesid_one = "";
		   String id_one = "";
		   String arrage_coursesid_two = "";
		   String id_two = "";
		   String semester = "";
		   String classgrade = "";
		   String inspect = "";
		   
		   commonCourse commonCourse = new commonCourse();
		   common common = new common();
		   
		   try { // 解析开始
			   JSONArray arr = JSONArray.fromObject("[" + RequestJson + "]");
			   for (int i = 0; i < arr.size(); i++) {
				   JSONObject obj = arr.getJSONObject(i);
				    //定义json解析字段列表		
				   arrage_coursesid_one = obj.getString("arrage_coursesid_one");
				   id_one = obj.getString("id_one");
				   arrage_coursesid_two = obj.getString("arrage_coursesid_two");
				   id_two = obj.getString("id_two");
				   semester = obj.getString("semester");
				   classgrade = obj.getString("classgrade");
				   inspect = obj.getString("inspect");
				   		
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
				//分割星期节次
				String [] weekly_one = id_one.split("_");
				String [] weekly_two = id_two.split("_");
				
				String [] arrays_one = arrage_coursesid_one.split("\\|");
				String [] arrays_two = arrage_coursesid_two.split("\\|");
				
				//1.判断课程是否是替换到空白处
				String teaching_task_one = arrays_one[0];
				String classroomid_one = arrays_one[1];
				String teacher_id_one  = arrays_one[2];
				
				String teaching_task_two = arrays_two[0];
				String classroomid_two = arrays_two[1];
				String teacher_id_two = arrays_two[2];
				
				int week_one_i = Integer.valueOf(weekly_one[0]);			//星期下表
				int week_one_j = Integer.valueOf(weekly_one[1]);			//节次下表
				
				
				int week_two_i = Integer.valueOf(weekly_two[0]);			//星期下表
				int week_two_j = Integer.valueOf(weekly_two[1]);			//节次下表
				
				
				if(teaching_task_one.equals(teaching_task_two)&&classroomid_one.equals(classroomid_two)){
					json.put("success", false);
					json.put("resultCode", "2000");
					json.put("msg", "别逗了,教师和教室都是相同的，不能转换");
					responsejson = json.toString();
					out.print(responsejson);
					Page.colseDP(db, page);
					return ;
				}
				
				
				
				ArrayList<ArrayList<String>> teacher_list_oneArrayList = new ArrayList<ArrayList<String>>();
				ArrayList<ArrayList<String>> teacher_list_twoArrayList = new ArrayList<ArrayList<String>>();
				
				//1.两个课程相互转换
				//找到老师所占时间
				Map<String,String> mapteacherOne = commonCourse.getTeacherinfo(teacher_id_one,semester);
				String teacher_one_timetable = "";
				boolean teacher_state_one = false;
				if(!mapteacherOne.isEmpty()){
					teacher_one_timetable = mapteacherOne.get("timetable");
					teacher_list_oneArrayList = commonCourse.toArrayList(teacher_one_timetable, "*", "#");
					String teacher_oneString = teacher_list_oneArrayList.get(week_two_i).get(week_two_j);
					
					String classtime_old = commonCourse.getClasstime(teacher_one_timetable);		//旧得上课时间
					if("1".equals(inspect)){
						//不检查
						teacher_list_oneArrayList.get(week_two_i).set(week_two_j, "0");
						teacher_list_oneArrayList.get(week_one_i).set(week_one_j, String.valueOf((week_one_j+1)));
						teacher_one_timetable = commonCourse.toStringfroList(teacher_list_oneArrayList, "*","#");
						String classtime_new = commonCourse.getClasstime(teacher_one_timetable);		//新得上课时间
						
						//增加记录
						commonCourse.setLectureLog(teaching_task_one, classtime_old, classtime_new, "teacher", teacher_id_one);
						
						
						//修改老师
						//commonCourse.updateTeacherInfo(mapteacherOne.get("id"),teacher_one_timetable);
						teacher_state_one = true;
					}else{
						if(!"0".equals(teacher_oneString) && !"9".equals(teacher_oneString)){
							teacher_list_oneArrayList.get(week_two_i).set(week_two_j, "0");
							teacher_list_oneArrayList.get(week_one_i).set(week_one_j, String.valueOf((week_one_j+1)));
							teacher_one_timetable = commonCourse.toStringfroList(teacher_list_oneArrayList, "*","#");
							
							String classtime_new = commonCourse.getClasstime(teacher_one_timetable);		//新得上课时间
							
							//增加记录
							commonCourse.setLectureLog(teaching_task_one, classtime_old, classtime_new, "teacher", teacher_id_one);
							
							
							
							//修改老师
							//commonCourse.updateTeacherInfo(mapteacherOne.get("id"),teacher_one_timetable);
							teacher_state_one = true;
						}else{
							json.put("success", false);
							json.put("resultCode", "2000");
							json.put("msg", "教师冲突");
							responsejson = json.toString();
							out.print(responsejson);
							Page.colseDP(db, page);
							Atm.LogSys("课表调整", "按照班级调整课表", "按照班级调整课表失败,原因:教师冲突不能调整,操作人:"+common.getusernameTouid(info.getUSERID())+"", "0", info.getUSERID(), info.getIp());
							return ;
						}
					}
				}
				
				
				Map<String,String> mapteacherTwo = commonCourse.getTeacherinfo(teacher_id_two,semester);
				String teacher_two_timetable = "";
				boolean teacher_state_two = false;
				if(!mapteacherTwo.isEmpty()){
					teacher_two_timetable = mapteacherTwo.get("timetable");
					teacher_list_twoArrayList = commonCourse.toArrayList(teacher_two_timetable, "*", "#");
					String teacher_twoString = teacher_list_twoArrayList.get(week_one_i).get(week_one_j);
					
					String classtime_old = commonCourse.getClasstime(teacher_two_timetable);		//旧得上课时间
					
					
					
					if("1".equals(inspect)){
						//不检查
						teacher_list_twoArrayList.get(week_one_i).set(week_one_j, "0");
						teacher_list_twoArrayList.get(week_two_i).set(week_two_j, String.valueOf((week_two_j+1)));
						teacher_two_timetable = commonCourse.toStringfroList(teacher_list_twoArrayList, "*","#");
						
						String classtime_new = commonCourse.getClasstime(teacher_two_timetable);		//新得上课时间
						
						//增加记录
						commonCourse.setLectureLog(teaching_task_two, classtime_old, classtime_new, "teacher", teacher_id_two);
						
						
						//修改老师
						//commonCourse.updateTeacherInfo(mapteacherTwo.get("id"),teacher_two_timetable);
						teacher_state_two = true;
					}else{
						if(!"0".equals(teacher_twoString) && !"9".equals(teacher_twoString)){
							teacher_list_twoArrayList.get(week_one_i).set(week_one_j, "0");
							teacher_list_twoArrayList.get(week_two_i).set(week_two_j, String.valueOf((week_two_j+1)));
							teacher_two_timetable = commonCourse.toStringfroList(teacher_list_twoArrayList, "*","#");
							
							String classtime_new = commonCourse.getClasstime(teacher_two_timetable);		//新得上课时间
							
							//增加记录
							commonCourse.setLectureLog(teaching_task_two, classtime_old, classtime_new, "teacher", teacher_id_two);
							
							
							
							//修改老师
							//commonCourse.updateTeacherInfo(mapteacherTwo.get("id"),teacher_two_timetable);
							teacher_state_two = true;
						}else{
							//跳出
							json.put("success", false);
							json.put("resultCode", "2000");
							json.put("msg", "教师冲突");
							responsejson = json.toString();
							out.print(responsejson);
							Page.colseDP(db, page);
							Atm.LogSys("课表调整", "按照班级调整课表", "按照班级调整课表失败,原因:教师冲突不能调整,操作人:"+common.getusernameTouid(info.getUSERID())+"", "0", info.getUSERID(), info.getIp());
							return ;
						}
					}
				}
				
				
				
				//找到教室所占时间
				ArrayList<ArrayList<String>> classroom_list_oneArrayList = new ArrayList<ArrayList<String>>();
				ArrayList<ArrayList<String>> classroom_list_twoArrayList = new ArrayList<ArrayList<String>>();
				
				
				Map<String,String> mapClassroomOne = commonCourse.getClassroomInfo(classroomid_one,semester);
				Map<String,String> mapClassroomTwo = commonCourse.getClassroomInfo(classroomid_two,semester);
				String classroom_one_timetable = "";
				String classroom_two_timetable = "";
				boolean classroom_state_one = false;
				boolean classroom_state_two = false;
				if(!classroomid_one.equals(classroomid_two)){
					if(!mapClassroomOne.isEmpty()){
						classroom_one_timetable = mapClassroomOne.get("timetable");
						classroom_list_oneArrayList = commonCourse.toArrayList(classroom_one_timetable, "*", "#");
						String classroom_str = classroom_list_oneArrayList.get(week_two_i).get(week_two_j);
						
						String classtime_old = commonCourse.getClasstime(classroom_one_timetable);
						
						if("1".equals(inspect)){
							//不检查
							classroom_list_oneArrayList.get(week_two_i).set(week_two_j, "0");
							classroom_list_oneArrayList.get(week_one_i).set(week_one_j, String.valueOf((week_one_j+1)));
							classroom_one_timetable = commonCourse.toStringfroList(classroom_list_oneArrayList, "*","#");
							
							String classtime_new = commonCourse.getClasstime(classroom_one_timetable);		//新得上课时间
							
							//增加记录
							commonCourse.setLectureLog(teaching_task_one, classtime_old, classtime_new, "classroom", classroomid_one);
							
							
							//修改教室
							//commonCourse.updateClassroom(mapClassroomOne.get("id"),classroom_one_timetable);
							classroom_state_one = true;
						}else{
							if(!"0".equals(classroom_str) && !"9".equals(classroom_str)){
								classroom_list_oneArrayList.get(week_two_i).set(week_two_j, "0");
								classroom_list_oneArrayList.get(week_one_i).set(week_one_j, String.valueOf((week_one_j+1)));
								classroom_one_timetable = commonCourse.toStringfroList(classroom_list_oneArrayList, "*","#");
								
								String classtime_new = commonCourse.getClasstime(classroom_one_timetable);		//新得上课时间
								
								//增加记录
								commonCourse.setLectureLog(teaching_task_one, classtime_old, classtime_new, "classroom", classroomid_one);
								
								//修改教室
								//commonCourse.updateClassroom(mapClassroomOne.get("id"),classroom_one_timetable);
								classroom_state_one = true;
							}else{
								//跳出
								json.put("success", false);
								json.put("resultCode", "2000");
								json.put("msg", "教室冲突");
								responsejson = json.toString();
								out.print(responsejson);
								Page.colseDP(db, page);
								Atm.LogSys("课表调整", "按照班级调整课表", "按照班级调整课表失败,原因:教室冲突不能调整,操作人:"+common.getusernameTouid(info.getUSERID())+"", "0", info.getUSERID(), info.getIp());
								return ;
							}
						}
						
					}
					
					if(!mapClassroomTwo.isEmpty()){
						classroom_two_timetable = mapClassroomTwo.get("timetable");
						classroom_list_twoArrayList = commonCourse.toArrayList(classroom_two_timetable, "*", "#");
						String classroom_str = classroom_list_twoArrayList.get(week_one_i).get(week_one_j);
						
						String classtime_old = commonCourse.getClasstime(classroom_two_timetable);
						
						if("1".equals(inspect)){
							//不检查
							classroom_list_twoArrayList.get(week_one_i).set(week_one_j, "0");
							classroom_list_twoArrayList.get(week_two_i).set(week_two_j, String.valueOf(week_two_j+1));
							classroom_two_timetable = commonCourse.toStringfroList(classroom_list_twoArrayList, "*","#");
							
							String classtime_new = commonCourse.getClasstime(classroom_two_timetable);		//新得上课时间
							
							//增加记录
							commonCourse.setLectureLog(teaching_task_two, classtime_old, classtime_new, "classroom", classroomid_two);
							
							//修改教室
							//commonCourse.updateClassroom(mapClassroomTwo.get("id"),classroom_two_timetable);
							classroom_state_two = true;
						}else{
							if(!"0".equals(classroom_str)  &&  !"9".equals(classroom_str)){
								classroom_list_twoArrayList.get(week_one_i).set(week_one_j, "0");
								classroom_list_twoArrayList.get(week_two_i).set(week_two_j, String.valueOf(week_two_j+1));
								classroom_two_timetable = commonCourse.toStringfroList(classroom_list_twoArrayList, "*","#");
								
								String classtime_new = commonCourse.getClasstime(classroom_two_timetable);		//新得上课时间
								
								//增加记录
								commonCourse.setLectureLog(teaching_task_two, classtime_old, classtime_new, "classroom", classroomid_two);
								
								//修改教室
								//commonCourse.updateClassroom(mapClassroomTwo.get("id"),classroom_two_timetable);
								classroom_state_two = true;
							}else{
								//跳出
								json.put("success", false);
								json.put("resultCode", "2000");
								json.put("msg", "教室冲突");
								responsejson = json.toString();
								out.print(responsejson);
								Page.colseDP(db, page);
								Atm.LogSys("课表调整", "按照班级调整课表", "按照班级调整课表失败,原因:教室冲突不能调整,操作人:"+common.getusernameTouid(info.getUSERID())+"", "0", info.getUSERID(), info.getIp());
								return ;
							}
						}
						
					}
					
				}
				
				//修改arrage_details表
				if(!"0".equals(teaching_task_one)&&!"0".equals(classroomid_one)&&!"0".equals(teacher_id_one)){
					String select_details_one = getdetailsSql(teaching_task_one,classroomid_one,teacher_id_one);
					ResultSet details_one_set = db.executeQuery(select_details_one);
					String details_time_one = "";
					String details_one_id = "";
					ArrayList<ArrayList<String>> details_one_list = new ArrayList<ArrayList<String>>();
					if(details_one_set.next()){
						details_one_id = details_one_set.getString("id");
						details_time_one = details_one_set.getString("timetable");
					}if(details_one_set!=null){details_one_set.close();}
					details_one_list = commonCourse.toArrayList(details_time_one, "*", "#");
					details_one_list.get(week_two_i).set(week_two_j, "0");
					details_one_list.get(week_one_i).set(week_one_j, String.valueOf((week_one_j+1)));
					details_time_one = commonCourse.toStringfroList(details_one_list, "*","#");
					updateArrageDetailsSql(details_one_id,details_time_one,commonCourse.getClasstime(details_time_one));
				}
				
				if(!"0".equals(teaching_task_two)&&!"0".equals(classroomid_two)&&!"0".equals(teacher_id_two)){
					String select_details_two = getdetailsSql(teaching_task_two,classroomid_two,teacher_id_two);
					ResultSet details_two_set = db.executeQuery(select_details_two);
					String details_time_two = "";
					String details_two_id = "";
					ArrayList<ArrayList<String>> details_two_list = new ArrayList<ArrayList<String>>();
					if(details_two_set.next()){
						details_two_id = details_two_set.getString("id");
						details_time_two = details_two_set.getString("timetable");
					}if(details_two_set!=null){details_two_set.close();}
					details_two_list = commonCourse.toArrayList(details_time_two, "*", "#");
					details_two_list.get(week_one_i).set(week_one_j, "0");
					details_two_list.get(week_two_i).set(week_two_j, String.valueOf((week_two_j+1)));
					details_time_two = commonCourse.toStringfroList(details_two_list, "*","#");
					updateArrageDetailsSql(details_two_id,details_time_two,commonCourse.getClasstime(details_time_two));
				}
				
				
				//修改班级表
				Map<String,String> mapClass = commonCourse.getclassInfo(classgrade,semester);
				ArrayList<ArrayList<String>> class_list = new ArrayList<ArrayList<String>>();
				if("0".equals(teaching_task_one)&&!"0".equals(teacher_id_two)){
					class_list = commonCourse.toArrayList(mapClass.get("timetable"), "*", "#");
					String classtime_old =  commonCourse.getClasstime(mapClass.get("timetable"));
					class_list.get(week_one_i).set(week_one_j, "0");
					class_list.get(week_two_i).set(week_two_j, String.valueOf((week_two_j+1)));
					
					String classtime_new = commonCourse.getClasstime(commonCourse.toStringfroList(class_list,"*","#"));		//新得上课时间
					
					//增加记录
					commonCourse.setLectureLog(teaching_task_two, classtime_old, classtime_new, "class", classgrade);
					
					commonCourse.updateClassinfo(mapClass.get("id"),commonCourse.toStringfroList(class_list,"*","#"));
				}else if(!"0".equals(teaching_task_one)&&"0".equals(teacher_id_two)){
					class_list = commonCourse.toArrayList(mapClass.get("timetable"), "*", "#");
					String classtime_old =  commonCourse.getClasstime(mapClass.get("timetable"));
					class_list.get(week_two_i).set(week_two_j, "0");
					class_list.get(week_one_i).set(week_one_j, String.valueOf((week_one_j+1)));
					
					
					String classtime_new = commonCourse.getClasstime(commonCourse.toStringfroList(class_list,"*","#"));		//新得上课时间
					
					//增加记录
					commonCourse.setLectureLog(teaching_task_one, classtime_old, classtime_new, "class", classgrade);
					
					commonCourse.updateClassinfo(mapClass.get("id"),commonCourse.toStringfroList(class_list,"*","#"));
				}
				
				//执行语句
				if(teacher_state_one){
					commonCourse.updateTeacherInfo(mapteacherOne.get("id"),teacher_one_timetable);
				}
				if(teacher_state_two){
					commonCourse.updateTeacherInfo(mapteacherTwo.get("id"),teacher_two_timetable);
				}
				if(classroom_state_one){
					commonCourse.updateClassroom(mapClassroomOne.get("id"),classroom_one_timetable);
				}
				if(classroom_state_two){
					commonCourse.updateClassroom(mapClassroomTwo.get("id"),classroom_two_timetable);
				}
				
					
				json.put("success", true);
				json.put("resultCode", "1000");
				json.put("msg", "成功");
				
				responsejson = json.toString();
				out.print(responsejson);
					 
				//记录日志
				long ExeTime = Calendar.getInstance().getTimeInMillis()-info.getTimeStart();
				String InsertSQLlog = "INSERT INTO  ec_appuse_log (`uuid`,`Mdels`,`NetMode`,`GPS`,`GPSLocal`,`username`,`did`,`uid`,`ExeTime`,`classpath`,`classname`,`ip`,`logintime`,`requestjson`,`responsejson`) VALUES ('"+info.getUUID()+"','"+info.getMdels()+"','"	+info.getNetMode()+"','"+info.getGPS()+"','"+info.getGPSLocal()+"','"	+info.getUSERID()+"','"+info.getDID()+"','"+info.getUSERID()+"','"+ExeTime+"','"+claspath+"','"+classname+"','"+info.getIp()+"',now(),'','');";
				db.executeUpdate(InsertSQLlog);
				// 记录日志end     
				Atm.LogSys("课表调整", "按照班级调整课表", "按照班级调整课表完成,操作人:"+common.getusernameTouid(info.getUSERID())+"", "0", info.getUSERID(), info.getIp());
			
			} catch (Exception e) {
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
		
		/**
		 * 
		 * @return
		 */
		public static String setSql(String teaching_task_id){
			String sql = "SELECT																	"+
			"			  arrange_sys_teacher.timetable AS timetable,                               "+
			"			  arrage_coursesystem.semester AS semester                                  "+
			"			FROM arrage_coursesystem                                                    "+
			"			  LEFT JOIN arrange_sys_teacher                                             "+
			"			    ON arrage_coursesystem.teacher_id = arrange_sys_teacher.teacherid       "+
			"			WHERE arrage_coursesystem.id = '"+teaching_task_id+"';";
			
			return sql;
		}
	
		public static String getdetailsSql(String arrage_coursesystem_id ,String classroomid,String teacherid){
			String sql = "SELECT 	 		id,				"+
				"			timetable                          "+
				"			FROM                                "+
				"			arrage_details       "+
				"			WHERE                           "+
				"			arrage_coursesystem_id = '"+arrage_coursesystem_id+"'AND  classroomid = '"+classroomid+"'	AND teacher_id = '"+teacherid+"'  ;";
			return sql;
		}
		
		public static String getdetailsSql1(String arrage_coursesystem_id ,String classroomid,String class_id){
			String sql = "SELECT 	 		id,				"+
				"			timetable                          "+
				"			FROM                                "+
				"			arrage_details       "+
				"			WHERE                           "+
				"			arrage_coursesystem_id = '"+arrage_coursesystem_id+"'AND  classroomid = '"+classroomid+"'	AND classid = '"+class_id+"'  ;";
			return sql;
		}
		
		public static String getdetailsSql2(String arrage_coursesystem_id ,String teacher_id,String class_id){
			String sql = "SELECT 	 		id,				"+
				"			timetable                          "+
				"			FROM                                "+
				"			arrage_details       "+
				"			WHERE                           "+
				"			arrage_coursesystem_id = '"+arrage_coursesystem_id+"'AND  teacher_id = '"+teacher_id+"'	AND classid = '"+class_id+"'  ;";
			return sql;
		}
		
		
		
		public static boolean updateArrageDetailsSql(String id,String timetable,String classtime){
			boolean state = true;
			Jdbc db = new Jdbc();
		    Page page = new Page();
			String sqlString = "UPDATE arrage_details 			"+
					"			SET                             "+
					"			timetable = '"+timetable+"',    "+
					"			classtime = '"+classtime+"'		"+
					"			WHERE                           "+
					"			id='"+id+"'  ;";
			System.out.println(sqlString);
			state = db.executeUpdate(sqlString);
			Page.colseDP(db, page);
			return state;
		}
		
		/**
		 * 课表调整 按照教室调整课表
		 * @param request
		 * @param response
		 * @param RequestJson
		 * @param info
		 * @param theClassName
		 * @throws ServletException
		 * @throws IOException
		 */
		public void timetableAdjustmentClassroom(HttpServletRequest request, HttpServletResponse response,String RequestJson,InfoEntity info,String theClassName) throws ServletException, IOException {
			
		    Jdbc db = new Jdbc();
		    Page page = new Page();
	       
	        response.setContentType("text/html;charset=UTF-8");
			request.setCharacterEncoding("UTF-8");
			response.setCharacterEncoding("UTF-8");
			PrintWriter out = response.getWriter();
	
		    String classname="获取课表信息按照教室查询";
	        String claspath=this.getClass().getName();
	        String responsejson=""; //返回客户端数据 
	        JSONObject json = new JSONObject();
	    //定义json接受字段列表        
	         
	        
	       JSONObject jsonbase = new JSONObject();
	       JSONObject jsonbase1 = new JSONObject();
		   ArrayList list = new ArrayList();
		   ArrayList list1 = new ArrayList();
		   
		   String arrage_coursesid_one = "";
		   String id_one = "";
		   String arrage_coursesid_two = "";
		   String id_two = "";
		   String semester = "";
		   String classroom = "";
		   String inspect = "";
		   
		   commonCourse commonCourse = new commonCourse();
		   common common = new common();
		   
		   try { // 解析开始
			   JSONArray arr = JSONArray.fromObject("[" + RequestJson + "]");
			   for (int i = 0; i < arr.size(); i++) {
				   JSONObject obj = arr.getJSONObject(i);
				    //定义json解析字段列表		
				   arrage_coursesid_one = obj.getString("arrage_coursesid_one");
				   id_one = obj.getString("id_one");
				   arrage_coursesid_two = obj.getString("arrage_coursesid_two");
				   id_two = obj.getString("id_two");
				   semester = obj.getString("semester");
				   classroom = obj.getString("classroom");
				   inspect = obj.getString("inspect");
				   		
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
				//分割星期节次
				String [] weekly_one = id_one.split("_");
				String [] weekly_two = id_two.split("_");
				
				String [] arrays_one = arrage_coursesid_one.split("\\|");
				String [] arrays_two = arrage_coursesid_two.split("\\|");
				
				//1.判断课程是否是替换到空白处
				String teaching_task_one = arrays_one[0];
				String teacher_one = arrays_one[1];
				String class_id_one  = arrays_one[2];
				
				String teaching_task_two = arrays_two[0];
				String teacher_two = arrays_two[1];
				String class_id_two = arrays_two[2];
				
				int week_one_i = Integer.valueOf(weekly_one[0]);			//星期下表
				int week_one_j = Integer.valueOf(weekly_one[1]);			//节次下表
				
				
				int week_two_i = Integer.valueOf(weekly_two[0]);			//星期下表
				int week_two_j = Integer.valueOf(weekly_two[1]);			//节次下表
				
				
				//判断获取的teaching_task_one 和teaching_task_two
				
				String teaching_task_one_sql = "select marge_class_id from arrage_coursesystem where id = '"+teaching_task_one+"'";
				String marge_class_id_one = "0";
				
				String teaching_task_two_sql = "select marge_class_id from arrage_coursesystem where id = '"+teaching_task_two+"'";
				String marge_class_id_two = "0";
				
				ResultSet teaching_task_one_sql_setResultSet = db.executeQuery(teaching_task_one_sql);
				if(teaching_task_one_sql_setResultSet.next()){
					marge_class_id_one = teaching_task_one_sql_setResultSet.getString("marge_class_id");
				}if(teaching_task_one_sql_setResultSet!=null){teaching_task_one_sql_setResultSet.close();}
				
				ResultSet teaching_task_two_sql_setResultSet = db.executeQuery(teaching_task_two_sql);
				if(teaching_task_two_sql_setResultSet.next()){
					marge_class_id_two = teaching_task_two_sql_setResultSet.getString("marge_class_id");
				}if(teaching_task_two_sql_setResultSet!=null){teaching_task_two_sql_setResultSet.close();}
				
				
				
				
				//判断合班是否存在
				ArrayList<String> class_margeArrayList = new ArrayList<String>();
				ArrayList<String> arrage_coursesystemList = new ArrayList<String>();
				if(!"0".equals(marge_class_id_one)){
					String marge_sqlString = "SELECT																			"+
							"		  arrage_coursesystem.id,                                                                   "+
							"		  class_id                                                                                  "+
							"		FROM teaching_tesk_marge                                                                    "+
							"		  LEFT JOIN arrage_coursesystem                                                             "+
							"		    ON teaching_tesk_marge.teaching_task_id = arrage_coursesystem.teaching_task_id          "+
							"		WHERE teaching_tesk_marge.marge_class_id = '"+marge_class_id_one+"'";
					ResultSet class_marge_setResultSet = db.executeQuery(marge_sqlString);
					while(class_marge_setResultSet.next()){
						class_margeArrayList.add(class_marge_setResultSet.getString("class_id"));
						arrage_coursesystemList.add(class_marge_setResultSet.getString("id"));
					}if(class_marge_setResultSet!=null){class_marge_setResultSet.close();}
				}
				
				if(!"0".equals(marge_class_id_two)){
					String marge_sql_two = "SELECT																			"+
					"		  arrage_coursesystem.id,                                                                   "+
					"		  class_id                                                                                  "+
					"		FROM teaching_tesk_marge                                                                    "+
					"		  LEFT JOIN arrage_coursesystem                                                             "+
					"		    ON teaching_tesk_marge.teaching_task_id = arrage_coursesystem.teaching_task_id          "+
					"		WHERE teaching_tesk_marge.marge_class_id = '"+marge_class_id_two+"'";
					ResultSet class_marge_setResultSet = db.executeQuery(marge_sql_two);
					while(class_marge_setResultSet.next()){
						class_margeArrayList.add(class_marge_setResultSet.getString("class_id"));
						arrage_coursesystemList.add(class_marge_setResultSet.getString("id"));
					}if(class_marge_setResultSet!=null){class_marge_setResultSet.close();}
				}
				
				
				if(class_id_one.equals(class_id_two)&&teacher_one.equals(teacher_two)){
					json.put("success", false);
					json.put("resultCode", "2000");
					json.put("msg", "班级和教师都是相同的，不能转换");
					responsejson = json.toString();
					out.print(responsejson);
					Page.colseDP(db, page);
					return ;
				}
				
				
				
				//找到教室所占时间
				ArrayList<ArrayList<String>> teacher_list_oneArrayList = new ArrayList<ArrayList<String>>();
				ArrayList<ArrayList<String>> teacher_list_twoArrayList = new ArrayList<ArrayList<String>>();
				
				//1.两个课程相互转换
				//找到老师所占时间
				Map<String,String> mapteacherOne = commonCourse.getTeacherinfo(teacher_one,semester);
				String teacher_one_timetable = "";
				boolean teacher_state_one = false;
				if(!mapteacherOne.isEmpty()){
					teacher_one_timetable = mapteacherOne.get("timetable");
					teacher_list_oneArrayList = commonCourse.toArrayList(teacher_one_timetable, "*", "#");
					String teacher_oneString = teacher_list_oneArrayList.get(week_two_i).get(week_two_j);
					
					String classtime_old = commonCourse.getClasstime(teacher_one_timetable);		//旧得上课时间
					if("1".equals(inspect)){
						//不检查
						teacher_list_oneArrayList.get(week_two_i).set(week_two_j, "0");
						teacher_list_oneArrayList.get(week_one_i).set(week_one_j, String.valueOf((week_one_j+1)));
						teacher_one_timetable = commonCourse.toStringfroList(teacher_list_oneArrayList, "*","#");
						String classtime_new = commonCourse.getClasstime(teacher_one_timetable);		//新得上课时间
						
						//增加记录
						commonCourse.setLectureLog(teaching_task_one, classtime_old, classtime_new, "teacher", teacher_one);
						
						
						//修改老师
						//commonCourse.updateTeacherInfo(mapteacherOne.get("id"),teacher_one_timetable);
						teacher_state_one = true;
					}else{
						if(!"0".equals(teacher_oneString) && !"9".equals(teacher_oneString)){
							teacher_list_oneArrayList.get(week_two_i).set(week_two_j, "0");
							teacher_list_oneArrayList.get(week_one_i).set(week_one_j, String.valueOf((week_one_j+1)));
							teacher_one_timetable = commonCourse.toStringfroList(teacher_list_oneArrayList, "*","#");
							
							String classtime_new = commonCourse.getClasstime(teacher_one_timetable);		//新得上课时间
							
							//增加记录
							commonCourse.setLectureLog(teaching_task_one, classtime_old, classtime_new, "teacher", teacher_one);
							
							
							
							//修改老师
							//commonCourse.updateTeacherInfo(mapteacherOne.get("id"),teacher_one_timetable);
							teacher_state_one = true;
						}else{
							json.put("success", false);
							json.put("resultCode", "2000");
							json.put("msg", "教师冲突1");
							responsejson = json.toString();
							out.print(responsejson);
							Page.colseDP(db, page);
							Atm.LogSys("课表调整", "按照班级调整课表", "按照班级调整课表失败,原因:教师冲突不能调整,操作人:"+common.getusernameTouid(info.getUSERID())+"", "0", info.getUSERID(), info.getIp());
							return ;
						}
					}
				}
				
				Map<String,String> mapteacherTwo = commonCourse.getTeacherinfo(teacher_two,semester);
				String teacher_two_timetable = "";
				boolean teacher_state_two = false;
				if(!mapteacherTwo.isEmpty()){
					teacher_two_timetable = mapteacherTwo.get("timetable");
					teacher_list_twoArrayList = commonCourse.toArrayList(teacher_two_timetable, "*", "#");
					String teacher_twoString = teacher_list_twoArrayList.get(week_one_i).get(week_one_j);
					
					String classtime_old = commonCourse.getClasstime(teacher_two_timetable);		//旧得上课时间
					
					
					
					if("1".equals(inspect)){
						//不检查
						teacher_list_twoArrayList.get(week_one_i).set(week_one_j, "0");
						teacher_list_twoArrayList.get(week_two_i).set(week_two_j, String.valueOf((week_two_j+1)));
						teacher_two_timetable = commonCourse.toStringfroList(teacher_list_twoArrayList, "*","#");
						
						String classtime_new = commonCourse.getClasstime(teacher_two_timetable);		//新得上课时间
						
						//增加记录
						commonCourse.setLectureLog(teaching_task_two, classtime_old, classtime_new, "teacher", teacher_two);
						
						//修改老师
						//commonCourse.updateTeacherInfo(mapteacherTwo.get("id"),teacher_two_timetable);
						teacher_state_two = true;
					}else{
						if(!"0".equals(teacher_twoString) && !"9".equals(teacher_twoString)){
							teacher_list_twoArrayList.get(week_one_i).set(week_one_j, "0");
							teacher_list_twoArrayList.get(week_two_i).set(week_two_j, String.valueOf((week_two_j+1)));
							teacher_two_timetable = commonCourse.toStringfroList(teacher_list_twoArrayList, "*","#");
							String classtime_new = commonCourse.getClasstime(teacher_two_timetable);		//新得上课时间
							//增加记录
							commonCourse.setLectureLog(teaching_task_two, classtime_old, classtime_new, "teacher", teacher_two);
							//修改老师
							//commonCourse.updateTeacherInfo(mapteacherTwo.get("id"),teacher_two_timetable);
							teacher_state_two = true;
						}else{
							//跳出
							json.put("success", false);
							json.put("resultCode", "2000");
							json.put("msg", "教师冲突2");
							responsejson = json.toString();
							out.print(responsejson);
							Page.colseDP(db, page);
							Atm.LogSys("课表调整", "按照班级调整课表", "按照班级调整课表失败,原因:教师冲突不能调整,操作人:"+common.getusernameTouid(info.getUSERID())+"", "0", info.getUSERID(), info.getIp());
							return ;
						}
					}
				}
				
				
				//班级查找
				Map<String,String> mapClass_one = commonCourse.getclassInfo(class_id_one,semester);
				ArrayList<ArrayList<String>> class_list_oneArrayList = new ArrayList<ArrayList<String>>();
				String class_timetable_one = "";
				boolean class_one_state = false;
				
				Map<String, String> mapClass_two = commonCourse.getclassInfo(class_id_two, semester);
				ArrayList<ArrayList<String>> class_list_twoArrayList = new ArrayList<ArrayList<String>>();
				String class_timetable_two = "";
				boolean class_two_state = false;
				if(!class_id_one.equals(class_id_two)){
					
					//判断marge是否存在
					if(!"0".equals(marge_class_id_one)){
						//存在 循环
						for(int i =0 ; i< class_margeArrayList.size();i++){
							Map<String,String> mapClass = commonCourse.getclassInfo(class_margeArrayList.get(i),semester);
							String class_timetale = mapClass.get("timetable");
							ArrayList<ArrayList<String>> class_list = commonCourse.toArrayList(class_timetale, "*", "#");
							String class_str = class_list.get(week_two_i).get(week_two_j);
							String classtime_old = commonCourse.getClasstime(class_timetale);
							if(!"0".equals(class_str) && !"9".equals(class_str)){
								
								class_list.get(week_two_i).set(week_two_j, "0");
								class_list.get(week_one_i).set(week_one_j, String.valueOf((week_one_j+1)));
								class_timetale = commonCourse.toStringfroList(class_list,"*", "#");
								
								
								String classtime_new = commonCourse.getClasstime(class_timetale);		//新得上课时间
								//增加记录
								commonCourse.setLectureLog(teaching_task_one, classtime_old, classtime_new, "class", class_id_one);
								
								//修改班级表
								//commonCourse.updateClassinfo(mapClass_one.get("id"),class_timetable_one);
								commonCourse.updateClassinfo(class_margeArrayList.get(i),class_timetale);
							}else{
								//跳出
								json.put("success", false);
								json.put("resultCode", "2000");
								json.put("msg", "班级冲突");
								responsejson = json.toString();
								out.print(responsejson);
								Page.colseDP(db, page);
								Atm.LogSys("课表调整", "按照教师调整课表", "按照教师调整课表失败,原因:班级冲突不能调整,操作人:"+common.getusernameTouid(info.getUSERID())+"", "0", info.getUSERID(), info.getIp());
								return ;
							}
							
						}
					}else{
						if(!mapClass_one.isEmpty()){
							class_timetable_one = mapClass_one.get("timetable");
							class_list_oneArrayList = commonCourse.toArrayList(class_timetable_one, "*", "#");
							String class_one_str = class_list_oneArrayList.get(week_two_j).get(week_two_j);
							
							String classtime_old = commonCourse.getClasstime(class_timetable_one);
							
							if("1".equals(inspect)){
								class_list_oneArrayList.get(week_two_i).set(week_two_j, "0");
								class_list_oneArrayList.get(week_one_i).set(week_one_j, String.valueOf((week_one_j+1)));
								class_timetable_one = commonCourse.toStringfroList(class_list_oneArrayList,"*", "#");
								
								String classtime_new = commonCourse.getClasstime(class_timetable_one);		//新得上课时间
								//增加记录
								commonCourse.setLectureLog(teaching_task_one, classtime_old, classtime_new, "class", class_id_one);
								
								//修改班级表
								//commonCourse.updateClassinfo(mapClass_one.get("id"),class_timetable_one);
								class_one_state = true;
							}else{
								if(!"0".equals(class_one_str) && !"9".equals(class_one_str)){
									class_list_oneArrayList.get(week_two_i).set(week_two_j, "0");
									class_list_oneArrayList.get(week_one_i).set(week_one_j, String.valueOf((week_one_j+1)));
									class_timetable_one = commonCourse.toStringfroList(class_list_oneArrayList,"*", "#");
									
									
									String classtime_new = commonCourse.getClasstime(class_timetable_one);		//新得上课时间
									//增加记录
									commonCourse.setLectureLog(teaching_task_one, classtime_old, classtime_new, "class", class_id_one);
									
									//修改班级表
									//commonCourse.updateClassinfo(mapClass_one.get("id"),class_timetable_one);
									class_one_state = true;
								}else{
									//跳出
									json.put("success", false);
									json.put("resultCode", "2000");
									json.put("msg", "班级冲突");
									responsejson = json.toString();
									out.print(responsejson);
									Page.colseDP(db, page);
									Atm.LogSys("课表调整", "按照教师调整课表", "按照教师调整课表失败,原因:班级冲突不能调整,操作人:"+common.getusernameTouid(info.getUSERID())+"", "0", info.getUSERID(), info.getIp());
									return ;
								}
							}
						}
					}
					
					//判断是否是two的marge_id
					if(!"0".equals(marge_class_id_two)){
						//存在 循环
						for(int i =0 ; i< class_margeArrayList.size();i++){
							Map<String,String> mapClass = commonCourse.getclassInfo(class_margeArrayList.get(i),semester);
							String class_timetale = mapClass.get("timetable");
							ArrayList<ArrayList<String>> class_list = commonCourse.toArrayList(class_timetale, "*", "#");
							String class_str = class_list.get(week_one_i).get(week_one_j);
							String classtime_old = commonCourse.getClasstime(class_timetale);
							if(!"0".equals(class_str) && !"9".equals(class_str)){
								class_list.get(week_one_i).set(week_one_j, "0");
								class_list.get(week_two_i).set(week_two_j, String.valueOf((week_two_j+1)));
								class_timetale = commonCourse.toStringfroList(class_list,"*", "#");
								
								String classtime_new = commonCourse.getClasstime(class_timetale);		//新得上课时间
								//增加记录
								commonCourse.setLectureLog(teaching_task_two, classtime_old, classtime_new, "class", class_margeArrayList.get(i));
								
								//修改班级表
								//commonCourse.updateClassinfo(mapClass_one.get("id"),class_timetable_one);
								commonCourse.updateClassinfo(class_margeArrayList.get(i),class_timetale);
							}else{
								//跳出
								json.put("success", false);
								json.put("resultCode", "2000");
								json.put("msg", "班级冲突");
								responsejson = json.toString();
								out.print(responsejson);
								Page.colseDP(db, page);
								Atm.LogSys("课表调整", "按照教师调整课表", "按照教师调整课表失败,原因:班级冲突不能调整,操作人:"+common.getusernameTouid(info.getUSERID())+"", "0", info.getUSERID(), info.getIp());
								return ;
							}
						}
					}else{
						if(!mapClass_two.isEmpty()){
							class_timetable_two = mapClass_two.get("timetable");
							class_list_twoArrayList = commonCourse.toArrayList(class_timetable_two, "*", "#");
							String class_two_str = class_list_twoArrayList.get(week_one_i).get(week_one_j);
							String classtime_old = commonCourse.getClasstime(class_timetable_two);
							
							if("1".equals(inspect)){
								//不检查
								class_list_twoArrayList.get(week_one_i).set(week_one_j, "0");
								class_list_twoArrayList.get(week_two_i).set(week_two_j, String.valueOf((week_two_j+1)));
								class_timetable_two = commonCourse.toStringfroList(class_list_twoArrayList, "*", "#");
								
								String classtime_new = commonCourse.getClasstime(class_timetable_two);		//新得上课时间
								//增加记录
								commonCourse.setLectureLog(teaching_task_two, classtime_old, classtime_new, "class", class_id_two);
								
								
								//修改班级表
								//commonCourse.updateClassinfo(mapClass_two.get("id"),class_timetable_two);
								class_two_state = true;
							}else{
								if(!"0".equals(class_two_str) && !"9".equals(class_two_str)){
									class_list_twoArrayList.get(week_one_i).set(week_one_j, "0");
									class_list_twoArrayList.get(week_two_i).set(week_two_j, String.valueOf((week_two_j+1)));
									class_timetable_two = commonCourse.toStringfroList(class_list_twoArrayList, "*", "#");
									
									String classtime_new = commonCourse.getClasstime(class_timetable_two);		//新得上课时间
									//增加记录
									commonCourse.setLectureLog(teaching_task_two, classtime_old, classtime_new, "class", class_id_two);
									
									//修改班级表
									//commonCourse.updateClassinfo(mapClass_two.get("id"),class_timetable_two);
									class_two_state = true;
									
								}else{
									//跳出
									json.put("success", false);
									json.put("resultCode", "2000");
									json.put("msg", "班级冲突");
									responsejson = json.toString();
									out.print(responsejson);
									Page.colseDP(db, page);
									Atm.LogSys("课表调整", "按照教师调整课表", "按照教师调整课表失败,原因:班级冲突不能调整,操作人:"+common.getusernameTouid(info.getUSERID())+"", "0", info.getUSERID(), info.getIp());
									return ;
								}
							}
							
						}
					}
					
					
					
				}
				//修改arrage_details表
				if(!"0".equals(teaching_task_one)&&!"0".equals(teacher_one)){
					if(!"0".equals(marge_class_id_one)){
						for(int i =0 ; i<arrage_coursesystemList.size();i++){
							String select_details_one = getdetailsSql2(arrage_coursesystemList.get(i),teacher_one,class_margeArrayList.get(i));
							ResultSet details_one_set = db.executeQuery(select_details_one);
							String details_time_one = "";
							String details_one_id = "";
							ArrayList<ArrayList<String>> details_one_list = new ArrayList<ArrayList<String>>();
							if(details_one_set.next()){
								details_one_id = details_one_set.getString("id");
								details_time_one = details_one_set.getString("timetable");
							}if(details_one_set!=null){details_one_set.close();}
							details_one_list = commonCourse.toArrayList(details_time_one, "*", "#");
							details_one_list.get(week_two_i).set(week_two_j, "0");
							details_one_list.get(week_one_i).set(week_one_j, String.valueOf((week_one_j+1)));
							details_time_one = commonCourse.toStringfroList(details_one_list, "*","#");
							updateArrageDetailsSql(details_one_id,details_time_one,commonCourse.getClasstime(details_time_one));
						}
					}
					String select_details_one = getdetailsSql2(teaching_task_one,teacher_one,class_id_one);
					ResultSet details_one_set = db.executeQuery(select_details_one);
					String details_time_one = "";
					String details_one_id = "";
					ArrayList<ArrayList<String>> details_one_list = new ArrayList<ArrayList<String>>();
					if(details_one_set.next()){
						details_one_id = details_one_set.getString("id");
						details_time_one = details_one_set.getString("timetable");
					}if(details_one_set!=null){details_one_set.close();}
					details_one_list = commonCourse.toArrayList(details_time_one, "*", "#");
					details_one_list.get(week_two_i).set(week_two_j, "0");
					details_one_list.get(week_one_i).set(week_one_j, String.valueOf((week_one_j+1)));
					details_time_one = commonCourse.toStringfroList(details_one_list, "*","#");
					System.out.println("sqasdad===="+details_time_one);
					updateArrageDetailsSql(details_one_id,details_time_one,commonCourse.getClasstime(details_time_one));
					
				}
				
				
				if(!"0".equals(teaching_task_two)&&!"0".equals(teacher_two)){
					if(!"0".equals(marge_class_id_two)){
						for(int i=0 ; i< arrage_coursesystemList.size();i++){
							String select_details_two = getdetailsSql2(arrage_coursesystemList.get(i),teacher_two,class_margeArrayList.get(i));
							ResultSet details_two_set = db.executeQuery(select_details_two);
							String details_time_two = "";
							String details_two_id = "";
							ArrayList<ArrayList<String>> details_two_list = new ArrayList<ArrayList<String>>();
							if(details_two_set.next()){
								details_two_id = details_two_set.getString("id");
								details_time_two = details_two_set.getString("timetable");
							}if(details_two_set!=null){details_two_set.close();}
							details_two_list = commonCourse.toArrayList(details_time_two, "*", "#");
							details_two_list.get(week_one_i).set(week_one_j, "0");
							details_two_list.get(week_two_i).set(week_two_j, String.valueOf((week_two_j+1)));
							details_time_two = commonCourse.toStringfroList(details_two_list, "*","#");
							updateArrageDetailsSql(details_two_id,details_time_two,commonCourse.getClasstime(details_time_two));
						}
					}
					String select_details_two = getdetailsSql2(teaching_task_two,teacher_two,class_id_two);
					ResultSet details_two_set = db.executeQuery(select_details_two);
					String details_time_two = "";
					String details_two_id = "";
					ArrayList<ArrayList<String>> details_two_list = new ArrayList<ArrayList<String>>();
					if(details_two_set.next()){
						details_two_id = details_two_set.getString("id");
						details_time_two = details_two_set.getString("timetable");
					}if(details_two_set!=null){details_two_set.close();}
					details_two_list = commonCourse.toArrayList(details_time_two, "*", "#");
					details_two_list.get(week_one_i).set(week_one_j, "0");
					details_two_list.get(week_two_i).set(week_two_j, String.valueOf((week_two_j+1)));
					details_time_two = commonCourse.toStringfroList(details_two_list, "*","#");
					updateArrageDetailsSql(details_two_id,details_time_two,commonCourse.getClasstime(details_time_two));
					
				}
				
				//修改教师表
				Map<String,String> mapteacher = commonCourse.getClassroomInfo(classroom,semester);
				ArrayList<ArrayList<String>> teacher_list = new ArrayList<ArrayList<String>>();
				if("0".equals(teaching_task_one)&&(!"0".equals(class_id_two)||!"0".equals(marge_class_id_one))){
					teacher_list = commonCourse.toArrayList(mapteacher.get("timetable"), "*", "#");
					String classtime_old = commonCourse.getClasstime(mapteacher.get("timetable"));
					teacher_list.get(week_one_i).set(week_one_j, "0");
					teacher_list.get(week_two_i).set(week_two_j, String.valueOf((week_two_j+1)));
					
					
					String classtime_new = commonCourse.getClasstime(commonCourse.toStringfroList(teacher_list,"*","#"));		//新得上课时间
					//增加记录
					commonCourse.setLectureLog(teaching_task_two, classtime_old, classtime_new, "teacher", classroom);
					
					
					commonCourse.updateTeacherInfo(mapteacher.get("id"),commonCourse.toStringfroList(teacher_list,"*","#"));
				}else if(!"0".equals(teaching_task_one)&&("0".equals(class_id_two) ||"0".equals(marge_class_id_two) )){
					teacher_list = commonCourse.toArrayList(mapteacher.get("timetable"), "*", "#");
					String classtime_old = commonCourse.getClasstime(mapteacher.get("timetable"));
					
					teacher_list.get(week_two_i).set(week_two_j, "0");
					teacher_list.get(week_one_i).set(week_one_j, String.valueOf((week_one_j+1)));
					
					String classtime_new = commonCourse.getClasstime(commonCourse.toStringfroList(teacher_list,"*","#"));		//新得上课时间
					//增加记录
					commonCourse.setLectureLog(teaching_task_one, classtime_old, classtime_new, "teacher", classroom);
					
					commonCourse.updateTeacherInfo(mapteacher.get("id"),commonCourse.toStringfroList(teacher_list,"*","#"));
				}
				
				
				if(class_one_state){
					commonCourse.updateClassinfo(mapClass_one.get("id"),class_timetable_one);
				}
				if(class_two_state){
					commonCourse.updateClassinfo(mapClass_two.get("id"),class_timetable_two);
				}
				if(teacher_state_one){
					commonCourse.updateTeacherInfo(mapteacherOne.get("id"),teacher_one_timetable);
				}
				if(teacher_state_two){
					commonCourse.updateTeacherInfo(mapteacherTwo.get("id"),teacher_two_timetable);
				}
				
				
				//修改主表的信息
				//one
				String arrage_coursesystem_one = setSql(teaching_task_one);
				ResultSet teaching_task_setResultSet = db.executeQuery(arrage_coursesystem_one);
				String arrage_coursesystem_timetable = "";
				if(teaching_task_setResultSet.next()){
					arrage_coursesystem_timetable = teaching_task_setResultSet.getString("timetable");
				}if(teaching_task_setResultSet!=null){teaching_task_setResultSet.close();}
				
				ArrayList<ArrayList<String>> arrage_coursesystem_timetable_listArrayList = commonCourse.toArrayList(arrage_coursesystem_timetable, "*", "#");
				
				if(!arrage_coursesystem_timetable_listArrayList.isEmpty()){
					arrage_coursesystem_timetable_listArrayList.get(week_two_i).set(week_two_j, "0");
					arrage_coursesystem_timetable_listArrayList.get(week_one_i).set(week_one_j, String.valueOf((week_one_j+1)));
					
					String update_arrage_sql = "	UPDATE arrage_coursesystem  SET timetable = '"+commonCourse.toStringfroList(arrage_coursesystem_timetable_listArrayList,"*","#")+"' WHERE id = '"+teaching_task_one+"' ;	";
					db.executeUpdate(update_arrage_sql);
				}
				
				
				//two
				String arrage_coursesystem_two = setSql(teaching_task_two);
				ResultSet teaching_task__two_setResultSet = db.executeQuery(arrage_coursesystem_two);
				String arrage_coursesystem_two_timetable = "";
				if(teaching_task__two_setResultSet.next()){
					arrage_coursesystem_two_timetable = teaching_task__two_setResultSet.getString("timetable");
				}if(teaching_task__two_setResultSet!=null){teaching_task__two_setResultSet.close();}
				
				ArrayList<ArrayList<String>> arrage_coursesystem_timetable_twoArrayList = commonCourse.toArrayList(arrage_coursesystem_two_timetable, "*", "#");
				if(!arrage_coursesystem_timetable_twoArrayList.isEmpty()){
					arrage_coursesystem_timetable_twoArrayList.get(week_one_i).set(week_one_j, "0");
					arrage_coursesystem_timetable_twoArrayList.get(week_two_i).set(week_two_j, String.valueOf((week_two_j+1)));
					
					String update_arrage_sql = "	UPDATE arrage_coursesystem  SET timetable = '"+commonCourse.toStringfroList(arrage_coursesystem_timetable_twoArrayList,"*","#")+"' WHERE id = '"+teaching_task_two+"' ;	";
					db.executeUpdate(update_arrage_sql);
				}
				
				
				//合班的信息修改
				for(int m = 0 ; m<arrage_coursesystemList.size();m++){
					String arrage_coursesystem = setSql(arrage_coursesystemList.get(m));
					ResultSet teaching_task_base_set = db.executeQuery(arrage_coursesystem);
					String arrage_coursesystem_base_timetable = "";
					if(teaching_task_base_set.next()){
						arrage_coursesystem_base_timetable = teaching_task_base_set.getString("timetable");
					}if(teaching_task_base_set!=null){teaching_task_base_set.close();}
					ArrayList<ArrayList<String>> arrage_coursesystem_timetable_base = commonCourse.toArrayList(arrage_coursesystem_base_timetable, "*", "#");
					if(!"0".equals(marge_class_id_one)){
						if(!arrage_coursesystem_timetable_base.isEmpty()){
							arrage_coursesystem_timetable_base.get(week_two_i).set(week_two_j, "0");
							arrage_coursesystem_timetable_base.get(week_one_i).set(week_one_j, String.valueOf((week_one_j+1)));
							String update_arrage_sql = "	UPDATE arrage_coursesystem  SET timetable = '"+commonCourse.toStringfroList(arrage_coursesystem_timetable_base,"*","#")+"' WHERE id = '"+arrage_coursesystemList.get(m)+"' ;	";
							db.executeUpdate(update_arrage_sql);
						}
						
					}else if(!"0".equals(marge_class_id_two)){
						if(!arrage_coursesystem_timetable_base.isEmpty()){
							arrage_coursesystem_timetable_base.get(week_one_i).set(week_one_j, "0");
							arrage_coursesystem_timetable_base.get(week_two_i).set(week_two_j, String.valueOf((week_two_j+1)));
							
							String update_arrage_sql = "	UPDATE arrage_coursesystem  SET timetable = '"+commonCourse.toStringfroList(arrage_coursesystem_timetable_base,"*","#")+"' WHERE id = '"+arrage_coursesystemList.get(m)+"' ;	";
							db.executeUpdate(update_arrage_sql);
						}
						
					}
				}
				
					
				json.put("success", true);
				json.put("resultCode", "1000");
				json.put("msg", "成功");
				
				responsejson = json.toString();
				out.print(responsejson);
					 
				//记录日志
				long ExeTime = Calendar.getInstance().getTimeInMillis()-info.getTimeStart();
				String InsertSQLlog = "INSERT INTO  ec_appuse_log (`uuid`,`Mdels`,`NetMode`,`GPS`,`GPSLocal`,`username`,`did`,`uid`,`ExeTime`,`classpath`,`classname`,`ip`,`logintime`,`requestjson`,`responsejson`) VALUES ('"+info.getUUID()+"','"+info.getMdels()+"','"	+info.getNetMode()+"','"+info.getGPS()+"','"+info.getGPSLocal()+"','"	+info.getUSERID()+"','"+info.getDID()+"','"+info.getUSERID()+"','"+ExeTime+"','"+claspath+"','"+classname+"','"+info.getIp()+"',now(),'','');";
				db.executeUpdate(InsertSQLlog);
				// 记录日志end     
				Atm.LogSys("课表调整", "按照教室调整课表", "按照教室调整课表完成,操作人:"+common.getusernameTouid(info.getUSERID())+"", "0", info.getUSERID(), info.getIp());
			
			} catch (Exception e) {
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
		
		
		/**
		 * 按照教师调整 课表
		 * @param request
		 * @param response
		 * @param RequestJson
		 * @param info
		 * @param theClassName
		 * @throws ServletException
		 * @throws IOException
		 */
		public void timetableAdjustmentTeacher(HttpServletRequest request, HttpServletResponse response,String RequestJson,InfoEntity info,String theClassName) throws ServletException, IOException {
			
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
	         
	        
	       JSONObject jsonbase = new JSONObject();
	       JSONObject jsonbase1 = new JSONObject();
		   ArrayList list = new ArrayList();
		   ArrayList list1 = new ArrayList();
		   
		   String arrage_coursesid_one = "";
		   String id_one = "";
		   String arrage_coursesid_two = "";
		   String id_two = "";
		   String semester = "";
		   String teacher = "";
		   String inspect = "";
		   
		   commonCourse commonCourse = new commonCourse();
		   common common = new common();
		   
		   try { // 解析开始
			   JSONArray arr = JSONArray.fromObject("[" + RequestJson + "]");
			   for (int i = 0; i < arr.size(); i++) {
				   JSONObject obj = arr.getJSONObject(i);
				    //定义json解析字段列表		
				   arrage_coursesid_one = obj.getString("arrage_coursesid_one");
				   id_one = obj.getString("id_one");
				   arrage_coursesid_two = obj.getString("arrage_coursesid_two");
				   id_two = obj.getString("id_two");
				   semester = obj.getString("semester");
				   teacher = obj.getString("teacher");
				   inspect = obj.getString("inspect");
				   		
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
				//分割星期节次
				String [] weekly_one = id_one.split("_");
				String [] weekly_two = id_two.split("_");
				
				String [] arrays_one = arrage_coursesid_one.split("\\|");
				String [] arrays_two = arrage_coursesid_two.split("\\|");
				
				//1.判断课程是否是替换到空白处
				String teaching_task_one = arrays_one[0];
				String classroomid_one = arrays_one[1];
				String class_id_one  = arrays_one[2];
				
				String teaching_task_two = arrays_two[0];
				String classroomid_two = arrays_two[1];
				String class_id_two = arrays_two[2];
				
				int week_one_i = Integer.valueOf(weekly_one[0]);			//星期下表
				int week_one_j = Integer.valueOf(weekly_one[1]);			//节次下表
				
				
				int week_two_i = Integer.valueOf(weekly_two[0]);			//星期下表
				int week_two_j = Integer.valueOf(weekly_two[1]);			//节次下表
				
				
				//判断获取的teaching_task_one 和teaching_task_two
				
				String teaching_task_one_sql = "select marge_class_id from arrage_coursesystem where id = '"+teaching_task_one+"'";
				String marge_class_id_one = "0";
				
				String teaching_task_two_sql = "select marge_class_id from arrage_coursesystem where id = '"+teaching_task_two+"'";
				String marge_class_id_two = "0";
				
				ResultSet teaching_task_one_sql_setResultSet = db.executeQuery(teaching_task_one_sql);
				if(teaching_task_one_sql_setResultSet.next()){
					marge_class_id_one = teaching_task_one_sql_setResultSet.getString("marge_class_id");
				}if(teaching_task_one_sql_setResultSet!=null){teaching_task_one_sql_setResultSet.close();}
				
				ResultSet teaching_task_two_sql_setResultSet = db.executeQuery(teaching_task_two_sql);
				if(teaching_task_two_sql_setResultSet.next()){
					marge_class_id_two = teaching_task_two_sql_setResultSet.getString("marge_class_id");
				}if(teaching_task_two_sql_setResultSet!=null){teaching_task_two_sql_setResultSet.close();}
				
				//判断合班是否存在
				ArrayList<String> class_margeArrayList = new ArrayList<String>();
				ArrayList<String> arrage_coursesystemList = new ArrayList<String>();
				if(!"0".equals(marge_class_id_one)){
					String marge_sqlString = "SELECT																			"+
							"		  arrage_coursesystem.id,                                                                   "+
							"		  class_id                                                                                  "+
							"		FROM teaching_tesk_marge                                                                    "+
							"		  LEFT JOIN arrage_coursesystem                                                             "+
							"		    ON teaching_tesk_marge.teaching_task_id = arrage_coursesystem.teaching_task_id          "+
							"		WHERE teaching_tesk_marge.marge_class_id = '"+marge_class_id_one+"'";
					ResultSet class_marge_setResultSet = db.executeQuery(marge_sqlString);
					while(class_marge_setResultSet.next()){
						class_margeArrayList.add(class_marge_setResultSet.getString("class_id"));
						arrage_coursesystemList.add(class_marge_setResultSet.getString("id"));
					}if(class_marge_setResultSet!=null){class_marge_setResultSet.close();}
				}
				
				if(!"0".equals(marge_class_id_two)){
					String marge_sql_two = "SELECT																			"+
					"		  arrage_coursesystem.id,                                                                   "+
					"		  class_id                                                                                  "+
					"		FROM teaching_tesk_marge                                                                    "+
					"		  LEFT JOIN arrage_coursesystem                                                             "+
					"		    ON teaching_tesk_marge.teaching_task_id = arrage_coursesystem.teaching_task_id          "+
					"		WHERE teaching_tesk_marge.marge_class_id = '"+marge_class_id_two+"'";
					ResultSet class_marge_setResultSet = db.executeQuery(marge_sql_two);
					while(class_marge_setResultSet.next()){
						class_margeArrayList.add(class_marge_setResultSet.getString("class_id"));
						arrage_coursesystemList.add(class_marge_setResultSet.getString("id"));
					}if(class_marge_setResultSet!=null){class_marge_setResultSet.close();}
				}
				
				
				
				
				if(class_id_one.equals(class_id_two)&&classroomid_one.equals(classroomid_two)){
					json.put("success", false);
					json.put("resultCode", "2000");
					json.put("msg", "班级和教室都是相同的，不能转换");
					responsejson = json.toString();
					out.print(responsejson);
					Page.colseDP(db, page);
					return ;
				}
				
				
				
				//找到教室所占时间
				ArrayList<ArrayList<String>> classroom_list_oneArrayList = new ArrayList<ArrayList<String>>();
				ArrayList<ArrayList<String>> classroom_list_twoArrayList = new ArrayList<ArrayList<String>>();
				
				
				Map<String,String> mapClassroomOne = commonCourse.getClassroomInfo(classroomid_one,semester);
				Map<String,String> mapClassroomTwo = commonCourse.getClassroomInfo(classroomid_two,semester);
				String classroom_one_timetable = "";
				String classroom_two_timetable = "";
				boolean classroom_state_one = false;
				boolean classroom_state_two = false;
				if(!classroomid_one.equals(classroomid_two)){
					if(!mapClassroomOne.isEmpty()){
						classroom_one_timetable = mapClassroomOne.get("timetable");
						classroom_list_oneArrayList = commonCourse.toArrayList(classroom_one_timetable, "*", "#");
						String classroom_str = classroom_list_oneArrayList.get(week_two_i).get(week_two_j);
						
						String classtime_old = commonCourse.getClasstime(classroom_one_timetable);
						
						if("1".equals(inspect)){
							classroom_list_oneArrayList.get(week_two_i).set(week_two_j, "0");
							classroom_list_oneArrayList.get(week_one_i).set(week_one_j, String.valueOf((week_one_j+1)));
							classroom_one_timetable = commonCourse.toStringfroList(classroom_list_oneArrayList, "*","#");
							
							String classtime_new = commonCourse.getClasstime(classroom_one_timetable);		//新得上课时间
							//增加记录
							commonCourse.setLectureLog(teaching_task_one, classtime_old, classtime_new, "classroom", classroomid_one);
							
							//修改教室
							//commonCourse.updateClassroom(mapClassroomOne.get("id"),classroom_one_timetable);
							classroom_state_one = true;
						}else{
							if(!"0".equals(classroom_str) && !"9".equals(classroom_str)){
								classroom_list_oneArrayList.get(week_two_i).set(week_two_j, "0");
								classroom_list_oneArrayList.get(week_one_i).set(week_one_j, String.valueOf((week_one_j+1)));
								classroom_one_timetable = commonCourse.toStringfroList(classroom_list_oneArrayList, "*","#");
								
								String classtime_new = commonCourse.getClasstime(classroom_one_timetable);		//新得上课时间
								//增加记录
								commonCourse.setLectureLog(teaching_task_one, classtime_old, classtime_new, "classroom", classroomid_one);
								
								//修改教室
								//commonCourse.updateClassroom(mapClassroomOne.get("id"),classroom_one_timetable);
								classroom_state_one = true;
							}else{
								//跳出
								json.put("success", false);
								json.put("resultCode", "2000");
								json.put("msg", "教室冲突");
								responsejson = json.toString();
								out.print(responsejson);
								Page.colseDP(db, page);
								Atm.LogSys("课表调整", "按照教师调整课表", "按照教师调整课表失败,原因:教室冲突不能调整,操作人:"+common.getusernameTouid(info.getUSERID())+"", "0", info.getUSERID(), info.getIp());
								return ;
							}
						}
					}
					
					if(!mapClassroomTwo.isEmpty()){
						classroom_two_timetable = mapClassroomTwo.get("timetable");
						classroom_list_twoArrayList = commonCourse.toArrayList(classroom_two_timetable, "*", "#");
						String classroom_str = classroom_list_twoArrayList.get(week_one_i).get(week_one_j);
						
						String classtime_old = commonCourse.getClasstime(classroom_two_timetable);
						
						if("1".equals(inspect)){
							classroom_list_twoArrayList.get(week_one_i).set(week_one_j, "0");
							classroom_list_twoArrayList.get(week_two_i).set(week_two_j, String.valueOf(week_two_j+1));
							classroom_two_timetable = commonCourse.toStringfroList(classroom_list_twoArrayList, "*","#");
							
							
							String classtime_new = commonCourse.getClasstime(classroom_two_timetable);		//新得上课时间
							//增加记录
							commonCourse.setLectureLog(teaching_task_two, classtime_old, classtime_new, "classroom", classroomid_two);
							
							
							//修改教室
							//commonCourse.updateClassroom(mapClassroomTwo.get("id"),classroom_two_timetable);
							classroom_state_two = true;
						}else{
							if(!"0".equals(classroom_str)  &&  !"9".equals(classroom_str)){
								classroom_list_twoArrayList.get(week_one_i).set(week_one_j, "0");
								classroom_list_twoArrayList.get(week_two_i).set(week_two_j, String.valueOf(week_two_j+1));
								classroom_two_timetable = commonCourse.toStringfroList(classroom_list_twoArrayList, "*","#");
								
								
								String classtime_new = commonCourse.getClasstime(classroom_two_timetable);		//新得上课时间
								//增加记录
								commonCourse.setLectureLog(teaching_task_two, classtime_old, classtime_new, "classroom", classroomid_two);
								
								
								//修改教室
								//commonCourse.updateClassroom(mapClassroomTwo.get("id"),classroom_two_timetable);
								classroom_state_two = true;
							}else{
								//跳出
								json.put("success", false);
								json.put("resultCode", "2000");
								json.put("msg", "教室冲突");
								responsejson = json.toString();
								out.print(responsejson);
								Page.colseDP(db, page);
								Atm.LogSys("课表调整", "按照教师调整课表", "按照教师调整课表失败,原因:教室冲突不能调整,操作人:"+common.getusernameTouid(info.getUSERID())+"", "0", info.getUSERID(), info.getIp());
								return ;
							}
						}
						
					}
					
				}
				//班级查找
				Map<String,String> mapClass_one = commonCourse.getclassInfo(class_id_one,semester);
				ArrayList<ArrayList<String>> class_list_oneArrayList = new ArrayList<ArrayList<String>>();
				String class_timetable_one = "";
				boolean class_one_state = false;
				
				Map<String, String> mapClass_two = commonCourse.getclassInfo(class_id_two, semester);
				ArrayList<ArrayList<String>> class_list_twoArrayList = new ArrayList<ArrayList<String>>();
				String class_timetable_two = "";
				boolean class_two_state = false;
				if(!class_id_one.equals(class_id_two)){
					
					//判断marge是否存在
					if(!"0".equals(marge_class_id_one)){
						//存在 循环
						for(int i =0 ; i< class_margeArrayList.size();i++){
							Map<String,String> mapClass = commonCourse.getclassInfo(class_margeArrayList.get(i),semester);
							String class_timetale = mapClass.get("timetable");
							ArrayList<ArrayList<String>> class_list = commonCourse.toArrayList(class_timetale, "*", "#");
							String class_str = class_list.get(week_two_i).get(week_two_j);
							String classtime_old = commonCourse.getClasstime(class_timetale);
							if(!"0".equals(class_str) && !"9".equals(class_str)){
								
								class_list.get(week_two_i).set(week_two_j, "0");
								class_list.get(week_one_i).set(week_one_j, String.valueOf((week_one_j+1)));
								class_timetale = commonCourse.toStringfroList(class_list,"*", "#");
								
								
								String classtime_new = commonCourse.getClasstime(class_timetale);		//新得上课时间
								//增加记录
								commonCourse.setLectureLog(teaching_task_one, classtime_old, classtime_new, "class", class_id_one);
								
								//修改班级表
								//commonCourse.updateClassinfo(mapClass_one.get("id"),class_timetable_one);
								commonCourse.updateClassinfo(class_margeArrayList.get(i),class_timetale);
							}else{
								//跳出
								json.put("success", false);
								json.put("resultCode", "2000");
								json.put("msg", "班级冲突");
								responsejson = json.toString();
								out.print(responsejson);
								Page.colseDP(db, page);
								Atm.LogSys("课表调整", "按照教师调整课表", "按照教师调整课表失败,原因:班级冲突不能调整,操作人:"+common.getusernameTouid(info.getUSERID())+"", "0", info.getUSERID(), info.getIp());
								return ;
							}
							
						}
					}else{
						if(!mapClass_one.isEmpty()){
							class_timetable_one = mapClass_one.get("timetable");
							class_list_oneArrayList = commonCourse.toArrayList(class_timetable_one, "*", "#");
							String class_one_str = class_list_oneArrayList.get(week_two_j).get(week_two_j);
							
							String classtime_old = commonCourse.getClasstime(class_timetable_one);
							
							if("1".equals(inspect)){
								class_list_oneArrayList.get(week_two_i).set(week_two_j, "0");
								class_list_oneArrayList.get(week_one_i).set(week_one_j, String.valueOf((week_one_j+1)));
								class_timetable_one = commonCourse.toStringfroList(class_list_oneArrayList,"*", "#");
								
								String classtime_new = commonCourse.getClasstime(class_timetable_one);		//新得上课时间
								//增加记录
								commonCourse.setLectureLog(teaching_task_one, classtime_old, classtime_new, "class", class_id_one);
								
								//修改班级表
								//commonCourse.updateClassinfo(mapClass_one.get("id"),class_timetable_one);
								class_one_state = true;
							}else{
								if(!"0".equals(class_one_str) && !"9".equals(class_one_str)){
									class_list_oneArrayList.get(week_two_i).set(week_two_j, "0");
									class_list_oneArrayList.get(week_one_i).set(week_one_j, String.valueOf((week_one_j+1)));
									class_timetable_one = commonCourse.toStringfroList(class_list_oneArrayList,"*", "#");
									
									
									String classtime_new = commonCourse.getClasstime(class_timetable_one);		//新得上课时间
									//增加记录
									commonCourse.setLectureLog(teaching_task_one, classtime_old, classtime_new, "class", class_id_one);
									
									//修改班级表
									//commonCourse.updateClassinfo(mapClass_one.get("id"),class_timetable_one);
									class_one_state = true;
								}else{
									//跳出
									json.put("success", false);
									json.put("resultCode", "2000");
									json.put("msg", "班级冲突");
									responsejson = json.toString();
									out.print(responsejson);
									Page.colseDP(db, page);
									Atm.LogSys("课表调整", "按照教师调整课表", "按照教师调整课表失败,原因:班级冲突不能调整,操作人:"+common.getusernameTouid(info.getUSERID())+"", "0", info.getUSERID(), info.getIp());
									return ;
								}
							}
						}
					}
					
					//判断是否是two的marge_id
					if(!"0".equals(marge_class_id_two)){
						//存在 循环
						for(int i =0 ; i< class_margeArrayList.size();i++){
							Map<String,String> mapClass = commonCourse.getclassInfo(class_margeArrayList.get(i),semester);
							String class_timetale = mapClass.get("timetable");
							ArrayList<ArrayList<String>> class_list = commonCourse.toArrayList(class_timetale, "*", "#");
							String class_str = class_list.get(week_one_i).get(week_one_j);
							String classtime_old = commonCourse.getClasstime(class_timetale);
							if(!"0".equals(class_str) && !"9".equals(class_str)){
								class_list.get(week_one_i).set(week_one_j, "0");
								class_list.get(week_two_i).set(week_two_j, String.valueOf((week_two_j+1)));
								class_timetale = commonCourse.toStringfroList(class_list,"*", "#");
								
								String classtime_new = commonCourse.getClasstime(class_timetale);		//新得上课时间
								//增加记录
								commonCourse.setLectureLog(teaching_task_two, classtime_old, classtime_new, "class", class_margeArrayList.get(i));
								
								//修改班级表
								//commonCourse.updateClassinfo(mapClass_one.get("id"),class_timetable_one);
								commonCourse.updateClassinfo(class_margeArrayList.get(i),class_timetale);
							}else{
								//跳出
								json.put("success", false);
								json.put("resultCode", "2000");
								json.put("msg", "班级冲突");
								responsejson = json.toString();
								out.print(responsejson);
								Page.colseDP(db, page);
								Atm.LogSys("课表调整", "按照教师调整课表", "按照教师调整课表失败,原因:班级冲突不能调整,操作人:"+common.getusernameTouid(info.getUSERID())+"", "0", info.getUSERID(), info.getIp());
								return ;
							}
						}
					}else{
						if(!mapClass_two.isEmpty()){
							class_timetable_two = mapClass_two.get("timetable");
							class_list_twoArrayList = commonCourse.toArrayList(class_timetable_two, "*", "#");
							String class_two_str = class_list_twoArrayList.get(week_one_i).get(week_one_j);
							String classtime_old = commonCourse.getClasstime(class_timetable_two);
							
							if("1".equals(inspect)){
								//不检查
								class_list_twoArrayList.get(week_one_i).set(week_one_j, "0");
								class_list_twoArrayList.get(week_two_i).set(week_two_j, String.valueOf((week_two_j+1)));
								class_timetable_two = commonCourse.toStringfroList(class_list_twoArrayList, "*", "#");
								
								String classtime_new = commonCourse.getClasstime(class_timetable_two);		//新得上课时间
								//增加记录
								commonCourse.setLectureLog(teaching_task_two, classtime_old, classtime_new, "class", class_id_two);
								
								
								//修改班级表
								//commonCourse.updateClassinfo(mapClass_two.get("id"),class_timetable_two);
								class_two_state = true;
							}else{
								if(!"0".equals(class_two_str) && !"9".equals(class_two_str)){
									class_list_twoArrayList.get(week_one_i).set(week_one_j, "0");
									class_list_twoArrayList.get(week_two_i).set(week_two_j, String.valueOf((week_two_j+1)));
									class_timetable_two = commonCourse.toStringfroList(class_list_twoArrayList, "*", "#");
									
									String classtime_new = commonCourse.getClasstime(class_timetable_two);		//新得上课时间
									//增加记录
									commonCourse.setLectureLog(teaching_task_two, classtime_old, classtime_new, "class", class_id_two);
									
									//修改班级表
									//commonCourse.updateClassinfo(mapClass_two.get("id"),class_timetable_two);
									class_two_state = true;
									
								}else{
									//跳出
									json.put("success", false);
									json.put("resultCode", "2000");
									json.put("msg", "班级冲突");
									responsejson = json.toString();
									out.print(responsejson);
									Page.colseDP(db, page);
									Atm.LogSys("课表调整", "按照教师调整课表", "按照教师调整课表失败,原因:班级冲突不能调整,操作人:"+common.getusernameTouid(info.getUSERID())+"", "0", info.getUSERID(), info.getIp());
									return ;
								}
							}
							
						}
					}
					
					
					
				}
				
				
				//修改arrage_details表
				if(!"0".equals(teaching_task_one)&&!"0".equals(classroomid_one)&&!"0".equals(class_id_one)){
					
					if(!"0".equals(marge_class_id_one)){
						for(int i =0 ; i<arrage_coursesystemList.size();i++){
							String select_details_one = getdetailsSql1(arrage_coursesystemList.get(i),classroomid_one,class_margeArrayList.get(i));
							ResultSet details_one_set = db.executeQuery(select_details_one);
							String details_time_one = "";
							String details_one_id = "";
							ArrayList<ArrayList<String>> details_one_list = new ArrayList<ArrayList<String>>();
							if(details_one_set.next()){
								details_one_id = details_one_set.getString("id");
								details_time_one = details_one_set.getString("timetable");
							}if(details_one_set!=null){details_one_set.close();}
							details_one_list = commonCourse.toArrayList(details_time_one, "*", "#");
							details_one_list.get(week_two_i).set(week_two_j, "0");
							details_one_list.get(week_one_i).set(week_one_j, String.valueOf((week_one_j+1)));
							details_time_one = commonCourse.toStringfroList(details_one_list, "*","#");
							updateArrageDetailsSql(details_one_id,details_time_one,commonCourse.getClasstime(details_time_one));
						}
					}
					String select_details_one = getdetailsSql1(teaching_task_one,classroomid_one,class_id_one);
					ResultSet details_one_set = db.executeQuery(select_details_one);
					String details_time_one = "";
					String details_one_id = "";
					ArrayList<ArrayList<String>> details_one_list = new ArrayList<ArrayList<String>>();
					if(details_one_set.next()){
						details_one_id = details_one_set.getString("id");
						details_time_one = details_one_set.getString("timetable");
					}if(details_one_set!=null){details_one_set.close();}
					details_one_list = commonCourse.toArrayList(details_time_one, "*", "#");
					details_one_list.get(week_two_i).set(week_two_j, "0");
					details_one_list.get(week_one_i).set(week_one_j, String.valueOf((week_one_j+1)));
					details_time_one = commonCourse.toStringfroList(details_one_list, "*","#");
					updateArrageDetailsSql(details_one_id,details_time_one,commonCourse.getClasstime(details_time_one));
					
				}
				
				if(!"0".equals(teaching_task_two)&&!"0".equals(classroomid_two)&&!"0".equals(class_id_two)){
					if(!"0".equals(marge_class_id_two)){
						for(int i=0 ; i< arrage_coursesystemList.size();i++){
							String select_details_two = getdetailsSql1(arrage_coursesystemList.get(i),classroomid_two,class_margeArrayList.get(i));
							ResultSet details_two_set = db.executeQuery(select_details_two);
							String details_time_two = "";
							String details_two_id = "";
							ArrayList<ArrayList<String>> details_two_list = new ArrayList<ArrayList<String>>();
							if(details_two_set.next()){
								details_two_id = details_two_set.getString("id");
								details_time_two = details_two_set.getString("timetable");
							}if(details_two_set!=null){details_two_set.close();}
							details_two_list = commonCourse.toArrayList(details_time_two, "*", "#");
							details_two_list.get(week_one_i).set(week_one_j, "0");
							details_two_list.get(week_two_i).set(week_two_j, String.valueOf((week_two_j+1)));
							details_time_two = commonCourse.toStringfroList(details_two_list, "*","#");
							updateArrageDetailsSql(details_two_id,details_time_two,commonCourse.getClasstime(details_time_two));
						}
					}
					String select_details_two = getdetailsSql1(teaching_task_two,classroomid_two,class_id_two);
					ResultSet details_two_set = db.executeQuery(select_details_two);
					String details_time_two = "";
					String details_two_id = "";
					ArrayList<ArrayList<String>> details_two_list = new ArrayList<ArrayList<String>>();
					if(details_two_set.next()){
						details_two_id = details_two_set.getString("id");
						details_time_two = details_two_set.getString("timetable");
					}if(details_two_set!=null){details_two_set.close();}
					details_two_list = commonCourse.toArrayList(details_time_two, "*", "#");
					details_two_list.get(week_one_i).set(week_one_j, "0");
					details_two_list.get(week_two_i).set(week_two_j, String.valueOf((week_two_j+1)));
					details_time_two = commonCourse.toStringfroList(details_two_list, "*","#");
					updateArrageDetailsSql(details_two_id,details_time_two,commonCourse.getClasstime(details_time_two));
					
				}
				
				//修改教师表
				Map<String,String> mapteacher = commonCourse.getTeacherinfo(teacher,semester);
				ArrayList<ArrayList<String>> teacher_list = new ArrayList<ArrayList<String>>();
				if("0".equals(teaching_task_one)&&!"0".equals(class_id_two)){
					teacher_list = commonCourse.toArrayList(mapteacher.get("timetable"), "*", "#");
					String classtime_old = commonCourse.getClasstime(mapteacher.get("timetable"));
					teacher_list.get(week_one_i).set(week_one_j, "0");
					teacher_list.get(week_two_i).set(week_two_j, String.valueOf((week_two_j+1)));
					
					
					String classtime_new = commonCourse.getClasstime(commonCourse.toStringfroList(teacher_list,"*","#"));		//新得上课时间
					//增加记录
					commonCourse.setLectureLog(teaching_task_two, classtime_old, classtime_new, "teacher", teacher);
					
					
					commonCourse.updateTeacherInfo(mapteacher.get("id"),commonCourse.toStringfroList(teacher_list,"*","#"));
				}else if(!"0".equals(teaching_task_one)&&"0".equals(class_id_two)){
					teacher_list = commonCourse.toArrayList(mapteacher.get("timetable"), "*", "#");
					String classtime_old = commonCourse.getClasstime(mapteacher.get("timetable"));
					
					teacher_list.get(week_two_i).set(week_two_j, "0");
					teacher_list.get(week_one_i).set(week_one_j, String.valueOf((week_one_j+1)));
					
					String classtime_new = commonCourse.getClasstime(commonCourse.toStringfroList(teacher_list,"*","#"));		//新得上课时间
					//增加记录
					commonCourse.setLectureLog(teaching_task_one, classtime_old, classtime_new, "teacher", teacher);
					
					commonCourse.updateTeacherInfo(mapteacher.get("id"),commonCourse.toStringfroList(teacher_list,"*","#"));
				}
				
				
				if(class_one_state){
					commonCourse.updateClassinfo(mapClass_one.get("id"),class_timetable_one);
				}
				if(class_two_state){
					commonCourse.updateClassinfo(mapClass_two.get("id"),class_timetable_two);
				}
				if(classroom_state_one){
					commonCourse.updateClassroom(mapClassroomOne.get("id"),classroom_one_timetable);
				}
				if(classroom_state_two){
					commonCourse.updateClassroom(mapClassroomTwo.get("id"),classroom_two_timetable);
				}
				
				
				//修改主表的信息
				//one
				String arrage_coursesystem_one = setSql(teaching_task_one);
				ResultSet teaching_task_setResultSet = db.executeQuery(arrage_coursesystem_one);
				String arrage_coursesystem_timetable = "";
				if(teaching_task_setResultSet.next()){
					arrage_coursesystem_timetable = teaching_task_setResultSet.getString("timetable");
				}if(teaching_task_setResultSet!=null){teaching_task_setResultSet.close();}
				
				ArrayList<ArrayList<String>> arrage_coursesystem_timetable_listArrayList = commonCourse.toArrayList(arrage_coursesystem_timetable, "*", "#");
				
				if(!arrage_coursesystem_timetable_listArrayList.isEmpty()){
					arrage_coursesystem_timetable_listArrayList.get(week_two_i).set(week_two_j, "0");
					arrage_coursesystem_timetable_listArrayList.get(week_one_i).set(week_one_j, String.valueOf((week_one_j+1)));
					
					String update_arrage_sql = "	UPDATE arrage_coursesystem  SET timetable = '"+commonCourse.toStringfroList(arrage_coursesystem_timetable_listArrayList,"*","#")+"' WHERE id = '"+teaching_task_one+"' ;	";
					db.executeUpdate(update_arrage_sql);
				}
				
				
				//two
				String arrage_coursesystem_two = setSql(teaching_task_two);
				ResultSet teaching_task__two_setResultSet = db.executeQuery(arrage_coursesystem_two);
				String arrage_coursesystem_two_timetable = "";
				if(teaching_task__two_setResultSet.next()){
					arrage_coursesystem_two_timetable = teaching_task__two_setResultSet.getString("timetable");
				}if(teaching_task__two_setResultSet!=null){teaching_task__two_setResultSet.close();}
				
				ArrayList<ArrayList<String>> arrage_coursesystem_timetable_twoArrayList = commonCourse.toArrayList(arrage_coursesystem_two_timetable, "*", "#");
				if(!arrage_coursesystem_timetable_twoArrayList.isEmpty()){
					arrage_coursesystem_timetable_twoArrayList.get(week_one_i).set(week_one_j, "0");
					arrage_coursesystem_timetable_twoArrayList.get(week_two_i).set(week_two_j, String.valueOf((week_two_j+1)));
					
					String update_arrage_sql = "	UPDATE arrage_coursesystem  SET timetable = '"+commonCourse.toStringfroList(arrage_coursesystem_timetable_twoArrayList,"*","#")+"' WHERE id = '"+teaching_task_two+"' ;	";
					db.executeUpdate(update_arrage_sql);
				}
				
				
				//合班的信息修改
				for(int m = 0 ; m<arrage_coursesystemList.size();m++){
					String arrage_coursesystem = setSql(arrage_coursesystemList.get(m));
					ResultSet teaching_task_base_set = db.executeQuery(arrage_coursesystem);
					String arrage_coursesystem_base_timetable = "";
					if(teaching_task_base_set.next()){
						arrage_coursesystem_base_timetable = teaching_task_base_set.getString("timetable");
					}if(teaching_task_base_set!=null){teaching_task_base_set.close();}
					ArrayList<ArrayList<String>> arrage_coursesystem_timetable_base = commonCourse.toArrayList(arrage_coursesystem_base_timetable, "*", "#");
					if(!"0".equals(marge_class_id_one)){
						if(!arrage_coursesystem_timetable_base.isEmpty()){
							arrage_coursesystem_timetable_base.get(week_two_i).set(week_two_j, "0");
							arrage_coursesystem_timetable_base.get(week_one_i).set(week_one_j, String.valueOf((week_one_j+1)));
							String update_arrage_sql = "	UPDATE arrage_coursesystem  SET timetable = '"+commonCourse.toStringfroList(arrage_coursesystem_timetable_base,"*","#")+"' WHERE id = '"+arrage_coursesystemList.get(m)+"' ;	";
							db.executeUpdate(update_arrage_sql);
						}
						
					}else if(!"0".equals(marge_class_id_two)){
						if(!arrage_coursesystem_timetable_base.isEmpty()){
							arrage_coursesystem_timetable_base.get(week_one_i).set(week_one_j, "0");
							arrage_coursesystem_timetable_base.get(week_two_i).set(week_two_j, String.valueOf((week_two_j+1)));
							
							String update_arrage_sql = "	UPDATE arrage_coursesystem  SET timetable = '"+commonCourse.toStringfroList(arrage_coursesystem_timetable_base,"*","#")+"' WHERE id = '"+arrage_coursesystemList.get(m)+"' ;	";
							db.executeUpdate(update_arrage_sql);
						}
						
					}
				}
				
					
				json.put("success", true);
				json.put("resultCode", "1000");
				json.put("msg", "成功");
				
				responsejson = json.toString();
				out.print(responsejson);
					 
				//记录日志
				long ExeTime = Calendar.getInstance().getTimeInMillis()-info.getTimeStart();
				String InsertSQLlog = "INSERT INTO  ec_appuse_log (`uuid`,`Mdels`,`NetMode`,`GPS`,`GPSLocal`,`username`,`did`,`uid`,`ExeTime`,`classpath`,`classname`,`ip`,`logintime`,`requestjson`,`responsejson`) VALUES ('"+info.getUUID()+"','"+info.getMdels()+"','"	+info.getNetMode()+"','"+info.getGPS()+"','"+info.getGPSLocal()+"','"	+info.getUSERID()+"','"+info.getDID()+"','"+info.getUSERID()+"','"+ExeTime+"','"+claspath+"','"+classname+"','"+info.getIp()+"',now(),'','');";
				db.executeUpdate(InsertSQLlog);
				// 记录日志end     
				Atm.LogSys("课表调整", "按照教师调整课表", "按照教师调整课表完成,操作人:"+common.getusernameTouid(info.getUSERID())+"", "0", info.getUSERID(), info.getIp());
			
			} catch (Exception e) {
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
		
		
		/**
		 * 获取全校性课表按班级
		 * @param request
		 * @param response
		 * @param RequestJson
		 * @param info
		 * @param theClassName
		 * @throws ServletException
		 * @throws IOException
		 */
		public void getAllSchoolTimetable(HttpServletRequest request, HttpServletResponse response,String RequestJson,InfoEntity info,String theClassName) throws ServletException, IOException {
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
	         
	        
	       JSONObject jsonbase = new JSONObject();
		   ArrayList list = new ArrayList();
		   
		   //"xueqi":xueqi,"ruxue":ruxue,"major":major,"department":department,"xiaoqu":xiaoqu
		   commonCourse commonCourse = new commonCourse();
		   common common = new common();
		   
		   String xueqi = "";			//学期
		   String xiaoqu = "";			//校区
		   String ruxue = "";			//入学年份
		   String major = "";			//专业
		   String department = "";		//院系
		   String zhouci = "";			//周次
		   
		   try { // 解析开始
			   JSONArray arr = JSONArray.fromObject("[" + RequestJson + "]");
			   for (int i = 0; i < arr.size(); i++) {
				   JSONObject obj = arr.getJSONObject(i);
				    //定义json解析字段列表		
				   xueqi = obj.getString("xueqi");
				   xiaoqu = obj.getString("xiaoqu");
				   ruxue = obj.getString("ruxue");
				   major = obj.getString("major");
				   department = obj.getString("department");
				   zhouci = obj.getString("zhouci");
				   		
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
			
			
			String sqlwhere = "";
			if(!"0".equals(ruxue)){
				sqlwhere += "	AND  class_grade.school_year = '"+ruxue+"'";
			}
			if(!"0".equals(department)){
				sqlwhere += "	AND  dict_departments_id = '"+department+"'";
			}
			if(!"0".equals(major)){
				sqlwhere += "	AND  major_id = '"+major+"'";
			}
			
			String class_sql = "SELECT										"+
					"			  classid,                                  "+
					"			  class_grade.class_name AS class_name      "+
					"			FROM arrange_sys_class                         "+
					"			  LEFT JOIN class_grade                     "+
					"			    ON arrange_sys_class.classid = class_grade.id             "+
					"			where 1=1 AND arrange_sys_class.semester='"+xueqi+"' 	"+ sqlwhere+"				";
			ResultSet classSet = db.executeQuery(class_sql);
			
			JSONObject jsonbase1 = new JSONObject();
			ArrayList list1 = new ArrayList();
			
			
			try {
				
				//查找class_id
				while(classSet.next()){
					JSONObject jsonbase2 = new JSONObject();
					ArrayList list2 = new ArrayList();
					jsonbase1.put("classname", classSet.getString("class_name"));
					
					String sql_detailes = "SELECT																		"+
									"		  dict_courses.course_name,                                                 "+
									"		  dict_courses.course_code,                                                 "+
									"		  classroom.classroomname AS classroomname,                                 "+
									"		  IFNULL(people_number_nan,0)+ IFNULL(people_number_woman,0) AS totle,      "+
									"			weeks,					"+
									"		  arrage_details.timetable,                                                                "+
									"			class_grade.class_name as class_name,"+
									"			classtime,												"+
									"		teacher_basic.teacher_name								"+
									"		FROM arrage_details                                                         "+
									"		  LEFT JOIN dict_courses                                                    "+
									"		    ON dict_courses.id = arrage_details.course_id                           "+
									"		    LEFT JOIN classroom ON arrage_details.classroomid = classroom.id        "+
									"			LEFT JOIN teacher_basic ON arrage_details.teacher_id = teacher_basic.id	"+
									"		    LEFT JOIN class_grade ON classid = class_grade.id                       "+
									"			LEFT JOIN arrage_coursesystem ON arrage_details.arrage_coursesystem_id = arrage_coursesystem.id		"+
									"		WHERE classid = '"+classSet.getString("classid")+"'		AND arrage_coursesystem.semester='"+xueqi+"' ;";
					
					ResultSet detailsSet = db.executeQuery(sql_detailes);
					while(detailsSet.next()){
						jsonbase2.put("course_name", detailsSet.getString("dict_courses.course_name"));
						jsonbase2.put("course_code", detailsSet.getString("dict_courses.course_code"));
						jsonbase2.put("classroomname", detailsSet.getString("classroomname"));
						jsonbase2.put("totle", detailsSet.getString("totle"));
						jsonbase2.put("timetable", commonCourse.toArrayList(detailsSet.getString("timetable"),"*","#"));
						jsonbase2.put("weeks", detailsSet.getString("weeks"));
						jsonbase2.put("teachername", detailsSet.getString("teacher_name"));
						jsonbase2.put("classtime", detailsSet.getString("classtime"));
						jsonbase2.put("class_name", detailsSet.getString("class_name"));
						list2.add(jsonbase2.toString());
					}if(detailsSet!=null){detailsSet.close();}
					jsonbase1.put("data_detailes", list2.toString());
					
					list1.add(jsonbase1.toString());
				}if(classSet!=null){classSet.close();}
				
				
				
				json.put("success", true);
				json.put("resultCode", "1000");
				json.put("msg", "成功");
				json.put("data", list1.toString());
				
				System.out.println("jison==="+json.toString());
				responsejson = json.toString();
				out.print(responsejson);
					 
				//记录日志
				long ExeTime = Calendar.getInstance().getTimeInMillis()-info.getTimeStart();
				String InsertSQLlog = "INSERT INTO  ec_appuse_log (`uuid`,`Mdels`,`NetMode`,`GPS`,`GPSLocal`,`username`,`did`,`uid`,`ExeTime`,`classpath`,`classname`,`ip`,`logintime`,`requestjson`,`responsejson`) VALUES ('"+info.getUUID()+"','"+info.getMdels()+"','"	+info.getNetMode()+"','"+info.getGPS()+"','"+info.getGPSLocal()+"','"	+info.getUSERID()+"','"+info.getDID()+"','"+info.getUSERID()+"','"+ExeTime+"','"+claspath+"','"+classname+"','"+info.getIp()+"',now(),'','');";
				db.executeUpdate(InsertSQLlog);
				// 记录日志end     
				Atm.LogSys("课表调整", "按照教师调整课表", "按照教师调整课表完成,操作人:"+common.getusernameTouid(info.getUSERID())+"", "0", info.getUSERID(), info.getIp());
				
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
		
		
		/**
		 * 获取全校性课表 按照教室课表
		 * @param request
		 * @param response
		 * @param RequestJson
		 * @param info
		 * @param theClassName
		 * @throws ServletException
		 * @throws IOException
		 */
		public void getAllSchoolRoom(HttpServletRequest request, HttpServletResponse response,String RequestJson,InfoEntity info,String theClassName) throws ServletException, IOException {
			Jdbc db = new Jdbc();
		    Page page = new Page();
	       
	        response.setContentType("text/html;charset=UTF-8");
			request.setCharacterEncoding("UTF-8");
			response.setCharacterEncoding("UTF-8");
			PrintWriter out = response.getWriter();
	
		    String classname="按照教室课表";
	        String claspath=this.getClass().getName();
	        String responsejson=""; //返回客户端数据 
	        JSONObject json = new JSONObject();
	    //定义json接受字段列表        
	         
	        
	       JSONObject jsonbase = new JSONObject();
		   ArrayList list = new ArrayList();
		   
		   //"xueqi":xueqi,"ruxue":ruxue,"major":major,"department":department,"xiaoqu":xiaoqu
		   commonCourse commonCourse = new commonCourse();
		   common common = new common();
		   
		   String xueqi = "";			//学期
		   String jiaoxuequ = "";			//教学区
		   String luo = "";			//教学楼
		   
		   try { // 解析开始
			   JSONArray arr = JSONArray.fromObject("[" + RequestJson + "]");
			   for (int i = 0; i < arr.size(); i++) {
				   JSONObject obj = arr.getJSONObject(i);
				    //定义json解析字段列表		
				   xueqi = obj.getString("xueqi");
				   jiaoxuequ = obj.getString("jiaoxuequ");
				   luo = obj.getString("luo");
				   		
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
			
			
			String sqlwhere = "";
			if(!"0".equals(jiaoxuequ)){
				sqlwhere = "	AND	teaching_area.id = '"+jiaoxuequ+"'			";
			}
			
			if(!"0".equals(luo)){
				sqlwhere = "	AND 	teaching_building.id = '"+luo+"'	";
			}
			
			String classroom_sql = "SELECT 													"+
						"		arragne_sys_classroom.classroomid AS classroomid,				"+
						"		classroom.classroomname    AS classroomname				"+
						"		FROM arragne_sys_classroom                                         "+
						"		  LEFT JOIN classroom                                       "+
						"		    ON arragne_sys_classroom.classroomid = classroom.id            "+
						"		  LEFT JOIN teaching_area                                   "+
						"		    ON teaching_area.id = classroom.teaching_area_id        "+
						"		  LEFT JOIN teaching_building                               "+
						"		    ON teaching_building.id = classroom.building_id         "+
						"		WHERE semester = '"+xueqi+"'		"+sqlwhere+"	;";
			
			
			
			
			ResultSet classSet = db.executeQuery(classroom_sql);
			System.out.println("sqlslqls=="+classroom_sql);
			
			JSONObject jsonbase1 = new JSONObject();
			ArrayList list1 = new ArrayList();
			
			
			try {
				
				//查找class_id
				while(classSet.next()){
					JSONObject jsonbase2 = new JSONObject();
					ArrayList list2 = new ArrayList();
					jsonbase1.put("classroomname", classSet.getString("classroomname"));
					
					String sql_detailes = "SELECT																		"+
									"		  dict_courses.course_name,                                                 "+
									"		  dict_courses.course_code,                                                 "+
									"		  classroom.classroomname AS classroomname,                                 "+
									"			weeks,					"+
									"		  arrage_details.timetable,                                                                "+
									"			IFNULL(marge_class.marge_name,class_grade.class_name) as class_name,		"+
									"			classtime,												"+
									"		teacher_basic.teacher_name								"+
									"		FROM arrage_details                                                         "+
									"		  LEFT JOIN dict_courses                                                    "+
									"		    ON dict_courses.id = arrage_details.course_id                           "+
									"		    LEFT JOIN classroom ON arrage_details.classroomid = classroom.id        "+
									"			LEFT JOIN teacher_basic ON arrage_details.teacher_id = teacher_basic.id	"+
									"		    LEFT JOIN class_grade ON classid = class_grade.id                       "+
									"			LEFT JOIN arrage_coursesystem ON arrage_details.arrage_coursesystem_id = arrage_coursesystem.id		"+
									"			LEFT JOIN marge_class ON arrage_coursesystem.marge_class_id = marge_class.id"+
									"		WHERE arrage_details.classroomid = '"+classSet.getString("classroomid")+"'		AND arrage_coursesystem.semester='"+xueqi+"' ;";
					
					
					ResultSet detailsSet = db.executeQuery(sql_detailes);
					while(detailsSet.next()){
						jsonbase2.put("course_name", detailsSet.getString("dict_courses.course_name"));
						jsonbase2.put("course_code", detailsSet.getString("dict_courses.course_code"));
						jsonbase2.put("classroomname", detailsSet.getString("classroomname"));
						jsonbase2.put("timetable", commonCourse.toArrayList(detailsSet.getString("timetable"),"*","#"));
						jsonbase2.put("weeks", detailsSet.getString("weeks"));
						jsonbase2.put("teachername", detailsSet.getString("teacher_name"));
						jsonbase2.put("classtime", detailsSet.getString("classtime"));
						jsonbase2.put("class_name", detailsSet.getString("class_name"));
						list2.add(jsonbase2.toString());
					}if(detailsSet!=null){detailsSet.close();}
					jsonbase1.put("data_detailes", list2.toString());
					
					list1.add(jsonbase1.toString());
				}if(classSet!=null){classSet.close();}
				
				json.put("success", true);
				json.put("resultCode", "1000");
				json.put("msg", "成功");
				json.put("data", list1.toString());
				
				System.out.println("jison==="+json.toString());
				responsejson = json.toString();
				out.print(responsejson);
					 
				//记录日志
				long ExeTime = Calendar.getInstance().getTimeInMillis()-info.getTimeStart();
				String InsertSQLlog = "INSERT INTO  ec_appuse_log (`uuid`,`Mdels`,`NetMode`,`GPS`,`GPSLocal`,`username`,`did`,`uid`,`ExeTime`,`classpath`,`classname`,`ip`,`logintime`,`requestjson`,`responsejson`) VALUES ('"+info.getUUID()+"','"+info.getMdels()+"','"	+info.getNetMode()+"','"+info.getGPS()+"','"+info.getGPSLocal()+"','"	+info.getUSERID()+"','"+info.getDID()+"','"+info.getUSERID()+"','"+ExeTime+"','"+claspath+"','"+classname+"','"+info.getIp()+"',now(),'','');";
				db.executeUpdate(InsertSQLlog);
				// 记录日志end     
				Atm.LogSys("课表调整", "按照教师调整课表", "按照教师调整课表完成,操作人:"+common.getusernameTouid(info.getUSERID())+"", "0", info.getUSERID(), info.getIp());
				
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
		
		/**
		 * 获取全校性课表按教师
		 * @param request
		 * @param response
		 * @param RequestJson
		 * @param info
		 * @param theClassName
		 * @throws ServletException
		 * @throws IOException
		 */
		public void getAllSchoolTeacher(HttpServletRequest request, HttpServletResponse response,String RequestJson,InfoEntity info,String theClassName) throws ServletException, IOException {
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
	         
	        
	       JSONObject jsonbase = new JSONObject();
		   ArrayList list = new ArrayList();
		   
		   //"xueqi":xueqi,"ruxue":ruxue,"major":major,"department":department,"xiaoqu":xiaoqu
		   commonCourse commonCourse = new commonCourse();
		   common common = new common();
		   
		   String xueqi = "";			//学期
		   String department = "";			//教学区
		   String jiaoyanshi = "";			//教学楼
		   
		   try { // 解析开始
			   JSONArray arr = JSONArray.fromObject("[" + RequestJson + "]");
			   for (int i = 0; i < arr.size(); i++) {
				   JSONObject obj = arr.getJSONObject(i);
				    //定义json解析字段列表		
				   xueqi = obj.getString("xueqi");
				   department = obj.getString("department");
				   jiaoyanshi = obj.getString("jiaoyanshi");
				   		
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
			
			
			String sqlwhere = "";
			if(!"0".equals(department)){
				sqlwhere = "	AND	dict_departments.id = '"+department+"'			";
			}
			
			if(!"0".equals(jiaoyanshi)){
				sqlwhere = "	AND 	teaching_research.id = '"+jiaoyanshi+"'	";
			}
			
			String classroom_sql = "SELECT 														 "+
					"				teacher_basic.id AS teacherid,								"+
					"				teacher_basic.teacher_name AS teacher_name						"+
					"			FROM arrange_sys_teacher                                             "+
					"			  LEFT JOIN teacher_basic                                            "+
					"			    ON teacher_basic.id = arrange_sys_teacher.teacherid              "+
					"			  LEFT JOIN dict_departments                                         "+
					"			    ON dict_departments.id = teacher_basic.faculty                   "+
					"			  LEFT JOIN teaching_research                                        "+
					"			    ON teaching_research.id = teacher_basic.teachering_office        "+
					"			    WHERE arrange_sys_teacher.semester = '"+xueqi+"'		"+sqlwhere+"					"+
					"			";
			
			
			
			
			ResultSet classSet = db.executeQuery(classroom_sql);
			System.out.println("sqlslqls=="+classroom_sql);
			
			JSONObject jsonbase1 = new JSONObject();
			ArrayList list1 = new ArrayList();
			
			
			try {
				
				//查找class_id
				while(classSet.next()){
					JSONObject jsonbase2 = new JSONObject();
					ArrayList list2 = new ArrayList();
					jsonbase1.put("teacher_name", classSet.getString("teacher_name"));
					
					String sql_detailes = "SELECT																		"+
									"		  dict_courses.course_name,                                                 "+
									"		  dict_courses.course_code,                                                 "+
									"		  classroom.classroomname AS classroomname,                                 "+
									"			weeks,					"+
									"		  arrage_details.timetable,                                                                "+
									"			IFNULL(marge_class.marge_name,class_grade.class_name) as class_name,"+
									"			classtime,												"+
									"		teacher_basic.teacher_name								"+
									"		FROM arrage_details                                                         "+
									"		  LEFT JOIN dict_courses                                                    "+
									"		    ON dict_courses.id = arrage_details.course_id                           "+
									"		    LEFT JOIN classroom ON arrage_details.classroomid = classroom.id        "+
									"			LEFT JOIN teacher_basic ON arrage_details.teacher_id = teacher_basic.id	"+
									"		    LEFT JOIN class_grade ON classid = class_grade.id                       "+
									"			LEFT JOIN arrage_coursesystem ON arrage_details.arrage_coursesystem_id = arrage_coursesystem.id		"+
									"			LEFT JOIN marge_class ON arrage_coursesystem.marge_class_id = marge_class.id"+
									"		WHERE arrage_details.teacher_id = '"+classSet.getString("teacherid")+"'		AND arrage_coursesystem.semester='"+xueqi+"' ;";
					
					
					ResultSet detailsSet = db.executeQuery(sql_detailes);
					while(detailsSet.next()){
						jsonbase2.put("course_name", detailsSet.getString("dict_courses.course_name"));
						jsonbase2.put("course_code", detailsSet.getString("dict_courses.course_code"));
						jsonbase2.put("classroomname", detailsSet.getString("classroomname"));
						jsonbase2.put("timetable", commonCourse.toArrayList(detailsSet.getString("timetable"),"*","#"));
						jsonbase2.put("weeks", detailsSet.getString("weeks"));
						jsonbase2.put("teachername", detailsSet.getString("teacher_name"));
						jsonbase2.put("classtime", detailsSet.getString("classtime"));
						jsonbase2.put("class_name", detailsSet.getString("class_name"));
						list2.add(jsonbase2.toString());
					}if(detailsSet!=null){detailsSet.close();}
					jsonbase1.put("data_detailes", list2.toString());
					
					list1.add(jsonbase1.toString());
				}if(classSet!=null){classSet.close();}
				
				json.put("success", true);
				json.put("resultCode", "1000");
				json.put("msg", "成功");
				json.put("data", list1.toString());
				
				System.out.println("jison==="+json.toString());
				responsejson = json.toString();
				out.print(responsejson);
					 
				//记录日志
				long ExeTime = Calendar.getInstance().getTimeInMillis()-info.getTimeStart();
				String InsertSQLlog = "INSERT INTO  ec_appuse_log (`uuid`,`Mdels`,`NetMode`,`GPS`,`GPSLocal`,`username`,`did`,`uid`,`ExeTime`,`classpath`,`classname`,`ip`,`logintime`,`requestjson`,`responsejson`) VALUES ('"+info.getUUID()+"','"+info.getMdels()+"','"	+info.getNetMode()+"','"+info.getGPS()+"','"+info.getGPSLocal()+"','"	+info.getUSERID()+"','"+info.getDID()+"','"+info.getUSERID()+"','"+ExeTime+"','"+claspath+"','"+classname+"','"+info.getIp()+"',now(),'','');";
				db.executeUpdate(InsertSQLlog);
				// 记录日志end     
				Atm.LogSys("课表调整", "按照教师调整课表", "按照教师调整课表完成,操作人:"+common.getusernameTouid(info.getUSERID())+"", "0", info.getUSERID(), info.getIp());
				
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
		
		
		
		
		
		
		
		
		
		
		/**
		 * 判断洲际都分配
		 * @param request
		 * @param response
		 * @param RequestJson
		 * @param info
		 * @param theClassName
		 * @throws ServletException
		 * @throws IOException
		 */
		public void getWeeklySchedule(HttpServletRequest request, HttpServletResponse response,String RequestJson,InfoEntity info,String theClassName) throws ServletException, IOException {
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
	         
	        
	       JSONObject jsonbase = new JSONObject();
		   ArrayList list = new ArrayList();
		   
		   //"xueqi":xueqi,"ruxue":ruxue,"major":major,"department":department,"xiaoqu":xiaoqu
		   commonCourse commonCourse = new commonCourse();
		   common common = new common();
		   
		   
		   String process_id = "";			//进程id
		   String teaching_plan_class_id = "";		//计划表中id
		   try { // 解析开始
			   JSONArray arr = JSONArray.fromObject("[" + RequestJson + "]");
			   for (int i = 0; i < arr.size(); i++) {
				   JSONObject obj = arr.getJSONObject(i);
				    //定义json解析字段列表		
				   process_id = obj.getString("process_id");
				   teaching_plan_class_id = obj.getString("teaching_plan_class_id");
				   		
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
				ArrayList list1 = new ArrayList();
				ArrayList list2 = new ArrayList();
				String sqlString = "select id,process_symbol_name from dict_process_symbol where publicstate = 1";
				ResultSet set = db.executeQuery(sqlString);
				while(set.next()){
					list1.add(set.getString("id"));
					list2.add(set.getString("process_symbol_name"));
				}if(set!=null){set.close();}
				
				String sql1 = "SELECT																		"+
					"			  process_id,                                                               "+
					"			  dict_process_symbol.process_symbol_name AS process_symbol_name            "+
					"			FROM teaching_plan_class                                                    "+
					"			  LEFT JOIN teaching_plan                                                   "+
					"			    ON teaching_plan_class.id = teaching_plan.teaching_plan_class_id        "+
					"			  LEFT JOIN dict_process_symbol                                             "+
					"			    ON teaching_plan.process_id = dict_process_symbol.id                    "+
					"			WHERE teaching_plan_class.id = '"+teaching_plan_class_id+"'                                           "+
					"			    AND courserprocess = 1";
				System.out.println("sql111++++"+sql1);
				ResultSet set1 = db.executeQuery(sql1);
				while(set1.next()){
					list1.add(set1.getString("process_id"));
					list2.add(set1.getString("process_symbol_name"));
				}if(set1!=null){set1.close();}
				
				//判断这个课程是否是进程的课
				
				String sql2 = "SELECT 	dict_courses.process_symbol AS process_symbol,						"+
						"			process_symbol_name													"+
						"		FROM teaching_plan_class                                                "+
						"		  LEFT JOIN teaching_plan                                               "+
						"		    ON teaching_plan_class.id = teaching_plan.teaching_plan_class_id    "+
						"		  LEFT JOIN dict_courses                                                "+
						"		    ON teaching_plan.course_id = dict_courses.id                        "+
						"		  LEFT JOIN dict_process_symbol                                         "+
						"		    ON dict_process_symbol.id = dict_courses.process_symbol             "+
						"		WHERE dict_courses.process_symbol != 0                                  "+
						"		    AND curriculum_type = 1		"+
						"			AND teaching_plan_class.id = '"+teaching_plan_class_id+"'";
				ResultSet set2 = db.executeQuery(sql2);
				while(set2.next()){
					list1.add(set2.getString("process_symbol"));
					list2.add(set2.getString("process_symbol_name"));
				}if(set2!=null){set2.close();}
				
				boolean state = list1.contains(process_id);
				
				if(state){
					json.put("success", true);
					json.put("resultCode", "1000");
					json.put("msg", "成功");
				}else{
					String info11 =  StringUtils.join(list2,",");
					json.put("success", false);
					json.put("resultCode", "2000");
					json.put("msg", info11);
				}
				
				
				
				System.out.println("jison==="+json.toString());
				responsejson = json.toString();
				out.print(responsejson);
					 
				//记录日志
				long ExeTime = Calendar.getInstance().getTimeInMillis()-info.getTimeStart();
				String InsertSQLlog = "INSERT INTO  ec_appuse_log (`uuid`,`Mdels`,`NetMode`,`GPS`,`GPSLocal`,`username`,`did`,`uid`,`ExeTime`,`classpath`,`classname`,`ip`,`logintime`,`requestjson`,`responsejson`) VALUES ('"+info.getUUID()+"','"+info.getMdels()+"','"	+info.getNetMode()+"','"+info.getGPS()+"','"+info.getGPSLocal()+"','"	+info.getUSERID()+"','"+info.getDID()+"','"+info.getUSERID()+"','"+ExeTime+"','"+claspath+"','"+classname+"','"+info.getIp()+"',now(),'','');";
				db.executeUpdate(InsertSQLlog);
				// 记录日志end     
				Atm.LogSys("课表调整", "按照教师调整课表", "按照教师调整课表完成,操作人:"+common.getusernameTouid(info.getUSERID())+"", "0", info.getUSERID(), info.getIp());
				
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
		
		
		/**
		 * 排课漏课管理
		 * @param request
		 * @param response
		 * @param RequestJson
		 * @param info
		 * @param theClassName
		 * @throws ServletException
		 * @throws IOException
		 */
		public void LeakingCourseTreatment(HttpServletRequest request, HttpServletResponse response,String RequestJson,InfoEntity info,String theClassName) throws ServletException, IOException {
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
	         
	        
	       JSONObject jsonbase = new JSONObject();
		   ArrayList list = new ArrayList();
		   
		   commonCourse commonCourse = new commonCourse();
		   common common = new common();
		   
		   String semester = "";			//学期号
		   String appoint_roomid = "";		//教室id	
		   String teacher_id = "";			//教师id
		   String id = "";					//主键id
		   String class_id = "";			//班级id
		   String srt = "";					//节次
		   String course_id = "";			//课程
		   String class_begins_weeks = "";	//讲课周次
		   try { // 解析开始
			   JSONArray arr = JSONArray.fromObject("[" + RequestJson + "]");
			   for (int i = 0; i < arr.size(); i++) {
				   JSONObject obj = arr.getJSONObject(i);
				    //定义json解析字段列表		
				   semester = obj.getString("semester");
				   appoint_roomid = obj.getString("appoint_roomid");
				   teacher_id = obj.getString("teacher_id");
				   id = obj.getString("id");
				   class_id = obj.getString("class_id");
				   srt = obj.getString("str");
				   course_id = obj.getString("course_id");
				   class_begins_weeks = obj.getString("class_begins_weeks");
				   		
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
				
				//查询初始化参数
				String sql1 = "select course_mode from arrage_course where school_number = '"+semester+"'";
				String course_mode = "";
				ResultSet sqlSet1 = db.executeQuery(sql1);
				while(sqlSet1.next()){
					course_mode = sqlSet1.getString("course_mode")==null?"5":sqlSet1.getString("course_mode");
				}if(sqlSet1!=null){sqlSet1.close();}
				
				
				
				//课表数组
				ArrayList<ArrayList<String>> base_list = commonCourse.setTwoArray((Integer.valueOf(course_mode)-1),4);
				
				ArrayList<String> jjj = new ArrayList<String>(Arrays.asList(srt.split("#")));
				
				//教师
				HashMap<String,String> map_teacher = commonCourse.getTeacherinfo(teacher_id,semester);
				//班级
				HashMap<String,String> map_class  = commonCourse.getclassInfo(class_id,semester);
				//教室
				HashMap<String,String> map_classroom = commonCourse.getClassroomInfo(appoint_roomid,semester);
				
				
				ArrayList<ArrayList<String>> class_list = new ArrayList<ArrayList<String>>();
				ArrayList<ArrayList<String>> teacher_list = new ArrayList<ArrayList<String>>();
				ArrayList<ArrayList<String>> classroom_list = new ArrayList<ArrayList<String>>();
				for(int i = 0 ;i<jjj.size();i++){
					//获取节次
					ArrayList<String> weekly = new ArrayList<String>(Arrays.asList(jjj.get(i).split("_")));
					int m = Integer.valueOf(weekly.get(0));		//周次
					int k = Integer.valueOf(weekly.get(1));		//课节
					//教师
					if(!map_teacher.isEmpty()){
						teacher_list = commonCourse.toArrayList(map_teacher.get("timetable"),"*","#");
						String stateString = teacher_list.get(m).get(k);
						if(!"0".equals(stateString) && !"9".equals(stateString)){
							teacher_list.get(m).set(k, "0");
						}else{
							json.put("success", false);
							json.put("resultCode", "2000");
							json.put("msg", "教师冲突不可用");
							responsejson = json.toString();
							out.print(responsejson);
							Page.colseDP(db, page);
							return;
						}
					}else{
						base_list.get(m).set(k, "0");
					}
					
					//教室
					if(!map_classroom.isEmpty()){
						classroom_list = commonCourse.toArrayList(map_classroom.get("timetable"),"*","#");
						String stateString = classroom_list.get(m).get(k);
						if(!"0".equals(stateString) && !"9".equals(stateString)){
							classroom_list.get(m).set(k, "0");
						}else{
							json.put("success", false);
							json.put("resultCode", "2000");
							json.put("msg", "教室冲突不可用");
							responsejson = json.toString();
							out.print(responsejson);
							Page.colseDP(db, page);
							return;
						}
					}else{
						base_list.get(m).set(k, "0");
					}
					
					//班级
					if(!map_class.isEmpty()){
						class_list = commonCourse.toArrayList(map_class.get("timetable"),"*","#");
						String stateString = class_list.get(m).get(k);
						if(!"0".equals(stateString) && !"9".equals(stateString)){
							class_list.get(m).set(k, "0");
						}else{
							json.put("success", false);
							json.put("resultCode", "2000");
							json.put("msg", "班级冲突不可用");
							
							responsejson = json.toString();
							out.print(responsejson);
							Page.colseDP(db, page);
							return;
						}
					}else{
						base_list.get(m).set(k, "0");
					}
					
				}
				
				
				//修改教师，教室，班级
				if(!map_teacher.isEmpty()){
					//修改
					commonCourse.updateTeacherInfo(map_teacher.get("id"),commonCourse.toStringfroList(teacher_list,"*","#"));
				}else{
					//新增
					commonCourse.insertTeacherInfo(teacher_id,semester,commonCourse.toStringfroList(base_list,"*","#"));
				}
				if(!map_classroom.isEmpty()){
					//修改
					commonCourse.updateClassroom(map_classroom.get("id"),commonCourse.toStringfroList(classroom_list,"*","#"));
				}else{
					//增加
					commonCourse.insertClassroom(appoint_roomid,semester,commonCourse.toStringfroList(base_list,"*","#"));
				}
				
				if(!map_class.isEmpty()){
					//修改
					commonCourse.updateClassinfo(map_class.get("id"),commonCourse.toStringfroList(class_list,"*","#"));
				}else{
					//增加
					commonCourse.insertClassinfo(class_id,semester,commonCourse.toStringfroList(base_list,"*","#"));
				}
				
				
				//修改主表
				String update_sql = "UPDATE arrage_coursesystem 		 "+
							"		SET                                  "+
							"		timetable = '"+commonCourse.toStringfroList(base_list,"*","#")+"'	,					"+
							"		timetablestate = '1'    "+
							"		WHERE                                "+
							"		id = '"+id+"' ;";
				
				//新增details表
				String insert_sql = "INSERT INTO arrage_details 		"+
						"			(                                "+
						"			arrage_coursesystem_id,             "+
						"			semester,                           "+
						"			course_id,                          "+
						"			classid,                            "+
						"			teacher_id,                         "+
						"			classroomid,                        "+
						"			weeks,                              "+
						"			timetable,                          "+
						"			classtime                           "+
						"			)                                   "+
						"			VALUES                              "+
						"			(                              "+
						"			'"+id+"',           "+
						"			'"+semester+"',                         "+
						"			'"+course_id+"',                        "+
						"			'"+class_id+"',                          "+
						"			'"+teacher_id+"',                       "+
						"			'"+appoint_roomid+"',                      "+
						"			'"+class_begins_weeks+"',                            "+
						"			'"+commonCourse.toStringfroList(base_list,"*","#")+"',                        "+
						"			'"+commonCourse.getClasstime(commonCourse.toStringfroList(base_list,"*","#"))+"'                         "+
						"			);";
				
				
				
				
				boolean state = db.executeUpdate(update_sql);
				
				if(state){
					db.executeUpdate(insert_sql);
				}
				
				if(state){
					json.put("success", true);
					json.put("resultCode", "1000");
					json.put("msg", "修改成功");
				}else{
					json.put("success", false);
					json.put("resultCode", "2000");
					json.put("msg", "修改失败");
				}
				
				responsejson = json.toString();
				out.print(responsejson);
					 
				//记录日志
				long ExeTime = Calendar.getInstance().getTimeInMillis()-info.getTimeStart();
				String InsertSQLlog = "INSERT INTO  ec_appuse_log (`uuid`,`Mdels`,`NetMode`,`GPS`,`GPSLocal`,`username`,`did`,`uid`,`ExeTime`,`classpath`,`classname`,`ip`,`logintime`,`requestjson`,`responsejson`) VALUES ('"+info.getUUID()+"','"+info.getMdels()+"','"	+info.getNetMode()+"','"+info.getGPS()+"','"+info.getGPSLocal()+"','"	+info.getUSERID()+"','"+info.getDID()+"','"+info.getUSERID()+"','"+ExeTime+"','"+claspath+"','"+classname+"','"+info.getIp()+"',now(),'','');";
				db.executeUpdate(InsertSQLlog);
				// 记录日志end     
				Atm.LogSys("课表调整", "按照教师调整课表", "按照教师调整课表完成,操作人:"+common.getusernameTouid(info.getUSERID())+"", "0", info.getUSERID(), info.getIp());
				
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
		
		
		/**
		 * 漏课冲突提示
		 * @param request
		 * @param response
		 * @param RequestJson
		 * @param info
		 * @param theClassName
		 * @throws ServletException
		 * @throws IOException
		 */
		public void LeakingClassConflict(HttpServletRequest request, HttpServletResponse response,String RequestJson,InfoEntity info,String theClassName) throws ServletException, IOException {
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
	         
	        
	       JSONObject jsonbase = new JSONObject();
		   ArrayList list = new ArrayList();
		   
		   commonCourse commonCourse = new commonCourse();
		   common common = new common();
		   
		   String semester = "";			//学期号
		   String appoint_roomid = "";		//教室id	
		   String teacher_id = "";			//教师id
		   String id = "";					//主键id
		   String class_id = "";			//班级id
		   String srt = "";					//节次
		   String course_id = "";			//课程
		   String class_begins_weeks = "";	//讲课周次
		   try { // 解析开始
			   JSONArray arr = JSONArray.fromObject("[" + RequestJson + "]");
			   for (int i = 0; i < arr.size(); i++) {
				   JSONObject obj = arr.getJSONObject(i);
				    //定义json解析字段列表		
				   semester = obj.getString("semester");
				   appoint_roomid = obj.getString("appoint_roomid");
				   teacher_id = obj.getString("teacher_id");
				   id = obj.getString("id");
				   class_id = obj.getString("class_id");
				   srt = obj.getString("str");
				   course_id = obj.getString("course_id");
				   class_begins_weeks = obj.getString("class_begins_weeks");
				   		
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
			
			
			
			//教师
			HashMap<String,String> map_teacher = commonCourse.getTeacherinfo(teacher_id,semester);
			//班级
			HashMap<String,String> map_class  = commonCourse.getclassInfo(class_id,semester);
			//教室
			HashMap<String,String> map_classroom = commonCourse.getClassroomInfo(appoint_roomid,semester);
			
			
			ArrayList<ArrayList<String>> class_list = new ArrayList<ArrayList<String>>();
			ArrayList<ArrayList<String>> teacher_list = new ArrayList<ArrayList<String>>();
			ArrayList<ArrayList<String>> classroom_list = new ArrayList<ArrayList<String>>();
			//获取节次
			ArrayList<String> weekly = new ArrayList<String>(Arrays.asList(srt.split("_")));
			int m = Integer.valueOf(weekly.get(0));		//周次
			int k = Integer.valueOf(weekly.get(1));		//课节
			//教师
			if(!map_teacher.isEmpty()){
				teacher_list = commonCourse.toArrayList(map_teacher.get("timetable"),"*","#");
				String stateString = teacher_list.get(m).get(k);
				if("0".equals(stateString) ){
					json.put("success", false);
					json.put("resultCode", "2000");
					json.put("msg", "教师课节被占用");
					responsejson = json.toString();
					out.print(responsejson);
					Page.colseDP(db, page);
					return;
				}else if("9".equals(stateString)){
					json.put("success", false);
					json.put("resultCode", "2000");
					json.put("msg", "教师课节被锁定");
					responsejson = json.toString();
					out.print(responsejson);
					Page.colseDP(db, page);
					return;
				}
			}
			
			//教室
			if(!map_classroom.isEmpty()){
				classroom_list = commonCourse.toArrayList(map_classroom.get("timetable"),"*","#");
				String stateString = classroom_list.get(m).get(k);
				if("0".equals(stateString) ){
					json.put("success", false);
					json.put("resultCode", "2000");
					json.put("msg", "教室课节被占用");
					responsejson = json.toString();
					out.print(responsejson);
					Page.colseDP(db, page);
					return;
				}else if("9".equals(stateString)){
					json.put("success", false);
					json.put("resultCode", "2000");
					json.put("msg", "教室课节被锁定");
					responsejson = json.toString();
					out.print(responsejson);
					Page.colseDP(db, page);
					return;
				}
			}
			
			//班级
			if(!map_class.isEmpty()){
				class_list = commonCourse.toArrayList(map_class.get("timetable"),"*","#");
				String stateString = class_list.get(m).get(k);
				if("0".equals(stateString) ){
					json.put("success", false);
					json.put("resultCode", "2000");
					json.put("msg", "班级课节被占用");
					responsejson = json.toString();
					out.print(responsejson);
					Page.colseDP(db, page);
					return;
				}else if("9".equals(stateString)){
					json.put("success", false);
					json.put("resultCode", "2000");
					json.put("msg", "班级课节被锁定");
					responsejson = json.toString();
					out.print(responsejson);
					Page.colseDP(db, page);
					return;
				}
			}
				
			json.put("success", true);
			json.put("resultCode", "1000");
			json.put("msg", "课表冲突检查");
			
			responsejson = json.toString();
			out.print(responsejson);
				 
			//记录日志
			long ExeTime = Calendar.getInstance().getTimeInMillis()-info.getTimeStart();
			String InsertSQLlog = "INSERT INTO  ec_appuse_log (`uuid`,`Mdels`,`NetMode`,`GPS`,`GPSLocal`,`username`,`did`,`uid`,`ExeTime`,`classpath`,`classname`,`ip`,`logintime`,`requestjson`,`responsejson`) VALUES ('"+info.getUUID()+"','"+info.getMdels()+"','"	+info.getNetMode()+"','"+info.getGPS()+"','"+info.getGPSLocal()+"','"	+info.getUSERID()+"','"+info.getDID()+"','"+info.getUSERID()+"','"+ExeTime+"','"+claspath+"','"+classname+"','"+info.getIp()+"',now(),'','');";
			db.executeUpdate(InsertSQLlog);
			// 记录日志end     
			Atm.LogSys("课表调整", "按照教师调整课表", "按照教师调整课表完成,操作人:"+common.getusernameTouid(info.getUSERID())+"", "0", info.getUSERID(), info.getIp());
			
			
			//关闭数据与serlvet.out
			if (db != null) { db.close(); db = null; }
			if (page != null) {page = null;}
					
			out.flush();
			out.close();
			
			
			
		}
		
		

}
