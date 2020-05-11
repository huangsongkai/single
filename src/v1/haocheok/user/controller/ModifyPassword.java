package v1.haocheok.user.controller;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import service.dao.db.Jdbc;
import service.dao.db.Page;
import service.sys.Atm;
import service.sys.ErrMsg;
import v1.haocheok.commom.entity.InfoEntity;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.Calendar;

/**
 * 
 * @author Administrator
 * @date 2017-9-7
 * @file_name ModifyPassword.java   用户修改密码
 * @Remarks
 */

public class ModifyPassword {
	
	public void modifyPassword(HttpServletRequest request, HttpServletResponse response,String RequestJson,InfoEntity info) throws ServletException, IOException {
		
		
		Jdbc db = new Jdbc();
		Page page = new Page();

	    String classname="app  用户修改密码";
        String claspath=this.getClass().getName();
        
		response.setContentType("text/html;charset=UTF-8");
		request.setCharacterEncoding("UTF-8");
		response.setCharacterEncoding("UTF-8");
		
		String journal="";//日志记录内容
		
		PrintWriter out = response.getWriter();
    	JSONObject json = new JSONObject();

	    
		//声明变量；
	    String mobile = "";//用户手机
	    String mobcode = "";//校验码  
	    String password = "";//密码 
	    
	    try { // 解析开始
			JSONArray arr = JSONArray.fromObject("[" + RequestJson + "]");
			for (int i = 0; i < arr.size(); i++) {
				JSONObject obj = arr.getJSONObject(i);
				mobile = obj.get("mobile") + "";     //手机号码
				mobcode = obj.get("mobcode") + ""; //验证码
				password = obj.get("password") + ""; //新密码
				
			}
		} catch (Exception e) {
			  ErrMsg.falseErrMsg(request, response, "500", "json格式解析异常");
			  Page.colseDOP(db, out, page);
			  return;
		}
		
		
		//判断 手机号是否合法
		if(Page.isChinaPhoneLegal(mobile)){
			
			//判断验证码是否合法
			if(Page.isnumber(mobcode)){
				String ifmobcode="SELECT ifnull(updatetime,'0') ROW FROM user_worker WHERE  usermob='"+mobile+"' AND mobcode='"+mobcode+"' ";
				int upmobcode=db.Row(ifmobcode);
				
				if(Page.int_time()<(upmobcode+300)){//验证码正确  在有效时间
			
					
					String pass =Page.filter_sql(password);
					
					if("安全".equals(pass)){
						String  uppassword="UPDATE `user_worker` SET `password`='"+password+"' WHERE usermob='"+mobile+"' AND mobcode='"+mobcode+"';";
						System.out.println("uppassword==="+uppassword);
						boolean upstate=db.executeUpdate(uppassword);
						if(upstate){
							json.put("success", true);
							json.put("resultCode", "1000");
							json.put("msg", "修改成功！");
							journal="用户修密码   修改成功！";
						}else{
							json.put("success", false);
							json.put("resultCode", "500");
							json.put("msg", "网路异常,请稍后重试！");
							journal="用户修密码   更新用户密码错误：【"+uppassword+"】";
							//Atm.SendEmil("好车帮金融", "用户修改密码错误", "用户修改密码错误：【"+uppassword+"】", MailServerConf.get("adminEmil"));
						}
						
						
					}else{
						json.put("success", false);
						json.put("resultCode", "500");
						json.put("msg", pass);
						journal="用户修密码   失败 --"+pass;
					}
				}else if(upmobcode==0){//验证码错误
					json.put("success", false);
					json.put("resultCode", "500");
					json.put("msg", "验证码错误,请输入正确的验证码！");
					journal="用户修密码   失败 --验证码错误,请输入正确的验证码";
				}else{//验证码超时
					json.put("success", false);
					json.put("resultCode", "500");
					json.put("msg", "验证码超时,请重新获取验证码！");
					journal="用户修密码   失败 --验证码超时";
				}
			}else{
				json.put("success", false);
				json.put("resultCode", "500");
				json.put("msg", "验证码格式错误,请输入正确的验证码！");
				journal="用户修密码   失败 --验证码格式错误,请输入正确的验证码";
			}
		}else{
			json.put("success", false);
			json.put("resultCode", "500");
			json.put("msg", "手机号格式错误,请输入正确的手机号！");
			journal="用户修密码   失败 --手机号不合法";
		}
		
		out.println(json);
		System.out.println(json);
		long ExeTime = Calendar.getInstance().getTimeInMillis()-info.getTimeStart();
		//添加操作日志
		Atm.LogSys(classname, journal, "操作者"+info.getUSERID()+"", "1",info.getUSERID(), info.getIp());
		// 记录执行日志
		Atm.AppuseLong(info, "", claspath, classname, json.toString(), ExeTime);
		Page.colseDOP(db, out, page);
		
		return;
	}
}