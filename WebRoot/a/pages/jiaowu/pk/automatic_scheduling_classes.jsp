<%@ page trimDirectiveWhitespaces="true" %>
<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@page import="v1.haocheok.commom.common"%>
<%@page import="v1.haocheok.commom.commonCourse"%>
<%@ include file="../../cookie.jsp"%>

<%


	String semString = "";

	String sql_sq = "select academic_year,this_academic_tag from academic_year where this_academic_tag = 'true' ;";
	ResultSet setsql = db.executeQuery(sql_sq);
	while(setsql.next()){
		
		semString = setsql.getString("academic_year");
		
	}if(setsql!=null){setsql.close();}
	
	if("xueqi".equals(ac)){
		semString = request.getParameter("semers");
	}
	
	
	
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
	<script src="../../js/ajaxs.js"></script>

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
		<div class="layui-field-box">
		    <form class="layui-form" action="?ac=add" method="post">
		    	<div class="b_left">
		    	<div class="layui-form-item">
				      <label class="layui-form-label">排课类别</label>
				      <div class="layui-input-block">
				        <select lay-verify="required" name="course_class" id="course_class" lay-verType="tips" lay-filter="course_class">
				          <option value="1" >教务处排课</option>
				          <option value="2" >教务处教务科排课</option>
				          <option value="3" >教务处体制改革</option>
				        </select>
				      </div>
				  </div>
				  <div class="layui-form-item">
				      <label class="layui-form-label">学年学期号</label>
				      <div class="layui-input-block">
				        <select name="school_number" id="school_number"  lay-filter="test" lay-verify="required" lay-verType="tips">
				          <option value="">请选择</option>
				          <%
				          	String sql_sem = "select academic_year from academic_year";
				          	ResultSet set = db.executeQuery(sql_sem);
				          	while(set.next()){
				          
				          %>
				          	<option value="<%=set.getString("academic_year")%>" <%if(semString.equals(set.getString("academic_year"))){out.println("selected='selected'");} %> ><%=set.getString("academic_year")%></option>
				          <%}if(set!=null){set.close();} %>
				          
				        </select>
				      </div>
				  </div>
				  

				  <div class="layui-form-item">
				    <label class="layui-form-label">开课通知单数:</label>
				    <div class="layui-input-block">
				      <input type="text"  value=""  name="num_kaike" class="layui-input" disabled="disabled">
				    </div>
				  </div>
				  <div class="layui-form-item">
				    <label class="layui-form-label">课程门数:</label>
				    <div class="layui-input-block">
				      <input type="text"  value="" name="num_kecheng"  class="layui-input" disabled="disabled">
				    </div>
				  </div>
				  
				  <div class="layui-form-item">
				    <label class="layui-form-label">授课教师人数:</label>
				    <div class="layui-input-block">
				      <input type="text"  value="" name="num_jiaoshi"   class="layui-input" disabled="disabled">
				    </div>
				  </div>
				  
				  
				  <div class="layui-form-item">
				    <label class="layui-form-label">可用教室数:</label>
				    <div class="layui-input-block">
				      <input type="text"  value="" name="num_jiaoshu"   class="layui-input" disabled="disabled">
				    </div>
				  </div>
				  
				  <div class="layui-form-item">
				    <label class="layui-form-label">排课合班数:</label>
				    <div class="layui-input-block">
				      <input type="text"  value=""  name="num_heban"   class="layui-input" disabled="disabled">
				    </div>
				  </div>
				  
				  <div class="layui-form-item">
				    <label class="layui-form-label">排课班级数:</label>
				    <div class="layui-input-block">
				      <input type="text"  value=""  name="num_class"  class="layui-input" disabled="disabled">
				    </div>
				  </div>
				  
				  <div class="layui-form-item">
				    <label class="layui-form-label">其中临班数:</label>
				    <div class="layui-input-block">
				      <input type="text"  value="0"  class="layui-input"  name=""  disabled="disabled">
				    </div>
				  </div>
				  
				  <div class="layui-form-item">
				    <label class="layui-form-label">已排课数量:</label>
				    <div class="layui-input-block">
				      <input type="text"  value=""   name="companynumber"  class="layui-input" disabled="disabled">
				    </div>
				  </div>
				  <div class="layui-form-item">
				    <label class="layui-form-label">未排课数量:</label>
				    <div class="layui-input-block">
				      <input type="text"  value=""  name="nocompanynumber"  class="layui-input" disabled="disabled">
				    </div>
				  </div>
			    </div>
			    
			    <div class="layui-form-item">
			    <label class="layui-form-label">排课方式</label>
				    <div class="layui-input-block">
						<input type="radio" name="fangshi" value="0" title="追加排课" checked>
						<input type="radio" name="fangshi" value="1" title="清空排课" >
				    </div>
			    </div>
			    
			    
			    
				<div class="lever">
					<div class="layui-form-item">
					    <div class="layui-input-block"  style="margin-left: 10px">
						    <button class="layui-btn" style="margin-right: 18%;" lay-submit lay-filter="*">编排课程</button>
						    <button class="layui-btn" type="button" style="margin-right: 18%;" onclick="select_class()">查询已排课信息</button>
						    <button class="layui-btn" type="button" style="margin-right: 18%;" onclick="del_class()">清空课表</button>
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



   form.on('submit(*)', function(data){
		var course_class = $("#course_class").val();
		if(course_class == ""){
			layer.msg("请选择排课类别");
			return false;
		}
	  	return true;	
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
   form.on('select(test)',function(data){
		var sem = data.value;
		if(sem!=""){
			window.location.href = "?ac=xueqi&semers="+sem+"";
		}

	})
   form.on('select(course_class)',function(data){
		var arrange_type = data.value;
		var school_number = $('#school_number').val();
		if(arrange_type!=""||school_number!=''){
			var obj_str1;
			obj_str1 = {"arrange_type":data.value,"school_number":school_number};
			var obj1 = JSON.stringify(obj_str1)
			var ret_str1=PostAjx('../../../../Api/v1/?p=web/info/getArrageParameters',obj1,'<%=Suid%>','<%=Spc_token%>');
			obj1 = JSON.parse(ret_str1);
			$('input[name="num_kaike"]').val(obj1.num_kaike);
			$('input[name="num_kecheng"]').val(obj1.num_kecheng);
			$('input[name="num_jiaoshu"]').val(obj1.num_jiaoshu);
			$('input[name="num_class"]').val(obj1.num_class);
			$('input[name="companynumber"]').val(obj1.companynumber);
			$('input[name="nocompanynumber"]').val(obj1.nocompanynumber);
			$('input[name="num_jiaoshi"]').val(obj1.num_jiaoshi);
			$('input[name="num_heban"]').val(obj1.num_heban);
		}

	})
   
  
});

function select_class(){
	
	var school_number = $("#school_number").val();
	if(school_number==null || school_number==""){
		layer.msg("请选择学期查询!");
		return;
	}
	layer.open({
		  type: 2,
		  title: '查询已排课信息',
		  shadeClose: true,
		  maxmin:1,
		  shade: 0.5,
		  area: ['100%', '100%'],
		  content: 'analysis_curriculum_query.jsp?xueqi='+school_number 
		});
	
}


function del_class(){
	
	var school_number = $("#school_number").val();
	if(school_number==null || school_number==""){
		layer.msg("请选择学期查询!");
		return;
	}
	window.location.href = "?ac=del_class&school_number="+school_number+"";
	
}


</script>


</body>
</html>

<%
	if("del_class".equals(ac)){
		
		String school_number = request.getParameter("school_number");
		System.out.println("学期号===="+school_number);
		if(school_number!=null &&	!"".equals(school_number)){
			boolean state = commonCourse.setScheduleCategory(school_number,"0");
			if(state){
				out.println("<script>parent.layer.msg('删除成功');window.location.replace('./automatic_scheduling_classes.jsp');</script>");
			}else{
				out.println("<script>parent.layer.msg('删除失败!');window.location.replace('./automatic_scheduling_classes.jsp');</script>");
			}
		}else{
			out.println("<script>parent.layer.msg('学期号不能为空');window.location.replace('./automatic_scheduling_classes.jsp');</script>");
		}
		
		
	}

%>


<%
	if("add".equals(ac)){
		
		commonCourse commonCourse = new commonCourse();
		String school_number = request.getParameter("school_number");
		if(school_number==null||"".equals(school_number)){
			out.println("<script>layer.msg('请选择学期学号');</script>");
			return ;
		}
		
		//排课类别
		String course_class = request.getParameter("course_class");
		
		String paikefangshi = request.getParameter("fangshi");
		
		if("1".equals(paikefangshi)){
			//删除再排课
			commonCourse.setScheduleCategory(school_number,course_class);
		}
		
		
		//调用公共方法
		common common = new common();
		String fixed_classroom = "";	//固定教室	1:启用  2:不启用
		String classroom1 = "";			//指定/固定教室检查		1:容纳人数不足-->漏课		2:容纳人数不足-->忽略	
		String classroom2 = "";			//指定/固定教室检查		1:教室状态不可用-->漏课	2:教室状态不可用-->忽略
		String course_mode = "";		//排课方式			5，6，7
		String querynum = "";			//漏课查询次数
		String coursql = "SELECT fixed_classroom,classroom1,classroom2,course_mode,querynum FROM arrage_course WHERE school_number = '"+school_number+"'; ";
		ResultSet courset = db.executeQuery(coursql); 
		if(courset.next()){
			fixed_classroom = courset.getString("fixed_classroom");
			classroom1 = courset.getString("classroom1");
			classroom2 = courset.getString("classroom2");
			course_mode = courset.getString("course_mode");
			querynum = courset.getString("querynum");
		}if(courset!=null){courset.close();}
		
		//课程分类设置
		String left_str = "";
		String left_where = "";
		String kecheng_fen = "select count(1) as row from arrage_course_category_set where semester='"+school_number+"' ;";
		int num_fenlei = db.Row(kecheng_fen);
		if(num_fenlei>0){
			left_str = "	LEFT JOIN arrage_course_category_set ON (arrage_coursesystem.course_category_id = arrage_course_category_set.categoryid  AND arrage_coursesystem.semester = arrage_course_category_set.semester)	";
			left_where = "		ORDER BY sort,arrage_coursesystem.schedulesort  ASC		";
		}else{
			left_where = "		ORDER BY arrage_coursesystem.schedulesort  ASC		";
		}
		
		
		//查询出合班的课程。
		String kaike_sql_no = " SELECT  arrage_coursesystem.*,														"+
				"			marge_class.class_grade_number,									"+
				"			arrage_coursesystem.class_begins_weeks  AS class_begins_weeks1,					"+
  				"				arrage_coursesystem.start_semester AS start_semester1	,				"+
  				"			arrage_coursesystem.teaching_area_id as teaching_area_id,							"+
				"			IFNULL(people_number_nan,0)+IFNULL(people_number_woman,0) AS totle					"+
				"		  FROM arrage_coursesystem                                                              "+
				"			LEFT JOIN marge_class ON arrage_coursesystem.marge_class_id = marge_class.id	"+
				left_str+
				"			LEFT JOIN class_grade									"+
    			"				ON arrage_coursesystem.class_id = class_grade.id						"+
				"		      WHERE  arrage_coursesystem.semester = '"+school_number+"'  AND timetablestate=0   AND marge_class_id!=0   "+left_where+"   ;";
		
		ResultSet kaikeNoSet = db.executeQuery(kaike_sql_no);		
		//1.查询出 合班的 marge_id 
		String marge_class_id = "";
		
		/********************************合班的开始*******************************************/
		
		
		
		outno:while(kaikeNoSet.next()){
			
			
			//获取周学时数
			int start_semester = kaikeNoSet.getInt("start_semester1");
			String semester = kaikeNoSet.getString("semester");				//学年学期号
			String class_id_marge = kaikeNoSet.getString("class_id");				//合班班级id
			String teacherid = kaikeNoSet.getString("teacher_id");			//老师id
			int week_num = Integer.valueOf(start_semester)/2;				//每周排课次数
			String course_id = kaikeNoSet.getString("arrage_coursesystem.course_id");
			String appoint_roomid = kaikeNoSet.getString("appoint_roomid");		//指定教室 
			String jiaoxuequ = kaikeNoSet.getString("teaching_area_id");			//教学区
			String class_grade_number = kaikeNoSet.getString("class_grade_number");		//合班人数	
			String class_begins_weeks = kaikeNoSet.getString("class_begins_weeks1");
			String arrage_coursesystem_id = kaikeNoSet.getString("arrage_coursesystem.id");
			String totle = kaikeNoSet.getString("totle");
			
			
			//2.通过合班的marge_id 查询出要排课的id
			marge_class_id = kaikeNoSet.getString("marge_class_id");
			String marge_sql = "	SELECT																						"+
			"			  arrage_coursesystem.id               AS id,                                                   "+
			"			  arrage_coursesystem.class_id               AS class_id,                                                   "+
			"			  arrange_sys_class.timetable AS timetable,														"+
			"			  arrage_coursesystem.teaching_task_id AS teaching_task_id                                      "+
			"			FROM teaching_tesk_marge                                                                        "+
			"			  LEFT JOIN arrage_coursesystem                                                                 "+
			"			    ON teaching_tesk_marge.teaching_task_id = arrage_coursesystem.teaching_task_id              "+
			"			LEFT JOIN arrange_sys_class ON arrange_sys_class.classid = arrage_coursesystem.class_id			"+
			"			WHERE teaching_tesk_marge.marge_class_id = '"+marge_class_id+"'	";
			
			ResultSet margeSet = db.executeQuery(marge_sql);
			ArrayList<String> arrage_coursesystem_classList = new ArrayList<String>();
			ArrayList<String> arrage_coursesystem_classid = new ArrayList<String>();
			ArrayList<String> arrage_id = new ArrayList<String>();
			while(margeSet.next()){
				
				//判断是否班级已经有排课 
				if(margeSet.getString("timetable")!=null && !"".equals(margeSet.getString("timetable"))){
					arrage_coursesystem_classList.add(margeSet.getString("timetable"));
				}
				
				arrage_coursesystem_classid.add(margeSet.getString("class_id"));
				arrage_id.add(margeSet.getString("id"));
				
			}if(margeSet!=null){margeSet.close();}
			
			
			//获取合班之后的时间表
			//ArrayList<ArrayList<String>> base_list = commonCourse.getclassList(semester,course_mode,arrage_coursesystem_classid);
			
			//公共信息 
			ArrayList<ArrayList<String>> base_list = commonCourse.setInitializationList(semester,course_mode);			//公共list 为了保存课程的信息
			
			ArrayList<ArrayList<String>> common_list = base_list;
			//获取合班之后的时间表
			ArrayList<ArrayList<String>> banji_list = commonCourse.getclassList(semester,course_mode,arrage_coursesystem_classList);
			ArrayList<ArrayList<String>> laoshi_list = commonCourse.setTeacherCondition(base_list,teacherid,semester);
			ArrayList<ArrayList<String>> classroomtole_list = base_list;
			
			
			
			
			//申明
			ArrayList<String> week_list = commonCourse.getSetupWeek(semester,course_mode,course_id);	//获取课表数  
			
			out1_no:for(int h=1;h<=week_num;h++){		//每周排课次数
				
				
				//1.调取class 班级信息 是否存在
				boolean state_class = true;
				
				//2.调取teacher 老师信息
				boolean state_teacher = true;
				String eqsql_teacher = "";
				HashMap<String,String> map_teacher = commonCourse.getTeacherinfo(teacherid,semester);
				if(!map_teacher.isEmpty()){
					laoshi_list = commonCourse.toArrayList(map_teacher.get("timetable"),"*","#");
					if(!commonCourse.judgeStr(laoshi_list)){
						
						//漏课处理
						commonCourse.LeakageClass(arrage_coursesystem_id);
						commonCourse.setArrageLog(arrage_coursesystem_id,"教师 "+common.idToFieidName("teacher_basic","teacher_name",teacherid)+"  已经全部排课，请重新分配");
						continue outno;
					}
				}
				//3.调取classroom 教室信息
				boolean state_classromm = true;
				
				for(int a=0 ;a<week_list.size();a++){
					String week_jieci = week_list.get(a);	
					char w = week_jieci.charAt(0);
					char jc = week_jieci.charAt(1);
					int i = Integer.valueOf(String.valueOf(w));
					int j = Integer.valueOf(String.valueOf(jc));
				//循环课表
					ArrayList<String> class_list = banji_list.get(i);
					ArrayList<String> teacher_list = laoshi_list.get(i);
					ArrayList<String> comm_list = common_list.get(i);
					String class_jieci = class_list.get(j);						//班级节次
					String teacher_jieci = teacher_list.get(j);
					
					//调用教室
					
					if(!"0".equals(class_jieci) && !"0".equals(teacher_jieci)){
						//查找教室   判断是否启动 固定教室
						
						String classroomid = "";
						if(appoint_roomid!=null&&!"".equals(appoint_roomid) && !"0".equals(appoint_roomid)){
							classroomid = appoint_roomid;
							HashMap<String,String> map_classroom = commonCourse.getClassroomInfo(classroomid,semester);
							if(!map_classroom.isEmpty()){
								classroomtole_list = commonCourse.toArrayList(map_classroom.get("timetable"),"*","#");
							}
							ArrayList<String> class_rommlist = classroomtole_list.get(i);
							String class_rommStr = class_rommlist.get(j);
							if("0".equals(class_rommStr)){
								classroomid = commonCourse.test(totle,fixed_classroom,class_id_marge,i,j,semester,classroom1,classroom2,class_grade_number,querynum,jiaoxuequ);
							}
						}else{
							classroomid = commonCourse.test(totle,fixed_classroom,class_id_marge,i,j,semester,classroom1,classroom2,class_grade_number,querynum,jiaoxuequ);
						}
						
						//if("".equals(classroomid)){
						if(classroomid==null || "null".equals(classroomid) || "0".equals(classroomid) || "".equals(classroomid)){
							//漏课处理
							commonCourse.LeakageClass(arrage_coursesystem_id);
							commonCourse.setArrageLog(arrage_coursesystem_id,"没有找到合适的教室请重新分配");
							continue outno;
						}else{
							HashMap<String,String> map_classroom = commonCourse.getClassroomInfo(classroomid,semester);
							if(!map_classroom.isEmpty()){
								classroomtole_list = commonCourse.toArrayList(map_classroom.get("timetable"),"*","#");
							}
							ArrayList<String> class_rommlist = classroomtole_list.get(i);
							String class_rommStr = class_rommlist.get(j);
							if(!"0".equals(class_rommStr)){
								
								//判断老师 课表节次是否锁定
								if("9".equals(teacher_list.get(j))){
									continue;		//只跳出一层循环
								}else{
									class_list.set(j,"0");
									teacher_list.set(j,"0");
									comm_list.set(j,"0");
									class_rommlist.set(j,"0");
								}
								
								//修改班级信息
								//if(map_class.isEmpty()){
									//判断是更新还是新增 班级
								//	state_class = commonCourse.insertClassinfo(class_id,semester,commonCourse.toStringfroList(banji_list,"*","#"));
								//}else{
								//	state_class = commonCourse.updateClassinfo(map_class.get("id"),commonCourse.toStringfroList(banji_list,"*","#"));
								//}
								
								
								//修改班级信息
								for(int ban = 0; ban<arrage_coursesystem_classid.size();ban++){
									int num = db.Row("SELECT 	COUNT(1) AS ROW FROM  arrange_sys_class	WHERE classid = '"+arrage_coursesystem_classid.get(ban)+"' ;");
									if(num>=1){
										
										String sql_class_sys = "	SELECT id,	timetable FROM  arrange_sys_class	WHERE classid='"+arrage_coursesystem_classid.get(ban)+"' ;	";
										ResultSet sqlsql_set = db.executeQuery(sql_class_sys);
										String class_timetable_new = "";
										String calss_id_new = "";
										while(sqlsql_set.next()){
											class_timetable_new = sqlsql_set.getString("timetable");
											calss_id_new = sqlsql_set.getString("id");
										}if(sqlsql_set!=null){sqlsql_set.close();}
										ArrayList<ArrayList<String>> new_class_list = commonCourse.toArrayList(class_timetable_new,"*","#");
										new_class_list.get(i).set(j,"0");
										//更新语句
										state_class = commonCourse.updateClassinfo(calss_id_new,commonCourse.toStringfroList(new_class_list,"*","#"));
									}else{
										state_class = commonCourse.insertClassinfo(arrage_coursesystem_classid.get(ban),semester,commonCourse.toStringfroList(banji_list,"*","#"));
									}
								}
								
								
								
								if(state_class){
									//修改老师信息
									if(map_teacher.isEmpty()){
										state_teacher = commonCourse.insertTeacherInfo(teacherid,semester,commonCourse.toStringfroList(laoshi_list,"*","#"));
									}else{
										state_teacher = commonCourse.updateTeacherInfo(map_teacher.get("id"),commonCourse.toStringfroList(laoshi_list,"*","#"));
									}
									
									if(state_teacher){
										//修改教室信息
										if(map_classroom.isEmpty()){
											state_classromm = commonCourse.insertClassroom(classroomid,semester,commonCourse.toStringfroList(classroomtole_list,"*","#"));
										}else{
											state_classromm = commonCourse.updateClassroom(map_classroom.get("id"),commonCourse.toStringfroList(classroomtole_list,"*","#"));
										}
										if(state_classromm){
											if(h==week_num){
												
												//根据合班的班级数量循环保存
												for(int k = 0 ; k<arrage_id.size();k++){
													commonCourse.setCourse(arrage_id.get(k),course_id,teacherid,classroomid,common_list,arrage_coursesystem_classid.get(k),class_begins_weeks ,semester );
													
												}
												
												//保存合班的那条数据
												boolean sttt = commonCourse.setCourse(arrage_coursesystem_id,course_id,teacherid,classroomid,common_list,class_id_marge,class_begins_weeks ,semester );
												
												//主表
												if(sttt){
													continue outno;
												}else{
													out.println("<script>parent.layer.msg('自动排课失败!');</script>");
								      			    return;
												}
												
											}else{
												continue out1_no;
											}
										}else{
											out.println("<script>parent.layer.msg('自动排课失败!');</script>");
											commonCourse.setArrageLog(arrage_coursesystem_id,"保存教室信息失败");
						      			    return;
										}
										
									}else{
										out.println("<script>parent.layer.msg('自动排课失败!');</script>");
										commonCourse.setArrageLog(arrage_coursesystem_id,"保存老师信息失败");
					      			    return;
									}
								}else{
									out.println("<script>parent.layer.msg('自动排课失败!');</script>");
									commonCourse.setArrageLog(arrage_coursesystem_id,"保存班级信息失败");
				      			    return;
								}
								
							}
							
						}
						
					}
				}
		}
		}if(kaikeNoSet!=null){kaikeNoSet.close();}
		
		
		
		
		
		
		
		
		
		
		
		
		
		/********************************合班的结束*******************************************/
		
		
		
		
		
		
		
		
		
		
		
		
		
		
				
		
	
		
		
		//1.查询出要排课的课程  没有合班的
		String kaike_sql = " SELECT  arrage_coursesystem.*,														"+
				"			marge_class.class_grade_number,									"+
				"			arrage_coursesystem.class_begins_weeks  AS class_begins_weeks1,					"+
  				"				arrage_coursesystem.start_semester AS start_semester1	,				"+
  				"			arrage_coursesystem.teaching_area_id as teaching_area_id,							"+
				"			IFNULL(people_number_nan,0)+IFNULL(people_number_woman,0) AS totle					"+
				"		  FROM arrage_coursesystem                                                              "+
				"			LEFT JOIN marge_class ON arrage_coursesystem.marge_class_id = marge_class.id	"+
				left_str+
				"			LEFT JOIN class_grade									"+
    			"				ON arrage_coursesystem.class_id = class_grade.id						"+
				"		      WHERE  arrage_coursesystem.semester = '"+school_number+"'  AND timetablestate=0 	AND arrage_coursesystem.is_merge_class!=1 AND arrage_coursesystem.marge_state!=1     "+left_where+"   ;";
		
		
		ResultSet kaike_set = db.executeQuery(kaike_sql);
		
		
		//text
		
		out:while(kaike_set.next()){
			
			//获取周学时数
			int start_semester = kaike_set.getInt("start_semester1");
			String class_id = kaike_set.getString("class_id");				//班级id
			String semester = kaike_set.getString("semester");				//学年学期号
			String teacherid = kaike_set.getString("teacher_id");			//老师id
			int week_num = Integer.valueOf(start_semester)/2;				//每周排课次数
			String course_id = kaike_set.getString("arrage_coursesystem.course_id");
			String appoint_roomid = kaike_set.getString("appoint_roomid");		//指定教室 
			String jiaoxuequ = kaike_set.getString("teaching_area_id");			//教学区
			
			String class_grade_number = kaike_set.getString("class_grade_number");		//合班人数	
			String class_begins_weeks = kaike_set.getString("class_begins_weeks1");
			String arrage_coursesystem_id = kaike_set.getString("arrage_coursesystem.id");
			String totle = kaike_set.getString("totle");
			
			//公共信息 
			
			
			ArrayList<ArrayList<String>> base_list = commonCourse.setInitializationList(semester,course_mode);			//公共list 为了保存课程的信息
			
			ArrayList<ArrayList<String>> common_list = base_list;
			ArrayList<ArrayList<String>> banji_list = base_list;
			ArrayList<ArrayList<String>> laoshi_list = commonCourse.setTeacherCondition(base_list,teacherid,semester);
			ArrayList<ArrayList<String>> classroomtole_list = base_list;
			
			//申明
			ArrayList<String> week_list = commonCourse.getSetupWeek(semester,course_mode,course_id);	//获取课表数  
			//ArrayList<String> week_list = commonCourse.getOutOfOrder(commonCourse.setWeekList(4,3));
			
			
			out1:for(int h=1;h<=week_num;h++){		//每周排课次数
				
				
				//1.调取class 班级信息 是否存在
				boolean state_class = true;
				String eqsql_class ="";
				HashMap<String,String> map_class  = commonCourse.getclassInfo(class_id,semester);
				if(!map_class.isEmpty()){
					banji_list = commonCourse.toArrayList(map_class.get("timetable"),"*","#");
					if(!commonCourse.judgeStr(banji_list)){
						
						//漏课处理
						commonCourse.LeakageClass(arrage_coursesystem_id);
						commonCourse.setArrageLog(arrage_coursesystem_id,"班级"+common.idToFieidName("class_grade","class_name",class_id)+" 已经全部排课，请重新分配");
						continue out;
					}
				}	
				//2.调取teacher 老师信息
				boolean state_teacher = true;
				String eqsql_teacher = "";
				HashMap<String,String> map_teacher = commonCourse.getTeacherinfo(teacherid,semester);
				if(!map_teacher.isEmpty()){
					laoshi_list = commonCourse.toArrayList(map_teacher.get("timetable"),"*","#");
					if(!commonCourse.judgeStr(laoshi_list)){
						
						//漏课处理
						commonCourse.LeakageClass(arrage_coursesystem_id);
						commonCourse.setArrageLog(arrage_coursesystem_id,"教师 "+common.idToFieidName("teacher_basic","teacher_name",teacherid)+"  已经全部排课，请重新分配");
						continue out;
					}
				}
				//3.调取classroom 教室信息
				boolean state_classromm = true;
				
				
				
				for(int a=0 ;a<week_list.size();a++){
					String week_jieci = week_list.get(a);	
					char w = week_jieci.charAt(0);
					char jc = week_jieci.charAt(1);
					int i = Integer.valueOf(String.valueOf(w));
					int j = Integer.valueOf(String.valueOf(jc));
				//循环课表
					ArrayList<String> class_list = banji_list.get(i);
					ArrayList<String> teacher_list = laoshi_list.get(i);
					ArrayList<String> comm_list = common_list.get(i);
					String class_jieci = class_list.get(j);
					String teacher_jieci = teacher_list.get(j);
					
					//调用教室
					
					
					
					if(!"0".equals(class_jieci) && !"0".equals(teacher_jieci)){
						//查找教室   判断是否启动 固定教室
						
						String classroomid = "";
						if(appoint_roomid!=null&&!"".equals(appoint_roomid) && !"0".equals(appoint_roomid)){
							classroomid = appoint_roomid;
							HashMap<String,String> map_classroom = commonCourse.getClassroomInfo(classroomid,semester);
							if(!map_classroom.isEmpty()){
								classroomtole_list = commonCourse.toArrayList(map_classroom.get("timetable"),"*","#");
							}
							ArrayList<String> class_rommlist = classroomtole_list.get(i);
							String class_rommStr = class_rommlist.get(j);
							if("0".equals(class_rommStr)){
								classroomid = commonCourse.test(totle,fixed_classroom,class_id,i,j,semester,classroom1,classroom2,class_grade_number,querynum,jiaoxuequ);
							}
						}else{
							classroomid = commonCourse.test(totle,fixed_classroom,class_id,i,j,semester,classroom1,classroom2,class_grade_number,querynum,jiaoxuequ);
						}
						
						//if("".equals(classroomid)){
						if(classroomid==null || "null".equals(classroomid) || "0".equals(classroomid) || "".equals(classroomid)){
							//漏课处理
							commonCourse.LeakageClass(arrage_coursesystem_id);
							commonCourse.setArrageLog(arrage_coursesystem_id,"没有找到合适的教室请重新分配");
							continue out;
						}else{
							HashMap<String,String> map_classroom = commonCourse.getClassroomInfo(classroomid,semester);
							if(!map_classroom.isEmpty()){
								classroomtole_list = commonCourse.toArrayList(map_classroom.get("timetable"),"*","#");
							}
							ArrayList<String> class_rommlist = classroomtole_list.get(i);
							String class_rommStr = class_rommlist.get(j);
							if(!"0".equals(class_rommStr)){
								
								//判断老师 课表节次是否锁定
								if("9".equals(teacher_list.get(j))){
									continue;		//只跳出一层循环
								}else{
									class_list.set(j,"0");
									teacher_list.set(j,"0");
									comm_list.set(j,"0");
									class_rommlist.set(j,"0");
								}
								
								//修改班级信息
								if(map_class.isEmpty()){
									//判断是更新还是新增 班级
									state_class = commonCourse.insertClassinfo(class_id,semester,commonCourse.toStringfroList(banji_list,"*","#"));
								}else{
									state_class = commonCourse.updateClassinfo(map_class.get("id"),commonCourse.toStringfroList(banji_list,"*","#"));
								}
								if(state_class){
									//修改老师信息
									if(map_teacher.isEmpty()){
										state_teacher = commonCourse.insertTeacherInfo(teacherid,semester,commonCourse.toStringfroList(laoshi_list,"*","#"));
									}else{
										state_teacher = commonCourse.updateTeacherInfo(map_teacher.get("id"),commonCourse.toStringfroList(laoshi_list,"*","#"));
									}
									
									if(state_teacher){
										//修改教室信息
										if(map_classroom.isEmpty()){
											state_classromm = commonCourse.insertClassroom(classroomid,semester,commonCourse.toStringfroList(classroomtole_list,"*","#"));
										}else{
											state_classromm = commonCourse.updateClassroom(map_classroom.get("id"),commonCourse.toStringfroList(classroomtole_list,"*","#"));
										}
										if(state_classromm){
											if(h==week_num){
												
												boolean sttt = commonCourse.setCourse(arrage_coursesystem_id,course_id,teacherid,classroomid,common_list,class_id,class_begins_weeks ,semester );
												
												//主表
												if(sttt){
													continue out;
												}else{
													out.println("<script>parent.layer.msg('自动排课失败!');</script>");
								      			    return;
												}
												
											}else{
												continue out1;
											}
										}else{
											out.println("<script>parent.layer.msg('自动排课失败!');</script>");
											commonCourse.setArrageLog(arrage_coursesystem_id,"保存教室信息失败");
						      			    return;
										}
										
									}else{
										out.println("<script>parent.layer.msg('自动排课失败!');</script>");
										commonCourse.setArrageLog(arrage_coursesystem_id,"保存老师信息失败");
					      			    return;
									}
								}else{
									out.println("<script>parent.layer.msg('自动排课失败!');</script>");
									commonCourse.setArrageLog(arrage_coursesystem_id,"保存班级信息失败");
				      			    return;
								}
								
							}
							
						}
						
					}
				}
		}
			
		}if(kaike_set!=null){kaike_set.close();}
		out.println("<script>parent.layer.msg('自动排课完成');</script>");
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