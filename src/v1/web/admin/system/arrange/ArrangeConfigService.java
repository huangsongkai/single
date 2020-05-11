package v1.web.admin.system.arrange;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
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
import v1.haocheok.commom.entity.InfoEntity;

public class ArrangeConfigService {

	
	/**
	 * 删除教学安排
	 * 删除时，生成任务书和教学安排表数据都删除，并且教师，合班一并删除，在教学计划里添加删除备注
	 */
	public void delArrange(HttpServletRequest request, HttpServletResponse response,String requestJson, InfoEntity info) throws ServletException, IOException {
		Jdbc db = new Jdbc();
		Page page = new Page();

	    String classname="web  删除教学安排";
        String claspath=this.getClass().getName();
        
		response.setContentType("text/html;charset=UTF-8");
		request.setCharacterEncoding("UTF-8");
		response.setCharacterEncoding("UTF-8");
		
		String journal="";//日志记录内容
		
		PrintWriter out = response.getWriter();
    	JSONObject json = new JSONObject();
	    
		//声明变量；
	    String teaching_task_id = "";
	    
	    teaching_task_id = request.getParameter("teaching_task_id");
	    try { // 解析开始
			JSONArray arr = JSONArray.fromObject("[" + requestJson + "]");
			for (int i = 0; i < arr.size(); i++) {
				JSONObject obj = arr.getJSONObject(i);
				teaching_task_id = obj.get("teaching_task_id") + "";    
			}
		} catch (Exception e) {
			  ErrMsg.falseErrMsg(request, response, "500", "json格式解析异常");
			  Page.colseDOP(db, out, page);
			  return;
		}
		boolean updateStatus = true;
		//查询是否有合办情况,删除合班
		String  hebanCheckSql = "select marge_class_id from teaching_tesk_marge where teaching_task_id="+teaching_task_id;
		String marge_class_id ="";
		java.sql.ResultSet hebanCheckRs = db.executeQuery(hebanCheckSql);
		try {
			while(hebanCheckRs.next()){
				marge_class_id = hebanCheckRs.getString("marge_class_id");
			}if(hebanCheckRs!=null)hebanCheckRs.close();
			//获取detailid，后面判断是否删除
			String taskDetailSql = "select teaching_task_detailed_id from teaching_task where id ="+teaching_task_id;
			java.sql.ResultSet taskDetailRs = db.executeQuery(taskDetailSql);
			String teaching_task_detailed_id ="";
			while(taskDetailRs.next()){
				 teaching_task_detailed_id = taskDetailRs.getString("teaching_task_detailed_id");
			}	if(taskDetailRs!=null)taskDetailRs.close();
			if(StringUtils.isBlank(marge_class_id)){
				//没有合班,确定teaching_task_detailed_id是否存在，存在先删除teaching_task_detailed数据,再删除teaching_task
				if(!teaching_task_detailed_id.equals("0")){
					String detailedCheck = "select count(id) row from teaching_task where teaching_task_detailed_id="+teaching_task_detailed_id ;
					int detailedNum = db.Row(detailedCheck);
					//如果teaching_task_detailed_id，存在别的数据中，不删除该条teaching_task_detailed
					if(detailedNum==1){
						String delDetailSql = "delete from teaching_task_detailed where id ="+teaching_task_detailed_id;
						updateStatus = db.executeUpdate(delDetailSql);
					}
				}
				String delSql = "delete from teaching_task where id="+teaching_task_id;
				updateStatus =  db.executeUpdate(delSql);
			}else{
				//合班,teaching_task_detailed_id肯定不是0
				String margeClassSql = "select id,teaching_task_id from teaching_tesk_marge where marge_class_id="+marge_class_id;
				java.sql.ResultSet margeClassRs = db.executeQuery(margeClassSql);
				String teachingDetailsNumSql="SELECT count(id) row from teaching_task t where t.teaching_task_detailed_id=(SELECT teaching_task_detailed_id  FROM teaching_task t where t.id="+teaching_task_id+")";
				int teachingDetailsNum = db.Row(teachingDetailsNumSql);
				//删除合班表
				String delMargeClassSql = "delete from marge_class where id="+marge_class_id;
				updateStatus = db.executeUpdate(delMargeClassSql);
				//删除合班信息
				String delTeachingMargeClassSql ="delete from teaching_tesk_marge where marge_class_id ="+marge_class_id;
				updateStatus = db.executeUpdate(delTeachingMargeClassSql);
				int i =1;
				while(margeClassRs.next()){
					i++;
					String delTeachingTaskSql = "delete from teaching_task where id="+margeClassRs.getString("teaching_task_id");
					updateStatus = db.executeUpdate(delTeachingTaskSql);
				}
				//如果teaching_detailid
				if(teachingDetailsNum==i){
					String delTeachingDetailSql = "delete from teaching_task_detailed where id="+teaching_task_detailed_id;
					updateStatus = db.executeUpdate(delTeachingDetailSql);
				}
				if(margeClassRs!=null)margeClassRs.close();
			}
		
		} catch (SQLException e) {
			updateStatus =false;
			e.printStackTrace();
		}
	
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
		Atm.LogSys(classname, journal, "操作者"+info.getUSERID()+"", "1",info.getUSERID(), info.getIp());
		// 记录执行日志
		Atm.AppuseLong(info, "", claspath, classname, json.toString(), ExeTime);
		Page.colseDOP(db, out, page);
		
		return;
	}
	
	public void delDelTasks(HttpServletRequest request, HttpServletResponse response,String requestJson, InfoEntity info) throws ServletException, IOException {
		Jdbc db = new Jdbc();
		Page page = new Page();
		
		String classname="web  删除任务书";
		String claspath=this.getClass().getName();
		
		response.setContentType("text/html;charset=UTF-8");
		request.setCharacterEncoding("UTF-8");
		response.setCharacterEncoding("UTF-8");
		
		String journal="";//日志记录内容
		
		PrintWriter out = response.getWriter();
		JSONObject json = new JSONObject();
		
		String teaching_task_class_id = request.getParameter("teaching_task_class_id");
		
		try { // 解析开始
			JSONArray arr = JSONArray.fromObject("[" + requestJson + "]");
			for (int i = 0; i < arr.size(); i++) {
				JSONObject obj = arr.getJSONObject(i);
				teaching_task_class_id = obj.get("teaching_task_class_id") + "";    
			}
		} catch (Exception e) {
			ErrMsg.falseErrMsg(request, response, "500", "json格式解析异常");
			Page.colseDOP(db, out, page);
			return;
		}
		boolean updateStatus = true;
		String taskClassSql ="select id from teaching_task where teaching_task_class_id="+teaching_task_class_id;
		java.sql.ResultSet taskClassRs = db.executeQuery(taskClassSql);
		try {
			while(taskClassRs.next()){
				String teaching_task_id = taskClassRs.getString("id");
				String margeCheck ="select marge_class_id from teaching_tesk_marge where teaching_task_id =" + teaching_task_id;
				java.sql.ResultSet margeCheckRs = db.executeQuery(margeCheck);
				String marge_class_id="";//合班id
				while(margeCheckRs.next()){
					marge_class_id = margeCheckRs.getString("marge_class_id");
				}
				if(StringUtils.isBlank(marge_class_id)){
					String delTask = "delete from teaching_task where id="+teaching_task_id;
					updateStatus  = db.executeUpdate(delTask);
				}else{
					String sql = "select teaching_task_id from teaching_tesk_marge where marge_class_id =  '"+marge_class_id+"' ";
					java.sql.ResultSet set =  db.executeQuery(sql);
					while(set.next()){
						String del_sqlString = "DELETE FROM teaching_task WHERE id = '"+set.getString("teaching_task_id")+"' ;";
						updateStatus = db.executeUpdate(del_sqlString);
						String del_sql1 = "DELETE FROM teaching_tesk_marge WHERE marge_class_id = '"+marge_class_id+"' ;";
						updateStatus = db.executeUpdate(del_sql1);
						String del_sql2 = "delete from marge_class where id = '"+marge_class_id+"'";
						updateStatus = db.executeUpdate(del_sql2);
						}
					//删除teaching_task 单条数据
					String delTeachingTask = "delete from teaching_task where id="+teaching_task_id;
					updateStatus = db.executeUpdate(delTeachingTask);
				}
				if(margeCheckRs!=null)margeCheckRs.close();
			}
			//删除任务书
			String delTask = "delete from teaching_task_class where id="+teaching_task_class_id;
			updateStatus = db.executeUpdate(delTask);
		} catch (SQLException e) {
			updateStatus =false;
			e.printStackTrace();
		}
		
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
		Atm.LogSys(classname, journal, "操作者"+info.getUSERID()+"", "1",info.getUSERID(), info.getIp());
		// 记录执行日志
		Atm.AppuseLong(info, "", claspath, classname, json.toString(), ExeTime);
		Page.colseDOP(db, out, page);
		
		return;
	}
	public void delDelTask(HttpServletRequest request, HttpServletResponse response,String requestJson, InfoEntity info) throws ServletException, IOException {
		Jdbc db = new Jdbc();
		Page page = new Page();
		
		String classname="web  删除任务书中单条数据";
		String claspath=this.getClass().getName();
		
		response.setContentType("text/html;charset=UTF-8");
		request.setCharacterEncoding("UTF-8");
		response.setCharacterEncoding("UTF-8");
		
		String journal="";//日志记录内容
		
		PrintWriter out = response.getWriter();
		JSONObject json = new JSONObject();
		
		String teaching_task_id = request.getParameter("teaching_task_id");
		System.out.println("aadadasad===="+teaching_task_id);
		try { // 解析开始
			JSONArray arr = JSONArray.fromObject("[" + requestJson + "]");
			for (int i = 0; i < arr.size(); i++) {
				JSONObject obj = arr.getJSONObject(i);
				teaching_task_id = obj.get("teaching_task_id") + "";    
			}
		} catch (Exception e) {
			ErrMsg.falseErrMsg(request, response, "500", "json格式解析异常");
			Page.colseDOP(db, out, page);
			return;
		}
		
		
		System.out.println("aadadasad===="+teaching_task_id);
		
		boolean updateStatus = true;
		//是否有合班 1 没有合班,直接删除teaching_task,再判断teaching_task_detailed_id,如果只要一条数据直接删除
		try {
			String margeCheck ="select marge_class_id from teaching_tesk_marge where teaching_task_id =" + teaching_task_id;
			System.out.println("margeCheckmargeCheckmargeCheckmargeCheck===="+margeCheck);
			java.sql.ResultSet margeCheckRs = db.executeQuery(margeCheck);
			String marge_class_id="";//合班id
			while(margeCheckRs.next()){
				marge_class_id = margeCheckRs.getString("marge_class_id");
			}
			if(StringUtils.isBlank(marge_class_id)){
				//未合班
				String delTask = "delete from teaching_task where id="+teaching_task_id;
				updateStatus  = db.executeUpdate(delTask);
			}else{
				String sql = "select teaching_task_id from teaching_tesk_marge where marge_class_id =  '"+marge_class_id+"' ";
				java.sql.ResultSet set =  db.executeQuery(sql);
				while(set.next()){
					String del_sqlString = "DELETE FROM teaching_task WHERE id = '"+set.getString("teaching_task_id")+"' ;";
					
					updateStatus = db.executeUpdate(del_sqlString);
					
					String del_sql1 = "DELETE FROM teaching_tesk_marge WHERE marge_class_id = '"+marge_class_id+"' ;";
					
					updateStatus = db.executeUpdate(del_sql1);
					
					String del_sql2 = "delete from marge_class where id = '"+marge_class_id+"'";
					
					updateStatus = db.executeUpdate(del_sql2);
				}
			}
			if(margeCheckRs!=null)margeCheckRs.close();
			//删除多教师安排
			String delSql ="delete from teaching_task_teacher where teaching_task_id="+teaching_task_id;
			updateStatus = db.executeUpdate(delSql);
		} catch (SQLException e) {
			updateStatus =false;
			e.printStackTrace();
		}
		
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
		Atm.LogSys(classname, journal, "操作者"+info.getUSERID()+"", "1",info.getUSERID(), info.getIp());
		// 记录执行日志
		Atm.AppuseLong(info, "", claspath, classname, json.toString(), ExeTime);
		Page.colseDOP(db, out, page);
		
		return;
	}
	
	/**
	 * 判断多教师是否可以设置
	 * @param request
	 * @param response
	 * @param requestJson
	 * @param info
	 * @throws ServletException
	 * @throws IOException
	 */
	public void teacherMany(HttpServletRequest request, HttpServletResponse response,String requestJson, InfoEntity info) throws ServletException, IOException {
		Jdbc db = new Jdbc();
		Page page = new Page();
		
		String classname="web  删除任务书";
		String claspath=this.getClass().getName();
		
		response.setContentType("text/html;charset=UTF-8");
		request.setCharacterEncoding("UTF-8");
		response.setCharacterEncoding("UTF-8");
		
		String journal="";//日志记录内容
		
		PrintWriter out = response.getWriter();
		JSONObject json = new JSONObject();
		
		String teaching_task_id = "";
		
		try { // 解析开始
			JSONArray arr = JSONArray.fromObject("[" + requestJson + "]");
			for (int i = 0; i < arr.size(); i++) {
				JSONObject obj = arr.getJSONObject(i);
				teaching_task_id = obj.get("teaching_task_id") + "";    
			}
		} catch (Exception e) {
			ErrMsg.falseErrMsg(request, response, "500", "json格式解析异常");
			Page.colseDOP(db, out, page);
			return;
		}
		boolean updateStatus = true;
		String taskClassSql ="select teacherid from teaching_task_teacher where teaching_task_id="+teaching_task_id+"	AND state=1	";
		String teacher_idString = "";
		java.sql.ResultSet taskClassRs = db.executeQuery(taskClassSql);
		try {
			while(taskClassRs.next()){
				teacher_idString = taskClassRs.getString("teacherid");
			}if(taskClassRs!=null){taskClassRs.close();}
		} catch (SQLException e) {
			updateStatus =false;
			e.printStackTrace();
		}
		
		if(teacher_idString==null || "0".equals(teacher_idString) || "".equals(teacher_idString)){
			json.put("success", false);
			json.put("resultCode", "2000");
			json.put("msg", "判断多教师");
			json.put("data", "");
		}else{
			json.put("success", true);
			json.put("resultCode", "1000");
			json.put("msg", "判断多教师");
			json.put("data", teacher_idString);
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
	
	
}
