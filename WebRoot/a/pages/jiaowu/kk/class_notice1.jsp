<%@ page trimDirectiveWhitespaces="true" %>
<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@page import="v1.haocheok.commom.common"%>
<%@page import="service.dao.db.Page"%>
<%@page import="com.sun.rowset.internal.Row"%>
<%@ include file="../../cookie.jsp"%>
<%
//获取文件后面的对象 数据
  	String search_val = request.getParameter("val"); if(search_val==null){search_val="";}else{search_val=search_val.replaceAll("\\s*", "");}
  	search_val = new Page().mysqlCode(search_val);//防止sql注入
	search_val=search_val.toUpperCase();
	search_val=search_val.replaceAll(" ","");
	
	//筛选信息查询
	String sqlwhere = "";		//拼凑where 条件的sql语句
	
	String banji = request.getParameter("banji");
	if(banji==null || "0".equals(banji)){banji="";}else{sqlwhere += "	AND t.class_id = '"+banji+"' ";}
	
	String laoshi = request.getParameter("laoshi");
	if(laoshi==null || "0".equals(laoshi)){laoshi="";}else{sqlwhere += "	AND	t.teacher_id='"+laoshi+"'	";}
	
	String timetablestate = request.getParameter("timetablestate");
	if(timetablestate==null || "all".equals(timetablestate)){timetablestate="";}else{sqlwhere += "	AND	t.timetablestate='"+timetablestate+"'	";}
	
	String xueqi = request.getParameter("xueqi");
	if(xueqi==null || "0".equals(xueqi)){
		String sqlslq = "select academic_year,this_academic_tag from academic_year where this_academic_tag = 'true'	;";
		ResultSet sqlqsSet = db.executeQuery(sqlslq);
		while(sqlqsSet.next()){
			xueqi=sqlqsSet.getString("academic_year");
		}if(sqlqsSet!=null){sqlqsSet.close();}
		sqlwhere +="	AND t.semester = '"+xueqi+"'";
	}else{
		sqlwhere +="	AND t.semester = '"+xueqi+"'";
	}
	
	
	String zhuanye = request.getParameter("zhuanye");
	if(zhuanye==null || "0".equals(zhuanye)){zhuanye="";}else{sqlwhere += "		AND t.major_id='"+zhuanye+"'";}
	
	String dict_departments_id = request.getParameter("dict_departments_id");
	if(dict_departments_id==null || "0".equals(dict_departments_id)){dict_departments_id="";}else{sqlwhere +="	AND t.dict_departments_id = '"+dict_departments_id+"'";}
	
	
 common common=new common();
 String  sql1 = "SELECT																												"+
 		"		t.id as id	,																										"+
 		"		t.timetablestate as timetablestate,																					"+
		"	  teacher_basic.teacher_name AS teacher_name,                                                                           "+
		"	  IFNULL(marge_class.marge_name,class_grade.class_name) AS class_name,                                                  "+
		"	  IFNULL(marge_class.class_grade_number,class_grade.people_number_nan+class_grade.people_number_woman) AS totle,        "+
		"	  t.class_begins_weeks AS class_begins_weeks, t.start_semester,                                                                           "+
		"		t.course_id AS course_id				"+
		"	FROM arrage_coursesystem t                                                                                              "+
		"	  LEFT JOIN marge_class                                                                                                 "+
		"	    ON t.marge_class_id = marge_class.id                                                                                "+
		"	  LEFT JOIN class_grade t2                                                                                              "+
		"	    ON t2.id = t.class_id                                                                                               "+
		"	  LEFT JOIN teacher_basic                                                                                               "+
		"	    ON t.teacher_id = teacher_basic.id                                                                                  "+
		"	  LEFT JOIN major                                                                                                       "+
		"	    ON t.major_id = major.id                                                                                            "+
		"	  LEFT JOIN class_grade                                                                                                 "+
		"	    ON class_grade.id = t.class_id                                                                                      "+
		"	  LEFT JOIN dict_departments																							"+
		"	    ON dict_departments.id = t.dict_departments_id"+
		"		WHERE 1=1  "+sqlwhere+"		";
 
 
System.out.println("====="+sql1);

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
 
<div id="tb" class="form_top layui-form" style="display: flex;width:1200px;">
			<select name="xueqi" id="xueqi">
				<option value="0">请选择学期号</option>
				<%
					String xueqi_sql = "select academic_year from academic_year";
					ResultSet xueqi_set = db.executeQuery(xueqi_sql);
					while(xueqi_set.next()){
				%>
					<option value="<%=xueqi_set.getString("academic_year") %>" <%if(xueqi.equals(xueqi_set.getString("academic_year"))){out.println("selected='selected'");} %>><%=xueqi_set.getString("academic_year") %></option>
				<%}if(xueqi_set!=null){xueqi_set.close();} %>
			</select>

            <select name="dict_departments_id" id="dict_departments_id" >
              <option value="0">全部院系</option>
            <%
            //查询院系
            String selectDsql="SELECT  DISTINCT p.dict_departments_id,d.departments_name,d.departments_name,ELT(INTERVAL(CONV(HEX(LEFT(CONVERT(d.departments_name USING gbk),1)),16,10),0xB0A1,0xB0C5,0xB2C1,0xB4EE,0xB6EA,0xB7A2,0xB8C1,0xB9FE,0xBBF7,0xBFA6,0xC0AC,0xC2E8,0xC4C3,0xC5B6,0xC5BE,0xC6DA,0xC8BB,0xC8F6,0xCBFA,0xCDDA,0xCEF4,0xD1B9,0xD4D1),'A','B','C','D','E','F','G','H','J','K','L','M','N','O','P','Q','R','S','T','W','X','Y','Z') AS PY FROM  teaching_task_class AS p, dict_departments AS d WHERE   p.dict_departments_id=d.id  ORDER BY py ASC;";
            ResultSet yxRs = db.executeQuery(selectDsql);
            while(yxRs.next()){
            %>
              <option value="<%=yxRs.getString("dict_departments_id") %>"  <%if(yxRs.getString("dict_departments_id").equals(dict_departments_id)){out.print("selected=\"selected\"");} %>><%=yxRs.getString("py") %>-<%=yxRs.getString("departments_name") %></option>
             <%}if(yxRs!=null){yxRs.close();} %>
            </select>
			<select name="laoshi" id="laoshi">
				<option value="0">请选择老师</option>
				<%
					String laoshi_sql = "select id,teacher_name from teacher_basic";
					ResultSet laoshi_set = db.executeQuery(laoshi_sql);
					while(laoshi_set.next()){
				%>
					<option value="<%=laoshi_set.getString("id") %>" <%if(laoshi.equals(laoshi_set.getString("id"))){out.print("selected=\"selected\"");} %>><%=laoshi_set.getString("teacher_name") %></option>
				<%}if(laoshi_set!=null){laoshi_set.close();} %>
			</select>  
			<select name="zhuanye" id="zhuanye">
				<option value="0">请选择专业</option>
				<%
					String zhuanye_sql = "select id,major_name from major";
					ResultSet zhuanye_set = db.executeQuery(zhuanye_sql);
					while(zhuanye_set.next()){
				%>
					<option value="<%=zhuanye_set.getString("id") %>" <%if(zhuanye.equals(zhuanye_set.getString("id"))){out.println("selected='selected'");} %>><%=zhuanye_set.getString("major_name") %></option>
				<%}if(zhuanye_set!=null){zhuanye_set.close();} %>
			</select>
			<select name="banji" id="banji">
				<option value="0">请选择班级</option>
				<%
					String banji_sql = "select id,class_name from class_grade";
					ResultSet banji_set = db.executeQuery(banji_sql);
					while(banji_set.next()){
				%>
					<option value="<%=banji_set.getString("id") %>" <%if(banji.equals(banji_set.getString("id"))){out.println("selected='selected'");} %>><%=banji_set.getString("class_name") %></option>
				<%} %>
			</select>
			<select name="timetablestate" id="timetablestate">
				<option value="all">全部</option>
				<option value="0" <%if(timetablestate.equals("0")) out.print("selected");%> >未排课</option>
				<option value="1" <%if(timetablestate.equals("1")) out.print("selected");%>>已排课</option>
				<option value="2" <%if(timetablestate.equals("2")) out.print("selected");%>>漏课</option>
				<option value="3" <%if(timetablestate.equals("3")) out.print("selected");%>>指定不排课</option>
			</select>
	<button class="layui-btn layui-btn-small  layui-btn-primary" onclick="ac_tion('')"  style="height: 35px;  color: white; background: rgb(25, 160, 148);"> <i class="layui-icon" style="color: #FFF;">&#xe615;</i> 搜索</button>
	<button class="layui-btn layui-btn-small  layui-btn-primary" onclick="shuaxin()" style="height: 35px;  color: white; background: rgb(25, 160, 148);"> <i class="layui-icon" style="color: #FFF;">ဂ</i> 刷新</button>
</div>
    
<div  style="display:block;clear:both;">

<!-- test --> 
<div id="LAY_preview">
<table border="1" width="100%" bordercolorlight="#588FC7" cellspacing="0" cellpadding="0" bordercolor="#19A094"   id="tab1">
  <tbody>
  	<tr>
      <td width="46" height="24" ><p align="center">课程名称</p></td>
      <td width="46" height="24" ><p align="center">上课周学时</p></td>
      <td width="60" height="34" align="center">授课教师</td>
      <td width="60" height="34" align="center">上课班级</td>
      <td width="65" height="24"><p align="center">排课人数</td>
      <td width="115" height="24"><p align="center">讲课周次</p></td>
      <td width="115" height="24"><p align="center">排课状态</p></td>
      <td width="60" height="34" align="center">操作</td>
      
    </tr>
    
  <%    
	    ResultSet bgRs1=null; 
		String course_nature_id="",course_category_id="",course_id="",sysid="";
		bgRs1=db.executeQuery(sql1);  
		while(bgRs1.next()){    
%>
    <tr>
      <td width="40" align="center"><%=common.idToFieidName("dict_courses","course_name",bgRs1.getString("course_id"))%></td>
      <td width="34" align="center"><%=bgRs1.getString("start_semester")%></td>
      <td width="34" align="center"><%=bgRs1.getString("teacher_name")%></td>
      <td width="34" align="center"><%=bgRs1.getString("class_name")%></td>
      <td width="34" align="center"><%=bgRs1.getString("totle")%></td>
      <td width="56" align="center"><%=bgRs1.getString("class_begins_weeks")%></td>
      <td width="34" align="center">
      <%
      	if("0".equals(bgRs1.getString("timetablestate"))){
      		out.println("未排课");
      	}else if("1".equals(bgRs1.getString("timetablestate"))){
      		out.println("已排课");
      	}else if("2".equals(bgRs1.getString("timetablestate"))){
      		out.println("漏课");
      	}
      	else if("3".equals(bgRs1.getString("timetablestate"))){
      		out.println("指定不排课");
      	}
      %></td>
      <td width="34" >
      	<div  style="margin:5px" align="center">
      		<button class="layui-btn" onclick="appoint('<%=bgRs1.getString("id") %>')">指定</button>
      		<button class="layui-btn" onclick="del('<%=bgRs1.getString("id") %>')">删除</button>
      	</div>
      </td>
    </tr>
  <%} %>
  </tbody>
</table>
           
          </div>
          
        </div>
      </div>

<script> 

/**
 * 搜索内容
 */
var search_val='<%=search_val%>';
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
	var dict_departments_id = $("#dict_departments_id").val();
	var timetablestate = $("#timetablestate").val();
	
	window.location.href="?ac=&xueqi="+xueqi+"&banji="+banji+"&zhuanye="+zhuanye+"&laoshi="+laoshi+"&dict_departments_id="+dict_departments_id+"&timetablestate="+timetablestate;
}

//导出
layui.use('table', function(){
  var table = layui.table;
  
});
function appoint(val) {
	 layer.open({
		  type: 2,
		  title: '排课指定',
		  offset: 't',//靠上打开
		  maxmin:1,
		  shade: 0.5,
		  area: ['100%', '100%'],
		  content: 'scheduling_appoint.jsp?id='+val
	});
}	
function del(id) {
	  layer.confirm("确认要删除吗，删除后不能恢复", { title: "删除确认" }, function (index) { 
          layer.close(index);
          window.location.href="?ac=deletet&delid="+id+"";   						 
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
//删除操作
if("deletet".equals(ac)){ 
	
	 String delid=request.getParameter("delid");
	 if(delid==null){delid="";}
	try{
	   String dsql="DELETE FROM arrage_coursesystem WHERE id='"+delid+"';";
		   if(db.executeUpdate(dsql)==true){
			   out.println("<script>parent.layer.msg('删除成功');window.location.replace('./scheduling_data_management.jsp');</script>");
		   }else{
			   out.println("<script>parent.layer.msg('删除失败');</script>");
		   }
	 }catch (Exception e){
	    out.println("<script>parent.layer.msg('删除失败');</script>");
	    return;
	 }
	//关闭数据与serlvet.out
	if (page != null) {page = null;}
}%>
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