<%@ page trimDirectiveWhitespaces="true" %>
<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@page import="service.dao.db.Page"%>
<%@include file="../../cookie.jsp"%>
<%String artile_content=""; %>
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
			
		<script type="text/javascript" src="../../../custom/jquery.min.js"></script>
		<link rel="stylesheet" href="../../js/zTree/css/demo.css" type="text/css">
		<link rel="stylesheet" href="../../js/zTree/css/zTreeStyle/zTreeStyle.css" type="text/css">
    <link href="../../css/base.css" rel="stylesheet">
    <link rel="stylesheet" href="../../../custom/easyui/easyui.css">
    <link href="../../css/process.css" rel="stylesheet">
    <link rel="stylesheet" type="text/css" href="../../../custom/easyui/icon.css">
    <link href="../../js/umeditor/themes/default/css/umeditor.css" type="text/css" rel="stylesheet">
		<script type="text/javascript" src="../../js/zTree/js/jquery.ztree.core.js"></script>
		<script type="text/javascript" src="../../js/layer/layer.js"></script>
		<script src="../../js/layui/layui.js"></script>
		
	  <link rel="stylesheet" href="../../kindeditor/themes/default/default.css" />
	  <link rel="stylesheet" href="../../kindeditor/plugins/code/prettify.css" />
	  <script charset="utf-8" src="../../kindeditor/kindeditor-min.js"></script>
	  <script charset="utf-8" src="../../kindeditor/lang/zh-CN.js"></script>
	  <script charset="utf-8" src="../../kindeditor/plugins/code/prettify.js"></script>
		
		<title>编辑页面</title> 
	    <style type="text/css">
			.inline{ position: relative; display: inline-block; margin-right: 10px; }
			.layui-input-block{ margin-left: 160px;}
	    </style>
	</head>
	<body>
		<div style="margin: 15px;">
			<fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
				<legend>编辑信息</legend>
			</fieldset>

			<form  action="?ac=editdata" method="post">
			    <div id="att">
                <input type="hidden" id="AppId" value="<%=AppId_web%>">
                <input type="hidden" id="AppKey" value="<%=AppKey_web%>">
                <input type="hidden" id="Spc_token" value="<%=Spc_token%>">
                <input type="hidden" id="Suid" value="<%=Suid%>">
                <input type="hidden" id="uuid" value="<%=uuid%>">
                </div>
				<div class="layui-form-item inline" style="width: 40%">
					<label class="layui-form-label" style=" width: 30%">标题</label>
					<input type="hidden" name="id" value="<%=request.getParameter("id")%>">
					<div class="layui-input-inline">
						<input type="text" id="title" name="title" lay-verify="required" autocomplete="off" class="layui-input"  >
					</div>
				</div>	
					<div class="layui-form-item inline" style="width: 40%">
					<label class="layui-form-label" style=" width: 30%">标题颜色</label>
					<input type="hidden" name="id" value="">
					<div class="layui-input-inline">
						<select id="titlecolor" name="titlecolor" class="layui-input"> 
						  <option  value="#ff0000" style="color:#ff0000">默认（纯红色）</option>
                      <%
			             String regionat="SELECT * FROM type where typegroupid=28";
			             ResultSet regionaat=db.executeQuery(regionat);
			             while(regionaat.next()){
			          %><option value="<%=regionaat.getString("typecode")%>" style="color:<%=regionaat.getString("typecode")%>"><%=regionaat.getString("typename")%></option><%
			          }
		              %>
                        </select> 
					</div>
				</div>			
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">栏目</label>
					<div class="layui-input-inline" >
						<input name="classna" type="text"  id="citySel"  lay-verify="required" autocomplete="off" class="layui-input" onclick="showMenu(); return false;" readonly="readonly">
						<input type="hidden"  id="regionalcode" name="twoid">
					</div>
					<div  id="menuContent" class="menuContent" style="display:none; position: absolute;z-index:1000;margin-top: 39px;margin-left: 135px;">
						<ul id="treeDemo" class="ztree" style="margin-top:0; width:220px;"></ul>
					</div>
				</div>
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%"s>发布人</label>
					<div class="layui-input-inline">
						<input type="text" id="author" readonly="readonly" name="author" lay-verify="required" autocomplete="off" class="layui-input" >
					</div>
				</div>	
			 <div class="layui-form-item inline" style=" width: 80%">
					<label class="layui-form-label" style=" width: 15%">发布时间</label>
					
			      	   <input style="width:23%;display:inline;" type="text" name="addtime" id="implementdate"  lay-verify="required|date"  autocomplete="off" class="layui-input" onclick="layui.laydate({elem: this})">
			      		~<input style="width:23%;display:inline;" type="text" name="endtime" id="enddate"  lay-verify="required|date"  autocomplete="off" class="layui-input" onclick="layui.laydate({elem: this})">
			        
				</div>			
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">可见范围</label>
					 <div margin-left="100px">
					     <div class="layui-input-block">
                               <div> <input id="w1" type="checkbox" name="like" value="1" >外网可见</div>
                               <div> <input id="w2" type="checkbox" name="like" value="2" >内网可见</div>
                               <div> <input id="w3" type="checkbox" name="like" value="3">内网登录可见</div>
                         </div>	 
                     </div>
				</div>
				<div class="layui-form-item inline" style="width: 40%">
					<label class="layui-form-label" style=" width: 30%">公开范围</label>					
						<select id="range" name="range" class="layui-input" style="width: 190px"> 
                           
                        </select> 
			    </div>	
			
				<div class="layui-form-item inline" style="width: 40%">
					<label class="layui-form-label" style=" width: 30%">公开属性</label>
					<input type="hidden" name="id" value="">
						<select id="attribute" name="attribute"  class="layui-input" style="width: 190px"> 
                           
                        </select> 
			    </div>
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">公开序号</label>
					<div class="layui-input-inline">
						<input type="text" id="num" name="num" lay-verify="required" autocomplete="off" class="layui-input" >
					</div>
				</div>
				<div class="layui-form-item inline" style="width: 40%">
					<label class="layui-form-label" style=" width: 30%">发文部门</label>
					
					<div class="layui-input-inline">
						<select id="department" name="department" class="layui-input"> 
                       <%
			             String regiona="SELECT * FROM type where typegroupid=26";
			             ResultSet regionaa=db.executeQuery(regiona);
			             while(regionaa.next()){
			          %> <option value="<%=regionaa.getInt("typecode")%>"><%=regionaa.getString("typename")%></option><%
			          }
		              %>
                        </select> 
					</div>
				</div>
						   
				<div id="tj" class="layui-form-item inline" style="width: 60%">
				<label class="layui-form-label" style="margin-left:70px;width:60px">已上传文件</label>
				</div>
				<div class="layui-form-item inline"  style="margin-top:5px">
			       <div style="margin-bottom:20px">文章内容</div>
					 <textarea id="editor_id" name="body" cols="100" rows="8" style="width:700px;height:500px;visibility:hidden;"></textarea>	
                        
				</div>
				<div class="layui-form-item" style="margin-bottom:45px">
					<div class="layui-input-block"  style="margin-left:540px">
						<button onclick="" class="layui-btn" lay-submit  lay-filter="formDemo">确认</button>
						<button type="reset" class="layui-btn layui-btn-primary">重置</button>
					</div>
				</div>
			</form>
		</div>
		<script>       
		 KindEditor.ready(function(K) {
  			var editor = K.create('textarea[name="body"]', {
  				cssPath : '../../kindeditor/plugins/code/prettify.css',
  				uploadJson : '../../kindeditor/jsp/upload_json.jsp',
  				fileManagerJson : '../../kindeditor/jsp/file_manager_json.jsp',
  				allowFileManager : true,
  				filterMode : true,
  				afterUpload : function(data){
                if(data.indexOf("#")>=0){
				    var strs= new Array(); 
 				    strs=data.split("#");
 				    $("#att").append(`<input type="hidden" name="attachment" value="`+strs[1]+`">`);
                }
 	        }
  			}); 		
  			editor.sync();
  			
		 });
		 $("#tj").on("click","div .sc",function(){		 
                $(this).parent().remove();
		})
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
////回显
             if("<%=request.getParameter("id")%>"!=""){
			  var Purl=basePath+"/Api/v1/?p=web/cms/articles/selectArticlesById";
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
			 		      $("#title").val( jsonData.threads[0].title);
			 		      $("#author").val( jsonData.threads[0].author);
			 		      $("#citySel").attr("value",jsonData.threads[0].classna);
			 		      $("#implementdate").val( jsonData.threads[0].addtime);
			 		      $("#enddate").val( jsonData.threads[0].endtime);
			 		      $("#regionalcode").val(jsonData.threads[0].twoid);
			 		      $("#num").val(jsonData.threads[0].num);
			 		       var str=jsonData.threads[0].visible;
			 		          if(jsonData.threads[0].attribute==1){
				 		        	$("#attribute").append(` <option value="1" selected>主动</option><option  value="2">依申请公开</option>`);
					 		        }else{
					 		        $("#attribute").append(` <option value="1" >主动</option><option  value="2" selected>依申请公开</option>`);      
						 		    }
			 		         if(jsonData.threads[0].range==2){
				 		        	$("#range").append(` <option value="2" selected>校内公开</option><option  value="1">社会公开</option>`);
					 		        }else{
					 		        $("#range").append(` <option value="2" >校内公开</option><option  value="1" selected>社会公开</option>`);      
						 		    }
				 		      $("#department").children("option").each(function(){
				 		    	     if($(this).val() == jsonData.threads[0].department){
	                                        $(this).attr("selected","selected");
					 		    	  }
					 		      });
				 		
				 		     console.log("遍历"+jsonData.threads[0].titlecolor);
				 		      $("#titlecolor").children("option").each(function(){
					 		      console.log("遍历"+$(this).val());
					 		     //alert($(this).val() == jsonData.threads[0].titlecolor);
			 		    	     if($(this).val() == jsonData.threads[0].titlecolor){
				 		    	   
                                     $(this).attr("selected","selected");
				 		    	  }
				 		      });
				 		   //多选框回显
			 		           if(str!=""){
			 		           var strs= new Array(); 
			 		              if(isNaN(str)){
			 		           strs=str.split("#"); }else{
                                        strs=str;
				 		           }
			 		           for (i=0;i<strs.length ;i++ ) 
			 		           {  
				 		          if(strs[i]==1){
				 		        	 $("#w1").attr("checked",'checked');
			 		               }
				 		          else if(strs[i]==2){
				 		        	 $("#w2").attr("checked",'checked');
				 		           }
				 		          else if(strs[i]==3){
				 		        	 $("#w3").attr("checked",'checked');
			 		              }
			 		           }
			 		         }
			 		     var texts=(jsonData.threads[0]).text;
			 		      	   
			 		     $("#editor_id").html(texts);
			 		     $("#text").html(texts);
			 		     //附件回显
			 		      var arr=jsonData.threads[0].attachment;
			 		     for(var keys in arr){					 		    		 		    
			 		      var path;		 		     
			 		      path=localhostPath+arr[keys];
			 		     var str={
					    	         "attachmentpath" : arr[keys]
					    	     }
		 //去附件表查询id
			$.ajax( {
				// 提交数据的类型 POST GET
				type : "POST",
				// 提交的网址
				url : basePath+"/Api/v1/?p=web/attachment/selectIdByPath",
				// 提交的数据
				data : JSON.stringify(str),
				// 返回数据的格式
				async : false,   //不是同步的话 返回值娶不到
				datatype : "json",// "xml", "html", "script", "json", "jsonp",
				// "text".
				// 成功返回之后调用的函数
				success : function(data,status) {
				 jsonData=eval("("+data+")"); 
				  $("#tj").append(`<div style="margin-top:5px"><input type="hidden" name="attachment" value="`+jsonData.attachmentid+`"><a href="`+path+`" target="_blank" download="`+keys+`">`+keys+`</a><a href="#" class="sc" style="margin-left:10px">删除</a></div>`)
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
		           }
				 },
			    // 调用出错执行的函数
				error : function() {
					 backdata="系统消息：网络故障与服务器失去联系";
				 }		      
			    }); 
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
			 			
			            }
			 		 },
			 	    // 调用出错执行的函数
			 		error : function() {
			 			 backdata="系统消息：网络故障与服务器失去联系";
			 		 }
			 	});
			  }   
			  var index = parent.layer.getFrameIndex(window.name);
           //编辑所有信息的表单
			  <% if( ac.equals("editdata")){
				     String id= request.getParameter("id");
			    	 artile_content= request.getParameter("body"); 
			    	 String title= request.getParameter("title"); 
			    	 String author= request.getParameter("author");
			    	 String classna= request.getParameter("classna");
			    	 String addtime= request.getParameter("addtime");
			    	 String endtime= request.getParameter("endtime");
			    	 String source= request.getParameter("source");
			    	 String department= request.getParameter("department");
			    	 String attribute= request.getParameter("attribute");
			    	 String range= request.getParameter("range");
			    	 String titlecolor= request.getParameter("titlecolor");
			    	 String num=request.getParameter("num");
			    	 String twoid= request.getParameter("twoid");
			    	 String[] values = request.getParameterValues("like");
			    	 String[] value=request.getParameterValues("attachment");
			    	 StringBuffer atta=new StringBuffer();
			    	 String att=null;
			    	 if(value!=null){		    		
			    		for(int i=0;i<value.length;i++){
			    	    	atta.append(value[i]+"#");
			    	     }
				    	att=atta.substring(0, atta.length()-1);
			    	 }else{
			    		 att=null;
			    	 }
                    
			    	 StringBuffer checkBoxValue= new StringBuffer();
			    	    for(int i=0;i<values.length;i++){
			    	    	 
			    	    	 checkBoxValue.append(values[i]+"#");
			    	    }
			    	  String check=checkBoxValue.substring(0, checkBoxValue.length()-1);		    	 
			    %>
			       var Purl=basePath+"/Api/v1/?p=web/cms/articles/editArticles";
			       var options=$("#department option:selected");
			       var source=options.text(); 			      
				   var text=escape(`<%=artile_content%>`);	
	   			   var classna="<%=classna%>";
				   var title="<%=title%>";	
				     var num="<%=num%>";
				     var author="<%=author%>";
				     var addtime="<%=addtime%>";
				     var endtime="<%=endtime%>";
				     var checkBoxValue="<%=check%>";
				  
				     if(title==""){
				    	 parent.layer.msg('请将标题信息填全');
				    
					     }else if(classna==""){
					        parent.layer.msg('请将栏目信息填全');
					    	  
						    }else if(text==""){
						        parent.layer.msg('请将文章内容信息填全');
						    	   
							    }else if(num==""){
							        parent.layer.msg('请将公开序号填全');
							    	  
								    }else if(isNaN(num)){
								        parent.layer.msg('请填写数字');
								    	  
								        }else if(author==""){
								        parent.layer.msg('请将发布人信息填全');
								    	   
									    }else if(addtime==""){
								             parent.layer.msg('请填写发布开始时间');
								    	   
									    }else if(endtime==""){
									        parent.layer.msg('请填写发布截止时间');
									    	   
										    }else if(checkBoxValue==""){
										        parent.layer.msg('请选择发布范围');
										    }else{
										    	var strvalue={
												    	 "id": <%=id%>,
													     "classna": classna,
													     "title": title,
													     "text": text,
													     "author": author,
													     "addtime": addtime,
													     "source":source,
													     "visible":checkBoxValue,
													     "num":num,
													     "department": "<%=department%>",
										    	         "attribute": "<%=attribute%>",
										    	         "range": "<%=range%>",
										    	         "attachment":"<%=att%>",
										    	         "titlecolor":"<%=titlecolor%>",
										    	         "twoid":"<%=twoid%>",
										    	         "endtime":endtime
													  };
											  				    
				  PostApi(Purl,AppId,AppKey,Spc_token,JSON.stringify(strvalue),Suid,uuid);}				 			  
			    <%}%>
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
				success : function(data,status){
				 jsonData=eval("("+data+")");  
			       if(jsonData.resultCode==404){
			    	   parent.layer.msg('编辑失败，请将信息填全');
				     }else{
				    	   parent.layer.msg('编辑 成功');
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
		  String SQL=" SELECT * FROM `cms_class` where fid=0 order by sort";		    
	      ResultSet RS = db.executeQuery(SQL);
		  while (RS.next()) {
			 String releasepeople=RS.getString("releasepeople");			  
			  if(releasepeople!=null){
            	if(releasepeople.indexOf("#"+Suid+"#")!=-1){
            		 out.println("{ id:"+RS.getInt("id")+", pId:"+RS.getInt("fid")+", name:'"+RS.getString("name")+"'},");
			    int idi=RS.getInt("id");
			    String SQLL=" SELECT * FROM `cms_class` where fid= "+idi+" order by sort";			   
			      ResultSet RSL = db.executeQuery(SQLL);			
			         while (RSL.next()) {
			        	 out.println("{ id:"+RSL.getInt("id")+", pId:"+RSL.getInt("fid")+", name:'"+RSL.getString("name")+"'},");
						
			         }
			         if(RSL!=null){RSL.close();}
            	}
			  }
		  }
		  if(RS!=null){RS.close();}		
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
				code += nodes[i].id + ",";
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
