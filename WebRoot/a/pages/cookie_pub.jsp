<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<% //不需要权限的公共模块比如上次组件等，只需要判断是否登录。
 String path = request.getContextPath();
 String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path;
 String jspath = basePath+"/a";
 String AppId_web = "8381b915c90c615d66045e54900feeab";
 String AppKey_web = "d4df770ef73bd57653b0af59934296ee";
   
	//获取当前请求jsp文件名
	String URLS=request.getRequestURI();
	String jspname="";
  
	String SYSname="黑龙江司法警官学院教务管理系统";
	
	String Susermob="",Suserkey="",SmarkKey="",Sworkspace="",Suserole="";
	Cookie[] Rcookies = request.getCookies();
	if(Rcookies!=null){
         for(int i=0; i<Rcookies.length; i++){
            Cookie Rcookie = Rcookies[i];
            String name = Rcookie.getName();
            String value = Rcookie.getValue();
			if(name.equals("hljsfiy@usermob")){  Susermob = value;}  
            if(name.equals("hljsfiy@userkey")){  Suserkey = value;}  
			if(name.equals("hljsfiy@markKey")){  SmarkKey = value;}  
			if(name.equals("hljsfiy@userole")){  Suserole = value;}  
         }
     } 

	if(Susermob==null || Suserkey==null || Suserole==null|| Suserkey.length()!=32){ 
		out.print("无权限");
		return;
	}
	
	 
%>
 