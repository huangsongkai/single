package v1.web.admin.common;

import java.io.IOException;
import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;
import java.util.Calendar;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import service.dao.db.Page;
import service.sys.Atm;
import v1.Api;
import v1.haocheok.commom.entity.InfoEntity;

/**
 * 通用流程ajax 接口
 * @author zhoukai04171019
 * @date:2017-9-7 下午05:24:20
 */
public class OrdersProcess {
	
	public void getinfo(HttpServletRequest request, HttpServletResponse response,String RequestJson,InfoEntity info) throws IOException, ServletException{
		
		response.setContentType("text/html;charset=UTF-8");
		request.setCharacterEncoding("UTF-8");
		response.setCharacterEncoding("UTF-8");
		
    	PrintWriter out = response.getWriter();
		
    	
    	try {//解析开始
			JSONArray arr = JSONArray.fromObject("[" + RequestJson + "]");
			   for(int i = 0; i < arr.size(); i++) {
				   JSONObject obj = arr.getJSONObject(i);
				   String dataString = obj.get("data") + "";
				   String eeString = obj.get("ee") + "";
			   }
		 }catch(Exception e){
			   
		 }
		 
		request.setAttribute("p", "");
    	
		new Api().doPost(request, response);
		
		
		JSONObject json = new JSONObject();
		json.put("success", true);
		json.put("resultCode", "1000");
		json.put("orderid", "");
		json.put("msg", "提交成功");
		out.print(json);
		out.flush();
		out.close();
		return;
	}
	
}
