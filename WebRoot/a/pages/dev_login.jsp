<%@ page trimDirectiveWhitespaces="true" %>
<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%String ac = request.getParameter("ac"); if(ac==null){ac=" ";}//  
if("login".equals(ac)){
%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.io.*" %>
<%@ page import="net.sf.json.*" %>
<%@ page import="service.dao.db.Md5" %>
<%@ page import="java.security.*"%>
<%@page import="v1.haocheok.commom.common"%>
<jsp:useBean id="db" scope="page" class="service.dao.db.Jdbc"/>
<jsp:useBean id="server" scope="page" class="service.dao.db.Page"/>
<%
String phone = request.getParameter("phone"); if(phone==null){phone=" ";}// 
String pws = request.getParameter("pws"); if(pws==null){pws=" ";}// 
System.out.println("phone="+phone);
System.out.println("pws="+pws);
if(phone.length()!=11){ 
	out.print("错误:手机号只能是纯数字11");
	return;//跳出程序只行 
} 

if(!regex_txt(pws)){ 
	out.print("错误:密码只能是a-z,A-Z,0-9的字符");
	return;//跳出程序只行 
} 

%>
<% 	  	String ip=request.getHeader("x-real-ip");
	        if(ip==null || ip.length()==0){ip=request.getRemoteAddr();}
			//System.out.println("SELECT COUNT(1) as row FROM  user_worker  WHERE usermob='"+phone+"'");
			int  RegTagSF=db.Row("SELECT COUNT(1) as row FROM  user_worker  WHERE usermob='"+phone+"'");
			if(RegTagSF==0){
				   out.print("错误:系统无此用户!");
				   if(db!=null)db.close();db=null;if(server!=null)server=null; 
				   return;
			}
			
			int   RegTag=db.Row("SELECT COUNT(1) as row FROM   user_worker  WHERE usermob='"+phone+"' and password='"+pws+"';");
			if(RegTag==0){
				   out.print("错误:账户与密码不对!");
					db.executeUpdate("insert into `log_sys` (`ltype`, `title`, `body`, `uid`, `fid`, `ip`, `status`, `addtime`) values('登陆','用户电脑端登录','用户:("+phone+") 通过pc电脑端<font color=\"#ff0000\">登录失败</font>','0','0','"+ip+"','0',now());");
					
				   if(db!=null)db.close();db=null;if(server!=null)server=null; 
				   return;
			}
		
		 
		 
			int RandNO=(int)(Math.random()*9000+1000); //随机码
			if(phone!=null && pws!=null   && phone.length()==11  && RegTag==1){
			 	Cookie usercookie = new Cookie("hljsfiy@usermob", phone);
			 	usercookie.setMaxAge(60*60*24);
			 	response.addCookie(usercookie);
		
				Cookie keycookie = new Cookie("hljsfiy@userkey", md5(phone+"@"+pws).toLowerCase());
				keycookie.setMaxAge(60*60*24);
				response.addCookie(keycookie);
		
				//重新登录就生成认证时间戳
				String markKey=md5(pws+"@hljsfiy"+phone+RandNO+md5(phone+"@temp"+pws)).toLowerCase();
				Cookie markKeycookie = new Cookie("hljsfiy@markKey",markKey);
				markKeycookie.setMaxAge(60*60*24);
				response.addCookie(markKeycookie);
		 
				String uid="",nickname="",state="",companyname="黑龙江司法警官学院",regionalname="",role_name=""; 
				ResultSet UerRs=db.executeQuery("SELECT uid,nickname,state FROM  user_worker  where usermob='"+phone+"' and password='"+pws+"';");  
				if(UerRs.next()){    
					uid=UerRs.getString("uid");
					state=UerRs.getString("state");
					nickname=UerRs.getString("nickname");
				}if(UerRs!=null)UerRs.close(); 
				
				if(!"1".equals(state)){
				  out.print("错误:账户被禁用!");
				  if(db!=null)db.close();db=null;if(server!=null)server=null; 
				  return;
				}
				//String regionalcode=common.getRegionalcodeTouid(uid);
				//更新用户token
				//db.executeUpdate("UPDATE user_worker SET pc_token='"+markKey+"',regionalname='"+common.getRegionalname(regionalcode)+"',role_name='"+common.getroleNameTouid(uid)+"' WHERE uid='"+uid+"'"); 
				db.executeUpdate("insert into `log_sys` (`ltype`, `title`, `body`, `uid`, `fid`, `ip`, `status`, `addtime`) values('切换登陆','用户电脑端登录成功','用户:"+nickname+"("+phone+") 通过pc电脑端登录成功','"+uid+"','0','"+ip+"','0',now());");
				out.print("<meta http-equiv=\"Refresh\" content=\"0;URL=main.jsp?jssonid="+md5(phone+"@"+phone+pws).toLowerCase()+"\" />");
				
				//更新用户token
				db.executeUpdate("UPDATE user_worker SET pc_token='"+markKey+"' WHERE uid='"+uid+"'"); 
				out.print("success");
			}
		
	if(db!=null)db.close();db=null;if(server!=null)server=null;
%>
<%!
	private boolean regex_num(String str){ 
			java.util.regex.Pattern p=null;  
			java.util.regex.Matcher m=null;
			
			boolean value=true; 
				try{ 
					p = java.util.regex.Pattern.compile("[^0-9]"); 
					m = p.matcher(str); 
					if(m.find()){ 
						value=false; 
					} 
				}catch(Exception e){
				} 
			return value; 
	} 
%>
<%!
	private boolean regex_txt(String str){ 
			java.util.regex.Pattern p=null; 
			java.util.regex.Matcher m=null; 
			boolean value=true; 
				try{ 
					p = java.util.regex.Pattern.compile("[^0-9A-Za-z]"); 
					m = p.matcher(str); 
					if(m.find()){ 
						value=false; 
					} 
				}catch(Exception e){
				} 
			return value; 
	} 
%>
<%! 
public String md5(String s){ 
	char hexDigits[] ={ '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'a', 'b', 'c', 'd', 'e', 'f'}; 
	try { 
		byte[] strTemp = s.getBytes(); 
		MessageDigest mdTemp = MessageDigest.getInstance("MD5"); 
		mdTemp.update(strTemp); 
		byte[] md = mdTemp.digest(); 
		int j = md.length; 
		char str[] = new char[j * 2]; 
		int k = 0; 
		for (int i = 0; i < j; i++) { 
			byte byte0 = md[i]; 
			str[k++] = hexDigits[byte0 >>> 4 & 0xf]; 
			str[k++] = hexDigits[byte0 & 0xf]; 
		} 
		return new String(str); 
	}catch (Exception e){ 
		return null; 
	} 
} 
%>
<%}else{ %>no 


<%} %>

 