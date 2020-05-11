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
				<legend>编辑成绩等级</legend>
			</fieldset>

			<form class="layui-form" action="?ac=post" method="post">
				<%
			        		String id = request.getParameter("id");
			          		String bank_sql = "select t.* from jz_achievement_leve t  where  t.id = "+id;
			          		ResultSet banks = db.executeQuery(bank_sql);
			          		int i = 1;
			          		while(banks.next()){
			         %>
				<div class="layui-form-item inline" >
					<label class="layui-form-label">成绩等级名称</label>
					<input type="hidden" name="id" value="<%=banks.getString("id") %>">
					<div class="layui-input-inline">
						<input type="text" name="name" lay-verify="required" autocomplete="off" class="layui-input"  value="<%=banks.getString("name") %>">
					</div>
				</div>
				<div class="layui-form-item inline">
					<label class="layui-form-label" >成绩等级编码</label>
					<div class="layui-input-inline">
						<input type="text" name="code" lay-verify="required" autocomplete="off" class="layui-input" value="<%=banks.getString("code") %>"  readonly >
					</div>
				</div>
				<div class="layui-form-item inline">
					<label class="layui-form-label" >等级分数</label>
					<div class="layui-input-inline">
						<input type="text" name="fraction" lay-verify="required" autocomplete="off" class="layui-input" value="<%=banks.getString("fraction") %>"  >
					</div>
				</div>
				<div class="layui-form-item inline">
					<label class="layui-form-label" >开始分数</label>
					<div class="layui-input-inline">
						<input type="text" name="start_fraction" lay-verify="required" autocomplete="off" class="layui-input" value="<%=banks.getString("start_fraction") %>"  >
					</div>
				</div>
				<div class="layui-form-item inline">
					<label class="layui-form-label" >截止分数</label>
					<div class="layui-input-inline">
						<input type="text" name="end_fraction" lay-verify="required" autocomplete="off" class="layui-input" value="<%=banks.getString("end_fraction") %>"  >
					</div>
				</div>
				<div class="layui-form-item inline">
					<label class="layui-form-label" >等级方式</label>
					<div class="layui-input-inline">
						<select id="style_fraction" name="style_fraction"  lay-verify="required" >
							<%
								String stauu = banks.getString("style_fraction");
								if(stauu.equals("1")){
									out.println("  <option value='1' selected>等级方式1</option><option value='2'>等级方式2</option><option value='3'>等级方式3</option>");
								}else if(stauu.equals("2")){
									out.println("  <option value='1' >等级方式1</option><option value='2' selected>等级方式2</option><option value='3'>等级方式3</option>");
								}else if(stauu.equals("3")){
									out.println("  <option value='1' >等级方式1</option><option value='2' >等级方式2</option><option value='3' selected>等级方式3</option>");
								}else{
									out.println("  <option value='1' selected>等级方式1</option><option value='2'>等级方式2</option><option value='3'>等级方式3</option>");
								}
							%>
					      </select>
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
		String name = "";
		String code = "";
		String style_fraction = "";
		String end_fraction = "";
		String start_fraction = "";
		String fraction = "";
		name = request.getParameter("name");
		code =  request.getParameter("code");
		style_fraction =  request.getParameter("style_fraction");
		end_fraction =  request.getParameter("end_fraction");
		start_fraction =  request.getParameter("start_fraction");
		fraction =  request.getParameter("fraction");
		int ids = Integer.parseInt(request.getParameter("id"));
		String sql = "update jz_achievement_leve t set name='"+name+  "',code='"+code+ "',style_fraction='"+style_fraction+ "',end_fraction='"+end_fraction+ "',start_fraction='"+start_fraction+ "',fraction='"+fraction+"'"+" where t.id = "+id;
		boolean status = db.executeUpdate(sql);
		if(status){
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