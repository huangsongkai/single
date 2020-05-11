<%@ page trimDirectiveWhitespaces="true" %>
<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@page import="service.dao.db.Page"%>
<%@include file="../../cookie.jsp"%>
<%@page import="org.apache.commons.lang3.StringUtils"%>
<%
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
		<title>编辑证书变动</title> 
	    <style type="text/css">
			.inline{ position: relative; display: inline-block; margin-right: 10px; }
	    </style>
	</head>
	<body>
		<div style="margin: 15px;">
			<fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
				<legend>编辑证书变动</legend>
			</fieldset>
			<form class="layui-form" action="edit_certificate_change.jsp?ac=edit&id=<%=id%>" method="post" >
			<% 
			String sqls="SELECT * FROM `person_certificate_change` WHERE id='"+id+"';";
			 ResultSet Rs = db.executeQuery(sqls);
	          while(Rs.next()){
			%>
              <div class="layui-form-item inline" style="width: 40%">
					<label class="layui-form-label" style=" width: 30%">姓名</label>	 				
					<div class="layui-input-inline">
							<input type="text" id="name" lay-verify="required"  name="name" class="layui-input" value="<%=Rs.getString("name")%>">
					</div>
				</div>
                <div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">证书名称</label>
					<div class="layui-input-inline">
						<input type="text" id="cer_name" lay-verify="required"  name="cer_name" class="layui-input" value="<%=Rs.getString("cer_name")%>">
					</div>
				</div>	
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">证书类型</label>
					<div class="layui-input-inline">
						<input type="text" id="cer_type" lay-verify="required"  name="cer_type" class="layui-input" value="<%=Rs.getString("cer_type")%>">
					</div>
				</div>	
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">证书编号</label>
					<div class="layui-input-inline">
						<input type="text" id="cer_num" name="cer_num" lay-verify="required"   class="layui-input" value="<%=Rs.getString("cer_num")%>" readonly>
					</div>
				</div>	
					<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">证书时间</label>
					<div class="layui-input-inline">
						<input type="text" id="cer_date" name="cer_date" class="layui-input"  lay-verify="required"  value="<%=Rs.getString("cer_date")%>" >
					</div>
				</div>	
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">证书单位</label>
					<div class="layui-input-inline">
						<input type="text" id="cer_address" name="cer_address" class="layui-input"  lay-verify="required"  value="<%=Rs.getString("cer_address")%>" >
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

layui.use(['form','layer','jquery','laydate'], function(){
				layer = layui.layer,
				layedit = layui.layedit,
				laydate = layui.laydate;
				laydate.render({
					   elem: '#cer_date' //指定元素
				  });
			
				})
	 var index = parent.layer.getFrameIndex(window.name);

</script>
</html>
<% if("edit".equals(ac)){ 
	String name=request.getParameter("name");
	 String cer_name= request.getParameter("cer_name");
	 String cer_type=request.getParameter("cer_type");
	 String cer_num= request.getParameter("cer_num");
	 String cer_date= request.getParameter("cer_date");
	 String cer_address= request.getParameter("cer_address");
	 
	try{
	   String sql="UPDATE `person_certificate_change` SET `name`='"+name+"',`cer_name`='"+cer_name+"',`cer_type`='"+cer_type+"',`cer_num`='"+cer_num+"',`cer_date`='"+cer_date+"',`cer_date`='"+cer_date+"',`cer_address`='"+cer_address +"'  WHERE id='"+id+"';";
	   if(db.executeUpdate(sql)==true){
		   out.println("<script>parent.layer.msg('编辑经历 成功'); parent.layer.close(index); parent.location.reload();</script>");
	   }else{
		   out.println("<script>parent.layer.msg('编辑经历失败!请重新输入');</script>");
	   }
	 }catch (Exception e){
	    out.println("<script>parent.layer.msg('编辑经历失败');</script>");
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