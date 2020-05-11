package v1.haocheok.homepage.controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import service.dao.db.Jdbc;
import service.dao.db.Page;
import service.sys.ErrMsg;
import v1.haocheok.commom.entity.InfoEntity;
import v1.haocheok.homepage.service.impl.HomepageServiceImpl;

public class ApphomepageList {

	public void homepageList(HttpServletRequest request, HttpServletResponse response,String RequestJson,InfoEntity info) throws ServletException, IOException {

		Jdbc db = new Jdbc();
		Page page = new Page();

        String claspath=this.getClass().getName();//当前类名
        
		response.setContentType("text/html;charset=UTF-8");
		request.setCharacterEncoding("UTF-8");
		response.setCharacterEncoding("UTF-8");
		
		
    	PrintWriter out = response.getWriter();
	    	
    		//定义接收变量值
           	String regionalcode="";
		   
		   try { // 解析开始
			   
			   
			   JSONArray arr = JSONArray.fromObject("[" + RequestJson + "]");
			   
			   for (int i = 0; i < arr.size(); i++) {
				   JSONObject obj = arr.getJSONObject(i);
				   regionalcode = obj.get("regionalcode") + "";
			   }
		   }catch(Exception e){
			   ErrMsg.falseErrMsg(request, response, "500", "json格式解析异常");
			   return;
		   }
//		 System.out.println("参数:+"+Page.regex(regionalcode));

			//判断过滤非法字符: 
		    /*if( !Page.regex(regionalcode)){ 
		    	ErrMsg.falseErrMsg(request, response, "500", "数据格式不匹配");
			    Page.colseDOP(db, out, page);
			    return;//跳出程序只行 
		    }  */  
			
		   JSONObject json = new JSONObject();
		   ArrayList<Object> list = new ArrayList<Object>();
		   JSONObject json_homePage= new JSONObject();
		   ArrayList<Object> list_homePage = new ArrayList<Object>();
		   
			//1.token 认证过滤
System.out.println("token 认证过滤==="+"SELECT COUNT(*) as row FROM  user_worker WHERE uid ='"+info.getUSERID()+"' AND app_token='"+ info.getToken() + "'");
			int TokenTag=db.Row("SELECT COUNT(*) as row FROM  user_worker WHERE uid ='"+info.getUSERID()+"' AND app_token='"+ info.getToken() + "'");
			if(TokenTag!=1){
				ErrMsg.falseErrMsg(request, response, "403", "请登录！");
				Page.colseDOP(db, out, page);
				return;//跳出程序只行 
			}  
			
			//2.用户角色信息
			String sql_roleString = "select rolecode,name,zk_role.id as roleid from zk_user_role,zk_role where zk_user_role.sys_user_id='"+info.getUSERID()+"' and zk_user_role.sys_role_id = zk_role.id and zk_role.type!=0";
			ResultSet rolePrs = db.executeQuery(sql_roleString);
			String rolecode = "",roleid = ""; 
			try {
				if(rolePrs.next()){
					rolecode = rolePrs.getString("rolecode");
					roleid = rolePrs.getString("roleid");
				}if(rolePrs!=null){rolePrs.close();}
			
			
				//3.判断角色信息
				if("salesman".equals(rolecode)){
					//业务员
					json.put("success", "true");
					json.put("resultCode", "1000");
					json.put("msg", "业务员首页信息");
					
//					String sQL_button = "SELECT buttonname,url,http,buttonstatus,buttoncode FROM z_role_button,z_buttonfuntion WHERE z_role_button.roleid='"+roleid+"' AND z_buttonfuntion.buttonid = 4 and z_role_button.buttonid = z_buttonfuntion.id order by z_buttonfuntion.sort asc ";
					String sQL_button = "SELECT buttonname,url,http,buttonstatus,buttoncode,z_buttonfuntion_bak.fatherid AS buttonid FROM z_role_button_bak,z_buttonfuntion_bak WHERE z_role_button_bak.roleid = '"+roleid+"' AND z_buttonfuntion_bak.id = z_role_button_bak.buttonid AND z_buttonfuntion_bak.fatherid=24  ORDER BY z_buttonfuntion_bak.sort ASC ";
					System.out.println("sql语句:"+sQL_button);
					ResultSet button = db.executeQuery(sQL_button);
					while(button.next()){
						json_homePage.put("buttonname", button.getString("buttonname"));
						json_homePage.put("buttoncode", button.getString("buttoncode"));
						json_homePage.put("api", button.getString("url"));
						json_homePage.put("httptype" , button.getString("http"));
						json_homePage.put("if_click", "1");     //点击订单 是否执行事件  0：代表不执行   1：执行
						json_homePage.put("num", "123");
						list_homePage.add(json_homePage.toString());
					}
					
					
				}else if("salesmaner".equals(rolecode)){
					//业务主管
					json.put("success", "true");
					json.put("resultCode", "1000");
					json.put("msg", "业务员首页信息");
					
//					String sQL_button = "SELECT buttonname,url,http,buttonstatus,buttoncode FROM z_role_button,z_buttonfuntion WHERE z_role_button.roleid='"+roleid+"' AND z_buttonfuntion.buttonid = 5 and z_role_button.buttonid = z_buttonfuntion.id order by z_buttonfuntion.sort asc ";
					String sQL_button ="SELECT buttonname,url,http,buttonstatus,buttoncode,z_buttonfuntion_bak.fatherid AS buttonid FROM z_role_button_bak,z_buttonfuntion_bak WHERE z_role_button_bak.roleid = '"+roleid+"' AND z_buttonfuntion_bak.id = z_role_button_bak.buttonid AND z_buttonfuntion_bak.fatherid=27  ORDER BY z_buttonfuntion_bak.sort ASC ";
					System.out.println("sql语句:"+sQL_button);
					ResultSet button = db.executeQuery(sQL_button);
					while(button.next()){
						json_homePage.put("buttonname", button.getString("buttonname"));
						json_homePage.put("buttoncode", button.getString("buttoncode"));
						json_homePage.put("api", button.getString("url"));
						json_homePage.put("httptype" , button.getString("http"));
						json_homePage.put("if_click", "1");     //点击订单 是否执行事件  0：代表不执行   1：执行
						json_homePage.put("num", "123");
						list_homePage.add(json_homePage.toString());
					}
				}else{
					//调用应用层实现类接口
					HomepageServiceImpl homepageServiceImpl = new HomepageServiceImpl();
					String outputString = homepageServiceImpl.getHomepageList(regionalcode, info, claspath);
						
					out.println(outputString);
					
					page.colseDP(db, page);
					//记录日志
					
					out.flush();
					out.close();
					return ;
				}
			} catch (SQLException e) {
			}
			json.put("homePage", list_homePage.toString());
			out.println(json.toString());
			
			page.colseDP(db, page);
			//记录日志
			
			out.flush();
			out.close();
			
			
	}
}
