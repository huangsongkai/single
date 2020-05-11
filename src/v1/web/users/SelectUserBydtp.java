package v1.web.users;
/** 
 * @author 王巨星  E-mail: 1031408541@qq.com 
 * @version 自动创建时间：2017-11-14 15:17:54
 * 类说明 查找文章内容
 */


import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Calendar;
import java.sql.ResultSet;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import service.dao.db.Jdbc;
import service.dao.db.Page;
import service.sys.ErrMsg;

 
public class SelectUserBydtp {

	private HttpServletRequest request;
	private HttpServletResponse response;

	public SelectUserBydtp (HttpServletRequest request, HttpServletResponse response) {
		this.request = request;
		this.response = response;
	}

	public void Transmit(String Token,String UUID,String USERID,String DID,String Mdels,String NetMode,String ChannelId,String RequestJson,String ip,String GPS,String GPSLocal,String AppKeyType,long TimeStart) throws ServletException, IOException {
		    Jdbc db = new Jdbc();
		    Page page = new Page();
	    
            response.setContentType("text/html;charset=UTF-8");
			request.setCharacterEncoding("UTF-8");
			response.setCharacterEncoding("UTF-8");
			PrintWriter out = response.getWriter();

		    String classname="查找用户";
	        String claspath=this.getClass().getName();

	    	//定义json接受字段列表
            String position="0";
	        String teachingResearch="0";     
	        String department="0";  
		    JSONObject json = new JSONObject();
		    ArrayList list = new ArrayList();		   
		   try { // 解析开始
			   JSONArray arr = JSONArray.fromObject("[" + RequestJson + "]");
			   for (int i = 0; i < arr.size(); i++) {
				   JSONObject obj = arr.getJSONObject(i);
				         //定义json解析字段列表
				   department=obj.get("department") + "";//所属院系
				   teachingResearch= obj.get("teachingresearch") + "";//教研室
				   position= obj.get("position") + "";//职务
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
			 	System.out.println(TokenTag);
			 	if(TokenTag!=1){
						ErrMsg.falseErrMsg(request, response, "403", "未授权请求！请登录。");
					    if (db != null) { db.close(); db = null; }
					    if (page != null) {page = null;}
					    out.flush();
					    out.close();
					   return;//跳出程序只行 
				}
          
			    //服务器响应代码部分

                //分页 search

	  try {   
		     
		      String SQL="";
	          String responsejson=""; //返回客户端数据 
              if(position.equals("0")&&teachingResearch.equals("0")&&department.equals("0")){
	               SQL="SELECT * FROM `user_worker`";}
              else if(position.equals("0")&&teachingResearch.equals("0")&&!department.equals("0")){
            	   SQL="SELECT * FROM `user_worker` where department='"+department+"'";            
              } else if(position.equals("0")&&!teachingResearch.equals("0")&&!department.equals("0")){
            	   SQL="SELECT * FROM `user_worker` WHERE department='"+department+"' AND teachingResearch='"+teachingResearch+"'";            
              } else if(!position.equals("0")&&teachingResearch.equals("0")&&department.equals("0")){
            	   SQL="SELECT * FROM `user_worker` WHERE position='"+position+"'";            
              } else if(!position.equals("0")&&!teachingResearch.equals("0")&&!department.equals("0")){
            	   SQL="SELECT * FROM `user_worker` WHERE position='"+position+"' AND department='"+department+"' AND teachingResearch='"+teachingResearch+"'";            
              }             
		      ResultSet RS = db.executeQuery(SQL);
			  while (RS.next()) {
				    json.put("uid", ""+RS.getString("uid"));
				    json.put("username", ""+RS.getString("username"));   
                    list.add(json.toString());  
			  }
			  if (RS != null) { RS.close(); }
		    
		        responsejson = "{\"success\":\"true\",\"resultCode\":\"1000\",\"msg\":\""+classname+"成功\",\"threads\":"+list.toString()+"}";		   
		        out.println(responsejson);//返回给客户端
			    list.clear(); //清空
		        //记录日志
      		    	long ExeTime = Calendar.getInstance().getTimeInMillis()-TimeStart;
      			    String InsertSQLlog = "INSERT INTO  ec_appuse_log (`uuid`,`Mdels`,`NetMode`,`GPS`,`GPSLocal`,`username`,`did`,`uid`,`ExeTime`,`classpath`,`classname`,`ip`,`logintime`,`requestjson`,`responsejson`) VALUES ('"+UUID+"','"+Mdels+"','"	+NetMode+"','"+GPS+"','"+GPSLocal+"','"	+USERID+"','"+DID+"','"+USERID+"','"+ExeTime+"','"+claspath+"','"+classname+"','"+ip+"',now(),'"+RequestJson+"','"+responsejson+"');";
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
