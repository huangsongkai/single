<%@ page trimDirectiveWhitespaces="true" %>
<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@include file="../../cookie.jsp"%>

<head> 
    <meta charset="utf-8"> 
    <meta name="viewport" content="width=device-width, initial-scale=1"> 
    <link rel="stylesheet" href="../../../pages/css/sy_style.css?22">	    
	    <link rel="stylesheet" href="../../js/layui/css/layui.css">
		<script type="text/javascript" src="../../js/jquery-1.9.1.js" ></script><!--通用jquery-->
		<script src="../../js/layui/layui.js"></script>
		<script type="text/javascript" src="../../js/tableExport/js/table-sort.js" ></script><!--表格排序js  css-->
		<script type="text/javascript" chartset="utf8" src="../../js/tableExport/js/table_list.js " ></script><!--表格导出js  css-->
	<link rel="stylesheet" href="../../../custom/easyui/tree.css">
    <title>档案列表</title> 
    <style type="text/css">
		th {
	      background-color: white;
	    }
	    td {
	      background-color: white;
	    }
	    .btn-group-vertical>.btn, .btn-group>.btn{height:33px;}
	    .layui-layer-content{padding:20px;}
	    .layui-layer-btn{text-align:center;}
	</style>
 </head> 
<body>
    <div class="">  
	<div id="tb" class="form_top layui-form" style="">
       <input type="text" class="layui-input textbox-text" placeholder="" style="">
        <button class="layui-btn layui-btn-small  layui-btn-primary"> <i class="layui-icon"></i> 搜索</button>
        <button class="layui-btn layui-btn-small layui-btn-primary" onclick="location.reload()"> <i class="layui-icon">ဂ</i>刷新</button>
        <button class="layui-btn layui-btn-small  layui-btn-primary" >批量删除</button>
        <button class="layui-btn layui-btn-small  layui-btn-primary newfile" >新建档案</button>
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
			        <!--  <option value="CSV" > CSV </option>
			        <option value="XLS"> XLS</option>
			        <option value="XLSX"  > XLSX</option>
			        <option value="PDF" > PDF</option>
			        <option value="XML" > XML</option>
			        <option value="SQL" > SQL</option>
			        <option value="Word" > Word</option>
			        <option value="PNG" > PNG</option>
			        <option value="JSON" > JSON</option>
			        <option value="TXT" > TXT</option>
			        -->
			      </select>
			    </div>
			 </div>
     </div>
    <table class="cuoz" id="table" data-toggle="table" data-show-toggle="true" data-show-columns="true" data-show-export="true" >
        <thead>
            <tr>
             <th data-field="state"  data-checkbox="true"><input type="checkbox" name="" ></th>
              <th data-field="编号"     data-sortable="true" data-filter-control="select" data-visible="true" >编号</th>
              <th data-field="姓名"  data-sortable="true" data-filter-control="select" data-visible="true">姓名</th>
              <th data-field="性别"     data-sortable="true" data-filter-control="select"  data-visible="true">贷款类别</th>
               <th data-field="家庭住址"  data-sortable="true" data-filter-control="select" data-visible="true">家庭住址</th>
                <th data-field="联系电话"  data-sortable="true" data-filter-control="select" data-visible="true">联系电话</th>
                <th data-field="时间"  data-sortable="true" data-filter-control="select" data-visible="true">时间</th>
              <th data-field="操作" data-sortable="true" data-filter-control="select" data-visible="true" >操作</th>
            </tr>
          </thead>
          <tbody>
          <%
          		String customer_sql = "select * from order_customerfile";
          		ResultSet customerPrs = db.executeQuery(customer_sql);
          		int i = 1;
          		while(customerPrs.next()){
           %>
          <tr>
	        <td ><input type="checkbox" name="" lay-skin="primary"></td>
	        <td class="" ><%=i %></td>
			<td class=""><%=customerPrs.getString("customername") %></td>
			<td class=""><%if("0".equals(customerPrs.getString("sex"))){out.println("男");}else{out.println("女");} %></td>
			<td class=""><%=customerPrs.getString("contactaddress") %></td>
			<td class=""><%=customerPrs.getString("contactnumber") %></td>
			<td class=""><%=customerPrs.getString("creationdate") %></td>
			<td class=""><a onclick="look()">查看</a><a onclick="edit()">编辑</a><a onclick="report()">报件</a><a onclick="deletet()">删除</a></td>
	      </tr>
	      <%i++;} %>
	      
        </tbody>
      </table>
  </div>    
    <script type="text/javascript">   
    function look(){
		layer.open({
		title:"查看",
		skin: 'layui-layer-molv',
		  type: 1,
		  area: ['400px', '450px'],
		  content: "<div class='easyui-panel' style='padding:5px'>"
			+"<ul id='look' class='easyui-tree'  ></ul>"
			+"</div>",
			btn:"确定"
		});
		$('#look').tree({    
	   		 checkbox: true,  
	   		 animate: true,
	   		 onlyLeafCheck: true,
			 url: "tree_data1.json"    
		}); 
    }
  
     function edit(){
		layer.open({
		title:"编辑",
		skin: 'layui-layer-molv',
		  type: 1,
		  area: ['400px', '450px'],
		  content: "<div class='easyui-panel' style='padding:5px'>"
			+"<ul id='edit' class='easyui-tree'  ></ul>"
			+"</div>",
			btn:"确定"
		});
		$('#edit').tree({    
	   		 checkbox: true,  
	   		 animate: true,
	   		 onlyLeafCheck: true,
			 url: "tree_data1.json"    
		});
    } 
    
    function report(){
				layer.open({
				  type: 2,
				  title: '新建报件',
				  shadeClose: true,
				  maxmin:1,
				  shade: 0.5,
				  area: ['980px', '530px'],
				  content: '../creditCommissioner/report.jsp' 
				}); 
		     }
    
    
       //树形结构
       function report_test(){
		layer.open({
		title:"报件",
		skin: 'layui-layer-molv',
		  type: 1,
		  area: ['400px', '450px'],
		  content: "<div class='easyui-panel' style='padding:5px'>"
			+"<ul id='report' class='easyui-tree'  ></ul>"
			+"</div>",
			btn:"确定"
		});
		$('#report').tree({    
	   		 checkbox: true,  
	   		 animate: true,
	   		 onlyLeafCheck: true,
			 url: "tree_data1.json"    
		});
    }  
      function deletet(){
		
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
     $(".newfile").click(function(){
		layer.open({
		  type: 2,
		  title: '新建档案',
		  shadeClose: true,
		  shade: 0.8,
		  offset: 't',
		  area: ['980px', '560px'],
		  content: 'customer_new.jsp' //iframe的url
		}); 
     })
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
if(db!=null)db.close();db=null;if(server!=null)server=null;%>