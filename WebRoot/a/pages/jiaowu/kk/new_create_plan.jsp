<%@ page trimDirectiveWhitespaces="true" %>
<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@page import="service.dao.db.Page"%>
<%@page import="v1.haocheok.commom.commonCourse"%>
<%@include file="../../cookie.jsp"%>
<%@page import="service.dao.db.Page"%>
<%@page import="v1.haocheok.commom.common"%>
<%@page import="v1.haocheok.commom.entity.UserEntity"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>

<%
	common common = new common();
	String departments_id = request.getParameter("departments_id");
	if (departments_id == null) {
		departments_id = "0";
	}
	String major_id = request.getParameter("major_id");
	if (major_id == null) {
		major_id = "0";
	}
	String school_year = request.getParameter("school_year");
	if (school_year == null) {
		school_year = "0";
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
		<title>生成任务书</title> 
	    <style type="text/css">
			.inline{ position: relative; display: inline-block; margin-right: 10px; }
	    </style>
	</head>
	<body>
		<div style="margin: 15px;">
			<fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
				<legend>生成任务书</legend>
			</fieldset>
			<form class="layui-form" action="new_create_plan.jsp?ac=add" method="post" >
			   
				<div class="layui-form-item inline" style="width: 40%">
					<label class="layui-form-label" style=" width: 30%">院系</label>
					
					<div class="layui-input-inline">
						<select id="depth" name="departments_id" class="layui-input" lay-filter="depth">
						  <option value="0" >请选择院系</option> 
                            <%
                             	//查询状态
                             	ResultSet stateRs = db
                             			.executeQuery("SELECT DISTINCT dict_departments_id FROM  teaching_plan_class WHERE state_approve_id=7;");
                             	while (stateRs.next()) {
                             %>
                             <option value="<%=stateRs.getString("dict_departments_id")%>" <%if (stateRs.getString("dict_departments_id").equals(
						departments_id)) {
					out.print("selected=\"selected\"");
				}%>><%=common.idToFieidName("dict_departments",
						"departments_name", stateRs
								.getString("dict_departments_id"))%></option>
                           <%
                           	}
                           	if (stateRs != null) {
                           		stateRs.close();
                           	}
                           %>
                        </select> 
					</div>
				</div>
<!--		    <input type="hidden" name="usernameid" lay-verify="nickname" autocomplete="off" class="layui-input" value="">-->
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">专业</label>
					<div class="layui-input-inline">
						<select id="major_id" name="major_id" class="layui-input" placeholder="专业" lay-filter="major_id"> 
						<option value="0" >请选择专业</option> 
                           <%
                            	//查询状态
                            	ResultSet Rs = db
                            			.executeQuery("SELECT DISTINCT major_id FROM  teaching_plan_class  WHERE state_approve_id=7 AND dict_departments_id="
                            					+ departments_id + ";");
                            	while (Rs.next()) {
                            %>
                          <option value="<%=Rs.getString("major_id")%>" <%if (Rs.getString("major_id").equals(major_id)) {
					out.print("selected=\"selected\"");
				}%>><%=common.idToFieidName("major", "major_name", Rs
						.getString("major_id"))%></option>
                           <%
                           	}
                           	if (Rs != null) {
                           		Rs.close();
                           	}
                           %>
                        </select> 
					</div>
				</div>
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">入学年份</label>
					<div class="layui-input-inline">
						<select  name="school_year" class="layui-input" placeholder="入学年份" lay-filter="school_year">  
						<option value="0" >请选择入学年份</option>                  
                           <%
                                             	ResultSet rxRs = db
                                             			.executeQuery("SELECT DISTINCT school_year FROM  teaching_plan_class  WHERE state_approve_id=7 AND major_id="
                                             					+ major_id + ";");
                                             	while (rxRs.next()) {
                                             %>
                          <option value="<%=rxRs.getString("school_year")%>" <%if (rxRs.getString("school_year").equals(school_year)) {
					out.print("selected=\"selected\"");
				}%>><%=rxRs.getString("school_year")%></option>
                           <%
                           	}
                           	if (rxRs != null) {
                           		rxRs.close();
                           	}
                           %>
                           
                        </select> 
					</div>
				</div>
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">开课学期</label>
					<div class="layui-input-inline">
						<select  id="start_semester" name="start_semester" class="layui-input" placeholder="开课学期" lay-filter="start_semester">  
						 <option value="0" >请选择开课学期</option>                  
                         <%
                                           	//SQL语
                                           	//开始查询专业表
                                           	ResultSet xzRs = db
                                           			.executeQuery("select eductional_systme_id from major where id='"
                                           					+ major_id + "';");
                                           	//学制
                                           	int xz = 0;
                                           	while (xzRs.next()) {
                                           		xz = xzRs.getInt("eductional_systme_id");
                                           	}
                                           	if (xzRs != null) {
                                           		xzRs.close();
                                           	}
                                           	int start_semester = Integer.parseInt(school_year);

                                           	//学期号前一个数字
                                           	int q = 0;
                                           	//学期号后一个数字
                                           	int h = 0;
                                           	q = start_semester;
                                           	h = start_semester + 1;
                                           	//学期选项value值 
                                           	int value = 1;
                                           	for (int i = 1; i <= xz; i++) {
                                           		//学期
                                           		int xq = 1;
                                           		while (xq <= 2) {
                                           %>
                           <option value="<%=value%>"><%=q%>-<%=h%>-<%=xq%></option>
                             <%
                             	xq++;
                             			value++;
                             		}
                             		q++;
                             		h++;
                             	}
                             %>                           
                        </select> 
					</div>
					<input name="semester" id="semester" value="" type="hidden"/>
				</div>
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">实验处理</label>
					<div class="layui-input-inline">
						<select id="experimental_state" name="experimental_state" class="layui-input">
								<option value="1">不处理实验课</option>
<%--								<option value="2">处理实验课</option>--%>
						</select>
					</div>
				</div>	
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">任务书名</label>
					<div class="layui-input-inline">
						<input type="text" id="teaching_plan_name" name="author" class="layui-input" >
					</div>
				</div>	
				<div class="layui-form-item" style="margin-bottom:45px">
					<div class="layui-input-block"  style="margin-left:540px">			
						<button  class="layui-btn" >生成</button>
					</div>
				</div>
			</form>
		</div>
	
	</body>
</html>
<script>
//多级联动
	 var index = parent.layer.getFrameIndex(window.name);
	 layui.use('form', function() {
				layer = layui.layer,
				layedit = layui.layedit,
				laydate = layui.laydate;
				var form = layui.form;
				
				  form.on('select(depth)', function(data){				
					  window.location.href="?ac=&departments_id="+data.value;
					}); 
				  form.on('select(start_semester)', function(){			
					  var val = $("#start_semester").find("option:selected").text();	
					  $("#semester").val(val);
					}); 
				form.on('select(major_id)', function(data){
					  var departments_id=jQuery("#depth").val();					  
					  window.location.href="?ac=&major_id="+data.value+"&departments_id="+departments_id;
					}); 
				form.on('select(school_year)', function(data){
					  var departments_id=jQuery("#depth").val();
					  var major_id=jQuery("#major_id").val();					  
					  window.location.href="?ac=&school_year="+data.value+"&major_id="+major_id+"&departments_id="+departments_id;
					}); 
				})
</script>
<%
	if ("add".equals(ac)) {
		departments_id = request.getParameter("departments_id");
		major_id = request.getParameter("major_id");
		school_year = request.getParameter("school_year");
		String author = request.getParameter("author");
		String start_semesters = request.getParameter("start_semester");
		String semester = request.getParameter("semester");
		String experimental_state = request
				.getParameter("experimental_state");
		String teaching_plan_class_id = "0";
		String class_grade_id = "0";
		if (departments_id == null) {
			departments_id = "";
		}
		if (major_id == null) {
			major_id = "";
		}
		if (school_year == null) {
			school_year = "";
		}
		if (author == null) {
			author = "";
		}
		int pkId = 0;
		SimpleDateFormat df = new SimpleDateFormat(
				"yyyy-MM-dd HH:mm:ss");//设置日期格式

		//查询计划
		ResultSet jhRs = db.executeQuery("SELECT id FROM  teaching_plan_class WHERE dict_departments_id='"
						+ departments_id
						+ "' AND major_id='"
						+ major_id
						+ "' AND school_year='"
						+ school_year + "'  AND  state_approve_id=7;");
		while (jhRs.next()) {
			teaching_plan_class_id = jhRs.getString("id");
		}if (jhRs != null) {jhRs.close();}
		//查询班级
		ResultSet bjRs = db.executeQuery("SELECT id FROM  class_grade WHERE departments_id='"
						+ departments_id
						+ "' AND majors_id='"
						+ major_id
						+ "' AND school_year='"
						+ school_year + "';");

		int num = db.Row("SELECT count(1) as row FROM  class_grade WHERE departments_id='"
						+ departments_id
						+ "' AND majors_id='"
						+ major_id
						+ "' AND school_year='"
						+ school_year + "';");
		if (num > 0) {
				int upnum =0;
			while (bjRs.next()) {
				//获取班级id
				class_grade_id = bjRs.getString("id");
				String checkSql ="select count(id) row from teaching_task_class where dict_departments_id="+departments_id
												+ " AND major_id='"+ major_id
												+ "' AND school_year='"+school_year 
												+ "' AND start_semester='"+start_semesters 
												+ "' AND class_grade_id="+class_grade_id ;
				if(db.Row(checkSql)>0){
					continue;
				}
				upnum++;
				//插入数据
				//往生成任务书分类表添加数据
				try {
					String sql = "INSERT INTO teaching_task_class (`dict_departments_id`,`major_id`,`semester`,`addtime`,`add_worker_id`,`teaching_plan_class_id`,`class_grade_id`,`teaching_task_name`,`school_year`,`start_semester`,`experimental_state`)  VALUES ('"
							+ departments_id
							+ "','"
							+ major_id
							+ "','"
							+ semester
							+ "','"
							+ df.format(new Date())
							+ "','"
							+ Suid
							+ "','"
							+ teaching_plan_class_id
							+ "','"
							+ class_grade_id
							+ "','"
							+ author
							+ "','"
							+ school_year
							+ "','"
							+ start_semesters
							+ "','" + experimental_state + "')";
					//获取主键id
					pkId = db.executeUpdateRenum(sql);
					if (pkId > 0) {
						out
								.println("<script>parent.layer.msg('添加 任务成功');parent.layer.close(index);</script>");
					} else {
						out
								.println("<script>parent.layer.msg('添加 失败!请将信息填全');</script>");
					}
				} catch (Exception e) {
					out
							.println("<script>parent.layer.msg('添加 失败');</script>");
					return;
				}
				//往计划书里的数据复制到安排表
				try {
					String sql = "";
					boolean updateState = false;

					//不处理实验 experimental_state=1
					if (experimental_state.equals("1")) {//start_semesters
						sql = "insert into `teaching_task` (`teaching_task_class_id`,`semester`,`teaching_plan_class_id`,`course_id`, `major_id`, `dict_departments_id`, `classes_weekly`, `start_semester`, `responsibility`, `school_year`, `lecture_classes`, `teaching_research_number`, `course_category_id`, `course_nature_id`,  `extracurricular_practice_hour`,  `professional_direction_coding`, `check_semester`, `test_semester`, `class_in`,  `class_id`,`class_begins_weeks`,total_classes,credits_term,startnum) SELECT "
								+ pkId
								+ " as teaching_task_class_id ,'"
								+ semester
								+ "' as semester ,`teaching_plan_class_id`, `course_id`, `major_id`, `dict_departments_id`,  `classes_weekly"
								+ start_semesters
								+ "`, `start_semester"
								+ start_semesters
								+ "`, `responsibility`, `school_year`, `lecture_classes`, `teaching_research_number`, `course_category_id`, `course_nature_id`, `extracurricular_practice_hour`,  `professional_direction_coding`, `check_semester`, `test_semester`, `class_in`,   "
								+ class_grade_id
								+ " as `class_id`,(CASE weeks WHEN '' THEN CONCAT('1-',classes_weekly"+start_semesters+") ELSE weeks END) AS weeks,total_classes,credits,'"+start_semesters+"' FROM teaching_plan WHERE teaching_plan_class_id="
								+ teaching_plan_class_id
								+ " AND start_semester"
								+ start_semesters
								+ "!='0' AND LENGTH(start_semester"
								+ start_semesters + ")>0 	AND courserprocess = 0 ;";
						updateState = db.executeUpdate(sql);
					} else {
						sql = "insert into `teaching_task` (`teaching_task_class_id`,`semester`,`teaching_plan_class_id`,`course_id`, `major_id`, `dict_departments_id`, `classes_weekly`, `start_semester`, `responsibility`, `school_year`, `lecture_classes`, `teaching_research_number`, `course_category_id`, `course_nature_id`,  `extracurricular_practice_hour`,  `professional_direction_coding`, `check_semester`, `test_semester`, `class_in`,  `class_id`,`class_begins_weeks`,total_classes,credits_term,startnum) SELECT "
								+ pkId
								+ " as teaching_task_class_id ,'"
								+ semester
								+ "' as semester ,`teaching_plan_class_id`, `course_id`, `major_id`, `dict_departments_id`,  `classes_weekly"
								+ start_semesters
								+ "`, `start_semester"
								+ start_semesters
								+ "`, `responsibility`, `school_year`, `lecture_classes`, `teaching_research_number`, `course_category_id`, `course_nature_id`, 0 as  `extracurricular_practice_hour`,  `professional_direction_coding`, `check_semester`, `test_semester`, 0 as  `class_in`,   "
								+ class_grade_id
								+ " as `class_id`,(CASE weeks WHEN '' THEN CONCAT('1-',classes_weekly"+start_semesters+") ELSE weeks END) AS weeks,total_classes,credits,'"+start_semesters+"'  FROM teaching_plan WHERE teaching_plan_class_id="
								+ teaching_plan_class_id
								+ " AND start_semester"
								+ start_semesters
								+ "!='0' AND LENGTH(start_semester"
								+ start_semesters + ")>0	AND courserprocess = 0 ;";
						updateState = db.executeUpdate(sql);
					}
					//更新教学周次
					String sql_teaching_plan = "select id, class_begins_weeks,test_semester,check_semester,start_semester from teaching_task where teaching_task_class_id = '"+pkId+"' ";
					ResultSet teaching_task = db.executeQuery(sql_teaching_plan);
					
					while(teaching_task.next()){
						
						String class_begins_weeks = "";
						class_begins_weeks = teaching_task.getString("class_begins_weeks");
						String test_semester = teaching_task.getString("test_semester");		//考试学期
						String check_semester = teaching_task.getString("check_semester");		//考察学期
						int numm = commonCourse.setWeekly(class_begins_weeks).size();			//授课周次
						int start_semester_num = teaching_task.getInt("start_semester");			//讲课周学时
						int semester_hours = start_semester_num*numm;								//本学期学时
						String totle_semester = "";				//开课总学期数
						
						if(test_semester==null || "".equals(test_semester)){
							if(check_semester==null || "".equals(check_semester)){
								totle_semester = "0";
							}else{
								totle_semester = String.valueOf(commonCourse.setWeekly(check_semester).size());
							}
						}else{
							totle_semester = String.valueOf(commonCourse.setWeekly(test_semester).size());
						}
						
						String update_teaching_sql = "UPDATE teaching_task 		"+ 
											"			SET                     "+
											"			classes_weekly = '"+numm+"' , 	        "+
											"			totle_semester = '"+totle_semester+"',	"+
											"			semester_hours = '"+semester_hours+"'	"+
											"			WHERE                   "+
											"			id = '"+teaching_task.getString("id")+"' ;";
						db.executeUpdate(update_teaching_sql);
						
						/*计算周总学时*/
						db.executeUpdate("UPDATE teaching_task  SET week_learn_time=start_semester+experiment+computer_week_time WHERE id ='"+teaching_task.getString("id")+"'");
					}if(teaching_task!=null){teaching_task.close();}
					if (updateState) {
						out.println("<script>parent.layer.msg('添加 计划书里的数据复制到安排表');window.parent.location.reload(true);parent.layer.close(index);</script>");
					} else {
						out.println("<script>parent.layer.msg('添加 失败!计划书里的数据复制到安排表');</script>");
					}
				} catch (Exception e) {
					out.println("<script>parent.layer.msg('添加 失败计划书里的数据复制到安排表');</script>");
					return;
				}
			}
			if (bjRs != null) {
				bjRs.close();
			}
				if(upnum==0){
					out.println("<script>parent.layer.msg('该专业下,所有班级任务书已存在');</script>");
				}
		} else {
			out.println("<script>parent.layer.msg('没有教学计划所对应的班级，请去班级管理添加');</script>");
		}

		//关闭数据与serlvet.out

		if (page != null) {
			page = null;
		}

	}
%>
 
<%
 	//插入常用菜单日志
 	int TagMenu = db
 			.Row("SELECT COUNT(*) as row FROM  menu_worker  WHERE sysmenuid='"
 					+ PMenuId
 					+ "' and  workerid='"
 					+ Suid
 					+ "' and  companyid=" + Scompanyid);
 	if (TagMenu == 0) {
 		db
 				.executeUpdate("INSERT INTO `menu_worker`(`sysmenuid`,`workerid`,`countes`,`companyid`) VALUES ('"
 						+ PMenuId
 						+ "','"
 						+ Suid
 						+ "','1','"
 						+ Scompanyid + "');");
 	} else {
 		db
 				.executeUpdate("UPDATE  `menu_worker` SET `countes`=countes+1,`usetime`=now() WHERE  sysmenuid='"
 						+ PMenuId
 						+ "' and  workerid='"
 						+ Suid
 						+ "' and  companyid=" + Scompanyid);
 	}
 %>
<%
	if (db != null)
		db.close();
	db = null;
	if (server != null)
		server = null;
%>