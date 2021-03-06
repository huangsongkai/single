package v1.web.cms.articles;
/** 
 * @author 王巨星  E-mail: 1031408541@qq.com 
 * @version 自动创建时间：2017-11-10 15:16:39
 * 类说明 添加文章
 */


import java.io.IOException;
import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.sql.ResultSet;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import service.dao.db.Jdbc;
import service.dao.db.Page;
import service.sys.ErrMsg;

public class AddArticles {

	private HttpServletRequest request;
	private HttpServletResponse response;

	public AddArticles (HttpServletRequest request, HttpServletResponse response) {
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

		    String classname="添加文章";
	        String claspath=this.getClass().getName();
            
	    	//定义json接受字段列表
            
           String classna="";
           String title="";
           String text="";
           String texts="";
           String author="";
           String addtime="";
           String visible="";
           String source="";
           String department="";
	       String attribute="";
	       String range="";
	       String num="";
           String attachment="";
           String titlecolor="";
           String twoid="";
           String endtime="";
		   JSONObject json = new JSONObject();
		   ArrayList list = new ArrayList();
		   
		   try { // 解析开始
					  
			   JSONArray arr = JSONArray.fromObject("[" + RequestJson + "]");
			   for (int i = 0; i < arr.size(); i++) {
				   JSONObject obj = arr.getJSONObject(i);
				    //定义json解析字段列表				          
						 classna= obj.get("classna") + "";
						 title= obj.get("title") + "";
						 texts= obj.get("text") + "";
						 texts=texts.replaceAll("％", "%");
						 author= obj.get("author") + "";
						 addtime= obj.get("addtime") + "";
						 visible= obj.get("visible") + "";
						 source= obj.get("source") + "";
						 department=obj.get("department") + "";
					     attribute=obj.get("attribute") + "";
					     range=obj.get("range") + "";
					     num=obj.get("num") + "";
					     attachment=obj.get("attachment") + "";
					     titlecolor=obj.get("titlecolor") + "";
					     twoid=obj.get("twoid") + "";
					     endtime=obj.get("endtime") + "";
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
			    //服务器响应代码部分
	  try {   
		        text= unescape(texts);
		        String oneid="";
	            String responsejson=""; //返回客户端数据 department="";
	            String SQL=" SELECT fid FROM `cms_class` WHERE id="+twoid+"";
			      ResultSet RS = db.executeQuery(SQL);
				  while (RS.next()){			  
					   oneid= RS.getString("fid");}
	  	     
			   //获取内容中的第一张图片 gaosong后期添加功能
				  
				  Matcher newsbodyimgRs=Pattern.compile("src=(.*?)[^>]*?>").matcher(text);   
				  if(newsbodyimgRs.find()){ //获取内容中的第一张图片
					  attachment=newsbodyimgRs.group(0).replaceAll("<\\/?[^>]+>","").replaceAll("src=\"|/>|\"","").replaceAll(" ","").replaceAll("alt=","");  
				   }
				//添加部分
				  
	          String UPSQL="INSERT INTO `cms_articles`(`classna`,`title`,`text`,`author`,`addtime`,`visible`,`source`,`department`,`attribute`,`range`,`num`,`attachment`,`title_color`,`one_class_id`,`two_class_id`,`endtime`) VALUES ('"+classna+"','"+title+"','"+text+"','"+author+"','"+addtime+"','"+visible+"','"+source+"','"+department+"','"+attribute+"','"+range+"','"+num+"','"+attachment+"','"+titlecolor+"','"+oneid+"','"+twoid+"','"+endtime+"');";
		        if(db.executeUpdate(UPSQL)==true){
		          responsejson = "{\"success\":\"true\",\"resultCode\":\"1000\",\"msg\":\""+classname+"添加文章成功\"}";
		        }else{
		    	 responsejson = "{\"success\":\"true\",\"resultCode\":\"404\",\"msg\":\""+classname+"添加文章失败\"}";
		       }
	  	     
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
	//解码(解js前台加密的文章)王巨星
public static String unescape(String src) {
        StringBuffer tmp = new StringBuffer();
        tmp.ensureCapacity(src.length());
        int lastPos = 0, pos = 0;
        char ch;
        while (lastPos < src.length()) {
            pos = src.indexOf("%", lastPos);
            if (pos == lastPos) {
                if (src.charAt(pos + 1) == 'u') {
                    ch = (char) Integer.parseInt(src
                            .substring(pos + 2, pos + 6), 16);
                    tmp.append(ch);
                    lastPos = pos + 6;
                } else {
                    ch = (char) Integer.parseInt(src
                            .substring(pos + 1, pos + 3), 16);
                    tmp.append(ch);
                    lastPos = pos + 3;
                }
            } else {
                if (pos == -1) {
                    tmp.append(src.substring(lastPos));
                    lastPos = src.length();
                }else {
                    tmp.append(src.substring(lastPos, pos));
                    lastPos = pos;
                }
            }
        }
        return tmp.toString();
    }
}
