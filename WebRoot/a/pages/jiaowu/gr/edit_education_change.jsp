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
		<title>编辑学历变动</title> 
	    <style type="text/css">
			.inline{ position: relative; display: inline-block; margin-right: 10px; }
	    </style>
	</head>
	<body>
		<div style="margin: 15px;">
			<fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
				<legend>编辑学历变动</legend>
			</fieldset>
			<form class="layui-form" action="edit_education_change.jsp?ac=edit&id=<%=id%>" method="post" >
			<% 
			String sqls="SELECT * FROM `person_education_change` WHERE id='"+id+"';";
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
					<label class="layui-form-label" style=" width: 30%">学历</label>
					<div class="layui-input-inline">
						<input type="text" id="degree" lay-verify="required"  name="degree" class="layui-input" value="<%=Rs.getString("degree")%>">
					</div>
				</div>	
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">学历证号</label>
					<div class="layui-input-inline">
						<input type="text" id="degree_num" lay-verify="required"  name="degree_num" class="layui-input" value="<%=Rs.getString("degree_num")%>">
					</div>
				</div>	
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">毕业时间</label>
					<div class="layui-input-inline">
						<input type="text" id="degree_date" name="degree_date" lay-verify="required"   class="layui-input" value="<%=Rs.getString("degree_date")%>" readonly>
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
				    elem: '#degree_date' //指定元素
				  });
			
				})
	 var index = parent.layer.getFrameIndex(window.name);

</script>
</html>
<% if("edit".equals(ac)){ 
	 String name=request.getParameter("name");
	 String degree= request.getParameter("degree");
	 String degree_num=request.getParameter("degree_num");
	 String degree_date= request.getParameter("degree_date");
	 
	try{
	   String sql="UPDATE `person_education_change` SET `name`='"+name+"',`degree`='"+degree+"',`degree_num`='"+degree_num+"',`degree_date`='"+degree_date +"'  WHERE id='"+id+"';";
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