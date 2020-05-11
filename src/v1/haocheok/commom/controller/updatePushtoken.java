package v1.haocheok.commom.controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.util.ArrayList;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import service.dao.db.Jdbc;
import service.dao.db.Page;
import service.sys.Atm;
import v1.haocheok.commom.entity.InfoEntity;

/**
 * 获取pushtoken，用来做推送使用
 * @company 010jiage
 * @author zhoukai04171019
 * @date:2017-9-21 上午10:38:52
 */
public class updatePushtoken {

	public void setUpdatePushtoken(HttpServletRequest request,
			HttpServletResponse response, String RequestJson, InfoEntity info)
	throws ServletException, IOException{
		Jdbc db = new Jdbc();
		Page page = new Page();
		
		String claspath = this.getClass().getName();// 当前类名
		String classname = "获取pushtoken";
		response.setContentType("text/html;charset=UTF-8");
		request.setCharacterEncoding("UTF-8");
		response.setCharacterEncoding("UTF-8");

		PrintWriter out = response.getWriter();
		JSONObject json = new JSONObject();
		ArrayList list = new ArrayList();
		
		// 定义接收变量值
		String pushtoken = "";
		
		
		
		try {
			JSONArray arr = JSONArray.fromObject("[" + RequestJson + "]");

			for (int i = 0; i < arr.size(); i++) {
				JSONObject obj = arr.getJSONObject(i);
				pushtoken = obj.get("pushtoken") + "";

			}
		} catch (Exception e) {
			// TODO: handle exception
		}
		
		String sql = "select count(1) as row form user_pushtoken where userid='"+info.getUSERID()+"' ;";
		
		int num = db.Row(sql);
		if(num == 0){
			//添加
			String insert_sql = "insert into `user_pushtoken` (userid,pushtoken) VALUES ('"+info.getUSERID()+"','"+pushtoken+"')"; 
			boolean status = db.executeUpdate(insert_sql);
			if(status){
				//添加操作日志
				Atm.LogSys("添加pushtoken成功", "pushtoken", "添加pushtoken"+info.getUSERID()+"", "0",info.getUSERID(), info.getIp());
			}else{
				//添加操作日志
				Atm.LogSys("添加pushtoken失败", "pushtoken", "添加pushtoken"+info.getUSERID()+"", "1",info.getUSERID(), info.getIp());
			}
			
		}else{
			//修改
			String update_sql = "update `user_pushtoken` set `pushtoken`='"+pushtoken+"' where userid = '"+info.getUSERID()+"' ";
			boolean status = db.executeUpdate(update_sql);
			if(status){
				//更新操作日志
				Atm.LogSys("更新pushtoken成功", "pushtoken", "更新pushtoken"+info.getUSERID()+"", "0",info.getUSERID(), info.getIp());
			}else{
				//更新操作日志
				Atm.LogSys("更新pushtoken失败", "pushtoken", "更新pushtoken"+info.getUSERID()+"", "0",info.getUSERID(), info.getIp());
			}
		}
		
		
	}
}
