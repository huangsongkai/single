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
			"		courses_bigclass_code,                      "+
			"		courses_bigclass_name,                      "+
			"		courses_sort,                               "+
			"		big_class_tag,                              "+
			"		show_mark                                   "+
			"		FROM                                        "+
			"		dict_courses_class_big       "+
			"		WHERE id = '"+id+"'; "; 
	String base_courses_bigclass_code = "";
	String base_courses_bigclass_name = "";
	String base_courses_sort = "";
	String base_big_class_tag = "";
	String base_show_mark = "";
	ResultSet base_set = db.executeQuery(select_sql);
	while(base_set.next()){
		base_courses_bigclass_code = base_set.getString("courses_bigclass_code");
		base_courses_bigclass_name = base_set.getString("courses_bigclass_name");
		base_courses_sort = base_set.getString("courses_sort");
		base_big_class_tag = base_set.getString("big_class_tag");
		base_show_mark = base_set.getString("show_mark");
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
		<title>修改课程大类</title> 
	    <style type="text/css">
			.inline{ position: relative; display: inline-block; margin-right: 10px; }
	    </style>
	</head>
	<body>
		<div style="margin: 15px;">
			<fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
				<legend>修改课程大类</legend>
			</fieldset>
			<form class="layui-form" action="?ac=add" method="post" >
				<input type="hidden" name="base_id" value="<%=id%>"/>
                <div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">课程大类代码</label>
					<div class="layui-input-inline">
						<input type="text" id="courses_bigclass_code" name="courses_bigclass_code" value="<%=base_courses_bigclass_code %>" class="layui-input"  lay-verify="required">
					</div>
				</div>	
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">课程大类名称</label>
					<div class="layui-input-inline">
						<input type="text" id="courses_bigclass_name"   lay-verify="required" name="courses_bigclass_name" value="<%=base_courses_bigclass_name %>" class="layui-input" >
					</div>
				</div>	
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">排列顺序码</label>
					<div class="layui-input-inline">
						<input type="text" id="courses_sort" name="courses_sort" value="<%=base_courses_sort %>" class="layui-input" >
					</div>
				</div>	
				
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">课程大类标识</label>
					<div class="layui-input-inline">
<%--						<input type="text" id="big_class_tag" name="big_class_tag" value="<%=base_big_class_tag %>" class="layui-input"   lay-verify="required" >--%>
						<select class="layui-input" name="big_class_tag" lay-verify="required">
							<option value="">无</option>
							<%
								String bigTag_sql = "SELECT typename,id FROM type where typegroupcode='bigClassTag'";
								ResultSet bigTag_set = db.executeQuery(bigTag_sql);
								while(bigTag_set.next()){
							%>
								<%if(base_big_class_tag!=null && base_big_class_tag.equals(bigTag_set.getString("id"))){ %>
									<option value="<%=bigTag_set.getString("id")%>" selected="selected"><%=bigTag_set.getString("typename") %></option>
								<%}else{ %>
									<option value="<%=bigTag_set.getString("id")%>"><%=bigTag_set.getString("typename") %></option>
								<%} %>
							<%}if(bigTag_set!=null){bigTag_set.close();} %>
						</select>
					</div>
				</div>
				
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">课表是否标记</label>
					<div class="layui-input-inline">
						<select name="show_mark" class="layui-input" lay-filter="teaching_research_id">
                          <option value="1" <%if("1".equals(base_show_mark)){out.println("selected='selected'");} %> >是</option>
                          <option value="0" <%if("0".equals(base_show_mark)){out.println("selected='selected'");} %>>否</option>
                         </select> 
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
	
	//隐藏于
	String base_id = request.getParameter("base_id");
	
	String courses_bigclass_code = request.getParameter("courses_bigclass_code");
	String courses_bigclass_name = request.getParameter("courses_bigclass_name");
	String courses_sort = request.getParameter("courses_sort");
	String big_class_tag = request.getParameter("big_class_tag");
	String show_mark = request.getParameter("show_mark");
	
	
	try{
	   String update_sql="UPDATE dict_courses_class_big 							 "+
			"		SET                                                      "+
			"		courses_bigclass_code = '"+courses_bigclass_code+"' ,        "+
			"		courses_bigclass_name = '"+courses_bigclass_name+"' ,        "+
			"		courses_sort = '"+courses_sort+"' ,                          "+
			"		big_class_tag = '"+big_class_tag+"' ,                        "+
			"		show_mark = '"+show_mark+"'                                  "+
			"		WHERE                                                    "+
			"		id = '"+base_id+"' ;";
			
	   if(db.executeUpdate(update_sql)==true){
		   out.println("<script>parent.layer.msg('修改课程大类 成功'); parent.layer.close(index); parent.location.reload();</script>");
	   }else{
		   out.println("<script>parent.layer.msg('修改课程大类失败!请重新输入');</script>");
	   }
	 }catch (Exception e){
	    out.println("<script>parent.layer.msg('修改课程大类失败');</script>");
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