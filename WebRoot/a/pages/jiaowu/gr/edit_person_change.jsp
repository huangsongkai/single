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
		<title>编辑个人变动</title> 
	    <style type="text/css">
			.inline{ position: relative; display: inline-block; margin-right: 10px; }
	    </style>
	</head>
	<body>
		<div style="margin: 15px;">
			<fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
				<legend>编辑个人变动</legend>
			</fieldset>
			<form class="layui-form" action="edit_person_change.jsp?ac=edit&id=<%=id%>" method="post" >
			<% 
			String sqls="SELECT * FROM `person_change` WHERE id='"+id+"';";
			 ResultSet Rs = db.executeQuery(sqls);
	          while(Rs.next()){
			%>
             <div class="layui-form-item inline" style="width: 40%">
					<label class="layui-form-label" style=" width: 30%">姓名</label>	 				
					<div class="layui-input-inline">
						<input type="text" id="name" name="name" class="layui-input"  lay-verify="required" value="<%=Rs.getString("name")%>">
					</div>
				</div>
                <div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">开始日期</label>
					<div class="layui-input-inline">
						<input type="text" id="start_date" name="start_date" class="layui-input time"   lay-verify="required" readonly value="<%=Rs.getString("start_date")%>">
					</div>
				</div>	
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">结束日期</label>
					<div class="layui-input-inline">
						<input type="text" id="end_date" name="end_date" class="layui-input time"   lay-verify="required" readonly value="<%=Rs.getString("end_date")%>">
					</div>
				</div>	
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">单位名称</label>
					<div class="layui-input-inline">
						<input type="text" id="work_address" name="work_address"  lay-verify="required"  class="layui-input"  value="<%=Rs.getString("work_address")%>">
					</div>
				</div>	
				 <div class="layui-form-item inline" style="width: 40%">
					<label class="layui-form-label" style=" width: 30%">部门</label>					
					<div class="layui-input-inline">
						<input type="text" id="branch" name="branch"  lay-verify="required"  class="layui-input"  value="<%=Rs.getString("branch")%>">
					</div>
				</div>		
				
				<div class="layui-form-item inline" style="width: 40%">
					<label class="layui-form-label" style=" width: 30%">工作内容</label>					
					<div class="layui-input-inline">
						<input type="text" id="work_info" name="work_info"  lay-verify="required"  class="layui-input"  value="<%=Rs.getString("work_info")%>">
					</div>
				</div>			
				<div class="layui-form-item inline" style="width: 40%">
					<label class="layui-form-label" style=" width: 30%">证明人</label>					
					<div class="layui-input-inline">
						<input type="text" id="work_people" name="work_people"  lay-verify="required"  class="layui-input"  value="<%=Rs.getString("work_people")%>">
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
					    elem: '#start_date' //指定元素
					  });
				 laydate.render({
					    elem: '#end_date' //指定元素
					  });
			
				})
	 var index = parent.layer.getFrameIndex(window.name);

</script>
</html>
<% if("edit".equals(ac)){ 
	String name=request.getParameter("name");
	 String work_address= request.getParameter("work_address");
	 String branch=request.getParameter("branch");
	 String work_info= request.getParameter("work_info");
	 String work_people = request.getParameter("work_people");
	 String examine = request.getParameter("examine");
	 String start_date = request.getParameter("start_date");
	 String end_date = request.getParameter("end_date");
	 
	try{
	   String sql="UPDATE `person_change` SET `name`='"+name+"',`work_address`='"+work_address+"',`branch`='"+branch+"',`work_info`='"+work_info+"',`work_people`='"+work_people+"',`start_date`='"+start_date+"',`end_date`='"+end_date +"'  WHERE id='"+id+"';";
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