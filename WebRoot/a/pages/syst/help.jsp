<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%--流程分类列表 --%>
<%@page trimDirectiveWhitespaces="true" %>
<%@page contentType="text/html; charset=UTF-8" language="java"%>
<%@page import="service.dao.db.Page"%>
<%@include file="../cookie.jsp"%>
<%String id=request.getParameter("id"); if(id==null){id="1";}  
 id=mysqlCode(id);
 String help="",helpname="";
	 String help_sql = "select helpinfo,menuname from  menu_sys where id="+id;
	 ResultSet helpRs = db.executeQuery(help_sql);
		 if(helpRs.next()){
			 helpname=helpRs.getString("menuname");
			 help=helpRs.getString("helpinfo");
          }if(helpRs!=null){helpRs.close();}
     
 %>
<!DOCTYPE html> 
<html lang="zh_CN"> 
<head> 
    <meta charset="utf-8"> 
    <meta name="viewport" content="width=device-width, initial-scale=1"> 
    <title>帮助信息</title> 
    <link href="../css/base.css" rel="stylesheet">
    <link rel="stylesheet" href="../../custom/easyui/easyui.css">
    <link href="../css/basic_info.css" rel="stylesheet">
    <script type="text/javascript" src="../../custom/jquery.min.js"></script>
    <script type="text/javascript" src="../../custom/jquery.easyui.min.js"></script>
    <script src="../js/layer/layer.js"></script>
    <script src="../js/layui/layui.js"></script>
    <link rel="stylesheet" href="../js/layui/css/layui.css">
</head> 
<body>
<style>
.container {
  position: relative;
  padding-left: 10px;
  position: relative;

}</style>

	<div class="container">
	 
		<div class="content">
			<div class="easyui-tabs1" style="width:100%;">
			
		      <div title="<%=helpname %>" data-options="closable:false" class="basic-info">
		      	
			 
				<div class="column"><span class="current">功能操作说明</span></div>
		      	<table class="kv-table">
					 
				</table>
		         <table align="center" class="kv-table yes-not">
					<tbody>
						<tr>
							<td class="kv-label"><%=help %></td>
						</tr>
					</tbody>
				</table>
				
 

		      </div>
		   
		      
		       
		    </div>
		</div>
	</div>
	
</body> 
</html>
 
<script type="text/javascript">
	$('.easyui-tabs1').tabs({
      tabHeight: 36
    });
    $(window).resize(function(){
    	$('.easyui-tabs1').tabs("resize");
    }).resize();
</script> <%
//插入常用菜单日志
int   TagMenu=db.Row("SELECT COUNT(*) as row FROM  menu_worker  WHERE sysmenuid='"+PMenuId+"' and  workerid='"+Suid+"'");
if(TagMenu==0){
     db.executeUpdate("INSERT INTO `menu_worker`(`sysmenuid`,`workerid`,`countes`) VALUES ('"+PMenuId+"','"+Suid+"','1');"); 
   }else{
  db.executeUpdate("UPDATE  `menu_worker` SET `countes`=countes+1,`usetime`=now() WHERE  sysmenuid='"+PMenuId+"' and  workerid='"+Suid+"'");
}
 %>
<%if(db!=null)db.close();db=null;if(server!=null)server=null;%>