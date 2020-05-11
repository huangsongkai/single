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
		<script src="../../js/ajaxs.js"></script>
		<title>新增教研室</title>
	    <style type="text/css">     
			.inline{position: relative; display: inline-block; margin-right: 10px;}
	    </style>
	</head> 
	<body>
		<div style="margin: 15px;">  
			<fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
				<legend>新增教研室</legend>
			</fieldset>
			<form class="layui-form" action="new_teach_manage.jsp?ac=add" method="post" >
              <div class="layui-form-item inline" style="width: 40%">
					<label class="layui-form-label" style=" width: 30%">分校</label>	 				
					<div class="layui-input-inline">
						<select name="campus_id" class="layui-input" lay-filter="campus_id">
							<option value="0">请选择分校</option>
                           <%
                           //查询状态
                           ResultSet campusRs = db.executeQuery("SELECT  id,campus_name FROM  dict_campus;");
                           while(campusRs.next()){
                           %>
                           <option value="<%=campusRs.getString("id")%>"><%=campusRs.getString("campus_name")%></option>
                           <%}if(campusRs!=null){campusRs.close();}%>
                         </select> 
					</div>
				</div>
				<div class="layui-form-item inline" style="width: 40%">
					<label class="layui-form-label" style=" width: 30%">院系</label>	 				
					<div class="layui-input-inline">
						<select name="departments_id" class="layui-input" id="yuanxi" lay-filter="" >
                        </select> 
					</div>
				</div>
                <div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">教研室编码</label>
					<div class="layui-input-inline">
						<input type="text" id="teaching_research_code" name="teaching_research_code" class="layui-input"  lay-verify="required">
					</div>
				</div>	
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">教研室名称</label>
					<div class="layui-input-inline">
						<input type="text" id="teaching_research_name" name="teaching_research_name" class="layui-input"  lay-verify="required" >
					</div>
				</div>
				<div class="layui-form-item inline" style="width: 40%">
					<label class="layui-form-label" style=" width: 30%">与教学有关</label>	 				
					<div class="layui-input-inline">
						<select name="is_teaching" class="layui-input" lay-filter="is_teaching">
                          <option value="0">无关</option> 
                          <option value="1">有关</option>    
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
	 layui.use(['form','layer','jquery'], function(){
		layer = layui.layer,
		layedit = layui.layedit,
		laydate = layui.laydate;
		var form = layui.form;
		var $ = layui.jquery;

		form.on('select(campus_id)',function(data){
			//通过抓也获取班级
			if(data.value!="0"){
				var obj_str1 = {"xiaoqu":data.value};
				var obj1 = JSON.stringify(obj_str1)
				var ret_str1=PostAjx('../../../../Api/v1/?p=web/info/campusGetDepartment',obj1,'<%=Suid%>','<%=Spc_token%>');
				obj1 = JSON.parse(ret_str1);
				$("#yuanxi").html(obj1.data);
				form.render('select');
			}
		})
			

				
				
	})
	 var index = parent.layer.getFrameIndex(window.name);

</script>
<% if("add".equals(ac)){ 
	
	 String campus_id=request.getParameter("campus_id");
	 String departments_id=request.getParameter("departments_id");
	 String teaching_research_code= request.getParameter("teaching_research_code");
	 String teaching_research_name=request.getParameter("teaching_research_name");
	 String is_teaching=request.getParameter("is_teaching");

	 if(is_teaching==null){is_teaching="";}
	 if(campus_id==null){campus_id="";}
	 if(departments_id==null){departments_id="";}
	 if(teaching_research_code==null){teaching_research_code="";}
	 if(teaching_research_name==null){teaching_research_name="";}
	try{
	   String sql="INSERT INTO `teaching_research` (`campus_id`,`departments_id`,`teaching_research_code`,`teaching_research_name`,`is_teaching`) VALUES ('"+campus_id+"','"+departments_id+"','"+teaching_research_code+"','"+teaching_research_name+"','"+is_teaching+"');";
	   if(db.executeUpdate(sql)==true){
		   out.println("<script>parent.layer.msg('添加教研室 成功'); parent.layer.close(index); parent.location.reload();</script>");
	   }else{
		   out.println("<script>parent.layer.msg('添加教研室失败!请重新输入');</script>");
	   }
	 }catch (Exception e){		 
	    out.println("<script>parent.layer.msg('添加教研室失败');</script>");
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