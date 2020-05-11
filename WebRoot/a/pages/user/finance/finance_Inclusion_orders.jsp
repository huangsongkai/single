<%@ page trimDirectiveWhitespaces="true" %>
<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@page import="service.dao.db.Page"%>
<%@page import="v1.haocheok.commom.common"%>
<%@include file="../../cookie.jsp"%>

<html>
	<head> 
	    <meta charset="utf-8"> 
	    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
		<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
		<meta name="apple-mobile-web-app-status-bar-style" content="black">
		<meta name="apple-mobile-web-app-capable" content="yes">
		<meta name="format-detection" content="telephone=no">
	     <link rel="stylesheet" href="../../../pages/css/sy_style.css?22">	    
	    <link rel="stylesheet" href="../../js/layui/css/layui.css">
		<script type="text/javascript" src="../../js/jquery-1.9.1.js" ></script><!--通用jquery-->
		<script src="../../js/layui/layui.js"></script>
		<script type="text/javascript" src="../../js/tableExport/js/table-sort.js" ></script><!--表格排序js  css-->
		<script type="text/javascript" chartset="utf8" src="../../js/tableExport/js/table_list.js " ></script><!--表格导出js  css-->
		<script src="../../js/ajaxs.js"></script>
	 
	    <title>档案列表</title> 
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
		        <input id="search" type="text" class="layui-input textbox-text" placeholder="输入借款人姓名" style="">
		        <button class="layui-btn layui-btn-small  layui-btn-primary" onclick="ac_tion('search')"> <i class="layui-icon"></i> 搜索</button>
		        <button class="layui-btn layui-btn-small layui-btn-primary" onclick="location.reload()"> <i class="layui-icon">ဂ</i>刷新</button>
		        <!--<button class="layui-btn layui-btn-small  layui-btn-primary" >批量删除</button>-->
		         <div class="layui-inline">
					    <label class="layui-form-label">导出</label>
					    <div class="layui-input-inline">
					      <select name="gender" lay-verify="required"  lay-filter="Export">
					        <option value="请选择格式" selected="">请选择格式</option>
					        <%
					        	String sql = "select name,value from export";
					        	ResultSet base = db.executeQuery(sql);
					        	while(base.next()){
					         %>
					         	<option value="<%=base.getString("value") %>" > <%=base.getString("name") %> </option>
					         <% }%>
					      </select>
					    </div>
				</div>
		    </div>
	    	<table class="cuoz" id="table" data-toggle="table" data-show-toggle="true" data-show-columns="true" data-show-export="true" >
		        <thead>
		            <tr>
		             	<th data-field="state"   data-checkbox="true"><input type="checkbox" name="" ></th>
		              	<th data-field="编号"     data-sortable="true" data-filter-control="select"  data-visible="true">编号</th>
		              	<th data-field="订单编号"  data-sortable="true" data-filter-control="select"  data-visible="true">订单编号</th>
		              	<th data-field="贷款类别"  data-sortable="true" data-filter-control="select"  data-visible="true">贷款类别</th>
		              	<th data-field="收费政策"  data-sortable="true" data-filter-control="select"  data-visible="true">收费政策</th>
		              	<th data-field="姓名"     data-sortable="true" data-filter-control="select"  data-visible="true">姓名</th>
		               	<th data-field="家庭住址"  data-sortable="true" data-filter-control="select"  data-visible="true">家庭住址</th>
		                <th data-field="联系电话"  data-sortable="true" data-filter-control="select"  data-visible="true">联系电话</th>
		                <th data-field="车辆类型"  data-sortable="true" data-filter-control="select"  data-visible="true">车辆类型</th>
		                <th data-field="时间"     data-sortable="true" data-filter-control="select"  data-visible="true">时间</th>
		                <th data-field="状态"     data-sortable="true" data-filter-control="select"  data-visible="true">状态</th>
		              	<th data-field="操作"     data-sortable="true" data-filter-control="select"  data-visible="true">操作</th>
		            </tr>
		        </thead>
		        <tbody>
		        <%
		        	//基本信息
		        	UserEntity user = (UserEntity)session.getAttribute("UserList");
		        	System.out.println("regionalcode========="+user.getRegionalcode());
		        	
		        	String val = request.getParameter("val"); if(val==null){val="";}//获取文件后面的对象 数据
		        	String type = request.getParameter("type"); if(type==null){type="";}//查询类型【正序   倒序 】
		        	val = new Page().mysqlCode(val);//防止sql注入
		        	val=val.toUpperCase();
		        	
		        	String newfile_str="";//新建的代码 
		        	
		        	String customer_sql="";
		        	
		        	if("".equals(ac)){//默认首页  （倒序）
						customer_sql = "SELECT *															  "
										+"FROM (SELECT *                                                      "
										+"      FROM (SELECT *                                                "
										+"            FROM process_log                                        "
										+"            ORDER BY creation_date DESC) AS `temp`                  "
										+"      GROUP BY nodeid,orderid                                       "
										+"      ORDER BY orderid) `temp1`,                                    "
										+"  	order_sheet,                                                  "
										+"  	order_customerfile                                            "
										+"	WHERE  temp1.status = '1'                                          "
										+"    AND order_sheet.customeruid = order_customerfile.id             "
										+"    AND temp1.orderid = order_sheet.id               "
										+" 	  AND operatorid = "+Suid+"              "
										+"    AND temp1.regionalcode LIKE '"+user.getRegionalcode()+"%'                           "
										+"    AND temp1.rolecode = '"+user.getRolecode()+"'                              ";
		          	}else if("search".equals(ac)){//搜索
			          	 	
							customer_sql = "SELECT *															  "
										+"FROM (SELECT *                                                      "
										+"      FROM (SELECT *                                                "
										+"            FROM process_log                                        "
										+"            ORDER BY creation_date DESC) AS `temp`                  "
										+"      GROUP BY nodeid,orderid                                       "
										+"      ORDER BY orderid) `temp1`,                                    "
										+"  	order_sheet,                                                  "
										+"  	order_customerfile                                            "
										+"	WHERE order_customerfile.customername LIKE '%"+val+"%'                   "
										+"    AND temp1.status = '1'                                          "
										+"    AND order_sheet.customeruid = order_customerfile.id             "
										+"    AND temp1.orderid = order_sheet.id                              "
										+" 	  AND operatorid = "+Suid+"              "
										+"    AND temp1.regionalcode LIKE '"+user.getRegionalcode()+"%'                           "
										+"    AND temp1.rolecode = '"+user.getRolecode()+"'                              ";
		        	}else if("b".equals(ac)){//上一页
		        	
		        	
		        	
		        	
		        	}else if("c".equals(ac)){//下一页
		        	
		        	
		        	
		        	
		        	}
		          	
		          	System.out.println("customer_sql===="+customer_sql);
		          	
		          	ResultSet customerPrs = db.executeQuery(customer_sql);
		          	int i = 1;
		          	while(customerPrs.next()){
		        %>
		          <tr>
			        <td ><input type="checkbox" name="" lay-skin="primary"></td>
			        <td class="" ><%=i %></td>
					<td class=""><%=customerPrs.getString("ordercode") %></td>
					<td class=""><%=customerPrs.getString("loantype") %></td>
					<td class=""><%=customerPrs.getString("policyname")%></td>
					<td class=""><%=customerPrs.getString("customername") %></td>
					<td class=""><%=customerPrs.getString("contactaddress") %></td>
					<td class=""><%=customerPrs.getString("phonenumber") %></td>
					<td class=""><%=customerPrs.getString("models") %></td>
					<td class=""><%=customerPrs.getString("updatetime") %></td>
					<td class=""><%=common.getDis4info("status",customerPrs.getString("status")) %></td>
					<td class="">
					<input type="hidden" value="<%=customerPrs.getString("nodeid") %>" name="nodeid" id="nodeid" />
					<input type="hidden" value="<%=customerPrs.getString("processid") %>" name="processid" id="processid" />
					<input type="hidden" value="<%=customerPrs.getString("orderid") %>" name="orderid" id="orderid" />
					 <div class="layui-btn-group">
					    <!--<button class="layui-btn" onclick="buttonin()">接单</button>-->
					    <button class="layui-btn" onclick="bianji('<%=customerPrs.getString("orderid") %>')" >编辑</button>
					  </div>
					</td>
			      </tr>
			    <%i++;}%>
		        </tbody>
	        </table>
	    </div>    
	    <script type="text/javascript">   
	    	function bianji(orderid){
	    		layer.open({
				  type: 2,
				  title: '编辑',
				  shadeClose: true,
				  maxmin:1,
				  offset: 't',
				  shade: 0.5,
				  area: ['980px', '500px'],
				  content: 'visitier_ti.jsp?order='+orderid 
				  
				});
	    	
	    	}
	    
		      layui.use(['form', 'layedit', 'laydate'], function(){
				  var form = layui.form()
				  ,layer = layui.layer
				  ,layedit = layui.layedit
				  ,laydate = layui.laydate;
				  form.on('select(Export)', function(data){
					 if(data.value=="CSV"){
					  doExport('#table', {type: 'csv'});
					 }else if(data.value=="XLS"){
					  doExport('#table', {type: 'excel'});
					 }else if(data.value=="XLSX"){
					 doExport('#table', {type: 'xlsx'});
					 }else if(data.value=="PDF"){
					 doExport('#table', {type: 'pdf', jspdf: {orientation: 'l', unit: 'mm', margins: {right: 5, left: 5, top: 10, bottom: 10}, autotable: false}});
					 }else if(data.value=="XML"){
					  doExport('#table', {type: 'xml'});
					 }else if(data.value=="SQL"){
					  doExport('#table', {type: 'sql'});
					 }else if(data.value=="Word"){
					  doExport('#table', {type: 'doc'});
					 }else if(data.value=="PNG"){
					  doExport('#table', {type: 'png'});
					 }else if(data.value=="JSON"){
					  doExport('#table', {type: 'json', tfootSelector: ''});
					 }else if(data.value=="TXT"){
					  doExport('#table', {type: 'txt'});
					 }
					});
					form.render(); 
			});     
		     
		     function ac_tion(ac) {
		     
			     if(ac=="a"){
			     
			     }else if(ac=="b"){
			     
			     }else if(ac=="search"){
			     
			       window.location.href="?ac="+ac+"&val="+$('#search').val()+"";
			     }
				
			}
		     
	    </script>  
	    
	    <script>
	</script>
	</body> 
</html>
















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