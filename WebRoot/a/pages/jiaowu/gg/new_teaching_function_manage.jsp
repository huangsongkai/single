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
		<title>新增教学楼信息</title> 
	    <style type="text/css">
			.inline{ position: relative; display: inline-block; margin-right: 10px; }
	    </style>
	</head>
	<body>
		<div style="margin: 15px;">
			<fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
				<legend>新增教学楼信息</legend>
			</fieldset>
			<form class="layui-form" action="?ac=add" method="post" >
                <div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">教学区编号</label>
					<div class="layui-input-inline">
						<input type="text" id="teaching_number" name="teaching_number" class="layui-input"  lay-verify="required">
					</div>
				</div>	
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">是否是体育场</label>
					<div class="layui-input-inline">
						<select name="stadium"  lay-verify="required" lay-search>
							<option value="">请选择</option>
							<option value="0">否</option>
							<option value="1">是</option>								    
						</select>
					</div>
				</div>	
				
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">是否专用</label>
					<div class="layui-input-inline">
							<select name="reserved"  lay-verify="required" lay-search>
							<option value="">请选择</option>
							<option value="0">否</option>
							<option value="1">是</option>								    
						</select>
					</div>
				</div>	
				
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">分校编号</label>
					<div class="layui-input-inline">
						<select name="campus_id"  lay-verify="required" lay-search>
							<option value="">请选择</option>
							<%
								String campus_sql = "select id,campus_name from dict_campus;";
								ResultSet set_campus = db.executeQuery(campus_sql);
								while(set_campus.next()){
							%>
								<option value="<%=set_campus.getString("id")%>"><%=set_campus.getString("campus_name") %></option>
							<%}if(set_campus!=null){set_campus.close();} %>
								    
						</select>
					</div>
				</div>
				
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">教学区名称</label>
					<div class="layui-input-inline">
						<input type="text" id="teaching_area_name" name="teaching_area_name" class="layui-input"   lay-verify="required">
					</div>
				</div>
				
				
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">教学区排课序号</label>
					<div class="layui-input-inline">
						<input type="text" id="serial_number" name="serial_number" class="layui-input"   lay-verify="required">
					</div>
				</div>
				
				
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">排列顺序码</label>
					<div class="layui-input-inline">
						<input type="text" id="sequence_code" name="sequence_code" class="layui-input"  lay-verify="required" >
					</div>
				</div>
					
				<div class="layui-form-item" style="margin-bottom:45px">
					<div class="layui-input-block"  style="margin-left:540px">			
						<button  class="layui-btn" lay-submit >确认</button>
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
			String teaching_number = request.getParameter("teaching_number");
			String stadium = request.getParameter("stadium");
			String reserved = request.getParameter("reserved");
			String campus_id = request.getParameter("campus_id");
			String teaching_area_name = request.getParameter("teaching_area_name");
			String serial_number = request.getParameter("serial_number");
			String sequence_code = request.getParameter("sequence_code");
			String insert_sql = "INSERT INTO teaching_area 		"+
				"		(                                       "+
				"		teaching_number,                        "+
				"		stadium,                                "+
				"		reserved,                               "+
				"		campus_id,                              "+
				"		teaching_area_name,                     "+
				"		serial_number,                          "+
				"		sequence_code                           "+
				"		)                                       "+
				"		VALUES                                  "+
				"		(                                       "+
				"		'"+teaching_number+"',                      "+
				"		'"+stadium+"',                              "+
				"		'"+reserved+"',                             "+
				"		'"+campus_id+"',                            "+
				"		'"+teaching_area_name+"',                   "+
				"		'"+serial_number+"',                        "+
				"		'"+sequence_code+"'                         "+
				"		);";
			
			boolean state = db.executeUpdate(insert_sql);
			if(state){
			   out.println("parent.layer.msg('添加教学楼信息 成功',{icon:1,time:1000,offset:'150px'},function(){  window.parent.location.reload(true);var index = parent.layer.getFrameIndex(window.name); parent.layer.close(index); });");
		   }else{
			   out.println("parent.layer.msg('添加教学楼信息 失败');");
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