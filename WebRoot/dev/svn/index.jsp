<%@ page language="java" import="java.io.*"  pageEncoding="utf8"%>
<%@ page import="java.util.*" %>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"s://"+request.getServerName()+":"+request.getServerPort()+path+"";
basePath=basePath.replaceAll(":80","");
%> 
<%if( basePath.indexOf("e168.cn")!=-1){%>
<script type="text/javascript">
var targetProtocol = "https:";
if (window.location.protocol != targetProtocol)
 window.location.href = targetProtocol +
  window.location.href.substring(window.location.protocol.length);
</script>
<%}%>
 <%
String pass = request.getParameter("pass"); 
if(pass==null){pass="ooo";}
%>
 

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
 
    <title>svn</title>
 
  </head>
  
  <body>
 <%if(!"gaosong".equals(pass)){%>
<div align="center"><img src="svn.jpg"></div>
<div align="center"><form id="form1" name="form1" method="post" action="index.jsp?num=<%=Calendar.getInstance().getTimeInMillis()%>">
 SVN 执行更新授权码
  <input type="password" name="pass" id="textfield" />
 <input type="submit" name="button" id="button" value="登录" />
</form></div>
<%}else{%>
  HI, SVN 执行更新部署到服务器上<br>
   执行结果：<font color="red">
   <% 
 Runtime runtime = Runtime.getRuntime(); 
 Process process =null;  
 //执行dos命令
String commandstr = "D:\\wwwroot\\dev.e168.cn\\webapps\\hljsfjy\\dev\\svn\\svn.bat";
Process p ;
try {
   p = Runtime.getRuntime().exec(commandstr);
//等待刚刚执行的命令的结束   
while (true){  
	  out.print(" 更新完毕！");
           if(p.waitFor() == 0)   break;
   }    
   
} catch (Exception e) {
    out.println(e.toString());
   }
  %>
</font>
  <%}%> 

  </body>
</html>
 