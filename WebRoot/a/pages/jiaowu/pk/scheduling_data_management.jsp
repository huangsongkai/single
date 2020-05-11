<%@ page trimDirectiveWhitespaces="true" %>
<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@page import="v1.haocheok.commom.common"%>
<%@page import="service.dao.db.Page"%>
<%@page import="javax.annotation.Resource"%>
<%@page import="net.sf.json.JSONArray"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="v1.haocheok.commom.commonCourse"%>
<%@include file="../../cookie.jsp"%>

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
				sql_where.append(" AND t.semester='"+form_datr.getString("academic_year")+"'   ");
			}
			if(form_datr.getString("dict_departments_id")!=null && form_datr.getString("dict_departments_id").length()>0 && !form_datr.getString("dict_departments_id").equals("0")){/*院系id*/
				sql_where.append("  AND dict_departments.id='"+form_datr.getString("dict_departments_id")+"'   ");
			}
			if(form_datr.getString("laoshi")!=null && form_datr.getString("laoshi").length()>0 && !form_datr.getString("laoshi").equals("0")){/*老师*/
				sql_where.append(" AND	teacher_basic.id='"+form_datr.getString("laoshi")+"'   ");
			}
			if(form_datr.getString("zhuanye")!=null && form_datr.getString("zhuanye").length()>0 && !form_datr.getString("zhuanye").equals("0")){/*专业*/
				sql_where.append(" AND t.major_id='"+form_datr.get("zhuanye")+"'   ");
			}
			if(form_datr.getString("banji")!=null && form_datr.getString("banji").length()>0 && !form_datr.getString("banji").equals("0")){/*班级*/
				sql_where.append(" AND t.class_id='"+form_datr.get("banji")+"'   ");
			}
			if(form_datr.getString("timetablestate")!=null && form_datr.getString("timetablestate").length()>0 && !form_datr.getString("timetablestate").equals("0")){/*班级*/
				sql_where.append(" AND t.timetablestate='"+form_datr.get("timetablestate")+"'   ");
			}
			if(form_datr.getString("course_class")!=null && form_datr.getString("course_class").length()>0 && !form_datr.getString("course_class").equals("0")){
				sql_where.append(" AND t.course_class='"+form_datr.get("course_class")+"'   ");
			}
		}
		
		/*返回数据*/
		JSONObject json =new JSONObject();
		JSONArray  json_arr = new JSONArray();
		/*计划总条数*/
		String plan_num_sql="SELECT																												"+
 		"		COUNT(1) as row																										"+
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
		"		WHERE 1=1  "+sql_where+"	AND is_merge_class!=1 AND marge_state!=1	"+
		"    order by t.id DESC  ";
		
		int plan_num=db.Row(plan_num_sql);
		
	 	common common=new common();
				        
        String  sql1 = "SELECT																												"+
 		"		t.id as id	,																										"+
 		"		t.course_class,																									"+
 		"		t.semester,																								"+
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
		"		WHERE 1=1  "+sql_where+"	AND is_merge_class!=1 AND marge_state!=1	"+
		"    order by t.id DESC "+
        " limit "+(pages-1)*limit+","+limit+" ;";
		System.out.println(sql1);
		ResultSet bgRs1=null; 
        String course_nature_id="",course_category_id="",course_id="",sysid="";
   		bgRs1=db.executeQuery(sql1);  //一级循环
   		String class_name = "";		//班级名称
   		int shangkerenshu = 0;	//上课人数
		while(bgRs1.next()){    
			String course_class = "";
			if("0".equals(bgRs1.getString("course_class"))){
				course_class= "全部";
	      	}else if("1".equals(bgRs1.getString("course_class"))){
	      		course_class= "教务处排课";
	      	}else if("2".equals(bgRs1.getString("course_class"))){
	      		course_class= "教务处教务科排课";
	      	}
	      	else if("3".equals(bgRs1.getString("course_class"))){
	      		course_class= "教务处体制改革";
	      	}
			
			String timetablestate = "";
			
			if("0".equals(bgRs1.getString("timetablestate"))){
				timetablestate= "未排课";
	      	}else if("1".equals(bgRs1.getString("timetablestate"))){
	      		timetablestate= "已排课";
	      	}else if("2".equals(bgRs1.getString("timetablestate"))){
	      		timetablestate= "漏课";
	      	}
	      	else if("3".equals(bgRs1.getString("timetablestate"))){
	      		timetablestate= "指定不排课";
	      	}
			
			JSONObject json_son =new JSONObject();
		
			json_son.put("id",                            bgRs1.getString("id"));
			json_son.put("course_class",                           course_class);
			json_son.put("course_name",                   common.idToFieidName("dict_courses","course_name",bgRs1.getString("course_id")));
			json_son.put("start_semester",                   bgRs1.getString("start_semester"));
			json_son.put("semester",                   bgRs1.getString("semester"));
			json_son.put("teacher_name",                      bgRs1.getString("teacher_name") );
			json_son.put("class_name",                   bgRs1.getString("class_name"));
			json_son.put("totle",                bgRs1.getString("totle"));
			json_son.put("class_begins_weeks",                 bgRs1.getString("class_begins_weeks"));
			json_son.put("timetablestate",                timetablestate);
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
		            <select name="dict_departments_id" id="dict_departments_id" lay-search >
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
					<select name="laoshi" id="laoshi" lay-search>
						<option value="">请选择老师</option>
						<%
							String laoshi_sql = "select id,teacher_name from teacher_basic";
							ResultSet laoshi_set = db.executeQuery(laoshi_sql);
							while(laoshi_set.next()){
						%>
							<option value="<%=laoshi_set.getString("id") %>" ><%=laoshi_set.getString("teacher_name") %></option>
						<%}if(laoshi_set!=null){laoshi_set.close();} %>
					</select> 
				</div>
				<div class="layui-input-inline"> 
					<select name="zhuanye" id="zhuanye" lay-search>
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
				
				<div class="layui-input-inline">
					<select name="timetablestate" id="timetablestate" lay-search>
						<option value="">排课状态</option>
						<option value="0"  >未排课</option>
						<option value="1">已排课</option>
						<option value="2" >漏课</option>
						<option value="3" >指定不排课</option>
					</select>
				</div>
				<div class="layui-input-inline">
					<select name="course_class" id="course_class" lay-search>
						<option value="">排课类型</option>
						<option value="0"  >全部</option>
						<option value="1">教务处排课</option>
						<option value="2" >教务处教务科排课</option>
						<option value="3" >教务处体制改革</option>
					</select>
				</div>
				<button class="layui-btn layui-btn-small  layui-btn-primary"  lay-submit lay-filter="*"  style="height: 35px;  color: white; background: rgb(25, 160, 148);"> <i class="layui-icon" style="color: #FFF;">&#xe615;</i> 搜索</button>
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
		<div class="layui-btn-group demoTable">
			<button class="layui-btn" data-type="getCheckData">排课类别设置</button>
		</div>
		<select name="my_select" id="my_select" style="width: 150px;height: 36px;">
	       <option value="1">教务处排课</option>
	       <option value="2">教务处教务科排课</option>
	       <option value="3">教务处体制改革</option>
	    </select>
	    
	    <div class="layui-btn-group demoTable">
			<button class="layui-btn" data-type="getTeacherData">教学区设置</button>
		</div>
		<select name="my_select1" id="my_select1" style="width: 150px;height: 36px;">
	       <option value="0">请选择教学区</option>
           	<%
           		String sql = "select id,teaching_area_name from teaching_area";
           		ResultSet set1 = db.executeQuery(sql);
           		while(set1.next()){
           	%>
           		<option value="<%=set1.getString("id")%>" ><%=set1.getString("teaching_area_name") %></option>
           	<%}if(set1!=null){set1.close();} %>
	    </select>
	    
	    <div class="layui-btn-group demoTable">
			<button class="layui-btn" data-type="NotGrantData">指定不予排课</button>
		</div>
	    
  	</body>
  	<script type="text/html" id="barDemo">
  		<a class="layui-btn layui-btn-xs" lay-event="edit">指定</a>
		<a class="layui-btn layui-btn-danger layui-btn-xs" lay-event="delete">删除</a>
	</script>
	<script type="text/javascript">

			/*编写表格头数据*/
		  	var tade_head=[[
					 {type:'checkbox', fixed: 'left'}
					,{field:'id',                              title: 'ID',   	   sort: true}
					,{field:'course_class',                              title: '排课类型',   	   sort: true}
					,{field:'course_name',                        title: '课程名称',   sort: true}
					,{field:'start_semester',                     title: '上课周学时',   sort: true,  width:160}
					,{field:'teacher_name',                     title: '授课教师',   sort: true,  width:160}
					,{field:'class_name',                  title: '上课班级',   sort: true}
					,{field:'totle',                   title: '排课人数',   sort: true}
					,{field:'class_begins_weeks',                title: '讲课周次',   sort: true,  width:160}
					,{field:'timetablestate',                title: '排课状态',   sort: true,  width:160}
					,{field:'operation',  					   title: '操作', 		width:150,  fixed: 'right',  toolbar: '#barDemo'}
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
								console.log(tade_head[0][i].field);
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
				 		$("th[data-field="+data.value+"]").css("display","none");
				 		$("td[data-field="+data.value+"]").css("display","none");
				 	}else{/*显示*/
				 		$("th[data-field="+data.value+"]").removeAttr("style");
				 		$("td[data-field="+data.value+"]").removeAttr("style");
				 	}
				}); 
				
  				//监听工具条
			  	table.on('tool(demo)', function(obj){
			    	var data = obj.data;
			    	 if(obj.event === 'edit'){/*指定*/
			    		 layer.open({
			    			  type: 2,
			    			  title: '排课指定',
			    			  offset: 't',//靠上打开
			    			  maxmin:1,
			    			  shade: 0.5,
			    			  area: ['100%', '100%'],
			    			  content: 'scheduling_appoint.jsp?id='+data.id,
			    			  yes: function(index, layero){
				      		    layer.close(index); 
				      		    document.getElementById("w_button").click();
				      		  }
			    		});
			    	}
			    	 if(obj.event === 'delete'){/*指定*/
			    		 layer.confirm("确认要删除吗，删除后不能恢复", { title: "删除确认" }, function (index) { 
			    	          layer.close(index);
			    	          window.location.href="?ac=deletet&semester="+data.semester+"&delid="+data.id+"";    						 
			    	      }); 
			    	}
				    	
			  });

	  		 
			  var $ = layui.$; 

			  active = {
			    getCheckData: function(){ /*获取选中数据*//*转出开课通知单*/

			      var checkStatus = table.checkStatus('test')
			      ,data = checkStatus.data;
			      
			       if(!confirm("确定要设置排课类别吗？")){
				        return ;
				    }
					var str= new Array();
					for(var i =0 ; i < data.length;i++){
						str[i]=data[i].id+"";
					}
					if(str.length>0){
						str = str.join();
						var my_select = $("#my_select").val();
						var url = "?ac=daochu&id="+str+"&my_select="+my_select;
						window.location.href=url;
					}else{
						layer.msg("必须选择一个");
					}
			      
			    },
			  	NotGrantData: function(){ 
				  var checkStatus = table.checkStatus('test')
			      ,data = checkStatus.data;
			      
			       if(!confirm("确定要指定不予排课吗？")){
				        return ;
				    }
					var str= new Array();
					for(var i =0 ; i < data.length;i++){
						str[i]=data[i].id+"";
					}
					if(str.length>0){
						str = str.join();
						var url = "?ac=notgrant&id="+str;
						window.location.href=url;
					}else{
						layer.msg("必须选择一个");
					}
			      
			    },
			    getTeacherData: function(){ 
					  var checkStatus = table.checkStatus('test')
				      ,data = checkStatus.data;
				      
				       if(!confirm("确定要设置教学区吗？")){
					        return ;
					    }
						var str= new Array();
						for(var i =0 ; i < data.length;i++){
							str[i]=data[i].id+"";
						}
						if(str.length>0){
							str = str.join();
							var my_select = $("#my_select1").val();
							var url = "?ac=jiaoxuequ&id="+str+"&my_select="+my_select;
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
		String my_select = request.getParameter("my_select");
		boolean state = true;
		for(int i =0 ; i < arr.length ; i++){
			//String num_sss = "SELECT COUNT(1) AS ROW FROM arrage_coursesystem WHERE teaching_task_id = '"+arr[i]+"'";
			//先删除在更新
			String delete_sql = "UPDATE arrage_coursesystem SET course_class = '"+my_select+"' WHERE id = '"+arr[i]+"' ;";
			if(db.executeUpdate(delete_sql)){
				if(state){
				}else{
					state = false;
					break;
				}
			}
		}
		if(state){
			out.println("<script>parent.layer.msg('设置 成功', {icon:1,time:1000,offset:'150px'},function(){}); </script>");
		}else{
			out.println("<script>parent.layer.msg('设置 失败');</script>");
		}
		
		
	}
	
	//设置教学区
	if("jiaoxuequ".equals(ac)){
		String ids = request.getParameter("id");
		String [] arr = ids.split(",");
		String my_select = request.getParameter("my_select");
		boolean state = true;
		for(int i =0 ; i < arr.length ; i++){
			//String num_sss = "SELECT COUNT(1) AS ROW FROM arrage_coursesystem WHERE teaching_task_id = '"+arr[i]+"'";
			//先删除在更新
			String delete_sql = "UPDATE arrage_coursesystem SET teaching_area_id = '"+my_select+"' WHERE id = '"+arr[i]+"' ;";
			if(db.executeUpdate(delete_sql)){
				if(state){
				}else{
					state = false;
					break;
				}
			}
		}
		if(state){
			out.println("<script>parent.layer.msg('设置 成功', {icon:1,time:1000,offset:'150px'},function(){}); </script>");
		}else{
			out.println("<script>parent.layer.msg('设置 失败');</script>");
		}
		
	}


	//指定不予排课
	if("notgrant".equals(ac)){
		String ids = request.getParameter("id");
		String [] arr = ids.split(",");
		String my_select = request.getParameter("my_select");
		boolean state = true;
		for(int i =0 ; i < arr.length ; i++){
			//String num_sss = "SELECT COUNT(1) AS ROW FROM arrage_coursesystem WHERE teaching_task_id = '"+arr[i]+"'";
			//先删除在更新
			String delete_sql = "UPDATE arrage_coursesystem SET timetablestate = '3' WHERE id = '"+arr[i]+"' ;";
			if(db.executeUpdate(delete_sql)){
				if(state){
				}else{
					state = false;
					break;
				}
			}
		}
		if(state){
			out.println("<script>parent.layer.msg('设置 成功', {icon:1,time:1000,offset:'150px'},function(){}); </script>");
		}else{
			out.println("<script>parent.layer.msg('设置 失败');</script>");
		}
		
	}
	
	
	


%>
<% 
//删除操作
if("deletet".equals(ac)){ 
	
	String delid=request.getParameter("delid");
	String semester = request.getParameter("semester");
	if(delid==null){delid="";}
	try{
	   //String dsql="DELETE FROM arrage_coursesystem WHERE id='"+delid+"';";
	   commonCourse commonCourse =  new commonCourse();
	   //判断是否是合班的
	   String sele_sql = "		SELECT marge_class_id FROM arrage_coursesystem WHERE id = '"+delid+"'	";
	   ResultSet set_marge = db.executeQuery(sele_sql);
	   String marge_id = "";
	   if(set_marge.next()){
		   marge_id = set_marge.getString("marge_class_id");
	   }if(set_marge!=null){set_marge.close();}
	   boolean state = true;
	   if(!"0".equals(marge_id)){
		   String marge_sql = "SELECT arrage_coursesystem.id													"+
					"	   FROM teaching_tesk_marge                                                             "+
					"	   LEFT JOIN arrage_coursesystem                                                        "+
					"	     ON teaching_tesk_marge.teaching_task_id = arrage_coursesystem.teaching_task_id     "+
					"	   WHERE teaching_tesk_marge.marge_class_id = '"+marge_id+"'		";
		   ResultSet marSet = db.executeQuery(marge_sql);
		   while(marSet.next()){
			   if(marSet.getString("id")!=null ||	"null".equals(marSet.getString("id"))){
				   state = commonCourse.setDelete(marSet.getString("id"),semester);
			   }
		   }if(marSet!=null){marSet.close();}
	   }
	   state = commonCourse.setDelete(delid,semester); 
	   
	  
		   if(state==true){
			   out.println("<script>parent.layer.msg('删除成功');window.location.replace('./scheduling_data_management.jsp');</script>");
		   }else{
			   out.println("<script>parent.layer.msg('删除失败');</script>");
		   }
	 }catch (Exception e){
	    out.println("<script>parent.layer.msg('删除失败');</script>");
	    if (page != null) {page = null;}
	    return;
	 }
	//关闭数据与serlvet.out
	if (page != null) {page = null;}
}%>
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