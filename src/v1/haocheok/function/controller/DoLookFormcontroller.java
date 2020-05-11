package v1.haocheok.function.controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import service.dao.db.Jdbc;
import service.dao.db.Page;
import service.sys.Atm;
import service.sys.ErrMsg;
import v1.haocheok.commom.entity.InfoEntity;
/**
 * 查看功能
 * @author zhoukai04171019
 * @date:2017-9-7 下午03:08:22
 */
public class DoLookFormcontroller {
	
	@SuppressWarnings("unchecked")
	public void DoLookForm(HttpServletRequest request, HttpServletResponse response,String RequestJson, InfoEntity info) throws ServletException, IOException {
	    
		Jdbc db = new Jdbc();
	    Page page = new Page();
	    
        response.setContentType("text/html;charset=UTF-8");
		request.setCharacterEncoding("UTF-8");
		response.setCharacterEncoding("UTF-8");
		PrintWriter out = response.getWriter();

	    String classname="返回表单";
        String claspath=this.getClass().getName();

        long TimeStart = new Date().getTime();// 程序开始时间，统计效率
        
        String userid=info.getUSERID();//用户id
        String orderid="";//订单id
        @SuppressWarnings("unused")
		String regionalcode = ""; // 区域code
		@SuppressWarnings("unused")
		String rolecode = ""; // 角色code
        
        //拦截登陆信息
        int TokenTag=db.Row("SELECT COUNT(*) as row FROM  user_worker WHERE uid ='"+info.getUSERID()+"' AND app_token='"+ info.getToken() + "'");
		if(TokenTag!=1){
			ErrMsg.falseErrMsg(request, response, "403", "请登录！");
			Page.colseDOP(db, out, page);
			return;//跳出程序只行 
		} 
		
		
        
        JSONObject json = new JSONObject();
        
        try {//解析开始
			JSONArray arr = JSONArray.fromObject("[" + RequestJson + "]");
			   for(int i = 0; i < arr.size(); i++) {
				   JSONObject obj = arr.getJSONObject(i);
				   orderid=obj.get("placeid") + "";//订单id
//				   orderid="1";//暂时写死
			   }
		 }catch(Exception e){
			   	json.put("success", "true");
				json.put("resultCode", "403");
				json.put("msg", "json解析异常！  "+RequestJson);
				out.print(json);
				long ExeTime = Calendar.getInstance().getTimeInMillis()-TimeStart;// 记录执行日志
				Atm.AppuseLong(info, claspath, classname, "返回表单失败  json解析异常！  "+RequestJson, json.toString(), ExeTime);// 记录执行日志
				Atm.LogSys(info.getAppKeyType(), "用户APP 返回表单", "返回表单失败  json解析异常！  "+RequestJson,"1", info.getUSERID(), info.getIp());//添加操作日志
				Page.colseDOP(db, out, page);
				return;// 程序关闭
		 }
        
System.out.println("placeid===="+orderid);
		 
		 //设置GROUP函数  长度
		 boolean state=db.executeUpdate_GROUP("SET SESSION group_concat_max_len = 99999999;");
		 if(state==false){
			 	json.put("success", "true");
				json.put("resultCode", "500");
				json.put("msg", "网络异常,请刷新重试");
				out.print(json);
				long ExeTime = Calendar.getInstance().getTimeInMillis()-TimeStart;// 记录执行日志
				Atm.AppuseLong(info, claspath, classname, "返回表单  设置GROUP函数  长度   执行的语句{SET SESSION group_concat_max_len = 99999999;} ", json.toString(), ExeTime);// 记录执行日志
				Atm.LogSys(info.getAppKeyType(), "用户APP端  返回表单", "返回表单  设置GROUP函数  长度   执行的语句{SET SESSION group_concat_max_len = 99999999;} ","1", info.getUSERID(), info.getIp());//添加操作日志
				Page.colseDOP(db, out, page);
				return;// 程序关闭
		 }
        //查找出角色表单模版
        String slect_from="SELECT  GROUP_CONCAT("+
											"CONCAT('{'  "+
													",'\"ispost\":',IFNULL(form_template_confg.ispost,'\"\"')"+
													",',' "+
													",'\"uniquelyid\":','\"',IFNULL(form_template_confg.tid,''),'\"' "+
													",',' "+
													",'\"ftype_name\":','\"',IFNULL(form_template_confg.ftype_name,''),'\"' "+
													",',' "+
													",'\"ftype_tag\":','\"',IFNULL(form_template_confg.ftype_tag,''),'\"' "+
													",','  "+
													",'\"title\":','\"',IFNULL(form_template_confg.title,''),'\"' "+
													",','   "+
													",'\"prompt\":','\"',IFNULL(form_template_confg.prompt,''),'\"'  "+
													",','  "+
													",'\"tmust_input\":','\"',IFNULL(form_template_confg.tmust_input,''),'\"' "+
													",','  "+
													",'\"teams\":',IFNULL(form_template_confg.teams,'\"\"')"+
													",','  "+
													",'\"fieldname\":','\"',IFNULL(form_template_confg.strname,''),'\"' "+
													",','  "+
													",'\"datatype\":','\"',IFNULL(form_template_confg.datatype,''),'\"' "+
													",','  "+
													",'\"fieldnamevalue\":','\"\"' "+
													",','  "+
													",'\"editstatus\":','\"',IFNULL(0,''),'\"' "+
											       ",'}' )  "+
											")AS json,"+
											"form_name.datafrom AS from_name,  "+
											"form_name.formname AS fromname ,role_from.code "+
										  "FROM zk_user_role "+ 
											"LEFT JOIN  role_from ON  zk_user_role.sys_role_id=role_from.roleid "+  
											"LEFT JOIN  form_name ON role_from.fromid=form_name.id  "+
											"LEFT JOIN  form_template_confg ON form_name.id=form_template_confg.fid  "+
										"WHERE zk_user_role.sys_user_id='"+userid+"' and form_name.datafrom<>'' "+
										"GROUP BY  form_template_confg.fid  order by role_from.code asc ";
        
        
System.out.println("slect_from==="+slect_from);
        ResultSet rs = db.executeQuery(slect_from);
        //表单
        JSONObject moudel_json=new  JSONObject();
        ArrayList<String> moudel = new ArrayList<String> ();
        
        
        //按钮
	    ArrayList list_button = new ArrayList();
        
        try{
        	
        	//基本信息
			String base_sql = "SELECT zk_role.id AS roleid,rolecode FROM zk_user_role,zk_role WHERE zk_user_role.sys_role_id = zk_role.id AND zk_user_role.sys_user_id = '"+info.getUSERID()+"'";
			
			ResultSet basePrs = db.executeQuery(base_sql); 
			String roleid = "";
			if(basePrs.next()){
				roleid = basePrs.getString("roleid");
				rolecode = basePrs.getString("rolecode");
			}if(basePrs!=null){basePrs.close();}
			
        	//表单信息
			while(rs.next()){
				String from_name=rs.getString("from_name");//英文表单名
				String f_json=rs.getString("json");//未赋值的字段
				String t_json=db.executeQuery_str("select jsontemplate as str  from "+from_name+" where orderid="+orderid+";");//表单的字段
				if(t_json==null || t_json.length()<1){
					ArrayList<String>threads= new ArrayList<String>();
					 try {//解析开始
						 	
							JSONArray arr1 = JSONArray.fromObject("[" + f_json + "]");
						   for(int i1 = 0; i1 < arr1.size(); i1++) {
							   threads.add(arr1.getJSONObject(i1).toString());
						   }
						 }catch(Exception e){
							   	json.put("success", "false");
								json.put("resultCode", "500");
								json.put("msg", "查询表单异常");
								out.print(json);
								long ExeTime = Calendar.getInstance().getTimeInMillis()-TimeStart;// 记录执行日志
								Atm.AppuseLong(info, claspath, classname, "返回表单失败   "+f_json, json.toString(), ExeTime);// 记录执行日志
								Atm.LogSys(info.getAppKeyType(), "用户APP 返回表单", "返回表单失败  "+f_json,"1", info.getUSERID(), info.getIp());//添加操作日志
								Page.colseDOP(db, out, page);
								return;// 程序关闭
						 }
					
					
					moudel_json.put("name",rs.getString("fromname") );//中文表单名
					moudel_json.put("basetable",from_name );//英文表单名
					moudel_json.put("threads",threads);
				}else{
					moudel_json.put("name",rs.getString("fromname") );//中文表单名
					moudel_json.put("basetable",from_name );//英文表单名
					moudel_json.put("threads",Page.mergeJson("{\"threads\":["+f_json+"]}",t_json));//合并方法
				}
				moudel.add(moudel_json.toString());
			}if(rs!=null){rs.close();}
		}catch(SQLException e){
			e.printStackTrace();
		 	json.put("success", "false");
			json.put("resultCode", "500");
			json.put("msg", "查询表单失败");
			out.print(json);
			long ExeTime = Calendar.getInstance().getTimeInMillis()-TimeStart;// 记录执行日志
			Atm.AppuseLong(info, claspath, classname, "返回表单   查询表单失败  sql语句：{"+slect_from+"} ", json.toString(), ExeTime);// 记录执行日志
			Atm.LogSys(info.getAppKeyType(), "用户APP端  返回表单", "返回表单  查询表单失败  sql语句：{"+slect_from+"} ","1", info.getUSERID(), info.getIp());//添加操作日志
			Page.colseDOP(db, out, page);
			return;// 程序关闭
		}
		
		json.put("success", "true");
		json.put("resultCode", "1000");
		json.put("msg", "请求成功");
		json.put("moudel", moudel);
		json.put("button", list_button.toString());
		out.print(json);
		System.out.println(json);
	Page.colseDOP(db, out, page);
}
}
