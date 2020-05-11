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
    <title>警务考核</title> 
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
       <br><input id="search" type="text" class="layui-input textbox-text" placeholder="请输入名称">
        <button class="layui-btn "  onclick="ac_tion('search')">搜索</button>
        <button class="layui-btn " onclick="location.reload()" > 刷新</button>
<%--        	<%--%>
<%--		       	//获取文件后面的对象 数据--%>
<%--		       	String search_val = request.getParameter("val"); --%>
<%--		       	if(search_val==null){search_val="";}else{search_val=search_val.replaceAll("\\s*", "");}--%>
<%--		       	search_val = new Page().mysqlCode(search_val);//防止sql注入--%>
<%--				search_val=search_val.toUpperCase();--%>
<%--				search_val=search_val.replaceAll(" ","");--%>
<%--				--%>
<%--				//查询的字段局部语句--%>
<%--		 		String search="";--%>
<%--		 		if(search_val.length()>=1){--%>
<%--		 			search="where t.stuname like '%"+search_val+"%'";--%>
<%--		 		}else{--%>
<%--		 			search = "where 1=1";--%>
<%--		 		}--%>
<%--		 		//计算出总页数--%>
<%--				String zpag_sql="select count(t.id)  row from student_regist_management t   "+search;--%>
<%--				int zpag= db.Row(zpag_sql);					--%>
<%--				--%>
<%--				//当前页数--%>
<%--		       	String pag = request.getParameter("pag");  	if(pag==null){pag="1";}--%>
<%--		       	int pages=Integer.parseInt(pag);--%>
<%--		       	--%>
<%--		        //当前页条数--%>
<%--		       	String limit = request.getParameter("limit"); if(limit==null){limit="10";}--%>
<%--		       	int limits=Integer.parseInt(limit);--%>
<%--		       	--%>
<%--		        String bank_sql= "select t.*  from student_regist_management  t "+search+"  limit "+(pages-1)*limits+","+limits+";";--%>
<%----%>
<%--				String html_str = "";--%>
<%--		        ArrayList<String> list  = new ArrayList<String>();--%>
<%--            		ResultSet groups = db.executeQuery(bank_sql);--%>
<%--            		while(groups.next()){--%>
<%--            			html_str = "<tr>"--%>
<%--   							+"<td class=\"\">"+groups.getString("student_id") +"</td>          "--%>
<%--   							+"<td class=\"\">"+groups.getString("academic_year") +"</td>          "--%>
<%--   							+"<td class=\"\">"+groups.getString("regist_sign") +"</td>          "--%>
<%--   							+"<td class=\"\">"+groups.getString("arrears") +"</td>          "--%>
<%--   							+"<td class=\"\">"+groups.getString("refund_sign") +"</td>          "--%>
<%--   							+"<td class=\"\">"+groups.getString("arrears_sign") +"</td>          "--%>
<%--   							+"<td class=\"\">"+groups.getString("order_num") +"</td>          "--%>
<%--   							+"<td class=\"\">"+groups.getString("pay_times") +"</td>          "--%>
<%--   							+"<td class=\"\">"+groups.getString("charge_standard") +"</td>          "--%>
<%--   							+"<td class=\"\">"+groups.getString("pay_date") +"</td>          "--%>
<%--   							+"<td class=\"\"> <a onclick=\"editBank("+groups.getString("id")+")\">编辑</a><a onclick=\"deletet("+groups.getString("id")+")\">删除</a>"+"</td> "--%>
<%--						+"</tr>"; --%>
<%--            			 list.add(html_str);--%>
<%--            		}if(groups!=null){groups.close();}--%>
<%--		         %>--%>
		    </div>
    <table class="cuoz" id="table" data-toggle="table" data-show-toggle="true" data-show-columns="true" data-show-export="true" >
        <thead>
            <tr>
              <th data-field="姓名"     data-sortable="true" data-filter-control="select" data-visible="true" >姓名</th>
              <th data-field="班级"     data-sortable="true" data-filter-control="select" data-visible="true" >班级</th>
              <th data-field="表彰奖励加分"     data-sortable="true" data-filter-control="select" data-visible="true" >表彰奖励加分</th>
              <th data-field="其他情况加分"     data-sortable="true" data-filter-control="select" data-visible="true" >其他情况加分</th>
              <th data-field="违规违纪减分"     data-sortable="true" data-filter-control="select" data-visible="true" >违规违纪减分</th>
              <th data-field="其他情况减分"     data-sortable="true" data-filter-control="select" data-visible="true" >其他情况减分</th>
              <th data-field="备注"     data-sortable="true" data-filter-control="select" data-visible="true" >备注</th>
              <th data-field="操作" data-sortable="true" data-filter-control="select" data-visible="true" >操作</th>
            </tr>
          </thead>
          <tbody>
          	<tr>
          		<td>张三</td>
          		<td>计算机网络</td>
          		<td>10.0</td>
          		<td>0</td>
          		<td>0</td>
          		<td>0</td>
          		<td>无</td>
          		<td><a >编辑</a><a >删除</a></td>
          	</tr>
          	<tr>
          		<td>李四</td>
          		<td>计算机网络</td>
          		<td>4.0</td>
          		<td>2</td>
          		<td>2</td>
          		<td>3</td>
          		<td>无</td>
          		<td><a >编辑</a><a >删除</a></td>
          	</tr>
          	<tr>
          		<td>赵四</td>
          		<td>计算机网络</td>
          		<td>10.0</td>
          		<td>4</td>
          		<td>0</td>
          		<td>0</td>
          		<td>表现优秀</td>
          		<td><a >编辑</a><a >删除</a></td>
          	</tr>
          	<tr>
          		<td>谢飞机</td>
          		<td>飞机班</td>
          		<td>10.0</td>
          		<td>3</td>
          		<td>0</td>
          		<td>0</td>
          		<td>666</td>
          		<td><a >编辑</a><a >删除</a></td>
          	</tr>
        </tbody>
      </table>
         <div id="pages"  style="float: right;"></div>
         </div>
    <script type="text/javascript">
<%--	var search_val='<%=search_val%>';--%>
<%--	search_val=search_val.replace(/(^\s*)|(\s*$)/g, "");//处理空格--%>
<%--	--%>
<%--	if(search_val.length>=1){--%>
<%--		modify('search',search_val);--%>
<%--	}--%>
<%--	//改变某个id的值--%>
<%--	function modify (id,search_val){--%>
<%--		$("#"+id+"").val(""+search_val+"")--%>
<%--	}--%>
<%----%>
<%--	 //清空 搜索输入框--%>
<%--	function Refresh(){--%>
<%--		$("#search").val("");--%>
<%--	} --%>
<%--    //执行--%>
<%--    function ac_tion() {--%>
<%--	       window.location.href="?ac=&val="+$('#search').val()+"";--%>
<%--	} --%>
<%----%>
<%--    layui.use(['laypage', 'layer'], function(){--%>
<%--		  var laypage = layui.laypage--%>
<%--		  ,layer = layui.layer;--%>
<%--				//完整功能----分页--%>
<%--			    laypage.render({--%>
<%--				      elem: 'pages'--%>
<%--				      ,count: <%=zpag%>//总页数--%>
<%--				      ,curr:  <%=pages%>//当前页数--%>
<%--				      ,limit:  <%=limits%>//当前页条数 --%>
<%--				      ,layout: ['count', 'prev', 'page', 'next','limit','skip']--%>
<%--				      ,jump: function(obj){--%>
<%--				    	  var curr = obj.curr;//当前页数--%>
<%--				    	  var limit = obj.limit;//每页条数 --%>
<%--						    if(curr!=<%=pages%> || limit!=<%=limits%>){//防止死循环 --%>
<%--							     	 window.location.href="?ac=&val="+$('#search').val()+"&pag="+curr+"&limit="+limit;--%>
<%--						    }--%>
<%--				      }--%>
<%--			    });--%>
<%--		});--%>
	    
    
    function newDistrbutor(){
        return;
    	layer.open({
		 type: 2,
		  title: '新建培养层次',
		  maxmin:1,
		  shade: 0.5,
		  offset: 't',
		  area: ['940px', '100%'],
		  content: 'new_student_syn.jsp'
		});
    }
    
     function editBank(id){
         return;
		layer.open({
		 type: 2,
		  title: '编辑培养层次',
		  maxmin:1,
		  shade: 0.5,
		  offset: 't',
		  area: ['940px', '100%'],
		  content: 'edit_student_syn.jsp?id='+id 
		});
    } 
    
    function deletet(id){
        return;
  layer.confirm("确认要删除吗，删除后不能恢复", { title: "删除确认" }, function (index) {  
	  		return;
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
			         //TODO
			          url : basePath+"/Api/v1/?p=web/do/doDelTeacher",
			          data : { id: id,table:"jz_culture_level"},  
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