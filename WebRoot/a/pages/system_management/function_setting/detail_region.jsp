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
		<title>区域详情页面</title> 
	    <style type="text/css">
			.inline{ position: relative; display: inline-block; margin-right: 10px; }
	    </style>
	</head>
	<body>
		
		<div style="margin: 15px;">
			<fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
				<legend>查看区域</legend>
			</fieldset>

			<form class="layui-form" action="?ac=post" method="post">
				<%
			        		String id = request.getParameter("id");
			          		String region_sql = "SELECT if(t.status='1','启用','禁用') statusShow,t.*, t2.regionalname parentidShow FROM s_regional_table t LEFT JOIN s_regional_table t2 ON t.parentid = t2.id where  t.id = "+id;
			          		ResultSet regions = db.executeQuery(region_sql);
			          		int i = 1;
			          		while(regions.next()){
			         %>
				<div class="layui-form-item inline" style="width: 40%">
					<label class="layui-form-label" style=" width: 30%">区域名称</label>
					<div class="layui-input-inline">
						<input type="text" name="regionalname" lay-verify="required" autocomplete="off" class="layui-input"  value="<%=regions.getString("regionalname") %>" readonly="readonly">
					</div>
				</div>
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">区域编码</label>
					<div class="layui-input-inline">
						<input type="text" name="regionalcode" lay-verify="required" autocomplete="off" class="layui-input" value="<%=regions.getString("regionalcode") %>" readonly="readonly">
					</div>
				</div>
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">上级机构</label>
					<div class="layui-input-inline">
						<input type="text"  id="citySel"  lay-verify="required" autocomplete="off" class="layui-input" value="<%=regions.getString("parentidShow") %>" readonly="readonly">
					</div>
				</div>
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">状态</label>
					<div class="layui-input-inline">
							<input type="text"  id="citySel"  lay-verify="required" autocomplete="off" class="layui-input" value="<%=regions.getString("statusShow") %>" readonly="readonly">
					</div>
				</div>
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">优先级</label>
					<div class="layui-input-inline">
						<input type="text" name="priority" lay-verify="required" autocomplete="off" class="layui-input"  value="<%=regions.getString("priority") %>"  readonly="readonly">
					</div>
				</div>
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">深度</label>
					<div class="layui-input-inline">
						<input type="text" name="depth"  id="depth" lay-verify="required" readonly="readonly" autocomplete="off" class="layui-input"  value="<%=regions.getString("depth") %>" >
					</div>
				</div>
				<%i++;} %>
				<div class="layui-form-item" style="margin-bottom:45px">
					<div class="layui-input-block"  style="margin-left:540px">
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