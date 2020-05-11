//package v1.haocheok.commom;
//
//import java.io.IOException;
//import java.io.PrintWriter;
//import java.util.Calendar;
//
//import javax.servlet.ServletException;
//import javax.servlet.http.HttpServletRequest;
//import javax.servlet.http.HttpServletResponse;
//
//import net.sf.json.JSONArray;
//import net.sf.json.JSONObject;
//import service.common.MailServerConf;
//import service.common.SendCodes;
//import service.dao.db.Jdbc;
//import service.dao.db.Page;
//import service.sys.Atm;
//import service.sys.ErrMsg;
//import v1.haocheok.commom.entity.InfoEntity;
//
//
///**
// *
// * @author Administrator
// * @date 2017-9-6
// * @file_name SendCode.java   发送验证码
// * @Remarks
// */
//public class SendCode {
//
//	public void sendCode(HttpServletRequest request, HttpServletResponse response,String RequestJson,InfoEntity info) throws ServletException, IOException {
//
//
//		Jdbc db = new Jdbc();
//		Page page = new Page();
//
//	    String classname="app  发送验证码";
//        String claspath=this.getClass().getName();
//
//		response.setContentType("text/html;charset=UTF-8");
//		request.setCharacterEncoding("UTF-8");
//		response.setCharacterEncoding("UTF-8");
//
//		String journal="";//日志记录内容
//
//		PrintWriter out = response.getWriter();
//    	JSONObject json = new JSONObject();
//
//
//		//声明变量；
//	    String mobile = "";
//	    String sendtype = "";
//
//	    try { // 解析开始
//			JSONArray arr = JSONArray.fromObject("[" + RequestJson + "]");
//			for (int i = 0; i < arr.size(); i++) {
//				JSONObject obj = arr.getJSONObject(i);
//				mobile = obj.get("mobile") + "";     //手机号码
//				sendtype = obj.get("sendtype") + ""; //发送类型
//
//				if(sendtype==null || sendtype.equals("") || sendtype.length()<1){ sendtype="0";}
//			}
//		} catch (Exception e) {
//			  ErrMsg.falseErrMsg(request, response, "500", "json格式解析异常");
//			  Page.colseDOP(db, out, page);
//			  return;
//		}
//
//		//判断手机号是否合法
//		if(Page.isChinaPhoneLegal(mobile)){
//
//			//判断手机号码是否存在
//			String ifphone="SELECT COUNT(1) ROW FROM user_worker WHERE  usermob='"+mobile+"' ";
//			int phonestate=db.Row(ifphone);
//
//			switch (phonestate) {
//			case 1:
//
//				//生成6位验证码
//				int RandomCode = (int) (Math.random() * 900000) + 100000;
//
//				//将验证码保存到数据库
//				String upCode_sql="UPDATE `user_worker` SET `mobcode`='"+RandomCode+"',updatetime='"+Page.int_time()+"'  WHERE usermob='"+mobile+"';";
//				boolean upstate=db.executeUpdate(upCode_sql);
//
//				if(upstate){
//					//发送验证码
//					String smscode=SendCodes.SmsCode(mobile, RandomCode);
//
//					if("true".equals(smscode)){
//						json.put("success", true);
//						json.put("resultCode", "1000");
//						json.put("msg", "验证码已下发至您的手机请注意查收");
//						journal="用户修密码-发送验证码    发送成功";
//
//					}else if("同一手机号验证码短信发送超出5条".equals(smscode)){
//
//						json.put("success", false);
//						json.put("resultCode", "500");
//						json.put("msg", "该号码发送验证码次数已达到5次,请24小时后重试");
//						journal="用户修密码-发送验证码    ["+mobile+"]该号码发送验证码次数已达到5次";
//
//					}else{
//
//						json.put("success", false);
//						json.put("resultCode", "500");
//						json.put("msg", "网路错误，请稍后重试");
//						journal="用户修密码-发送验证码    发送验证码失败,未知错误（检查账户余额）";
//						Atm.SendEmil("好车帮金融", classname+"出错", "手机号码    ["+mobile+"]  发送验证码失败,未知错误（检查账户余额)", MailServerConf.get("adminEmil"));
//
//					}
//				}else{
//					json.put("success", false);
//					json.put("resultCode", "500");
//					json.put("msg", "网路异常请稍后重试");
//					journal="用户修密码-发送验证码  保存验证码错误 【"+upCode_sql+"】";
//				}
//				break;
//
//			case 0:
//				json.put("success", false);
//				json.put("resultCode", "404");
//				json.put("msg", "未找到该手机号码，请与后台管理员核实用户信息");
//				journal="用户修密码-发送验证码  【"+mobile+"】 找到该手机号码";
//				break;
//
//			default://出现异常情况
//				Atm.SendEmil("好车帮金融", classname+"出错", "手机号码    ["+mobile+"]  出现多次,请检查数据结构", MailServerConf.get("adminEmil"));
//				json.put("success", false);
//				json.put("resultCode", "500");
//				json.put("msg", "该手机号异常，请与后台管理员联系");
//				journal="用户修密码-发送验证码  【"+mobile+"】 该手机号异常，请与后台管理员联系";
//				break;
//			}
//
//
//		}else{
//
//			json.put("success", false);
//			json.put("resultCode", "500");
//			json.put("msg", "手机号格式错误,请输入正确的手机号！");
//			journal="用户修密码-发送验证码  失败";
//		}
//
//
//		out.println(json);
//		System.out.println(json);
//		long ExeTime = Calendar.getInstance().getTimeInMillis()-info.getTimeStart();
//		//添加操作日志
//		Atm.LogSys(classname, journal, "操作者"+info.getUSERID()+"", "1",info.getUSERID(), info.getIp());
//		// 记录执行日志
//		Atm.AppuseLong(info, "", claspath, classname, json.toString(), ExeTime);
//		Page.colseDOP(db, out, page);
//
//		return;
//	}
//}
