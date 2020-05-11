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
 * 导入user_worker相关操作
 * @company 010jiage
 * @author gf
 * @date:2018-3-20 上午11:13:16
 */
public class ImportConfigService {

	/**
	 * 学生导入user_woker
	 */
	public void studentInWorker(HttpServletRequest request, HttpServletResponse response,String requestJson, InfoEntity info) throws ServletException, IOException {
		Jdbc db = new Jdbc();
		Page page = new Page();

	    String classname="web  学生导入user_woker";
        String claspath=this.getClass().getName();
        
		response.setContentType("text/html;charset=UTF-8");
		request.setCharacterEncoding("UTF-8");
		response.setCharacterEncoding("UTF-8");
		String journal="";//日志记录内容
		PrintWriter out = response.getWriter();
    	JSONObject json = new JSONObject();
	    
	    String ids = request.getParameter("ids");
	    
	    try { // 解析开始
			JSONArray arr = JSONArray.fromObject("[" + requestJson + "]");
			for (int i = 0; i < arr.size(); i++) {
				JSONObject obj = arr.getJSONObject(i);
				ids = obj.get("ids") + "";     
			}
		} catch (Exception e) {
			  ErrMsg.falseErrMsg(request, response, "500", "json格式解析异常");
			  Page.colseDOP(db, out, page);
			  return;
		}
		
		String[] studuents = ids.split(",");
		boolean updateState = true;
		int i =0;
		StringBuffer sbk = new StringBuffer();
		StringBuffer sbl = new StringBuffer();
		if(studuents.length>0){
			for (String studentid : studuents) {
				String sql ="";
				String stuphoneSql = "select stuname,telephone from student_basic where id="+studentid;
				java.sql.ResultSet phoneSet = db.executeQuery(stuphoneSql);
				String stuphone ="";
				String stuname ="";
				try {
					while(phoneSet.next()){
						stuphone = phoneSet.getString("telephone");
						stuname = phoneSet.getString("stuname");
					}if(phoneSet!=null)phoneSet.close();
				} catch (SQLException e) {
					e.printStackTrace();
				}
				if(StringUtils.isBlank(stuphone)){
					sbk.append(stuname+",");
					continue;
				}
				String checkSql = "select count(uid) row from user_worker where usermob='"+stuphone+"' or ( userole=2 and user_association="+studentid +")";
				if(db.Row(checkSql)==0){
					sql ="INSERT INTO user_worker (nickname,username,usermob,state,userole,user_association,password) SELECT stuname nickname,stuname username,telephone usermob,1 state,2 userole,"+studentid+" user_association,111111 password  from student_basic where id="+studentid;
					int userId= db.executeUpdateRenum(sql);
					if(userId>0){
						boolean userRole_state = true;
						//给角色 普通学生
						String user_uprole="INSERT INTO zk_user_role  ( sys_user_id, sys_role_id) VALUES ('"+userId+"', 29);";
						userRole_state= db.executeUpdate(user_uprole);
						if(userRole_state){//更新用户角色信息成功
							updateState= true;
							i++;
						}else{
							updateState= false;
						}
					}else{
						updateState= false;
					}
				}else{sbl.append(stuname+",");continue;}
			}
		}
		if(updateState){
			json.put("success", true);
			json.put("resultCode", "1000");
			json.put("msg", "导入"+i+"条数据 ; "+sbk+"手机号为空 ; "+sbl+"数据已存在用户表");
		}else{
			json.put("msg", "导入失败");
		}
			out.print(json);
			
		long ExeTime = Calendar.getInstance().getTimeInMillis()-info.getTimeStart();
		//添加操作日志
		Atm.LogSys("学生批量导入", "学生批量导入", "操作者 id:"+info.getUSERID()+"", "1",info.getUSERID(), info.getIp());
		// 记录执行日志
		Atm.AppuseLong(info, "", claspath, classname, json.toString(), ExeTime);
		Page.colseDOP(db, out, page);
		return;
	}
	/**
	 * 教职工导入登录用户
	 * @param request
	 * @param response
	 * @param requestJson
	 * @param info
	 * @throws ServletException
	 * @throws IOException
	 */
	public void teacherInWorker(HttpServletRequest request, HttpServletResponse response,String requestJson, InfoEntity info) throws ServletException, IOException {
		Jdbc db = new Jdbc();
		Page page = new Page();
		
		String classname="web  教师导入user_woker";
		String claspath=this.getClass().getName();
		
		response.setContentType("text/html;charset=UTF-8");
		request.setCharacterEncoding("UTF-8");
		response.setCharacterEncoding("UTF-8");
		String journal="";//日志记录内容
		PrintWriter out = response.getWriter();
		JSONObject json = new JSONObject();
		
		String ids = request.getParameter("ids");
		
		try { // 解析开始
			JSONArray arr = JSONArray.fromObject("[" + requestJson + "]");
			for (int i = 0; i < arr.size(); i++) {
				JSONObject obj = arr.getJSONObject(i);
				ids = obj.get("ids") + "";     
			}
		} catch (Exception e) {
			ErrMsg.falseErrMsg(request, response, "500", "json格式解析异常");
			Page.colseDOP(db, out, page);
			return;
		}
		
		String[] teachers = ids.split(",");
		boolean updateState = true;
		int i =0;//成功导入数据条数
		StringBuffer sbk = new StringBuffer();
		StringBuffer sbl = new StringBuffer();
		if(teachers.length>0){
			for (String teacher : teachers) {
				String sql ="";
				String stuphoneSql = "select teacher_name,telephone from teacher_basic where id="+teacher;
				java.sql.ResultSet phoneSet = db.executeQuery(stuphoneSql);
				String stuphone ="";
				String teacher_name ="";
				try {
					while(phoneSet.next()){
						stuphone = phoneSet.getString("telephone");
						teacher_name = phoneSet.getString("teacher_name");
					}if(phoneSet!=null)phoneSet.close();
				} catch (SQLException e) {
					e.printStackTrace();
				}
				if(StringUtils.isBlank(stuphone)){
					sbk.append(teacher_name+",");
					continue;
				}
				String checkSql = "select count(uid) row from user_worker where usermob='"+stuphone+"' or ( userole=1 and user_association="+teacher +")";
				if(db.Row(checkSql)==0){
					sql ="INSERT INTO user_worker (nickname,username,usermob,state,userole,user_association,password) SELECT teacher_name nickname,teacher_name username,telephone usermob,1 state,1 userole,"+teacher+" user_association,111111 password  from teacher_basic where id="+teacher;
					int userId= db.executeUpdateRenum(sql);
					if(userId>0){
						boolean userRole_state = true;
						//给角色 普通学生
						String user_uprole="INSERT INTO zk_user_role  ( sys_user_id, sys_role_id) VALUES ('"+userId+"', 28);";
						userRole_state= db.executeUpdate(user_uprole);
						if(userRole_state){//更新用户角色信息成功
							updateState= true;
							i++;
						}else{
							updateState= false;
						}
					}else{
						updateState= false;
					}
				}else{ sbl.append(teacher_name+",");continue;}
			}
		}
		if(updateState){
			json.put("success", true);
			json.put("resultCode", "1000");
			json.put("msg", "导入"+i+"条数据 ; "+sbk+"手机号为空 ; "+sbl+"数据已存在用户表");
		}else{
			json.put("msg", "导入失败");
		}
		out.print(json);
		
		long ExeTime = Calendar.getInstance().getTimeInMillis()-info.getTimeStart();
		//添加操作日志
		Atm.LogSys("教师批量导入", "教师批量导入", "操作者 id:"+info.getUSERID()+"", "1",info.getUSERID(), info.getIp());
		// 记录执行日志
		Atm.AppuseLong(info, "", claspath, classname, json.toString(), ExeTime);
		Page.colseDOP(db, out, page);
		return;
	}
	
	
}
