<%@ page trimDirectiveWhitespaces="true" %>
<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@page import="service.dao.db.Page"%>
<%--<%@include file="../../cookie_pub.jsp"%>--%>
<%@page import="java.util.Date"%>
<%@page import="v1.haocheok.commom.common"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="org.apache.commons.lang3.StringUtils"%>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.text.DecimalFormat"%>
<%@ page import="v1.haocheok.commom.entity.UserEntity"%>
<%@ page language="java" import="java.util.regex.*"%>
<jsp:useBean id="db" scope="page" class="service.dao.db.Jdbc"/>
<jsp:useBean id="server" scope="page" class="service.dao.db.Page"/>

<%
	String id = request.getParameter("id");
	String select_sql = "SELECT 	 			"+
		"			teacher_number,                 "+
		"			old_name,                    "+
		"			new_name,                    "+
		"			nation,                    "+
		"			telephone,                    "+
		"			old_id_number,                    "+
		"			sex,                            "+
		"			state,                            "+
		"			teacher_class,                  "+
		"			birthday,                       "+
		"			director,                       "+
		"			political_status,               "+
		"			native_place,                   "+
		"			faculty,                        "+
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
		"			encryption_dog_number,          "+
		"			teacher_name,                    "+
		"			work_time,                    "+
		"			graduate_shcool,                    "+
		"			administrative_level,                    "+
		"			teacher_mark                    "+
		"			FROM                            "+
		"			teacher_basic    "+
		"			WHERE id = '"+id+"';";
	ResultSet set = db.executeQuery(select_sql);
	System.out.println("sql==="+select_sql);
	String base_teacher_number = "";
	String base_sex = "";
	String base_teacher_class = "";
	String base_birthday = "";
	String base_director = "";
	String base_political_status = "";
	String base_native_place = "";
	String nation = "";
	String base_faculty = "";
	String base_teaching_staff_office = "";
	String base_technical_title = "";
	String base_duty = "";
	String base_stal = "";
	String base_education = "";
	String base_degree = "";
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
	String state = "";
	String work_time = "";
	String teaching_staff_office = "";
	String teacher_mark = "";
	String graduate_shcool = "";
	String telephone = "";
	String administrative_level = "";
	
	while(set.next()){
		old_name = set.getString("old_name");
		if(StringUtils.isBlank(old_name)){old_name ="";}
		new_name = set.getString("new_name");
		if(StringUtils.isBlank(new_name)){new_name ="";}
		nation = set.getString("nation");
		if(StringUtils.isBlank(nation)){nation ="";}
		old_id_number = set.getString("old_id_number");
		if(StringUtils.isBlank(old_id_number)){old_id_number ="";}
		base_teacher_number = set.getString("teacher_number");
		if(StringUtils.isBlank(base_teacher_number)){base_teacher_number ="";}
		base_sex = set.getString("sex");
		if(StringUtils.isBlank(base_sex)){base_sex ="";}
		base_teacher_class = set.getString("teacher_class");
		if(StringUtils.isBlank(base_teacher_class)){base_teacher_class ="";}
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
		if(StringUtils.isBlank(base_teacher_name)){base_teacher_name ="";}
		teaching_staff_office = set.getString("teaching_staff_office");
		if(StringUtils.isBlank(teaching_staff_office)){teaching_staff_office ="";}
		teacher_mark = set.getString("teacher_mark");
		if(StringUtils.isBlank(teacher_mark)){teacher_mark ="";}
		state = set.getString("state");
		if(StringUtils.isBlank(state)){state ="";}
		graduate_shcool = set.getString("graduate_shcool");
		if(StringUtils.isBlank(graduate_shcool)){graduate_shcool ="";}
		administrative_level = set.getString("administrative_level");
		if(StringUtils.isBlank(administrative_level)){administrative_level ="";}
		telephone = set.getString("telephone");
		if(StringUtils.isBlank(telephone)){telephone ="";}
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
		<title>查看教职工信息</title> 
	    <style type="text/css">
			.inline{ position: relative; display: inline-block; margin-right: 10px; }
	    </style>
	    <script>
			 layui.use(['form','laydate'], function() {
					var	layer = layui.layer,
						laydate = layui.laydate,
						layedit = layui.layedit,
						laydate = layui.laydate;
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
				<legend>查看教职工信息</legend>
			</fieldset>
			<form class="layui-form" action="" method="post" >
                <div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">教职工编号</label>
					<div class="layui-input-inline">
						<input type="text" id="teacher_number" name="teacher_number" value="<%=base_teacher_number %>" class="layui-input"  readonly>
					</div>
				</div>	
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">教职工姓名</label>
					<div class="layui-input-inline">
						<input type="text" id="teacher_name" name="teacher_name" value="<%=base_teacher_name %>" class="layui-input"  readonly>
					</div>
				</div>
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">性别</label>
					<div class="layui-input-inline" >
						<select name="sex" class="layui-input" disabled>
							<option value="1" <%if("1".equals(base_sex)){out.println("selected='selected'");} %>>男</option>
							<option value="2" <%if("2".equals(base_sex)){out.println("selected='selected'");} %>>女</option>
						</select>
					</div>
				</div>	
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">曾用名</label>
					<div class="layui-input-inline">
						<input type="text" id="old_name"  readonly name="old_name" class="layui-input"  value="<%=old_name%>">
					</div>
				</div>
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">现用名</label>
					<div class="layui-input-inline">
						<input type="text" id="new_name"  readonly name="new_name" class="layui-input"  value="<%=new_name%>">
					</div>
				</div>
				
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">身份证号</label>
					<div class="layui-input-inline">
						<input type="text" id="id_number" name="id_number" value="<%=base_id_number %>" class="layui-input" readonly >
					</div>
				</div>
				
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">原身份证号</label>
					<div class="layui-input-inline">
						<input type="text" id="id_number" name="id_number" value="<%=old_id_number %>" class="layui-input" readonly >
					</div>
				</div>
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">联系方式</label>
					<div class="layui-input-inline">
						<input type="text" id="id_number" name="id_number" value="<%=telephone %>" class="layui-input" readonly >
					</div>
				</div>
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">民族</label>
					<div class="layui-input-inline">
						<input type="text" id="nation" name="nation" value="<%=nation %>" class="layui-input" readonly >
					</div>
				</div>
<%--				<div class="layui-form-item inline" style=" width: 40%">--%>
<%--					<label class="layui-form-label" style=" width: 30%">教职工标识</label>--%>
<%--					<div class="layui-input-inline">--%>
<%--						<select name="teacher_mark" class="layui-input" disabled>--%>
<%--							<option value="1" <%if("1".equals(teacher_mark)){out.println("selected='selected'");} %>>是</option>--%>
<%--							<option value="2" <%if("2".equals(teacher_mark)){out.println("selected='selected'");} %>>否</option>--%>
<%--						</select>--%>
<%--					</div>--%>
<%--				</div>	--%>
<%--				<div class="layui-form-item inline" style=" width: 40%">--%>
<%--					<label class="layui-form-label" style=" width: 30%">教职工可见标识</label>--%>
<%--					<div class="layui-input-inline">--%>
<%--						<select name="state" class="layui-input"  disabled>--%>
<%--							<option value="1" <%if("1".equals(state)){out.println("selected='selected'");} %>>可见</option>--%>
<%--							<option value="2" <%if("2".equals(state)){out.println("selected='selected'");} %>>不可见</option>--%>
<%--						</select>--%>
<%--					</div>--%>
<%--				</div>	--%>
<%--				<div class="layui-form-item inline" style=" width: 40%">--%>
<%--					<label class="layui-form-label" style=" width: 30%">教职工类别</label>--%>
<%--					<div class="layui-input-inline">--%>
<%--						<select class="layui-input" name="teacher_class" disabled>--%>
<%--							<%--%>
<%--								String teacher_sql = "select id,categoryname from teacher_class";--%>
<%--								ResultSet teacher_set = db.executeQuery(teacher_sql);--%>
<%--								while(teacher_set.next()){--%>
<%--							%>--%>
<%--								<%if(base_teacher_class!=null && base_teacher_class.equals(teacher_set.getString("id"))){ %>--%>
<%--									<option value="<%=teacher_set.getString("id")%>" selected="selected"><%=teacher_set.getString("categoryname") %></option>--%>
<%--								<%}else{ %>--%>
<%--									<option value="<%=teacher_set.getString("id")%>"><%=teacher_set.getString("categoryname") %></option>--%>
<%--								<%} %>--%>
<%--							<%}if(teacher_set!=null){teacher_set.close();} %>--%>
<%--						</select>--%>
<%--					</div>--%>
<%--				</div>--%>
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">出生日期</label>
					<div class="layui-input-inline" readonly>
						<input type="text" id="birthday" name="birthday" value="<%=base_birthday %>" class="layui-input time"  >
					</div>
				</div>	
				
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">主任标识</label>
					<div class="layui-input-inline">
						<select class="layui-input" name="director" disabled>
							<option value="">无</option>
							<option value="0" <%if("0".equals(base_director)){out.println("selected='selected'");} %>>否</option>
							<option value="1" <%if("1".equals(base_director)){out.println("selected='selected'");} %>>是</option>
						</select>
					</div>
				</div>
				
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">政治面貌</label>
					<div class="layui-input-inline">
<%--						<input type="text" id="political_status" name="political_status" value="<%=base_political_status %>" class="layui-input"  readonly>--%>
						<select name="political_status"  lay-verify="" lay-search disabled >
							<option value="">无</option>
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
						<input type="text" id="native_place" name="native_place" value="<%=base_native_place %>" class="layui-input"  readonly>
					</div>
				</div>
				
				
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">所属院系</label>
					<div class="layui-input-inline">
						<select class="layui-input" name="faculty" disabled>
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
				
<%--				<div class="layui-form-item inline" style=" width: 40%">--%>
<%--					<label class="layui-form-label" style=" width: 30%">任课教研室</label>--%>
<%--					<div class="layui-input-inline">--%>
<%--						<select class="layui-input" name="teaching_staff_office" disabled>--%>
<%--							<option value="">无</option>--%>
<%--							<%--%>
<%--								String teaching_research_sql = "select id,teaching_research_name from teaching_research ;";--%>
<%--								ResultSet teaching_research_set = db.executeQuery(teaching_research_sql);--%>
<%--								while(teaching_research_set.next()){--%>
<%--							%>--%>
<%--								<%if(base_teaching_staff_office!=null && base_teaching_staff_office.equals(teaching_research_set.getString("id"))){ %>--%>
<%--									<option value="<%=teaching_research_set.getString("id")%>" selected="selected"><%=teaching_research_set.getString("teaching_research_name")%></option>--%>
<%--								<%}else{ %>--%>
<%--									<option value="<%=teaching_research_set.getString("id")%>"><%=teaching_research_set.getString("teaching_research_name")%></option>--%>
<%--								<%} %>--%>
<%--							<%}if(teaching_research_set!=null){teaching_research_set.close();} %>--%>
<%--						</select>--%>
<%--					</div>--%>
<%--				</div>--%>
				
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">职称</label>
					<div class="layui-input-inline">
						<select class="layui-input" name="technical_title" disabled>
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
						<select class="layui-input" name="duty" disabled>
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
						<select class="layui-input" name="stal" disabled>
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
					<div class="layui-input-inline">
						<input type="text" id="education" name="education" value="<%=base_education %>" class="layui-input"  readonly >
					</div>
				</div>
				
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">学位</label>
					<div class="layui-input-inline">
<%--						<input type="text" id="degree" name="degree" value="<%=base_degree %>" class="layui-input" readonly >--%>
						<select name="degree"  lay-verify="" lay-search disabled >
							<option value="">无</option>
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
					<label class="layui-form-label" style=" width: 30%">岗位</label>
					<div class="layui-input-inline">
						<select class="layui-input" name="post_status" disabled >
							<option value="">无</option>
							<%
								String teacher_position_sql = "select id,positionname from teacher_position ;";
								ResultSet teacher_position_set = db.executeQuery(teacher_position_sql);
								while(teacher_position_set.next()){
							%>
								<%if(base_stal!=null && base_stal.equals(teacher_position_set.getString("id"))){ %>
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
						<input type="text" id="family_name" name="family_name" value="<%=base_family_name %>" class="layui-input" readonly >
					</div>
				</div>
				
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">住校情况</label>
					<div class="layui-input-inline">
						<input type="text" id="residence" name="residence" value="<%=base_residence %>" class="layui-input" readonly >
					</div>
				</div>
				
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">进校时间</label>
					<div class="layui-input-inline">
						<input type="text" value="<%=base_into_school_time %>" class="layui-input "  readonly >
					</div>
				</div>
				
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">转正时间</label>
					<div class="layui-input-inline">
						<input type="text"  value="<%=base_regular_time %>" class="layui-input "  readonly >
					</div>
				</div>
				
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">学科类别</label>
					<div class="layui-input-inline">
						<select class="layui-input" name="subject_category" disabled >
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
					<label class="layui-form-label" style=" width: 30%">备注</label>
					<div class="layui-input-inline">
						<input type="text" id="remark" name="remark" value="<%=base_remark %>" class="layui-input"  readonly>
					</div>
				</div>
			</form>
		</div>
	</body>
</html>

<%
if(db!=null)db.close();db=null;if(server!=null)server=null;
%>