<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%--生成任务书分类列表可以添加查询创建 --%>
<%@page trimDirectiveWhitespaces="true" %>
<%@page contentType="text/html; charset=UTF-8" language="java"%>
<%@page import="service.dao.db.Page"%>
<%@page import="v1.haocheok.commom.common"%>
<%@page import="v1.haocheok.commom.entity.UserEntity"%>
<%@page import="org.apache.commons.lang3.StringUtils"%>
<%@include file="../../cookie.jsp"%>

<%
	String teaching_task_id = request.getParameter("teaching_task_id");
	String teacher_id = request.getParameter("jiaoshi");

	
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title></title>
<meta name="renderer" content="webkit">
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
<meta name="apple-mobile-web-app-status-bar-style" content="black"> 
<meta name="apple-mobile-web-app-capable" content="yes">
<meta name="format-detection" content="telephone=no">
<link rel="stylesheet" href="../../js/layui2/css/layui.css">
<script type="text/javascript" src="../../js/jquery-1.9.1.js" ></script><!--通用jquery-->
<script src="../../js/layui2/layui.js"></script>
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
</style>
</head>
<body>
	
<div id="box">
	<blockquote class="layui-elem-quote" style="padding: 5px">
		&nbsp;&nbsp;&nbsp;
		:<span style="margin-left: 15px;">[学年学期号：2009-2010-1]</span>
	</blockquote>
	<div class="layui-field-box">
	    <form class="layui-form" action="?ac=add" method="post">
			<input type="hidden" name="teaching_task_id" value="<%=teaching_task_id%>" />
			<input type="hidden" name="jiaoshi" value="<%=teacher_id%>" />
			
			<%
				String num_sql = "SELECT 	count(1) as row						"+
				"		FROM                                "+
				"		teaching_task_teacher               "+
				"		where teaching_task_id = '"+teaching_task_id+"'	AND	state=0		;";
				int num = db.Row(num_sql);
				if(num>0){
					String set_sql = "SELECT 	id, 						"+
					"		teaching_task_id,          "+
					"		teacherid,                          "+
					"		class_begins_weeks,                 "+
					"		teaching_week_time,                 "+
					"		leixing                                "+
					"		FROM                                "+
					"		teaching_task_teacher               "+
					"		where teaching_task_id = '"+teaching_task_id+"'		AND	state=0		;";
					ResultSet setter = db.executeQuery(set_sql);
					while(setter.next()){
			%>
				<div class="layui-form-item">
		  		<div class="layui-inline">
				    <label class="layui-form-label">任课教师1</label>
				    <div class="layui-input-inline">				    	
				      	<select lay-verType="tips" name="teacherid">
				      		<option value="0"> 请选择老师 </option>
				      		<%
				      			String teacher_sql1 = "select id,teacher_name from teacher_basic";
				      			ResultSet set1 = db.executeQuery(teacher_sql1);
				      			while(set1.next()){
				      		%>
				      			<option value="<%=set1.getString("id")%>" <%if((setter.getString("teacherid")).equals(set1.getString("id"))){out.println("selected='selected'");} %>><%=set1.getString("teacher_name") %></option>
				      		<%}if(set1!=null){set1.close();} %>
				        </select>
				    </div>
			    </div>
			  	<div class="layui-inline">
				    <div class="layui-input-inline">
				      	<select lay-verType="tips" name="type">
				          <option value="1" <%if("1".equals(setter.getString("leixing"))){out.println("selected='selected'");} %>>讲课</option>
				          <option value="2" <%if("2".equals(setter.getString("leixing"))){out.println("selected='selected'");} %>>实验</option>
				        </select>
				    </div>
		      	</div>
		      	<div class="layui-inline">
				    <label class="layui-form-label">学时</label>
				    <div class="layui-input-inline">				    	
				      	<input type="text" name="teaching_week_time" value="<%=setter.getString("teaching_week_time") %>" class="layui-input">
				    </div>
			    </div>
			    <div class="layui-inline">
				    <label class="layui-form-label">周次</label>
				    <div class="layui-input-inline">				    	
				      	<input type="text" name="class_begins_weeks" value="<%=setter.getString("class_begins_weeks") %>" class="layui-input">
				    </div>
			    </div>			  				  
			</div>
			
			<%}if(setter!=null){setter.close();}}else{ %>
			
			<div class="layui-form-item">
		  		<div class="layui-inline">
				    <label class="layui-form-label">任课教师1</label>
				    <div class="layui-input-inline">				    	
				      	<select lay-verType="tips" name="teacherid">
				      		<option value="0"> 请选择老师 </option>
				      		<%
				      			String teacher_sql1 = "select id,teacher_name from teacher_basic";
				      			ResultSet set1 = db.executeQuery(teacher_sql1);
				      			while(set1.next()){
				      		%>
				      			<option value="<%=set1.getString("id")%>"><%=set1.getString("teacher_name") %></option>
				      		<%}if(set1!=null){set1.close();} %>
				        </select>
				    </div>
			    </div>
			  	<div class="layui-inline">
				    <div class="layui-input-inline">
				      	<select lay-verType="tips" name="type">
				          <option value="1">讲课</option>
				          <option value="2">实验</option>
				        </select>
				    </div>
		      	</div>
		      	<div class="layui-inline">
				    <label class="layui-form-label">学时</label>
				    <div class="layui-input-inline">				    	
				      	<input type="text" name="teaching_week_time" value="" class="layui-input">
				    </div>
			    </div>
			    <div class="layui-inline">
				    <label class="layui-form-label">周次</label>
				    <div class="layui-input-inline">				    	
				      	<input type="text" name="class_begins_weeks" value="" class="layui-input">
				    </div>
			    </div>			  				  
			</div>

			<div class="layui-form-item">
		  		<div class="layui-inline">
				    <label class="layui-form-label">任课教师1</label>
				    <div class="layui-input-inline">				    	
				      	<select lay-verType="tips" name="teacherid">
				      		<option value="0"> 请选择老师 </option>
				      		<%
				      			String teacher_sql = "select id,teacher_name from teacher_basic";
				      			ResultSet set = db.executeQuery(teacher_sql);
				      			while(set.next()){
				      		%>
				      			<option value="<%=set.getString("id")%>"><%=set.getString("teacher_name") %></option>
				      		<%}if(set!=null){set.close();} %>
				        </select>
				    </div>
			    </div>
			  	<div class="layui-inline">
				    <div class="layui-input-inline">
				      	<select lay-verType="tips" name="type">
				          <option value="1">讲课</option>
				          <option value="2">实验</option>
				        </select>
				    </div>
		      	</div>
		      	<div class="layui-inline">
				    <label class="layui-form-label">学时</label>
				    <div class="layui-input-inline">				    	
				      	<input type="text" name="teaching_week_time" value="" class="layui-input">
				    </div>
			    </div>
			    <div class="layui-inline">
				    <label class="layui-form-label">周次</label>
				    <div class="layui-input-inline">				    	
				      	<input type="text" name="class_begins_weeks" value="" class="layui-input">
				    </div>
			    </div>			  				  
			</div>
			<%} %>
			<div class="layui-form-item" style="margin-bottom:45px">
				<div class="layui-input-block"  style="margin-left:540px">			
					<button class="layui-btn" lay-submit lay-filter="*"  >确认</button>
				</div>
			</div>
			
		</form>
    </div>
</div>

<br><br><br>

<script>
layui.use(['form','layer','jquery'], function(){
	var form = layui.form;
	var $ = layui.jquery;

	

	//监听提交
	form.on('submit(*)', function(data){
		return true;
	});
  
});

</script>
</body>
</html>


<%
	if("add".equals(ac)){
		String jiaoshi_id = request.getParameter("jiaoshi");
		teaching_task_id = request.getParameter("teaching_task_id");
		String [] teacherids = request.getParameterValues("teacherid");
		String [] class_begins_weeks = request.getParameterValues("class_begins_weeks");
		String [] teaching_week_time = request.getParameterValues("teaching_week_time");
		String [] type = request.getParameterValues("type");
		
		boolean ss = true;
		String del_sql = "DELETE FROM teaching_task_teacher WHERE teaching_task_id = '"+teaching_task_id+"' AND state=0 ;"; 
		boolean state = db.executeUpdate(del_sql);
		System.out.println(state);
		if(state){
			for(int i=0 ; i< teacherids.length;i++){
				
				if(!"".equals(teaching_week_time[i])){
					String add_sql = "INSERT INTO teaching_task_teacher 		"+
					"		(                                           "+
					"		teaching_task_id,                  "+
					"		teacherid,                                  "+
					"		class_begins_weeks,                         "+
					"		teaching_week_time,                         "+
					"		leixing,                                        "+
					"		state										"+
					"		)                                           "+
					"		VALUES                                      "+
					"		(                                           "+
					"		'"+teaching_task_id+"',                "+
					"		'"+teacherids[i]+"',                                "+
					"		'"+class_begins_weeks[i]+"',                       "+
					"		'"+teaching_week_time[i]+"',                       "+
					"		'"+type[i]+"' ,                                     "+
					"		0			"+
					"		);";  
					ss = db.executeUpdate(add_sql);
					if(!ss){
						out.println("<script>parent.layer.msg('多教师设置失败');</script>");
					}
				}
				
			}
		}
		
		if(ss){
			out.println("<script>parent.layer.msg('多教师设置 成功', {icon:1,time:1000,offset:'150px'},function(){var index = parent.layer.getFrameIndex(window.name);parent.layer.close(index);}); </script>");
		}else{
			out.println("<script>parent.layer.msg('添加教师信息 失败');</script>");
		}
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