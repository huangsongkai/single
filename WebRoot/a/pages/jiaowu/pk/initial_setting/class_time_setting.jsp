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
	<title>班级时间设置</title> 
<body>
	<%
	String semester = request.getParameter("semester"); if(semester==null){semester="";}
	String classid = request.getParameter("classid"); if(classid==null){classid="";}
	
	String qSql = "select * from arrage_course_class t where t.semester='"+semester+"'";
	ResultSet qSqlRs = db.executeQuery(qSql);
	StringBuffer sb = new StringBuffer();
	while(qSqlRs.next()){
		sb.append(qSqlRs.getString("totalid")+",");
	}if(qSqlRs!=null)qSqlRs.close();
	%>
<div id="box">
	<blockquote class="layui-elem-quote" style="padding: 5px">
		&nbsp;&nbsp;&nbsp;
		班级时间设置<span style="margin-left: 15px;">[学年学期号：<%=semester %>]</span>
	</blockquote>
	<div class="layui-field-box">
	    <form class="layui-form" action="">
	    	<div class="layui-form-item">
		  		<div class="layui-inline">
				    <label class="layui-form-label">班级</label>
				    <div class="layui-input-inline">				    	
				      	<input type="text" name="班级" value="" class="layui-input">
				    </div>
			    </div>
			    <div class="layui-inline">
				    <input type="button" name="xxx" value="查找" class="layui-btn">
				    <input type="button" name="xxx" value="设置" class="layui-btn">
		      	</div>
			  	<div class="layui-inline">
				    <label class="layui-form-label">已设置班级</label>
				    <div class="layui-input-inline">
				      	<select lay-verType="tips">
				          <option value="">全部</option>
				          <option value="1">1</option>
				          <option value="2" disabled>2</option>
				          <option value="30">30</option>
				        </select>
				    </div>
		      	</div>			  				  
			</div>

			<div class="layui-form-item">
		  		<div class="layui-inline">
				    <label class="layui-form-label">周次</label>
				    <div class="layui-input-inline" style="width: 100px;">
				      	<select lay-verType="tips">
				          <option value="">全部</option>
				          <option value="1">1</option>
				          <option value="2" disabled>2</option>
				          <option value="30">30</option>
				        </select>
				    </div>
			    </div>
			  	<div class="layui-inline">
				    <div class="layui-input-inline" style="width: 260px;">
				      	<input type="checkbox" title="显示已设置[排课/不排课]的周次" lay-skin="primary">
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
									    <div class="layui-input-inline" style="width: 90px;">
									      	<select name="quiz" lay-filter="quiz" lay-verType="tips">
									          <option value="2"></option>
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
			      <textarea placeholder="请输入内容" class="layui-textarea"></textarea>
			    </div>
		    </div>
			<!-- 底部按钮 -->
			<div class="layui-form-item">
				<div class="layui-inline"  style="width: 68%;">
				    <div class="layui-input-inline">
				    	<input type="radio" name="sex" value="nv" title="不排课" checked>
				      	<input type="radio" name="sex" value="nan" title="排课">						
				    </div>
			    </div>
			    <div class="layui-inline" style="width: 28%; text-align: right;">
			      <input type="button" value="保存" class="layui-btn"  lay-submit lay-filter="*">
			      <input type="button" value="删除设置" class="layui-btn" >
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

	//事件监听  
	form.on('checkbox(funxuan)', function(data){
		var selectDom = $(data.elem).parents('tr').find('select');
		if (data.elem.checked == true) {
				for (var i = 0; i < selectDom.length; i++) {
					$(selectDom[i]).next().remove();
				selectDom[i].innerHTML = selectDom.html();
		  		$(selectDom[i]).find("option")[1].setAttribute("selected",true);
		  	}
		} else {
		  	for (var i = 0; i < selectDom.length; i++) {
		  		$(selectDom[i]).find("option")[1].removeAttribute("selected");
		  	}
		}  	 	
		form.render('select');  	
	});

	form.on('checkbox(funxuan2)', function(data){
		var cellIndex = $(data.elem).parents('th').index() - 1;
		var trDom = $(data.elem).parents('thead').next().find('tr');
		if (data.elem.checked == true) {
			for (var i = 0; i < trDom.length; i++) {
				var selectDom = $(trDom[i]).find('select')[cellIndex];
				$(selectDom).next().remove();
				selectDom.innerHTML = $(selectDom).html();    		
		  		$(selectDom).find("option")[1].setAttribute("selected",true);
	  		}
		} else {
		  	for (var i = 0; i < trDom.length; i++) {
		  		var selectDom = $(trDom[i]).find('select')[cellIndex];
				$(selectDom).next().remove();
				selectDom.innerHTML = $(selectDom).html();    		
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

		if (radioVal === "排课") {
			selectBox = '<select name="quiz" lay-filter="quiz" lay-verType="tips"><option value="2"></option><option value="3">排课</option> </select>';
		    $('td').find('select').next().remove();
			$(selectBox).replaceAll($('td').find('select'));
			form.render('select');
		} else {
			selectBox = '<select name="quiz" lay-filter="quiz" lay-verType="tips"><option value="2"></option><option value="1">不排课</option></select>';
		    $('td').find('select').next().remove();
			$(selectBox).replaceAll($('td').find('select'));
			form.render('select');
		}
	});

	//监听提交
	form.on('submit(*)', function(data){
		console.log(data)
		return false;
	});
  
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