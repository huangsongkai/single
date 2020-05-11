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
 * 完善此订单表单信息接口
 * @company 010jiage
 * @author zhoukai04171019
 * @date:2017-10-13 上午10:25:33
 */
public class DoPerfectController {
	
	@SuppressWarnings("unchecked")
	public void DoPerfect(HttpServletRequest request, HttpServletResponse response,String RequestJson, InfoEntity info) throws ServletException, IOException {
	    
		Jdbc db = new Jdbc();
	    Page page = new Page();
	    
        response.setContentType("text/html;charset=UTF-8");
		request.setCharacterEncoding("UTF-8");
		response.setCharacterEncoding("UTF-8");
		PrintWriter out = response.getWriter();

	    String classname="完善订单信息";
        String claspath=this.getClass().getName();

        long TimeStart = new Date().getTime();// 程序开始时间，统计效率
        
        @SuppressWarnings("unused")
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
        String slect_from="   select * from (               " +
        									"SELECT  GROUP_CONCAT("+
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
													",'\"editstatus\":','\"',IFNULL(1,''),'\"' "+
											       ",'}' )  "+
											")AS json,"+
											"form_name.datafrom AS from_name,  "+
											"form_name.formname AS fromname  "+
										  "FROM form_name," +
										  "form_template_confg," +
										  "f_personnel,(SELECT @i:=0) b "+
										  "WHERE form_name.datafrom = 'f_personnel' AND form_name.id = form_template_confg.fid AND  f_personnel.orderid = "+orderid+" GROUP BY f_personnel.id" +
										  " UNION ALL  " +
										  "SELECT  GROUP_CONCAT("+
											"CONCAT('{'  "+
													",'\"ispost\":',IFNULL(form_template_confg.ispost,'\"\"')"+
													",',' "+
													",'\"uniquelyid\":','\"',IFNULL(((@i:=@i + 1)+form_template_confg.tid),''),'\"' "+
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
													",'\"editstatus\":','\"',IFNULL(1,''),'\"' "+
											       ",'}' )  "+
											")AS json,"+
											"form_name.datafrom AS from_name,  "+
											"form_name.formname AS fromname  "+
										  "FROM form_name," +
										  "form_template_confg," +
										  "f_guarantee,(SELECT @i:=0) b " +
										  "WHERE " +
										  "form_name.datafrom = 'f_guarantee' " +
										  "AND form_name.id = form_template_confg.fid " +
										  "AND  f_guarantee.orderid = "+orderid+" " +
										  " GROUP BY f_guarantee.id " +
										  " ) as a";
        ResultSet rs = db.executeQuery(slect_from);
        //表单
        JSONObject moudel_json=new  JSONObject();
        ArrayList<String> moudel = new ArrayList<String> ();
        
        
        //按钮
        JSONObject json_button1 = new JSONObject();
	    ArrayList list_button = new ArrayList();
        
        try{
        	
        	
        	//基本信息
			String base_sql = "SELECT zk_role.id AS roleid,rolecode FROM zk_user_role,zk_role WHERE zk_user_role.sys_role_id = zk_role.id AND zk_user_role.sys_user_id = '"+info.getUSERID()+"'";
			
			ResultSet basePrs = db.executeQuery(base_sql); 
			@SuppressWarnings("unused")
			String roleid = "";
			if(basePrs.next()){
				roleid = basePrs.getString("roleid");
				rolecode = basePrs.getString("rolecode");
			}if(basePrs!=null){basePrs.close();}
			
			//按钮
        	
        	json_button1.put("buttonname", "提交");
        	json_button1.put("buttoncode", "submit");
        	json_button1.put("api", "app/do/fromDate");
        	json_button1.put("httptype", "post");
			json_button1.put("type", "6");
			json_button1.put("buttonstatus", "6");
			json_button1.put("fontcolour", "#ffffff");
			json_button1.put("backgroundcolour", "#FF0000");
			list_button.add(json_button1.toString());
			
			int i = 1;
        	int dateId=0;
        	String  formid="";
			while(rs.next()){
				String from_name=rs.getString("from_name");//英文表单名
				String f_json=rs.getString("json");//未赋值的字段
				//判断是否为担保人表单
				if("f_guarantee".equals(from_name)){
					int t_json2=db.Row("select count(1) Row  from "+from_name+" where orderid="+orderid+" ;");//表单的字段
					int tttt=t_json2-(i-1);
					formid=db.executeQuery_str("SELECT GROUP_CONCAT(id) as str FROM "+from_name+" WHERE orderid="+orderid+" ");//表单的字段
					String formidarr []=formid.split("\\,");
					dateId= Integer.parseInt(formidarr[tttt].toString()) ;
				}else{
					dateId=db.Row("SELECT id as Row FROM "+from_name+" WHERE orderid="+orderid+" ");//表单的字段
				}
				
				
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
					
					
//					threads.add(f_json.toString());
					moudel_json.put("name",rs.getString("fromname")+""+String.valueOf(i) );//中文表单名
					moudel_json.put("basetable",from_name );//英文表单名
					moudel_json.put("dateId",dateId );//英文表单名
					moudel_json.put("editstatus","1" );//表单编辑状态
					moudel_json.put("threads",threads);
				}else{
					moudel_json.put("name",rs.getString("fromname")+""+String.valueOf(i) );//中文表单名
					moudel_json.put("basetable",from_name );//英文表单名
					moudel_json.put("dateId",dateId );//英文表单名
					moudel_json.put("editstatus","1" );//表单编辑状态
					moudel_json.put("threads",Page.mergeJson("{\"threads\":["+f_json+"]}",t_json));//合并方法
				}
				moudel.add(moudel_json.toString());
				i++;
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
