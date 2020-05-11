<%@ page trimDirectiveWhitespaces="true" %>
<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@ include file="../../../cookie.jsp"%>
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
	<script src="../../../js/layui2/layui.js"></script>
	<script type="text/javascript" src="../../../js/layerCommon.js" ></script><!--通用jquery-->
	<script type="text/javascript" src="../../../js/ajaxs.js" ></script><!--通用jquery-->

<style>
body{padding: 10px;}
/*#box{width: 900px;margin: 0 auto;}*/
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
	<title>排课时间设置</title> 
<body>
	<%
	String semester = request.getParameter("semester"); if(semester==null){semester="";}
	String weekly = request.getParameter("weekly");if(weekly==null){weekly="0";}
	
	String qSql = "select * from arrage_course_nottime t where t.academic_year='"+semester+"' and t.weekly='"+weekly+"'";
	ResultSet qSqlRs = db.executeQuery(qSql);
	StringBuffer sb = new StringBuffer();
	while(qSqlRs.next()){
		sb.append(qSqlRs.getString("totalid")+",");
	}if(qSqlRs!=null)qSqlRs.close();
	%>
<div id="box">
	<blockquote class="layui-elem-quote" style="padding: 5px">
		&nbsp;&nbsp;&nbsp;
		不规则时间设置:<span style="margin-left: 15px;">[学年学期号：<%=semester %>]</span>
	</blockquote>
	<div class="layui-field-box">
	    <form class="layui-form" action="?ac=timetablesetting" method="post">
	    	<input name="semester" value="<%=semester%>" type="hidden"/>
			<input name="totalid" value="<%=sb.toString()%>" type="hidden"/>
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
				    	<input type="checkbox" title="只显示已设置[排课/不排课]的周次"  id="showchecked" lay-filter="showchecke"  lay-skin="primary">
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
								<%=weekday %>
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
								<%=sectionname %>
					      </td>
					      <%
					      int j=0;
							while(j<bigAry.size()){
								%>
								<td class="changetd">
									<input name='classinfo' value2='<%=id+"|"+bigAry.get(j) %>'   class='classinfo' value='<%=id+"|"+bigAry.get(j) %>' type='hidden' >
						      </td>
							<%j++;}%>
					    </tr>
			  		<%	} if(sectionRs!=null)sectionRs.close();  %>			 
			  		 </tbody>
			</table>

			<div class="layui-form-item">
		  		<div class="layui-inline">
				    <label class="layui-form-label" style="width: 266px;">指定3节连排的课程,起始排课小节次只能是</label>
				    <div class="layui-input-inline" style="width: 100px;">
				      	<input type="text" name="" value="1,2,3,4" class="layui-input">
				    </div>小节
			    </div>			  		  				  
			</div>
			<div class="layui-form-item">
		  		<div class="layui-inline">
				    <label class="layui-form-label" style="width: 266px;">指定3节连排的课程,起始排课小节次只能是</label>
				    <div class="layui-input-inline" style="width: 100px;">
				      	<input type="text" name="" value="1,2,3,4" class="layui-input">
				    </div>小节
			    </div>			  		  				  
			</div>
			<div class="layui-form-item">
		  		<div class="layui-inline">
				    <label class="layui-form-label" style="width: 266px;">指定3节连排的课程,起始排课小节次只能是</label>
				    <div class="layui-input-inline" style="width: 100px;">
				      	<input type="text" name="" value="1,2,3,4" class="layui-input">
				    </div>小节（含5节以上）
			    </div>			  		  				  
			</div>
			<!-- 底部按钮 -->
			<div class="layui-form-item">
			    <div class="layui-input-block" style="width: 300px;margin:40px auto;">
			      <input id="fenGe" type="button" value="课表分割" class="layui-btn">
			        <button class="layui-btn" lay-submit lay-filter="formDemo">确定</button>
			        <a id="del" class="layui-btn layui-btn-primary" value="<%=semester%>">删除</a>
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

  $('#del').click(function(event) {
	   var semester = $('input[name="semester"]').val();
	   var weekly = $('select[name="weekly"]').val();
			layer.confirm('确定删除该时间设置?', function(index){
				var str = {"semester":semester,"weekly":weekly};
	    		var obj = JSON.stringify(str);
	    		var ret_str=PostAjx('../../../../../Api/v1/?p=web/do/doDelTime',obj,'<%=Suid%>','<%=Spc_token%>');
	    		var obj = JSON.parse(ret_str);
	    		if(obj.success && obj.resultCode=="1000"){
	    			successMsg("删除成功");	    			 
	    		}else{
	    			errorMsg("删除失败");
	    		}
				  layer.close(index);
				}); 
});
  
  $(function(){
		var weekly = '<%=weekly%>';
		$("#weekly").val(weekly);
		var a = $('input[name="totalid"]').val();
		var as = a.split(',');
		for(var i =0;i<as.length-1;i++){
			 $("input[name='classinfo']").each(function(){
				    var value2 = $(this).attr('value2');
				    if(as[i].indexOf(value2)==0){
				    	$(this).val(as[i]);
				    	$(this).parent().append("锁定");
					    }
				  });
			}
		form.render('select');  
	})
  
  	var statehtml = $('select[name="weekly"]').html();
  form.on('checkbox(showchecke)', function(data){
		var semester = $('input[name="semester"]').val();
		var  weekly = $('select[name="weekly"]').val();
		var state = $('#showchecked').is(':checked');
		if(state){
			var str = {"semester":semester};
  		var obj = JSON.stringify(str);
  		var ret_str=PostAjx('../../../../../Api/v1/?p=web/do/getTimeWeek',obj,'<%=Suid%>','<%=Spc_token%>');
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
  $('.changetd').click(function(event) {
  	var isLock = $(this).html();
  	var vale = $(this).find('input').attr('value2');
  	if(isLock.indexOf('锁定')>=0){
  		$(this).html(isLock.replace("锁定",''))
  		$(this).find('input').val(vale);
  	  	}else{
  	  	$(this).html(isLock+"锁定");
  	  $(this).find('input').val(vale+"|3");
  	  	  }
  });
  
	 $('#fenGe').click(function(event) {
	  		layer.open({
				  type: 2,
				  title: '课表分割',
				  maxmin:1,
				  offset: 't',
				  shade: 0.5,
				  area: ['100%', '530px'],
				  content: 'class_segmentation.jsp' 
				});
		  });
  //自定义验证规则
  form.verify({
    title: function(value){
      if(value.length < 5){
        return '标题也太短了吧';
      }
    }
    ,pass: [/(.+){6,12}$/, '密码必须6到12位']
  });

	 form.on('select(weekly)', function(data){
		 var semester = $('input[name="semester"]').val();
		  var weekly = $('select[name="weekly"]').val();
	 	location.href ="timetable_setting.jsp?semester="+semester+"&weekly="+weekly;
	  });
  
  //监听提交
  form.on('submit(formDemo)', function(data){
  });
  <%
	if("timetablesetting".equals(ac)){
		String[] classinfos=request.getParameterValues("classinfo"); 
		 semester = request.getParameter("semester");
		  weekly = request.getParameter("weekly");
			String delSql = "delete from arrage_course_nottime where academic_year= '"+semester+"' and weekly='"+weekly+"'" ;
			boolean updateStatus = db.executeUpdate(delSql);
			boolean states = true;
			for(int l =0;l<classinfos.length;l++){
				if(classinfos[l].split("\\|").length>2){
					String[] b = classinfos[l].split("\\|");
					 String sql = "insert into arrage_course_nottime (section_id,week_id,state,academic_year,totalid,weekly) values ('"+b[0]+"','"+b[1]+"','"+b[2]+"','"+semester+"','"+classinfos[l]+"','"+weekly+"')";
					states = db.executeUpdate(sql);
				}
			}
			if(states==true){
				out.println("successMsg('保存成功');");
			}else{
				out.println("layer.msg('保存失败');");
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