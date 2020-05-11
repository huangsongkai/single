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
    <div class="tongyi"><img src="../img/student_h.jpg"/></div>
    <div style="margin-top:10px"><a onclick="location='student_handing1.jsp'" style="margin-left:60px">01.学籍处理条件</a></div>
    <div style="margin-top:10px"><a onclick="location='student_handing2.jsp'" style="margin-left:60px">02.学籍处理管理</a></div>
    <div style="margin-top:10px"><a onclick="location='student_handing3.jsp'" style="margin-left:60px">03.学籍处理统计</a></div>
    <div style="margin-top:10px"><a onclick="location='student_handing4.jsp'" style="margin-left:60px">04.处理结果字典维护</a></div>
    <div style="margin-top:10px"><a onclick="location='student_handing5.jsp'" style="margin-left:60px">05.重编执行计划</a></div>
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