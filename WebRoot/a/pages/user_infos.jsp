<%@ page trimDirectiveWhitespaces="true" %>
<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<% String MMenuId="0"; //个人密码修改模块编号%>
<%@ include file="cookie.jsp"%>
<%@page import="v1.haocheok.commom.common"%>
<!DOCTYPE html> 
<html lang="zh_CN"> 
<head> 
    <meta charset="utf-8"> 
    <meta name="viewport" content="width=device-width, initial-scale=1"> 
    <title>基本信息</title> 
    <link href="css/base.css" rel="stylesheet">
    <link rel="stylesheet" href="../custom/easyui/easyui.css">
    <link href="css/basic_info.css" rel="stylesheet">
</head> 
<body>
<style>
.container {
  position: relative;
  padding-left: 10px;
  position: relative;
}
.kv-table > input {margin-left: 0px; margin-right: 0px; padding-top: 0px; padding-bottom: 0px; height: 33px; line-height: 33px; width: 180px;}
</style>
	<div class="container">
	 
		<div class="content">
			<div class="easyui-tabs1" style="width:100%;">
			
		      <div title="个人信息" data-options="closable:false" class="basic-info">
		      	<table class="kv-table">
		      			<%
			          		String user_sql = "select t.*,t1.regionalname regionalname,t3.name rolename from user_worker t LEFT JOIN s_regional_table t1 ON t.regionalcode = t1.regionalcode LEFT JOIN zk_user_role t2 ON t2.sys_user_id = t.uid LEFT JOIN zk_role t3 ON t3.id = t2.sys_role_id  where 1=1 and  t.uid = "+Suid;
		      				System.out.println(user_sql);
			          		ResultSet user = db.executeQuery(user_sql);
			          		int i = 1;
			          		while(user.next()){
			         %>
					<tbody>
						<tr>
							<td class="kv-label">昵称</td>
							<td class="kv-content">
								
							</td>
						</tr>
						<tr>
							<td class="kv-label">用户姓名</td>
							<td class="kv-content" colspan="3">
							<%=user.getString("username") %>
							</td>
						</tr>
						<tr>
							<td class="kv-label">性别</td>
							<td class="kv-content" colspan="3">
							   <%
							        	Map<String ,String> map = common.getDicMap("gender");
							        	for(Map.Entry<String,String> entry:map.entrySet()){
							        		if(user.getString("sex").equals(entry.getKey())){
							        			out.println(entry.getValue());
							        	}
							        	}
							         %>
							</td>
						</tr>
							<tr>
							<td class="kv-label">角色</td>
							<td class="kv-content" colspan="3">
							<%=user.getString("rolename") %>
							</td>
						</tr>
							<tr>
							<td class="kv-label">区域</td>
							<td class="kv-content" colspan="3">
							<%=user.getString("regionalname") %>
							</td>
						</tr>
						<tr>
							<td class="kv-label">手机号</td>
							<td class="kv-content" colspan="3">
							<%=user.getString("usermob") %>
							</td>
						</tr>
						<tr>
							<td class="kv-label">邮箱</td>
							<td class="kv-content" colspan="3">
							<%=user.getString("email") %>
							</td>
						</tr>
						 
					</tbody>
							<%i++;} %>
				</table>
					<!--
				 	<div align="center"  >
					<a href="javascript:chongzhi();" class="easyui-linkbutton l-btn l-btn-small l-btn-selected" data-options="selected:false" group="" id=""><span class="l-btn-left"><span class="l-btn-text" >重置页面</span></span></a>
					<a href="javascript:addfenlei();" class="easyui-linkbutton l-btn l-btn-small l-btn-selected" data-options="selected:true" group="" id=""><span class="l-btn-left"><span class="l-btn-text" >确定修改密码</span></span></a>
					</div>
				   -->
				</div>
		   
		   <!-- 学生端设置 -->    
		    <div title="我的操作日志" data-options="closable:false" class="basic-info">
		          
		     
		     <div class="column"><span class="current">最近500条记录操作</span></div>
		

          <table class="kv-table">
					<tbody>
					 
						<tr>
						  <td width="104" class="kv-label">ID序号</td>
						  <td width="149" class="kv-label">日志类型</td>
						  <td width="149" class="kv-label">标题</td>
						  <td width="149" class="kv-label">事件</td>
						  <td width="149" class="kv-label">IP</td>
						  <td width="149" class="kv-label">发生时间</td>
					  </tr>
					  <%	ResultSet Rslog = db.executeQuery("SELECT * FROM `log_sys`  where uid='"+Suid+"' order by id desc limit 500");
		          		   	 while(Rslog.next()){ %>
						<tr>
							<td class="kv-label"><%=Rslog.getString("id") %></td>
							<td class="kv-label"><%=Rslog.getString("ltype") %></td>
							<td class="kv-label"><%=Rslog.getString("title") %></td>
							<td class="kv-content"><%=Rslog.getString("body") %></td>
							<td class="kv-label"><%=Rslog.getString("ip") %></td>
							<td class="kv-content"><%=Rslog.getString("addtime") %></td>
						</tr>
					<%} if(Rslog!=null){Rslog.close();}%> 
					</tbody>
				</table>
				
		   </div> <!-- 操作日志 -->
		        
		   
		      
		       
		    </div>
		</div>
	</div>
	
</body> 
    <script type="text/javascript" src="../custom/jquery.min.js"></script>
    <script type="text/javascript" src="../custom/jquery.easyui.min.js"></script>
<script type="text/javascript">
	$('.easyui-tabs1').tabs({
      tabHeight: 36
    });
    $(window).resize(function(){
    	$('.easyui-tabs1').tabs("resize");
    }).resize();
</script>
</html>
<%
//插入常用菜单日志
int   TagMenu=db.Row("SELECT COUNT(*) as row FROM  menu_worker  WHERE sysmenuid='"+MMenuId+"' and  workerid='"+Suid+"' and  companyid='"+Scompanyid+"'");
if(TagMenu==0){
  db.executeUpdate("INSERT INTO `menu_worker`(`sysmenuid`,`workerid`,`countes`,`companyid`) VALUES ('"+MMenuId+"','"+Suid+"','1','"+Scompanyid+"');"); 
}else{
 db.executeUpdate("UPDATE  `menu_worker` SET `countes`=countes+1,`usetime`=now() WHERE  sysmenuid='"+MMenuId+"' and  workerid='"+Suid+"' and  companyid='"+Scompanyid+"'");
}
 %>
<% 
if(db!=null)db.close();db=null;if(server!=null)server=null;%>