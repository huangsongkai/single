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
    <title>栏目管理</title> 
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
	<div id="tb" class="form_top layui-form" style="">
      <button class="layui-btn layui-btn-small layui-btn-primary" onclick="location.reload()"> <i class="layui-icon">ဂ</i>刷新</button>
        <button class="layui-btn layui-btn-small  layui-btn-primary "  onclick="newDistrbutor()" >新建栏目</button>
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
     <form action="program_management.jsp" method="post">
         <input type="hidden" id="test" name="test" value="123"/>
     </form>
    <table class="cuoz" id="table" data-toggle="table" data-show-toggle="true" data-show-columns="true" data-show-export="true" >
        <thead>
            <tr>
              <th data-field="栏目深度" data-sortable="true" data-filter-control="select" data-visible="true" >栏目标题</th>
              <th data-field="父级id"  data-sortable="true" data-filter-control="select" data-visible="true">发布人</th>
              <th data-field="排序"  data-sortable="true" data-filter-control="select" data-visible="true">审核人</th>
              <th data-field="栏目标题"  data-sortable="true" data-filter-control="select" data-visible="true">栏目深度</th>
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
      var AppId=$("#AppId").val();
	  var AppKey=$("#AppKey").val();
	  var Spc_token=$("#Spc_token").val();
	  var Suid=$("#Suid").val();
	  var uuid=$("#uuid").val();
      var Purl=basePath+"/Api/v1/?p=web/cms/classify/selectClassify";
     var strvalue={
    	     "page": "<%=pages%>", 
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
 	 		      var id=jsonData.threads[i].id;
 	 		      var depth=jsonData.threads[i].depth;
 	 		      var tp=jsonData.threads[i].name;
 		    	  var audit=jsonData.threads[i].auditperson;
	 		      var rp=findpeople(jsonData.threads[i].releasepeople);
	 		      var ap=findpeople(audit);	 		      
     document.getElementById("tj").innerHTML+=`<tr>			       
                    <td class="">`+tp+`</td>
 					<td class="">`+rp+`</td>
 					<td class="">`+ap+`</td>
 					<td class="">`+depth+`级</td>
 					<td class=""><a onclick="editDistrbutor(`+id+`)">编辑</a><a onclick="dect(`+id+`)">删除</a></td>
 			      </tr>`
              }
 		      var  page=jsonData.pages;}
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
      //显示拥有该栏目的人员
	function findpeople(ra){
		    var rult=""; 
        var strvalueid={
    	     "ids" : ra
    	    }
 	 $.ajax( {
 		// 提交数据的类型 POST GET
 		type : "POST",
 		// 提交的网址
 		url : basePath+"/Api/v1/?p=web/users/selectUserBydIds",
 		// 提交的数据
 		data : JSON.stringify(strvalueid),
 		// 返回数据的格式
 		async : false,//不是同步的话 返回值娶不到
 		datatype : "json",// "xml", "html", "script", "json", "jsonp",
 		// "text".
 		// 成功返回之后调用的函数
 		success : function(datas){						 							 		
 		      jsonDatas=eval("("+datas+")"); 
 		     if(jsonData.success){ 
 		      rult=jsonDatas.threads;}
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
     	if(rult==undefined){rult="";}
	 	return rult;
	      }
    function ac_tion(ac){
			     if(ac=="search"){//搜索
			       window.location.href="?ac="+ac+"&val="+$('#search').val()+"";
			     }
			 }  
    function newDistrbutor(){
    	layer.open({
		  type: 2,
		  title: '新建栏目',
		  shadeClose: true,
		  maxmin:1,
		  offset:'t',
		  shade: 0.5,
		  area: ['940px', '100%'],
		  content: 'new_information_class.jsp' 
		});
    }
     function editDistrbutor(id){
		layer.open({
		 type: 2,
		  title: '编辑栏目',
		  shadeClose: true,
		  offset:'t',
		  maxmin:1,
		  shade: 0.5,
		  area: ['940px', '100%'],
		  content: 'edit_information_class.jsp?id='+id 
		});
    } 
    function dect(id){
    	var AppId=$("#AppId").val();
		  var AppKey=$("#AppKey").val();
		  var Spc_token=$("#Spc_token").val();
		  var Suid=$("#Suid").val();
		  var uuid=$("#uuid").val();
		 		    var strvaluename={
		 		    		 "id" : id
				    	    }
		 		    $.ajax( {
				 		// 提交数据的类型 POST GET
				 		type : "POST",
				 		// 提交的网址
				 		url : basePath+"/Api/v1/?p=web/cms/articles/selectArticlesByTwoId",
				 		// 提交的数据
				 		data : JSON.stringify(strvaluename),
				 		// 返回数据的格式
				 		async : false,//不是同步的话 返回值娶不到
				 		datatype : "json",// "xml", "html", "script", "json", "jsonp",
				 		// "text".
				 		// 成功返回之后调用的函数
				 		success : function(data){
				 		     jsonData=eval("("+data+")");
				 		       
				 		    if(jsonData.threads[0].id==1){
				 		    	layer.msg('该栏目被使用，不可删除！！！');
					 		   }else if(jsonData.threads[0].id==0){
					 			  deletet(id); 
						 	   }else if(jsonData.threads[0].id==11){
						 		  layer.msg('该栏目的子级被使用，不可删除！！！');
						 	   }
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
    function deletet(id){
    	layer.confirm("确认要删除吗，删除后不能恢复", { title: "删除确认" }, function (index) {  
            layer.close(index);  
            var curWwwPath = window.document.location.href;
		    var pathName = window.document.location.pathname;
		    var pos = curWwwPath.indexOf(pathName);
		    var localhostPath = curWwwPath.substring(0, pos);
		    var projectName = pathName.substring(0, pathName.substr(1).indexOf('/') + 1);
		    var basePath=localhostPath+projectName+"/";		    
		    var uid = '<%=Suid%>';
		  	var token = '<%=Spc_token%>';
		  	var strvalue={
		    	         "id":id
		    	    }
		  	$.ajax({  
		  	    headers : {
		  		"Content-type" : "application/json",
	 			"X-AppId" : AppId,
	 			"X-AppKey" : AppKey,
	 			"Token" : Spc_token,
	 			"X-USERID": Suid,
	 			"X-UUID": uuid,
			    },
		         type : "post",  
		          url : basePath+"/Api/v1/?p=web/cms/classify/delClassify",
		          data : JSON.stringify(strvalue),  
		          success : function(data){  
		          var datas = eval('(' + data + ')');
	                    layer.alert(datas.msg, {  
	                        title: "删除操作",  
	                        btn: ['确定']  
	                    },  
	                        function (index, item) {  
	                            //layer.close(index);  
	                            location.reload();  
	                        });  
		          }  
	     }); 
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