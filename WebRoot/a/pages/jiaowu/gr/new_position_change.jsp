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
		<title>新增职位经历</title> 
	    <style type="text/css">
			.inline{ position: relative; display: inline-block; margin-right: 10px; }
	    </style>
	</head>
	<body>
		<div style="margin: 15px;">
			<fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
				<legend>新增职位变化</legend>
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
			<form class="layui-form" action="new_position_change.jsp?ac=add" method="post" >
              <div class="layui-form-item inline" style="width: 40%">
					<label class="layui-form-label" style=" width: 30%">姓名</label>	 				
					<div class="layui-input-inline">
						<input type="text" id="name" name="name" class="layui-input"  lay-verify="required" value="<%=tname%>">
					</div>
				</div>
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">单位名称</label>
					<div class="layui-input-inline">
						<input type="text" id="work_address" name="work_address" class="layui-input" >
					</div>
				</div>	
                <div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">任职日期</label>
					<div class="layui-input-inline">
						<input type="text" id="start_date" name="start_date" class="layui-input time"   lay-verify="required" readonly>
					</div>
				</div>	
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">离职日期</label>
					<div class="layui-input-inline">
						<input type="text" id="end_date" name="end_date" class="layui-input time"   lay-verify="required" readonly>
					</div>
				</div>	
				 <div class="layui-form-item inline" style="width: 40%">
					<label class="layui-form-label" style=" width: 30%">职称</label>					
					<div class="layui-input-inline">
						<input type="text" id="postion_name" name="postion_name" class="layui-input"  lay-verify="required" >
					</div>
				</div>		
				
				<div class="layui-form-item inline" style="width: 40%">
					<label class="layui-form-label" style=" width: 30%">级别</label>					
					<div class="layui-input-inline">
						<input type="text" id="level" name="level" class="layui-input"  lay-verify="required" >
					</div>
				</div>			
				<div class="layui-form-item inline" style="width: 40%">
					<label class="layui-form-label" style=" width: 30%">工资</label>					
					<div class="layui-input-inline">
						<input type="text" id="wages" name="wages" class="layui-input"  lay-verify="required" >
					</div>
				</div>			
				<div class="layui-form-item inline" style="width: 40%">
					<label class="layui-form-label" style=" width: 30%">发布文号</label>					
					<div class="layui-input-inline">
						<input type="text" id="wen_num" name="wen_num" class="layui-input"  lay-verify="required" >
					</div>
				</div>			
						<input type="hidden" value="1" id="examine" name="examine" >
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
					    elem: '#start_date' //指定元素
					  });
				 laydate.render({
					    elem: '#end_date' //指定元素
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
	 String work_address= request.getParameter("work_address");
	 String start_date = request.getParameter("start_date");
	 String end_date = request.getParameter("end_date");
	 String postion_name=request.getParameter("postion_name");
	 String level= request.getParameter("level");
	 String wen_num = request.getParameter("wen_num");
	 String examine = request.getParameter("examine");
	 String wages = request.getParameter("wages");
	try{
	   String sql="INSERT INTO `person_position_change` (`name`,`teacherid`,`work_address`,`postion_name`,`level`,`wen_num`,`wages`,`add_user`,`examine`,`start_date`,`end_date`) VALUES ('"+name+"','"+teacherid+"','"+work_address+"','"+postion_name+"','"+level+"','"+wen_num+"','"+wages+"','"+Suid+"','"+examine+"','"+start_date+"','"+end_date+"');";
	   if(db.executeUpdate(sql)==true){
		   out.println("<script>parent.layer.msg('添加个人经历 成功'); parent.layer.close(index); parent.location.reload();</script>");
	   }else{
		   out.println("<script>parent.layer.msg('添加个人经历失败!请重新输入');</script>");
	   }
	 }catch (Exception e){
	    out.println("<script>parent.layer.msg('添加院系失败');</script>");
	    return;
	}
	//关闭数据与serlvet.out
	
	if (page != null) {page = null;}
	
}%>
 
<%
if(db!=null)db.close();db=null;if(server!=null)server=null;
%>