package v1.web.cms.classAll;
/**
 * @author zhou
 */


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

 
public class ClassAll {


	public void getClassAll(HttpServletRequest request, HttpServletResponse response,InfoEntity info,String Token,String UUID,String USERID,String DID,String Mdels,String NetMode,String ChannelId,String RequestJson,String ip,String GPS,String GPSLocal,String AppKeyType,long TimeStart) throws ServletException, IOException {
	
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
		   
		   String semester = "";			//入学年份
		   String dict_coursesid = "";		//课程id
		   String taskid=  "";				//task 表中id
		   
		   
		   
		   try { // 解析开始
			   JSONArray arr = JSONArray.fromObject("[" + RequestJson + "]");
			   for (int i = 0; i < arr.size(); i++) {
				   JSONObject obj = arr.getJSONObject(i);
				    //定义json解析字段列表				     
				   	semester = obj.getString("semester");
				   	dict_coursesid = obj.getString("dict_coursesid");
				   	taskid = obj.getString("taskid");
				    }
			    } catch (Exception e) {
			    	ErrMsg.falseErrMsg(request, response, "500", "json格式解析异常");
			     return;
			    }
				
				  //判断过滤非法字符: 
			     if(!page.regex(UUID)){ 
			            ErrMsg.falseErrMsg(request, response,"403", "数据格式不匹配");
					    if (db != null) { db.close(); db = null; }
					    if (page != null) {page = null;}
					    out.flush();
					    out.close();
					   return;//跳出程序只行 
			    }    
			    

                //token 认证过滤-如果不需要本接口请求授权，可以删掉本代码
			 	int TokenTag=db.Row("SELECT COUNT(*) as row FROM  user_worker WHERE uid ='"+USERID+"' AND (app_token='"+Token+"' OR pc_token='"+Token+"')");
				if(TokenTag!=1){
					  
						ErrMsg.falseErrMsg(request, response, "403", "未授权请求！请登录。");
					    if (db != null) { db.close(); db = null; }
					    if (page != null) {page = null;}
					    out.flush();
					    out.close();
					   return;//跳出程序只行 
				}

	  try {   
		String select_sqlString = "select id,class_name,people_number_nan,people_number_woman from class_grade WHERE school_year='"+semester+"' ";
		select_sqlString = "SELECT class_grade.id,class_grade.class_name,class_grade.people_number_nan,class_grade.people_number_woman FROM teaching_task LEFT JOIN class_grade ON teaching_task.class_id = class_grade.id WHERE teaching_task.course_id = '"+dict_coursesid+"' AND semester='"+semester+"'  AND teaching_task.id != '"+taskid+"'";
		System.out.println("select_sqlString==="+select_sqlString);
		ResultSet set = db.executeQuery(select_sqlString);
		String returnStr = "";
		while(set.next()){
			int num = set.getInt("people_number_nan")+set.getInt("people_number_woman");
			String class_name = set.getString("class_name");
			returnStr = returnStr+"<option value='"+set.getString("id")+"' ondblclick='moveRight()'>"+class_name+"["+num+"]</option>";
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

}
