<%@ page trimDirectiveWhitespaces="true" %>
<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@page import="service.dao.db.Page"%>
<%@include file="../../cookie.jsp"%>
<%
   String id= request.getParameter("id");
   if(regex_num(id)==false){id="0";}
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
		<title>编辑教室</title> 
	    <style type="text/css">
			.inline{ position: relative; display: inline-block; margin-right: 10px; }
	    </style>
	</head>
	<body>
		<div style="margin: 15px;">
			<fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
				<legend>编辑教室</legend>
			</fieldset>
			<form class="layui-form" action="edit_classroom_manage.jsp?ac=edit&id=<%=id%>" method="post" >
			<% 
			String sqls="SELECT * FROM `classroom` WHERE id='"+id+"';";
			 ResultSet Rs = db.executeQuery(sqls);
	          while(Rs.next()){
			%>
              <div class="layui-form-item inline" style="width: 40%">
					<label class="layui-form-label" style=" width: 30%">教学楼名称</label>	 				
					<div class="layui-input-inline">
						<select name="building_id" class="layui-input" lay-filter="building_id"  lay-verify="required">
                             <%
                         //查询状态
                          ResultSet campusRs = db.executeQuery("SELECT  id,building_name FROM teaching_building;");
                            while(campusRs.next()){
                            %>
                          <option value="<%=campusRs.getString("id")%>" <%if(campusRs.getString("id").equals(Rs.getString("building_id"))){out.print("selected=\"selected\"");}%>><%=campusRs.getString("building_name") %></option>
                           <%}if(campusRs!=null){campusRs.close();}%>
                         </select> 
					</div>
				</div>
				 <div class="layui-form-item inline" style="width: 40%">
					<label class="layui-form-label" style=" width: 30%">教学功能区名称</label>	 				
					<div class="layui-input-inline">
						<select name="teaching_area_id" class="layui-input" lay-filter="teaching_area_id" lay-verify="required" >
                             <%
                         //查询状态
                          ResultSet gnRs = db.executeQuery("SELECT  id,teaching_area_name FROM teaching_area;");
                            while(gnRs.next()){
                            %>
                          <option value="<%=gnRs.getString("id")%>" <%if(gnRs.getString("id").equals(Rs.getString("teaching_area_id"))){out.print("selected=\"selected\"");}%>><%=gnRs.getString("teaching_area_name") %></option>
                           <%}if(gnRs!=null){gnRs.close();}%>
                         </select> 
					</div>
				</div>
				 <div class="layui-form-item inline" style="width: 40%">
					<label class="layui-form-label" style=" width: 30%">是否专用</label>					
					<div class="layui-input-inline">
						<select name="dedicated" class="layui-input" lay-filter="dedicated" lay-verify="required" > 
                          <option value="0" <%if("0".equals(Rs.getString("dedicated"))){out.print("selected=\"selected\"");}%>>否</option>
                          <option value="1" <%if("1".equals(Rs.getString("dedicated"))){out.print("selected=\"selected\"");}%>>是</option>
                         </select> 
					</div>
				</div>	
				 <div class="layui-form-item inline" style="width: 40%">
					<label class="layui-form-label" style=" width: 30%">状态</label>					
					<div class="layui-input-inline">
						<select name="state" class="layui-input" lay-filter="state" lay-verify="required" > 
                          <option value="1" <%if("1".equals(Rs.getString("state"))){out.print("selected=\"selected\"");}%>>可用</option>
                          <option value="0" <%if("0".equals(Rs.getString("state"))){out.print("selected=\"selected\"");}%>>不可用</option>
                         </select> 
					</div>
				</div>	
                <div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">教室编号</label>
					<div class="layui-input-inline">
						<input type="text" id="classroom_number" name="classroom_number" class="layui-input" value="<%=Rs.getString("classroom_number")%>" lay-verify="required">
					</div>
				</div>	
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">教室名称</label>
					<div class="layui-input-inline">
						<input type="text" id="classroom_name" name="classroomname" class="layui-input" value="<%=Rs.getString("classroomname")%>" lay-verify="required"> 
					</div>
				</div>	
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">上课容纳人数</label>
					<div class="layui-input-inline">
						<input type="text" id="goclass_number" name="goclass_number" class="layui-input" value="<%=Rs.getString("goclass_number")%>" lay-verify="required">
					</div>
				</div>		
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">考试容纳人数</label>
					<div class="layui-input-inline">
						<input type="text" id="exam_number" name="exam_number" class="layui-input" value="<%=Rs.getString("exam_number")%>" lay-verify="required">
					</div>
				</div>				
				<div class="layui-form-item" style="margin-bottom:45px">
					<div class="layui-input-block"  style="margin-left:540px">			
						<button  class="layui-btn" lay-submit >确认</button>
					</div>
				</div>
				<%}if(Rs!=null){Rs.close();}%>
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

</script>
<% if("edit".equals(ac)){ 
	
	 String classroom_number=request.getParameter("classroom_number");
	 String classroomname=request.getParameter("classroomname");
	 String dedicated= request.getParameter("dedicated");
	 String teaching_area_id=request.getParameter("teaching_area_id");
	 String building_id= request.getParameter("building_id");
	 String goclass_number= request.getParameter("goclass_number");
	 String exam_number=request.getParameter("exam_number");
	 String state= request.getParameter("state");
	 if(goclass_number==null){goclass_number="";}
	 if(classroomname==null){classroomname="";}
	 if(state==null){state="";}
	 if(classroom_number==null){classroom_number="";}
	 if(classroomname==null){classroomname="";}
	 if(dedicated==null){dedicated="";}
	 if(teaching_area_id==null){teaching_area_id="";}
	 if(building_id==null){building_id="";}
	try{
	   String sql="UPDATE `classroom` SET classroom_number='"+classroom_number+"',classroomname='"+classroomname+"',dedicated='"+dedicated+"',teaching_area_id='"+teaching_area_id+"',building_id='"+building_id+"',goclass_number='"+goclass_number+"',exam_number='"+exam_number+"',state='"+state+"' WHERE id='"+id+"';";
	   if(db.executeUpdate(sql)==true){
		   out.println("<script>parent.layer.msg('添加教室成功'); parent.layer.close(index); parent.location.reload();</script>");
	   }else{
		   out.println("<script>parent.layer.msg('添加教室失败!请重新输入');</script>");
	   }
	 }catch (Exception e){
	    out.println("<script>parent.layer.msg('添加教室失败');</script>");
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