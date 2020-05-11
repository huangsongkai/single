package v1.web.cms.classAll;


import java.io.IOException;
import java.io.PrintWriter;
import java.sql.ResultSet;
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
import v1.haocheok.commom.entity.InfoEntity;

/**
 * 
 * @company 010jiage
 * @author zhoukai04171019
 * @date:2018-4-8 下午05:50:00
 */
public class InfoDeCalssAll {
	
	
	
	/**
	 * 通过校区获得院系
	 * @param request
	 * @param response
	 * @param RequestJson
	 * @param info
	 * @throws ServletException
	 * @throws IOException
	 */
	public void campusGetDepartment(HttpServletRequest request, HttpServletResponse response,String RequestJson,InfoEntity info,String theClassName) throws ServletException, IOException {
	
		    Jdbc db = new Jdbc();
		    Page page = new Page();
	       
            response.setContentType("text/html;charset=UTF-8");
			request.setCharacterEncoding("UTF-8");
			response.setCharacterEncoding("UTF-8");
			PrintWriter out = response.getWriter();

		    String classname="通过校区获取院系信息";
	        String claspath=this.getClass().getName();
	        String responsejson=""; //返回客户端数据 
	        JSONObject json = new JSONObject();
	    //定义json接受字段列表        
             
		   ArrayList list = new ArrayList();
		   
		   String xiaoqu = "";
		   
		   
		   try { // 解析开始
			   JSONArray arr = JSONArray.fromObject("[" + RequestJson + "]");
			   for (int i = 0; i < arr.size(); i++) {
				   JSONObject obj = arr.getJSONObject(i);
				    //定义json解析字段列表		
				   xiaoqu = obj.getString("xiaoqu");
				   		
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
		String select_sqlString = "select departments_name,id from dict_departments where campus = '"+xiaoqu+"'" ;
		StringBuffer major_html = new  StringBuffer();
		ResultSet rest = db.executeQuery(select_sqlString);
		major_html.append("<option value=\"0\">请选择院系</option>");
		while(rest.next()){
			major_html.append("<option value=\""+rest.getString("id")+"\">"+rest.getString("departments_name")+"</option>");
		}if(rest!=null){rest.close();}
					
		//生成json信息
		json.put("success", "true");
		json.put("resultCode", "1000");
		json.put("msg", "请求成功");
		json.put("data", major_html.toString());
		
		responsejson = json.toString();
		out.print(responsejson);
			 
        //记录日志
		long ExeTime = Calendar.getInstance().getTimeInMillis()-info.getTimeStart();
		String InsertSQLlog = "INSERT INTO  ec_appuse_log (`uuid`,`Mdels`,`NetMode`,`GPS`,`GPSLocal`,`username`,`did`,`uid`,`ExeTime`,`classpath`,`classname`,`ip`,`logintime`,`requestjson`,`responsejson`) VALUES ('"+info.getUUID()+"','"+info.getMdels()+"','"	+info.getNetMode()+"','"+info.getGPS()+"','"+info.getGPSLocal()+"','"	+info.getUSERID()+"','"+info.getDID()+"','"+info.getUSERID()+"','"+ExeTime+"','"+claspath+"','"+classname+"','"+info.getIp()+"',now(),'','');";
		db.executeUpdate(InsertSQLlog);
		// 记录日志end     
		Atm.LogSys("获取院系信息", "通过校区获取院系信息", "通过校区获取院系信息成功", "0", info.getUSERID(), info.getIp());
		
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
	 * 获取教研室信息
	 * @param request
	 * @param response
	 * @param RequestJson
	 * @param info
	 * @throws ServletException
	 * @throws IOException
	 */
	public void teachingResearch(HttpServletRequest request, HttpServletResponse response,String RequestJson,InfoEntity info,String theClassName) throws ServletException, IOException {
	
		    Jdbc db = new Jdbc();
		    Page page = new Page();
	       
            response.setContentType("text/html;charset=UTF-8");
			request.setCharacterEncoding("UTF-8");
			response.setCharacterEncoding("UTF-8");
			PrintWriter out = response.getWriter();

		    String classname="通过院系获取教研室";
	        String claspath=this.getClass().getName();
	        String responsejson=""; //返回客户端数据 
	        JSONObject json = new JSONObject();
	    //定义json接受字段列表        
             
		   ArrayList list = new ArrayList();
		   
		   String departments_id = "";
		   
		   
		   try { // 解析开始
			   JSONArray arr = JSONArray.fromObject("[" + RequestJson + "]");
			   for (int i = 0; i < arr.size(); i++) {
				   JSONObject obj = arr.getJSONObject(i);
				    //定义json解析字段列表		
				   departments_id = obj.getString("departments_id");
				   		
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
		String select_sqlString = "select teaching_research_name,id from teaching_research where departments_id = '"+departments_id+"'" ;
		StringBuffer major_html = new  StringBuffer();
		ResultSet rest = db.executeQuery(select_sqlString);
		major_html.append("<option value=\"0\">请选择教研室</option>");
		while(rest.next()){
			major_html.append("<option value=\""+rest.getString("id")+"\">"+rest.getString("teaching_research_name")+"</option>");
		}if(rest!=null){rest.close();}
					
		//生成json信息
		json.put("success", "true");
		json.put("resultCode", "1000");
		json.put("msg", "请求成功");
		json.put("data", major_html.toString());
		
		responsejson = json.toString();
		out.print(responsejson);
			 
        //记录日志
		long ExeTime = Calendar.getInstance().getTimeInMillis()-info.getTimeStart();
		String InsertSQLlog = "INSERT INTO  ec_appuse_log (`uuid`,`Mdels`,`NetMode`,`GPS`,`GPSLocal`,`username`,`did`,`uid`,`ExeTime`,`classpath`,`classname`,`ip`,`logintime`,`requestjson`,`responsejson`) VALUES ('"+info.getUUID()+"','"+info.getMdels()+"','"	+info.getNetMode()+"','"+info.getGPS()+"','"+info.getGPSLocal()+"','"	+info.getUSERID()+"','"+info.getDID()+"','"+info.getUSERID()+"','"+ExeTime+"','"+claspath+"','"+classname+"','"+info.getIp()+"',now(),'','');";
		db.executeUpdate(InsertSQLlog);
		// 记录日志end     
		// 添加操作日志
		Atm.LogSys("web获取获取教研室", "web获取教研室", "通过院系信息获得教研室", "0", info.getUSERID(), info.getIp());
		
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
	 * 获取专业信息
	 * @param request
	 * @param response
	 * @param RequestJson
	 * @param info
	 * @throws ServletException
	 * @throws IOException
	 */
	public void getMajor(HttpServletRequest request, HttpServletResponse response,String RequestJson,InfoEntity info,String theClassName) throws ServletException, IOException {
		
	    Jdbc db = new Jdbc();
	    Page page = new Page();
       
        response.setContentType("text/html;charset=UTF-8");
		request.setCharacterEncoding("UTF-8");
		response.setCharacterEncoding("UTF-8");
		PrintWriter out = response.getWriter();

	    String classname="通过院系获得专业";
        String claspath=this.getClass().getName();
        String responsejson=""; //返回客户端数据 
        JSONObject json = new JSONObject();
    //定义json接受字段列表        
         
	   ArrayList list = new ArrayList();
	   
	   String departments_id = "";
	   
	   
	   try { // 解析开始
		   JSONArray arr = JSONArray.fromObject("[" + RequestJson + "]");
		   for (int i = 0; i < arr.size(); i++) {
			   JSONObject obj = arr.getJSONObject(i);
			    //定义json解析字段列表		
			   departments_id = obj.getString("departments_id");
			   		
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
			String select_sqlString = "select major_name,id from major where departments_id = '"+departments_id+"'" ;
			StringBuffer major_html = new  StringBuffer();
			ResultSet rest = db.executeQuery(select_sqlString);
			major_html.append("<option value=\"0\">请选择专业</option>");
			while(rest.next()){
				major_html.append("<option value=\""+rest.getString("id")+"\">"+rest.getString("major_name")+"</option>");
			}if(rest!=null){rest.close();}
						
			//生成json信息
			json.put("success", "true");
			json.put("resultCode", "1000");
			json.put("msg", "请求成功");
			json.put("data", major_html.toString());
			
			responsejson = json.toString();
			out.print(responsejson);
				 
		    //记录日志
			long ExeTime = Calendar.getInstance().getTimeInMillis()-info.getTimeStart();
			String InsertSQLlog = "INSERT INTO  ec_appuse_log (`uuid`,`Mdels`,`NetMode`,`GPS`,`GPSLocal`,`username`,`did`,`uid`,`ExeTime`,`classpath`,`classname`,`ip`,`logintime`,`requestjson`,`responsejson`) VALUES ('"+info.getUUID()+"','"+info.getMdels()+"','"	+info.getNetMode()+"','"+info.getGPS()+"','"+info.getGPSLocal()+"','"	+info.getUSERID()+"','"+info.getDID()+"','"+info.getUSERID()+"','"+ExeTime+"','"+claspath+"','"+classname+"','"+info.getIp()+"',now(),'','');";
			db.executeUpdate(InsertSQLlog);
			// 记录日志end     
			//日志
			Atm.LogSys("获取专业信息", "通过院系信息获取专业信息", "获取专业信息成功", "0", info.getUSERID(), info.getIp());
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
	 * 获取班级信息信息
	 * @param request
	 * @param response
	 * @param RequestJson
	 * @param info
	 * @throws ServletException
	 * @throws IOException
	 */
	public void getClassGrade(HttpServletRequest request, HttpServletResponse response,String RequestJson,InfoEntity info,String theClassName) throws ServletException, IOException {
		
	    Jdbc db = new Jdbc();
	    Page page = new Page();
       
        response.setContentType("text/html;charset=UTF-8");
		request.setCharacterEncoding("UTF-8");
		response.setCharacterEncoding("UTF-8");
		PrintWriter out = response.getWriter();

	    String classname="通过专业获取班级信息";
        String claspath=this.getClass().getName();
        String responsejson=""; //返回客户端数据 
        JSONObject json = new JSONObject();
    //定义json接受字段列表        
         
	   ArrayList list = new ArrayList();
	   
	   String major_id = "";
	   
	   
	   try { // 解析开始
		   JSONArray arr = JSONArray.fromObject("[" + RequestJson + "]");
		   for (int i = 0; i < arr.size(); i++) {
			   JSONObject obj = arr.getJSONObject(i);
			    //定义json解析字段列表		
			   major_id = obj.getString("major_id");
			   		
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
			String select_sqlString = "select class_name,id from class_grade where majors_id = '"+major_id+"'" ;
			StringBuffer major_html = new  StringBuffer();
			ResultSet rest = db.executeQuery(select_sqlString);
			major_html.append("<option value=\"0\">请选择班级</option>");
			while(rest.next()){
				major_html.append("<option value=\""+rest.getString("id")+"\">"+rest.getString("class_name")+"</option>");
			}if(rest!=null){rest.close();}
						
			//生成json信息
			json.put("success", "true");
			json.put("resultCode", "1000");
			json.put("msg", "请求成功");
			json.put("data", major_html.toString());
			
			responsejson = json.toString();
			out.print(responsejson);
				 
		    //记录日志
			long ExeTime = Calendar.getInstance().getTimeInMillis()-info.getTimeStart();
			String InsertSQLlog = "INSERT INTO  ec_appuse_log (`uuid`,`Mdels`,`NetMode`,`GPS`,`GPSLocal`,`username`,`did`,`uid`,`ExeTime`,`classpath`,`classname`,`ip`,`logintime`,`requestjson`,`responsejson`) VALUES ('"+info.getUUID()+"','"+info.getMdels()+"','"	+info.getNetMode()+"','"+info.getGPS()+"','"+info.getGPSLocal()+"','"	+info.getUSERID()+"','"+info.getDID()+"','"+info.getUSERID()+"','"+ExeTime+"','"+claspath+"','"+classname+"','"+info.getIp()+"',now(),'','');";
			db.executeUpdate(InsertSQLlog);
			// 记录日志end     
			Atm.LogSys("排课课表分析查询", "通过专业获取班级", "通过专业获取班级成功", "0", info.getUSERID(), info.getIp());
			
			System.out.println("执行时间======"+ExeTime);
			
			
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
	 * 通过院系获得老师
	 * @param request
	 * @param response
	 * @param RequestJson
	 * @param info
	 * @throws ServletException
	 * @throws IOException
	 */
	public void getTeacherToDepartment(HttpServletRequest request, HttpServletResponse response,String RequestJson,InfoEntity info,String theClassName) throws ServletException, IOException {
		
		    Jdbc db = new Jdbc();
		    Page page = new Page();
	       
	        response.setContentType("text/html;charset=UTF-8");
			request.setCharacterEncoding("UTF-8");
			response.setCharacterEncoding("UTF-8");
			PrintWriter out = response.getWriter();
	
		    String classname="通过院系获得老师";
	        String claspath=this.getClass().getName();
	        String responsejson=""; //返回客户端数据 
	        JSONObject json = new JSONObject();
	    //定义json接受字段列表        
	         
		   ArrayList list = new ArrayList();
		   
		   String departments_id = "";
		   
		   
		   try { // 解析开始
			   JSONArray arr = JSONArray.fromObject("[" + RequestJson + "]");
			   for (int i = 0; i < arr.size(); i++) {
				   JSONObject obj = arr.getJSONObject(i);
				    //定义json解析字段列表		
				   departments_id = obj.getString("departments_id");
				   		
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
				String select_sqlString = "SELECT id,teacher_name FROM teacher_basic WHERE faculty = '"+departments_id+"'" ;
				StringBuffer major_html = new  StringBuffer();
				ResultSet rest = db.executeQuery(select_sqlString);
				major_html.append("<option value=\"0\">请选择老师</option>");
				while(rest.next()){
					major_html.append("<option value=\""+rest.getString("id")+"\">"+rest.getString("teacher_name")+"</option>");
				}if(rest!=null){rest.close();}
							
				//生成json信息
				json.put("success", "true");
				json.put("resultCode", "1000");
				json.put("msg", "请求成功");
				json.put("data", major_html.toString());
				
				responsejson = json.toString();
				out.print(responsejson);
					 
			    //记录日志
				long ExeTime = Calendar.getInstance().getTimeInMillis()-info.getTimeStart();
				String InsertSQLlog = "INSERT INTO  ec_appuse_log (`uuid`,`Mdels`,`NetMode`,`GPS`,`GPSLocal`,`username`,`did`,`uid`,`ExeTime`,`classpath`,`classname`,`ip`,`logintime`,`requestjson`,`responsejson`) VALUES ('"+info.getUUID()+"','"+info.getMdels()+"','"	+info.getNetMode()+"','"+info.getGPS()+"','"+info.getGPSLocal()+"','"	+info.getUSERID()+"','"+info.getDID()+"','"+info.getUSERID()+"','"+ExeTime+"','"+claspath+"','"+classname+"','"+info.getIp()+"',now(),'','');";
				db.executeUpdate(InsertSQLlog);
				// 记录日志end     
				Atm.LogSys("排课课表分析查询", "通过院系获得老师", "通过院系获得老师成功", "0", info.getUSERID(), info.getIp());
				
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
	 * 通过排课类别获取排课参数
	 * @param request
	 * @param response
	 * @param RequestJson
	 * @param info
	 * @param theClassName
	 * @throws ServletException
	 * @throws IOException
	 */
	public void getArrageParameters(HttpServletRequest request, HttpServletResponse response,String RequestJson,InfoEntity info,String theClassName) throws ServletException, IOException {
		
		Jdbc db = new Jdbc();
		Page page = new Page();
		
		response.setContentType("text/html;charset=UTF-8");
		request.setCharacterEncoding("UTF-8");
		response.setCharacterEncoding("UTF-8");
		PrintWriter out = response.getWriter();
		
		String classname="通过排课类别获取排课参数";
		String claspath=this.getClass().getName();
		String responsejson=""; //返回客户端数据 
		JSONObject json = new JSONObject();
		//定义json接受字段列表        
		
		ArrayList list = new ArrayList();
		
		String arrange_type = "";
		String school_number = "";
		
		try { // 解析开始
			JSONArray arr = JSONArray.fromObject("[" + RequestJson + "]");
			for (int i = 0; i < arr.size(); i++) {
				JSONObject obj = arr.getJSONObject(i);
				//定义json解析字段列表		
				arrange_type = obj.getString("arrange_type");
				school_number = obj.getString("school_number");
				
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
		String endSql ="";
		if(!arrange_type.equals("0")){
			endSql =" and course_class="+arrange_type;
		}
		try {   
			//开课通知单
			int num_kaike =  db.Row("SELECT COUNT(1) AS ROW FROM teaching_task where typestate=2 AND semester = '"+school_number+"' ; ");

			//课程数
			int num_kecheng = db.Row("SELECT COUNT(DISTINCT course_id) AS ROW FROM arrage_coursesystem where typestate=2 AND semester = '"+school_number+"'"+endSql);
			
			//教师数量
			int num_jiaoshi = db.Row("SELECT COUNT(DISTINCT teacher_id) AS ROW FROM arrage_coursesystem where  typestate=2 AND semester = '"+school_number+"' "+endSql);
			
			//可用教室数量
			int num_jiaoshu = db.Row("SELECT COUNT(1) AS ROW FROM classroom WHERE dedicated = 1 ;");
			
			//排课合班数
			int num_heban = db.Row("SELECT COUNT(1) AS ROW FROM arrage_coursesystem WHERE semester = '"+school_number+"' AND timetablestate != 1	AND	 marge_class_id!=0 "+endSql);
			
			//排课班级数
			int num_class = db.Row("SELECT COUNT(DISTINCT class_id) AS ROW FROM arrage_coursesystem where timetablestate = 0 and semester = '"+school_number+"' "+endSql);
			
			//以排课数量
			int companynumber = db.Row("SELECT COUNT(1) AS ROW FROM arrage_coursesystem WHERE semester = '"+school_number+"' AND timetablestate = 1 "+endSql);
			
			//未排课数量
			int nocompanynumber = db.Row("SELECT COUNT(1) AS ROW FROM arrage_coursesystem WHERE semester = '"+school_number+"' AND timetablestate != 1  AND is_merge_class!=1 AND marge_state!=1 "+endSql);
			
			//生成json信息
			json.put("success", "true");
			json.put("resultCode", "1000");
			json.put("msg", "请求成功");
			json.put("num_kaike", num_kaike);
			json.put("num_jiaoshi", num_jiaoshi);
			json.put("num_kecheng", num_kecheng);
			json.put("num_jiaoshu", num_jiaoshu);
			json.put("num_class", num_class);
			json.put("companynumber", companynumber);
			json.put("nocompanynumber", nocompanynumber);
			json.put("num_heban", num_heban);
			
			responsejson = json.toString();
			out.print(responsejson);
			
			//记录日志
			long ExeTime = Calendar.getInstance().getTimeInMillis()-info.getTimeStart();
			String InsertSQLlog = "INSERT INTO  ec_appuse_log (`uuid`,`Mdels`,`NetMode`,`GPS`,`GPSLocal`,`username`,`did`,`uid`,`ExeTime`,`classpath`,`classname`,`ip`,`logintime`,`requestjson`,`responsejson`) VALUES ('"+info.getUUID()+"','"+info.getMdels()+"','"	+info.getNetMode()+"','"+info.getGPS()+"','"+info.getGPSLocal()+"','"	+info.getUSERID()+"','"+info.getDID()+"','"+info.getUSERID()+"','"+ExeTime+"','"+claspath+"','"+classname+"','"+info.getIp()+"',now(),'','');";
			db.executeUpdate(InsertSQLlog);
			// 记录日志end     
			Atm.LogSys("自动编排课表", "自动编排课表获得参数", "自动编排课表获得参数成功", "0", info.getUSERID(), info.getIp());
			
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
	 * 根据院系和教研室获取老师
	 * @param request
	 * @param response
	 * @param RequestJson
	 * @param info
	 * @param theClassName
	 * @throws ServletException
	 * @throws IOException
	 */
	public void getteacherToDepartmentAndjiao(HttpServletRequest request, HttpServletResponse response,String RequestJson,InfoEntity info,String theClassName) throws ServletException, IOException {
		
	    Jdbc db = new Jdbc();
	    Page page = new Page();
       
        response.setContentType("text/html;charset=UTF-8");
		request.setCharacterEncoding("UTF-8");
		response.setCharacterEncoding("UTF-8");
		PrintWriter out = response.getWriter();

	    String classname="获取全部的班级信息";
        String claspath=this.getClass().getName();
        String responsejson=""; //返回客户端数据 
        JSONObject json = new JSONObject();
    //定义json接受字段列表        
         
	   ArrayList list = new ArrayList();
	   
	   String departments_id = "";
	   String jiaoyanshi = "";
	   
	   
	   try { // 解析开始
		   JSONArray arr = JSONArray.fromObject("[" + RequestJson + "]");
		   for (int i = 0; i < arr.size(); i++) {
			   JSONObject obj = arr.getJSONObject(i);
			    //定义json解析字段列表		
			   departments_id = obj.getString("departments_id");
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

		  try {   
			String select_sqlString = "SELECT id,teacher_name FROM teacher_basic WHERE faculty = '"+departments_id+"' AND teaching_staff_office = '"+jiaoyanshi+"'" ;
			
			System.out.println("select_sql=="+select_sqlString);
			
			StringBuffer major_html = new  StringBuffer();
			ResultSet rest = db.executeQuery(select_sqlString);
			major_html.append("<option value=\"0\">请选择老师</option>");
			while(rest.next()){
				major_html.append("<option value=\""+rest.getString("id")+"\">"+rest.getString("teacher_name")+"</option>");
			}if(rest!=null){rest.close();}
						
			//生成json信息
			json.put("success", "true");
			json.put("resultCode", "1000");
			json.put("msg", "请求成功");
			json.put("data", major_html.toString());
			
			responsejson = json.toString();
			out.print(responsejson);
				 
		    //记录日志
			long ExeTime = Calendar.getInstance().getTimeInMillis()-info.getTimeStart();
			String InsertSQLlog = "INSERT INTO  ec_appuse_log (`uuid`,`Mdels`,`NetMode`,`GPS`,`GPSLocal`,`username`,`did`,`uid`,`ExeTime`,`classpath`,`classname`,`ip`,`logintime`,`requestjson`,`responsejson`) VALUES ('"+info.getUUID()+"','"+info.getMdels()+"','"	+info.getNetMode()+"','"+info.getGPS()+"','"+info.getGPSLocal()+"','"	+info.getUSERID()+"','"+info.getDID()+"','"+info.getUSERID()+"','"+ExeTime+"','"+claspath+"','"+classname+"','"+info.getIp()+"',now(),'','');";
			db.executeUpdate(InsertSQLlog);
			// 记录日志end   
			//日志
			Atm.LogSys("获取教师信息", "根据院系与教研室获取教师信息", "获取教师信息成功", "0", info.getUSERID(), info.getIp());
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
	 * WEB通过教学区获得教室
	 * @param request
	 * @param response
	 * @param RequestJson
	 * @param info
	 * @param theClassName
	 * @throws ServletException
	 * @throws IOException
	 */
	public void getclassroomTobuilde(HttpServletRequest request, HttpServletResponse response,String RequestJson,InfoEntity info,String theClassName) throws ServletException, IOException {
		
	    Jdbc db = new Jdbc();
	    Page page = new Page();
       
        response.setContentType("text/html;charset=UTF-8");
		request.setCharacterEncoding("UTF-8");
		response.setCharacterEncoding("UTF-8");
		PrintWriter out = response.getWriter();

	    String classname="WEB通过教学区获得教室";
        String claspath=this.getClass().getName();
        String responsejson=""; //返回客户端数据 
        JSONObject json = new JSONObject();
    //定义json接受字段列表        
         
	   ArrayList list = new ArrayList();
	   
	   String teaching_area_id = "";
	   
	   
	   try { // 解析开始
		   JSONArray arr = JSONArray.fromObject("[" + RequestJson + "]");
		   for (int i = 0; i < arr.size(); i++) {
			   JSONObject obj = arr.getJSONObject(i);
			    //定义json解析字段列表		
			   teaching_area_id = obj.getString("teaching_area_id");
			   		
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
			  	String sqlwhere = "";
			  
			  	if(!"0".equals(teaching_area_id)){
			  		sqlwhere = "	AND		teaching_area_id = '"+teaching_area_id+"'";
			  	}
				String select_sqlString = "SELECT id,classroomname FROM classroom WHERE 1=1   "+sqlwhere+" ;" ;
				StringBuffer major_html = new  StringBuffer();
				ResultSet rest = db.executeQuery(select_sqlString);
				major_html.append("<option value=\"0\">请选择教室</option>");
				while(rest.next()){
					major_html.append("<option value=\""+rest.getString("id")+"\">"+rest.getString("classroomname")+"</option>");
				}if(rest!=null){rest.close();}
							
				//生成json信息
				json.put("success", "true");
				json.put("resultCode", "1000");
				json.put("msg", "请求成功");
				json.put("data", major_html.toString());
				
				responsejson = json.toString();
				out.print(responsejson);
					 
				//记录日志
				long ExeTime = Calendar.getInstance().getTimeInMillis()-info.getTimeStart();
				String InsertSQLlog = "INSERT INTO  ec_appuse_log (`uuid`,`Mdels`,`NetMode`,`GPS`,`GPSLocal`,`username`,`did`,`uid`,`ExeTime`,`classpath`,`classname`,`ip`,`logintime`,`requestjson`,`responsejson`) VALUES ('"+info.getUUID()+"','"+info.getMdels()+"','"	+info.getNetMode()+"','"+info.getGPS()+"','"+info.getGPSLocal()+"','"	+info.getUSERID()+"','"+info.getDID()+"','"+info.getUSERID()+"','"+ExeTime+"','"+claspath+"','"+classname+"','"+info.getIp()+"',now(),'','');";
				db.executeUpdate(InsertSQLlog);
				// 记录日志end   
				//日志
				Atm.LogSys("WEB通过教学区获得教室", "根据WEB通过教学区获得教室", "教学区获得教室信息成功", "0", info.getUSERID(), info.getIp());
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
	
	
	public void getbuildeToCampu(HttpServletRequest request, HttpServletResponse response,String RequestJson,InfoEntity info,String theClassName) throws ServletException, IOException {
		
	    Jdbc db = new Jdbc();
	    Page page = new Page();
       
        response.setContentType("text/html;charset=UTF-8");
		request.setCharacterEncoding("UTF-8");
		response.setCharacterEncoding("UTF-8");
		PrintWriter out = response.getWriter();

	    String classname="WEB通过分校获得教学区";
        String claspath=this.getClass().getName();
        String responsejson=""; //返回客户端数据 
        JSONObject json = new JSONObject();
    //定义json接受字段列表        
         
	   ArrayList list = new ArrayList();
	   
	   String xiaoqu = "";
	   
	   
	   try { // 解析开始
		   JSONArray arr = JSONArray.fromObject("[" + RequestJson + "]");
		   for (int i = 0; i < arr.size(); i++) {
			   JSONObject obj = arr.getJSONObject(i);
			    //定义json解析字段列表		
			   xiaoqu = obj.getString("xiaoqu");
			   		
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
			String select_sqlString = "SELECT id,teaching_area_name FROM teaching_area WHERE campus_id = '"+xiaoqu+"' ;" ;
			StringBuffer major_html = new  StringBuffer();
			ResultSet rest = db.executeQuery(select_sqlString);
			major_html.append("<option value=\"0\">请选择教学区</option>");
			while(rest.next()){
				major_html.append("<option value=\""+rest.getString("id")+"\">"+rest.getString("teaching_area_name")+"</option>");
			}if(rest!=null){rest.close();}
						
			//生成json信息
			json.put("success", "true");
			json.put("resultCode", "1000");
			json.put("msg", "请求成功");
			json.put("data", major_html.toString());
			
			responsejson = json.toString();
			out.print(responsejson);
				 
		    //记录日志
			long ExeTime = Calendar.getInstance().getTimeInMillis()-info.getTimeStart();
			String InsertSQLlog = "INSERT INTO  ec_appuse_log (`uuid`,`Mdels`,`NetMode`,`GPS`,`GPSLocal`,`username`,`did`,`uid`,`ExeTime`,`classpath`,`classname`,`ip`,`logintime`,`requestjson`,`responsejson`) VALUES ('"+info.getUUID()+"','"+info.getMdels()+"','"	+info.getNetMode()+"','"+info.getGPS()+"','"+info.getGPSLocal()+"','"	+info.getUSERID()+"','"+info.getDID()+"','"+info.getUSERID()+"','"+ExeTime+"','"+claspath+"','"+classname+"','"+info.getIp()+"',now(),'','');";
			db.executeUpdate(InsertSQLlog);
			// 记录日志end   
			//日志
			Atm.LogSys("WEB通过分校获得教学区", "根据WEB通过分校获得教学区", "通过分校获得教学区信息成功", "0", info.getUSERID(), info.getIp());
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
	
	

}
