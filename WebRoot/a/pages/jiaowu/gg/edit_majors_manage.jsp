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
	//获取信息
	String id = request.getParameter("id");

	String select_sql = "SELECT 	id, 				"+
			"			departments_id,                 "+
			"			majors_number,                  "+
			"			major_name,                     "+
			"			major_field,                    "+
			"			gradation,                      "+
			"			eductional_systme_id,           "+
			"			major_code,                     "+
			"			major_name_customer,            "+
			"			enroll_student_season,          "+
			"			disciplines,                    "+
			"			establish_year,					"+
			"			school_year                     "+
			"			FROM                            "+
			"			major                           "+
			"			WHERE id='"+id+"' ;";
			
	ResultSet base_set = db.executeQuery(select_sql);
	String base_departments_id = "";
	String base_majors_number = "";
	String base_major_name = "";
	String base_major_field = "";
	String base_gradation = "";
	String base_eductional_systme_id = "";
	String base_major_code = "";
	String base_major_name_customer = "";
	String base_enroll_student_season = "";
	String base_disciplines = "";
	String base_school_year = "";
	String base_establish_year = "";
	
	while(base_set.next()){
		base_departments_id = base_set.getString("departments_id");
		base_majors_number = base_set.getString("majors_number");
		base_major_name = base_set.getString("major_name");
		base_major_field = base_set.getString("major_field");
		base_gradation = base_set.getString("gradation");
		base_eductional_systme_id = base_set.getString("eductional_systme_id");
		base_major_code = base_set.getString("major_code");
		base_major_name_customer = base_set.getString("major_name_customer");
		base_enroll_student_season = base_set.getString("enroll_student_season");
		base_disciplines = base_set.getString("disciplines");
		base_school_year = base_set.getString("school_year");
		base_establish_year = base_set.getString("establish_year");
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
		<title>新增专业信息管理</title> 
	    <style type="text/css">
			.inline{ position: relative; display: inline-block; margin-right: 10px; }
	    </style>
	</head>
	<body>
		<div style="margin: 15px;">
			<fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
				<legend>新增专业信息管理</legend>
			</fieldset>
			<form class="layui-form" action="?ac=update" method="post" >
				<input type="hidden" name="base_id" value="<%=id%>"/>
                <div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">所属院系</label>
					<div class="layui-input-inline">
						<select name="departments_id"  lay-verify="required" lay-search lay-verify="required">
							<option value="">请选择</option>
							<%
								String depar_sql = "select id,departments_name from dict_departments;";
								ResultSet set = db.executeQuery(depar_sql);
								while(set.next()){
							%>
								<%if(base_departments_id.equals(set.getString("id"))){ %>
									<option value="<%=set.getString("id")%>" selected="selected"><%=set.getString("departments_name") %></option>
								<%}else{ %>
									<option value="<%=set.getString("id")%>"><%=set.getString("departments_name") %></option>
								<%} %>
								
							<%}if(set!=null){set.close();} %>
								    
						</select>
					</div>
				</div>	
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">专业编号</label>
					<div class="layui-input-inline">
						<input type="text" id="majors_number" name="majors_number" value="<%=base_majors_number %>" class="layui-input"  lay-verify="required">
					</div>
				</div>	
				
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">专业名称</label>
					<div class="layui-input-inline">
						<input type="text" id="major_name" name="major_name" value="<%=base_major_name %>" class="layui-input"  lay-verify="required">
					</div>
				</div>	
				
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">专业方向</label>
					<div class="layui-input-inline">
						<input type="text" id="major_field" name="major_field" value="<%=base_major_field %>" class="layui-input"  lay-verify="required">
					</div>
				</div>
				
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">培养层次</label>
					<div class="layui-input-inline">
<%--						<input type="text" id="gradation" name="gradation" value="<%=base_gradation %>" class="layui-input"  lay-verify="required">--%>
						<select name="gradation"  lay-verify="required" lay-search >
							<option value="">请选择</option>
							<%
								String jz_sql = "select id,name from jz_culture_level;";
								ResultSet jz_sqlRs = db.executeQuery(jz_sql);
								while(jz_sqlRs.next()){
							%>
								<%if(base_gradation.equals(jz_sqlRs.getString("id"))){ %>
									<option value="<%=jz_sqlRs.getString("id")%>" selected="selected"><%=jz_sqlRs.getString("name") %></option>
								<%}else{ %>
									<option value="<%=jz_sqlRs.getString("id")%>"><%=jz_sqlRs.getString("name") %></option>
								<%} %>
							<%}if(jz_sqlRs!=null){jz_sqlRs.close();} %>
						</select>
					</div>
				</div>
				
				
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">学制</label>
					<div class="layui-input-inline">
						<select name="eductional_systme_id"  lay-verify="required" lay-search >
							<option value="">请选择</option>
							<%
								String eductional_sql = "select id,eductional_systme_name from dict_eductional_systme;";
								ResultSet set_eductional = db.executeQuery(eductional_sql);
								while(set_eductional.next()){
							%>
								<%if(base_eductional_systme_id.equals(set_eductional.getString("id"))){ %>
									<option value="<%=set_eductional.getString("id")%>" selected="selected"><%=set_eductional.getString("eductional_systme_name") %></option>
								<%}else{ %>
									<option value="<%=set_eductional.getString("id")%>"><%=set_eductional.getString("eductional_systme_name") %></option>
								<%} %>
								
							<%}if(set_eductional!=null){set_eductional.close();} %>
								    
						</select>
					</div>
				</div>
				
				
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">专业代码</label>
					<div class="layui-input-inline">
						<input type="text" id="major_code" name="major_code" value="<%=base_major_code %>" class="layui-input"  lay-verify="required">
					</div>
				</div>
				
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">部颁专业名称</label>
					<div class="layui-input-inline">
						<input type="text" id="major_name_customer" name="major_name_customer" value="<%=base_major_name_customer %>" class="layui-input"  lay-verify="required">
					</div>
				</div>
				
				
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">招生季节</label>
					<div class="layui-input-inline">
						<input type="text" id="enroll_student_season" name="enroll_student_season" value="<%=base_enroll_student_season %>" class="layui-input"  lay-verify="required" >
					</div>
				</div>
				
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">学科类别</label>
					<div class="layui-input-inline">
<%--						<input type="text" id="disciplines" name="disciplines" value="<%=base_disciplines %>" class="layui-input"  lay-verify="required">--%>
						<select name="disciplines"  lay-verify="required" lay-search >
							<option value="">请选择</option>
							<%
								String disciplines_sql = "SELECT categoryname,id from dict_subject_category";
								ResultSet disRs = db.executeQuery(disciplines_sql);
								while(disRs.next()){
							%>
								<%if(base_disciplines.equals(disRs.getString("id"))){ %>
									<option value="<%=disRs.getString("id")%>" selected="selected"><%=disRs.getString("categoryname") %></option>
								<%}else{ %>
									<option value="<%=disRs.getString("id")%>"><%=disRs.getString("categoryname") %></option>
								<%} %>
								
							<%}if(disRs!=null){disRs.close();} %>
								    
						</select>
					</div>
				</div>
				
				
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">开设年份</label>
					<div class="layui-input-inline">
						<input type="text" id="establish_year" name="establish_year" value="<%=base_establish_year %>" class="layui-input"  lay-verify="required" >
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
				layer = layui.layer,
				layedit = layui.layedit,
				laydate = layui.laydate;
				})
	 var index = parent.layer.getFrameIndex(window.name);

	 <% if("update".equals(ac)){ 
		 	String base_id = request.getParameter("base_id");
			//收集数据
			String departments_id = request.getParameter("departments_id");
			String majors_number = request.getParameter("majors_number");
			String major_name = request.getParameter("major_name");
			String major_field= request.getParameter("major_field");
			String gradation = request.getParameter("gradation");
			String eductional_systme_id = request.getParameter("eductional_systme_id");
			String major_code = request.getParameter("major_code");
			String major_name_customer = request.getParameter("major_name_customer");
			String enroll_student_season = request.getParameter("enroll_student_season");
			String disciplines = request.getParameter("disciplines");
			String school_year = request.getParameter("school_year");
			String establish_year = request.getParameter("establish_year");
			
			String update_sql = "UPDATE major 							"+
						"		SET                                                     "+
						"		departments_id = '"+departments_id+"' ,                     "+
						"		majors_number = '"+majors_number+"' ,                       "+
						"		major_name = '"+major_name+"' ,                             "+
						"		major_field = '"+major_field+"' ,                           "+
						"		gradation = '"+gradation+"' ,                               "+
						"		eductional_systme_id = '"+eductional_systme_id+"' ,         "+
						"		major_code = '"+major_code+"' ,                             "+
						"		major_name_customer = '"+major_name_customer+"' ,           "+
						"		enroll_student_season = '"+enroll_student_season+"' ,       "+
						"		disciplines = '"+disciplines+"' ,                           "+
						"		establish_year = '"+establish_year+"'						"+
						"		WHERE                                                   "+
						"		id = '"+base_id+"' ;";
			
			boolean state = db.executeUpdate(update_sql);
			if(state){
			   out.println("parent.layer.msg('修改专业信息 成功',{icon:1,time:1000,offset:'150px'},function(){  window.parent.location.reload(true);var index = parent.layer.getFrameIndex(window.name); parent.layer.close(index); });");
		   }else{
			   out.println("parent.layer.msg('修改专业信息 失败');");
		   }
			//关闭数据与serlvet.out
			
			if (page != null) {page = null;}
			
		}%>

</script>

 
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