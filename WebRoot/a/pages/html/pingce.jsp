<%@ page trimDirectiveWhitespaces="true"%>
<%@ page contentType="text/html; charset=UTF-8" language="java"  import="java.util.regex.*,java.net.*,java.util.*,net.sf.json.*"%>
<%@ page import="java.sql.*" %>
<jsp:useBean id="db" scope="page" class="service.dao.db.Jdbc"/>
<jsp:useBean id="server" scope="page" class="service.dao.db.Page"/>
<%@page import="org.apache.commons.lang3.StringUtils"%>

<%String title = request.getParameter("title");
String uid = request.getParameter("uid"); 
String token = request.getParameter("token");
String semester = request.getParameter("semester");//获取学期
	String semSql = "SELECT academic_year from academic_year where this_academic_tag='true' ";
	ResultSet semRs = db.executeQuery(semSql);
	while(semRs.next()){
		semester=semRs.getString("academic_year");
	}
	if(semRs!=null)semRs.close();
	String classnameSql = "SELECT                                                                            "+
							"			t1.classroomid,t2.class_name                                      "+
							"			FROM                                                              "+
							"				user_worker t                                                 "+
							"			LEFT JOIN student_basic t1 ON t.user_association = t1.id          "+
							"			LEFT JOIN class_grade t2 ON t1.classroomid=t2.id                  "+
							"			WHERE                                                             "+
							"				t.userole = 2                                                 "+
							"			AND t.app_token ='"+token+"'";//获取班级名称
	ResultSet classRs = db.executeQuery(classnameSql);
	String classname="";
	String classid ="";
	while(classRs.next()){
		classid=classRs.getString("classroomid");
		classname=classRs.getString("class_name");
	}if(classRs!=null)classRs.close();
	if(StringUtils.isBlank(classname)||StringUtils.isBlank(classid)){//班级id或班级名称不存在，设置默认都为不存在，检查class_grade对应id
		classid="0";
		classname="无";
	}
%> 

<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>高职评测</title>
<meta name="renderer" content="webkit">
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
<meta name="apple-mobile-web-app-status-bar-style" content="black"> 
<meta name="apple-mobile-web-app-capable" content="yes">
<meta name="format-detection" content="telephone=no">
<link rel="stylesheet" href="../js/layui2/css/layui.css">
<script type="text/javascript" src="../js/jquery-1.9.1.js" ></script>
<script src="../js/layui2/layui.js"></script>
<style>
body{padding: 10px;}
.xz { margin-top: 10px;}
.xzz {font-size: 15;}
</style>
</head>
<body>
	
<div id="box">
	<blockquote class="layui-elem-quote" style="padding: 5px">
		&nbsp;&nbsp;&nbsp;
		高职评测
	</blockquote>
	<div class="layui-field-box">
<!--	    <form class="layui-form" action="" >-->
	        <form class="layui-form" action="?token=<%=token %>&uid=<%=uid %>" method="post" id="forminfo">
	        <input type="hidden" value="<%=uid %>"  id="uid"  name="uid"/>
<%--	        <input type="hidden" value="<%=token %>"  id="token"  name="token"/>--%>
	        <input type="hidden" value=""  id="ac"  name="ac"/>
	         <input type="hidden" value="<%=semester %>"  id="semester" name="semester" />
	         <input type="hidden" value="<%=classid %>"  id="classid" name="classid" />
	         <input type="hidden" value=""  id="total" name="total" />
	         <input type="hidden" value=""  id="a_score" name="a_score" />
	         <input type="hidden" value=""  id="b_score" name="b_score" />
	         <input type="hidden" value=""  id="c_score" name="c_score" />
	         <input type="hidden" value=""  id="d_score" name="d_score" />
	         <input type="hidden" value=""  id="e_score" name="e_score" />
	         <input type="hidden" value=""  id="zong" name="zong" />
	        <h3><%=semester %> 学期教师授课质量测评表</h3>
	        <div style="font-size: 10px;padding-top: 10px;" >
		        <p>参加评教活动的全体同学：</p>
		        <p>			学生评教工作是学院了解和掌握教学过程中各种信息的重要手段，对教师改进教学，提高教学质量具有很重要的价值。要求同学们以客观的态度如实逐项填写评教表。</p>
				<p>注 : 1、以上每要素为5分，其中A为5分，B为3分，C为2分，D为1分。</p>
			</div>
			<div>
				<p style="padding-left: 15px;margin-top: 10px;">班级 : <%=classname %></p>
				<input name="classid"  value="<%=classid%>" type='hidden'/>
				<div class="layui-inline"  style=" margin-top: 10px">
				    <label class="layui-form-label"  style="text-align:  left;width: 56px;">教师姓名</label>
				    <div class="layui-input-inline" style="width: 50%;">				    	
				    	<select name="teacher_name" lay-verify="required"  id="teacher_name" lay-search>
				    		<%
				    			String teacherSql ="SELECT                                                                   "+
											    	"			t.teacherid,t2.teacher_name                                  "+
											    	"			FROM                                                         "+
											    	"				teaching_task_teacher t                                  "+
											    	"			LEFT JOIN teaching_task t1 ON t.teaching_task_id = t1.id     "+
											    	"			LEFT JOIN teacher_basic t2 ON t.teacherid=t2.id              "+
											    	"			WHERE                                                        "+
											    	"				t1.typestate=2                                           "+
											    	"				and t1.class_id != 0 and t1.class_id="+classid;
				    		if(StringUtils.isNotBlank(classid)){
					    		ResultSet teacherRs = db.executeQuery(teacherSql);
					    		String teachername="";
					    		String teacherid ="";
					    		while(teacherRs.next()){
					    			teacherid=teacherRs.getString("teacherid");
					    			teachername=teacherRs.getString("teacher_name");
					    			out.println("<option value='"+teacherid+"'>"+teachername+"</option>");
					    		}if(teacherRs!=null)teacherRs.close();
					    		}
				    		%>
					      </select>
				    </div>
			    </div>
			</div>
			<div id="partone" ></div>
			<div class="layui-form-item" style="text-align: right">
			<div class="layui-inline">
				<button class="layui-btn" lay-submit lay-filter="*">提交</button>   
				</div>
		    </div>
		</form>
    </div>
</div>
<script>
function init(){
	var arr=new Array("教学工作有热情、讲课认真投入")
	arr.push("能把传授知识和塑造人的全面素质结合起来");
	arr.push("有鼓励学生独立思考、创新的表现");
	arr.push("注重方法训练，重视能力培养");
	arr.push("教学态度认真，教学组织严密");
	arr.push("内容充实，信息量大，观点正确");
	arr.push("理论联系实际、例证恰当");
	arr.push("重点突出，难点讲透，概念准确，条理清晰");
	arr.push("语言流畅、标准、精炼，生动幽默，有吸引力");
	arr.push("板书正确工整，板图形象逼真，有助于知识学习");
	arr.push("善于启发、方法灵活，有师生交流互动，气氛活跃");
	arr.push("能应用先进有效的教学手段，提高教学效果");
	arr.push("教师不迟到，不早退，不压堂");
	arr.push("教师不在课堂上做与课堂无关的事情");
	arr.push("能管理学生出勤和课堂纪律");
	arr.push("能按时布置作业、思考题，并及时评阅");
	arr.push("上课有教材、教案及补充讲义");
	arr.push("当堂能理解60%以上的教学内容");
	arr.push("课后能独立完成作业并能归纳出本课程的主要教学内容");
	arr.push("通过学习掌握了该门课的核心内容，并有能力进行自学");
	var html ='';
	for(var i=0;i<arr.length;i++){
		html = html+'<div class="layui-form-item">'+
						'<div  class="xz">'+
							'<label class="xzz">'+(i+1)+'.'+arr[i]+'</label>'+
							'<div class="" >'+
								'<input type="radio" name="'+(i+1)+'" value="5" title="A">'+
								'<input type="radio" name="'+(i+1)+'" value="3" title="B" >'+
								'<input type="radio" name="'+(i+1)+'" value="2" title="C">'+
								'<input type="radio" name="'+(i+1)+'" value="1" title="D" >'+
							'</div>'+
						'</div>'+
					'</div>';
	}
	$('#partone').append(html);
}	

layui.use(['form','layer','jquery'], function(){
	var form = layui.form;
	var layer = layui.layer;
	var $ = layui.jquery;

	$(function(){
		init();
		form.render();
	})
	
	//监听提交
	form.on('submit(*)', function(data){
		 var zong = JSON.stringify(data.field);
		  var uid = $('#uid').val();
		  var semester = $('#semester').val();
		  var teacher_name = $('#teacher_name').val();
		  if(teacher_name=='0'||teacher_name==''){
			 layer.msg("无对应教师");
			return false;
			 }
		var i=0;
		var total=0;
		var a_score=0;
		var b_score=0;
		var c_score=0;
		var d_score=0;
		var e_score=0;
	  $('input[type="radio"]:checked').each(function(){
		i++;
		if($(this).attr("name")=='1'||$(this).attr("name")=='2'||$(this).attr("name")=='3'||$(this).attr("name")=='4'||$(this).attr("name")=='5'){
			a_score = parseInt(a_score) + parseInt($(this).val());
		}
		if($(this).attr("name")=='6'||$(this).attr("name")=='7'||$(this).attr("name")=='8'||$(this).attr("name")=='9'){
			b_score = parseInt(b_score) + parseInt($(this).val());
		}
		if($(this).attr("name")=='10'||$(this).attr("name")=='11'||$(this).attr("name")=='12'){
			c_score = parseInt(c_score) + parseInt($(this).val());
		}
		if($(this).attr("name")=='13'||$(this).attr("name")=='14'||$(this).attr("name")=='15'||$(this).attr("name")=='16'||$(this).attr("name")=='17'){
			d_score =parseInt(d_score) + parseInt($(this).val());
		}
		if($(this).attr("name")=='18'||$(this).attr("name")=='19'||$(this).attr("name")=='20'){
			e_score =parseInt(e_score) + parseInt($(this).val());
		}
		total =parseInt(total)+parseInt($(this).val());
	  })
	  if(i!=20){
		layer.msg("请完成测评");
		return false;
	  }else{
		  $('#total').val(total);
		  $('#ac').val("add");
		  $('#a_score').val(a_score);
		  $('#b_score').val(b_score);
		  $('#c_score').val(c_score);
		  $('#d_score').val(d_score);
		  $('#e_score').val(e_score);
		  $('#zong').val(zong);
		return true;
	  }
	  return false; 
	});
});
</script>
</body>
</html>

<%
	String ac = request.getParameter("ac");
	if("add".equals(ac)){
		semester = request.getParameter("semester");
		 uid = request.getParameter("uid");
		 String teacherid = request.getParameter("teacher_name");
		 String  total = request.getParameter("total");
		   classid = request.getParameter("classid");
		 String  a_score = request.getParameter("a_score");
		 String  b_score = request.getParameter("b_score");
		 String  d_score = request.getParameter("d_score");
		 String  c_score = request.getParameter("c_score");
		 String  zong = request.getParameter("zong");
		 String  e_score = request.getParameter("e_score");
		 String checkSql =" select count(t.id) row from student_pingce t where studentid="+uid+" and semester='"+semester+"' and teacherid="+teacherid;
		 int checkNum = db.Row(checkSql);
		 boolean state = false;
		 if(checkNum>0){
			 state =false;
		 }else{
			 String sql =" insert into student_pingce (studentid,teacherid,classid,semester,a_score,b_score,c_score,d_score,e_score,zong,total) values "+"('"+uid+"','"+teacherid+"','"+classid+"','"+semester+"','"+a_score+"','"+b_score+"','"+c_score+"','"+d_score+"','"+e_score+"','"+zong+"','"+total+"')";
			 state = db.executeUpdate(sql);
		 }
		 if(state){
			  out.println("<script>alert('提交成功,谢谢参加评测')</script>");
		 }else{
			  out.println("<script>alert('已参加评测,请勿重新评测')</script>");
		 }
	}
%>
<%
if(db!=null)db.close();db=null;if(server!=null)server=null;
%>