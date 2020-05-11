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
		<title>新增学期信息</title> 
	    <style type="text/css">
			.inline{ position: relative; display: inline-block; margin-right: 10px; }
	    </style>
	</head>
	<body>
		<div style="margin: 15px;">
			<fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
				<legend>新建教职工信息</legend>
			</fieldset>
			<form class="layui-form" action="?ac=add" method="post" >
                <div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">编号</label>
					<div class="layui-input-inline">
						<input type="text" id="teacher_number" lay-verify="required" name="teacher_number" class="layui-input" >
					</div>
				</div>	
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">姓名</label>
					<div class="layui-input-inline">
						<input type="text" id="teacher_name"  lay-verify="required" name="teacher_name" class="layui-input" >
					</div>
				</div>
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">曾用名</label>
					<div class="layui-input-inline">
						<input type="text" id="old_name" name="old_name" class="layui-input" >
					</div>
				</div>
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">现用名</label>
					<div class="layui-input-inline">
						<input type="text" id="new_name" lay-verify="" name="new_name" class="layui-input" >
					</div>
				</div>
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">性别</label>
					<div class="layui-input-inline">
						<select name="sex" class="layui-input" >
							<option value="1">男</option>
							<option value="2">女</option>
						</select>
					</div>
				</div>	
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">身份证号</label>
					<div class="layui-input-inline">
						<input type="text" id="id_number" name="id_number" class="layui-input"  lay-verify="required" >
					</div>
				</div>
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">曾用身份证号</label>
					<div class="layui-input-inline">
						<input type="text" id="old_id_number" name="old_id_number" class="layui-input" >
					</div>
				</div>
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">联系电话</label>
					<div class="layui-input-inline">
						<input type="text" id="telephone" name="telephone" class="layui-input"  lay-verify="required">
					</div>
				</div>
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">民族</label>
					<div class="layui-input-inline">
						<input type="text" id="nation" name="nation" class="layui-input"  lay-verify="">
					</div>
				</div>
				<!-- 教师标识和教师可见标识 用于区分教师管理的教师列表，2个标识都为是的时候，教师列表才能看到 -->
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">教师标识</label>
					<div class="layui-input-inline">
						<select name="teacher_mark" class="layui-input" >
							<option value="2">否</option>
							<option value="1">是</option>
						</select>
					</div>
				</div>	
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">教师可见标识</label>
					<div class="layui-input-inline">
						<select name="state" class="layui-input" >
							<option value="2">不可见</option>
							<option value="1">可见</option>
						</select>
					</div>
				</div>	
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">教职工类别</label>
					<div class="layui-input-inline">
						<select class="layui-input" name="teacher_class" lay-search>
							<%
								String teacher_sql = "select id,categoryname from teacher_class";
								ResultSet teacher_set = db.executeQuery(teacher_sql);
								while(teacher_set.next()){
							%>
								<option value="<%=teacher_set.getString("id")%>"><%=teacher_set.getString("categoryname") %></option>
							<%}if(teacher_set!=null){teacher_set.close();} %>
						</select>
					</div>
				</div>
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">出生日期</label>
					<div class="layui-input-inline">
						<input type="text" id="birthday" name="birthday"  lay-verify="" class="layui-input time"  readonly >
					</div>
				</div>	
				
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">主任标识</label>
					<div class="layui-input-inline">
						<select class="layui-input" name="director" lay-verify="required">
							<option value="0">否</option>
							<option value="1">是</option>
						</select>
					</div>
				</div>
				
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">政治面貌</label>
					<div class="layui-input-inline">
						<select name="political_status"  lay-verify="" lay-search>
							<option value="">请选择</option>
							<%
								String zz_sql = "SELECT typename,id FROM type where typegroupcode='politicsStatus'";
								ResultSet zz_sqlRs = db.executeQuery(zz_sql);
								while(zz_sqlRs.next()){
							%>
								<option value="<%=zz_sqlRs.getString("id")%>"><%=zz_sqlRs.getString("typename") %></option>
							<%}if(zz_sqlRs!=null){zz_sqlRs.close();} %>
						</select>
					</div>
				</div>
				
				
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">籍贯</label>
					<div class="layui-input-inline">
						<input type="text" id="native_place"  lay-verify="" name="native_place" class="layui-input" >
					</div>
				</div>
				
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">行政级别</label>
					<div class="layui-input-inline">
<%--						<input type="text" id="administrative_level" lay-verify="required" name="administrative_level" class="layui-input" >--%>
						<select name="administrative_level"   lay-search >
							<option value="">请选择</option>
							<%
								String level_sql = "SELECT typename,id FROM type where typegroupcode='administrativeLevel'";
								ResultSet level_sqlRs = db.executeQuery(level_sql);
								while(level_sqlRs.next()){
							%>
									<option value="<%=level_sqlRs.getString("id")%>"><%=level_sqlRs.getString("typename") %></option>
							<%}if(level_sqlRs!=null){level_sqlRs.close();} %>
						</select>
					</div>
				</div>
				
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">所属院系</label>
					<div class="layui-input-inline">
						<select class="layui-input" name="faculty" lay-search  lay-filter="department">
							<option value="">无</option>
							<%
								String dict_departments_sql = "select id,departments_name from dict_departments ;";
								ResultSet dict_departments_set = db.executeQuery(dict_departments_sql);
								while(dict_departments_set.next()){
							%>
								<option value="<%=dict_departments_set.getString("id")%>"><%=dict_departments_set.getString("departments_name")%></option>
							<%}if(dict_departments_set!=null){dict_departments_set.close();} %>
						</select>
					</div>
				</div>
				
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">所属教研室</label>
					<div class="layui-input-inline">
						<select class="layui-input" name="teaching_staff_office" id="teaching_staff_office" lay-search >
							<option value="">无</option>
							
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
								<option value="<%=teacher_title_set.getString("id")%>"><%=teacher_title_set.getString("teacher_title_name")%></option>
							<%}if(teacher_title_set!=null){teacher_title_set.close();} %>
						</select>
					</div>
				</div>
				
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">职务</label>
					<div class="layui-input-inline">
						<select class="layui-input" name="duty" >
							<option value="">无</option>
							<%
								String teacher_duties_sql = "select id,dutiesname from teacher_duties ;";
								ResultSet teacher_duties_set = db.executeQuery(teacher_duties_sql);
								while(teacher_duties_set.next()){
							%>
								<option value="<%=teacher_duties_set.getString("id")%>"><%=teacher_duties_set.getString("dutiesname")%></option>
							<%}if(teacher_duties_set!=null){teacher_duties_set.close();} %>
						</select>
					</div>
				</div>
				
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">编制</label>
					<div class="layui-input-inline">
						<select class="layui-input" name="stal" lay-verify="">
							<option value="">无</option>
							<%
								String teacher_organization_sql = "select id,organizationname,organizationcode from teacher_organization ;";
								ResultSet teacher_organization_set = db.executeQuery(teacher_organization_sql);
								while(teacher_organization_set.next()){
								//	if(teacher_organization_set.getString("organizationcode").equals("external_teacher")){continue;}
							%>
								<option value="<%=teacher_organization_set.getString("id")%>"><%=teacher_organization_set.getString("organizationname")%></option>
							<%}if(teacher_organization_set!=null){teacher_organization_set.close();} %>
						</select>
					</div>
				</div>
				
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">学历</label>
					<div class="layui-input-inline">
<%--						<input type="text" id="education" name="education" class="layui-input"  lay-verify="required">--%>
						<select class="layui-input" name="education" lay-verify="">
							<option value="">无</option>
							<%
								String education_sql = "SELECT name,id from jz_educational_info ;";
								ResultSet education_sql_set = db.executeQuery(education_sql);
								while(education_sql_set.next()){
							%>
								<option value="<%=education_sql_set.getString("id")%>"><%=education_sql_set.getString("name")%></option>
							<%}if(education_sql_set!=null){education_sql_set.close();} %>
						</select>
					</div>
				</div>
				
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">学位</label>
					<div class="layui-input-inline">
<%--						<input type="text" id="degree" name="degree" class="layui-input" >--%>
						<select name="degree"  lay-verify="" lay-search >
							<option value="">请选择</option>
							<%
								String deg_sql = "SELECT typename,id FROM type where typegroupcode='degree'";
								ResultSet deg_sqlRs = db.executeQuery(deg_sql);
								while(deg_sqlRs.next()){
							%>
									<option value="<%=deg_sqlRs.getString("id")%>"><%=deg_sqlRs.getString("typename") %></option>
							<%}if(deg_sqlRs!=null){deg_sqlRs.close();} %>
						</select>
					</div>
				</div>
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">毕业学校</label>
					<div class="layui-input-inline">
						<input type="text" id="graduate_shcool" lay-verify="" name="graduate_shcool" class="layui-input" >
					</div>
				</div>
				
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">岗位</label>
					<div class="layui-input-inline">
						<select class="layui-input" name="post_status" lay-verify="">
							<option value="">无</option>
							<%
								String teacher_position_sql = "select id,positionname from teacher_position ;";
								ResultSet teacher_position_set = db.executeQuery(teacher_position_sql);
								while(teacher_position_set.next()){
							%>
								<option value="<%=teacher_position_set.getString("id")%>"><%=teacher_position_set.getString("positionname")%></option>
							<%}if(teacher_position_set!=null){teacher_position_set.close();} %>
						</select>
					</div>
				</div>
				
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">家属姓名</label>
					<div class="layui-input-inline">
						<input type="text" id="family_name" name="family_name" class="layui-input" >
					</div>
				</div>
				
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">住校情况</label>
					<div class="layui-input-inline">
						<input type="text" id="residence" name="residence" class="layui-input" >
					</div>
				</div>
				
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">参加工作时间</label>
					<div class="layui-input-inline">
						<input type="text" id="work_time"  name="work_time" class="layui-input time" >
					</div>
				</div>
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">进校时间</label>
					<div class="layui-input-inline">
						<input type="text" id="into_school_time" name="into_school_time" class="layui-input time"  lay-verify="">
					</div>
				</div>
				
				
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">转正时间</label>
					<div class="layui-input-inline">
						<input type="text" id="regular_time" name="regular_time" class="layui-input time"  >
					</div>
				</div>
				
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">学科类别</label>
					<div class="layui-input-inline">
						<select class="layui-input" name="subject_category" >
							<option value="">无</option>
							<%
								String subject_category_sql = "select id,categoryname from dict_subject_category ;";
								ResultSet subject_category_set = db.executeQuery(subject_category_sql);
								while(subject_category_set.next()){
							%>
								<option value="<%=subject_category_set.getString("id")%>"><%=subject_category_set.getString("categoryname")%></option>
							<%}if(subject_category_set!=null){subject_category_set.close();} %>
						</select>
					</div>
				</div>
				
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">备注</label>
					<div class="layui-input-inline">
						<input type="text" id="remark" name="remark" class="layui-input" >
					</div>
				</div>
				
				<div class="layui-form-item" style="margin-bottom:45px">
					<div class="layui-input-block"  style="margin-left:540px">			
					<button class="layui-btn" lay-submit=""  >确认</button>
					</div>
				</div>
			</form>
		</div>
	</body>
	 <script>
		layui.use(['form', 'layedit', 'laydate'], function() {
			 form = layui.form,
				layer = layui.layer,
				layedit = layui.layedit,
				laydate = layui.laydate;
				$('.time').each(function(){
					laydate.render({
					elem: this
					});
				})
			 	form.render();
				 
				 form.on('select(department)',function(data){
						if(data.value!="0"){
							var obj_str1 = {"departments_id":data.value};
							var obj1 = JSON.stringify(obj_str1)
							var ret_str1=PostAjx('../../../../Api/v1/?p=web/info/teachingResearch',obj1,'<%=Suid%>','<%=Spc_token%>');
							obj1 = JSON.parse(ret_str1);
							$("#teaching_staff_office").html(obj1.data);
							form.render('select');
						}
					})
			});
</script>
</html>

<%

	if("add".equals(ac)){
		String filed ="";
		String values  ="";
		//收据数据
		String sex = request.getParameter("sex");
		if(!StringUtils.isBlank(sex)){
			filed ="sex";
			values ="'"+sex+"'";
		}
		String teacher_number = request.getParameter("teacher_number");
		if(!StringUtils.isBlank(teacher_number)){
			filed= filed+",teacher_number";
			values =values +",'"+ teacher_number+"'";
		}
		String teacher_mark = request.getParameter("teacher_mark");
		if(!StringUtils.isBlank(teacher_mark)){
			filed =filed+",teacher_mark";
			values = values +",'"+teacher_mark+"'";
		}
		String state = request.getParameter("state");
		if(!StringUtils.isBlank(state)){
			filed =filed+",state";
			values = values +",'"+state+"'";
		}
	
		String teacher_class = request.getParameter("teacher_class");
		if(!StringUtils.isBlank(teacher_class)){
			filed =filed+",teacher_class";
			values = values +",'"+teacher_class+"'";
		}
		String birthday = request.getParameter("birthday");
		if(!StringUtils.isBlank(birthday)){
			filed =filed+",birthday";
			values = values +",'"+birthday+"'";
		}
		String director = request.getParameter("director");
		if(!StringUtils.isBlank(director)){
			filed =filed+",director";
			values = values +",'"+director+"'";
		}
		String political_status = request.getParameter("political_status");
		if(!StringUtils.isBlank(political_status)){
			filed =filed+",political_status";
			values = values +",'"+political_status+"'";
		}
		String native_place = request.getParameter("native_place");
		if(!StringUtils.isBlank(native_place)){
			filed =filed+",native_place";
			values = values +",'"+native_place+"'";
		}
		String faculty = request.getParameter("faculty");
		if(!StringUtils.isBlank(faculty)){
			filed =filed+",faculty";
			values = values +",'"+faculty+"'";
		}
		String nation = request.getParameter("nation");
		if(!StringUtils.isBlank(nation)){
			filed =filed+",nation";
			values = values +",'"+nation+"'";
		}
		String teaching_staff_office = request.getParameter("teaching_staff_office");
		if(!StringUtils.isBlank(teaching_staff_office)){
			filed =filed+",teaching_staff_office";
			values = values +",'"+teaching_staff_office+"'";
		}
		String technical_title = request.getParameter("technical_title");
		if(!StringUtils.isBlank(technical_title)){
			filed =filed+",technical_title";
			values = values +",'"+technical_title+"'";
		}
		String duty = request.getParameter("duty");
		if(!StringUtils.isBlank(duty)){
			filed =filed+",duty";
			values = values +",'"+duty+"'";
		}
		String stal = request.getParameter("stal");
		if(!StringUtils.isBlank(stal)){
			filed =filed+",stal";
			values = values +",'"+stal+"'";
		}
		String education = request.getParameter("education");
		if(!StringUtils.isBlank(education)){
			filed =filed+",education";
			values = values +",'"+education+"'";
		}
		String degree = request.getParameter("degree");
		if(!StringUtils.isBlank(degree)){
			filed =filed+",degree";
			values = values +",'"+degree+"'";
		}
		String post_status = request.getParameter("post_status");
		if(!StringUtils.isBlank(post_status)){
			filed =filed+",post_status";
			values = values +",'"+post_status+"'";
		}
		String family_name = request.getParameter("family_name");
		if(!StringUtils.isBlank(family_name)){
			filed =filed+",family_name";
			values = values +",'"+family_name+"'";
		}
		String residence = request.getParameter("residence");
		if(!StringUtils.isBlank(residence)){
			filed =filed+",residence";
			values = values +",'"+residence+"'";
		}
		String id_number = request.getParameter("id_number");
		if(!StringUtils.isBlank(id_number)){
			filed =filed+",id_number";
			values = values +",'"+id_number+"'";
		}
		String into_school_time = request.getParameter("into_school_time");
		if(!StringUtils.isBlank(into_school_time)){
			filed =filed+",into_school_time";
			values = values +",'"+into_school_time+"'";
		}
		String regular_time = request.getParameter("regular_time");
		if(!StringUtils.isBlank(regular_time)){
			filed =filed+",regular_time";
			values = values +",'"+regular_time+"'";
		}
		String subject_category = request.getParameter("subject_category");
		if(!StringUtils.isBlank(subject_category)){
			filed =filed+",subject_category";
			values = values +",'"+subject_category+"'";
		}
		String remark = request.getParameter("remark");
		if(!StringUtils.isBlank(remark)){
			filed =filed+",remark";
			values = values +",'"+remark+"'";
		}
		String teacher_name = request.getParameter("teacher_name");
		if(!StringUtils.isBlank(teacher_name)){
			filed =filed+",teacher_name";
			values = values +",'"+teacher_name+"'";
		}
		String old_name = request.getParameter("old_name");
		if(!StringUtils.isBlank(old_name)){
			filed =filed+",old_name";
			values = values +",'"+old_name+"'";
		}
		String work_time = request.getParameter("work_time");
		if(!StringUtils.isBlank(work_time)){
			filed =filed+",work_time";
			values = values +",'"+work_time+"'";
		}
		String new_name = request.getParameter("new_name");
		if(!StringUtils.isBlank(new_name)){
			filed =filed+",new_name";
			values = values +",'"+new_name+"'";
		}
		String old_id_number = request.getParameter("old_id_number");
		if(!StringUtils.isBlank(old_id_number)){
			filed =filed+",old_id_number";
			values = values +",'"+old_id_number+"'";
		}
		String graduate_shcool = request.getParameter("graduate_shcool");
		if(!StringUtils.isBlank(graduate_shcool)){
			filed =filed+",graduate_shcool";
			values = values +",'"+graduate_shcool+"'";
		}
		String administrative_level = request.getParameter("administrative_level");
		if(!StringUtils.isBlank(administrative_level)){
			filed =filed+",administrative_level";
			values = values +",'"+administrative_level+"'";
		}
		String telephone = request.getParameter("telephone");
		if(!StringUtils.isBlank(telephone)){
			filed =filed+",telephone";
			values = values +",'"+telephone+"'";
		}
		
		String checkSql = "select count(1) row from teacher_basic where id_number='"+id_number+"' or telephone='"+telephone+"' or teacher_number='"+teacher_number+"'";
		if(db.Row(checkSql)==0){
						String insert_sql = "INSERT INTO teacher_basic 				"+
							"			(                                       "+
							"			teacher_number,                         "+
							"			telephone,                         "+
							"			graduate_shcool,                         "+
							"			administrative_level,                         "+
							"			state,                         "+
							"			sex,                                    "+
							"			teacher_mark,                                    "+
							"			nation,                                    "+
							"			teacher_class,                          "+
							"			birthday,                               "+
							"			director,                               "+
							"			political_status,                       "+
							"			native_place,                           "+
							"			faculty,                                "+
							"			teaching_staff_office,                      "+
							"			technical_title,                        "+
							"			duty,                                   "+
							"			stal,                                   "+
							"			education,                              "+
							"			degree,                                 "+
							"			post_status,                            "+
							"			family_name,                            "+
							"			residence,                              "+
							"			id_number,                              "+
							"			into_school_time,                       "+
							"			regular_time,                           "+
							"			subject_category,                       "+
							"			remark,                                 "+
							"			work_time,                                 "+
							"			old_name,                                 "+
							"			new_name,                                 "+
							"			old_id_number,                                 "+
							"			Zgstate,                                 "+
							"			teacher_name                            "+
							"			)                                       "+
							"			VALUES                                  "+
							"			(                                       "+
							"			'"+teacher_number+"',                       "+
							"			'"+telephone+"',                       "+
							"			'"+graduate_shcool+"',                       "+
							"			'"+administrative_level+"',                       "+
							"			'"+sex+"',                                  "+
							"			'"+state+"',                                  "+
							"			'"+teacher_mark+"',                                  "+
							"			'"+nation+"',                                  "+
							"			'"+teacher_class+"',                        "+
							"			'"+birthday+"',                             "+
							"			'"+director+"',                             "+
							"			'"+political_status+"',                     "+
							"			'"+native_place+"',                         "+
							"			'"+faculty+"',                              "+
							"			'"+teaching_staff_office+"',                    "+
							"			'"+technical_title+"',                      "+
							"			'"+duty+"',                                 "+
							"			'"+stal+"',                                 "+
							"			'"+education+"',                            "+
							"			'"+degree+"',                               "+
							"			'"+post_status+"',                          "+
							"			'"+family_name+"',                          "+
							"			'"+residence+"',                            "+
							"			'"+id_number+"',                            "+
							"			'"+into_school_time+"',                     "+
							"			'"+regular_time+"',                         "+
							"			'"+subject_category+"',                     "+
							"			'"+remark+"',                               "+
							"			'"+work_time+"',                               "+
							"			'"+old_name+"',                         "+
							"			'"+new_name+"',                     "+
							"			'"+old_id_number+"',2                               "+
							"			'"+teacher_name+"'                          "+
							"			);";
					String sql ="INSERT INTO teacher_basic 	("+filed+") values ("+values+")";
					System.out.println(sql);
					boolean upstate = db.executeUpdate(sql);
					if(upstate){
					   out.println("<script>parent.layer.msg('添加教职工信息 成功', {icon:1,time:1000,offset:'150px'},function(){parent.location.reload();}); </script>");
				   }else{
					   out.println("<script>parent.layer.msg('添加教职工信息 失败');</script>");
				   }
		}else{
			 out.println("<script>parent.layer.msg('添身份证或教师编号或手机号已存在,请勿重新添加');</script>");
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