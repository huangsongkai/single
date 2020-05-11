<%@ page trimDirectiveWhitespaces="true" %>
<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@page import="service.dao.db.Page"%>
<%@include file="../../../cookie.jsp"%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="utf-8">
		<meta name="renderer" content="webkit">
		<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
		<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
		<meta name="apple-mobile-web-app-status-bar-style" content="black">
		<meta name="apple-mobile-web-app-capable" content="yes">
		<meta name="format-detection" content="telephone=no">
			<script type="text/javascript" src="../../../js/jquery-1.9.1.js" ></script><!--通用jquery-->
     	<link rel="stylesheet" href="../../../../pages/css/sy_style.css?22">
		<script src="../../../../pages/js/layui2/layui.js"></script>
			<script type="text/javascript" src="../../../js/ajaxs.js" ></script>
		<link rel="stylesheet" href="../../../js/layui2/css/layui.css" media="all" />
		<title>新建学生信息</title> 
	    <style type="text/css">
			.inline{ position: relative; display: inline-block; margin-right: 10px; }
	    </style>
	</head>
	<body  style='height:auto'>
		<div style="margin: 15px;">
			<fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
				<legend>新建学生信息</legend>
			</fieldset>
			<form class="layui-form" action="?ac=post" method="post">
				<div class="layui-form-item inline">
					<label class="layui-form-label" >姓名</label>
					<input type="hidden" name="id" value="">
					<div class="layui-input-inline">
						<input type="text" name=stuname lay-verify="required" autocomplete="off" class="layui-input"  value="">
					</div>
				</div>
				<div class="layui-form-item inline">
					<label class="layui-form-label" >学号</label>
					<div class="layui-input-inline">
						<input type="text" name="student_number" lay-verify="required" autocomplete="off" class="layui-input"  value="">
					</div>
				</div>
				<div class="layui-form-item inline">
					<label class="layui-form-label" >考号</label>
					<div class="layui-input-inline">
						<input type="text" name="test_number" lay-verify="required" autocomplete="off" class="layui-input"  value="">
					</div>
				</div>
				<div class="layui-form-item inline">
					<label class="layui-form-label" >身份证号</label>
					<div class="layui-input-inline">
						<input type="text" name="idcard" lay-verify="required" autocomplete="off" class="layui-input"  value="">
					</div>
				</div>
				<div class="layui-form-item inline">
					<label class="layui-form-label" >警号</label>
					<div class="layui-input-inline">
						<input type="text" name="alarm" lay-verify="required" autocomplete="off" class="layui-input"  value="">
					</div>
				</div>
				<div class="layui-form-item inline">
					<label class="layui-form-label" >性别</label>
					<div class="layui-input-inline">
						<select name="sex"> 
							<option value="1">男</option>
							<option value="2">女</option>
						</select>
					</div>
				</div>
				<div class="layui-form-item inline">
					<label class="layui-form-label" >民族</label>
					<div class="layui-input-inline">
						<input type="text" name="nation" lay-verify="required" autocomplete="off" class="layui-input"  value="">
					</div>
				</div>
				<div class="layui-form-item inline">
					<label class="layui-form-label" >出生日期</label>
					<div class="layui-input-inline">
						<input type="text" name="birth" id="birth"  autocomplete="off" class="layui-input"  value="">
					</div>
				</div>
				<div class="layui-form-item inline">
					<label class="layui-form-label" >入学日期</label>
					<div class="layui-input-inline">
						<input type="text" name="start_date" id="start_date" lay-verify="required" autocomplete="off" class="layui-input"  value="">
					</div>
				</div>
				<div class="layui-form-item inline" >
					<label class="layui-form-label" >所属院系</label>
					<div class="layui-input-inline">
						<select class="layui-input" name="faculty"  id="faculty" lay-search lay-verify="required"  lay-filter="department">
							<option value="">无</option>
							<%
								String dict_departments_sql = "select id,departments_name from dict_departments where teach_tag=1";
								ResultSet dict_departments_set = db.executeQuery(dict_departments_sql);
								while(dict_departments_set.next()){
							%>
								<option value="<%=dict_departments_set.getString("id")%>"><%=dict_departments_set.getString("departments_name")%></option>
							<%}if(dict_departments_set!=null){dict_departments_set.close();} %>
						</select>
					</div>
				</div>
				<div class="layui-form-item inline">
					<label class="layui-form-label" >专业</label>
					<div class="layui-input-inline">
							<select name="major"  id="major" class="layui-input"  lay-search lay-filter="major">
								<%
									String majorSql =" SELECT id,major_name FROM `major`";
									ResultSet majorRs = db.executeQuery(majorSql);
									while(majorRs.next()){
										out.println("<option value='"+majorRs.getString("id")+"'>"+majorRs.getString("major_name")+"</option>");
									}if(majorRs!=null)majorRs.close();
								%>
							</select>
<%--						<input type="text" name="major" lay-verify="required" autocomplete="off" class="layui-input"  value="">--%>
					</div>
				</div>
						<div class="layui-form-item inline" >
					<label class="layui-form-label" >所属班级</label>
					<div class="layui-input-inline">
<%--						<input type="text" name="classroomid"  autocomplete="off" class="layui-input" value=""  >--%>
						<select name="classroomid"  id="classroomid" class="layui-input"  lay-search >
							<%
								String classSql =" SELECT id,class_name FROM `class_grade`";
								ResultSet classSqlRs = db.executeQuery(classSql);
								while(classSqlRs.next()){
									out.println("<option value='"+classSqlRs.getString("id")+"'>"+classSqlRs.getString("class_name")+"</option>");
								}if(classSqlRs!=null)classSqlRs.close();
							%>
						</select>
					</div>
				</div>
				<div class="layui-form-item inline">
					<label class="layui-form-label" >电话</label>
					<div class="layui-input-inline">
						<input type="text" name="telephone"  autocomplete="off" class="layui-input"  value="">
					</div>
				</div>
					<div class="layui-form-item inline" >
					<label class="layui-form-label" >培养层次</label>
					<div class="layui-input-inline">
						<select name="gradation"  lay-verify="required" lay-search>
							<option value="">请选择</option>
							<%
								String jz_sql = "select id,name from jz_culture_level;";
								ResultSet jz_sqlRs = db.executeQuery(jz_sql);
								while(jz_sqlRs.next()){
							%>
								<option value="<%=jz_sqlRs.getString("id")%>"><%=jz_sqlRs.getString("name") %></option>
							<%}if(jz_sqlRs!=null){jz_sqlRs.close();} %>
						</select>
					</div>
				</div>
				<div class="layui-form-item inline">
					<label class="layui-form-label" >籍贯</label>
					<div class="layui-input-inline">
						<input type="text" name="native_place"  autocomplete="off" class="layui-input"  value="">
					</div>
				</div>
				<div class="layui-form-item inline">
					<label class="layui-form-label" >毕业学校</label>
					<div class="layui-input-inline">
						<input type="text" name="graduate_institution"  autocomplete="off" class="layui-input"  value="">
					</div>
				</div>
				<div class="layui-form-item inline">
					<label class="layui-form-label" >紧急人联系电话</label>
					<div class="layui-input-inline">
						<input type="text" name="emergency_telephone"  lay-verify="required" autocomplete="off" class="layui-input"  value="">
					</div>
				</div>
				<div class="layui-form-item inline" >
					<label class="layui-form-label" >高考分数</label>
					<div class="layui-input-inline">
						<input type="text" name="exam_score"  autocomplete="off" class="layui-input" value=""  >
					</div>
				</div>
				<div class="layui-form-item inline" >
					<label class="layui-form-label" >家庭住址</label>
					<div class="layui-input-inline">
						<input type="text" name="home_address"  autocomplete="off" class="layui-input" value=""  >
					</div>
				</div>
				<div class="layui-form-item inline" >
					<label class="layui-form-label" >学籍状态</label>
					<div class="layui-input-inline">
						<input type="text" name="student_roll"  autocomplete="off" class="layui-input" value=""  >
					</div>
				</div>
				<div class="layui-form-item inline" >
					<label class="layui-form-label" >政治面貌</label>
					<div class="layui-input-inline">
<%--						<input type="text" name="politics_status"  autocomplete="off" class="layui-input" value=""  >--%>
						<select name="politics_status"  lay-verify="required" lay-search>
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
				<div class="layui-form-item inline" >
					<label class="layui-form-label" >备注</label>
					<div class="layui-input-inline">
						<input type="text" name="comments"  autocomplete="off" class="layui-input" value=""  >
					</div>
				</div>
		
				<div class="layui-form-item" style="margin-bottom:45px">
					<div class="layui-input-block"  style="margin-left:540px">
						<button class="layui-btn" lay-submit="" ;>确认</button>
					</div>
				</div>
			</form>
		</div>
	
		<script>
			layui.use(['form', 'layedit', 'laydate'], function() {
				var form = layui.form,
					layer = layui.layer,
					layedit = layui.layedit,
					laydate = layui.laydate;

				 form.on('select(department)',function(data){
						if(data.value!="0"){
							var obj_str1 = {"departments_id":data.value};
							var obj1 = JSON.stringify(obj_str1)
							var ret_str1=PostAjx('../../../../../Api/v1/?p=web/info/getMajor',obj1,'<%=Suid%>','<%=Spc_token%>');
							obj1 = JSON.parse(ret_str1);
							$("#major").html(obj1.data);
							form.render('select');
						}
					})
					
				 form.on('select(major)',function(data){
						if(data.value!="0"){
							var obj_str1 = {"major_id":data.value};
							var obj1 = JSON.stringify(obj_str1)
							var ret_str1=PostAjx('../../../../../Api/v1/?p=web/info/getClassGrade',obj1,'<%=Suid%>','<%=Spc_token%>');
							obj1 = JSON.parse(ret_str1);
							$("#classroomid").html(obj1.data);
							form.render('select');
						}
					})

				 laydate.render({
					    elem: '#start_date' //指定元素
					  });
				 laydate.render({
					    elem: '#birth' 
					  });
				  
				form.verify({  
				 	zhengshu:function(value){
				 		if(value.indexOf('%')>=0){
							value = value.replace('%','');
					 		}
				 		var reg = /^\d+(?=\.{0,1}\d+$|$)/;
						 if(!reg.test(value)){
						  return '必须是正数' ;
						  }
				 		}
					  });  
			<%	
	if(ac.equals("post")){
		String stuname ="";
		String test_number ="";
		String student_number ="";
		String alarm ="";
		String idcard ="";
		String sex ="";
		String nation ="";
		String birth ="";
		String start_date ="";
		String major ="";
		String telephone ="";
		String native_place ="";
		String graduate_institution ="";
		String emergency_telephone ="";
		String home_address ="";
		String exam_score ="";
		String student_roll ="";
		String politics_status ="";
		String gradation = request.getParameter("gradation");
		String comments ="";
		String classroomid ="";
		String faculty ="";
		stuname =  request.getParameter("stuname");
		test_number =  request.getParameter("test_number");
		alarm =  request.getParameter("alarm");
		idcard =  request.getParameter("idcard");
		student_number = request.getParameter("student_number");
		sex = request.getParameter("sex");
		nation = request.getParameter("nation");
		birth = request.getParameter("birth");
		start_date = request.getParameter("start_date");
		major = request.getParameter("major");
		telephone = request.getParameter("telephone");
		native_place = request.getParameter("native_place");
		graduate_institution = request.getParameter("graduate_institution");
		emergency_telephone = request.getParameter("emergency_telephone");
		home_address = request.getParameter("home_address");
		exam_score = request.getParameter("exam_score");
		student_roll = request.getParameter("student_roll");
		politics_status = request.getParameter("politics_status");
		comments = request.getParameter("comments");
		classroomid = request.getParameter("classroomid");
		faculty = request.getParameter("faculty");
		String checkSql ="select count(id) as row from student_basic t  where t.student_number='"+student_number+"' or t.telephone='"+telephone+"'";
		int rows = db.Row(checkSql);
		if(rows>0){
			out.print("layer.msg('学号或手机号已存在,请勿重新添加')");
		}else{
		String sql = "INSERT INTO student_basic (stuname,test_number,student_number,idcard,alarm,sex,nation,birth,start_date,major,telephone,native_place,graduate_institution,emergency_telephone,home_address,exam_score,student_roll,politics_status,comments,classroomid,faculty,gradation) VALUES ('"+stuname+"','"+test_number+"','"+student_number+"','"+alarm+"','"+idcard+"','"+sex+"','"+nation+"','"+birth+"','"+start_date+"','"+major+"','"+telephone+"','"+native_place+"','"+graduate_institution+"','"+emergency_telephone+"','"+home_address+"','"+exam_score+"','"+student_roll+"','"+politics_status+"','"+comments+"','"+classroomid+"','"+faculty+"','"+gradation+"')";
		boolean status = db.executeUpdate(sql);
		if(status){
		 	out.print("var index = parent.layer.getFrameIndex(window.name); parent.layer.close(index); parent.location.reload();;");
		 }else{
		 	out.print("layer.msg('提交错误')");
		 }
		}
	}
	%>
			});
			
	</script>
	</body>
</html>
<%
//插入常用菜单日志
int   TagMenu=db.Row("SELECT COUNT(*) as row FROM  menu_worker  WHERE sysmenuid='"+PMenuId+"' and  workerid='"+Suid+"' and  companyid='"+Scompanyid+"'");
if(TagMenu==0){
  db.executeUpdate("INSERT INTO `menu_worker`(`sysmenuid`,`workerid`,`countes`,`companyid`) VALUES ('"+PMenuId+"','"+Suid+"','1','"+Scompanyid+"');"); 
}else{
 db.executeUpdate("UPDATE  `menu_worker` SET `countes`=countes+1,`usetime`=now() WHERE  sysmenuid='"+PMenuId+"' and  workerid='"+Suid+"' and  companyid= '"+Scompanyid+"'");
}
 %>
<%
if(db!=null)db.close();db=null;if(server!=null)server=null;
%>