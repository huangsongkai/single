<%@ page trimDirectiveWhitespaces="true" %>
<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@page import="v1.haocheok.commom.common"%>
<%@page import="service.dao.db.Page"%>
<%@page import="com.sun.rowset.internal.Row"%>
<%@page import="org.apache.commons.lang3.StringUtils" %>

<%@ include file="../../cookie.jsp"%>

<%
	common common = new common();
	String teaching_task_classid = request.getParameter("teaching_task_classid");
	
	System.out.println("teaching_task_classid"+teaching_task_classid);
	
	
	String ssle_sql = "select dict_departments_id,major_id from teaching_task_class where teaching_plan_class_id = '"+teaching_task_classid+"'   limit 1 ;";
	
	String dict_departments_id_base = "";
	String major_id_base = "";
	
	ResultSet sshe = db.executeQuery(ssle_sql);
	if(sshe.next()){
		dict_departments_id_base = sshe.getString("dict_departments_id");
		major_id_base = sshe.getString("major_id");
	}if(sshe!=null){sshe.close();}
	
	
	
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
<script src="../../js/ajaxs.js"></script>
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
			var jiaoshi = $("#jiaoshi").val();
			if(jiaoshi=="0"){
				layer.msg("请先选择教师");
				return false;
			}
			var classes_weekly = $("#classes_weekly").val();
			if(classes_weekly==""||classes_weekly==null){
				layer.msg("请填写授课周数");
				return false;
			}
			var class_begins_weeks = $("#class_begins_weeks").val();
			if(class_begins_weeks==null || class_begins_weeks==""){
				layer.msg("讲课周次");
				return false;
			}
			
			
			var ss=true;
			
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
			
			/*验证数字*/
			var type="^[0-9]*$"; 
			var r=new RegExp(type); 
			$("input.w-num").each(function(){	
				
				var flag=r.test($(this).val());
				
				if(!flag || $(this).val().length<1){
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
		$('#course_id').comboSelect();
		var dict_departments_id='<%=dict_departments_id_base%>';
		var major_id='<%=major_id_base%>';
		$('#dict_departments_id').val(dict_departments_id);
		btnChange(dict_departments_id);
		$('#major_id').val(major_id);
		
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


	//通过院系 查找专业和教研室
	function btnChange(id){

		if(id!=0){
			//获取教研室 信息
			var obj_str = {"departments_id":id};
			var obj = JSON.stringify(obj_str)
			var ret_str=PostAjx('../../../../Api/v1/?p=web/info/teachingResearch',obj,'<%=Suid%>','<%=Spc_token%>');
			obj = JSON.parse(ret_str);
			$("#college_major").html(obj.data);
			if(obj.success){
				//获取专业信息
				var obj_str1 = {"departments_id":id};
				var obj1 = JSON.stringify(obj_str1)
				var ret_str1=PostAjx('../../../../Api/v1/?p=web/info/getMajor',obj1,'<%=Suid%>','<%=Spc_token%>');
				obj1 = JSON.parse(ret_str1);
				$("#major_id").html(obj1.data);
			}
		}
	}

	//通过专业查询班级
	function zhuanyeChange(major_id){
		//获取班级信息
		var obj_str1 = {"major_id":major_id};
		var obj1 = JSON.stringify(obj_str1)
		var ret_str1=PostAjx('../../../../Api/v1/?p=web/info/getClassGrade',obj1,'<%=Suid%>','<%=Spc_token%>');
		obj1 = JSON.parse(ret_str1);
		$("#class_id").html(obj1.data);
	}

	//获取课程编码
	function bianChange(str){

		console.log(str);
		var arr = new Array();
		arr = str.split("|"); 
		$("#bianma").text(arr[1]);

	}
	
	/*计算总学时*/
	function xs_js(){
		$("#zz_xs").val(parseInt($("#jk_xs").val())+ parseInt($("#sy_xs").val())+ parseInt($("#sj_xs").val())); 
		
	}
	//zz_xs=jk_xs+sy_xs+sj_xs  
	
</script>
</head>

<body>
<form action="?ac=add" method="post" id="formid"  >
<input type="hidden" name="teaching_task_classid" value="<%=teaching_task_classid%>"/>
<div id="bottom">
	
	<div class="bottom_inner">
	<input type="hidden" name="duojiaoid" value=""/>
    <div class="tit">
        <p class="tit_itme">院系：
	        <span>
	        	<select name="dict_departments_id" id="dict_departments_id" onchange='btnChange(this[selectedIndex].value);' style="width:150px" >
	        		<option value="0">请选择院系</option>
       				<%
		            /*查询院系*/
		            String selectDsql="SELECT  DISTINCT p.dict_departments_id,d.departments_name,d.departments_name,ELT(INTERVAL(CONV(HEX(LEFT(CONVERT(d.departments_name USING gbk),1)),16,10),0xB0A1,0xB0C5,0xB2C1,0xB4EE,0xB6EA,0xB7A2,0xB8C1,0xB9FE,0xBBF7,0xBFA6,0xC0AC,0xC2E8,0xC4C3,0xC5B6,0xC5BE,0xC6DA,0xC8BB,0xC8F6,0xCBFA,0xCDDA,0xCEF4,0xD1B9,0xD4D1),'A','B','C','D','E','F','G','H','J','K','L','M','N','O','P','Q','R','S','T','W','X','Y','Z') AS PY FROM  teaching_plan_class AS p, dict_departments AS d WHERE   p.dict_departments_id=d.id  ORDER BY py ASC;";
		            ResultSet yxRs = db.executeQuery(selectDsql);
		            while(yxRs.next()){
		            %>
	        			<option value="<%=yxRs.getString("dict_departments_id") %>" ><%=yxRs.getString("py") %>-<%=yxRs.getString("departments_name") %></option>
		            <%}if(yxRs!=null){yxRs.close();}%>
	        	</select>
	        </span>
        </p>
        <p class="tit_itme">教研室：
	        	<select name="teaching_research_number" id="college_major" style="width:165px"	>
	        	</select>
	        	
        </p>
        <p class="tit_itme">专业：
	        <select name="major_id" id="major_id" style="width:150px" onchange='zhuanyeChange(this[selectedIndex].value);'>
	        </select>
        </p>
        <p class="tit_itme">学年学期：
        
	        <select name="semester" style="width:150px">
	        	<%
	        		String semester_sql = "select this_academic_tag ,academic_year from academic_year";
	        		ResultSet setsem = db.executeQuery(semester_sql);
	        		while(setsem.next()){
	        	%>
	        		<option value="<%=setsem.getString("academic_year") %>" <%if("true".equals(setsem.getString("this_academic_tag"))){out.println("selected='selected'");} %> ><%=setsem.getString("academic_year") %></option>
	        	<%}if(setsem!=null){setsem.close();} %>
	        	
	        
	        </select>
        
        </p>
        
        
        <p class="tit_itme" >教师：
        	<select id="jiaoshi" name="teacher_id" style="width: 200px;display:inline-block;">
        		<option value="0">无</option>
        		<%
        			String teacher_basic_sql = "select id, teacher_name,teachering_office,teacher_number from teacher_basic where teacher_mark=1 and state=1";
        			ResultSet teacher_set = db.executeQuery(teacher_basic_sql);
        			while(teacher_set.next()){
        		%>
        				<option value="<%=teacher_set.getString("id")%>"><%=teacher_set.getString("teacher_number") %>-<%=teacher_set.getString("teacher_name") %>[<%=common.idToFieidName("teaching_research","teaching_research_name",teacher_set.getString("teachering_office")) %>]</option>
        		<%}if(teacher_set!=null){teacher_set.close();} %>
        	</select>
        </p>
        <p class="tit_itme" >联合课码：<input class="my_input" name="union_class_code" value="" ></p>
        <p class="tit_itme" >选课性质：
        	<select width="100%" name="character_selection">
        		<option value="0" >正常选课</option>
        		<option value="1" >重修选课</option>
        		<option value="2" >正常/重修选课</option>
          	</select>
        </p>
    </div> 

    <table class="dataintable">
      <tbody>
        <tr>
          <td>课程名称：</td>
          <td colspan="3">
          	<select name="course_id"  id="course_id" onchange='bianChange(this[selectedIndex].value);'>
	          	<%
	          		String sql1 = "select id,course_name,course_code from dict_courses ";
	          		ResultSet set1 = db.executeQuery(sql1);
	          		while(set1.next()){
	          	%>
	          		<option value="<%=set1.getString("id")%>|<%=set1.getString("course_code")%>"><%=set1.getString("course_name") %></option>
	          	<%}if(set1!=null){set1.close();} %>
	         </select>
          </td>
          	
          <td colspan="2">课程编码</td>
          <td colspan="3" id="bianma"> </td>
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
          		<option value ="<%=dict_course_category_set.getString("id")%>" ><%=dict_course_category_set.getString("category") %></option>
          	
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
       				<option value ="<%=nature_set.getString("id")%>"><%=nature_set.getString("nature") %></option>
        		<%}if(nature_set!=null){nature_set.close();} %>
          	</select>
          </td>
        </tr>

        <tr>
          <td>授课周数：</td>
          <td><input class="my_input my-block w_dd" name="classes_weekly" id ="classes_weekly" value=""></td>
          <td class="my-color" colspan="2">实践周次：<input class="my_input w_dd" name="practice_weeks" value=""></td>
          <td colspan="5">考核方式：
            <select width="100%" name="assessment_id">
            	<%
            		String dict_assessment_sql = "select assessment_name,id from dict_assessment";
            		ResultSet dict_aResultSet = db.executeQuery(dict_assessment_sql);
            		while(dict_aResultSet.next()){
            	%>	
           			<option value ="<%=dict_aResultSet.getString("id") %>"><%=dict_aResultSet.getString("assessment_name") %></option>
            	<%}if(dict_aResultSet!=null){dict_aResultSet.close();} %>
              
            </select>考试类别：
            <select width="100%" name="assessment_category_id">
            	 <%
            	 	String assessment_category_sql = "select id,category_name from dict_assessment_category";
            	 	ResultSet assessment_category_set = db.executeQuery(assessment_category_sql);
            	 	while(assessment_category_set.next()){
            	 %>
           	 		<option value ="<%=assessment_category_set.getString("id")%>"><%=assessment_category_set.getString("category_name") %></option>
            	 <%}if(assessment_category_set!=null){assessment_category_set.close();} %>
              
            </select>
          </td>
        </tr>
        <tr>
          <td class="my-color">讲课周次：</td>
          <td><input class="my_input my-block w_dd" name="class_begins_weeks" id="class_begins_weeks" value=""></td>
          <td class="my-color">实验周次：</td>
          <td><input class="my_input my-block w_dd" name="experiment_weeks" value=""></td>
          <td colspan="2">周学时总数：<input class="my_input w-num"   id="zz_xs" name="week_learn_time" value=""></td>
          <td colspan="3" class="my-color">
            讲课周学时：<input class="my_input w-num" id="jk_xs"  name="start_semester" value="">
            实验周学时：<input class="my_input w-num" id="sy_xs"  name="experiment" value="">
          </td>
        </tr>

        <tr>
          <td></td>
          <td></td>
          <td class="my-color">上机周次：</td>
          <td><input class="my_input my-block w_dd" name="computer_weeks" value=""></td>
          <td></td>
          <td></td>
          <td></td>
          <td colspan="2" class="my-color">
            上机周学时：<input class="my_input w-num" id="sj_xs" onkeyup="xs_js()" name="computer_week_time" value="">
          </td>
        </tr>

        <tr>
          <td>总学分：</td>
          <td><input class="my_input my-block w-num" name="credits" value=""> </td>
          <td>本学期学分：</td>
          <td><input class="my_input my-block w-num" name="credits_term" value=""></td>
          <td colspan="2">开课总学期数：</td>
          <td><input class="my_input my-block w-num" name="totle_semester" value=""></td>
          <td>开课学期序号：</td>
          <td><input class="my_input my-block" name="startnum" value=""></td>
        </tr>

        <tr>
          <td>学时分配：</td>
          <td colspan="2" class="my-center">总学时</td>
          <td class="my-center">讲课</td>
          <td colspan="2" class="my-center">其中实验</td>
          <td colspan="2" class="my-center">其中上机</td>
          <td class="my-center">实践学时/周数</td>          
        </tr>

        <tr>
          <td>总学时：</td>
          <td colspan="2"><input class="my_input my-block w-num" name="total_classes" value=""></td>
          <td><input class="my_input my-block w-num" name="lecture_hours" value=""></td>
          <td colspan="2"><input class="my_input my-block w-num" name="amongshiyan" value=""></td>
          <td><input class="my_input my-block w-num" name="amongshangji" value=""></td>
          <td class="my-center" colspan="2"><input class="my_input w-num" name="practice_time" value="">
            <select width="100%" name="practice_state">
              <option value ="1" >周数</option>
              <option value ="2" >学时</option>
            </select>
          </td>          
        </tr>

        <tr>
          <td>本学期学时：</td>
          <td colspan="2"><input class="my_input my-block w-num" name="semester_hours" value=""></td>
          <td><input class="my_input my-block w-num" name="semester_jiangke" value=""></td>
          <td colspan="2"><input class="my_input my-block w-num" name="semester_amongshiyan" value=""></td>
          <td><input class="my_input my-block w-num" name="semester_amongshangji" value=""></td>
          <td class="my-center" colspan="2"><input class="my_input w-num" name="semester_practice_time" value="">
            <select width="100%" name="semester_practice_state">
              <option value ="1" >周数</option>
              <option value ="2" >学时</option>
            </select>
          </td>          
        </tr>

        <tr>
          <td>合班情况：</td>
          <td colspan="8">
          
          
          </td>  
        </tr>

        <tr>
           <td>需特殊教学区：</td>
           <td colspan="2">
              <select width="100%" name="teaching_area_id">
              	<option value="0">无</option>
              	<%
              		String teaching_area_sql = "select id,teaching_area_name from teaching_area";
              		ResultSet teaching_area_set = db.executeQuery(teaching_area_sql);
              		while(teaching_area_set.next()){
              	%>
      				<option value ="<%=teaching_area_set.getString("id")%>" ><%=teaching_area_set.getString("teaching_area_name")%></option>
              	<%}if(teaching_area_set!=null){teaching_area_set.close();} %>
              </select>
            </td>
           <td>需特殊实验区</td>
           <td colspan="3">
            <select width="100%" name="experiment_area_id">
            	<option value="0">无</option>
              <%
              		String teaching_area_sql1 = "select id,teaching_area_name from teaching_area";
              		ResultSet teaching_area_set1 = db.executeQuery(teaching_area_sql);
              		while(teaching_area_set1.next()){
              	%>
         			<option value ="<%=teaching_area_set1.getString("id")%>" ><%=teaching_area_set1.getString("teaching_area_name")%></option>
              	<%}if(teaching_area_set1!=null){teaching_area_set1.close();} %>
            </select>
            </td>
            <td>性别要求：</td>
            <td>
              <select width="100%" name="sex_ask">
                <option value ="0" >无</option>
                <option value ="1" >男</option>
                <option value ="2" >女</option>
              </select>
            </td>
        </tr>

        <tr>
           <td><button class="mybtn">默认值</button></td>
           <td colspan="3">
              上课人数：<input class="my_input w-num" name="classes_number" value="">
              排课人数：<input class="my_input w-num" name="course_number" value="">
           </td>
           <td colspan="5"><button class="mybtn" onclick="" lay-submit lay-filter="*">保存</button></td>
        </tr>
        </tbody>
    </table>
  </div>
</div>
</form>
</body>

</html>


<%
	if("add".equals(ac)){
		//接受信息
		String teacher_id = request.getParameter("teacher_id");
		String semester = request.getParameter("semester");				//学期学号
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
		String dict_departments_id = request.getParameter("dict_departments_id");
		String course_id = request.getParameter("course_id");
		String major_id = request.getParameter("major_id");
		
		
		String [] couStrings = course_id.split("\\|");
		String course_id_new = couStrings[0];
		
		
		String teaching_plan_id = request.getParameter("teaching_task_classid");
		
		
		String sqlsql = "SELECT 	id, 				"+
			"				school_year,                "+
			"	             class_grade_id                           "+
			"				FROM                        "+
			"				teaching_task_class         "+
			"				WHERE teaching_plan_class_id = '"+teaching_plan_id+"';";
		
		
		ResultSet setset = db.executeQuery(sqlsql);
		
		boolean state = true;
		
		while(setset.next()){
			String insert_sql = "INSERT INTO teaching_task 		"+
			"		(                                                        "+
			"		teaching_task_class_id,                                     "+
			"		semester,                                                   "+
			"		course_id,                                                  "+
			"		major_id,                                                   "+
			"		dict_departments_id,                                        "+
			"		class_id,                                                   "+
			"		classes_weekly,                                             "+
			"		start_semester,                                             "+
			"		school_year,                                                "+
			"		teaching_research_number,                                   "+
			"		course_category_id,                                         "+
			"		course_nature_id,                                           "+
			"		is_merge_class,                                             "+
			"		marge_state,                                                "+
			"		marge_class_id,                                             "+
			"		merge_number,                                               "+
			"		typestate,                                                  "+
			"		union_class_code,                                           "+
			"		character_selection,                                        "+
			"		practice_weeks,                                             "+
			"		assessment_id,                                              "+
			"		assessment_category_id,                                     "+
			"		class_begins_weeks,                                         "+
			"		experiment_weeks,                                           "+
			"		week_learn_time,                                            "+
			"		experiment,                                                 "+
			"		computer_weeks,                                             "+
			"		computer_week_time,                                         "+
			"		credits,                                                    "+
			"		credits_term,                                               "+
			"		totle_semester,                                             "+
			"		startnum,                                                   "+
			"		total_classes,                                              "+
			"		lecture_hours,                                              "+
			"		amongshiyan,                                                "+
			"		amongshangji,                                               "+
			"		practice_time,                                              "+
			"		practice_state,                                             "+
			"		semester_hours,                                             "+
			"		semester_jiangke,                                           "+
			"		semester_amongshiyan,                                       "+
			"		semester_amongshangji,                                      "+
			"		semester_practice_state,                                    "+
			"		teaching_area_id,                                           "+
			"		experiment_area_id,                                         "+
			"		sex_ask,                                                    "+
			"		classes_number,                                             "+
			"		course_number,                                              "+
			"		semester_practice_time                                      "+
			"		)                                                           "+
			"		VALUES (                                                     "+
			"		'"+setset.getString("id")+"',                                   "+
			"		'"+semester+"',                                                 "+
			"		'"+course_id_new+"',                                                "+
			"		'"+major_id+"',                                                 "+
			"		'"+dict_departments_id+"',                                      "+
			"		'"+setset.getString("class_grade_id")+"',                                                 "+
			"		'"+classes_weekly+"',                                           "+
			"		'"+start_semester+"',                                           "+
			"		'"+setset.getString("school_year")+"',                                              "+
			"		'"+teaching_research_number_new+"',                                 "+
			"		'"+course_category_id+"',                                       "+
			"		'"+course_nature_id+"',                                         "+
			"		'0',                                           "+
			"		'0',                                              "+
			"		'0',                                           "+
			"		'0',                                             "+
			"		'1',                                                "+
			"		'"+union_class_code+"',                                         "+
			"		'"+character_selection+"',                                      "+
			"		'"+practice_weeks+"',                                           "+
			"		'"+assessment_id+"',                                            "+
			"		'"+assessment_category_id+"',                                   "+
			"		'"+class_begins_weeks+"',                                       "+
			"		'"+experiment_weeks+"',                                         "+
			"		'"+week_learn_time+"',                                          "+
			"		'"+experiment+"',                                               "+
			"		'"+computer_weeks+"',                                           "+
			"		'"+computer_week_time+"',                                       "+
			"		'"+credits+"',                                                  "+
			"		'"+credits_term+"',                                             "+
			"		'"+totle_semester+"',                                           "+
			"		'"+startnum+"',                                                 "+
			"		'"+total_classes+"',                                            "+
			"		'"+lecture_hours+"',                                            "+
			"		'"+amongshiyan+"',                                              "+
			"		'"+amongshangji+"',                                             "+
			"		'"+practice_time+"',                                            "+
			"		'"+practice_state+"',                                           "+
			"		'"+semester_hours+"',                                           "+
			"		'"+semester_jiangke+"',                                         "+
			"		'"+semester_amongshiyan+"',                                     "+
			"		'"+semester_amongshangji+"',                                    "+
			"		'"+semester_practice_state+"',                                  "+
			"		'"+teaching_area_id+"',                                         "+
			"		'"+experiment_area_id+"',                                       "+
			"		'"+sex_ask+"',                                                  "+
			"		'"+classes_number+"',                                           "+
			"		'"+course_number+"',                                            "+
			"		'"+semester_practice_time+"'  );                                  ";
			
			int pkid = db.executeUpdateRenum(insert_sql);
			
			if(pkid>0){
				//插入
				String insert_sql1 = "INSERT INTO teaching_task_teacher 		"+
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
							"		'"+pkid+"',                     "+
							"		'"+teacher_id+"',                            "+
							"		'"+class_begins_weeks+"',                   "+
							"		'"+start_semester+"',                   "+
							"		'1',                              "+
							"		'1'                                 "+
							"		);";
				state = db.executeUpdate(insert_sql1);
				if(!state){
					state = false;
					break;
				}
			}
		}if(setset!=null){setset.close();}
		
		
			if(state){
				out.println("<script>parent.layer.msg('添加教师信息 成功', {icon:1,time:1000,offset:'150px'},function(){var index = parent.layer.getFrameIndex(window.name); parent.layer.close(index);parent.document.getElementById(\"w_button\").click(); }) </script>");
			}else{
				out.println("<script>parent.layer.msg('添加教师信息 失败', {icon:2,time:1000,offset:'150px'},function(){var index = parent.layer.getFrameIndex(window.name);parent.layer.close(index);})</script>");
			}
		
		
		
		
		
	}



%>



<% if(db!=null)db.close();db=null;if(server!=null)server=null;%>