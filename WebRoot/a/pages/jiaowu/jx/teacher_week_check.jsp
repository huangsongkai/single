<%@page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page trimDirectiveWhitespaces="true" %>
<%@page contentType="text/html; charset=UTF-8" language="java"%>
<%@page import="service.dao.db.Page"%>
<%@page import="v1.haocheok.commom.common"%>
<%@page import="v1.haocheok.commom.entity.UserEntity"%>
<%@page import="org.apache.commons.lang3.StringUtils"%>
<%@include file="../../cookie.jsp"%>
<%
		String semester ="";
		String semSql = "SELECT academic_year from academic_year where this_academic_tag='true' ";
		ResultSet semRs = db.executeQuery(semSql);
		while(semRs.next()){
			semester=semRs.getString("academic_year");
		}
		if(semRs!=null)semRs.close();
	%>
<%
       	//获取文件后面的对象 数据
       	String search_val = request.getParameter("val"); if(search_val==null){search_val="";}else{search_val=search_val.replaceAll("\\s*", "");}
       	search_val = new Page().mysqlCode(search_val);//防止sql注入
		search_val=search_val.replaceAll(" ","");
		
       	String state = request.getParameter("state"); 
       	if(StringUtils.isBlank(state)){state="0";}
		//查找字段名称
		common common=new common();
		if(!Suserole.equals("1")||StringUtils.isBlank(Sassociationid)){
			Sassociationid ="0";
		}
	//	String idsSql = "SELECT id from teacher_basic where faculty in ( SELECT t.faculty from teacher_basic t where t.id= "+Sassociationid+")";
 		String search="where 1=1 and teacherid in (SELECT id from teacher_basic where teachering_office in ( SELECT t.teachering_office from teacher_basic t where t.id= "+Sassociationid+") 	or teaching_staff_office in (SELECT t.teaching_staff_office from teacher_basic t where id = "+Sassociationid+" ) ) and t1.semester='"+semester+"' and t.state!=1" ;  
 		if(search_val.length()>=1){
 			search= search + " and t5.teacher_name like '%"+search_val+"%' ";
 		} 
 		//if(StringUtils.isNotBlank(dict_departments_id)&&!dict_departments_id.equals("0")){
 			//search=search +" and t.faculty="+dict_departments_id;
 		//}
 		if(StringUtils.isNotBlank(state)&&!state.equals("0")){
 				search=search +" and t.state="+state;
 		}
       	/**
       	 *分页相关
       	 */
       	//当前页数
       	String pag = request.getParameter("pag");  	if(pag==null){pag="1";}
       	int pages=Integer.parseInt(pag);
       	
        //当前页条数
       	String limit = request.getParameter("limit"); if(limit==null){limit="10";}
       	int limits=Integer.parseInt(limit);
       	
      	//计算出总页数
	//	String zpag_sql="select count(1) as row from teacher_week "+search+";";
		String zpag_sql = "SELECT  count(t.id) row                                                                 "+
		"	 		FROM                                                      "+
		"	 			teacher_week t                                        "+
		"	 		LEFT JOIN teaching_task t1 ON t.teaching_task_id = t1.id  "+
		"	 		LEFT JOIN class_grade t3 ON t1.class_id = t3.id           "+
		"	 		LEFT JOIN dict_courses t4 ON t1.course_id = t4.id         "+
		"	 		LEFT JOIN teacher_basic t5 ON t.teacherid = t5.id         "+
					search;
		int zpag= db.Row(zpag_sql);			
		 
		//SQL语句
		String sql = "SELECT  t.id,   t.teaching_task_id,                                                                  "+
												"	 			t.week,                                               "+
												"	 			t.teaching_time,                                      "+
												"	 			t.teacherid,  t5.teacher_name,                                        "+
												"	 			t3.people_number_nan,                                 "+
												"	 			t3.people_number_woman,                               "+
												"	 			t3.class_name,                                        "+
												"	 			t4.course_name, t.state, t5.teachering_office, t6.departments_id,                                     "+
												"	 			t.remark,t.add_time                                        "+
												"	 		FROM                                                      "+
												"	 			teacher_week t                                        "+
												"	 		LEFT JOIN teaching_task t1 ON t.teaching_task_id = t1.id  "+
												"	 		LEFT JOIN class_grade t3 ON t1.class_id = t3.id           "+
												"	 		LEFT JOIN dict_courses t4 ON t1.course_id = t4.id         "+
												"	 		LEFT JOIN teacher_basic t5 ON t.teacherid = t5.id         "+
												"	 		LEFT JOIN teaching_research t6 ON t5.teachering_office=t6.id          "+
													search+" order by t.id desc  limit " +(pages-1)*limits+","+limits+";";
       	//String sql="select * from teacher_week t  "+search+" order by id asc limit  "+(pages-1)*limits+","+limits+";";

       	System.out.println("sql "+sql);
       	String html_str="";  //页面代码
       	ArrayList<String> list = new ArrayList<String>();
       	
       	//开始查询
        StringBuffer sb = new StringBuffer();
        ResultSet Rs = db.executeQuery(sql);
        String teachering_office ="";
        String departments_id="";
        while(Rs.next()){
        	int boyNum =0;
			int girlNum =0;
			if(StringUtils.isNotBlank(Rs.getString("people_number_nan"))){
				boyNum =Integer.parseInt(Rs.getString("people_number_nan"));
			}
			if(StringUtils.isNotBlank(Rs.getString("people_number_woman"))){
				girlNum =Integer.parseInt(Rs.getString("people_number_woman"));
			}
			if(StringUtils.isNotBlank(Rs.getString("teachering_office"))){
				teachering_office =Rs.getString("teachering_office");
			}
			if(StringUtils.isNotBlank(Rs.getString("departments_id"))){
				departments_id =Rs.getString("departments_id");
			}
			String marks = Rs.getString("remark");
			if(StringUtils.isBlank(Rs.getString("remark"))){
				marks ="";
			}
			String add_time = Rs.getString("add_time");
			if(StringUtils.isBlank(Rs.getString("add_time"))){
				add_time ="";
			}
			String stateName = "";
			String buttHtml  ="";
			if(Rs.getString("state").equals("1")){
				stateName ="未送审";
			}else if(Rs.getString("state").equals("2")){
				stateName ="已送审";
				buttHtml ="<a onclick='pass("+Rs.getString("id")+")'>通过</a><a onclick='reject("+Rs.getString("id")+")'>拒绝</a>";
			}else if(Rs.getString("state").equals("3")){
				stateName ="已签字";
				buttHtml ="";
			}else  if(Rs.getString("state").equals("4")){
				stateName ="已拒绝";
			}
 			
 			html_str="<tr  id='"+Rs.getString("id")+"'>\r\n"
					+"<td class=\"\">"+Rs.getString("teacher_name") +"</td>          "
					+"<td class=\"\">"+Rs.getString("week") +"</td>          "
					+"<td class=\"\">"+Rs.getString("course_name")+"</td>         "
					+"<td class=\"\">"+Rs.getString("class_name")+"</td>         "
					+"<td class=\"\">"+Rs.getString("teaching_time")+"</td>         "
					+"<td class=\"\">"+(boyNum+girlNum)+"</td>         "
					+"<td class=\"\">"+marks+"</td>         "
					+"<td class=\"\">"+stateName+"</td>         "
					+"<td class=\"\">"+add_time+"</td>         "
					//+"<td class=\"\"> <a onclick='editWeeks("+Rs.getString("id")+")'>修改</a><a onclick='sendCheck("+Rs.getString("id")+")'>送审</a>"+"</td> "
					+"<td class=\"\"> "+buttHtml+"</td> "
			+"</tr>"; 
 			sb.append(html_str);
       }if(Rs!=null){Rs.close();}
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
		<script type="text/javascript" src="../../js/tableExport/js/table-sort.js" ></script><!--表格排序js  css-->
		<script type="text/javascript" chartset="utf8" src="../../js/tableExport/js/table_list.js " ></script><!--表格导出js  css-->
	 <script type="text/javascript" src="../../js/jquery.form.js" ></script>
	 <script type="text/javascript" src="../../js/ajaxs.js" ></script>
	    <title><%=Mokuai %></title> 
	  <style type="text/css"> 
	    th { background-color: white; }
	    .btn-group-vertical>.btn, .btn-group>.btn{height:33px;}
        table tr:hover{background:#eeeeee;color:#19A094;}
     </style>
 	</head> 
	<body>
	    <div class="" style="padding-bottom: 0px;margin-left: 1%;margin-right: 1%; height:auto;">  
			<div id="tb" class="form_top layui-form" style="display: flex;">
		        <br><input id="search" type="text" class="layui-input textbox-text" placeholder="输入名字" style="height: 35px; color: #272525; ">
<%--		        <div class="layui-input-inline">--%>
<%--		            <select name="dict_departments_id"  id="dict_departments_id" lay-search  lay-filter="department">--%>
<%--		              <option value="0">全部院系</option>--%>
<%--		            <%--%>
<%--		            //查询院系--%>
<%--		            String selectDsql="SELECT id,departments_name from dict_departments ;";--%>
<%--		            ResultSet yxRs = db.executeQuery(selectDsql);--%>
<%--		            while(yxRs.next()){--%>
<%--		            %>--%>
<%--		              <option value="<%=yxRs.getString("id") %>"  ><%=yxRs.getString("departments_name") %></option>--%>
<%--		             <%}if(yxRs!=null){yxRs.close();} %>--%>
<%--		            </select>--%>
<%--		        </div>--%>
		        <div class="layui-input-inline">
		            <select name="state"  id="state" lay-search  >
		              <option value="0">全部</option>
		              <option value="2">已送审</option>
		              <option value="3">已签字</option>
		              <option value="4">已拒绝</option>
		            </select>
		        </div>
		        <button class="layui-btn layui-btn-small  layui-btn-primary" onclick="ac_tion('')"  style="height: 35px;  color: white; background: rgb(25, 160, 148);"> <i class="layui-icon" style="color: #FFF;">&#xe615;</i> 搜索</button>
		    	<button class="layui-btn layui-btn-small  layui-btn-primary" onclick="Refresh();ac_tion('')"  style="height: 35px;  color: white; background: rgb(25, 160, 148);"> <i class="layui-icon" style="color: #FFF;">&#x1002;</i> 刷新</button>
		    <div class="daochu_div layui-form">
		    	<label class="layui-form-label" style="float:left;"><font color='#19a094'></font></label>
		    	<button class="layui-btn" onclick="daochu()" >导出部门课时统计</button>
		    </div>
		    <div class="daochu_div layui-form">
		    	<label class="layui-form-label" style="float:left;"><font color='#19a094'></font></label>
		    	<button class="layui-btn" onclick="daochuquan()" >导出全院课时统计</button>
		    </div>
		    </div>
		    <input type="hidden"  id="teachering_office"  value="<%=teachering_office %>">
		    <input type="hidden"  id="departments_id"  value="<%=departments_id %>">
	    	<table class="cuoz" id="table" data-toggle="table" data-show-toggle="true" data-show-columns="true" data-show-export="true" >
		        <thead>
		           <tr>
              <th data-field="教师"     data-sortable="true" data-filter-control="select" data-visible="true" >教师</th>
              <th data-field="周次"     data-sortable="true" data-filter-control="select" data-visible="true" >周次</th>
              <th data-field="课程"     data-sortable="true" data-filter-control="select" data-visible="true" >课程</th>
              <th data-field="班级"     data-sortable="true" data-filter-control="select" data-visible="true" >班级</th>
              <th data-field="周学时"     data-sortable="true" data-filter-control="select" data-visible="true" >周学时</th>
              <th data-field="人数"     data-sortable="true" data-filter-control="select" data-visible="true" >人数</th>
              <th data-field="备注"     data-sortable="true" data-filter-control="select" data-visible="true" >备注</th>
              <th data-field="状态"     data-sortable="true" data-filter-control="select" data-visible="true" >状态</th>
              <th data-field="签字/拒绝时间"     data-sortable="true" data-filter-control="select" data-visible="true" >签字/拒绝时间</th>
              <th data-field="操作" data-sortable="true" data-filter-control="select" data-visible="true" >操作</th>
            </tr>
		        </thead>
		        <tbody id="tbody">
					<%=sb.toString()%>
		        </tbody>
	        </table>
	        <div id="pages"  style="float: right;"></div>
	    </div>    
	    <script type="text/javascript">  
	    
	    		//搜索内容
	    		var search_val='<%=search_val%>';
	    		var state='<%=state%>';
	    		
	    		if(search_val.length>=1){
	    			modify('search',search_val);
	    		}
	    		if(state>=1){
	    			modify('state',state);
	    		}
	    		//改变某个id的值
	    		function modify (id,search_val){
	    			$("#"+id+"").val(""+search_val+"")
	    		} 
	    		 //清空 搜索输入框
	    		function Refresh(){
	    			$("#search").val("");
	    		} 
	    		
	    		//清空某个id 的标签内容//$("#"+id+"").empty();
		         
			    layui.use(['form', 'layedit', 'laydate','laypage'], function(){
				  var laypage = layui.laypage,
				  form = layui.form
				  ,layer = layui.layer;
					    laypage.render({
						      elem: 'pages'
						      ,count: <%=zpag%>//总页数
						      ,curr:  <%=pages%>//当前页数
						      ,limit:  <%=limits%>//当前页条数 
						      ,layout: ['count', 'prev', 'page', 'next','limit','skip']
						      ,jump: function(obj){
						    	  var curr = obj.curr;//当前页数
						    	  var limit = obj.limit;//每页条数 
								    if(curr!=<%=pages%> || limit!=<%=limits%>){//防止死循环 
								    	var state = $("#state").val();
								    	var searchval = $('#search').val();
									       window.location.href="?ac=&val="+searchval+"&state="+state+"&pag="+curr+"&limit="+limit;
								    }
						      }
					    });
						 form.on('select(department)',function(data){
								if(data.value!="0"){
									var obj_str1 = {"departments_id":data.value};
									var obj1 = JSON.stringify(obj_str1)
									var ret_str1=PostAjx('../../../../Api/v1/?p=web/info/teachingResearch',obj1,'<%=Suid%>','<%=Spc_token%>');
									obj1 = JSON.parse(ret_str1);
									$("#teaching_staff_office").html(obj1.data);
									form.render('select');
								}
							})
					    form.render();
				});

			  //导出报表
				function daochu(){
					var teachering_office = $("#teachering_office").val();
					if(teachering_office==undefined||teachering_office==''){
							layer.msg("当前登录用户无教研室");
						}else{
						window.location.href="excel_vistier.jsp?teachering_office="+teachering_office;
							}
				}
				function daochuquan(){
					var departments_id = $("#departments_id").val();
					if(departments_id==undefined||departments_id==''){
							layer.msg("当前登录用户无院系");
						}else{
						window.location.href="excel_vistierquan.jsp?departments_id="+departments_id;
							}
				}
			    
				$("#batchUserWorker").click(function(){
					var ids ="";
					$('tbody').find('.selected').each(function(){
						ids = ids + $(this).attr("id") +",";
					})
					if(ids==''){
						layer.msg('请至少选择一行');
						return false;
					}
					ids = ids.substring(0,ids.length-1);
					var str = {"ids":ids};
					var obj = JSON.stringify(str);
					var ret_str=PostAjx('../../../../Api/v1/?p=web/do/TerinUserWorker',obj,'<%=Suid%>','<%=Spc_token%>');
					var obj = JSON.parse(ret_str);
					if(obj.success && obj.resultCode=="1000"){
							layer.confirm(obj.msg);
					}else{
						layer.confirm(obj.msg);
					}
			});
				
			    
		        //执行
		        function ac_tion() {
			    	var state = $("#state").val();
			    	var searchval = $('#search').val();
				       window.location.href="?ac=&val="+searchval+"&state="+state;
				}

	        function pass(id){
	         	layer.confirm("确认要通过吗", { title: "通过确认" }, function (index) { 
	                 layer.close(index);
	                 window.location.href="?ac=pass&id="+id+"";   						 
	             }); 
	    	    }

	         function reject(id){
	        		layer.confirm("确认要拒绝吗", { title: "拒绝确认" }, function (index) { 
	                 layer.close(index);
	                 window.location.href="?ac=reject&id="+id;   						 
	             }); 
	    	    }       
			
	    </script>
	</body> 
</html>
<% 
if("pass".equals(ac)){ 
	 String id=request.getParameter("id");
	 if(id==null){return;}
	try{
		String upSql =" update teacher_week set state=3,add_time=now() where id="+id;
	   if(db.executeUpdate(upSql)==true){
		   out.println("<script>parent.layer.msg('通过成功');window.location.replace('./teacher_week_check.jsp');</script>");
	   }
	   else{
		   out.println("<script>parent.layer.msg('通过失败');</script>");
	   }
	 }catch (Exception e){
	    out.println("<script>parent.layer.msg('通过失败');</script>");
	    return;
	 }
	//关闭数据与serlvet.out
	if (page != null) {page = null;}
}%>
<% 
if("reject".equals(ac)){ 
	 String id=request.getParameter("id");
	 if(id==null){return;}
	try{
		String upSql =" update teacher_week set state=4,add_time=now() where id="+id;
	   if(db.executeUpdate(upSql)==true){
		   out.println("<script>parent.layer.msg('拒绝成功');window.location.replace('./teacher_week_check.jsp');</script>");
	   }
	   else{
		   out.println("<script>parent.layer.msg('拒绝失败');</script>");
	   }
	 }catch (Exception e){
	    out.println("<script>parent.layer.msg('拒绝失败');</script>");
	    return;
	 }
	//关闭数据与serlvet.out
	if (page != null) {page = null;}
}%>
<%
long TimeEnd = Calendar.getInstance().getTimeInMillis();
System.out.println(Mokuai+"耗时:"+(TimeEnd - TimeStart) + "ms");
//插入常用菜单日志
int   TagMenu=db.Row("SELECT COUNT(*) as row FROM  menu_worker  WHERE sysmenuid='"+PMenuId+"' and  workerid='"+Suid+"'");
if(TagMenu==0){
     db.executeUpdate("INSERT INTO `menu_worker`(`sysmenuid`,`workerid`,`countes`) VALUES ('"+PMenuId+"','"+Suid+"','1');"); 
   }else{
  db.executeUpdate("UPDATE  `menu_worker` SET `countes`=countes+1,`usetime`=now() WHERE  sysmenuid='"+PMenuId+"' and  workerid='"+Suid+"'");
}
 %>
<%if(db!=null)db.close();db=null;if(server!=null)server=null;%>
