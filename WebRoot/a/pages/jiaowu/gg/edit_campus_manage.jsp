<%@ page trimDirectiveWhitespaces="true" %>
<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@page import="service.dao.db.Page"%>
<%@include file="../../cookie.jsp"%>
<%@page import="java.util.Date"%>
<%@page import="v1.haocheok.commom.common"%>
<%@page import="java.text.SimpleDateFormat"%>

<%
common common=new common();
   String id= request.getParameter("id");
   if(regex_num(id)==false){id="0";}
%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="utf-8"> 
	    <meta name="viewport" content="width=device-width, initial-scale=1"> 
	    
	    <link rel="stylesheet" href="../../../pages/css/sy_style.css">	    
	    <link rel="stylesheet" href="../../js/layui2/css/layui.css">
		<script type="text/javascript" src="../../js/jquery-1.9.1.js" ></script><!--通用jquery-->
		<script src="../../js/layui2/layui.js"></script>
		<title>编辑校区</title> 
	    <style type="text/css">
			.inline{ position: relative; display: inline-block; margin-right: 10px; }
	    </style>
	</head>
	<body>
		<div style="margin: 15px;">
			<fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
				<legend>编辑校区</legend>
			</fieldset>
			<form class="layui-form" action="edit_campus_manage.jsp?ac=edit&id=<%=id%>" method="post" >
			<% 
			String sqls="SELECT * FROM `dict_campus` WHERE id='"+id+"';";
			 ResultSet Rs = db.executeQuery(sqls);
	          while(Rs.next()){
			%>
                <div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">分校编号</label>
					<div class="layui-input-inline">
						<input type="text" id="campus_number"  lay-verify="required" name="campus_number" class="layui-input" value="<%=Rs.getString("campus_number")%>">
					</div>
				</div>	
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">分校名称</label>
					<div class="layui-input-inline">
						<input type="text" id="campus_name"  lay-verify="required"  name="campus_name" class="layui-input" value="<%=Rs.getString("campus_name")%>">
					</div>
				</div>	
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">分校英文名称</label>
					<div class="layui-input-inline">
						<input type="text" id="campus_english_name" name="campus_english_name" class="layui-input" value="<%=Rs.getString("campus_english_name")%>">
					</div>
				</div>	
				<%}%>	
				<div class="layui-form-item" style="margin-bottom:45px">
					<div class="layui-input-block"  style="margin-left:540px">			
						<button  class="layui-btn"  lay-submit >确认</button>
					</div>
				</div>
			</form>
		</div>
	</body>
<script>
	 layui.use('form', function() {
				layer = layui.layer,
				layedit = layui.layedit,
				laydate = layui.laydate;
				})
	 var index = parent.layer.getFrameIndex(window.name);
</script>
</html>
<% if("edit".equals(ac)){ 
	
	 String campus_number=request.getParameter("campus_number");
	 String campus_name=request.getParameter("campus_name");
	 String campus_english_name= request.getParameter("campus_english_name");
	 if(campus_number==null){campus_number="";}
	 if(campus_name==null){campus_name="";}
	 if(campus_english_name==null){campus_english_name="";}
	try{
	   String sql="UPDATE `dict_campus` SET `campus_number`='"+campus_number+"',`campus_name`='"+campus_name+"',`campus_english_name`='"+campus_english_name+"' WHERE id='"+id+"';";
	   if(db.executeUpdate(sql)==true){
		   out.println("<script>parent.layer.msg('编辑校区 成功'); parent.layer.close(index); parent.location.reload();</script>");
	   }else{
		   out.println("<script>parent.layer.msg('编辑校区失败!请重新输入');</script>");
	   }
	 }catch (Exception e){
	    out.println("<script>parent.layer.msg('编辑校区失败');</script>");
	    return;
	}
	//关闭数据与serlvet.out
	
	if (page != null) {page = null;}
	
}%>
 
<%
//插入常用菜单日志
int   TagMenu=db.Row("SELECT COUNT(*) as row FROM  menu_worker  WHERE sysmenuid='"+PMenuId+"' and  workerid='"+Suid+"' and  companyid="+Scompanyid);
if(TagMenu==0){
  db.executeUpdate("INSERT INTO `menu_worker`(`sysmenuid`,`workerid`,`countes`,`companyid`) VALUES ('"+PMenuId+"','"+Suid+"','1','"+Scompanyid+"');"); 
}else{
 db.executeUpdate("UPDATE  `menu_worker` SET `countes`=countes+1,`usetime`=now() WHERE  sysmenuid='"+PMenuId+"' and  workerid='"+Suid+"' and  companyid="+Scompanyid);
}
 %>
<%
if(db!=null)db.close();db=null;if(server!=null)server=null;
%>