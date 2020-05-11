package v1.haocheok.user.controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import service.dao.db.Jdbc;
import service.dao.db.Page;
import service.sys.ErrMsg;
import v1.haocheok.commom.entity.InfoEntity;

public class AppOperation {
	Jdbc db = new Jdbc();
	Page page = new Page();
	public void Operation(HttpServletRequest request, HttpServletResponse response,String RequestJson,InfoEntity info) throws ServletException, IOException {

        String claspath=this.getClass().getName();//当前类名
        
		response.setContentType("text/html;charset=UTF-8");
		request.setCharacterEncoding("UTF-8");
		response.setCharacterEncoding("UTF-8");
		
		
    	PrintWriter out = response.getWriter();
	    	
    		//定义接收变量值
           	String regionalcode="";
           	String rolecode =  "";
           	String status_form = "";
           	String processid = ""; 
		   
		   try { // 解析开始
			   
			   System.out.println("待结单列表模块接收数据："+RequestJson);
			   
			   JSONArray arr = JSONArray.fromObject("[" + RequestJson + "]");
			   
			   for (int i = 0; i < arr.size(); i++) {
				   JSONObject obj = arr.getJSONObject(i);
				   regionalcode = obj.get("regionalcode") + "";
				   rolecode = obj.get("rolecode") + "";
				   status_form = obj.get("status") + "";
				   processid = obj.get("process") + "";
			   }
		   }catch(Exception e){
			   ErrMsg.falseErrMsg(request, response, "500", "json格式解析异常");
			   return;
		   }
		   
		   System.out.println("regionalcode::"+regionalcode);
		   System.out.println("rolecode"+rolecode);
		   System.out.println("status"+status_form);
		   System.out.println("process"+processid);

		   try {
			   //1.提交操作
			   if("6".equals(status_form)){
				   String basesql = "SELECT * FROM t_yewudian , t_yewuxian WHERE t_yewuxian.status_form = '"+status_form+"' and t_yewudian.nodeid = t_yewuxian.nodeid_form AND t_yewudian.t_yewumian_id = '"+processid+"' AND rolecode = '"+rolecode+"';";
				   
				   ResultSet submit_Prs = db.executeQuery(basesql);
				   
				   while(submit_Prs.next()){
					   String nodeid_form = "";
					   String nodeid_to = "";
					   String status_to = "";
					   nodeid_form = submit_Prs.getString("nodeid_form");
					   nodeid_to = submit_Prs.getString("nodeid_to");
					   status_to = submit_Prs.getString("status_to");
					   //如果状态为0时 是未接单，不等于0需要添加操作者的id
					   String operatorid = "0";
					   if(!"0".equals(status_to)){
						  operatorid = info.getUSERID();
					   }
					   
					   //1.获取信息
					   HashMap<String, Object> map = getRoleinfo(nodeid_to);
					   String insertString = "insert into `process_log` (orderid,processid,regionalcode,nodeid,rolecode," +
   											"rolename,operatorid,status,common," +
   											"creation_date,creation_uid,updatetime,up_uid) " +
   											"VALUES('3','"+processid+"','"+regionalcode+"','"+nodeid_to+"','"+map.get("rolecode")+"','"+map.get("rolename")+"','"+operatorid+"','"+status_to+"','很好1'," +
   											" now(),'"+info.getUSERID()+"',now(),'"+info.getUSERID()+"');";
					   System.out.println(insertString);
					   //判断是否有条件
					   if("".equals(submit_Prs.getString("guize"))){
						   //没有规则时顺序执行
						   boolean status = db.executeUpdate(insertString);
						  
					   }else{
						   //有规则时：
						   boolean status = false;
						   String guize = submit_Prs.getString("guize");
						   if(guize.indexOf("or")==-1){
							   System.out.println(guize);
							   String select_sql = "SELECT COUNT(1) AS ROW FROM process_log WHERE processid = '"+processid+"' AND STATUS='6' AND nodeid = '"+guize+"' AND orderid = '2';";
							   int num = db.Row(select_sql);
							   if(num>=1){
								   status = true;
							   }
							   System.out.println(num);
						   }else{
							   List<String> list = Arrays.asList(guize.split("or"));
							   for(int i = 0;i < list.size() ; i++){
								   String select_sql = "SELECT COUNT(1) AS ROW FROM process_log WHERE processid = '"+processid+"' AND STATUS='6' AND nodeid = '"+list.get(i)+"' AND orderid = '2';";
								   int num = db.Row(select_sql);
								   if(num>=1){
									   status = true;
								   }
							   }
						   }
						   if(status){
							   boolean tiaojian_state = db.executeUpdate(insertString);
						   }
					   }
					   
					   
				   }
				
				 
			   }
			  
			   
		   } catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		   
		   String outputString = "{\"success\":\"true\",\"resultCode\": \"1000\",\"msg\": \"成功\"}";
				
			out.println(outputString);
			
			page.colseDP(db, page);
			//记录日志
			
			out.flush();
			out.close();
	}
	
	public HashMap<String, Object> getRoleinfo( String nodeid){
		HashMap<String, Object> map = new HashMap<String, Object>();
		String sql = "SELECT * FROM zk_role,t_yewudian WHERE nodeid = '"+nodeid+"' AND zk_role.id = t_yewudian.roleid ";
		ResultSet role_Set = db.executeQuery(sql);
		try {
			if(role_Set.next()){
				map.put("rolecode", role_Set.getString("rolecode"));
				map.put("rolename", role_Set.getString("name"));
				
			}else{
				map.put("rolecode", "");
				map.put("rolename", "");
				
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return map;
	}
}
