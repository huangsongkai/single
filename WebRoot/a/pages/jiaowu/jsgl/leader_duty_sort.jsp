<%@ page trimDirectiveWhitespaces="true" %>
<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@page import="service.dao.db.Page"%>
<%@include file="../../cookie.jsp"%>

<html>
<head> 
    <meta charset="utf-8"> 
    <meta name="viewport" content="width=device-width, initial-scale=1"> 
     <link rel="stylesheet" href="../../../pages/css/sy_style.css?22">	    
	    <link rel="stylesheet" href="../../js/layui2/css/layui.css">
		<script type="text/javascript" src="../../js/jquery-1.9.1.js" ></script><!--通用jquery-->
		<script src="../../js/layui2/layui.js"></script>
		<script type="text/javascript" src="../../js/tableExport/js/table-sort.js" ></script><!--表格排序js  css-->
		<script type="text/javascript" chartset="utf8" src="../../js/tableExport/js/table_list.js " ></script><!--表格导出js  css-->
	 <script type="text/javascript" src="../../../custom/jquery.easyui.min.js"></script>
 <link rel="stylesheet" href="../../../custom/easyui/tree.css" />
    <title>领导职务</title> 
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
       <div class="" style="padding-bottom: 0px;margin-left: 1%;margin-right: 1%; height:auto;">  
	<div id="tb" class="form_top layui-form"  style="display: flex;"><br>
       <br><input id="search" type="text" class="layui-input textbox-text" placeholder="请输入类别">
        <button class="layui-btn "  onclick="ac_tion('search')">搜索</button>
        <button class="layui-btn " onclick="location.reload()" > 刷新</button>
<!--        <button class="layui-btn " >删除</button>-->
        <button class="layui-btn "  onclick="newDistrbutor()" >新建领导职务</button>
        	<%
		       	//获取文件后面的对象 数据
		       	String search_val = request.getParameter("val"); 
		       	if(search_val==null){search_val="";}else{search_val=search_val.replaceAll("\\s*", "");}
		       	search_val = new Page().mysqlCode(search_val);//防止sql注入
				search_val=search_val.toUpperCase();
				search_val=search_val.replaceAll(" ","");
				
				//查询的字段局部语句
		 		String search="";
		 		if(search_val.length()>=1){
		 			search="where dutiesname like '%"+search_val+"%'";
		 		}else{
		 			search = "where 1=1";
		 		}
		 		//计算出总页数
				String zpag_sql="select count(t.id)  row from teacher_duties t   "+search;
				int zpag= db.Row(zpag_sql);					
				
				//当前页数
		       	String pag = request.getParameter("pag");  	if(pag==null){pag="1";}
		       	int pages=Integer.parseInt(pag);
		       	
		        //当前页条数
		       	String limit = request.getParameter("limit"); if(limit==null){limit="10";}
		       	int limits=Integer.parseInt(limit);
		       	
		        String bank_sql= "select t.*  from teacher_duties t  "+search+"  limit "+(pages-1)*limits+","+limits+";";

		        System.out.println(bank_sql);
				String html_str = "";
		        ArrayList<String> list  = new ArrayList<String>();
            		ResultSet groups = db.executeQuery(bank_sql);
            		while(groups.next()){
            			html_str = "<tr>"
   							+"<td class=\"\">"+groups.getString("dutiesname") +"</td>          "
   							+"<td class=\"\">"+groups.getString("dutiescode")+"</td>         "
   							+"<td class=\"\"> <a onclick=\"editBank("+groups.getString("id")+")\">编辑</a><a onclick=\"deletet("+groups.getString("id")+")\">删除</a>"+"</td> "
						+"</tr>"; 
            			 list.add(html_str);
            		}if(groups!=null){groups.close();}
		         %>
		    </div>
    <table class="cuoz" id="table" data-toggle="table" data-show-toggle="true" data-show-columns="true" data-show-export="true" >
        <thead>
            <tr>
              <th data-field="职务名称"     data-sortable="true" data-filter-control="select" data-visible="true" >职务名称</th>
              <th data-field="职务编码"     data-sortable="true" data-filter-control="select" data-visible="true" >职务编码</th>
              <th data-field="操作" data-sortable="true" data-filter-control="select" data-visible="true" >操作</th>
            </tr>
          </thead>
          <tbody>
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
    //执行
    function ac_tion() {
	       window.location.href="?ac=&val="+$('#search').val()+"";
	} 

    layui.use(['laypage', 'layer'], function(){
		  var laypage = layui.laypage
		  ,layer = layui.layer;

				//完整功能----分页
			    laypage.render({
				      elem: 'pages'
				      ,count: <%=zpag%>//总页数
				      ,curr:  <%=pages%>//当前页数
				      ,limit:  <%=limits%>//当前页条数 
				      ,layout: ['count', 'prev', 'page', 'next','limit','skip']
				      ,jump: function(obj){
				    	  var curr = obj.curr;//当前页数
				    	  var limit = obj.limit;//每页条数 
						    if(curr!=<%=pages%> || limit!=<%=limits%>){//防止死循环 
							     	 window.location.href="?ac=&val="+$('#search').val()+"&pag="+curr+"&limit="+limit;
						    }
				      }
			    });
		});
	    
    
    function newDistrbutor(){
    	layer.open({
		 type: 2,
		  title: '新建领导职务',
		  maxmin:1,
		  shade: 0.5,
		  offset: 't',
		  area: ['940px', '100%'],
		  content: 'new_leader_duty_sort.jsp' 
		});
    }
    
  
     function editBank(id){
		layer.open({
		 type: 2,
		  title: '编辑领导职务',
		  maxmin:1,
		  shade: 0.5,
		  offset: 't',
		  area: ['940px', '100%'],
		  content: 'edit_leader_duty_sort.jsp?id='+id 
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
			            "X-AppId":"8381b915c90c615d66045e54900feeab",// 标明正在运行的是哪个App程序
			            "X-AppKey":"72393aaa69c41a24d0d40e851301647a",// 授权鉴定终端
			            "Token":""+token+"",// 授权鉴定终端
			            "X-UUID":"pc",
			            "X-Mdels":"pc",
				    },
			         type : "post",  
			          url : basePath+"/Api/v1/?p=web/do/doDelTeacher",
			          data : { id: id,table:"teacher_duties"},  
			          success : function(data){  
			          var datas = eval('(' + data + ')');
		                    layer.alert(datas.msg, {  
		                        title: "删除操作",  
		                        btn: ['确定']  
		                    },  
		                        function (index, item) {  
		                            location.reload();  
		                        });  
			          }  
		     }); 
            }); 
    }    
    
    layui.use(['form', 'layedit', 'laydate'], function(){
		  var form = layui.form
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
int   TagMenu=db.Row("SELECT COUNT(*) as row FROM  menu_worker  WHERE sysmenuid='"+PMenuId+"' and  workerid='"+Suid+"' and  companyid='"+Scompanyid+"'");
if(TagMenu==0){
  db.executeUpdate("INSERT INTO `menu_worker`(`sysmenuid`,`workerid`,`countes`,`companyid`) VALUES ('"+PMenuId+"','"+Suid+"','1','"+Scompanyid+"');"); 
}else{
 db.executeUpdate("UPDATE  `menu_worker` SET `countes`=countes+1,`usetime`=now() WHERE  sysmenuid='"+PMenuId+"' and  workerid='"+Suid+"' and  companyid= '"+Scompanyid+"'");
}
 %>
<% 
if(db!=null)db.close();db=null;if(server!=null)server=null;%>