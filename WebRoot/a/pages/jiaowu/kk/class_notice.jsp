<%@ page trimDirectiveWhitespaces="true" %>
<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@page import="v1.haocheok.commom.common"%>
<%@page import="service.dao.db.Page"%>
<%@page import="javax.annotation.Resource"%>
<%@page import="net.sf.json.JSONArray"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="v1.haocheok.commom.commonCourse"%>
<%@include file="../../cookie.jsp"%>
<%@page import="org.apache.commons.lang3.StringUtils"%>


<%
	/*获取表格数据*/
	if("acSelect".equals(ac)){
		
		
		int pages=1;
		int limit=10;
		
		if(request.getParameter("page")!=null){pages=Integer.parseInt(request.getParameter("page"));}
		if(request.getParameter("limit")!=null){limit=Integer.parseInt(request.getParameter("limit"));}
		
		/*拼凑sql的where 条件*/
		StringBuffer sql_where = new StringBuffer();	
		JSONObject form_datr = JSONObject.fromObject(request.getParameter("form_date").toString());
		/*使用了搜索*/
		if(form_datr.size()>0){
			if(form_datr.getString("academic_year")!=null && form_datr.getString("academic_year").length()>0 && !form_datr.getString("academic_year").equals("0")){/*学期号*/
				sql_where.append(" AND teaching_task.semester='"+form_datr.getString("academic_year")+"'   ");
			}
			if(form_datr.getString("dict_departments_id")!=null && form_datr.getString("dict_departments_id").length()>0 && !form_datr.getString("dict_departments_id").equals("0")){/*院系id*/
				sql_where.append("  AND teaching_task.dict_departments_id='"+form_datr.getString("dict_departments_id")+"'   ");
			}
			if(form_datr.getString("laoshi")!=null && form_datr.getString("laoshi").length()>0 && !form_datr.getString("laoshi").equals("0")){/*老师*/
				if("无".equals(form_datr.getString("laoshi"))){
					sql_where.append("  AND (teaching_task_teacher.teacherid IS NULL OR teaching_task_teacher.teacherid=0) ");
				}else{
					sql_where.append(" AND teaching_task_teacher.teacherid='"+form_datr.getString("laoshi")+"'   ");
				}
			}
			
			if(form_datr.getString("jiaoyanshi")!=null && form_datr.getString("jiaoyanshi").length()>0 && !form_datr.getString("jiaoyanshi").equals("0")){/*教研室*/
				sql_where.append(" AND dict_courses.teaching_research_id='"+form_datr.get("jiaoyanshi")+"'   ");
			}
			if(form_datr.getString("zhuanye")!=null && form_datr.getString("zhuanye").length()>0 && !form_datr.getString("zhuanye").equals("0")){/*专业*/
				sql_where.append(" AND teaching_task.major_id='"+form_datr.get("zhuanye")+"'   ");
			}
			if(form_datr.getString("banji")!=null && form_datr.getString("banji").length()>0 && !form_datr.getString("banji").equals("0")){/*班级*/
				sql_where.append(" AND teaching_task.class_id='"+form_datr.get("banji")+"'   ");
			}
		}
		
		/*返回数据*/
		JSONObject json =new JSONObject();
		JSONArray  json_arr = new JSONArray();
		/*计划总条数*/
		String plan_num_sql="SELECT	  count(1) row	FROM teaching_task   LEFT JOIN teaching_task_teacher ON ( teaching_task.id = teaching_task_id and teaching_task_teacher.state=1)		 LEFT JOIN teacher_basic    ON teaching_task_teacher.teacherid = teacher_basic.id  LEFT JOIN dict_courses     ON teaching_task.course_id = dict_courses.id	  LEFT JOIN marge_class      ON teaching_task.marge_class_id = marge_class.id WHERE    typestate=2	AND   marge_state = 0  "+ sql_where+" order by teaching_task.id DESC;  ";
		
		int plan_num=db.Row(plan_num_sql);
		
	 	common common=new common();
	 	String sql = "SELECT *,"+
	 					"		teaching_task_teacher.teacherid as teacher_id,		"+
			        	"		marge_class.class_grade_number as class_grade_numberssss	"+
				        "FROM teaching_task                                                  "+
				        "		LEFT JOIN teaching_task_teacher ON ( teaching_task.id = teaching_task_id and teaching_task_teacher.state=1)"+
				        "	  LEFT JOIN teacher_basic    ON teaching_task_teacher.teacherid = teacher_basic.id "+
				        "	  LEFT JOIN dict_courses     ON teaching_task.course_id = dict_courses.id	"+
				        "	  LEFT JOIN marge_class      ON teaching_task.marge_class_id = marge_class.id "+
				        "WHERE "+ 
				        "    typestate=2	AND "+
				        "    marge_state = 0		 "+
				        sql_where+
				        "    order by teaching_task.id DESC "+
				        " limit "+(pages-1)*limit+","+limit+" ;";
		System.out.println("草泥马===="+sql);
		ResultSet bgRs1=null; 
        String course_nature_id="",course_category_id="",course_id="",sysid="";
   		bgRs1=db.executeQuery(sql);  //一级循环
   		String class_name = "";		//班级名称
   		String teacher_name = "";		//教师姓名
   		int shangkerenshu = 0;	//上课人数
		while(bgRs1.next()){    
		          JSONObject json_son =new JSONObject();
		        	  String marge_name = bgRs1.getString("marge_name");
		  			if(marge_name!=null){
		  				class_name = marge_name;
		  				shangkerenshu = bgRs1.getInt("class_grade_numberssss");
		  			}else{
		  				class_name = common.idToFieidName("class_grade","class_name",bgRs1.getString("class_id"));
		  				shangkerenshu =0; 
		  				String people_number_nan = common.idToFieidName("class_grade","people_number_nan",bgRs1.getString("class_id")); 
		  				String people_number_woman =common.idToFieidName("class_grade","people_number_woman",bgRs1.getString("class_id")); 
		  				if(StringUtils.isBlank(people_number_nan)){
		  					people_number_nan="0";
		  				}
		  				if(StringUtils.isBlank(people_number_woman)){
		  					people_number_woman="0";
		  				}
		  				shangkerenshu = Integer.parseInt(people_number_nan) + Integer.parseInt(people_number_woman);
		  			}
		
				json_son.put("id",                            bgRs1.getString("teaching_task.id"));
				json_son.put("semester",                      bgRs1.getString("teaching_task.semester") );
				json_son.put("course_code",                   common.idToFieidName("dict_courses","course_code",bgRs1.getString("course_id")));
				json_son.put("course_name",                   common.idToFieidName("dict_courses","course_name",bgRs1.getString("course_id")));
				json_son.put("check_semester",                bgRs1.getString("check_semester"));
				json_son.put("test_semester",                 bgRs1.getString("test_semester"));
				json_son.put("course_nature_id",              common.idToFieidName("dict_course_nature","nature",bgRs1.getString("course_nature_id")));
				json_son.put("course_category_id",            common.idToFieidName("dict_course_category","category",bgRs1.getString("course_category_id")));
				json_son.put("dict_departments_id",            common.idToFieidName("dict_departments","departments_name",bgRs1.getString("dict_departments_id")));
				json_son.put("teacher_name",                    bgRs1.getString("teacher_name"));
				json_son.put("class_name",                    class_name);
				json_son.put("start_semester",				  bgRs1.getString("start_semester"));
				json_son.put("class_begins_weeks",            bgRs1.getString("class_begins_weeks") );
				json_son.put("shangkerenshu",                 shangkerenshu);
				json_son.put("classes_weekly",                bgRs1.getString("classes_weekly"));
				json_son.put("start_semester",                bgRs1.getString("start_semester"));
				json_son.put("lecture_classes",               bgRs1.getString("lecture_classes"));
				json_son.put("class_in",                      bgRs1.getString("class_in"));
				json_son.put("extracurricular_practice_hour", bgRs1.getString("extracurricular_practice_hour"));
				
				json_arr.add(json_son);
		}
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
	  	<title><%=Mokuai%></title>
	    <link rel="stylesheet" href="../../../pages/css/sy_style.css">	    
	  	<link rel="stylesheet" href="../../js/layui2/css/layui.css">
		<script type="text/javascript" src="../../js/jquery-1.9.1.js" ></script><!--通用jquery-->
		<script src="../../js/layui2/layui.js"></script>
		<script type="text/javascript" src="../../js/ajaxs.js" ></script>
		<script type="text/javascript" src="../../js/layerCommon.js" ></script>
	</head>
	<body>  
  		<%-- 搜索区域 --%>
  		<div id="tb" class="form_top layui-form" style="display: flex;width:1200px; float: inherit;">
			<form class="layui-form">
				<div class="layui-input-inline">
					<select name="academic_year" id="academic_year" lay-search>
						<option value="">请选择学期号</option>
						<%
	            		String semesterSql =  "SELECT t.academic_year,t.this_academic_tag FROM academic_year t order by t.academic_year desc ";
	            		ResultSet semesterRs = db.executeQuery(semesterSql);
	            		while(semesterRs.next()){
	            				if("true".equals(semesterRs.getString("this_academic_tag"))){
	            					%>
	            				<option value="<%=semesterRs.getString("academic_year") %>"  selected><%=semesterRs.getString("academic_year") %></option>
	            					<%}else{%>
	            				<option value="<%=semesterRs.getString("academic_year") %>" ><%=semesterRs.getString("academic_year") %></option>
	            			<%}}%>
					</select>
				</div>
				<div class="layui-input-inline">
		            <select name="dict_departments_id" id="dict_departments_id" lay-search  lay-filter="department">
		              <option value="">全部院系</option>
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
					<select name="jiaoyanshi" id="jiaoyanshi" lay-search>
						<option value="">请选择教研室</option>
					<% 
						//教研室
						String jiaoyan_sql = "select id,teaching_research_name from teaching_research  where is_teaching=1";
						ResultSet jiaoyan_set = db.executeQuery(jiaoyan_sql);
						while(jiaoyan_set.next()){
					%>
						<option value="<%=jiaoyan_set.getString("id") %>" ><%=jiaoyan_set.getString("teaching_research_name") %></option>
					<%}if(jiaoyan_set!=null){jiaoyan_set.close();} %>			
					</select>  
				</div>
				<div class="layui-input-inline">
					<select name="laoshi" id="laoshi" lay-search>
						<option value="">请选择老师</option>
						<option value="无">无</option>
						<%
							//String laoshi_sql = "select id,teacher_name from teacher_basic";
							String laoshi_sql = "SELECT DISTINCT(t.teacherid) teacherid,t1.id,t1.teacher_name  FROM teaching_task_teacher t LEFT JOIN teacher_basic t1 ON t1.id=t.teacherid";
							ResultSet laoshi_set = db.executeQuery(laoshi_sql);
							while(laoshi_set.next()){
						%>
							<option value="<%=laoshi_set.getString("id") %>" ><%=laoshi_set.getString("teacher_name") %></option>
						<%}if(laoshi_set!=null){laoshi_set.close();} %>
					</select> 
				</div>
				<div class="layui-input-inline"> 
					<select name="zhuanye" id="zhuanye" lay-search  lay-filter="grade" >
						<option value="">请选择专业</option>
						<%
							String zhuanye_sql = "select id,major_name from major";
							ResultSet zhuanye_set = db.executeQuery(zhuanye_sql);
							while(zhuanye_set.next()){
						%>
							<option value="<%=zhuanye_set.getString("id") %>" ><%=zhuanye_set.getString("major_name") %></option>
						<%}if(zhuanye_set!=null){zhuanye_set.close();} %>
					</select>
				</div>
				<div class="layui-input-inline">
					<select name="banji" id="banji" lay-search>
						<option value="">请选择班级</option>
						<%
							String banji_sql = "select id,class_name from class_grade";
							ResultSet banji_set = db.executeQuery(banji_sql);
							while(banji_set.next()){
						%>
							<option value="<%=banji_set.getString("id") %>" ><%=banji_set.getString("class_name") %></option>
						<%} %>
					</select>
				</div>
				<button class="layui-btn layui-btn-small  layui-btn-primary"  lay-submit lay-filter="*" id="w_button"  style="height: 35px;  color: white; background: rgb(25, 160, 148);"> <i class="layui-icon" style="color: #FFF;">&#xe615;</i> 搜索</button>
				<button class="layui-btn layui-btn-small  layui-btn-primary" onclick="shuaxin()" style="height: 35px;  color: white; background: rgb(25, 160, 148);"> <i class="layui-icon" style="color: #FFF;">ဂ</i> 刷新</button>
				<div class="layui-form-item" style=" width: 0px;float:  right;margin-top: -39px;">
				    <a class="layui-btn"  onclick=" $('#table_control').fadeToggle();"><i class="layui-icon" style="font-size: 30px; color: #f4f6f7;">&#xe620;</i>  </a>
				    <div class="layui-form-select" style="    margin-left: 10%;">
				    	<dl class="layui-anim layui-anim-upbit" style="margin-top: -40px; " id="table_control">
				    		<dd  class=""> <input type="checkbox" name="id" title="" lay-filter="tableControl"></dd>
				    		<dd  class=""> <input type="checkbox" name="like[write1]" title="写作" lay-filter="tableControl"></dd>
				    		<dd  class=""> <input type="checkbox" name="like[write2]" title="写作" lay-filter="allChoose"></dd>
				    	</dl>
				    </div>
				</div>
			</form>
		</div>
		
		<table class="layui-table" lay-filter="demo" style="    margin-top: -2%;" id="test"></table>
		<%
		//****用户类型是管理员或用户类型是教职工且不是普通教师(id =28),判断暂时写死
		boolean teaboo = true;
		if(Suserole.equals("4")){
			String userole = " select t1.id from zk_user_role t LEFT JOIN zk_role t1 ON t.sys_role_id = t1.id where 	t.sys_user_id = "+Suid;
			ResultSet rs = db.executeQuery(userole);
			ArrayList<String> listRole = new ArrayList<String>();
			while(rs.next()){
				listRole.add(rs.getString("id"));
			}if(rs!=null)rs.close();
			if(listRole!=null&&listRole.size()==1&&listRole.contains("28")){
				teaboo = false;
			}
		}
		if(Suserole.equals("4")||teaboo){
		%>
		<div class="layui-btn-group demoTable">
			<button class="layui-btn" data-type="getCheckData">转出</button>
		</div>
		<select name="my_select" style="width: 87px;height: 36px;">
	       <option value="0">排课系统</option>
	       <option value="1">选课系统</option>
	    </select>		  
		<%}
		%>
  	</body>
  	<script type="text/html" id="barDemo">
  		<a class="layui-btn layui-btn-xs" lay-event="edit">明细</a>
		<a class="layui-btn layui-btn-danger layui-btn-xs" lay-event="del">删除</a>
	</script>
	<script type="text/javascript">
			/*编写表格头数据*/
		  	var tade_head=[[
					 {type:'checkbox', fixed: 'left'}
					,{field:'course_name',                     title: '课程名称',   sort: true,  width:160}
					,{field:'test_semester',                   title: '考试学期',   sort: true}
					,{field:'teacher_name',                   title: '教师',   sort: true}
					,{field:'class_name',                      title: '上课班级',   sort: true,  width:260}
					,{field:'class_begins_weeks',              title: '讲课周次',   sort: true,  width:160}
					,{field:'shangkerenshu',                   title: '上课人数',   sort: true,  width:160}
					,{field:'classes_weekly',                  title: '周数',   sort: true,  width:160}
					,{field:'start_semester',                  title: '周学时数',   sort: true,  width:160}
					,{field:'id',                              title: 'ID',    display:"none"}
					,{field:'semester',                        title: '学期学号',   display:"none"}
					,{field:'course_code',                     title: '课程编码',   width:160,  display:'none'}
					,{field:'check_semester',                  title: '考察学期',    display:'none'}
					,{field:'course_nature_id',                title: '课程性质',    width:160,  display:'none'}
					,{field:'course_category_id',              title: '课程类别',   width:160,  display:'none'}
					,{field:'dict_departments_id',              title: '开课院系',    width:160,  display:'none'}
					,{field:'start_semester',              	   title: '讲课周学时',   width:160,  display:'none'}
					,{field:'lecture_classes',                 title: '讲课学时',    width:160,  display:'none'}
					,{field:'class_in',                        title: '实践学时',   width:160,  display:'none'}
					,{field:'extracurricular_practice_hour',   title: '独立设置', width:160,  display:'none'}
					,{field:'operation',  					   title: '操作', 		width:120,  fixed: 'right',  toolbar: '#barDemo'}
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
						//tableControl_html=tableControl_html+"<dd  class><input type=\"checkbox\" value=\""+table_hed[i].field+"\" name=\""+table_hed[i].field+"\" title=\""+table_hed[i].title+"\"  lay-filter=\"tableControl\"> </dd>";
						if(table_hed[i].display=='none'){
							tableControl_html=tableControl_html+"<dd  class><input type=\"checkbox\" value=\""+table_hed[i].field+"\" name=\""+table_hed[i].field+"\" title=\""+table_hed[i].title+"\"  lay-filter=\"tableControl\"> </dd>";
							}else{
							tableControl_html=tableControl_html+"<dd  class><input type=\"checkbox\" checked value=\""+table_hed[i].field+"\" name=\""+table_hed[i].field+"\" title=\""+table_hed[i].title+"\"  lay-filter=\"tableControl\"> </dd>";
								}
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
					  url: '?ac=acSelect&form_date='+JSON.stringify(field)
					});
				  	return false;	
				 }); 	
				/*定义表格*/
				table.render({
				    elem: '#test'
				    ,url:'?ac=acSelect&form_date='+JSON.stringify(field)
				    ,page:true
				    ,minWidth:80
				    ,limit:30
				    ,cellMinWidth: 100 //全局定义常规单元格的最小宽度，layui 2.2.1 新增
				    ,cols: tade_head
				    ,done:function(obj){
						/*渲染select*/
					  	form.render('select');
					  	form.render('checkbox');
					  	
					    for (var i=0;i<tade_head[0].length;i++){
							
							if(tade_head[0][i].display!=undefined){
								$("th[data-field="+tade_head[0][i].field+"]").css("display","none");
								$("td[data-field="+tade_head[0][i].field+"]").css("display","none");
							}
						}
				    }
				});
	  
			  	/*渲染select*/
			  	form.render('select');
			  	form.render('checkbox');
	
		 		/*监控select -[院系]*/
				form.on('select(dict_departments)', function(data){
			  		var id = data.value;/*选中有效值*/
			  		if(id!=0){
						layer.open({
							  type: 2,
							  title: '增加课程信息',
							  offset: 't',//靠上打开
							  shadeClose: true,
							  maxmin:1,
							  shade: 0.5,
							  area: ['100%', '100%'],
							  content: 'new_teacher_shezhi.jsp?teaching_task_classid='+id
						});
					}
				 });
				 
				 /*监听表头控制*/
				 form.on('checkbox(tableControl)', function(data){
				 	if(data.elem.checked){/*隐藏*/
				 		$("th[data-field="+data.value+"]").removeAttr("style");
				 		$("td[data-field="+data.value+"]").removeAttr("style");
				 	}else{/*显示*/
				 		$("th[data-field="+data.value+"]").css("display","none");
				 		$("td[data-field="+data.value+"]").css("display","none");
				 	}
				}); 
				 form.on('select(department)',function(data){
						if(data.value!="0"){
<%--							var obj_str1 = {"departments_id":data.value};--%>
<%--							var obj1 = JSON.stringify(obj_str1)--%>
<%--							var ret_str1=PostAjx('../../../../Api/v1/?p=web/info/teachingResearch',obj1,'<%=Suid%>','<%=Spc_token%>');--%>
<%--							obj1 = JSON.parse(ret_str1);--%>	
<%--							$("#jiaoyanshi").html(obj1.data);--%>
							//获取专业信息
							var obj_str2 = {"departments_id":data.value};
							var obj2 = JSON.stringify(obj_str2)
							var ret_str2=PostAjx('../../../../Api/v1/?p=web/info/getMajor',obj2,'<%=Suid%>','<%=Spc_token%>');
							obj2 = JSON.parse(ret_str2);
							$("#zhuanye").html(obj2.data);
							form.render('select');
						}
						
					})
					form.on('select(grade)',function(data){
						if(data.value!="0"){
							var obj_str1 = {"major_id":data.value};
							var obj1 = JSON.stringify(obj_str1)
							var ret_str1=PostAjx('../../../../Api/v1/?p=web/info/getClassGrade',obj1,'<%=Suid%>','<%=Spc_token%>');
							obj1 = JSON.parse(ret_str1);
							$("#banji").html(obj1.data);
							form.render('select');
						}
						
					})
					table.on('sort(demo)', function(obj){ //注：tool是工具条事件名，test是table原始容器的属性 lay-filter="对应的值"
						  console.log(obj.field); //当前排序的字段名
						  console.log(obj); //当前排序类型：desc（降序）、asc（升序）、null（空对象，默认排序）
						  console.log(this); //当前排序的 th 对象
						  table.reload('test', {
						    initSort: obj //记录初始排序，如果不设的话，将无法标记表头的排序状态。 layui 2.1.1 新增参数
						    ,where: { //请求参数（注意：这里面的参数可任意定义，并非下面固定的格式）
						      field: obj.field //排序字段
						      ,order: obj.type //排序方式
						    }
						  });
						});
					
  				//监听工具条
			  	table.on('tool(demo)', function(obj){
			    	var data = obj.data;
			    	 if(obj.event === 'edit'){/*编辑*/
							layer.open({
								  type: 2,
								  title: '设置教师',
								  offset: 't',//靠上打开
								  shadeClose: true,
								  maxmin:1,
								  shade: 0.5,
								  area: ['100%', '100%'],
								  content: 'teach_shezhi.jsp?id='+data.id+'&school_year='+data.semester+"&state=0",
								  yes: function(index, layero){
					      		    layer.close(index); 
					      		    document.getElementById("w_button").click();
					      		  }
							});
			    	}else if(obj.event === 'del'){
				    	 
				      	layer.confirm('真的删除行么', function(index){
				      		var str = {"teaching_task_id":data.id,"semester":data.semester};

				      		var ret_str=PostAjx('../../../../Api/v1/?p=web/do/doDelTask',JSON.stringify(str),'<%=Suid%>','<%=Spc_token%>');
							var obj = JSON.parse(ret_str);
							if(obj.success && obj.resultCode=="1000"){
								layer.msg("删除成功",{icon:1,time:1000,offset:'150px'},function(){
							    document.getElementById("w_button").click();
							   });
							}else{
								layer.msg("删除失败",{icon:2,time:1000,offset:'150px'},function(){
									
							   });
							}
				        	layer.close(index);
				      	});
				      	
				    /*编辑*/
			    	}
			  });
  			
			  var $ = layui.$, active = {
			    getCheckData: function(){ /*获取选中数据*//*转出开课通知单*/
			      var checkStatus = table.checkStatus('test')
			      ,data = checkStatus.data;
			      
			       if(!confirm("确定要转出吗？")){
				        return ;
				    }
	
					var str= new Array();
					for(var i =0 ; i < data.length;i++){
						str[i]=data[i].id+"";
					}
					if(str.length>0){
						str = str.join();
						var url = "?ac=daochu&id="+str;
						window.location.href=url;
					}else{
						layer.msg("必须选择一个");
					}
			      
			    }
			  };
  
			   $('.demoTable .layui-btn').on('click', function(){
			    var type = $(this).data('type');
			    active[type] ? active[type].call(this) : '';
			  });
		 
		 });
		 		 
			/*帮助页面*/
			function help(val) {
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
			
			
			/*修改合班信息*/
			function xiugai(id){
				layer.open({
					  type: 2,
					  title: '修改合班信息',
					  //offset: 't',//靠上打开
					  shadeClose: true,
					  maxmin:1,
					  shade: 0.5,
					  area: ['900px', '500px'],
					  content: 'edit_hebanxinxi.jsp?id='+id,
					  yes: function(index, layero){
		      		    layer.close(index); 
		      		    document.getElementById("w_button").click();
		      		  }
				});
			}
			/*刷新*/
			function shuaxin(){
				window.location.href="?ac=";
			}	
	</script>
	<script>
</script>
</html>
<%
	//转出
	if("daochu".equals(ac)){
		
		String ids = request.getParameter("id");
		String [] arr = ids.split(",");
		boolean state = true;
		for(int i =0 ; i < arr.length ; i++){
			//String num_sss = "SELECT COUNT(1) AS ROW FROM arrage_coursesystem WHERE teaching_task_id = '"+arr[i]+"'";
			
			//删除之前先查询下，需要把关联的表都删除掉
			String sql_coursesystem = "select teaching_task.id,teaching_task.semester,teaching_task.marge_class_id,teaching_task_teacher.teacherid from teaching_task LEFT JOIN teaching_task_teacher ON teaching_task.id = teaching_task_teacher.teaching_task_id  WHERE teaching_task.id = '"+arr[i]+"'		AND		teaching_task_teacher.state=1 ;";
			
			ResultSet couResultSet = db.executeQuery(sql_coursesystem);
			ResultSet sdasd = db.executeQuery(sql_coursesystem);
			String arrage_coursesystem_id = "";
			String semester = "";
			String marge_class_id = "";
			String teacherid = "";
			if(sdasd.next()){
				arrage_coursesystem_id = sdasd.getString("id");
				semester = sdasd.getString("semester");
				marge_class_id = sdasd.getString("marge_class_id");
				teacherid = sdasd.getString("teacherid");
			}if(sdasd!=null){sdasd.close();}
			
			
			//先删除在更新
			
			boolean sss = commonCourse.setDelete(arrage_coursesystem_id,semester);
			
			
			//String delete_sql = "DELETE FROM arrage_coursesystem WHERE teaching_task_id = '"+arr[i]+"' ;";
			if(sss){
				
				
				if(!"0".equals(marge_class_id)){
					
					String sql_marge = "	SELECT teaching_task_id FROM teaching_tesk_marge WHERE marge_class_id = '"+marge_class_id+"' ;		";
					
					ResultSet marge_set = db.executeQuery(sql_marge);
					while(marge_set.next()){
						String sql1 ="";
						sql1 = setTaskInsetSql(marge_set.getString("teaching_task_id"),teacherid);
						state = db.executeUpdate(sql1);
						if(state){
							System.out.println("asdasasd");
						}else{
							state = false;
							break;
						}
					}if(marge_set!=null){marge_set.close();}
				}
				String sql1 ="";
				sql1 = setTaskInsetSql(arr[i],teacherid);
				state = db.executeUpdate(sql1);
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
<%!

public static String  setTaskInsetSql(String id,String teacherid){
	String sql = "INSERT INTO arrage_coursesystem 			"+
	"		(                                               "+
	"		teaching_task_id,								"+
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
	"		teacher_id,                                         "+
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
	"		teaching_task.id,												"+
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
	"		marge_state	,									"+
	"		merge_number,                                   "+
	"		teaching_way,                                   "+
	"		computer_area_id,                               "+
	"		teaching_task_sort  ,                            "+
	"		2   as  typestate,										"+
	"		'"+teacherid+"' AS teacher_id,                                         "+
	"		union_class_code,                                   "+
	"		character_selection,                                "+
	"		practice_weeks,                                     "+
	"		assessment_id,                                      "+
	"		assessment_category_id,                             "+
	"		IFNULL(teaching_task_teacher.class_begins_weeks,teaching_task.class_begins_weeks) AS class_begins_weeks,                                 "+
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
	"		LEFT JOIN teaching_task_teacher					"+
    "		ON teaching_task.id = teaching_task_teacher.teaching_task_id		"+
	"		WHERE teaching_task.id='"+id+"'   ;";
	
	return sql;
}

public static String setUpdateSql(String id){
	
	
	String sql = "UPDATE arrage_coursesystem a,teaching_task b SET                       "+
	"			a.teaching_task_class_id=b.teaching_task_class_id,                           "+
	"			a.teaching_task_parentid=b.parent_id"+
	"			a.semester =b.semester,                                                      "+
	"			a.course_id=b.course_id,                                                     "+
	"			a.major_id=b.major_id,                                                       "+
	"			a.dict_departments_id=b.dict_departments_id,                                 "+
	"			a.class_id=b.class_id,                                                       "+
	"			a.classes_weekly=b.classes_weekly,                                           "+
	"			a.start_semester=b.start_semester,                                           "+
	"			a.responsibility=b.responsibility,                                           "+
	"			a.school_year=b.school_year,                                                 "+
	"			a.lecture_classes=b.lecture_classes,                                         "+
	"			a.teaching_research_number=b.teaching_research_number,                       "+
	"			a.course_category_id=b.course_category_id,                                   "+
	"			a.course_nature_id=b.course_nature_id,                                       "+
	"			a.extracurricular_practice_hour=b.extracurricular_practice_hour,             "+
	"			a.professional_direction_coding=b.professional_direction_coding,             "+
	"			a.check_semester=b.check_semester,                                           "+
	"			a.test_semester=b.test_semester,                                             "+
	"			a.class_in=b.class_in,                                                       "+
	"			a.teaching_plan_class_id=b.teaching_plan_class_id,                           "+
	"			a.is_merge_class=b.is_merge_class,                                           "+
	"			a.marge_class_id=b.marge_class_id,                                           "+
	"			a.merge_number=b.merge_number,                                               "+
	"			a.teaching_way=b.teaching_way,                                               "+
	"			a.computer_area_id=b.computer_area_id,                                       "+
	"			a.teacher_id = b.teacher_id ,                                                 "+
	"			a.union_class_code = b.union_class_code ,                                     "+
	"			a.character_selection = b.character_selection ,                               "+
	"			a.course_category_id = b.course_category_id ,                                 "+
	"			a.course_nature_id = b.course_nature_id ,                                     "+
	"			a.practice_weeks = b.practice_weeks ,                                         "+
	"			a.assessment_id = b.assessment_id ,                                           "+
	"			a.assessment_category_id = b.assessment_category_id ,                         "+
	"			a.class_begins_weeks = b.class_begins_weeks ,                                 "+
	"			a.experiment_weeks = b.experiment_weeks ,                                     "+
	"			a.week_learn_time = b.week_learn_time ,                                       "+
	"			a.teaching_week_time = b.teaching_week_time ,                                 "+
	"			a.experiment = b.experiment ,                                                 "+
	"			a.computer_weeks = b.computer_weeks ,                                         "+
	"			a.computer_week_time = b.computer_week_time ,                                 "+
	"			a.credits = b.credits ,                                                       "+
	"			a.credits_term = b.credits_term ,                                             "+
	"			a.totle_semester = b.totle_semester ,                                         "+
	"			a.startnum = b.startnum ,                                                     "+
	"			a.total_classes = b.total_classes ,                                           "+
	"			a.lecture_hours = b.lecture_hours ,                                           "+
	"			a.amongshiyan = b.amongshiyan ,                                               "+
	"			a.amongshangji = b.amongshangji ,                                             "+
	"			a.practice_time = b.practice_time ,                                           "+
	"			a.practice_state = b.practice_state ,                                         "+
	"			a.semester_hours = b.semester_hours ,                                         "+
	"			a.semester_jiangke = b.semester_jiangke ,                                     "+
	"			a.semester_amongshiyan = b.semester_amongshiyan ,                             "+
	"			a.semester_amongshangji = b.semester_amongshangji ,                           "+
	"			a.semester_practice_state = b.semester_practice_state ,                       "+
	"			a.teaching_area_id = b.teaching_area_id ,                                     "+
	"			a.experiment_area_id = b.experiment_area_id ,                                 "+
	"			a.sex_ask = b.sex_ask ,                                                       "+
	"			a.classes_number = b.classes_number ,                                         "+
	"			a.course_number = b.course_number ,                                           "+
	"			a.semester_practice_time = b.semester_practice_time,                           "+
	"			a.teaching_task_sort=b.teaching_task_sort                                   "+
	"			where a.teaching_task_id=b.id and b.id="+id;
	
	return sql;
}


%>
<%
	long TimeEnd = Calendar.getInstance().getTimeInMillis();
	System.out.println(Mokuai+"耗时:"+(TimeEnd - TimeStart) + "ms");
	//插入常用菜单日志
	int   TagMenu=db.Row("SELECT COUNT(*) as row FROM  menu_worker  WHERE sysmenuid='"+PMenuId+"' and  workerid='"+Suid+"'");
	if(TagMenu==0){
     	db.executeUpdate("INSERT INTO `menu_worker`(`sysmenuid`,`workerid`,`countes`) VALUES ('"+PMenuId+"','"+Suid+"','1');"); 
    }else{
  		db.executeUpdate("UPDATE  `menu_worker` SET `countes`=countes+1,`usetime`=now() WHERE  sysmenuid='"+PMenuId+"' and  workerid='"+Suid+"'");
	}
%>
<%if(db!=null)db.close();db=null;if(server!=null)server=null;%>