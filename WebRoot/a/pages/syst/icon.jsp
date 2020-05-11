<%@ page trimDirectiveWhitespaces="true" %>
<%@ page language="java" import="java.io.*,java.util.*" pageEncoding="UTF-8"%>
<!DOCTYPE html> 
<html lang="zh_CN"> 
<head> 
    <meta charset="utf-8"> 
    <meta name="viewport" content="width=device-width, initial-scale=1"> 
<link href="../css/base.css" rel="stylesheet">
<link href="../css/platform.css" rel="stylesheet">
<style type="text/css">
html {
    height: 100%;
    background: #09825b;
    min-width: 1200px;
    overflow: auto;
}
</style>
</head>  
<body style="overflow:auto; ">
	<div style="overflow:scroll; text-align:center;">
	        <%for(int i=600;i<700;i++){%>
	         <code>"& # x e <%=i %>;"</code>
	         <p style=" color: white; font-size: 80px; display: inline-block;">
	            <span class="iconfont" style="    font-size: 60px;">&#xe<%=i %>;</span>
	  		</p><br>
	 		 <%} %>
	 		 <%
	 		char begin_letter1='a';
	 		
	 		for (int i=(int)begin_letter1;i<begin_letter1+6;i++){
	 		int aa=0;
		 		for(;aa<10;){
		 		aa++;
		 		%>   	       
	         <code>"& # x e 6<%=aa %> <%=(char)i%>;"</code>
	         <p style=" color: white; font-size: 80px; display: inline-block;">
	            <span class="iconfont" style="    font-size: 60px;">&#xe6<%=aa %><%=(char)i %>;</span>
	  		</p><br>
	 		 <%}
	 		} %>
	</div>
</body> 
</html>