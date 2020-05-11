<%@ page trimDirectiveWhitespaces="true" %>
<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@page import="service.dao.db.Page"%>
<%@include file="../../cookie.jsp"%>
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
 <script type="text/javascript" src="../../../custom/jquery.easyui.min.js"></script>
 <link rel="stylesheet" href="../../../custom/easyui/tree.css" />
    <title>经销商配置</title> 
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
       <input type="text" class="layui-input textbox-text" placeholder="" style="" id="search">
        <button class="layui-btn layui-btn-small  layui-btn-primary"  onclick="ac_tion('search')"> <i class="layui-icon"></i> 搜索</button>
        <button class="layui-btn layui-btn-small layui-btn-primary" onclick="location.reload()"> <i class="layui-icon">ဂ</i>刷新</button>
<!--        <button class="layui-btn layui-btn-small  layui-btn-primary" >删除</button>-->
        <button class="layui-btn layui-btn-small  layui-btn-primary "  onclick="newDistrbutor()" >新建经销商</button>
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
             <th data-field="state"  data-checkbox="true"><input type="checkbox" name="" ></th>
              <th data-field="编号"     data-sortable="true" data-filter-control="select" data-visible="true" >编号</th>
              <th data-field="名称"     data-sortable="true" data-filter-control="select" data-visible="true" >名称</th>
              <th data-field="法人"  data-sortable="true" data-filter-control="select" data-visible="true">法人</th>
              <th data-field="区域"  data-sortable="true" data-filter-control="select" data-visible="true">区域</th>
              <th data-field="备注"  data-sortable="true" data-filter-control="select" data-visible="true">备注</th>
              <th data-field="生效时间"  data-sortable="true" data-filter-control="select" data-visible="true">生效时间</th>
              <th data-field="操作" data-sortable="true" data-filter-control="select" data-visible="true" >操作</th>
            </tr>
          </thead>
          <tbody>
          <%
		        	
		        String distrbutor_sql= "select t.*,t1.regionalname  from g_distributor t,s_regional_table t1 where t.regioncode = t1.regionalcode "+search+" limit  "+(pages-1)*10+",10;";
		        System.out.println(distrbutor_sql);	
          		ResultSet groups = db.executeQuery(distrbutor_sql);
          		int i = 1;
          		while(groups.next()){
           %>
          <tr>
	        <td ><input type="checkbox" name="" lay-skin="primary"></td>
	        <td class="" ><%=i %></td>
			<td class=""><%=groups.getString("name") %></td>
			<td class=""><%=groups.getString("legalperson") %></td>
			<td class=""><%=groups.getString("regionalname") %></td>
			<td class=""><%=groups.getString("common") %></td>
			<td class=""><%=groups.getString("implementdate") %></td>
			<td class=""><a onclick="lookDistrbutor(<%=groups.getString("id") %>)">查看</a><a onclick="editDistrbutor(<%=groups.getString("id") %>)">编辑</a><a onclick="deletet(<%=groups.getString("id") %>)">删除</a></td>
	      </tr>
	      <%i++;} %>
	      
        </tbody>
      </table>
      <div id="pages"  style="float: right;"></div>
  </div>    
    <script type="text/javascript">
    
     function ac_tion(ac) {
		     
			     if(ac=="search"){//搜索
			       window.location.href="?ac="+ac+"&val="+$('#search').val()+"";
			     }
			 }
    
    function newDistrbutor(){
    	layer.open({
		 type: 2,
		  title: '新建经销商',
		  shadeClose: true,
		  maxmin:1,
		  shade: 0.5,
		  area: ['940px', '440px'],
		  content: 'new_distrbutor.jsp' 
		});
    }
    
    function lookDistrbutor(id){
		layer.open({
		 type: 2,
		  title: '查看经销商',
		  shadeClose: true,
		  maxmin:1,
		  shade: 0.5,
		  area: ['980px', '440px'],
		  content: 'detail_distrbutor.jsp?id='+id 
		});
		
    }
  
     function editDistrbutor(id){
		layer.open({
		 type: 2,
		  title: '编辑经销商',
		  shadeClose: true,
		  maxmin:1,
		  shade: 0.5,
		  area: ['940px', '440px'],
		  content: 'edit_distrbutor.jsp?id='+id 
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
			  	$.ajax({  
			  	    headers : {
			            "X-USERID":""+uid+"",
			            "Content-Type":"multipart/form-data",
			            "X-AppId":"d42b46df6e583ca9a1b3e819dc42cfak",// 标明正在运行的是哪个App程序
			            "X-AppKey":"23548ad081d91ca0bdc66b22ca59cfc6",// 授权鉴定终端
			            "Token":""+token+"",// 授权鉴定终端
			            "X-UUID":"pc",
			            "X-Mdels":"pc",
				    },
			         type : "post",  
			          url : basePath+"/Api/v1/?p=web/do/doDelDistrbutor",
			          data : { id: id},  
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
    
    layui.use(['form', 'layedit', 'laydate'], function(){
		  var form = layui.form()
		  ,layer = layui.layer
		  ,layedit = layui.layedit
		  ,laydate = layui.laydate;
			form.render(); 
	});     
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