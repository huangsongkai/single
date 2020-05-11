<%@ page trimDirectiveWhitespaces="true" %>
<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@page import="net.sf.json.JSONArray"%>
<%@page import="net.sf.json.JSONObject"%>
<%@ include file="../../cookie.jsp"%>
<%
	/*获取老师列表*/
	if("teacherList".equals(ac)){
		
		int pages=1;
		int limit=10;
		
		if(request.getParameter("page")!=null) {pages=Integer.parseInt(request.getParameter("page"));}
		if(request.getParameter("limit")!=null){limit=Integer.parseInt(request.getParameter("limit"));}
		/*拼凑limit条件*/
		String limitSql="limit "+(pages-1)*limit+","+limit+" ";
		
		/*拼凑sql的where 条件*/
		StringBuffer sql_where = new StringBuffer();	
		JSONObject form_datr = JSONObject.fromObject(request.getParameter("form_date").toString());
		
		/*使用了搜索*/
		if(form_datr.size()>0){
			
			if(form_datr.getString("teacherName")!=null && form_datr.getString("teacherName").length()>0){/*学期号*/
				sql_where.append(" AND w.username LIKE '%"+form_datr.getString("teacherName")+"%'   ");
			}
			if(form_datr.getString("teaching_research")!=null && form_datr.getString("teaching_research").length()>0){/*学期号*/
				sql_where.append(" AND  res.id='"+form_datr.getString("teaching_research")+"'   ");
			}
		}
		
		
		/*返回数据*/
		JSONObject json =new JSONObject();
		JSONArray  json_arr = new JSONArray();
		
		/*计划总条数*/
		String teacherList_count_sql="SELECT count(1) row FROM user_worker w,teacher_basic t LEFT JOIN  dict_departments dic ON t.faculty=dic.id  LEFT JOIN  teaching_research res ON t.teachering_office=res.id  WHERE  w.user_association=t.id   AND userole='1' "+sql_where+";";
		int plan_num=db.Row(teacherList_count_sql);
		/*教师基本信息*/
		String teacherList_sql=" SELECT "+
									"w.uid AS ID ,"+
									"t.teacher_number AS teacher_number ,"+
									"w.username AS username,"+
									"w.sex AS sex,"+
									"w.usermob AS usermob,"+
									"w.password AS password,"+
									"res.teaching_research_name AS teaching_research_name,"+
									"dic.departments_name AS departments_name,"+
									"w.state AS state"+
							   " FROM "+
							   " 	user_worker w,teacher_basic t "+
							   "	LEFT JOIN  dict_departments dic ON t.faculty=dic.id "+
							   "	LEFT JOIN  teaching_research res ON t.teachering_office=res.id "+
							   " WHERE  w.user_association=t.id "+
							   "    AND userole='1' "+
							   sql_where+
							   limitSql+";";
		ResultSet rs = db.executeQuery(teacherList_sql);
		String state="";
		String sex="";
		
		while(rs.next()){
			JSONObject json_son =new JSONObject();
			
			if(rs.getInt("sex")==1){ sex="男"; }else if(rs.getInt("sex")==2){sex="女"; }else{sex="未知"; }
			if(rs.getInt("state")==1){ state="启用"; }else{state="禁止"; }
			
			json_son.put("ID",								rs.getString("ID"));
			json_son.put("teacher_number",					rs.getString("teacher_number"));
			json_son.put("username",						rs.getString("username"));
			json_son.put("sex",								sex);
			json_son.put("usermob",							rs.getString("usermob"));
			json_son.put("password",						"******");
			json_son.put("teaching_research_name",			rs.getString("teaching_research_name"));
			json_son.put("departments_name",				rs.getString("departments_name"));
			json_son.put("state",							state);
			
			json_arr.add(json_son);
		}if(rs!=null){rs.close();}
		
		json.put("code","0");
		json.put("msg","");
		json.put("count",plan_num);
		json.put("data",json_arr);
		out.print(json);
		
	if(db!=null)db.close();db=null;
	return;
	}
	
	/*修改老师密码*/
	if("updateTeacherPassword".equals(ac)){
	
		String updateTeacherid= request.getParameter("updateTeacherid").toString();
		
		
		if(updateTeacherid.length()>0){
			String update_sql=" UPDATE user_worker  SET PASSWORD = usermob WHERE uid IN  ("+updateTeacherid+") ;";
			boolean upState=false;
			upState = db.executeUpdate(update_sql);
			out.print(upState);
		}
	
	if(db!=null)db.close();db=null;
	return;
	}
	

	/*修改老师账户状态*/
	if("updateTeacherState".equals(ac)){
	
		String updateTeacherid= request.getParameter("updateTeacherid").toString();
		String state= request.getParameter("state").toString();
		
		if(updateTeacherid.length()>0){
			String update_sql="UPDATE user_worker  SET state = '"+state+"' WHERE uid = '"+updateTeacherid+"' ;";
			System.out.println(update_sql);
			boolean upState=false;
			upState = db.executeUpdate(update_sql);
			out.print(upState);
		}
		
	if(db!=null)db.close();db=null;
	return;
	}
%>


<!DOCTYPE html> 
<html>
  <head>
    <meta charset="utf-8"> 
    <meta name="viewport" content="width=device-width, initial-scale=1"> 
    <title>教师密码管理</title>
    <link rel="stylesheet" href="../../../pages/css/sy_style.css">	
    <link rel="stylesheet" href="../../js/layui2/css/layui.css">
	<script type="text/javascript" src="../../js/jquery-1.9.1.js" ></script><!--通用jquery-->
	<script src="../../js/layui2/layui.js"></script>
	<script type="text/javascript" src="../../js/ajaxs.js" ></script>
  </head>
  <body>
  	<%-- 页面搜索区 --%>
  	<div id="tb" class="form_top layui-form" style="display: flex;width:1200px; float: inherit;">
	  	<form class="layui-form">
	  		<div class="layui-input-inline">
			    	<input type="text" name="teacherName" required   placeholder="请输入教师姓名" autocomplete="off" class="layui-input">
			</div>
	  		<div class="layui-input-inline">
				<select name="teaching_research" id="teaching_research" lay-search>
					<option value="">请选择教研室</option>
					<%
						String xueqi_sql = "SELECT  id,teaching_research_name FROM teaching_research  ";
						ResultSet xueqi_set = db.executeQuery(xueqi_sql);
						while(xueqi_set.next()){
					%>
						<option value="<%=xueqi_set.getString("id") %>" ><%=xueqi_set.getString("teaching_research_name") %></option>
					<%}if(xueqi_set!=null){xueqi_set.close();} %>
				</select>
			 </div>
	  		<button class="layui-btn layui-btn-small  layui-btn-primary"  lay-submit lay-filter="*"  id="w_button" style="height: 35px;  color: white; background: rgb(25, 160, 148);"> <i class="layui-icon" style="color: #FFF;">&#xe615;</i> 搜索</button>
			<div class="layui-btn-group demoTable">
					<a class="layui-btn" data-type="getCheckData">初始化选中密码</a>
			</div>
			<div class="layui-form-item" style=" width: 0px;float:  right;margin-top: -39px;">
			    <a class="layui-btn"  onclick=" $('#table_control').fadeToggle();"><i class="layui-icon" style="font-size: 30px; color: #f4f6f7;">&#xe620;</i>  </a>
			    <div class="layui-form-select" style="    margin-left: 10%;">
			    	<dl class="layui-anim layui-anim-upbit" style="margin-top: -40px; " id="table_control">
			    		<dd  class=""> <input type="checkbox" name="id" title="" lay-filter="tableControl"></dd>
			    		<dd  class=""> <input type="checkbox" name="like[write1]" title="写作" lay-filter="tableControl"></dd>
			    		<dd  class=""> <input type="checkbox" name="like[write2]" title="写作" lay-filter="allChoose"></dd>
			    	</dl>
			    </div>
			</div>
		</form>
	</div>
  	
  	<%-- 页面展示区 --%>
  	<table class="layui-table" lay-filter="demo" style="    margin-top: -2%;" id="test"></table>
  </body>
  <script type="text/html" id="barDemo">
  		<a class="layui-btn layui-btn-primary layui-btn-xs" lay-event="editPassword">初始密码</a>
  		<a class="layui-btn layui-btn-xs" lay-event="editState">修改账号状态</a>
  </script>
  <script type="text/javascript">
			/*编写表格头数据*/
		  	var tade_head=[[
					 {type:'checkbox', fixed: 'left'}
					,{field:'ID',  						title: 'ID', 		sort: true}
					,{field:'teacher_number',  			title: '教师编号', 	sort: true}
					,{field:'username',  				title: '教师姓名', 	sort: true}
					,{field:'sex',  					title: '性别', 	sort: true}
					,{field:'usermob',  				title: '手机号码', 	sort: true}
					,{field:'password',  				title: '密码', 	sort: true}
					,{field:'teaching_research_name',	title: '所属教研室',	sort: true}
					,{field:'departments_name',  		title: '所属院系', 	sort: true}
					,{field:'state',  					title: '账号状态', 	sort: true}
					,{field:'operation',  				title: '操作', 		width:250,  fixed: 'right',  toolbar: '#barDemo'}
				 ]]
				/*创建控制表格显示列方法*/
				/*获取整个表头的级数*/
				var tade_head_l=tade_head.length;
				/*获取表头的最后一级数组*/
				var table_hed=tade_head[tade_head_l-1];
				/*声明保存html代码的标量*/
				var tableControl_html="";
				/*遍历当前数组*/
				for(var i=0;i<table_hed.length;i++){
					/*是否存在显示对象*/
					if(table_hed[i].field!=undefined){
							tableControl_html=tableControl_html+"<dd  class><input type=\"checkbox\" value=\""+table_hed[i].field+"\" name=\""+table_hed[i].field+"\" title=\""+table_hed[i].title+"\"  lay-filter=\"tableControl\"> </dd>";
					}
				}
				$("#table_control").html(tableControl_html);
			
	
	
			layui.use(['laypage', 'form', 'laydate', 'table'], function(){
		 		var laypage 	= layui.laypage
				  	,layer 		= layui.layer
				  	,table 		= layui.table
				  	,laydate 	= layui. laydate
				  	,form 		= layui.form;
				var field={};
				 form.on('submit(*)', function(data){
		  			field=data.field;
				  	
				  	table.reload('test', {
					  url: '?ac=teacherList&form_date='+JSON.stringify(field)
					});
				  	return false;	
				 }); 	
				/*定义表格*/
				table.render({
				    elem: '#test'
				    ,url:'?ac=teacherList&form_date='+JSON.stringify(field)
				    ,page:true
				    ,minWidth:80
				    ,cellMinWidth: 100 //全局定义常规单元格的最小宽度，layui 2.2.1 新增
				    ,cols: tade_head
				});
	  
			  	/*渲染select*/
			  	form.render('select');
			  	form.render('checkbox');
	
				 
				/*监听表头控制*/
				form.on('checkbox(tableControl)', function(data){
				 	if(data.elem.checked){/*隐藏*/
				 		$("th[data-field="+data.value+"]").css("display","none");
				 		$("td[data-field="+data.value+"]").css("display","none");
				 	}else{/*显示*/
				 		$("th[data-field="+data.value+"]").removeAttr("style");
				 		$("td[data-field="+data.value+"]").removeAttr("style");
				 	}
				}); 
				
  				//监听工具条
			  	table.on('tool(demo)', function(obj){
			    	var data = obj.data;
			    	if(obj.event === 'editPassword'){/*初始当前密码*/
			    		layer.confirm('确定初始化当前密码吗？初始化后密码为用户的手机号！', function(index){

			    			var state=PostAjx('?ac=updateTeacherPassword&updateTeacherid='+data.ID,null,'','');
			    			if(state){
									layer.msg("初始化成功！",{icon:1,time:1000,offset:'150px'},function(){
							   });
							}else{
									layer.msg("初始化失败！",{icon:2,time:1000,offset:'150px'},function(){
							   });
							}

					    });
				    } else if(obj.event === 'editState'){/*修改 当前状态*/
					    
				      	layer.confirm('确定要修改当前状态吗？', function(index){
							var state=data.state;

							if(state=='启用'){state='0'}else{state='1'}
					      	
				      		var upstate=PostAjx('?ac=updateTeacherState&updateTeacherid='+data.ID+'&state='+state,null,'','');
			    			if(upstate){
									layer.msg("修改成功！",{icon:1,time:1000,offset:'150px'},function(){
									document.getElementById("w_button").click();
							   });
							}else{
									layer.msg("修改失败！",{icon:2,time:1000,offset:'150px'},function(){
							   });
							}
				      	});
			    	} 
			  });
  			
			  var $ = layui.$, active = {
			      getCheckData: function(){ /*获取选中数据*/
			      		var   checkStatus = table.checkStatus('test'),
			      	    	  data = checkStatus.data;

						      layer.confirm('确定初始化选用的用户密码吗？初始化后密码为用户的手机号！', function(index){
						    	    var str= new Array();
									for(var i =0 ; i < data.length;i++){
										str[i]=data[i].ID+"";
									}
									if(str.length>0){
										str = str.join();
										var state=PostAjx('?ac=updateTeacherPassword&updateTeacherid='+str,null,'','');
						    			if(state){
												layer.msg("初始化成功！",{icon:1,time:1000,offset:'150px'},function(){
										   });
										}else{
												layer.msg("初始化失败！",{icon:2,time:1000,offset:'150px'},function(){
										   });
										}
									}else{
										layer.msg("必须选择一个");
									}
						      	});
			    }
			  };
  
			   $('.demoTable .layui-btn').on('click', function(){
			    var type = $(this).data('type');
			    active[type] ? active[type].call(this) : '';
			  });
		 
		 });
		 		 
			
			/*刷新*/
			function shuaxin(){
				 location.reload();
			}	
	</script>
</html>
<%
	/*插入常用菜单日志*/
	int   TagMenu=db.Row("SELECT COUNT(*) as row FROM  menu_worker  WHERE sysmenuid='"+PMenuId+"' and  workerid='"+Suid+"' and  companyid="+Scompanyid);
	if(TagMenu==0){
  		db.executeUpdate("INSERT INTO `menu_worker`(`sysmenuid`,`workerid`,`countes`,`companyid`) VALUES ('"+PMenuId+"','"+Suid+"','1','"+Scompanyid+"');"); 
	}else{
		db.executeUpdate("UPDATE  `menu_worker` SET `countes`=countes+1,`usetime`=now() WHERE  sysmenuid='"+PMenuId+"' and  workerid='"+Suid+"' and  companyid="+Scompanyid);
	}
	if(db!=null)db.close();db=null;if(server!=null)server=null;
%>