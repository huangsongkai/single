<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%--生成教学计划列表--%>
<%@page trimDirectiveWhitespaces="true" %>
<%@page contentType="text/html; charset=UTF-8" language="java"%>
<%@page import="service.dao.db.Page"%>
<%@page import="net.sf.json.JSONArray"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="v1.haocheok.commom.common"%>
<%@page import="v1.haocheok.commom.entity.UserEntity"%>
<%@include file="../../cookie.jsp"%>



<% 
/*Mr.wang*/
/*获取生成列表*/
	if("generate_list".equals(ac)){
		
		/*获取请求数据*/
		String form_date=request.getParameter("form_date").toString();
		if(form_date==null){form_date="{}";}
		JSONObject form_datr = JSONObject.fromObject(form_date);
		
		StringBuffer sql_where = new StringBuffer();
		
		/*查询计划关键字*/		
		if(form_datr.getString("keywordss")!=null && form_datr.getString("keywordss").length()>0  && !form_datr.getString("keywordss").equals("0")){
			sql_where.append("where  tpag.teaching_plan_name  like '%"+form_datr.getString("keywordss")+"%'   ");
		}
		/*查询所选院系*/	
		if(form_datr.getString("dict_departments_id")!=null && form_datr.getString("dict_departments_id").length()>0 && !form_datr.getString("dict_departments_id").equals("0")){
			if(sql_where.length()>0){
				sql_where.append(" AND tpag.dict_departments_id='"+form_datr.getString("dict_departments_id")+"'   ");
			}else{
				sql_where.append(" where  tpag.dict_departments_id='"+form_datr.getString("dict_departments_id")+"'   ");
			}
			
		}
		/*查询所选入学年份*/
		if(form_datr.getString("school_year")!=null && form_datr.getString("school_year").length()>0 && !form_datr.getString("school_year").equals("0")){
			if(sql_where.length()>0){
				sql_where.append(" AND tpag.school_year='"+form_datr.getString("school_year")+"'   ");
			}else{
				sql_where.append(" where tpag.school_year='"+form_datr.getString("school_year")+"'   ");
			}
			
		}
		/*查询所选生成状态*/
		if(form_datr.getString("state_approve_id")!=null && form_datr.getString("state_approve_id").length()>0){
			if(sql_where.length()>0){
				sql_where.append(" AND tpag.state_generate='"+form_datr.getString("state_approve_id")+"'   ");
			}else{
				sql_where.append(" where tpag.state_generate='"+form_datr.getString("state_approve_id")+"'   ");
			}
		}
		
		int plan_num = db.Row("SELECT  count(1) row FROM teaching_plan_class_guidance AS tpag 	   "+
							"	LEFT JOIN major ON major.id = tpag.major_id	   "+
							"	LEFT JOIN dict_departments d ON  d.id=tpag.dict_departments_id 	   "+
							sql_where.toString()/*默认条件 state_generate*/);
		
		String limit_sql="limit "+(form_datr.getInt("page")-1)*form_datr.getInt("limit")+","+form_datr.getInt("limit")+" ";
		
		String sql_str="SELECT "+
							"tpag.id,"+
							"tpag.state_approve_id,"+
							"tpag.teaching_plan_name,"+
							"d.departments_name,"+
							"tpag.school_year,"+
							"major.major_name,"+
							"major.majors_number,"+
							"tpag.data_num, "+
							"tpag.state_generate "+
						"FROM teaching_plan_class_guidance AS tpag 	"+																			 
							"	LEFT JOIN major ON major.id = tpag.major_id		"+																	  
							"	LEFT JOIN dict_departments d ON  d.id=tpag.dict_departments_id 	"+													  
							sql_where.toString()+/*默认条件 state_generate*/
							"ORDER BY tpag.id DESC "+
							limit_sql;/*默认条件 state_generate*/
		
		
		JSONObject return_json = new JSONObject();
		
		StringBuffer return_tbody = new StringBuffer();
		ResultSet rs = db.executeQuery(sql_str);					
		while(rs.next()){
			return_tbody.append(
						"<tr>"+
							"<td>"+ rs.getString("tpag.teaching_plan_name") +"</td>"+
							"<td>"+ rs.getString("d.departments_name") +"</td>"+
							"<td>"+ rs.getString("tpag.school_year") +"</td>"+
							"<td>["+ rs.getString("major.majors_number") +"]"+ rs.getString("major.major_name") +"<span class='layui-badge'>"+ rs.getString("tpag.data_num") +"条</span></td>"+
							"<td><strong>教学进程表 </strong></td>");
			if("0".equals(rs.getString("tpag.state_generate")) ){
				if("7".equals(rs.getString("tpag.state_approve_id"))){
					return_tbody.append(			
							"<td><button class='layui-btn' onclick=\"generate('"+rs.getString("tpag.id")+"')\">生成</td>");
				}else{
					return_tbody.append(			
							"<td><button class='layui-btn layui-btn-disabled' disabled='disabled' style='color:red'>未生成</td>");
				}
				
			}else{
				return_tbody.append(			
							"<td><button class='layui-btn layui-btn-disabled' disabled='disabled' >已生成</td>");
			}
			return_tbody.append(	
						"</tr>");
			
		}if(rs!=null){rs.close();}
		
		return_json.put("code","0");	
		return_json.put("tbody",return_tbody.toString());	
		return_json.put("plan_num",plan_num);	
		
		
		out.println(return_json.toString());
		if(db!=null)db.close();db=null;
		return;
	}
%>

<%
/*Mr.wang*/
/*生成计划*/

if("generate".equals(ac)){
	
	/*获取请求数据*/
	String sysid=request.getParameter("sysid").toString();
	
	/* 复制数据到 teaching_plan_class 返回的主键id*/
	int insert_pclass_id=0;
	
	insert_pclass_id=db.executeUpdateRenum("INSERT INTO teaching_plan_class "+
											" ( teaching_plan_name, dict_departments_id, school_year, major_id, state_approve_id, state_generate, data_num, signature_worker_id, add_worker_id, ADDTIME, signature_addtime, opinion, note, semester_weekly1, semester_weekly2, semester_weekly3, semester_weekly4, semester_weekly5, semester_weekly6, semester_weekly7, semester_weekly8, semester_weekly9, semester_weekly10)"+
											" SELECT teaching_plan_name, dict_departments_id, school_year, major_id, state_approve_id, state_generate, data_num, signature_worker_id, add_worker_id, ADDTIME, signature_addtime, opinion, note, semester_weekly1, semester_weekly2, semester_weekly3, semester_weekly4, semester_weekly5, semester_weekly6, semester_weekly7, semester_weekly8, semester_weekly9,semester_weekly10 FROM teaching_plan_class_guidance WHERE id='"+sysid+"'; "
								  );
								  
	
	if(insert_pclass_id>0){/*teaching_plan_class写入成功*/
		
		/*写入 teaching_plan 状态*/
		boolean insert_p_state=false;
		/*写入 teaching_plan sql*/
		insert_p_state=db.executeUpdate("INSERT INTO teaching_plan "+
											" (course_id, major_id, dict_departments_id, start_semester, responsibility, school_year, lecture_classes, teaching_research_number, course_category_id, course_nature_id, assessment, extracurricular_practice_hour, weeks, professional_direction_coding, check_semester, test_semester, class_in, credits, total_classes, classes_weekly1, classes_weekly2, classes_weekly3, classes_weekly4, classes_weekly5, classes_weekly6, classes_weekly7, classes_weekly9, classes_weekly8, classes_weekly10, start_semester1, start_semester2, start_semester3, start_semester4, start_semester5, start_semester6, start_semester7, start_semester8, start_semester9, start_semester10, teaching_plan_class_id, sort,process_id,courserprocess)"+
											" SELECT course_id, major_id, dict_departments_id, start_semester, responsibility, school_year, lecture_classes, teaching_research_number, course_category_id, course_nature_id, assessment, extracurricular_practice_hour, weeks, professional_direction_coding, check_semester, test_semester, class_in, credits, total_classes, classes_weekly1, classes_weekly2, classes_weekly3, classes_weekly4, classes_weekly5, classes_weekly6, classes_weekly7, classes_weekly9, classes_weekly8, classes_weekly10, start_semester1, start_semester2, start_semester3, start_semester4, start_semester5, start_semester6, start_semester7, start_semester8, start_semester9, start_semester10, "+insert_pclass_id+", sort ,process_id,courserprocess FROM teaching_plan_guidance WHERE class_guidance_id='"+sysid+"';");
		
		if(insert_p_state){
			/*更新 teaching_plan_class_guidance 生成状态*/
			boolean pcg_state= db.executeUpdate("UPDATE teaching_plan_class_guidance  SET state_generate = '1'   WHERE id = '"+sysid+"' ;");
			if(pcg_state){
				 out.println(insert_p_state);
				if(db!=null)db.close();db=null;
		    	return;
			}else{
				/*清除写入的数据*/
				db.executeUpdate("DELETE FROM teaching_plan  WHERE teaching_plan_class_id = '"+insert_pclass_id+"'  ;");
				db.executeUpdate("DELETE FROM teaching_plan_class  WHERE id = '"+insert_pclass_id+"' ;");
				out.println(false);
				if(db!=null)db.close();db=null;
		    	return;
			}
		}else{
			/*清除写入的数据*/
			db.executeUpdate("DELETE FROM teaching_plan  WHERE teaching_plan_class_id = '"+insert_pclass_id+"'  ;");
			db.executeUpdate("DELETE FROM teaching_plan_class  WHERE id = '"+insert_pclass_id+"' ;");
			out.println(false);
			if(db!=null)db.close();db=null;
	    	return;
		}
		
	}else{/*teaching_plan_class写入失败*/
		out.println(false);
		if(db!=null)db.close();db=null;
    	return;
	}
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
		<script type="text/javascript" src="../../js/tableExport/js/table-sort.js" ></script><!--表格排序js  css-->
		<script type="text/javascript" chartset="utf8" src="../../js/tableExport/js/table_list.js " ></script><!--表格导出js  css-->
	    <script src="../../js/ajaxs.js"></script>
	    <title>获取生成计划列表</title> 
	    <style type="text/css"> 
	    th { background-color: white; }
	    .btn-group-vertical>.btn, .btn-group>.btn{height:33px;}
        table tr:hover{background:#eeeeee;color:#19A094;}
     </style>
 	</head> 
	<body>
	    <div class="" style="padding-bottom: 0px;margin-left: 1%;margin-right: 1%; height:auto;">
	    	<%-- 页面搜索实现区 --%>
			<form class="layui-form"  id="formids" action="">
				<div id="tb" class="form_top layui-form" style="display: flex;">
						<%-- 计划关键字 --%>
						<input id="keyword" type="text" name="keywordss" class="layui-input textbox-text" placeholder="输入计划关键字" value="" style="width: 125px; height: 35px; color: #272525; background: rgb(227, 227, 227);">
						<%-- 选择院系 --%>
						<select name="dict_departments_id" id="dict_departments_id" lay-verify="required" >
			              <option value="0">全部院系</option>
			              <%
			            	//查询院系
			            	String selectDsql="SELECT  DISTINCT p.dict_departments_id,d.departments_name,d.departments_name,ELT(INTERVAL(CONV(HEX(LEFT(CONVERT(d.departments_name USING gbk),1)),16,10),0xB0A1,0xB0C5,0xB2C1,0xB4EE,0xB6EA,0xB7A2,0xB8C1,0xB9FE,0xBBF7,0xBFA6,0xC0AC,0xC2E8,0xC4C3,0xC5B6,0xC5BE,0xC6DA,0xC8BB,0xC8F6,0xCBFA,0xCDDA,0xCEF4,0xD1B9,0xD4D1),'A','B','C','D','E','F','G','H','J','K','L','M','N','O','P','Q','R','S','T','W','X','Y','Z') AS PY FROM  teaching_plan_class_guidance AS p, dict_departments AS d WHERE   p.dict_departments_id=d.id  ORDER BY py ASC;";
			            	ResultSet yxRs = db.executeQuery(selectDsql);
			           		while(yxRs.next()){
			           		 	out.println("<option value='"+ yxRs.getString("dict_departments_id") +"'>" + yxRs.getString("py") + "-" +yxRs.getString("departments_name") + "</option>");
			            	}if(yxRs!=null){yxRs.close();}
			           	  %>
			            </select>
			            <%-- 选择年份 --%>
			            <select name="school_year"  id="school_year" lay-verify="required">
			               <option value="0">全部年份</option>
				            <%
				            //查询入学年份
				            String school_yearSql="SELECT  DISTINCT school_year FROM  teaching_plan_class_guidance  ORDER BY school_year ASC;";
				            ResultSet school_yearRs = db.executeQuery(school_yearSql);
				            while(school_yearRs.next()){
				            	out.println("<option value='"+ school_yearRs.getString("school_year") +"'>" + school_yearRs.getString("school_year") +  "</option>");
				            }if(school_yearRs!=null){school_yearRs.close();} 
				            %>
			            </select>
			            <%-- 选择状态 --%>
			            <select size="1" name="state_approve_id" id="state_approve_id" style="width: 83; height: 23">
				           <option value="">全部状态</option>
				           <option value="1">已生成</option>
				           <option value="0">待生成</option>
				        </select>
				        
				        <button class="layui-btn" id="select_button" lay-submit lay-filter="statistics">查询</button>
				        <a class="layui-btn layui-btn-small  layui-btn-primary" onclick="shuaxin()"  style="height: 35px;  color: white; background: rgb(25, 160, 148);"> <i class="layui-icon" style="color: #FFF;">&#x1002;</i> 刷新</a>
 		    			<a class="layui-btn layui-btn-small  layui-btn-primary " onclick="help(<%=PMenuId %>)"  style="height: 35px;  color:#A9A9A9; background: rgb(245, 245, 245);"><i class="layui-icon" >&#xe60c;</i>帮助</a>
				</div>
			</form>  
		</div>
	    <table class="cuoz" id="table" data-toggle="table" data-show-toggle="true" data-show-columns="true" data-show-export="true" >
	        <thead>
	            <tr>  
                     <th data-field="计划名"    	data-sortable="true" data-filter-control="select"  data-visible="true">计划名</th>
	                 <th data-field="院系名称"  	data-sortable="true" data-filter-control="select"  data-visible="true">院系名称</th>
	                 <th data-field="入学年份"  	data-sortable="true" data-filter-control="select"  data-visible="true">入学年份</th>
	                 <th data-field="专业名称"  	data-sortable="true" data-filter-control="select"  data-visible="true">专业名称</th>
	                 <th data-field="教学进程表"	data-sortable="true" data-filter-control="select"  data-visible="true">教学进程表</th>
	                 <th data-field="生成状态"  	data-sortable="true" data-filter-control="select"  data-visible="true">生成状态</th>
	            </tr>
	        </thead>
		        <tbody id="tbodys">
		       		
		        </tbody>
	        </table>
	        <div id="pages"  style="float: right;"></div>
	    <script type="text/javascript">  
	    
	    		/*刷新*/
	    		function shuaxin(){
	    			 location.reload();
	    		}
	    		
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
	    		
	    		/*模拟点击一次--查询列表*/
	    		window.onload=function(){
				     $("#select_button").click();
				};
				
				/*生成计划*/
				function generate(sysid){
				
					/*返回的json状态*/
					var generate=PostAjx("?ac=generate&sysid="+sysid,"","","");
				  	if(generate){
				  		layer.msg("生成计划成功！");
				  		setTimeout(function () { shuaxin();}, 800); 
				  	}else{
				  		layer.msg("生成计划异常！");
				  	}		
					 
				}
	    		
			    layui.use(['laypage', 'layer','form'], function(){
			   	 var laypage = layui.laypage,
			   	 	 form = layui.form ,
				  	 layer   = layui.layer;
			    
			    /*查询统计 */
				 form.on('submit(statistics)', function(data){
				 
				 
				    
				 
				 	/*获取表格数据*/
				 	var field=data.field;
				 	
				 	field.page="1";  /*默认页数*/
				 	field.limit="10";/*默认每页条数*/
				 	
				 	var return_date=$.parseJSON(PostAjx("?ac=generate_list&form_date="+JSON.stringify(field),"","",""));
				 	
				 	if(return_date.code==0){
					  	  $("#tbodys").html(return_date.tbody);
				 	      /*清空form表单*/
				    	  document.getElementById("formids").reset();   
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
							    	console.log(field);
							    		var return_date=$.parseJSON(PostAjx("?ac=generate_list&form_date="+JSON.stringify(field),"","",""));
							    		if(return_date.code==0){
										 	  $("#tbodys").html(return_date.tbody);
										  	 
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
	    </script>
	</body> 
</html>
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