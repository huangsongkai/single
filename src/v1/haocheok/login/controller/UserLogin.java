package v1.haocheok.login.controller;

/** 
 * @author microfar  E-mail: 932246@qq.com 
 * @version 创建时间：2017-2-27 下午22:58:32 
 * @类说明 :app登录模块
 */


import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import service.dao.db.Page;
import service.sys.ErrMsg;
import v1.haocheok.commom.entity.InfoEntity;
import v1.haocheok.login.service.impl.APILoginServiceImpl;
 
public class UserLogin {

	public void userLogin(HttpServletRequest request, HttpServletResponse response,String RequestJson,InfoEntity info) throws ServletException, IOException {

		

	        String claspath=this.getClass().getName();
			response.setContentType("text/html;charset=UTF-8");
			request.setCharacterEncoding("UTF-8");
			response.setCharacterEncoding("UTF-8");
	    	PrintWriter out = response.getWriter();
           String mobile="";
           String password="";
		   
		   try { // 解析开始
			  
			   //System.out.println(RequestJson);
			   
			   JSONArray arr = JSONArray.fromObject("[" + RequestJson + "]");
			   
			   for(int i = 0; i < arr.size(); i++){
				   
				   JSONObject obj = arr.getJSONObject(i);
				   mobile = obj.get("user") + "";
				   password = obj.get("password") + "";
			   }
		   }catch(Exception e){
		   	 
			   ErrMsg.falseErrMsg(request, response, "500", "json格式解析异常");
			   return;
		   }
		 
		   //判断过滤非法字符: 
		   if(!Page.regex(mobile) || !Page.regex(password)){ 
			   ErrMsg.falseErrMsg(request, response, "500", "数据格式不匹配");
		       out.flush(); out.close();
			   return;//跳出程序只行 
			}    
		   //调用业务层实现接口
		   APILoginServiceImpl apiLoginServiceImpl = new APILoginServiceImpl();
		   String outputString = apiLoginServiceImpl.loginVerification(mobile, password , info,claspath);
		   
		   out.println(outputString);
		   
		   out.flush(); out.close();
	}

	 


}
