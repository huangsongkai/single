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
		<script src="../../js/ajaxs.js"></script>
		<title>编辑银行卡</title>
	    <style type="text/css">     
			.inline{position: relative; display: inline-block; margin-right: 10px;}
	    </style>
	</head> 
	<body>
		<div style="margin: 15px;">  
			<fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
				<legend>编辑银行卡</legend>
			</fieldset>
			<form class="layui-form" action="?ac=edit&id=<%=id%>" method="post" >
			<% 
			String sqls="SELECT * FROM `wealth_bank` WHERE id='"+id+"';";
			 ResultSet Rs = db.executeQuery(sqls);
			 String bankcard = "";
			 String id_number = "";
			 String name = "";
	          while(Rs.next()){
	        	  bankcard = Rs.getString("bankcard");
	        	  id_number = Rs.getString("id_number");
	        	  name = Rs.getString("name");
			%>
				<div class="layui-form-item inline" style="width: 40%">
					<label class="layui-form-label" style=" width: 30%">开户行</label>	 				
					<div class="layui-input-inline">
						<input type="text" id="name"  lay-verify="required" name="name" class="layui-input" value="<%=name%>">
					</div>
				</div>
                <div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">身份证号</label>
					<div class="layui-input-inline">
						<input type="text" id="id_number"  lay-verify="required" name="id_number" class="layui-input" value="<%=id_number%>">
					</div>
				</div>	
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">银行卡</label>
					<div class="layui-input-inline">
						<input type="text" id="bankcard" lay-verify="required"  name="bankcard" class="layui-input" value="<%=bankcard%>">
					</div>
				</div>
				<div class="layui-form-item" style="margin-bottom:45px">
					<div class="layui-input-block"  style="margin-left:540px">			
						<button  class="layui-btn"  lay-submit >确认</button> 
					</div>
				</div>
				<%}%>
			</form>
		</div>
	</body>
</html>
<script>

	 layui.use('form', function(){
		 layer = layui.layer,
		layedit = layui.layedit,
		laydate = layui.laydate;
		var form = layui.form;
		var $ = layui.jquery;
	})
	 var index = parent.layer.getFrameIndex(window.name);
</script>
<% if("edit".equals(ac)){ 
	  bankcard=request.getParameter("bankcard");
	  id_number=request.getParameter("id_number");
	 name= request.getParameter("name");

	try{
	   String sql="UPDATE wealth_bank" 
			+" SET"
			+" name = '"+name+"' ,"
			+"id_number = '"+id_number+"' ," 
			+"bankcard = '"+bankcard+"'  	"
			+"WHERE"
			+" id = '"+id+"';";
	   if(db.executeUpdate(sql)==true){
		   out.println("<script>parent.layer.msg('编辑成功'); parent.layer.close(index); parent.location.reload();</script>");
	   }else{
		   out.println("<script>parent.layer.msg('编辑失败!请重新输入');</script>");
	   }
	 }catch (Exception e){		 
	    out.println("<script>parent.layer.msg('编辑失败');</script>");
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