<%@ page trimDirectiveWhitespaces="true" %>
<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@page import="service.dao.db.Page"%>
<%@include file="../../cookie.jsp"%>	
<%@page import="org.apache.commons.lang3.StringUtils"%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="utf-8"> 
	    <meta name="viewport" content="width=device-width, initial-scale=1"> 
	    
	    <link rel="stylesheet" href="../../../pages/css/sy_style.css">	    
	    <link rel="stylesheet" href="../../js/layui2/css/layui.css">
		<script type="text/javascript" src="../../js/jquery-1.9.1.js" ></script><!--通用jquery-->
		<script src="../../js/layui2/layui.js"></script>
		<title>新增学历经历</title> 
	    <style type="text/css">
			.inline{ position: relative; display: inline-block; margin-right: 10px; }
	    </style>
	</head>
	<body>
		<div style="margin: 15px;">
			<fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
				<legend>新增学历变化</legend>
			</fieldset>
			<%
				String tname ="";
				if(Suserole.equals("1")){
					String sql =" select teacher_name from teacher_basic where id="+Sassociationid;
					ResultSet rs = db.executeQuery(sql);
					while(rs.next()){
						tname = rs.getString("teacher_name");
					}if(rs!=null)rs.close();
				}
			%>
			<form class="layui-form" action="new_education_change.jsp?ac=add" method="post" >
              <div class="layui-form-item inline" style="width: 40%">
					<label class="layui-form-label" style=" width: 30%">姓名</label>	 				
					<div class="layui-input-inline">
						<input type="text" id="name" name="name" class="layui-input"  value="<%=tname %>"  lay-verify="required">
					</div>
				</div>
                <div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">学历</label>
					<div class="layui-input-inline">
						<input type="text" id="degree" name="degree" class="layui-input"   lay-verify="required" >
					</div>
				</div>	
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">学历证号</label>
					<div class="layui-input-inline">
						<input type="text" id="degree_num" name="degree_num" class="layui-input"   lay-verify="required" >
					</div>
				</div>	
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">毕业时间</label>
					<div class="layui-input-inline">
						<input type="text" id="degree_date" name="degree_date" class="layui-input time"  lay-verify="required" >
					</div>
				</div>	
						<input type="hidden" value="1" id="examine" name="examine" class="layui-input" >
				<div class="layui-form-item" style="margin-bottom:45px">
					<div class="layui-input-block"  style="margin-left:540px">			
						<button  class="layui-btn"  lay-submit >确认</button>
					</div>
				</div>
			</form>
		</div>
	</body>
<script>

			layui.use(['form','layer','jquery','laydate'], function(){
				layer = layui.layer,
				layedit = layui.layedit,
				laydate = layui.laydate;
				 laydate.render({
					    elem: '#degree_date' //指定元素
					  });
				})
	 var index = parent.layer.getFrameIndex(window.name);
</script>
</html>
<% if("add".equals(ac)){ 
	
	 String name=request.getParameter("name");
	 String teacherid=Sassociationid;
	 if(StringUtils.isBlank(teacherid)){
		 teacherid = "0";
	 }
	 String degree= request.getParameter("degree");
	 String degree_num=request.getParameter("degree_num");
	 String degree_date= request.getParameter("degree_date");
	 String examine = request.getParameter("examine");
	try{
	   String sql="INSERT INTO `person_education_change` (`name`,`teacherid`,`degree`,`degree_num`,`degree_date`,`examine`,`add_user`) VALUES ('"+name+"','"+teacherid+"','"+degree+"','"+degree_num+"','"+degree_date+"','"+examine+"','"+Suid+"');";
	   if(db.executeUpdate(sql)==true){
		   out.println("<script>parent.layer.msg('添加经历 成功'); parent.layer.close(index); parent.location.reload();</script>");
	   }else{
		   out.println("<script>parent.layer.msg('添加经历失败!请重新输入');</script>");
	   }
	 }catch (Exception e){
	    out.println("<script>parent.layer.msg('添加经历失败');</script>");
	    return;
	}
	//关闭数据与serlvet.out
	
	if (page != null) {page = null;}
	
}%>
 
<%
if(db!=null)db.close();db=null;if(server!=null)server=null;
%>