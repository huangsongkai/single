
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
     <div class="tongyi"><img src="../img/assessment_summary_statistics.jpg"/></div>
     <div style="margin-top:30px"><a onclick="location='assessment_summary_statistics1.jsp'" style="margin-left:60px">1.按教师/指标汇总分析</a></div>
     <div style="margin-top:30px"><a onclick="location='assessment_summary_statistics2.jsp'" style="margin-left:60px">2.按教师/课程汇总分析</a></div>
     <div style="margin-top:30px"><a onclick="location='assessment_summary_statistics3.jsp'" style="margin-left:60px">3.按教师/课程/班级汇总分析</a></div>
     <div style="margin-top:30px"><a onclick="location='assessment_summary_statistics4.jsp'" style="margin-left:60px">4.按院系/分数段汇总分析</a></div>
     <div style="margin-top:30px"><a onclick="location='assessment_summary_statistics5.jsp'" style="margin-left:60px">5.按院系/一级指标汇总分析</a></div>
     <div style="margin-top:30px"><a onclick="location='assessment_summary_statistics6.jsp'" style="margin-left:60px">6.按院系/二级指标汇总分析</a></div> 
     <div style="margin-top:30px"><a onclick="location='assessment_summary_statistics7.jsp'" style="margin-left:60px">7.学生评价成绩专业排名表</a></div>
     <div style="margin-top:30px"><a onclick="location='assessment_summary_statistics8.jsp'" style="margin-left:60px">8.学生评教情况汇总表</a></div>
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
