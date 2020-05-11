<%@ page trimDirectiveWhitespaces="true" %>
<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@page import="service.dao.db.Page"%>
<%@page import="v1.haocheok.commom.common"%>
<%@page import="service.dao.db.Jdbc"%>
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
		<link rel="stylesheet" href="../../js/layui/css/layui.css" media="all" />
		<!-- zTree -->
		<script type="text/javascript" src="../../js/zTree/js/jquery-1.4.4.min.js"></script>
		<link rel="stylesheet" href="../../js/zTree/css/demo.css" type="text/css">
		<link rel="stylesheet" href="../../js/zTree/css/zTreeStyle/zTreeStyle.css" type="text/css">
		<script type="text/javascript" src="../../js/zTree/js/jquery.ztree.core.js"></script>
		<title>区域新建页面</title> 
	    <style type="text/css">
			.inline{ position: relative; display: inline-block; margin-right: 10px; }
	    </style>
	</head>
	<body>
		<div style="margin: 15px;">
			<fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
				<legend>新建区域</legend>
			</fieldset>

			<form class="layui-form" action="?ac=post" method="post">

				<div class="layui-form-item inline" style="width: 40%">
					<label class="layui-form-label" style=" width: 30%">区域名称</label>
					<div class="layui-input-inline">
						<input type="text" name="regionalname" lay-verify="required" autocomplete="off" class="layui-input"  value="">
					</div>
				</div>
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">区域编码</label>
					<div class="layui-input-inline">
						<input type="text" name="regionalcode" lay-verify="required" autocomplete="off" class="layui-input" value="" >
					</div>
				</div>
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">上级机构</label>
					<div class="layui-input-inline">
						<input type="text"  id="citySel"  lay-verify="" autocomplete="off" class="layui-input" value=""  onclick="showMenu(); return false;" readonly="readonly">
						<input type="hidden"  id="parentid" name="parentid"  >
					</div>
					<div id="menuContent" class="menuContent" style="display:none; position: absolute;z-index:999;margin-top: 39px;margin-left: 135px;">
						<ul id="treeDemo" class="ztree" style="margin-top:0; width:220px;"></ul>
					</div>
				</div>
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">状态</label>
					<div class="layui-input-inline">
					<select name="status" id="status" lay-filter=""  slay-verify="requried">
				        <%
				        	Map<String ,String> map = common.getDicMap("regionStatus");
				        	for(Map.Entry<String,String> entry:map.entrySet()){
				        		out.println("<option value='"+entry.getKey()+"'>"+entry.getValue()+"</option>");
				        	}
				         %>
				     </select>
					</div>
				</div>
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">优先级</label>
					<div class="layui-input-inline">
						<input type="text" name="priority" lay-verify="required" autocomplete="off" class="layui-input" value=""  >
					</div>
				</div>
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">深度</label>
					<div class="layui-input-inline">
						<input type="text" name="depth"  id="depth" lay-verify="" readonly="readonly" autocomplete="off" class="layui-input" value=""  >
					</div>
				</div>
				
				<div class="layui-form-item" style="margin-bottom:45px">
					<div class="layui-input-block"  style="margin-left:540px">
						<button class="layui-btn" lay-submit="" ; lay-filter="beforeSubmit" >确认</button>
						<button type="reset" class="layui-btn layui-btn-primary">重置</button>
					</div>
				</div>
				
			</form>
		</div>
	
		<script>
			$(function(){
				
			})
		</script>
		<script>
			layui.use(['form', 'layedit', 'laydate'], function() {
				var form = layui.form(),
					layer = layui.layer,
					layedit = layui.layedit,
					laydate = layui.laydate;
					
				form.on('submit(beforeSubmit)', function(data){
					  var regionalcode = data.field.regionalcode;
					  var uid = '<%=Suid%>';
					  var token = '<%=Spc_token%>';
					  	$.ajax({  
					  	    headers : {
					            "X-USERID":""+uid+"",
					            "Content-Type":"multipart/form-data",
					            "X-AppId":"d42b46df6e583ca9a1b3e819dc42cfak",// 标明正在运行的是哪个App程序
					            "X-AppKey":"23548ad081d91ca0bdc66b22ca59cfc6",// 授权鉴定终端
					            "Token":""+token+"",// 授权鉴定终端
					            "X-UUID":"pc",
					            "X-Mdels":"pc",
						    },
					         type : "post",  
					          url : getBasePath()+"/Api/v1/?p=web/get/checkRegionNum",  
					          data : { regionalcode: regionalcode},  
					          success : function(data){  
					          var datas = eval('(' + data + ')');
				                	if(datas.resultCode=='2000'){
				                		layer.alert(datas.msg);
				                		return false;
				                	}
					          }  
			     }); 
					 // return false; //阻止表单跳转。如果需要表单跳转，去掉这段即可。
					});
			});
			
			<%	
	
	if(ac.equals("post")){
		String regionalname = "";
		String parentid = "";
		String status = "";
		String depth = "";
		String priority = "";
		String regionalcode = "";
		regionalname =  request.getParameter("regionalname");
		depth = request.getParameter("depth");
		parentid = request.getParameter("parentid");
		if(parentid.equals("")){
			parentid = "0";
			depth = "0";
		}
		status = request.getParameter("status");
		priority = request.getParameter("priority");
		regionalcode = request.getParameter("regionalcode");
		String sql = "INSERT INTO s_regional_table (regionalname,parentid,status,depth,priority,regionalcode) VALUES ('"+regionalname+"','"+parentid+"','"+status+"','"+depth+"','"+priority+"','"+regionalcode+"')";
System.out.println("sql========="+sql);
		boolean updateStatus = db.executeUpdate(sql);
		if(updateStatus){
		 	out.print("var index = parent.layer.getFrameIndex(window.name); parent.layer.close(index); parent.location.reload();;");
		 }else{
		 	out.print("layer.msg('提交错误')");
		 }
		
	}
	%>
	</script>
	<SCRIPT type="text/javascript">
			//获取项目路径
			function getBasePath(){
				 var curWwwPath = window.document.location.href;
			    var pathName = window.document.location.pathname;
			    var pos = curWwwPath.indexOf(pathName);
			    var localhostPath = curWwwPath.substring(0, pos);
			    var projectName = pathName.substring(0, pathName.substr(1).indexOf('/') + 1);
			    var basePath=localhostPath+projectName+"/";
			    return basePath;
			}
	//设置zTree数据		
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
				//beforeClick: beforeClick,
				onClick: onClick
			}
		};
		var zNodes =[
			<%
			String regional="SELECT id,parentId,regionalname,regionalcode,depth  FROM s_regional_table  ";
			ResultSet regional_rs=db.executeQuery(regional);
			while(regional_rs.next()){
			out.println("{ id:"+regional_rs.getInt("id")+", pId:"+regional_rs.getInt("parentId")+",depth:"+regional_rs.getInt("depth")+", name:'"+regional_rs.getString("regionalname")+"', open:true,regionalcode:'"+regional_rs.getString("regionalcode")+"'},");
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
			id = "";
			depth = "";
			nodes.sort(function compare(a,b){return a.id-b.id;});
			for (var i=0, l=nodes.length; i<l; i++) {
			
				v += nodes[i].name + ",";
				id += nodes[i].id + ",";
				depth += nodes[i].depth + ",";
			}
			if (v.length > 0 ) v = v.substring(0, v.length-1);
			if (id.length > 0 ) id = id.substring(0, id.length-1);
			if (depth.length > 0 ) depth = depth.substring(0, depth.length-1);
			
			 $("#citySel").attr("value", v);
			$('#parentid').attr('value',id);
			$('#depth').attr('value',eval(depth)+1);
			
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

