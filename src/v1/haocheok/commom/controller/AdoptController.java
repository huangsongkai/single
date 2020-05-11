package v1.haocheok.commom.controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;

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

/**
 * 征信web通过功能
 * @author zhoukai04171019
 * @date:2017-8-31 上午09:54:46
 */

public class AdoptController {
	 
	
	public  boolean Doappoint( String placeid,String status,String common,String nodeid,String process,String USERID)
			throws ServletException, IOException {
		Jdbc db = new Jdbc();
		Page page = new Page();
		

		JSONObject json = new JSONObject();
		ArrayList list = new ArrayList();
		// 定义接收变量值
		String regionalcode = ""; // 区域code
		String rolecode = ""; // 角色code
		String status_form = status; // 订单状态
		String orderid = placeid; // 订单id
		String processid = process;
		String common_info = common;
		nodeid = nodeid;
		
		boolean status1 = false;
		

		try {
			
			//基本信息
			String base_sql = "SELECT * FROM user_worker,zk_user_role,zk_role WHERE user_worker.uid = zk_user_role.sys_user_id AND zk_user_role.sys_role_id = zk_role.id AND uid = '"+USERID+"'";
			
			ResultSet basePrs = db.executeQuery(base_sql); 
			if(basePrs.next()){
				rolecode = basePrs.getString("rolecode");
				regionalcode = basePrs.getString("regionalcode");
			}if(basePrs!=null){basePrs.close();}
			 //1.提交操作
			   if("6".equals(status_form)){
				   String basesql = DoCommonController.setBaseSql(processid, nodeid, status_form, rolecode);
				   ResultSet submit_Prs = db.executeQuery(basesql);
				   while(submit_Prs.next()){
					   String nodeid_form = "";
					   String nodeid_to = "";
					   String status_to = "";
					   nodeid_form = submit_Prs.getString("nodeid_form");
					   nodeid_to = submit_Prs.getString("nodeid_to");
					   status_to = submit_Prs.getString("status_to");
					   String operatorid = "0";
					   if(!"0".equals(status_to) && !"8".equals(status_to)){
						  operatorid = USERID;
					   }
					   
					   //1.提交
					   HashMap<String, Object> map =DoCommonController.getRoleinfo(nodeid_to,processid);
					   
					   
					   String insertString = "insert into `process_log` (orderid,processid,regionalcode,nodeid,rolecode," +
											"rolename,operatorid,status,common," +
											"creation_date,creation_uid,updatetime,up_uid) " +
											"VALUES('"+orderid+"','"+processid+"','"+regionalcode+"','"+nodeid_to+"','"+map.get("rolecode")+"','"+map.get("rolename")+"','"+operatorid+"','"+status_to+"','"+common_info+"'," +
											" now(),'"+USERID+"',now(),'"+USERID+"');";
					   System.out.println(insertString);
					   //判断是否有条件
					   
					   if("".equals(submit_Prs.getString("guize"))){
						   //没有规则时顺序执行
						    status1 = db.executeUpdate(insertString);
						  
					   }else{
						   //有规则时：
						    status1 = false;
						   String guize = submit_Prs.getString("guize");
						   if(guize.indexOf("or")==-1){
							   System.out.println(guize);
							   String select_sql = "SELECT COUNT(1) AS ROW FROM process_log WHERE processid = '"+processid+"' AND STATUS='"+status_form+"' AND nodeid = '"+guize+"' AND orderid = '"+orderid+"';";
							   int num = db.Row(select_sql);
							   if(num>=1){
								   status1 = true;
							   }
							   System.out.println(num);
						   }else{
							   List<String> list1 = Arrays.asList(guize.split("or"));
							   for(int i = 0;i < list1.size() ; i++){
								   String select_sql = "SELECT COUNT(1) AS ROW FROM process_log WHERE processid = '"+processid+"' AND STATUS='"+status_form+"' AND nodeid = '"+list1.get(i)+"' AND orderid = '"+orderid+"';";
								   int num = db.Row(select_sql);
								   if(num>=1){
									   status1 = true;
								   }
							   }
						   }
						   if(status1){
							   boolean tiaojian_state = db.executeUpdate(insertString);
						   }
					   }
				   }
			   }
			
		} catch (SQLException e) {
			Page.colseDP(db, page);
			return status1;
		}
		Page.colseDP(db, page);
		return status1;

		// 调用应用层实现类接口
	}
	
}
