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
		<script src="../../../pages/js/layui/layui.js"></script>
		<script type="text/javascript" src="../../js/pub.js"></script>
		<!-- zTree -->
		
		<script type="text/javascript" src="../../../custom/jquery.min.js"></script>
		<link rel="stylesheet" href="../../js/zTree/css/demo.css" type="text/css">
		<link rel="stylesheet" href="../../js/zTree/css/zTreeStyle/zTreeStyle.css" type="text/css">
    <link href="../../css/base.css" rel="stylesheet">
    <link rel="stylesheet" href="../../../custom/easyui/easyui.css">
    <link href="../../css/process.css" rel="stylesheet">
    <link rel="stylesheet" type="text/css" href="../../../custom/easyui/icon.css">
    <link href="../../js/umeditor/themes/default/css/umeditor.css" type="text/css" rel="stylesheet">
		<script type="text/javascript" src="../../js/zTree/js/jquery.ztree.core.js"></script>
		<title>审核页面</title> 
	    <style type="text/css">
			.inline{ position: relative; display: inline-block; margin-right: 10px; }
	    </style>
	</head>
	<body>
		<div style="margin: 15px;">
			<fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
				<legend>审核信息</legend>
			</fieldset>

			<form class="layui-form" action="?ac=post" method="post">
			    <div>
                <input type="hidden" id="AppId" value="<%=AppId_web%>">
                <input type="hidden" id="AppKey" value="<%=AppKey_web%>">
                <input type="hidden" id="Spc_token" value="<%=Spc_token%>">
                <input type="hidden" id="Suid" value="<%=Suid%>">
                <input type="hidden" id="uuid" value="<%=uuid%>">
                </div>
				<div class="layui-form-item inline" style="width: 40%">
					<label class="layui-form-label" style=" width: 30%">审核状态</label>
					<input type="hidden" name="id" value="">
					<div class="layui-input-inline">
					   <select id="state">  
                          <option value ="0">待审核</option>  
                          <option value ="1">不通过</option>  
                          <option value="2">通过</option>   
                       </select>  
					</div>
				</div>
                <div class="layui-form-item inline" style="width: 40%">
					<label class="layui-form-label" style=" width: 30%">审核意见</label>
					<input type="hidden" name="id" value="">
					<div class="layui-input-inline">
						<input type="text" id="opinion" name="title" lay-verify="required" autocomplete="off" class="layui-input"  >
					</div>
				</div>
				<div class="layui-form-item" style="margin-bottom:45px">
					<div class="layui-input-block"  style="margin-left:540px">
						<button onclick="cmssadd()" class="layui-btn" lay-submit="";>确认</button>
					</div>
				</div>
			</form>
		</div>
		<script>
		 //basepath获取服务器根目录
	    var curWwwPath = window.document.location.href;
	    var pathName = window.document.location.pathname;
	    var pos = curWwwPath.indexOf(pathName);
	    var localhostPath = curWwwPath.substring(0, pos);
	    var projectName = pathName.substring(0, pathName.substr(1).indexOf('/') + 1);
	    var basePath=localhostPath+projectName+"/";
	    
			layui.use(['form', 'layedit', 'laydate'], function() {
				var form = layui.form(),
					layer = layui.layer,
					layedit = layui.layedit,
					laydate = layui.laydate;
			});
			  var AppId=$("#AppId").val();
			  var AppKey=$("#AppKey").val();
			  var Spc_token=$("#Spc_token").val();
			  var Suid=$("#Suid").val();
			  var uuid=$("#uuid").val();
			 
		   //ajax调用编辑接口
		  function cmssadd(){ 
			     var Purl=basePath+"/Api/v1/?p=web/cms/articles/editOpinion";
                 var id=$("#id").val();
   			     var state=$("#state").val();
			     var opinion=$("#opinion").val();
			    
			     var strvalue={
					     "id":<%=request.getParameter("id")%>,
					     "responsibility":"<%=Susername%>",
					     "state": state,
					     "opinion": opinion
					  };
			  PostApi(Purl,AppId,AppKey,Spc_token,JSON.stringify(strvalue),Suid,uuid);
			  
		  }
		  function PostApi(Purl,AppId,AppKey,token,strvalue,userid,uuid)// 发送数据
		   {   
			  var index = parent.layer.getFrameIndex(window.name); 
			 var backdata; 
			$.ajax( {
				// 提交数据的类型 POST GET
				type : "POST",
				// 提交的网址
				url : Purl,
				// 提交的数据
				data : strvalue,
				// 返回数据的格式
				async : false,   //不是同步的话 返回值娶不到
				datatype : "json",// "xml", "html", "script", "json", "jsonp",
				// "text".
				// 成功返回之后调用的函数
				success : function(data,status) {
				 jsonData=eval("("+data+")");  
			       if(jsonData.resultCode==404){
			    	   parent.layer.msg('审核失败');
				     }else{
				    	   parent.layer.msg('审核 成功');
						   parent.layer.close(index);
					    }
				   },
				 headers : {
					"Content-type" : "application/json",
					"X-AppId" : AppId,
					"X-AppKey" : AppKey,
					"Token" : token,
					"X-USERID": userid,
					"X-UUID": uuid,
				 }, 
				// 调用执行后调用的函数
				complete : function(XMLHttpRequest, textStatus) {
				  if (textStatus == "success") {
					  //$("#msg").html(XMLHttpReques.=XMLHttpRequest.responseText;);
					  //alert(data1);
		           }
				 },
			    // 调用出错执行的函数
				error : function() {
					 backdata="系统消息：网络故障与服务器失去联系";
				 }
		      
			});
			
			  return backdata;

		 }
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
			String regional="SELECT id,fid,name FROM cms_class ";
			ResultSet regional_rs=db.executeQuery(regional);
			while(regional_rs.next()){
			out.println("{ id:"+regional_rs.getInt("id")+", pId:"+regional_rs.getInt("fid")+", name:'"+regional_rs.getString("name")+"'},");
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
			if (v.length > 0 ) v = v.substring(0, v.length-1);
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

    <script type="text/javascript" src="../../../custom/jquery.easyui.min.js"></script>
    <script type="text/javascript" charset="utf-8" src="../../js/umeditor/umeditor.config.js"></script>
    <script type="text/javascript" charset="utf-8" src="../../js/umeditor/umeditor.min.js"></script>
    <script type="text/javascript" src="../../js/umeditor/lang/zh-cn/zh-cn.js"></script>
<script type="text/javascript">
	$('.easyui-tabs1').tabs({
      tabHeight: 36
    });

     var state = UM.getEditor('editor-state');
     state.setWidth("98%");
     $(".edui-body-container").css("width", "98%");

     $(window).resize(function(){
    	setTimeout(function(){
    		$('.easyui-tabs1').tabs("resize");
	    	state.setWidth("98%");
	     	$(".edui-body-container").css("width", "98%");	
	     },1);
    }).resize();
</script>
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