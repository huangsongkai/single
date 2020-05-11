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
     	<script src="../../../pages/js/layui/layui.js"></script>
     	<!-- zTree -->
		<script type="text/javascript" src="../../js/zTree/js/jquery-1.4.4.min.js"></script>
		<link rel="stylesheet" href="../../js/zTree/css/demo.css" type="text/css">
		<link rel="stylesheet" href="../../js/zTree/css/zTreeStyle/zTreeStyle.css" type="text/css">
		<script type="text/javascript" src="../../js/zTree/js/jquery.ztree.core.js"></script>
		<link rel="stylesheet" href="../../js/layui/css/layui.css" media="all" />
		<title>经销商配置编辑页面</title> 
	    <style type="text/css">
			.inline{ position: relative; display: inline-block; margin-right: 10px; }
	    </style>
	</head>
	<body>
		
		<div style="margin: 15px;">
			<fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
				<legend>编辑经销商配置</legend>
			</fieldset>

			<form class="layui-form" action="?ac=post" method="post">
				<%
			        		String id = request.getParameter("id");
			          		String distributor_sql = "select t.*,t1.regionalname from g_distributor t,s_regional_table t1 where t1.regionalcode=t.regioncode and t.id = "+id;
			          		ResultSet distributors = db.executeQuery(distributor_sql);
			          		int i = 1;
			          		while(distributors.next()){
			         %>
				<div class="layui-form-item inline" style="width: 40%">
					<label class="layui-form-label" style=" width: 30%">名称</label>
					<input type="hidden" name="id" value="<%=distributors.getString("id") %>">
					<div class="layui-input-inline">
						<input type="text" name="name" lay-verify="required" autocomplete="off" class="layui-input"  value="<%=distributors.getString("name") %>">
					</div>
				</div>
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%"s>法人</label>
					<div class="layui-input-inline">
						<input type="text" name="legalperson" lay-verify="required" autocomplete="off" class="layui-input" value="<%=distributors.getString("legalperson") %>">
					</div>
				</div>
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">区域</label>
					<div class="layui-input-inline">
						<input type="text"  id="citySel"  lay-verify="required" autocomplete="off" class="layui-input" value="<%=distributors.getString("regionalname")%>"  onclick="showMenu(); return false;" readonly="readonly">
						<input type="hidden"  id="regionalcode" name="regionalcode"   value="<%=distributors.getString("regioncode") %>">
					</div>
					<div id="menuContent" class="menuContent" style="display:none; position: absolute;z-index:999;margin-top: 39px;margin-left: 135px;">
						<ul id="treeDemo" class="ztree" style="margin-top:0; width:220px;"></ul>
					</div>
				</div>
				
					<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%"s>生效时间</label>
					<div class="layui-input-inline">
			      	<input type="text" name="implementdate" id="implementdate"  lay-verify="required|date" value="<%=distributors.getString("implementdate") %>" autocomplete="off" class="layui-input" onclick="layui.laydate({elem: this})">
			      </div>
				</div>
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%"s>备注</label>
					<div class="layui-input-inline">
						<input type="text" name="common" lay-verify="" autocomplete="off" class="layui-input" value="<%=distributors.getString("common") %>">
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
		<script>
			layui.use(['form', 'layedit', 'laydate'], function() {
				var form = layui.form(),
					layer = layui.layer,
					layedit = layui.layedit,
					laydate = layui.laydate;
			});
			
			<%	
	
	if(ac.equals("post")){
		String  implementdate= "";            
		String legalperson = "";   
		String common = "";
		String name = "";
		String regionalcode = "";
		implementdate = request.getParameter("implementdate");
		legalperson = request.getParameter("legalperson");
		name =  request.getParameter("name");
		common = request.getParameter("common");
		regionalcode = request.getParameter("regionalcode");
		int ids = Integer.parseInt(request.getParameter("id"));
		String sql = "update g_distributor t set name='"+name+"',legalperson='"+legalperson+ "',common='"+common+"',regioncode='"+regionalcode+"',implementdate='"+implementdate+"',updateid='"+Suid+"',updatetime="+"now()"+" where t.id = "+id;
System.out.println("sql========="+sql);
		boolean status = db.executeUpdate(sql);
		if(status){
		 	out.print("var index = parent.layer.getFrameIndex(window.name); parent.layer.close(index); parent.location.reload();");
		 }else{
		 	out.print("layer.msg('提交错误')");
		 }
	}
	%>
	</script>
	<SCRIPT type="text/javascript">
	
	var setting = {
			view: {
				dblClickExpand: false
			},
			data: {
				simpleData: {
					enable: true
				}
			},
			callback: {
				beforeClick: beforeClick,
				onClick: onClick
			}
		};
		var zNodes =[
			<%
			String regional="SELECT id,parentId,regionalname,regionalcode  FROM s_regional_table  ";
			ResultSet regional_rs=db.executeQuery(regional);
			while(regional_rs.next()){
			out.println("{ id:"+regional_rs.getInt("id")+", pId:"+regional_rs.getInt("parentId")+", name:'"+regional_rs.getString("regionalname")+"', open:true,regionalcode:'"+regional_rs.getString("regionalcode")+"'},");
			}if(regional_rs!=null){regional_rs.close();}
		%>
		
		 ];
		function beforeClick(treeId, treeNode) {
			var check = (treeNode && !treeNode.isParent);
			if (!check) alert("只能选择子级...");
			return check;
		}
		
		function onClick(e, treeId, treeNode) {
			var zTree = $.fn.zTree.getZTreeObj("treeDemo"),
			nodes = zTree.getSelectedNodes(),
			v = "";
			code = "";
			nodes.sort(function compare(a,b){return a.id-b.id;});
			for (var i=0, l=nodes.length; i<l; i++) {
				v += nodes[i].name + ",";
				code += nodes[i].regionalcode + ",";
			}
			//判断tree选择数据，防止ctrl选择多个数据
			if (v.length > 0 ) v = v.substring(0, v.length-1);
			if(v.indexOf(',')>0){
				layer.alert('只能选择一个节点');
				return false;
			}
			if (code.length > 0 ) code = code.substring(0, code.length-1);
			 $("#citySel").attr("value", v);
			$('#regionalcode').attr('value',code);
			
		}
		function showMenu() {
			var cityObj = $("#citySel");
			var cityOffset = $("#citySel").offset();
			//$("#menuContent").css({left:cityOffset.left + "px", top:cityOffset.top + cityObj.outerHeight() + "px"}).slideDown("fast");
			$("#menuContent").slideDown("fast");
			$("body").bind("mousedown", onBodyDown);
		}
		function hideMenu() {
			$("#menuContent").fadeOut("fast");
			$("body").unbind("mousedown", onBodyDown);
		}
		function onBodyDown(event) {
			if (!(event.target.id == "menuBtn" || event.target.id == "menuContent" || $(event.target).parents("#menuContent").length>0)) {
				hideMenu();
			}
		}
		$(document).ready(function(){
			$.fn.zTree.init($("#treeDemo"), setting, zNodes);
		});

	</SCRIPT>
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