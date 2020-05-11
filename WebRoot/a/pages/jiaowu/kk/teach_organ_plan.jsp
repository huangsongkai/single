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
	String class_id = request.getParameter("class_id");
	String major_id = request.getParameter("major_id");
	String type = request.getParameter("type");
	
	if(StringUtils.isBlank(semester)){
		String semSql = "SELECT academic_year from academic_year where this_academic_tag='true' ";
		ResultSet semRs = db.executeQuery(semSql);
		while(semRs.next()){
			semester=semRs.getString("academic_year");
		}
		if(semRs!=null)semRs.close();
	}
	if(class_id==null){
		class_id ="";
	}
	if(major_id==null){
		major_id ="";
	}
	if(type==null){
		type ="2";
	}
	
	semester = semester.replaceAll("\"","");
	//开课表
	String kaikeSql ="SELECT                                                                          "+
				"				t1.course_name,t1.course_system_name,t.id,                                                  "+
				"				t2.nature, t7.category,                                                      "+
				"				t.lecture_classes,                                               "+
				"				t.assessment_id,                                               "+
				"				t.credits_term,                                                  "+
				"				t.semester_hours,                                                "+
				"				t.start_semester,                                               "+
				"				t.check_semester,                                                "+
				"				t.test_semester,                                                 "+
				"				t.class_begins_weeks,                                            "+
				"				t3.class_name,                                                   "+
				"				t3.people_number_nan,                                            "+
				"				t3.people_number_woman,                                          "+
				"				teacher_basic.teacher_name,                                                  "+
				"				t6.marge_name,                                                  "+
				"				t6.marge_name_number,teacher_basic.teacher_name as all_teacher_name                                                 "+
				"			FROM                                                                 "+
				"				teaching_task t                                                  "+
				"			LEFT JOIN dict_courses t1 ON t.course_id = t1.id                     "+
				"			LEFT JOIN dict_course_nature t2 ON t2.id = t.course_nature_id        "+
				"			LEFT JOIN class_grade t3 ON t3.id = t.class_id                       "+
				"			LEFT JOIN marge_class t6 ON t6.id=t.marge_class_id                       "+
				"			LEFT JOIN dict_course_category t7 ON t7.id=t.course_category_id                       "+
				"			LEFT JOIN  teaching_task_teacher on ( teaching_task_teacher.teaching_task_id = t.id  AND state = 1  )                   "+
				"			LEFT JOIN teacher_basic on teaching_task_teacher.teacherid = teacher_basic.id"+
				"			WHERE                                                                "+
				"				t.typestate ="+type+"                                                  "+
				"			AND t.marge_state = 0                                                "+
				"			AND t.class_id ="+class_id+"                                                   "+
				"			AND t.semester = '"+semester+"'";               
	System.out.println(kaikeSql);
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
		<script type="text/javascript" src="../../js/ajaxs.js" ></script>
		<script type="text/javascript" src="../../js/tableExport/js/table-sort.js" ></script><!--表格排序js  css-->
		<script type="text/javascript" chartset="utf8" src="../../js/tableExport/js/table_list.js " ></script><!--表格导出js  css-->
	 
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
				<select name="type" id="type">
					<option value='1'>教学安排表</option>
					<option value='2'  selected>开课通知单</option>
				</select>
	            <select name=semester  id="semester" lay-verify="required" lay-filter="semester" lay-search>
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
	            <select  name="major_id" id="major_id"  lay-search  lay-filter="major">
	            	<option value="" >请选择专业</option>
	            	<%
	            		String majorSql ="SELECT major_name,id from major";
	            		ResultSet majorRs = db.executeQuery(majorSql);
	            		while(majorRs.next()){
	            			if(class_id.equals(majorRs.getString("id"))){
	            			%>
								<option value="<%=majorRs.getString("id")%>" selected><%=majorRs.getString("major_name") %></option>	            			
	            			<%
	            			}else{%>
	            				<option value="<%=majorRs.getString("id")%>"><%=majorRs.getString("major_name") %></option>	            			
	            			<%}
	            		}if(majorRs!=null)majorRs.close();%>
	            </select>
	            <select  name="class_id" id="class_id"  lay-search>
	            	<option value="" >请选择班级</option>
	            	<%
	            		String classSql ="select class_name,id from class_grade";
	            		ResultSet classRs = db.executeQuery(classSql);
	            		while(classRs.next()){
	            			if(class_id.equals(classRs.getString("id"))){
	            			%>
								<option value="<%=classRs.getString("id")%>" selected><%=classRs.getString("class_name") %></option>	            			
	            			<%
	            			}else{%>
	            				<option value="<%=classRs.getString("id")%>"><%=classRs.getString("class_name") %></option>	            			
	            			<%}
	            		}if(classRs!=null)classRs.close();%>
	            </select>
		        <button class="layui-btn layui-btn-small  layui-btn-primary" onclick="ac_tion('')"  style="height: 35px;  color: white; background: rgb(25, 160, 148);"> <i class="layui-icon" style="color: #FFF;">&#xe615;</i> 搜索</button>
		    </div>
		        <div id="asc" class="form_top layui-form" style="display: flex;    ">
		    </div>
    	
    		<input type="hidden"  value=""  name="total_info"/>
	    	<table class="layui-table" >
				    <tbody>
				      <tr>
				      		<td rowspan="2">课程名称</td>
				      		<td rowspan="2">学时</td>
				      		<td  rowspan="2">学分</td>
				      		<td rowspan="2">周时</td>
				      		<td rowspan="2">课程性质</td>
				      		<td rowspan="2">考试</td>
				      		<td rowspan="2">教学环节</td>
						<%
							String semesterSql1 ="select academic_weeks from academic_year where academic_year='"+semester+"'";
							ResultSet semeRs = db.executeQuery(semesterSql1);
							int academic_weeks =19;
							while(semeRs.next()){
								academic_weeks= semeRs.getInt("academic_weeks");
							}if(semeRs!=null)semeRs.close();
							for(int i=0;i<academic_weeks;i++){
								%>
									<td><%=i+1 %></td>
								<%
							}
						%>
							<td rowspan="2">上课班级</td>
							<td rowspan="2">上课人数</td>
							<td rowspan="2">任课教师</td>
				      </tr>
				      <tr>
				      	<%
				    	for(int i=0;i<academic_weeks;i++){
							%>
								<td></td>
							<%
						}
				      	%>
				      </tr>
				      <%
				      if(StringUtils.isNotBlank(class_id)&&StringUtils.isNotBlank(semester)){
				      		ResultSet kaikeRs = db.executeQuery(kaikeSql);
				      		while(kaikeRs.next()){
				      			//判断marge_name是否为空，为空说明没有合班
				      			String className = kaikeRs.getString("marge_name");
				      			int classNum =kaikeRs.getInt("marge_name_number");
				      			if(StringUtils.isBlank(className)){
				      				className = kaikeRs.getString("class_name");
				      				classNum = kaikeRs.getInt("people_number_woman")+kaikeRs.getInt("people_number_nan");
				      			}
				      			%>
				      			<tr class='infos'  taskid="<%=kaikeRs.getString("id") %>" >
				      				<td><%=kaikeRs.getString("course_name") %></td>
				      				<td><%=kaikeRs.getString("semester_hours") %></td>
				      				<td><%=kaikeRs.getString("credits_term") %></td>
				      				<td><%=kaikeRs.getString("start_semester") %></td>
				      				<td><%=kaikeRs.getString("nature") %></td>
				      				<td><% if(kaikeRs.getString("assessment_id").equals("1")){
				      								out.println("考");
				      				}else{ out.println("");} %></td>
				      				<td><%
				      							String corsysname = kaikeRs.getString("course_system_name");
				      							if(StringUtils.isBlank(corsysname)){out.println("无");}
				      							else{
				      								out.println(corsysname);
				      							}
				      							//if("1".equals(corsysname)){out.println("理论");}
				      							//if("2".equals(corsysname)){out.println("实践");}
				      							//if("3".equals(corsysname)){out.println("实验");}
				      				%></td>
			      				  	<%
			      				  	//处理教课周次 格式1-3,6,7-9
			      				  	String class_week = kaikeRs.getString("class_begins_weeks");
			      				  	String[] class_weeks = class_week.split(",");
			      				  	ArrayList<Integer> class_weeksAry = new ArrayList<Integer>();
			      				  	for(int j=0;j<class_weeks.length;j++){
			      				  		if(StringUtils.isNotBlank(class_weeks[j])&&class_weeks[j].indexOf("-")<0){
			      				  			class_weeksAry.add(Integer.parseInt(class_weeks[j]));	
			      				  		}
			      				  		if(StringUtils.isNotBlank(class_weeks[j])&&class_weeks[j].indexOf("-")>=0){
			      				  			String a =class_weeks[j];
				      				  		int a1 = Integer.parseInt(a.substring(0, a.indexOf("-")));
				      						int a2 = Integer.parseInt(a.substring(a.indexOf("-")+1));
				      						for(int l=a1;l<=a2;l++){
				      							class_weeksAry.add(l);	
				      						}
			      				  		}
			      				  	}
							    	for(int i=0;i<academic_weeks;i++){
							    		if(class_weeksAry.contains(i+1)){
							    			out.println("<td>"+kaikeRs.getString("start_semester")+"</td>");	
							    		}else{
							    			out.println("<td></td>");	
							    		}
									}
							      	%>
							      	<td><%=className %></td>
				      				<td><%=classNum %></td>
				      				<td><% if(StringUtils.isNotBlank(kaikeRs.getString("all_teacher_name"))){
				      					out.println(kaikeRs.getString("all_teacher_name"));
				      				}else{
				      					out.println(kaikeRs.getString("teacher_name"));
				      				} %></td>
				      			</tr>
				 <%}if(kaikeRs!=null)kaikeRs.close();  }%>
				 <tr class="total">
				 			<td>总计</td>
				 			<td></td>
				 			<td></td>
				 			<td></td>
				 			<td></td>
				 			<td></td>
				 			<td></td>
				 			<%
					 			for(int i=0;i<academic_weeks;i++){
						    			out.println("<td></td>");	
								}
				 			%>
				 			<td></td>
				 			<td></td>
				 			<td></td>
				 </tr>
				    </tbody>
				  </table>
				  	注 : 
					<div>
							<%
								String jincheng ="select * from dict_process_symbol";
								ResultSet jcRs = db.executeQuery(jincheng);
								while(jcRs.next()){
										out.println(""+jcRs.getString("process_symbol_name")+" : "+jcRs.getString("process_symbol")+"&nbsp;"+"");								
								}if(jcRs!=null)jcRs.close();
							%>
					</div>
					<div>
										注 :  双击修改详情信息
					</div>
	    </div>    
	    <script>
	  
		$(function(){
			var ace = '<%=academic_weeks%>';
			ace = Number(ace);
			for(var tdnum=7;tdnum<ace+7;tdnum++){
				var td10 =0;
					$('.infos').each(function(){
						td10 = eval(td10+Number($(this).find('td').eq(tdnum).text()));
					})
					$('.total').find('td').eq(tdnum).html(td10);
				}
			})
	    
		var semester='<%=semester%>';
		var type ='<%=type%>';
		var class_id ='<%=class_id%>';
		var major_id ='<%=major_id%>';
		if(semester.length>=1){
			modify('semester',semester);
			modify('type',type);
			modify('class_id',class_id);
			modify('major_id',major_id);
		}
		//改变某个id的值
		function modify (id,search_val){
			$("#"+id+"").val(""+search_val+"")
		} 

	    	function saveInfo(){
		    	//如果weeklyid=0，说明是新数据要插入，否则更新
		    	var infos ='';
		    	var semester = '<%=semester %>';
	    		$('[class*=infos]').each(function(){
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
	    
	     function ac_tion() {
		     	if($("select[name='class_id']").val()==''||$("select[name='class_id']").val()=='0'){
					layer.msg("请选择班级");
					return false;
			     	}
		       window.location.href="?ac=&semester="+$('#semester').val()+"&class_id="+$('select[name="class_id"]').val()+"&type="+$('#type').val()+"&major_id="+$('select[name="major_id"]').val();
		}
	  //注意：折叠面板 依赖 element 模块，否则无法进行功能性操作
		layui.use(['element','form','layer'], function(){
			var element = layui.element;
			var layer = layui.layer;
			var form    = layui.form;

			  $(".infos").dblclick(function(){
				  	var id =$(this).attr('taskid');
				  	var semester = $('#semester').val();
					layer.open({
						  type: 2,
						  title: '设置教师',
						  maxmin:1,
						  shade: 0.5,
						  area: ['100%', '100%'],
						  content: 'teach_shezhi.jsp?id='+id+'&school_year='+semester+"&state=1"
					});
		    	});

			  form.on('select(major)',function(data){
					if(data.value!="0"){
						var obj_str1 = {"major_id":data.value};
						var obj1 = JSON.stringify(obj_str1)
						var ret_str1=PostAjx('../../../../Api/v1/?p=web/info/getClassGrade',obj1,'<%=Suid%>','<%=Spc_token%>');
						obj1 = JSON.parse(ret_str1);
						$("#class_id").html(obj1.data);
						form.render('select');
					}
				})
		})
	    </script>
	    <script type="text/javascript">  
	    		 //刷新整个页面
	    		function shuaxin(){
	    			 location.reload();
	    		}
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