<%@ page trimDirectiveWhitespaces="true" %>
<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@page import="v1.haocheok.commom.common"%>
<%@page import="service.dao.db.Page"%>
<%@page import="com.sun.rowset.internal.Row"%>
<%@page import="org.apache.commons.lang3.StringUtils"%>
<%@ include file="../../cookie.jsp"%>

<%
	String id = request.getParameter("id");					//teaching_tsak表中id
	String marge_id = request.getParameter("marge_id");if(marge_id==null || "null".equals(marge_id)){marge_id="";}					//合班id（marge_class 的id）
	
	String select_sql = "SELECT teaching_task.semester,																	"+
			"		dict_courses.id as dict_coursesid				,						"+
			"		  course_name,                                                                                      "+
			"			major_id,					"+
			"			teaching_task.course_id,																						"+
			"				teaching_task.school_year,																	"+
			"			teaching_task.class_id,																						"+
			"		  teacher_name,                                                                                      "+
			"			teaching_task.dict_departments_id"+
			"		FROM teaching_task                                                                                  "+
			"		  LEFT JOIN dict_courses                                                                            "+
			"		    ON teaching_task.course_id = dict_courses.id                                                    "+
			"			LEFT JOIN teaching_task_teacher ON ( teaching_task_teacher.teaching_task_id = teaching_task.id	AND teaching_task_teacher.state=1					)		"+
			"		  LEFT JOIN teacher_basic                                                                           "+
			"		    ON teaching_task_teacher.teacherid = teacher_basic.id WHERE teaching_task.id = '"+id+"';";
	ResultSet set = db.executeQuery(select_sql);
	String semester = "";			//学年学期号
	String course_name = "";
	String dict_coursesid = "";		//课程id
	String major_id = "";			//专业
	String teacher_name = "";
	String course_id = "";
	String class_id = "";
	String school_year = "";		//入学年份
	String dict_departments_id = "";		//院系id
	while(set.next()){
		semester = set.getString("semester");
		course_name = set.getString("course_name");
		teacher_name = set.getString("teacher_name");
		course_id = set.getString("course_id");
		class_id = set.getString("class_id");
		school_year = set.getString("school_year");
		dict_departments_id = set.getString("dict_departments_id");
		dict_coursesid = set.getString("dict_coursesid");
	}if(set!=null){set.close();}
	if(teacher_name==null || "".equals(teacher_name)){
		teacher_name = "未填写";
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
  <script src="../../js/ajaxs.js"></script>
  <script type="text/javascript" src="../../js/jquery-1.9.1.js" ></script><!--通用jquery-->
<style type="text/css"> 
  .select_move {width: 900px;margin: 30px auto;height: auto;}
  select{width: 180px;height: 230px;overflow-y: scroll;border: 1px solid #e6e6e6;} 
  .select_move_1, .select_move_2, .select_move_3 { float:left;width: 33.33%;text-align: center;} 
  .clear{clear: both;} 
  .my-btn{width:66px;height: 30px;border: 1px solid #d3d3d3;display: block;margin: 0 auto;
    font-size: 12px;color: #3f3f3f;background: #f4f4f4;}
  .elem-quote {
    margin-bottom: 30px;
    padding: 15px;
    line-height: 22px;
    border-left: 5px solid #009688;
    border-radius: 0 2px 2px 0;
    background-color: #f2f2f2;
    font-size:13px;
  }
  .elem-quote span{margin-right: 24px;}
  .lever{width: 136px;margin: 20px auto;height: 40px;}
</style> 
<script type="text/javascript"> 
  
    
  /**选中的元素向右移动**/
  function moveRight() 
  { 
      
      //得到第一个select对象 
    var selectElement = document.getElementById("first"); 
    var optionElements = selectElement.getElementsByTagName("option"); 
    var len = optionElements.length; 
    
  
    if(!(selectElement.selectedIndex==-1))  //如果没有选择元素，那么selectedIndex就为-1 
    { 
        
      //得到第二个select对象 
      var selectElement2 = document.getElementById("secend"); 
    
        // 向右移动 
        for(var i=0;i<len ;i++) 
        { 
          selectElement2.appendChild(optionElements[selectElement.selectedIndex]); 
        } 
    } else
    { 
      alert("您还没有选择需要移动的元素！"); 
    } 
  } 
    
  //移动所有的到右边 
  function moveAll() 
  { 
    //得到第一个select对象 
    var selectElement = document.getElementById("first"); 
    var optionElements = selectElement.getElementsByTagName("option"); 
    var len = optionElements.length; 
    //alert(len); 
    
    //将第一个selected中的数组翻转 
    var firstOption = new Array(); 
    for(var k=len-1;k>=0;k--) 
    { 
      firstOption.push(optionElements[k]); 
    
    } 
    var lens = firstOption.length; 
      //得到第二个select对象 
    var selectElement2 = document.getElementById("secend"); 
    for(var j=lens-1;j>=0;j--) 
    { 
      selectElement2.appendChild(firstOption[j]); 
    } 
  } 
    
  //移动选中的元素到左边 
  function moveLeft() 
  { 
    //首先得到第二个select对象 
    var selectElement = document.getElementById("secend"); 
    var optionElement = selectElement.getElementsByTagName("option"); 
    var len = optionElement.length; 
      
    //再次得到第一个元素 
    if(!(selectElement.selectedIndex==-1)) 
    { 
      var firstSelectElement = document.getElementById("first"); 
      for(i=0;i<len;i++) 
      { 
        firstSelectElement.appendChild(optionElement[selectElement.selectedIndex]);//被选中的那个元素的索引 
      } 
    }else
    { 
      alert("您还没有选中要移动的项目!"); 
    } 
  } 
    
  //全部向左移 
  function moveAllLeft() 
  { 
    var selectElement = document.getElementById("secend"); 
    var optionElements = document.getElementsByTagName("option"); 
    var len = optionElements.length; 
    var optionEls = new Array(); 
    for(var i=len-1;i>=0;i--) 
    { 
      optionEls.push(optionElements[i]); 
    } 
    var lens = optionEls.length; 
      
    var firstSelectElement = document.getElementById("first"); 
    for(var j=lens-1;j>=0;j--) 
    { 
      firstSelectElement.appendChild(optionEls[j]); 
    } 
  } 

	//获取全部班级
	function all_class(semester,dict_coursesid,taskid){

    	var obj_str = {"semester":semester,"dict_coursesid":dict_coursesid,"taskid":taskid};
    	
		var obj = JSON.stringify(obj_str)
		var ret_str=PostAjx('../../../../Api/v1/?p=web/class/all',obj,'<%=Suid%>','<%=Spc_token%>');
		var obj = JSON.parse(ret_str);
		if(obj.success && obj.resultCode=="1000"){
			//先清空待选择班级
			$("#first").empty();
			//追加所有班级
			$("#first").append(obj.data);
			//取消点击更多班级事件
			$("#gengduo").unbind("click");
		}else{
		
			alert("请求出现问题");
		}

	}



	//保存信息
	function baocun(dict_departments_id,semester,teaching_task_id,marge_id,major_id){

		var array_val = new Array();  //定义数组   
		var str_txt = new Array();
	     $("#secend option").each(function(){  //遍历所有option  
	          var val = $(this).val();   //获取option值   
	          var txt = $(this).text();
	          if(val!=''){  
	        	  array_val.push(val);  //添加到数组中  
	          }  
	          if(txt!=''){
	        	  str_txt.push(Trim(txt,"g"))
		      }
	     })
		//班级id
		var class_teaching = array_val.join();
		//合并班级名称
		var merge_name = str_txt.join();
		
		var url = "?ac=add&dict_departments_id="+dict_departments_id+"&class_teaching="+class_teaching+"&merge_name="+merge_name+"&semester="+semester+"&teaching_task_id="+teaching_task_id+"&marge_id="+marge_id+"&major_id="+major_id;
	    window.location.href=url;
	}


	//去掉所有空格
	function Trim(str,is_global)
    {

        var result;

        result = str.replace(/(^\s+)|(\s+$)/g,"");

        if(is_global.toLowerCase()=="g")

        {

            result = result.replace(/\s/g,"");

         }

        return result;

	}
	
  
</script>
</head> 
  
<body> 
  <form class="select_move">
    <blockquote class="elem-quote" style="padding: 5px">
      &nbsp;&nbsp;&nbsp;
      学年学期号：<span><%=semester %></span>
      课程名称：<span><%=course_name %></span>
      授课教师：<span>[<%=teacher_name %>]</span>
    </blockquote>     
    <blockquote class="elem-quote" style="padding: 5px">
    	注：合班之后，讲课周次需手动修改。
    </blockquote>     
    <div class="select_move_1">
      候选班级<br><br> 
     <select name="first" size="10" id="first" multiple="multiple"> 
     <%
     	//判断是否是合班
     	ArrayList classid_arr = new ArrayList();
     	String huo_sql = "";
     	System.out.println("marge_class_id======"+marge_id);
		huo_sql = "select class_grade.id as class_id, class_name,people_number_nan,people_number_woman,teaching_task.id as id from teaching_task LEFT JOIN class_grade ON teaching_task.class_id = class_grade.id where course_id='"+course_id+"' and class_id!='"+class_id+"' ";
    		huo_sql = "SELECT											"+
     	"		  class_grade.id      AS class_id,                  "+
     	"		  IFNULL(marge_class.marge_name,class_name) AS class_name,                                       "+
     	"		teaching_task.marge_class_id as 	marge_id,					"+
     	"		  people_number_nan,                                "+
     	"		  people_number_woman,                              "+
     	"		  teaching_task.id    AS id                         "+
     	"		FROM teaching_task                                  "+
     	"		  LEFT JOIN class_grade                             "+
     	"		    ON teaching_task.class_id = class_grade.id      "+
     	"			LEFT JOIN marge_class ON teaching_task.marge_class_id = marge_class.id	"+
     	"		WHERE course_id = '"+course_id+"'                             "+
     	"		    AND class_id != '"+class_id+"' AND marge_state = 0 AND typestate=1";
     	
   		ResultSet huo_set = db.executeQuery(huo_sql);
   		while(huo_set.next()){
   	%>		    
   		<option ondblclick="moveRight()" title="<%=huo_set.getString("class_name") %>" value="<%=huo_set.getString("class_id")%>|<%=huo_set.getString("id")%>"> <%=huo_set.getString("class_name") %>[<% int num = huo_set.getInt("people_number_nan")+huo_set.getInt("people_number_woman");   out.println(num);    %>]</option>
   	
   	<%}if(huo_set!=null){huo_set.close();}%>
     </select>
     <br><br>
      <p style="font-size: 14px">
        <input type="button"  class="my-btn" id="gengduo" style="margin-top: 9px;" value="更多班级" onclick="all_class('<%=semester %>','<%=dict_coursesid %>','<%=id %>')" />
      </p> 
    </div> 
     <div class="select_move_2" style="padding-top: 72px;">
        <input class="my-btn" type="button" value="------>" onclick="moveRight()"/><br /> 
        <input class="my-btn" type="button" value="===>" onclick="moveAll()" /><br /> 
        <input class="my-btn" type="button" value="<------" onclick="moveLeft()"/><br /> 
        <input class="my-btn" type="button" value="<===" onclick="moveAllLeft()"/>
        <br><br>
        <input type="button" onclick="baocun('<%=dict_departments_id %>','<%=semester %>','<%=id %>','<%=marge_id %>','<%=major_id %>')" class="my-btn"  style="margin-top: 9px;" value="保存参数"/>
     </div> 
    <div class="select_move_3">
    已选班级<br><br> 
       <select size="10" id="secend"  multiple="multiple"> 
       		<%
       			if("".equals(marge_id)){
       				String class_sql = "select id,class_name,people_number_nan,people_number_woman from class_grade  where id = '"+class_id+"'";
    				class_sql = "SELECT													"+
    						"	  teaching_task.id                AS id,                "+
    						"	  class_grade.class_name,                               "+
    						"	  class_grade.people_number_nan,                        "+
    						"	  class_grade.people_number_woman,                      "+
    						"	  teaching_task.class_id          AS class_id           "+
    						"	FROM teaching_task                                      "+
    						"	  LEFT JOIN class_grade                                 "+
    						"	    ON teaching_task.class_id = class_grade.id          "+
    						"	WHERE teaching_task.id = '"+id+"' ;";
    				ResultSet class_set = db.executeQuery(class_sql);
    				while(class_set.next()){
       			
       		
       		%>
       			<option value="<%=class_set.getString("class_id") %>|<%=class_set.getString("id")%>" ><%=class_set.getString("class_name") %>[<% int num = class_set.getInt("people_number_nan")+class_set.getInt("people_number_woman");   out.println(num);    %>]</option>
       		<%}if(class_set!=null){class_set.close();}}else{ 
       			String marge_sql = "SELECT													"+
		       		"	  teaching_task.id                AS id,                            "+
		       		"	  class_grade.class_name,                                           "+
		       		"	  class_grade.people_number_nan,                                    "+
		       		"	  class_grade.people_number_woman,                                  "+
		       		"	  teaching_task.class_id          AS class_id                       "+
		       		"	FROM marge_class                                                    "+
		       		"	  LEFT JOIN teaching_tesk_marge                                     "+
		       		"	    ON marge_class.id = teaching_tesk_marge.marge_class_id          "+
		       		"	  LEFT JOIN teaching_task                                           "+
		       		"	    ON teaching_tesk_marge.teaching_task_id = teaching_task.id      "+
		       		"	  LEFT JOIN class_grade                                             "+
		       		"	    ON teaching_task.class_id = class_grade.id                      "+
		       		"	WHERE marge_class.id = '"+marge_id+"'";
       			ResultSet marge_set = db.executeQuery(marge_sql);
       			while(marge_set.next()){
       		%>
       			<option value="<%=marge_set.getString("class_id") %>|<%=marge_set.getString("id")%>" ><%=marge_set.getString("class_name") %>[<% int num = marge_set.getInt("people_number_nan")+marge_set.getInt("people_number_woman");   out.println(num);    %>]</option>
       			
       		<%}if(marge_set!=null){marge_set.close();}} %>
       </select>
       <br><br>
       <input type="button"  class="my-btn"  style="margin-top: 9px;" value="新增临班"/>
    </div>
    <div class="clear"></div>
    <!-- 下面 -->
    <div class="lever">      
      <p style="font-size: 14px;margin-left: 20px;">
        <input type="checkbox" name="vehicle" value="Bike" />
        &nbsp;格式化合班名
      </p>      
    </div> 
  </form> 
    
</body> 
</html>
<%
	//提交信息
	if("add".equals(ac)){
		
		common common = new common();
		
		String class_id_new = request.getParameter("class_teaching");						//班级id和教学计划id
		String merge_name_new = request.getParameter("merge_name");						//合班名称
		String semester_new = request.getParameter("semester");
		String teaching_task_id_new = request.getParameter("teaching_task_id");
		String dict_departments_id_new = request.getParameter("dict_departments_id");
		String marge_id_new = request.getParameter("marge_id");					//合班id(marge_class)	
		String major_id_new =request.getParameter("major_id") ;					//专业
		
		System.out.println("详情====="+teaching_task_id_new);
		
		String [] arr = class_id_new.split(",");
		boolean state = true;
		
		if(!"".equals(marge_id_new)){
			//合班信息拆分 只保留自己 那就是不和班级了  把teaching_task 中marge_state 状态修改掉 并且删除掉之前的合办信息
			//1.通过marge_id 删除teaching_tesk_marge 中信息
			String sql1 = "SELECT teaching_task_id FROM teaching_tesk_marge WHERE marge_class_id = '"+marge_id_new+"'";
			ResultSet set1 = db.executeQuery(sql1);
			while(set1.next()){
				//2.更新teaching 数据
				String up_sql1 = "UPDATE teaching_task  SET marge_state = 0,is_merge_class=0 WHERE id = '"+set1.getString("teaching_task_id")+"' ;";
				db.executeUpdate(up_sql1);
				
			}if(set1!=null){set1.close();}
			//3.删除marge_class 表中数据
			String del_sql1 = "DELETE FROM marge_class WHERE id = '"+marge_id_new+"' ;";
			db.executeUpdate(del_sql1);
			//4.删除teaching_tesk_marge
			String del_sql2 = "DELETE FROM teaching_tesk_marge WHERE marge_class_id = '"+marge_id_new+"' ;";
			db.executeUpdate(del_sql2);
			//判断是否是合班重构
			if(arr.length>1){
				//插入合班表中
				String marge_insert = "INSERT INTO marge_class 			 "+
				"			(                             "+
				"			marge_code,                      "+
				"			marge_name_number,               "+
				"			marge_name,                      "+
				"			marge_number,                    "+
				"			school_year_number,              "+
				"			dict_departments_id              "+
				"			)                                "+
				"			VALUES                           "+
				"			(                           "+
				"			'',                    "+
				"			'123',             "+
				"			'"+merge_name_new+"',                    "+
				"			'1',                  "+
				"			'"+semester_new+"',            "+
				"			'"+dict_departments_id_new+"'            "+
				"			);";
				int pkid = db.executeUpdateRenum(marge_insert);
				
				if(pkid>0){
					int totle = 0;
					for(int i = 0 ; i< arr.length;i++){
						List<String> result = Arrays.asList(arr[i].split("\\|")); 
						String classid = result.get(0);
						String teachingid = result.get(1);
						String people_number_nan = common.idToFieidName("class_grade","people_number_nan",classid);
						String people_number_woman = common.idToFieidName("class_grade","people_number_woman",classid);
						int yigong = Integer.parseInt(people_number_nan) + Integer.parseInt(people_number_woman);
						//2.插入到 teaching_tesk_marge 表中
						String insert_sql = "INSERT INTO teaching_tesk_marge 	"+
									"		(                                "+
									"		teaching_task_id,                   "+
									"		class_grade_id,                     "+
									"		class_grade_number,                 "+
									"		marge_class_id,                     "+
									"		academic_year,                      "+
									"		dict_departments_id,                "+
									"		is_temporary_class                  "+
									"		)                                   "+
									"		VALUES                              "+
									"		(                              "+
									"		"+teachingid+",                 "+
									"		"+classid+",                   "+
									"		"+yigong+",               "+
									"		"+pkid+",                   "+
									"		'"+semester_new+"',                    "+
									"		"+dict_departments_id_new+",              "+
									"		0                "+
									"		);";
									
						db.executeUpdate(insert_sql);
						if(!state){
							break;
						}else{
							//更新teaching_task 表 is_merge_class = 1
							String update_sql = "UPDATE teaching_task 					"+
									"			SET                                     "+
									"			marge_state = 1,						"+
									"			is_merge_class = 1       "+
									"			WHERE                                   "+
									"			id = '"+teachingid+"' ;";
							db.executeUpdate(update_sql);
						}			
						totle += yigong;
					}
					
					//增加一个临时班级
					String insert_class = "INSERT INTO class_grade 			"+
						"				(                                   "+
						"				departments_id,                     "+
						"				majors_id,                          "+
						"				class_name,                         "+
						"				people_number_nan,                  "+
						"				people_number_woman,                "+
						"				counsellor,                         "+
						"				class_number,                       "+
						"				class_big,                          "+
						"				class_abbreviation,                 "+
						"				class_category_number,              "+
						"				school_year,                        "+
						"				campus_id,                          "+
						"				teaching_area_id,                   "+
						"				classroom_id,                       "+
						"				school_year_code,                   "+
						"				graduation_class,                   "+
						"				stauts,                             "+
						"				hide                                "+
						"				)                                   "+
						"				VALUES                              "+
						"				(                                   "+
						"				'"+dict_departments_id_new+"',                   "+
						"				'"+major_id_new+"',                        "+
						"				'"+merge_name_new+"',                       "+
						"				'"+totle+"',                "+
						"				'0',                                "+
						"				'0',                                "+
						"				'0',                                "+
						"				'0',                                "+
						"				'0',                                "+
						"				'0',                                "+
						"				'0',                      "+
						"				'1',                                "+
						"				'0',                                "+
						"				'0',                                "+
						"				'0',                 "+
						"				'1',                                "+
						"				'1',                                "+
						"				'0'                                 "+
						"				);";
					
					int class_pkid = db.executeUpdateRenum(insert_class);
					
					
					//修改marge_class 表中的人数
					String marge_upsql = "UPDATE  marge_class SET class_grade_number = '"+totle+"' WHERE id = '"+pkid+"';";
					db.executeUpdate(marge_upsql);
					//修改teaching_task 中的marge_class_id 
					String teaching_task11 = "update teaching_task set marge_class_id = '"+pkid+"',class_id='"+class_pkid+"' where id = '"+teaching_task_id_new+"';";
					db.executeUpdate(teaching_task11);
				}else{
					state = false;
				}
			}else{
				//全部分解 删除生成的数据
				String teahcing_tasl_del = "DELETE FROM teaching_task WHERE id = '"+teaching_task_id_new+"' ;";
				db.executeUpdate(teahcing_tasl_del);
				//删除教师
				String teaching_sql = "DELETE FROM teaching_task_teacher WHERE teaching_task_id = '"+teaching_task_id_new+"'";
				db.executeUpdate(teaching_sql);
			}
		}else{
			if(arr.length>1){
				//插入合班表中
				String marge_insert = "INSERT INTO marge_class 			 "+
				"			(                             "+
				"			marge_code,                      "+
				"			marge_name_number,               "+
				"			marge_name,                      "+
				"			marge_number,                    "+
				"			school_year_number,              "+
				"			dict_departments_id              "+
				"			)                                "+
				"			VALUES                           "+
				"			(                           "+
				"			'',                    "+
				"			'123',             "+
				"			'"+merge_name_new+"',                    "+
				"			'1',                  "+
				"			'"+semester_new+"',            "+
				"			'"+dict_departments_id_new+"'            "+
				"			);";
				int pkid = db.executeUpdateRenum(marge_insert);
				
				if(pkid>0){
					int totle = 0;
					for(int i = 0 ; i< arr.length;i++){
						List<String> result = Arrays.asList(arr[i].split("\\|")); 
						String classid = result.get(0);
						String teachingid = result.get(1);
						String people_number_nan = common.idToFieidName("class_grade","people_number_nan",classid);
						String people_number_woman = common.idToFieidName("class_grade","people_number_woman",classid);
						int yigong = Integer.parseInt(people_number_nan) + Integer.parseInt(people_number_woman);
						//2.插入到 teaching_tesk_marge 表中
						String insert_sql = "INSERT INTO teaching_tesk_marge 	"+
									"		(                                "+
									"		teaching_task_id,                   "+
									"		class_grade_id,                     "+
									"		class_grade_number,                 "+
									"		marge_class_id,                     "+
									"		academic_year,                      "+
									"		dict_departments_id,                "+
									"		is_temporary_class                  "+
									"		)                                   "+
									"		VALUES                              "+
									"		(                              "+
									"		"+teachingid+",                 "+
									"		"+classid+",                   "+
									"		"+yigong+",               "+
									"		"+pkid+",                   "+
									"		'"+semester_new+"',                    "+
									"		"+dict_departments_id_new+",              "+
									"		0                "+
									"		);";
									
						db.executeUpdate(insert_sql);
						if(!state){
							break;
						}else{
							//更新teaching_task 表 is_merge_class = 1
							String update_sql = "UPDATE teaching_task 					"+
									"			SET                                     "+
									"			marge_state = 1,						"+
									"			is_merge_class = 1       "+
									"			WHERE                                   "+
									"			id = '"+teachingid+"' ;";
							db.executeUpdate(update_sql);
						}			
						totle += yigong;
					}
					//修改marge_class 表中的人数
					String marge_upsql = "UPDATE  marge_class SET class_grade_number = '"+totle+"' WHERE id = '"+pkid+"';";
					db.executeUpdate(marge_upsql);
					
					
					
					
					//增加一个临时班级
					String insert_class = "INSERT INTO class_grade 			"+
						"				(                                   "+
						"				departments_id,                     "+
						"				majors_id,                          "+
						"				class_name,                         "+
						"				people_number_nan,                  "+
						"				people_number_woman,                "+
						"				counsellor,                         "+
						"				class_number,                       "+
						"				class_big,                          "+
						"				class_abbreviation,                 "+
						"				class_category_number,              "+
						"				school_year,                        "+
						"				campus_id,                          "+
						"				teaching_area_id,                   "+
						"				classroom_id,                       "+
						"				school_year_code,                   "+
						"				graduation_class,                   "+
						"				stauts,                             "+
						"				hide                                "+
						"				)                                   "+
						"				VALUES                              "+
						"				(                                   "+
						"				'"+dict_departments_id_new+"',                   "+
						"				'"+major_id_new+"',                        "+
						"				'"+merge_name_new+"',                       "+
						"				'"+totle+"',                "+
						"				'0',                                "+
						"				'0',                                "+
						"				'0',                                "+
						"				'0',                                "+
						"				'0',                                "+
						"				'0',                                "+
						"				'0',                      "+
						"				'1',                                "+
						"				'0',                                "+
						"				'0',                                "+
						"				'0',                 "+
						"				'1',                                "+
						"				'1',                                "+
						"				'0'                                 "+
						"				);";
					
					int class_pkid = db.executeUpdateRenum(insert_class);
					
					
					
					
					
					
					//修改teaching_task 中的marge_class_id 
					String teaching_task11 = setTaskInsetSql(teaching_task_id_new,String.valueOf(pkid),class_pkid); 
					int pkTeacher_id = db.executeUpdateRenum(teaching_task11);
					
					//修改多教师数据
					if(pkTeacher_id>0){
						//先删除再添加老师
						if(db.executeUpdate("DELETE FROM teaching_task_teacher WHERE teaching_task_id = '"+pkTeacher_id+"'")){
							String teacher_sql = "INSERT INTO teaching_task_teacher		"+
						    "    	(teaching_task_id,                              "+
						    "            teacherid,                                 "+
						    "            class_begins_weeks,                        "+
						    "            teaching_week_time,                        "+
						    "            leixing,                                   "+
						    "            state)                                     "+
							"       SELECT                                          "+
							"         '"+pkTeacher_id+"' as teaching_task_id,       "+
							"         teacherid,                                    "+
							"         class_begins_weeks,                           "+
							"         teaching_week_time,                           "+
							"         leixing,                                      "+
							"         state                                         "+
							"       FROM teaching_task_teacher                      "+
							"       WHERE teaching_task_id = '"+teaching_task_id_new+"'";
							db.executeUpdate(teacher_sql);
						}else{
							state = false;
						}
					}
					
					
					
				}else{
					state = false;
				}
			}
		}
		
		
		//最后 跳转
		if(state){
			out.println("<script>parent.layer.msg('合并班级 成功', {icon:1,time:1000,offset:'150px'},function(){parent.location.reload();}); </script>");
		}else{
			out.println("<script>parent.layer.msg('合并班级 失败');</script>");
		}
		
	}


%>



<%!

public static String  setTaskInsetSql(String id,String marge_class_id,int class_pkid){
	String sql = "INSERT INTO teaching_task 			"+
	"		(                                               "+
	"		teaching_task_class_id,                         "+
	"		semester,                                       "+
	"		course_id,                                      "+
	"		major_id,                                       "+
	"		dict_departments_id,                            "+
	"		class_id,                                       "+
	"		classes_weekly,                                 "+
	"		start_semester,                                 "+
	"		responsibility,                                 "+
	"		school_year,                                    "+
	"		lecture_classes,                                "+
	"		teaching_research_number,                       "+
	"		course_category_id,                             "+
	"		course_nature_id,                               "+
	"		extracurricular_practice_hour,                  "+
	"		professional_direction_coding,                  "+
	"		check_semester,                                 "+
	"		test_semester,                                  "+
	"		class_in,                                       "+
	"		teaching_plan_class_id,                         "+
	"		is_merge_class,                                 "+
	"		marge_class_id,                                 "+
	"		marge_state,									"+
	"		merge_number,                                   "+
	"		teaching_way,                                   "+
	"		computer_area_id,                               "+
	"		teaching_task_sort,                              "+
	"		typestate,												"+
	"		union_class_code,                                   "+
	"		character_selection,                                "+
	"		practice_weeks,                                     "+
	"		assessment_id,                                      "+
	"		assessment_category_id,                             "+
	"		class_begins_weeks,                                 "+
	"		experiment_weeks,                                   "+
	"		week_learn_time,                                    "+
	"		experiment,                                         "+
	"		computer_weeks,                                     "+
	"		computer_week_time,                                 "+
	"		credits,                                            "+
	"		credits_term,                                       "+
	"		totle_semester,                                     "+
	"		startnum,                                           "+
	"		total_classes,                                      "+
	"		lecture_hours,                                      "+
	"		amongshiyan,                                        "+
	"		amongshangji,                                       "+
	"		practice_time,                                      "+
	"		practice_state,                                     "+
	"		semester_hours,                                     "+
	"		semester_jiangke,                                   "+
	"		semester_amongshiyan,                               "+
	"		semester_amongshangji,                              "+
	"		semester_practice_state,                            "+
	"		teaching_area_id,                                   "+
	"		experiment_area_id,                                 "+
	"		sex_ask,                                            "+
	"		classes_number,                                     "+
	"		course_number,                                      "+
	"		semester_practice_time                              "+
	"		)                                               "+
    "                                                       "+
	"		SELECT 	                                        "+
	"		teaching_task_class_id,                         "+
	"		semester,                                       "+
	"		course_id,                                      "+
	"		major_id,                                       "+
	"		dict_departments_id,                            "+
	"		'"+class_pkid+"' as  class_id,                                       "+
	"		classes_weekly,                                 "+
	"		start_semester,                                 "+
	"		responsibility,                                 "+
	"		school_year,                                    "+
	"		lecture_classes,                                "+
	"		teaching_research_number,                       "+
	"		course_category_id,                             "+
	"		course_nature_id,                               "+
	"		extracurricular_practice_hour,                  "+
	"		professional_direction_coding,                  "+
	"		check_semester,                                 "+
	"		test_semester,                                  "+
	"		class_in,                                       "+
	"		teaching_plan_class_id,                         "+
	"		0 as is_merge_class,                                 "+
	"		"+marge_class_id+" as  marge_class_id,                                 "+
	"		0 as marge_state	,									"+
	"		merge_number,                                   "+
	"		teaching_way,                                   "+
	"		computer_area_id,                               "+
	"		teaching_task_sort  ,                            "+
	"		1   as  typestate,										"+
	"		union_class_code,                                   "+
	"		character_selection,                                "+
	"		practice_weeks,                                     "+
	"		assessment_id,                                      "+
	"		assessment_category_id,                             "+
	"		class_begins_weeks,                                 "+
	"		experiment_weeks,                                   "+
	"		week_learn_time,                                    "+
	"		experiment,                                         "+
	"		computer_weeks,                                     "+
	"		computer_week_time,                                 "+
	"		credits,                                            "+
	"		credits_term,                                       "+
	"		totle_semester,                                     "+
	"		startnum,                                           "+
	"		total_classes,                                      "+
	"		lecture_hours,                                      "+
	"		amongshiyan,                                        "+
	"		amongshangji,                                       "+
	"		practice_time,                                      "+
	"		practice_state,                                     "+
	"		semester_hours,                                     "+
	"		semester_jiangke,                                   "+
	"		semester_amongshiyan,                               "+
	"		semester_amongshangji,                              "+
	"		semester_practice_state,                            "+
	"		teaching_area_id,                                   "+
	"		experiment_area_id,                                 "+
	"		sex_ask,                                            "+
	"		classes_number,                                     "+
	"		course_number,                                      "+
	"		semester_practice_time                              "+
	"		FROM                                            "+
	"		teaching_task                                   "+
	"		WHERE id='"+id+"';";
	
	return sql;
}

%>



<%
if(db!=null)db.close();db=null;if(server!=null)server=null;%>