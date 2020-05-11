package v1.haocheok.list.service.impl;

import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;

import net.sf.json.JSONObject;
import service.dao.db.Jdbc;
import service.dao.db.Md5;
import service.dao.db.Page;
import service.sys.Atm;
import v1.haocheok.commom.common;
import v1.haocheok.commom.entity.InfoEntity;
import v1.haocheok.list.service.WaitingService;

public class WaitingServiceImpl implements WaitingService {

	@Override
	public String getwaitingList(String rolecode,String regionalcode,InfoEntity info,HashMap<String, Object> map,String keyword,String buttoncode) {
		Jdbc db = new Jdbc();
		Page page = new Page();
		Md5 md5ac = new Md5();
		String responsejson="";
		String classname="APP待接单";
		String username=common.getusernameTouid(info.getUSERID());
		JSONObject json = new JSONObject();
	    ArrayList list = new ArrayList();
	    json.put("success", "true");
		json.put("resultCode", "1000");
		json.put("msg", "获取待接单列表成功");
		
		try {
			String sql_baseString = "SELECT * FROM " +
			"(SELECT * FROM process_log ORDER BY  creation_date DESC) AS `temp` ,order_sheet ,order_customerfile  " +
			"where order_customerfile.customername like '%"+keyword+"%' and temp.status = '0' and order_sheet.customeruid = order_customerfile.id AND temp.orderid =order_sheet.id AND temp.regionalcode like '"+regionalcode+"%' and temp.rolecode='"+rolecode+"' " +
			"GROUP BY nodeid ,orderid  " +
			"ORDER BY orderid , nodeid " +
			"limit "+map.get("DQcount2")+","+map.get("listnum2")+" ";
			System.out.println("sql_base===="+sql_baseString);
			ResultSet basePrSet = db.executeQuery(sql_baseString);
			
			JSONObject json_order = new JSONObject();
			while(basePrSet.next()){
				json_order.put("customername",basePrSet.getString("customername"));
				json_order.put("loantype", basePrSet.getString("loantype"));
				json_order.put("phone", basePrSet.getString("phonenumber"));
				json_order.put("contactaddress", basePrSet.getString("contactaddress"));
				json_order.put("createtime", basePrSet.getString("order_sheet.createtime"));
				list.add(json_order.toString());
			}
			json.put("info", list.toString());
			//2获取按钮
			JSONObject json_button1 = new JSONObject();
		    ArrayList list_button = new ArrayList();
			String rolebutton = "SELECT buttonname,buttoncode,url,http, buttonstatus " +
								"FROM z_buttonfuntion,z_role_button " +
								"WHERE z_buttonfuntion.fatherid = (SELECT id FROM z_buttonfuntion WHERE buttoncode = '"+buttoncode+"') " +
								"AND z_role_button.buttonid = z_buttonfuntion.id;";
			System.out.println(rolebutton);
			ResultSet roleResultSet = db.executeQuery(rolebutton);
			while(roleResultSet.next()){
				json_button1.put("buttonname", roleResultSet.getString("buttonname"));
				json_button1.put("buttoncode", roleResultSet.getString("buttoncode"));
				json_button1.put("api", roleResultSet.getString("url"));
				json_button1.put("httptype", roleResultSet.getString("http"));
				json_button1.put("buttonstatus", roleResultSet.getString("buttonstatus"));
				list_button.add(json_button1.toString());
				
			}
			System.out.println("json_button ==="+json_button1.toString());
			json.put("button", list_button.toString());
			responsejson = json.toString();
			
			// 记录执行日志
			long ExeTime = Calendar.getInstance().getTimeInMillis()-info.getTimeStart();
			Atm.AppuseLong(info, username,  this.getClass().getName(), classname, responsejson, ExeTime);
			//添加操作日志
			Atm.LogSys("获取待接单", "用户APP端成功", "用户"+username+"获取待接单成功", "0",info.getUSERID(), info.getIp());
			
		} catch (Exception e) {
			int ErrLineNumber = e.getStackTrace()[0].getLineNumber();
			responsejson = "{\"success\":true,\"resultCode\":\"500\",\"msg\":\"服务器开小差了\"}";
			// 记录执行日志
			long ExeTime = Calendar.getInstance().getTimeInMillis()-info.getTimeStart();
			Atm.AppuseLong(info, username,  this.getClass().getName(), classname, responsejson, ExeTime);
			//添加操作日志
			Atm.LogSys("系统错误", classname+"模块系统出错", "错误信息详见 "+this.getClass().getName()+"第"+ErrLineNumber+"行","1", info.getUSERID(), info.getIp());
			Page.colseDP(db, page);
			return responsejson;
		}
		Page.colseDP(db, page);
		return responsejson;
	}

}
