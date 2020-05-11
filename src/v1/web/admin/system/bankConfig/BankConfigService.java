package v1.web.admin.system.bankConfig;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Calendar;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang3.StringUtils;

//import com.mysql.jdbc.ResultSet;

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
 * 周计划分配，删除字典配置接口
 * @company 010jiage
 * @author gf
 * @date:2018-3-20 上午11:13:16
 */
public class BankConfigService {

	/**
	 * 根据taskid 获取教学计划详情
	 * @param request
	 * @param response
	 * @param requestJson
	 * @param info
	 * @throws ServletException
	 * @throws IOException
	 */
	public void findTeachingPlan(HttpServletRequest request, HttpServletResponse response,String requestJson, InfoEntity info) throws ServletException, IOException {
		Jdbc db = new Jdbc();
		Page page = new Page();

	    String classname="web  查询教学计划详情";
        String claspath=this.getClass().getName();
        
		response.setContentType("text/html;charset=UTF-8");
		request.setCharacterEncoding("UTF-8");
		response.setCharacterEncoding("UTF-8");
		
		String journal="";//日志记录内容
		
		PrintWriter out = response.getWriter();
    	JSONObject json = new JSONObject();

	    
		//声明变量；
	    String semester = "";
	    String taskid = "";
	    
	    semester = request.getParameter("semester");
	    taskid = request.getParameter("taskid");
	    
	    try { // 解析开始
			JSONArray arr = JSONArray.fromObject("[" + requestJson + "]");
			for (int i = 0; i < arr.size(); i++) {
				JSONObject obj = arr.getJSONObject(i);
				semester = obj.getString("semester") ;     
				taskid = obj.getString("taskid") ;     
			}
		} catch (Exception e) {
			  ErrMsg.falseErrMsg(request, response, "500", "json格式解析异常");
			  Page.colseDOP(db, out, page);
			  return;
		}
		
		String sql = "SELECT "+
							"		t.*, "+
							"		t3.teacher_name, "+
							"		t4.class_name,                                                                         "+
							"		t2.course_name                                                                        "+
							"	FROM                                                                                       "+
							"		teaching_task t                                                                        "+
							"	LEFT JOIN dict_courses t2 ON t.course_id=t2.id                                             "+
							"	LEFT JOIN teaching_task_teacher t5 ON teaching_task_id=t.id                                           "+
							"	LEFT JOIN teacher_basic t3 ON t3.id = t5.teacherid                                          "+
							"	LEFT JOIN class_grade t4 ON t.class_id=t4.id                                               "+
							"	where  t.semester='"+semester+"' and t.id="+taskid ;
		System.out.println(sql);
		java.sql.ResultSet res = db.executeQuery(sql);
		String jsonStr;
		try {
			jsonStr = common.resultSetToJson(res);
			json.put("success", true);
			json.put("resultCode", "1000");
			json.put("data", jsonStr);
			json.put("msg", "查询成功");
		} catch (SQLException e) {
			e.printStackTrace();
			json.put("success", true);
			json.put("resultCode", "2000");
			json.put("msg", "查询失败");
		}
		
		out.print(json);
		long ExeTime = Calendar.getInstance().getTimeInMillis()-info.getTimeStart();
		//添加操作日志
		Atm.LogSys(classname, journal, "操作者"+info.getUSERID()+"", "1",info.getUSERID(), info.getIp());
		// 记录执行日志
		Atm.AppuseLong(info, "", claspath, classname, json.toString(), ExeTime);
		Page.colseDOP(db, out, page);
		
		return;
	}
	
	/**
	 * 获取学期列表和当前apptonken登录教师
	 */
	public void findSemesterTea(HttpServletRequest request, HttpServletResponse response,String requestJson, InfoEntity info) throws ServletException, IOException {
		Jdbc db = new Jdbc();
		Page page = new Page();

	    String classname="app  获取学期列表和当前apptonken登录教师";
        String claspath=this.getClass().getName();
        
		response.setContentType("text/html;charset=UTF-8");
		request.setCharacterEncoding("UTF-8");
		response.setCharacterEncoding("UTF-8");
		
		String journal="";//日志记录内容
		
		PrintWriter out = response.getWriter();
    	JSONObject json = new JSONObject();

	    
		//声明变量；
	    String apptoken = "";
	    
	    apptoken = request.getParameter("apptoken");
	    
	    try { // 解析开始
			JSONArray arr = JSONArray.fromObject("[" + requestJson + "]");
			for (int i = 0; i < arr.size(); i++) {
				JSONObject obj = arr.getJSONObject(i);
				apptoken = obj.getString("apptoken") ;     
			}
		} catch (Exception e) {
			  ErrMsg.falseErrMsg(request, response, "500", "json格式解析异常");
			  Page.colseDOP(db, out, page);
			  return;
		}
	
      	try {
      		//学期信息
      		String sql_sem = "select academic_year from academic_year order by id desc";
          	java.sql.ResultSet setRs = db.executeQuery(sql_sem);
          	String sem ="";
			while(setRs.next()){
				sem = sem+"<option value="+setRs.getString("academic_year")+">"+setRs.getString("academic_year")+"</option>";
			} if(setRs!=null){setRs.close();}
			  json.put("semData", sem);
			//教师信息
			String teaStr="";
			 String sql = "SELECT t1.id,t1.teacher_name FROM user_worker t LEFT JOIN teacher_basic t1 ON t. user_association=t1.id where t.app_token='"+apptoken+"' and t.userole=1;";
			 java.sql.ResultSet res = db.executeQuery(sql);
			while(res.next()){
				teaStr = teaStr+"<option value="+res.getString("id")+">"+res.getString("teacher_name")+"</option>";
			} if(res!=null){res.close();}
			json.put("success", true);
			json.put("resultCode", "1000");
			json.put("teaData", teaStr);
			json.put("msg", "查询成功");
      	}
		catch (SQLException e1) {
			e1.printStackTrace();
			json.put("success", true);
			json.put("resultCode", "2000");
			json.put("msg", "查询失败");
		}
		out.print(json);
		long ExeTime = Calendar.getInstance().getTimeInMillis()-info.getTimeStart();
		//添加操作日志
		Atm.LogSys(classname, journal, "操作者"+info.getUSERID()+"", "1",info.getUSERID(), info.getIp());
		// 记录执行日志
		Atm.AppuseLong(info, "", claspath, classname, json.toString(), ExeTime);
		Page.colseDOP(db, out, page);
		return;
	}
	/**
	 * 根据教师id获取课程班级信息
	 * @param request
	 * @param response
	 * @param requestJson
	 * @param info
	 * @throws ServletException
	 * @throws IOException
	 */
	public void findTeachingPlan1(HttpServletRequest request, HttpServletResponse response,String requestJson, InfoEntity info) throws ServletException, IOException {
		Jdbc db = new Jdbc();
		Page page = new Page();
		
		String classname="web  获取课程班级信息";
		String claspath=this.getClass().getName();
		
		response.setContentType("text/html;charset=UTF-8");
		request.setCharacterEncoding("UTF-8");
		response.setCharacterEncoding("UTF-8");
		
		String journal="";//日志记录内容
		
		PrintWriter out = response.getWriter();
		JSONObject json = new JSONObject();
		
		//声明变量；
		String semester = "";
		String teacherid = "";
		
		try { // 解析开始
			JSONArray arr = JSONArray.fromObject("[" + requestJson + "]");
			for (int i = 0; i < arr.size(); i++) {
				JSONObject obj = arr.getJSONObject(i);
				semester = obj.getString("semester") ;     
				teacherid = obj.getString("teacherid") ;     
			}
		} catch (Exception e) {
			ErrMsg.falseErrMsg(request, response, "500", "json格式解析异常");
			Page.colseDOP(db, out, page);
			return;
		}
		
		String sql = "SELECT "+
		"		t.id, "+
		"		t3.teacher_name, "+
		"		t4.class_name,                                                                         "+
		"		t2.course_name                                                                        "+
		"	FROM                                                                                       "+
		"		teaching_task t                                                                        "+
		"	LEFT JOIN dict_courses t2 ON t.course_id=t2.id                                             "+
		"	LEFT JOIN teaching_task_teacher t5 ON teaching_task_id=t.id                                           "+
		"	LEFT JOIN teacher_basic t3 ON t3.id = t5.teacherid                                          "+
		"	LEFT JOIN class_grade t4 ON t.class_id=t4.id                                               "+
		"	where  t.semester='"+semester+"' AND 	t.typestate = 2 and t5.teacherid="+teacherid ;
		System.out.println(sql);
		java.sql.ResultSet res = db.executeQuery(sql);
		StringBuffer sb = new StringBuffer();
		sb.append("<option value='0'>请选择</option>");
		try {
			while(res.next()){
				sb.append("<option value='"+res.getString("id")+"'>"+res.getString("class_name")+"-"+res.getString("course_name")+"</option>");
			}
			json.put("success", true);
			json.put("resultCode", "1000");
			json.put("data",sb.toString() );
			json.put("msg", "查询成功");
		} catch (SQLException e) {
			e.printStackTrace();
			json.put("success", true);
			json.put("resultCode", "2000");
			json.put("msg", "查询失败");
		}
		
		out.print(json);
		long ExeTime = Calendar.getInstance().getTimeInMillis()-info.getTimeStart();
		//添加操作日志
		Atm.LogSys(classname, "查询课程详情", "操作者id : "+info.getUSERID()+"", "1",info.getUSERID(), info.getIp());
		// 记录执行日志
		Atm.AppuseLong(info, "", claspath, classname, json.toString(), ExeTime);
		Page.colseDOP(db, out, page);
		
		return;
	}
	
	/**
	 * 保存周计划分配
	 */
	public void save(HttpServletRequest request, HttpServletResponse response,String requestJson, InfoEntity info) throws ServletException, IOException {
		Jdbc db = new Jdbc();
		Page page = new Page();

	    String classname="web  保存周计划分配";
        String claspath=this.getClass().getName();
        
		response.setContentType("text/html;charset=UTF-8");
		request.setCharacterEncoding("UTF-8");
		response.setCharacterEncoding("UTF-8");
		
		String journal="";//日志记录内容
		
		PrintWriter out = response.getWriter();
    	JSONObject json = new JSONObject();

		//声明变量；
	    String infos = "";
	    infos = request.getParameter("infos");
	    String[] infosAry = infos.split("\\|");
	    boolean status = false;
	    for(int i=1;i<infosAry.length;i++){
	    	JSONObject in =JSONObject.fromObject(infosAry[i]);
	    	String sql ="";
	    	//如果id是0 说明没有周分配计划，插入新数据,否则更新
	    	String id = in.getString("id");
	    	if(StringUtils.isBlank(id)){
	    		break;
	    	}
	    	if(in.getString("id").equals("0")){
	    		sql = "insert into weekly_schedule_new (dict_departments_id,class_id,semester,weekly_info) values ("+
				    				in.getString("dict_departments_id")+","+
				    				in.getString("class_id")+",'"+
				    				in.getString("semester")+"','"+
				    				in.getString("weekly_info")+
				    				"')";
	    	}else{
	    		sql = "update weekly_schedule_new set dict_departments_id='"+in.getString("dict_departments_id")+
				    		"',class_id='"+	in.getString("class_id")+
				    		"',semester='"+	in.getString("semester")+
				    		"',weekly_info='"+	in.getString("weekly_info")+
				    		"'  where id="+id;
	    	}
	    	
	    	
	    	setTeachWeeks(in.getString("class_id"),in.getString("semester"),in.getString("weekly_info"));
	    	
	    	  status = db.executeUpdate(sql);
	    	 // System.out.println("sql : "+sql);
	    	  if(status==false){
	    		  break;
	    	  }
	    }
		if(status==true){
			json.put("success", true);
			json.put("resultCode", "1000");
			json.put("msg", "保存成功");
		}else{
			json.put("success", true);
			json.put("resultCode", "2000");
			json.put("msg", "保存失败，请联系系统维护人员");
		}
		out.print(json);
		long ExeTime = Calendar.getInstance().getTimeInMillis()-info.getTimeStart();
		//添加操作日志
		Atm.LogSys(classname, "保存周分配计划", "操作者id : "+info.getUSERID()+"", "1",info.getUSERID(), info.getIp());
		// 记录执行日志
		Atm.AppuseLong(info, "", claspath, classname, json.toString(), ExeTime);
		Page.colseDOP(db, out, page);
		
		return;
	}
	
	/**
	 * 周进度分配影响教学计划表
	 */
	public static boolean setTeachWeeks(String class_id,String semester,String weekly_info){
		Jdbc db = new Jdbc();
		Page page = new Page();
		commonCourse commonCourse = new commonCourse();
		boolean state = true;
		int academic_weeks = 0;
		//查询学期的周数
		String sqlString = "select academic_weeks from	academic_year where academic_year = '"+semester+"'";
		java.sql.ResultSet set = db.executeQuery(sqlString);
		try {
			while(set.next()){
				academic_weeks = set.getInt("academic_weeks");
			}if(set!=null){set.close();}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		ArrayList<Integer> ttArrayList = new ArrayList<Integer>();
		ArrayList<Integer> jinArrayList = new ArrayList<Integer>();
		
		//保存信息
		JSONArray arr = JSONArray.fromObject(weekly_info);
		for (int i = 0; i < arr.size(); i++) {
			JSONObject obj = arr.getJSONObject(i);
			if("15".equals(obj.getString("threadid"))){
				jinArrayList.add(Integer.valueOf(obj.getString("week")));
			}
				ttArrayList.add(Integer.valueOf(obj.getString("week")));
		}

		//1.课程进程标记是警训
		if(jinArrayList!=null&&jinArrayList.size()>0){
			String week_str_jin = "";
			week_str_jin = commonCourse.getweekOStr(jinArrayList,academic_weeks);
			ArrayList<String> list1 = commonCourse.setWeekly(week_str_jin) ;
			String sql_sql = "SELECT teaching_task.id as id FROM teaching_task LEFT JOIN dict_courses ON teaching_task.course_id = dict_courses.id WHERE process_symbol = 15	AND  class_id = '"+class_id+"'	and typestate = 1  and semester='"+semester+"'	and weekjistate=0";
			//String sql_sql = "SELECT teaching_task.id as id FROM teaching_task LEFT JOIN dict_courses ON teaching_task.course_id = dict_courses.id WHERE teaching_task.course_id =1	AND  class_id = '"+class_id+"'	and typestate = 1  and semester='"+semester+"'	and weekjistate=0";
			java.sql.ResultSet set1 = db.executeQuery(sql_sql);
			try {
				while(set1.next()){
					String update_sql1 = "UPDATE teaching_task 				 "+
					"			SET                                  "+
					"			class_begins_weeks = '"+week_str_jin+"',		"+
					"			classes_weekly = '"+list1.size()+"'		"+
					//"			weekjistate = '1'          "+
					"			WHERE                                "+
					"			teaching_task.id = '"+set1.getString("id")+"'	 ;";
					state = db.executeUpdate(update_sql1);
					if(!state){
						break;
					}
				}if(set1!=null){set1.close();}
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
		if(state&&ttArrayList.size()>0){
			//2.课程进程标记不是警训的
			String week_str_notjin = "";
			week_str_notjin = commonCourse.getweekStr(ttArrayList,academic_weeks);
			ArrayList<String> list2 = commonCourse.setWeekly(week_str_notjin) ;
			String sql_sql2 = "SELECT teaching_task.id as id FROM teaching_task LEFT JOIN dict_courses ON teaching_task.course_id = dict_courses.id WHERE process_symbol = !15	AND  class_id = '"+class_id+"'	and typestate = 1  and semester='"+semester+"'	and weekjistate=0";
			java.sql.ResultSet set2 = db.executeQuery(sql_sql2);
			try {
				while(set2.next()){
					String update_sql = "UPDATE teaching_task 				 "+
					"			SET                                  "+
					"			class_begins_weeks = '"+week_str_notjin+"',		"+
					"			classes_weekly = '"+list2.size()+"'		"+
					//"			weekjistate = '1'          "+
					"			WHERE                                "+
					"			teaching_task.id = '"+set2.getString("id")+"'	 ;";
					//"			class_id = '"+class_id+"'	and typestate = 1  and semester='"+semester+"'	and weekjistate=0 and teaching_task.course_id!=1	 ;";
					state = db.executeUpdate(update_sql);
					if(!state){
						break;
					}
				}if(set2!=null){set2.close();}
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}else{
			state = false;
		}
		Page.colseDP(db, page);
		return state;
		
	}
	
	
	
	
	/**
	 * 删除教师类型配置
	 * @param request
	 * @param response
	 * @param requestJson
	 * @param info
	 * @throws ServletException
	 * @throws IOException
	 */
	public void del(HttpServletRequest request, HttpServletResponse response,String requestJson, InfoEntity info) throws ServletException, IOException {
		Jdbc db = new Jdbc();
		Page page = new Page();

	    String classname="web  删除教师配置";
        String claspath=this.getClass().getName();
        
		response.setContentType("text/html;charset=UTF-8");
		request.setCharacterEncoding("UTF-8");
		response.setCharacterEncoding("UTF-8");
		
		String journal="";//日志记录内容
		
		PrintWriter out = response.getWriter();
    	JSONObject json = new JSONObject();

	    
		//声明变量；
	    String id = "";
	    String table ="";
	    
	    id = request.getParameter("id");
	    table = request.getParameter("table");
	    try { // 解析开始
			JSONArray arr = JSONArray.fromObject("[" + requestJson + "]");
			for (int i = 0; i < arr.size(); i++) {
				JSONObject obj = arr.getJSONObject(i);
				id = obj.get("id") + "";    
				table = obj.get("table") + "";    
			}
		} catch (Exception e) {
			  ErrMsg.falseErrMsg(request, response, "500", "json格式解析异常");
			  Page.colseDOP(db, out, page);
			  return;
		}
		
		String delSql = "DELETE from "+table+"  where id ="+id;
		boolean updateStatus = db.executeUpdate(delSql);
		if(updateStatus==true){
			json.put("success", true);
			json.put("resultCode", "1000");
			json.put("msg", "删除成功");
		}else{
			json.put("success", true);
			json.put("resultCode", "2000");
			json.put("msg", "删除失败，请联系系统维护人员");
		}
		out.print(json);
		long ExeTime = Calendar.getInstance().getTimeInMillis()-info.getTimeStart();
		//添加操作日志
		Atm.LogSys("教师类型配置", "删除教师类型配置", "操作者 id:"+info.getUSERID()+"", "1",info.getUSERID(), info.getIp());
		// 记录执行日志
		Atm.AppuseLong(info, "", claspath, classname, json.toString(), ExeTime);
		Page.colseDOP(db, out, page);
		
		return;
	}
	//删除排课教师配置
	public void delArrange(HttpServletRequest request, HttpServletResponse response,String requestJson, InfoEntity info) throws ServletException, IOException {
		Jdbc db = new Jdbc();
		Page page = new Page();
		
		String classname="web  删排课教师配置";
		String claspath=this.getClass().getName();
		
		response.setContentType("text/html;charset=UTF-8");
		request.setCharacterEncoding("UTF-8");
		response.setCharacterEncoding("UTF-8");
		
		String journal="";//日志记录内容
		
		PrintWriter out = response.getWriter();
		JSONObject json = new JSONObject();
		
		
		//声明变量；
		String teacherid = "";
		String semester ="";
		String weekly ="";
		
		teacherid = request.getParameter("teacherid");
		semester = request.getParameter("semester");
		weekly = request.getParameter("weekly");
		try { // 解析开始
			JSONArray arr = JSONArray.fromObject("[" + requestJson + "]");
			for (int i = 0; i < arr.size(); i++) {
				JSONObject obj = arr.getJSONObject(i);
				teacherid = obj.get("teacherid") + "";    
				semester = obj.get("semester") + "";    
				weekly = obj.get("weekly") + "";    
			}
		} catch (Exception e) {
			ErrMsg.falseErrMsg(request, response, "500", "json格式解析异常");
			Page.colseDOP(db, out, page);
			return;
		}
		
		String delSql = "DELETE from arrage_course_teacher  where semester ='"+semester+"' and teacher_id ="+teacherid +" and weekly='"+weekly+"'";
		boolean updateStatus = db.executeUpdate(delSql);
		if(updateStatus==true){
			json.put("success", true);
			json.put("resultCode", "1000");
			json.put("msg", "删除成功");
		}else{
			json.put("success", true);
			json.put("resultCode", "2000");
			json.put("msg", "删除失败，请联系系统维护人员");
		}
		out.print(json);
		long ExeTime = Calendar.getInstance().getTimeInMillis()-info.getTimeStart();
		//添加操作日志
		Atm.LogSys("课教师配置", "删排课教师配置", "操作者 id:"+info.getUSERID()+"", "1",info.getUSERID(), info.getIp());
		// 记录执行日志
		Atm.AppuseLong(info, "", claspath, classname, json.toString(), ExeTime);
		Page.colseDOP(db, out, page);
		
		return;
	}
	//删除排课部门配置
	public void delArrangeDep(HttpServletRequest request, HttpServletResponse response,String requestJson, InfoEntity info) throws ServletException, IOException {
		Jdbc db = new Jdbc();
		Page page = new Page();
		
		String classname="web  删排课部门配置";
		String claspath=this.getClass().getName();
		
		response.setContentType("text/html;charset=UTF-8");
		request.setCharacterEncoding("UTF-8");
		response.setCharacterEncoding("UTF-8");
		
		String journal="";//日志记录内容
		
		PrintWriter out = response.getWriter();
		JSONObject json = new JSONObject();
		
		//声明变量；
		String teaching_room_id = "";
		String semester ="";
		String weekly ="";
		
		teaching_room_id = request.getParameter("teaching_room_id");
		semester = request.getParameter("semester");
		weekly = request.getParameter("weekly");
		try { // 解析开始
			JSONArray arr = JSONArray.fromObject("[" + requestJson + "]");
			for (int i = 0; i < arr.size(); i++) {
				JSONObject obj = arr.getJSONObject(i);
				teaching_room_id = obj.get("teacherid") + "";    
				semester = obj.get("semester") + "";    
				weekly = obj.get("weekly") + "";    
			}
		} catch (Exception e) {
			ErrMsg.falseErrMsg(request, response, "500", "json格式解析异常");
			Page.colseDOP(db, out, page);
			return;
		}
		
		String delSql = "DELETE from arrage_course_department  where semester ='"+semester+"' and teaching_room_id ="+teaching_room_id +" and weekly='"+weekly+"'";
		boolean updateStatus = db.executeUpdate(delSql);
		if(updateStatus==true){
			json.put("success", true);
			json.put("resultCode", "1000");
			json.put("msg", "删除成功");
		}else{
			json.put("success", true);
			json.put("resultCode", "2000");
			json.put("msg", "删除失败，请联系系统维护人员");
		}
		out.print(json);
		long ExeTime = Calendar.getInstance().getTimeInMillis()-info.getTimeStart();
		//添加操作日志
		Atm.LogSys("排课部门配置", "删除排课部门配置", "操作者"+info.getUSERID()+"", "1",info.getUSERID(), info.getIp());
		// 记录执行日志
		Atm.AppuseLong(info, "", claspath, classname, json.toString(), ExeTime);
		Page.colseDOP(db, out, page);
		
		return;
	}
	public void delTime(HttpServletRequest request, HttpServletResponse response,String requestJson, InfoEntity info) throws ServletException, IOException {
		Jdbc db = new Jdbc();
		Page page = new Page();
		
		String classname="web  删排课时间配置";
		String claspath=this.getClass().getName();
		
		response.setContentType("text/html;charset=UTF-8");
		request.setCharacterEncoding("UTF-8");
		response.setCharacterEncoding("UTF-8");
		
		String journal="";//日志记录内容
		
		PrintWriter out = response.getWriter();
		JSONObject json = new JSONObject();
		
		//声明变量；
		String semester ="";
		String weekly ="";
		
		semester = request.getParameter("semester");
		weekly = request.getParameter("weekly");
		try { // 解析开始
			JSONArray arr = JSONArray.fromObject("[" + requestJson + "]");
			for (int i = 0; i < arr.size(); i++) {
				JSONObject obj = arr.getJSONObject(i);
				semester = obj.get("semester") + "";    
				weekly = obj.get("weekly") + "";    
			}
		} catch (Exception e) {
			ErrMsg.falseErrMsg(request, response, "500", "json格式解析异常");
			Page.colseDOP(db, out, page);
			return;
		}
		
		String delSql = "DELETE from arrage_course_nottime  where academic_year ='"+semester+"' and weekly='"+weekly+"'";
		boolean updateStatus = db.executeUpdate(delSql);
		if(updateStatus==true){
			json.put("success", true);
			json.put("resultCode", "1000");
			json.put("msg", "删除成功");
		}else{
			json.put("success", true);
			json.put("resultCode", "2000");
			json.put("msg", "删除失败，请联系系统维护人员");
		}
		out.print(json);
		long ExeTime = Calendar.getInstance().getTimeInMillis()-info.getTimeStart();
		//添加操作日志
		Atm.LogSys("排课时间配置", "删排课时间配置", "操作者"+info.getUSERID()+"", "1",info.getUSERID(), info.getIp());
		// 记录执行日志
		Atm.AppuseLong(info, "", claspath, classname, json.toString(), ExeTime);
		Page.colseDOP(db, out, page);
		
		return;
	}
	public void findTeacherWeek(HttpServletRequest request, HttpServletResponse response,String requestJson, InfoEntity info) throws ServletException, IOException {
		Jdbc db = new Jdbc();
		Page page = new Page();
		
		String classname="WEB显示教师已设置周次";
		String claspath=this.getClass().getName();
		
		response.setContentType("text/html;charset=UTF-8");
		request.setCharacterEncoding("UTF-8");
		response.setCharacterEncoding("UTF-8");
		
		String journal="";//日志记录内容
		
		PrintWriter out = response.getWriter();
		JSONObject json = new JSONObject();
		
		
		//声明变量；
		String teacherid = "";
		String semester ="";
		
		teacherid = request.getParameter("teacherid");
		semester = request.getParameter("semester");
		try { // 解析开始
			JSONArray arr = JSONArray.fromObject("[" + requestJson + "]");
			for (int i = 0; i < arr.size(); i++) {
				JSONObject obj = arr.getJSONObject(i);
				teacherid = obj.get("teacherid") + "";    
				semester = obj.get("semester") + "";    
			}
		} catch (Exception e) {
			ErrMsg.falseErrMsg(request, response, "500", "json格式解析异常");
			Page.colseDOP(db, out, page);
			return;
		}
		
		String delSql = "SELECT t.weekly FROM arrage_course_teacher t where t.semester='"+semester+"' and t.teacher_id="+teacherid+" GROUP BY t.weekly" ;
		java.sql.ResultSet rs = db.executeQuery(delSql);
		StringBuffer sb = new StringBuffer();
		try {
			while(rs.next()){
				if(rs.getString("weekly").equals("0")){
					sb.append("<option value='0'>全部</option>");
				}else{
					sb.append("<option value='"+rs.getString("weekly")+"'>"+rs.getString("weekly")+"</option>");
				}
			}
		} catch (SQLException e) {
			json.put("success", false);
			e.printStackTrace();
		}
			json.put("success", true);
			json.put("resultCode", "1000");
			json.put("data", sb.toString());
		out.print(json);
		long ExeTime = Calendar.getInstance().getTimeInMillis()-info.getTimeStart();
		//添加操作日志
		Atm.LogSys("显示教师已设置周次", "显示教师已设置周次", "操作者"+info.getUSERID()+"", "1",info.getUSERID(), info.getIp());
		// 记录执行日志
		Atm.AppuseLong(info, "", claspath, classname, json.toString(), ExeTime);
		Page.colseDOP(db, out, page);
		
		return;
	}
	public void findTimeWeek(HttpServletRequest request, HttpServletResponse response,String requestJson, InfoEntity info) throws ServletException, IOException {
		Jdbc db = new Jdbc();
		Page page = new Page();
		
		String classname="WEB显示时间已设置周次";
		String claspath=this.getClass().getName();
		
		response.setContentType("text/html;charset=UTF-8");
		request.setCharacterEncoding("UTF-8");
		response.setCharacterEncoding("UTF-8");
		
		String journal="";//日志记录内容
		
		PrintWriter out = response.getWriter();
		JSONObject json = new JSONObject();
		
		
		//声明变量；
		String weekly = "";
		String semester ="";
		
		weekly = request.getParameter("weekly");
		semester = request.getParameter("semester");
		try { // 解析开始
			JSONArray arr = JSONArray.fromObject("[" + requestJson + "]");
			for (int i = 0; i < arr.size(); i++) {
				JSONObject obj = arr.getJSONObject(i);
				weekly = obj.get("weekly") + "";    
				semester = obj.get("semester") + "";    
			}
		} catch (Exception e) {
			ErrMsg.falseErrMsg(request, response, "500", "json格式解析异常");
			Page.colseDOP(db, out, page);
			return;
		}
		
		String delSql = "SELECT t.weekly FROM arrage_course_nottime t where t.academic_year='"+semester+"' GROUP BY t.weekly" ;
		java.sql.ResultSet rs = db.executeQuery(delSql);
		StringBuffer sb = new StringBuffer();
		try {
			while(rs.next()){
				if(rs.getString("weekly").equals("0")){
					sb.append("<option value='0'>全部</option>");
				}else{
					sb.append("<option value='"+rs.getString("weekly")+"'>"+rs.getString("weekly")+"</option>");
				}
			}
		} catch (SQLException e) {
			json.put("success", false);
			e.printStackTrace();
		}
		json.put("success", true);
		json.put("resultCode", "1000");
		json.put("data", sb.toString());
		out.print(json);
		long ExeTime = Calendar.getInstance().getTimeInMillis()-info.getTimeStart();
		//添加操作日志
		Atm.LogSys("显示时间已设置周次", "显示时间已设置周次", "操作者"+info.getUSERID()+"", "1",info.getUSERID(), info.getIp());
		// 记录执行日志
		Atm.AppuseLong(info, "", claspath, classname, json.toString(), ExeTime);
		Page.colseDOP(db, out, page);
		
		return;
	}
	public void findDepWeek(HttpServletRequest request, HttpServletResponse response,String requestJson, InfoEntity info) throws ServletException, IOException {
		Jdbc db = new Jdbc();
		Page page = new Page();
		
		String classname="WEB显示部门已设置周次";
		String claspath=this.getClass().getName();
		
		response.setContentType("text/html;charset=UTF-8");
		request.setCharacterEncoding("UTF-8");
		response.setCharacterEncoding("UTF-8");
		
		String journal="";//日志记录内容
		
		PrintWriter out = response.getWriter();
		JSONObject json = new JSONObject();
		
		
		//声明变量；
		String teaching_room_id = "";
		String semester ="";
		
		teaching_room_id = request.getParameter("teaching_room_id");
		semester = request.getParameter("semester");
		try { // 解析开始
			JSONArray arr = JSONArray.fromObject("[" + requestJson + "]");
			for (int i = 0; i < arr.size(); i++) {
				JSONObject obj = arr.getJSONObject(i);
				teaching_room_id = obj.get("teaching_room_id") + "";    
				semester = obj.get("semester") + "";    
			}
		} catch (Exception e) {
			ErrMsg.falseErrMsg(request, response, "500", "json格式解析异常");
			Page.colseDOP(db, out, page);
			return;
		}
		
		String delSql = "SELECT t.weekly FROM arrage_course_department t where t.semester='"+semester+"' and teaching_room_id="+teaching_room_id+" GROUP BY t.weekly" ;
		java.sql.ResultSet rs = db.executeQuery(delSql);
		StringBuffer sb = new StringBuffer();
		try {
			while(rs.next()){
				if(rs.getString("weekly").equals("0")){
					sb.append("<option value='0'>全部</option>");
				}else{
					sb.append("<option value='"+rs.getString("weekly")+"'>"+rs.getString("weekly")+"</option>");
				}
			}
		} catch (SQLException e) {
			json.put("success", false);
			e.printStackTrace();
		}
		json.put("success", true);
		json.put("resultCode", "1000");
		json.put("data", sb.toString());
		out.print(json);
		Page.colseDOP(db, out, page);
		
		return;
	}
}
