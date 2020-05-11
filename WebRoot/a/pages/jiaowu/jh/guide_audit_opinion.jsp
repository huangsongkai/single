<%@ page trimDirectiveWhitespaces="true" %>
<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@page import="service.dao.db.Page"%>
<%@include file="../../cookie.jsp"%>
<%@page import="java.util.Date"%>
<%@page import="v1.haocheok.commom.common"%>
<%@page import="java.text.SimpleDateFormat"%>

<%
common common=new common();
   String sysid= request.getParameter("sysid");
   if(sysid==null){sysid="0";}
%>
<!DOCTYPE html>
<html>
	<head>
		 <meta charset="utf-8"> 
	    <meta name="viewport" content="width=device-width, initial-scale=1"> 
	    
	    <link rel="stylesheet" href="../../../pages/css/sy_style.css">	    
	    <link rel="stylesheet" href="../../js/layui2/css/layui.css">
		<script type="text/javascript" src="../../js/jquery-1.9.1.js" ></script><!--通用jquery-->
		<script src="../../js/layui2/layui.js"></script>
		<title>签字页面</title> 
	    <style type="text/css">
			.inline{ position: relative; display: inline-block; margin-right: 10px; }
	    </style>
	</head>
	<body>
		<div style="margin: 15px;">
			<fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
				<legend>签字页面</legend>
			</fieldset>
			<form class="layui-form" action="new_guide_audit.jsp?ac=add" method="post" >
			   <input name="sysid" type="hidden" value="<%=sysid%>" >
			   <table border="1" width="100%" bordercolorlight="#588FC7" cellspacing="0" cellpadding="0" bordercolor="#19A094" >
			   
          <%//计划分类表查询 
          String selectDsql="SELECT dict_departments_id,school_year,major_id,add_worker_id,signature_addtime,signature_worker_id,opinion,state_approve_id from teaching_plan_class_guidance WHERE id="+sysid+";";
            ResultSet Rs = db.executeQuery(selectDsql);
            while(Rs.next()){%>
			   <tr>
			      <td align="center">院系名称</td>
			      <td ><%=common.idToFieidName("dict_departments","departments_name",Rs.getString("dict_departments_id"))%></td>
			      <td align="center">入学年份</td>
			      <td colspan="3"><%=Rs.getString("school_year")%></td>
			   </tr>
			   <tr>
			      <td align="center">专业名称</td>
			      <td ><%=common.idToFieidName("major","major_name",Rs.getString("major_id"))%></td>
			      <td align="center">签字人</td>
			      <td ><%=common.getusernameTouid(Rs.getString("signature_worker_id"))%></td>
			      <td align="center">签字日期</td>
			      <td ><%=Rs.getString("signature_addtime")%></td>
			   </tr>
			   <tr>
			      <td align="center">签字状态</td>		      
			      <td colspan="5">
			        <%=common.idToFieidName("dict_state_approve","state_name",Rs.getString("state_approve_id"))%>
			      </td>
			   </tr>
			    <tr>
			      <td align="center">签字意见</td>		      
			      <td colspan="5"><%=Rs.getString("opinion")%></td>
			   </tr>
			   <%}if(Rs!=null){Rs.close();} %>
			   </table>
				
			
			</form>
		</div>
	
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
if(db!=null)db.close();db=null;if(server!=null)server=null;
%>