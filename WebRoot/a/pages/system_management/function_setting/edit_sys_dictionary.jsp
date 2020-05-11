<%@ page trimDirectiveWhitespaces="true" %>
<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@page import="service.dao.db.Page"%>
<%@include file="../../cookie.jsp"%>
<!DOCTYPE html>
<html>

	<head>
		<meta charset="utf-8">
		<meta name="renderer" content="webkit">
		<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
		<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
		<meta name="apple-mobile-web-app-status-bar-style" content="black">
		<meta name="apple-mobile-web-app-capable" content="yes">
		<meta name="format-detection" content="telephone=no">
		<link rel="stylesheet" href="../../../pages/js/layui/css/layui.css">
     	<link rel="stylesheet" href="../../../pages/css/sy_style.css?22">
		<link rel="stylesheet" href="../../js/layui/css/layui.css" media="all" />
		<title>数据字典编辑页面</title> 
	    <style type="text/css">
			.inline{ position: relative; display: inline-block; margin-right: 10px; }
	    </style>
	</head>

	<body>
			
	
           
		<div style="margin: 15px;">
			<fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
				<legend>数据字典信息</legend>
			</fieldset>

			<form class="layui-form" action="?ac=post" method="post">
				<%
        		String id = request.getParameter("id");
          		String typegroup_sql = "select * from typegroup where id = "+id;
          		ResultSet typegroups = db.executeQuery(typegroup_sql);
          		int i = 1;
          		while(typegroups.next()){
           %>
				<div class="layui-form-item inline" style="width: 40%">
					<label class="layui-form-label" style=" width: 30%">数据字典编码</label>
					<input type="hidden" name="id" value="<%=typegroups.getString("id") %>">
					<div class="layui-input-inline">
						<input type="text" name="typegroupcode" lay-verify="required" autocomplete="off" class="layui-input"  value="<%=typegroups.getString("typegroupcode")%>">
					</div>
				</div>
<!--				<input type="hidden" name="usernameid" lay-verify="nickname" autocomplete="off" class="layui-input" value="">-->
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%"s>数据字典名称</label>
					<div class="layui-input-inline">
						<input type="text" name="typegroupname" lay-verify="required" autocomplete="off" class="layui-input" value="<%=typegroups.getString("typegroupname") %>">
					</div>
				</div>
				<%i++;} %>
				
				<div class="layui-form-item" style="margin-bottom:45px">
					<div class="layui-input-block"  style="margin-left:540px">
						<button class="layui-btn" lay-submit="" ;>确认</button>
						<button type="reset" class="layui-btn layui-btn-primary">重置</button>
					</div>
				</div>
			</form>
		</div>
		<script type="text/javascript" src="../../../custom/jquery.min.js"></script>
		<script type="text/javascript" src="../../js/layui/layui.js"></script>
		<script src="../../../pages/js/layui/layui.js"></script>
		<script><!--
			layui.use(['form', 'layedit', 'laydate'], function() {
				var form = layui.form(),
					layer = layui.layer,
					layedit = layui.layedit,
					laydate = layui.laydate;
			});
			<%
	
	if(ac.equals("post")){
		String  typegroupcode= "";            
		String typegroupname = "";   
		typegroupcode = request.getParameter("typegroupcode");
		typegroupname = request.getParameter("typegroupname");
		int ids = Integer.parseInt(request.getParameter("id"));
		String sql = "update typegroup t set typegroupcode='"+typegroupcode+"',typegroupname='"+typegroupname+ "' where t.id = "+id;
		System.out.println("sql========="+sql);
		boolean status = db.executeUpdate(sql);
		 //out.print("<script>\r\n \r\n var index = parent.layer.getFrameIndex(window.name); parent.layer.close(index);  \r\n  </script>");
		if(status){
		 	//通过订单流程完成
		 	//AdoptController adopt = new AdoptController();
		 	//boolean tong_status = adopt.Doappoint("5","6","征信通过很好","1","9",Suid);
		 	out.print("var index = parent.layer.getFrameIndex(window.name); parent.layer.close(index); parent.location.reload();");
		 }else{
		 	out.print("layer.msg('提交错误')");
		 }
		 
		
	}
	%>
	</script>
	</body>
</html>

<%
if(db!=null)db.close();db=null;if(server!=null)server=null;
%>