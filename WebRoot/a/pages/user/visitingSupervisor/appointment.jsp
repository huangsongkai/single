<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page import="v1.haocheok.commom.entity.UserEntity"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="v1.haocheok.commom.common"%>
<%@include file="../../cookie.jsp"%>


<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <base href="<%=basePath%>">
    
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">

	
<style type="text/css">
	
	.appointment{color: #575757;width: 100%;}
	.appointment h4{line-height: 45px;border-bottom: 1px solid #cac9c9;font-weight: normal;padding:0;margin:0;padding-left: 20px;margin-bottom:10px;}
	.appointment p{line-height: 28px;padding:0;margin:0;padding-left: 20px;}

	
</style>
  </head>
  
  <body>
  <div class="appointment">
  		<%
  			String orderid = request.getParameter("order");
  			if(orderid==null){orderid="0";}
  			String sql = "SELECT userid FROM homevisits_time WHERE orderid="+orderid+" GROUP BY userid";
  			ResultSet sql_prs = db.executeQuery(sql);
  			
  			while(sql_prs.next()){
  				int i = 1;
  				String sql_uu = "select appointmenttime from homevisits_time where orderid="+orderid+" and userid="+sql_prs.getString("userid")+" ";
  				ResultSet sql_pppp = db.executeQuery(sql_uu);
  				
  		%>
  			<h4><font color="#B03060" style="font-weight:bold;" ><%=common.getusernameTouid(sql_prs.getString("userid")) %></font>预约时间</h4>
  		<% 
  				while(sql_pppp.next()){
  					SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd"); 
  					SimpleDateFormat sdf1 = new SimpleDateFormat("HH-mm"); 
  		 %>
			
			<p>第<%=i %>次&nbsp;&nbsp;<%=sdf.format(sql_pppp.getTimestamp("appointmenttime")) %>&nbsp;&nbsp;<%=sdf1.format(sql_pppp.getTimestamp("appointmenttime")) %></p>
		<%
			i++;} 
			
		}%>
	</div>
  </body>
</html>
<%
if(db!=null)db.close();db=null;if(server!=null)server=null;
%>