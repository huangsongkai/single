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
		<title>选择人员页面</title> 
	    <style type="text/css">
			.inline{ position: relative; display: inline-block; margin-right: 10px; }
			#bot{
			   margin-top:10px;
			   overflow:hidden;
			   width:100%;
			}
			.center{
			  text-align:center;
			  width:10%;
			  float:left;
			}
			.lb{
			  text-align:center;
			  width:30%;
			  float:left;
			}
	    </style>
	</head>
	<body>
		<div style="margin:15px;">
			<fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
				<legend>选择人员</legend>
			</fieldset>
		<div class="layui-form" >
			    <div>
                <input type="hidden" id="AppId" value="<%=AppId_web%>">
                <input type="hidden" id="AppKey" value="<%=AppKey_web%>">
                <input type="hidden" id="Spc_token" value="<%=Spc_token%>">
                <input type="hidden" id="Suid" value="<%=Suid%>">
                <input type="hidden" id="uuid" value="<%=uuid%>">
                </div>
				<div class="layui-form-item inline" style="width: 50%">
					<label class="layui-form-label" style=" width: 20%">院系</label>
					<input type="hidden" name="id" value="">
					<div class="layui-input-inline">
						<select id="depth" name="depth" class="layui-input" lay-filter="depth"> 
                          
                        </select> 
					</div>
				</div>
<!--		    <input type="hidden" name="usernameid" lay-verify="nickname" autocomplete="off" class="layui-input" value="">-->
				<div class="layui-form-item inline" style=" width: 50%">
					<label class="layui-form-label" style=" width: 20%">教研室</label>
					<div class="layui-input-inline">
						<select id="fid" name="fid" class="layui-input"> 
                           <option value ="0" selected>（全部）</option>   
                        </select> 
					</div>
				</div>
				<div class="layui-form-item inline" style=" width: 50%">
					<label class="layui-form-label" style=" width: 20%">职位</label>
					 <div class="layui-input-inline">
					   <select id="zw" name="zw" class="layui-input"> 
					     <option value ="0" selected>（全部）</option>   
                      <%
			             String regiona="SELECT * FROM type where typegroupid=27";
			             ResultSet regionaa=db.executeQuery(regiona);
			             while(regionaa.next()){
			          %><option value="<%=regionaa.getInt("typecode")%>"><%=regionaa.getString("typename")%></option><%
			          }
		              %>
                       </select>
                     </div>
                  </div>
			  <button  class="layui-btn" onclick="selectpeople()" >查询</button>
		</div>	
		<form name =Form1>
		  <div  id="bot">
		  <div class="lb">   
			<select id="s1" name=Jsrbh class="myselect" style="width: 162; height: 260"  ondblclick="javascript:addbj();" size="10"  multiple>                                        
            </select>
           </div> 
             <div class="center">      
                <input type="button" value="> " name="add" onclick ="javascript:addbjs();" class="button"><br><br>    
                <input type="button" value=">>" name="addall" onclick ="javascript:addbjall();" class="button"><br><br>     
                <input type="button" value="< " name="remove" onclick ="javascript:removebjs();" class="button"><br><br>     
                <input type="button" value="<<" name="removeall" onclick ="javascript:removebjall();" class="button">
              </div>
            <div class="lb">  
              <select id="s2" name=Jsrbh2 style="width: 162; height: 260" ondblclick="javascript:removebj();" multiple size="10" class="mytext">                                       
           
              </select> 
             </div>     
				<div class="layui-form-item" style="margin-bottom:45px">
					<div class="layui-input-block"  style="margin-left:540px">							
						<button  class="layui-btn" onclick="cz()">确认</button>								
					</div>
				</div>
		  </div>  
		</form> 
 <script>
		//往父页面传发布人值
	    function cz(){
	    	   var index = parent.layer.getFrameIndex(window.name);
		       var str="#";
		       var strs="";
               $("#s2").children("option").each(function(){
                    str+=$(this).val()+"#";
                    strs+=$(this).text()+",";
               })
               parent.$('#release').val(strs);
               parent.$('#releasepeople').val(str);
               parent.layer.close(index);
		};
		//basepath获取服务器根目录
	    var curWwwPath = window.document.location.href;
	    var pathName = window.document.location.pathname;
	    var pos = curWwwPath.indexOf(pathName);
	    var localhostPath = curWwwPath.substring(0, pos);
	    var projectName = pathName.substring(0, pathName.substr(1).indexOf('/') + 1);
	    var basePath=localhostPath+projectName+"/";
    var obj;
       //查找院系-教研室
	var str={
    		"bu":"不需要数据"
    	    }
    $.ajax( {
 		// 提交数据的类型 POST GET
 		type : "POST",
 		// 提交的网址
 		url : basePath+"/Api/v1/?p=web/publicInformation/selectMultistage",
 		// 提交的数据
 		data : JSON.stringify(str),
 		// 返回数据的格式
 		async : false,//不是同步的话 返回值娶不到
 		datatype : "json",// "xml", "html", "script", "json", "jsonp",
 		// "text".
 		// 成功返回之后调用的函数
 		success : function(data) {		  
 		  var  inner;
 		       jsonData=eval("("+data+")");     
 		       for(var i=0;i<jsonData.threads.length;i++){
 		    	      obj= jsonData.threads[i];
 		    	     var inner;		    
 		    	         inner+=`<option value="0">全部</option>`;	    	   
 		    	     for(var key in  obj)
 		    	     {    
	 		    	   inner+=`<option value="`+key+`">`+key+`</option>`;     	        	     
 		    	     }
              }
 		    $('#depth').prepend(inner);
        },
 		 headers : {
 			"Content-type" : "application/json",
 			"X-AppId" : "<%=AppId_web%>",
 			"X-AppKey" : "<%=AppKey_web%>",
 			"Token" : "<%=Spc_token%>",
 			"X-USERID": "<%=Suid%>",
 			"X-UUID": "<%=uuid%>",
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
		//查找人员
  function selectpeople(){
	  var department=$("#depth").val();
	  var teachingResearch=$("#fid").val();
	  var position=$("#zw").val();
	  var str={
				  "department": department,
				  "teachingResearch": teachingResearch,
				  "position": position
	    	  }
	    $.ajax( {
	 		// 提交数据的类型 POST GET
	 		type : "POST",
	 		// 提交的网址
	 		url : basePath+"/Api/v1/?p=web/users/selectUserBydtp",
	 		// 提交的数据
	 		data : JSON.stringify(str),
	 		// 返回数据的格式
	 		async : false,//不是同步的话 返回值娶不到
	 		datatype : "json",// "xml", "html", "script", "json", "jsonp",
	 		// "text".
	 		// 成功返回之后调用的函数
	 		success : function(data) {		  
	    	         jsonData=eval("("+data+")");  
	    	         var inner;   
		       for(var i=0;i<jsonData.threads.length;i++){
                       inner+=`<option value ="`+jsonData.threads[i].uid+`">`+jsonData.threads[i].username+`</option>`;
			       }
		        $("#s1").html(inner);
	        },
	 		 headers : {
	 			"Content-type" : "application/json",
	 			"X-AppId" : "<%=AppId_web%>",
	 			"X-AppKey" : "<%=AppKey_web%>",
	 			"Token" : "<%=Spc_token%>",
	 			"X-USERID": "<%=Suid%>",
	 			"X-UUID": "<%=uuid%>",
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
        }				
		//多级联动
		layui.use(['form', 'layedit', 'laydate'], function() {
				var form = layui.form(),
					layer = layui.layer,
					layedit = layui.layedit,
					laydate = layui.laydate;
				form.on('select(depth)', function(data){					 
					  console.log(data.value); //得到被选中的值
					  $("#fid").html();
					  var arr=obj[data.value];
					  var arrs=arr[0];
					  var date1;
					  date1+=`<option value="0">全部</option>`; 
					  for(var keys in arrs ){						  
						   date1+=`<option value="`+arrs[keys]+`">`+keys+`</option>`; 
						 }
					  $("#fid").html(date1); 
					  form.render('select', 'depth');                             
					});  
			});
//原系统js
function js_callpage4(htmlurl) {
  var newwin=window.open(htmlurl,"_blank",'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=no,top=205,left=205,width=250,height=240');
}
function findfind()
{
readdata.style.visibility='visible';
iLen = document.Form1.Jsrbh2.length;
for (i =0;i<iLen;i++)
{
 document.Form1.Jsrbh2.options[i].selected = true;
}
document.Form1.action='?ReadData=OK&datetime=2017/12/12 11:20:37';
document.Form1.submit();
}
function selectOK()
{
var BH ='';
var MC = '';
  iLen = document.Form1.Jsrbh2.length ;
  //alert(iLen);
  
  //alert(window.opener.window.document.Form1.JsrFw);
  for (i=0;i<iLen;i++)
  {
     BH = BH + document.Form1.Jsrbh2.options[i].value + ',';
     MC = MC + document.Form1.Jsrbh2.options[i].text + ',';
     //alert(BH);
  }
  	if(BH.length>500)
	{
		alert("选择人员太多！");
		return false;
	}
   try{
	    //alert(MC);
		window.opener.window.document.all(document.Form1.UpdateBH.value).value = BH;
		window.opener.window.document.all(document.Form1.UpdateMC.value).value = MC;
		window.close();
    }
    catch(exception){
		window.close();
   }
}
function addbj() 
{ 
 var stext; 
 var svalue; 
 var ss; 
 var oOption = document.createElement("OPTION");    
  
 if (document.Form1.Jsrbh.selectedIndex < 0 ){return false} 
  
 stext = document.Form1.Jsrbh.options[document.Form1.Jsrbh.selectedIndex].text; 
 svalue=document.Form1.Jsrbh.value  
 document.Form1.Jsrbh2.options.add(oOption);  
 oOption.innerText = stext ;  
 oOption.value = svalue ; 
 document.Form1.Jsrbh.options.remove(document.Form1.Jsrbh.selectedIndex ); 
   
}   
function removebj() 
{ 
 var stext; 
 var svalue; 
 var ss; 
 var oOption = document.createElement("OPTION");    
  
 if (document.Form1.Jsrbh2.selectedIndex < 0 ){return false} 
  
 stext = document.Form1.Jsrbh2.options[document.Form1.Jsrbh2.selectedIndex].text; 
 svalue=document.Form1.Jsrbh2.value  
 document.Form1.Jsrbh.options.add(oOption);  
 oOption.innerText = stext ;  
 oOption.value = svalue ; 
 document.Form1.Jsrbh2.options.remove(document.Form1.Jsrbh2.selectedIndex ); 
   
}   
function addbjs() 
{ 
 var stext; 
 var svalue; 
 var ss; 
 var oOption; 
     
 //alert(document.Form1.Jsrbh.options[0].selected ); 
 if (document.Form1.Jsrbh.length <= 0 ){return false} 
 i=0; 
 for (;;) 
 { 
   if (i==document.Form1.Jsrbh.length){return false} 
   if (document.Form1.Jsrbh.options[i].selected) 
   { 
     oOption = document.createElement("OPTION"); 
     stext = document.Form1.Jsrbh.options[i].text; 
     svalue=document.Form1.Jsrbh.value  
     document.Form1.Jsrbh2.options.add(oOption);  
     oOption.innerText = stext ;  
     oOption.value = svalue ; 
     document.Form1.Jsrbh.options.remove(i); 
   } 
   else 
   { 
     i=i+1; 
   }   
 }  
}   
function removebjs() 
{ 
 var stext; 
 var svalue; 
 var ss; 
 var oOption; 
     
 //alert(document.Form1.Jsrbh.options[0].selected ); 
 if (document.Form1.Jsrbh2.length <= 0 ){return false} 
 i=0; 
 for (;;) 
 { 
   if (i==document.Form1.Jsrbh2.length){return false} 
   if (document.Form1.Jsrbh2.options[i].selected) 
   { 
     oOption = document.createElement("OPTION"); 
     stext = document.Form1.Jsrbh2.options[i].text; 
     svalue=document.Form1.Jsrbh2.value  
     document.Form1.Jsrbh.options.add(oOption);  
     oOption.innerText = stext ;  
     oOption.value = svalue ; 
     document.Form1.Jsrbh2.options.remove(i); 
   } 
   else 
   { 
     i=i+1; 
   }   
 }  
}   
function addbjall() 
{ 
 var stext; 
 var svalue; 
 var ss; 
 var oOption;    
  
 if (document.Form1.Jsrbh.length <= 0 ){return false} 
  
 for (;;) 
 { 
  oOption = document.createElement("OPTION"); 
 stext = document.Form1.Jsrbh.options[0].text; 
 svalue=document.Form1.Jsrbh.options[0].value  
 document.Form1.Jsrbh2.options.add(oOption);  
 oOption.innerText = stext ;  
 oOption.value = svalue ; 
 document.Form1.Jsrbh.options.remove(0); 
 if (document.Form1.Jsrbh.length <= 0 ){return false} 
 
 }  
}   
function removebjall() 
{ 
 var stext; 
 var svalue; 
 var ss; 
 var oOption;    
  
 if (document.Form1.Jsrbh2.length <= 0 ){return false} 
  
 for (;;) 
 { 
  oOption = document.createElement("OPTION"); 
 stext = document.Form1.Jsrbh2.options[0].text; 
 svalue=document.Form1.Jsrbh2.options[0].value  
 document.Form1.Jsrbh.options.add(oOption);  
 oOption.innerText = stext ;  
 oOption.value = svalue ; 
 document.Form1.Jsrbh2.options.remove(0); 
 if (document.Form1.Jsrbh2.length <= 0 ){return false} 
 
 }  
}   
function showfindbj()
{
  if (document.Form1.morebj.checked){
    findbj.style.visibility="visible";
  }
  else
  {
    //findbj.style.visibility="hidden";
    //readdata.style.visibility="visible";
    //document.Form1.submit();
    findfind();
  }
}
//////原系统js
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