<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*,java.io.*" %>
<%@page import="java.util.Date"%>
<%@ include file="../../cookie.jsp"%> 
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="org.apache.commons.fileupload.*" %>
<%@ page import="org.apache.commons.fileupload.disk.*" %>
<%@ page import="org.apache.commons.fileupload.servlet.*" %>
<%@ page import="org.json.simple.*" %>
<script type="text/javascript" src="../../../custom/jquery.min.js"></script>
<%
 System.out.println("edit_upload_json.jsp");

//文件保存目录路径
String savePath = pageContext.getServletContext().getRealPath("/") + "a/web/images/";

String depth=null;
String sort=null;
String fid=null;
String author=null;
String imgsurl=null;
String id=null;
String releasepeople=null;
String auditperson=null;
int abc=0;
//文件保存目录URL
String saveUrl  = request.getContextPath() + "/a/web/images/";

System.out.println(savePath);
System.out.println(savePath);

//定义允许上传的文件扩展名
HashMap<String, String> extMap = new HashMap<String, String>();
extMap.put("image", "gif,jpg,jpeg,png,bmp");
extMap.put("flash", "swf,flv");
extMap.put("media", "swf,flv,mp3,wav,wma,wmv,mid,avi,mpg,asf,rm,rmvb");
extMap.put("file", "doc,docx,xls,xlsx,ppt,htm,html,txt,zip,rar,gz,bz2");

//最大文件大小
long maxSize = 10000000*600; //1MB

response.setContentType("text/html; charset=UTF-8");

if(!ServletFileUpload.isMultipartContent(request)){
	out.println(getError("请选择文件。"));
	return;
}
//检查目录
File uploadDir = new File(savePath);
if(!uploadDir.isDirectory()){
	out.println(getError("上传目录不存在。"));
	return;
}
//检查目录写权限
if(!uploadDir.canWrite()){
	out.println(getError("上传目录没有写权限。"));
	return;
}

String dirName = request.getParameter("dir");

if (dirName == null) {
	dirName = "image";
}
if(!extMap.containsKey(dirName)){
	out.println(getError("目录名不正确。"));
	return;
}
//创建文件夹
savePath += dirName + "/";
saveUrl += dirName + "/";
File saveDirFile = new File(savePath);
if (!saveDirFile.exists()) {
	saveDirFile.mkdirs();
}
SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
String ymd = sdf.format(new Date());
savePath += ymd + "/";
saveUrl += ymd + "/";
File dirFile = new File(savePath);
if (!dirFile.exists()) {
	dirFile.mkdirs();
}
FileItemFactory factory = new DiskFileItemFactory();
ServletFileUpload upload = new ServletFileUpload(factory);
upload.setHeaderEncoding("UTF-8");
List items = upload.parseRequest(request);
Iterator itr = items.iterator();
while (itr.hasNext()) {
	FileItem item = (FileItem) itr.next();
	
	String fileName = item.getName();
	System.out.println("filename===="+fileName);
	long fileSize = item.getSize();
	if (!item.isFormField()) {
		//检查文件大小
		if(item.getSize() > maxSize){
			out.println(getError("上传文件大小超过限制。"));
			return;
		}
		//检查扩展名
		String fileExt = fileName.substring(fileName.lastIndexOf(".") + 1).toLowerCase();
		if(!Arrays.<String>asList(extMap.get(dirName).split(",")).contains(fileExt)){
			//out.println(getError("上传文件扩展名是不允许的扩展名。\n只允许" + extMap.get(dirName) + "格式。"));
			//return;
			abc=1;
		}
  if(abc!=1){
	  System.out.println("*******"+abc);
		SimpleDateFormat df = new SimpleDateFormat("yyyyMMddHHmmss");
		String newFileName = df.format(new Date()) + "_" + new Random().nextInt(1000) + "." + fileExt;
		try{
			
			//图片
			File uploadedFile = new File(savePath, newFileName);
			imgsurl="a/web/images/"+dirName + "/"+ymd + "/"+newFileName;
			//System.out.print(imgsurl);
			//db.executeUpdate("INSERT INTO `cms_class`(`imgsurl`) VALUES ('"+imgsurl+"');"); 
			item.write(uploadedFile);
		}catch(Exception e){
			out.println(getError("上传文件失败。"));
			return;
		}

		JSONObject obj = new JSONObject();
		obj.put("error", 0);
		obj.put("url", saveUrl + newFileName);
		out.println(obj.toJSONString());
  }
	}else{
		try {  
            if("sort".equals(item.getFieldName())) {  
              sort = item.getString("UTF-8").trim();  
                 //  System.out.println(sort);  
            }  
            else if("depth".equals(item.getFieldName())) {  
                 depth = item.getString("UTF-8").trim();  
                     // System.out.println("sgebgdu:"+depth);  
               }  
            else if("fid".equals(item.getFieldName())) {  
                 fid = item.getString("UTF-8").trim();  
                     // System.out.println("fu:"+fid);  
               }  
            else if("author".equals(item.getFieldName())) {  
                 author = item.getString("UTF-8").trim();  
                     // System.out.println(author);  
               }
            else if("id".equals(item.getFieldName())) {  
                id = item.getString("UTF-8").trim();  
                    // System.out.println(author);  
              }
            else if("imgsurl".equals(item.getFieldName())) {  
            	imgsurl = item.getString("UTF-8").trim();  
                    System.out.println(imgsurl);  
              }
            else if("releasepeople".equals(item.getFieldName())) {  
           	 releasepeople = item.getString("UTF-8").trim();  
                     
              }
            else if("auditperson".equals(item.getFieldName())) {  
           	 auditperson = item.getString("UTF-8").trim();  
                      
              }
          }catch (NumberFormatException e) {  
            e.printStackTrace();  
            return;  
        }
     
	}
}
%>
  <script>
		 //basepath获取服务器根目录
	    var curWwwPath = window.document.location.href;
	    var pathName = window.document.location.pathname;
	    var pos = curWwwPath.indexOf(pathName);
	    var localhostPath = curWwwPath.substring(0, pos);
	    var projectName = pathName.substring(0, pathName.substr(1).indexOf('/') + 1);
	    var basePath=localhostPath+projectName+"/";

			  var Purl=basePath+"/Api/v1/?p=web/cms/classify/editClassify";
		  
			     var strvalue={
					     "id":<%=id%>,
					     "depth": "<%=depth%>",
					     "fid": "<%=fid%>",
					     "sort": "<%=sort%>",
					     "name": "<%=author%>",
					     "imgsurl":"<%=imgsurl%>",
					     "releasepeople":"<%=releasepeople%>",
						 "auditperson":"<%=auditperson%>"
					  };
		 PostApi(JSON.stringify(strvalue));
	
		  function PostApi(strvalue)// 发送数据
		   {   
			  var index = parent.layer.getFrameIndex(window.name); 
			
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
				 jsonData=eval("("+data+")");  
			       if(jsonData.resultCode==404){
			    	   parent.layer.msg('添加 失败，请将信息填全');
				     }else{				    	   
				    	   parent.layer.msg('编辑 成功');
						   parent.layer.close(index);
					    }
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
			  return true;

		 }
	</script> 
<%!
private String getError(String message) {
	JSONObject obj = new JSONObject();
	obj.put("error", 1);
	obj.put("message", message);
	return obj.toJSONString();
}
%>
<%if(db!=null)db.close();db=null;if(server!=null)server=null;%>