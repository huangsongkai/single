package v1.haocheok.commom.controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import service.dao.db.Jdbc;
import service.dao.db.Page;
import service.sys.Atm;
import service.sys.ErrMsg;
import service.util.che300.VinUtils;
import service.util.tool.StringUtil;
import v1.haocheok.commom.entity.InfoEntity;
import v1.haocheok.commom.entity.UserEntity;

public class GetVinToModelController {

	
	
	public void getVin(HttpServletRequest request,
			HttpServletResponse response, String RequestJson, InfoEntity info)
			throws ServletException, IOException {
		Jdbc db = new Jdbc();
		Page page = new Page();

		String claspath = this.getClass().getName();// 当前类名
		String classname = "通过vin获取车型";
		response.setContentType("text/html;charset=UTF-8");
		request.setCharacterEncoding("UTF-8");
		response.setCharacterEncoding("UTF-8");

		PrintWriter out = response.getWriter();
		JSONObject json = new JSONObject();
		ArrayList list = new ArrayList();
		// 定义接收变量值
		String vin = ""; // vin码
		
		int TokenTag = db
		.Row("SELECT COUNT(*) as row FROM  user_worker WHERE uid ='"
				+ info.getUSERID() + "' AND (pc_token='"
				+ info.getToken() + "' OR app_token='"+info.getToken()+"')");
		if (TokenTag != 1) {
			ErrMsg.falseErrMsg(request, response, "403", "请登录！");
			Page.colseDOP(db, out, page);
			return;// 跳出程序只行
		}
		try { // 解析开始

			//接收数据
			JSONArray arr = JSONArray.fromObject("[" + RequestJson + "]");
			for (int i = 0; i < arr.size(); i++) {
				JSONObject obj = arr.getJSONObject(i);
				vin = obj.get("vin") + "";
			}
		} catch (Exception e) {
			ErrMsg.falseErrMsg(request, response, "500", "json格式解析异常");
			return;
		}
		String responsejson = "";
		String models_str = "";
		//判断vin码不为空
		
		if("".equals(vin)){
			responsejson = "{\"success\":true,\"resultCode\":\"1000\",\"msg\":\"未获取信息\",\"models\":\"\"}";
		}else if(StringUtil.isChinese(vin)){
			responsejson = "{\"success\":true,\"resultCode\":\"1000\",\"msg\":\"未获取信息\",\"models\":\"\"}";
		}else{
			JSONArray models = 	VinUtils.getVin2Models(vin);
			if(models.size()>0){
				JSONObject mod_obj = models.getJSONObject(0);
				models_str = mod_obj.getString("PP")+" "+ mod_obj.getString("CJMC") +" "+ mod_obj.getString("CX") +""+ mod_obj.getString("XSMC") +" "+ mod_obj.getString("VINNF") ;
				responsejson = "{\"success\":true,\"resultCode\":\"1000\",\"msg\":\"获取车型信息成功\",\"models\":\""+models_str+"\"}";
			}else{
				responsejson = "{\"success\":true,\"resultCode\":\"1000\",\"msg\":\"获取车型成功\",\"models\":\"\"}";
			}
		}
		
		

		// 调用应用层实现类接口
		
		out.println(responsejson);
		// 记录日志
		page.colseDP(db, page);
		out.flush();
		out.close();
	}
	
	
}
