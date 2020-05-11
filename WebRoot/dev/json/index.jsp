<%@ page trimDirectiveWhitespaces="true" %>
<%@ page contentType="text/html; charset=UTF-8" language="java"
	import="java.util.regex.*,java.sql.*,java.util.*,java.io.*,java.net.*,net.sf.json.*"%>
<%@page import="service.dao.db.Page"%>
<%@page import="service.dao.db.Jdbc"%>
<jsp:useBean id="db" scope="page" class="service.dao.db.Jdbc" />
<jsp:useBean id="server" scope="page" class="service.dao.db.Page" />

<%
String path = request.getContextPath();
String basePath = request.getScheme()+"s://"+request.getServerName()+":"+request.getServerPort()+path+"";
basePath=basePath.replaceAll(":80","");
if(basePath.indexOf("127.0.0.1")!=-1 || basePath.indexOf("localhost")!=-1  ){
basePath=basePath.replaceAll("https","http");	
}
basePath=basePath.replaceAll("https","http");
%> 

<%if( basePath.indexOf("e168.cn")!=-1){%>
<script type="text/javascript">
var targetProtocol = "http:";
if (window.location.protocol != targetProtocol)
 window.location.href = targetProtocol +
  window.location.href.substring(window.location.protocol.length);
</script>
<%}%>

<%
/*String agentname=(String)session.getAttribute("agentname");
String project_name=(String)session.getAttribute("project_name");
*/
String agentname="";
String project_name="";
Cookie[] Rcookies = request.getCookies();
 // 遍历数组,获得具体的Cookie
     if(Rcookies == null) {
        //out.print("没有Cookie信息");
     } else {
         for(int i=0; i<Rcookies.length; i++) {
            // 获得具体的Cookie
            Cookie Rcookie = Rcookies[i];
            // 获得Cookie的名称
            String name = Rcookie.getName();
            String value = Rcookie.getValue();
			if(name.equals("agentname"))  
              {  
                   agentname =URLDecoder.decode(value,"UTF-8");  
              }  
              if(name.equals("project_name"))  
              {  
                   project_name = URLDecoder.decode(value,"UTF-8");  
              }  
			     

            //out.print(i+"Cookie名:"+name+" &nbsp; Cookie值:"+value+"<br>");
         }
     } 


String ac = request.getParameter("ac"); 
String username = request.getParameter("username"); 
String userpwd = request.getParameter("userpwd"); 
String id = request.getParameter("id");
Page Page=new Page();
    if(ac==null){ac="";}
	if (id == null) {
		id = "0";
	}
	String json = "请选择右上角对应的模块";
	String beizhu = "",title="请选择右上角对应的模块",Path="";
	id=Page.mysqlCode(id).replaceAll(" ","");

%>


<%if(agentname==null || project_name==null || agentname.length()<2 || project_name.length()<2){%>
<br><br><br>
<div align="center"><img src="json.jpg"></div>
<br><br><br>
<div align="center">
<form id="form1" name="form1" method="post" action="?ac=go">
登录名<input type="txt" name="username" id="textfield" />
密码<input type="password" name="userpwd" id="textfield" />
 <input type="submit" name="button" id="button" value="登录" />
</form></div><%}else{%>




 

<!DOCTYPE html>
<html lang="CN">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

		<meta name="viewport"
			content="initial-scale=1.0, maximum-scale=1.0, user-scalable=no, width=device-width">
		<meta name="generator" content="joDoc">

		<title><%=agentname %>您好，欢迎使用 json api 开发联调平台</title>

		<link rel="stylesheet" type="text/css" href="index.css">
		<link rel="stylesheet" type="text/css" 	href="mobile.css" media="only screen and (max-device-width: 1024px)">
		<link rel="stylesheet" type="text/css" href="prettify.css">
		 <script src="formatjson.js"></script>
	</head>
	<body>
	<iframe src="sendemail.jsp" width="0" height="0"  frameborder="0"></iframe> 
 
	
<!-- 头部开始 -->	
		<div id="header">
			<h1>
				<a href="./"><%=agentname %>您好，欢迎使用 json api 开发联调平台</a>
			</h1>
			<small> <script type="text/JavaScript">
<!--
function MM_jumpMenu(targ,selObj,restore){ //v3.0
  eval(targ+".location='"+selObj.options[selObj.selectedIndex].value+"'");
  if (restore) selObj.selectedIndex=0;
}
//-->
</script>

				<form name="form1" id="form1">
					<select name="menu1" onChange="MM_jumpMenu('parent',this,0)">
						<optgroup label="<%=project_name %>api版本1.0" value="zh">
<%
ResultSet TRS2=null;
ResultSet TRS = db.executeQuery(" SELECT * FROM  `dev_json` where ctype=1 order by title asc");
	 String Tid="",Ttitle="",Tid2="";
	while (TRS.next()) {
        Tid = TRS.getString("id");
		Ttitle = TRS.getString("title");
	

	%> <option value="?ac=dev&id=<%=Tid%>"<%if(id.equals(Tid)){%>selected="selected"<%}%>>┏<%=Ttitle%></option>
	  <%TRS2 = db.executeQuery(" SELECT * FROM  `dev_json` where ctype=2 and faid="+Tid+" order by title asc");
	  while (TRS2.next()) { Tid2 = TRS2.getString("id");%>
	 <option value="?ac=dev&id=<%=Tid2%>"<%if(id.equals(Tid2)){%>selected="selected"<%}%>>┠●<%=TRS2.getString("title")%></option>
	   <%}%>
							 
	 <%}
	if (TRS != null) {
		TRS.close();
	}if (TRS2 != null) {
		TRS2.close();
	}%>
						</optgroup>

					</select>

					<a href="../svn/index.jsp"  target="_blank">SNV部署</a>
					<a href="sql.jsp"  target="_blank">SQL工具</a>
					<a href="index.jsp?ac=out">退出</a>
			</small>
			</form>
		</div>
		<div id="subheader">
			<h1> 
				Project of <%=project_name %> JSON API development joint debugging system </h1>
			<small><%=project_name %></small>
		</div>
	<!-- 头部 结束-->		
		
		
		

<!-- 左侧开始 -->

<div id="sidebar">
            <div class="vertical_divider"></div>
        <h1><a href="#">文档说明</a></h1>
        <ul>
   <%ResultSet leftopRs=db.executeQuery("SELECT * FROM  `dev_json_article`  where atype=0; ");  
      while(leftopRs.next()){   %>
        <%if( "article".equals(ac) && leftopRs.getString("id").equals(id)){ %>
       <li><a href="?ac=article&id=<%=leftopRs.getString("id") %>"><font color="#009900">☞<%=leftopRs.getString("title") %></font></a></li>
       <%}else{ %>
        <li><a href="?ac=article&id=<%=leftopRs.getString("id") %>"><%=leftopRs.getString("title") %></a></li>
       <%} %>
    <% }if(leftopRs!=null)leftopRs.close();  %>
      <li><a href="?ac=gettoken">APP快捷-获取token</a></li>
      </ul>



<% int leftmaxnum=0; int leftminnum=0;
ResultSet leftTRS2=null;
ResultSet leftTRS = db.executeQuery(" SELECT * FROM  `dev_json` where ctype=1 order by id asc");
	 String leftTid="",leftTtitle="",leftTid2="";
	while (leftTRS.next()) {leftmaxnum=leftmaxnum+1;
        leftTid = leftTRS.getString("id");
		leftTtitle = leftTRS.getString("title");
	
leftminnum=0;
	%>
<h1><a href="?ac=devshowlist&id=<%=leftTid %>"><%=leftmaxnum%>.<%=leftTtitle %></a></h1>
 <ul>
  <%leftTRS2 = db.executeQuery(" SELECT * FROM  `dev_json` where ctype=2 and faid="+leftTid+" order by id asc");
	  while (leftTRS2.next()) { leftminnum=leftminnum+1; leftTid2= leftTRS2.getString("id");%>
	  <%if( "dev".equals(ac) && leftTid2.equals(id)){ %>
       <li><a href="?ac=dev&id=<%=leftTid2%>"><font color="#009900">☞<%=leftmaxnum%>.<%=leftminnum%><%=leftTRS2.getString("title").replaceAll("\\.","").replaceAll("\\d+","")%></font></a></li>
      <%}else{ %>
      <li><a href="?ac=dev&id=<%=leftTid2%>"><%=leftmaxnum%>.<%=leftminnum%><%=leftTRS2.getString("title").replaceAll("\\.","").replaceAll("\\d+","")%></a></li>
      <%}//当前记录换颜色 %>
 <%}%>
</ul>

 <%}
	if (leftTRS != null) {
		leftTRS.close();
	}if (leftTRS2 != null) {
		leftTRS2.close();
	}%>


</div>
	
<!-- 左侧结束 -->	

<%if("dev".equals(ac)){//  ///判断dev显示信息结束 %>
<!-- dev模拟器右侧开始 -->
<%
String devtuptime="",model_view="";
ResultSet RS = db.executeQuery(" SELECT * FROM  `dev_json` where id="+ id);
	if (RS.next()) {

		json = RS.getString("json");
		beizhu = RS.getString("beizhu");
		title = RS.getString("title");
		Path= RS.getString("Path"); 
		devtuptime= RS.getString("uptime"); 
		model_view= RS.getString("model_view");
		if(Path==null){Path="";}

	}
	if (RS != null) {
		RS.close();
	}
	if(beizhu==null){beizhu="";}
	if(title==null){title="";}
	String AppId=""; %>
	
		<div id="scrollable">
			<div id="content">
				<div id="home">

					<h1>
						<a name="top1" id="top1"><%=title %> <font size="4">数据通信模拟器</font> </a>
						<div style="width:280px;height:20px;border:0px solid #000;float:right;font-size:12px;margin-top:20px;color:#F06433;">最后修改时间  <%=devtuptime %> <a href="?ac=history&id=<%=id %>">历史修改>>></a></div>
						
					</h1>
                      
					<br>
		
<script type="text/javascript">
var msg="testes_tse";
function loadXMLDoc()
{
      document.getElementById("send").innerHTML="<pre class=\"prettyprint\"><code><font color=\"#FFFFFF\">数据发送中...</font></code></pre>";
     document.getElementById("smsg").innerHTML="<textarea name=\"textarea\" cols=\"100%\" rows=\"10\">等待服务器响应...</textarea>";
    document.getElementById("smsgtojson").innerHTML="<textarea name=\"textarea\" cols=\"100%\" rows=\"30\">等待服务器响应...</textarea>";
	
var xmlhttp;
if (window.XMLHttpRequest)
  {// code for IE7+, Firefox, Chrome, Opera, Safari
  xmlhttp=new XMLHttpRequest();
  }
else
  {// code for IE6, IE5
  xmlhttp=new ActiveXObject("Microsoft.XMLHTTP");
  }
xmlhttp.onreadystatechange=function()
  {
  if (xmlhttp.readyState==4 && xmlhttp.status==200)
    {
	//alert(xmlhttp.responseText);


    // document.getElementById("smsg").innerHTML="<textarea name=\"textarea\" cols=\"100%\" rows=\"30\">"+format(xmlhttp.responseText,false)+"</textarea>";
	// document.getElementById("send").innerHTML="<pre class=\"prettyprint\"><code><font color=\"#FFFFFF\">"+document.getElementById("myDiv").value+"</font></code></pre>";

    document.getElementById("smsg").innerHTML="<textarea name=\"textarea\" cols=\"100%\" rows=\"10\">"+xmlhttp.responseText+"</textarea>";
    document.getElementById("smsgtojson").innerHTML="<textarea name=\"textarea\" cols=\"100%\" rows=\"30\">"+format(xmlhttp.responseText,false)+"</textarea>";
	document.getElementById("send").innerHTML="<pre class=\"prettyprint\"><code><font color=\"#FFFFFF\">"+document.getElementById("myDiv").value+"</font></code></pre>";

    //alert(format(xmlhttp.responseText,true));
 
	
    }
  }
xmlhttp.open("POST",document.getElementById("X-url").value,true);
xmlhttp.setRequestHeader("Content-type","application/json");
xmlhttp.setRequestHeader("X-AppId",document.getElementById("X-AppId").value);
xmlhttp.setRequestHeader("X-AppKey",document.getElementById("X-AppKey").value);
xmlhttp.setRequestHeader("Token",document.getElementById("Token").value);

xmlhttp.setRequestHeader("X-UUID",document.getElementById("X-UUID").value); 
xmlhttp.setRequestHeader("X-USERID",document.getElementById("X-USERID").value);
xmlhttp.setRequestHeader("X-Mdels",document.getElementById("X-Mdels").value);

xmlhttp.setRequestHeader("X-NetMode",document.getElementById("X-NetMode").value);
xmlhttp.setRequestHeader("X-ChannelId",document.getElementById("X-ChannelId").value);
//xmlhttp.setRequestHeader("X-CityCode",document.getElementById("X-CityCode").value);
xmlhttp.setRequestHeader("X-DeviceId",document.getElementById("X-DeviceId").value);
xmlhttp.setRequestHeader("X-GPS",document.getElementById("X-GPS").value);
xmlhttp.setRequestHeader("X-GPSLocal",encodeURI(document.getElementById("X-GPSLocal").value));
 

xmlhttp.send(document.getElementById("myDiv").value);
}

</script>
					</head>
					<body>
						<div align="center">
							<%
								String url = request.getScheme() + "://" + request.getServerName();
							%>
							<div align="left">
								<strong>请选择</strong>
								<br>
<table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td width="47%">线上正式Api请求地址：</td>
    <%if(Path.indexOf("/appApi/")!=-1){ %>
    <td width="53%"><input name="X-url2" id="X-url2" type="text" value="<%=basePath%><%=Path %>" size="50" /></td>
    <%}else{ %>
    <td width="53%"><input name="X-url2" id="X-url2" type="text" value="<%=basePath%>/Api/v1/?p=<%=Path %>" size="50" /></td>
    <%} %>
  </tr>
  <tr>
    <td>开发测试Api请求地址：</td>
     <%if(Path.indexOf("/appApi/")!=-1){ %>
    <td width="53%"><input name="X-url2" id="X-url" type="text" value="<%=basePath%><%=Path %>" size="50" /></td>
      <%}else{ %>
    <td width="53%"><input name="X-url2" id="X-url" type="text" value="<%=basePath%>/Api/v1/?p=<%=Path %>" size="50" /></td>
    <%} %>
    
  </tr>
  <tr>
    <td>HTTPP头验证：X-AppId：</td>
    <td><input name="X-AppId" id="X-AppId" type="text" value="8381b915c90c615d66045e54900feeab" size="50" /></td>
  </tr>
    <tr>
    <td>HTTPP头验证：X-AppKey：</td>
    <td><input name="X-AppKey" id="X-AppKey" type="text" value="d4df770ef73bd57653b0af59934296ee" size="50" /></td>
  </tr>
  <tr>
    <td>HTTPP头token验证：Token：</td>
    <td><input name="Token" id="Token" type="text" value="" size="50" /></td>
  </tr>
  
  <tr>
    <td>HTTPP头X-UUID验证：X-UUID：</td>
    <td><input name="X-UUID" id="X-UUID" type="text" value="000000000000000000000000" size="50" /></td>
  </tr>
  
    <tr>
    <td>HTTPP头X-DeviceId设备硬件验证：X-DeviceId：</td>
    <td><input name="X-DeviceId" id="X-DeviceId" type="text" value="3" size="50" /></td>
  </tr>
  
  <tr>
    <td>HTTPP头X-USERID验证：X-USERID：</td>
    <td><input name="X-USERID" id="X-USERID" type="text" value="1" size="50" /></td>
  </tr>
  
  <tr>
    <td>HTTPP头X-Mdels手机型号验证：X-Mdels：</td>
    <td><input name="X-Mdels" id="X-Mdels" type="text" value="iso7s" size="50" /></td>
  </tr>
  <tr>
    <td>HTTPP头X-NetMode上网模式验证：X-NetMode：</td>
    <td><input name="X-NetMode" id="X-NetMode" type="text" value="3G" size="50" /></td>
  </tr>
    <tr>
    <td>HTTPP头X-ChannelId推广id验证：X-ChannelId：</td>
    <td><input name="X-ChannelId" id="X-ChannelId" type="text" value="1" size="50" /></td>
  </tr>
   
     <tr>
    <td>HTTPP头X-GPS验证：X-GPS：</td>
    <td><input name="X-GPS" id="X-GPS" type="text" value="116.4757120000,39.9082850000" size="50" /></td>
  </tr>
   
     <tr>
    <td>HTTPP头X-GPSLocal验证：X-GPSLocal：</td>
    <td><input name="X-GPSLocal" id="X-GPSLocal" type="text" value="北京大望路" size="50" /></td>
  </tr>
    
   
</table>
<div style="width:735px;height:60px;border:1px solid #cccccc;float:left;font-size:12px;margin-top:15px;">
&nbsp;Json格式在线测试推荐网址：<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;1:<a href="http://www.json.cn" target="_blank">JSON格式测试1 http://www.json.cn</a><br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;2:<a href="http://www.bejson.com/" target="_blank">JSON格式测试2 http://www.bejson.com/</a>
</div>

<%if(model_view.length()>2){ %>
<br><br>
<script type="text/javascript" src="jquery.min.js"></script>
<style type="text/css">
*{margin:0;padding:0;list-style-type:none;}
a,img{border:0;}
body{font:12px/180% Arial, Helvetica, sans-serif, "宋体";}
/* suspend */
.suspend{width:40px;height:198px;position:fixed;top:200px;right:0;overflow:hidden;z-index:9999;}
.suspend dl{width:120px;height:198px;border-radius:25px 0 0 25px;padding-left:40px;box-shadow:0 0 5px #e4e8ec;}
.suspend dl dt{width:40px;height:198px;background:url(images/suspend.png);position:absolute;top:0;left:0;cursor:pointer;}
.suspend dl dd.suspendQQ{width:120px;height:85px;background:#ffffff;}
.suspend dl dd.suspendQQ a{width:120px;height:85px;display:block;background:url(images/suspend.png) -40px 0;overflow:hidden;}
.suspend dl dd.suspendTel{width:120px;height:112px;background:#ffffff;border-top:1px solid #e4e8ec;}
.suspend dl dd.suspendTel a{width:120px;height:112px;display:block;background:url(images/suspend.png) -40px -86px;overflow:hidden;}
* html .suspend{position:absolute;left:expression(eval(document.documentElement.scrollRight));top:expression(eval(document.documentElement.scrollTop+200))}
</style>
<div class="suspend">
	<dl>
		<dt class="IE6PNG"></dt>
		<dd class="suspendQQ"><a href="images/<%=model_view%>" target="_blank" alt="点击打开【<%=title%>】模型效果图" ><img   src="images/<%=model_view%>" width="110px"   /></a></dd>
		<dd class="suspendTel"><a href="images/<%=model_view%>" target="_blank" alt="点击打开【<%=title%>】模型效果图"></a></dd>
	</dl>
</div>

<script type="text/javascript">           
$(document).ready(function(){

	 $(".suspend").mouseover(function() {
        $(this).stop();
        $(this).animate({width: 160}, 400);
    })
	
    $(".suspend").mouseout(function() {
        $(this).stop();
        $(this).animate({width: 40}, 400);
    });
	
});
</script>

<%} %>

<br> <br> <br> 
<pre class="prettyprint2"><code>本接口名称：<strong><%=title%></strong><br><br><font color="#000000">接口说明：<%=beizhu%></font></code></pre>
 
<br> 模拟数据如下文本框：
  <textarea name="textarea" id="myDiv" cols="100%"  rows="5"><%=json%></textarea><br>

</div>
 
	<button type="button" onClick="loadXMLDoc()">模拟手机上行发送给服务器</button>
						</div>

						<br>
				 
						1>发送给服务器的JSON:


						<div id="send">
						</div>

						<br>
						2>服务器响应返回源生JSON:


						<div id="smsg">
						</div>
							<br>
						3>服务器响应返回格式化过的JSON:


						<div id="smsgtojson">
						  

						</div>
						
							
				</div>
<div style="width:100px;height:20px;border:0px solid #000;float:right;font-size:12px;margin-top:20px;color:#F06433;"><a href="?ac=showeditapi&id=<%=id %>">编辑该接口>>></a></div>
			</div>
		</div>
<!--  dev模拟器右侧结束 -->
<% }//判断dev显示信息结束 %>

 
<%if("article".equals(ac)){//判断article显示信息开始 %>
<!-- 判断article右侧开始 -->
<%ResultSet articleRS = db.executeQuery(" SELECT * FROM  `dev_json_article` where id="+ id);
	if (articleRS.next()) {  %>
	<div id="scrollable">
            <div id="content">
              <div id="home">
              <h1><a name="top1" id="top1"><%=articleRS.getString("title") %><font size="-2"> 修改时间<%=articleRS.getString("uptime") %></font><br></a></h1>
<p>


<%=articleRS.getString("body").replaceAll("\r\n","<br>") %>
           </div>

            </div>
        </div>
<% 	}if (articleRS != null) {articleRS.close();}
}//判断判断article结束 %>



<%if("gettoken".equals(ac)){//判断gettoken显示信息开始 %>
<!-- 判断article右侧开始 -->

<!-- 判断gettoken右侧开始 -->
   <style type="text/css">
		 th { background-color: white; }
	    .btn-group-vertical>.btn, .btn-group>.btn{height:#FF0000;}
         table tr:hover{background:#000000;color:#FF0000;}
		</style>
<form  name="dengluform" id="dengluform"  target="_blank" method="post" action="../../a/pages/dev_login.jsp">
<input type="hidden" name="phone" id="phone"  value="" />
<input type="hidden" name="pws"  id="pws"  value="" />
<input type="hidden" name="ac"  id="ac"  value="login" />
</form> 
  <script type="text/javascript">
  function denglu(phone,pws){
	   document.getElementById("phone").value=phone;
	   document.getElementById("pws").value=pws;
       document.getElementById("dengluform").submit();    
     }
  </script> 

	<div id="scrollable">
            <div id="content">
              <div id="home"  style="width: 950px;">
              <h3>用户名-token 列表</h3><table border=1>
<tr>
<td bgcolor=silver class='medium'>USERID</td>
<td bgcolor=silver class='medium'>用户名</td>
<td bgcolor=silver class='medium'>快捷登录</td>
<td bgcolor=silver class='medium'>usermob</td>
<td bgcolor=silver class='medium'>app_token</td>
<td bgcolor=silver class='medium'>pc_token</td>
<td bgcolor=silver class='medium'>登录密码</td></tr>
<%ResultSet articleRS = db.executeQuery(" SELECT uid,username,usermob,app_token,pc_token,password FROM  `user_worker` limit 100");
	while (articleRS.next()) {  %>
<tr>
<td class='normal' valign='top'><%=articleRS.getString("uid") %></td>
<td class='normal' valign='top'><%=articleRS.getString("username") %></td>
<td class='normal' valign='top'><input type="submit" name="Submit" onclick="denglu('<%=articleRS.getString("usermob") %>','<%=articleRS.getString("password") %>');" value="登录" id="Submit" /></td>
<td class='normal' valign='top'><%=articleRS.getString("usermob") %></td>
<td class='normal' valign='top'><%=articleRS.getString("app_token") %></td>
<td class='normal' valign='top'><%=articleRS.getString("pc_token") %></td>
<td class='normal' valign='top'><%=articleRS.getString("password") %></td>
</tr>
<%	}if (articleRS != null) {articleRS.close();} %> 
</tr>
</table>
          
<p>
 
           </div>

            </div>
        </div>
<% }//判断判断gettoken结束 %>


<%if("history".equals(ac)){//判断历史版本显示信息开始 %>
<!-- 判断article右侧开始 -->

	<div id="scrollable">
            <div id="content">
   <%
   int   historynum=db.Row("SELECT COUNT(*) as row FROM   `dev_json_article` where atype=1 and jsonid='"+ id+"';");
   int zongshu=historynum;
   ResultSet articleRS = db.executeQuery(" SELECT * FROM  `dev_json_article` where atype=1 and jsonid='"+id+"' order by id desc  limit 100 ; ");
	while (articleRS.next()) { historynum=historynum-1; %>
              <div id="home">
              <h1><a name="top1" id="top1"><font c color="FF0000">历史版本v<%=historynum %>：<%=articleRS.getString("title") %></font><font size="-2"> 修改时间<%=articleRS.getString("uptime") %></font><br></a></h1>
<p>

<%=articleRS.getString("body").replaceAll("\r\n","<br>") %>
           </div>
<%	}if (articleRS != null) {articleRS.close();} %>

<%if(zongshu==0){ %>  <div id="content">本接口无历史修改信息 </div><%} %>
            </div>
        </div>
      
<% }//判断历史版本显示信结束 %>




<%if("devshowlist".equals(ac)){// 判断分类管理 右侧开始 %>
<!-- 判断分类管理开始 右侧开始 -->
<% 

ResultSet articleRS = db.executeQuery(" SELECT * FROM  `dev_json` where id="+ id);
	if (articleRS.next()) {  %>
	<div id="scrollable">
            <div id="content">
              <div id="home">
              <h1><a name="top1" id="top1"><%=articleRS.getString("title") %>-接口管理<font size="-2"> 修改时间<%=articleRS.getString("uptime") %></font><br></a></h1>
<p>


<form action="?ac=addapi" method="post">
 <fieldset>
    <legend>①此分类下添加接口</legend>
   
    <br><input name="pbgid" id="bgid" type="hidden" value="<%=id %>" > 
    接口名字： <br><input name="ptitle" id="title" type="text" value="" size="50" placeholder="接口名字"> <br>
    资源路径： <br><input name="ppath" id="path" type="text" value="" size="50" placeholder="例如：app/add/device"> <br>
  Request数据: <br><textarea name="pjson" id="json" cols="100%" rows="5"  placeholder="手机发送到服务器的json数据例如：{}"></textarea><br>
   接口说明 <br><textarea name="pbeizhu" id="myDiv" cols="100%" rows="10">
   
   请求服务器说明：

    {
     "page": "1", // page 第一页
     "listnum": "10"   //listnum每页多少条
    }
      

服务器返回说明：
 
  
 {
    "success": "true", //服务器返回状态
    "resultCode": "1000", //服务器返回状态码  1000为正常 403禁止 500服务器错误  404没有找到
    "msg": "APP获取库房列表成功", //接口业务返回文字说明
    "order": "asc",  // 排序方式，回传客户端order值
    "currentpage": "1",   //当前页面，由客户端传递回传给客户端
    "pages": "10",  //总页数
    "Count":"6", //总记录数
    "threads": [
      .................
    ]
}</textarea><br>
模型图： <br><input name="pmodel_view" id="pmodel_view" type="text" value="<%=articleRS.getString("model_view") %>" size="50" placeholder="例如：10.png"> <br>
 <br>
   <input type="submit" name="Submit" value="新添接口" id="Submit" />
   <br>
   <br>
  </fieldset>
  </form>

 <br>  <br>

<form action="?ac=editclass" method="post">
 <fieldset>
    <legend>②修改此分类名</legend>
   
    <br><input name="pbgid" id="pbgid" type="hidden" value="<%=id %>" > 
    分类名字： <br><input name="ptitle" id="title" type="text" value="<%=articleRS.getString("title") %>" size="50" placeholder="分类名字："> <br>
  分类说明  <br><input name="pjson" id="pjson" type="text" value="<%=articleRS.getString("json") %>" size="50" placeholder="分类说明"> <br>
   分类备注 <br><input name="pbeizhu" id="pbeizhu" type="text" value="<%=articleRS.getString("beizhu") %>" size="50" placeholder="分类备注"> <br>
  
   <input type="submit" name="Submit" value="修改分类名" id="Submit" /> 
  </fieldset>
  </form>
 <br>  <br>
<form action="?ac=addclass" method="post">
 <fieldset>
    <legend>③添加新分类</legend>
   
    <br><input name="pbgid" id="pbgid" type="hidden" value="<%=id %>" > 
    分类名字： <br><input name="ptitle" id="title" type="text" value="" size="50" placeholder="分类名字："> <br>
  分类说明  <br><input name="pjson" id="pjson" type="text" value="APP接口此为分类无json测试数据。" size="50" placeholder="分类说明"> <br>
   分类备注 <br><input name="pbeizhu" id="pbeizhu" type="text" value="APP接口此为分类无json测试数据。" size="50" placeholder="分类备注"> <br>
  
   <input type="submit" name="Submit" value="添加新分类" id="Submit" /> 
  </fieldset>
  </form>
 
           </div>

            </div>
        </div>
       
        
<% 	}if (articleRS != null) {articleRS.close();}
}//判断分类管理开始 右侧结束 %>



<%if("showeditapi".equals(ac)){// 判断编辑接口api信息开始 %>
<% 

ResultSet articleRS = db.executeQuery(" SELECT * FROM  `dev_json` where id="+ id);
	if (articleRS.next()) {  %>
	<div id="scrollable">
            <div id="content">
              <div id="home">
              <h1><a name="top1" id="top1"><%=articleRS.getString("title") %>-接口编辑<font size="-2"> 修改时间<%=articleRS.getString("uptime") %></font><br></a></h1>
<p>


<form action="?ac=editapi" method="post">
 <fieldset>
    <legend>修改接口</legend>
   
    <br><input name="pbgid" id="bgid" type="hidden" value="<%=id %>" > 
    接口名字： <br><input name="ptitle" id="title" type="text" value="<%=articleRS.getString("title") %>" size="50" placeholder="接口名字"> <br>
    资源路径： <br><input name="ppath" id="path" type="text" value="<%=articleRS.getString("path") %>" size="50" placeholder="例如：app/add/device"> <br>
  Request数据: <br><textarea name="pjson" id="json" cols="100%" rows="5"  placeholder="手机发送到服务器的json数据例如：{}"><%=articleRS.getString("json") %></textarea><br>
   接口说明 <br><textarea name="pbeizhu" id="myDiv" cols="100%" rows="10">
  <%=articleRS.getString("beizhu") %></textarea><br> <br>
  模型图： <br><input name="pmodel_view" id="pmodel_view" type="text" value="<%=articleRS.getString("model_view") %>" size="50" placeholder="例如：10.png"> <br>
  修改原因 <br><textarea name="yuanyin" id=""yuanyin"" cols="100%" rows="3" placeholder="请填写修改原因理由"></textarea><br> <br>
   <input type="submit" name="Submit" value="编辑该接口" id="Submit" />
   <br>
   <br>
  </fieldset>
  </form>

 <br>  <br>
 </div>
 </div>
 </div>        
<%  }if (articleRS != null) {articleRS.close();}
}//判断编辑接口api信息结束 %>

</div>
 
</body>
</html>

   <%if(ac!=null && ac.equals("addapi")){  //在某分类添加新接口
   String pbgid = request.getParameter("pbgid"); 
   String ptitle = request.getParameter("ptitle"); 
   
   String ppath = request.getParameter("ppath"); 
   String pjson = request.getParameter("pjson"); 
   String pbeizhu = request.getParameter("pbeizhu"); 
   String pmodel_view = request.getParameter("pmodel_view");
   if(pmodel_view==null){pmodel_view="";}
      
   if(pbgid==null || pbgid.length()<0){
     out.print("<script language=\"JavaScript\">\r\n <!--\r\n alert(\"分类id不对\"); \r\n location.href='javascript:history.go(-1);'; \r\n// -->\r\n  </script>");
     return;
   }
   
    if(ptitle==null || ptitle.length()<3){
     out.print("<script language=\"JavaScript\">\r\n <!--\r\n alert(\"接口名没有填写\"); \r\n location.href='javascript:history.go(-1);'; \r\n// -->\r\n  </script>");
   return;
   }
   
    if(ppath==null || ppath.length()<3){
     out.print("<script language=\"JavaScript\">\r\n <!--\r\n alert(\"接口资源路径\"); \r\n location.href='javascript:history.go(-1);'; \r\n// -->\r\n  </script>");
    return;
   }
   
    if(pjson==null || pjson.length()<3 || pbeizhu.length()<3){
     out.print("<script language=\"JavaScript\">\r\n <!--\r\n alert(\"json数据或备注说明填写不完整\"); \r\n location.href='javascript:history.go(-1);'; \r\n// -->\r\n  </script>");
     return;
   }  
   db.executeUpdate("INSERT INTO `dev_json`(`model_view`,`ctype`,`faid`,`title`,`json`,`beizhu`,`path`,`uptime`) VALUES ('"+pmodel_view+"','2','"+pbgid+"','"+ptitle+"','"+pjson+"','"+pbeizhu+"','"+ppath+"',now());");  
	
	String tempstr=""+server.getTimeB()+"  <font color=\"#FF9900\">"+agentname+"</font> 新添 <font color=\"#00CC00\">"+ptitle+"</font> 接口!<font color=\"#0033FF\">快去看看吧</font>\r\n ";
	String tempsql="UPDATE  `dev_json_article` SET  body=CONCAT('"+tempstr+"',body)  WHERE id=1";
 
	//System.out.println("tempsql============="+tempsql);
   db.executeUpdate(tempsql);
   db.executeUpdate("INSERT INTO  `dev_json_article`( `atype`,`jsonid`,`title`,`body`,`uptime`) VALUES ('1','"+pbgid+"','"+agentname+"新添接口"+ptitle+"','"+server.getTimeD()+"  <font color=\"#FF9900\">"+agentname+"</font> 添加了 <font color=\"#00CC00\">"+ptitle+"</font> 接口.\r\n资源路径:"+ppath+" \r\n \r\n Request数据: "+pjson+"\r\n "+pbeizhu+"',now());");
  
   db.executeUpdate("insert into  `dev_user_send_email`(`title`,`mailinfo`,`state`,`addtime`) values ( '开发平台通知："+agentname+"新添接口"+ptitle+"~快去看看吧','"+server.getTimeD()+"  <font color=\"#FF9900\">"+agentname+"</font> 添加了 <font color=\"#00CC00\">"+ptitle+"</font> 接口.\r\n资源路径:"+ppath+" \r\n \r\n Request数据: "+pjson+"\r\n "+pbeizhu+"','0',now());");	
  	
   out.print("<script language=\"JavaScript\">\r\n <!--\r\n alert(\"【"+ptitle+"】添加接口成功！\"); \r\n location.href='index.jsp?ac=devshowlist&id="+pbgid+"'; \r\n// -->\r\n  </script>");
 
    }        
   %>  
   
    <%if(ac!=null && ac.equals("addclass")){  //添加新分类
 
   String ptitle = request.getParameter("ptitle"); 
   String pjson = request.getParameter("pjson"); 
   String pbeizhu = request.getParameter("pbeizhu"); 
   
   if(ptitle==null || ptitle.length()<3){
     out.print("<script language=\"JavaScript\">\r\n <!--\r\n alert(\"分类名没有填写\"); \r\n location.href='javascript:history.go(-1);'; \r\n// -->\r\n  </script>");
   return;
   }
   
     if(pjson==null || pjson.length()<3 || pbeizhu.length()<3){
     out.print("<script language=\"JavaScript\">\r\n <!--\r\n alert(\"数据或备注说明填写不完整\"); \r\n location.href='javascript:history.go(-1);'; \r\n// -->\r\n  </script>");
     return;
   }
   db.executeUpdate("INSERT INTO `dev_json`(`ctype`,`faid`,`title`,`json`,`beizhu`,`path`,`uptime`) VALUES ('1','0','"+ptitle+"','"+pjson+"','"+pbeizhu+"','',now());");  
	
   out.print("<script language=\"JavaScript\">\r\n <!--\r\n alert(\"【"+ptitle+"】添加分类成功！\"); \r\n location.href='index.jsp'; \r\n// -->\r\n  </script>");
 
    }        
   %>  
   
   <%if(ac!=null && ac.equals("editclass")){  //修改分类
 
   String pbgid = request.getParameter("pbgid"); 
   String ptitle = request.getParameter("ptitle"); 
   
   String ppath = request.getParameter("ppath"); 
   String pjson = request.getParameter("pjson"); 
   String pbeizhu = request.getParameter("pbeizhu"); 
   
   if(pbgid==null || pbgid.length()<0){
     out.print("<script language=\"JavaScript\">\r\n <!--\r\n alert(\"分类id不对\"); \r\n location.href='javascript:history.go(-1);'; \r\n// -->\r\n  </script>");
     return;
   }
   if(ptitle==null || ptitle.length()<3){
     out.print("<script language=\"JavaScript\">\r\n <!--\r\n alert(\"分类名没有填写\"); \r\n location.href='javascript:history.go(-1);'; \r\n// -->\r\n  </script>");
   return;
   }
   
     if(pjson==null || pjson.length()<3 || pbeizhu.length()<3){
     out.print("<script language=\"JavaScript\">\r\n <!--\r\n alert(\"数据或备注说明填写不完整\"); \r\n location.href='javascript:history.go(-1);'; \r\n// -->\r\n  </script>");
     return;
   }
   db.executeUpdate("UPDATE `dev_json` SET `title`='"+ptitle+"',`json`='"+pjson+"',`beizhu`='"+pbeizhu+"'  where id='"+pbgid+"'");  
	
   out.print("<script language=\"JavaScript\">\r\n <!--\r\n alert(\"【"+ptitle+"】添加分类成功！\"); \r\n location.href='index.jsp'; \r\n// -->\r\n  </script>");
 
    }        
   %>   
   
   <%if(ac!=null && ac.equals("editapi")){  //修改接口
 
   String pbgid = request.getParameter("pbgid"); 
   String ptitle = request.getParameter("ptitle"); 
   String yuanyin = request.getParameter("yuanyin"); 
   String ppath = request.getParameter("ppath"); 
   String pjson = request.getParameter("pjson"); 
   String pbeizhu = request.getParameter("pbeizhu"); 
   String pmodel_view = request.getParameter("pmodel_view"); 
   
   pjson=pjson.replaceAll("\\\\","\\\\\\\\");
   pbeizhu=pbeizhu.replaceAll("\\\\","\\\\\\\\");
   if(pbgid==null || pbgid.length()<0){
     out.print("<script language=\"JavaScript\">\r\n <!--\r\n alert(\"分类id不对\"); \r\n location.href='javascript:history.go(-1);'; \r\n// -->\r\n  </script>");
     return;
   }
   if(ptitle==null || ptitle.length()<3){
     out.print("<script language=\"JavaScript\">\r\n <!--\r\n alert(\"分类名没有填写\"); \r\n location.href='javascript:history.go(-1);'; \r\n// -->\r\n  </script>");
   return;
   }
     if(yuanyin==null || yuanyin.length()<3){
     out.print("<script language=\"JavaScript\">\r\n <!--\r\n alert(\"修改原因理由没有填写\"); \r\n location.href='javascript:history.go(-1);'; \r\n// -->\r\n  </script>");
   return;
   }
   
     if(pjson==null || pjson.length()<3 || pbeizhu.length()<3){
     out.print("<script language=\"JavaScript\">\r\n <!--\r\n alert(\"数据或备注说明填写不完整\"); \r\n location.href='javascript:history.go(-1);'; \r\n// -->\r\n  </script>");
     return;
   }
   db.executeUpdate("UPDATE `dev_json` SET `model_view`='"+pmodel_view+"', `title`='"+ptitle+"',`json`='"+pjson+"',`beizhu`='"+pbeizhu+"',`path`='"+ppath+"',uptime=now() where id='"+pbgid+"'");  
   db.executeUpdate("UPDATE  `dev_json_article` SET `body`=CONCAT('"+server.getTimeB()+"  <font color=\"#FF9900\">"+agentname+"</font> 修改了 <font color=\"#00CC00\">"+ptitle+"</font> 接口,原因：<font color=\"#0033FF\">"+yuanyin+"</font>\r\n\',body)  WHERE id=1");
   db.executeUpdate("INSERT INTO  `dev_json_article`( `atype`,`jsonid`,`title`,`body`,`uptime`) VALUES ('1','"+pbgid+"','"+agentname+"修改接口"+ptitle+"','"+server.getTimeD()+"  <font color=\"#FF9900\">"+agentname+"</font> 修改了 <font color=\"#00CC00\">"+ptitle+"</font> 接口,原因：<font color=\"#0033FF\">"+yuanyin+"</font> \r\n \r\n Request数据: \r\n "+pjson+""+pbeizhu+"',now());");
  
   db.executeUpdate("insert into  `dev_user_send_email`(`title`,`mailinfo`,`state`,`addtime`) values ( '开发平台通知："+agentname+"修改接口"+ptitle+"','"+server.getTimeD()+"  <font color=\"#FF9900\">"+agentname+"</font> 修改了 <font color=\"#00CC00\">"+ptitle+"</font> 接口,原因：<font color=\"#0033FF\">"+yuanyin+"</font> \r\n \r\n Request数据: \r\n "+pjson+""+pbeizhu+"','0',now());");
  
  
   out.print("<script language=\"JavaScript\">\r\n <!--\r\n alert(\"【"+ptitle+"】编辑接口成功！\"); \r\n location.href='index.jsp?ac=dev&id="+pbgid+"'; \r\n// -->\r\n  </script>");
 
    }        
   %>   
<%if(ac.length()==0){//默认登录页面
response.sendRedirect("index.jsp?ac=article&id=1");
}
%>

<%} //判断登录结束%>


<%if(ac!=null && ac.equals("go")){  //开始登录
 
if(username!=null & userpwd!=null){
	String ip = request.getHeader("x-real-ip");
		if (ip == null || ip.length() == 0) {
			ip = request.getRemoteAddr();
		}
 
username=Page.mysqlCode(username); 	//防止SQL注入
userpwd=Page.mysqlCode(userpwd).replaceAll(" ","");	//防止SQL注入

int   RegTag=db.Row("SELECT COUNT(*) as row FROM   dev_json_user  WHERE username='"+username+"' and userpwd='"+userpwd+"' and state=1;");
if(RegTag==0){
 
	   out.print("<script language=\"JavaScript\">\r\n <!--\r\n alert(\"账户与密码不对!\"); \r\n location.href='index.jsp'; \r\n// -->\r\n  </script>");
	   if(db!=null)db.close();db=null;if(server!=null)server=null; 
	   return;
	}else{
	
	ResultSet UerRs=db.executeQuery("SELECT id,project_name,username FROM  `dev_json_user`  where username='"+username+"' and userpwd='"+userpwd+"' and state=1 limit 1; ");  
      if(UerRs.next()){    
      
	   Cookie cookiename  = new Cookie("agentname",URLEncoder.encode(UerRs.getString("username"),"UTF-8") );
       cookiename.setMaxAge(60*60*24*7);
       //cookiename.setPath("/");
       response.addCookie(cookiename);

       Cookie cookieproject = new Cookie("project_name",URLEncoder.encode(UerRs.getString("project_name"),"UTF-8"));
       cookieproject.setMaxAge(60*60*24*7);
       //cookieproject.setPath("/");
       response.addCookie(cookieproject);
       
	  	/*session.setAttribute("agentname",UerRs.getString("username"));
	    session.setAttribute("project_name",UerRs.getString("project_name"));
	    */
	     db.executeUpdate("UPDATE   `dev_json_user` SET `logintime`=now(),`logincount`=logincount+1,`ip`='"+ip+"' WHERE `id`='"+UerRs.getString("id")+"';");  
	      db.executeUpdate("INSERT INTO  `dev_json_article`( `atype`,`title`,`body`,`uptime`) VALUES ('2','系统登录','"+server.getTimeD()+""+UerRs.getString("username")+"成功登录了系统,IP地址："+ip+"',now());");
 
	  }if(UerRs!=null)UerRs.close(); 
            response.sendRedirect("index.jsp");
	  }
	

  }else{
    out.print("<script language=\"JavaScript\">\r\n <!--\r\n alert(\"请填写完整的账户与密码!\"); \r\n location.href='index.jsp'; \r\n// -->\r\n  </script>");
	   if(db!=null)db.close();db=null;if(server!=null)server=null; 
  }

}%>



<%if(ac!=null && ac.equals("out")){ //退出
//session.removeAttribute("agentname"); 
//session.removeAttribute("project_name"); 
// 遍历数组,获得具体的Cookie
     if(Rcookies == null) {
        out.print("安全退出成功!");
     } else {
         for(int i=0; i<Rcookies.length; i++) {
            Rcookies[i].setMaxAge(0);  
            response.addCookie(Rcookies[i]); 
         }
     } 

 out.print("<script language=\"JavaScript\">\r\n <!--\r\n alert(\"成功退出!\"); \r\n location.href='index.jsp'; \r\n// -->\r\n  </script>");
 }%>
 
 
 <%
	if (db != null)
		db.close();
	db = null;
	if (server != null)
		server = null;
%>
 