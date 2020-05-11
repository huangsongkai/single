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
     <div class="tongyi"><img src="../img/school_sum.jpg"/></div>
     <div style="margin-top:60px"><a onclick="location='school_sum1.jsp'" style="margin-left:60px">1.教室占用时间情况</a></div>
     <div style="margin-top:60px"><a onclick="location='school_sum2.jsp'" style="margin-left:60px">2.开课通知单学时汇总</a></div>
     <div style="margin-top:60px"><a onclick="location='classroom_class.jsp'" style="margin-left:60px">3.教室上课班级情况</a></div>
     <div style="margin-top:60px"><a onclick="location='class_classroom.jsp'" style="margin-left:60px">4.班级使用教室情况</a></div>
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