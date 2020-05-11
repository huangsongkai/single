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
		<title>新增进程</title> 
	    <style type="text/css">
			.inline{ position: relative; display: inline-block; margin-right: 10px; }
	    </style>
	</head>
	<body>
		<div style="margin: 15px;">
			<fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
				<legend>新增进程</legend>
			</fieldset>
			<form class="layui-form" action="new_process_manage.jsp?ac=add" method="post" >
              <div class="layui-form-item inline" style="width: 40%">
					<label class="layui-form-label" style=" width: 30%">进程选择</label>	 				
					<div class="layui-input-inline">
						<select name="campus" class="layui-input" lay-filter="campus"  lay-verify="required">
                            <%
                         //查询状态
                          ResultSet campusRs = db.executeQuery("SELECT  id,process_symbol_name FROM  dict_process_symbol;");
                            while(campusRs.next()){
                             %>
                          <option value="<%=campusRs.getString("id")%>"><%=campusRs.getString("process_symbol_name") %></option>
                           <%}if(campusRs!=null){campusRs.close();}%>
                         </select> 
					</div>
				</div>
                <label class="layui-form-label" style=" width: 30%">如果没有到：教学字典-》教学进程符号中添加</label>				
				<div class="layui-form-item" style="margin-bottom:45px">
					<div class="layui-input-block"  style="margin-left:540px">			
						<button class="layui-btn" >确认</button>
					</div>
				</div>
			</form>
		</div>
	</body>
</html>
<script>
	 layui.use('form', function(){
				layer = layui.layer,
				layedit = layui.layedit,
				laydate = layui.laydate;
				})
	 var index = parent.layer.getFrameIndex(window.name);

</script>
<% if("add".equals(ac)){ 
	 String campus=request.getParameter("campus");
	 
	 if(campus==null){campus="";}
	 String course_name="";
	 ResultSet czRs = db.executeQuery("SELECT  id,process_symbol_name FROM  dict_process_symbol WHERE id="+campus+";");
     while(czRs.next()){
      
          course_name=czRs.getString("process_symbol_name"); 
    }if(czRs!=null){czRs.close();}	
	try{
	   String sql="INSERT INTO `dict_courses` (`course_name`,`process_symbol`,`curriculum_type`) VALUES ('"+course_name+"','"+campus+"',1);";
	   if(db.executeUpdate(sql)){
		   out.println("<script>parent.layer.msg('新增成功'); parent.layer.close(index); parent.location.reload();</script>");
	   }else{
		   out.println("<script>parent.layer.msg('新增失败!请重新输入');</script>");
	   }
	 }catch (Exception e){
	    out.println("<script>parent.layer.msg('新增失败');</script>");
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