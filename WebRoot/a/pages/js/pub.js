  function PostpcApi(Purl,AppId,AppKey,token,strvalue,userid,uuid)// 发送数据
   {   
	  
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
		   
		    $("#msg").html(decodeURI(data));
		    backdata=data;
		   
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
  $(".supplier").click(function(){
    var mob=document.getElementById("mob").value;
    var password=document.getElementById("password").value;
    var randcode=document.getElementById("randcode").value;
   
   // if(mob.length!=11){
    //  $("#error-info").html("手机格式不对");
    //  $("#alert-error").show();
    //  return;
    // }
    
    if(password.length<=4){
        $("#error-info").html("密码没有填写");
        $("#alert-error").show();
        return;
       }
    if(randcode.length!=4){
        $("#error-info").html("请填写4位验证码");
        $("#alert-error").show();
        return;
       }

   var Purl="login.jsp";
   var AppId="d42b46df6e583ca9a1b3e819dc42cfak";
   var AppKey="23548ad081d91ca0bdc66b22ca59cfc6";
   var token="login";
   var strvalue="{\"mob\":\""+mob+"\",\"password\":\""+password+"\",\"randcode\":\""+randcode+"\"}";
   var datapc =PostpcApi(Purl,AppId,AppKey,token,strvalue);
     
   if(datapc.indexOf("错误")!=-1){
	    $("#error-info").html(datapc);
	    $("#alert-error").fadeIn();
	    document.getElementById("randImage").src ="jsproot/randImage.jsp?"+Math.random();
	    return;
   }
   if(datapc=="success"){
	
	    $("#purchaser").html("登录中...");

	    location.href="main.jsp?jssonid="+Math.random()*9389473245+Math.random();
	    return;
  }
    
   });

  
$("#randImage").click(function(){ //验证码
  document.getElementById("randImage").src ="jsproot/randImage.jsp?"+Math.random();
});

function hiddenerr(){
	  $("#error-info").html("错误提示");
	  $("#alert-error").fadeOut("slow");
}

function fanhui(url){
	window.location.replace(url);
}
  
  
  
 