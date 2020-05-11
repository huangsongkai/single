<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page trimDirectiveWhitespaces="true" %>
<%@page contentType="text/html; charset=UTF-8" language="java"%>
<%@page import="service.dao.db.Page"%>
<%@page import="v1.haocheok.commom.common"%>
<%@page import="v1.haocheok.commom.entity.UserEntity"%>
<%@include file="../../cookie.jsp"%>

<%
	String teacherids = request.getParameter("teacherids");
	System.out.println("------------"+teacherids);
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title></title>
<meta name="renderer" content="webkit">
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
<meta name="apple-mobile-web-app-status-bar-style" content="black"> 
<meta name="apple-mobile-web-app-capable" content="yes">
<meta name="format-detection" content="telephone=no">
<link rel="stylesheet" href="../../js/layui2/css/layui.css">
<script type="text/javascript" src="../../js/jquery-1.9.1.js" ></script><!--通用jquery-->
<script src="../../js/layui2/layui.js"></script>
</head>
<body>
<div id="box">
	<div class="layui-field-box">
	    <form class="layui-form" action="?ac=add" method="post">
	    <%
	    	int i =0;
	    	while(i<8){
	    		if(teacherids!=null&&teacherids!=""&&teacherids.length()>0){
	    			String[] teacherid = teacherids.split(",");
	    			if(teacherid.length>i){
	    			%>
	    			<div class="layui-form-item">
				  		<div class="layui-inline">
						    <label class="layui-form-label">任课教师</label>
						    <div class="layui-input-inline">				    	
						      	<select lay-verType="tips" >
						      		<option value="0"></option>
						      		<%
						      			String teacher_sql1 = "select id,teacher_name from teacher_basic";
						      			ResultSet set1 = db.executeQuery(teacher_sql1);
						      			String teacheridss = teacherid[i];
						      			while(set1.next()){
						      		%>
						      			<option value="<%=set1.getString("id")%>" <%if(teacheridss.equals(set1.getString("id"))) out.print("selected"); %> ><%=set1.getString("teacher_name") %></option>
						      		<%}if(set1!=null){set1.close();} %>
						        </select>
						    </div>
					    </div>
					</div>
	    			<%
	    			i++;
	    			continue;
	    			}else{
	    			%>
	    			<div class="layui-form-item">
		  		<div class="layui-inline">
				    <label class="layui-form-label">任课教师</label>
				    <div class="layui-input-inline">				    	
				      	<select lay-verType="tips" >
				      		<option value="0"></option>
				      		<%
				      			String teacher_sql1 = "select id,teacher_name from teacher_basic";
				      			ResultSet set1 = db.executeQuery(teacher_sql1);
				      			while(set1.next()){
				      		%>
				      			<option value="<%=set1.getString("id")%>" ><%=set1.getString("teacher_name") %></option>
				      		<%}if(set1!=null){set1.close();} %>
				        </select>
				    </div>
			    </div>
			</div>
	    			<%
	    			i++;
	    			continue;
	    		}}else{
	    				%>
	    				<div class="layui-form-item">
		  		<div class="layui-inline">
				    <label class="layui-form-label">任课教师</label>
				    <div class="layui-input-inline">				    	
				      	<select lay-verType="tips" >
				      		<option value="0"></option>
						      		<%
						      			String teacher_sql1 = "select id,teacher_name from teacher_basic";
						      			ResultSet set1 = db.executeQuery(teacher_sql1);
						      			while(set1.next()){
						      		%>
						      			<option value="<%=set1.getString("id")%>" ><%=set1.getString("teacher_name") %></option>
						      		<%}if(set1!=null){set1.close();} %>
						        </select>
						    </div>
					    </div>
					</div>
	    				<%
	    				i++;
		    			continue;
	    			}
	    		%>
	    		<%
	    	}
	    %>
		</form>
    </div>
</div>

<script>
layui.use(['form','layer','jquery'], function(){
	var form = layui.form;
	var $ = layui.jquery;

	//监听提交
	form.on('submit(*)', function(data){
		return true;
	});
  
});

</script>
</body>
</html>

<%
long TimeEnd = Calendar.getInstance().getTimeInMillis();
System.out.println(Mokuai+"耗时:"+(TimeEnd - TimeStart) + "ms");
//插入常用菜单日志
int   TagMenu=db.Row("SELECT COUNT(*) as row FROM  menu_worker  WHERE sysmenuid='"+PMenuId+"' and  workerid='"+Suid+"'");
if(TagMenu==0){
     db.executeUpdate("INSERT INTO `menu_worker`(`sysmenuid`,`workerid`,`countes`) VALUES ('"+PMenuId+"','"+Suid+"','1');"); 
   }else{
  db.executeUpdate("UPDATE  `menu_worker` SET `countes`=countes+1,`usetime`=now() WHERE  sysmenuid='"+PMenuId+"' and  workerid='"+Suid+"'");
}
 %>
<%if(db!=null)db.close();db=null;if(server!=null)server=null;%>