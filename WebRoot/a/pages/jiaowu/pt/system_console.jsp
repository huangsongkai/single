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
    <div class="tongyi" "><img src="../img/system_console1.jpg"/></div>
    <div class="tongyi" style="margin-top:18px;margin-left:82px"><img src="../img/system_console2.jpg"/></div>
    <div class="tongyi" style="margin-top:18px;margin-left:82px"><img src="../img/system_console3.jpg"/></div>
    <div class="tongyi" style="margin-top:18px;margin-left:82px"><img src="../img/system_console4.jpg"/></div>
    <div class="tongyi" style="margin-top:18px;margin-left:82px"><img src="../img/system_console5.jpg"/></div>
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