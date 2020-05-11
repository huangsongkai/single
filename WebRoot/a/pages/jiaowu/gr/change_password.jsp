<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page trimDirectiveWhitespaces="true" %>
<%@page contentType="text/html; charset=UTF-8" language="java"%>
<%@page import="service.dao.db.Page"%>
<%@page import="v1.haocheok.commom.common"%>
<%@page import="v1.haocheok.commom.entity.UserEntity"%>
<%@page import="org.apache.commons.lang3.StringUtils"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="net.sf.json.JSONArray"%>
<%@include file="../../cookie.jsp"%>

<!DOCTYPE html> 
<html>
  <head>
    <meta charset="utf-8"> 
    <meta name="viewport" content="width=device-width, initial-scale=1"> 
    <title>证书经历</title>
     <link rel="stylesheet" href="../../../pages/css/sy_style.css">	    
    <link rel="stylesheet" href="../../js/layui2/css/layui.css">
	<script type="text/javascript" src="../../js/jquery-1.9.1.js" ></script><!--通用jquery-->
	<script src="../../js/layui2/layui.js"></script>
	<script type="text/javascript" src="../../js/tableExport/js/table-sort.js" ></script><!--表格排序js  css-->
	<script type="text/javascript" chartset="utf8" src="../../js/tableExport/js/table_list.js " ></script><!--表格导出js  css-->
 	<script src="../../js/ajaxs.js"></script>
    <link href="../css/jw.css" rel="stylesheet">
  </head>
  <body>
  	
     <div style="margin-top:60px"><a onclick="location='education_change.jsp'" style="margin-left:60px">1.学历变动</a></div>
     <div style="margin-top:60px"><a onclick="location='person_change.jsp'" style="margin-left:60px">2.个人经历</a></div>
     <div style="margin-top:60px"><a onclick="location='position_change.jsp'" style="margin-left:60px">3.职位变动</a></div>
     <div style="margin-top:60px"><a onclick="location='certificate_change.jsp'" style="margin-left:60px">4.证书管理</a></div>
  
  </body>
  
  <script>
//注意：选项卡 依赖 element 模块，否则无法进行功能性操作
//layui.use('element', function(){
  layui.use(['form', 'layedit', 'laydate','laypage','element'], function(){
	  var laypage = layui.laypage,
	  form = layui.form
	  ,layer = layui.layer
	  ,element = layui.element;
});
</script>
</html>
<%
//插入常用菜单日志
int   TagMenu=db.Row("SELECT COUNT(*) as row FROM  menu_worker  WHERE sysmenuid='"+PMenuId+"' and  workerid='"+Suid+"' and  companyid="+Scompanyid);
if(TagMenu==0){
  db.executeUpdate("INSERT INTO `menu_worker`(`sysmenuid`,`workerid`,`countes`,`companyid`) VALUES ('"+PMenuId+"','"+Suid+"','1','"+Scompanyid+"');"); 
}else{
 db.executeUpdate("UPDATE  `menu_worker` SET `countes`=countes+1,`usetime`=now() WHERE  sysmenuid='"+PMenuId+"' and  workerid='"+Suid+"' and  companyid="+Scompanyid);
}
 %>
<% 
if(db!=null)db.close();db=null;if(server!=null)server=null;%>