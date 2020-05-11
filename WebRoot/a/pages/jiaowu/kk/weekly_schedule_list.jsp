<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page trimDirectiveWhitespaces="true" %>
<%@page contentType="text/html; charset=UTF-8" language="java"%>
<%@page import="service.dao.db.Page"%>
<%@page import="v1.haocheok.commom.common"%>
<%@page import="v1.haocheok.commom.entity.UserEntity"%>
<%@page import="org.apache.commons.lang3.StringUtils"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="net.sf.json.JSONArray"%>
<%@include file="../../cookie.jsp"%>
<% 
	String semester = request.getParameter("semester");//获取学期
	if(StringUtils.isBlank(semester)){
		String semSql = "SELECT academic_year from academic_year where this_academic_tag='true' ";
		ResultSet semRs = db.executeQuery(semSql);
		while(semRs.next()){
			semester=semRs.getString("academic_year");
		}
		if(semRs!=null)semRs.close();
	}
	semester = semester.replaceAll("\"","");
	
	StringBuffer sql_where = new StringBuffer();	
	String dict_departments_id = request.getParameter("dict_departments_id");
	String zhuanye = request.getParameter("zhuanye");
	//String banji = request.getParameter("banji");
	String schoolYear = request.getParameter("schoolYear");
	
	if(StringUtils.isBlank(dict_departments_id)) dict_departments_id="";
	if(StringUtils.isNotBlank(dict_departments_id)&&!dict_departments_id.equals("0")){
		sql_where.append(" and teaching_task_class.dict_departments_id="+dict_departments_id);
	}
	if(StringUtils.isBlank(zhuanye)) zhuanye="";
	if(StringUtils.isNotBlank(zhuanye)&&!zhuanye.equals("0")){
		sql_where.append(" and teaching_task_class.major_id="+zhuanye);
	}
	if(StringUtils.isBlank(schoolYear)) schoolYear="";
	if(StringUtils.isNotBlank(schoolYear)&&!schoolYear.equals("0")){
		sql_where.append(" and class_grade.school_year="+schoolYear);
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
	    <title><%=Mokuai %></title> 
	   <style type="text/css"> 
	    th { background-color: white; }
	    .btn-group-vertical>.btn, .btn-group>.btn{height:33px;}
        table tr:hover{background:#eeeeee;color:#19A094;}
        #my_table{width: 1000px;height: auto;overflow: auto;margin:0 auto;}
		.layui-table .my_center{text-align: center} 
		.layui-table td{text-align: center;}
		.layui-table .table_img_b {padding:0;background: url(../../../web/images/img1.png) no-repeat; 
			background-size:279px;width: 120px;height: 88px;}
		.layui-table .table_img_s {padding:0;background: url(../../../web/images/img2.png) no-repeat; 
			background-size:48px;width: 48px;height: auto;}
		.layui-table td, .layui-table th {padding: 9px 9px;}
		.layui-table tbody tr:hover{ background-color: #fff;}
       </style>
 	</head> 
	<body>
	    <div class="" style="padding-bottom: 0px;margin-left: 1%;margin-right: 1%; height:auto;">  
			<div id="tb" class="form_top layui-form" style="display: flex;">
	            <select name=semester  id="semester" lay-verify="required"  lay-search>
	            	<option value="0" selected></option>
	            	<%
	            		String semesterSql =  "SELECT t.academic_year FROM academic_year t order by t.academic_year desc ";
	            		ResultSet semesterRs = db.executeQuery(semesterSql);
	            		while(semesterRs.next()){
	            				if(semester.equals(semesterRs.getString("academic_year"))){
	            					%>
	            				<option value="<%=semesterRs.getString("academic_year") %>"  selected><%=semesterRs.getString("academic_year") %></option>
	            					<%}else{%>
	            				<option value="<%=semesterRs.getString("academic_year") %>" ><%=semesterRs.getString("academic_year") %></option>
	            			<%}}%>
	            </select>
	            
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
		            
		            <select name="zhuanye" id="zhuanye" lay-search lay-filter="grade" >
						<option value="">请选择专业</option>
						<%
							String zhuanye_sql = "select id,major_name from major";
							ResultSet zhuanye_set = db.executeQuery(zhuanye_sql);
							while(zhuanye_set.next()){
						%>
							<option value="<%=zhuanye_set.getString("id") %>" ><%=zhuanye_set.getString("major_name") %></option>
						<%}if(zhuanye_set!=null){zhuanye_set.close();} %>
					</select>
					
					 <input type="text" class="layui-input" name="schoolYear" id="schoolYear" placeholder="入学年份" lay-verify="required" value="" style="width:100px">
					
<%--					<select name="nianfen" id="nianfen" lay-search>--%>
<%--						<option value="">请选择班级</option>--%>
<%--						<%--%>
<%--							String banji_sql = "select id,class_name from class_grade";--%>
<%--							ResultSet banji_set = db.executeQuery(banji_sql);--%>
<%--							while(banji_set.next()){--%>
<%--						%>--%>
<%--							<option value="<%=banji_set.getString("id") %>" ><%=banji_set.getString("class_name") %></option>--%>
<%--						<%} %>--%>
<%--					</select>--%>
		            
		        <button class="layui-btn layui-btn-small  layui-btn-primary" onclick="ac_tion('')"  style="height: 35px;  color: white; background: rgb(25, 160, 148);"> <i class="layui-icon" style="color: #FFF;">&#xe615;</i> 搜索</button>
<%--		    	<button class="layui-btn layui-btn-small  layui-btn-primary" onclick="Refresh();ac_tion('')"  style="height: 35px;  color: white; background: rgb(25, 160, 148);"> <i class="layui-icon" style="color: #FFF;">&#x1002;</i> 刷新</button>--%>
		    	<button class="layui-btn layui-btn-small  layui-btn-primary" onclick="editRemark('<%=semester %>')"  style="height: 35px;  color: white; background: rgb(25, 160, 148);">  修改备注</button>
<%--		        <button class="layui-btn layui-btn-small  layui-btn-primary " onclick="help(<%=PMenuId %>)"  style="height: 35px;  color:#A9A9A9; background: rgb(245, 245, 245);">帮助</button>--%>
<%--		        <button class="layui-btn layui-btn-small  layui-btn-primary " onclick="editInfo('');"  style="height: 35px;  color:#A9A9A9; background: rgb(245, 245, 245);">设置</button>--%>
		   	   <input type="button" name="xxx" value="导出excel" onclick="method5('my-table1');" class="layui-btn">
		    </div>
		        <div id="asc" class="form_top layui-form" style="display: flex;    ">
		        <button class="layui-btn layui-btn-small  layui-btn-primary " onclick="saveInfo('');"   style="height: 35px;  color: white; background: rgb(25, 160, 148);" >保存</button>
		        <div class="layui-inline">
					    <label class="layui-form-label" style="color: #19a094;font-size: 20px; margin-top: 4px;">进程:</label>
					    <div class="layui-input-inline" style="margin-top: 4px;">
					      <select id="process" lay-verify=""  lay-filter="process">
					         <%
					        	String process_sql = "SELECT t.id,t.process_symbol,t.process_symbol_name  FROM dict_process_symbol t   order by t.id desc ";
					        	ResultSet processRs = db.executeQuery(process_sql);
					        	while(processRs.next()){
					         %>
					         	<option value="<%=processRs.getString("id") %>" > <%=processRs.getString("process_symbol_name") %> </option>
					         <%}if(processRs!=null){processRs.close();}%>
					      </select>
					    </div>
				</div>
		    </div>
		    
		
    	
    		<%if(semester!="0"){ %>
    		<input type="hidden"  value=""  name="total_info"/>
	    	<table class="layui-table" style="width: 1200px">
				    <colgroup>
				      <col width="20">
				      <col width="30">
				      <col width="48">
				      <col width="140">
				    </colgroup>
				    <thead>
				      <tr>
				        <th class="my_center" colspan="23"><h2>校历  (<%=semester %>) 学期</h2></th>
				      </tr> 
				    </thead>
				    <tbody id="my-table1">
				      <tr>
<%--				        <td class="table_img_s"></td>--%>
							  <td class="table_img_b" colspan="4" rowspan="1"></td>
						<%
							String semesterSql1 ="select academic_weeks from academic_year where academic_year='"+semester+"'";
							ResultSet semeRs = db.executeQuery(semesterSql1);
							int academic_weeks =19;
							while(semeRs.next()){
								academic_weeks= semeRs.getInt("academic_weeks");
							}if(semeRs!=null)semeRs.close();
							for(int i=0;i<academic_weeks;i++){
								%>
									<td  onclick='chageVal("<%=i+2 %>")'><%=i+1 %></td>
								<%
							}
						%>
				      </tr>
				
						<%
							String  weekly_class = "SELECT                                                                                                "+
													"				distinct(t1.id) id,                                                                          "+
													"				t.semester,                                                                          "+
													"				t.dict_departments_id,                                                                          "+
													"				t2.departments_name,                                                                   "+
													"				t1.class_name,                                                                        "+
													"				t3.class_id,                                                                          "+
													"				ifnull(t3.id,'0') weeklyid,                                                                       "+
													"				t3.weekly_info,                                                                       "+
													"				t3.remark                                                                             "+
													"			FROM                                                                                      "+
													"				teaching_task t                                                                 "+
													"			LEFT JOIN class_grade t1 ON t.class_id = t1.id                                      "+
													"			LEFT JOIN dict_departments t2 ON t.dict_departments_id = t2.id                                                  "+
													"			LEFT JOIN weekly_schedule_new t3 ON t.class_id=t3.class_id and t3.semester='"+semester+"'"+
													"			WHERE t.semester = '"+semester+"' order by dict_departments_id desc ";   
						
									//新的sql
									weekly_class = "SELECT																				 "+
												"	  (class_grade.id)                              id,                                  "+
												"	  teaching_task_class.teaching_plan_class_id AS teaching_plan_class_id,              "+
												"	  teaching_task_class.semester,                                                      "+
												"	  teaching_task_class.dict_departments_id,                                           "+
												"	  dict_departments.departments_name,                                                 "+
												"	  class_grade.class_name,                                                            "+
												"	  weekly_schedule_new.class_id,                                                      "+
												"	  IFNULL(weekly_schedule_new.id,'0')            weeklyid,                            "+
												"	  weekly_schedule_new.weekly_info,                                                   "+
												"	  weekly_schedule_new.remark                                                         "+
												"	FROM teaching_task_class                                                             "+
												"	  LEFT JOIN class_grade                                                              "+
												"	    ON teaching_task_class.class_grade_id = class_grade.id                           "+
												"	  LEFT JOIN dict_departments                                                         "+
												"	    ON teaching_task_class.dict_departments_id = dict_departments.id                 "+
												"	  LEFT JOIN weekly_schedule_new                                                      "+
												"	    ON (teaching_task_class.class_grade_id = weekly_schedule_new.class_id            "+
												"	        AND weekly_schedule_new.semester = '"+semester+"')                            "+
												"	WHERE teaching_task_class.semester = '"+semester+"' "+sql_where+"      order by dict_departments_id desc";
									System.out.println(weekly_class);
									ResultSet classRs = db.executeQuery(weekly_class);
									int i=1;
									while(classRs.next()){
										%>
										<tr class="<%="infos_"+classRs.getString("weeklyid") %>"> 
											<td colspan="2"><%
												if(StringUtils.isBlank(classRs.getString("departments_name"))){
													out.println("");
												}else{
													out.println(classRs.getString("departments_name"));
												} %>
												<input type="hidden" value="<%=classRs.getString("dict_departments_id") %>"/>
											</td>
											 <td colspan="2"><%=classRs.getString("class_name") %><input type="hidden" value="<%=classRs.getString("id") %>"></td>
											 <%
											 String weekly_info = classRs.getString("weekly_info");
											 if(StringUtils.isBlank(weekly_info)){
											 	for(int j =i;j<academic_weeks+1;j++){
											 		out.print("<td class='info' id='"+classRs.getString("teaching_plan_class_id")+"'><input type='hidden' value='24'>课堂教学</td>");
											 	}
											 }else{
												 JSONArray jsonArray = JSONArray.fromObject(weekly_info);
													for(int j =i;j<academic_weeks+1;j++){
														boolean cunzai = false;
														int z =0;
														for(int k=0;k<jsonArray.size();k++){
															if(j==jsonArray.getJSONObject(k).getInt("week")){
																z = k;
																cunzai =true;
																break;
															}
														}
														if(cunzai){
															out.print("<td class='info' id='"+classRs.getString("teaching_plan_class_id")+"'><input type='hidden' value='"+jsonArray.getJSONObject(z).get("threadid")+"'>"+jsonArray.getJSONObject(z).get("threadname")+"</td>");
														}else{
															out.print("<td class='info' id='"+classRs.getString("teaching_plan_class_id")+"'><input type='hidden' value='24'>课堂教学</td>");
														}
												 	}
											 }
											 %>
										</tr>
										<%}if(classRs!=null){classRs.close();} %>
					  </tbody>
				      <tr>
				        <td rowspan="5">备注</td>
				        <td colspan="22" rowspan="5">
				        	<%
				        		String remarkSql = "select remark from weekly_schedule_remark t where t.semester ='"+semester+"'";
				        		ResultSet remarkRs = db.executeQuery(remarkSql);
				        		String remark = "";
				        		if(remarkRs.next()){
				        			if(StringUtils.isNotBlank(remarkRs.getString("remark"))){
				        			remark = remarkRs.getString("remark");
				        			}
				        		}
				        		if(remarkRs!=null){remarkRs.close();}
				        	%>
				        	<textarea  class="layui-textarea" readonly ><%=remark%></textarea>
				        	</td>
				      </tr>
				    
				  </table>
				  <%}else{
				  }%>
					
	    </div>    
	    <script>

	    function ac_tion() {
		     //  window.location.href="?ac=&dict_departments_id="+$('#dict_departments_id').val()+"&semester="+$('#semester').val()+"&zhuanye="+$('#zhuanye').val()+"&banji="+$('#banji').val();
		       window.location.href="?ac=&dict_departments_id="+$('#dict_departments_id').val()+"&semester="+$('#semester').val()+"&zhuanye="+$('#zhuanye').val()+"&schoolYear="+$('#schoolYear').val();
		}

	  //搜索内容
		var dict_departments_id='<%=dict_departments_id%>';
		var zhuanye='<%=zhuanye%>';
		var schoolYear='<%=schoolYear%>';
		
		if(dict_departments_id.length>=1){
			modify('dict_departments_id',dict_departments_id);
		}
		if(zhuanye.length>=1){
			modify('zhuanye',zhuanye);
		}
		if(schoolYear.length>=1){
			modify('schoolYear',schoolYear);
		}
		//改变某个id的值
		function modify (id,search_val){
			$("#"+id+"").val(""+search_val+"")
		} 
	    
	    	//修改竖排数值
	    	function chageVal(val){
		    		var processid = $('#process').val();
					var processtyle = $('#process').find('option:selected').html();
					$('[class*=infos]').each(function(){    
						    $(this).children('td:eq('+val+')').html('<input type="hidden" value="'+processid+'">'+processtyle);
						});
		    	}
	    	$(function(){
	    		//修改单元格数值	
				$(".info").bind("click",function(){
					var processid = $('#process').val();
					var processtyle = $('#process').find('option:selected').html();
					var teaching_plan_class_id = $(this).attr("id");
					var obj_str1 = {"process_id":processid,"teaching_plan_class_id":teaching_plan_class_id};
					var obj1 = JSON.stringify(obj_str1)
					var ret_str1=PostAjx('../../../../Api/v1/?p=web/kebiao/getWeeklySchedule',obj1,'<%=Suid%>','<%=Spc_token%>');
					obj1 = JSON.parse(ret_str1);
					if(obj1.success){
						$(this).html("<input type='hidden' value='"+processid+"'>"+processtyle);
					}else{
						layer.msg("您只能选择	:"+	obj1.msg);
					}
					
					});
		    	})
	    	
	    	function saveInfo(){
		    	//如果weeklyid=0，说明是新数据要插入，否则更新
		    	var infos ='';
		    	var semester = '<%=semester %>';
		    	var saveState =true;
	    		$('[class*=infos]').each(function(){
		    	//对于勤务（执勤）控制同一班一个学期不能有两次。
		    		var zhiqin = 0;
	    			$(this).find('.info').each(function(){ 
		    			var a = $(this).find("input").val();
		    			if(a==18){//18  执勤id
							zhiqin = zhiqin + 1;
			    		}
		    		})
		    		if(zhiqin>1){
						saveState = false;
			    	}
		    		var weeklyid =  $(this).attr('class').split('_')[1];
		    		var department = $(this).find('td:eq(0)').find("input").val();
		    		var classid = $(this).find('td:eq(1)').find('input').val();
		    		var infoSize = $('tbody tr:first td').size()-1;
		    		var weekInfos =[];
		    		for(var a=1 ;a<infoSize+1;a++){
			    		var c = $(this).find('td:eq('+(a+1)+')').find('input').val();
			    		if(c==''||c=='undefined'||c=='24'){
								continue;
				    		}
			    		var b = $(this).find('td:eq('+(a+1)+')').text();
			    		var d = {'week':a,'threadid':c,'threadname':b};
			    		weekInfos.push(d);
			    		}
		   
		    		var jsonInfos = JSON.stringify(weekInfos);
		    		var str = {'id':weeklyid,'dict_departments_id':department,'class_id':classid,'semester':semester,'weekly_info':jsonInfos};
		    		str = JSON.stringify(str);
		    		infos = infos+"|"+str ;
		    		})
		    	if(saveState==false){
		    		layer.msg("执勤同一班一个学期不能有两次");
					return false;
			    	}
                 var curWwwPath = window.document.location.href;
			    var pathName = window.document.location.pathname;
			    var pos = curWwwPath.indexOf(pathName);
			    var localhostPath = curWwwPath.substring(0, pos);
			    var projectName = pathName.substring(0, pathName.substr(1).indexOf('/') + 1);
			    var basePath=localhostPath+projectName+"/";
			     var uid = '<%=Suid%>';
			  	var token = '<%=Spc_token%>';
			  	$.ajax({  
			  	    headers : {
			            "X-USERID":""+uid+"",
			            "X-AppId":"8381b915c90c615d66045e54900feeab",// 标明正在运行的是哪个App程序
			            "X-AppKey":"72393aaa69c41a24d0d40e851301647a",// 授权鉴定终端
			            "Token":""+token+"",// 授权鉴定终端
			            "X-UUID":"pc",
			            "X-Mdels":"pc",
				    },
			         type : "post",  
			          url : basePath+"/Api/v1/?p=web/do/doSaveWeek",
			          data : { infos: infos},  
			          success : function(data){  
			          var datas = eval('(' + data + ')');
			          if(datas.success){
							 var semesterval =$('#semester').val();
							layer.msg("保存成功");
							 window.location.href="weekly_schedule_list.jsp?ac=&semester="+semesterval
				          }else{
							layer.msg("保存失败");
					          }
			          }  
		     }); 
		    	}
	    
	    </script>
	    <script>
	  //注意：折叠面板 依赖 element 模块，否则无法进行功能性操作
		layui.use(['element','form','layer' ,'laydate'], function(){
			var element = layui.element;
			var layer = layui.layer;
			  var laydate = layui. laydate;
			var form    = layui.form;
			//监听select
			form.on('select(semester)', function(data){
			    var semesterval = JSON.stringify(data.value);
			    if(semesterval=='0'){
					return false;
				    }else{
					    window.location.href="weekly_schedule_list.jsp?ac=&semester="+semesterval
						return true;
					    }
			});

			  laydate.render({elem: '#schoolYear' ,type: 'year' ,value: ''});
			
			form.on('select(department)',function(data){
				if(data.value!="0"){
					var obj_str1 = {"departments_id":data.value};
					var obj1 = JSON.stringify(obj_str1)
					var ret_str1=PostAjx('../../../../Api/v1/?p=web/info/teachingResearch',obj1,'<%=Suid%>','<%=Spc_token%>');
					obj1 = JSON.parse(ret_str1);
					$("#jiaoyanshi").html(obj1.data);
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
			
			form.on('select(process)', function(data){
				//editInfo();
			}); 

			form.render();
		})
		//编辑分配信息
		function edit_weekinfo(classid,weeklyid,semester){
		    	if(weeklyid=='undefined' || weeklyid=='' || weeklyid=="null"){
					weeklyid="0";
			    	}
	    	  	layer.open({
		       		 type: 2,
		       		  title: '编辑',
		       		  maxmin:1,
		       		  offset: 't',
		       		  area: ['940px', '100%'],
		       		  content: 'weekly_list_edit.jsp?classid='+classid+'&weeklyid='+weeklyid+'&semester='+semester 
		       		});
		    	}
	    </script>
	    <script type="text/javascript">  
	    		 //刷新整个页面
	    		function shuaxin(){
	    			 location.reload();
	    		}
	    		  //编辑备注    
				 function editRemark(semester){
					 	if(semester=='0'){
						 	layer.msg("请选择学期");
							return false;
						 	}
					  	layer.open({
				       		 type: 2,
				       		  title: '编辑',
				       		  maxmin:1,
				       		  area: ['940px', '50%'],
				       		  content: 'weekly_remark_edit.jsp?semester='+semester 
				       		});
					 }
	    </script>
      <%if(request.getParameter("index_id")!=null){//接受从首页过来的变量 直接打开某个任务%> 
	    <script>  look('<%=request.getParameter("index_id")%>','<%=request.getParameter("index_name")%>'); </script> 
	 <%} %>
	</body> 
	<script>
		//excel
		var idTmr;  
		function  getExplorer() {  
		    var explorer = window.navigator.userAgent ;  
		    //ie  
		    if (explorer.indexOf("MSIE") >= 0) {  
		        return 'ie';  
		    }  
		    //firefox  
		    else if (explorer.indexOf("Firefox") >= 0) {  
		        return 'Firefox';  
		    }  
		    //Chrome  
		    else if(explorer.indexOf("Chrome") >= 0){  
		        return 'Chrome';  
		    }  
		    //Opera  
		    else if(explorer.indexOf("Opera") >= 0){  
		        return 'Opera';  
		    }  
		    //Safari  
		    else if(explorer.indexOf("Safari") >= 0){  
		        return 'Safari';  
		    }  
		}  
		function method5(tableid) {  
		    
		    if(getExplorer()=='ie')  
		    {  
		        var curTbl = document.getElementById(tableid);  
		        var oXL = new ActiveXObject("Excel.Application");  
		        var oWB = oXL.Workbooks.Add();  
		        var xlsheet = oWB.Worksheets(1);  
		        var sel = document.body.createTextRange();  
		        //sel.moveToElementText(curTbl);  
		        //sel.select();  
		        sel.moveToElementText(document.getElementById("ieid"))
		        sel.execCommand("Copy");  
		        xlsheet.Paste();  
		        oXL.Visible = true;  
	
		        try {  
		            var fname = oXL.Application.GetSaveAsFilename("Excel.xls", "Excel Spreadsheets (*.xls), *.xls");  
		        } catch (e) {  
		            print("Nested catch caught " + e);  
		        } finally {  
		            oWB.SaveAs(fname);  
		            oWB.Close(savechanges = false);  
		            oXL.Quit();  
		            oXL = null;  
		            idTmr = window.setInterval("Cleanup();", 1);  
		        }  
	
		    }  
		    else  
		    {  
		        tableToExcel(tableid)  
		    }  
		}  
		function Cleanup() {  
		    window.clearInterval(idTmr);  
		    CollectGarbage();  
		}  
		var tableToExcel = (function() {  
		    var uri = 'data:application/vnd.ms-excel;base64,',  
		            template = '<html><head><meta charset="UTF-8"></head><body><table border="1" align="center">{table}</table></body></html>',  
		            base64 = function(s) { return window.btoa(unescape(encodeURIComponent(s))) },  
		            format = function(s, c) {  
		                return s.replace(/{(\w+)}/g,  
		                        function(m, p) { return c[p]; }) }  
		    return function(table, name) { 
		        var id=table;
		        var aaa= $("#"+table).html();
		        var colspan=$("#"+table+" tbody tr td").eq(0).attr("colspan");
		        $("#"+table+" tbody tr td").eq(0).attr("colspan",$("#"+table+" tbody tr td").eq(0).attr("colspan")-2);
		        $(".delete").remove();
		        for(i=0;i<$("#"+table+" tbody tr td").size();i++){
		      	  $("#"+table+" tbody tr td").eq(i).html($("#"+table+" tbody tr td").eq(i).html().replace(/-/g, "━"));
		        }
		        
		        if (!table.nodeType) table = document.getElementById(table)  
		        var ctx = {worksheet: name || 'Worksheet', table: table.innerHTML}  
		        console.log(uri + base64(format(template, ctx)) );
		        window.location.href = uri + base64(format(template, ctx))  
		        //$("#"+id+"").html(aaa);
		    }  
		})()   
	
	</script>
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