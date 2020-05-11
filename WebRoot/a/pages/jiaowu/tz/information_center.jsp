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
 <link href="../../css/base.css" rel="stylesheet">
    <link rel="stylesheet" href="../../../custom/easyui/easyui.css">
    <link href="../../css/basic_info.css" rel="stylesheet">
 <script type="text/javascript" src="../../../custom/jquery.easyui.min.js"></script>
     <link rel="stylesheet" href="../../../custom/easyui/tree.css" />
     <script type="text/javascript" src="../../js/pub.js"></script>
    <link rel="stylesheet" href="../layui/css/layui.css">
   
    <style type="text/css">
    	#left-tree{height:500px;overflow:hidden;}
    	.easyui-tabs1{height:520px;overflow:hidden;border:#bfbfbf 1px solid;padding:0 10px;}
    	#wrapper{height:500px;overflow:scroll;}
    	.container{width:100%;}
    </style>
    <title>信息中心</title> 
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
	    .left-tree{width:472px;}
	    #leftdao{width:160px;}
	</style>
	<script>
    layui.use('element', function(){
       var element = layui.element; //导航的hover效果、二级菜单等功能，需要依赖element模块
       //监听导航点击      
     });
</script>

 </head> 
<body>
<div class="container" >
<div class="left-tree" id="left-tree">
<ul class="layui-nav layui-nav-tree layui-nav-side" lay-filter="test" id="leftdao">
  
</ul>
</div>
  <div class="content">
    <div class="">  
              <div>
                <input type="hidden" id="AppId" value="<%=AppId_web%>">
                <input type="hidden" id="AppKey" value="<%=AppKey_web%>">
                <input type="hidden" id="Spc_token" value="<%=Spc_token%>">
                <input type="hidden" id="Suid" value="<%=Suid%>">
                <input type="hidden" id="uuid" value="<%=uuid%>">
              </div>
	<div id="tb" class="form_top layui-form" style="">
      <button class="layui-btn layui-btn-small layui-btn-primary" onclick="location.reload()"> <i class="layui-icon">ဂ</i>刷新</button>      
        	<%
		       	//获取文件后面的对象 数据
		       	String search_val = request.getParameter("val"); 
		       	if(search_val==null){search_val="";}else{search_val=search_val.replaceAll("\\s*", "");}
		       	search_val = new Page().mysqlCode(search_val);//防止sql注入
				search_val=search_val.toUpperCase();	
				//查询的字段局部语句
		 		String search="";		 		
		 		if(search_val.length()>1){
		 			search="where name like '%"+search_val+"%'";
		 		}
		 		//计算出总页数
				String zpag_sql="select count(1) as row from g_distributor "+search+";";
				int zpag= db.Row(zpag_sql);					
				zpag=(zpag+10-1)/10;				
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
              <th data-field="添加时间"  data-sortable="true" data-filter-control="select" data-visible="true">添加时间</th>
              <th data-field="操作"  data-sortable="true" data-filter-control="select" data-visible="true" >操作</th>
            </tr>
          </thead>
          <tbody id="tj">
          </tbody>
      </table>
      <div id="pages"  style="float: right;"></div>
    </div> 
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
      var Purl=basePath+"/Api/v1/?p=web/cms/articles/selectArticles";
     var strvalue={
    	     "page":"<%=pages%>", 
    	     "listnum": "10"
    	    }
 	 $.ajax( {
 		// 提交数据的类型 POST GET
 		type : "POST",
 		// 提交的网址
 		url : Purl,
 		// 提交的数据
 		data : JSON.stringify(strvalue),
 		// 返回数据的格式
 		async : false,//不是同步的话 返回值娶不到
 		datatype : "json",// "xml", "html", "script", "json", "jsonp",
 		// "text".
 		// 成功返回之后调用的函数
 		success : function(data) {
 		       jsonData=eval("("+data+")");   
 		      if(jsonData.success){
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
 					
 					<td class="">`+jsonData.threads[i].addtime+`</td>
 					
 					<td class=""><a onclick="look(`+jsonData.threads[i].id+`)">预览</a></td>
 			      </tr>`
              } 
 		      }else{alert("您没有任何栏目的权限，请联系管理员！")} 		      
              var  page=jsonData.pages;       
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
								     	window.location.href="?ac=&val="+$('#search').val()+"&pag="+curr;
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
  	//栏目调取数据
 
    function ac_tion(ac){
			     if(ac=="search"){//搜索
			       window.location.href="?ac="+ac+"&val="+$('#search').val()+"";
			     }
			 }  
    function newDistrbutor(){
    	layer.open({
		  type: 2,
		  title: '新建信息',
		  shadeClose: true,
		  maxmin:1,
		  shade: 0.5,
		  area: ['980px', '100%'],
		  content: 'new_information.jsp' 
		});
    }
   
    function look(id){
		  var toUrl = 'detail_distrbutor_copy.jsp?id='+id ;
		
        window.open(toUrl);
  }
    //导航栏
    var str={
    		"bu":"不需要数据"
    	    }
    $.ajax( {
 		// 提交数据的类型 POST GET
 		type : "POST",
 		// 提交的网址
 		url : basePath+"/Api/v1/?p=web/cms/classify/selectClassifyToDaoA",
 		// 提交的数据
 		data : JSON.stringify(str),
 		// 返回数据的格式
 		async : false,//不是同步的话 返回值娶不到
 		datatype : "json",// "xml", "html", "script", "json", "jsonp",
 		// "text".
 		// 成功返回之后调用的函数
 		success : function(data) {
 		  
 		  var  inner;
 		       jsonData=eval("("+data+")");  	       
 		       for(var i=0;i<jsonData.threads.length;i++){
 		    	   var obj= jsonData.threads[i]
 		    	     		    	   
 		    	      for(var key in  obj)
 		    	       {    
	 		    	       var arr=  obj[key];
	 		inner+= `<li class="layui-nav-item ">
	 	    <a href="javascript:;">`+key+`</a>
	 	    <dl class="layui-nav-child">`
	 	   for(var j=0;j< arr.length;j++){
   	    	  var arrs=arr[j]
   	    	            var c=0;
	    	      for(var keys in arrs )
	    	      {   
                         if(c==0){
		    	    	  c=1; 
			    	      continue;
			    	      };  
		    	      var jk=arrs[keys]
	    	         inner+= `<dd><a href="javascript:find(`+jk+`);">`+keys+`</a></dd>`
	    	      }
               }        
	 	   inner+= `</dl> </li> `	    	        	     
 		    	       }
              }
 		    $('#leftdao').prepend(inner);
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
 		error : function(){
 			 backdata="系统消息：网络故障与服务器失去联系";
 		 }
 	});
 	
 	  //返回对应所选栏目的内容
 	 	function find(id){
 		 var strvalue={
 		 		 "id": id,
 	    	     "page":"<%=pages%>", 
 	    	     "listnum": "10"
 	    	    }	
 	 	 $.ajax( {
 	 		// 提交数据的类型 POST GET
 	 		type : "POST",
 	 		// 提交的网址
 	 		url : basePath+"/Api/v1/?p=web/cms/articles/selectArticlesNameAdmin",
 	 		// 提交的数据
 	 		data : JSON.stringify(strvalue),
 	 		// 返回数据的格式
 	 		async : false,//不是同步的话 返回值娶不到
 	 		datatype : "json",// "xml", "html", "script", "json", "jsonp",
 	 		// "text".
 	 		// 成功返回之后调用的函数
 	 		success : function(data) {
 	 		     document.getElementById("tj").innerHTML="";
  	 		
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
 	 					
 	 					<td class="">`+jsonData.threads[i].addtime+`</td>
 	 					
 	 					<td class=""><a onclick="look(`+jsonData.threads[i].id+`)">预览</a></td>
 	 			      </tr>`
 	              } 
 	              var  page=jsonData.pages;
 	             
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
 									     	window.location.href="?ac=&val="+$('#search').val()+"&pag="+curr;
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