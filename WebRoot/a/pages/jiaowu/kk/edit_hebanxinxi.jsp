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

<%
	//获取margeid
	String id = request.getParameter("id");
	//获取class_id
	String class_id = request.getParameter("class_id");
	
	String select_sql = " SELECT "+
								"marge_name_number,"+/*合班名称序号*/
								"marge_name,"+       /*合班名称，*/
								"marge_number,"+     /*合班序号，*/
								"class_grade_number"+/*合班人数*/
						" FROM marge_class  where id='"+id+"'";
	ResultSet set = db.executeQuery(select_sql);
	
	String marge_name_number = "";	
	String marge_name = "";			
	String marge_number = "";			
	String class_grade_number = "";			
	
	if(set.next()){
		
		marge_name_number = set.getString("marge_name_number");
		marge_name = set.getString("marge_name");
		marge_number = set.getString("marge_number");
		class_grade_number = set.getString("class_grade_number");
		
	}if(set!=null){set.close();}
	

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
		<title>修改合班信息</title> 
	    <style type="text/css">
			.inline{ position: relative; display: inline-block; margin-right: 10px; }
	    </style>
	</head>
	<body>
		<div style="margin: 15px;">  
			<fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
				<legend>修改合班信息</legend>
			</fieldset>
			<form class="layui-form" action="?ac=add" method="post" >
				<input type="hidden" name="base_id" value="<%=id%>"/>
				<input type="hidden" name="class_id" value="<%=class_id %>" />
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">合班名称序号</label>
					<div class="layui-input-inline">
						<input type="text" id="marge_name_number" name="marge_name_number" value="<%=marge_name_number %>" class="layui-input" >
					</div>
				</div>	
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">合班名称</label>
					<div class="layui-input-inline">
						<input type="text" id="marge_name" name="marge_name" value="<%=marge_name %>" class="layui-input" >
					</div>
				</div>	
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">合班序号</label>
					<div class="layui-input-inline">
						<input type="text" id="marge_number" name="marge_number" value="<%=marge_number %>" class="layui-input" >
					</div>
				</div>
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">合班人数</label>
					<div class="layui-input-inline">
						<input type="text" id="class_grade_number" name="class_grade_number" value="<%=class_grade_number %>" class="layui-input" >
					</div>
				</div>
				
				<div class="layui-form-item" style="margin-bottom:45px">
					<div class="layui-input-block"  style="margin-left:540px">			
						<button  class="layui-btn" >确认</button>
						<button type="reset" class="layui-btn layui-btn-primary">重置</button>
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
	//添加操作
	String marge_name_number_new = request.getParameter("marge_name_number");
	String marge_name_new = request.getParameter("marge_name");
	String marge_number_new = request.getParameter("marge_number");
	String class_grade_number_new = request.getParameter("class_grade_number");
	String base_id = request.getParameter("base_id");
	String update_sql = "UPDATE marge_class 							 "+
				"		SET                                              "+
				"		marge_name_number = '"+marge_name_number_new+"'                      "+
				"		,marge_name = '"+marge_name_new+"'                       "+
				"		,marge_number = '"+marge_number_new+"'       "+
				"		,class_grade_number = '"+class_grade_number_new+"'       "+
				"		WHERE                                            "+
				"		id = '"+base_id+"' ;";
				
	
	String class_id_new = request.getParameter("class_id");			
	String class_update = "UPDATE class_grade 							"+
					"		SET                                         "+
					"		class_name = '"+marge_name_new+"',                  "+
					"		people_number_nan = '"+class_grade_number_new+"'     "+
					"		WHERE                                       "+
					"		id = '"+class_id_new+"' ;";
	db.executeUpdate(class_update);	
	
	try{
		
		boolean state = db.executeUpdate(update_sql);
		if(state){
			out.println("<script>parent.layer.msg('修改合班信息 成功', {icon:1,time:1000,offset:'150px'},function(){parent.location.reload();}); </script>");
		}else{
			out.println("<script>parent.layer.msg('修改合班信息 失败');</script>");
		}
	 }catch (Exception e){
	    out.println("<script>parent.layer.msg('修改失败');</script>");
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