<%@ page trimDirectiveWhitespaces="true" %>
<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@page import="service.dao.db.Page"%>
<%@include file="../../cookie.jsp"%>
<html>
<head> 
    <meta charset="utf-8"> 
    <meta name="viewport" content="width=device-width, initial-scale=1"> 
    <link rel="stylesheet" href="../../css/sy_style.css?22">	    
	    <link rel="stylesheet" href="../../js/layui/css/layui.css">
		<script src="../../js/layui/layui.js"></script>
		<script type="text/javascript" src="../../js/tableExport/js/table-sort.js" ></script><!--表格排序js  css-->
		<script type="text/javascript" chartset="utf8" src="../../js/tableExport/js/table_list.js " ></script><!--表格导出js  css-->
 <script type="text/javascript" src="../../../custom/jquery.easyui.min.js"></script>
     <link rel="stylesheet" href="../../../custom/easyui/tree.css" />
    <title>信息审核</title> 
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
             <div>
                <input type="hidden" id="AppId" value="<%=AppId_web%>">
                <input type="hidden" id="AppKey" value="<%=AppKey_web%>">
                <input type="hidden" id="Spc_token" value="<%=Spc_token%>">
                <input type="hidden" id="Suid" value="<%=Suid%>">
                <input type="hidden" id="uuid" value="<%=uuid%>">
             </div>
	<div id="tb" class="form_top ">
       <button class="layui-btn layui-btn-small layui-btn-primary" onclick="location.reload()"> <i class="layui-icon">ဂ</i>刷新</button> 
           <label style="margin-left:20px">审核状态:</label>
           <select id="opt" name="" style="margin-left:5px;height:26px;width:80px"> 
                            <option value="0">待审核</option> 
                            <option value="1">不通过</option>
                            <option value="2">通过</option>
           </select> 
        <button class="layui-btn layui-btn-small layui-btn-primary" onclick="states()" style="margin-left:20px"><i class="layui-icon"></i>查询</button>
        	   <%
				//获取页数数
		       	String pageNum = request.getParameter("pag"); if(pageNum==null){pageNum="1";}
		       	int pages=Integer.parseInt(pageNum);
		        %>
		    </div>
     </div>
    <table class="cuoz" id="table" data-toggle="table" data-show-toggle="true" data-show-columns="true" data-show-export="true" >
        <thead>
            <tr>                        
              <th data-field="文章栏目"  data-sortable="true" data-filter-control="select" data-visible="true" >信息栏目</th>
              <th data-field="文章标题"  data-sortable="true" data-filter-control="select" data-visible="true">信息标题</th>
              <th data-field="操作人"  data-sortable="true" data-filter-control="select" data-visible="true">发布人</th>
              <th data-field="添加时间"  data-sortable="true" data-filter-control="select" data-visible="true">添加时间</th>
              <th data-field="审核状态" data-sortable="true" data-filter-control="select" data-visible="true">审核状态</th>
              <th data-field="审核意见" data-sortable="true" data-filter-control="select" data-visible="true">审核意见</th>
              <th data-field="操作"  data-sortable="true" data-filter-control="select" data-visible="true" >操作</th>
            </tr>
          </thead>
          <tbody id="tj">
          </tbody>
      </table>
      <div id="pages"  style="float: right;"></div>
  </div>    
    <script type="text/javascript">
    //basepath获取服务器根目录
    var curWwwPath = window.document.location.href;
    var pathName = window.document.location.pathname;
    var pos = curWwwPath.indexOf(pathName);
    var localhostPath = curWwwPath.substring(0, pos);
    var projectName = pathName.substring(0, pathName.substr(1).indexOf('/') + 1);
    var basePath=localhostPath+projectName+"/";
    //
      var  page;
      var AppId=$("#AppId").val();
	  var AppKey=$("#AppKey").val();
	  var Spc_token=$("#Spc_token").val();
	  var Suid=$("#Suid").val();
	  var uuid=$("#uuid").val();
    if(<%=request.getParameter("state")%>!=null){   	
    	 
    	 state=<%=request.getParameter("state")%>;
    	 var strvalue={
			     "state":state,
	    	     "page":"<%=pages%>", 
	    	     "listnum": "10"
	    	    }
	   $.ajax( {
	 		// 提交数据的类型 POST GET
	 		type : "POST",
	 		// 提交的网址
	 		url : basePath+"/Api/v1/?p=web/cms/articles/selectArticlesByState",
	 		// 提交的数据
	 		data : JSON.stringify(strvalue),
	 		// 返回数据的格式
	 		async : false,//不是同步的话 返回值娶不到
	 		datatype : "json",// "xml", "html", "script", "json", "jsonp",
	 		// 成功返回之后调用的函数
	 		success : function(data) {
	 		       jsonData=eval("("+data+")"); 	 		      
	 		       for(var i=0;i<jsonData.threads.length;i++){
	 	 		        var states;
	 	 		        if(jsonData.threads[i].state==0){
	                          states="待审核";
	 	 	 		        }else if(jsonData.threads[i].state==1){
	                          states="不通过";
	 	 	 	 		    }else{
	 	 	 	 		      states="通过";
	 	 	 	 	 		}
	 document.getElementById("tj").innerHTML+=`<tr>    
	 					<td class="">`+jsonData.threads[i].classna+`</td>
	 					<td class="">`+jsonData.threads[i].title+`</td>
	 					<td class="">`+jsonData.threads[i].author+`</td>
	 					<td class="">`+jsonData.threads[i].addtime+`</td>
	 					<td class="">`+states+`</td>
	 					<td class="">`+jsonData.threads[i].opinion+`</td>
	 					<td class=""><a onclick="look(`+jsonData.threads[i].id+`)">预览</a><a onclick="editDistrbutor(`+jsonData.threads[i].id+`)">审核</a><a onclick="editsDistrbutor(`+jsonData.threads[i].id+`)">编辑</a></td>
	 			      </tr>`
	              } 
	               page=jsonData.pages;	             
	              layui.use(['laypage', 'layer'], function(){
					  var laypage = layui.laypage
					  ,layer = layui.layer;
							laypage({
							    cont: 'pages'
							    ,pages: page //总页数
							    ,curr: <%=pages%>     //当前页数 
							    ,skip: true
							    ,jump: function(obj, first){
									    //得到了当前页，用于向服务端请求对应数据
									     var curr = obj.curr;
									     if(curr!=<%=pages%>){//防止死循环 
									     	window.location.href="?ac=&state="+state+"&pag="+curr;
									     }
									  }
						    });
					});
	        layui.use(['form', 'layedit', 'laydate'], function(){
			     var form = layui.form()
			        ,layer = layui.layer
			        ,layedit = layui.layedit
			        ,laydate = layui.laydate;
				    form.render(); 
		         });     
	 		   },
	 		 headers : {
	 			"Content-type" : "application/json",
	 			"X-AppId" : AppId,
	 			"X-AppKey" : AppKey,
	 			"Token" : Spc_token,
	 			"X-USERID": Suid,
	 			"X-UUID": uuid,
	 		 }, 
	 		// 调用执行后调用的函数
	 		complete : function(XMLHttpRequest, textStatus) {
	 		  if (textStatus == "success") {
	 			  //$("#msg").html(XMLHttpReques.=XMLHttpRequest.responseText;);
	 			  //alert(data1);
	            }
	 		 },
	 	    // 调用出错执行的函数
	 		error : function() {
	 			 backdata="系统消息：网络故障与服务器失去联系";
	 		 }
	 	});           	  
       }    
    function look(id){
		  var toUrl = 'detail_distrbutor_copy.jsp?id='+id ;
        window.open(toUrl);
    }
    function editDistrbutor(id){
		layer.open({
		 type: 2,
		  title: '审核',
		  shadeClose: true,
		  offset:'t',
		  maxmin:1,
		  shade: 0.5,
		  area: ['980px', '100%'],
		  content: 'edit_information_state.jsp?id='+id 
		});
    }
    function editsDistrbutor(id){
		layer.open({
		 type: 2,
		  title: '编辑信息',
		  shadeClose: true,
		  offset:'t',
		  maxmin:1,
		  shade: 0.5,
		  area: ['980px', '100%'],
		  content: 'edit_information.jsp?id='+id 
		});
    } 
  //通过审核状态查找
   function states(){
	   document.getElementById("tj").innerHTML=""; 
	   var optiona=$("#opt option:selected");
	   var state=optiona.val(); 
	   var strvalue={
			     "state":state,
	    	     "page":"<%=pages%>", 
	    	     "listnum": "10"
	    	    }
	   $.ajax( {
	 		// 提交数据的类型 POST GET
	 		type : "POST",
	 		// 提交的网址
	 		url : basePath+"/Api/v1/?p=web/cms/articles/selectArticlesByState",
	 		// 提交的数据
	 		data : JSON.stringify(strvalue),
	 		// 返回数据的格式
	 		async : false,//不是同步的话 返回值娶不到
	 		datatype : "json",// "xml", "html", "script", "json", "jsonp",
	 		// "text".
	 		// 成功返回之后调用的函数
	 		success : function(data) {
	 		       jsonData=eval("("+data+")"); 	 		      
	 		       for(var i=0;i<jsonData.threads.length;i++){
	 	 		        var states
	 	 		        if(jsonData.threads[i].state==0){
	                          states="待审核";
	 	 	 		        }else if(jsonData.threads[i].state==1){
	                          states="不通过";
	 	 	 	 		    }else{
	 	 	 	 		      states="通过";
	 	 	 	 	 		}
	 document.getElementById("tj").innerHTML+=`<tr>    
	 					<td class="">`+jsonData.threads[i].classna+`</td>
	 					<td class="">`+jsonData.threads[i].title+`</td>
	 					<td class="">`+jsonData.threads[i].author+`</td>
	 					<td class="">`+jsonData.threads[i].addtime+`</td>
	 					<td class="">`+states+`</td>
	 					<td class="">`+jsonData.threads[i].opinion+`</td>
	 					<td class=""><a onclick="look(`+jsonData.threads[i].id+`)">预览</a><a onclick="editDistrbutor(`+jsonData.threads[i].id+`)">审核</a><a onclick="editsDistrbutor(`+jsonData.threads[i].id+`)">编辑</a></td>
	 			      </tr>`
	              } 
	               page=jsonData.pages;	             
	              layui.use(['laypage', 'layer'], function(){
					  var laypage = layui.laypage
					  ,layer = layui.layer;
							laypage({
							    cont: 'pages'
							    ,pages: page //总页数
							    ,curr: <%=pages%>     //当前页数 
							    ,skip: true
							    ,jump: function(obj, first){
									    //得到了当前页，用于向服务端请求对应数据
									     var curr = obj.curr;
									     if(curr!=<%=pages%>){//防止死循环 
									     	window.location.href="?ac=&state="+state+"&pag="+curr;
									     }
									  }
						    });
					});
	        layui.use(['form', 'layedit', 'laydate'], function(){
			     var form = layui.form()
			        ,layer = layui.layer
			        ,layedit = layui.layedit
			        ,laydate = layui.laydate;
				    form.render(); 
		         });     
	 		   },
	 		 headers : {
	 			"Content-type" : "application/json",
	 			"X-AppId" : AppId,
	 			"X-AppKey" : AppKey,
	 			"Token" : Spc_token,
	 			"X-USERID": Suid,
	 			"X-UUID": uuid,
	 		 }, 
	 		// 调用执行后调用的函数
	 		complete : function(XMLHttpRequest, textStatus) {
	 		  if (textStatus == "success") {
	 			  //$("#msg").html(XMLHttpReques.=XMLHttpRequest.responseText;);
	 			  //alert(data1);
	            }
	 		 },
	 	    // 调用出错执行的函数
	 		error : function() {
	 			 backdata="系统消息：网络故障与服务器失去联系";
	 		 }
	 	});       
   }
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