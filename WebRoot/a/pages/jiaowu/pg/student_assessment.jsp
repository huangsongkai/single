<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page trimDirectiveWhitespaces="true" %>
<%@page contentType="text/html; charset=UTF-8" language="java"%>
<%@page import="service.dao.db.Page"%>
<%@page import="v1.haocheok.commom.common"%>
<%@page import="org.apache.commons.lang3.StringUtils"%>
<%@page import="v1.haocheok.commom.entity.UserEntity"%>
<%@include file="../../cookie.jsp"%>
<%
		String semester = request.getParameter("semester");//获取学期
		if(StringUtils.isBlank(semester)){
			String semSql = "SELECT academic_year from academic_year where this_academic_tag='true' ";
			ResultSet semRs = db.executeQuery(semSql);
			while(semRs.next()){
				semester=semRs.getString("academic_year");
			}
			if(semRs!=null)semRs.close();
		}

       	//获取文件后面的对象 数据
       	String search_val = request.getParameter("val"); if(search_val==null){search_val="";}else{search_val=search_val.replaceAll("\\s*", "");}
       	search_val = new Page().mysqlCode(search_val);//防止sql注入
		search_val=search_val.replaceAll(" ","");
		//查找字段名称
		common common=new common();
		//查询的字段局部语句
 		String search="where 1=1 ";  
 		if(search_val.length()>=1){
 			search=search+"and  t1.teacher_name like '%"+search_val+"%'  ";
 		}     	
 		if(semester.length()>=1){
 			search=search+"and  t.semester='"+semester+"' ";
 		}     	
 		
       	//当前页数
       	String pag = request.getParameter("pag");  	if(pag==null){pag="1";}
       	int pages=Integer.parseInt(pag);
       	
        //当前页条数
       	String limit = request.getParameter("limit"); if(limit==null){limit="10";}
       	int limits=Integer.parseInt(limit);
		
		String zpag_sql =	"SELECT count(id) row FROM  	(SELECT t.id  FROM  	student_pingce t       "+
							  "    	LEFT JOIN teacher_basic t1 ON t.teacherid=t1.id        "+
							  "    	LEFT JOIN class_grade t2 ON t2.id =t.classid           "+search+
							  "    	GROUP BY                                               "+
							  "    		t.semester,                                        "+
							  "    		t.classid,                                         "+
							  "    		t.teacherid  ) aa                                      ";
		
		int zpag= db.Row(zpag_sql);			
       	String sql="SELECT                                                         "+
					  "    		t1.teacher_name,                                   "+
					  "    		t2.class_name,                                     "+
					  "    		t.semester,                                        "+
					  "    		SUM(t.a_score) a_score,                            "+
					  "    		SUM(t.b_score) b_score,                            "+
					  "    		SUM(t.c_score) c_score,                            "+
					  "    		SUM(t.d_score) d_score,                            "+
					  "    		SUM(t.e_score) e_score,                            "+
					  "    		SUM(t.total) total,                                "+
					  "    		count(t.id) cepingnum                              "+
					  "    	FROM                                                   "+
					  "    		student_pingce t                                   "+
					  "    	LEFT JOIN teacher_basic t1 ON t.teacherid=t1.id        "+
					  "    	LEFT JOIN class_grade t2 ON t2.id =t.classid           "+search+
					  "    	GROUP BY                                               "+
					  "    		t.semester,                                        "+
					  "    		t.classid,                                         "+
					  "    		t.teacherid                                        "+
					 "		 limit  "+(pages-1)*limits+","+limits+";";
        
       	String html_str="";  //页面代码
       	ArrayList<String> list = new ArrayList<String>();
       	
       	//开始查询
        ResultSet Rs = db.executeQuery(sql);
        while(Rs.next()){
         	html_str="<tr>"+
         	"<td > "+Rs.getString("teacher_name")+" </td>\r\n"+
         	"<td > "+Rs.getString("class_name")+" </td>\r\n"+
         	"<td > "+Rs.getString("semester")+" </td>\r\n"+
         	"<td > "+Rs.getDouble("a_score")/Rs.getInt("cepingnum")+" </td>\r\n"+
         	"<td > "+Rs.getDouble("b_score")/Rs.getInt("cepingnum")+" </td>\r\n"+
         	"<td > "+Rs.getDouble("c_score")/Rs.getInt("cepingnum")+" </td>\r\n"+
         	"<td > "+Rs.getDouble("d_score")/Rs.getInt("cepingnum")+" </td>\r\n"+
         	"<td > "+Rs.getDouble("e_score")/Rs.getInt("cepingnum")+" </td>\r\n"+
		//	"<td > "+Rs.getString("total")+" </td>\r\n"+		
			"<td > "+Rs.getString("cepingnum")+" </td>\r\n"+		
			"<td > "+Rs.getInt("total")/Rs.getInt("cepingnum")+" </td>\r\n"+		
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
		        <br><input id="search" type="text" class="layui-input textbox-text" placeholder="输入姓名进行查询" style="height: 35px; color: #272525; background: rgb(227, 227, 227);">
		       	
		       	 <select name=semester  id="semester" lay-verify="required"  lay-search>
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
		    	
		    </div>
	    	<table class="cuoz" id="table" data-toggle="table" data-show-toggle="true" data-show-columns="true" data-show-export="true"  style='margin-top:3px'>
		        <thead>
		            <tr>
		                <th data-field="教师姓名"  data-sortable="true" data-filter-control="select"  data-visible="true">教师姓名</th>
		                <th data-field="班级"  data-sortable="true" data-filter-control="select"  data-visible="true">班级</th>
		                <th data-field="学期"  data-sortable="true" data-filter-control="select"  data-visible="true">学期</th>
		                <th data-field="教学态度及能力培养"  data-sortable="true" data-filter-control="select"  data-visible="true">教学态度及能力培养</th>
		                <th data-field="教学内容"  data-sortable="true" data-filter-control="select"  data-visible="true">教学内容</th>
		                <th data-field="教学方法与手段"  data-sortable="true" data-filter-control="select"  data-visible="true">教学方法与手段</th>
		                <th data-field="教学常规"  data-sortable="true" data-filter-control="select"  data-visible="true">教学常规</th>
		                <th data-field="教学效果"  data-sortable="true" data-filter-control="select"  data-visible="true">教学效果</th>
<%--		                <th data-field="总分"  data-sortable="true" data-filter-control="select"  data-visible="true">总分</th>--%>
		                <th data-field="评测学生数"  data-sortable="true" data-filter-control="select"  data-visible="true">评测学生数</th>
		                <th data-field="总平均分"  data-sortable="true" data-filter-control="select"  data-visible="true">总平均分</th>
	              	
		            </tr>
		        </thead>
		        <tbody id="tbody">
					<%=list.toString().replaceAll("\\[","").replaceAll("\\]","").replaceAll(",","").replaceAll("@#@",",")%>
		        </tbody>
	        </table>
	        <div id="pages"  style="float: right;"></div>
	    </div>    
	    <script type="text/javascript">  
	    
	    		//搜索内容
	    		var search_val='<%=search_val%>';
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
			    layui.use(['laypage', 'layer'], function(){
				  var laypage = layui.laypage
				  ,layer = layui.layer;
						//完整功能----分页
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
									     	 window.location.href="?ac=&val="+$('#search').val()+"&pag="+curr+"&limit="+limit;
								    }
						      }
					    });
				});
			    
		        //执行
		        function ac_tion() {
				       window.location.href="?ac=&val="+$('#search').val()+"";
				}

		        function deletet(id){
					  layer.confirm("确认要删除吗，删除后不能恢复", { title: "删除确认" }, function (index) { 
					                layer.close(index);
					                window.location.href="?ac=deletet&id="+id+"";   						 
					            
					            }); 
				}
				
	    </script>
	      
      <%if(request.getParameter("index_id")!=null){//接受从首页过来的变量 直接打开某个任务%> 
	    <script>  look('<%=request.getParameter("index_id")%>','<%=request.getParameter("index_name")%>'); </script> 
	 <%} %>
	
	</body> 
</html>
<% if("deletet".equals(ac)){ 
	 String id=request.getParameter("id");
	 if(id==null){id="";}
	try{
	   String dsql="DELETE FROM student_pingce WHERE id='"+id+"';";
	   if(db.executeUpdate(dsql)==true){
		   out.println("<script>parent.layer.msg('删除测评成功');window.location.replace('./student_assessment.jsp');</script>");
	   }
	   else{
		   out.println("<script>parent.layer.msg('删除测评失败');</script>");
	   }
	 }catch (Exception e){
	    out.println("<script>parent.layer.msg('删除测评失败');</script>");
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