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
		<title>经销商配置详情页面</title> 
	    <style type="text/css">
			.inline{ position: relative; display: inline-block; margin-right: 10px; }
	    </style>
	</head>
	<body>
		
		<div style="margin: 15px;">
			<fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
				<legend>查看经销商配置</legend>
			</fieldset>

			<form class="layui-form" action="?ac=post" method="post">
				<%
			        		String id = request.getParameter("id");
			          		String distributor_sql = "select t.*,t1.regionalname from g_distributor t,s_regional_table t1  where t.regioncode = t1.regionalcode  and  t.id = "+id;
			          		ResultSet distributors = db.executeQuery(distributor_sql);
			          		int i = 1;
			          		while(distributors.next()){
			         %>
				<div class="layui-form-item inline" style="width: 40%">
					<label class="layui-form-label" style=" width: 30%">名称</label>
					<input type="hidden" name="id" value="<%=distributors.getString("id") %>">
					<div class="layui-input-inline">
						<input type="text" name="name" lay-verify="required" autocomplete="off" class="layui-input"  value="<%=distributors.getString("name") %>"   readonly="readonly"> 
					</div>
				</div>
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%"s>法人</label>
					<div class="layui-input-inline">
						<input type="text" readonly="readonly" name="legalperson" lay-verify="required" autocomplete="off" class="layui-input" value="<%=distributors.getString("legalperson") %>">
					</div>
				</div>
				
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%"s>区域</label>
					<div class="layui-input-inline">
						<input type="text" readonly="readonly" name="" lay-verify="required" autocomplete="off" class="layui-input" value="<%=distributors.getString("regionalname") %>">
					</div>
				</div>
				
					<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%"s>生效时间</label>
					<div class="layui-input-inline">
			      	<input type="text" readonly="readonly" name="implementdate" id="implementdate" required lay-verify="required|date" value="<%=distributors.getString("implementdate") %>" autocomplete="off" class="layui-input" onclick="layui.laydate({elem: this})">
			      </div>
				</div>
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%"s>备注</label>
					<div class="layui-input-inline">
						<input type="text" readonly="readonly" name="common" lay-verify="" autocomplete="off" class="layui-input" value="<%=distributors.getString("common") %>">
					</div>
				</div>
				<%i++;} %>
				<div class="layui-form-item" style="margin-bottom:45px">
					<div class="layui-input-block"  style="margin-left:540px">
						<!--<button class="layui-btn" lay-submit="" ; onclick="return false;">确认</button>
						--><!--<button type="reset" class="layui-btn layui-btn-primary">重置</button>-->
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
			

</script>
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