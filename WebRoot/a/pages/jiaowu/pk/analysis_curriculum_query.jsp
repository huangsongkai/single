<%@ page trimDirectiveWhitespaces="true" %>
<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@ include file="../../cookie.jsp"%>

<%
	String xueqi = request.getParameter("xueqi");

	if(xueqi==null){
		xueqi = "0";
	}

%>



<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>按行政班级课表调整</title>
<meta name="renderer" content="webkit">
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
<meta name="apple-mobile-web-app-status-bar-style" content="black"> 
<meta name="apple-mobile-web-app-capable" content="yes">
<meta name="format-detection" content="telephone=no">
<link rel="stylesheet" href="../../js/layui2/css/layui.css">
<script type="text/javascript" src="../../js/jquery-1.9.1.js" ></script><!--通用jquery-->
<script src="../../js/layui2/layui.js"></script>
<script src="../../js/ajaxs.js"></script>
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
.layui-form-label{width: auto;}
</style>
</head>
<body>
	
<div id="box">
	<blockquote class="layui-elem-quote" style="padding: 5px">
		&nbsp;&nbsp;&nbsp;
		按教师课表调整
	</blockquote>
	<div class="layui-field-box">
	    <form class="layui-form" action="">
	    	<div class="layui-form-item">
		    	<div class="layui-inline">
				    <label class="layui-form-label">学期</label>
				    <div class="layui-input-inline" style="width: 150px;">
				      	<select lay-verType="tips" name="xueqi" id="xueqi" lay-filter="xueqi">
				      		<option value="0">全部 </option>
				      		<%
				      			String sql = "select academic_year,this_academic_tag from academic_year ";
				      			ResultSet set = db.executeQuery(sql);
				      			while(set.next()){
				      		%>
				      			<option value="<%=set.getString("academic_year")%>" <%if("true".equals(set.getString("this_academic_tag"))){out.println("selected='selected'");} %>> <%=set.getString("academic_year") %> </option>
				      		<%}if(set!=null){set.close();} %>
				      		
				        </select>
				    </div>
			    </div>
			     <div class="layui-inline">
				    <label class="layui-form-label">周次</label>
				    <div class="layui-input-inline" style="width: 100px;">
				      	<select lay-verType="tips" id="zhouci">
				      		<option value="0">全部</option>
				      		<%
				      			for(int i =1 ; i<=30;i++){
				      		%>
				      			<option value="<%=i%>"><%=i%></option>
				      		<%} %>
				        </select>
				    </div>
			    </div>
			    <div class="layui-inline">
				    <label class="layui-form-label">校区</label>
				    <div class="layui-input-inline" style="width: 150px;">
						<select lay-verType="tips" lay-filter="xiaoqu" id="xiaoqu" name="xiaoqu">
				          <option value="0">全部</option>
				         <%
				          		String xiaoqu = "select id,campus_name from dict_campus";	
				          		ResultSet xiaoquSet = db.executeQuery(xiaoqu);
				          		boolean select =true;
				          		while(xiaoquSet.next()){
				          %>	
				          		<option value="<%=xiaoquSet.getString("id")%>"  <% if(select) out.print("selected"); %>><%=xiaoquSet.getString("campus_name") %></option>
				          <%select=false;}if(xiaoquSet!=null){xiaoquSet.close();} %>
				        </select>
				    </div>
			    </div>
			    <div class="layui-inline">
				    <label class="layui-form-label">院系</label>
				    <div class="layui-input-inline" style="width: 150px;">
				      	<select lay-verType="tips"  lay-search lay-filter="department" id = "department" name="department">
				          
				        </select>
				    </div>
			    </div>
			    
			    
			    <div class="layui-inline">
				    <label class="layui-form-label">教研室</label>
				    <div class="layui-input-inline" style="width: 150px;">
				      	<select lay-verType="tips" lay-search lay-filter="jiaoyanshi" id="jiaoyanshi" name="jiaoyanshi">
				          <option value="">全部</option>
				        </select>
				    </div>
			    </div>
			    <div class="layui-inline">
				    <label class="layui-form-label">教师</label>
				    <div class="layui-input-inline">
				      	<select lay-verType="tips" lay-search lay-filter="teacher" id="teacher" name="teacher">
				        </select>
				    </div>
		      	</div>	
		      	
			    <div class="layui-inline">
				    <input type="button" name="xxx" value="查找" class="layui-btn layui-btn-primary">
				    <input type="button" id="excelid" name="xxx" value="导出excel" onclick="method5('my-table1');" disabled="disabled" class="layui-btn layui-btn-disabled">
				    <input type="button" name="xxx" value="返回上一级" onclick="fanhui();" class="layui-btn layui-btn-primary">
				    
				    <span id="teacher_common" style="padding-left:24px;"></span>
				    
		      	</div>
		      	
		      	
			</div>

			
			
			<!-- 表格 -->
			<table id="my-table1" class="layui-table">
			  <thead>
			    <tr>
			      <th>打印网页</th>
			      
			      
			     <%
			     	for(int i =1 ;i<=7;i++){
			     %>
			      <th>
						<div class="layui-inline">
						    <div class="layui-input-inline" style="width: 120px;">
						      	星期<%=i %>
						    </div>
					    </div>
			      </th>
			      <%} %>
			      
			    </tr> 
			  </thead>
			  <tbody>
			  
			  	<%
			  		int m =0;
			  		for(int j=1;j<8;j=j+2){
			  	%>
			    <tr>
			      <td>
						<div class="layui-inline">
						    <div class="layui-input-inline" style="width: 120px;">
						      	第<%=j %><%=j+1 %>节
						    </div>
					    </div>
			      </td>
			      <%
			      	for(int g=0;g<7;g++){
			      %>
			      	<td id="<%=g %>_<%=m %>" class="moren"></td>
			      <%} %>
			    </tr>
			    
			    <%m++;} %>
			  </tbody>
			</table>

			<!-- 表格 -->
			<table id="my-table2" class="layui-table" style="margin-top: 100px;">
			  <thead>
			    <tr>
			      <th colspan="11" style="text-align: left;">
			      	<div class="layui-form-item" style="margin-bottom: 0;">
					    <label class="layui-form-label">排序方式</label>
					    <div class="layui-input-inline" style="width: 100px;">
					      	<select lay-verType="tips">
					          <option value="">全部</option>
					          <option value="1">1</option>
					          <option value="2" disabled>2</option>
					          <option value="30">30</option>
					        </select>
					    </div>
				    	<div class="layui-input-inline" style="width: 300px;margin-left: 60px;">
						    <input type="radio" name="sex" value="1" title="有课程表课程"  checked lay-filter="kbRadio">
						    <input type="radio" name="sex" value="0" title="无课程表课程" lay-filter="kbRadio">
					    </div>
			    	</div>	
			      </th>
			    </tr> 
			  </thead>
			  
			  
			  <tbody id="lineid">
			    <tr>
			      <td><input type="button" class="" name="" value="&nbsp;+&nbsp;"></td>
			      <td>授课教师</td>
			      <td>开课编号</td>
			      <td>开课课程</td>
			      <td>班级</td>
			      <td>排课人数</td>
			      <td>上课地点</td>
			      <td>开课时间</td>
			      <td>开课周次</td>
			    </tr>		
			    
			  </tbody>
			  
			  
			  
			  
			  
			  
			</table>

			<!-- 底部按钮 -->
			<!-- <div class="layui-form-item">
			    <div class="layui-inline" style="width: 28%; text-align: right;">
			      <input type="button" value="保存" class="layui-btn"  lay-submit lay-filter="*">
			      <input type="button" value="删除设置" class="layui-btn" >
			    </div>
		    </div> -->
		</form>
    </div>
</div>

<br><br><br>


<script type="text/javascript">
	//返回
	function fanhui(){
		window.location.replace('./schedule_find.jsp');
	}




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
	        if (!table.nodeType) table = document.getElementById(table)  
	        var ctx = {worksheet: name || 'Worksheet', table: table.innerHTML}  
	        //console.log(uri + base64(format(template, ctx)) );
	        window.location.href = uri + base64(format(template, ctx))  
	    }  
	})()  


</script>


<script>

$(function(){
	var semester = $('#xueqi').val();
	var obj_str1 = {"semester":semester};
	var obj1 = JSON.stringify(obj_str1)
	var ret_str1=PostAjx('../../../../Api/v1/?p=web/base/print',obj1,'<%=Suid%>','<%=Spc_token%>');
	obj1 = JSON.parse(ret_str1);
	if(obj1.data=="1"){
		$("#excelid").removeAttr("disabled");
		$("#excelid").attr("class","layui-btn layui-btn-primary");
	}
})



layui.use(['form','layer','jquery'], function(){
	var form = layui.form;
	var $ = layui.jquery;


	//监听下拉
	form.on('select(xueqi)',function(data){
		var semester = $('#xueqi').val();
		var obj_str1 = {"semester":semester};
		var obj1 = JSON.stringify(obj_str1)
		var ret_str1=PostAjx('../../../../Api/v1/?p=web/base/print',obj1,'<%=Suid%>','<%=Spc_token%>');
		obj1 = JSON.parse(ret_str1);
		if(obj1.data=="1"){
			$("#excelid").removeAttr("disabled");
			$("#excelid").attr("class","layui-btn layui-btn-primary");
		}

	})



	
	//监听提交
	form.on('submit(*)', function(data){
		return false;
	});
	$(function(){
		var a = $('#xiaoqu').val();
		var obj_str1 = {"xiaoqu":a};
		var obj1 = JSON.stringify(obj_str1)
		var ret_str1=PostAjx('../../../../Api/v1/?p=web/info/campusGetDepartment',obj1,'<%=Suid%>','<%=Spc_token%>');
		obj1 = JSON.parse(ret_str1);
		$("#department").html(obj1.data);
		form.render('select');
		})
	form.on('select(xiaoqu)',function(data){
		//校区 获取院系
		if(data.value!="0"){
			
			var obj_str1 = {"xiaoqu":data.value};
			var obj1 = JSON.stringify(obj_str1)
			var ret_str1=PostAjx('../../../../Api/v1/?p=web/info/campusGetDepartment',obj1,'<%=Suid%>','<%=Spc_token%>');
			obj1 = JSON.parse(ret_str1);
			$("#department").html(obj1.data);
			form.render('select');
		}
	})

	//院系
	form.on('select(department)',function(data){
		if(data.value!="0"){
			var obj_str1 = {"departments_id":data.value};
			var obj1 = JSON.stringify(obj_str1)
			var ret_str1=PostAjx('../../../../Api/v1/?p=web/info/teachingResearch',obj1,'<%=Suid%>','<%=Spc_token%>');
			obj1 = JSON.parse(ret_str1);
			$("#jiaoyanshi").html(obj1.data);

			//院系查找老师
			var obj_str2 = {"departments_id":data.value};
			var obj2 = JSON.stringify(obj_str2)
			var ret_str2=PostAjx('../../../../Api/v1/?p=web/info/getteacherToDepartment',obj2,'<%=Suid%>','<%=Spc_token%>');
			obj2 = JSON.parse(ret_str2);
			$("#teacher").html(obj2.data);
			form.render('select');

		}
	})
	
	//教研室
	form.on('select(jiaoyanshi)',function(data){
		var departments_id = $("#department").val();
		if(data.value!="0"&&departments_id!="0"){
			var obj_str2 = {"departments_id":departments_id,"jiaoyanshi":data.value};
			var obj2 = JSON.stringify(obj_str2)
			var ret_str2=PostAjx('../../../../Api/v1/?p=web/info/getteacherToDepartmentAndjiao',obj2,'<%=Suid%>','<%=Spc_token%>');
			obj2 = JSON.parse(ret_str2);
			$("#teacher").html(obj2.data);
			
			form.render('select');
		}
	})

	
	//获取课表
	form.on('select(teacher)',function(data){
		kebiao(data.value);
	})
	
	form.on('radio(kbRadio)',function(data){
		if($('#teacher').val()!='0'){
			kebiao($('#teacher').val());
		}
	})
	
	function kebiao(teacherid){
		if(teacherid!='0'){
			//获取学期
			var xueqi = $("#xueqi").val();
			if(xueqi=="0"){
				layer.msg('请选择学期学号');
				return ;
			}
			//清楚备注
			$("#teacher_common").text("");
			//1 有课表 0 无课表
			var kebiaotype = $('input[name="sex"]:checked').val();
			//周次
			var zhouci = $("#zhouci").val();
			//班级id
			var teacher_id = teacherid;	
			var obj_str1 = {"xueqi":xueqi,"teacher_id":teacher_id,"zhouci":zhouci,"kebiaotype":kebiaotype};
			var obj1 = JSON.stringify(obj_str1)
			var ret_str1=PostAjx('../../../../Api/v1/?p=web/kebiao/getScheduleTeacherInfo',obj1,'<%=Suid%>','<%=Spc_token%>');
			obj1 = JSON.parse(ret_str1);
			//赋值到备注中
			var obj_str2 = {"xueqi":xueqi,"teacher_id":teacher_id};
			var obj2 = JSON.stringify(obj_str2)
			var ret_str2=PostAjx('../../../../Api/v1/?p=web/kebiao/getTeacherCom',obj2,'<%=Suid%>','<%=Spc_token%>');
			obj2 = JSON.parse(ret_str2);
			$("#teacher_common").text("教师备注是:	"+obj2.msg);
			if(obj1.success){
				$(".moren").each(function(){
					$(this).text('');
				});
				
				//课表信息
				var array = obj1.data
				for(var i =0 ; i<array.length;i++){
					var array1 = array[i].timetable;
					for(var j=0;j<array1.length;j++){
						var array2 = array1[j]
						for(var m =0 ;m<array2.length;m++){
							if(array2[m]=="0"){
								var str = array[i].course_name+"<br>";
								str += array[i].classname+"<br>";
								str +=  array[i].class_begins_weeks+"<br>";
								str += array[i].classroomname;
								$("#"+j+"_"+m+"").html(str);
							}
						}
					}
				}

				//行数据信息
				var html = ' <tr>																	' +
						    '	  <td><input type="button" class="" name="" value="&nbsp;+&nbsp;"></td>         ' +
							'      <td>班级</td>                                                                  ' +
							'      <td>排课人数</td>                                                                ' +
							'      <td>开课编号</td>                                                                ' +
							'      <td>开课课程</td>                                                                ' +
							'      <td>授课教师</td>                                                                ' +
							'      <td>上课地点</td>                                                                ' +
							'      <td>开课时间</td>                                                                ' +
							'      <td>开课周次</td>                                                                ' +
							'      <td>单/双周</td>                                                                ' +
							'      <td>操作</td>                                                                  ' +
							'    </tr>'		;
				var arrayline = obj1.linedata
				$(".shan").remove();
				for(var k = 0;k<arrayline.length;k++){
					var html = ' <tr class="shan">																	' +
				    '	  <td><input type="button" class="" name="" value="&nbsp;+&nbsp;"></td>         ' +
					'      <td>'+arrayline[k].teacher_name+'</td>                                                                  ' +
					'      <td>'+arrayline[k].course_code+'</td>                                                                ' +
					'      <td>'+arrayline[k].course_name+'</td>                                                                ' +
					'      <td>'+arrayline[k].classname+'</td>                                                                ' +
					'      <td>'+arrayline[k].totle+'</td>                                                                ' +
					'      <td>'+arrayline[k].classroomname+'</td>                                                                ' +
					'      <td>'+arrayline[k].classtime+'</td>                                                                ' +
					'      <td>'+arrayline[k].class_begins_weeks+'</td>                                                                ' +
					'    </tr>'		;

					$("#lineid").append(html);
					
				}
				
			}
			
		}
		}
	
  
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