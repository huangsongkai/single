//封装Ajax请求数据函数
function PostAjx(Purl,strvalue,uid,token)// 发送数据
{   
	 var backdata; 
	$.ajax({
		// 提交数据的类型 POST GET
		type : "POST",
		// 提交的网址
		url : Purl,
		// 提交的数据
		data : strvalue,
		// 返回数据的格式
		async : false,//不是同步的话 返回值娶不到
		datatype : "json",// "xml", "html", "script", "json", "jsonp",
		// "text".
		// 成功返回之后调用的函数
		success : function(data,status) {
		    backdata=data;
		    
		},
		complete : function(XMLHttpRequest, textStatus) {//调用执行后调用的函数
			 if (textStatus == "success") {
				  //$("#msg").html(XMLHttpReques.=XMLHttpRequest.responseText;);
				  //alert(data1);
			 }
		},
		error : function() {// 调用出错执行的函数
			 
			backdata="系统消息：网络故障与服务器失去联系";
		},
	    headers : {
            "X-USERID":""+uid+"",
            "Content-Type":"multipart/form-data",
            "X-AppId":"8381b915c90c615d66045e54900feeab",// 标明正在运行的是哪个App程序
	        "X-AppKey":"72393aaa69c41a24d0d40e851301647a",// 授权鉴定终端
            "Token":""+token+"",// 授权鉴定终端
            "X-UUID":"pc",
            "X-Mdels":"pc",
	    }
	});
	  return backdata;
}

//封装Ajax请求数据函数，无Content-Type
function PostAjxNo(Purl,strvalue,uid,token)// 发送数据
{   
	 var backdata; 
	$.ajax({
		// 提交数据的类型 POST GET
		type : "POST",
		// 提交的网址
		url : Purl,
		// 提交的数据
		data : strvalue,
		// 返回数据的格式
		async : false,//不是同步的话 返回值娶不到
		datatype : "json",// "xml", "html", "script", "json", "jsonp",
		// "text".
		// 成功返回之后调用的函数
		success : function(data,status) {
		    backdata=data;
		    
		},
		complete : function(XMLHttpRequest, textStatus) {//调用执行后调用的函数
			 if (textStatus == "success") {
				  //$("#msg").html(XMLHttpReques.=XMLHttpRequest.responseText;);
				  //alert(data1);
			 }
		},
		error : function() {// 调用出错执行的函数
			 
			backdata="系统消息：网络故障与服务器失去联系";
		},
	    headers : {
            "X-USERID":""+uid+"",
            "X-AppId":"8381b915c90c615d66045e54900feeab",// 标明正在运行的是哪个App程序
	        "X-AppKey":"72393aaa69c41a24d0d40e851301647a",// 授权鉴定终端
            "Token":""+token+"",// 授权鉴定终端
            "X-UUID":"pc",
            "X-Mdels":"pc",
	    }
	});
	  return backdata;
}





