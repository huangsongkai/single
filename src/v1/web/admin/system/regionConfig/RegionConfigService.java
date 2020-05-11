package v1.web.admin.system.regionConfig;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.util.Calendar;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

//import com.mysql.jdbc.ResultSet;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import service.dao.db.Jdbc;
import service.dao.db.Page;
import service.sys.Atm;
import service.sys.ErrMsg;
import v1.haocheok.commom.entity.InfoEntity;

public class RegionConfigService {

	
	public void check(HttpServletRequest request, HttpServletResponse response,String requestJson, InfoEntity info)  throws ServletException, IOException{
		Jdbc db = new Jdbc();
		Page page = new Page();
		
		String classname="web 查看编码是否重复";
		String claspath=this.getClass().getName();
		
		response.setContentType("text/html;charset=UTF-8");
		request.setCharacterEncoding("UTF-8");
		response.setCharacterEncoding("UTF-8");
		
		String journal="";//日志记录内容
		
		PrintWriter out = response.getWriter();
		JSONObject json = new JSONObject();
		
		
		//声明变量；
		String regionalcode = "";
		
		regionalcode = request.getParameter("regionalcode");
		System.out.println(regionalcode);
		try { // 解析开始
			JSONArray arr = JSONArray.fromObject("[" + requestJson + "]");
			for (int i = 0; i < arr.size(); i++) {
				JSONObject obj = arr.getJSONObject(i);
				regionalcode = obj.get("regionalcode") + ""; 
			}
		} catch (Exception e) {
			ErrMsg.falseErrMsg(request, response, "500", "json格式解析异常");
			Page.colseDOP(db, out, page);
			return;
		}
		
		String check_sql = "SELECT * from s_regional_table t where t.regionalcode="+regionalcode;
		java.sql.ResultSet rs = db.executeQuery(check_sql);
		int rsNum=0;
		try {
			rs.last();
			rsNum = rs.getRow();
		} catch (SQLException e) {
			e.printStackTrace();
		} //移到最后一行   
		if(rsNum==0){
			json.put("success", true);
			json.put("resultCode", "1000");
			json.put("msg", "区域编码不存在，可以添加");
		}else{
			json.put("success", true);
			json.put("resultCode", "2000");
			json.put("msg", "区域编码已存在");
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

	    String classname="web  删除区域配置";
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
		String checkSql = "select t.* from s_regional_table t where t.parentid = "+id;
		java.sql.ResultSet rs = db.executeQuery(checkSql);
		int rsNum=0;
		try {
			rs.last();
			rsNum = rs.getRow();
		} catch (SQLException e) {
			e.printStackTrace();
		} //移到最后一行  
		if(rsNum>0){
			json.put("success", true);
			json.put("resultCode", "2000");
			json.put("msg", "该区域存在子级，请先删除子级");
		}else{
			String delSql = "DELETE from s_regional_table where id ="+id;
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
