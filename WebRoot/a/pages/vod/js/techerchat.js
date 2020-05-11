$(window).bind('beforeunload', function() {// 监听用户在线状态
	//var pid = document.getElementById("teacherIds").value;
	//var jsonstr = "{\'c\':\'mobh5\',\'m\':\'chat\',\'pid\':\'"+pid+"\',\'page\':\'chatout\'}";
          // PostJsonAjx(jsonstr);	//我走了告诉服务器一声	
		});
 

function getstudentlist() // 得到在线学生数据
{    
    var liveid = document.getElementById("liveid").value;
     PostJsonAjx('',1,'../../vod/chatac/studentlist.jsp?id='+liveid);

}

function chatstat(stuname,stuno) // 点击左边学生赋值给右面
{    
   //alert(stuname+stuno);
   document.getElementById("stuname").value=stuname;
   document.getElementById("stuno").value=stuno;
    document.getElementById("chat_title").innerHTML="正在与 <b>"+stuname+ "</b> 沟通";
    layer.tips('你选择了与 '+stuname+' 沟通', '#chat_title', {
		  tips: [4, '#78BA32']
	 	});
    $("#duihualit").remove();
    getchat();
    getstudentlist();
    loadedriht();
}


function addchat() // 发送数据
{   
	var tid = document.getElementById("tid").value;
    var stuno = document.getElementById("stuno").value;
	var saytext = document.getElementById("saytext").value;
	var teachername = document.getElementById("teachername").value;
	var timg = document.getElementById("timg").value;
	if(stuno.indexOf("没有选择")!=-1){
		newmsg('你至少要选择一个学生', '#studentlist');
	  layer.tips('你至少要到左边要选择一个学生', '#saytext', {
		  tips: [4, '#FF0000']
	 	});
	  return;}
	//saytext = replace_em();
	
	Httpmsg("<dl><dt class=\'lt\'><p class=\'name\' style=\"text-align:right;\">"+teachername+" &nbsp;</p><p class=\'time\'>"+getNowFormatDate()+"</p><p>"+saytext+"</p></dt><dd class=\'lt\'><img src=\'"+timg+"\'></dd></dl>"); //先写到用户界面上
	 
	 var jsonstr = "{\'c\':\'mobh5\',\'m\':\'techchat\',\'tid\':\'"+tid+"\',\'pid\':\'"+stuno+"\',\'page\':\'addchat\',\'pstr\':\'"
	 	+ saytext + "\'}";
	 document.getElementById("saytext").value = "";
	 getstudentlist();
    PostJsonAjx(jsonstr,0,'../apiv1');
    loadedriht();
    $('#wrapper').scrollTop($('#wrapper')[0].scrollHeight);// 重点让焦点最下

}

function getchat() // 得到数据
{    
	var tid = document.getElementById("tid").value;
    var stuno = document.getElementById("stuno").value;
	var saytext = document.getElementById("saytext").value;
	var jsonstr = "{\'c\':\'mobh5\',\'m\':\'techchat\',\'tid\':\'"+tid+"\',\'pid\':\'"+stuno+"\',\'page\':\'getchat\',\'pstr\':\'"
			+ saytext + "\'}";
	if(stuno.indexOf("没有选择")!=-1){  return;}
	PostJsonAjx(jsonstr,0,'../apiv1');
	loadedriht();
}

function HttpConnection() {
	getstudentlist();
	getchat();
	setTimeout("HttpConnection()", 5000); // 定时器
 
}

function Httpmsg(msg) {
  $("ol").append(msg);
  

}

 
 

function PostJsonAjx(jsonstr,tagid,url) // 发送数据
{   //tagid=1  获取在线  //tagid=0 聊天
	var UUID ="laosih";
	var USERID ="0";
	var NetMode = "pc-wifi-net";
	$.ajax( {
		// 提交数据的类型 POST GET
		type : "POST",
		// 提交的网址
		url : url,
		// 提交的数据
		data : jsonstr,
		// 返回数据的格式
		datatype : "html",// "xml", "html", "script", "json", "jsonp",
		// "text".
		// 成功返回之后调用的函数
		success : function(data) {
			$("#msg").html(decodeURI(data));
		},
		headers : {
			"Content-type" : "application/json",
			"X-AppId" : "aec9fcfec1a6530d24529948de247aeb",
			"X-AppKey" : "a9cfb03695de0eec5301cffefafbcb53",
			"X-USERID" : USERID,
			"X-UUID" : UUID,
			"X-NetMode" : NetMode,
			"X-Mdels" : "web-admin-chat"
		},
		// 调用执行后调用的函数
		complete : function(XMLHttpRequest, textStatus) {
			// layer.closeAll();
		if (textStatus == "success") {
			//var msg = msg_em(XMLHttpRequest.responseText);
		   // alert(XMLHttpRequest.responseText);
			if(tagid==1){
			document.getElementById("studentlist").innerHTML =XMLHttpRequest.responseText;
			}
			if(tagid==0){
				Httpmsg(XMLHttpRequest.responseText);
				  //alert($('#wrapper')[0].scrollHeight);
				  loadedriht();
				  $('#wrapper').scrollTop($('#wrapper')[0].scrollHeight);// 重点让焦点最下
				}
			//if(msg.length>0){ //如过有最新消息就执行添加到用户手机上
			 
				//Httpmsg(msg);
			   
			 
			//}
			
		} else {
			//Httpmsg("<li class=\'even\'><span>系统消息：</span>网络故障发送超时。</li>");
		 }
	},
	// 调用出错执行的函数
		error : function() {
		   Httpmsg("<li class=\'even\'><span>系统消息：</span>网络故障与服务器失去联系，请重进教室。</li>");
		 
		}
	});

}

// 键盘事件
document.onkeydown = function(event) {
	var e = event || window.event || arguments.callee.caller.arguments[0];
	if (e && e.keyCode == 27) { // 按 Esc
		document.getElementById("saytext").value = "";
	}
	if (e && e.keyCode == 113) { // 按 F2
		// 要做的事情
	}
	if (e && e.keyCode == 13) { // enter 键
		addchat();
	}
};
//时间
function getNowFormatDate() {
    var date = new Date();
    var seperator1 = "-";
    var seperator2 = ":";
    var month = date.getMonth() + 1;
    var strDate = date.getDate();
    if (month >= 1 && month <= 9) {
        month = "0" + month;
    }
    if (strDate >= 0 && strDate <= 9) {
        strDate = "0" + strDate;
    }
    var currentdate = date.getFullYear() + seperator1 + month + seperator1 + strDate
            + " " + date.getHours() + seperator2 + date.getMinutes()
            + seperator2 + date.getSeconds();
    return currentdate;
}
