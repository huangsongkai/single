<%@ page trimDirectiveWhitespaces="true" %>
<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@page import="service.dao.db.Page"%>
<%@include file="../../cookie.jsp"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>

<%
   String departments_id= request.getParameter("departments_id");
   if(departments_id==null){departments_id="0";}
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
		<title>新增教学计划页面</title> 
	    <style type="text/css">
			.inline{ position: relative; display: inline-block; margin-right: 10px; }
	    </style>
	</head>
	<body>
		<div style="margin: 15px;">
			<fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
				<legend>新增教学计划</legend>
			</fieldset>
			<form class="layui-form" action="new_guide_enact.jsp?ac=add" method="post" >
			   
				<div class="layui-form-item inline" style="width: 40%">
					<label class="layui-form-label" style=" width: 30%">院系</label>
					
					<div class="layui-input-inline">
						<select name="departments_id" class="layui-input" lay-filter="depth">
						  <option value="0" >请选择院系</option> 
                             <%
                         //查询状态
                          ResultSet stateRs = db.executeQuery("SELECT  id,departments_name FROM  dict_departments  WHERE teach_tag=1;");
                            while(stateRs.next()){
                            %>
                          <option value="<%=stateRs.getString("id")%>" <%if(stateRs.getString("id").equals(departments_id)){out.print("selected=\"selected\"");}%>><%=stateRs.getString("departments_name") %></option>
                           <%}if(stateRs!=null){stateRs.close();}%>
                        </select> 
					</div>
				</div>
<!--		    <input type="hidden" name="usernameid" lay-verify="nickname" autocomplete="off" class="layui-input" value="">-->
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">专业</label>
					<div class="layui-input-inline">
						<select  name="major_id" class="layui-input" placeholder="专业"> 
                           <%
                         //查询状态
                          ResultSet Rs = db.executeQuery("SELECT  id,major_name FROM  major  WHERE departments_id="+departments_id+";");
                            while(Rs.next()){
                            %>
                          <option value="<%=Rs.getString("id")%>" ><%=Rs.getString("major_name")%></option>
                           <%}if(Rs!=null){Rs.close();}%>
                        </select> 
					</div>
				</div>
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">入学年份</label>
					<div class="layui-input-inline">
						<select  name="school_year" class="layui-input" placeholder="入学年份"> 
                           <%
                           SimpleDateFormat sdf = new SimpleDateFormat("yyyy");
                           Date date = new Date();
                           int nown=Integer.parseInt(sdf.format(date));
                           for(int i=0;i<30;i++){
                            %>
                          <option value="<%=nown-9+i%>" ><%=nown-9+i%></option>
                       <%} %>
                        </select> 
					</div>
				</div>
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">计划名</label>
					<div class="layui-input-inline">
						<input type="text" id="teaching_plan_name" name="author" class="layui-input" >
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
//多级联动
	 var index = parent.layer.getFrameIndex(window.name);
	 layui.use('form', function() {
			
				layer = layui.layer,
				layedit = layui.layedit,
				laydate = layui.laydate;
				var form = layui.form;
				  form.on('select(depth)', function(data){
					  
					  console.log(data.value); //得到被选中的值
					  window.location.href="?ac=&departments_id="+data.value;
					}); 
				})

</script>
<% if("add".equals(ac)){ 
	
	 String major_id=request.getParameter("major_id");
	 String school_year=request.getParameter("school_year");
	 String author=request.getParameter("author");
	 if(departments_id==null){departments_id="";}
	 if(major_id==null){major_id="";}
	 if(school_year==null){school_year="";}
	 if(author==null){author="";}
	 SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");//设置日期格式
	 
	try{
	   String sql="INSERT INTO teaching_plan_class_guidance (`addtime`,`add_worker_id`,`dict_departments_id`,`school_year`,`major_id`,`teaching_plan_name`)  VALUES ('"+df.format(new Date())+"','"+Suid+"','"+departments_id+"','"+school_year+"','"+major_id+"','"+author+"')";
	   if(db.executeUpdate(sql)==true){
		   String major_sql = "UPDATE major 					"+
							"	SET                             "+
							"	school_year = '"+school_year+"'     "+
							"	WHERE                           "+
							"	id = '"+major_id+"' ;";
			if(db.executeUpdate(major_sql)==true){
				out.println("<script>parent.layer.msg('添加 成功', {icon:1,time:1000,offset:'150px'},function(){parent.location.reload();});</script>");
			}else{
				out.println("<script>parent.layer.msg('添加 失败!请重新输入');</script>");
			}
	   }else{
		   out.println("<script>parent.layer.msg('添加 失败!请重新输入');</script>");
	   }
	} catch (Exception e){
	    out.println("<script>parent.layer.msg('添加 失败');</script>");
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