package v1.haocheok.homepage.service.impl;

import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.Calendar;

import net.sf.json.JSONObject;
import service.dao.db.Jdbc;
import service.dao.db.Md5;
import service.dao.db.Page;
import service.sys.Atm;
import v1.haocheok.commom.entity.InfoEntity;
import v1.haocheok.homepage.service.HomepageService;

public class HomepageServiceImpl implements HomepageService {

	@Override
	public String getHomepageList(String regionalcode, InfoEntity info,String claspath) {
		// TODO Auto-generated method stub
		Jdbc db = new Jdbc();
		Page page = new Page();
		
	    String username="";
	    String USERID = info.getUSERID();
	   
	    String responsejson="";
	    String classname="APP获取首页";
	    JSONObject json = new JSONObject();
		
	    try {
			//1.用户角色信息
			json.put("success", "true");
			json.put("resultCode", "1000");
			json.put("msg", "首页信息");
			
			//2.用户角色信息
			String sql_roleString = "select rolecode,name,zk_role.id as roleid from zk_user_role,zk_role where zk_user_role.sys_user_id='"+USERID+"' and zk_user_role.sys_role_id = zk_role.id and zk_role.type!=0";
			ResultSet rolePrs = db.executeQuery(sql_roleString);
			String rolecode = "",roleid = ""; 
			if(rolePrs.next()){
				rolecode = rolePrs.getString("rolecode");
				roleid = rolePrs.getString("roleid");
			}if(rolePrs!=null){rolePrs.close();}
			
			
			JSONObject json_base = new JSONObject();
			JSONObject json_homePage = new JSONObject();
			JSONObject json_rightcorner = new JSONObject();
			ArrayList<Object> list_homePage = new ArrayList<Object>();
			ArrayList<Object> list_rightcorner = new ArrayList<Object>();
			
			//3.待接单数量
			String waiting = "SELECT COUNT(1) AS ROW"
							+"	FROM (SELECT STATUS,regionalcode,rolecode,nodeid,orderid"
							+"	      FROM (SELECT STATUS,regionalcode,rolecode,nodeid,orderid"
							+"	            FROM process_log"
							+"	            ORDER BY creation_date DESC) AS `temp` "
							+"	      GROUP BY nodeid,orderid" 
							+"	      ORDER BY orderid) `temp1` "
							+"	WHERE  temp1.status = '0' "
							+"	    AND temp1.regionalcode = '"+regionalcode+"' "
							+"	    AND temp1.rolecode = '"+rolecode+"';";
			System.out.println("waiting===="+waiting);
			int waiting_list = db.Row(waiting);
			//4.以接单数量
			String received = getSql("1", USERID, rolecode, regionalcode);
			int received_list = db.Row(received);
			//5.以完成数量
			String completed = getSql("6", USERID, rolecode, regionalcode);
			
			int completed_list = db.Row(completed);
			//6.驳回
			String reject = getSql("3", USERID, rolecode, regionalcode);
			int reject_list = db.Row(reject);
			//7.被拒
			String rejected = getSql("4", USERID, rolecode, regionalcode);
			int rejected_list = db.Row(rejected);
			//8.拒绝
			String breject = getSql("2", USERID, rolecode, regionalcode);
			int breject_list = db.Row(breject);
			//9.被驳回
			String brejected = getSql("5", USERID, rolecode, regionalcode);
			int brejected_list = db.Row(brejected);
			ArrayList<Object> list_test = new ArrayList<Object>();
			list_test.add(waiting_list);
			list_test.add(received_list);
			list_test.add(completed_list);
			
			list_test.add(brejected_list);
			list_test.add(reject_list);
			
			list_test.add(rejected_list);
			list_test.add(breject_list);
			
//			String sQL_button = "SELECT buttonname,url,http,buttonstatus,buttoncode,z_buttonfuntion.buttonid AS buttonid FROM z_role_button,z_buttonfuntion WHERE z_role_button.roleid='"+roleid+"' AND (z_buttonfuntion.buttonid = 1 or z_buttonfuntion.buttonid = 5) AND z_role_button.buttonid = z_buttonfuntion.id order by z_buttonfuntion.sort asc ";
			String sQL_button = "SELECT buttonname,url,http,buttonstatus,buttoncode,z_buttonfuntion_bak.fatherid AS buttonid FROM z_role_button_bak,z_buttonfuntion_bak WHERE z_role_button_bak.roleid = '"+roleid+"' AND z_buttonfuntion_bak.id = z_role_button_bak.buttonid AND (z_buttonfuntion_bak.fatherid=1 OR z_buttonfuntion_bak.fatherid = 27) ORDER BY z_buttonfuntion_bak.sort ASC ";
			ResultSet sql_PSR = db.executeQuery(sQL_button);
			int i=0;
			while(sql_PSR.next()){
				if("27".equals(sql_PSR.getString("buttonid"))){
					json_rightcorner.put("buttonname", sql_PSR.getString("buttonname"));
					json_rightcorner.put("buttoncode", sql_PSR.getString("buttoncode"));
					json_rightcorner.put("api", sql_PSR.getString("url"));
					json_rightcorner.put("httptype" , sql_PSR.getString("http"));
					json_rightcorner.put("if_click", "1");                       //点击订单 是否执行事件  0：代表不执行   1：执行
					list_rightcorner.add(json_rightcorner.toString());
				}else{
					json_homePage.put("buttonname", sql_PSR.getString("buttonname"));
					json_homePage.put("buttoncode", sql_PSR.getString("buttoncode"));
					json_homePage.put("api", sql_PSR.getString("url"));
					json_homePage.put("httptype" , sql_PSR.getString("http"));
					json_homePage.put("num", list_test.get(i));
					json_homePage.put("if_click", "0");							//点击订单 是否执行事件  0：代表不执行   1：执行
					list_homePage.add(json_homePage.toString());
					i++;
				}
				
			}if(sql_PSR!=null){sql_PSR.close();}
			
			if(list_rightcorner!=null && list_rightcorner.size()>0){
				
				json_base.put("name", "全部");
				json_base.put("listbutton", list_rightcorner.toString());
			}
			
			json.put("homePage", list_homePage.toString());
			json.put("rightcorner", json_base.toString());
			//返回值
			responsejson=json.toString();
			
			
			// 记录执行日志
			long ExeTime = Calendar.getInstance().getTimeInMillis()-info.getTimeStart();
			// 记录执行日志
			Atm.AppuseLong(info, username,  claspath, classname, responsejson, ExeTime);
			//添加操作日志
			Atm.LogSys("登陆", "用户APP端登录", "获取首页"+USERID+"", "0",USERID, info.getIp());
			
		} catch (Exception e) {
		    int ErrLineNumber = e.getStackTrace()[0].getLineNumber();
		    //final String ltype, final String title,final String body,final String uid,final String ip
		    Atm.LogSys("系统错误", classname+"模块系统出错", "错误信息详见 "+claspath+",第"+ErrLineNumber+"行。", "1",info.getUSERID(), info.getIp());
		    Page.colseDP(db, page);
		    return Page.returnjson("500","服务器开小差啦-"+ErrLineNumber);
		}
		Page.colseDP(db, page);
		return responsejson;
	}
	
	/**
	 * 拼写sql语句
	 * @param status
	 * @param userid
	 * @param rolecode
	 * @param regionalcode
	 * @return
	 */
	private String getSql(String status,String userid,String rolecode,String regionalcode){
	
		String sql = "SELECT COUNT(1) AS ROW"
			+"	FROM (SELECT STATUS,regionalcode,rolecode,nodeid,orderid,operatorid"
			+"	      FROM (SELECT STATUS,regionalcode,rolecode,nodeid,orderid,operatorid"
			+"	            FROM process_log"
			+"	            ORDER BY creation_date DESC) AS `temp` "
			+"	      GROUP BY nodeid,orderid" 
			+"	      ORDER BY orderid) `temp1` "
			+"	WHERE  temp1.status = '"+status+"' "
			+"	    AND temp1.regionalcode = '"+regionalcode+"' " +
					" AND temp1.operatorid = '"+userid+"'"
			+"	    AND temp1.rolecode = '"+rolecode+"';";
		return sql;
	}

}
