<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%--万能表单列表--%>
<%@page trimDirectiveWhitespaces="true" %>
<%@page contentType="text/html; charset=UTF-8" language="java"%>
<%@page import="service.dao.db.Page"%>
<%@include file="../../cookie.jsp"%>
<%
		String formid = request.getParameter("fromid"); if(formid==null){formid="";}else{formid=formid.replaceAll("\\s*", "").replaceAll(" ", "");}
		
       	String sql="SELECT froms.COLUMN_NAME,froms.DATA_TYPE ,froms.column_comment,form_template_confg.tid FROM form_name  LEFT JOIN form_template_confg ON form_name.id=form_template_confg.fid LEFT JOIN INFORMATION_SCHEMA.Columns froms ON froms.COLUMN_NAME=form_template_confg.strname   WHERE  froms.table_name=form_name.datafrom  AND form_name.id='"+formid+"';";
        
       	String html_str="";  //页面代码
       	ArrayList<String> list = new ArrayList<String>();
       	
       	//开始查询
        ResultSet customerPrs = db.executeQuery(sql);
        while(customerPrs.next()){
         	
         	html_str="<tr>"+
						"<td >"+customerPrs.getString("froms.COLUMN_NAME") +"</td>"+//字段名称
						"<td >"+customerPrs.getString("froms.DATA_TYPE") +"</td>"+  //字段数据类型
						"<td >"+customerPrs.getString("froms.column_comment")+"</td>"+//字段备注
						"<td >"+
							"<div class=\"layui-btn-group\">"+
						    	"<button class=\"layui-btn\" onclick=\"edit('"+customerPrs.getString("form_template_confg.tid")+"')\">查看详细信息</button>"+
						 	"</div>"+
						"</td>"+
				      "</tr>";
		   list.add(html_str);
       }
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head> 
	    <meta charset="utf-8"> 
	    <meta name="viewport" content="width=device-width, initial-scale=1"> 
	    
	    <link rel="stylesheet" href="../../../pages/css/sy_style.css?22">	    
	    <link rel="stylesheet" href="../../js/layui/css/layui.css">
		<script type="text/javascript" src="../../js/jquery-1.9.1.js" ></script><!--通用jquery-->
		<script src="../../js/layui/layui.js"></script>
		<script type="text/javascript" src="../../js/tableExport/js/table-sort.js" ></script><!--表格排序js  css-->
	 
	    <title>编辑万能表单</title> 
	    <style type="text/css">
			th { background-color: white; }
		    td {  background-color: white; }
		    .btn-group-vertical>.btn, .btn-group>.btn{height:33px;}
		</style>
 	</head> 
	<body>
	    <div class="" style="padding-bottom: 0px;margin-left: 1%;margin-right: 1%; height:auto;">  
			<div id="tb" class="form_top layui-form" style="display: flex;">
		        <button class="layui-btn layui-btn-small  layui-btn-primary " onclick="newup_user()"  style="height: 35px;  color: white; background: rgb(25, 160, 148);">增加字段</button>
		    </div>
	    	<table class="cuoz" id="table" data-toggle="table" data-show-toggle="true" data-show-columns="true" data-show-export="true" >
		        <thead>
		            <tr>
		              	<th data-field="字段名称"  data-sortable="true" data-filter-control="select"  data-visible="true">表单名称[中]</th>
		              	<th data-field="字段数据类型"  data-sortable="true" data-filter-control="select"  data-visible="true">表单名称[中]</th>
		              	<th data-field="字段备注"  data-sortable="true" data-filter-control="select"  data-visible="true">分配角色</th>
		              	<th data-field="操作"     data-sortable="true" data-filter-control="select"  data-visible="true">操作</th>
		            </tr>
		        </thead>
		        <tbody id="tbody">
					<%=list.toString().replaceAll("\\[","").replaceAll("\\]","").replaceAll(",","")%>
		        </tbody>
	        </table>
	        <div id="pages"  style="float: right;"></div>
	    </div>    
	    <script type="text/javascript">  
	    
	    		
		     layui.use(['laypage', 'layer'], function(){
		     
		         
		     });  
		     	function newup_user(){
					layer.open({
					  type: 2,
					  title: '新增字段',
					  offset: 't',//靠上打开
					  shadeClose: true,
					  maxmin:1,
					  shade: 0.5,
					  area: ['100%', '100%'],
					  content: 'form_new_field.jsp' 
					}); 
			     }
			        
		        function edit(fieldid) {//编辑 
					 layer.open({
						  type: 2,
						  title: '修改字段',
						  offset: 't',//靠上打开
						  shadeClose: true,
						  maxmin:1,
						  shade: 0.5,
						  area: ['100%', '100%'],
						  content: 'form_edit_field.jsp?fieldid='+fieldid
					});
				 }
			
	    </script>  
	    
	    <script>
	</script>
	</body> 
</html>
<%if(db!=null)db.close();db=null;if(server!=null)server=null;%>