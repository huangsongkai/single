<%@page trimDirectiveWhitespaces="true" %>
<%@page contentType="text/html; charset=UTF-8" language="java"%>
<%@page import="service.dao.db.Page"%>
<%@include file="../../cookie.jsp"%>
<%
/**
 *  角色列表
 */
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
	 
	    <title>表单列表</title> 
	    <style type="text/css">
			th {
		      background-color: white;
		    }
		    td {
		      background-color: white;
		    }
		    .btn-group-vertical>.btn, .btn-group>.btn{height:33px;}
		</style>
 	</head> 
	<body>
	    <div class="" style="padding-bottom: 0px;margin-left: 1%;margin-right: 1%; height:auto;">  
			<div id="tb" class="form_top layui-form" style="">
		        <input id="search" type="text" class="layui-input textbox-text" placeholder="输入表单名称进行查询" style="">
		        <button class="layui-btn layui-btn-small  layui-btn-primary" onclick="ac_tion('search')"> <i class="layui-icon"> </i> 搜索</button>
		        <button class="layui-btn layui-btn-small  layui-btn-primary" onclick="location.reload()"> <i class="layui-icon">ဂ</i> 刷新</button>
		        <button class="layui-btn layui-btn-small  layui-btn-primary " onclick="newup_user()" >新增表单</button>
		        <div class="layui-inline">
					    <label class="layui-form-label">导出:</label>
					    <div class="layui-input-inline">
					      <select name="gender" lay-verify="required"  lay-filter="Export">
					        <option value="请选择格式" selected="">请选择格式</option>
					         <%
					        	String sql = "select name,value from export";
					        	ResultSet base = db.executeQuery(sql);
					        	while(base.next()){
					         %>
					         	<option value="<%=base.getString("value") %>" > <%=base.getString("name") %> </option>
					         <%}%>
					      </select>
					    </div>
				</div>
				<%
					String pag = request.getParameter("page"); if(pag==null){pag="1";}//当前页数
		        	int pages = Integer.parseInt(pag); //当前页数
		        	
		        	if(pages<1){pages=1;out.println("<script>  alert('已经是第一页了！');  </script>");}
		        	
		        	int pag_num = (db.Row("select count(1) as row from form_name ;")  +  10  - 1) / 10; 
		        	
		        	if(pages>pag_num){pages=pag_num; out.println("<script>  alert('没有更多了');  </script>");}
		        	
		         %>
				<button class="layui-btn layui-btn-small  layui-btn-primary "><a href="?page=<%=pages-1%>">上一页</a></button>
				<button class="layui-btn layui-btn-small  layui-btn-primary "><a href="?page=<%=pages+1%>">下一页</a></button>
		    </div>
	    	<table class="cuoz" id="table" data-toggle="table" data-show-toggle="true" data-show-columns="true" data-show-export="true" >
		        <thead>
		            <tr>    
		             	<th data-field="state"   data-checkbox="true"><input type="checkbox" name="" ></th>
		              	<th data-field="表单名称"  data-sortable="true" data-filter-control="select"  data-visible="true">表单名称</th>
		              	<th data-field="数据表名称"  data-sortable="true" data-filter-control="select"  data-visible="true">数据表名称</th>
		              	<th data-field="表单所属角色"  data-sortable="true" data-filter-control="select"  data-visible="true">表单所属角色</th>
		              	<th data-field="操作"     data-sortable="true" data-filter-control="select"  data-visible="true">操作</th>
		            </tr>
		        </thead>
		        <tbody id="tbody">
		        <%
		        	
		        	
		        	String val = request.getParameter("val"); if(val==null){val="";}//获取文件后面的对象 数据
		        	
		        	val = new Page().mysqlCode(val);//防止sql注入
		        	val=val.toUpperCase();
		        	
		        	String customer_sql="";
		        	
		        	if("".equals(ac)){//默认首页  （倒序）
		        	
			          	 	customer_sql = "SELECT form_name.id as id,form_name.formname as formname,form_name.datafrom as datafrom, IFNULL((SELECT zk_role.name FROM role_from  LEFT JOIN zk_role ON role_from.roleid=zk_role.id WHERE  role_from.fromid=form_name.id  AND role_from.code=1),'无') AS role_name  FROM form_name limit "+(pages-1)*10+","+10+";";
							out.println(" <script>  $(\"#tbody\").empty();   </script>");
		          	}else if("search".equals(ac)){//搜索
			          	 	customer_sql = "SELECT form_name.id as id,form_name.formname as formname,form_name.datafrom as datafrom, IFNULL((SELECT zk_role.name FROM role_from  LEFT JOIN zk_role ON role_from.roleid=zk_role.id WHERE  role_from.fromid=form_name.id  AND role_from.code=1),'无') AS role_name  FROM form_name like '%"+val+"%'";
		        	}
		        	
		        	System.out.println("customer_sql==="+customer_sql);
		          	ResultSet customerPrs = db.executeQuery(customer_sql);
		          	while(customerPrs.next()){
		          	
		        %>
		          <tr>
			        <td ><input type="checkbox" name="" lay-skin="primary"></td>
					<td class=""><%=customerPrs.getString("formname") %></td><!--表单名称-->
					<td class=""><%=customerPrs.getString("datafrom")%></td><!--数据表名-->
					<td class=""><%=customerPrs.getString("role_name") %></td><!--角色名称-->
					<td class="">
					 <div class="layui-btn-group">
					    <button class="layui-btn" onclick="edit('<%=customerPrs.getString("id")%>')">编辑</button>
					  </div>
					</td>
			      </tr>
			    <%}%>
		        </tbody>
	        </table>
	    </div>    
	    <script type="text/javascript">   
		         
		     function newup_user(){
				layer.open({
				  type: 2,
				  title: '新建表单',
				  shadeClose: true,
				  maxmin:1,
				  shade: 0.5,
				  area: ['980px', '530px'],
				  content: 'new_from.jsp' 
				}); 
		     }
		     function ac_tion(ac) {
		     
			     if(ac=="search"){//搜索
			       window.location.href="?ac="+ac+"&val="+$('#search').val()+"";
			     }
			 }
			 
			 function edit(val) {//编辑 
				 layer.open({
					  type: 2,
					  title: '编辑角色信息',
					  shadeClose: true,
					  maxmin:1,
					  shade: 0.5,
					  area: ['780px', '530px'],
					  content: 'edit_role.jsp?id='+val
				});
			      //window.location.href="edit.jsp?uid="+val;
			 }
			
	    </script>  
	    
	    <script>
	</script>
	</body> 
</html>
<%
//插入常用菜单日志
int   TagMenu=db.Row("SELECT COUNT(1) as row FROM  menu_worker  WHERE sysmenuid='"+PMenuId+"' and  workerid='"+Suid+"' and  companyid="+Scompanyid);
if(TagMenu==0){
  		db.executeUpdate("INSERT INTO `menu_worker`(`sysmenuid`,`workerid`,`countes`,`companyid`) VALUES ('"+PMenuId+"','"+Suid+"','1','"+Scompanyid+"');"); 
}else{
   		db.executeUpdate("UPDATE  `menu_worker` SET `countes`=countes+1,`usetime`=now() WHERE  sysmenuid='"+PMenuId+"' and  workerid='"+Suid+"' and  companyid="+Scompanyid);
}
%>
<%
if(db!=null)db.close();db=null;if(server!=null)server=null;
%>