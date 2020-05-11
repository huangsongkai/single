<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.text.DecimalFormat"%>
<%@ page import="v1.haocheok.commom.entity.UserEntity"%>
<%@ page language="java" import="java.util.regex.*"%>
<jsp:useBean id="db" scope="page" class="service.dao.db.Jdbc"/>
<jsp:useBean id="server" scope="page" class="service.dao.db.Page"/>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core_rt" %>
<%
 String path = request.getContextPath();
 String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path;
 String jspath = basePath+"/a";
 String AppId_web = "8381b915c90c615d66045e54900feeab";
 String AppKey_web = "d4df770ef73bd57653b0af59934296ee";
 String uuid= "000000000000000000000000";
 long TimeStart = Calendar.getInstance().getTimeInMillis();
%>   
<%  
	//获取当前请求jsp文件名
	String URLS=request.getRequestURI();
	String jspname="";
	for(int namei=0;namei<URLS.split("/").length;namei++){jspname=URLS.split("/")[namei];}
		
	String ac = request.getParameter("ac"); if(ac==null){ac="";}//获取文件后面的对象 数据	
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
     //if(Susermob==null || Suserkey==null || Susermob.length()!=11 || Suserkey.length()!=32){ 
     if(Susermob==null || Suserkey==null || Suserkey.length()!=32||Suserole==null){ 
		response.sendRedirect("index.jsp?msg=登录超时！");
		if(db!=null)db.close();db=null;if(server!=null)server=null;
		return;
	}	
	 //得出传递过来的PMenuId 去系统找到该模块
    String PMenuId="",Sleftshow="",Sshowstate="", Mokuai="",menutxt="",apiurl="";  
    String modular_sql="SELECT id,leftshow,showstate,menuname,menutxt,apiurl FROM menu_sys WHERE  menulink LIKE '%"+jspname+"%'; ";
     
    ResultSet menuSyst=db.executeQuery(modular_sql);  
      if(menuSyst.next()){ 
    	  PMenuId=menuSyst.getString("id"); //权限id
          Sleftshow=menuSyst.getString("leftshow"); //左边是否显示
          Sshowstate=menuSyst.getString("showstate"); //右面是否显示
          Mokuai=menuSyst.getString("menuname"); //菜单名
		  menutxt=menuSyst.getString("menutxt"); //菜单说明
		  apiurl=menuSyst.getString("apiurl"); //api地址
	  }if(menuSyst!=null)menuSyst.close(); 
  
	  System.out.println("当前的文件名PMenuId==="+PMenuId);
	  System.out.println("当前的文件名jspname==="+jspname);

 	//取出用户名
 	//String Suserinfo="SELECT uid,nickname,workspace,email,headimgurl,username,powerid,remarks,companyname,companyid,UserDepartment,UserDepartmentid,pc_token,app_token,regionalcode,zk_role.rolecode as rolecode,zk_role.name as rolename,zk_role.id as roleid FROM  user_worker,zk_user_role,zk_role  WHERE user_worker.uid = zk_user_role.sys_user_id AND zk_user_role.sys_role_id = zk_role.id AND usermob='"+Susermob+"'";
 	String Suserinfo ="SELECT                                                            "+
								 "		uid,                                             "+
								 "		nickname,                                        "+
								 "		workspace,                                       "+
								 "		t.email,                                           "+
								 "		headimgurl,                                      "+
								 "		username,                                        "+
								 "		powerid,                                         "+
								 "		remarks,                                         "+
								 "		companyname,                                     "+
								 "		companyid,                                       "+
								 "		UserDepartment,                                  "+
								 "		UserDepartmentid,                                "+
								 "		pc_token,                                        "+
								 "		app_token,                                       "+
								 "		user_association,                                       "+
								 "		regionalcode                                    "+
								 "	FROM                                                 "+
								 "		user_worker t                              "+
								 "		LEFT JOIN zk_user_role t2 ON t.uid = t2.sys_user_id                              "+
								 "		LEFT JOIN zk_role t3 ON t2.sys_role_id = t3.id                                     ";
							
 	if(Suserole.equals("1")){
		Suserinfo = Suserinfo +	 "LEFT JOIN teacher_basic t1 ON t1.id = t.user_association	WHERE	t.userole=1	and	(t.usermob = '"+Susermob+"'	 OR t1.teacher_number = '"+Susermob+"')";
 	}else if(Suserole.equals("2")){
		Suserinfo = Suserinfo +	 " LEFT JOIN student_basic t1 ON t1.id=t.user_association WHERE	t.userole=2 and	(t.usermob = '"+Susermob+"' OR t1.student_number = '"+Susermob+"')";
 	}else{
		Suserinfo = Suserinfo +	 " where	t.usermob = '"+Susermob+"'";
 	}
 	String Spowerid="",Suid="",Semail="",Snickname="",Susername="",Sheadimgurl="",SUserDepartment="",SDepartmentid="",Spc_token="",App_token="",Scompanyname="",Scompanyid="",Sremarks="",Sregionalcode="",Srolecode="",Sroleid = "",Srolename="",Sassociationid="";
    System.out.println(Suserinfo);
 	ResultSet  AdminRS=db.executeQuery(Suserinfo);  
    if(AdminRS.next()){    
	  Suid=AdminRS.getString("uid");  //员工id
	  Snickname=AdminRS.getString("nickname");//员工昵称
	  Susername=AdminRS.getString("username");//员工名字
	  Spowerid=AdminRS.getString("powerid"); //员工权限组
	  Sremarks=AdminRS.getString("remarks"); //备注
	  Sheadimgurl=AdminRS.getString("headimgurl"); //备注
	  Semail=AdminRS.getString("email"); //email
	  
	  Scompanyname=AdminRS.getString("companyname"); //员工所属公司id
	  Scompanyid=AdminRS.getString("companyid"); //员工所属公司id
	  
	  SUserDepartment=AdminRS.getString("UserDepartment");  //部门
	  SDepartmentid=AdminRS.getString("UserDepartmentid"); //员工部门id
	  Spc_token = AdminRS.getString("pc_token"); //员工pctoken 认证
	  App_token = AdminRS.getString("app_token"); //员工pctoken 认证
	  Sworkspace= AdminRS.getString("workspace"); //开发者本机ide工作目录
	  Sregionalcode = AdminRS.getString("regionalcode");  //区域标识
	  Sassociationid = AdminRS.getString("user_association");  //用户关联id
	  //Srolecode = AdminRS.getString("rolecode");
 	  //Sroleid = AdminRS.getString("roleid");
 	  //Srolename = AdminRS.getString("rolename");
 	   
 	  //保存信息
 	  UserEntity user = new UserEntity();
 	  user.setRegionalcode(Sregionalcode);
 	  user.setUserid(Suid);
 	  user.setUsername(Susername);
 	  //user.setRolecode(Srolecode);
 	  //user.setRoleid(Sroleid);
 	  session.setAttribute("UserList",user);
 	  
 	  //设置请求头内容
	  response.setHeader("X-AppId",AppId_web); 
	  response.setHeader("X-AppKey",AppKey_web); 
	  response.setHeader("Token",Spc_token); 
	  response.setHeader("X-UUID",Spc_token); 
	  response.setHeader("X-AppId",AppId_web); 
	  response.setHeader("x-real-ip",getIpAddr(request)); 
	}if(AdminRS!=null)AdminRS.close();

int pending_num=0;
int doing_num=0;
int finish_num=0;

System.out.println("Spc_token==================="+Spc_token);
System.out.println("SmarkKey==================="+SmarkKey);

   if(!Spc_token.equals(SmarkKey)){  //判断用登地方录
	out.print("<meta http-equiv=\"Refresh\" content=\"0;URL=index.jsp?msg=您在其他电脑登录。此登录操作退出。\" />");
	if(db!=null)db.close();db=null;if(server!=null)server=null;
	return;
   }
   String	 SuserPowerids="";
   //获取用户的权限组 菜单id集合
   //ResultSet  menuSysrs=db.executeQuery("SELECT menu_sys_id FROM zk_role WHERE rolecode='"+Srolecode+"' ;");  
   //if (menuSysrs.next()){ 
   //       SuserPowerids=menuSysrs.getString("menu_sys_id");
  //  }              
   //if(SuserPowerids.indexOf("#"+PMenuId+"#")==-1){
    //out.print("<script language=\"JavaScript\">\r\n <!--\r\n alert(\"警告：没有该权限,请联系管理员！\"); \r\n location.href='javascript:history.go(-1);'; \r\n// -->\r\n  </script>");
	///if(db!=null)db.close();db=null;if(server!=null)server=null;
   // return ;
 	//  }
   ResultSet  menuSysrs=db.executeQuery("SELECT t2.menu_sys_id from zk_user_role t LEFT JOIN zk_role t2 ON t.sys_role_id=t2.id WHERE t.sys_user_id='"+Suid+"' ;");  
   while(menuSysrs.next()){
	   SuserPowerids=SuserPowerids +menuSysrs.getString("menu_sys_id");
	   }
	   if(SuserPowerids.indexOf("#"+PMenuId+"#")==-1){
		   //out.print("<script language=\"JavaScript\">\r\n <!--\r\n alert(\"警告："+Mokuai+"未授权使用\"); \r\n location.href='index.jsp'; \r\n// -->\r\n  </script>");
		    out.print("<script> alert(\"警告：没有该权限,请联系管理员！\");   parent.location.reload(); </script>");
			if(db!=null)db.close();db=null;if(server!=null)server=null;
		    return ;
		   }
   if(menuSysrs!=null)menuSysrs.close();                      
   int  RandNO=(int)(Math.random()*9000+10000000); //随机码
 
%>
<%!
	private boolean regex_num(String str){ 
	    if(str==null || str.length()<1){str="x";}
		java.util.regex.Pattern p=null;  
		java.util.regex.Matcher m=null; 
		boolean value=true; 
			try{ 
				p = java.util.regex.Pattern.compile("[^0-9]"); 
				m = p.matcher(str); 
				if(m.find()) { 
					value=false; 
				} 
			}catch(Exception e){} 
		return value; 
	} 
%>
<%!
	private boolean regex_txt(String str){ 
	    if(str==null  || str.length()<1){str="x x";}
		java.util.regex.Pattern p=null; 
		java.util.regex.Matcher m=null; 
		boolean value=true; 
			try{ 
				p = java.util.regex.Pattern.compile("[^0-9A-Za-z]"); 
				m = p.matcher(str); 
				if(m.find()) { 
					value=false; 
				} 
			}catch(Exception e){} 
		return value; 
	} 
%>
<%!
//防止sql注入
	public String mysqlCode(String strs) {
		String stres = " ";
		try{
			if(strs != null && strs.length() > 0) {
				strs=strs.toLowerCase();
				strs = strs.replaceAll("\\\\", "\\\\\\\\");
				strs = strs.replaceAll("databases", "");
				strs = strs.replaceAll("%", "％");
				strs = strs.replaceAll("form", "ｆｏｒｍ");
				strs = strs.replaceAll("or", "");
				strs = strs.replaceAll("and", "");
				strs = strs.replaceAll("exec", "");
				strs = strs.replaceAll("insert", "");
				strs = strs.replaceAll("select", "");
				strs = strs.replaceAll("delete", "");
				strs = strs.replaceAll("update", "");
				strs = strs.replaceAll("%", "％");
				strs = strs.replaceAll("'", "");
				strs = strs.replaceAll("\'", "");
				stres = strs;
			}
		} catch (Exception stre) {
			System.err.println((new StringBuilder("mysql famt code:")).append(stre.getMessage()).toString());
		}
		return stres;
	}
 %>
 
 <%!
 	//获取当前ip  过滤虚假ip 
 	public String getIpAddr(HttpServletRequest request)
	{
	  String ip = request.getHeader("x-forwarded-for");
	  if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip))
	  {
	    ip = request.getHeader("Proxy-Client-IP");
	  }
	  if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip))
	  {
	    ip = request.getHeader("WL-Proxy-Client-IP");
	  }
	  if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip))
	  {
	    ip = request.getRemoteAddr();
	  }
	  return ip;
	} 
%>