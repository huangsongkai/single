<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%
 String ip=request.getHeader("x-real-ip");
 if(ip==null || ip.length()==0){ip=request.getRemoteAddr();}
%>
{"cip": "<%=ip%>","lanips": "218.7.10.2;218.7.10.3;218.7.10.4;218.7.10.5;218.7.10.6;218.7.10.7;218.7.10.8;218.7.10.9;"}
 