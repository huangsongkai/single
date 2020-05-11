<!-- 用户的右侧菜单-->
<%@ page trimDirectiveWhitespaces="true" %>
<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<% String MMenuId="0";%>
<%@ include file="cookie.jsp"%>
                <h2 class="pf-model-name">
                    <span class="iconfont"></span>
                    <span class="pf-name">我的首页</span>
                    <span class="toggle-icon"></span>
                </h2>
                <ul class="sider-nav">
                    <li class="current">
                    
                        <a href="javascript:;">
                            <span class="iconfont sider-nav-icon">&#xe671;</span>
                            <span class="sider-nav-title">欢迎页面</span>
                            <i class="iconfont"></i>
                        </a>
                        <ul class="sider-nav-s">
                           <li class="active"><a  onclick="addTab('首页','workbench.jsp')">首页</a></li>
                        </ul>
                     </li>
                 	 <li>
                        <a href="javascript:;"  title="使用次数最多">
                            <span class="iconfont sider-nav-icon">&#xe620;</span>
                            <span class="sider-nav-title">常用功能</span>
                            <i class="iconfont"></i>
                        </a>
                    	<ul class="sider-nav-s">
		                    <% int p=0;
		                    //用户常用主菜单 
		                    //System.out.println("用户常用主菜单 ===="+"SELECT menu_sys.menuname,menu_sys.menulink FROM  `menu_worker`,`menu_sys`  WHERE  menu_worker.sysmenuid=menu_sys.id AND menu_worker.workerid="+Suid+" AND menu_worker.companyid="+Scompanyid+" ORDER  BY menu_worker.countes DESC");    
			                    ResultSet   Rs3=db.executeQuery("SELECT menu_sys.menuname,menu_sys.menulink FROM  `menu_worker`,`menu_sys`  WHERE  menu_worker.sysmenuid=menu_sys.id AND menu_worker.workerid="+Suid+" AND menu_worker.companyid="+Scompanyid+" ORDER  BY menu_worker.countes DESC limit 20");  
			                    while(Rs3.next()){ p=p+1;%>
		                            <li><a  onclick="addTab('<%=Rs3.getString("menuname") %>','<%=Rs3.getString("menulink") %>')"><%=p%>.<%=Rs3.getString("menuname") %></a></li>
		                    <%} p=0; %>
                        </ul>
                     </li>
                     <li>
                        <a href="javascript:;"  title="最近使用的功能">
                            <span class="iconfont sider-nav-icon">&#xe690;</span>
                            <span class="sider-nav-title">最近使用</span>
                            <i class="iconfont"></i>
                        </a>
                        <ul class="sider-nav-s">
                        <%
	                   		//用户最近使用主菜单     
	                   	    //System.out.println("用户最近使用主菜单 ===="+"SELECT menu_sys.menuname,menu_sys.menulink FROM  `menu_worker`,`menu_sys`  WHERE menu_worker.sysmenuid!=0 and  menu_worker.sysmenuid=menu_sys.id AND menu_worker.workerid="+Suid+" AND menu_worker.companyid="+Scompanyid+" ORDER  BY menu_worker.usetime DESC");
	                        Rs3=db.executeQuery("SELECT menu_sys.menuname,menu_sys.menulink FROM  `menu_worker`,`menu_sys`  WHERE menu_worker.sysmenuid!=0 and  menu_worker.sysmenuid=menu_sys.id AND menu_worker.workerid="+Suid+" AND menu_worker.companyid="+Scompanyid+" ORDER  BY menu_worker.usetime DESC limit 20");  
	                          while(Rs3.next()){ p=p+1;%>
	                            <li><a href="javascript:(0);" onclick="addTab('<%=Rs3.getString("menuname") %>','<%=Rs3.getString("menulink") %>')"><%=p%>.<%=Rs3.getString("menuname") %></a></li>
	                        <%}if(Rs3!=null)Rs3.close(); %>
                        </ul>
                     </li>  
                 	 <li>
                        <a href="javascript:;">
                            <span class="iconfont sider-nav-icon">&#xe674;</span>
                            <span class="sider-nav-title">账号设置</span>
                            <i class="iconfont"></i>
                        </a>
                        <ul class="sider-nav-s">
                           <li class="active"><a href="javascript:(0);" onclick="addTab('我的信息','user_infos.jsp')">个人信息</a></li>
                           <li class="active"><a href="javascript:(0);" onclick="addTab('修改密码','modify_pwd.jsp')">修改密码</a></li>
                        </ul>
                     </li>
                 </ul>
 <script>
	$(".sider-nav-s li").click(function(){
	  $(this).addClass("active").siblings("li").removeClass("active")
	})
</script>
 <% if(db!=null)db.close();db=null;if(server!=null)server=null;%>