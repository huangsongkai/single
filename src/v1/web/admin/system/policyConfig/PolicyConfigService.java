package v1.web.admin.system.policyConfig;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
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
import v1.haocheok.commom.common;
import v1.haocheok.commom.entity.InfoEntity;

public class PolicyConfigService {

	public void find(HttpServletRequest request, HttpServletResponse response,String requestJson, InfoEntity info) throws ServletException, IOException {
		Jdbc db = new Jdbc();
		Page page = new Page();

	    String classname="web  查询政策类型";
        String claspath=this.getClass().getName();
        
		response.setContentType("text/html;charset=UTF-8");
		request.setCharacterEncoding("UTF-8");
		response.setCharacterEncoding("UTF-8");
		
		String journal="";//日志记录内容
		
		PrintWriter out = response.getWriter();
    	JSONObject json = new JSONObject();

	    
		//声明变量；
	    String id = "";//政策id
	    
	    id = request.getParameter("id");
System.out.println(id);
	    try { // 解析开始
			JSONArray arr = JSONArray.fromObject("[" + requestJson + "]");
			for (int i = 0; i < arr.size(); i++) {
				JSONObject obj = arr.getJSONObject(i);
				id = obj.get("id") + "";     //经销商配置id
			}
		} catch (Exception e) {
			  ErrMsg.falseErrMsg(request, response, "500", "json格式解析异常");
			  Page.colseDOP(db, out, page);
			  return;
		}
		
		String sql = "select * from g_policy where id = "+id;
		java.sql.ResultSet res = db.executeQuery(sql);
		String jsonStr;
		try {
			jsonStr = common.resultSetToJson(res);
			json.put("success", true);
			json.put("resultCode", "1000");
			json.put("data", jsonStr);
			json.put("msg", "查询成功");
		} catch (SQLException e) {
			e.printStackTrace();
			json.put("success", true);
			json.put("resultCode", "2000");
			json.put("msg", "查询失败");
		}
		
		out.print(json);
System.out.println(json);
		long ExeTime = Calendar.getInstance().getTimeInMillis()-info.getTimeStart();
		//添加操作日志
		Atm.LogSys(classname, journal, "操作者"+info.getUSERID()+"", "1",info.getUSERID(), info.getIp());
		// 记录执行日志
		Atm.AppuseLong(info, "", claspath, classname, json.toString(), ExeTime);
		Page.colseDOP(db, out, page);
		
		return;
	}
	
	public void del(HttpServletRequest request, HttpServletResponse response,String requestJson, InfoEntity info) throws ServletException, IOException {
		Jdbc db = new Jdbc();
		Page page = new Page();

	    String classname="web  删除政策配置";
        String claspath=this.getClass().getName();
        
		response.setContentType("text/html;charset=UTF-8");
		request.setCharacterEncoding("UTF-8");
		response.setCharacterEncoding("UTF-8");
		
		String journal="";//日志记录内容
		
		PrintWriter out = response.getWriter();
    	JSONObject json = new JSONObject();

	    
		//声明变量；
	    String id = "";//经销商配置id
	    
	    id = request.getParameter("id");
System.out.println(id);
	    try { // 解析开始
			JSONArray arr = JSONArray.fromObject("[" + requestJson + "]");
			for (int i = 0; i < arr.size(); i++) {
				JSONObject obj = arr.getJSONObject(i);
				id = obj.get("id") + "";     //政策配置id
			}
		} catch (Exception e) {
			  ErrMsg.falseErrMsg(request, response, "500", "json格式解析异常");
			  Page.colseDOP(db, out, page);
			  return;
		}
		
		String delSql = "DELETE from g_policy where id ="+id;
		boolean updateStatus = db.executeUpdate(delSql);
		if(updateStatus==true){
			json.put("success", true);
			json.put("resultCode", "1000");
			json.put("msg", "删除成功");
		}else{
			json.put("success", true);
			json.put("resultCode", "2000");
			json.put("msg", "删除失败，请联系系统维护人员");
		}
		
		out.print(json);
System.out.println(json);
		long ExeTime = Calendar.getInstance().getTimeInMillis()-info.getTimeStart();
		//添加操作日志
		Atm.LogSys(classname, journal, "操作者"+info.getUSERID()+"", "1",info.getUSERID(), info.getIp());
		// 记录执行日志
		Atm.AppuseLong(info, "", claspath, classname, json.toString(), ExeTime);
		Page.colseDOP(db, out, page);
		
		return;
	}
}
