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
		<title>新建栏目页面</title> 
	    <style type="text/css">
			.inline{ position: relative; display: inline-block; margin-right: 10px; }
	    </style>
	</head>
	<body>
		<div style="margin: 15px;">
			<fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
				<legend>新建栏目</legend>
			</fieldset>
			<form class="layui-form" action="upload_json.jsp" method="post" enctype="multipart/form-data">
			    <div>
                <input type="hidden" id="AppId" value="<%=AppId_web%>">
                <input type="hidden" id="AppKey" value="<%=AppKey_web%>">
                <input type="hidden" id="Spc_token" value="<%=Spc_token%>">
                <input type="hidden" id="Suid" value="<%=Suid%>">
                <input type="hidden" id="uuid" value="<%=uuid%>">
                </div>
				<div class="layui-form-item inline" style="width: 40%">
					<label class="layui-form-label" style=" width: 30%">深度</label>
					<input type="hidden" name="id" value="">
					<div class="layui-input-inline">
						<select id="depth" name="depth" class="layui-input" lay-filter="depth"> 
                            <option class="op" value="1">一级</option> 
                            <option class="op" value="2">二级</option>
                        </select> 
					</div>
				</div>
<!--		    <input type="hidden" name="usernameid" lay-verify="nickname" autocomplete="off" class="layui-input" value="">-->
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">父级</label>
					<div class="layui-input-inline">
						<select id="fid" name="fid" class="layui-input" placeholder="请选择父级"> 
                          <option value="0">顶级</option>
                        </select> 
					</div>
				</div>
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">排序</label>
					<div class="layui-input-inline">
						<input type="text" id="sort" name="sort" lay-verify="required" autocomplete="off" class="layui-input" >
					</div>
				</div>
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">栏目名称</label>
					<div class="layui-input-inline">
						<input type="text" id="name" name="author" class="layui-input" >
					</div>
				</div>
			<div id="tp">
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">发布人</label>
					<div class="layui-input-inline">
						 <input type="text" readonly="readonly" id="release" name="releasePeople" class="layui-input" >
						 <input type="hidden" id="releasepeople" name="releasepeople" value="">
						 <a onclick="openp()">选择</a>
					</div>
				</div>								
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">审核人</label>
					<div class="layui-input-inline">
					    <input type="hidden" id="auditperson" name="auditperson" value="">
						<input type="text" readonly="readonly" id="auditPerson" name="auditPerson" class="layui-input" >
						<a onclick="openpo()">选择</a>
					</div>
				</div>				
				   <label class="layui-form-label" style=" width: 16%">上传一级栏目图片:</label>
				   <input type="file" name="dir"/>
			</div>				
				<div class="layui-form-item" style="margin-bottom:45px">
					<div class="layui-input-block"  style="margin-left:540px">			
						<button  class="layui-btn" >确认</button>
						<button type="reset" class="layui-btn layui-btn-primary">重置</button>
					</div>
				</div>
			</form>
		</div>
		<script>
		var date1=`<option value="0">顶级</option>`;
		
		var date2=`
        <%
        String regiona="SELECT id,fid,name FROM cms_class where depth=1";
        ResultSet regiona_rs=db.executeQuery(regiona);
        while(regiona_rs.next()){
     %> <option value="<%=regiona_rs.getInt("id")%>"><%=regiona_rs.getString("name")%></option><%
     }
     %>`
		//多级联动
		
		layui.use(['form', 'layedit', 'laydate'], function() {
				var form = layui.form(),
					layer = layui.layer,
					layedit = layui.layedit,
					laydate = layui.laydate;				
				form.on('select(depth)', function(data){
					 					 
					  $("#fid").html();
					  if(data.value=='1'){
					  	 $("#fid").html(date1);
					  	 $("#tp").html("");
					  	 var tpv=`<div class="layui-form-item inline" style=" width: 40%">
						  <label class="layui-form-label" style=" width: 30%">发布人</label>
							<div class="layui-input-inline">
								 <input type="text" readonly="readonly" id="release" name="releasePeople" class="layui-input" >
								 <input type="hidden" id="releasepeople" name="releasepeople" value="">
								 <a onclick="openp()">选择</a>
							</div>
						</div>								
						<div class="layui-form-item inline" style=" width: 40%">
							<label class="layui-form-label" style=" width: 30%">审核人</label>
							<div class="layui-input-inline">
							    <input type="hidden" id="auditperson" name="auditperson" value="">
								<input type="text" readonly="readonly" id="auditPerson" name="auditPerson" class="layui-input" >
								<a onclick="openpo()">选择</a>
							</div>
						</div>
						<label class="layui-form-label" style=" width: 16%">上传一级栏目图片:</label>
							<input type="file" name="dir"/>`
					  	 $("#tp").html(tpv);
					  }else{
					  	 $("#fid").html(date2);
					  	 $("#tp").html("");
					  }
					  form.render('select', 'depth'); 
                              
					});  
			});
	//选择发布人员
	 function openp(){		
		layer.open({
		 type: 2,
		  title: '人员',
		  shadeClose: true,
		  offset:'t',
		  maxmin:1,
		  shade: 0.5,
		  area: ['740px', '100%'],
		  content: 'select_personnel.jsp'
		});
    } 
	//选择审核人员
	 function openpo(){		
		layer.open({
		  type: 2,
		  title: '人员',
		  shadeClose: true,
		  offset:'t',
		  maxmin:1,
		  shade: 0.5,
		  area: ['740px', '100%'],
		  content: 'select_personnel_state.jsp'
		});
    } 
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