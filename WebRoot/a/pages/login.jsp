<%@ page trimDirectiveWhitespaces="true" %>
<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.io.*" %>
<%@ page import="net.sf.json.*" %>
<%@ page import="service.dao.db.Md5" %>
<%@ page import="java.security.*"%>
<jsp:useBean id="db" scope="page" class="service.dao.db.Jdbc"/>
<jsp:useBean id="server" scope="page" class="service.dao.db.Page"/>
<%
	String  InputString = null; // 读取请求内容
	String RequestJson="";
			try{
					BufferedReader br = new BufferedReader(new InputStreamReader(request.getInputStream(), "UTF-8"));// json进行uf8编码
					String line = null;
					StringBuilder sb = new StringBuilder();
					while((line = br.readLine())!= null){
						sb.append(line);
					}br.close();
					InputString = sb.toString();
				 	RequestJson=InputString.replaceAll(" ","").replaceAll("'","");
					System.out.println("RequestJson=="+RequestJson);
			}catch(Exception e){
				e.printStackTrace();
			} 
			String phone="",pws="",prandcode="";
		 	String randcode=(String)session.getAttribute("rand");//获取生成验证码
		 //	System.out.println("randcode=="+randcode);
		    try{//解析开始
					JSONArray arr = JSONArray.fromObject("[" + RequestJson + "]");
					for (int i = 0; i < arr.size(); i++) {
							JSONObject obj = arr.getJSONObject(i);
							phone= obj.get("mob") + "";//手机号 
							pws= obj.get("password") + "";//密码
							prandcode= obj.get("randcode") + "";//验证码 
					}
			} catch (Exception e) {
					out.print( "错误:json格式解析异常");
					return;
			}
            //判断手机号密码 
			if(phone==null){
				phone="";
			}else{
				phone=phone.replaceAll("<\\/?[^>]+>","").replaceAll(" ","");
			}
			if(pws==null){
				pws="";
			}else{
				pws=pws.replaceAll("<\\/?[^>]+>","").replaceAll(" ","");
			}
%>
<%
			String AppId=request.getHeader("X-AppId");  
			String AppKey=request.getHeader("X-AppKey");  
			String token=request.getHeader("Token"); 
			
			if(!"d42b46df6e583ca9a1b3e819dc42cfak".equals(AppId) || !"23548ad081d91ca0bdc66b22ca59cfc6".equals(AppKey)  || !"login".equals(token)){
				out.print("错误：api接口拒绝了您的请求");
				return;//跳出程序只行 
			}
			if(!regex_num(phone)){ 
				out.print("错误:手机号只能是纯数字");
				return;//跳出程序只行 
			} 
			if(phone.length()==0){ 
				out.print("请填写手机号");
				return;//跳出程序只行 
			} 
			//if(phone.length()!=11){ 
			//	out.print("错误:手机号只能是纯数字11");
			//	return;//跳出程序只行 
			//} 
			if(!regex_txt(pws)){ 
				out.print("错误:密码只能是a-z,A-Z,0-9的字符");
				return;//跳出程序只行 
			} 
		
			if(!regex_txt(prandcode) || prandcode.length()!=4){ 
				out.print("错误:验证码必须是4位数字");
				return;//跳出程序只行 
			} 
		 
			if(!prandcode.equals(randcode)){
			   out.print("错误:验证码不正确!");
			   return;
			}
%>
<% 	 
			System.out.println("SELECT COUNT(1) as row FROM  user_worker  WHERE usermob='"+phone+"'");
			//int  RegTagSF=db.Row("SELECT COUNT(1) as row FROM  user_worker  WHERE usermob='"+phone+"'");
			String checkFir = "SELECT count(1) row from                                                                                        "+
									"		((SELECT uid,usermob,t1.teacher_number num FROM	user_worker t                                  "+
									"				LEFT JOIN teacher_basic t1 ON t.user_association = t1.id                               "+
									"				WHERE	t.userole=1 )                                                                  "+
									"				UNION (SELECT	uid,usermob,student_number num FROM	user_worker t                      "+
									"				LEFT JOIN student_basic t1 ON t.user_association = t1.id                               "+
									"				WHERE	t.userole=2 )                                                                  "+
									"				union (SELECT uid,usermob,'' num from user_worker where userole!=1 and	 userole!=2)) t1 " +
									"				where t1.num='"+phone+"' or t1.usermob='"+phone+"' " ;
			System.out.println(checkFir);
			int RegTagSF = db.Row(checkFir);
			if(RegTagSF==0){
				   out.print("错误:系统无此用户!");
				   if(db!=null)db.close();db=null;if(server!=null)server=null; 
				   return;
			}			
			//int   RegTag=db.Row("SELECT COUNT(1) as row FROM   user_worker  WHERE usermob='"+phone+"' and password='"+pws+"';");
				String checkSec = "SELECT count(1) row  from                                                                                        "+
									"		((SELECT uid,usermob,t1.teacher_number num,password,userole FROM	user_worker t                                  "+
									"				LEFT JOIN teacher_basic t1 ON t.user_association = t1.id                               "+
									"				WHERE	t.userole=1 )                                                                  "+
									"				UNION (SELECT	uid,usermob,student_number num,password,userole FROM	user_worker t                      "+
									"				LEFT JOIN student_basic t1 ON t.user_association = t1.id                               "+
									"				WHERE	t.userole=2 )                                                                  "+
									"				union (SELECT uid,usermob,'' num,password,userole  from user_worker where userole!=1 and	 userole!=2)) t1 " +
									"				where (t1.num='"+phone+"' or t1.usermob='"+phone+"') and t1.password='"+pws+"'" ;
			int RegTag = db.Row(checkSec);
			if(RegTag==0){
				   out.print("错误:账户与密码不对!");
				   if(db!=null)db.close();db=null;if(server!=null)server=null; 
				   return;
			}	
		 	String ip=request.getHeader("x-real-ip");
		 	if(ip==null || ip.length()==0){ip=request.getRemoteAddr();}
		 
			int RandNO=(int)(Math.random()*9000+1000); //随机码
			//if(phone!=null && pws!=null   && phone.length()==11  && RegTag==1){
			if(phone!=null && pws!=null   && RegTag==1){
			 	Cookie usercookie = new Cookie("hljsfiy@usermob", phone);
			 	usercookie.setMaxAge(60*60*24);
			 	usercookie.setPath("/");
			 	response.addCookie(usercookie);
		
				Cookie keycookie = new Cookie("hljsfiy@userkey", md5(phone+"@"+pws).toLowerCase());
				keycookie.setMaxAge(60*60*24);
				keycookie.setPath("/");
				response.addCookie(keycookie);
		
				//重新登录就生成认证时间戳
				String markKey=md5(pws+"@youtu51"+phone+RandNO+md5(phone+"@temp"+pws)).toLowerCase();
				Cookie markKeycookie = new Cookie("hljsfiy@markKey",markKey);
				markKeycookie.setMaxAge(60*60*24);
				markKeycookie.setPath("/");
				response.addCookie(markKeycookie);
		 
				String uid="",nickname="",state="",userole=""; //useroel 1.teacher 2.student 3.parent 4.admin
				//ResultSet UerRs=db.executeQuery("SELECT uid,nickname,state FROM  user_worker  where usermob='"+phone+"' and password='"+pws+"';");  
				//ResultSet UerRs=db.executeQuery("SELECT t.uid,t.nickname,t.state  from user_worker t LEFT JOIN teacher_basic t1 ON t.teacherid=t1.id where (t1.teacher_number='"+phone+"' or t.usermob='"+phone+"') and t.`password`='"+pws+"'");  
				String userSql = "SELECT *  from                                                                                        "+
										"		((SELECT uid,usermob,t1.teacher_number num,password,nickname,t.state,userole FROM	user_worker t                                  "+
										"				LEFT JOIN teacher_basic t1 ON t.user_association = t1.id                               "+
										"				WHERE	t.userole=1 )                                                                  "+
										"				UNION (SELECT	uid,usermob,student_number num,password,nickname,t.state,userole FROM	user_worker t                      "+
										"				LEFT JOIN student_basic t1 ON t.user_association = t1.id                               "+
										"				WHERE	t.userole=2 )                                                                  "+
										"				union (SELECT uid,usermob,'' num,password,nickname,state,userole  from user_worker where userole!=1 and	 userole!=2)) t1 " +
										"				where (t1.num='"+phone+"' or t1.usermob='"+phone+"') and t1.password='"+pws+"'" ;
				ResultSet UerRs=db.executeQuery(userSql);
				if(UerRs.next()){    
					uid=UerRs.getString("uid");
					state=UerRs.getString("state");
					nickname=UerRs.getString("nickname");
					userole=UerRs.getString("userole");
				}if(UerRs!=null)UerRs.close(); 
				
				if(!"1".equals(state)){
				  out.print("错误:账户被禁用!");
				  if(db!=null)db.close();db=null;if(server!=null)server=null; 
				  return;
				}
				
			 	Cookie userolecookie = new Cookie("hljsfiy@userole", userole);
			 	usercookie.setMaxAge(60*60*24);
			 	userolecookie.setPath("/");
			 	response.addCookie(userolecookie);
				
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


 