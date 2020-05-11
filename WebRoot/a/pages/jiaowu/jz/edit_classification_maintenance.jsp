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
	String select_sql = "SELECT 	id, 						"+
			"		category,                                   "+
			"		category_code                               "+
			"		FROM                                        "+
			"		dict_course_category         "+
			"		WHERE id = '"+id+"';";
	String base_category = "";
	String base_category_code = "";
	ResultSet base_set = db.executeQuery(select_sql);
	while(base_set.next()){
		base_category = base_set.getString("category");
		base_category_code = base_set.getString("category_code");
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
		<title>修改课程分类</title> 
	    <style type="text/css">
			.inline{ position: relative; display: inline-block; margin-right: 10px; }
	    </style>
	</head>
	<body>
		<div style="margin: 15px;">
			<fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
				<legend>修改课程分类</legend>
			</fieldset>
			<form class="layui-form" action="?ac=add" method="post" >
				<input type="hidden" name="base_id" value="<%=id%>" />
                <div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">课程类别名</label>
					<div class="layui-input-inline">
						<input type="text" id="category" name="category" value="<%=base_category %>" class="layui-input"  lay-verify="required">
					</div>
				</div>	
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">课程类别编码</label>
					<div class="layui-input-inline">
						<input type="text" id="category_code" name="category_code" value="<%=base_category_code %>" class="layui-input"  lay-verify="required"  readonly>
					</div>
				</div>	
					
				<div class="layui-form-item" style="margin-bottom:45px">
					<div class="layui-input-block"  style="margin-left:540px">			
						<button  class="layui-btn"  lay-submit >确认</button>
					</div>
				</div>
			</form>
		</div>
	</body>
</html>
<script>

	 layui.use('form', function() {
			var form = layui.form,
				layer = layui.layer,
				layedit = layui.layedit,
				laydate = layui.laydate;
				})
	 var index = parent.layer.getFrameIndex(window.name);

</script>
<% if("add".equals(ac)){ 
	String base_id = request.getParameter("base_id");
	String category = request.getParameter("category");
	String category_code = request.getParameter("category_code");
	try{
	   String sql="UPDATE dict_course_category 			"+
			"		SET                                 "+
			"		category = '"+category+"' ,             "+
			"		category_code = '"+category_code+"'     "+
			"		WHERE                               "+
			"		id = '"+base_id+"' ;";
	   if(db.executeUpdate(sql)==true){
		   out.println("<script>parent.layer.msg('添加课程分类 成功'); parent.layer.close(index); parent.location.reload();</script>");
	   }else{
		   out.println("<script>parent.layer.msg('添加课程分类失败!请重新输入');</script>");
	   }
	 }catch (Exception e){
	    out.println("<script>parent.layer.msg('添加课程分类失败');</script>");
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