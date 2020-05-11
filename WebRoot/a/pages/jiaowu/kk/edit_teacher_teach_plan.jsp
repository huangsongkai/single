<%@ page trimDirectiveWhitespaces="true" %>
<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@page import="service.dao.db.Page"%>
<%@include file="../../cookie.jsp"%>
<%@page import="java.util.Date"%>
<%@page import="v1.haocheok.commom.common"%>
<%@page import="java.text.SimpleDateFormat"%>

<%
common common=new common();
   String semester= request.getParameter("semester");
   String taskid = request.getParameter("taskid");
   String taskDisplay ="SELECT	t.*,t4.class_name,t3.teacher_name,t2.course_name  FROM	teaching_task t  	LEFT JOIN dict_courses t2 ON t.course_id = t2.id LEFT JOIN teaching_task_teacher t5 ON teaching_task_id=t.id LEFT JOIN teacher_basic t3 ON t3.id = t5.teacherid LEFT JOIN class_grade t4 ON t.class_id = t4.id	where  t.semester='"+semester+"' and t.id="+taskid;
	System.out.println(taskDisplay);
   ResultSet taskDisplayRs = db.executeQuery(taskDisplay);
	String class_name ="";//班级名称
	String class_id ="";//班级id
	String teacher_name ="";//教师姓名
	String course_name ="";//课程名称
	String class_begins_weeks="";//讲课周次
	String semester_hours ="";//总学时
	while(taskDisplayRs.next()){
			class_id = taskDisplayRs.getString("class_id");
			teacher_name = taskDisplayRs.getString("teacher_name");
			course_name = taskDisplayRs.getString("course_name");
			class_begins_weeks = taskDisplayRs.getString("week_learn_time");
			semester_hours = taskDisplayRs.getString("semester_hours");
			class_name = taskDisplayRs.getString("class_name");
	}
	if(taskDisplayRs!=null)taskDisplayRs.close();
	System.out.println(semester_hours);
%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="utf-8"> 
	    <meta name="viewport" content="width=device-width, initial-scale=1"> 
	    <link rel="stylesheet" href="../../../pages/css/sy_style.css">	    
	    <link rel="stylesheet" href="../../js/layui2/css/layui.css">
		<script type="text/javascript" src="../../js/jquery-1.9.1.js" ></script><!--通用jquery-->
		<script type="text/javascript" src="../../js/ajaxs.js" ></script><!--通用jquery-->
		<script src="../../js/layui2/layui.js"></script>
		<title>修改教师授课计划</title> 
		<style>
			body{padding: 10px;}
			.layui-btn{background: #f4f4f4;border: 1px #e6e6e6 solid;color: #3f3f3f;}
			.layui-btn:hover{color: #000000;}
			.layui-field-box {padding: 10px 0px;}
			.layui-input-block {margin-left: 0px;}
			.layui-btn-primary:hover{border-color: #e6e6e6;}
			.lever{width: 128px;margin: 20px auto;height: 40px;}
			blockquote span{margin-right: 20px;}
			.layui-form-item .layui-inline{line-height: 38px;}
			.layui-table tbody tr:hover{ background-color: #fff;}
			.layui-table tbody td, .layui-table thead th{ text-align: center;}
			.my-table th, .my-table td{padding:0;min-height: 16px;line-height: 16px;font-size: 12px;
			border:none;}
			.my-table{border-collapse: separate;border-spacing:6px;}
			.my-table thead tr{background: none}
			.my-btn{height: 24px;
			line-height: 24px;
			padding: 0 8px;font-size: 12px}
			</style>
	</head>
	<body>
		<div id="box">
	<blockquote class="layui-elem-quote" style="padding: 5px">
		&nbsp;&nbsp;&nbsp;
		教师授课计划<span style="margin-left: 15px;">[学年学期号：<%=semester %>]</span>
	</blockquote>
	<div class="layui-field-box">
	    <form class="layui-form" action="?ac=add" method="post">
	    <input type="hidden"  name="semester"  value="<%=semester %>" />
	    <input type="hidden"  name="taskid"  value="<%=taskid %>" />
	    	<div class="layui-form-item">
		  		<div class="layui-inline">
				    <label class="layui-form-label">课程名称</label>
				    <div class="layui-input-inline">				    	
				    	<select name="class_name" lay-verify="required"  lay-filter="classChange"  disabled>
					        <option value="0" selected=""></option>
					         <%
					        	String classSql = "SELECT	t.*,t4.class_name,t2.course_name  FROM	teaching_task t    	LEFT JOIN dict_courses t2 ON t.course_id=t2.id  LEFT JOIN class_grade t4 ON t.class_id=t4.id	where  t.semester='"+semester+"' ";
					        	ResultSet base = db.executeQuery(classSql);
					        	while(base.next()){
					        		if(base.getString("id").equals(taskid)){
					        	%>	
					         	<option value="<%=base.getString("id") %>"  selected><%=base.getString("course_name") %> 
					        	<%		}else{
					         %>
					         	<option value="<%=base.getString("id") %>" ><%=base.getString("course_name") %> 
					         	</option>
					         <%}}if(base!=null){base.close();}%>
					      </select>
				    </div>
			    </div>
			    <div class="layui-inline">
<%--				    <input type="button" name="xxx" value="查找" class="layui-btn">--%>
		      	</div>
			  			    			  				  
			</div>
			<div class="layui-form-item">
				<div class="layui-inline">
				    <label class="layui-form-label">版本</label>
				    <div class="layui-input-inline">				    	
				      	<input type="text" name="class_begins_weeks" value="" class="layui-input" readonly>
				    </div>
			    </div>
			      <div class="layui-inline">
				    <label class="layui-form-label">教材参考书</label>
				    <div class="layui-input-inline">				    	
				      	<input type="text" name="班级" value="" class="layui-input" readonly>
				    </div>
				    </div>
			    <div class="layui-inline">
				    <label class="layui-form-label">任课教师</label>
				    <div class="layui-input-inline">				    	
				      	<input type="text" name="teacher_name" value="<%=teacher_name %>" class="layui-input" readonly>
				    </div>
			    </div>
				<div class="layui-inline">
				    <label class="layui-form-label">任课班级</label>
				    <div class="layui-input-inline">				    	
				      	<input type="text" name="class_begins_weeks" value="<%=class_name %>" class="layui-input" readonly>
				    </div>
			    </div>
			    <div class="layui-inline">
				    <label class="layui-form-label">人数</label>
				    <div class="layui-input-inline">				    	
				      	<input type="text" name="班级" value="" class="layui-input">
				    </div>
			    </div>
			    <div class="layui-inline">
				    <label class="layui-form-label">计划学时</label>
				    <div class="layui-input-inline">				    	
				      	<input type="text" name="semester_hours" class="layui-input" value="<%=semester_hours %>">
				    </div>
			    </div>
			      <div class="layui-inline">
				    <label class="layui-form-label">考试(考察)</label>
				    <div class="layui-input-inline">				    	
				      	<input type="text" name="班级" value="" class="layui-input" readonly>
				    </div>
			    </div>
			</div>

			<!-- 操作按钮 -->
			<div class="layui-form-item" style="text-align: center">
			    <div class="layui-inline">
<%--			      <input type="button" value="删除" id="del_teacher_plan"  class="layui-btn" >--%>
<%--			       <button class="layui-btn" lay-submit lay-filter="formDemo">保存</button>--%>
<%--			      <input type="button" value="添加明细" id="addRow" class="layui-btn" >--%>
<%--			      <input type="button" value="删除明细"  id="delRow" class="layui-btn" >--%>
			    </div>
		    </div>
			
			<!-- 表格 -->
			<table id="table_two" class="layui-table">
			      <colgroup>
				    <col width="40">
				    <col width="90">
				    <col width="90">
				    <col width="120">
				    <col width="90">
				    <col width="90">
				    <col width="90">
				    <col width="90">
				    <col width="90">
				    <col width="110">
				  </colgroup>
			  <thead>
			    <tr>
			    	<th><input type="checkbox" lay-filter="funxuan" name="" lay-skin="primary"></th>
						<th>教学周</th>
					<th>时间</th>
					<th>章</th>
					<th>节</th>
					<th>授课题目</th>
					<th>学时分配</th>
					<th>作业布置</th>
					<th>备注</th>
					<th>辅助教师</th>
					<th>操作</th>
			    </tr>
			  </thead>
			  	  <tbody>
			  <% 
			  				String sql = "select * from teaching_plan_teacher where teaching_task_id="+taskid +" order by week ";
			  				ResultSet rs = db.executeQuery(sql);
			  				while(rs.next()){
			  					System.out.println(rs.getString("teacherid"));
			  		%>			
			  <tr>
					    	<td><input type="checkbox" lay-filter="funxuan2" name="" lay-skin="primary" ><div class="layui-unselect layui-form-checkbox" lay-skin="primary"><i class="layui-icon"></i></div><input type="hidden" name="teaching_plan_id" value="<%=rs.getString("id") %>" class="layui-input"></td>
							<td><input type="text" name="week" value="<%=rs.getString("week") %>" class="layui-input"></td>
							<td>
							<input type="text"  name="time" value="<%=rs.getString("time") %>" class="layui-input time" readonly>
							</td>
							<td><input type="text" name="chapter" value="<%=rs.getString("chapter") %>" class="layui-input"></td>
							<td><input type="text" name="section" value="<%=rs.getString("section") %>" class="layui-input "></td>
							<td><input type="text" name="teach_title" value="<%=rs.getString("teach_title") %>" class="layui-input"></td>
							<td>
							<input type="text" name="time_distribution" value="<%=rs.getString("time_distribution") %>" class="layui-input need_time">
							</td>
							<td>
							<input type="text" name="homework" value="<%=rs.getString("homework") %>" class="layui-input">
							</td>
							<td>
							<input type="text" name="remark" value="<%=rs.getString("remark") %>" class="layui-input">
							</td>
							<td>
							<input type="text" name="teachername" value="<%=rs.getString("teachername") %>" class="layui-input" readonly>
							<input type='hidden'  value="<%=rs.getString("teacherid") %>"  name="teacherid" />
							</td>
							<td>
<%--								<p onclick="zhiding(this)" >指定教师</p>--%>
							</td>
					    </tr>
			  			<%	}  %>
		
				
			  </tbody>
			</table>			
		</form>
    </div>
</div>

<script>

//指定多个教师
function zhiding(dom){
	var teachername = $(dom).parent().prev().find('input[name="teachername"]');
	var teacherid = $(dom).parent().prev().find('input[name="teacherid"]');
	var  teacheridval= teacherid.val();
	var a ='';
	var b='';
   	 layer.open({
		 type: 2,
		  title: '新建教师授课计划',
		  area: ['60%', '80%'],
		  content: 'teacher_zhiding.jsp?teacherids='+teacheridval,
		  btn: ['确定']
         ,yes: function(index, layero){
	   		var body = layer.getChildFrame('body', index); 
             $(body).find('select').each(function(){
                 	if($(this).val()!=0){
					 a =	a+$(this).val()+",";
					 b = b+ $(this).find("option:selected").text()+",";
                     	}
                 })
                 a=a.substring(0,a.lastIndexOf(','));
                 b=b.substring(0,b.lastIndexOf(','));
                 teachername.val(b);
                 teacherid.val(a);
              	layer.close(index);
         }
		});
	}

		layui.use(['form','layer','jquery','laydate'], function(){
			var form = layui.form;
			var layer = layui.layer;
			var laydate = layui.laydate;
			var $ = layui.jquery;

			lay('.time').each(function(){
				  laydate.render({
				    elem: this
				  });
				});
			
			var removeNodes = [];
			//监听全选和全不选  
			form.on('checkbox(funxuan)', function(data){
				var checkboxNodes = $('#table_two tbody').find("input[type='checkbox']");
				if (data.elem.checked == true) {
					for(var i=0; i < checkboxNodes.length; i ++) {
						checkboxNodes[i].checked = true ;
						removeNodes.push($(checkboxNodes[i]).parents('tr').index());
					}
					form.render('checkbox');	  	
				} else {
				  	for(var i=0; i < checkboxNodes.length; i ++) {
						checkboxNodes[i].checked = false ;
					}
					removeNodes.length = 0;
					form.render('checkbox');
				}  	 			  	
			}); 
		
			// 监听每行复选框
			form.on('checkbox(funxuan2)', function(data){
				var trNode = $(data.elem).parents('tr').index();
				if (data.elem.checked == true) {
					removeNodes.push(trNode);
				} else {
				  	removeNodes.removeByValue(trNode);
				} 	 	 
			});   
		
			// 增加明细  按钮事件
			$('#addRow').click(function(event) {
				var dom = `<tr>
					    	<td><input type="checkbox" lay-filter="funxuan2" name="" lay-skin="primary"><input type="hidden" name="teaching_plan_id" value="0" ></td>
							<td><input type="text" name="week" value="" class="layui-input"></td>
							<td><input type="text" name="class_type" value="" class="layui-input"></td>
							<td><input type="text" name="section_content" value="" class="layui-input"></td>
							<td><input type="text" name="need_time" value="" class="layui-input need_time"></td>
							<td><input type="text" name="teaching_method" value="" class="layui-input"></td>
							<td><input type="text" name="teaching_site" value="" class="layui-input"></td>
							<td><input type="text" name="teaching_aids" value="" class="layui-input"></td>
							<td><input type="text" name="teacherid" value="" class="layui-input"></td>
							<td>
								<div class="layui-btn-group">
								  <button class="layui-btn my-btn">增加</button>
								</div>
							</td>
					    </tr>`;
					    $('#table_two tbody').children().find('input[name="teacherid"] :last-child').val('');
					    var dom = $('#table_two tbody').children().html();
						dom = "<tr>"+dom+"</tr>";
					    $('#table_two').find('tbody').append(dom);
					    $('#table_two tbody').find('input :last').val('');
					    $('#table_two tbody').find('input :last').prev().val('');
					    $('#table_two thead').find('input[type="checkbox"]')[0].checked = false;
					    form.render('checkbox');
						lay('.time').each(function(){
							  laydate.render({
							    elem: this
							  });
							});
					    form.render();
			});
		
			// 删除明细  按钮事件
			$('#delRow').click(function(event) {
				if (removeNodes.length != 0) {
					var trNodes = $('#table_two tbody tr');
					for(var i=0; i < removeNodes.length; i ++) {
						var aa = trNodes[removeNodes[i]];				
						$(aa).remove();
					}
					$('#table_two thead').find('input[type="checkbox"]')[0].checked = false;
					form.render('checkbox');
					removeNodes.length = 0;
				} else {
					layer.msg('请先选择');
				}
				
			});
				
			//监听提交
			form.on('submit(formDemo)', function(data){
				var class_name = $('select[name="class_name"]').val();
				var semester_hours = $('input[name="semester_hours"]').val();
				if(class_name=='0'){
					layer.msg("请选择课程名称");
					return false;
					}
				var a =0;
				$(".need_time").each(function(){
					a = parseInt(a)+parseInt($(this).val());
					})
				if(a!=semester_hours){
					layer.msg('总学时与需要学时和不相等');
					return false;
					}	
				
			});
		
			//原生数组增加移除的方法
		    Array.prototype.removeByValue = function(val) {
		      for(var i=0; i<this.length; i++) {
		        if(this[i] == val) {
		          this.splice(i, 1);
		          break;
		        }
		      }
		    }
		  
		});

</script>
	</body>
</html>

<%
	if("add".equals(ac)){
		semester = request.getParameter("semester");
		String teaching_task_id = request.getParameter("taskid");
		String[] weeks = request.getParameterValues("week");
		String[] time = request.getParameterValues("time");
		String[] chapter = request.getParameterValues("chapter");
		String[] section = request.getParameterValues("section");
		String[] teach_title = request.getParameterValues("teach_title");
		String[] time_distribution = request.getParameterValues("time_distribution");
		String[] homework = request.getParameterValues("homework");
		String[] teacherid = request.getParameterValues("teacherid");
		String[] teachername =request.getParameterValues("teachername");
		String[] remark =request.getParameterValues("remark");
		boolean upstate = false;
		String delsql = "DELETE from teaching_plan_teacher where  teaching_task_id="+teaching_task_id;
		 upstate = db.executeUpdate(delsql);
		for(int i=0;i<weeks.length;i++){
				String sql1 = "insert into teaching_plan_teacher (teaching_task_id,week,time,chapter,section,teach_title,time_distribution,homework,teacherid,teachername,semester,remark,check_state,add_user) values" +"('"+teaching_task_id+"','"+weeks[i]+"','"+time[i]+"','"+chapter[i]+"','"+section[i]+"','"+teach_title[i]+"','"+time_distribution[i]+"','"+homework[i]+"','"+teacherid[i]+"','"+teachername[i]+"','"+semester+"','"+remark[i]+"',1,'"+Suid+"')";
			 upstate = db.executeUpdate(sql1);
		}
		if(upstate){
		   out.println("<script>parent.layer.msg('添加教师授课计划成功', {icon:1,time:1000,offset:'150px'},function(){parent.location.reload();}); </script>");
	   }else{
		   out.println("<script>parent.layer.msg('添加教师授课计划 失败');</script>");
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
 %>
<%
if(db!=null)db.close();db=null;if(server!=null)server=null;
%>