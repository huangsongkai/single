<%@ page trimDirectiveWhitespaces="true" %>
<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@page import="service.dao.db.Page"%>
<%@include file="../../cookie.jsp"%>
<%@page import="java.util.Date"%>
<%@page import="v1.haocheok.commom.common"%>
<%@page import="java.text.SimpleDateFormat"%>

<%
common common=new common();
   String sysid= request.getParameter("sysid");
   if(regex_num(sysid)==false){sysid="0";}
%>
<%
	String id = request.getParameter("id");
	String select_sql =	"SELECT 	id, 						"+
			"		assessment_name,                      "+
			"		assessment_number                      "+
			"		FROM                                        "+
			"		dict_assessment       "+
			"		WHERE id = '"+id+"'; "; 
	   String assessment_name = "";
	   String assessment_number = "";

	ResultSet base_set = db.executeQuery(select_sql);
	while(base_set.next()){
		assessment_name = base_set.getString("assessment_name");
		assessment_number = base_set.getString("assessment_number");
	}
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
		<title>新增考核方式</title> 
	    <style type="text/css">
			.inline{ position: relative; display: inline-block; margin-right: 10px; }
	    </style>
	</head>
	<body>
		<div style="margin: 15px;">
			<fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
				<legend>新增考核方式</legend>
			</fieldset>
			<form class="layui-form" action="edit_assessment_maintenance.jsp?ac=edit&id=<%=id%>" method="post" >
                <div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">考核方式名称</label>
					<div class="layui-input-inline">
						<input type="text" id="assessment_name" name="assessment_name" class="layui-input" value="<%=assessment_name %>"  lay-verify="required">
					</div>
				</div>	
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">考核方式编码</label>
					<div class="layui-input-inline">
						<input type="text" id="assessment_number" name="assessment_number" class="layui-input" value="<%=assessment_number %>" readonly>
					</div>
				</div>	
			
				<div class="layui-form-item" style="margin-bottom:45px">
					<div class="layui-input-block"  style="margin-left:540px">			
						<button  class="layui-btn"  lay-submit>确认</button>
					</div>
				</div>
			</form>
		</div>
	</body>
</html>
<script>
	 layui.use(['element','form','upload','layer','laydate'], function() {
				   var $    = layui.jquery ,
					form    = layui.form,
					 layer   = layui.layer,
					 laydate = layui.laydate,
					element = layui.element,
					upload = layui.upload;
				    form.render('select');  
					laydate.render({
					    elem: '#start_date'
					  });
				})		
	 var index = parent.layer.getFrameIndex(window.name);
</script>
<% if("edit".equals(ac)){ 
	  assessment_name=request.getParameter("assessment_name");
	  assessment_number=request.getParameter("assessment_number");
	  id = request.getParameter("id");
	 if(assessment_name==null){assessment_name="";}
	 if(assessment_number==null){assessment_number="";}
	try{
		
		   String sql="UPDATE `dict_assessment` SET `assessment_name`='"+assessment_name+"',`assessment_number`= '"+assessment_number+"' WHERE id="+id+";";
	   
		   if(db.executeUpdate(sql)==true){
			   out.println("<script>parent.layer.msg('编辑 成功'); parent.layer.close(index); parent.location.reload();</script>");
		   }else{
			   out.println("<script>parent.layer.msg('编辑失败!请重新输入');</script>");
		   }
	 }catch (Exception e){
	    out.println("<script>parent.layer.msg('编辑失败');</script>");
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