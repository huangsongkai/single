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
		<title>新增证书经历</title> 
	    <style type="text/css">
			.inline{ position: relative; display: inline-block; margin-right: 10px; }
	    </style>
	</head>
	<body>
		<div style="margin: 15px;">
			<fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
				<legend>新增证书变化</legend>
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
			<form class="layui-form" action="new_certificate_change.jsp?ac=add" method="post" >
              <div class="layui-form-item inline" style="width: 40%">
					<label class="layui-form-label" style=" width: 30%">姓名</label>	 				
					<div class="layui-input-inline">
						<input type="text" id="name" name="name" class="layui-input"  lay-verify="required"  value="<%=tname%>">
					</div>
				</div>
                <div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">证书名称</label>
					<div class="layui-input-inline">
						<input type="text" id="cer_name" name="cer_name" class="layui-input"   lay-verify="required" >
					</div>
				</div>	
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">证书类型</label>
					<div class="layui-input-inline">
						<input type="text" id="cer_type" name="cer_type" class="layui-input"   lay-verify="required" >
					</div>
				</div>	
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">证书编号</label>
					<div class="layui-input-inline">
						<input type="text" id="cer_num" name="cer_num" class="layui-input"  lay-verify="required" >
					</div>
				</div>	
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">证书时间</label>
					<div class="layui-input-inline">
						<input type="text" id="cer_date" name="cer_date" class="layui-input"  lay-verify="required" >
					</div>
				</div>	
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">证书单位</label>
					<div class="layui-input-inline">
						<input type="text" id="cer_address" name="cer_address" class="layui-input"  lay-verify="required" >
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
					    elem: '#cer_date' //指定元素
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
	 String cer_name= request.getParameter("cer_name");
	 String cer_type=request.getParameter("cer_type");
	 String cer_num= request.getParameter("cer_num");
	 String cer_date= request.getParameter("cer_date");
	 String cer_address= request.getParameter("cer_address");
	 String examine = request.getParameter("examine");
	try{
	   String sql="INSERT INTO `person_certificate_change` (`name`,`teacherid`,`cer_name`,`cer_type`,`cer_num`,`cer_date`,`cer_address`,`examine`,`add_user`) VALUES ('"+name+"','"+teacherid+"','"+cer_name+"','"+cer_type+"','"+cer_num+"','"+cer_date+"','"+cer_address+"','"+examine+"','"+Suid+"');";
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