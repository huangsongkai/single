package v1.web.admin.powergroup;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.ResultSet;
import java.sql.SQLException;
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
 * @author Administrator  王旭东  测试
 * @date 2017-7-25
 * @file_name Jurisdiction.java
 * @Remarks  系统管理-权限-列表-WEB数据接口
 */
public class Jurisdiction {

//	public void jurisdiction(HttpServletRequest request, HttpServletResponse response,InfoEntity info,String Token,String UUID,String USERID,String DID,String Mdels,String NetMode,String ChannelId,String RequestJson,String ip,String GPS,String GPSLocal,String AppKeyType,long TimeStart) throws ServletException, IOException {
//			
//			Jdbc db = new Jdbc();
//			Page page = new Page();
//		 
//		    String classname="系统管理-权限管理-权限列表-WEB数据接口";
//	        String claspath=this.getClass().getName();
//	        
//			response.setContentType("text/html;charset=UTF-8");
//			request.setCharacterEncoding("UTF-8");
//			response.setCharacterEncoding("UTF-8");
//			
//	    	PrintWriter out = response.getWriter();
//	    	
//	    	JSONObject responsejson = new JSONObject();
//	    	JSONObject json = new JSONObject();
//	    	ArrayList<String> list = new ArrayList<String>();
//	    	
//			//判断过滤非法字符: 
//            if(!regex(UUID)){ 
//		    	ErrMsg.falseErrMsg(request, response, "500", "数据格式不匹配");
//		    	Page.colseDOP(db, out, page);
//				return;//跳出程序执行 
//		     }  
//			/*
//			 * Token合法性判断
//			 */
//			    
//		    int UerTag = db.Row("SELECT COUNT(1) AS ROW  FROM  user_worker WHERE uid='"+UUID+"'  and pc_token='"+ Token + "';");
//		    if (UerTag == 0) {
//				   out.print(Page.returnjson("403","Token非法，接口拒绝"));
//				   Page.colseDOP(db, out, page);
//				   return;//跳出程序执行 
//			 }
//			 //取出用户公司id
//			 String pubCompanyid="";
//			 try {
//				 ResultSet ComRs = db.executeQuery("SELECT companyid FROM `user_worker` WHERE  uid='"+UUID+"'  and pc_token='"+ Token + "';");
//				 if (ComRs.next()) {
//					 pubCompanyid=ComRs.getString("companyid");
//				 }if (ComRs != null) {  ComRs.close(); }
//			 }catch (SQLException e) {
//				 e.printStackTrace();
//			 }  
//			String keyword="";      // 查询关键词
//            String Dpage = "1";     //当前页面
//			String listnum="10";    //每页条数
//				
//		    try { // 解析开始
//				JSONArray arr = JSONArray.fromObject("[" + RequestJson + "]");
//				for (int i = 0; i < arr.size(); i++) {
//					JSONObject obj = arr.getJSONObject(i);
//				    keyword= obj.get("keywd") + "";
//					Dpage = obj.get("page") + "";
//					listnum = obj.get("listnum") + "";
//				}
//			} catch (Exception e) {
//				ErrMsg.falseErrMsg(request, response, "500", "json格式解析异常");
//				Page.colseDOP(db, out, page);
//				return;
//			}
//				
//			if(keyword==null || keyword.indexOf("null")!=-1  ||  keyword.length()<1){keyword="0";}
//			if(Dpage==null || Dpage.indexOf("null")!=-1  ||  Dpage.length()<1){Dpage="1";}
//			if(listnum==null || listnum.indexOf("null")!=-1 ||  listnum.length()<1){listnum="10";}
//				
//			String whereString=""; //总的查询条件
//			@SuppressWarnings("unused")
//			String whereOderby=" company_id desc"; //初始化id排序
//			String TJkeyword=""; //多标签查询条件
//			 
//				 
//			//处理关键词
//			if(!"0".equals(keyword)){
//				TJkeyword=" and (user_group_name like '"+"%"+page.mysqlCode(keyword).replaceAll(" ", "%")+"%' or user_group_txt like '"+"%"+page.mysqlCode(keyword).replaceAll(" ", "%")+"%')"; //过滤整合关键词查询
//			}
//				
//			 
//			//总拼装查询提交语句
//			whereString="where"+TJkeyword+" and companyid="+pubCompanyid;
//			whereString=whereString.replaceFirst("where and", "where ");
//			if("where".equals(whereString)){whereString="";}//如果单独where就取消条件查询
//				
//			 
//				  
//			//分页 search
//			int listnum2=Integer.parseInt(listnum);;
////		    int Asum2=db.Row("SELECT COUNT(1) as row FROM  `zk_role`  "+whereString);
//		    int Asum2=db.Row("SELECT COUNT(1) as row FROM  `zk_role`  ");
//			int Zongshu=Asum2;
//			int pages2=Integer.parseInt(Dpage);
//			int Zpages2=0;
//					
//			if(Asum2%listnum2==0){  
//				Zpages2=(Asum2/listnum2);  
//			}else{ 
//				Zpages2=(Asum2/listnum2)+1;  
//			}
//				 
//			//if(pages2>Zpages2){pages2=1;}
//			int DQcount2=(pages2*listnum2)-listnum2;  
//			if(DQcount2<0){DQcount2=0;}	    
//			   
//			//主查询语句
//			String Sql = "SELECT *  FROM  `zk_role` order by id desc   LIMIT "+DQcount2+", "+listnum2+"  ";
//			//System.out.println(classname+"\r\n\r\nRoomSql="+Sql); 
//			try {
//				 ResultSet Rs = db.executeQuery(Sql);
//				 list.clear(); //清空
//				 while (Rs.next()) {
//					 json.put("id", Rs.getString("id"));
//					 json.put("user_group_name", Rs.getString("name"));
//					 json.put("rolecode", Rs.getString("rolecode"));
//					 json.put("user_group_txt", ""+Rs.getString("rolecode")); 
//					 json.put("powerarrnum", Rs.getString("menu_sys_id").split("#").length);
//					 list.add(json.toString());  
//				 }if (Rs != null) { Rs.close(); }
//			} catch (Exception e) {
//				   int ErrLineNumber = e.getStackTrace()[0].getLineNumber();
//				   ErrMsg.falseErrMsg(request, response, "500", "服务器开小差啦"+ErrLineNumber);
//				   Atm.LogSys("系统错误", classname+"模块系统出错","错误信息详见 "+claspath, USERID, ip);
//				   Page.colseDOP(db, out, page);
//				   return;
//	
//			}
//
//			responsejson.put("success", true);
//			responsejson.put("resultCode", "1000");
//			responsejson.put("msg", classname+"成功");
//			responsejson.put("currentpage", Dpage);
//			responsejson.put("pages", Zpages2);
//			responsejson.put("Count", Zongshu);
//			responsejson.put("threads", list.toString());
//	
//	
//			out.println(responsejson);//返回给接口
//			// 记录执行日志
//			long ExeTime = Calendar.getInstance().getTimeInMillis()-TimeStart;
//			Atm.AppuseLong(info, USERID, claspath, classname, responsejson.toString(), ExeTime);
//			Page.colseDOP(db, out, page);
//	}
//	private boolean regex(String str){ 
//		java.util.regex.Pattern p=null; //正则表达式 
//		java.util.regex.Matcher m=null; //操作的字符串 
//		boolean value=true; 
//		try{ 
//		p = java.util.regex.Pattern.compile("[^0-9A-Za-z]"); 
//		m = p.matcher(str); 
//		if(m.find()) { 
//
//		value=false; 
//		} 
//		}catch(Exception e){} 
//		return value; 
//		} 
	
	public static String test(){
		Jdbc db = new Jdbc();
		
		
		boolean aa=db.executeUpdate("SET SESSION group_concat_max_len = 9999999;");
  	    if(aa){
  	    	System.out.println("设置会话中的group_concat长度成功");
  	    }else{
  	    	db.executeUpdate("SET SESSION group_concat_max_len = 9999999;");
  	    }
  	    
  	    ArrayList<String> list = new  ArrayList<String>();
		//查询语句
		String sql="SELECT  "+
			//"GROUP_CONCAT( "+
						"CONCAT("+
						"'<tr>',CHAR(13), "+
						"'    <td>',NAME,'</td>',CHAR(13), "+
						"'    <td>',rolecode,'</td>',CHAR(13), "+
						"'    <td>',IF(available=1,'可用','不可用'),'</td>',CHAR(13), "+
						"'    <td>', "+
						"	CASE  "+
						"	WHEN TYPE=0 THEN 'pc端'  "+
						"	WHEN TYPE=1 THEN '手机端' "+
						"	ELSE '全部' "+
						"END,    "+
						"'    </td>',CHAR(13), "+
						"'    <td>',CHAR(13), "+
						"'          <a href=\"\" target=\"_blank\" class=\"layui-btn layui-btn-normal layui-btn-mini\" >查看</a>',CHAR(13), "+
						"'          <a href=\"\" target=\"_blank\" class=\"layui-btn layui-btn-normal layui-btn-mini\" >修改权限</a>',CHAR(13), "+
						"'    </td>',CHAR(13), "+
						"'</tr>',CHAR(13) "+
						") AS shtml "+
					//"SEPARATOR '')
				"FROM zk_role ; ";
			System.out.println("sql==="+sql);
			String 	shtml="";	
			
			
			ResultSet rs = db.executeQuery(sql);
			try {
				list.clear();
				while(rs.next()){
					list.add(rs.getString("shtml"));
				}if(rs!=null){rs.close();}
			} catch (SQLException e) {
				e.printStackTrace();
			}
			if(db!=null){db.close();}
			return list.toString().replaceAll(", <","<").replaceAll("\\[", "").replaceAll("\\]", "");
	}
	public static void main(String[] args) {
		System.out.println(Jurisdiction.test());
	}

}
