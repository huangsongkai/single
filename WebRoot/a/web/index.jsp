<%@ page trimDirectiveWhitespaces="true" %>
<%@ page language="java" import="java.io.*,java.util.*" pageEncoding="UTF-8"%>
<%
String msg=request.getParameter("msg"); if(msg==null){msg="";}
Cookie[] Rcookies = request.getCookies();
 // 遍历数组,获得具体的Cookie
    if(Rcookies!=null) {
         for(int i=0; i<Rcookies.length; i++) {
            Rcookies[i].setMaxAge(0);  
          //response.addCookie(Rcookies[i]); 
         }
     } 
%>
<!DOCTYPE html> 
<html lang="en"> 
	<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>黑龙江司法警官职业学院办公网</title>
    <link href="css/style.css" rel="stylesheet" type="text/css" />
</head>
	
	<body>
    <div class="center_box">
        <div id="logo_img">
            <img src="images/images1-1.jpg">
        </div>
        <ul id="navbar">
            <li><a href="#">首页</a></li>
            <li><a href="#">学院概况</a></li>
            <li><a href="#">学院领导</a></li>
            <li><a href="#">数据发布</a></li>
            <li><a href="#">大事记</a></li>
            <li><a href="#">文件查阅</a></li>
            <li><a href="#">规章制度</a></li>
            <li><a href="#">电话查询</a></li>
            <li><a href="#">常用表格下载</a></li>
            <li><a href="#">办公信箱</a></li>
        </ul>
        <ul id="news_box">
   
        </ul>
        <div id="link_box">
            <ul class="link_top">
                <li><a href="#"><img src="images/tushuguan.png" /></a></li>
                <li><a href="#"><img src="images/xinsheng.png" /></a></li>
                <li><a href="#"><img src="images/sifating.png" /></a></li>
                <li><a href="#"><img src="images/home_02.png" /></a></li>
                <li><a href="#"><img src="images/xinli.png" /></a></li>
                <li><a href="#"><img src="images/jiaowu.png" /></a></li>
            </ul>
            <ul class="link_bottom">
                <li><a href="#">书记信箱<br/>benlee2004@vip.163.com</a></li>
                <li><a href="#">院长信箱<br/>sftwanglang@126.com</a></li>
                <li><a href="#">办公室主任信箱<br/>zqx678@163.com</a></li>
                <li><a href="#">办公室信箱<br/>88079849@163.com</a></li>
                <li><a href="#">纪检信箱<br/>jw88079143@163.com</a></li>
            </ul>
        </div>
        <div id="copyright_box">Copyright © 2017 www.hljsfjy.org.cn 版权所有   黑ICP备12000865号
</div>
    </div>
    <script type="text/javascript" src="js/jquery-1.11.1.min.js"></script>
<script type="text/javascript">
//basepath获取服务器根目录
var curWwwPath = window.document.location.href;
var pathName = window.document.location.pathname;
var pos = curWwwPath.indexOf(pathName);
var localhostPath = curWwwPath.substring(0, pos);
var projectName = pathName.substring(0, pathName.substr(1).indexOf('/') + 1);
 var basePath=localhostPath+projectName+"/";
window.onload=function(){
    //兼容样式
    $('.list_bottom li:last-child').css('border-bottom','none');
    $('.link_bottom li:last-child').css('border-right','none');
     //ajax请求数据
     //导航栏
     var inner="";
	  var inn="";
	//跳到详情页面
    var str={
    		"bu":"不需要数据"
    	    }
    $.ajax({
 		// 提交数据的类型 POST GET
 		type : "POST",
 		// 提交的网址
 		url : basePath+"/Api/v1/?p=web/cms/classify/selectClassifyToDao",
 		// 提交的数据
 		data : JSON.stringify(str),
 		// 返回数据的格式
 		async : false,//不是同步的话 返回值娶不到
 		datatype : "json",// "xml", "html", "script", "json", "jsonp",
 		// "text"
 		// 成功返回之后调用的函数
 		success : function(data) {		  
 		       jsonData=eval("("+data+")");  
 		       for(var i=0;i<jsonData.threads.length;i++){
 		    	   var obj= jsonData.threads[i];
 		    	      for(var key in  obj){    
	 		    	       var arr=  obj[key];
	 	   for(var j=0;j< arr.length;j++){
		 	  
	 		  inner+=`<li>
	            <div style="border:1px solid #afc8da;height:210px">
	 		     <div class="news_list">
                  <div class="list_top">
                      <div class="list_left" style="background:url(`+basePath+arr[j].imgsurl+`) no-repeat 5px center;">
                          <ul class="subnav">`
   	    	      var arrs=arr[j];
   	    	  
   	    	       inn="";
   	    	       var a=0;
   	    	       var b=0;	
   	    	       var c=0;
	    	      for(var keys in arrs )
	    	      {     
		    	      if(c==0){		    	    	  
		    	    	  c=1; 
			    	      continue;
			    	      };
			    	  //每个栏目列表
		    	      he(arrs[keys],b);
		    	      //默认显示第一个栏目
		    	      if(a==0){
	    	          inner+= `<li class="active">`+keys+`</li>`}
		    	      else{
		    	      inner+= `<li>`+keys+`</li>`
			    	      } 
		    	      a=1; 
		    	      b=1;  	    
	    	      }
               }        
	 	   inner+= `</ul>
                        </div>
                        <div class="list_right"></div>
                    </div>`
        
          inner+=inn;
          inner+=`</div></div></li> `	    	        	     
 		    	       }
              }
             inner+=`<div class="clear_box"></div>`;
 		    $('#news_box').prepend(inner);
        },
 		 headers : {
 			"Content-type" : "application/json",
 			"X-AppId" : "8381b915c90c615d66045e54900feeab",
 			"X-AppKey" : "d4df770ef73bd57653b0af59934296ee",
<%-- 			"Token" : "a1c745a9fbe65e12e1c12594dcfd4568",--%>
<%-- 			"X-USERID": "37",--%>
 			"X-UUID": "000000000000000000000000",
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
    function he(id,index){
		 var strvalue={
		 		 "id": id,
	    	     "page":"1", 
	    	     "listnum": "10"
	    	    }
		
	 	 $.ajax( {
	 		// 提交数据的类型 POST GET
	 		type : "POST",
	 		// 提交的网址
	 		url : basePath+"/Api/v1/?p=web/cms/articles/selectArticlesName",
	 		// 提交的数据
	 		data : JSON.stringify(strvalue),
	 		// 返回数据的格式
	 		async : false,//不是同步的话 返回值娶不到
	 		datatype : "json",// "xml", "html", "script", "json", "jsonp",
	 		// "text"
	 		// 成功返回之后调用的函数
	 		success : function(data) {
	 		      var  jsonData=eval("("+data+")");
	 		     
	 		     if(index==0){
	 		          inn+=`<ul class="list_bottom">`
	 		          }else{
	 		    	  inn+=`<ul class="list_bottom" style="display:none;">`
		 		      }  
	 		     for(var i=0;i<jsonData.threads.length;i++){

	 		    	  var nowtime=new Date();
		 		      var bigtime=new Date(Date.parse(jsonData.threads[i].addtime)); 
		 		      var endtime=new Date(Date.parse(jsonData.threads[i].endtime));
		 		     //发布时间大于等于现在时间并且现在时间 小于截止日期
		 		     if(bigtime<=nowtime&&nowtime<=endtime){
			 		     	 		           
	 		    	  inn+=`<li><a href="javascript:look(`+jsonData.threads[i].id+`)"  style='width:73%'>`+jsonData.threads[i].title+`</a> <span style="width:25%">`+jsonData.threads[i].addtime+`</span></li>`;		     
		 		     }
	 		      }
	 		    inn+=`</ul>`;
	 		   },
	 		 headers : {
	 				"Content-type" : "application/json",
	 	 			"X-AppId" : "8381b915c90c615d66045e54900feeab",
	 	 			"X-AppKey" : "d4df770ef73bd57653b0af59934296ee",
	 	 			"Token" : "a1c745a9fbe65e12e1c12594dcfd4568",
	 	 			"X-USERID": "37",
	 	 			"X-UUID": "000000000000000000000000",
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

     //Tap切换
   
    $('.subnav li').click(function(event) {
        $(this).siblings("li").removeClass('active');
        $(this).addClass('active');
        $(this).parents('.news_list').find('.list_bottom').css('display','none');
        var index = $(this).index();
        $(this).parents('.news_list').find('.list_bottom')[index].style.display = 'block';

    });
    
}

function look(id){
	
	  var toUrl =basePath+'a/web/particulars.jsp?id='+id ;
	 
      window.open(toUrl);
    
}
</script>
</body>
</html>

 
 

