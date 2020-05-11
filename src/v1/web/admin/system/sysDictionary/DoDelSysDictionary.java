package v1.web.admin.system.sysDictionary;

import java.io.IOException;
import java.io.PrintWriter;
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

/**
 * 删除数据字典
 * @company 010jiage
 * @author gf
 * @date:2017-9-25 下午02:14:29
 */
public class DoDelSysDictionary {

	public void del(HttpServletRequest request, HttpServletResponse response,String requestJson, InfoEntity info) throws ServletException, IOException {
		Jdbc db = new Jdbc();
		Page page = new Page();

	    String classname="web  删除数据字典";
        String claspath=this.getClass().getName();
        
		response.setContentType("text/html;charset=UTF-8");
		request.setCharacterEncoding("UTF-8");
		response.setCharacterEncoding("UTF-8");
		
		String journal="";//日志记录内容
		
		PrintWriter out = response.getWriter();
    	JSONObject json = new JSONObject();

		//声明变量；
	    String id = "";//数据字典id
	    
	    id = request.getParameter("id");
System.out.println(id);
	    try { // 解析开始
			JSONArray arr = JSONArray.fromObject("[" + requestJson + "]");
			for (int i = 0; i < arr.size(); i++) {
				JSONObject obj = arr.getJSONObject(i);
				id = obj.get("id") + "";     //数据字典id
			}
		} catch (Exception e) {
			  ErrMsg.falseErrMsg(request, response, "500", "json格式解析异常");
			  Page.colseDOP(db, out, page);
			  return;
		}
		
		String checkSql = "select count(1) row  from type t where t.typegroupid = "+id;
		int typeNum = db.Row(checkSql);
		if(typeNum>0){
			json.put("success", true);
			json.put("resultCode", "2000");
			json.put("msg", "改数据字典存在下级，请先删除数据字典值");
			out.print(json);
			Page.colseDOP(db, out, page);
			return;
		}
		String delSql = "DELETE from typegroup where id ="+id;
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

	public void delInfo(HttpServletRequest request,	HttpServletResponse response, String requestJson, InfoEntity info)  throws ServletException, IOException{
		Jdbc db = new Jdbc();
		Page page = new Page();

	    String classname="web  删除数据字典值";
        String claspath=this.getClass().getName();
        
		response.setContentType("text/html;charset=UTF-8");
		request.setCharacterEncoding("UTF-8");
		response.setCharacterEncoding("UTF-8");
		
		String journal="";//日志记录内容
		
		PrintWriter out = response.getWriter();
    	JSONObject json = new JSONObject();

	    
		//声明变量；
	    String id = "";//数据字典id
	    
	    id = request.getParameter("id");
System.out.println(id);
	    try { // 解析开始
			JSONArray arr = JSONArray.fromObject("[" + requestJson + "]");
			for (int i = 0; i < arr.size(); i++) {
				JSONObject obj = arr.getJSONObject(i);
				id = obj.get("id") + "";     //数据字典id
			}
		} catch (Exception e) {
			  ErrMsg.falseErrMsg(request, response, "500", "json格式解析异常");
			  Page.colseDOP(db, out, page);
			  return;
		}
		
		String delSql = "DELETE from type where id ="+id;
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
