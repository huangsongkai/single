<%@ page trimDirectiveWhitespaces="true" %>
<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@page import="net.sf.json.JSONArray"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="service.common.SendMail"%>
<%--新建角色 --%>

<%@include file="../../cookie.jsp"%>

<html>
<head> 
	<meta charset="utf-8">
	<meta name="renderer" content="webkit">
	<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
	<meta name="apple-mobile-web-app-status-bar-style" content="black">
	<meta name="apple-mobile-web-app-capable" content="yes">
	<meta name="format-detection" content="telephone=no">
	
	<link rel="stylesheet" href="../../js/layui/css/layui.css">
   	<link rel="stylesheet" href="../../css/sy_style.css?22">
	<link rel="stylesheet" href="../../js/layui2/css/layui.css" media="all" />
	<script type="text/javascript" src="../../../custom/jquery.min.js"></script>
    <script src="../../js/layui2/layui.js"></script>
      <style type="text/css">
			.inline{ position: relative; display: inline-block; margin-right: 10px; }
	  </style>	
    <title>新建角色</title> 
</head> 
<body>
	<div class="layui-tab-item layui-show" >
				<form class="layui-form"  action="?ac=role_info"  method="post" style="height: 80%; margin-top: 4%;"  >
					        
					    <div class="layui-form-item inline">
							<label class="layui-form-label">角色名称</label>
							<div class="layui-input-inline">
								<input type="text" name="name" lay-verify="nickname" autocomplete="off" class="layui-input" value="">
							</div>
						</div>
					    <div class="layui-form-item inline">
							<label class="layui-form-label">角色类别</label>
							<div class="layui-input-inline">
								<select name="roleclass" lay-filter="roleclass"  lay-verify="required">
									<option value=""></option>
									<option value="1" >教师</option>
									<option value="2" >学生</option>
									<option value="3" >家长</option>
									<option value="4" >管理员</option>
							</select>
							</div>
						</div>
					    <div class="layui-form-item inline">
							<label class="layui-form-label">角色标识</label>
							<div class="layui-input-inline">
								<input type="text" name="rolecode" lay-verify="nickname" autocomplete="off" class="layui-input" value="">
							</div>
						</div>
						<div class="layui-form-item inline">
							<label class="layui-form-label">是否禁用</label>
							<div class="layui-input-inline">
								<select name="available"><%---1正常 0 禁止 --%>
									<option value="1">启用</option>
									<option value="0">禁止</option>
								       
								</select>
							</div>
						</div>
						<div class="layui-form-item inline">
							<label class="layui-form-label">用户信息</label>
							<div class="layui-input-inline">
								<select name="info_state"><%---1不加密 0 加密 --%>
									<option value="0">加密</option>
									<option value="1">不加密</option>
								       
								</select>
							</div>
						</div>
						<div class="layui-form-item inline">
							<label class="layui-form-label">角色权限</label>
							<div class="layui-input-inline">
								<select name="type"><%---0:pc端 1:手机端，2：手机与pc --%>
									<option value="0">pc端</option>
									<option value="1">手机端</option>
									<option value="2">手机端与pc端</option>
								</select>
							</div>
						</div>
						<div class="layui-form-item inline">
							<label class="layui-form-label">显示app首页</label>
							<div class="layui-input-inline">
								<select name="homepage"><%--- 是否显示首页 0:显示，1:不显示 --%>
									<option value="0">显示</option>
									<option value="1">不显示</option>
								</select>
							</div>
						</div>
						
						<div class="layui-form-item" style="width:97%;">
						  <div class="layui-input-block" style="  float: right; margin-top: 5%;" >
						    <button class="layui-btn" lay-submit="role_from_see" lay-filter="role_from_see">立即提交</button>
						    <button type="reset" class="layui-btn layui-btn-primary">重置</button>
						  </div>
						</div>
				</form>
	    </div>
</body> 	
	<script>
		layui.use(['layer', 'form', 'element'], function(){
		  var layer = layui.layer
		  ,form = layui.form
		  ,element = layui.element


		  /*监听下拉*/
			form.on('select(baojian_style)', function(data){
					
			});



		  
			//提交成功	
			function Success(){
				layer.confirm('创建角色成功！', {icon: 1,  closeBtn:0,btn: ['关闭'] ,title:'提示'}, function(index){
				  parent.location.reload();   
				  layer.close(index);
				});			
			}
			
			//提交失败	
			function fail(str){
				layer.confirm(str, {icon: 2,  closeBtn:0,btn: ['关闭'] ,title:'提示'}, function(index){
				  layer.close(index);
				});			
			}
			
			<%
				if("role_info".equals(ac)){
					String name=request.getParameter("name");//获取角色名称
					String rolecode=request.getParameter("rolecode");//获取角色标识
					String available=request.getParameter("available");//获取角色是否禁用
					String info_state=request.getParameter("info_state");//获取用户信息是否加密
					String type=request.getParameter("type");//角色权限
					String homepage=request.getParameter("homepage");//显示首页
					String roleclass = request.getParameter("roleclass");//角色类别
					
					
					boolean up_state=db.executeUpdate("INSERT INTO zk_role (NAME,rolecode,available,info_state,TYPE,homepage,roleclass) VALUES ('"+name+"','"+rolecode+"','"+available+"','"+info_state+"','"+type+"','"+homepage+"','"+roleclass+"');");
					
					if(up_state){
						out.println("Success()");
					}else{
						out.println("fail('角色创建失败');");
					}
				}
			%>
			 
		});
	</script>
</html>
<% if(db!=null)db.close();db=null;if(server!=null)server=null; %>