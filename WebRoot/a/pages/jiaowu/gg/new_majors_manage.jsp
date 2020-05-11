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
		<title>新增专业信息管理</title> 
	    <style type="text/css">
			.inline{ position: relative; display: inline-block; margin-right: 10px; }
	    </style>
	</head>
	<body>
		<div style="margin: 15px;">
			<fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
				<legend>新增专业信息管理</legend>
			</fieldset>
			<form class="layui-form" action="?ac=add" method="post" >
                <div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">所属院系</label>
					<div class="layui-input-inline">
						<select name="departments_id"  lay-verify="required" lay-search lay-verify="required">
							<option value="">请选择</option>
							<%
								String depar_sql = "select id,departments_name from dict_departments;";
								ResultSet set = db.executeQuery(depar_sql);
								while(set.next()){
							%>
								<option value="<%=set.getString("id")%>"><%=set.getString("departments_name") %></option>
							<%}if(set!=null){set.close();} %>
								    
						</select>
					</div>
				</div>	
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">专业编号</label>
					<div class="layui-input-inline">
						<input type="text" id="majors_number" name="majors_number" class="layui-input" lay-verify="required" >
					</div>
				</div>	
				
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">专业名称</label>
					<div class="layui-input-inline">
						<input type="text" id="major_name" name="major_name" class="layui-input"  lay-verify="required">
					</div>
				</div>	
				
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">专业方向</label>
					<div class="layui-input-inline">
						<input type="text" id="major_field" name="major_field" class="layui-input"  lay-verify="required" >
					</div>
				</div>
				
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">培养层次</label>
					<div class="layui-input-inline">
<%--						<input type="text" id="gradation" name="gradation" class="layui-input"  lay-verify="required">--%>
						<select name="gradation"  lay-verify="required" lay-search>
							<option value="">请选择</option>
							<%
								String jz_sql = "select id,name from jz_culture_level;";
								ResultSet jz_sqlRs = db.executeQuery(jz_sql);
								while(jz_sqlRs.next()){
							%>
								<option value="<%=jz_sqlRs.getString("id")%>"><%=jz_sqlRs.getString("name") %></option>
							<%}if(jz_sqlRs!=null){jz_sqlRs.close();} %>
						</select>
					</div>
				</div>
				
				
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">学制</label>
					<div class="layui-input-inline">
						<select name="eductional_systme_id"  lay-verify="required" lay-search >
							<option value="">请选择</option>
							<%
								String eductional_sql = "select id,eductional_systme_name from dict_eductional_systme;";
								ResultSet set_eductional = db.executeQuery(eductional_sql);
								while(set_eductional.next()){
							%>
								<option value="<%=set_eductional.getString("id")%>"><%=set_eductional.getString("eductional_systme_name") %></option>
							<%}if(set_eductional!=null){set_eductional.close();} %>
								    
						</select>
					</div>
				</div>
				
				
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">专业代码</label>
					<div class="layui-input-inline">
						<input type="text" id="major_code" name="major_code" class="layui-input"  lay-verify="required">
					</div>
				</div>
				
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">部颁专业名称</label>
					<div class="layui-input-inline">
						<input type="text" id="major_name_customer" name="major_name_customer" class="layui-input"  lay-verify="required">
					</div>
				</div>
				
				
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">招生季节</label>
					<div class="layui-input-inline">
						<input type="text" id="enroll_student_season" name="enroll_student_season" class="layui-input" lay-verify="required" >
					</div>
				</div>
				
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">学科类别</label>
					<div class="layui-input-inline">
<%--						<input type="text" id="disciplines" name="disciplines" class="layui-input"  lay-verify="required">--%>
						<select name="disciplines"  lay-verify="required" lay-search>
							<option value="">请选择</option>
							<%
								String zz_sql = "SELECT categoryname,id from dict_subject_category";
								ResultSet zz_sqlRs = db.executeQuery(zz_sql);
								while(zz_sqlRs.next()){
							%>
								<option value="<%=zz_sqlRs.getString("id")%>"><%=zz_sqlRs.getString("categoryname") %></option>
							<%}if(zz_sqlRs!=null){zz_sqlRs.close();} %>
						</select>
					</div>
				</div>
				
				
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">开设年份</label>
					<div class="layui-input-inline">
						<input type="text" id="establish_year" name="establish_year" class="layui-input"  lay-verify="required" >
					</div>
				</div>
					
				<div class="layui-form-item" style="margin-bottom:45px">
					<div class="layui-input-block"  style="margin-left:540px">			
						<button  class="layui-btn"  lay-submit >确认</button>
					</div>
				</div>
			</form>
		</div>
	</body>
</html>
<script>

	 layui.use('form', function() {
				layer = layui.layer,
				layedit = layui.layedit,
				laydate = layui.laydate;
				})
	 var index = parent.layer.getFrameIndex(window.name);

	 <% if("add".equals(ac)){ 
			//收集数据
			String departments_id = request.getParameter("departments_id");
			String majors_number = request.getParameter("majors_number");
			String major_name = request.getParameter("major_name");
			String major_field= request.getParameter("major_field");
			String gradation = request.getParameter("gradation");
			String eductional_systme_id = request.getParameter("eductional_systme_id");
			String major_code = request.getParameter("major_code");
			String major_name_customer = request.getParameter("major_name_customer");
			String enroll_student_season = request.getParameter("enroll_student_season");
			String disciplines = request.getParameter("disciplines");
			String school_year = request.getParameter("school_year");
			String establish_year = request.getParameter("establish_year");
			
			String insert_sql = "INSERT INTO major 						"+
						"			(                                   "+
						"			departments_id,                     "+
						"			majors_number,                      "+
						"			major_name,                         "+
						"			major_field,                        "+
						"			gradation,                          "+
						"			eductional_systme_id,               "+
						"			major_code,                         "+
						"			major_name_customer,                "+
						"			enroll_student_season,              "+
						"			disciplines,                        "+
						"			establish_year						"+
						"			)                                   "+
						"			VALUES                              "+
						"			(                                   "+
						"			'"+departments_id+"',                   "+
						"			'"+majors_number+"',                    "+
						"			'"+major_name+"',                       "+
						"			'"+major_field+"',                      "+
						"			'"+gradation+"',                        "+
						"			'"+eductional_systme_id+"',             "+
						"			'"+major_code+"',                       "+
						"			'"+major_name_customer+"',              "+
						"			'"+enroll_student_season+"',            "+
						"			'"+disciplines+"',                      "+
						"			'"+establish_year+"'				"+
						"			);";
			
			boolean state = db.executeUpdate(insert_sql);
			if(state){
			   out.println("parent.layer.msg('添加专业信息 成功',{icon:1,time:1000,offset:'150px'},function(){  window.parent.location.reload(true);var index = parent.layer.getFrameIndex(window.name); parent.layer.close(index); });");
		   }else{
			   out.println("parent.layer.msg('添加专业信息 失败');");
		   }
			
			
			
			//关闭数据与serlvet.out
			
			if (page != null) {page = null;}
			
		}%>

</script>

 
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