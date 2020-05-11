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
     	<link rel="stylesheet" href="../../../pages/css/sy_style.css?22">
		<script src="../../../pages/js/layui2/layui.js"></script>
		<link rel="stylesheet" href="../../js/layui2/css/layui.css" media="all" />
		<!-- zTree -->
		<script type="text/javascript" src="../../js/zTree/js/jquery-1.4.4.min.js"></script>
		<link rel="stylesheet" href="../../js/zTree/css/demo.css" type="text/css">
		<link rel="stylesheet" href="../../js/zTree/css/zTreeStyle/zTreeStyle.css" type="text/css">
		<script type="text/javascript" src="../../js/zTree/js/jquery.ztree.core.js"></script>
		<title>新建页面</title> 
	    <style type="text/css">
			.inline{ position: relative; display: inline-block; margin-right: 10px; }
	    </style>
	</head>
	<body  style='height:auto'>
		<div style="margin: 15px;">
			<fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
				<legend>新建培养层次</legend>
			</fieldset>

			<form class="layui-form" action="?ac=post" method="post">

				<div class="layui-form-item inline">
					<label class="layui-form-label" >培养层次名称</label>
					<input type="hidden" name="id" value="">
					<div class="layui-input-inline">
						<input type="text" name="name" lay-verify="required" autocomplete="off" class="layui-input"  value="">
					</div>
				</div>
				<div class="layui-form-item inline" >
					<label class="layui-form-label" >培养层次编码</label>
					<div class="layui-input-inline">
						<input type="text" name="code" lay-verify="required" autocomplete="off" class="layui-input" value=""  >
					</div>
				</div>
				
				<div class="layui-form-item" style="margin-bottom:45px">
					<div class="layui-input-block"  style="margin-left:540px">
						<button class="layui-btn" lay-submit="" ;>确认</button>
					</div>
				</div>
			</form>
		</div>
	
		<script>
			layui.use(['form', 'layedit', 'laydate'], function() {
				var form = layui.form,
					layer = layui.layer,
					layedit = layui.layedit,
					laydate = layui.laydate;
				form.verify({  
				 	zhengshu:function(value){
				 		if(value.indexOf('%')>=0){
							value = value.replace('%','');
					 		}
				 		var reg = /^\d+(?=\.{0,1}\d+$|$)/;
						 if(!reg.test(value)){
						  return '必须是正数' ;
						  }
				 		}
					  });  
			<%	
	if(ac.equals("post")){
		String code = "";
		String name = "";
		name =  request.getParameter("name");
		code = request.getParameter("code");
		String checkSql ="select count(id) as row from jz_culture_level t  where t.code='"+code+"'";
		int rows = db.Row(checkSql);
		if(rows>0){
			out.print("layer.msg('编码已存在,请勿重新添加')");
		}else{
		String sql = "INSERT INTO jz_culture_level (name,code) VALUES ('"+name+"','"+code+"')";
		boolean status = db.executeUpdate(sql);
		if(status){
		 	out.print("var index = parent.layer.getFrameIndex(window.name); parent.layer.close(index); parent.location.reload();;");
		 }else{
		 	out.print("layer.msg('提交错误')");
		 }
		}
	}
	%>
			});
			
	</script>
	</body>
</html>
<%
//插入常用菜单日志
int   TagMenu=db.Row("SELECT COUNT(*) as row FROM  menu_worker  WHERE sysmenuid='"+PMenuId+"' and  workerid='"+Suid+"' and  companyid='"+Scompanyid+"'");
if(TagMenu==0){
  db.executeUpdate("INSERT INTO `menu_worker`(`sysmenuid`,`workerid`,`countes`,`companyid`) VALUES ('"+PMenuId+"','"+Suid+"','1','"+Scompanyid+"');"); 
}else{
 db.executeUpdate("UPDATE  `menu_worker` SET `countes`=countes+1,`usetime`=now() WHERE  sysmenuid='"+PMenuId+"' and  workerid='"+Suid+"' and  companyid= '"+Scompanyid+"'");
}
 %>
<%
if(db!=null)db.close();db=null;if(server!=null)server=null;
%>