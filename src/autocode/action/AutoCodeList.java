package autocode.action;

/***
 *  
 * @author microfar  E-mail: 932246@qq.com 
 * @version 创建时间：2017-6-30 下午03:18:32 
 * 类说明 WEB-admin-系统管理-自动化代码生成器-数据接口
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
import service.sys.Atm;
import service.sys.ErrMsg;
import v1.haocheok.commom.entity.InfoEntity;
 

/**
 * 
 * @author Administrator
 * @date 2017-7-24
 * @file_name AutoCodeList.java
 * @Remarks 系统管理-自动化代码生成器-WEB数据接口
 */
public class AutoCodeList {

	public void autoCodeList(HttpServletRequest request, HttpServletResponse response,InfoEntity info,String Token,String UUID,String USERID,String DID,String Mdels,String NetMode,String ChannelId,String RequestJson,String ip,String GPS,String GPSLocal,String AppKeyType,long TimeStart) throws ServletException, IOException {
	    	Jdbc db = new Jdbc();
		 
		    String classname="系统管理-自动化代码生成器-WEB数据接口";
	        String claspath=this.getClass().getName();
	        
			response.setContentType("text/html;charset=UTF-8");
			request.setCharacterEncoding("UTF-8");
			response.setCharacterEncoding("UTF-8");
			
	    	PrintWriter out = response.getWriter();
	    	
	    	JSONObject responsejson = new JSONObject();
    	    JSONObject json = new JSONObject();
		    ArrayList<Object> list = new ArrayList<Object>();
		    
		    Page page = new Page ();
              
			//判断过滤非法字符: 
		    if(!Page.regex(UUID)){ 
		    	ErrMsg.falseErrMsg(request, response,"500", "数据格式不匹配");
		    	Page.colseDOP(db, out, page);
				return;//跳出程序只行 
		    }  
			    
			/*
			 *  解析json  
			 *   { "page": "1",  "listnum": "1",  "keyword": "" }
			 */
			    
		    /*
		     * Token合法性判断
		     */
			String uerTagSQL="SELECT COUNT(1) AS ROW  FROM  user_worker WHERE uid='"+UUID+"'  and pc_token='"+ Token + "';";
		    int UerTag = db.Row(uerTagSQL);
		    
		    if(UerTag == 0) 
		    {
		    	ErrMsg.trueErrMsg(request, response, json, "403", "Token非法，接口拒绝");
		    	Page.colseDOP(db, out, page);
				return;//跳出程序只行 
		    }
			  
			String keyword="";      // 查询关键词
			String Dpage = "1";     //当前页面
			String listnum="10";    //每页条数
				
		    try {//解析开始
		    	
				JSONArray arr = JSONArray.fromObject("[" + RequestJson + "]");
				for(int i = 0; i < arr.size(); i++){
					
					JSONObject obj = arr.getJSONObject(i);
				    keyword= obj.get("keywd") + "";
					Dpage = obj.get("page") + "";
					listnum = obj.get("listnum") + "";
				}
			}catch(Exception e){
				
				ErrMsg.falseErrMsg(request, response, "500", "json格式解析异常");
				Page.colseDOP(db, out, page);
				return;
			}
				
			if(keyword==null || keyword.indexOf("null")!=-1  ||  keyword.length()<1){keyword="0";}
				 
			if(Dpage==null || Dpage.indexOf("null")!=-1  ||  Dpage.length()<1){Dpage="1";}
			
			if(listnum==null || listnum.indexOf("null")!=-1 ||  listnum.length()<1){listnum="10";}
			 
				
				
			String whereString=""; //总的查询条件
			@SuppressWarnings("unused")
			String whereOderby=" id desc"; //初始化id排序
			String TJkeyword=""; //多标签查询条件
			 
			//处理关键词
			if(!"0".equals(keyword)){
				TJkeyword=" and (title like '"+"%"+page.mysqlCode(keyword).replaceAll(" ", "%")+"%' or code like '"+"%"+page.mysqlCode(keyword).replaceAll(" ", "%")+"%')"; //过滤整合关键词查询
			}
				
			 
			//总拼装查询提交语句
			whereString="where"+TJkeyword;
			whereString=whereString.replaceFirst("where and", "where ");
			if("where".equals(whereString)){whereString="";}//如果单独where就取消条件查询
				
				 
				  
			//分页 search
			 int listnum2=Integer.parseInt(listnum);;
			 int Asum2=db.Row("SELECT COUNT(1) as row FROM  auto_code  "+whereString);
			 int Zongshu=Asum2;
			 int pages2=Integer.parseInt(Dpage);
			 int Zpages2=0;
					
			 if(Asum2%listnum2==0){  
					Zpages2=(Asum2/listnum2);  
			 }else{ 
					Zpages2=(Asum2/listnum2)+1;  
			 }
				 
			 //if(pages2>Zpages2){pages2=1;}
			 int DQcount2=(pages2*listnum2)-listnum2;  
			 if(DQcount2<0){DQcount2=0;}	    
			   
				     
			 //主查询语句
			 String LogSql = "SELECT id,title,codepath,codetype,code,workerid,state,table_sql,addtime  FROM  auto_code "+whereString+" order by id desc   LIMIT "+DQcount2+", "+listnum2+"  ";
						
			 //System.out.println(classname+"\r\n\r\nRoomSql="+LogSql); 
			 
			 try {
				 ResultSet Rs = db.executeQuery(LogSql);
				 String btnid="";
				 while (Rs.next()) {
					 btnid=Rs.getString("id");
					 json.put("id", btnid);
					 json.put("title", Rs.getString("title"));
					 json.put("codepath", ""+Rs.getString("codepath")); 
					 json.put("codetype", ""+Rs.getString("codetype"));
					 json.put("code", ""+Rs.getString("code"));
					 json.put("workerid", ""+Rs.getString("workerid"));
					 if("0".equals(Rs.getString("state"))){
					   json.put("state", "<button class=\"layui-btn-mini layui-btn\" id=\""+btnid+"\">生成</button>");
					 }else{
					   json.put("state", "<button class=\"layui-btn-mini layui-btn-warm\" id=\""+btnid+"\">重新生成</button> <button class=\"layui-btn-mini layui-btn-normal\" id=\"showbtn"+btnid+"\">查看</button> <button class=\"layui-btn-mini layui-btn-normal\" onclick=\"opensql('"+btnid+"')\"  >查看SQL语句</button> <input type=\"hidden\" id=\"sqid"+btnid+"\" value=\""+Rs.getString("table_sql").replaceAll("", "").replaceAll("\r\n", "<br>")+"\">");
					 }
					 json.put("addtime", ""+Rs.getString("addtime"));
				  
					 list.add(json.toString()); 
				  
				 }if (Rs != null) {Rs.close();}
		    
				
				 responsejson.put("success", true);
				 responsejson.put("resultCode", "1000");
				 responsejson.put("msg", classname+"成功");
				 responsejson.put("currentpage",Dpage);
				 responsejson.put("pages",Zpages2 );
				 responsejson.put("Count",Zongshu );
				 responsejson.put("threads", list.toString());
		   	    		     
			out.println(responsejson);//返回给接口
			list.clear(); //清空

			// 记录执行日志
			long ExeTime = Calendar.getInstance().getTimeInMillis()-TimeStart;
			Atm.AppuseLong(info, "", claspath, classname, responsejson.toString(), ExeTime);
		} catch (Exception e) {
			
			 	int ErrLineNumber = e.getStackTrace()[0].getLineNumber();
			    ErrMsg.falseErrMsg(request, response,"500", "服务器开小差啦-"+ErrLineNumber+"");
			    Atm.LogSys("系统错误", classname+"模块系统出错", "错误信息详见 "+claspath+",第"+ErrLineNumber+"行。","1",USERID,ip);
			    Page.colseDOP(db, out, page);
			    return;//跳出程序只行 
		}

		Page.colseDOP(db, out, page);
	}
 

}
