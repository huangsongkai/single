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
		<title>签字页面</title> 
	    <style type="text/css">
			.inline{ position: relative; display: inline-block; margin-right: 10px; }
	    </style>
	</head>
	<body>
		<div style="margin: 15px;">
			<fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
				<legend>签字页面</legend>
			</fieldset>
			<form class="layui-form" action="new_guide_audit.jsp?ac=add" method="post" >
			   <input name="sysid" type="hidden" value="<%=sysid%>" >
			   <table border="1" width="100%" bordercolorlight="#588FC7" cellspacing="0" cellpadding="0" bordercolor="#19A094" >
			   
          <%//计划分类表查询 
          String selectDsql="SELECT dict_departments_id,state_approve_id,school_year,major_id,add_worker_id,addtime,opinion from teaching_plan_class_guidance WHERE id="+sysid+";";
          
          System.out.println("selectDsql"+selectDsql);
            ResultSet Rs = db.executeQuery(selectDsql);
            while(Rs.next()){%>
			   <tr>
			      <td align="center">院系名称</td>
			      <td ><%=common.idToFieidName("dict_departments","departments_name",Rs.getString("dict_departments_id"))%></td>
			      <td align="center">入学年份</td>
			      <td colspan="3"><%=Rs.getString("school_year")%></td>
			   </tr>
			   <tr>
			      <td align="center">专业名称</td>
			      <td ><%=common.idToFieidName("major","major_name",Rs.getString("major_id"))%></td>
			      <td align="center">提交人</td>
			      <td ><%=common.getusernameTouid(Rs.getString("add_worker_id"))%></td>
			      <td align="center">提交日期</td>
			      <td ><%=Rs.getString("addtime")%></td>
			   </tr>
			   <tr>
			      <td align="center">选项</td>		      
			      <td colspan="5">
			        <input name="status" type="radio" value="7"  <%if("7".equals(Rs.getString("state_approve_id"))){out.println("checked='checked'");} %> title="同意 "/> 
                    <input name="status" type="radio" value="4" <%if("4".equals(Rs.getString("state_approve_id"))){out.println("checked='checked'");} %> title="不同意"/>  
                    <input name="status" type="radio" value="6" <%if("6".equals(Rs.getString("state_approve_id"))){out.println("checked='checked'");} %> title="直接提交"/>
			      </td>
			   </tr>
			    <tr>
			      <td align="center">签字意见</td>		      
			      <td colspan="5"><textarea name="text" style="width:500px;height:80px;"><% if(Rs.getString("opinion")!=null){out.println(Rs.getString("opinion"));}%></textarea></td>
			   </tr>
			   
			   </table>				
			   
			   <%
			   		if("7".equals(Rs.getString("state_approve_id")) || "4".equals(Rs.getString("state_approve_id")) || "6".equals(Rs.getString("state_approve_id"))){
			   		}else{
			   %>
			   			<div class="layui-form-item" style="margin-bottom:45px">
							<div class="layui-input-block"  style="margin-left:540px">			
								<button  class="layui-btn" >确认</button>
							</div>
						</div>
			   <%} %>
				
				
				<%}if(Rs!=null){Rs.close();} %>
				
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
	
	 String status=request.getParameter("status");
	 String text=request.getParameter("text");
	 sysid= request.getParameter("sysid");
	 SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");//设置日期格式
	 if(status==null){status="";}
	 if(text==null){text="";}
	 if(sysid==null){sysid="";}

	 
	try{
	   String sql="UPDATE `teaching_plan_class_guidance` set opinion='"+text+"',state_approve_id='"+status+"',add_worker_id='"+Suid+"',signature_addtime='"+df.format(new Date())+"' where id='"+sysid+"';";
	   System.out.print(sql);
	   if(db.executeUpdate(sql)==true){
		   out.println("<script>parent.layer.msg('签字 成功', {icon:1,time:1000,offset:'150px'},function(){parent.location.reload();});</script>");
	   }else{
		   out.println("<script>parent.layer.msg('签字失败!请重新输入');</script>");
	   }
	} catch (Exception e){
		
	    out.println("<script>parent.layer.msg('签字 失败');</script>");
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