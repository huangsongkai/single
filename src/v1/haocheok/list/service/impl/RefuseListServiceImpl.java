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
import service.sys.ErrMsg;
import v1.haocheok.commom.common;
import v1.haocheok.commom.entity.InfoEntity;
import v1.haocheok.list.service.RefuseListService;

public class RefuseListServiceImpl implements RefuseListService {

	@Override
	public String getRefuseList(String rolecode, String regionalcode,InfoEntity info,HashMap<String, Object> map,String keyword) {
		Jdbc db = new Jdbc();
		Page page = new Page();
		Md5 md5ac = new Md5();
		String responsejson = "";
		String classname = "APP被拒列表";
		//基础信息json
		JSONObject json = new JSONObject();
		ArrayList list = new ArrayList();
		String username=common.getusernameTouid(info.getUSERID());
		json.put("success", "true");
		json.put("resultCode", "1000");
		json.put("msg", "获取被拒列表成功");
		try {

			// 查询状态主要使用的sql语句
			// SELECT * FROM (SELECT * FROM process_log ORDER BY creation_date
			// DESC) AS `temp` where regionalcode like '1000:1' and
			// rolecode='+rolecode+' GROUP BY nodeid ,orderid ORDER BY orderid ,
			// nodeid

			String sql_baseString = "SELECT * FROM " +
									"(SELECT * FROM process_log ORDER BY  creation_date DESC) AS `temp` ,order_sheet ,order_customerfile  " +
									"where order_customerfile.customername like '%"+keyword+"%' and temp.status = '3' and order_sheet.customeruid = order_customerfile.id AND temp.orderid =order_sheet.id AND temp.regionalcode like '"+regionalcode+"%' and temp.rolecode='"+rolecode+"' " +
									"GROUP BY nodeid ,orderid  " +
									"ORDER BY orderid , nodeid " +
									"limit "+map.get("DQcount2")+","+map.get("listnum2")+" ";
			System.out.println(sql_baseString);
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
			json.put("order", list.toString());
			responsejson = json.toString();
			
			// 记录执行日志
			long ExeTime = Calendar.getInstance().getTimeInMillis()-info.getTimeStart();
			Atm.AppuseLong(info, username,  this.getClass().getName(), classname, responsejson, ExeTime);
			//添加操作日志
			Atm.LogSys("获取列表", "用户APP端成功", "用户"+username+"获取被拒列表成功", "0",info.getUSERID(), info.getIp());
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
