<%@ page trimDirectiveWhitespaces="true" %>
<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@page import="service.dao.db.Page"%>
<%@include file="../../cookie.jsp"%>
<%@page import="org.apache.commons.lang3.StringUtils"%>

<html>
<head> 
    <meta charset="utf-8"> 
    <meta name="viewport" content="width=device-width, initial-scale=1"> 
     <link rel="stylesheet" href="../../../pages/css/sy_style.css?22">	    
	    <link rel="stylesheet" href="../../js/layui2/css/layui.css">
		<script type="text/javascript" src="../../js/jquery-1.9.1.js" ></script>
		<script src="../../js/layui2/layui.js"></script>
		<script type="text/javascript" src="../../js/tableExport/js/table-sort.js" ></script><!--表格排序js  css-->
		<script type="text/javascript" chartset="utf8" src="../../js/tableExport/js/table_list.js " ></script><!--表格导出js  css-->
	 <script type="text/javascript" src="../../../custom/jquery.easyui.min.js"></script>
    <title>用户管理</title> 
    <style type="text/css">
		th { background-color: white;}
	    td { background-color: white;}
	    .btn-group-vertical>.btn, .btn-group>.btn{height:33px;}
	    .layui-layer-content{padding:20px;}
	    .layui-layer-btn{text-align:center;}
	</style>
 </head> 
<body >
       <div class="" style="padding-bottom: 0px;margin-left: 1%;margin-right: 1%; height:auto;">  
	<div id="tb" class="form_top layui-form"  style="display: flex;"><br>
       <br><input id="search" type="text" class="layui-input textbox-text" placeholder="请输入姓名或手机号">
	           <div class="layui-inline">
			        	<label class="layui-form-label"></label>
			        	<div class="layui-input-inline">
			        		<select name="usertype" id="usertype">
			        			<option value="0">全部</option>
			        			<option value="1">教职工</option>
			        			<option value="2">学生</option>
			        			<option value="3">家长</option>
			        			<option value="4">管理员</option>
			        		</select>
			        	</div>
			        </div>
        <button class="layui-btn "  onclick="ac_tion('search')">搜索</button>
        <button class="layui-btn " onclick="location.reload()" > 刷新</button>
        <button class="layui-btn  " onclick="newup_user()" >新增用户</button>
          <button class="layui-btn "  id="batchDelr" > 批量删除</button>
        	<%
		       	//获取文件后面的对象 数据
		       	String search_val = request.getParameter("val"); 
        		String search_role =  request.getParameter("usertype"); 
        		if(search_role==null){search_role="";}
		       	if(search_val==null){search_val="";}else{search_val=search_val.replaceAll("\\s*", "");}
		       	search_val = new Page().mysqlCode(search_val);//防止sql注入
				search_val=search_val.replaceAll(" ","");
				
				//查询的字段局部语句
		 		String search="where 1=1 ";
		 		if(search_val.length()>=1){
		 			search= search+" and t.username like '%"+search_val+"%' or t.usermob like '%"+search_val+"%'";
		 		}
		 		if(search_role.length()>0&&!search_role.equals("0")){
		 			search= search+" and t.userole="+search_role;
		 		}
		 		//计算出总页数
				String zpag_sql="select count(t.uid)  row from user_worker t   "+search;
				int zpag= db.Row(zpag_sql);					
				
				//当前页数
		       	String pag = request.getParameter("pag");  	if(pag==null){pag="1";}
		       	int pages=Integer.parseInt(pag);
		       	
		        //当前页条数
		       	String limit = request.getParameter("limit"); if(limit==null){limit="10";}
		       	int limits=Integer.parseInt(limit);
		       	
		        String bank_sql= "SELECT 	uid,nickname, username, sex, usermob, email, add_time, state,userole FROM  user_worker t "+search+"  limit "+(pages-1)*limits+","+limits+";";

				String html_str = "";
				StringBuffer sb = new StringBuffer();
            		ResultSet customerPrs = db.executeQuery(bank_sql);
            		while(customerPrs.next()){
            			String sex="";
			          	if(customerPrs.getInt("sex")==1){ sex="男";}else{sex="女";}
			          	String userole = "";
			          	switch(customerPrs.getInt("userole")){
			          	case 1:
			          		userole ="教职工" ;break;
			          	case 2:
			          		userole ="学生" ;break;	
			          	case 3:
			          		userole ="家长" ;break;	
			          	case 4:
			          		userole ="管理员" ;break;
			          	 default: userole="无"; break;
			          	}
                     	
            			html_str = "<tr id='"+customerPrs.getString("uid")+"'>"
   							+"<td ><input type='checkbox' name='' lay-skin='primary'></td> "
   							+"<td class=\"\">"+ customerPrs.getString("nickname") +"</td>          "
   							+"<td class=\"\">"+customerPrs.getString("username")+"</td>          "
   							+"<td class=\"\">"+sex +"</td>          "
   							+"<td class=\"\">"+customerPrs.getString("usermob") +"</td>          "
   							+"<td class=\"\">"+userole +"</td>          "
   							+"<td class=\"\">"+customerPrs.getString("email")+"</td>          "
   							+"<td class=\"\">"+customerPrs.getString("add_time") +"</td>          "
   							+"<td class=\"\"><a onclick=\"edit("+customerPrs.getString("uid")+")\">编辑</a> <a onclick=\"delete_class("+customerPrs.getString("uid")+")\">删除</a>"+"</td> "
						+"</tr>"; 
						sb.append(html_str);
            		}if(customerPrs!=null){customerPrs.close();}
		         %>
		    </div>
    <table class="cuoz" id="table" data-toggle="table" data-show-toggle="true" data-show-columns="true" data-show-export="true"  >
           <thead>
		            <tr>
		             	<th data-field="state"   data-checkbox="true"><input type="checkbox" name="" ></th>
		              	<th data-field="用户昵称"  data-sortable="true" data-filter-control="select"  data-visible="true">用户昵称</th>
		              	<th data-field="用户姓名"  data-sortable="true" data-filter-control="select"  data-visible="true">用户姓名</th>
		              	<th data-field="用户性别"  data-sortable="true" data-filter-control="select"  data-visible="true">用户性别</th>
		              	<th data-field="手机号码"  data-sortable="true" data-filter-control="select"  data-visible="true">手机号码</th>
		              	<th data-field="用户类型"  data-sortable="true" data-filter-control="select"  data-visible="true">用户类型</th>
		               	<th data-field="email "  data-sortable="true" data-filter-control="select"  data-visible="false">email</th>
		                <th data-field="创建时间"  data-sortable="true" data-filter-control="select"  data-visible="false">创建时间</th>
		              	<th data-field="操作"     data-sortable="true" data-filter-control="select"  data-visible="true">操作</th>
		            </tr>
		        </thead>
          <tbody>
          	<%=sb.toString()%>
        </tbody>
      </table>
         <div id="pages"  style="float: right;"></div>
         </div>
    <script type="text/javascript">
    
	var search_val='<%=search_val%>';
	var search_role='<%=search_role%>';
	search_val=search_val.replace(/(^\s*)|(\s*$)/g, "");//处理空格
	
	if(search_val.length>=1){
		modify('search',search_val);
	}
	if(search_role.length>=1){
		modify('usertype',search_role);
	}
	//改变某个id的值
	function modify (id,search_val){
		$("#"+id+"").val(""+search_val+"");
	}

	 //清空 搜索输入框
	function Refresh(){
		$("#search").val("");
	} 
    //执行
    function ac_tion() {
	       window.location.href="?ac=&val="+$('#search').val()+"&usertype="+$('#usertype').val();
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
							     	 window.location.href="?ac=&val="+$('#search').val()+"&usertype="+$('#usertype').val()+"&pag="+curr+"&limit="+limit;
						    }
				      }
			    });
		});

	$("#batchDelr").click(function(){
		var ids ="";
		$('tbody').find('.selected').each(function(){
			ids = ids + $(this).attr("id") +",";
		})
		if(ids==''){
			layer.msg('请至少选择一行');
			return false;
		}
		ids = ids.substring(0,ids.length-1);
		layer.confirm("确认要删除吗，删除后不能恢复", { title: "删除确认" }, function (index) { 
            layer.close(index);
            window.location.href="?ac=deletet&id="+ids+"";   						 
        }); 
});
	
    //删除操作
    function delete_class(id){
    	layer.confirm("确认要删除吗，删除后不能恢复", { title: "删除确认" }, function (index) { 
            layer.close(index);
            window.location.href="?ac=deletet&id="+id+"";   						 
        }); 
    }

    function newup_user(){
		layer.open({
		  type: 2,
		  title: '新建报件',
		  maxmin:1,
		  shade: 0.5,
		  area: ['100%', '100%'],
		  content: 'new_user.jsp' 
		}); 
     }
	 
	 function edit(val) {//编辑 
		 layer.open({
			  type: 2,
			  title: '编辑用户信息',
			  shadeClose: true,
			  maxmin:1,
			  shade: 0.5,
			  area: ['100%', '100%'],
			  content: 'edit.jsp?uid='+val
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
//删除操作
if("deletet".equals(ac)){ 
	 String ids=request.getParameter("id");
	 String dsql = "";
	 boolean delState =  false;
	 if(ids==null){ids="";}
	try{
		String[]  id = ids.split(",");
		for(int i=0;i<id.length;i++){
	   		 dsql="DELETE FROM user_worker WHERE uid='"+id[i]+"';";
	   		 System.out.println(dsql);
	   		delState = db.executeUpdate(dsql);
		}
	   if(delState){
		   out.println("<script>parent.layer.msg('删除成功');window.location.replace('./userInfo.jsp');</script>");
	   }
	   else{
		   out.println("<script>parent.layer.msg('删除失败');</script>");
	   }
	 }catch (Exception e){
	    out.println("<script>parent.layer.msg('删除失败');</script>");
	    return;
	 }
	//关闭数据与serlvet.out
	if (page != null) {page = null;}
}%>
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