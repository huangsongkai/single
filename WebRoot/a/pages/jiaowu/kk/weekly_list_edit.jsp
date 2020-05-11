<%@ page trimDirectiveWhitespaces="true" %>
<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@page import="service.dao.db.Page"%>
<%@include file="../../cookie.jsp"%>
<%@page import="v1.haocheok.commom.common"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="net.sf.json.JSONArray"%>
<%@page import="org.apache.commons.lang3.StringUtils"%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head> 
	    <meta charset="utf-8"> 
	    <meta name="viewport" content="width=device-width, initial-scale=1"> 
	    
	    <link rel="stylesheet" href="../../../pages/css/sy_style.css">	    
	    <link rel="stylesheet" href="../../js/layui2/css/layui.css">
		<script type="text/javascript" src="../../js/jquery-1.9.1.js" ></script><!--通用jquery-->
		<script src="../../js/layui2/layui.js"></script>
		<script type="text/javascript" src="../../js/tableExport/js/table-sort.js" ></script><!--表格排序js  css-->
		<script type="text/javascript" chartset="utf8" src="../../js/tableExport/js/table_list.js " ></script><!--表格导出js  css-->
	 	<script src="../../js/layerCommon.js"></script>
	 
	    <title><%=Mokuai %></title> 
	   <style type="text/css"> 
	    th { background-color: white; }
	    .btn-group-vertical>.btn, .btn-group>.btn{height:33px;}
        table tr:hover{background:#eeeeee;color:#19A094;}
       </style>
 	</head> 
  <body>
  	
  	<%
		String classid = request.getParameter("classid"); if(classid==null){classid="0";}
		String weeklyid = request.getParameter("weeklyid"); if(weeklyid==null){weeklyid="0";}
		String semester = request.getParameter("semester");if(semester==null){semester="";}
%>
	<form class="layui-form" action="?ac=post&classid=<%=classid %>&weeklyid=<%=weeklyid %>" method="post">
				
			 	 <!-- id隐藏域 -->
			 	 <input type="hidden" name="classid" value="<%=classid%>"/>
			 	 <input type="hidden" name="id" value="<%=weeklyid%>" />
			 	 <input type="hidden" name="semester" value="<%=semester%>" />
	 			<div class="more ">
	 					<%if(weeklyid.equals("0")){%>
						<div class="layui-form-item dingwei width280"  >
							 <div class="layui-inline">
								 <label class="layui-form-label" >开始周数</label>
								 <div class="layui-input-inline" id="startweek">
								 	<select name="startweek" lay-search lay-filter="reduction" lay-verify="required" >
										<option value='0'></option>
										<%
											String startweekSql = "select id,academic_weeks from academic_year t where t.academic_year ='"+semester+"'";
											ResultSet rs = db.executeQuery(startweekSql);
											int academic_weeks =1;
											if(rs.next()){
											 academic_weeks = rs.getInt("academic_weeks");
											for(int i =0;i< academic_weeks;i++){	
										%>
											<option value='<%=i+1%>'><%=i+1 %></option>
										<%		}}	if(rs!=null){rs.close();}%>
								 	</select>
								 </div>
								 <font class='must'>*</font>
							  </div>
							  <div class="layui-inline">
								 <label class="layui-form-label"  >持续周数</label>
								 <div class="layui-input-inline" id="endweek">
						  			<select name="endweek" lay-search lay-filter="reduction" lay-verify="required"  >
						  				<option value='0'></option>
						  				<%
						  					for(int j =0;j<academic_weeks;j++){
						  						%>
						  						<option value='<%=j+1%>'><%=j+1 %></option>
						  						<%}%>
								 	</select>
								</div>
								<font class='must'>*</font>
							</div>
							<div class="layui-inline">
								 <label class="layui-form-label">校历类型</label>
								 <div class="layui-input-inline"  id="calendar" >
								 		<select name="calendar"  lay-filter="reduction" lay-verify="required"  />
						  					<option value='0'></option>
						  					<%
						  						String couseSql = "SELECT t.id,t.course_name FROM dict_courses t where t.curriculum_type=1";
						  						ResultSet courseRs = db.executeQuery(couseSql);
						  						while(courseRs.next()){
						  							%>
						  							<option value="<%=courseRs.getString("course_name")%>"><%=courseRs.getString("course_name") %></option>
						  							<%}if(courseRs!=null){courseRs.close();}%>
								 	</select>
								</div>
								<font class='must'>*</font>
							</div>
						</div>  
							<%}else{
								String checkInfoSql ="SELECT weekly_info FROM weekly_schedule t where t.class_id="+classid+" and t.semester='"+semester+"' ";
								ResultSet  infoRs = db.executeQuery(checkInfoSql);
								String weeklyInfo = "";
								if(infoRs.next()){
									if(StringUtils.isNotBlank(infoRs.getString("weekly_info"))){
										weeklyInfo = infoRs.getString("weekly_info");
									}
								}
								if(infoRs!=null){infoRs.close();}
								JSONObject json = JSONObject.fromObject(weeklyInfo); 
								JSONArray jsonAry = JSONArray.fromObject(json.getString("info"));
							 	for(int i =0;i<jsonAry.size();i++){
							 		JSONObject obj = (JSONObject)jsonAry.get(i);
							 		int startweek = obj.getInt("startweek");
							 		int endweek = obj.getInt("endweek");
							 		String calendar = obj.getString("calendar");
							 		%>
							 			<div class="layui-form-item dingwei width280"  style="width: 900px;" >
							 <div class="layui-inline">
								 <label class="layui-form-label" >开始周数</label>
								 <div class="layui-input-inline" id="startweek">
								 	<select name="startweek" lay-search lay-filter="reduction" lay-verify="required" >
										<option value='0'></option>
										<%
											String startweekSql = "select id,academic_weeks from academic_year t where t.academic_year ='"+semester+"'";
											ResultSet Rs = db.executeQuery(startweekSql);
											int academic_weeks =1;
											if(Rs.next()){
											 academic_weeks = Rs.getInt("academic_weeks");
											for(int p =0;p< academic_weeks;p++){	
												if(p+1==startweek){
													out.println("<option value='"+startweek+"'  selected >"+startweek+"</option>");
												}else{%>
													<option value='<%=p+1%>'  ><%=p+1 %></option>
											<%}}%>
										<%		}	%>
								 	</select>
								 </div>
								 <font class='must'>*</font>
							  </div>
							  <div class="layui-inline">
								 <label class="layui-form-label"  >持续周数</label>
								 <div class="layui-input-inline" id="endweek">
						  			<select name="endweek" lay-search lay-filter="reduction" lay-verify="required"  >
						  				<option value='0'></option>
						  				<%
						  					for(int l =0;l<academic_weeks;l++){
						  						if(l+1==endweek){
													out.println("<option value='"+endweek+"'  selected >"+endweek+"</option>");
						  						}else{
						  						%>
						  						<option value='<%=l+1%>'><%=l+1 %></option>
						  						<%}}%>
								 	</select>
								</div>
								<font class='must'>*</font>
							</div>
							<div class="layui-inline">
								 <label class="layui-form-label">校历类型</label>
								 <div class="layui-input-inline"  id="calendar" >
								 		<select name="calendar"  lay-filter="reduction" lay-verify="required"  />
						  					<option value='0'></option>
						  					<%
						  						String couseSql = "SELECT t.id,t.course_name FROM dict_courses t where t.curriculum_type=1";
						  						ResultSet courseRs = db.executeQuery(couseSql);
						  						while(courseRs.next()){
						  								if(calendar.equals(courseRs.getString("course_name"))){
															out.println("<option value='"+calendar+"'  selected >"+calendar+"</option>");
						  								}else{
						  							%>
						  							<option value="<%=courseRs.getString("course_name")%>"><%=courseRs.getString("course_name") %></option>
						  							<%}}if(courseRs!=null){courseRs.close();}%>
								 	</select>
								</div>
								<font class='must'>*</font>
							</div>
							<%
								if(i!=0){
							%>
							<a class="shan" style="display: none;"><font size="6">×</font></a>
							<%
								}
							%>
						</div>  
							 <%
							 	}}%>
						<a class="tianjia ">添加&nbsp;<font size="4">+</font></a>
					</div>
	 
	<div class="marbo"></div>
	 <div class="layui-form-item center ab">
	    <button class="layui-btn" lay-submit="" lay-filter="demo2"  style="margin-right: 250px;float: right;">保存</button>
	  </div>
	 
</form>
  </body>
  <script>
	layui.use(['form', 'layedit', 'laydate'], function(){
		 var form = layui.form;
		 form.verify({
		    title: function(value){
		      if(value.length==''){
		        return '得输入政策类型啊';
		      }
		    }
		    ,region: function(value){
		      if(value.length==''){
		        return '得输入区域啊';
		      }
		    }
		  });

		 var i=2;
			$(".more .tianjia").click(function(){
				//获取下拉菜单信息
				var append_gsptype = $("#startweek").html();
				var append_endweek = $("#endweek").html();
				var append_calendar = $("#calendar").html();
			
			i++;
				 $(this).before('<div class="layui-form-item dingwei width280" style="width:900px" >'+
						 			 '<div class="layui-inline">'+
									 '<input type="hidden" name="id" value="0" />'+
										'<label class="layui-form-label">开始周数</label>'+
										' <div class="layui-input-inline" id="startweek_'+i+'">'+
								   		
										'</div>'+
										'<font class="must">*</font>'+
									'</div>'+
									'<div class="layui-inline" >'+
									'	<label class="layui-form-label" >持续周数</label>'+
									'	 <div class="layui-input-inline" id="endweek_'+i+'">'+
						
									'	</div>'+
									'<font class="must">*</font>'+
									'</div>'+
									'<div class="layui-inline">'+
									'	<label class="layui-form-label" >校历类型</label>'+
									'	 <div class="layui-input-inline" id="calendar_'+i+'">'+
									'	</div>'+
									'<font class="must">*</font>'+
									'</div>'+
								' </div> ');
			
			 $(".more .layui-form-item").last().append('<a class="shan" style="display:none;"><font size="6">×</font></a>').siblings('.layui-form-item').children(".shan").remove();
			 $("#startweek_"+i+"").append(append_gsptype);
			 $("#endweek_"+i+"").append(append_endweek);
			 $("#calendar_"+i+"").append(append_calendar);
			 form.render('select');
			})
		  
		  	//鼠标放上显示隐藏 和删除
			$("body").on("mouseenter",".layui-form-item",function(){
				$(this).children(".shan").show();
			}).on("mouseleave",".layui-form-item",function(){
				$(this).children(".shan").hide();
			});
			$("body").on("click",".shan",function(){
				$(this).parent(".dingwei").remove();
				$(".more .layui-form-item:not(:first)").last().append('<a class="shan" style="display:none"><font size="6">×</font></a>');
				
			});
		  
		 form.on('submit(demo2)', function(data){
		    console.log(JSON.stringify(data.field));
		    return true;
		  });

		 <%
			if("post".equals(ac)){
				//接收流程信息
				 classid = request.getParameter("classid");
				 weeklyid = request.getParameter("id");
				 semester = request.getParameter("semester");
				String[] startweeks = request.getParameterValues("startweek");		//开始周数
				String[] endweeks = request.getParameterValues("endweek");			//持续周数
				String[] calendars = request.getParameterValues("calendar");		//校历类型
				
				String startweek = "";				
				String endweek = "";					
				String calendar = "";	
				int id = 0;
				JSONObject json = new JSONObject();
				ArrayList<JSONObject> ary = new ArrayList<JSONObject>();
				json.put("classid",classid);
				json.put("weeklyid",weeklyid);
				json.put("semester",semester);
				for(int i =0;i<startweeks.length;i++){
					JSONObject infoJson = new JSONObject();
					infoJson.put("startweek",startweeks[i]);
					infoJson.put("endweek",endweeks[i]);
					infoJson.put("calendar",calendars[i]);
					ary.add(infoJson);
				}
				json.put("info",ary);
				boolean state = false;
				String checkSql = "SELECT count(1) as row  FROM weekly_schedule t where t.id='"+weeklyid+"'";	
				int checkRow = db.Row(checkSql);
				String sql ="";
				if(checkRow>0){//更新
					sql = "update weekly_schedule set weekly_info='"+json+"',class_id='"+classid+"',semester='"+semester+"',updatetime=now(),update_worker_id="+Suid+" where id="+weeklyid;
				}else{//插入
					sql = "insert into weekly_schedule  (weekly_info,class_id,semester,addtime,add_worker_id) values('"+json+"',"+classid+",'"+semester+"',now(),'"+Suid+"')";
				}
				state = db.executeUpdate(sql);
				if(state){
					out.println("successMsg('保存成功');");
				}else{
					out.println("errorMsg('保存失败')");
				}
			}
		%>
    });
</script>
</html>
<% 
if(db!=null)db.close();db=null;if(server!=null)server=null;%>