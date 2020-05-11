package v1.web.users;

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
import service.sys.ErrMsg;
import v1.haocheok.commom.entity.InfoEntity;

/**
 * 查询用户类别下用户列表
 * @company 010jiage
 * @author gf
 * @date:2018-3-21 上午11:22:26
 */
public class UserListService {

	public void getUserList(HttpServletRequest request, HttpServletResponse response,InfoEntity info,String Token,String UUID,String USERID,String DID,String Mdels,String NetMode,String ChannelId,String RequestJson,String ip,String GPS,String GPSLocal,String AppKeyType,long TimeStart) throws ServletException, IOException {
		
	    Jdbc db = new Jdbc();
	    Page page = new Page();
       
        response.setContentType("text/html;charset=UTF-8");
		request.setCharacterEncoding("UTF-8");
		response.setCharacterEncoding("UTF-8");
		PrintWriter out = response.getWriter();

	    String classname="获取用户类别列表信息";
        String claspath=this.getClass().getName();
        String responsejson=""; //返回客户端数据 
        JSONObject json = new JSONObject();
    //定义json接受字段列表        
         
	   ArrayList list = new ArrayList();
	   String userole = "";	
	   userole  = request.getParameter("id");
	   
	   try { // 解析开始
		   JSONArray arr = JSONArray.fromObject("[" + RequestJson + "]");
		   for (int i = 0; i < arr.size(); i++) {
			   JSONObject obj = arr.getJSONObject(i);
			    //定义json解析字段列表				     
			   userole = obj.getString("userole");
			    }
		    } catch (Exception e) {
		    	ErrMsg.falseErrMsg(request, response, "500", "json格式解析异常");
		     return;
		    }

		  try {   
			String select_sqlString = "SELECT id,teacher_name,teacher_number FROM teacher_basic ";
			ResultSet set = db.executeQuery(select_sqlString);
			String returnStr = "";
			while(set.next()){
				returnStr = returnStr+"<option value='"+set.getString("id")+"'>"+set.getString("teacher_name")+"["+set.getString("teacher_number")+"]</option>";
			}if(set!=null){set.close();}
						
			//生成json信息
			json.put("success", "true");
			json.put("resultCode", "1000");
			json.put("msg", "请求成功");
			json.put("data", returnStr);
			
			responsejson = json.toString();
			out.print(responsejson);
				 
			 //记录日志
			long ExeTime = Calendar.getInstance().getTimeInMillis()-TimeStart;
			String InsertSQLlog = "INSERT INTO  ec_appuse_log (`uuid`,`Mdels`,`NetMode`,`GPS`,`GPSLocal`,`username`,`did`,`uid`,`ExeTime`,`classpath`,`classname`,`ip`,`logintime`,`requestjson`,`responsejson`) VALUES ('"+UUID+"','"+Mdels+"','"	+NetMode+"','"+GPS+"','"+GPSLocal+"','"	+USERID+"','"+DID+"','"+USERID+"','"+ExeTime+"','"+claspath+"','"+classname+"','"+ip+"',now(),'','');";
			System.out.println(InsertSQLlog);
			db.executeUpdate(InsertSQLlog);
			// 记录日志end     
			
			} catch (Exception e) {
				 
					int ErrLineNumber = e.getStackTrace()[0].getLineNumber();
					ErrMsg.falseErrMsg(request, response, "500", "服务器开小差啦-"+ErrLineNumber);
			db.executeUpdate(" INSERT INTO `log_sys`(`ltype`,`title`,`body`,`uid`,`ip`,`addtime`) VALUES ('系统错误','"+classname+"模块系统出错','错误信息详见 "+claspath+",第"+ErrLineNumber+"行。','"+USERID+"','"+ip+"',now());;");
				    if (db != null) { db.close(); db = null; 	}
			        if (page != null) { 	page = null; 	}
			        out.flush();
					out.close();
				    return;
				}		
			           
				//关闭数据与serlvet.out
				if (db != null) { db.close(); db = null; }
				if (page != null) {page = null;}
						
				out.flush();
				out.close();
	}

public void getRoleList(HttpServletRequest request, HttpServletResponse response,InfoEntity info,String Token,String UUID,String USERID,String DID,String Mdels,String NetMode,String ChannelId,String RequestJson,String ip,String GPS,String GPSLocal,String AppKeyType,long TimeStart) throws ServletException, IOException {
		
	    Jdbc db = new Jdbc();
	    Page page = new Page();
       
        response.setContentType("text/html;charset=UTF-8");
		request.setCharacterEncoding("UTF-8");
		response.setCharacterEncoding("UTF-8");
		PrintWriter out = response.getWriter();

	    String classname="获取用户类别列表信息";
        String claspath=this.getClass().getName();
        String responsejson=""; //返回客户端数据 
        JSONObject json = new JSONObject();
        //定义json接受字段列表        
         
	   ArrayList list = new ArrayList();
	   String userole = "";	
	   userole  = request.getParameter("id");
	   try { // 解析开始
		   JSONArray arr = JSONArray.fromObject("[" + RequestJson + "]");
		   for (int i = 0; i < arr.size(); i++) {
			   JSONObject obj = arr.getJSONObject(i);
			    //定义json解析字段列表				     
			   userole = obj.getString("id");
			    }
		    } catch (Exception e) {
		    	ErrMsg.falseErrMsg(request, response, "500", "json格式解析异常");
		     return;
		    }
		  try {   
			String select_sqlString = "SELECT * FROM zk_role t where t.roleclass= "+userole;
			ResultSet set = db.executeQuery(select_sqlString);
			String returnStr = "";
			while(set.next()){
				//returnStr = returnStr+"<option value='"+set.getString("id")+"'>"+set.getString("name")+"["+set.getString("rolecode")+"]</option>";
				returnStr = returnStr + "{ id:"+set.getInt("id")+", name:'"+set.getString("name")+"', open:true,rolecode:'"+set.getString("rolecode")+"'},";
			}if(set!=null){set.close();}
			returnStr = "["+returnStr+"]";			
			
			
			String teacherStr = "<option value=''>无</option>";
			if(userole.equals("1")){
				//教师列表
				String teacherSql = "SELECT id,teacher_name,teacher_number FROM teacher_basic ";
				ResultSet teacherSet = db.executeQuery(teacherSql);
				while(teacherSet.next()){
					teacherStr = teacherStr+"<option value='"+teacherSet.getString("id")+"'>"+teacherSet.getString("teacher_name")+"["+teacherSet.getString("teacher_number")+"]</option>";
				}if(teacherSet!=null){teacherSet.close();}
			}else if(userole.equals("2")){
				//学生列表
				String studentSql = "SELECT id,stuname,student_number FROM student_basic ";
				ResultSet studentRs = db.executeQuery(studentSql);
				while(studentRs.next()){
					teacherStr = teacherStr+"<option value='"+studentRs.getString("id")+"'>"+studentRs.getString("stuname")+"["+studentRs.getString("student_number")+"]</option>";
				}if(studentRs!=null){studentRs.close();}
			}else{
				teacherStr = "<option value=''>无<option>";
			}
			
			//生成json信息
			json.put("success", "true");
			json.put("resultCode", "1000");
			json.put("msg", "请求成功");
			json.put("data", returnStr);
			json.put("teacherData", teacherStr);
			
			responsejson = json.toString();
			out.print(responsejson);
				 
			 //记录日志
			long ExeTime = Calendar.getInstance().getTimeInMillis()-TimeStart;
			String InsertSQLlog = "INSERT INTO  ec_appuse_log (`uuid`,`Mdels`,`NetMode`,`GPS`,`GPSLocal`,`username`,`did`,`uid`,`ExeTime`,`classpath`,`classname`,`ip`,`logintime`,`requestjson`,`responsejson`) VALUES ('"+UUID+"','"+Mdels+"','"	+NetMode+"','"+GPS+"','"+GPSLocal+"','"	+USERID+"','"+DID+"','"+USERID+"','"+ExeTime+"','"+claspath+"','"+classname+"','"+ip+"',now(),'','');";
			System.out.println(InsertSQLlog);
			db.executeUpdate(InsertSQLlog);
			// 记录日志end     
			
			} catch (Exception e) {
				 
					int ErrLineNumber = e.getStackTrace()[0].getLineNumber();
					ErrMsg.falseErrMsg(request, response, "500", "服务器开小差啦-"+ErrLineNumber);
			db.executeUpdate(" INSERT INTO `log_sys`(`ltype`,`title`,`body`,`uid`,`ip`,`addtime`) VALUES ('系统错误','"+classname+"模块系统出错','错误信息详见 "+claspath+",第"+ErrLineNumber+"行。','"+USERID+"','"+ip+"',now());;");
				    if (db != null) { db.close(); db = null; 	}
			        if (page != null) { 	page = null; 	}
			        out.flush();
					out.close();
				    return;
				}		
			           
				//关闭数据与serlvet.out
				if (db != null) { db.close(); db = null; }
				if (page != null) {page = null;}
						
				out.flush();
				out.close();
	}
}
