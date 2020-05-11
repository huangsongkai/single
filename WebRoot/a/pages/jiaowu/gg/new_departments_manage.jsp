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
		<title>新增院系</title> 
	    <style type="text/css">
			.inline{ position: relative; display: inline-block; margin-right: 10px; }
	    </style>
	</head>
	<body>
		<div style="margin: 15px;">
			<fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
				<legend>新增院系</legend>
			</fieldset>
			<form class="layui-form" action="new_departments_manage.jsp?ac=add" method="post" >
              <div class="layui-form-item inline" style="width: 40%">
					<label class="layui-form-label" style=" width: 30%">分校</label>	 				
					<div class="layui-input-inline">
						<select name="campus" class="layui-input" lay-filter="campus">
                             <%
                         //查询状态
                          ResultSet campusRs = db.executeQuery("SELECT  id,campus_name FROM  dict_campus;");
                            while(campusRs.next()){
                            %>
                          <option value="<%=campusRs.getString("id")%>"><%=campusRs.getString("campus_name") %></option>
                           <%}if(campusRs!=null){campusRs.close();}%>
                         </select> 
					</div>
				</div>
                <div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">院系编号</label>
					<div class="layui-input-inline">
						<input type="text" id="departments_number" name="departments_number" class="layui-input"  lay-verify="required">
					</div>
				</div>	
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">院系名称</label>
					<div class="layui-input-inline">
<%--						<input type="text" id="departments_name" name="departments_name" class="layui-input" lay-verify="required" >--%>
						<select name="departments_name" lay-verify="required"  lay-search>
					        <option value="0" ></option>
					         <%
					        	String depSql = "SELECT typename,id from type where typegroupcode='departmentNumber'";
					        	ResultSet base = db.executeQuery(depSql);
					        	while(base.next()){
					         %>
					         	<option value="<%=base.getString("typename") %>" ><%=base.getString("typename") %> 
					         	</option>
					         <%}if(base!=null){base.close();}%>
					      </select>
					</div>
				</div>	
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">院系英文名称</label>
					<div class="layui-input-inline">
						<input type="text" id="departments_english" name="departments_english" class="layui-input" >
					</div>
				</div>	
				 <div class="layui-form-item inline" style="width: 40%">
					<label class="layui-form-label" style=" width: 30%">教学标记</label>					
					<div class="layui-input-inline">
						<select name="teach_tag" class="layui-input" lay-filter="teach_tag"> 
                          <option value="0">无关</option>
                          <option value="1">有关</option>
                         </select> 
					</div>
				</div>		
				
				<div class="layui-form-item inline" style="width: 40%">
					<label class="layui-form-label" style=" width: 30%">常用标记</label>					
					<div class="layui-input-inline">
						<select name="iscommon" class="layui-input" lay-filter="teach_tag"> 
                          <option value="1">常用</option>
                          <option value="2">不常用</option>
                         </select> 
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

</script>
<% if("add".equals(ac)){ 
	
	 String departments_number=request.getParameter("departments_number");
	 String departments_name=request.getParameter("departments_name");
	 String departments_english= request.getParameter("departments_english");
	 String campus=request.getParameter("campus");
	 String teach_tag= request.getParameter("teach_tag");
	 String iscommon = request.getParameter("iscommon");
	 if(campus==null){campus="";}
	 if(teach_tag==null){teach_tag="";}
	 if(departments_number==null){departments_number="";}
	 if(departments_name==null){departments_name="";}
	 if(departments_english==null){departments_english="";}
	 if(iscommon==null){iscommon="1";}
	try{
	   String sql="INSERT INTO `dict_departments` (`departments_number`,`departments_name`,`departments_english`,`campus`,`teach_tag`,`iscommon`) VALUES ('"+departments_number+"','"+departments_name+"','"+departments_english+"','"+campus+"','"+teach_tag+"','"+iscommon+"');";
	   if(db.executeUpdate(sql)==true){
		   out.println("<script>parent.layer.msg('添加院系 成功'); parent.layer.close(index); parent.location.reload();</script>");
	   }else{
		   out.println("<script>parent.layer.msg('添加院系失败!请重新输入');</script>");
	   }
	 }catch (Exception e){
	    out.println("<script>parent.layer.msg('添加院系失败');</script>");
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