<%@ page trimDirectiveWhitespaces="true" %>
<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@page import="service.dao.db.Page"%>
<%@include file="../../cookie.jsp"%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="utf-8"> 
	    <meta name="viewport" content="width=device-width, initial-scale=1"> 
	    
	    <link rel="stylesheet" href="../../../pages/css/sy_style.css">	    
	    <link rel="stylesheet" href="../../js/layui2/css/layui.css">
		<script type="text/javascript" src="../../js/jquery-1.9.1.js" ></script><!--通用jquery-->
		<script src="../../js/layui2/layui.js"></script>
		<title>新增课程</title> 
	    <style type="text/css">
			.inline{ position: relative; display: inline-block; margin-right: 10px; }
	    </style>
	</head>
	<body>
		<div style="margin: 15px;">
			<fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
				<legend>添加课程</legend>
			</fieldset>
			<form class="layui-form" action="new_courses_manage.jsp?ac=add" method="post" >
              <div class="layui-form-item inline" style="width: 40%">
					<label class="layui-form-label" style=" width: 30%">教研室</label>	 				
					<div class="layui-input-inline">
						<select name="teaching_research_id" class="layui-input" lay-filter="teaching_research_id" lay-search>
                             <%
                         //查询状态
                          ResultSet campusRs = db.executeQuery("SELECT  id,teaching_research_name FROM teaching_research;");
                            while(campusRs.next()){
                            %>
                          <option value="<%=campusRs.getString("id")%>"><%=campusRs.getString("teaching_research_name") %></option>
                           <%}if(campusRs!=null){campusRs.close();}%>
                         </select> 
					</div>
				</div>
				 <div class="layui-form-item inline" style="width: 40%">
					<label class="layui-form-label" style=" width: 30%">课程大类</label>	 				
					<div class="layui-input-inline">
						<select name="dict_courses_class_big_id" class="layui-input" lay-filter="dict_courses_class_big_id">
                             <%
                         //查询状态
                          ResultSet gnRs = db.executeQuery("SELECT  id,courses_bigclass_name FROM dict_courses_class_big;");
                            while(gnRs.next()){
                            %>
                          <option value="<%=gnRs.getString("id")%>"><%=gnRs.getString("courses_bigclass_name") %></option>
                           <%}if(gnRs!=null){gnRs.close();}%>
                         </select> 
					</div>
				</div>
				<div class="layui-form-item inline" style="width: 40%">
					<label class="layui-form-label" style=" width: 30%">课程体系</label>	 				
					<div class="layui-input-inline">
						<select name="course_system_id" class="layui-input" lay-filter="course_system_name">
							<option value="1">理论</option>
							<option value="2">实践</option>
							<option value="3">实验</option>
                         </select> 
					</div>
				</div>
				 <div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">课程名称</label>
					<div class="layui-input-inline">
						<input type="text" id="course_name" name="course_name" class="layui-input"  lay-verify="required">
					</div>
				</div>	
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">课程编码</label>
					<div class="layui-input-inline">
						<input type="text" id="course_code" name="course_code" class="layui-input"  lay-verify="required">
					</div>
				</div>	
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">课程英文名称</label>
					<div class="layui-input-inline">
						<input type="text" id="course_name_en" name="course_name_en" class="layui-input" >
					</div>
				</div>	
				 <div class="layui-form-item inline" style="width: 40%">
					<label class="layui-form-label" style=" width: 30%">是否实验</label>					
					<div class="layui-input-inline">
						<select name="is_test" class="layui-input" lay-filter="is_test"> 
                          <option value="0">否</option>
                          <option value="1">是</option>
                         </select> 
					</div>
				</div>	
				 <div class="layui-form-item inline" style="width: 40%">
					<label class="layui-form-label" style=" width: 30%">是否独立开课</label>					
					<div class="layui-input-inline">
						<select name="is_alone_start" class="layui-input" lay-filter="is_alone_start"> 
                          <option value="1">是</option>
                          <option value="0">否</option>
                         </select> 
					</div>
				</div>

				 <div class="layui-form-item inline" style="width: 40%">
					<label class="layui-form-label" style=" width: 30%">是否上机</label>					
					<div class="layui-input-inline">
						<select name="is_computer" class="layui-input" lay-filter="is_computer"> 
                          <option value="1">是</option>
                          <option value="0">否</option>
                         </select> 
					</div>
				</div>		
				 <div class="layui-form-item inline" style="width: 40%">
					<label class="layui-form-label" style=" width: 30%">所属进程</label>					
					<div class="layui-input-inline">
						<select name="process_symbol" class="layui-input"  lay-verify="required"> 
							<option value="0">无</option>
                          	<%
								String jincheng ="select * from dict_process_symbol";
								ResultSet jcRs = db.executeQuery(jincheng);
								while(jcRs.next()){
										out.println("<option value='"+jcRs.getString("id")+"'>"+jcRs.getString("process_symbol_name")+" : "+jcRs.getString("process_symbol")+"&nbsp;"+"</option>");								
								}if(jcRs!=null)jcRs.close();
							%>
                         </select> 
					</div>
				</div>
				<div class="layui-form-item" style="margin-bottom:45px">
					<div class="layui-input-block"  style="margin-left:540px">			
						<button  class="layui-btn"  lay-submit>确认</button>
					</div>
				</div>
			</form>
		</div>
	</body>
<script>
	 layui.use('form', function() {
				layer = layui.layer,
				layedit = layui.layedit,
				laydate = layui.laydate;
				var form    = layui.form;
				})
	 var index = parent.layer.getFrameIndex(window.name);

</script>
</html>
<% if("add".equals(ac)){ 
	 String teaching_research_id=request.getParameter("teaching_research_id");
	 String dict_courses_class_big_id=request.getParameter("dict_courses_class_big_id");
	 String course_system_id = request.getParameter("course_system_id");
	 String course_name=request.getParameter("course_name");
	 String course_name_en= request.getParameter("course_name_en");
	 String is_test= request.getParameter("is_test");
	 String is_alone_start=request.getParameter("is_alone_start");
	 String is_computer= request.getParameter("is_computer");
	 String course_code= request.getParameter("course_code");
	 
	 
	 String process_symbol = request.getParameter("process_symbol");
	 
	 String curriculum_type= "";
	 if("0".equals(process_symbol)){
		 curriculum_type = "2";
	 }else{
		 curriculum_type = "1";
	 }
	 
	 
	 
	 
	 
	 
	 String course_system_name= "";
	 if("1".equals(course_system_id)){
		 course_system_name = "理论";
	 }else if("2".equals(course_system_id)){
		 course_system_name = "实践";
	 }else if("3".equals(course_system_id)){
		 course_name = "实验";
	 }
	 
	 
	 if(course_code==null){course_code="";}
	 if(teaching_research_id==null){teaching_research_id="";}
	 if(dict_courses_class_big_id==null){dict_courses_class_big_id="";}
	 if(course_system_name==null){course_system_name="";}
	 if(course_name==null){course_name="";}
	 if(course_name_en==null){course_name_en="";}
	 if(is_test==null){is_test="";}
	 if(is_alone_start==null){is_alone_start="";}
	 if(is_computer==null){is_computer="";}
	
	try{
	   String sql="INSERT INTO `dict_courses` (`teaching_research_id`,`dict_courses_class_big_id`,`course_system_name`,`course_name`,`course_name_en`,`is_test`,`is_alone_start`,`is_computer`,`course_code`,`curriculum_type`,`course_system_id`,`process_symbol`) VALUES ('"+teaching_research_id+"','"+dict_courses_class_big_id+"','"+course_system_name+"','"+course_name+"','"+course_name_en+"','"+is_test+"','"+is_alone_start+"','"+is_computer+"','"+course_code+"','"+curriculum_type+"','"+course_system_id+"','"+process_symbol+"');";
	   if(db.executeUpdate(sql)==true){
		   out.println("<script>parent.layer.msg('添加课程成功'); parent.layer.close(index); parent.location.reload();</script>");
	   }else{
		   out.println("<script>parent.layer.msg('添加课程失败!请重新输入');</script>");
	   }
	 }catch (Exception e){
	    out.println("<script>parent.layer.msg('添加课程失败');</script>");
	    return;
	}
	//关闭数据与serlvet.out
	
	if (page != null) {page = null;}
	
}%>
 
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