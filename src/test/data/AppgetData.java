package test.data;
/** 
 * @author 周凯  E-mail:  
 * @version 自动创建时间：2017-07-11 11:41:17
 * 类说明 测试获取数据
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

 
public class AppgetData {

	private HttpServletRequest request;
	private HttpServletResponse response;

	public AppgetData (HttpServletRequest request, HttpServletResponse response) {
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

		    String classname="测试获取数据";
	        String claspath=this.getClass().getName();

	    	//定义json接受字段列表
            
           String Dpage="";
           String listnum="";
             
		  
		   
		   JSONObject json = new JSONObject();
		   ArrayList list = new ArrayList();
		   
		   try { // 解析开始
			   JSONArray arr = JSONArray.fromObject("[" + RequestJson + "]");
			   for (int i = 0; i < arr.size(); i++) {
				   JSONObject obj = arr.getJSONObject(i);
				    //定义json解析字段列表
				      
				   Dpage= obj.get("page") + "";
				   listnum= obj.get("listnum") + "";
		  
				    }
			    } catch (Exception e) {
			    	ErrMsg.falseErrMsg(request, response, "500", "json格式解析异常");
			     return;
			    }
				
				  //判断过滤非法字符: 
			     if(!Page.regex(UUID)){ 
			    	 ErrMsg.falseErrMsg(request, response, "403", "数据格式不匹配");
					    if (db != null) { db.close(); db = null; }
					    if (page != null) {page = null;}
					    out.flush();
					    out.close();
					   return;//跳出程序只行 
			    }    

                //token 认证过滤-如果不需要本接口请求授权，可以删掉本代码
			 	/*int TokenTag=db.Row("SELECT COUNT(*) as row FROM  user WHERE uid ='"+USERID+"' AND app_token='"+ Token + "'");
				if(TokenTag!=1){
					 errinfo.ShowErrMsg("403", "未授权请求！请登录。");
					    if (db != null) { db.close(); db = null; }
					    if (page != null) {page = null;}
					    out.flush();
					    out.close();
					   return;//跳出程序只行 
				}*/
          

		 
			    //服务器响应代码部分

                //分页 search

			   

				 int   listnum2=Integer.parseInt(listnum);;
				 int   Asum2=db.Row(" SELECT COUNT(*) as row FROM  `testdata` ");
				 int Zongshu=Asum2;
				 int pages2=Integer.parseInt(Dpage);
				 int Zpages2=0;
					
					if(Asum2%listnum2==0){  
					     Zpages2=(Asum2/listnum2);  
					  }else{ 
					     Zpages2=(Asum2/listnum2)+1;  
					 }
					int DQcount2=(pages2*listnum2)-listnum2;  
				    if(DQcount2<0){DQcount2=0;}	



	  try {   
	            String responsejson=""; //返回客户端数据 

	  	    /**
	  	     * 更新部分

              String UPSQL="UPDATE `user_order` SET `state`='"+state+"' WHERE `id`='"+id+"' and userid="+USERID;
		        if(db.executeUpdate(UPSQL)==true){
		          responsejson = "{\"success\":\"true\",\"resultCode\":\"1000\",\"msg\":\""+classname+"更新成功\"}";
		        }else{
		    	 responsejson = "{\"success\":\"true\",\"resultCode\":\"404\",\"msg\":\""+classname+"更新失败\"}";
		       }

	  	     */

	          String SQL=" SELECT * FROM `testdata`   order by id  LIMIT "+DQcount2+", "+listnum2+" ";
		    
		      ResultSet RS = db.executeQuery(SQL);
			  while (RS.next()) {
				  
                    json.put("id", ""+RS.getString("id"));
                    json.put("name", ""+RS.getString("name"));
                    json.put("age", ""+RS.getString("age"));
				  
                  list.add(json.toString());  
			  }
			  if (RS != null) { RS.close(); }
		    
		      responsejson = "{\"success\":\"true\",\"resultCode\":\"1000\",\"msg\":\""+classname+"成功\",\"currentpage\":\""
				+ Dpage
				+ "\",\"pages\":\""+Zpages2+"\",\"Count\":\""+Zongshu+"\",\"threads\":"+list.toString()+"}";
		   
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
