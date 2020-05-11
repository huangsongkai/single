package v1.haocheok.function.controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
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
import v1.haocheok.commom.entity.InfoEntity;
import v1.haocheok.commom.common;

/**
 * @company 010jiage
 * @author wangxudong(1503631902@qq.com)
 * @date:2017-10-16 上午10:14:39
 */
public class DoFormcontroller {
	
		@SuppressWarnings("unchecked")
		public void DoForm(HttpServletRequest request, HttpServletResponse response,String RequestJson, InfoEntity info) throws ServletException, IOException {
		    
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
														",'\"editstatus\":','\"',IFNULL(role_from.code,''),'\"' "+
												       ",'}' )  "+
												")AS json,"+
												"form_name.datafrom AS from_name,  "+
												"form_name.formname AS fromname ," +
												"role_from.code "+
											  "FROM zk_user_role "+ 
												"LEFT JOIN  role_from ON  zk_user_role.sys_role_id=role_from.roleid "+  
												"LEFT JOIN  form_name ON role_from.fromid=form_name.id  "+
												"LEFT JOIN  form_template_confg ON form_name.id=form_template_confg.fid  "+
											"WHERE zk_user_role.sys_user_id='"+userid+"' and form_name.datafrom<>'' "+
											"GROUP BY  form_template_confg.fid  order by role_from.code asc ";
	        ResultSet rs = db.executeQuery(slect_from);
	        
	        //表单
	        JSONObject moudel_json=new  JSONObject();
	        ArrayList<String> moudel = new ArrayList<String> ();
	        
	        
	        //按钮
	        JSONObject json_button1 = new JSONObject();
		    ArrayList list_button = new ArrayList();
	        
		    
	        try{
	        	
	        	//获取客户id
	        	String sql_order = "select customeruid as str from order_sheet where id = "+orderid+"";
	        	String customeruid= db.executeQuery_str(sql_order);
	        	
	        	//用户基本信息
				String base_sql = "SELECT zk_role.id AS roleid,rolecode FROM zk_user_role,zk_role WHERE zk_user_role.sys_role_id = zk_role.id AND zk_user_role.sys_user_id = '"+info.getUSERID()+"'";
				ResultSet basePrs = db.executeQuery(base_sql); 
				String roleid = "";
				if(basePrs.next()){
					roleid = basePrs.getString("roleid");
					rolecode = basePrs.getString("rolecode");
				}if(basePrs!=null){basePrs.close();}
	        	
				while(rs.next()){
					String from_name=rs.getString("from_name");//英文表单名
					
					String f_json=rs.getString("json");//未赋值的字段
					
					ArrayList<String> threads= new ArrayList<String>();
					
					
					if("order_customerfile".equals(from_name)){//客户信息表
						try {//解析开始
							JSONArray arr1 = JSONArray.fromObject("[" + f_json + "]");
System.out.println("arr1==="+arr1);
						   for(int i1 = 0; i1 < arr1.size(); i1++) {
						   
							   String map_key = arr1.getJSONObject(i1).get("fieldname") + "";//获取字段名称
							   String map_value="";
							   
							   //sex      maritalstatus
							   //nation 民族 
							   
							  // industrycategory 
							   System.out.println("map_key==="+map_key);
							   HashMap<String, String> map = db.executeQuery_map("select "+map_key+" from "+from_name+" where id = "+customeruid+"");
							   
							   map_value=map.get(map_key);
//							   if("sex".equals(map_key)){
//								   map_value=common.getDis4info("gender", map_value);
//								   
//							   }else if("nation".equals(map_key)){
//								   map_value=db.executeQuery_str("select from where ");
//								   
//							   }else if("maritalstatus".equals(map_key)){
//								   map_value=common.getDis4info("maritalStatus", map_value);
//								   
//							   }else if("industrycategory".equals(map_key)){
//								   map_value=db.executeQuery_str("select industry_name from config_industry where id =  '"+map_value+"'");
//							   }
							   
							   System.out.println("map==="+map);
							   arr1.getJSONObject(i1).put("fieldnamevalue",map_value);
							   
							  	
							   
							   JSONArray arr2 =  JSONArray.fromObject(arr1.getJSONObject(i1).get("teams"));
							   
							   if(arr2!=null && arr2.size()>0){
								   
								   String valueString = map.get(map_key);
								   
								   for(int i = 0 ; i < arr2.size() ; i++){
									   
									   String option = arr2.getJSONObject(i).get("option") + "";
									   
									   if(valueString.equals(option)){
										   String option_value = arr2.getJSONObject(i).get("option_value") + "";
										   arr1.getJSONObject(i1).put("fieldvaluename", option_value);
									   }
								   }
							   }else{
								   arr1.getJSONObject(i1).put("fieldvaluename", "");
							   }

							   threads.add(arr1.getJSONObject(i1).toString());
						   }
						   moudel_json.put("name",rs.getString("fromname") );//中文表单名
						   moudel_json.put("basetable",from_name );//英文表单名
						   moudel_json.put("dateId","0" );//本条数据id
						   moudel_json.put("editstatus",0);//操作状态   0查看 1操作
						   moudel_json.put("threads",threads);
						}catch (Exception e) {
							long ExeTime = Calendar.getInstance().getTimeInMillis()-TimeStart;// 程序结束时间，统计效率
				    		out.print(fail(claspath, classname, RequestJson, ExeTime, info, "查询表单异常", "返回表单失败  "+f_json));
							Page.colseDOP(db, out, page);
							return;// 程序关闭
						}
					}else if("f_creditreport".equals(from_name)){//客户征信信息
						try {//解析开始
							JSONArray arr1 = JSONArray.fromObject("[" + f_json + "]");
						   for(int i1 = 0; i1 < arr1.size(); i1++) {
							   String map_key = arr1.getJSONObject(i1).get("fieldname") + "";
							  
							   HashMap<String, String> map = db.executeQuery_map("select "+map_key+" from "+from_name+" where customerid = '"+customeruid+"'");
							 
							   arr1.getJSONObject(i1).put("fieldnamevalue", map.get(map_key));
							   
							   JSONArray arr2 =  JSONArray.fromObject(arr1.getJSONObject(i1).get("teams"));
							  
							   if(arr2!=null && arr2.size()>0){
								   String valueString = map.get(map_key);
								   for(int i = 0 ; i < arr2.size() ; i++){
									   String option = arr2.getJSONObject(i).get("option") + "";
									   if(valueString.equals(option)){
										   String option_value = arr2.getJSONObject(i).get("option_value") + "";
										   arr1.getJSONObject(i1).put("fieldnamevalue", option_value);
									   }
								   }
							   }else{
								   arr1.getJSONObject(i1).put("fieldnamevalue", "");
							   }
							   threads.add(arr1.getJSONObject(i1).toString());
						   }
						   moudel_json.put("name",rs.getString("fromname") );//中文表单名
						   moudel_json.put("basetable",from_name );//英文表单名
						   moudel_json.put("dateId","0" );//本条数据id
						   moudel_json.put("editstatus",0);//操作状态   0查看 1操作
						   moudel_json.put("threads",threads);
						}catch (Exception e) {
							long ExeTime = Calendar.getInstance().getTimeInMillis()-TimeStart;// 程序结束时间，统计效率
				    		out.print(fail(claspath, classname, RequestJson, ExeTime, info, "查询表单异常", "返回表单失败  "+f_json));
							Page.colseDOP(db, out, page);
							return;// 程序关闭
						}
					}else{
						String t_json=db.executeQuery_str("select jsontemplate as str  from "+from_name+" where orderid="+orderid+";");//表单的字段
//						if(t_json==null || t_json.length()<1){
							int dateId=db.Row("select ifnull(id,'0') as Row  from "+from_name+" where orderid="+orderid+";");//表单当前数据唯一id
							 try {//解析开始
								 	
									JSONArray arr1 = JSONArray.fromObject("[" + f_json + "]");
								   for(int i1 = 0; i1 < arr1.size(); i1++) {
									   threads.add(arr1.getJSONObject(i1).toString());
								   }
								 }catch(Exception e){
									 	long ExeTime = Calendar.getInstance().getTimeInMillis()-TimeStart;// 程序结束时间，统计效率
							    		out.print(fail(claspath, classname, RequestJson, ExeTime, info, "查询表单异常", "返回表单失败  "+f_json));
										Page.colseDOP(db, out, page);
										return;// 程序关闭
								 }
							moudel_json.put("name",rs.getString("fromname") );//中文表单名
							moudel_json.put("basetable",from_name );//英文表单名
							moudel_json.put("dateId",dateId );//本条数据id
							moudel_json.put("editstatus",rs.getString("role_from.code") );//操作状态   0查看 1操作
							moudel_json.put("threads",threads);
//						}else{
//							
//							moudel_json.put("name",rs.getString("fromname") );//中文表单名
//							moudel_json.put("basetable",from_name );//英文表单名
//							moudel_json.put("dateId",dateId );//本条数据id
//							moudel_json.put("editstatus",rs.getString("role_from.code") );//操作状态   0查看 1操作
//System.out.println("f_json=="+f_json);
//System.out.println("t_json=="+t_json);
//							moudel_json.put("threads",Page.mergeJson("{\"threads\":["+f_json+"]}",t_json));//合并方法
//						}
					}
					moudel.add(moudel_json.toString());
				}if(rs!=null){rs.close();}
				
				
				
	        	//修改按钮数据表的sql语句
	        	String button_sql = "SELECT buttonname,buttoncode,url,http, buttonstatus,TYPE,fontcolour,backgroundcolour FROM z_role_button_bak,z_buttonfuntion_bak WHERE z_role_button_bak.roleid = '"+roleid+"' AND z_buttonfuntion_bak.fatherid = '18' AND z_role_button_bak.buttonid = z_buttonfuntion_bak.id ORDER BY sort ASC ";
	        	ResultSet buttonPrs = db.executeQuery(button_sql);
	        	while(buttonPrs.next()){
	        		json_button1.put("buttonname", buttonPrs.getString("buttonname"));
					json_button1.put("buttoncode", buttonPrs.getString("buttoncode"));
					json_button1.put("api", buttonPrs.getString("url"));
					json_button1.put("httptype", buttonPrs.getString("http"));
					json_button1.put("type", buttonPrs.getString("type"));
					json_button1.put("buttonstatus", buttonPrs.getString("buttonstatus"));
					json_button1.put("fontcolour", buttonPrs.getString("fontcolour"));
					json_button1.put("backgroundcolour", buttonPrs.getString("backgroundcolour"));
					list_button.add(json_button1.toString());
	        	}if(buttonPrs!=null){buttonPrs.close();}
				
				
				
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
		
		/**
		 * 
		 * @author Administrator
		 * @date 2017-10-15
		 * @Remarks 出错处理方法
		 */
		public static  JSONObject  fail(String claspath,String classname,String RequestJson,long  ExeTime,InfoEntity info,String msg,String sql_str){
			JSONObject json =new JSONObject();
			json.put("success", false);
			json.put("resultCode", "500");
			json.put("msg", msg);
			//记录出错日志
			Atm.AppuseLong(info, "",claspath,classname, RequestJson, ExeTime);
			//记录出错日
			Atm.LogSys("系统错误", classname + "模块系统出错", "写入订单主表失败  ：{"+sql_str+"}","1", info.getUSERID(), info.getIp());
			return json;
		}
}
