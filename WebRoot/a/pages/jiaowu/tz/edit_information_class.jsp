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
		<title>信息编辑页面</title> 
	    <style type="text/css">
			.inline{ position: relative; display: inline-block; margin-right: 10px; }
	    </style>
	</head>
	<body>
		<div style="margin: 15px;">
			<fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
				<legend>编辑信息</legend>
			</fieldset>
			<form class="layui-form" action="edit_upload_json.jsp" method="post" enctype="multipart/form-data">
			    <div>
                <input type="hidden" id="AppId" value="<%=AppId_web%>">
                <input type="hidden" id="AppKey" value="<%=AppKey_web%>">
                <input type="hidden" id="Spc_token" value="<%=Spc_token%>">
                <input type="hidden" id="Suid" value="<%=Suid%>">
                <input type="hidden" id="uuid" value="<%=uuid%>">
                </div>
				<div class="layui-form-item inline" style="width: 40%">
					<label class="layui-form-label" style=" width: 30%">深度</label>
					<input type="hidden" name="id" value="<%=request.getParameter("id")%>">
					<div class="layui-input-inline">
						<select id="depth" name="depth" class="layui-input" lay-filter="depth"> 
                            
                        </select> 
					</div>
				</div>
<!--		    <input type="hidden" name="usernameid" lay-verify="nickname" autocomplete="off" class="layui-input" value="">-->
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">父级</label>
					<div class="layui-input-inline">
						<select id="fid" name="fid" class="layui-input"> 
                            <option value="0">顶级</option> 
                      <%
			             String regiona="SELECT id,fid,name FROM cms_class where depth=1";
			             ResultSet regiona_rs=db.executeQuery(regiona);
			             while(regiona_rs.next()){
			          %> <option value="<%=regiona_rs.getInt("id")%>"><%=regiona_rs.getString("name")%></option><%
			          }
		              %>
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
						<input type="text" id="name" name="author" lay-verify="required" autocomplete="off" class="layui-input" >
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
						<button class="layui-btn" lay-submit="";>确认</button>
						<button type="reset" class="layui-btn layui-btn-primary">重置</button>
					</div>
				</div>
			</form>
		</div>
		<script>
     var date1=`<option value="0">顶级</option>`;
		
		var date2=`
        <%
        String region="SELECT id,fid,name FROM cms_class where depth=1";
        ResultSet regiona_r=db.executeQuery(region);
        while(regiona_r.next()){
     %> <option value="<%=regiona_r.getInt("id")%>"><%=regiona_r.getString("name")%></option><%
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
							<div  class="layui-input-inline">
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
			  var Purl=basePath+"/Api/v1/?p=web/cms/classify/selectClassifyById";
			     var strvalueid={
			    	     "id" : "<%=request.getParameter("id")%>"
			    	    }
			 	 $.ajax( {
			 		// 提交数据的类型 POST GET
			 		type : "POST",
			 		// 提交的网址
			 		url : Purl,
			 		// 提交的数据
			 		data : JSON.stringify(strvalueid),
			 		// 返回数据的格式
			 		async : false,//不是同步的话 返回值娶不到
			 		datatype : "json",// "xml", "html", "script", "json", "jsonp",
			 		// "text".
			 		// 成功返回之后调用的函数
			 		success : function(data) {			 		
			 		      jsonData=eval("("+data+")"); 
			 		        if(jsonData.threads[0].depth==1){
			 		        	$("#depth").append(`<option value="1" selected>一级</option> <option value="2">二级</option>`);
			 		        	
				 		        }else{
				 		           $("#depth").append(`<option value="1" >一级</option> <option value="2" selected>二级</option>`);
				 		           $("#tp").html("");      
					 		    }
			 		      $("#fid").children("option").each(function(){
			 		    	     if($(this).val()==jsonData.threads[0].fid){
                                        $(this).attr("selected","selected");
				 		    	  }
				 		      });
			 		      $("#depth").append(`<input type="hidden" name="imgsurl" value="`+jsonData.threads[0].imgsurl+`">`); 
			 		      $("#sort").val( jsonData.threads[0].sort);
			 		      $("#name").val( jsonData.threads[0].name);
			 		      $("#releasepeople").val(jsonData.threads[0].releasepeople);
			 		      $("#auditperson").val(jsonData.threads[0].auditperson);
			 		      var audit=jsonData.threads[0].auditperson;
			 		      var rp=findpeople(jsonData.threads[0].releasepeople);
			 		       $("#release").val(rp);
			 		      var ap=findpeople(audit);	 		    
			 		       $("#auditPerson").val(ap);
			 		      //显示拥有该栏目的人员
			 		     function findpeople(ra){
				 		    var rult; 
					        var strvalueid={
					    	     "ids" : ra
					    	    }
					 	 $.ajax( {
					 		// 提交数据的类型 POST GET
					 		type : "POST",
					 		// 提交的网址
					 		url : basePath+"/Api/v1/?p=web/users/selectUserBydIds",
					 		// 提交的数据
					 		data : JSON.stringify(strvalueid),
					 		// 返回数据的格式
					 		async : false,//不是同步的话 返回值娶不到
					 		datatype : "json",// "xml", "html", "script", "json", "jsonp",
					 		// "text".
					 		// 成功返回之后调用的函数
					 		success : function(datas){						 							 		
					 		      jsonData=eval("("+datas+")"); 
					 		      rult=jsonData.threads;
					 		   },
					 		 headers : {
					 			"Content-type" : "application/json",
					 			"X-AppId" : AppId,
					 			"X-AppKey" : AppKey,
					 			"Token" : Spc_token,
					 			"X-USERID": Suid,
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
						 	return rult;
			 		      }
			 		   },
			 		 headers : {
			 			"Content-type" : "application/json",
			 			"X-AppId" : AppId,
			 			"X-AppKey" : AppKey,
			 			"Token" : Spc_token,
			 			"X-USERID": Suid,
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
					  content: 'edit_select_personnel.jsp?id='+<%=request.getParameter("id")%>
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
					  content: 'edit_select_personnel_state.jsp?id='+<%=request.getParameter("id")%>
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