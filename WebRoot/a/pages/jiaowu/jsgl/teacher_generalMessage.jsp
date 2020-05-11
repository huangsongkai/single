<%@page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%--流程分类列表 --%>
<%@page trimDirectiveWhitespaces="true" %>
<%@page contentType="text/html; charset=UTF-8" language="java"%>
<%@page import="service.dao.db.Page"%>
<%@page import="v1.haocheok.commom.common"%>
<%@page import="v1.haocheok.commom.entity.UserEntity"%>
<%@page import="org.apache.commons.lang3.StringUtils"%>
<%@include file="../../cookie.jsp"%>
<%
       	
       	//获取文件后面的对象 数据
       	String search_val = request.getParameter("val"); if(search_val==null){search_val="";}else{search_val=search_val.replaceAll("\\s*", "");}
       	search_val = new Page().mysqlCode(search_val);//防止sql注入
		search_val=search_val.toUpperCase();
		search_val=search_val.replaceAll(" ","");
		String dict_departments_id = request.getParameter("dict_departments_id"); 
       	String jiaoyanshi = request.getParameter("teaching_office"); // 教职工所填写教研室
       	if(StringUtils.isBlank(dict_departments_id)){dict_departments_id="0";}
       	if(StringUtils.isBlank(jiaoyanshi)){jiaoyanshi="0";}
		//查找字段名称
		common common=new common();
		//查询的字段局部语句
 		String search="where id>0 and teacher_mark=1 and state=1 ";  
 		if(search_val.length()>=1){
 			//search=search+"and (majors_number like '%"+search_val+"%' or major_name like '%"+search_val+"%' or major_field like '%"+search_val+"%') ";
 			search= search + "and (t.teacher_name like '%"+search_val+"%' or t.id_number like '%"+search_val+"%' )";
 		}  	
 		if(StringUtils.isNotBlank(dict_departments_id)&&!dict_departments_id.equals("0")){
 			search=search +" and t.faculty="+dict_departments_id;
 		}
 		if(StringUtils.isNotBlank(jiaoyanshi)&&!jiaoyanshi.equals("0")){
 			search=search +" and t.teachering_office="+jiaoyanshi;
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
		String zpag_sql="select count(1) as row from teacher_basic t "+search+";";
		int zpag= db.Row(zpag_sql);			
		 
		//SQL语句
       	String sql="select * from teacher_basic t "+search+" order by id asc limit  "+(pages-1)*limits+","+limits+";";

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
         	String sex ="";
         	if("1".equals(Rs.getString("sex"))){sex="男";}
         	if("2".equals(Rs.getString("sex"))){sex="女";}
         	
         	String teacher_number = Rs.getString("teacher_number");
         	if(StringUtils.isBlank(teacher_number)){teacher_number="";}
         	String teacher_name = Rs.getString("teacher_name");
         	if(StringUtils.isBlank(teacher_name)){teacher_name="";}
         	String id_number = Rs.getString("id_number");
         	if(StringUtils.isBlank(id_number)){id_number="";}
         	String native_place = Rs.getString("native_place");
         	if(StringUtils.isBlank(native_place)){native_place="";}
          	String teaching_research = common.idToFieidName("teaching_research","teaching_research_name",Rs.getString("teachering_office"));
         	if(StringUtils.isBlank(teaching_research)){teaching_research="";}
         	
         	html_str="<tr>\r\n"+
         	
         	"<td ><strong>"+teacher_number+"</strong></td>\r\n"+//教师编号	
			"<td ><strong>"+teacher_name+"</strong></td>\r\n"+//教师姓名
			"<td ><strong>"+sex+"</strong></td>\r\n"+//性别
			"<td ><strong>"+id_number+"</strong></td>\r\n"+//身份证号码
			"<td ><strong>"+native_place+"</strong></td>\r\n"+//籍贯	
			"<td ><strong>"+teaching_research+"</strong></td>\r\n"+//教研室
						"<td >"+
						    "<div class=\"layui-btn-group\">"+
					             "<button class=\"layui-btn\" onclick=\"look('"+Rs.getString("id")+"'@#@'"+Rs.getString("teacher_name")+"')\">编辑</button>"+
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
	 	<script src="../../js/ajaxs.js"></script>
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
		        <br><input id="search" type="text" class="layui-input textbox-text" placeholder="输入名字或身份证" style="height: 35px; color: #272525;">
		        <div class="layui-input-inline">
		            <select name="dict_departments_id"  id="dict_departments_id" lay-search lay-filter="department" >
		              <option value="0">全部院系</option>
		            <%
		            //查询院系
		            String selectDsql="SELECT id,departments_name from dict_departments ;";
		            ResultSet yxRs = db.executeQuery(selectDsql);
		            while(yxRs.next()){
		            %>
		              <option value="<%=yxRs.getString("id") %>"  ><%=yxRs.getString("departments_name") %></option>
		             <%}if(yxRs!=null){yxRs.close();} %>
		            </select>
		        </div>
		        <div class="layui-input-inline"> 
					<select class="layui-input" name="teaching_office"  id="teaching_office" lay-search >
							<option value="0">全部教研室</option>
							<%
								String teaching_research_sql = "select id,teaching_research_name from teaching_research ;";
								ResultSet teaching_research_set = db.executeQuery(teaching_research_sql);
								while(teaching_research_set.next()){
							%>
								<option value="<%=teaching_research_set.getString("id")%>"><%=teaching_research_set.getString("teaching_research_name")%></option>
							<%}if(teaching_research_set!=null){teaching_research_set.close();} %>
						</select>
				</div>
		        <button class="layui-btn layui-btn-small  layui-btn-primary" onclick="ac_tion('')"  style="height: 35px;  color: white; background: rgb(25, 160, 148);"> <i class="layui-icon" style="color: #FFF;">&#xe615;</i> 搜索</button>
		    	<button class="layui-btn layui-btn-small  layui-btn-primary" onclick="Refresh();ac_tion('')"  style="height: 35px;  color: white; background: rgb(25, 160, 148);"> <i class="layui-icon" style="color: #FFF;">&#x1002;</i> 刷新</button>
		        <button class="layui-btn layui-btn-small  layui-btn-primary" onclick="newup_class()"  style="height: 35px;  color: white; background: rgb(25, 160, 148);"> <i class="layui-icon" style="color: #FFF;">&#xe61f;</i> 增加</button>
		    </div>
		   <div id="asc" class="form_top layui-form" style="display: flex;    float: right;">
		        <div class="layui-inline">
					    <label class="layui-form-label" style="color: #19a094;font-size: 20px; margin-top: 4px;">导出:</label>
					    <div class="layui-input-inline" style="margin-top: 4px;">
					      <select name="gender" lay-verify="required"  lay-filter="Export">
					        <option value="请选择格式" selected="">请选择格式</option>
					         <%
					        	String Export_sql = "select name,value from export";
					        	ResultSet base = db.executeQuery(Export_sql);
					        	while(base.next()){
					         %>
					         	<option value="<%=base.getString("value") %>" > <%=base.getString("name") %> </option>
					         <%}if(base!=null){base.close();}%>
					      </select>
					    </div>
				</div>
		    </div>
	    	<table class="cuoz" id="table" data-toggle="table" data-show-toggle="true" data-show-columns="true" data-show-export="true" >
		        <thead>
		            <tr>
		                <th data-field="教师编号"  data-sortable="true" data-filter-control="select"  data-visible="true">教师编号</th>
		                <th data-field="专业编号"  data-sortable="true" data-filter-control="select"  data-visible="true">教师姓名</th>
		                <th data-field="性别"  data-sortable="true" data-filter-control="select"  data-visible="true">性别</th>
	              	    <th data-field="身份证号码"  data-sortable="true" data-filter-control="select"  data-visible="true">身份证号码</th>
	              	    <th data-field="籍贯"  data-sortable="true" data-filter-control="select"  data-visible="true">籍贯</th>
		                <th data-field="教研室"  data-sortable="true" data-filter-control="select"  data-visible="true">教研室</th>
		               
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
			var dict_departments_id='<%=dict_departments_id%>';
			var teaching_office='<%=jiaoyanshi%>';
			
			if(search_val.length>=1){
				modify('search',search_val);
			}
			if(dict_departments_id.length>=1){
				modify('dict_departments_id',dict_departments_id);
			}
			if(teaching_office>=1){
				modify('teaching_office',teaching_office);
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
		         
			    layui.use(['laypage', 'layer','form'], function(){
				  var laypage = layui.laypage
				  ,form = layui.form
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
						      	var dict_departments_id = $("#dict_departments_id").val();
						    	var teaching_office = $("#teaching_office").val();
						    	var searchval = $('#search').val();
							       window.location.href="?ac=&val="+searchval+"&dict_departments_id="+dict_departments_id+"&teaching_office="+teaching_office+"&pag="+curr+"&limit="+limit;
						    }
				      }
			    });

				 form.on('select(department)',function(data){
						if(data.value!="0"){
							var obj_str1 = {"departments_id":data.value};
							var obj1 = JSON.stringify(obj_str1)
							var ret_str1=PostAjx('../../../../Api/v1/?p=web/info/teachingResearch',obj1,'<%=Suid%>','<%=Spc_token%>');
							obj1 = JSON.parse(ret_str1);
							$("#teaching_office").html(obj1.data);
							form.render('select');
						}
					})
					
			    form.render();
				});
   
			    function ac_tion() {
		        	var dict_departments_id = $("#dict_departments_id").val();
			    	var teaching_office = $("#teaching_office").val();
			    	var searchval = $('#search').val();
				       window.location.href="?ac=&val="+searchval+"&dict_departments_id="+dict_departments_id+"&teaching_office="+teaching_office;
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
		     		  title: '查看【'+name+'】教师信息',
		     		  shadeClose: true,
		     		  maxmin:1,
		     		  shade: 0.5,
		     		  area: ['100%', '100%'],
		     		  content: 'edit_teacher_generalMessage.jsp?id='+id 
		     		});
			     	 
		     		
		         }
		       
		         
			     function newup_class(){
			    	 layer.open({
			    		 type: 2,
			    		  title: '新建教师信息',
			    		  shadeClose: true,
			    		  maxmin:1,
			    		  shade: 0.5,
			    		  area: ['100%', '100%'],
			    		  content: 'new_teacher_generalMessage.jsp' 
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
	   String dsql="update teacher_basic  set state=2 WHERE id='"+id+"';";
	   if(db.executeUpdate(dsql)==true){
		   out.println("<script>parent.layer.msg('删除成功');window.location.replace('./teacher_generalMessage.jsp');</script>");
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
