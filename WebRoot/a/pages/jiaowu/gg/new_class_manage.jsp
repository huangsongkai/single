<%@ page trimDirectiveWhitespaces="true" %>
<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@page import="service.dao.db.Page"%>
<%@include file="../../cookie.jsp"%>
<%@page import="java.util.Date"%>
<%@page import="v1.haocheok.commom.common"%>
<%@page import="java.text.SimpleDateFormat"%>
<%
common common=new common();
   String sysid= request.getParameter("sysid");
   if(regex_num(sysid)==false){sysid="0";}
   String departments_id_url= request.getParameter("departments_id");
   if(departments_id_url==null){departments_id_url="0";}
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
		<script src="../../js/ajaxs.js"></script>
		<title>新增班级信息</title> 
	    <style type="text/css">
			.inline{ position: relative; display: inline-block; margin-right: 10px; }
	    </style>
	</head>
	<body>
		<div style="margin: 15px;">
			<fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
				<legend>新增班级信息</legend>
			</fieldset>
			<form class="layui-form" action="?ac=add" method="post" >
                <div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">所属院系</label>
					<div class="layui-input-inline">
						<select name="departments_id"  lay-verify="required" lay-search lay-filter="depth"  lay-verify="required"> 
							<option value="">请选择</option>
							 <%
                         //查询状态
                          ResultSet stateRs = db.executeQuery("SELECT  id,departments_name FROM  dict_departments  WHERE teach_tag=1;");
                            while(stateRs.next()){
                            %>
                          <option value="<%=stateRs.getString("id")%>" <%if(stateRs.getString("id").equals(departments_id_url)){out.print("selected=\"selected\"");}%>><%=stateRs.getString("departments_name") %></option>
                           <%}if(stateRs!=null){stateRs.close();}%>
								    
						</select>
					</div>
					
				</div>	
				
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">专业编号</label>
					<div class="layui-input-inline">
						<select name="majors_id"  lay-verify="required" lay-search lay-verify="required">
							<option value="">请选择</option>
							<%
								String major_sql = "select id,major_name from major WHERE departments_id="+departments_id_url+";";
								ResultSet set_major = db.executeQuery(major_sql);
								while(set_major.next()){
							%>
								<option value="<%=set_major.getString("id")%>"><%=set_major.getString("major_name") %></option>
							<%}if(set_major!=null){set_major.close();} %>
								    
						</select>
					</div>
				</div>	
				
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">班级名称</label>
					<div class="layui-input-inline">
						<input type="text" id="class_name" name="class_name" class="layui-input"  lay-verify="required" >
					</div>
				</div>	
				
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">班级男生人数</label>
					<div class="layui-input-inline">
						<input type="text" id="people_number_nan" name="people_number_nan" class="layui-input"  lay-verify="required">
					</div>
				</div>	
				
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">班级女生人数</label>
					<div class="layui-input-inline">
						<input type="text" id="people_number_woman" name="people_number_woman" class="layui-input"  lay-verify="required" >
					</div>
				</div>		
					
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">辅导员</label>
					<div class="layui-input-inline">
						<input type="text" id="counsellor" name="counsellor" class="layui-input" lay-verify="required" >
					</div>
				</div>
				
				
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">班级编号</label>
					<div class="layui-input-inline">
						<input type="text" id="class_number" name="class_number" class="layui-input"  lay-verify="required" >
					</div>
				</div>
				
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">班级大类编号</label>
					<div class="layui-input-inline">
						<input type="text" id="class_big" name="class_big" class="layui-input" >
					</div>
				</div>	
				
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">班级简称</label>
					<div class="layui-input-inline">
						<input type="text" id="class_abbreviation" name="class_abbreviation" class="layui-input" >
					</div>
				</div>
				
				
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">班级类别编号</label>
					<div class="layui-input-inline">
						<input type="text" id="class_category_number" name="class_category_number" class="layui-input" >
					</div>
				</div>
				
				
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">入学年份</label>
					<div class="layui-input-inline">
						<input type="text" id="school_year" name="school_year" class="layui-input"  lay-verify="required" >
					</div>
				</div>	
				
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">分校编号</label>
					<div class="layui-input-inline">
						<select name="campus_id"  lay-verify="required" lay-search id="campus_id" lay-filter="campus_id" >
							<option value="">请选择</option>
							<%
								String campus_sql = "select id,campus_name from dict_campus;";
								ResultSet set_campus = db.executeQuery(campus_sql);
								while(set_campus.next()){
							%>
								<option value="<%=set_campus.getString("id")%>"><%=set_campus.getString("campus_name") %></option>
							<%}if(set_campus!=null){set_campus.close();} %>
								    
						</select>
					</div>
				</div>
				
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">固定教学区编号</label>
					<div class="layui-input-inline">
						<select name="teaching_area_id"   lay-search lay-verify="required" id="teaching_area_id" lay-filter="teaching_area_id">
								    
						</select>
					</div>
				</div>
				
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">固定教室编号</label>
					<div class="layui-input-inline">
						<select name="classroom_id"   lay-search lay-verify="required" lay-filter="classroom_id" id="classroom_id">
						</select>
					</div>
				</div>
				
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">入学年份代码</label>
					<div class="layui-input-inline">
						<input type="text" id="school_year_code" name="school_year_code" class="layui-input" >
					</div>
				</div>
				
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">是否是毕业班级</label>
					<div class="layui-input-inline">
							  	<select name="graduation_class"  lay-verify="required" lay-search lay-verify="required">
								    <option value="">请选择</option>
								    <option value="0">否</option>
								    <option value="1">是</option>
							 	</select>
					</div>
				</div>
				
				
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">是否审核</label>
					<div class="layui-input-inline">
							  	<select name="stauts"  lay-verify="required" lay-search>
								    <option value="">请选择</option>
								    <option value="0">否</option>
								    <option value="1">是</option>
							 	</select>
					</div>
				</div>
					
				
				<div class="layui-form-item" style="margin-bottom:45px">
					<div class="layui-input-block"  style="margin-left:540px">			
						<button  class="layui-btn" lay-submit >确认</button>
					</div>
				</div>
			</form>
		</div>
	</body>
</html>
<script>

	 layui.use(['form','laydate'], function() {
			
		layer = layui.layer,
		layedit = layui.layedit,
		laydate = layui.laydate;
		var form = layui.form;
		form.on('select(depth)', function(data){
		  
		  window.location.href="?ac=&departments_id="+data.value;
		});

		laydate.render({
		  elem: '#school_year' //指定元素
		  ,type:'year'
		});

		//分校获取教学区
		form.on('select(campus_id)',function(data){
			if(data.value!="0"){
				var obj_str1 = {"xiaoqu":data.value};
				var obj1 = JSON.stringify(obj_str1)
				var ret_str1=PostAjx('../../../../Api/v1/?p=web/info/getbuildeToCampu',obj1,'<%=Suid%>','<%=Spc_token%>');
				obj1 = JSON.parse(ret_str1);
				$("#teaching_area_id").html(obj1.data);
				form.render('select');

			}
		})

		//教学区获取教室
		form.on('select(teaching_area_id)',function(data){
			if(data.value!="0"){
				var obj_str1 = {"teaching_area_id":data.value};
				var obj1 = JSON.stringify(obj_str1)
				var ret_str1=PostAjx('../../../../Api/v1/?p=web/info/getclassroomTobuilde',obj1,'<%=Suid%>','<%=Spc_token%>');
				obj1 = JSON.parse(ret_str1);
				$("#classroom_id").html(obj1.data);
				form.render('select');

			}
		})
			
	})
	 var index = parent.layer.getFrameIndex(window.name);

</script>
<% 
	if("add".equals(ac)){ 
		
		//所属院系
		String departments_id = "";
		departments_id = request.getParameter("departments_id");
		//专业编号
		String majors_id = "";
		majors_id = request.getParameter("majors_id");
		//班级名称
		String class_name = "";
		class_name = request.getParameter("class_name");
		//班级男生人数
		String people_number_nan = "";
		people_number_nan = request.getParameter("people_number_nan");
		//班级女生人数
		String people_number_woman = "";
		people_number_woman = request.getParameter("people_number_woman");
		//辅导员
		String counsellor = "";
		counsellor = request.getParameter("counsellor");
		//班级编号
		String class_number = "";
		class_number = request.getParameter("class_number");
		//班级大类编号
		String class_big = "";
		class_big = request.getParameter("class_big");
		//班级简称
		String class_abbreviation = "";
		class_abbreviation = request.getParameter("class_abbreviation");
		//班级类别编号
		String class_category_number = "";
		class_category_number = request.getParameter("class_category_number");
		//入学年份
		String school_year = "";
		school_year = request.getParameter("school_year");
		//分校编号
		String campus_id = "";
		campus_id = request.getParameter("campus_id");
		//固定教学区编号
		String teaching_area_id = "";
		teaching_area_id = request.getParameter("teaching_area_id");
		//固定教室编号
		String classroom_id = "";
		classroom_id = request.getParameter("classroom_id");
		//入学年份代码
		String school_year_code = "";
		school_year_code = request.getParameter("school_year_code");
		//是否是毕业班级
		String graduation_class = "";
		graduation_class = request.getParameter("graduation_class");
		//是否审核
		String stauts = "";
		stauts = request.getParameter("stauts");
		
		String sql = "INSERT INTO class_grade 	"+
			"		(                                           "+
			"		departments_id,                             "+
			"		majors_id,                                  "+
			"		class_name,                                 "+
			"		people_number_nan,                          "+
			"		people_number_woman,                        "+
			"		counsellor,                                 "+
			"		class_number,                               "+
			"		class_big,                                  "+
			"		class_abbreviation,                         "+
			"		class_category_number,                      "+
			"		school_year,                                "+
			"		campus_id,                                  "+
			"		teaching_area_id,                           "+
			"		classroom_id,                               "+
			"		school_year_code,                           "+
			"		graduation_class,                           "+
			"		hide,                           "+
			"		stauts                                      "+
			"		)                                           "+
			"		VALUES                                      "+
			"		(                                           "+
			"		'"+departments_id+"',                           "+
			"		'"+majors_id+"',                                "+
			"		'"+class_name+"',                               "+
			"		'"+people_number_nan+"',                        "+
			"		'"+people_number_woman+"',                      "+
			"		'"+counsellor+"',                               "+
			"		'"+class_number+"',                             "+
			"		'"+class_big+"',                                "+
			"		'"+class_abbreviation+"',                       "+
			"		'"+class_category_number+"',                    "+
			"		'"+school_year+"',                              "+
			"		'"+campus_id+"',                                "+
			"		'"+teaching_area_id+"',                         "+
			"		'"+classroom_id+"',                             "+
			"		'"+school_year_code+"',                         "+
			"		'"+graduation_class+"',1,                         "+
			"		'"+stauts+"'                                    "+
			"		);";
		
			boolean state = db.executeUpdate(sql);
			if(state){
			   out.println("<script>parent.layer.msg('添加班级信息 成功'); parent.layer.close(index); parent.location.reload();</script>");
		   }else{
			   out.println("<script>parent.layer.msg('添加班级信息 失败');</script>");
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