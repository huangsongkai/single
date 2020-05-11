<%@page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page trimDirectiveWhitespaces="true" %>
<%@page contentType="text/html; charset=UTF-8" language="java"%>
<%@page import="service.dao.db.Page"%>
<%@page import="v1.haocheok.commom.common"%>
<%@page import="v1.haocheok.commom.commonCourse"%>
<%@page import="v1.haocheok.commom.entity.UserEntity"%>
<%@page import="org.apache.commons.lang3.StringUtils"%>
<%@include file="../../cookie.jsp"%>
<%
       	//获取文件后面的对象 数据
       	String semester = request.getParameter("semester");//获取学期
       	if(StringUtils.isBlank(semester)){
    		String semSql = "SELECT academic_year from academic_year where this_academic_tag='true' ";
    		ResultSet semRs = db.executeQuery(semSql);
    		while(semRs.next()){
    			semester=semRs.getString("academic_year");
    		}
    		if(semRs!=null)semRs.close();
    	}
    	semester = semester.replaceAll("\"","");
		common common=new common();
 		String search="where t.semester='"+semester+"' ";
       	String pag = request.getParameter("pag");  	if(pag==null){pag="1";}
       	int pages=Integer.parseInt(pag);
       	String limit = request.getParameter("limit"); if(limit==null){limit="10";}
       	int limits=Integer.parseInt(limit);
		String zpag_sql="select count(1) as row from teaching_plan_teacher t "+search+";";
		int zpag= db.Row(zpag_sql);			
		 
       	String sql ="SELECT  DISTINCT(t.teaching_task_id) task_id,                                                                              "+
					"       		t3.course_name,                                                           "+
					"       		t2.class_name,                                                            "+
					"       		t5.teacher_name,                                                          "+
					"       		t1.week_learn_time,                                                     "+
					"       		t1.experiment,                                               "+
					"       		t1.class_begins_weeks,                                                        "+
					"       		t.id                                                                     "+
					"       	FROM                                                                          "+
					"       		teaching_plan_teacher t                                                   "+
					"       	LEFT JOIN teaching_task t1 ON t.teaching_task_id = t1.id                      "+
					"			LEFT JOIN teaching_task_teacher ON t1.id = teaching_task_teacher.teaching_task_id"+
					"       	LEFT JOIN class_grade t2 ON t2.id=t1.class_id                                 "+
					"       	LEFT JOIN dict_courses t3 ON t1.course_id=t3.id                               "+
					"       	LEFT JOIN teacher_basic t5 ON t5.id=teaching_task_teacher.teacherid                             "+
					"       	"+search+" GROUP BY t.teaching_task_id  order by t.id asc limit  "+(pages-1)*limits+","+limits+";";

       	System.out.println("sql "+sql);
       	String html_str="";  //页面代码
       	ArrayList<String> list = new ArrayList<String>();
       	
       	//开始查询
       
        ResultSet Rs = db.executeQuery(sql);
        while(Rs.next()){
         	
         	html_str="<tr>\r\n"+
			"<td >"+Rs.getString("course_name")+"</td>\r\n"+
			"<td >"+Rs.getString("class_name")+"</td>\r\n"+
			"<td >"+Rs.getString("teacher_name")+"</td>\r\n"+
			"<td >"+Rs.getString("week_learn_time")+"</td>\r\n"+
			"<td >"+Rs.getString("experiment")+"</td>\r\n"+
			"<td >"+Rs.getString("class_begins_weeks")+"</td>\r\n"+
				"<td >"+
				    "<div class=\"layui-btn-group\">"+
			             "<button class=\"layui-btn\" onclick=\"edit('"+Rs.getString("task_id")+"')\">明细</button>"+
			 	"</div>"+
				"</td>\r\n"+
		      "</tr>\r\n\r\n";
		   list.add(html_str);
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
				  <select name=semester  id="semester" lay-verify="required" lay-filter="semester" lay-search>
	            	<option value="0" selected></option>
	            	<%
	            		String semesterSql =  "SELECT t.academic_year FROM academic_year t order by t.academic_year desc ";
	            		ResultSet semesterRs = db.executeQuery(semesterSql);
	            		while(semesterRs.next()){
	            				if(semester.equals(semesterRs.getString("academic_year"))){
	            					%>
	            				<option value="<%=semesterRs.getString("academic_year") %>"  selected><%=semesterRs.getString("academic_year") %></option>
	            					<%}else{%>
	            				<option value="<%=semesterRs.getString("academic_year") %>" ><%=semesterRs.getString("academic_year") %></option>
	            			<%}}%>
	            </select>
		        <button class="layui-btn layui-btn-small  layui-btn-primary" onclick="ac_tion('')"  style="height: 35px;  color: white; background: rgb(25, 160, 148);"> <i class="layui-icon" style="color: #FFF;">&#xe615;</i> 搜索</button>
		    	<button class="layui-btn layui-btn-small  layui-btn-primary" onclick="Refresh();ac_tion('')"  style="height: 35px;  color: white; background: rgb(25, 160, 148);"> <i class="layui-icon" style="color: #FFF;">&#x1002;</i> 刷新</button>
<%--		    	 <button class="layui-btn layui-btn-small  layui-btn-primary" onclick="newup_class()"  style="height: 35px;  color: white; background: rgb(25, 160, 148);"> <i class="layui-icon" style="color: #FFF;">&#xe61f;</i> 增加</button>--%>
		    </div>
		   <div id="asc" class="form_top layui-form" style="display: flex;    float: right;">
		        <div class="layui-inline">
					    <label class="layui-form-label" style="color: #19a094;font-size: 20px; margin-top: 4px;">导出:</label>
					    <div class="layui-input-inline" style="margin-top: 4px;">
					      <select name="gender" lay-verify="required"  lay-filter="Export">
					        <option value="请选择格式" selected="">请选择格式</option>
					         <%
					        	String Export_sql = "select name,value from export";
					        	ResultSet base = db.executeQuery(Export_sql);
					        	while(base.next()){
					         %>
					         	<option value="<%=base.getString("value") %>" > <%=base.getString("name") %> </option>
					         <%}if(base!=null){base.close();}%>
					      </select>
					    </div>
				</div>
		    </div>
	    	<table class="cuoz" id="table" data-toggle="table" data-show-toggle="true" data-show-columns="true" data-show-export="true" >
		        <thead>
		            <tr>
		                <th data-field="课程名称"  data-sortable="true" data-filter-control="select"  data-visible="true">课程名称</th>
		                <th data-field="专业班级"  data-sortable="true" data-filter-control="select"  data-visible="true">专业班级</th>
		                <th data-field="授课教师"  data-sortable="true" data-filter-control="select"  data-visible="true">授课教师</th>
	              	    <th data-field="讲科学时"  data-sortable="true" data-filter-control="select"  data-visible="true">讲科学时</th>
	              	    <th data-field="实验学时"  data-sortable="true" data-filter-control="select"  data-visible="true">实验学时</th>
	              	    <th data-field="授课周数"  data-sortable="true" data-filter-control="select"  data-visible="true">授课周数</th>
		                <th data-field="操作"     data-sortable="true" data-filter-control="select"  data-visible="true">操作</th>
		            </tr>
		        </thead>
		        <tbody id="tbody">
					<%=list.toString().replaceAll("\\[","").replaceAll("\\]","").replaceAll("@#@",",")%>
		        </tbody>
	        </table>
	        <div id="pages"  style="float: right;"></div>
	    </div>    
	    <script type="text/javascript">  
	    
	    		//搜索内容
	    		var search_val='<%=semester%>';
	    		search_val=search_val.replace(/(^\s*)|(\s*$)/g, "");//处理空格
	    		
	    		if(search_val.length>=1){
	    			modify('search',search_val);
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
		         
			    layui.use(['laypage', 'layer','form'], function(){
				  var laypage = layui.laypage
				  ,layer = layui.layer
				  ,form = layui.form;
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
									     	 window.location.href="?ac=&semester="+$('#semester').val()+"&pag="+curr+"&limit="+limit;
								    }
						      }
					    });
					 	form.on('select(semester)', function(data){
						    var semesterval = JSON.stringify(data.value);
						    if(semesterval=='0'){
								return false;
							    }else{
								    window.location.href="teacher_teach_plan.jsp?ac=&semester="+semesterval
									return true;
								    }
						});
				});
   
		        //执行
		        function ac_tion() {
				       window.location.href="?ac=&val="+$('#search').val()+"";
				}

		        function newup_class(){
			        var semester = $('#semester').val();
			        if(semester=='0'||semester==''){
						layer.msg("请选择学期");
						return false;
				        }
			    	 layer.open({
			    		 type: 2,
			    		  title: '新建教师授课计划',
			    		  maxmin:1,
			    		  shade: 0.5,
			    		  area: ['100%', '100%'],
			    		  content: 'new_teacher_teach_plan.jsp?semester='+ semester
			    		});
			     }
			     
		        function edit(taskid){
		        	  var semester = $('#semester').val();
				        if(semester=='0'||semester==''){
							layer.msg("请选择学期");
							return false;
					        }
		           layer.open({
		     		 type: 2,
		     		  title: '教师授课计划',
		     		  maxmin:1,
		     		  shade: 0.5,
		     		  area: ['100%', '100%'],
		     		  content: 'edit_teacher_teach_plan.jsp?taskid='+taskid+"&semester="+semester 
		     		});
		         }
		         
		        function del(taskid){
		        	  var semester = $('#semester').val();
				        if(semester=='0'||semester==''){
							layer.msg("请选择学期");
							return false;
					        }
				        layer.confirm("确认删除吗",function(){
				 		       window.location.href="?ac=delete&taskid="+taskid+"&semester="+semester
					        });
		         }
	    </script>
	</body> 
</html>
<%
		if("delete".equals(ac)){
			String teaching_task_id = request.getParameter("taskid");
			 semester = request.getParameter("semester");
			boolean upstate = true;
			String delsql = "DELETE from teaching_plan_teacher where  teaching_task_id="+teaching_task_id +" and semester='"+semester+"'";
			upstate = db.executeUpdate(delsql);
			if(upstate){
				   out.println("<script>parent.layer.msg('删除教师授课计划成功', {icon:1,time:1000,offset:'150px'},function(){}); </script>");
			   }else{	
				   out.println("<script>parent.layer.msg('删除教师授课计划 失败');</script>");
			   }
		}
%>
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
