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
%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="utf-8"> 
	    <meta name="viewport" content="width=device-width, initial-scale=1"> 
	    	<link rel="stylesheet" href="../../css/sy_style.css">
		<link rel="stylesheet" href="../../js/layui2/css/layui.css" media="all" />
		<script type="text/javascript" src="../../js/jquery-1.9.1.js" ></script>
		<script src="../../../pages/js/ajaxs.js"></script>
	  	<script src="../../../pages/js/layui2/layui2.js" charset="utf-8"></script>
		<title>新增教师授课计划</title> 
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
			
			.layui-input-block{margin-left:108px;}
			</style>
	</head>
	<body>
		<div id="box">
	<blockquote class="layui-elem-quote" style="padding: 5px">
		&nbsp;&nbsp;&nbsp;
		班级时间设置<span style="margin-left: 15px;">[学年学期号：<%=semester %>]</span>
	</blockquote>
	<div class="layui-field-box">
	    <form class="layui-form" action="?ac=add" method="post">
	    
	    <input type="hidden"  name="semester"  value="<%=semester %>" />
	    	<div class="layui-form-item">
		  		<div class="layui-inline">
				    <label class="layui-form-label">课程名称</label>
				    <div class="layui-input-inline">				    	
				    	<select name="class_name" lay-verify="required"  lay-filter="classChange" lay-search>
					        <option value="0" selected=""></option>
					         <%
					        	String classSql = "SELECT	t.*,t4.class_name,t3.teacher_name,t2.course_name  FROM	teaching_task t    	LEFT JOIN dict_courses t2 ON t.course_id=t2.id LEFT JOIN teacher_basic t3 ON t3.id=t.teacher_id LEFT JOIN class_grade t4 ON t.class_id=t4.id	where  t.semester='"+semester+"' ";
					        	ResultSet base = db.executeQuery(classSql);
					        	while(base.next()){
					         %>
					         	<option value="<%=base.getString("id") %>" ><%=base.getString("course_name") %> 
					         	</option>
					         <%}if(base!=null){base.close();}%>
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
				      	<input type="text" name="班级" value="" class="layui-input" readonly>
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
				      	<input type="text" name="teacher_name" value="" class="layui-input" readonly>
				    </div>
			    </div>
			        <div class="layui-inline">
				    <label class="layui-form-label">任课班级</label>
				    <div class="layui-input-inline">				    	
				      	<input type="text" name="班级" value="" class="layui-input" readonly>
				    </div>
			    </div>
			        <div class="layui-inline">
				    <label class="layui-form-label">人数</label>
				    <div class="layui-input-inline">				    	
				      	<input type="text" name="班级" value="" class="layui-input" readonly>
				    </div>
			    </div>
			
			    <div class="layui-inline">
				    <label class="layui-form-label">计划学时</label>
				    <div class="layui-input-inline">				    	
				      	<input type="text" name="semester_hours" value="" class="layui-input" readonly>
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
			       <button class="layui-btn" lay-submit lay-filter="formDemo">保存</button>
			      <input type="button" value="添加明细" id="addRow" class="layui-btn" >
			      <input type="button" value="删除明细"  id="delRow" class="layui-btn" >
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
				<tr>
					    	<td><input type="checkbox" lay-filter="funxuan2" name="" lay-skin="primary"><input type="hidden" name="teaching_plan_id" value="0" ></td>
							<td><input type="text" name="week" value="" class="layui-input"></td>
							<td>
								<input type="text" name="time" value="" class="layui-input time" readonly>
							</td>
							<td><input type="text" name="chapter" value="" class="layui-input"></td>
							<td><input type="text" name="section" value="" class="layui-input "></td>
							<td><input type="text" name="teach_title" value="" class="layui-input"></td>
							<td>
							<input type="text" name="time_distribution" value="" class="layui-input need_time">
							</td>
							<td>
							<input type="text" name="homework" value="" class="layui-input">
							</td>
							<td>
							<input type="text" name="remark" value="" class="layui-input">
							</td>
							<td>
									<input type="text" name="teachername" value="" class="layui-input" readonly>
									<input type="hidden" name="teacherid" value="" class="layui-input">
							</td>
							<td>
								<p onclick="zhiding(this)" >指定教师</p>
							</td>
					    </tr>
				
			  </tbody>
			</table>			
		</form>
		    <div>
		    </div>
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
					    	<td><input type="checkbox" lay-filter="funxuan2" name="" lay-skin="primary"></td>
							<td><input type="text" name="week" value="" class="layui-input"></td>
							<td><input type="text" name="class_type" value="" class="layui-input"></td>
							<td><input type="text" name="section_content" value="" class="layui-input"></td>
							<td><input type="text" name="need_time" value="" lay-filter="number" class="layui-input need_time"></td>
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
				var dom = $('#table_two tbody').children().html();
				dom = "<tr>"+dom+"</tr>";
			    $('#table_two').find('tbody').append(dom);
				$('#table_two tbody').find('input :last').val('');
			    $('#table_two thead').find('input[type="checkbox"]')[0].checked = false;
			    form.render('checkbox');
			    form.render();
				lay('.time').each(function(){
					  laydate.render({
					    elem: this
					  });
					});
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

			form.on('select(classChange)',function(data){
				var semester = $('input[name="semester"]').val();
				var str = {"semester":semester,"taskid":data.value};
	    		var obj = JSON.stringify(str);
    	       var curWwwPath = window.document.location.href;
			    var pathName = window.document.location.pathname;
			    var pos = curWwwPath.indexOf(pathName);
			    var localhostPath = curWwwPath.substring(0, pos);
			    var projectName = pathName.substring(0, pathName.substr(1).indexOf('/') + 1);
			    var basePath=localhostPath+projectName+"/";
			    var url =basePath+"/Api/v1/?p=web/get/teaching_plan";
	    		var ret_str=PostAjx(url,obj,'<%=Suid%>','<%=Spc_token%>');
	    		var obj = JSON.parse(ret_str);
	    		if(obj.success && obj.resultCode=="1000"){
		    		$('input[name="teacher_name"]').val(obj.data[0].teacher_name);
		    		$('input[name="semester_hours"]').val(obj.data[0].semester_hours);
	    		}else{
	    		}
				})
				
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
		String class_name = request.getParameter("class_name");
		String checkSql ="select count(id) row from teaching_plan_teacher where teaching_task_id="+class_name;
		if(db.Row(checkSql)>0){
			out.println("<script>parent.layer.msg('教师授课计划已添加,请勿重新添加');</script>");
		}else{
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
			for(int i=0;i<weeks.length;i++){
				String sql = "insert into teaching_plan_teacher (teaching_task_id,week,time,chapter,section,teach_title,time_distribution,homework,teacherid,teachername,semester,remark,check_state,add_user) values" +"('"+class_name+"','"+weeks[i]+"','"+time[i]+"','"+chapter[i]+"','"+section[i]+"','"+teach_title[i]+"','"+time_distribution[i]+"','"+homework[i]+"','"+teacherid[i]+"','"+teachername[i]+"','"+semester+"','"+remark[i]+"',1,'"+Suid+"')";
				 upstate = db.executeUpdate(sql);
			}
			if(upstate){
			   out.println("<script>parent.layer.msg('添加教师授课计划成功', {icon:1,time:1000,offset:'150px'},function(){parent.location.reload();}); </script>");
		   }else{
			   out.println("<script>parent.layer.msg('添加教师授课计划 失败');</script>");
		   }
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