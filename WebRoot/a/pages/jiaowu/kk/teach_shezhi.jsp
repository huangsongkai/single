<%@ page trimDirectiveWhitespaces="true" %>
<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@page import="v1.haocheok.commom.common"%>
<%@page import="service.dao.db.Page"%>
<%@page import="org.apache.commons.lang3.StringUtils" %>

<%@ include file="../../cookie.jsp"%>

<%
	String state_save = request.getParameter("state");				//状态值  判断是否有保存按钮
	String id = request.getParameter("id");		//主键id
	String school_year = request.getParameter("school_year");		//学年学期
	common common=new common();					//使用common
	
	
	String sqlwhere = "";
	String num_slq1 = "SELECT COUNT(1) AS ROW FROM teaching_task_teacher WHERE teaching_task_id = '"+id+"' AND teaching_task_teacher.state = 1; ";
	int num1 = db.Row(num_slq1);
	if(num1>0){
		sqlwhere = "	AND teaching_task_teacher.state = 1";
	}
	
	String base_sql = "SELECT		*,																										"+
		"		  teaching_task_teacher.teacherid as teacher_id,					"+
		"		  dict_courses.course_name          AS course_name,                                                                 "+
		"		  dict_courses.course_code          AS course_code,                                                                 "+
		"		  marge_class.class_grade_number as class_grade_numberssss	,"+
		"		  dict_departments.id as dict_departmentsid,														"+
		"		  dict_departments.departments_name AS departments_name                                                            "+
		"		FROM teaching_task                                                                                                  "+
		"		  LEFT JOIN dict_departments       ON teaching_task.dict_departments_id = dict_departments.id                                                      "+
		"		  LEFT JOIN teaching_task_teacher  ON teaching_task.id = teaching_task_teacher.teaching_task_id	"+
		"		  LEFT JOIN dict_courses           ON teaching_task.course_id = dict_courses.id                                                                    "+
		"		LEFT JOIN marge_class ON teaching_task.marge_class_id = marge_class.id							"+
		"		WHERE teaching_task.id = '"+id+"'  "+sqlwhere+"";
	
	System.out.println(base_sql);
	ResultSet set = db.executeQuery(base_sql);
	
	String course_name = "";
	String departments_name = "";
	String course_code = "";
	String dict_departmentsid = "";
	String teaching_research_number = "";
	String class_grade_numberssss = "";
	String class_name ="";
	
%>

<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title></title>
<link href="../../css/style-7.css" rel="stylesheet" type="text/css" />
<link href="../../css/combo.select.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" href="../../js/layui2/css/layui.css">
<script type="text/javascript" src="../../js/jquery-1.9.1.js" ></script><!--通用jquery-->
<script type="text/javascript" src="../../js/jquery.combo.select.js" ></script><!--通用jquery-->
<script src="../../js/layui2/layui.js"></script>
<script type="text/javascript">
	function setsubmit(){
		var obj = document.getElementById('formid');
		obj.submit();
	}

	layui.use('form', function() {
		layer = layui.layer,
		layedit = layui.layedit,
		laydate = layui.laydate;

		var form = layui.form;
		//监听提交
		form.on('submit(*)', function(data){
			var classes_weekly = $("#classes_weekly").val();
			if(classes_weekly==""||classes_weekly==null){
				layer.msg("请填写授课周数");
				return false;
			}

			/*var class_begins_weeks = $("#weekjistate").val();
			if(class_begins_weeks==null || class_begins_weeks==""){
				layer.msg("讲课周次");
				return false;
			}
			*/
			var ss=true;
			
			/*验证数字*/
			var type="^[0-9]*$"; 
			var r=new RegExp(type); 
			$("input.w-num").each(function(){	
			
				var flag=r.test($(this).val());
				if(!flag  || $(this).val().length<1){
					if($(this).attr('id')==undefined){
						$(this).attr('id',new Date().getTime()+parseInt(50*Math.random()));
					}
					layer.tips('只能输入数字！', '#'+$(this).attr('id'));
					 ss= false;
					 return false;
				}else{
					 ss= true;
					 return true;
				}
			 
			});	
			if(ss==false){
				return false;
			}
			/*验证周数是否合法*/
			 $("input.w_dd").each(function(){	
			 
				var flag=/(\d{1}|(\d(-|,)\d{1}))/.test($(this).val());
				if(!flag){
					if($(this).attr('id')==undefined){
						$(this).attr('id',new Date().getTime()+parseInt(50*Math.random()));
					}
					layer.tips('输入的数据不合法！', '#'+$(this).attr('id'));
					 ss= false;
					 return false;
				}else{
					 ss= true;
					 return true;
				}
			 
			});	
			
			
			if(ss==false){
				return false;
			}
			
			return true;
		});

		
	
		})
	var index = parent.layer.getFrameIndex(window.name);

	function chazhao(){

		layer.open({
			  type: 2,
			  title: '设置教师',
			  offset: 't',//靠上打开
			  shadeClose: true,
			  maxmin:1,
			  shade: 0.5,
			  area: ['100%', '100%'],
			  content: 'teach_shezhi.jsp?id='+id+'&school_year='+school_year
		});
	}

	$(function() {
		$('#jiaoshi').comboSelect();
	});


	function duojiaoshi(teaching_task_id){

		var jiaoshi = $("#jiaoshi").val();
		if(jiaoshi=="0"){
			layer.msg("请先设置教师");
		}
		
		if(teaching_task_id=="0"|| teaching_task_id==null || teaching_task_id==""){
			layer.msg("请先保存再进行修改");
			return;
		}else{
			layer.open({
				  type: 2,
				  title: '设置多教师安排',
				  offset: 't',//靠上打开
				  shadeClose: true,
				  maxmin:1,
				  shade: 0.5,
				  area: ['100%', '100%'],
				  content: 'teach_many_set.jsp?teaching_task_id='+teaching_task_id+'&jiaoshi='+jiaoshi
			});

		}
		

	}
	
	/*计算总学时*/
	function xs_js(){
		
		$("#zz_xs").val(parseInt($("#jk_xs").val())+ parseInt($("#sy_xs").val())+ parseInt($("#sj_xs").val())); 

		/*改变本学期学时*/
		bxqxs_js();
		
	}
	/*讲课周次*/
	function jkzc_js(){
		var weekly=$("#weekjistate").val();

		if(weekly.length>0){
			/*记录周次=数组长度*/
			var totle_list=[];
			
			var list=weekly.split(",");

			
			for(var i=0;i<list.length;i++)
			{
				var t=list[i];

				if(t.length>0){
					
					if(t.indexOf("-")==-1){
		    			/*不存在周数范围*/
		    			totle_list.push(t);
		    		}else{
		    			//存在周数范围
		    			
		    			var ss = t.split("-");

		    			var g=Number(ss[0]);
		    			var h=Number(ss[1]);
		    			for(;g<=h;g++){
		    				totle_list.push(g);
		    			}
		    		}
				}  
			}
			/*改变授课周数*/
			$("#classes_weekly").val(totle_list.length);

			/*改变本学期学时*/
			bxqxs_js();
		}
	}
	
	//
	function bxqxs_js(){

		/*授课周数*/
		var classes_weekly=$("#classes_weekly").val();

		/*总学时*/
		var zz_xs=$("#zz_xs").val(); 

		/*改变本学期学时*/
		$("#semester_hours").val(zz_xs*classes_weekly);
		$("#semester_jiangke").val(zz_xs*classes_weekly);
		
	}
	//zz_xs=jk_xs+sy_xs+sj_xs  
	
</script>
</head>

<body>
<form action="?ac=add" method="post" id="formid">
<input type="hidden" name="base_id" value="<%=id%>"   />

<div id="bottom">
<%


while(set.next()){
	int shangkerenshu = 0;
	course_name = set.getString("course_name");
	departments_name = set.getString("departments_name");
	course_code = set.getString("course_code");
	dict_departmentsid = set.getString("dict_departmentsid");
	teaching_research_number = set.getString("teaching_research_number");
	class_grade_numberssss = set.getString("class_grade_numberssss");
	String marge_name  = set.getString("marge_name");
	
	if(class_grade_numberssss==null){
		String people_number_nan = common.idToFieidName("class_grade","people_number_nan",set.getString("class_id")); 
		String people_number_woman =common.idToFieidName("class_grade","people_number_woman",set.getString("class_id")); 
		if(StringUtils.isBlank(people_number_nan)){
				people_number_nan="0";
			}
			if(StringUtils.isBlank(people_number_woman)){
				people_number_woman="0";
			}
		shangkerenshu = Integer.parseInt(people_number_nan) + Integer.parseInt(people_number_woman);
		class_name = common.idToFieidName("class_grade","class_name",set.getString("class_id"));
	}else{
		shangkerenshu = set.getInt("class_grade_numberssss");
		class_name =marge_name;
	}
	
	//查询多教师id 
	
	String ss = "select id from teaching_task_teacher where teaching_task_id = '"+set.getString("teaching_task.id")+"' and teacherid='"+set.getString("teacher_id")+"'";
	ResultSet ssset = db.executeQuery(ss);
	String duojiaoid = "";
	while(ssset.next()){
		duojiaoid = ssset.getString("id");
	}if(ssset!=null){ssset.close();}
	%>
	
	
	
	
	
	
	<div class="bottom_inner">
	<input type="hidden" name="duojiaoid" value="<%=duojiaoid%>"/>
    <div class="tit">
        <p class="tit_itme">院系：<span><%=departments_name %></span></p>
        <p class="tit_itme">学年学期：<span><%=school_year %></span></p>
        <p class="tit_itme">教研室：
	        <span>
	        	<select name="teaching_research_number" style="width:150px">
	        		<%
	        			String jiaoyanshi_sql = "select teaching_research_name,id from teaching_research where is_teaching=1";
	        			ResultSet set1 = db.executeQuery(jiaoyanshi_sql);
	        			while(set1.next()){
	        		%>	
	        			<option value="<%=set1.getString("id")%>" <%if(teaching_research_number.equals(set1.getString("id"))){out.println("selected='selected'");} %>><%=set1.getString("teaching_research_name") %></option>
	        		<%}if(set1!=null){set1.close();} %>
	        	
	        	</select>
	        </span>
        </p>
        <p class="tit_itme" >教师：
        	<select id="jiaoshi" name="teacher_id" style="width: 200px;display:inline-block;">
        		<option value="0">无</option>
        		<%
        			//String teacher_basic_sql = "select id, teacher_name,teachering_office,teacher_number from teacher_basic where faculty = '"+dict_departmentsid+"' ORDER BY teacher_name  DESC ;";
        			String teacher_basic_sql = "select id, teacher_name,teachering_office,teacher_number from teacher_basic where teacher_mark=1 and state=1   ORDER BY case when faculty = '"+dict_departmentsid+"' then 1 else 2 end";
        			ResultSet teacher_set = db.executeQuery(teacher_basic_sql);
        			while(teacher_set.next()){
        		%>
        			<%if(set.getString("teacher_id")!=null && set.getString("teacher_id").equals(teacher_set.getString("id"))){ %>
        				<option value="<%=teacher_set.getString("id")%>" selected="selected"><%=teacher_set.getString("teacher_number") %>-<%=teacher_set.getString("teacher_name") %>[<%=common.idToFieidName("teaching_research","teaching_research_name",teacher_set.getString("teachering_office")) %>]</option>
        			<%}else{ %>
        				<option value="<%=teacher_set.getString("id")%>"><%=teacher_set.getString("teacher_number") %>-<%=teacher_set.getString("teacher_name") %>[<%=common.idToFieidName("teaching_research","teaching_research_name",teacher_set.getString("teachering_office")) %>]</option>
        			<%} %>
        		<%}if(teacher_set!=null){teacher_set.close();} %>
        	</select>
        </p>
        <p class="tit_itme" >联合课码：<input class="my_input" name="union_class_code" value="<% if(StringUtils.isBlank(set.getString("union_class_code"))){out.println("0");}else{out.println(set.getString("union_class_code"));}%>" ></p>
        <p class="tit_itme" >选课性质：
        	<select width="100%" name="character_selection">
        		<option value="0" <%if("0".equals(set.getString("character_selection"))){out.println("selected='selected'");} %>>正常选课</option>
        		<option value="1" <%if("1".equals(set.getString("character_selection"))){out.println("selected='selected'");} %>>重修选课</option>
        		<option value="2" <%if("2".equals(set.getString("character_selection"))){out.println("selected='selected'");} %>>正常/重修选课</option>
          	</select>
        </p>
    </div> 

    <table class="dataintable">
      <tbody>
	        <tr>
		          <td>课程名称：</td>
		          <td colspan="3"><%=course_name %></td>
		          <td colspan="2">课程编码</td>
		          <td colspan="3"><%=course_code %></td>
	        </tr>
	        <tr>
		          <td>课程类别：</td>
		          <td colspan="3">
		            <select width="100%" name="course_category_id">
		            <%
		          		String dict_course_category_sql = "select id,category from dict_course_category";
		          		ResultSet dict_course_category_set = db.executeQuery(dict_course_category_sql);
		          		while(dict_course_category_set.next()){
		          %>
		          		<option value ="<%=dict_course_category_set.getString("id")%>" <%if( set.getString("course_category_id").equals(dict_course_category_set.getString("id"))){out.println("selected='selected'"); }%>><%=dict_course_category_set.getString("category") %></option>
		          	
		          <%}if(dict_course_category_set!=null){dict_course_category_set.close();} %>
		              
		            </select>
		          </td>
		          <td colspan="2">课程性质</td>
		          <td colspan="3">
		            <select width="100%" name="course_nature_id">
		        		<%
		        			String dict_course_nature_sql = "select nature,id from dict_course_nature";
		        			ResultSet nature_set = db.executeQuery(dict_course_nature_sql);
		        			while(nature_set.next()){
		        		%>
		        			<%if(set.getString("course_nature_id")!=null && set.getString("course_nature_id").equals(nature_set.getString("id"))){ %>
		        				<option value ="<%=nature_set.getString("id")%>" selected="selected"><%=nature_set.getString("nature") %></option>
		        			<%}else{ %>
		        				<option value ="<%=nature_set.getString("id")%>"><%=nature_set.getString("nature") %></option>
		        			<%} %>
		        			
		        		<%}if(nature_set!=null){nature_set.close();} %>
		          	</select>
		          </td>
	        </tr>
        	<tr>
		          <td>授课周数：</td>
		          <td>
		          	<input class="my_input my-block w-num" name="classes_weekly" id ="classes_weekly" value="<%if(StringUtils.isBlank(set.getString("classes_weekly"))){out.println("0");}else{out.println(set.getString("classes_weekly"));}%>">
		          </td>
		          <td class="my-color w_dd" colspan="2">实践周次：<input class="my_input" name="practice_weeks" value="<%if(StringUtils.isBlank(set.getString("practice_weeks"))){out.println("0");}else{out.println(set.getString("practice_weeks"));}%>"></td>
		          <td colspan="5">考核方式：
		            <select width="100%" name="assessment_id">
		            	<%
		            		String dict_assessment_sql = "select assessment_name,id from dict_assessment";
		            		ResultSet dict_aResultSet = db.executeQuery(dict_assessment_sql);
		            		while(dict_aResultSet.next()){
		            	%>	
		            		<%if(set.getString("assessment_id")!=null && set.getString("assessment_id").equals(dict_aResultSet.getString("id"))){ %>
		            			<option value ="<%=dict_aResultSet.getString("id") %>" selected="selected"><%=dict_aResultSet.getString("assessment_name") %></option>
		            		<%}else{ %>
		            			<option value ="<%=dict_aResultSet.getString("id") %>"><%=dict_aResultSet.getString("assessment_name") %></option>
		            		<%} %>
		            	<%}if(dict_aResultSet!=null){dict_aResultSet.close();} %>
		              
		            </select>考试类别：
		            <select width="100%" name="assessment_category_id">
		            	 <%
		            	 	String assessment_category_sql = "select id,category_name from dict_assessment_category";
		            	 	ResultSet assessment_category_set = db.executeQuery(assessment_category_sql);
		            	 	while(assessment_category_set.next()){
		            	 %>
		            	 	<%if(set.getString("assessment_category_id")!=null && set.getString("assessment_category_id").equals(assessment_category_set.getString("id"))){ %>
		            	 		<option value ="<%=assessment_category_set.getString("id")%>" selected="selected"><%=assessment_category_set.getString("category_name") %></option>
		            	 	<%}else{ %>
		            	 		<option value ="<%=assessment_category_set.getString("id")%>"><%=assessment_category_set.getString("category_name") %></option>
		            	 	<%} %>
		            	 <%}if(assessment_category_set!=null){assessment_category_set.close();} %>
		              
		            </select>
		          </td>
        	</tr>
	        <tr>
		          <td class="my-color">
		          		讲课周次：
		          </td>
		          <td>
		          		<input class="my_input my-block "  onkeyup="jkzc_js()" id="weekjistate" <%if("1".equals(set.getString("weekjistate"))){out.println("style='color:red;'");} %> name="class_begins_weeks"  value="<% if(StringUtils.isBlank(set.getString("class_begins_weeks"))){out.println("0");}else{out.println(set.getString("class_begins_weeks"));}%>">
		          </td>
		          <td class="my-color">
		          		实验周次：
		          </td>
		          <td>
		          		<input   class="my_input my-block " name="experiment_weeks" value="<%if(StringUtils.isBlank(set.getString("experiment_weeks"))){out.println("0");}else{out.println(set.getString("experiment_weeks"));} %>">
		          </td>
		          <td colspan="2">
		          		周学时总数：<input class="my_input w-num" id="zz_xs" readonly="readonly" name="week_learn_time" value="<% if(StringUtils.isBlank(set.getString("week_learn_time"))){out.println("0");}else{out.println(set.getString("week_learn_time"));} %>">
		          </td>
		          <td colspan="3" class="my-color">
				               讲课周学时：<input id="jk_xs" onkeyup="xs_js()" class="my_input w-num" name="start_semester" value="<%  if(StringUtils.isBlank(set.getString("start_semester"))){out.println("0");}else{out.println(set.getString("start_semester"));} %>">
				               实验周学时：<input id="sy_xs" onkeyup="xs_js()" class="my_input w-num" name="experiment" value="<%  if(StringUtils.isBlank(set.getString("experiment"))){out.println("0");}else{out.println(set.getString("experiment"));} %>">
		          </td>
	        </tr>
	        <tr>
		          <td></td>
		          <td></td>
		          <td class="my-color">上机周次：</td>
		          <td>
		          		<input class="my_input my-block " name="computer_weeks" value="<% if(StringUtils.isBlank(set.getString("computer_weeks"))){out.println("0");}else{out.println(set.getString("computer_weeks"));}  %>">
		          </td>
		          <td></td>
		          <td></td>
		          <td></td>
		          <td colspan="2" class="my-color">
		                                上机周学时：<input id="sj_xs" onkeyup="xs_js()" {console.log(jk_sx.val());}" class="my_input w-num" name="computer_week_time" value="<%  if(StringUtils.isBlank(set.getString("computer_week_time"))){out.println("0");}else{out.println(set.getString("computer_week_time"));}  %>">
		          </td>
	        </tr>
	        <tr>
		          <td>  总学分：</td>
		          <td>
		          		<input class="my_input my-block w-num" name="credits" value="<%  if(StringUtils.isBlank(set.getString("credits"))){out.println("0");}else{out.println(set.getString("credits"));} %>"> 
		          </td>
		          <td>	本学期学分：</td>
		          <td>
		          		<input class="my_input my-block w-num" name="credits_term" value="<% if(StringUtils.isBlank(set.getString("credits_term"))){out.println("0");}else{out.println(set.getString("credits_term"));} %>">
		          </td>
		          <td colspan="2">
		          		开课总学期数：
		          </td>
		          <td>
		          		<input class="my_input my-block w-num" name="totle_semester" value="<% if(StringUtils.isBlank(set.getString("totle_semester"))){out.println("0");}else{out.println(set.getString("totle_semester"));} %>">
		          </td>
		          <td>	开课学期序号：</td>
		          <td>
		          		<input class="my_input my-block" name="startnum" value="<%  if(set.getString("startnum")==null || set.getString("startnum").length()<1 ){out.println("0");}else{out.println(set.getString("startnum"));}%>">
		          </td>
	        </tr>
	        <tr>
		          <td>  学时分配：</td>
		          <td colspan="2" class="my-center">
		          		总学时
		          </td>
		          <td class="my-center">
		          		讲课
		          </td>
		          <td colspan="2" class="my-center">
		          		其中实验
		          </td>
		          <td colspan="2" class="my-center">
		          		其中上机
		          </td>
		          <td class="my-center">
		         		实践学时/周数
		         </td>          
	        </tr>
	        <tr>
	          	 <td>	总学时：</td>
	         	 <td colspan="2">
	         	 		<input class="my_input my-block w-num" name="total_classes" value="<% if(StringUtils.isBlank(set.getString("total_classes"))){out.println("0");}else{out.println(set.getString("total_classes"));}%>">
	         	 </td>
	          	 <td>	
	          	 		<input class="my_input my-block w-num" name="lecture_hours" value="<% if(StringUtils.isBlank(set.getString("lecture_hours"))){out.println("0");}else{out.println(set.getString("lecture_hours"));}%>">
	          	 </td>
		         <td colspan="2">
		         		<input class="my_input my-block w-num" name="amongshiyan" value="<% if(StringUtils.isBlank(set.getString("amongshiyan"))){out.println("0");}else{out.println(set.getString("amongshiyan"));}%>">
		         </td>
		         <td>
		         		<input class="my_input my-block w-num" name="amongshangji" value="<%  if(StringUtils.isBlank(set.getString("amongshangji"))){out.println("0");}else{out.println(set.getString("amongshangji"));}%>">
		         </td>
		         <td class="my-center" colspan="2"><input class="my_input w-num" name="practice_time" value="<%  if(StringUtils.isBlank(set.getString("practice_time"))){out.println("0");}else{out.println(set.getString("practice_time"));}%>">
		            	<select width="100%" name="practice_state">
		             		<option value ="1" <%if("1".equals(set.getString("practice_state"))){out.println("selected='selected'");} %>>周数</option>
		              		<option value ="2" <%if("2".equals(set.getString("practice_state"))){out.println("selected='selected'");} %>>学时</option>
		            	</select>
	          	</td>          
	        </tr>
	        <tr>
	          	<td>	本学期学时：</td>
	          	<td colspan="2">
	          			<input class="my_input my-block w-num"   id="semester_hours" name="semester_hours" value="<%  if(StringUtils.isBlank(set.getString("semester_hours"))){out.println("0");}else{out.println(set.getString("semester_hours"));}%>">
	          	</td>
	          	<td>
	          			<input class="my_input my-block w-num"  id="semester_jiangke" name="semester_jiangke" value="<%  if(StringUtils.isBlank(set.getString("semester_jiangke"))){out.println("0");}else{out.println(set.getString("semester_jiangke"));} %>">
	          	</td>
	          	<td colspan="2">
	          			<input class="my_input my-block w-num" name="semester_amongshiyan" value="<% if(StringUtils.isBlank(set.getString("semester_amongshiyan"))){out.println("0");}else{out.println(set.getString("semester_amongshiyan"));}%>">
	          	</td>
	          	<td>
	          			<input class="my_input my-block w-num" name="semester_amongshangji" value="<%  if(StringUtils.isBlank(set.getString("semester_amongshangji"))){out.println("0");}else{out.println(set.getString("semester_amongshangji"));} %>">
	          	</td>
	          	<td class="my-center" colspan="2">
	          			<input class="my_input w-num" name="semester_practice_time" value="<% if(StringUtils.isBlank(set.getString("semester_practice_time"))){out.println("0");}else{out.println(set.getString("semester_practice_time"));}%>">
	            		<select width="100%" name="semester_practice_state">
	              			<option value ="1" <%if("1".equals(set.getString("semester_practice_state"))){out.println("selected='selected'");} %>>周数</option>
	              			<option value ="2" <%if("2".equals(set.getString("semester_practice_state"))){out.println("selected='selected'");} %>>学时</option>
	            		</select>
	          	</td>          
	        </tr>
	        <tr>
		        <td>	班级名称：</td>
		        <td colspan="8">
		          <%=class_name %>
		        </td>  
	        </tr>
	        <tr>
	            <td>	需特殊教学区：</td>
	            <td colspan="2">
	              		<select width="100%" name="teaching_area_id">
			              	<option value="0">无</option>
			              	<%
			              		String teaching_area_sql = "select id,teaching_area_name from teaching_area";
			              		ResultSet teaching_area_set = db.executeQuery(teaching_area_sql);
			              		while(teaching_area_set.next()){
			              	%>
			              		<%if(set.getString("teaching_area_id")!=null && set.getString("teaching_area_id").equals(teaching_area_set.getString("id"))){ %>
			              			<option value ="<%=teaching_area_set.getString("id")%>" selected="selected"><%=teaching_area_set.getString("teaching_area_name")%></option>
			              		<%}else{ %>
			           				<option value ="<%=teaching_area_set.getString("id")%>" ><%=teaching_area_set.getString("teaching_area_name")%></option>
			              		<%} %>
			              	<%}if(teaching_area_set!=null){teaching_area_set.close();} %>
	              		</select>
	           </td>
	           <td>		需特殊实验区</td>
	           <td colspan="3">
	            		<select width="100%" name="experiment_area_id">
	            			<option value="0">无</option>
			                <%
			              		String teaching_area_sql1 = "select id,teaching_area_name from teaching_area";
			              		ResultSet teaching_area_set1 = db.executeQuery(teaching_area_sql);
			              		while(teaching_area_set1.next()){
			              	%>
			              		<%if(set.getString("teaching_area_id")!=null && set.getString("teaching_area_id").equals(teaching_area_set1.getString("id"))){ %>
			              			<option value ="<%=teaching_area_set1.getString("id")%>" selected="selected"><%=teaching_area_set1.getString("teaching_area_name")%></option>
			              		<%}else{ %>
			           				<option value ="<%=teaching_area_set1.getString("id")%>" ><%=teaching_area_set1.getString("teaching_area_name")%></option>
			              		<%} %>
			              	<%}if(teaching_area_set1!=null){teaching_area_set1.close();} %>
			            </select>
	            </td>
	            <td>	性别要求：</td>
	            <td>
		                <select width="100%" name="sex_ask">
			                <option value ="0" <%if("0".equals(set.getString("sex_ask"))){out.println("selected='selected'");} %>>无</option>
			                <option value ="1" <%if("1".equals(set.getString("sex_ask"))){out.println("selected='selected'");} %>>男</option>
			                <option value ="2" <%if("2".equals(set.getString("sex_ask"))){out.println("selected='selected'");} %>>女</option>
		                </select>
	            </td>
	        </tr>
	        <tr>
	           <td>
	           			<button class="mybtn">默认值</button></td>
	           <td colspan="3">
				              上课人数：<input class="my_input w-num" name="classes_number" readonly="readonly" value="<%=shangkerenshu%>">
				              排课人数：<input class="my_input w-num" name="course_number" value="<% if(StringUtils.isBlank(set.getString("course_number"))){out.println("0");}else{out.println(set.getString("course_number"));}%>">
	           </td>
	           <td colspan="5"><%if("1".equals(state_save)){%><button class="mybtn" onclick="" lay-submit lay-filter="*">保存</button><%} %></td>
	        </tr>
        </tbody>
    </table>
    <%}if(set!=null){set.close();} %>
  </div>
</div>
</form>
</body>

</html>

<%
	//提交
	if("add".equals(ac)){
		//接受信息
		String teacher_id = request.getParameter("teacher_id");
		String base_id = request.getParameter("base_id");					//teaching_task 主键
		String union_class_code = request.getParameter("union_class_code");	//联合课码
		String character_selection = request.getParameter("character_selection");	//选课性质
		String course_category_id = request.getParameter("course_category_id");		//课程类别
		String course_nature_id = request.getParameter("course_nature_id");		//课程性质
		String classes_weekly = request.getParameter("classes_weekly");			//授课周数
		String practice_weeks = request.getParameter("practice_weeks");			//实践周次
		String assessment_id = request.getParameter("assessment_id");			//考核方式
		String assessment_category_id = request.getParameter("assessment_category_id");	//考试类别
		String class_begins_weeks = request.getParameter("class_begins_weeks");		//讲课周次/上课周次
		String experiment_weeks = request.getParameter("experiment_weeks");		//实验周次
		String week_learn_time = request.getParameter("week_learn_time");		//周学时数
		String start_semester = request.getParameter("start_semester");		//讲课周学时
		String experiment = request.getParameter("experiment");				//实验周学时
		String computer_weeks = request.getParameter("computer_weeks");			//上机周次
		String computer_week_time = request.getParameter("computer_week_time");		//上机周学时
		String credits = request.getParameter("credits");				//总学分
		String credits_term = request.getParameter("credits_term");			//本学期学分
		String totle_semester = request.getParameter("totle_semester");			//开课总学期数
		String startnum = request.getParameter("startnum");				//开课学期序号
		String total_classes = request.getParameter("total_classes");			//总学时
		String lecture_hours = request.getParameter("lecture_hours");			//总学时 讲课
		String amongshiyan = request.getParameter("amongshiyan");			//总学时 其中实验
		String amongshangji = request.getParameter("amongshangji");			//总学时 其中上机
		String practice_time = request.getParameter("practice_time");			//实践学时/周次
		String practice_state = request.getParameter("practice_state");			//周次状态
		String semester_hours = request.getParameter("semester_hours");			//本学期 总学时
		String semester_jiangke = request.getParameter("semester_jiangke");		//本学期 讲课
		String semester_amongshiyan = request.getParameter("semester_amongshiyan");	//本学期 其中实验
		String semester_amongshangji = request.getParameter("semester_amongshangji");	//本学期 其中上机
		String semester_practice_state = request.getParameter("semester_practice_state");	//本学期 状态
		String teaching_area_id = request.getParameter("teaching_area_id");		//需特殊教学区
		String experiment_area_id = request.getParameter("experiment_area_id");		//需特殊实验区
		String sex_ask = request.getParameter("sex_ask");				//性别需求
		String classes_number = request.getParameter("classes_number");			//上课人数
		String course_number = request.getParameter("course_number");			//排课人数
		String semester_practice_time = request.getParameter("semester_practice_time");		//本学期 实践学时
		String teaching_research_number_new = request.getParameter("teaching_research_number");	//教研室id
		
		
		String teaching_task_update = "UPDATE teaching_task 						"+
							"		SET                                             "+
							"		course_category_id = '"+course_category_id+"' ,     "+
							"		course_nature_id = '"+course_nature_id+"' ,          "+
							"			union_class_code = '"+union_class_code+"' ,                                               "+
							"			character_selection = '"+character_selection+"' ,                                                                     "+
							"			classes_weekly = '"+classes_weekly+"' ,                                                         "+
							"			practice_weeks = '"+practice_weeks+"' ,                                                                 "+
							"			assessment_id = '"+assessment_id+"' ,                                                               "+
							"			assessment_category_id = '"+assessment_category_id+"' ,                                                       "+
							"			class_begins_weeks = '"+class_begins_weeks+"' ,                                     "+
							"			experiment_weeks = '"+experiment_weeks+"' ,                                                 "+
							"			week_learn_time = '"+week_learn_time+"' ,                                                     "+
							"			start_semester = '"+start_semester+"' ,                                         "+
							"			experiment = '"+experiment+"' ,                                                           "+
							"			computer_weeks = '"+computer_weeks+"' ,                           "+
							"			computer_week_time = '"+computer_week_time+"' ,                                                 "+
							"			credits = '"+credits+"' ,                                                         "+
							"			credits_term = '"+credits_term+"' ,                                                     "+
							"			totle_semester = '"+totle_semester+"' ,                                                         "+
							"			startnum = '"+startnum+"' ,                           "+
							"			total_classes = '"+total_classes+"' ,                                                         "+
							"			lecture_hours = '"+lecture_hours+"' ,                                                           "+
							"			amongshiyan = '"+amongshiyan+"' ,                                                                     "+
							"			amongshangji = '"+amongshangji+"' ,                                                                       "+
							"			practice_time = '"+practice_time+"' ,                                                           "+
							"			practice_state = '"+practice_state+"' ,                                         "+
							"			semester_hours = '"+semester_hours+"' ,                                                         "+
							"			semester_jiangke = '"+semester_jiangke+"' ,                                                         "+
							"			semester_amongshiyan = '"+semester_amongshiyan+"' ,                                                             "+
							"			semester_amongshangji = '"+semester_amongshangji+"' ,                                                         "+
							"			semester_practice_state = '"+semester_practice_state+"' ,                                                           "+
							"			teaching_area_id = '"+teaching_area_id+"' ,                                                       "+
							"			experiment_area_id = '"+experiment_area_id+"' ,                                                 "+
							"			sex_ask = '"+sex_ask+"' ,                                                                 "+
							"			classes_number = '"+classes_number+"' ,                                                 "+
							"			course_number = '"+course_number+"',                                                      "+
							"			teaching_research_number = '"+teaching_research_number_new+"',							"+
							"			weekjistate =1 ,							"+
							"			semester_practice_time = '"+semester_practice_time+"'										"+
							"		WHERE                                           "+
							"		id = '"+base_id+"' ;";
		boolean ss = db.executeUpdate(teaching_task_update);
		
		
		//查询多 是否存在
		String num_sql = "select count(1) as row from teaching_task_teacher		where teaching_task_id='"+base_id+"' AND state = 1 ";
		int num = db.Row(num_sql);
		if(num>0){
			//更新
			String update_sql = "UPDATE teaching_task_teacher 							"+
						"		SET                                                     "+
						"		teacherid = '"+teacher_id+"' ,                               "+
						"		class_begins_weeks = '"+class_begins_weeks+"' ,             "+
						"		teaching_week_time = '"+start_semester+"'              "+
						"		WHERE                                                   "+
						"		teaching_task_id = '"+base_id+"' AND state = 1  ;";
			db.executeUpdate(update_sql);
		}else{
			//插入
			String insert_sql = "INSERT INTO teaching_task_teacher 		"+
						"		(                                    "+
						"		teaching_task_id,                       "+
						"		teacherid,                              "+
						"		class_begins_weeks,                     "+
						"		teaching_week_time,                     "+
						"		leixing,                                "+
						"		state                                   "+
						"		)                                       "+
						"		VALUES                                  "+
						"		(                                  "+
						"		'"+base_id+"',                     "+
						"		'"+teacher_id+"',                            "+
						"		'"+class_begins_weeks+"',                   "+
						"		'"+start_semester+"',                   "+
						"		'1',                              "+
						"		'1'                                 "+
						"		);";
			
			db.executeUpdate(insert_sql);
			
			
		}
		
		
		
		if(ss){
			out.println("<script>parent.layer.msg('添加教师信息 成功', {icon:1,time:1000,offset:'150px'},function(){var index = parent.layer.getFrameIndex(window.name); parent.layer.close(index); parent.document.getElementById(\"w_button\").click(); })</script>");
		}else{
			out.println("<script>parent.layer.msg('添加教师信息 失败', {icon:2,time:1000,offset:'150px'},function(){var index = parent.layer.getFrameIndex(window.name);parent.layer.close(index);})</script>");
		}
			
		
		
		
	}
	


%>




<% if(db!=null)db.close();db=null;if(server!=null)server=null;%>