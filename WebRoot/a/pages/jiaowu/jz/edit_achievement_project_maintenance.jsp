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
		<script src="../../../pages/js/layui2/layui.js"></script>
     	<link rel="stylesheet" href="../../../pages/css/sy_style.css?22">
		<link rel="stylesheet" href="../../js/layui2/css/layui.css" media="all" />
		<!-- zTree -->
		<script type="text/javascript" src="../../js/zTree/js/jquery-1.4.4.min.js"></script>
		<link rel="stylesheet" href="../../js/zTree/css/demo.css" type="text/css">
		<link rel="stylesheet" href="../../js/zTree/css/zTreeStyle/zTreeStyle.css" type="text/css">
		<script type="text/javascript" src="../../js/zTree/js/jquery.ztree.core.js"></script>
		<title>编辑页面</title> 
	    <style type="text/css">
			.inline{ position: relative; display: inline-block; margin-right: 10px; }
	    </style>
	</head>
	<body style='height:auto'>
		
		<div style="margin: 15px;">
			<fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
				<legend>编辑成绩项目</legend>
			</fieldset>

			<form class="layui-form" action="?ac=post" method="post">
				<%
			        		String id = request.getParameter("id");
			          		String bank_sql = "select t.* from jz_achievement_project t  where  t.id = "+id;
			          		ResultSet banks = db.executeQuery(bank_sql);
			          		int i = 1;
			          		while(banks.next()){
			         %>
				<div class="layui-form-item inline" >
					<label class="layui-form-label">成绩项目名称</label>
					<input type="hidden" name="id" value="<%=banks.getString("id") %>">
					<div class="layui-input-inline">
						<input type="text" name="name" lay-verify="required" autocomplete="off" class="layui-input"  value="<%=banks.getString("name") %>">
					</div>
				</div>
				<div class="layui-form-item inline">
					<label class="layui-form-label" >成绩项目编码</label>
					<div class="layui-input-inline">
						<input type="text" name="code" lay-verify="required" autocomplete="off" class="layui-input" value="<%=banks.getString("code") %>"  readonly >
					</div>
				</div>
				<div class="layui-form-item inline">
					<label class="layui-form-label" >最小百分比%</label>
					<div class="layui-input-inline">
						<input type="text" name="mixpercent" lay-verify="required" autocomplete="off" class="layui-input" value="<%=banks.getString("mixpercent") %>"  >
					</div>
				</div>
				<div class="layui-form-item inline">
					<label class="layui-form-label" >最大百分比%</label>
					<div class="layui-input-inline">
						<input type="text" name="maxpercent" lay-verify="required" autocomplete="off" class="layui-input" value="<%=banks.getString("maxpercent") %>"  >
					</div>
				</div>
				<div class="layui-form-item inline">
					<label class="layui-form-label" >状态</label>
					<div class="layui-input-inline">
						<div class="layui-input-inline">
							 <select id="status" name="status"  lay-verify="required" >
							 	<%
							 		String statuss = banks.getString("status");
							 		if(statuss.equals("1")){
							 			%>
							 				    <option value="1" selected>是</option>
						     				   <option value="2">否</option>
							 			<%
							 		}else{%>
							 				    <option value="1">是</option>
						  				      <option value="2" selected>否</option>
							 		<%}
							 	%>
						      </select>					
					     </div>
					</div>
				</div>
				<%i++;} if(banks!=null){banks.close();} %>
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
		String mixpercent = "";
		String maxpercent ="";
		String status ="";
		code = request.getParameter("code");
		name =  request.getParameter("name");
		mixpercent =  request.getParameter("mixpercent");
		maxpercent =  request.getParameter("maxpercent");
		status =  request.getParameter("status");
		int ids = Integer.parseInt(request.getParameter("id"));
		String sql = "update jz_achievement_project t set name='"+name+  "',code='"+code+  "',mixpercent='"+mixpercent+  "',maxpercent='"+maxpercent+  "',status='"+status+"'"+" where t.id = "+id;
		boolean statusz = db.executeUpdate(sql);
		if(statusz){
		 	out.print("var index = parent.layer.getFrameIndex(window.name); parent.layer.close(index); parent.location.reload();");
		 }else{
		 	out.print("layer.msg('提交错误')");
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