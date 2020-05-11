<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%--万能表单列表--%>
<%@page trimDirectiveWhitespaces="true" %>
<%@page contentType="text/html; charset=UTF-8" language="java"%>
<%@page import="service.dao.db.Page"%>
<%@include file="../../cookie.jsp"%>
<%
       	
       	//获取文件后面的对象 数据
       	String search_val = request.getParameter("val"); if(search_val==null){search_val="";}else{search_val=search_val.replaceAll("\\s*", "").replaceAll(" ", "");}
       	search_val = new Page().mysqlCode(search_val);//防止sql注入
		search_val=search_val.toUpperCase();
		search_val=search_val.replaceAll(" ","");
		//查询的字段局部语句
 		String search="";
 		if(search_val.length()>=1){
 			search="where form_name.formname like '%"+search_val+"%'";
 		}
 		//计算出总页数
		String zpag_sql="select count(1) as row from form_name "+search+";";
		int zpag= db.Row(zpag_sql);						
		zpag=(zpag+10-1)/10;
		
		//获取页数数
       	String pag = request.getParameter("pag"); if(pag==null){pag="1";}
       	int pages=Integer.parseInt(pag);
		        	
       	String sql="SELECT form_name.id as id,form_name.formname,form_name.datafrom,IFNULL((SELECT NAME FROM zk_role WHERE id=role_from.roleid),'未分配')formRole,form_name.createtime FROM form_name  LEFT JOIN role_from ON role_from.fromid=form_name.id AND role_from.code=1  "+search+" limit  "+(pages-1)*10+",10;";
        
       	String html_str="";  //页面代码
       	ArrayList<String> list = new ArrayList<String>();
       	
       	//开始查询
        ResultSet customerPrs = db.executeQuery(sql);
        while(customerPrs.next()){
         	
         	html_str="<tr>"+
						"<td >"+customerPrs.getString("form_name.formname") +"</td>"+//表单名称[中]
						"<td >"+customerPrs.getString("form_name.datafrom") +"</td>"+//表单名称[英]
						"<td >"+customerPrs.getString("formRole")+"</td>"+//分配角色
						"<td >"+customerPrs.getString("form_name.createtime") +"</td>"+//创建时间
						"<td >"+
							"<div class=\"layui-btn-group\">"+
						    	"<button class=\"layui-btn\" onclick=\"edit('"+customerPrs.getString("id")+"')\">编辑</button>"+
						 	"</div>"+
						"</td>"+
				      "</tr>";
		   list.add(html_str);
       }
%>
<html>
	<head> 
	    <meta charset="utf-8"> 
	    <meta name="viewport" content="width=device-width, initial-scale=1"> 
	    
	    <link rel="stylesheet" href="../../../pages/css/sy_style.css?22">	    
	    <link rel="stylesheet" href="../../js/layui/css/layui.css">
		<script type="text/javascript" src="../../js/jquery-1.9.1.js" ></script><!--通用jquery-->
		<script src="../../js/layui/layui.js"></script>
		<script type="text/javascript" src="../../js/tableExport/js/table-sort.js" ></script><!--表格排序js  css-->
		<script type="text/javascript" chartset="utf8" src="../../js/tableExport/js/table_list.js " ></script><!--表格导出js  css-->
	 
	    <title>万能表单列表</title> 
	    <style type="text/css">
			th { background-color: white; }
		    td {  background-color: white; }
		    .btn-group-vertical>.btn, .btn-group>.btn{height:33px;}
		</style>
 	</head> 
	<body>
	    <div class="" style="padding-bottom: 0px;margin-left: 1%;margin-right: 1%; height:auto;">  
			<div id="tb" class="form_top layui-form" style="display: flex;">
		        <input id="search" type="text" class="layui-input textbox-text" placeholder="输入表单名称进行查询" style="height: 35px; color: #272525; background: rgb(227, 227, 227);">
		        <button class="layui-btn layui-btn-small  layui-btn-primary" onclick="ac_tion('')"  style="height: 35px;  color: white; background: rgb(25, 160, 148);"> <i class="layui-icon"> </i> 搜索</button>
		    	<button class="layui-btn layui-btn-small  layui-btn-primary" onclick="Refresh();ac_tion('');"  style="height: 35px;  color: white; background: rgb(25, 160, 148);"> <i class="layui-icon">ဂ</i> 刷新</button>
		        <button class="layui-btn layui-btn-small  layui-btn-primary " onclick="newup_user()"  style="height: 35px;  color: white; background: rgb(25, 160, 148);">新建表单</button>
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
					         <%}%>
					      </select>
					    </div>
				</div>
		    </div>
	    	<table class="cuoz" id="table" data-toggle="table" data-show-toggle="true" data-show-columns="true" data-show-export="true" >
		        <thead>
		            <tr>
		              	<th data-field="表单名称[中]"  data-sortable="true" data-filter-control="select"  data-visible="true">表单名称[中]</th>
		              	<th data-field="表单名称[英]"  data-sortable="true" data-filter-control="select"  data-visible="true">表单名称[中]</th>
		              	<th data-field="分配角色"  data-sortable="true" data-filter-control="select"  data-visible="true">分配角色</th>
		               	<th data-field="创建时间"  data-sortable="true" data-filter-control="select"  data-visible="false">创建时间</th>
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
						laypage({
						    cont: 'pages'
						    ,pages: <%=zpag%>  //总页数
						    ,curr:  <%=pages%>     //当前页数 
						    ,skip: true
						    ,jump: function(obj, first){
								    //得到了当前页，用于向服务端请求对应数据
								     var curr = obj.curr;
								     if(curr!=<%=pages%>){//防止死循环 
								     	window.location.href="?ac=&val="+$('#search').val()+"&pag="+curr;
								     }
								  }
					    });
				});
		         
		        //执行
		        function ac_tion() {
				       window.location.href="?ac=&val="+$('#search').val()+"";
				}
			     function newup_user(){
					layer.open({
					  type: 2,
					  title: '新建表单',
					  offset: 't',//靠上打开
					  shadeClose: true,
					  maxmin:1,
					  shade: 0.5,
					  area: ['980px', '530px'],
					  content: 'form_new.jsp' 
					}); 
			     }
				 function edit(val) {//编辑 
					 layer.open({
						  type: 2,
						  title: '修改表单',
						  offset: 't',//靠上打开
						  shadeClose: true,
						  maxmin:1,
						  shade: 0.5,
						  area: ['100%', '100%'],
						  content: 'from_edit.jsp?fromid='+val
					});
				 }
			
	    </script>  
	    
	    <script>
	</script>
	</body> 
</html>

<%if(db!=null)db.close();db=null;if(server!=null)server=null;%>