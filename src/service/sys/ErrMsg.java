package service.sys;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONObject;

/**
 * 
 * @author Administrator
 * @date 2017-7-24
 * @file_name ErrMsg.java
 * @Remarks  返回错误信息错误提示
 */

@SuppressWarnings("serial")
public class ErrMsg extends HttpServlet {
	
	/*
	 * 自动输出错误信息-状态值为false
	 */
	public static void falseErrMsg(HttpServletRequest request, HttpServletResponse response,String errcode, String errinfo)throws ServletException, IOException {
		
		response.setContentType("text/html;charset=UTF-8");
		request.setCharacterEncoding("UTF-8");
		PrintWriter out = response.getWriter();
		JSONObject json = new JSONObject();
		
		json.put("success", false);
		json.put("resultCode", errcode);
		json.put("msg", errinfo);
		
		out.print(json);
		
		out.flush(); out.close();
	}
	/*
	 * 自动输出错误信息-状态值为true
	 */
	public static void trueErrMsg(HttpServletRequest request, HttpServletResponse response,JSONObject json,String errcode, String errinfo)throws ServletException, IOException {
		
		response.setContentType("text/html;charset=UTF-8");
		request.setCharacterEncoding("UTF-8");
		PrintWriter out = response.getWriter();
		
		json.put("success", false);
		json.put("resultCode", errcode);
		json.put("msg", errinfo);
		
		out.print(json);
		
		out.flush(); out.close();
	}
	
}