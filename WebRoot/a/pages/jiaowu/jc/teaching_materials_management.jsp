<%@ page trimDirectiveWhitespaces="true" %>
<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@ include file="../../cookie.jsp"%>
<!DOCTYPE html> 
<html>
  <head>
    <meta charset="utf-8"> 
    <meta name="viewport" content="width=device-width, initial-scale=1"> 
    <title><%=Mokuai %></title>
    <link href="../css/jw.css" rel="stylesheet">
  </head>
  <body>
     <div class="top"><span>图文演示</span></div>
     <div class="tongyi"><img src="../img/teaching_materials_management.jpg"/></div>
     <div style="margin-top:40px"><a onclick="location='teaching_materials_management1.jsp'" style="margin-left:60px">1.教材禁发情况</a></div>
     <div style="margin-top:40px"><a onclick="location='teaching_materials_management2.jsp'" style="margin-left:60px">2.集体售书情况</a></div>
     <div style="margin-top:40px"><a onclick="location='teaching_materials_management3.jsp'" style="margin-left:60px">3.集体售书记账</a></div>
     <div style="margin-top:40px"><a onclick="location='teaching_materials_management4.jsp'" style="margin-left:60px">4.教师领书管理</a></div>
     <div style="margin-top:40px"><a onclick="location='teaching_materials_management5.jsp'" style="margin-left:60px">5.教材零售管理</a></div>
     <div style="margin-top:40px"><a onclick="location='teaching_materials_management6.jsp'" style="margin-left:60px">6.教材使用情况</a></div>
  </body>
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