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
<!DOCTYPE html>
<html>
	<head>
		<meta charset="utf-8"> 
	    <meta name="viewport" content="width=device-width, initial-scale=1"> 
	    
	    <link rel="stylesheet" href="../../../pages/css/sy_style.css">	    
	    <link rel="stylesheet" href="../../js/layui2/css/layui.css">
		<script type="text/javascript" src="../../js/jquery-1.9.1.js" ></script><!--通用jquery-->
		<script src="../../js/layui2/layui.js"></script>
		<title>新增课程大类</title> 
	    <style type="text/css">
			.inline{ position: relative; display: inline-block; margin-right: 10px; }
	    </style>
	</head>
	<body>
		<div style="margin: 15px;">
			<fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
				<legend>新增课程大类</legend>
			</fieldset>
			<form class="layui-form" action="?ac=add" method="post" >
                <div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">课程大类代码</label>
					<div class="layui-input-inline">
						<input type="text" id="courses_bigclass_code" name="courses_bigclass_code" class="layui-input"  lay-verify="required" >
					</div>
				</div>	
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">课程大类名称</label>
					<div class="layui-input-inline">
						<input type="text" id="courses_bigclass_name" name="courses_bigclass_name" class="layui-input"  lay-verify="required" >
					</div>
				</div>	
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">排列顺序码</label>
					<div class="layui-input-inline">
						<input type="text" id="courses_sort" name="courses_sort" class="layui-input" >
					</div>
				</div>	
				
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">课程大类标识</label>
					<div class="layui-input-inline">
<%--						<input type="text" id="big_class_tag" name="big_class_tag" class="layui-input"  lay-verify="required" >--%>
						<select class="layui-input" name="big_class_tag" lay-verify="required">
							<option value="">无</option>
							<%
								String bigTag_sql = "SELECT typename,id FROM type where typegroupcode='bigClassTag'";
								ResultSet bigTag_set = db.executeQuery(bigTag_sql);
								while(bigTag_set.next()){
							%>
									<option value="<%=bigTag_set.getString("id")%>"><%=bigTag_set.getString("typename") %></option>
							<%}if(bigTag_set!=null){bigTag_set.close();} %>
						</select>
					</div>
				</div>
				
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">课表是否标记</label>
					<div class="layui-input-inline">
						<select name="show_mark" class="layui-input" lay-filter="teaching_research_id">
                          <option value="1">是</option>
                          <option value="0">否</option>
                         </select> 
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
	
	String courses_bigclass_code = request.getParameter("courses_bigclass_code");
	String courses_bigclass_name = request.getParameter("courses_bigclass_name");
	String courses_sort = request.getParameter("courses_sort");
	String big_class_tag = request.getParameter("big_class_tag");
	String show_mark = request.getParameter("show_mark");
	
	
	try{
	   String sql="INSERT INTO dict_courses_class_big 	"+
			"	(                                       "+
			"		courses_bigclass_code,              "+
			"		courses_bigclass_name,              "+
			"		courses_sort,                       "+
			"		big_class_tag,                      "+
			"		show_mark                           "+
			"		)                                   "+
			"		VALUES                              "+
			"		(                                   "+
			"		'"+courses_bigclass_code+"',            "+
			"		'"+courses_bigclass_name+"',            "+
			"		'"+courses_sort+"',                     "+
			"		'"+big_class_tag+"',                    "+
			"		'"+show_mark+"'                         "+
			"		);";
	   if(db.executeUpdate(sql)==true){
		   out.println("<script>parent.layer.msg('添加课程大类 成功'); parent.layer.close(index); parent.location.reload();</script>");
	   }else{
		   out.println("<script>parent.layer.msg('添加课程大类失败!请重新输入');</script>");
	   }
	 }catch (Exception e){
	    out.println("<script>parent.layer.msg('添加课程大类失败');</script>");
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