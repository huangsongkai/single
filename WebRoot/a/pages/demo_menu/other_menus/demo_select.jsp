<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<%-- 下拉选择联动测试 --%>
<!DOCTYPE html>
<html>

	<head>
		<meta charset="utf-8">
		<title>下拉选择框测试 </title>
		<meta name="renderer" content="webkit">
		<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
		<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
		<meta name="apple-mobile-web-app-status-bar-style" content="black">
		<meta name="apple-mobile-web-app-capable" content="yes">
		<meta name="format-detection" content="telephone=no">
		<link rel="stylesheet" href="../../../pages/js/layui/css/layui.css">
		<script type="text/javascript" src="../../../custom/jquery.min.js"></script>
		<script src="../../../pages/js/layui/layui.js"></script>
	</head>
	<body>
		<div style="margin: 15px;">
			<fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
				<legend>响应式的表单集合</legend>
			</fieldset>

			<form class="layui-form" action="">
				<div class="layui-form-item">
					<label class="layui-form-label">行内选择框</label>
					<div class="layui-input-inline" >
						<select name="quiz1" lay-filter="quiz1">
							<option value="" selected="">请选择一级</option>
							<option value="1">测试数据1</option>
							<option value="2">测试数据2</option>
							<option value="3">测试数据3</option>
						</select>
					</div>
					<div class="layui-input-inline" >
						<select name="quiz2" id="quiz2" >
							<option value="" selected="">请选择二级</option>
						</select>
					</div>
				</div>
				<div class="layui-form-item">
					<div class="layui-input-block">
						<button class="layui-btn" lay-submit="" lay-filter="demo1">立即提交</button>
						<button type="reset" class="layui-btn layui-btn-primary">重置</button>
					</div>
				</div>
			</form>
		</div>
		<script>
		
			var date1="<option value='测试数据1.1'>测试数据1.1</option><option value='测试数据1.2'>测试数据1.2</option><option value='测试数据1.3'>测试数据1.3</option><option value='测试数据1.4'>测试数据1.4</option>";
			
			var date2="<option value='测试数据2.1'>测试数据2.1</option><option value='测试数据2.2'>测试数据2.2</option><option value='测试数据2.3'>测试数据2.3</option><option value='测试数据2.4'>测试数据2.4</option>";
			
			var date3="<option value='测试数据3.1'>测试数据3.1</option><option value='测试数据3.2'>测试数据3.2</option><option value='测试数据3.3'>测试数据3.3</option><option value='测试数据3.4'>测试数据3.4</option>";
			layui.use(['form', 'layedit', 'laydate'], function() {
				var form = layui.form(),
					layer = layui.layer,
					layedit = layui.layedit,
					laydate = layui.laydate;
				//监听下拉菜单
	 			form.on('select(quiz1)', function(data){
					  //console.log(data.value); //得到被选中的值
					  $("#quiz2").html();
					  if(data.value=='1'){
					  	 $("#quiz2").html(date1);
					  }else if(data.value=='2'){
					  	 $("#quiz2").html(date2);
					  }else{
					  	 $("#quiz2").html(date3);
					  }
					  form.render('select', 'quiz1'); 
				});     

				//监听提交
				form.on('submit(demo1)', function(data) {
					layer.alert(JSON.stringify(data.field), {
						title: '最终的提交信息'
					})
					return false;
				});
			});
		</script>
	</body>

</html>