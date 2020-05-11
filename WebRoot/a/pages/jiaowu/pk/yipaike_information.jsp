<%@ page trimDirectiveWhitespaces="true" %>
<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@page import="v1.haocheok.commom.common"%>
<%@page import="service.dao.db.Page"%>
<%@page import="com.sun.rowset.internal.Row"%>
<%@page import="v1.haocheok.commom.commonCourse"%>
<%@ include file="../../cookie.jsp"%>

<%
	//获取学期学号
	String school_number = request.getParameter("school_number");

	String sel_sql = "SELECT *																				 "+
			"		FROM arrage_coursesystem                                                                 "+
			"		  LEFT JOIN teaching_task_detailed                                                       "+
			"		    ON arrage_coursesystem.teaching_task_detailed_id = teaching_task_detailed.id         "+
			"		WHERE semester = '"+school_number+"'                                                                      "+
			"		    AND timetablestate = 1";
	ResultSet set = db.executeQuery(sel_sql);
%>


<!DOCTYPE html> 
<html>
  <head>
    <meta charset="utf-8"> 
    <meta name="viewport" content="width=device-width, initial-scale=1"> 
    <title><%=Mokuai%></title>
        <link rel="stylesheet" href="../../../pages/css/sy_style.css">	    
	    <link rel="stylesheet" href="../../js/layui2/css/layui.css">
		<script type="text/javascript" src="../../js/jquery-1.9.1.js" ></script><!--通用jquery-->
		<script src="../../js/layui2/layui.js"></script>
<style type="text/css">
.myinput {BACKGROUND-COLOR: #e6f3ff; BORDER-BOTTOM: #ffffff 1px groove; BORDER-LEFT: #ffffff 1px groove; BORDER-RIGHT: #ffffff 1px groove; BORDER-TOP: #ffffff 1px groove; COLOR: #000000; FONT: 24px Verdana,Geneva,sans-serif; HEIGHT: 36px; WIDTH: 60px"}
</style>
<style type="text/css"> 
	    th { background-color: white; }
	    .btn-group-vertical>.btn, .btn-group>.btn{height:33px;}
        table tr:hover{background:#eeeeee;color:#19A094;}
</style>

  </head>
  <body>
<div class="" style="padding-bottom: 0px;margin-left: 1%;margin-right: 1%; height:auto;">  
    
<div id="tb" class="form_top layui-form" style="display: flex;">
	<p>学期学号:<%=school_number %></p>
</div>
<div  style="display:block;clear:both;">

<!-- test --> 
<div id="LAY_preview">
<table border="1" width="100%" bordercolorlight="#588FC7" cellspacing="0" cellpadding="0" bordercolor="#19A094"   id="tab1">
  <tbody>
  	<tr>
      <td width="46" height="24" align="center" >课程名称</td>
      <td width="46" height="24" align="center" >授课老师</td>
      <td width="46" height="24" align="center" >教室</td>
      <td width="46" height="24" align="center" >上课班级</td>
      <td width="46" height="24" align="center" >排课人数</td>
      <td width="46" height="24" align="center" >讲课周次</td>
      <td width="46" height="24" align="center" >实验周次</td>
      <td width="46" height="24" align="center" >上机周次</td>
      <td width="46" height="24" align="center" >讲课周学时</td>
      <td width="46" height="24" align="center" >实验周学时</td>
      <td width="46" height="24" align="center" >上机周学时</td>
      <td width="46" height="24" align="center" >学分</td>
      <td width="46" height="24" align="center" >总学时数</td>
      <td width="46" height="24" align="center" >星期一</td>
      <td width="46" height="24" align="center" >星期二</td>
      <td width="46" height="24" align="center" >星期三</td>
      <td width="46" height="24" align="center" >星期四</td>
      <td width="46" height="24" align="center" >星期五</td>
      <td width="46" height="24" align="center" >星期六</td>
      <td width="46" height="24" align="center" >星期日</td>
    </tr>
    <%
    	common common = new common();
    	commonCourse commonCourse = new commonCourse();
    	while(set.next()){
    %>
    
    
   	<tr>
      <td width="40" align="center"><%=common.idToFieidName("dict_courses","course_name",set.getString("course_id"))%></td>
      <td width="40" align="center"><%=common.idToFieidName("teacher_basic","teacher_name",set.getString("teacher_id"))%></td>
      <td width="40" align="center"><%=common.idToFieidName("classroom","classroomname",set.getString("classroomid")) %></td>
      <td width="40" align="center"><%=common.idToFieidName("class_grade","class_name",set.getString("class_id")) %></td>
      <td width="40" align="center"><% String people_number_nan = common.idToFieidName("class_grade","people_number_nan",set.getString("class_id")); String people_number_woman = common.idToFieidName("class_grade","people_number_woman",set.getString("class_id")); int num = Integer.valueOf(people_number_woman)+Integer.valueOf(people_number_nan); out.println(num); %></td>
      <td width="40" align="center"><%=set.getString("class_begins_weeks") %></td>
      <td width="40" align="center"><%=set.getString("experiment_weeks")==null?"":set.getString("experiment_weeks") %></td>
      <td width="40" align="center"><%=set.getString("computer_weeks")==null?"":set.getString("computer_weeks") %></td>
      <td width="40" align="center"><%=set.getString("teaching_week_time")==null?"":set.getString("teaching_week_time") %></td>
      <td width="40" align="center"><%=set.getString("experiment")==null?"":set.getString("experiment") %></td>
      <td width="40" align="center"><%=set.getString("computer_week_time")==null?"":set.getString("computer_week_time") %></td>
      <td width="40" align="center"><%=set.getString("credits_term")==null?"":set.getString("credits_term") %></td>
      <td width="40" align="center"><%=set.getString("total_classes")==null?"":set.getString("total_classes") %></td>
      
      <%
      		ArrayList<ArrayList<String>> common_list = commonCourse.toArrayList(set.getString("timetable"),"*","#");
      
      		for(int i=0; i<common_list.size();i++){
      %>
   		 <td width="40" align="center"><%= commonCourse.getSection(common_list.get(i))%></td>
      <%} %>
    </tr>
    <%}if(set!=null){set.close();} %>
    
    
  </tbody>
</table>
           
          </div>
          
        </div>
      </div>

<script> 

function zhuanchu(){
	if(!confirm("确定要转出到开课通知单吗？")){
        return ;
    }

	var cks=document.getElementsByName("check");
	var str= new Array();
	for(var i =0 ; i < cks.length;i++){
		if(cks[i].checked){
            str.push(cks[i].value);
        }
	}
	if(str.length>0){
		str = str.join();
		var url = "?ac=daochu&id="+str;
		window.location.href=url;
	}else{
		layer.msg("必须选择一个");
	}
	
}

function ckAll(){
    var flag=document.getElementById("allChecks").checked;
    var cks=document.getElementsByName("check");
    for(var i=0;i<cks.length;i++){
        cks[i].checked=flag;
    }
}


/**
 * 搜索内容
 */
var search_val='12';
search_val=search_val.replace(/(^\s*)|(\s*$)/g, "");//处理空格

if(search_val.length>=1){
	modify('search',search_val);
}
//改变某个id的值
function modify (id,search_val){
	$("#"+id+"").val(""+search_val+"")
} 
 //清空 搜索输入框
function Refresh(){
	$("#search").val("");
} 
 //刷新整个页面
function shuaxin(){
	 //location.reload();
	window.location.href="?ac=";
}

//执行
function ac_tion() {
	var xueqi = $("#xueqi").val();
	var banji = $("#banji").val();
	var zhuanye = $("#zhuanye").val();
	var laoshi = $("#laoshi").val();
	var jiaoyanshi = $("#jiaoyanshi").val();
	var dict_departments_id = $("#dict_departments_id").val();
	
	window.location.href="?ac=&xueqi="+xueqi+"&banji="+banji+"&zhuanye="+zhuanye+"&laoshi="+laoshi+"&jiaoyanshi="+jiaoyanshi+"&dict_departments_id="+dict_departments_id+"";
}

//合并 id,teaching_task_detailed_id(教学计划详情id) marge_id (合班id)
function hebing(id,teaching_task_detailed_id,marge_id){
	if(teaching_task_detailed_id==null || teaching_task_detailed_id=="0" || teaching_task_detailed_id==""){
			alert("请先设定教师");
			return;
	}
	 layer.open({
		  type: 2,
		  title: '合并班级',
		  offset: 't',//靠上打开
		  shadeClose: true,
		  maxmin:1,
		  shade: 0.5,
		  area: ['100%', '100%'],
		  content: 'xbj.jsp?id='+id+'&teaching_task_detailed_id='+teaching_task_detailed_id+'&marge_id='+marge_id
	});
	
}


//导出
layui.use('table', function(){
  var table = layui.table;
  
});
function help(val) {//帮助页面
	 layer.open({
		  type: 2,
		  title: '帮助页面',
		  offset: 't',//靠上打开
		  shadeClose: true,
		  maxmin:1,
		  shade: 0.5,
		  area: ['780px', '100%'],
		  content: '../../syst/help.jsp?id='+val
	});
}	

//设置教师页面
function setupTeacher(id,school_year){
	layer.open({
		  type: 2,
		  title: '设置教师',
		  offset: 't',//靠上打开
		  shadeClose: true,
		  maxmin:1,
		  shade: 0.5,
		  area: ['100%', '100%'],
		  content: 'teach_shezhi.jsp?id='+id+'&school_year='+school_year+"&state=1"
	});

}

</script> 
  </body>
</html>
<%
	if("daochu".equals(ac)){
		String ids = request.getParameter("id");
		String [] arr = ids.split(",");
		boolean state = true;
		for(int i = 0 ; i < arr.length ; i++){
			String sel_num = "SELECT COUNT(1) AS ROW FROM teaching_task WHERE id = '"+arr[i]+"' AND teaching_task_detailed_id !=0;";
			if(db.Row(sel_num)>0){
			}else{
				out.println("<script>parent.layer.msg('转出 失败,请先设置老师');</script>");
				return;
			}
		}
		
		
		for(int i = 0 ; i < arr.length ; i++){
			//判断是否存在合班
			if(arr[i].indexOf("marge")!=-1){
				String selet_marge = "select teaching_task_id from teaching_tesk_marge where marge_class_id = '"+arr[i]+"';";
				ResultSet set_marge = db.executeQuery(selet_marge);
				while(set_marge.next()){
					//1.先判断是否存在 如果存在删除
					String num_sss = "SELECT COUNT(1) AS ROW FROM teaching_kaike WHERE teaching_task_id = '"+set_marge.getString("teaching_task_id")+"'";
					if(db.Row(num_sss)>0){
						String del = "DELETE FROM teaching_kaike WHERE teaching_task_id = '"+set_marge.getString("teaching_task_id")+"' ;";
						db.executeUpdate(del);
					}
					String insert_sql = "INSERT INTO teaching_kaike 			"+
						"		(                                               "+
						"		teaching_task_class_id,                         "+
						"		teaching_task_detailed_id,                      "+
						"		semester,                                       "+
						"		course_id,                                      "+
						"		major_id,                                       "+
						"		dict_departments_id,                            "+
						"		class_id,                                       "+
						"		classes_weekly,                                 "+
						"		academic_year,                                  "+
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
						"		merge_class_id,                                 "+
						"		merge_number,                                   "+
						"		teaching_way,                                   "+
						"		computer_area_id,                               "+
						"		teaching_task_sort,                              "+
						"		teaching_task_id								"+
						"		)                                               "+
		                "                                                       "+
						"		SELECT 	                                        "+
						"		teaching_task_class_id,                         "+
						"		teaching_task_detailed_id,                      "+
						"		semester,                                       "+
						"		course_id,                                      "+
						"		major_id,                                       "+
						"		dict_departments_id,                            "+
						"		class_id,                                       "+
						"		classes_weekly,                                 "+
						"		academic_year,                                  "+
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
						"		merge_class_id,                                 "+
						"		merge_number,                                   "+
						"		teaching_way,                                   "+
						"		computer_area_id,                               "+
						"		teaching_task_sort  ,                            "+
						"		id												"+
						"		FROM                                            "+
						"		teaching_task                                   "+
						"		WHERE id='"+set_marge.getString("teaching_task_id")+"';";
						
						state = db.executeUpdate(insert_sql);
						if(state){
						}else{
							state = false;
							break;
						}
				}if(set_marge!=null){set_marge.close();}
			}else{
				//1.先判断是否存在 如果存在删除
				String num_sss = "SELECT COUNT(1) AS ROW FROM teaching_kaike WHERE teaching_task_id = '"+arr[i]+"'";
				if(db.Row(num_sss)>0){
					String del = "DELETE FROM teaching_kaike WHERE teaching_task_id = '"+arr[i]+"' ;";
					db.executeUpdate(del);
				}
				
				String insert_sql = "INSERT INTO teaching_kaike 			"+
					"		(                                               "+
					"		teaching_task_class_id,                         "+
					"		teaching_task_detailed_id,                      "+
					"		semester,                                       "+
					"		course_id,                                      "+
					"		major_id,                                       "+
					"		dict_departments_id,                            "+
					"		class_id,                                       "+
					"		classes_weekly,                                 "+
					"		academic_year,                                  "+
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
					"		merge_class_id,                                 "+
					"		merge_number,                                   "+
					"		teaching_way,                                   "+
					"		computer_area_id,                               "+
					"		teaching_task_sort,                              "+
					"		teaching_task_id								"+
					"		)                                               "+
	                "                                                       "+
					"		SELECT 	                                        "+
					"		teaching_task_class_id,                         "+
					"		teaching_task_detailed_id,                      "+
					"		semester,                                       "+
					"		course_id,                                      "+
					"		major_id,                                       "+
					"		dict_departments_id,                            "+
					"		class_id,                                       "+
					"		classes_weekly,                                 "+
					"		academic_year,                                  "+
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
					"		merge_class_id,                                 "+
					"		merge_number,                                   "+
					"		teaching_way,                                   "+
					"		computer_area_id,                               "+
					"		teaching_task_sort  ,                            "+
					"		id												"+
					"		FROM                                            "+
					"		teaching_task                                   "+
					"		WHERE id='"+arr[i]+"';";
					
					state = db.executeUpdate(insert_sql);
					if(state){
					}else{
						state = false;
						break;
					}
			}
			
			
			
			
		}
		if(state){
			out.println("<script>parent.layer.msg('转出 成功', {icon:1,time:1000,offset:'150px'},function(){}); </script>");
		}else{
			out.println("<script>parent.layer.msg('转出 失败');</script>");
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
long TimeEnd=Calendar.getInstance().getTimeInMillis();
System.out.println("执行时间"+ (TimeEnd-TimeStart)+"ms");
 %>
<%
if(db!=null)db.close();db=null;if(server!=null)server=null;%>