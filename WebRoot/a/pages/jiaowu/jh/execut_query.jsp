<%@ page trimDirectiveWhitespaces="true" %>
<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@page import="v1.haocheok.commom.common"%>
<%@page import="service.dao.db.Page"%>
<%@page import="javax.annotation.Resource"%>
<%@page import="net.sf.json.JSONArray"%>
<%@page import="net.sf.json.JSONObject"%>
<%@include file="../../cookie.jsp"%>


<%	
		/*查询--》表格表头 */
		if("table".equals(ac)){
		
			/*获取请求数据*/
			JSONObject form_datr = JSONObject.fromObject(request.getParameter("form_date").toString());
			
			StringBuffer sql_where01 = new StringBuffer();
			
			if(form_datr.getString("course_name")!=null && form_datr.getString("course_name").length()>0){
				sql_where01.append(" AND (dic_cour.course_name='"+form_datr.getString("course_name")+"' or  dict_process_symbol.process_symbol_name='"+form_datr.getString("course_name")+"'  )   ");
			}
			if(form_datr.getString("course_code")!=null && form_datr.getString("course_code").length()>0){
				sql_where01.append(" AND dic_cour.course_code='"+form_datr.getString("course_code")+"'   ");
			}
			if(form_datr.getString("course_nature")!=null && form_datr.getString("course_nature").length()>0){/*课程类别*/
				sql_where01.append(" AND dic_nature.id='"+form_datr.get("course_nature")+"'   ");
			}
			if(form_datr.getString("course_category")!=null && form_datr.getString("course_category").length()>0){/*课程性质*/
				sql_where01.append(" AND dic.id='"+form_datr.get("course_category")+"'   ");
			
			}
			if(form_datr.getString("start_semester")!=null && form_datr.getString("start_semester").length()>0){/*学期数*/
				sql_where01.append("  AND (start_semester"+form_datr.getString("start_semester")+" <> '' OR start_semester1 <> NULL)   "); 
			}
			
			StringBuffer sql_order = new StringBuffer();
			/*排序*/
			if(form_datr.getString("condition_sort")!=null && form_datr.getString("condition_sort").length()>0){/*按照学期数*/
				if("1".equals(form_datr.getString("condition_sort"))){
					sql_order.append("  ORDER BY start_semester1 DESC   ");
				}else if("2".equals(form_datr.getString("start_semester"))){
					sql_order.append("  ORDER BY tea.course_category_id DESC   "); 
				}else{
					sql_order.append("  ORDER BY tea_course_nature_id DESC   ");  
				}
			}
			/*返回数据*/
			JSONObject json =new JSONObject();
			
			int nz=0;	/*年制*/								
			int school_year=0; /*开学年*/									
		    String nz_sql="select eductional_systme_id,school_year from major where id='"+form_datr.get("major_id")+"';";
			ResultSet nz_rs = db.executeQuery(nz_sql);
			if(nz_rs.next()){
				 nz=nz_rs.getInt("eductional_systme_id");
				school_year=nz_rs.getInt("school_year");
			}if(nz_rs!=null){nz_rs.close();}
		
			/*表头的学年*/
			StringBuffer thead_nz=new StringBuffer();
			for(int j=1;j<=nz;j++){
				thead_nz.append("<th class='th' colspan='2'>"+school_year+"学年-"+(school_year+1)+"学年</th>");
				school_year=(school_year+1);
			}
			/*表头的学期*/
			StringBuffer thead_xq=new StringBuffer();
			for(int j=1;j<=(nz*2);j++){
				thead_xq.append("<th class='th' >"+j+"</th>");
			}
			
						
			/*计划总条数*/
			String plan_num_sql="select count(1) row  from teaching_plan tea  "+
														"LEFT JOIN teaching_plan_class tea_class  ON tea_class.id=tea.teaching_plan_class_id "+
														"LEFT JOIN dict_course_category dic       ON dic.id=tea.course_category_id  "+
														"LEFT JOIN dict_course_nature dic_nature  ON dic_nature.id=tea.course_nature_id  "+
														"LEFT JOIN dict_courses dic_cour          ON dic_cour.id=tea.course_id  "+
														"LEFT JOIN dict_process_symbol            ON dict_process_symbol.id = tea.process_id							"+
													" WHERE "+
														"tea_class.dict_departments_id='"+form_datr.get("dict_departments_id")+"' "+
														"AND tea_class.major_id='"+form_datr.get("major_id")+"' "+
														"AND tea_class.school_year='"+form_datr.get("schoolYear")+"'  "+
														"AND tea_class.state_approve_id='7' "+
														sql_where01.toString();
			int plan_num=db.Row(plan_num_sql);
			
			String where_sql=" AND tea_class.dict_departments_id='"+form_datr.get("dict_departments_id")+"' AND  tea_class.major_id='"+form_datr.get("major_id")+"' AND tea_class.school_year='"+form_datr.get("schoolYear")+"'  AND tea_class.state_approve_id='7' "+ sql_where01.toString() ;
			
			String sql="SELECT "+
							"tea.course_nature_id                       AS tea_course_nature_id,          "+
							"tea_class.id 						        AS plan_id,                       "+
							"dic.category 						        AS category,                      "+
							"dic_nature.nature 					        AS nature,                        "+
							"dic_cour.course_name 				        AS course_name,                   "+
							"dic_cour.course_code 				        AS course_code,                   "+
							"tea.total_classes 					        AS total_classes,                 "+
							"tea.lecture_classes 				        AS lecture_classes,               "+
							"tea.class_in 						        AS class_in,                      "+
							"tea.extracurricular_practice_hour          AS extracurricular_practice_hour, "+
							"tea.test_semester 					        AS test_semester,                 "+
							"tea.check_semester 				        AS check_semester,                "+
							"tea.start_semester1 				        AS start_semester1,               "+
							"tea.start_semester2 				        AS start_semester2,               "+
							"tea.start_semester3 				        AS start_semester3,               "+
							"tea.start_semester4                        AS start_semester4,               "+
							"tea.start_semester5                        AS start_semester5,               "+
							"tea.start_semester6                        AS start_semester6,               "+
							"tea.start_semester7                        AS start_semester7,               "+
							"tea.start_semester8                        AS start_semester8,               "+
							"tea.start_semester9                        AS start_semester9,               "+
							"tea.start_semester10                       AS start_semester10,              "+
							"tea.weeks as weeks "+
					   "FROM   "+
							"teaching_plan tea  "+
							"LEFT JOIN teaching_plan_class tea_class    ON tea_class.id=tea.teaching_plan_class_id  "+
							"LEFT JOIN dict_course_category dic         ON dic.id=tea.course_category_id            "+
							"LEFT JOIN dict_course_nature dic_nature    ON dic_nature.id=tea.course_nature_id       "+
							"LEFT JOIN dict_courses dic_cour            ON dic_cour.id=tea.course_id                "+
							"LEFT JOIN dict_process_symbol              ON dict_process_symbol.id = tea.process_id	"+
					  "WHERE courserprocess = 0  "+where_sql+
					  "UNION ALL				 "+					
					  "SELECT                    "+
					        "tea.course_nature_id                       AS tea_course_nature_id,          "+
					  		"tea_class.id                      			AS plan_id,                       "+
					  		"dic.category 								AS category,                      "+
					  		"dic_nature.nature 							AS nature,                        "+
					  		"dict_process_symbol.process_symbol_name 	AS course_name,                   "+
					  		"'' 										AS course_code,                   "+
					  		"tea.total_classes 							AS total_classes,                 "+
					  		"tea.lecture_classes 						AS lecture_classes,               "+
					  		"tea.class_in 								AS class_in,                      "+
					  		"tea.extracurricular_practice_hour 			AS extracurricular_practice_hour, "+
					  		"tea.test_semester 							AS test_semester,                 "+
					  		"tea.check_semester 						AS check_semester,                "+
					  		"tea.start_semester1                        As start_semester1,               "+
					  		"tea.start_semester2                        As start_semester2,               "+
					  		"tea.start_semester3                        As start_semester3,               "+
					  		"tea.start_semester4                        As start_semester4,               "+
					  		"tea.start_semester5                        As start_semester5,               "+
					  		"tea.start_semester6                        As start_semester6,               "+
					  		"tea.start_semester7                        As start_semester7,               "+
					  		"tea.start_semester8                        As start_semester8,               "+
					  		"tea.start_semester9                        As start_semester9,               "+
					  		"tea.start_semester10 						AS start_semester10,              "+
					  		"tea.weeks as weeks                                                           "+
					  "FROM  "+
						      "teaching_plan tea  "+
					          "LEFT JOIN teaching_plan_class tea_class  ON tea_class.id = tea.teaching_plan_class_id                        "+
					          "LEFT JOIN dict_course_category dic       ON dic.id = tea.course_category_id                                  "+
					          "LEFT JOIN dict_course_nature dic_nature  ON dic_nature.id = tea.course_nature_id                             "+
					          "LEFT JOIN dict_process_symbol            ON dict_process_symbol.id = tea.process_id							"+
					          "LEFT JOIN dict_courses dic_cour          ON dic_cour.id=tea.course_id                                        "+
					  "WHERE    courserprocess = 1   "+where_sql+
					  sql_order+
					  "limit "+(form_datr.getInt("page")-1)*form_datr.getInt("limit")+","+form_datr.getInt("limit")+" ";
			
			System.out.println(sql);
			ResultSet rs = db.executeQuery(sql);
			
			/**/
			String plan_class_id="";
			
			int total_classes=0;/*课程总学时数*/
			int lecture_classes=0;/*理论教学时数*/
			int class_in=0;/*课内*/
			int extracurricular_practice_hour=0;/*独立设置*/
			JSONObject start_semester_json = new JSONObject();/*存放所有学期的总计*/
			
			/*表体数据结构*/
			StringBuffer tbody = new  StringBuffer();
			while(rs.next()){
			    plan_class_id=rs.getString("plan_id");
				StringBuffer start_semester = new StringBuffer();
				for(int i=1;i<=(nz*2);i++){
					int temporary=0; //临时变量
					try {
						temporary=start_semester_json.getInt(""+i+"");
					} catch (Exception e) {
						temporary=0;
					}
					
					start_semester_json.put(""+i+"",(temporary+rs.getInt("start_semester"+i)));
					start_semester.append("<td >"+rs.getString("start_semester"+i)+"</td>");
				}
				tbody.append(
					"<tr>"+
					
					    "<td >"+rs.getString("nature")+"</td>"+/*课程类别*/
					    "<td >"+rs.getString("category")+"</td>"+/*课程性质*/
					    "<td >"+rs.getString("course_name")+"</td>"+/*课程名称*/
					    "<td >"+rs.getString("course_code")+"</td>"+/*课程编号*/
					    "<td >"+rs.getInt("total_classes")+"</td>"+/*课程总学时数*/
					    "<td >"+rs.getInt("lecture_classes")+"</td>"+/*理论教学时数*/
					    "<td >"+rs.getInt("class_in")+"</td>"+/*课内*/
					    "<td >"+rs.getInt("extracurricular_practice_hour")+"</td>"+/*独立设置*/
					    "<td >"+rs.getString("test_semester")+"</td>"+/*考试学期*/
					    "<td >"+rs.getString("check_semester")+"</td>"+/*考查学期*/
					    start_semester.toString()+/*学期周课时*/
					    "<td >"+rs.getString("weeks")+"</td>"+/*开课周次*/
					    "<td >*</td>"+/*操作*/
					"<tr>"
				);
				total_classes=total_classes+rs.getInt("total_classes");
				lecture_classes=lecture_classes+rs.getInt("lecture_classes");
				class_in=class_in+rs.getInt("class_in");
				extracurricular_practice_hour=extracurricular_practice_hour+rs.getInt("extracurricular_practice_hour");
			}if(rs!=null){rs.close();}
			
			/*将总计转换成html*/
			StringBuffer start_semester_html = new StringBuffer();
			for(int i=1;i<=(nz*2);i++){
					try {
						start_semester_html.append("<td class='ztd'>"+start_semester_json.getString(""+i+"")+"</td>");
					} catch (Exception e) {
						start_semester_html.append("<td class='ztd'>0</td>");
					}
					
				
			}
			
			tbody.append(
					"<tr>"+
 
						"<td class='ztd'   colspan='4' >总计</td>"+/*课程性质*//*课程类别*//*课程名称*//*课程编号*/
					    "<td class='ztd'>"+total_classes+"</td>"+/*课程总学时数*/
					    "<td class='ztd'>"+lecture_classes+"</td>"+/*理论教学时数*/
					    "<td class='ztd'>"+class_in+"</td>"+/*课内*/
					    "<td class='ztd'>"+extracurricular_practice_hour+"</td>"+/*独立设置*/
					    "<td class='ztd'>*</td>"+/*考试学期*/
					    "<td class='ztd'>*</td>"+/*考查学期*/ 
					    start_semester_html.toString()+
					    "<td class='ztd'>*</td>"+/*开课周次*/
					    "<td class='ztd'>*</td>"+/*操作*/
					"<tr>"
				);
			
			
			/*表格头学期开课周次 weeks*/
			StringBuffer thead_weeks=new StringBuffer();
			String weekly="select semester_weekly1,semester_weekly2,semester_weekly3,semester_weekly4,semester_weekly5,semester_weekly6,semester_weekly7,semester_weekly8,semester_weekly9,semester_weekly10 from teaching_plan_class where id='"+plan_class_id+"' ";
			ResultSet wee_rs= db.executeQuery(weekly);
			if(wee_rs.next()){
				for(int i=1;i<=(nz*2);i++){
					thead_weeks.append("<th class='th' >"+wee_rs.getString("semester_weekly"+i)+"</th>");
				}
			}if(wee_rs!=null){wee_rs.close();}
			
			
			/*设置表头*/
			StringBuffer thead = new StringBuffer();
			thead.append(
						"<tr>                                                	"+
						"  <th class='th' rowspan='4'>课程性质</th>           	"+
						"  <th class='th' rowspan='4'>课程类别</th>           	"+
						"  <th class='th' rowspan='4'>课程名称</th>           	"+
						"  <th class='th' rowspan='4'>课程编号</th>      			"+
						"  <th class='th' colspan='4'>学时数</th>              	"+
						"  <th class='th' rowspan='4'>考试学期</th>            	"+
						"  <th class='th' rowspan='4'>考查学期</th>              "+
						"  <th class='th' colspan='"+(nz*2)+"'>开课学期</th>              "+
						"  <th class='th' rowspan='4'>开课周次</th>              "+
						"  <th class='th' rowspan='4'>操作</th>                	"+
						"</tr>                                               	"+
						"<tr>                                                	"+
						"  <th class='th' rowspan='3'>课程总学时数</th>        	"+
						"  <th class='th' rowspan='3'>理论教学时数</th>        	"+
						"  <th class='th' colspan='2'>实践教学</th>              "+
						thead_nz.toString()+
						"</tr>                                               	"+
						"<tr>                                                	"+
						"  <th class='th' rowspan='2'>课内</th>                	"+
						"  <th class='th' rowspan='2'>独立设置</th>              "+
						thead_xq.toString()+
						"</tr>                                               	"+
						"<tr>                                                	"+
						thead_weeks.toString()+
						"</tr>                                               	"
					);
			
			
		
			json.put("code","0");	
			json.put("thead",thead.toString());	
			json.put("tbody",tbody.toString());	
			json.put("plan_num",plan_num);	
		
			out.println(json.toString());
		    if(db!=null)db.close();db=null;
			return;
	 }
%>


<%	
		/*查询--》院系相关的--》专业名称 */
		if("select_major".equals(ac)){
			String major=request.getParameter("id");
			ResultSet major_rs =  db.executeQuery("SELECT id,major_name FROM  major WHERE  departments_id='"+major+"'; ");
			StringBuffer major_html = new  StringBuffer();
			major_html.append("<option value=\"\">请选择专业</option>");
			while(major_rs.next()){
				major_html.append("<option value=\""+major_rs.getString("id")+"\">"+major_rs.getString("major_name")+"</option>");
			}if(major_rs!=null){major_rs.close();}
			out.println(major_html.toString());
			if(db!=null)db.close();db=null;
			return;
		}
%>
<!DOCTYPE html> 
<html>
  <head>
	    <meta charset="utf-8"> 
	    <meta name="viewport" content="width=device-width, initial-scale=1"> 
	    <title><%=Mokuai %></title>
        <link rel="stylesheet" href="../../../pages/css/sy_style.css">	    
	    <link rel="stylesheet" href="../../js/layui2/css/layui.css">
	    <script src="../../js/layui2/layui.js"></script>
		<script type="text/javascript" src="../../js/jquery-1.9.1.js" ></script><!--通用jquery-->
		<script type="text/javascript" chartset="utf8" src="../../js/tableExport/js/table_list.js " ></script><!--表格导出js  css-->
		<script src="../../js/ajaxs.js"></script>
		<style type="text/css">
			.myinput {BACKGROUND-COLOR: #e6f3ff; BORDER-BOTTOM: #ffffff 1px groove; BORDER-LEFT: #ffffff 1px groove; BORDER-RIGHT: #ffffff 1px groove; BORDER-TOP: #ffffff 1px groove; COLOR: #000000; FONT: 24px Verdana,Geneva,sans-serif; HEIGHT: 36px; WIDTH: 60px"}
		    .btn-group-vertical>.btn, .btn-group>.btn{height:33px;}
	       #w_span_one {    color: forestgreen;}
	       .w_span_one{padding:0 9px  !important;}
	      
		</style>
  </head>
  <body>
		<div class="" style="padding-bottom: 0px;margin-left: 1%;margin-right: 1%; height:auto;">
			<%-- 页面搜索实现区 --%>
			<form class="layui-form"  action="">
				<div id="tb" class="form_top layui-form" style="display: flex;  ">
				   <!-- 院系名称  -->
				   <div>
					   <select name="dict_departments_id" id="dict_departments_id" lay-verify="required"  lay-filter="dict_departments" >
			               <option value="">请选择院系</option>
				            <%
				            /*查询院系*/
				            String selectDsql="SELECT  DISTINCT p.dict_departments_id,d.departments_name,d.departments_name,ELT(INTERVAL(CONV(HEX(LEFT(CONVERT(d.departments_name USING gbk),1)),16,10),0xB0A1,0xB0C5,0xB2C1,0xB4EE,0xB6EA,0xB7A2,0xB8C1,0xB9FE,0xBBF7,0xBFA6,0xC0AC,0xC2E8,0xC4C3,0xC5B6,0xC5BE,0xC6DA,0xC8BB,0xC8F6,0xCBFA,0xCDDA,0xCEF4,0xD1B9,0xD4D1),'A','B','C','D','E','F','G','H','J','K','L','M','N','O','P','Q','R','S','T','W','X','Y','Z') AS PY FROM  teaching_plan_class AS p, dict_departments AS d WHERE   p.dict_departments_id=d.id  ORDER BY py ASC;";
				            ResultSet yxRs = db.executeQuery(selectDsql);
				            while(yxRs.next()){
				            %>
				            <option value="<%=yxRs.getString("dict_departments_id") %>"  <%/*if(yxRs.getString("dict_departments_id").equals(dict_departments_id)){out.print("selected=\"selected\"");} */%>><%=yxRs.getString("py") %>-<%=yxRs.getString("departments_name") %></option>
				            <%}if(yxRs!=null){yxRs.close();}%>
			            </select>
		            </div>
		            <div class="layui-form-mid layui-word-aux">*</div>
		            
		            <!-- 专业名称  -->
		            <div>
			            <select name="major_id"  id="college_major" lay-verify="required"  lay-filter="college_major" >
			               	<option value="">请选择专业</option>
			            </select>
			        </div>
		            <div class="layui-form-mid layui-word-aux" style="color: red">*</div>
		            
		            <!-- 入学年份  -->
		            <div class="layui-inline">
				      <div class="layui-input-inline">
				        <input type="text" class="layui-input" name="schoolYear" id="schoolYear" placeholder="入学年份" lay-verify="required" value="">
				      </div>
				    </div>
				    <div class="layui-form-mid layui-word-aux">*</div>
				    
		        </div>
		        <%--↓↓↓↓↓↓页面功能展示↓↓↓↓↓↓--%>
		        <div style="float:right; margin: 0.45%;">
		            <div id="asc" class=" layui-form" style="display: flex;    float: right;">
				        <div class="layui-inline">
							    <div class="layui-input-inline" >
							      <select name="gender" lay-verify="required"  lay-filter="Export">
							        <option value="请选择格式" selected="">请选择导出格式</option>
							        <option value="XLS"> XLS </option>
							        <option value="XLSX"> XLSX </option>
							      </select>
							    </div>
						</div>
				    </div>
		             <a class="layui-btn layui-btn-small  layui-btn-primary" onclick="shuaxin()" style="height: 35px;  color: white; background: rgb(25, 160, 148);"> <i class="layui-icon" style="color: #FFF;">ဂ</i> 刷新</a>
			       	 <a class="layui-btn layui-btn-small  layui-btn-primary " onclick="help(<%=PMenuId %>)" style="height: 35px;  color:#A9A9A9; background: rgb(245, 245, 245);"><i class="layui-icon"></i>帮助</a>
	           	</div>
	           	<%--↑↑↑↑↑↑页面功能展示↑↑↑↑↑↑ --%>
		        <div id="tb" class="form_top layui-form" style="display: flex;">
		            <!-- 课程性质   dict_course_nature-->
		            <select name="course_nature"  >
		               	<option value="">全部课程性质</option>
		               	<% 
		               		ResultSet course_nature_rs=db.executeQuery("SELECT id,nature FROM  dict_course_nature");
		               		while(course_nature_rs.next()){
		                		out.println("<option value=\""+ course_nature_rs.getString("id") +"\">"+ course_nature_rs.getString("nature") +"</option>");	
		               		}if(course_nature_rs!=null){course_nature_rs.close();}
		               	%>
		            </select>
		            <!-- 课程类别  dict_course_category-->
		            <select name="course_category"   >
		               	<option value="">全部课程类别</option>
		               	<% 
		               		ResultSet course_category_rs=db.executeQuery("SELECT id,category FROM  dict_course_category");
		               		while(course_category_rs.next()){
		                		out.println("<option value=\""+ course_category_rs.getString("id") +"\">"+ course_category_rs.getString("category") +"</option>");	
		               		}if(course_category_rs!=null){course_category_rs.close();}
		               	%>
		            </select>
		            <!-- 开课学期  -->
		            <select name="start_semester" >
		               	<option value="">全部开课学期</option>
		               	<% 
		               		for(int i=1;i<=14;i++){	
		               			out.println("<option value=\""+ i +"\">"+ i +"</option>");	
		               		}
		               	%>
		            </select>
		            <!-- 课程名称  -->
		           	<label class="layui-form-label">课程名称</label> <input name="course_name" type="text" class="layui-input textbox-text" placeholder="输入课程名称" value="" style="width: 125px; height: 35px; color: #272525; background: rgb(227, 227, 227);">
		            <!-- 课程编码  -->
		            <label class="layui-form-label">课程编码</label><input name="course_code"  type="text" class="layui-input textbox-text" placeholder="输入课程编码" value="" style="width: 125px; height: 35px; color: #272525; background: rgb(227, 227, 227);">
		            <!-- 排序方式  -->
		            <select name="condition_sort">
		               	<option value="1">按开课学期排序</option>
		               	<option value="2">按课程性质排序</option>
		               	<option value="3">按开课类别排序</option>
		            </select>
		            
		            <button class="layui-btn" lay-submit lay-filter="statistics">查询</button>
			    </div>
			</form>
		    <!-- 页面表格展示实现区 -->
			<div  style="display:block;clear:both;">
				<!-- test --> 
				<div id="table">
					<table class="layui-table tb tb-b c-100 c-t-center "  id="table-w">
						<thead id="theads">

						</thead>
						<tbody id="tbodys">
							
						</tbody>
					</table>
				</div>
				<div id="pages"></div>
	        </div>
        </div>
  </body>
  <script> 
  	
		layui.use(['laypage', 'form', 'laydate', 'table'], function(){
				  var laypage = layui.laypage
				  ,layer = layui.layer
				  ,table = layui.table
				  ,laydate = layui. laydate
				  ,form = layui.form;
				  
				  
				  /*年选择器*/
				  laydate.render({elem: '#schoolYear' ,type: 'year' ,value: '2018'});
				  
				  /*监控select -[院系]*/
				  form.on('select(dict_departments)', function(data){
				  		/*选中有效值*/
				  		if(data.value!=0){
				  			var college_major_option=PostAjx("?ac=select_major&id="+data.value,"","","");
				  			$("#college_major").html(college_major_option);
				  			form.render('select');
				  		} 
				 }); 
				 
				 /*表格样式重载*/
				 function table_style(){
					  $(".th").css("text-align","center");
				  	  $(".th").css("font-size","12px");
				  	  $(".th").css("font-weight","bold");
			 		 
			 		  $(".ztd").css("color","#ef0a13");
				  	  $(".ztd").css("text-align","center");
				  	  $(".ztd").css("font-size","20px");
				  	  $(".ztd").css("font-weight","bold");
				 }
				 
				 /*查询统计 */
				 form.on('submit(statistics)', function(data){
				 
				 	/*获取表格数据*/
				 	var field=data.field;
				 	
				 	field.page="1";  /*默认页数*/
				 	field.limit="10";/*默认每页条数*/
				 	
				 	
				 	var return_date=$.parseJSON(PostAjx("?ac=table&form_date="+JSON.stringify(field),"","",""));
				 	if(return_date.code==0){
					 	  $("#theads").html(return_date.thead); 
					  	  $("#tbodys").html(return_date.tbody);
					  	  <%--因为表格是后加载的样式要重置--%>
					  	  table_style();
				 	
				 	   	  /*分页 */
					 	  laypage.render({
							    elem: 'pages'
							    ,count: return_date.plan_num
							    ,limit:10
							    ,limits:[10,20,30,40,50,60,70,80,90,100]/*分页开启模式定义*/
							    ,layout: ['count', 'prev', 'page', 'next', 'limit', 'skip']
							    ,jump: function(obj, first){
								    field.page=obj.curr;  /*当前页数*/
					 				field.limit=obj.limit;/*当前每页条数*/
							    	if(!first){<%--首次不执行--%>
							    		var return_date=$.parseJSON(PostAjx("?ac=table&form_date="+JSON.stringify(field),"","",""));
							    		if(return_date.code==0){
										 	  $("#theads").html(return_date.thead); 
										 	  $("#tbodys").html(return_date.tbody);
											   <%--因为表格是后加载的样式要重置--%>
										  	  table_style();
										  	 
									  	 }else{
									  	 	  layer.msg("获取数据异常");
									  	 }
									}
						    	}
						  });	
				 	}else{
				  	 	  layer.msg("获取数据异常");
				  	}
				    return false;
				 });
				
				  
		});	
		
		
		/*帮助页面*/
		function help(val) {
			 layer.open({
				  type: 2,
				  title: '帮助页面',
				  offset: 't',/*靠上打开*/
				  shadeClose: true,
				  maxmin:1,
				  shade: 0.5,
				  area: ['780px', '100%'],
				  content: '../../syst/help.jsp?id='+val
			});
		}
		
		/*刷新*/
		function shuaxin(){
			 location.reload();
		}
				
	</script> 
</html>
<%
		/*插入常用菜单日志 */
		int  TagMenu=db.Row("SELECT COUNT(*) as row FROM  menu_worker  WHERE sysmenuid='"+PMenuId+"' and  workerid='"+Suid+"' and  companyid="+Scompanyid);
		
		if(TagMenu==0){ 
			db.executeUpdate("INSERT INTO `menu_worker`(`sysmenuid`,`workerid`,`countes`,`companyid`) VALUES ('"+PMenuId+"','"+Suid+"','1','"+Scompanyid+"');"); 
		}else{         
			db.executeUpdate("UPDATE  `menu_worker` SET `countes`=countes+1,`usetime`=now() WHERE  sysmenuid='"+PMenuId+"' and  workerid='"+Suid+"' and  companyid="+Scompanyid);
		}
		long TimeEnd=Calendar.getInstance().getTimeInMillis();
		
		System.out.println("执行时间"+ (TimeEnd-TimeStart)+"ms");
		
		if(db!=null)db.close();db=null;if(server!=null)server=null;
%>
