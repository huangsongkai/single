<%@ page trimDirectiveWhitespaces="true" %>
<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@ include file="../../../cookie.jsp"%>
<%@page import="org.apache.commons.lang3.StringUtils"%>
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

   <link rel="stylesheet" href="../../../../pages/css/sy_style.css">	    
   <link rel="stylesheet" href="../../../js/layui2/css/layui.css">
	<script type="text/javascript" src="../../../js/jquery-1.9.1.js" ></script><!--通用jquery-->
	<script type="text/javascript" src="../../../js/layerCommon.js" ></script><!--通用jquery-->
	<script src="../../../js/layui2/layui.js"></script>
		<script type="text/javascript" src="../../../js/ajaxs.js" ></script><!--通用jquery-->
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
	<title>部门时间设置</title> 
<body>
<%
	String semester = request.getParameter("semester"); if(semester==null){semester="";}
	String teaching_room_id = request.getParameter("teaching_room_id"); if(teaching_room_id==null){teaching_room_id="";}
	String weekly = request.getParameter("weekly");if(weekly==null){weekly="0";}
	
	String qSql = "select * from arrage_course_department t where t.semester='"+semester+"' and t.teaching_room_id='"+teaching_room_id+"' and t.weekly='"+weekly+"'";
	ResultSet qSqlRs = db.executeQuery(qSql);
	StringBuffer sb = new StringBuffer();
	String state ="1";//默认不排课 radio
	String remarks ="";
	while(qSqlRs.next()){
		sb.append(qSqlRs.getString("totalid")+",");
		state = qSqlRs.getString("state");
		remarks = qSqlRs.getString("remarks");
	}if(qSqlRs!=null)qSqlRs.close();
	if(StringUtils.isBlank(remarks)){
		remarks = "";
	}
	%>
<div id="box">
	<blockquote class="layui-elem-quote" style="padding: 5px">
		&nbsp;&nbsp;&nbsp;
		部门时间设置:<span style="margin-left: 15px;">[学年学期号：<%=semester %>]</span>
	</blockquote>
	<div class="layui-field-box">
		     <form class="layui-form" action="?ac=depsetting" method="post">
	    	<input name="semester" value="<%=semester%>" type="hidden"/>
			<input name="totalid" value="<%=sb.toString()%>" type="hidden"/>
	    	<div class="layui-form-item">
		  		<div class="layui-inline">
				    <label class="layui-form-label">部门</label>
				    <div class="layui-input-inline">				    	
				      	<select name="teaching_room_id" id="teaching_room_id" lay-filter="teaching_room_id"  lay-verify="required" lay-search>
				      		    <option value="">全部</option>
				      		<%
				      			String teacherSql = "select id,teaching_research_name,campus_id from teaching_research t ";
				      			ResultSet teacherRs = db.executeQuery(teacherSql);
				      			while(teacherRs.next()){
				      				out.println("<option value='"+teacherRs.getString("id")+"'>["+teacherRs.getString("campus_id")+"]"+teacherRs.getString("teaching_research_name")+"</option>");
				      			}if(teacherRs!=null)teacherRs.close();
				      		%>
						</select>
				    </div>
			    </div>
			    <div class="layui-inline">
				    <input type="button" name="xxx" value="开始设置" class="layui-btn">
		      	</div>
			  	<div class="layui-inline">
				    <label class="layui-form-label">已设置部门</label>
				    <div class="layui-input-inline">
				      	<select lay-verType="tips" lay-filter="selecteacher" lay-search>
				          <option value="">全部</option>
				         <%
				         	String selectSql = "SELECT	t.teaching_room_id,t2.teaching_research_name,t2.campus_id FROM	 arrage_course_department t	LEFT JOIN teaching_research t2 on t.teaching_room_id=t2.id WHERE	t.semester = '"+semester+"' GROUP BY t.teaching_room_id";
				         	ResultSet selectSqlRs = db.executeQuery(selectSql);
				         	while(selectSqlRs.next()){
				         		out.println("<option value='"+selectSqlRs.getString("teaching_room_id")+"'>["+selectSqlRs.getString("campus_id")+"]"+selectSqlRs.getString("teaching_research_name")+"</option>");
				         	}
				         %>
				        </select>
				    </div>
		      	</div>			  				  
			</div>

			<div class="layui-form-item">
		  		<div class="layui-inline">
				    <label class="layui-form-label">周次</label>
				    <div class="layui-input-inline" style="width: 100px;">
				      	<select name="weekly"  id="weekly" lay-filter='weekly' lay-verType="tips">
				      	<%
				      		String semesterSql = "select academic_weeks from academic_year where academic_year='"+semester+"'";
				      		ResultSet semesterRs = db.executeQuery(semesterSql);
				      		int academic_weeks= 19;
				      		while(semesterRs.next()){
				      			academic_weeks  = semesterRs.getInt("academic_weeks");
				      		}if(semesterRs!=null)semesterRs.close();
				      	%>
				          <option value="0">全部</option>
				          <%
				          	int n=1;
				          	while(n<academic_weeks+1){
				          		out.println("<option value='"+n+"'>"+n+"</option>");
				          		n++;
				          	}
				          %>
				        </select>
				    </div>
			    </div>
			  	<div class="layui-inline">
				    <div class="layui-input-inline" style="width: 260px;">
				      	<input type="checkbox" title="只显示已设置[排课/不排课]的周次"  id="showchecked" lay-filter="showchecke"   lay-skin="primary">
				    </div>
		      	</div>			  				  
			</div>
			
			<!-- 表格 -->
			<table class="layui-table">
			  <thead>
			    <tr>
			      <th></th>
			      <%
			      	String weekSql = "select * from arrage_week ";
			      	ResultSet weekRs = db.executeQuery(weekSql);
			      	ArrayList<String> bigAry = new ArrayList<String>();
			      	while(weekRs.next()){
			      		String id = weekRs.getString("id");
			      		String weekday = weekRs.getString("weekday");
			      		bigAry.add(id);
			      		%>
			      		 <th>
								<div class="layui-inline">
								    <div class="layui-input-inline" style="width: 120px;">
								      	<input type="checkbox" lay-filter="funxuan2" name="" title="<%=weekday %>" lay-skin="primary">
								    </div>
							    </div>
					      </th>
			      		<%
			      	}if(weekRs!=null)weekRs.close();
			      %>
			    </tr> 
			  </thead>
			  <tbody>
				<%
			  	String sectionSql = "select * from arrage_section";
			  	ResultSet sectionRs = db.executeQuery(sectionSql);
			  	while(sectionRs.next()){
			  		String id = sectionRs.getString("id");
			  		String sectionname = sectionRs.getString("sectionname");
			  		%>
			  		  <tr>
					      <td>
								<div class="layui-inline">
								    <div class="layui-input-inline" style="width: 120px;">
								      	<input type="checkbox" lay-filter="funxuan" name="" title="<%=sectionname %>" lay-skin="primary">
								    </div>
							    </div>
					      </td>
					      <%
					      int j=0;
							while(j<bigAry.size()){
								%>
								<td>
									<div class="layui-inline">
									<input name='classinfo' value2='<%=id+"|"+bigAry.get(j) %>'   class='classinfo' value='<%=id+"|"+bigAry.get(j) %>' type='hidden' >
									    <div class="layui-input-inline" style="width: 90px;">
									      	<select name="quiz"  lay-filter='changeval'  lay-verType="tips">
									          <option value="2"> </option>
									          <option value="1">不排课</option>
									        </select>
									    </div>
								    </div>
						      </td>
							<%j++;}%>
					    </tr>
			  		<%	} if(sectionRs!=null)sectionRs.close();  %>			 
			  		 </tbody>
			</table>

			<div class="layui-form-item layui-form-text">
			    <label class="layui-form-label" style="width: auto;">备注</label>
			    <div class="layui-input-block">
			      <textarea placeholder="请输入内容"  name="remarks"   class="layui-textarea"><%=remarks %></textarea>
			    </div>
		    </div>
			<!-- 底部按钮 -->
			<div class="layui-form-item">
				<div class="layui-inline"  style="width: 68%;">
				    <div class="layui-input-inline">
				    	 	<input type="radio" name="sex" value="1" title="不排课" checked>
				      	<input type="radio" name="sex" value="3" title="排课">						
				    </div>
			    </div>
			    <div class="layui-inline" style="width: 28%; text-align: right;">
			      <button class="layui-btn" lay-submit lay-filter="formDemo">确定</button>
			        <a id="del" class="layui-btn layui-btn-primary" value="<%=teaching_room_id%>">删除设置</a>
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

	$(function(){
		var teaching_room_id = '<%=teaching_room_id%>';
		var weekly = '<%=weekly%>';
		if(teaching_room_id==''){
			return false;
			}
		//设置页面初始值
		$('#teaching_room_id').val(teaching_room_id);
		$("#weekly").val(weekly);
		//赋值radio
		var state = '<%=state%>';
		$(":radio[name='sex'][value='" + state + "']").prop("checked", "checked");
		form.render('radio');  
		if(state=='3'){
			var selectBox = '<select name="quiz" lay-filter="changeval" lay-verType="tips"><option value="2"></option><option value="3">排课</option></select>';
		    $('td').find('select').next().remove();
			$(selectBox).replaceAll($('td').find('select'));
			form.render('select');
			}
		var a = $('input[name="totalid"]').val();
		var as = a.split(',');
		for(var i =0;i<as.length-1;i++){
			 $("input[name='classinfo']").each(function(){
				    var value2 = $(this).attr('value2');
				    if(as[i].indexOf(value2)==0){
				    	var d = as[i].substr(as[i].lastIndexOf('|')+1);
				    	$(this).val(as[i]);
					    $(this).next().find('select').val(d);
					    }
				  });
			}
		form.render('select');  
	})
	
	//设置状态
	var statehtml = $('select[name="weekly"]').html();
	   $('#del').click(function(event) {
		   var teaching_room_id = $(this).attr("value");
		   var semester = $('input[name="semester"]').val();
		   if(teaching_room_id==''){
				layer.msg('请选择要删除部门');
			}else{
				layer.confirm('确定删除该部门设置?', function(index){
					var str = {"teaching_room_id":teaching_room_id,"semester":semester,"weekly":weekly};
		    		var obj = JSON.stringify(str);
		    		var ret_str=PostAjx('../../../../../Api/v1/?p=web/do/doDelArrDep',obj,'<%=Suid%>','<%=Spc_token%>');
		    		var obj = JSON.parse(ret_str);
		    		if(obj.success && obj.resultCode=="1000"){
		    			successMsg("删除成功");	    			 
		    		}else{
		    			errorMsg("删除失败");
		    		}
					  layer.close(index);
					}); 
				}
   });
	
	//事件监听  
	form.on('checkbox(funxuan)', function(data){
		var selectDom = $(data.elem).parents('tr').find('select');
		var c = $("input[name='sex']:checked").val();
		if (data.elem.checked == true) {
				for (var i = 0; i < selectDom.length; i++) {
					$(selectDom[i]).next().remove();
				selectDom[i].innerHTML = selectDom.html();
				var b = $(selectDom[i]).parent().prev().attr('value2');
				b = b +"|"+c;
				 $(selectDom[i]).parent().prev().val(b);
		  		$(selectDom[i]).find("option")[1].setAttribute("selected",true);
		  	}
		} else {
		  	for (var i = 0; i < selectDom.length; i++) {
		  		var b = $(selectDom[i]).parent().prev().attr('value2');
				 $(selectDom[i]).parent().prev().val(b);
		  		$(selectDom[i]).find("option")[1].removeAttribute("selected");
		  	}
		}  	 	
		form.render('select');  	
	});
	
	form.on('checkbox(showchecke)', function(data){
		var semester = $('input[name="semester"]').val();
		  var teaching_room_id = $('select[name="teaching_room_id"]').val();
		  if(teaching_room_id==''){
				layer.msg('请选择部门');
			}
		var state = $('#showchecked').is(':checked');
		if(state){
			var str = {"teaching_room_id":teaching_room_id,"semester":semester};
  		var obj = JSON.stringify(str);
  		var ret_str=PostAjx('../../../../../Api/v1/?p=web/do/getDepWeek',obj,'<%=Suid%>','<%=Spc_token%>');
  		var obj = JSON.parse(ret_str);
  		if(obj.success && obj.resultCode=="1000"){
  			$('select[name="weekly"]').html(obj.data);
  		}else{
  		}
			}else{
				$('select[name="weekly"]').html(statehtml);
			}
		form.render('select');  	
	});

	form.on('checkbox(funxuan2)', function(data){
		var cellIndex = $(data.elem).parents('th').index() - 1;
		var trDom = $(data.elem).parents('thead').next().find('tr');
		var c =  $("input[name='sex']:checked").val();
		if (data.elem.checked == true) {
			for (var i = 0; i < trDom.length; i++) {
				var selectDom = $(trDom[i]).find('select')[cellIndex];
				$(selectDom).next().remove();
				selectDom.innerHTML = $(selectDom).html();    		
				var b = $(selectDom).parent().prev().attr('value2');
				b = b +"|"+c;
				 $(selectDom).parent().prev().val(b);
		  		$(selectDom).find("option")[1].setAttribute("selected",true);
	  		}
		} else {
		  	for (var i = 0; i < trDom.length; i++) {
		  		var selectDom = $(trDom[i]).find('select')[cellIndex];
				$(selectDom).next().remove();
				selectDom.innerHTML = $(selectDom).html();   
				var b = $(selectDom).parent().prev().attr('value2');
				 $(selectDom).parent().prev().val(b); 		
		  		$(selectDom).find("option")[1].removeAttribute("selected");
		  	}
		}  	 	
		form.render('select'); 
	});        

	form.on('radio', function(data){
		var radioVal = data.elem.title;
		var selectBox = '';
		$('table').find("input[type='checkbox']").removeAttr('checked');
		$('table').find("input[type='checkbox']").next().remove();
		form.render('checkbox');
		$('.classinfo').each(function(){
				$(this).val($(this).attr('value2'));
			})
		if (radioVal === "排课") {
			selectBox = '<select name="quiz" lay-filter="changeval" lay-verType="tips"><option value="2"></option><option value="3">排课</option></select>';
		    $('td').find('select').next().remove();
			$(selectBox).replaceAll($('td').find('select'));
			form.render('select');
		} else {
			selectBox = '<select name="quiz" lay-filter="changeval" lay-verType="tips"><option value="2"></option><option value="1">不排课</option> </select>';
		    $('td').find('select').next().remove();
			$(selectBox).replaceAll($('td').find('select'));
			form.render('select');
		}
	});

	 form.on('select(changeval)', function(data){
		    var b = $(this).parent().parent().parent().parent().find('.classinfo').attr('value2');
		    b = b+"|"+data.value;
		     $(this).parent().parent().parent().parent().find('.classinfo').val(b);
		  });
	  
	 form.on('select(teaching_room_id)', function(data){
		  var semester = $('input[name="semester"]').val();
		  var teaching_room_id = $("#teaching_room_id").val();
		  var weekly = $('#weekly').val();
		 	location.href ="dep_time_setting.jsp?semester="+semester+"&teaching_room_id="+teaching_room_id+"&weekly="+weekly;
		  });
	 form.on('select(selecteacher)', function(data){
		  var semester = $('input[name="semester"]').val();
		  var teaching_room_id = data.value;
		  var weekly = $('#weekly').val();
		 	location.href ="dep_time_setting.jsp?semester="+semester+"&teaching_room_id="+teaching_room_id+"&weekly="+weekly;
		  });
	 form.on('select(weekly)', function(data){
			 var semester = $('input[name="semester"]').val();
			  var teaching_room_id = $('select[name="teaching_room_id"]').val();
			  if(teaching_room_id==''){
					layer.msg('请选择部门');
					return false;
				  }
			  var weekly = $('select[name="weekly"]').val();
		 	location.href ="dep_time_setting.jsp?semester="+semester+"&teaching_room_id="+teaching_room_id+"&weekly="+weekly;
		  });

	//监听提交
	form.on('submit(formDemo)', function(data){
		if($('select[name="teaching_room_id"]').val()==''){
			alert('请选择部门');
			return false;
			}
	    return true;
	});


	<%
	if("depsetting".equals(ac)){
		String[] classinfos=request.getParameterValues("classinfo"); 
		 semester = request.getParameter("semester");
		  remarks = request.getParameter("remarks");
		  weekly = request.getParameter("weekly");
			state = request.getParameter("sex");
		  teaching_room_id = request.getParameter("teaching_room_id");
			String delSql = "delete from arrage_course_department where semester= '"+semester+"' and teaching_room_id='"+teaching_room_id+"' and weekly='"+weekly+"'" ;
			System.out.println("--------"+delSql);
			boolean updateStatus = db.executeUpdate(delSql);
			boolean states = true;
			for(int l =0;l<classinfos.length;l++){
				if(classinfos[l].split("\\|").length>2){
					String[] b = classinfos[l].split("\\|");
					String checkSql = "select count(id) row from arrage_course_department t where t.section_id="+b[0]+" and week_id = "+b[1]+" and weekly = '"+weekly+"' and semester= '"+semester+"' and teaching_room_id='"+teaching_room_id+"'" ;
					System.out.println("checkSql "+checkSql);
					String sql ="";
					if(db.Row(checkSql)>0){
						sql = "update arrage_course_department set state="+b[2]+",totalid='"+classinfos[l]+"',remarks='"+remarks+"'  where section_id="+b[0]+" and week_id = "+b[1]+" and semester= '"+semester+"' and weekly='"+weekly+"'"  ;
					}else{
					 sql = "insert into arrage_course_department (section_id,week_id,state,semester,totalid,teaching_room_id,weekly,remarks) values ('"+b[0]+"','"+b[1]+"','"+b[2]+"','"+semester+"','"+classinfos[l]+"','"+teaching_room_id+"','"+weekly+"','"+remarks+"')";
					}
					states = db.executeUpdate(sql);
				}
			}
			if(states==true){
				out.println("successMsg('保存成功');");
			}else{
				out.println("errorMsg('保存失败');");
			}
	}
%>
});

</script>
</body>
</html>

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
if(db!=null)db.close();db=null;if(server!=null)server=null;%>