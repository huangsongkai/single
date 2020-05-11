<%@ page trimDirectiveWhitespaces="true" %>
<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@page import="net.sf.json.JSONArray"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="v1.haocheok.commom.commonCourse"%>
<%@page import="java.util.Map.Entry"%>
<%@ include file="../../cookie.jsp"%>
<%
	/*获取老师列表*/
	if("teacherList".equals(ac)){
		
		
		int pages=1;
		int limit=10;
		
		if(request.getParameter("page")!=null) {pages=Integer.parseInt(request.getParameter("page"));}
		if(request.getParameter("limit")!=null){limit=Integer.parseInt(request.getParameter("limit"));}
		/*拼凑limit条件*/
		String limitSql="limit "+(pages-1)*limit+","+limit+" ;";
		
		/*拼凑sql的where 条件*/
		StringBuffer sql_where = new StringBuffer();	
		JSONObject form_datr = JSONObject.fromObject(request.getParameter("form_date").toString());
		
		 
		sql_where.append(" WHERE task.course_nature_id IS NOT NULL ");
		/*使用了搜索*/
		if(form_datr.size()>0){
			
			if(form_datr.getString("teacherName")!=null && form_datr.getString("teacherName").length()>0){/*老师姓名*/
				if(sql_where.length()<1){
					sql_where.append(" WHERE basic.teacher_name LIKE '%"+form_datr.getString("teacherName")+"%'   ");
				}else{
					sql_where.append(" AND basic.teacher_name LIKE '%"+form_datr.getString("teacherName")+"%'   ");
				}
				
			}
			if(form_datr.getString("teaching_research")!=null && form_datr.getString("teaching_research").length()>0){/*学期号*/
				if(sql_where.length()<1){
					sql_where.append(" WHERE  task.semester='"+form_datr.getString("teaching_research")+"'   ");
				}else{
					sql_where.append(" AND  task.semester='"+form_datr.getString("teaching_research")+"'   ");
				}
				
			}
			if(form_datr.getString("department")!=null && form_datr.getString("department").length()>0){/*院系*/
				if(sql_where.length()<1){
					sql_where.append(" WHERE  task.dict_departments_id='"+form_datr.getString("teaching_research")+"'   ");
				}else{
					sql_where.append(" AND  task.dict_departments_id='"+form_datr.getString("teaching_research")+"'   ");
				}
				
			}
		}
		
		
		/*返回数据*/
		JSONObject json =new JSONObject();
		JSONArray  json_arr = new JSONArray();
		
		/*计划总条数*/
		String teacherList_count_sql="SELECT COUNT(1) row FROM (SELECT count(1) row FROM teaching_task AS task RIGHT JOIN teaching_task_teacher teacher 	ON teacher.teaching_task_id = task.id LEFT  JOIN teacher_basic 	 basic 		ON basic.id=teacher.teacherid    LEFT  JOIN dict_departments 	 epart 		ON epart.id=task.dict_departments_id  LEFT  JOIN dict_course_nature    nature 	ON task.course_nature_id=nature.id    "+  sql_where+"	GROUP BY basic.teacher_name,epart.departments_name ORDER BY basic.teacher_name    )y;";
		
		int plan_num=db.Row(teacherList_count_sql);
		
		/*设置 group_concat 长度放置 数据被截取 */
		db.executeUpdate_GROUP("SET GLOBAL group_concat_max_len = 999999; ");
		
		/*教师基本信息*/
		String teacherList_sql="SELECT                                                                               "+  
								"	basic.teacher_name ,                                                              "+  
								"	epart.departments_name ,                                                          "+  
								"	GROUP_CONCAT(nature.nature SEPARATOR '|') AS nature,                                        "+  
								"	GROUP_CONCAT(IF(teacher.leixing=1,'讲课','实验') SEPARATOR '|') AS leixing,                                      "+  
								"	GROUP_CONCAT(teacher.class_begins_weeks SEPARATOR '|') AS weeks,                           "+  
								"	GROUP_CONCAT(teacher.teaching_week_time SEPARATOR '|') AS weeks_time                            "+  
								"FROM teaching_task AS task                                                           "+  
								"	RIGHT JOIN teaching_task_teacher teacher 	ON teacher.teaching_task_id = task.id "+  
								"	LEFT  JOIN teacher_basic 	 basic 		ON basic.id=teacher.teacherid             "+  
								"	LEFT  JOIN dict_departments 	 epart 		ON epart.id=task.dict_departments_id  "+  
								"	LEFT  JOIN dict_course_nature    nature 	ON task.course_nature_id=nature.id    "+  
								sql_where+  
								"	GROUP BY basic.teacher_name,epart.departments_name ORDER BY basic.teacher_name    "+
								limitSql;  
		System.out.println("teacherList_sql==="+teacherList_sql);	                                                                                        
		ResultSet rs = db.executeQuery(teacherList_sql);
		String state="";
		String sex="";
		
		
		
		while(rs.next()){
			
			/*当前老师 当前系 的上课类型总汇*/
			String [] leixingArr =rs.getString("leixing").split("\\|");
			/*当前老师 当前系 的上课周数总汇*/
			String [] class_begins_weeks =rs.getString("weeks").split("\\|");
			/*当前老师 当前系 的上课周学时总汇*/
			String [] teaching_week_time =rs.getString("weeks_time").split("\\|");
			
			/*获取课程数目相关 */
			int  curriculum =0;/*课程总数*/
			int  elective =0; /*必修*/
			int  required =0;/*选修*/
			int  limitedSelection =0;/*限选*/
			
			/*获取课时数目相关 */
			int  lectureHours =0;/*讲课学时*/
			int  experimentalHours      =0; /*实验学时*/
			int  totalHours =0;/*总学时*/
			
			/*调用数组去重方法（返回重复角标）*/
			Iterator<Entry<Object, Object>> entries = commonCourse.Arrcoot(rs.getString("nature")).entrySet().iterator();  
			
		    while (entries.hasNext()) {  
		      
		        Entry<Object, Object> entry = entries.next();  
		        
		        /*总课程数*/
		        curriculum=curriculum+JSONArray.fromObject(entry.getValue()).size();
		        
		        if("必修".equals(entry.getKey())){
		        	elective=elective+JSONArray.fromObject(entry.getValue()).size();
		        }else if("选修".equals(entry.getKey())){
		        	required=required+JSONArray.fromObject(entry.getValue()).size();
		        }else if("限选".equals(entry.getKey())){
		        	limitedSelection=limitedSelection+JSONArray.fromObject(entry.getValue()).size();
		        }
		        
		        for(int entriesLength=0;entriesLength<leixingArr.length;entriesLength++){
		        	/*学时计算  周数*周学时 */
		        	if("实验".equals(leixingArr[entriesLength])){
		        		experimentalHours=experimentalHours+(commonCourse.setWeekly(class_begins_weeks[entriesLength]).size()*Integer.parseInt(teaching_week_time[entriesLength]));
		        	}else if("讲课".equals(leixingArr[entriesLength])){
		        		lectureHours=lectureHours+(commonCourse.setWeekly(class_begins_weeks[entriesLength]).size()*Integer.parseInt(teaching_week_time[entriesLength]));
		        	}
		        	totalHours=totalHours+(commonCourse.setWeekly(class_begins_weeks[entriesLength]).size()*Integer.parseInt(teaching_week_time[entriesLength]));
		        }
		        
		    } 
			
			JSONObject json_son =new JSONObject();
			
			json_son.put("teacher_name",					rs.getString("basic.teacher_name"));
			json_son.put("departments_name",				rs.getString("epart.departments_name"));
			json_son.put("curriculum",						curriculum+"");
			json_son.put("elective",						elective+"");
			json_son.put("required",						required+"");
			json_son.put("limitedSelection",				limitedSelection+"");
			json_son.put("lectureHours",			        lectureHours+"");
			json_son.put("experimentalHours",				experimentalHours+"");
			json_son.put("totalHours",						totalHours+"");
			
			json_arr.add(json_son);
		}if(rs!=null){rs.close();}
		System.out.println(json_arr);
		json.put("code","0");
		json.put("msg","");
		json.put("count",plan_num);
		json.put("data",json_arr);
		out.print(json);
		
	if(db!=null)db.close();db=null;
	return;
	}
%>


<!DOCTYPE html> 
<html>
  <head>
    <meta charset="utf-8"> 
    <meta name="viewport" content="width=device-width, initial-scale=1"> 
    <title>教师课程门数统计</title>
    <link rel="stylesheet" href="../../../pages/css/sy_style.css">	
    <link rel="stylesheet" href="../../js/layui2/css/layui.css">
	<script type="text/javascript" src="../../js/jquery-1.9.1.js" ></script><!--通用jquery-->
	<script src="../../js/layui2/layui.js"></script>
	<script type="text/javascript" src="../../js/ajaxs.js" ></script>
  </head>
  <body>
  	<%-- 页面搜索区 --%>
  	<div id="tb" class="form_top layui-form" style="display: flex;width:1200px; float: inherit;">
	  	<form class="layui-form" style="    width: 100%;">
	  	   <div class="layui-input-inline">
				<select name="teaching_research" id="teaching_research" lay-search>
					<option value="">学年学期号</option>
					<%
						String xueqi_sql = "select academic_year from academic_year";
						ResultSet xueqi_set = db.executeQuery(xueqi_sql);
						while(xueqi_set.next()){
					%>
						<option value="<%=xueqi_set.getString("academic_year") %>" ><%=xueqi_set.getString("academic_year") %></option>
					<%}if(xueqi_set!=null){xueqi_set.close();} %>
				</select>
			</div>
	  	   	<div class="layui-input-inline">
				<select name="department" id="department" lay-search>
					<option value="">院系名称</option>
					 <%
			            //查询院系
			            String selectDsql="SELECT  DISTINCT p.dict_departments_id,d.departments_name,d.departments_name,ELT(INTERVAL(CONV(HEX(LEFT(CONVERT(d.departments_name USING gbk),1)),16,10),0xB0A1,0xB0C5,0xB2C1,0xB4EE,0xB6EA,0xB7A2,0xB8C1,0xB9FE,0xBBF7,0xBFA6,0xC0AC,0xC2E8,0xC4C3,0xC5B6,0xC5BE,0xC6DA,0xC8BB,0xC8F6,0xCBFA,0xCDDA,0xCEF4,0xD1B9,0xD4D1),'A','B','C','D','E','F','G','H','J','K','L','M','N','O','P','Q','R','S','T','W','X','Y','Z') AS PY FROM  teaching_task_class AS p, dict_departments AS d WHERE   p.dict_departments_id=d.id  ORDER BY py ASC;";
			            ResultSet yxRs = db.executeQuery(selectDsql);
			            while(yxRs.next()){
		            %>
		              	<option value="<%=yxRs.getString("dict_departments_id") %>"  ><%=yxRs.getString("py") %>-<%=yxRs.getString("departments_name") %></option>
		             <%}if(yxRs!=null){yxRs.close();} %>
				</select>
			</div>
			<div class="layui-input-inline">
			    	<input type="text" name="teacherName" required   placeholder="请输入教师姓名" autocomplete="off" class="layui-input">
			</div>
	  		<button class="layui-btn layui-btn-small  layui-btn-primary"  lay-submit lay-filter="*"  id="w_button" style="height: 35px;  color: white; background: rgb(25, 160, 148);"> <i class="layui-icon" style="color: #FFF;">&#xe615;</i> 搜索</button>
	  		<a class="layui-btn layui-btn-small  layui-btn-primary"   onclick="window.history.go(-1);"  style="height: 35px;  color: white; background: rgb(25, 160, 148);">返回上一页</a>
			<div class="layui-form-item" style=" float:  right;">
			    <a class="layui-btn"  onclick=" $('#table_control').fadeToggle();"><i class="layui-icon" style="font-size: 30px; color: #f4f6f7;">&#xe620;</i>  </a>
			    <div class="layui-form-select" style="    margin-left: 10%;">
			    	<dl class="layui-anim layui-anim-upbit" style="margin-top: -40px; " id="table_control">
			    	</dl>
			    </div>
			</div>
		</form>
	</div>
  	
  	<%-- 页面展示区 --%>
  	<table class="layui-table" lay-filter="demo" style="    margin-top: -2%;" id="test"></table>
  </body>
  <script type="text/javascript">
			/*编写表格头数据*/
		  	var tade_head=[[
					 {type:'checkbox', fixed: 'left'}
					,{field:'departments_name',  		title: '院系名称', 	sort: true}
					,{field:'teacher_name',  			title: '教师姓名', 	sort: true}
					,{field:'curriculum',  				title: '课程总数', 	sort: true}
					,{field:'elective',  				title: '必修课门数', 	sort: true}
					,{field:'required',  				title: '限选课门数', 	sort: true}
					,{field:'limitedSelection',			title: '任选课门数',	sort: true}
					,{field:'lectureHours',  			title: '讲课学时', 	sort: true}
					,{field:'experimentalHours',  		title: '实验学时', 	sort: true}
					,{field:'totalHours',  				title: '总学时', 	sort: true}
				 ]]
				/*创建控制表格显示列方法*/
				/*获取整个表头的级数*/
				var tade_head_l=tade_head.length;
				/*获取表头的最后一级数组*/
				var table_hed=tade_head[tade_head_l-1];
				/*声明保存html代码的标量*/
				var tableControl_html="";
				/*遍历当前数组*/
				for(var i=0;i<table_hed.length;i++){
					/*是否存在显示对象*/
					if(table_hed[i].field!=undefined){
							tableControl_html=tableControl_html+"<dd  class><input type=\"checkbox\" value=\""+table_hed[i].field+"\" name=\""+table_hed[i].field+"\" title=\""+table_hed[i].title+"\"  lay-filter=\"tableControl\"> </dd>";
					}
				}
				$("#table_control").html(tableControl_html);
			
	
	
			layui.use(['laypage', 'form', 'laydate', 'table'], function(){
		 		var laypage 	= layui.laypage
				  	,layer 		= layui.layer
				  	,table 		= layui.table
				  	,laydate 	= layui. laydate
				  	,form 		= layui.form;
				var field={};
				 form.on('submit(*)', function(data){
		  			field=data.field;
				  	
				  	table.reload('test', {
					  url: '?ac=teacherList&form_date='+JSON.stringify(field)
					});
				  	return false;	
				 }); 	
				/*定义表格*/
				table.render({
				    elem: '#test'
				    ,url:'?ac=teacherList&form_date='+JSON.stringify(field)
				    ,page:true
				    ,minWidth:80
				    ,cellMinWidth: 100 //全局定义常规单元格的最小宽度，layui 2.2.1 新增
				    ,cols: tade_head
				});
	  
			  	/*渲染select*/
			  	form.render('select');
			  	form.render('checkbox');
	
				 
				/*监听表头控制*/
				form.on('checkbox(tableControl)', function(data){
				 	if(data.elem.checked){/*隐藏*/
				 		$("th[data-field="+data.value+"]").css("display","none");
				 		$("td[data-field="+data.value+"]").css("display","none");
				 	}else{/*显示*/
				 		$("th[data-field="+data.value+"]").removeAttr("style");
				 		$("td[data-field="+data.value+"]").removeAttr("style");
				 	}
				}); 
				
			}); 
			
			/*刷新*/
			function shuaxin(){
				 location.reload();
			}	
	</script>
</html>


<%
	/*插入常用菜单日志*/
	int   TagMenu=db.Row("SELECT COUNT(*) as row FROM  menu_worker  WHERE sysmenuid='"+PMenuId+"' and  workerid='"+Suid+"' and  companyid="+Scompanyid);
	if(TagMenu==0){
  		db.executeUpdate("INSERT INTO `menu_worker`(`sysmenuid`,`workerid`,`countes`,`companyid`) VALUES ('"+PMenuId+"','"+Suid+"','1','"+Scompanyid+"');"); 
	}else{
		db.executeUpdate("UPDATE  `menu_worker` SET `countes`=countes+1,`usetime`=now() WHERE  sysmenuid='"+PMenuId+"' and  workerid='"+Suid+"' and  companyid="+Scompanyid);
	}
	if(db!=null)db.close();db=null;if(server!=null)server=null;
%>