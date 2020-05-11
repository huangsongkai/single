<%@ page trimDirectiveWhitespaces="true"%>
<%@ page contentType="text/html; charset=UTF-8" language="java"  import="java.util.regex.*,java.net.*,java.util.*,net.sf.json.*"%>
<%String title = request.getParameter("title");
String uid = request.getParameter("uid"); 
String token = request.getParameter("token");

%> 
您的信息<br>
title=<%=title %><br>
uid=<%=uid %><br>
token=<%=token %><br>
<hr>
<div class="align-center">暂无数据</div> 
