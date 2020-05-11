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
		<title>信息详情页面</title> 
	   <link href="css/style-2.css" rel="stylesheet" type="text/css" />
</head>

<body>
               <div>
                <input type="hidden" id="AppId" value="<%=AppId_web%>">
                <input type="hidden" id="AppKey" value="<%=AppKey_web%>">
                <input type="hidden" id="Spc_token" value="<%=Spc_token%>">
                <input type="hidden" id="Suid" value="<%=Suid%>">
                <input type="hidden" id="uuid" value="<%=uuid%>">
              </div>
    <div class="center_box">
        <div id="logo_img">
            <img src="images/1_r1_c2.jpg">
        </div>
        <ul id="navbar">
            <li><a href="#">首页</a></li>            
            <li><a href="#">学院领导</a></li>
            <li><a href="#">文件查阅</a></li>
            <li><a href="#">数据发布</a></li>
            <li><a href="#">电话查询</a></li>            
            <li><a href="#">每周工作安排</a></li>            
            <li><a href="#">院长接待日安排</a></li>
        </ul>
        <div id="article">
            <div class="news">
                <h1></h1>
                <h2></h2>
                <div class="text">
                    <div class="text_inner">
                        <span id="xinxi"></span>
                        <h1></h1>
                           <p id="text">为了进一步行政执法风险是指在执法过程中，因人为或客观原因给执法对象和社会造成损失、危害而被纪检监察、司法部门追究责任的风险。包括党纪政纪风险、行政赔偿风险、刑事责任风险。<br />我局行政执法风险主要来自两个方面，一是败诉、败议的风险，二是纪检监察部门、检察院责任追究的风险。<br />败诉、败议主要源自于不具备执法主体资格、无法定依据、执法程序错误、相关证据的无效、不足、失真及未按法律规定实施行政强制措施。发生败诉、败议，行政机关将追究相关人员的责任；涉及赔偿的，将按法律规定承担部分或者全部赔偿费用。<br />纪检监察部门、检察院责任追究包括：1、对企业的违法行为未及时发现、未及时查处或不认真查处的，将追究行政不作为、乱作为责任或追究滥用职权罪、玩忽职守罪；2、对不应处罚而予以行政处罚的，将按《黑龙江省损害发展环境行政行为责任追究办法》追究责任。<br />为有效防控行政执法风险，要求如下：<br />1、行政执法必须依法执法、依法办案；严禁违法实施罚款、责令停产停业、没收财物等；<br />2、实施行政处罚必须以事实为依据，严格按法定程序查办案件；<br />3、调查取证必须全面、真实、有效；<br />4、行政处罚必须与违法行为事实、性质、情节和社会危害程度相当，避免滥用自由裁量权；<br />5、必须按规定处理罚没和扣押的财物；<br />6、严禁违法采取查封（扣押）场所（财物）行政强制措施；
                           <img src="images/20171120151849-3.jpg"/></p>
                        
                    </div>
                </div>
                 <div id="logo">相关文件
                 </div>
                 <div id="copyright_box">Copyright  2005 黑龙江司法警官职业学院办公室 All Right Reserved</div>
                
            </div>
        </div>
       
    </div>
    <script type="text/javascript" src="js/jquery-1.11.1.min.js"></script>
<script type="text/javascript" src="js/jquery-1.11.1.min.js"></script>

		<script type="text/javascript" src="../../../custom/jquery.min.js"></script>
		<script type="text/javascript" src="../../js/layui/layui.js"></script>
		<script src="../../../pages/js/layui/layui.js"></script>
	  <script>
	  //basepath获取服务器根目录
	    var curWwwPath = window.document.location.href;
	    var pathName = window.document.location.pathname;
	    var pos = curWwwPath.indexOf(pathName);
	    var localhostPath = curWwwPath.substring(0, pos);
	    var projectName = pathName.substring(0, pathName.substr(1).indexOf('/') + 1);
	    var basePath=localhostPath+projectName+"/";
	  var AppId=$("#AppId").val();
	  var AppKey=$("#AppKey").val();
	  var Spc_token=$("#Spc_token").val();
	  var Suid=$("#Suid").val();
	  var uuid=$("#uuid").val();
      var Purl=basePath+"/Api/v1/?p=web/cms/articles/selectArticlesById";
     var strvalue={
    	     "id" : "<%=request.getParameter("id")%>"
    	    }
 	 $.ajax( {
 		// 提交数据的类型 POST GET
 		type : "POST",
 		// 提交的网址
 		url : Purl,
 		// 提交的数据
 		data : JSON.stringify(strvalue),
 		// 返回数据的格式
 		async : false,//不是同步的话 返回值娶不到
 		datatype : "json",// "xml", "html", "script", "json", "jsonp",
 		// "text".
 		// 成功返回之后调用的函数
 		success : function(data){	
 		      jsonData=eval("("+data+")");   
 		      $("h1").text( jsonData.threads[0].title);  
 		     $("h1").css("color",jsonData.threads[0].titlecolor);          
 		      $("h2").html("文章来源："+jsonData.threads[0].source+"&nbsp;&nbsp;发文责任人："+jsonData.threads[0].responsibility+"&nbsp;&nbsp;文章录入:"+jsonData.threads[0].author+"    日期："+jsonData.threads[0].addtime+" &nbsp;&nbsp;阅读次数："+jsonData.threads[0].hits);
 		     var str=jsonData.threads[0].addtime;
 		     var strs= new Array(); 
 		     var stra="";
              strs=str.split("-"); 
              for(i=0;i<strs.length;i++){
                    stra+=strs[i];
                 }
 		      $("#xinxi").html("信息公开编号:12728-"+jsonData.threads[0].department+"-"+stra+"-"+jsonData.threads[0].num+"-"+jsonData.threads[0].range+"-"+jsonData.threads[0].attribute);
 		      var texts=(jsonData.threads[0]).text;

 		      $("#text").html(texts);
 		      var arr=jsonData.threads[0].attachment;
 		     for(var keys in arr){
 		      var path;
 		     
 		      path=localhostPath+arr[keys];
 		      $("#logo").append(`<a href="`+path+`" target="_blank" download="`+keys+`">`+keys+`</a>`)}
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