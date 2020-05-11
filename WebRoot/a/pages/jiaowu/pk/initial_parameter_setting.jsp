<%@ page trimDirectiveWhitespaces="true" %>
<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@ include file="../../cookie.jsp"%>


<%
	String semester_base = request.getParameter("semester_base");
	if(semester_base==null){
		
		String sql_sem = "select academic_year from academic_year where this_academic_tag = 'true' ";
		ResultSet semSet = db.executeQuery(sql_sem);
		while(semSet.next()){
			semester_base = semSet.getString("academic_year");
		}if(semSet!=null){semSet.close();}
	}
	String sel_sql = "SELECT 	id, 							"+
			"		school_number,                              "+
			"		course_class,                               "+
			"		course_mode,                                "+
			"		class_begins,                               "+
			"		noclass_begins,                             "+
			"		stadium_num,                                "+
			"		class_control,                              "+
			"		teacher_control,                            "+
			"		fixed_classroom,                            "+
			"		classroom1,                                 "+
			"		classroom2,                                 "+
			"		lecturestate,                               "+
			"		experimentlecture,                          "+
			"		appointteacher,                             "+
			"		identicalclass,                             "+
			"		no_class,                                   "+
			"		notsameday,                                 "+
			"		querynum,									"+
			"		print_state ,                                "+
			"		print_state1,								"+
			"		print_state2									"+
			"		FROM                                        "+
			"		arrage_course                "+
			"		where school_number = '"+semester_base+"' ; ";
	System.out.println(sel_sql);
	ResultSet sel_set = db.executeQuery(sel_sql);
	String id_base = "";
	String school_number_base = "";
	String course_class_base = "";
	String course_mode_base = "";
	String class_begins_base = "";
	String stadium_num_base = "";
	String class_control_base = "";
	String teacher_control_base = "";
	String fixed_classroom_base = "";
	String classroom1_base = "";
	String classroom2_base = "";
	String lecturestate_base = "";
	String experimentlecture_base = "";
	String appointteacher_base = "";
	String identicalclass_base = "";
	String no_class_base = "";
	String notsameday_base = "";
	String print_state_base = "";
	String querynum = "";
	String print_state1 = "";
	String print_state2 = "";
	
	
	while(sel_set.next()){
		id_base = sel_set.getString("id");
		course_class_base = sel_set.getString("course_class");
		course_mode_base = sel_set.getString("course_mode");
		class_begins_base = sel_set.getString("class_begins");
		stadium_num_base = sel_set.getString("stadium_num");
		class_control_base = sel_set.getString("class_control");
		teacher_control_base = sel_set.getString("teacher_control");
		fixed_classroom_base = sel_set.getString("fixed_classroom");
		classroom1_base = sel_set.getString("classroom1");
		classroom2_base = sel_set.getString("classroom2");
		lecturestate_base = sel_set.getString("lecturestate");
		experimentlecture_base = sel_set.getString("experimentlecture");
		appointteacher_base = sel_set.getString("appointteacher");
		identicalclass_base = sel_set.getString("identicalclass");
		no_class_base = sel_set.getString("no_class");
		notsameday_base = sel_set.getString("notsameday");
		print_state_base = sel_set.getString("print_state");
		querynum = sel_set.getString("querynum");
		print_state1 = sel_set.getString("print_state1");
		print_state2 = sel_set.getString("print_state2");
	}if(sel_set!=null){sel_set.close();}


%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <title></title>
  <meta name="renderer" content="webkit">
  <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
  <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
  <meta name="apple-mobile-web-app-status-bar-style" content="black"> 
  <meta name="apple-mobile-web-app-capable" content="yes">
  <meta name="format-detection" content="telephone=no">

   <link rel="stylesheet" href="../../../pages/css/sy_style.css">	    
   <link rel="stylesheet" href="../../js/layui2/css/layui.css">
	<script type="text/javascript" src="../../js/jquery-1.9.1.js" ></script><!--通用jquery-->
	<script src="../../js/layui2/layui.js"></script>

<style>
body{padding: 10px;}
#box{width: 900px;margin: 0 auto;}
.b_left{width: 56%;float: left;margin-right: 2%;}
.b_right{width: 42%;float: right;}
.res{height: 317px;}
.techer{border: 1px #E6E6E6 solid;padding: 15px 8px;
margin:0 20px 30px 20px;height: 200px;overflow-y: scroll;}
.layui-btn{background: none;border: 1px #e6e6e6 solid;color: #000000;}
.layui-btn:hover{color: #000000;}
.layui-form-label{text-align: left;width: 130px;}
.b_right .layui-input-block{margin-left: 110px;}
.layui-field-box {padding: 10px 0px;}
.layui-input-block {margin-left: 160px;}
.layui-btn-primary:hover{border-color: #e6e6e6}
.lever{width: 800px;margin: 0 auto;}
</style>
</head>
<body>
	
<div id="box">
	<blockquote class="layui-elem-quote" style="padding: 5px">初始化数据</blockquote>
		<div class="layui-field-box">
		    <form class="layui-form" action="?ac=add" method="post">
		    	<input type="hidden" name="id_base" value="<%=id_base%>" />
		    	<div class="b_left">
		    		  <div class="layui-form-item">
				      <label class="layui-form-label">排课类别</label>
				      <div class="layui-input-block">
				        <select lay-verify="required" name="course_class" lay-verType="tips">
				          <option value="">请选择</option>
				          <option value="1" <%if("1".equals(course_class_base)){out.println("selected='selected'");} %> selected="selected">教务处排课</option>
				          <option value="2" <%if("2".equals(course_class_base)){out.println("selected='selected'");} %>>教务处教务科排课</option>
				          <option value="3" <%if("3".equals(course_class_base)){out.println("selected='selected'");} %>>教务处体制改革</option>
				        </select>
				      </div>
				  </div>
				  <div class="layui-form-item">
				      <label class="layui-form-label">学年学期号</label>
				      <div class="layui-input-block">
				        <select name="school_number" id="school_number"  lay-filter="test" lay-verify="required" lay-verType="tips">
				          <%
				          	String sql_sem = "select academic_year from academic_year";
				          	ResultSet set = db.executeQuery(sql_sem);
				          	while(set.next()){
				          
				          %>
				          	<option value="<%=set.getString("academic_year")%>" <%if(school_number_base.equals(set.getString("academic_year"))||semester_base.equals(set.getString("academic_year"))){out.println("selected='selected'");} %>><%=set.getString("academic_year")%></option>
				          <%}if(set!=null){set.close();} %>
				          
				        </select>
				      </div>
				  </div>
			
				  <div class="layui-form-item">
				    <label class="layui-form-label">排课方式</label>
				    <div class="layui-input-block">
				      <input type="radio" name="course_mode" value="5" <%if("5".equals(course_mode_base)){out.println("checked='checked'");} %>  title="五天制">
				      <input type="radio" name="course_mode" value="6" <%if("6".equals(course_mode_base)){out.println("checked='checked'");} %>  title="六天制" >
				      <input type="radio" name="course_mode" value="7" <%if("7".equals(course_mode_base)){out.println("checked='checked'");} %> title="七天制" >
				    </div>
				  </div>

				  <div class="layui-form-item">
				    <label class="layui-form-label">缺省上课周次</label>
				    <div class="layui-input-block">
				      <input type="text" name="class_begins" value="<%=class_begins_base %>" class="layui-input">
				    </div>
				  </div>
				  <div class="layui-form-item">
				    <label class="layui-form-label">其中不上课周次</label>
				    <div class="layui-input-block">
				      <input type="text" name="noclass_begins" value="<%=no_class_base %>"  class="layui-input">
				    </div>
				  </div>
				  <div class="layui-form-item">
				    <label class="layui-form-label">体育场容纳班级数</label>
				    <div class="layui-input-block">
				      <input type="text" name="stadium_num" value="<%=stadium_num_base %>" class="layui-input">
				    </div>
				  </div>

				  <div class="layui-form-item">
				      <label class="layui-form-label">班级上课地点控制</label>
				      <div class="layui-input-block">
				        <select name="class_control" lay-verify="required" lay-verType="tips">
				          <option value="1" <%if("1".equals(class_control_base)){out.println("selected='selected'");} %>>本分校班级只能安排在本分校上课</option>
				          <option value="2" <%if("2".equals(class_control_base)){out.println("selected='selected'");} %>>本分校班级尽量安排在本分校上课</option>
				          <option value="3" <%if("3".equals(class_control_base)){out.println("selected='selected'");} %>>任意安排班级上课地点</option>
				        </select>
				      </div>
				  </div>
				  <div class="layui-form-item">
				      <label class="layui-form-label">教师上课地点控制</label>
				      <div class="layui-input-block">
				        <select name="teacher_control" lay-verify="required" lay-verType="tips">
				          <option value="1" <%if("1".equals(teacher_control_base)){out.println("selected='selected'");} %>>同一天不能安排在多个分校上课</option>
				          <option value="2" <%if("2".equals(teacher_control_base)){out.println("selected='selected'");} %>>上午或下午不能安排在多个分校上课</option>
				          <option value="3" <%if("3".equals(teacher_control_base)){out.println("selected='selected'");} %>>任意安排教师上课地点</option>
				        </select>
				      </div>
				  </div>
				  <div class="layui-form-item">
				      <label class="layui-form-label">固定教室控制</label>
				      <div class="layui-input-block">
				        <select name="fixed_classroom" lay-verify="required" lay-verType="tips">
				          <option value="1" <%if("1".equals(fixed_classroom_base)){out.println("selected='selected'");} %>>启用班级固定教学功能区及教室排课</option>
				          <option value="2" <%if("2".equals(fixed_classroom_base)){out.println("selected='selected'");} %>>不启用班级固定教学功能区及教室排课</option>
				        </select>
				      </div>
				  </div>
				  <div class="layui-form-item">
				      <label class="layui-form-label">指定/固定教室检查</label>
				      <div class="layui-input-block">
				        <select name="classroom1" lay-verify="required" lay-verType="tips">
				          <option value="1" <%if("1".equals(classroom1_base)){out.println("selected='selected'");} %>>容纳人数不足-->漏课</option>
				          <option value="2" <%if("2".equals(classroom1_base)){out.println("selected='selected'");} %>>容纳人数不足-->忽略</option>
				        </select>
				      </div>
				  </div>
				  <div class="layui-form-item">
				      <label class="layui-form-label">指定/固定教室检查</label>
				      <div class="layui-input-block">
				        <select name="classroom2" lay-verify="required" lay-verType="tips">
				          <option value="1" <%if("1".equals(classroom2_base)){out.println("selected='selected'");} %>>教室状态不可用-->漏课</option>
				          <option value="2" <%if("2".equals(classroom2_base)){out.println("selected='selected'");} %>>教室状态不可用-->忽略</option>
				        </select>
				      </div>
				  </div>
				  <div class="layui-form-item">
				      <label class="layui-form-label">漏课查询次数</label>
				      <div class="layui-input-block">
				        <input type="text" name="querynum" value="<%=querynum %>" class="layui-input" lay-verify="required">
				      </div>
				  </div>
			    </div>

			    <div class="b_right">
			    	<div class="layui-form-item">
					    <div class="layui-input-block">
					      <a id="paike1" class="layui-btn layui-btn-primary">排课时间设置</a>
					    </div>
					</div>
					<div class="layui-form-item">
					    <div class="layui-input-block">
					      <a id="paike2" class="layui-btn layui-btn-primary">排课顺序设置</a>
					    </div>
					</div>
					<div class="layui-form-item">
					    <div class="layui-input-block">
					      <a id="paike3" class="layui-btn layui-btn-primary">班级时间设置</a>
					    </div>
					</div>
					<div class="layui-form-item">
					    <div class="layui-input-block">
					      <a id="paike4" class="layui-btn layui-btn-primary">教室时间设置</a>
					    </div>
					</div>
					<div class="layui-form-item">
					    <div class="layui-input-block">
					      <a id="paike5" class="layui-btn layui-btn-primary">教师时间设置</a>
					    </div>
					</div>
					<div class="layui-form-item">
					    <div class="layui-input-block">
					      <a id="paike6" class="layui-btn layui-btn-primary">部门时间设置</a>
					    </div>
					</div>
			    	<div class="layui-form-item" pane>
					    <div class="layui-input-block">
					      <input type="checkbox" name="lecturestate" value="1" <%if("1".equals(lecturestate_base)){out.println("checked='checked'");} %> lay-skin="primary" title="讲课或实验部分必须隔天安排">
					      <input type="checkbox" name="experimentlecture" value="1" <%if("1".equals(experimentlecture_base)){out.println("checked='checked'");} %> lay-skin="primary" title="允许讲课和实验同一天排课">
					      <input type="checkbox" name="appointteacher" value="1" <%if("1".equals(appointteacher_base)){out.println("checked='checked'");} %> lay-skin="primary" title="指定教师连续集中排课">
					      <input type="checkbox" name="identicalclass" value="1" <%if("1".equals(identicalclass_base)){out.println("checked='checked'");} %> lay-skin="primary" title="同一个班的相同课程安排同一教室">
					      <input type="checkbox" name="no_class" value="1" <%if("1".equals(no_class_base)){out.println("checked='checked'");} %> lay-skin="primary" title="如果5,6节为体育课则7,8节不排课">
					      <input type="checkbox" name="notsameday" value="1" <%if("1".equals(notsameday_base)){out.println("checked='checked'");} %> lay-skin="primary" title="讲课或实验不能同一天排课">
					    </div>
					</div>
    			</div>
				<div class="lever">
					<div class="layui-form-item" pane>
					    <div class="layui-input-block">
					      <input type="checkbox" name="print_state" value="1" <%if("1".equals(print_state_base)){out.println("checked='checked'");} %> lay-skin="primary" title="教师/学生可查询课表">
					      <input type="checkbox" name="print_state1" value="1" <%if("1".equals(print_state1)){out.println("checked='checked'");} %> lay-skin="primary" title="教师/学生可打印课表">
					      <input type="checkbox" name="print_state2" value="1" <%if("1".equals(print_state2)){out.println("checked='checked'");} %> lay-skin="primary" title="启用调课日志记录">
					    </div>
					</div>		
					<div class="layui-form-item">
					    <div class="layui-input-block"  style="margin-left: 10px">
						    <button lay-submit lay-filter="*" class="layui-btn"  style="margin-right: 18%;">保存参数</button>
						    <a class="layui-btn layui-btn-primary">排课类别设置</a>
					    </div>
					</div>					
				</div>  
			</form>
	     </div>
</div>

<br><br><br>

<script>

layui.use(['form','layer','jquery'], function(){
   var form = layui.form;
   var layer = layui.layer;
   var $ = layui.jquery;

   $('#paike1').click(function(event) {
	   var semester = $('#school_number').val();
	   if(semester==''){
			layer.msg("请选择学期");
		   return false;}
		layer.open({
			  type: 2,
			  title: '排课时间设置',
			  maxmin:1,
			  offset: 't',
			  area: ['100%', '600px'],
			  content: 'initial_setting/timetable_setting.jsp?semester='+semester
			});
   });
   $('#paike2').click(function(event) {
	   var semester = $('#school_number').val();
	   if(semester==''){
			layer.msg("请选择学期");
		   return false;}
		layer.open({
			  type: 2,
			  title: '排课顺序设置',
			  maxmin:1,
			  offset: 't',
			  area: ['100%', '600px'],
			  content: 'initial_setting/sequence_setting.jsp?semester='+semester
			});
   });
   $('#paike3').click(function(event) {
	   var semester = $('#school_number').val();
	   if(semester==''){
			layer.msg("请选择学期");
		   return false;}
		layer.open({
			  type: 2,
			  title: '班级时间设置',
			  maxmin:1,
			  offset: 't',
			  area: ['100%', '600px'],
			  content: 'initial_setting/class_time_setting.jsp?semester='+semester
			});
   });
   $('#paike4').click(function(event) {
	   var semester = $('#school_number').val();
	   if(semester==''){
			layer.msg("请选择学期");
		   return false;}
		layer.open({
			  type: 2,
			  title: '教室时间设置',
			  maxmin:1,
			  offset: 't',
			  area: ['100%', '600px'],
			  content: 'initial_setting/class_room_setting.jsp?semester='+semester
			});
   });
   $('#paike5').click(function(event) {
	   var semester = $('#school_number').val();
	   if(semester==''){
			layer.msg("请选择学期");
		   return false;}
	   if(semester==''){
			layer.msg("请选择学期");
		   return false;}
		layer.open({
			  type: 2,
			  title: '教师时间设置',
			  maxmin:1,
			  offset: 't',
			  area: ['100%', '600px'],
			  content: 'initial_setting/class_teacher_setting.jsp?semester='+semester
			});
   });
   $('#paike6').click(function(event) {
	   var semester = $('#school_number').val();
	   if(semester==''){
			layer.msg("请选择学期");
		   return false;}
		layer.open({
			  type: 2,
			  title: '部门时间设置',
			  maxmin:1,
			  offset: 't',
			  area: ['100%', '600px'],
			  content: 'initial_setting/dep_time_setting.jsp?semester='+semester
			});
   });

   //自定义验证规则
   form.verify({
     title: function(value){
      if(value.length < 5){
        return '标题也太短了吧';
      }
     }
     ,pass: [/(.+){6,12}$/, '密码必须6到12位']
   });
  
   //监听提交
   form.on('submit(*)', function(data){
     return true;
   });
   //监听下拉 选择学年学期
   form.on('select(test)', function(data){
	   window.location.href="?ac=&semester_base="+data.value+"";
   }); 
  
});

</script>


</body>
</html>


<%
	if("add".equals(ac)){
		
		String id_base_new = request.getParameter("id_base");
		String school_number = request.getParameter("school_number");
		String course_class = request.getParameter("course_class");
		String course_mode = request.getParameter("course_mode");
		String class_begins = request.getParameter("class_begins");
		String noclass_begins = request.getParameter("noclass_begins");
		String stadium_num = request.getParameter("stadium_num");
		String class_control = request.getParameter("class_control");
		String teacher_control = request.getParameter("teacher_control");
		String fixed_classroom = request.getParameter("fixed_classroom");
		String classroom1 = request.getParameter("classroom1");
		String classroom2 = request.getParameter("classroom2");
		String print_state = request.getParameter("print_state");
		String lecturestate = request.getParameter("lecturestate");	if(lecturestate==null){lecturestate="0";}
		String experimentlecture = request.getParameter("experimentlecture");if(experimentlecture==null){experimentlecture="0";}
		String appointteacher = request.getParameter("appointteacher");if(appointteacher==null){appointteacher="0";}
		String identicalclass = request.getParameter("identicalclass");if(identicalclass==null){identicalclass="0";}
		String no_class = request.getParameter("no_class");if(no_class==null){no_class="0";}
		String notsameday = request.getParameter("notsameday");if(notsameday==null){notsameday="0";}
		String querynum_new = request.getParameter("querynum");if(querynum_new==null){querynum_new="0";}
		String print_state1_new = request.getParameter("print_state1");if(print_state1_new==null){print_state1_new="0";}
		String print_state2_new = request.getParameter("print_state2");if(print_state2_new==null){print_state2_new="0";}
		
		if("".equals(stadium_num)){
			stadium_num = "0";
		}
		
		if("".equals(course_mode)){
			course_mode = "6";
		}
		
		if(print_state==null){
			print_state = "0";
		}
		if(print_state1==null){
			print_state1 = "0";
		}
		if(print_state2==null){
			print_state2 = "0";
		}
		
		
		boolean state = true;	
		
		if("".equals(id_base_new)){
			String insert_sql = "INSERT INTO arrage_course 		"+
			"	(	                                    "+
			"	school_number,                          "+
			"	course_class,                           "+
			"	course_mode,                            "+
			"	class_begins,                           "+
			"	noclass_begins,                         "+
			"	stadium_num,                            "+
			"	class_control,                          "+
			"	teacher_control,                        "+
			"	fixed_classroom,                        "+
			"	classroom1,                             "+
			"	classroom2,                             "+
			"	lecturestate,                           "+
			"	experimentlecture,                      "+
			"	appointteacher,                         "+
			"	identicalclass,                         "+
			"	no_class,                               "+
			"	notsameday,                             "+
			"	print_state,                             "+
			"	querynum,								"+
			"	print_state1,							"+
			"	print_state2							"+
			"	)                                       "+
			"	VALUES                                  "+
			"	(		                                "+
			"	'"+school_number+"',                        "+
			"	'"+course_class+"',                         "+
			"	'"+course_mode+"',                          "+
			"	'"+class_begins+"',                         "+
			"	'"+noclass_begins+"',                       "+
			"	'"+stadium_num+"',                          "+
			"	'"+class_control+"',                        "+
			"	'"+teacher_control+"',                      "+
			"	'"+fixed_classroom+"',                      "+
			"	'"+classroom1+"',                           "+
			"	'"+classroom2+"',                           "+
			"	'"+lecturestate+"',                         "+
			"	'"+experimentlecture+"',                    "+
			"	'"+appointteacher+"',                       "+
			"	'"+identicalclass+"',                       "+
			"	'"+no_class+"',                             "+
			"	'"+notsameday+"',                           "+
			"	'"+print_state+"',                           "+
			"	'"+querynum_new+"',							"+
			"	'"+print_state1_new+"',							"+
			"	'"+print_state2_new+"'							"+
			"	);";
	
			state = db.executeUpdate(insert_sql);
		}else{
			String update_sql = "UPDATE arrage_course 							"+
			"				SET                                                 "+
			"				school_number = '"+school_number+"' ,               "+
			"				course_class = '"+course_class+"' ,                 "+
			"				course_mode = '"+course_mode+"' ,                       "+
			"				class_begins = '"+class_begins+"' ,                     "+
			"				noclass_begins = '"+noclass_begins+"' ,                 "+
			"				stadium_num = '"+stadium_num+"' ,                       "+
			"				class_control = '"+class_control+"' ,                   "+
			"				teacher_control = '"+teacher_control+"' ,               "+
			"				fixed_classroom = '"+fixed_classroom+"' ,               "+
			"				classroom1 = '"+classroom1+"' ,                         "+
			"				classroom2 = '"+classroom2+"' ,                         "+
			"				lecturestate = '"+lecturestate+"' ,                     "+
			"				experimentlecture = '"+experimentlecture+"' ,           "+
			"				appointteacher = '"+appointteacher+"' ,                 "+
			"				identicalclass = '"+identicalclass+"' ,                 "+
			"				no_class = '"+no_class+"' ,                             "+
			"				notsameday = '"+notsameday+"' ,                         "+
			"				print_state = '"+print_state+"',                         "+
			"				querynum = '"+querynum_new+"',							"+
			"				print_state1 = '"+print_state1_new+"',						"+
			"				print_state2 = '"+print_state2_new+"'						"+
			"				WHERE                                               "+
			"				id = '"+id_base_new+"' ;";
			
			System.out.println("update_sql==="+update_sql);
			state = db.executeUpdate(update_sql);
		}
		
		
		
			
			if(state){
				out.println("<script>parent.layer.msg('设置 成功', {icon:1,time:1000,offset:'150px'},function(){}); </script>");
			}else{
				out.println("<script>parent.layer.msg('设置 失败');</script>");
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
if(db!=null)db.close();db=null;if(server!=null)server=null;%>