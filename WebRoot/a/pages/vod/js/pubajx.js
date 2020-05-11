//vod list 页面调用
  



function PubAtion(userid,Postjson,Repdivid,action) {
	
	var  studenlist_y=document.getElementById(Repdivid).value;
 
	
	var xmlhttp;
	if (window.XMLHttpRequest) {
		xmlhttp = new XMLHttpRequest()
	} else {
		xmlhttp = new ActiveXObject("Microsoft.XMLHTTP")
	}
	xmlhttp.onreadystatechange = function() {
		if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
			
			if(action.indexOf("累加")!=-1){  
			 
		    document.getElementById(Repdivid).value =xmlhttp.responseText+"\r\n"+studenlist_y;
		    hangshu();
			}else{
				//新加替换
			   document.getElementById(Repdivid).value =xmlhttp.responseText;
			   hangshu();
			}
		  
		} 
	}
	xmlhttp.open("POST", "../../../../Api/v1/?p=web/vod/GetStudenList", true);
	xmlhttp.setRequestHeader("Content-type","application/json");
	xmlhttp.setRequestHeader("X-AppId","8381b915c90c615d66045e54900feeab");
	xmlhttp.setRequestHeader("X-AppKey","d4df770ef73bd57653b0af59934296ee");
	xmlhttp.setRequestHeader("X-USERID",userid);
	xmlhttp.setRequestHeader("X-UUID",document.getElementById("X-UUID").value);
	xmlhttp.setRequestHeader("Token",document.getElementById("Token").value);
	xmlhttp.setRequestHeader("X-NetMode",document.getElementById("X-NetMode").value);
    xmlhttp.setRequestHeader("X-Mdels","pc-admin-h5")
	xmlhttp.send(Postjson); //发送
   //alert("send Postjson:"+Postjson);
 
}
 




 