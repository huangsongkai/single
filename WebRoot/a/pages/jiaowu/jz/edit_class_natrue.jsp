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
	//编辑信息
	String id = request.getParameter("id");
	String select_sql = "SELECT 	id, 					 "+
		"			nature,                                  "+
		"			nature_code                              "+
		"			FROM                                     "+
		"			dict_course_nature        "+
		"			WHERE id = '"+id+"';";
	String base_nature = "";
	String base_nature_code = "";
	ResultSet base_set = db.executeQuery(select_sql);
	while(base_set.next()){
		base_nature = base_set.getString("nature");
		base_nature_code = base_set.getString("nature_code");
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
		<title>编辑课程性质</title> 
	    <style type="text/css">
			.inline{ position: relative; display: inline-block; margin-right: 10px; }
	    </style>
	</head>
	<body>
		<div style="margin: 15px;">
			<fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
				<legend>编辑课程性质</legend>
			</fieldset>
			<form class="layui-form" action="?ac=add" method="post" >
				<input type="hidden" name="base_id" value="<%=id%>" />
                <div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">性质名称</label>
					<div class="layui-input-inline">
						<input type="text" id="nature" name="nature" value="<%=base_nature %>" class="layui-input" lay-verify="required"  >
					</div>
				</div>	
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">性质编码</label>
					<div class="layui-input-inline">
						<input type="text" id="nature_code" name="nature_code" value="<%=base_nature_code %>" class="layui-input"  readonly>
					</div>
				</div>	
					
				<div class="layui-form-item" style="margin-bottom:45px">
					<div class="layui-input-block"  style="margin-left:540px">			
						<button  class="layui-btn"  lay-sumbit >确认</button>
					</div>
				</div>
			</form>
		</div>
	</body>
<script>

	 layui.use('form', function() {
			var form = layui.form,
				layer = layui.layer,
				layedit = layui.layedit,
				laydate = layui.laydate;
				
			
				})
	 var index = parent.layer.getFrameIndex(window.name);

</script>
</html>
<% if("add".equals(ac)){ 
	
	String base_id = request.getParameter("base_id");
	String nature = request.getParameter("nature");
	String nature_code = request.getParameter("nature_code");
	try{
	   String sql="UPDATE dict_course_nature 			"+
			"		SET                                 "+
			"		nature = '"+nature+"' ,                 "+
			"		nature_code = '"+nature_code+"'         "+
			"		WHERE                               "+
			"		id = '"+base_id+"' ;";
	   if(db.executeUpdate(sql)==true){
		   out.println("<script>parent.layer.msg('添加课程性质成功'); parent.layer.close(index); parent.location.reload();</script>");
	   }else{
		   out.println("<script>parent.layer.msg('添加课程性质失败!请重新输入');</script>");
	   }
	 }catch (Exception e){
	    out.println("<script>parent.layer.msg('添加课程性质失败');</script>");
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