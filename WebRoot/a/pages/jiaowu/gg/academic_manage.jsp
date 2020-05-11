<%@page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%--流程分类列表 --%>
<%@page trimDirectiveWhitespaces="true" %>
<%@page contentType="text/html; charset=UTF-8" language="java"%>
<%@page import="service.dao.db.Page"%>
<%@page import="v1.haocheok.commom.common"%>
<%@page import="v1.haocheok.commom.entity.UserEntity"%>
<%@include file="../../cookie.jsp"%>
<%
       	
       	//获取文件后面的对象 数据
       	String search_val = request.getParameter("val"); if(search_val==null){search_val="";}else{search_val=search_val.replaceAll("\\s*", "");}
       	search_val = new Page().mysqlCode(search_val);//防止sql注入
		search_val=search_val.toUpperCase();
		search_val=search_val.replaceAll(" ","");
		//查找字段名称
		common common=new common();
		//查询的字段局部语句
 		String search="where id>0 ";  
 		if(search_val.length()>=1){
 			search=search+"and (academic_year like '%"+search_val+"%' or academic_yaer_as like '%"+search_val+"%') ";
 		}  	
       	/**
       	 *分页相关
       	 */
       	//当前页数
       	String pag = request.getParameter("pag");  	if(pag==null){pag="1";}
       	int pages=Integer.parseInt(pag);
       	
        //当前页条数
       	String limit = request.getParameter("limit"); if(limit==null){limit="10";}
       	int limits=Integer.parseInt(limit);
       	
      	//计算出总页数
		String zpag_sql="select count(1) as row from academic_year "+search+";";
		int zpag= db.Row(zpag_sql);			
		 
		//SQL语句
       	String sql="select * from academic_year  "+search+" order by id desc limit  "+(pages-1)*limits+","+limits+";";

       	String html_str="";  //页面代码
       	ArrayList<String> list = new ArrayList<String>();
       	
       	//开始查询
       String tagDqxq="";
       String tagZy="";
        ResultSet Rs = db.executeQuery(sql);
        while(Rs.next()){
         	/*
         	String type="";
         	if(ProcessRs.getInt("type")==0){type="pc端";}
         	else if(ProcessRs.getInt("type")==1){type="手机端";}
         	else{type="手机与pc端";}
         	*/
         	//判断是否当前学期
        	tagZy=Rs.getString("this_academic_tag");
         	if(!"true".equals(tagZy)){tagZy="";}else{tagZy="&#x1005;";}
         	tagDqxq=Rs.getString("this_academic_tag");
         	//判断输出符号
         	if("true".equals(tagDqxq)){tagDqxq="&#x1005;";}else{tagDqxq="";}    	
         	html_str="<tr>\r\n"+
         	"<td ><strong>"+Rs.getString("academic_year")+"</strong></td>\r\n"+//学年学期号
			"<td ><strong>"+Rs.getString("academic_yaer_as")+"</strong></td>\r\n"+//学期号简称
			"<td ><strong>"+Rs.getString("start_week")+"</strong></td>\r\n"+//起始上课周
			"<td ><strong>"+Rs.getString("end_week")+"</strong></td>\r\n"+//终止上课周
			"<td ><strong>"+Rs.getString("start_date")+"</strong></td>\r\n"+//终止上课周
			"<td ><strong>"+Rs.getString("academic_weeks")+"</strong></td>\r\n"+
			"<td ><i class=\"layui-icon\">"+tagZy+"</td>\r\n"+
						"<td >"+
						    "<div class=\"layui-btn-group\">"+
						     "<button class=\"layui-btn\" onclick=\"edit_academic_manage('"+Rs.getString("id")+"')\">修改</button>"+
				             "<button class=\"layui-btn\" onclick=\"deletet('"+Rs.getString("id")+"')\">删除</button>"+
					 	"</div>"+
						"</td>\r\n"+
				      "</tr>\r\n\r\n";
		   list.add(html_str);
       }if(Rs!=null){Rs.close();}
%>
<!DOCTYPE html>
<html>
	<head> 
	    <meta charset="utf-8"> 
	    <meta name="viewport" content="width=device-width, initial-scale=1"> 
	    
	    <link rel="stylesheet" href="../../../pages/css/sy_style.css">	    
	    <link rel="stylesheet" href="../../js/layui2/css/layui.css">
		<script type="text/javascript" src="../../js/jquery-1.9.1.js" ></script><!--通用jquery-->
		<script src="../../js/layui2/layui.js"></script>
		<script type="text/javascript" src="../../js/tableExport/js/table-sort.js" ></script><!--表格排序js  css-->
		<script type="text/javascript" chartset="utf8" src="../../js/tableExport/js/table_list.js " ></script><!--表格导出js  css-->
	 
	    <title><%=Mokuai %></title> 
	  <style type="text/css"> 
	    th { background-color: white; }
	    .btn-group-vertical>.btn, .btn-group>.btn{height:33px;}
        table tr:hover{background:#eeeeee;color:#19A094;}
     </style>
 	</head> 
	<body>
	    <div class="" style="padding-bottom: 0px;margin-left: 1%;margin-right: 1%; height:auto;">  
			<div id="tb" class="form_top layui-form" style="display: flex;">
		        <br><input id="search" type="text" class="layui-input textbox-text" placeholder="输入关键字进行查询" style="height: 35px; color: #272525; background: rgb(227, 227, 227);">
		        <button class="layui-btn layui-btn-small  layui-btn-primary" onclick="ac_tion('')"  style="height: 35px;  color: white; background: rgb(25, 160, 148);"> <i class="layui-icon" style="color: #FFF;">&#xe615;</i> 搜索</button>
		    	<button class="layui-btn layui-btn-small  layui-btn-primary" onclick="Refresh();ac_tion('')"  style="height: 35px;  color: white; background: rgb(25, 160, 148);"> <i class="layui-icon" style="color: #FFF;">&#x1002;</i> 刷新</button>
		        <button class="layui-btn layui-btn-small  layui-btn-primary" onclick="new_academic_manage()"  style="height: 35px;  color: white; background: rgb(25, 160, 148);"> <i class="layui-icon" style="color: #FFF;">&#xe61f;</i> 增加</button>
		    </div>
	    	<table class="cuoz" id="table" data-toggle="table" data-show-toggle="true" data-show-columns="true" data-show-export="true" >
		        <thead>
		            <tr>
		                <th data-field="学年学期号"  data-sortable="true" data-filter-control="select"  data-visible="true">学年学期号</th>
		                <th data-field="学期号简称"  data-sortable="true" data-filter-control="select"  data-visible="true">学期号简称</th>
		                <th data-field="起始上课周"  data-sortable="true" data-filter-control="select"  data-visible="true">起始上课周</th>
	              	    <th data-field="终止上课周"  data-sortable="true" data-filter-control="select"  data-visible="true">终止上课周</th>
	              	    <th data-field="学期开始日期"  data-sortable="true" data-filter-control="select"  data-visible="true">学期开始日期</th>
	              	    <th data-field="学期周数"  data-sortable="true" data-filter-control="select"  data-visible="true">学期周数</th>
		                <th data-field="当前学期标志"  data-sortable="true" data-filter-control="select"  data-visible="true">当前学期标志</th>
		                <th data-field="操作"     data-sortable="true" data-filter-control="select"  data-visible="true">操作</th>
		            </tr>
		        </thead>
		        <tbody id="tbody">
					<%=list.toString().replaceAll("\\[","").replaceAll("\\]","").replaceAll(",","").replaceAll("@#@",",")%>
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
	    		
	    		//清空某个id 的标签内容//$("#"+id+"").empty();
		         
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
   
		        //执行
		        function ac_tion() {
				       window.location.href="?ac=&val="+$('#search').val()+"";
				}

		        function new_academic_manage(){
			    	 layer.open({
			    		  type: 2,
			    		  title: '添加学年学期',
			    		  shadeClose: true,
			    		  maxmin:1,
			    		  shade: 0.5,
			    		  area: ['940px', '80%'],
			    		  content: 'new_academic_manage.jsp' 
			    		});
			     }
			     function edit_academic_manage(id){
			    	 layer.open({
			    		  type: 2,
			    		  title: '编辑学年学期',
			    		  shadeClose: true,
			    		  maxmin:1,
			    		  shade: 0.5,
			    		  area: ['940px', '80%'],
			    		  content: 'edit_academic_manage.jsp?id='+id 
			    		});
			     }
				 
				 function help(val) {//帮助页面
					 layer.open({
						  type: 2,
						  title: '帮助页面',
						  offset: 't',//靠上打开
						  shadeClose: true,
						  maxmin:1,
						  shade: 0.5,
						  area: ['780px', '100%'],
						  content: '../../syst/help.jsp?id='+val
					});
				 }
				 function deletet(id){
					  layer.confirm("确认要删除吗，删除后不能恢复", { title: "删除确认" }, function (index) { 
					                layer.close(index);
					                window.location.href="?ac=deletet&id="+id+"";   						 				               
					            }); 
				}
			var index = parent.layer.getFrameIndex(window.name);
			
	    </script>
	      
     <%if(request.getParameter("index_id")!=null){//接受从首页过来的变量 直接打开某个任务%> 
	    <script>look('<%=request.getParameter("index_id")%>','<%=request.getParameter("index_name")%>'); </script> 
	 <%}%>
	
	</body> 
</html>
<% if("deletet".equals(ac)){ 
	 String id=request.getParameter("id");
	 if(id==null){id="";}
	try{
	   String dsql="DELETE FROM academic_year WHERE id='"+id+"';";
	   if(db.executeUpdate(dsql)==true){
		   out.println("<script>parent.layer.msg('删除成功');window.location.replace('./academic_manage.jsp');</script>");
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
long TimeEnd = Calendar.getInstance().getTimeInMillis();
System.out.println(Mokuai+"耗时:"+(TimeEnd - TimeStart) + "ms");
//插入常用菜单日志
int   TagMenu=db.Row("SELECT COUNT(*) as row FROM  menu_worker  WHERE sysmenuid='"+PMenuId+"' and  workerid='"+Suid+"'");
if(TagMenu==0){
     db.executeUpdate("INSERT INTO `menu_worker`(`sysmenuid`,`workerid`,`countes`) VALUES ('"+PMenuId+"','"+Suid+"','1');"); 
   }else{
  db.executeUpdate("UPDATE  `menu_worker` SET `countes`=countes+1,`usetime`=now() WHERE  sysmenuid='"+PMenuId+"' and  workerid='"+Suid+"'");
}
 %>
<%if(db!=null)db.close();db=null;if(server!=null)server=null;%>

