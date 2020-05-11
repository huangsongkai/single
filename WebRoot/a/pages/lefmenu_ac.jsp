<%@ page trimDirectiveWhitespaces="true" %>
<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@ page import="java.io.*" %>
<%@ page import="net.sf.json.*" %>
<%@ include file="cookie.jsp"%>
<%
	String MMenuId=request.getParameter("id");// 一级菜单id -->
	//查询一级菜单名称
	String menu_name_sql="select menuname as str from  menu_sys where id='"+MMenuId+"' ";
	String menu_name= db.executeQuery_str(menu_name_sql);
%>
                <h2 class="pf-model-name">
                    <span class="iconfont"></span>
                    <span class="pf-name"><%=menu_name%></span>
                    <span class="toggle-icon"></span>
                </h2>
                <ul class="sider-nav">
                
 <%
  System.out.println("用户主菜单   Mokuai  =="+Mokuai);
  System.out.println("MMenuId  =="+MMenuId);
 if(!regex_num(MMenuId)){ 
out.print("错误:变量智能为数字");
if(db!=null)db.close();db=null;if(server!=null)server=null;
return;//跳出程序只行 
} 
      //用户主菜单     
      String menuname="", menuico="", menuid3="";
      int j=0;
      ResultSet Rs3=null;
      String userMenu_sql="SELECT id,menuname,ico FROM  `menu_sys`  where depth=2 and showstate=1 and leftshow=1 and fatherid="+MMenuId+" ORDER  by Sortid asc";
      //System.out.println("用户主菜单   userMenu_sql  =="+userMenu_sql);
      ResultSet Rs2=db.executeQuery(userMenu_sql);  
      while(Rs2.next()){   
         menuname=Rs2.getString("menuname");
         menuname=menuname.replaceAll("&&",Srolename);
	     menuico=Rs2.getString("ico");
	     menuid3=Rs2.getString("id");
	     if(SuserPowerids.indexOf("#"+menuid3+"#")==-1){
	    	 continue;
	     }
	     j=j+1;
	%>
                  <li class="<%if(j==1){out.print("current");}%>">
                        <a href="javascript:;">
                            <span class="iconfont sider-nav-icon"><%=menuico %></span>
                            <span class="sider-nav-title"><%=menuname%></span>
                            <i class="iconfont"></i>
                        </a>
                        <ul class="sider-nav-s">
                 <% int p=0;
                 Rs3=db.executeQuery("SELECT id,menuname,menulink,menutxt FROM  `menu_sys`  where depth=3 and showstate=1 and leftshow=1 and fatherid="+menuid3+" ORDER  by Sortid asc");  
                    while(Rs3.next()){ 
		                    if(SuserPowerids.indexOf("#"+Rs3.getString("id")+"#")==-1){
		           	    	 continue;
		           	     }
		                    p=p+1; 
                    %>
                          <li><a  title="<%=Rs3.getString("menutxt")%>" onclick="addTab('<%=Rs3.getString("menuname").replaceAll("&&",Srolename)  %>','<%=Rs3.getString("menulink")%>')"><%=p %>.<%=Rs3.getString("menuname").replaceAll("&&",Srolename)  %></a></li><%}%>
                        </ul>
                     </li>
      <%} if(Rs2!=null)Rs2.close(); if(Rs3!=null)Rs3.close();  %>                   
                  </ul> 
 <%if(db!=null)db.close();db=null;if(server!=null)server=null;%>
 <script>
$(".sider-nav-s li").click(function(){
  $(this).addClass("active").siblings("li").removeClass("active")
})
</script>
