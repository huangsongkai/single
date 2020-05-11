<%@ page trimDirectiveWhitespaces="true" %>
<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@ include file="../../cookie.jsp"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>教室课表</title>
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
.layui-form-item .layui-form-checkbox[lay-skin="primary"]{
	margin-top: -2px;
}
#my-table2.layui-table th {border-bottom:1px solid #f2f2f2;border-top:1px solid #f2f2f2;border-left: none;}
</style>
</head>
<body>
	
<div id="box">
	<blockquote class="layui-elem-quote" style="padding: 5px">
		&nbsp;&nbsp;&nbsp;
		教室课表
	</blockquote>
	<div class="layui-field-box">
	    <form class="layui-form" action="">
	    	<div class="layui-form-item">
			    <div class="layui-inline">
				    <label class="layui-form-label">内容</label>
				    <div class="layui-input-inline" style="width: 400px">
				      	<input type="radio" name="content" value="6" title="星期六" lay-skin="primary">
						<input type="radio" name="content" value="7" title="星期日" checked="checked" lay-skin="primary"> 
						<input type="radio" name="content" value="0" title="无课表不显示"  lay-skin="primary"> 
				    </div>
				</div>
				<div class="layui-inline">
				    <label class="layui-form-label">周次</label>
				    <div class="layui-input-inline" style="width: 150px;">
				      	<select lay-verType="tips">
				          <option value="0">全部</option>
				          <%
				          		for(int i = 1;i<=20;i++){
				          %>
				          	<option value="<%=i%>">第<%=i %>周</option>
				          <%} %>
				          
				          
				        </select>
				    </div>
			    </div>

			    <div class="layui-inline">
				    <label class="layui-form-label">学期</label>
				    <div class="layui-input-inline" style="width: 150px;">
				      	<select lay-verType="tips" id="xueqi" lay-filter="xueqi">
				      		<%
				      			String sql = "select academic_year,this_academic_tag from academic_year ";
				      			ResultSet set = db.executeQuery(sql);
				      			while(set.next()){
				      		%>
				      			<option value="<%=set.getString("academic_year")%>" <%if("true".equals(set.getString("this_academic_tag"))){out.println("selected='selected'");} %>><%=set.getString("academic_year") %></option>
				      		
				      		<%}if(set!=null){set.close();} %>
				      	
				      	
				      	
				        </select>
				    </div>
			    </div>
			    <div class="layui-inline">
				    <label class="layui-form-label">校区</label>
				    <div class="layui-input-inline" style="width: 150px;">
				      	<select lay-verType="tips" lay-filter="xiaoqu" id="xiaoqu">
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
				    <label class="layui-form-label">教学区</label>
				    <div class="layui-input-inline" style="width: 150px;">
				      	<select lay-verType="tips" lay-filter="jiaoxuequ" id="jiaoxuequ">
				        </select>
				    </div>
			    </div>
			    
			    <div class="layui-inline">
				    <label class="layui-form-label">教学楼</label>
				    <div class="layui-input-inline" style="width: 150px;">
				      	<select lay-verType="tips" lay-filter="luo" id="luo">
				      		<option value="0">请选择教学楼</option>
				      		<%
				      			String luo = "select id,building_name from teaching_building";
				      			ResultSet luoSet = db.executeQuery(luo);
				      			while(luoSet.next()){
				      		%>
				      		
				      			<option value="<%=luoSet.getString("id") %>"><%=luoSet.getString("building_name") %></option>
				      		<%}if(luoSet!=null){luoSet.close();} %>
				        </select>
				    </div>
			    </div>

			    	
			    <div class="layui-inline">
				    <input type="button" name="xxx" value="查找" onclick="find()" class="layui-btn">
				    <input type="button" id="excelid" name="xxx" value="导出excel" onclick="method5('my-table1');" disabled="disabled" class="layui-btn layui-btn-disabled">
				    <input type="button" name="xxx" value="返回上一级" onclick="fanhui();" class="layui-btn">
		      	</div>		  		
			  			  				  
			</div>

			<!-- 表格 -->
			<div  style="height:500px;overflow: auto;" id="ieid">
				<table id="my-table1"  class="layui-table">
					<colgroup>
					    <col width="80">
					    <col width="80">
					</colgroup>
				  <tbody>
				  	<tr id="class_grade_id">
				  		<td>星期</td>
						<td>节次</td>
				    </tr>
				    <%
				    	for(int i = 1; i<=7;i++){
				    %>
				    <tr id ="base_<%=i %>_0">
				  	  <td rowspan="4">
				  	  <%
				  	  	switch(i){
				  	  		case 1: out.println("星期一");break;
				  	  		case 2: out.println("星期二");break;
				  	  		case 3: out.println("星期三");break;
				  	  		case 4: out.println("星期四");break;
				  	  		case 5: out.println("星期五");break;
				  	  		case 6: out.println("星期六");break;
				  	  		case 7: out.println("星期日");break;
				  	  		default:out.println("暂无");break;
				  	  		
				  	  	}
				  	  %>
				  	  
				  	  </td>
				  	  <td>一二</td>
				    </tr>
				    <tr id ="base_<%=i %>_1">
						<td>三四</td>
				    </tr>
				    <tr id ="base_<%=i %>_2">
				    	<td>五六</td>
				    </tr>
					<tr id ="base_<%=i %>_3">
						<td>七八</td>
					</tr>
					<%} %>				    
				  </tbody>
				</table>
			</div>
		</form>
    </div>
</div>

<br><br><br>


<script type="text/javascript">

	//返回
	function fanhui(){
		window.location.replace('./general_school_curriculum_totle.jsp');
	}


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
                if (!table.nodeType) table = document.getElementById(table)  
                var ctx = {worksheet: name || 'Worksheet', table: table.innerHTML}  
                console.log(uri + base64(format(template, ctx)) );
                window.location.href = uri + base64(format(template, ctx))  
            }  
        })()  





	//打印
	function myPrint(obj){
	    //打开一个新窗口newWindow
	    var newWindow=window.open("打印窗口","_blank");
	    //要打印的div的内容
	    var docStr = obj.innerHTML;
	    //打印内容写入newWindow文档
	    newWindow.document.write(docStr);
	    //关闭文档
	    newWindow.document.close();
	    //调用打印机
	    newWindow.print();
	    //关闭newWindow页面
	    newWindow.close();
	}




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
		console.log(data)
		return false;
	});

	$(function(){
		var a = $('#xiaoqu').val();
		var obj_str1 = {"xiaoqu":a};
		var obj1 = JSON.stringify(obj_str1)
		var ret_str1=PostAjx('../../../../Api/v1/?p=web/info/getbuildeToCampu',obj1,'<%=Suid%>','<%=Spc_token%>');
		obj1 = JSON.parse(ret_str1);
		$("#jiaoxuequ").html(obj1.data);
		form.render('select');
		})
		
	form.on('select(xiaoqu)',function(data){
		//校区 获取院系
		if(data.value!="0"){
			
			var obj_str1 = {"xiaoqu":data.value};
			var obj1 = JSON.stringify(obj_str1)
			var ret_str1=PostAjx('../../../../Api/v1/?p=web/info/getbuildeToCampu',obj1,'<%=Suid%>','<%=Spc_token%>');
			obj1 = JSON.parse(ret_str1);
			$("#jiaoxuequ").html(obj1.data);
			form.render('select');
		}
	})

	form.on('select(department)',function(data){
		if(data.value!="0"){
			var obj_str1 = {"departments_id":data.value};
			var obj1 = JSON.stringify(obj_str1)
			var ret_str1=PostAjx('../../../../Api/v1/?p=web/info/getMajor',obj1,'<%=Suid%>','<%=Spc_token%>');
			obj1 = JSON.parse(ret_str1);
			$("#major").html(obj1.data);
			form.render('select');

		}
	})
});

	//
	function find(){

		$(".shan").remove();
		
		var xiaoqu = $("#xiaoqu").val();
		if(xiaoqu=="0"){
			layer.msg("请选择校区");
			return ;
		}
		var xueqi = $("#xueqi").val();

		
		if(xueqi=="0"){
			layer.msg("请选择学期学号");
			return ;
		}

		var jiaoxuequ = $("#jiaoxuequ").val();		//教学区

		var luo = $("#luo").val();					//教学楼
		

		//获取课表星期次数
		var kebiaolength = $("input:radio:checked").val();
		if(kebiaolength=="0"){
			kebiaolength = "5";
		}
		

		var obj_str1 = {"xueqi":xueqi,"jiaoxuequ":jiaoxuequ,"luo":luo};
		var obj1 = JSON.stringify(obj_str1)
		var ret_str1=PostAjx('../../../../Api/v1/?p=web/kebiao/getAllSchoolRoom',obj1,'<%=Suid%>','<%=Spc_token%>');
		obj1 = JSON.parse(ret_str1);
		console.log(obj1);	
		if(obj1.success){
			var data = obj1.data;
			
			for(var i =0 ;i<data.length;i++){
				$("#class_grade_id").append("<td class='shan'>"+obj1.data[i].classroomname+"</td>");
				for(var k=1;k<=kebiaolength;k++){
					$("#base_"+k+"_0").append("<td class='shan' title='' id='timetable_"+i+"_"+k+"_0'></td>");
					$("#base_"+k+"_1").append("<td class='shan' title='' id='timetable_"+i+"_"+k+"_1'></td>");
					$("#base_"+k+"_2").append("<td class='shan' title='' id='timetable_"+i+"_"+k+"_2'></td>");
					$("#base_"+k+"_3").append("<td class='shan' title='' id='timetable_"+i+"_"+k+"_3'></td>");
				}
				var deatils = data[i].data_detailes;
				for(var j = 0; j<deatils.length;j++){

					//循环课表
					var timetable = deatils[j].timetable;
					for(var m =0 ;m<timetable.length;m++){
						var array = timetable[m];
						for(var y = 0; y < array.length;y++){

							if(array[y]=="0"){
								var str = "";
								str += deatils[j].course_name+"<br>";
								str += deatils[j].teachername+"<br>";
								str += deatils[j].classtime+"		"+deatils[j].weeks+"<br>";
								str += deatils[j].class_name+"<br>";
								var title = $("#timetable_"+i+"_"+(m+1)+"_"+y+"").attr("title");;
								title += "课程编码:"+deatils[j].course_code+"\r";
								title += "开课课程:"+ deatils[j].course_name+"\r"; 
								title += "授课教师:"+deatils[j].teachername+"\r";
								title += "开课时间:"+deatils[j].classtime+"\r";
								title += "上课周次:"+deatils[j].weeks+"\r";
								title += "开课地点:"+deatils[j].classroomname+"\r";
								title += "上课班级:"+deatils[j].class_name+"\r";
								
								$("#timetable_"+i+"_"+(m+1)+"_"+y+"").append(str);
								$("#timetable_"+i+"_"+(m+1)+"_"+y+"").attr("title",title);
							}
							
						}
					}
					
				}
				
			}
			
		}
		
	}

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