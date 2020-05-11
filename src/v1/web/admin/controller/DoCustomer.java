package v1.web.admin.controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.Calendar;

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
 * 提交客户档案信息
 * @author wo
 *
 */
public class DoCustomer {
	
	public void setcustomer(HttpServletRequest request, HttpServletResponse response,String RequestJson,InfoEntity info) throws ServletException, IOException {
		Jdbc db = new Jdbc();
		Page page = new Page();

	    String classname="WEB 提交客户档案信息";
        String claspath=this.getClass().getName();
		response.setContentType("text/html;charset=UTF-8");
		request.setCharacterEncoding("UTF-8");
		response.setCharacterEncoding("UTF-8");
		
    	PrintWriter out = response.getWriter();
    	
    	JSONObject responsejson = new JSONObject();
    	
		//判断过滤非法字符: 
	    if(!regex(info.getUUID())){ 
	    	ErrMsg.falseErrMsg(request, response, "500", "数据格式不匹配");
	    	Page.colseDOP(db, out, page);
			return;//跳出程序执行 
	     }  

		    
	    /*
	     * Token合法性判断
	     */
	    int UerTag = db.Row("SELECT COUNT(1) AS ROW  FROM  user_worker WHERE uid='"+info.getUSERID()+"'  and pc_token='"+ info.getToken() + "';");
	    System.out.println("SELECT COUNT(1) AS ROW  FROM  user_worker WHERE uid='"+info.getUSERID()+"'  and pc_token='"+ info.getToken() + "';");
	    if (UerTag == 0) {
	    	out.print(Page.returnjson("403","Token非法，接口拒绝"));
	    	Page.colseDOP(db, out, page);
		    return;//跳出程序只行 
	    }
		//声明变量；
	    String id = "";
	    String customername = "";
	    String sex = "";
	    String birthdate = "";
	    String identityid = "";
	    String phonenumber = "";
	    String contactaddress = "";
	    String companyname = "";
	    String companyaddress = "";
	    String nation = "";
	    String industrycategory = "";
	    String maritalstatus = "";
	    try { // 解析开始
			JSONArray arr = JSONArray.fromObject("[" + RequestJson + "]");
			for (int i = 0; i < arr.size(); i++) {
				JSONObject obj = arr.getJSONObject(i);
				id = obj.get("id") +"";
				customername = obj.get("customername") + "";
				sex = obj.get("sex") + "";
				birthdate = obj.get("birthdate") +"";
				identityid = obj.get("identityid") + "";
				phonenumber = obj.get("phonenumber") + "";
				contactaddress = obj.get("contactaddress") +"";
				companyname = obj.get("companyname") + "";
				companyaddress = obj.get("companyaddress") + "";
				nation = obj.get("nation") + "";
				industrycategory = obj.get("industrycategory") + "";
				maritalstatus = obj.get("maritalstatus") + "";
			}
		} catch (Exception e) {
			  ErrMsg.falseErrMsg(request, response, "500", "json格式解析异常");
			  Page.colseDOP(db, out, page);
			  return;
		}
			     
	    //主查询语句
		try {
			if (id==null || id.indexOf("null")!=-1 ) {
				//添加
				String sql_base= "INSERT INTO `order_customerfile` (customername,sex,birthdate,identityid,phonenumber,contactaddress,companyname,companyaddress,nation,industrycategory,maritalstatus,creation_date,creation_uid,updatetime,up_uid) VALUES('"+customername+"','"+sex+"'," +
								"'"+birthdate+"','"+identityid+"','"+phonenumber+"','"+contactaddress+"'," +
								"'"+companyname+"','"+companyaddress+"','"+nation+"','"+industrycategory+"','"+maritalstatus+"',now(),'"+info.getUSERID()+"',now(),'"+info.getUSERID()+"');";
				System.out.println(sql_base);
				boolean insert_status = db.executeUpdate(sql_base);
				if(insert_status){
					responsejson.put("success", true);
					responsejson.put("resultCode", "1000");
					responsejson.put("msg", classname+"成功");
					//添加操作日志
					Atm.LogSys("添加客户资料", "用户WEB端添加客户资料成功", "操作者"+info.getUSERID()+"", "0",info.getUSERID(), info.getIp());
				}else{
					responsejson.put("success", false);
					responsejson.put("resultCode", "2000");
					responsejson.put("msg", classname+"成功");
					//添加操作日志
					Atm.LogSys("添加客户资料", "用户WEB端添加客户资料失败", "操作者"+info.getUSERID()+"", "1",info.getUSERID(), info.getIp());
				}
			} else {
				//修改
				// 判断过滤非法字符:
				if (!Page.regex(id) ) {
					ErrMsg.falseErrMsg(request, response, "500", "数据格式不匹配");
					Page.colseDOP(db, out, page);
					return;// 跳出程序只行
				}
				
				@SuppressWarnings("unused")
				String sql_update = "UPDATE `order_customerfile` set customername = '"+customername+"',sex = '"+sex+"',birthdate='"+birthdate+"'";
				
				//String sql_update = "UPDATE `order_customerfile`";
				responsejson.put("success", true);
				responsejson.put("resultCode", "1000");
				responsejson.put("msg", "修改客户资料成功");
				System.out.println("修改资料");
			}
	    
		} catch (Exception e) {
			   ErrMsg.falseErrMsg(request, response, "500", "服务器开小差啦");
			   Atm.LogSys("系统错误", classname+"模块系统出错","错误信息详见 "+claspath, "1",info.getUSERID(), info.getIp());
			   Page.colseDOP(db, out, page);
			   return;

		}
	
		

		out.println(responsejson);//返回给接口
	// 记录执行日志
	long ExeTime = Calendar.getInstance().getTimeInMillis()-info.getTimeStart();
	Atm.AppuseLong(info, info.getUSERID(), claspath, classname, responsejson.toString(), ExeTime);
	Page.colseDOP(db, out, page);
}

private boolean regex(String str){ 
	java.util.regex.Pattern p=null; //正则表达式 
	java.util.regex.Matcher m=null; //操作的字符串 
	boolean value=true; 
	try{ 
	p = java.util.regex.Pattern.compile("[^0-9A-Za-z]"); 
	m = p.matcher(str); 
	if(m.find()) { 

	value=false; 
	} 
	}catch(Exception e){} 
	return value; 
	} 

}
