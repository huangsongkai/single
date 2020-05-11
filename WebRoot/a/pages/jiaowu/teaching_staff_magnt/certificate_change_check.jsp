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
    <title>证书审核</title> 
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
       <br><input id="search" type="text" class="layui-input textbox-text" placeholder="请输入姓名">
        <button class="layui-btn "  onclick="ac_tion('search')">搜索</button>
        <button class="layui-btn " onclick="location.reload()" > 刷新</button>
          <button class="layui-btn "  id="batchDelr" > 批量审核</button>
        	<%
		       	//获取文件后面的对象 数据
		       	String search_val = request.getParameter("val"); 
		       	if(search_val==null){search_val="";}else{search_val=search_val.replaceAll("\\s*", "");}
		       	search_val = new Page().mysqlCode(search_val);//防止sql注入
				search_val=search_val.replaceAll(" ","");
				
				//查询的字段局部语句
		 		String search="where t.teacherid!=0 and teacherid is not null";
		 		if(search_val.length()>=1){
		 			search= search+" and t.name like '%"+search_val+"%'";
		 		}
		 		//计算出总页数
				String zpag_sql="select count(t.id)  row from person_certificate_change t   "+search;
				int zpag= db.Row(zpag_sql);					
				
				//当前页数
		       	String pag = request.getParameter("pag");  	if(pag==null){pag="1";}
		       	int pages=Integer.parseInt(pag);
		       	
		        //当前页条数
		       	String limit = request.getParameter("limit"); if(limit==null){limit="10";}
		       	int limits=Integer.parseInt(limit);
		       	
		        String bank_sql= "SELECT t.*,t1.teacher_name,teacher_number  FROM  person_certificate_change t left join teacher_basic t1 on t.teacherid=t1.id  "+search+"  limit "+(pages-1)*limits+","+limits+";";
				String html_str = "";
				StringBuffer sb = new StringBuffer();
            		ResultSet customerPrs = db.executeQuery(bank_sql);
            		while(customerPrs.next()){
                     	if(customerPrs.getString("teacherid").equals("0")||StringUtils.isBlank(customerPrs.getString("teacherid"))){
                     		continue;
                     	}
                     	String btn ="";
                     	if(customerPrs.getString("examine").equals("1")){
                     		btn = "<a onclick=\"delete_class("+customerPrs.getString("id")+")\">审核</a>";
                     	}else{
                     		btn ="审核已通过";
                     	}
                     	
            			html_str = "<tr id='"+customerPrs.getString("id")+"'>"
   							+"<td ><input type='checkbox' name='' lay-skin='primary'></td> "
   							+"<td class=\"\">"+ customerPrs.getString("name") +"</td>          "
   							+"<td class=\"\">["+ customerPrs.getString("teacher_number")+"]"+ customerPrs.getString("teacher_name") +"</td>          "
   							+"<td class=\"\">"+customerPrs.getString("cer_name") +"</td>          "
   							+"<td class=\"\">"+customerPrs.getString("cer_type") +"</td>          "
   							+"<td class=\"\">"+customerPrs.getString("cer_num") +"</td>          "
   							+"<td class=\"\">"+customerPrs.getString("cer_date") +"</td>          "
   							+"<td class=\"\">"+customerPrs.getString("cer_address") +"</td>          "
   							+"<td class=\"\">"+btn+"</td> "
						+"</tr>"; 
						sb.append(html_str);
            		}if(customerPrs!=null){customerPrs.close();}
		         %>
		    </div>
    <table class="cuoz" id="table" data-toggle="table" data-show-toggle="true" data-show-columns="true" data-show-export="true"  >
           <thead>
		            <tr>
		             	<th data-field="state"   data-checkbox="true"><input type="checkbox" name="" ></th>
		              	<th data-field="姓名"  data-sortable="true" data-filter-control="select"  data-visible="true">姓名</th>
		              	<th data-field="教师"  data-sortable="true" data-filter-control="select"  data-visible="true">教师</th>
		              	<th data-field="证书名称"  data-sortable="true" data-filter-control="select"  data-visible="true">证书名称</th>
		              	<th data-field="证书类型"  data-sortable="true" data-filter-control="select"  data-visible="true">证书类型</th>
		              	<th data-field="证书编号"  data-sortable="true" data-filter-control="select"  data-visible="true">证书编号</th>
		              	<th data-field="证书时间"  data-sortable="true" data-filter-control="select"  data-visible="true">证书时间</th>
		              	<th data-field="证书单位"  data-sortable="true" data-filter-control="select"  data-visible="true">证书单位</th>
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
	search_val=search_val.replace(/(^\s*)|(\s*$)/g, "");//处理空格
	
	if(search_val.length>=1){
		modify('search',search_val);
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
	       window.location.href="?ac=&val="+$('#search').val();
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
		layer.confirm("确认要审核通过吗", { title: "审核确认" }, function (index) { 
            layer.close(index);
            window.location.href="?ac=check&id="+ids+"";   						 
        }); 
});
	
    //删除操作
    function delete_class(id){
    	layer.confirm("确认要审核通过吗", { title: "审核确认" }, function (index) { 
            layer.close(index);
            window.location.href="?ac=check&id="+id+"";   						 
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
if("check".equals(ac)){ 
	 String ids=request.getParameter("id");
	 String dsql = "";
	 boolean delState =  false;
	 if(ids==null){ids="";}
	try{
		String[]  id = ids.split(",");
		for(int i=0;i<id.length;i++){
	   		 dsql="update  person_certificate_change  set examine=4 WHERE id='"+id[i]+"';";
	   		delState = db.executeUpdate(dsql);
		}
	   if(delState){
		   out.println("<script>parent.layer.msg('审核成功');window.location.replace('./certificate_change_check.jsp');</script>");
	   }
	   else{
		   out.println("<script>parent.layer.msg('审核失败');</script>");
	   }
	 }catch (Exception e){
	    out.println("<script>parent.layer.msg('审核失败');</script>");
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