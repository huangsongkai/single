<%@ page trimDirectiveWhitespaces="true" %>
<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@page import="service.dao.db.Page"%>
<%@include file="../../cookie.jsp"%>
<%@page import="java.util.Date"%>
<%@page import="v1.haocheok.commom.common"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="org.apache.commons.lang3.StringUtils"%>

<%
common common=new common();
	String taskid="",teacherid="",week="",teaching_time="",remark="";
   String id = request.getParameter("id");
   if(StringUtils.isNotBlank(id)){
	   String teaSql = "select  * from teacher_week where id="+id;
	   ResultSet rs = db.executeQuery(teaSql);
	   while(rs.next()){
		   taskid= rs.getString("teaching_task_id");
		    teacherid= rs.getString("teacherid");
		    week= rs.getString("week");
		    teaching_time= rs.getString("teaching_time");
		    remark= rs.getString("remark");
	   }if(rs!=null)rs.close();
   }else{
	   id ="";
	    taskid= request.getParameter("taskid");
	    teacherid= request.getParameter("teacherid");
	    week= request.getParameter("week");
	    teaching_time= request.getParameter("teaching_time");
   }
   
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
		<title>修改课时</title> 
	    <style type="text/css">
			.inline{ position: relative; display: inline-block; margin-right: 10px; }
	    </style>
	</head>
	<body>
		<div style="margin: 15px;">
			<fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
				<legend>修改课时</legend>
			</fieldset>
			<form class="layui-form" action="?ac=update" method="post" >
						<input type="hidden" id="id" name="id" value="<%=id %>" class="layui-input"  readonly>
						<input type="hidden" id="taskid" name="taskid" value="<%=taskid %>" class="layui-input"  readonly>
						<input type="hidden" id="teacherid" name="teacherid" value="<%=teacherid %>" class="layui-input"  readonly>
                <div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">周次</label>
					<div class="layui-input-inline">
						<input type="text" id="week" name="week" value="<%=week %>" class="layui-input"  readonly>
					</div>
				</div>	
				
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">本周课时</label>
					<div class="layui-input-inline">
						<input type="text" id="teaching_time" name="teaching_time" value="<%=teaching_time %>" class="layui-input"  lay-verify="required" >
					</div>
				</div>
				
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">备注</label>
					<div class="layui-input-inline">
						<input type="text" id="remark" name="remark"  class="layui-input"  value="<%=remark%>" >
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
	 <% if("update".equals(ac)){ 
		 	 remark = request.getParameter("remark");
		 	 id = request.getParameter("id");
			 taskid = request.getParameter("taskid");
			 teacherid = request.getParameter("teacherid");
			 teaching_time = request.getParameter("teaching_time");
			 week = request.getParameter("week");
			 String sql = "";
			 if(StringUtils.isNotBlank(id)){
				 sql =" update teacher_week set teaching_time="+teaching_time+",remark='"+remark+"' where id="+id;
			 }else{
			 sql = "insert into  teacher_week 	(teaching_task_id,teacherid,week,teaching_time,leixing,state,remark)		"+
						"		values ("+taskid+","+teacherid+","+week+","+teaching_time+",1,1,'"+remark+"')                                             ";
			 }
			boolean state = db.executeUpdate(sql);
			if(state){
			   out.println("parent.layer.msg('修改课时 成功',{icon:1,time:1000,offset:'150px'},function(){  window.parent.location.reload(true);var index = parent.layer.getFrameIndex(window.name); parent.layer.close(index); });");
		   }else{
			   out.println("parent.layer.msg('修改课时 失败');");
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