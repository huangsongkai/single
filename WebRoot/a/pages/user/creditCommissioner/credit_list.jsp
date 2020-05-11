<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%--征信专员-报件列表  --%>
<%@page trimDirectiveWhitespaces="true" %>
<%@page contentType="text/html; charset=UTF-8" language="java"%>
<%@page import="service.dao.db.Page"%>
<%@include file="../../cookie.jsp"%>
<%
	//获取文件后面的对象 数据
	String search_val = request.getParameter("val");
	if (search_val == null) {
		search_val = "";
	} else {
		search_val = search_val.replaceAll("\\s*", "");
	}
	search_val = new Page().mysqlCode(search_val);//防止sql注入
	search_val = (search_val.toUpperCase()).replaceAll(" ", "");

	//查询的字段局部语句
	String search = "";
	if (search_val.length() >= 1) {
		search = "AND B.customername like'%" + search_val + "%'";
	}
	//计算出总页数
	String zpag_sql = "SELECT COUNT(1)as row FROM order_sheet A LEFT JOIN order_customerfile B ON A.customeruid=B.id   WHERE A.createid=10  "
			+ search + ";";
	int zpag = db.Row(zpag_sql);
	zpag = (zpag + 10 - 1) / 10;

	//获取页数数
	String pag = request.getParameter("pag");
	if (pag == null) {
		pag = "1";
	}
	int pages = Integer.parseInt(pag);

	String sql = "SELECT A.id,A.ordercode,ifnull((SELECT typename FROM TYPE  WHERE id=loantype),'无') loantypes,A.policyname,B.customername,B.contactaddress,B.contactnumber,A.models,A.createtime FROM order_sheet A LEFT JOIN order_customerfile B ON A.customeruid=B.id   WHERE A.createid='"
			+ Suid
			+ "' ORDER BY createtime DESC "
			+ search
			+ " limit  "
			+ (pages - 1)
			* 10
			+ ",10;";
	System.out.println("sqlllll==="+sql);
	String html_str = ""; //页面代码
	ArrayList<String> list = new ArrayList<String>();

	//开始查询
	ResultSet rs = db.executeQuery(sql);
	while (rs.next()) {

		html_str = "<tr>" + "<td >"
				+ rs.getString("A.ordercode")
				+ "</td>"
				+ //订单编号
				"<td >"
				+ rs.getString("loantypes")
				+ "</td>"
				+ //贷款类别
				"<td >"
				+ rs.getString("A.policyname")
				+ "</td>"
				+ //收费政策
				"<td >"
				+ rs.getString("B.customername")
				+ "</td>"
				+ //客户姓名
				"<td >"
				+ rs.getString("B.contactaddress")
				+ "</td>"
				+ //客户地址
				"<td >"
				+ rs.getString("B.contactnumber")
				+ "</td>"
				+ //客户电话
				"<td >"
				+ rs.getString("A.models")
				+ "</td>"
				+ //所购车型
				"<td >"
				+ rs.getString("A.createtime")
				+ "</td>"
				+ //创建时间
				"<td >"
				+ //操作
				"<div class=\"layui-btn-group\">"
				+ "<button class=\"layui-btn\" onclick=\"check_see('"
				+ rs.getString("A.id") + "')\">查看</button>" + "</div>"
				+ "</td>" + "</tr>";
		list.add(html_str);
	}
	if (rs != null) {
		rs.close();
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
	 
	    <title>征信专员-报件列表</title> 
	    <style type="text/css">
			th { background-color: white; }
		    td {  background-color: white; }
		    .btn-group-vertical>.btn, .btn-group>.btn{height:33px;}
		</style>
 	</head> 
	<body>
	    <div class="" style="padding-bottom: 0px;margin-left: 1%;margin-right: 1%; height:auto;">  
			<div id="tb" class="form_top layui-form" style="display: flex;">
		        <br><input id="search" type="text" class="layui-input textbox-text" placeholder="输入角色名进行查询" style="height: 35px; color: #272525; background: rgb(227, 227, 227);">
		        <button class="layui-btn layui-btn-small  layui-btn-primary" onclick="ac_tion('')"  style="height: 35px;  color: white; background: rgb(25, 160, 148);"> <i class="layui-icon"> </i> 搜索</button>
		    	<button class="layui-btn layui-btn-small  layui-btn-primary" onclick="Refresh();ac_tion('');"  style="height: 35px;  color: white; background: rgb(25, 160, 148);"> <i class="layui-icon">ဂ</i> 刷新</button>
		        <button class="layui-btn layui-btn-small  layui-btn-primary " onclick="newup_user()"  style="height: 35px;  color: white; background: rgb(25, 160, 148);">新建报件</button>
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
					         	while (base.next()) {
					         %>
					         	<option value="<%=base.getString("value")%>" > <%=base.getString("name")%> </option>
					         <%
					         	}
					         %>
					      </select>
					    </div>
				</div>
		    </div>
	    	<table class="cuoz" id="table" data-toggle="table" data-show-toggle="true" data-show-columns="true" data-show-export="true" >
		        <thead>
		            <tr>
		             	
		              	<th data-field="订单编号"  data-sortable="true" data-filter-control="select"  data-visible="true">订单编号</th>
		              	<th data-field="贷款类别"  data-sortable="true" data-filter-control="select"  data-visible="true">贷款类别</th>
		  <%--政策类型  --%>	<th data-field="收费政策"  data-sortable="true" data-filter-control="select"  data-visible="true">收费政策</th>
		              	<th data-field="客户姓名"     data-sortable="true" data-filter-control="select"  data-visible="true">姓名</th>
		               	<th data-field="客户住址"  data-sortable="true" data-filter-control="select"  data-visible="true">家庭住址</th>
		                <th data-field="客户电话"  data-sortable="true" data-filter-control="select"  data-visible="true">联系电话</th>
		                <th data-field="所购车型"  data-sortable="true" data-filter-control="select"  data-visible="true">车辆类型</th>
		                <th data-field="创建时间"     data-sortable="true" data-filter-control="select"  data-visible="true">时间</th>
		              	<th data-field="操作"     data-sortable="true" data-filter-control="select"  data-visible="true">操作</th>
		            </tr>
		        </thead>
		        <tbody id="tbody">
					<%=list.toString().replaceAll("\\[", "").replaceAll("\\]",
					"").replaceAll(",", "")%>
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
		         
			     function check_see(orderid){
		    		layer.open({
					  type: 2,
					  title: '查看',
					  offset: 't',//靠上打开
					  shadeClose: true,
					  maxmin:1,
					  offset: 't',
					  shade: 0.5,
					  area: ['980px', '500px'],
					  content: '../visitingSupervisor/visitier_check.jsp?orderid='+orderid 
					});
		    	 }
			     function newup_user(orderid){
		    		layer.open({
					  type: 2,
					  title: '新建报件',
					  offset: 't',//靠上打开
					  shadeClose: true,
					  maxmin:1,
					  offset: 't',
					  shade: 0.5,
					  area: ['980px', '500px'],
					  content: 'report.jsp' 
					});
		    	 }
	    </script>  
	    
	    <script>
	</script>
	</body> 
</html>

<%
	if (db != null)
		db.close();
	db = null;
	if (server != null)
		server = null;
%>