<%@ page trimDirectiveWhitespaces="true" %>
<%@ page contentType="text/html; charset=UTF-8" language="java"
	import="java.util.regex.*,java.sql.*,java.util.*,java.io.*,net.sf.json.*"%>
<%@page import="service.common.SendMail"%>
<jsp:useBean id="db" scope="page" class="service.dao.db.Jdbc" />

<% 
SendMail sendMail=new SendMail();
String title="",mailinfo="",eamiladdes=""; 
	
		ResultSet UsRs=db.executeQuery("SELECT email FROM  `dev_json_user`  where  state=1; ");  
        while(UsRs.next()){    
	  	    eamiladdes=eamiladdes+UsRs.getString("email")+"#";
	      }if(UsRs!=null)UsRs.close(); 
	
	out.print(eamiladdes);
	
	ResultSet Rs=db.executeQuery("SELECT * FROM  `dev_user_send_email`  where  state=0; ");  
      while(Rs.next()){    
	  	title=Rs.getString("title");
	  	mailinfo=Rs.getString("mailinfo").replaceAll("\r\n","<br>");
	    db.executeUpdate(" update  `dev_user_send_email` set `state`='1' where `id`='"+Rs.getString("id")+"';");
	    sendMail.send("开发联调平台",""+title+"",mailinfo,eamiladdes);
	   }if(Rs!=null)Rs.close(); 
      

	if (db != null)
		db.close();
	    db = null;
 
%>
 