package v1.haocheok.commom.controller;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;

import service.dao.db.Jdbc;
import service.dao.db.Page;
import service.sys.Atm;
import v1.haocheok.commom.entity.InfoEntity;

/**
 * 公共流程方法
 * @company 010jiage
 * @author zhoukai04171019
 * @date:2017-10-10 下午05:58:19
 */
public class DoCommonController {

	/**
	 * 增加担保人流程
	 * @param info
	 * @param nodeid
	 * @param status_form
	 * @param orderid
	 * @param processid
	 * @param common_info
	 * @return
	 */
	public static boolean setProcess(InfoEntity info,String nodeid,String status_form ,String orderid,String processid,String common_info){
		Jdbc db = new Jdbc();
		Page page = new Page();
		// 基本信息
		String base_sql = "SELECT * FROM user_worker,zk_user_role,zk_role WHERE user_worker.uid = zk_user_role.sys_user_id AND zk_user_role.sys_role_id = zk_role.id AND uid = '"
				+ info.getUSERID() + "'";
		String rolecode = "";
		String regionalcode = "";
		boolean status = false;
		ResultSet basePrs = db.executeQuery(base_sql);
		try {
			if (basePrs.next()) {
				rolecode = basePrs.getString("rolecode");
				regionalcode = basePrs.getString("regionalcode");
			}
			if (basePrs != null) {
				basePrs.close();
			}
			
			//流程查询sql
			String basesql = setBaseSql(processid, nodeid, status_form, rolecode);
			ResultSet orderSet = db.executeQuery(basesql);
			while (orderSet.next()) {
				String nodeid_to = orderSet.getString("nodeid_to");
				// 获取角色信息
				HashMap<String, Object> map = getRoleinfo(nodeid_to,processid);
				String nodeid_form = orderSet.getString("nodeid_form");
				// 操作者id
				String operatorid = info.getUSERID();
				String insertString = "insert into `process_log` (orderid,processid,regionalcode,nodeid,rolecode,"
						+ "rolename,operatorid,status,common,"
						+ "creation_date,creation_uid,updatetime,up_uid) "
						+ "VALUES('"
						+ orderid
						+ "','"
						+ processid
						+ "','"
						+ regionalcode
						+ "','"
						+ nodeid_to
						+ "','"
						+ map.get("rolecode")
						+ "','"
						+ map.get("rolename")
						+ "','"
						+ operatorid
						+ "',"
						+ " '"
						+ orderSet.getString("status_to")
						+ "','"
						+ common_info
						+ "',now(),'"
						+ info.getUSERID()
						+ "',now(),'" + info.getUSERID() + "');";
				status = db.executeUpdate(insertString);
			}
			if (orderSet != null) {
				orderSet.close();
			}
		} catch (SQLException e) {
			status = false;
		}
		return status;
	}
	
	
	/**
	 * 获取角色信息
	 * @param nodeid
	 * @return
	 */
	public static HashMap<String, Object> getRoleinfo( String nodeid,String processid){
		Jdbc db = new Jdbc();
		Page page = new Page();
		HashMap<String, Object> map = new HashMap<String, Object>();
		String sql = "SELECT * FROM zk_role,t_yewudian WHERE nodeid = '"+nodeid+"' AND zk_role.id = t_yewudian.roleid AND t_yewudian.t_yewumian_id = '"+processid+"'";
		ResultSet role_Set = db.executeQuery(sql);
		try {
			if(role_Set.next()){
				map.put("rolecode", role_Set.getString("rolecode"));
				map.put("rolename", role_Set.getString("name"));
				
			}else{
				map.put("rolecode", "");
				map.put("rolename", "");
				
			}if(role_Set!=null){role_Set.close();}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		page.colseDP(db, page);
		return map;
	}
	
	/**
	 * 设置流程基本查询sql
	 * @param processid
	 * @param nodeid
	 * @param status_form
	 * @param rolecode
	 * @return
	 */
	public static String setBaseSql(String processid,String nodeid,String status_form,String rolecode){
		String sql = "SELECT nodeid_form,nodeid_to,status_to,guize FROM t_yewudian td,t_yewuxian tx WHERE td.t_yewumian_id = tx.t_yewumian_id  AND td.t_yewumian_id = '"+processid+"' AND td.nodeid = '"+nodeid+"' AND td.nodeid = tx.nodeid_form AND tx.status_form = '"+status_form+"' AND rolecode = '"+rolecode+"';";
		
		return sql;
	}
	
}
