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
    <style type="text/css">
      div{
        overflow:hidden;
      }
      a{
        float:left;
        width:300px;
      }
    </style>
  </head>
  <body>
    <div class="top"><span>图文演示</span></div>
    <div class="tongyi"><img src="../img/query_statistics.jpg"/></div>
    <div style="margin-top:10px"><a  onclick="location='query_statistics1.jsp'" style="margin-left:60px">01:学籍卡片</a><a onclick="location='query_statistics9.jsp'" style="margin-left:300px">09:学生人数统计[1]</a></div>
    <div style="margin-top:10px"><a class="as" onclick="location='query_statistics2.jsp'" style="margin-left:60px">02:学生名册</a><a onclick="location='query_statistics10.jsp'" style="margin-left:300px">10:学生人数统计[2]</a></div>
    <div style="margin-top:10px"><a class="as" onclick="location='query_statistics3.jsp'" style="margin-left:60px">03:学生准考证</a><a onclick="location='query_statistics11.jsp'" style="margin-left:300px">11:学生人数统计[3]</a></div>
    <div style="margin-top:10px"><a class="as" onclick="location='query_statistics4.jsp'" style="margin-left:60px">04:学生奖励统计</a><a onclick="location='query_statistics12.jsp'" style="margin-left:300px">12:学生人数统计[4]</a></div>
    <div style="margin-top:10px"><a class="as" onclick="location='query_statistics5.jsp'" style="margin-left:60px">05:学生处分统计</a><a onclick="location='query_statistics13.jsp'" style="margin-left:300px">13:学生人数统计[5]</a></div>
    <div style="margin-top:10px"><a class="as" onclick="location='query_statistics6.jsp'" style="margin-left:60px">06:学生异动统计</a><a onclick="location='query_statistics14.jsp'" style="margin-left:300px">14:学生人数统计[6]</a></div>
    <div style="margin-top:10px"><a class="as" onclick="location='query_statistics7.jsp'" style="margin-left:60px">07:学生异动分析</a><a onclick="location='query_statistics15.jsp'" style="margin-left:300px">15:学生人数统计[7]</a></div>
    <div style="margin-top:10px"><a class="as" onclick="location='query_statistics8.jsp'" style="margin-left:60px">08:学生奖学金统计</a><a onclick="location='query_statistics16.jsp'" style="margin-left:300px">16:学期平均成绩</a></div>
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