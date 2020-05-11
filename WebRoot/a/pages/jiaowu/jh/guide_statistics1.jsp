<%@ page trimDirectiveWhitespaces="true" %>
<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@ include file="../../cookie.jsp"%>
<%-- 指导计划总计---课程门数统计 --%>
<!DOCTYPE html> 
<html>
  <head>
    <meta charset="utf-8"> 
    <meta name="viewport" content="width=device-width, initial-scale=1"> 
    <title>指导计划总计--->课程门数统计</title>
    <link href="../css/jw.css" rel="stylesheet">
  </head>
  <body>
  	<div class="" style="padding-bottom: 0px;margin-left: 1%;margin-right: 1%; height:auto;">
		<%-- 页面搜索实现区 --%>
		<form class="layui-form"  action="">
			<!-- 院系名称  -->
			   <div>
				   <select name="dict_departments_id" id="dict_departments_id" lay-verify="required"  lay-filter="dict_departments" >
		               <option value="">选择开课学期</option>
			            <%--		      
			            
			            	 	String sql="";
			            
					        ResultSet Rs= db.executeQuery(sql);
					       
					        while(Rs.next()){ 
						       //学期
						        int start_semester=Integer.parseInt(Rs.getString("start_semester"));
						       //年份
						        int year=Integer.parseInt(Rs.getString("school_year"));
						     
						       //求学期学号
						        int yearq=((start_semester-1)/2);
						       
						        int yeary=start_semester%2;
						        String years="";
						        if(yeary==0){
						        	years=(year+yearq)+"-"+(year+yearq+1)+"-"+2;
						        }else{
						        	years=(year+yearq)+"-"+(year+yearq+1)+"-"+1;
						        }
					        }if(Rs!=null){Rs.close();} 
				        --%>
		            </select>
	            </div>
	             <button class="layui-btn" lay-submit lay-filter="statistics">查询</button>
		</form>
	</div>
    <div class="top"><span>图文演示</span></div>
    <div class="tongyi"><img src="../img/guide_statistics1.jpg"/></div>
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