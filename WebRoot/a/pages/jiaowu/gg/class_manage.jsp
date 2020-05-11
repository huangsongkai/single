<%@page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%--流程分类列表 --%>
<%@page trimDirectiveWhitespaces="true" %>
<%@page contentType="text/html; charset=UTF-8" language="java"%>
<%@page import="service.dao.db.Page"%>
<%@page import="v1.haocheok.commom.common"%>
<%@page import="v1.haocheok.commom.entity.UserEntity"%>
<%@include file="../../cookie.jsp"%>
<%  	
		//显示全部
		String state = request.getParameter("state");
		if(state==null){
			//初始设置
			state = "1";
		}
       	//获取文件后面的对象 数据
       	String search_val = request.getParameter("val"); if(search_val==null){search_val="";}else{search_val=search_val.replaceAll("\\s*", "");}
       	search_val = new Page().mysqlCode(search_val);//防止sql注入
		search_val=search_val.toUpperCase();
		search_val=search_val.replaceAll(" ","");
		//查找字段名称
		common common=new common();
		//查询的字段局部语句
 		String search="where hide=1 ";  
 		//判断是否显示全部
 		if("1".equals(state)){
 			search += "		AND    CONCAT((eductional_systme_id)+IFNULL(class_grade.school_year,0),'-07') > DATE_FORMAT(NOW(),'%Y-%m')";
 		}
 		if(search_val.length()>=1){
 			search=search+"and (class_number like '%"+search_val+"%' or class_abbreviation like '%"+search_val+"%' or counsellor like '%"+search_val+"%') ";
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
		String zpag_sql="select count(1) as row from class_grade    LEFT JOIN major "+
		"	ON class_grade.majors_id = major.id "+search+" ;";
		int zpag= db.Row(zpag_sql);			
		 
		//SQL语句
       	String sql="select class_grade.id as id, 								"+
		    "   		class_grade.departments_id as departments_id,                     "+
		    "   		majors_id,                          "+
		    "   		class_name,                         "+
		    "   		people_number_nan,                  "+
		    "   		people_number_woman,                "+
		    "   		counsellor,                         "+
		    "   		class_number,                       "+
		    "   		class_big,                          "+
		    "   		class_abbreviation,                 "+
		    "   		class_category_number,              "+
		    "   		class_grade.school_year as school_year,                        "+
		    "   		campus_id,                          "+
		    "   		teaching_area_id,                   "+
		    "   		classroom_id,                       "+
		    "   		school_year_code,                   "+
		    "   		graduation_class,                   "+
		    "   		stauts from class_grade   LEFT JOIN major "+
    		"	ON class_grade.majors_id = major.id "+search+" order by class_grade.id DESC limit  "+(pages-1)*limits+","+limits+";";
    		System.out.println(sql);

       	String html_str="";  //页面代码
       	ArrayList<String> list = new ArrayList<String>();
       	
       	//开始查询   
        ResultSet Rs = db.executeQuery(sql);
        while(Rs.next()){
         	/*
         	String type="";
         	if(ProcessRs.getInt("type")==0){type="pc端";}
         	else if(ProcessRs.getInt("type")==1){type="手机端";}
         	else{type="手机与pc端";}
         	*/
         	String py=common.idToFieidName("major","gradation",Rs.getString("majors_id"));
         	String fx=common.idToFieidName("dict_departments","campus",Rs.getString("departments_id"));
         	html_str="<tr>\r\n"+
         	"<td ><strong>"+Rs.getString("class_number")+"</strong></td>\r\n"+//班级编号
			"<td ><strong>"+Rs.getString("class_name")+"</strong></td>\r\n"+//班级名称
			"<td ><strong>"+Rs.getString("counsellor")+"</strong></td>\r\n"+//班主任
			"<td ><strong>"+common.idToFieidName("dict_departments","departments_name",Rs.getString("departments_id"))+"</strong></td>\r\n"+//所属院系	
			"<td ><strong>"+common.idToFieidName("major","major_name",Rs.getString("majors_id"))+"</strong></td>\r\n"+//所属专业
			"<td ><strong>"+Rs.getString("school_year")+"</strong></td>\r\n"+//入学年份
			"<td ><strong>"+common.fidToTypeTable(py,32)+"</strong></td>\r\n"+//培养层次
			"<td ><strong>"+(Integer.valueOf(Rs.getString("people_number_nan"))+Integer.valueOf(Rs.getString("people_number_woman")))+"</strong></td>\r\n"+//总人数
						"<td >"+
						    "<div class=\"layui-btn-group\">"+
					             "<button class=\"layui-btn\" onclick=\"look('"+Rs.getString("id")+"'@#@'"+Rs.getString("class_number")+"')\">编辑</button>"+
					             "<button class=\"layui-btn\" onclick=\"delete_class('"+Rs.getString("id")+"')\">删除</button>"+
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
		        <button class="layui-btn layui-btn-small  layui-btn-primary" onclick="newup_class()"  style="height: 35px;  color: white; background: rgb(25, 160, 148);"> <i class="layui-icon" style="color: #FFF;">&#xe61f;</i> 增加</button>
		       	<button class="layui-btn layui-btn-small  layui-btn-primary" onclick="show_all()"  style="height: 35px;  color: white; background: rgb(25, 160, 148);"> <i class="layui-icon" style="color: #FFF;">&#xe61f;</i> 显示全部</button>
<%--		        <button class="layui-btn layui-btn-small  layui-btn-primary " onclick="help(<%=PMenuId %>)"  style="height: 35px;  color:#A9A9A9; background: rgb(245, 245, 245);"><i class="layui-icon" >&#xe60c;</i>帮助</button>--%>
		    </div>
	    	<table class="cuoz" id="table" data-toggle="table" data-show-toggle="true" data-show-columns="true" data-show-export="true" >
		        <thead>
		            <tr>
		                <th data-field="班级编号"  data-sortable="true" data-filter-control="select"  data-visible="true">班级编号</th>
		                <th data-field="班级名称"  data-sortable="true" data-filter-control="select"  data-visible="true">班级名称</th>
		                <th data-field="班主任"  data-sortable="true" data-filter-control="select"  data-visible="true">班主任</th>
	              	    <th data-field="所属院系"  data-sortable="true" data-filter-control="select"  data-visible="true">所属院系</th>
	              	    <th data-field="所属专业"  data-sortable="true" data-filter-control="select"  data-visible="true">所属专业</th>
		                <th data-field="入学年份"  data-sortable="true" data-filter-control="select"  data-visible="true">入学年份</th>
		                <th data-field="培养层次"  data-sortable="true" data-filter-control="select"  data-visible="true">培养层次</th>
		                <th data-field="总人数"  data-sortable="true" data-filter-control="select"  data-visible="true">总人数</th>
<%--		                <th data-field="男生人数"  data-sortable="true" data-filter-control="select"  data-visible="true">男生人数</th>--%>
<%--		                <th data-field="女生人数"  data-sortable="true" data-filter-control="select"  data-visible="true">女生人数</th>--%>
<%--		                <th data-field="固定教学区"  data-sortable="true" data-filter-control="select"  data-visible="true">固定教学区</th>--%>
<%--		                <th data-field="固定教室"  data-sortable="true" data-filter-control="select"  data-visible="true">固定教室</th>--%>
<%--		                <th data-field="分校"  data-sortable="true" data-filter-control="select"  data-visible="true">分校</th>--%>
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
									     	 window.location.href="?ac=&state=<%=state%>&val="+$('#search').val()+"&pag="+curr+"&limit="+limit;
								    }
						      }
					    });
				});
   
		        //执行
		        function ac_tion() {
				       window.location.href="?ac=&state=2&val="+$('#search').val()+"";
				}

				//显示全部
				function show_all(){

					window.location.href = "?ac=&state=2";
				}

		        //删除操作
		        function delete_class(id){
		        	layer.confirm("确认要删除吗，删除后不能恢复", { title: "删除确认" }, function (index) { 
		                layer.close(index);
		                window.location.href="?ac=deletet&id="+id+"";   						 
		               
		            }); 
			    }		        
		        
		        function look(id,name){
		        	  // window.location.href="process_list.jsp?id="+id;
		           layer.open({
		     		 type: 2,
		     		  title: '查看【'+name+'】班级信息',
		     		  maxmin:1,
		     		  shade: 0.5,
		     		  area: ['100%', '100%'],
		     		  content: 'edit_class_manage.jsp?id='+id 
		     		});
		         }
		       
			     function newup_class(){
			    	 layer.open({
			    		 type: 2,
			    		  title: '班级信息管理',
			    		  maxmin:1,
			    		  shade: 0.5,
			    		  area: ['100%', '100%'],
			    		  content: 'new_class_manage.jsp' 
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
			
	    </script>
	      
      <%if(request.getParameter("index_id")!=null){//接受从首页过来的变量 直接打开某个任务%> 
	    <script>  look('<%=request.getParameter("index_id")%>','<%=request.getParameter("index_name")%>'); </script> 
	 <%} %>
	
	</body> 
</html>
<% 
//删除操作
if("deletet".equals(ac)){ 
	
	 String id=request.getParameter("id");
	 if(id==null){id="";}
	try{
	   String dsql="DELETE FROM class_grade WHERE id='"+id+"';";
	   if(db.executeUpdate(dsql)==true){
		   out.println("<script>parent.layer.msg('删除成功');window.location.replace('./class_manage.jsp');</script>");
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
