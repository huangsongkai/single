<%@ page trimDirectiveWhitespaces="true" %>
<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@page import="service.dao.db.Page"%>
<%@include file="../../cookie.jsp"%>
<%@page import="java.util.Date"%>
<%@page import="v1.haocheok.commom.common"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="org.apache.commons.lang3.StringUtils"%>

<%
common common=new common();
   String sysid= request.getParameter("sysid");
   if(regex_num(sysid)==false){sysid="0";}
%>

<%
	String id = request.getParameter("id");
	String select_sql = "SELECT 	 			"+
		"			teacher_number,                 "+
		"			telephone,                 "+
		"			sex,                            "+
		"			teacher_class,                  "+
		"			birthday,                       "+
		"			director,                       "+
		"			political_status,               "+
		"			nation,               "+
		"			native_place,                   "+
		"			faculty,                        "+
		"			teachering_office,              "+
		"			teaching_staff_office,              "+
		"			technical_title,                "+
		"			duty,                           "+
		"			stal,                           "+
		"			education,                      "+
		"			degree,                         "+
		"			post_status,                    "+
		"			family_name,                    "+
		"			residence,                      "+
		"			id_number,                      "+
		"			into_school_time,               "+
		"			regular_time,                   "+
		"			subject_category,               "+
		"			remark,                         "+
		"			work_time,                         "+
		"			encryption_dog_number,          "+
		"			old_name,                    "+
		"			new_name,                    "+
		"			old_id_number,                    "+
		"			graduate_shcool,                    "+
		"			administrative_level,                    "+
		"			Zgstate,                    "+
		"			teacher_name                    "+
		"			FROM                            "+
		"			teacher_basic    "+
		"			WHERE id = '"+id+"';";
	ResultSet set = db.executeQuery(select_sql);
	String base_teacher_number = "";
	String telephone = "";
	String base_sex = "";
	String base_teacher_class = "";
	String base_birthday = "";
	String base_director = "";
	String nation = "";
	String base_political_status = "";
	String base_native_place = "";
	String base_faculty = "";
	String base_teachering_office = "";
	String base_teaching_staff_office = "";
	String base_technical_title = "";
	String base_duty = "";
	String base_stal = "";
	String base_education = "";
	String base_degree = "";
	String work_time = "";
	String base_post_status = "";
	String base_family_name = "";
	String base_residence = "";
	String base_id_number = "";
	String base_into_school_time = "";
	String base_regular_time = "";
	String base_subject_category = "";
	String base_remark = "";
	String base_encryption_dog_number = "";
	String base_teacher_name = "";
	String old_name = "";
	String new_name = "";
	String old_id_number = "";
	String graduate_shcool = "";
	String administrative_level = "";
	String Zgstate = "";
	
	while(set.next()){
		Zgstate = set.getString("Zgstate");
		if(StringUtils.isBlank(Zgstate)){Zgstate ="";}
		old_name = set.getString("old_name");
		if(StringUtils.isBlank(old_name)){old_name ="";}
		telephone = set.getString("telephone");
		if(StringUtils.isBlank(telephone)){telephone ="";}
		new_name = set.getString("new_name");
		if(StringUtils.isBlank(new_name)){new_name ="";}
		old_id_number = set.getString("old_id_number");
		if(StringUtils.isBlank(old_id_number)){old_id_number ="";}
		nation = set.getString("nation");
		if(StringUtils.isBlank(nation)){nation ="";}
		graduate_shcool = set.getString("graduate_shcool");
		if(StringUtils.isBlank(graduate_shcool)){graduate_shcool ="";}
		administrative_level = set.getString("administrative_level");
		if(StringUtils.isBlank(administrative_level)){administrative_level ="";}
		base_teacher_number = set.getString("teacher_number");
		if(StringUtils.isBlank(base_teacher_number)){base_teacher_number ="";}
		base_sex = set.getString("sex");	if(StringUtils.isBlank(base_sex)){base_sex ="";}
		base_teacher_class = set.getString("teacher_class");		if(StringUtils.isBlank(base_teacher_class)){base_teacher_class ="";}
		base_birthday = set.getString("birthday");
		if(StringUtils.isBlank(base_birthday)){base_birthday ="";}
		base_director = set.getString("director");
		if(StringUtils.isBlank(base_director)){base_director ="";}
		base_political_status = set.getString("political_status");
		if(StringUtils.isBlank(base_political_status)){base_political_status ="";}
		base_native_place = set.getString("native_place");
		if(StringUtils.isBlank(base_native_place)){base_native_place ="";}
		base_faculty = set.getString("faculty");
		if(StringUtils.isBlank(base_faculty)){base_faculty ="";}
		base_teachering_office = set.getString("teachering_office");
		if(StringUtils.isBlank(base_teachering_office)){base_teachering_office ="";}
		base_teaching_staff_office = set.getString("teaching_staff_office");
		if(StringUtils.isBlank(base_teaching_staff_office)){base_teaching_staff_office ="";}
		base_technical_title = set.getString("technical_title");
		if(StringUtils.isBlank(base_technical_title)){base_technical_title ="";}
		base_duty = set.getString("duty");
		if(StringUtils.isBlank(base_duty)){base_duty ="";}
		base_stal = set.getString("stal");
		if(StringUtils.isBlank(base_stal)){base_stal ="";}
		base_education = set.getString("education");
		if(StringUtils.isBlank(base_education)){base_education ="";}
		base_degree = set.getString("degree");
		if(StringUtils.isBlank(base_degree)){base_degree ="";}
		base_post_status = set.getString("post_status");
		if(StringUtils.isBlank(base_post_status)){base_post_status ="";}
		base_family_name = set.getString("family_name");
		if(StringUtils.isBlank(base_family_name)){base_family_name ="";}
		base_residence = set.getString("residence");
		if(StringUtils.isBlank(base_residence)){base_residence ="";}
		base_id_number = set.getString("id_number");
		if(StringUtils.isBlank(base_id_number)){base_id_number ="";}
		base_into_school_time = set.getString("into_school_time");
		if(StringUtils.isBlank(base_into_school_time)){base_into_school_time ="";}
		base_regular_time = set.getString("regular_time");
		if(StringUtils.isBlank(base_regular_time)){base_regular_time ="";}
		base_subject_category = set.getString("subject_category");
		if(StringUtils.isBlank(base_subject_category)){base_subject_category ="";}
		base_remark = set.getString("remark");
		if(StringUtils.isBlank(base_remark)){base_remark ="";}
		work_time = set.getString("work_time");
		if(StringUtils.isBlank(work_time)){work_time ="";}
		base_encryption_dog_number = set.getString("encryption_dog_number");
		if(StringUtils.isBlank(base_encryption_dog_number)){base_encryption_dog_number ="";}
		base_teacher_name = set.getString("teacher_name");
	}if(set!=null){set.close();}
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
		<script src="../../js/ajaxs.js"></script>
		<title>修改教师信息</title> 
	    <style type="text/css">
			.inline{ position: relative; display: inline-block; margin-right: 10px; }
	    </style>
	    <script>
			 layui.use(['form','laydate'], function() {
					var	layer = layui.layer,
						laydate = layui.laydate,
						layedit = layui.layedit,
						laydate = layui.laydate;
					//初始化 多个时间控件，class =time 即可
					$('.time').each(function(){
						laydate.render({
						elem: this
						});
					})
			})
		
		</script>
	</head>
	<body>
		<div style="margin: 15px;">
			<fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
				<legend>修改教师信息</legend>
			</fieldset>
			<form class="layui-form" action="?ac=update" method="post" >
			
				<input type="hidden" name="base_id" value="<%=id%>" />
                <div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">教师编号</label>
					<div class="layui-input-inline">
						<input type="text" id="teacher_number" name="teacher_number" value="<%=base_teacher_number %>" class="layui-input"   lay-verify="required">
					</div>
				</div>	
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">教师姓名</label>
					<div class="layui-input-inline">
						<input type="text" id="teacher_name" name="teacher_name" value="<%=base_teacher_name %>" class="layui-input"   lay-verify="required">
					</div>
				</div>
						<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">曾用名</label>
					<div class="layui-input-inline">
						<input type="text" id="old_name" name="old_name" class="layui-input"  value="<%=old_name%>">
					</div>
				</div>
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">现用名</label>
					<div class="layui-input-inline">
						<input type="text" id="new_name" name="new_name" class="layui-input"  value="<%=new_name%>">
					</div>
				</div>
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">性别</label>
					<div class="layui-input-inline">
						<select name="sex" class="layui-input" lay-search  >
							<option value="1" <%if("男".equals(base_sex)){out.println("selected='selected'");} %>>男</option>
							<option value="2" <%if("女".equals(base_sex)){out.println("selected='selected'");} %>>女</option>
						</select>
					</div>
				</div>	
						<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">身份证号</label>
					<div class="layui-input-inline">
						<input type="text" id="id_number" name="id_number" value="<%=base_id_number %>" class="layui-input"   lay-verify="required" >
					</div>
				</div>
					<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">曾用身份证号</label>
					<div class="layui-input-inline">
						<input type="text" id="old_id_number" name="old_id_number" value="<%=old_id_number %>" class="layui-input" >
					</div>
				</div>
					<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">联系电话</label>
					<div class="layui-input-inline">
						<input type="text" id="telephone" name="telephone" value="<%=telephone %>" class="layui-input"  lay-verify="required">
					</div>
				</div>
					<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">民族</label>
					<div class="layui-input-inline">
						<input type="text" id="nation" name="nation" value="<%=nation %>" class="layui-input"  lay-verify="required">
					</div>
				</div>
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">教师类别</label>
					<div class="layui-input-inline">
						<select class="layui-input" name="teacher_class" lay-search lay-verify="">
							<option value="">无</option>
							<%
								String teacher_sql = "select id,categoryname from teacher_class";
								ResultSet teacher_set = db.executeQuery(teacher_sql);
								while(teacher_set.next()){
							%>
								<%if(base_teacher_class!=null && base_teacher_class.equals(teacher_set.getString("id"))){ %>
									<option value="<%=teacher_set.getString("id")%>" selected="selected"><%=teacher_set.getString("categoryname") %></option>
								<%}else{ %>
									<option value="<%=teacher_set.getString("id")%>"><%=teacher_set.getString("categoryname") %></option>
								<%} %>
							<%}if(teacher_set!=null){teacher_set.close();} %>
						</select>
					</div>
				</div>
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">出生日期</label>
					<div class="layui-input-inline">
						<input type="text" id="birthday" name="birthday" value="<%=base_birthday %>" class="layui-input time"   lay-verify="" readonly>
					</div>
				</div>	
				
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">主任标识</label>
					<div class="layui-input-inline">
						<select class="layui-input" name="director" lay-search lay-verify="" >
							<option value="">无</option>
							<option value="0" <%if("0".equals(base_director)){out.println("selected='selected'");} %>>否</option>
							<option value="1" <%if("1".equals(base_director)){out.println("selected='selected'");} %>>是</option>
						</select>
					</div>
				</div>
				
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">政治面貌</label>
					<div class="layui-input-inline">
<%--						<input type="text" id="political_status" name="political_status" value="<%=base_political_status %>" class="layui-input"   lay-verify="required" >--%>
						<select name="political_status"  lay-verify="" lay-search >
								<option value="">请选择</option>
								<%
									String zz_sql = "SELECT typename,id FROM type where typegroupcode='politicsStatus'";
									ResultSet zz_sqlRs = db.executeQuery(zz_sql);
									while(zz_sqlRs.next()){
								%>
									<%if(base_political_status.equals(zz_sqlRs.getString("id"))){ %>
										<option value="<%=zz_sqlRs.getString("id")%>" selected="selected"><%=zz_sqlRs.getString("typename") %></option>
									<%}else{ %>
										<option value="<%=zz_sqlRs.getString("id")%>"><%=zz_sqlRs.getString("typename") %></option>
									<%} %>
								<%}if(zz_sqlRs!=null){zz_sqlRs.close();} %>
							</select>
					</div>
				</div>
				
				
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">籍贯</label>
					<div class="layui-input-inline">
						<input type="text" id="native_place" name="native_place" value="<%=base_native_place %>" class="layui-input"   lay-verify="" >
					</div>
				</div>
				
						<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">行政级别</label>
					<div class="layui-input-inline">
<%--						<input type="text" id="administrative_level" name="administrative_level" class="layui-input"  value="<%=administrative_level%> "  lay-verify="required">--%>
						<select name="administrative_level"   lay-search >
							<option value="">无</option>
							<%
								String level_sql = "SELECT typename,id FROM type where typegroupcode='administrativeLevel'";
								ResultSet level_sqlRs = db.executeQuery(level_sql);
								while(level_sqlRs.next()){
							%>
								<%if(administrative_level!=null && administrative_level.equals(level_sqlRs.getString("id"))){ %>
									<option value="<%=level_sqlRs.getString("id")%>" selected="selected"><%=level_sqlRs.getString("typename")%></option>
									<%}else{ %>
									<option value="<%=level_sqlRs.getString("id")%>"><%=level_sqlRs.getString("typename") %></option>
							<%}}if(level_sqlRs!=null){level_sqlRs.close();} %>
						</select>
					</div>
				</div>
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">所属院系</label>
					<div class="layui-input-inline">
						<select class="layui-input" name="faculty" lay-filter="department" lay-search>
							<option value="">无</option>
							<%
								String dict_departments_sql = "select id,departments_name from dict_departments ;";
								ResultSet dict_departments_set = db.executeQuery(dict_departments_sql);
								while(dict_departments_set.next()){
							%>
								<%if(base_faculty!=null && base_faculty.equals(dict_departments_set.getString("id"))){ %>
									<option value="<%=dict_departments_set.getString("id")%>" selected="selected"><%=dict_departments_set.getString("departments_name")%></option>
								<%}else{ %>
									<option value="<%=dict_departments_set.getString("id")%>"><%=dict_departments_set.getString("departments_name")%></option>
								<%} %>
							<%}if(dict_departments_set!=null){dict_departments_set.close();} %>
						</select>
					</div>
				</div>
				
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">任课教研室</label>
					<div class="layui-input-inline">
						<select class="layui-input" name="teachering_office" id="teachering_office" lay-search  >
							<option value="">无</option>
							<%
								String teaching_research_sql = "select id,teaching_research_name from teaching_research where is_teaching=1;";
								ResultSet teaching_research_set = db.executeQuery(teaching_research_sql);
								while(teaching_research_set.next()){
							%>
								<%if(base_teachering_office!=null && base_teachering_office.equals(teaching_research_set.getString("id"))){ %>
									<option value="<%=teaching_research_set.getString("id")%>" selected="selected"><%=teaching_research_set.getString("teaching_research_name")%></option>
								<%}else{ %>
									<option value="<%=teaching_research_set.getString("id")%>"><%=teaching_research_set.getString("teaching_research_name")%></option>
								<%} %>
							<%}if(teaching_research_set!=null){teaching_research_set.close();} %>
						</select>
					</div>
				</div>
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">所属教研室</label>
					<div class="layui-input-inline">
						<select class="layui-input" name="teaching_staff_office" id="teaching_staff_office" lay-search  >
							<option value="">无</option>
							<%
								ResultSet teaching_staff_research_set = db.executeQuery(teaching_research_sql);
								while(teaching_staff_research_set.next()){
							%>
								<%if(base_teaching_staff_office!=null && base_teaching_staff_office.equals(teaching_staff_research_set.getString("id"))){ %>
									<option value="<%=teaching_staff_research_set.getString("id")%>" selected="selected"><%=teaching_staff_research_set.getString("teaching_research_name")%></option>
								<%}else{ %>
									<option value="<%=teaching_staff_research_set.getString("id")%>"><%=teaching_staff_research_set.getString("teaching_research_name")%></option>
								<%} %>
							<%}if(teaching_staff_research_set!=null){teaching_staff_research_set.close();} %>
						</select>
					</div>
				</div>
				
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">职称</label>
					<div class="layui-input-inline">
						<select class="layui-input" name="technical_title" lay-search >
							<option value="">无</option>
							<%
								String teacher_title_sql = "select id,teacher_title_name from teacher_title ;";
								ResultSet teacher_title_set = db.executeQuery(teacher_title_sql);
								while(teacher_title_set.next()){
							%>
								<%if(base_technical_title!=null && teacher_title_set.getString("id").equals(base_technical_title)){ %>
									<option value="<%=teacher_title_set.getString("id")%>" selected="selected"><%=teacher_title_set.getString("teacher_title_name")%></option>
								<%}else{ %>
									<option value="<%=teacher_title_set.getString("id")%>"><%=teacher_title_set.getString("teacher_title_name")%></option>
								<%} %>
							<%}if(teacher_title_set!=null){teacher_title_set.close();} %>
						</select>
					</div>
				</div>
				
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">职务</label>
					<div class="layui-input-inline">
						<select class="layui-input" name="duty" lay-search >
							<option value="">无</option>
							<%
								String teacher_duties_sql = "select id,dutiesname from teacher_duties ;";
								ResultSet teacher_duties_set = db.executeQuery(teacher_duties_sql);
								while(teacher_duties_set.next()){
							%>
								<%if(base_duty!=null && base_duty.equals(teacher_duties_set.getString("id"))){ %>
									<option value="<%=teacher_duties_set.getString("id")%>" selected="selected"><%=teacher_duties_set.getString("dutiesname")%></option>
								<%}else{ %>
									<option value="<%=teacher_duties_set.getString("id")%>"><%=teacher_duties_set.getString("dutiesname")%></option>
								<%} %>
								
							<%}if(teacher_duties_set!=null){teacher_duties_set.close();} %>
						</select>
					</div>
				</div>
				
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">编制</label>
					<div class="layui-input-inline">
						<select class="layui-input" name="stal" lay-search lay-verify="">
							<option value="">无</option>
							<%
								String teacher_organization_sql = "select id,organizationname from teacher_organization ;";
								ResultSet teacher_organization_set = db.executeQuery(teacher_organization_sql);
								while(teacher_organization_set.next()){
							%>
								<%if(base_stal!=null && base_stal.equals(teacher_organization_set.getString("id"))){ %>
									<option value="<%=teacher_organization_set.getString("id")%>" selected="selected"><%=teacher_organization_set.getString("organizationname")%></option>
								<%}else{ %>
									<option value="<%=teacher_organization_set.getString("id")%>"><%=teacher_organization_set.getString("organizationname")%></option>
								<%} %>
							<%}if(teacher_organization_set!=null){teacher_organization_set.close();} %>
						</select>
					</div>
				</div>
				
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">学历</label>
					<div class="layui-input-inline" >
<%--						<input type="text" id="education" name="education" value="<%=base_education %>" class="layui-input"  lay-verify="required" >--%>
							<select class="layui-input" name="education" lay-verify="">
							<option value="">无</option>
							<%
								String education_sql = "SELECT name,id from jz_educational_info ;";
								ResultSet education_sql_set = db.executeQuery(education_sql);
								while(education_sql_set.next()){
							%>
							<%if(base_education!=null && base_education.equals(education_sql_set.getString("id"))){ %>
									<option value="<%=education_sql_set.getString("id")%>" selected="selected"><%=education_sql_set.getString("name")%></option>
								<%}else{ %>
								<option value="<%=education_sql_set.getString("id")%>"><%=education_sql_set.getString("name")%></option>
							<%}}if(education_sql_set!=null){education_sql_set.close();} %>
						</select>
					</div>
				</div>
				
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">学位</label>
					<div class="layui-input-inline">
<%--						<input type="text" id="degree" name="degree" value="<%=base_degree %>" class="layui-input"  >--%>
						<select name="degree"  lay-verify="" lay-search >
							<option value="">请选择</option>
							<%
								String deg_sql = "SELECT typename,id FROM type where typegroupcode='degree'";
								ResultSet deg_sqlRs = db.executeQuery(deg_sql);
								while(deg_sqlRs.next()){
							%>
								<%if(base_degree.equals(deg_sqlRs.getString("id"))){ %>
									<option value="<%=deg_sqlRs.getString("id")%>" selected="selected"><%=deg_sqlRs.getString("typename") %></option>
								<%}else{ %>
									<option value="<%=deg_sqlRs.getString("id")%>"><%=deg_sqlRs.getString("typename") %></option>
								<%} %>
							<%}if(deg_sqlRs!=null){deg_sqlRs.close();} %>
						</select>
					</div>
				</div>
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">毕业学校</label>
					<div class="layui-input-inline">
						<input type="text" id="graduate_shcool" name="graduate_shcool" class="layui-input"  value="<%=graduate_shcool%>"  lay-verify="" >
					</div>
				</div>
				
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">岗位</label>
					<div class="layui-input-inline">
						<select class="layui-input" name="post_status" lay-search lay-verify="">
							<option value="">无</option>
							<%
								String teacher_position_sql = "select id,positionname from teacher_position ;";
								ResultSet teacher_position_set = db.executeQuery(teacher_position_sql);
								while(teacher_position_set.next()){
							%>
								<%if(base_post_status!=null && base_post_status.equals(teacher_position_set.getString("id"))){ %>
									<option value="<%=teacher_position_set.getString("id")%>" selected="selected"><%=teacher_position_set.getString("positionname")%></option>
								<%}else{ %>
									<option value="<%=teacher_position_set.getString("id")%>"><%=teacher_position_set.getString("positionname")%></option>
								<%} %>
							<%}if(teacher_position_set!=null){teacher_position_set.close();} %>
						</select>
					</div>
				</div>
				
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">家属姓名</label>
					<div class="layui-input-inline">
						<input type="text" id="family_name" name="family_name" value="<%=base_family_name %>" class="layui-input" >
					</div>
				</div>
				
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">住校情况</label>
					<div class="layui-input-inline">
						<input type="text" id="residence" name="residence" value="<%=base_residence %>" class="layui-input" >
					</div>
				</div>
				
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">进校时间</label>
					<div class="layui-input-inline">
						<input type="text" id="into_school_time" name="into_school_time" value="<%=base_into_school_time %>" class="layui-input time" lay-verify="" >
					</div>
				</div>
				
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">转正时间</label>
					<div class="layui-input-inline">
						<input type="text" id="regular_time" name="regular_time" value="<%=base_regular_time %>" class="layui-input time"  >
					</div>
				</div>
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">参考工作时间</label>
					<div class="layui-input-inline">
						<input type="text" id="work_time" name="work_time" value="<%=work_time %>" class="layui-input time"   >
					</div>
				</div>
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">学科类别</label>
					<div class="layui-input-inline">
						<select class="layui-input" name="subject_category" lay-search>
							<option value="">无</option>
							<%
								String subject_category_sql = "select id,categoryname from dict_subject_category ;";
								ResultSet subject_category_set = db.executeQuery(subject_category_sql);
								while(subject_category_set.next()){
							%>
								<%if(base_subject_category!=null && base_subject_category.equals(subject_category_set.getString("id"))){ %>
									<option value="<%=subject_category_set.getString("id")%>" selected="selected"><%=subject_category_set.getString("categoryname")%></option>
								<%}else{ %>
									<option value="<%=subject_category_set.getString("id")%>"><%=subject_category_set.getString("categoryname")%></option>
								<%} %>
								
							<%}if(subject_category_set!=null){subject_category_set.close();} %>
						</select>
					</div>
				</div>
				
			<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">外聘教师标记</label>
					<div class="layui-input-inline">
						<select class="layui-input" name="Zgstate"  >
								<option value="2" <%if(Zgstate.equals("2")) out.print("selected"); %>>否</option>
								<option value="1" <%if(Zgstate.equals("1")) out.print("selected"); %>>是</option>
						</select>
					</div>
				</div>
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">备注</label>
					<div class="layui-input-inline">
						<input type="text" id="remark" name="remark" value="<%=base_remark %>" class="layui-input" >
					</div>
				</div>
				<div class="layui-form-item" style="margin-bottom:45px">
					<div class="layui-input-block"  style="margin-left:540px">			
						<button  class="layui-btn"  lay-submit=""  >确认</button>
					</div>
				</div>
			</form>
		</div>
	</body>
	 <script>

	$(function(){
		var obj_str1 = {"departments_id":"<%=base_faculty%>"};
		var obj1 = JSON.stringify(obj_str1)
		var ret_str1=PostAjx('../../../../Api/v1/?p=web/info/teachingResearch',obj1,'<%=Suid%>','<%=Spc_token%>');
		obj1 = JSON.parse(ret_str1);
		//$("#teachering_office").html(obj1.data);
		$("#teaching_staff_office").html(obj1.data);
		//$("#teachering_office").val("<%=base_teachering_office%>");
		$("#teaching_staff_office").val("<%=base_teaching_staff_office%>");
	})
	 
	 
		layui.use(['form', 'layedit', 'laydate'], function() {
			form = layui.form,
			layer = layui.layer,
			layedit = layui.layedit,
			laydate = layui.laydate;
			form.render('select');

			form.on('select(department)',function(data){
				if(data.value!="0"){
					var obj_str1 = {"departments_id":data.value};
					var obj1 = JSON.stringify(obj_str1)
					var ret_str1=PostAjx('../../../../Api/v1/?p=web/info/teachingResearch',obj1,'<%=Suid%>','<%=Spc_token%>');
					obj1 = JSON.parse(ret_str1);
					//$("#teachering_office").html(obj1.data);
					$("#teaching_staff_office").html(obj1.data);
					form.render('select');
				}
			})
				
		});
</script>
</html>


<%

	if("update".equals(ac)){
		//收据数据
		String filed ="";
		String values  ="";
		
		String base_id = request.getParameter("base_id");
		String sex = request.getParameter("sex");
		if(!StringUtils.isBlank(sex)){
			values ="sex='"+sex+"'";
		}
		String teacher_number = request.getParameter("teacher_number");
		if(!StringUtils.isBlank(teacher_number)){
			values = values +",teacher_number='"+teacher_number+"'";
		}
		String teacher_class = request.getParameter("teacher_class");
		if(!StringUtils.isBlank(teacher_class)){
			values = values +",teacher_class='"+teacher_class+"'";
		}
		String birthday = request.getParameter("birthday");
		if(!StringUtils.isBlank(birthday)){
			values = values +",birthday='"+birthday+"'";
		}
		 nation = request.getParameter("nation");
		if(!StringUtils.isBlank(nation)){
			values = values +",nation='"+nation+"'";
		}
		String director = request.getParameter("director");
		if(!StringUtils.isBlank(director)){
			values = values +",director='"+director+"'";
		}
		String political_status = request.getParameter("political_status");
		if(!StringUtils.isBlank(political_status)){
			values = values +",political_status='"+political_status+"'";
		}
		 Zgstate = request.getParameter("Zgstate");
		if(!StringUtils.isBlank(Zgstate)){
			values = values +",Zgstate='"+Zgstate+"'";
		}
		String native_place = request.getParameter("native_place");
		if(!StringUtils.isBlank(native_place)){
			values = values +",native_place='"+native_place+"'";
		}
		String faculty = request.getParameter("faculty");
		if(!StringUtils.isBlank(faculty)){
			values = values +",faculty='"+faculty+"'";
		}
		String teachering_office = request.getParameter("teachering_office");
		if(!StringUtils.isBlank(teachering_office)){
			values = values +",teachering_office='"+teachering_office+"'";
		}
		String teaching_staff_office = request.getParameter("teaching_staff_office");
		if(!StringUtils.isBlank(teaching_staff_office)){
			values = values +",teaching_staff_office='"+teaching_staff_office+"'";
		}
		String technical_title = request.getParameter("technical_title");
		if(!StringUtils.isBlank(technical_title)){
			values = values +",technical_title='"+technical_title+"'";
		}
		String duty = request.getParameter("duty");
		if(!StringUtils.isBlank(duty)){
			values = values +",duty='"+duty+"'";
		}
		String stal = request.getParameter("stal");
		if(!StringUtils.isBlank(stal)){
			values = values +",stal='"+stal+"'";
		}
		String education = request.getParameter("education");
		if(!StringUtils.isBlank(education)){
			values = values +",education='"+education+"'";
		}
		String degree = request.getParameter("degree");
		if(!StringUtils.isBlank(degree)){
			values = values +",degree='"+degree+"'";
		}
		String post_status = request.getParameter("post_status");
		if(!StringUtils.isBlank(post_status)){
			values = values +",post_status='"+post_status+"'";
		}
		String family_name = request.getParameter("family_name");
		if(!StringUtils.isBlank(family_name)){
			values = values +",family_name='"+family_name+"'";
		}
		String residence = request.getParameter("residence");
		if(!StringUtils.isBlank(residence)){
			values = values +",residence='"+residence+"'";
		}
		String id_number = request.getParameter("id_number");
		if(!StringUtils.isBlank(id_number)){
			values = values +",id_number='"+id_number+"'";
		}
		String into_school_time = request.getParameter("into_school_time");
		if(!StringUtils.isBlank(into_school_time)){
			values = values +",into_school_time='"+into_school_time+"'";
		}
		String regular_time = request.getParameter("regular_time");
		if(!StringUtils.isBlank(regular_time)){
			values = values +",regular_time='"+regular_time+"'";
		}
		String subject_category = request.getParameter("subject_category");
		if(!StringUtils.isBlank(subject_category)){
			values = values +",subject_category='"+subject_category+"'";
		}
		String remark = request.getParameter("remark");
		if(!StringUtils.isBlank(remark)){
			values = values +",remark='"+remark+"'";
		}
		String teacher_name = request.getParameter("teacher_name");
		if(!StringUtils.isBlank(teacher_name)){
			values = values +",teacher_name='"+teacher_name+"'";
		}
		 old_id_number = request.getParameter("old_id_number");
		if(!StringUtils.isBlank(old_id_number)){
			values = values +",old_id_number='"+old_id_number+"'";
		}
		 telephone = request.getParameter("telephone");
		if(!StringUtils.isBlank(telephone)){
			values = values +",telephone='"+telephone+"'";
		}
		 work_time = request.getParameter("work_time");
		if(!StringUtils.isBlank(work_time)){
			values = values +",work_time='"+work_time+"'";
		}
		 new_name = request.getParameter("new_name");
		if(!StringUtils.isBlank(new_name)){
			values = values +",new_name='"+new_name+"'";
		}
		 administrative_level = request.getParameter("administrative_level");
		if(!StringUtils.isBlank(administrative_level)){
			values = values +",administrative_level='"+administrative_level+"'";
		}
		 graduate_shcool = request.getParameter("graduate_shcool");
		if(!StringUtils.isBlank(graduate_shcool)){
			values = values +",graduate_shcool='"+graduate_shcool+"'";
		}
		 old_name = request.getParameter("old_name");
		if(!StringUtils.isBlank(old_name)){
			values = values +",old_name='"+old_name+"'";
		}
		
		String insert_sql = "UPDATE teacher_basic 									"+
				"		SET                                                         "+
				"		teacher_number = '"+teacher_number+"' ,                         "+
				"		old_id_number = '"+old_id_number+"' ,                         "+
				"		telephone = '"+telephone+"' ,                         "+
				"		administrative_level = '"+administrative_level+"' ,                         "+
				"		graduate_shcool = '"+graduate_shcool+"' ,                         "+
				"		old_id_number = '"+old_id_number+"' ,                         "+
				"		old_name = '"+old_name+"' ,                         "+
				"		teaching_staff_office = '"+teaching_staff_office+"' ,                         "+
				"		new_name = '"+new_name+"' ,                         "+
				"		sex = '"+sex+"' ,                                               "+
				"		teacher_class = '"+teacher_class+"' ,                           "+
				"		birthday = '"+birthday+"' ,                                     "+
				"		director = '"+director+"' ,                                     "+
				"		political_status = '"+political_status+"' ,                     "+
				"		native_place = '"+native_place+"' ,                             "+
				"		faculty = '"+faculty+"' ,                                       "+
				"		teachering_office = '"+teachering_office+"' ,                   "+
				"		technical_title = '"+technical_title+"' ,                       "+
				"		duty = '"+duty+"' ,                                             "+
				"		stal = '"+stal+"' ,                                             "+
				"		education = '"+education+"' ,                                   "+
				"		degree = '"+degree+"' ,                                         "+
				"		post_status = '"+post_status+"' ,                               "+
				"		family_name = '"+family_name+"' ,                               "+
				"		residence = '"+residence+"' ,                                   "+
				"		id_number = '"+id_number+"' ,                                   "+
				"		into_school_time = '"+into_school_time+"' ,                     "+
				"		regular_time = '"+regular_time+"' ,                             "+
				"		subject_category = '"+subject_category+"' ,                     "+
				"		remark = '"+remark+"' ,                                         "+
				"		work_time = '"+work_time+"' ,                                         "+
				"		teacher_name = '"+teacher_name+"'                               "+
				"		WHERE                                                       "+
				"		id = '"+base_id+"' ;";
		String sql = " update teacher_basic set "+values +" where id="+base_id;
		System.out.println(sql);
		boolean state = db.executeUpdate(sql);
		if(state){
		   out.println("<script>parent.layer.msg('修改教师信息 成功', {icon:1,time:1000,offset:'150px'},function(){parent.location.reload();}); </script>");
	   }else{
		   out.println("<script>parent.layer.msg('修改教师信息 失败');</script>");
	   }
		
	}

%>


 
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