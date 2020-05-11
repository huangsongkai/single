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
		<title>新增学年学期</title> 
	    <style type="text/css">
			.inline{ position: relative; display: inline-block; margin-right: 10px; }
	    </style>
	</head>
	<body>
		<div style="margin: 15px;">
			<fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
				<legend>新增学年学期</legend>
			</fieldset>
			<form class="layui-form" action="new_academic_manage.jsp?ac=add" method="post" >
                <div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">学年学期号</label>
					<div class="layui-input-inline">
						<input type="text" id="academic_year" name="academic_year" class="layui-input"  lay-verify="required">
					</div>
				</div>	
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">学年学期号简称</label>
					<div class="layui-input-inline">
						<input type="text" id="academic_yaer_as" name="academic_yaer_as" class="layui-input" >
					</div>
				</div>	
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">学期周数</label>
					<div class="layui-input-inline">
						<input type="text" id="academic_weeks" name="academic_weeks" class="layui-input"  lay-verify="required" >
					</div>
				</div>
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">学期开始日期</label>
					<div class="layui-input-inline">
						<input type="text" id="start_date" name="start_date" class="layui-input"  lay-verify="required" >
					</div>
				</div>	
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">起始周</label>
					<div class="layui-input-inline">
						<input type="text" id="start_week" name="start_week" class="layui-input" >
					</div>
				</div>
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">截至周</label>
					<div class="layui-input-inline">
						<input type="text" id="end_week" name="end_week" class="layui-input" >
					</div>
				</div>	
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">是否当前学期</label>
					<div class="layui-input-inline">
						<input type="checkbox" name="aa" value="1" class="layui-input"  >
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
</html>
<script>
	 layui.use(['element','form','upload','layer','laydate'], function() {
				   var $    = layui.jquery ,
					form    = layui.form,
					 layer   = layui.layer,
					 laydate = layui.laydate,
					element = layui.element,
					upload = layui.upload;
				    form.render('select');  
					laydate.render({
					    elem: '#start_date'
					  });
				})
				
	 var index = parent.layer.getFrameIndex(window.name);

</script>
<% if("add".equals(ac)){ 
	 String academic_year=request.getParameter("academic_year");
	 String academic_yaer_as=request.getParameter("academic_yaer_as");
	 String start_week= request.getParameter("start_week");
	 String end_week= request.getParameter("end_week");
	 String academic_weeks= request.getParameter("academic_weeks");
	 String start_date= request.getParameter("start_date");
	 if(end_week==null){end_week="";}
	 if(academic_year==null){academic_year="";}
	 if(academic_yaer_as==null){academic_yaer_as="";}
	 if(start_week==null){start_week="";}
	 String aa=request.getParameter("aa");
	 String this_academic_tag="";
	 if(aa!=null){
		 this_academic_tag="true";
		 String sql = "UPDATE academic_year SET this_academic_tag = 'false'";
		 db.executeUpdate(sql);
	 }else{
		 this_academic_tag="false";
	 }
	try{
	   String sql="INSERT INTO `academic_year` (`academic_year`,`academic_yaer_as`,`start_week`,`end_week`,academic_weeks,start_date,`this_academic_tag`) VALUES ('"+academic_year+"','"+academic_yaer_as+"','"+start_week+"','"+end_week+"','"+academic_weeks+"','"+start_date+"','"+this_academic_tag+"');";
	   if(db.executeUpdate(sql)==true){
		   out.println("<script>parent.layer.msg('添加 成功');  parent.location.reload();parent.layer.close(index);</script>");
	   }else{
		   out.println("<script>parent.layer.msg('添加失败!请重新输入');</script>");
	   }
	 }catch (Exception e){
	    out.println("<script>parent.layer.msg('添加失败');</script>");
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