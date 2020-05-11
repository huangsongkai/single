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
		//search_val=search_val.toUpperCase();
		search_val=search_val.replaceAll(" ","");
		
		String dict_departments_id = request.getParameter("dict_departments_id"); 
       	String jiaoyanshi = request.getParameter("teaching_staff_office"); // 教职工所填写教研室
       	if(StringUtils.isBlank(dict_departments_id)){dict_departments_id="0";}
       	if(StringUtils.isBlank(jiaoyanshi)){jiaoyanshi="0";}
		//查找字段名称
		common common=new common();
		//查询的字段局部语句
 		String search="where Zgstate!=1 ";  
 		if(search_val.length()>=1){
 			//search=search+"and (majors_number like '%"+search_val+"%' or major_name like '%"+search_val+"%' or major_field like '%"+search_val+"%') ";
 			search= search + "and (t.teacher_name like '%"+search_val+"%' or t.id_number like '%"+search_val+"%' )";
 		} 
 		if(StringUtils.isNotBlank(dict_departments_id)&&!dict_departments_id.equals("0")){
 			search=search +" and t.faculty="+dict_departments_id;
 		}
 		if(StringUtils.isNotBlank(jiaoyanshi)&&!jiaoyanshi.equals("0")){
 			search=search +" and t.teaching_staff_office="+jiaoyanshi;
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
       	String sql="select * from teacher_basic t  "+search+" order by id asc limit  "+(pages-1)*limits+","+limits+";";

       	System.out.println("sql "+sql);
       	String html_str="";  //页面代码
       	ArrayList<String> list = new ArrayList<String>();
       	
       	//开始查询
       
        ResultSet Rs = db.executeQuery(sql);
        while(Rs.next()){
         	String sex ="";
         	if(Rs.getString("sex").equals("1")){
         		sex="男";
         	}else{
         		sex ="女";
         	}
         	String teacher_number = Rs.getString("teacher_number");
         	if(StringUtils.isBlank(teacher_number)){teacher_number="";}
         	String telephone = Rs.getString("telephone");
         	if(StringUtils.isBlank(telephone)){telephone="";}
         	String teacher_name = Rs.getString("teacher_name");
         	if(StringUtils.isBlank(teacher_name)){teacher_name="";}
         	String id_number = Rs.getString("id_number");
         	if(StringUtils.isBlank(id_number)){id_number="";}
         	String native_place = Rs.getString("native_place");
         	if(StringUtils.isBlank(native_place)){native_place="";}
         	String teaching_research = common.idToFieidName("teaching_research","teaching_research_name",Rs.getString("teaching_staff_office"));
         	if(StringUtils.isBlank(teaching_research)){teaching_research="";}
         	String add_time = Rs.getString("add_time");
         	if(StringUtils.isBlank(add_time)){add_time="";}
         	
         	html_str="<tr  id='"+Rs.getString("id")+"'>\r\n"+
        	"<td ><input type='checkbox' name='check' ></td> "+
			"<td ><strong>"+teacher_number+"</strong></td>\r\n"+//教师编号	
			"<td ><strong>"+teacher_name+"</strong></td>\r\n"+//教师姓名
			"<td ><strong>"+sex+"</strong></td>\r\n"+//性别
			"<td ><strong>"+id_number+"</strong></td>\r\n"+//身份证号码
			"<td ><strong>"+native_place+"</strong></td>\r\n"+//籍贯	
			"<td ><strong>"+teaching_research+"</strong></td>\r\n"+//教研室
			"<td ><strong>"+telephone+"</strong></td>\r\n"+//手机号
			"<td ><strong>"+add_time+"</strong></td>\r\n"+//添加时间
						"<td >"+
						    "<div class=\"layui-btn-group\">"+
					            // "<button class=\"layui-btn\" onclick=\"look('"+Rs.getString("id")+"')\">查看</button>"+
					             "<button class=\"layui-btn\" onclick=\"edit('"+Rs.getString("id")+"')\">编辑</button>"+
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
	 <script type="text/javascript" src="../../js/jquery.form.js" ></script>
	 <script type="text/javascript" src="../../js/ajaxs.js" ></script>
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
		        <br><input id="search" type="text" class="layui-input textbox-text" placeholder="输入名字或身份证查询" style="height: 35px; color: #272525; ">
		        <div class="layui-input-inline">
		            <select name="dict_departments_id"  id="dict_departments_id" lay-search  lay-filter="department">
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
					<select class="layui-input" name="teaching_staff_office"  id="teaching_staff_office" lay-search >
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
		           <button class="layui-btn "  id="batchUserWorker" data-type="getCheckData"> 批量导入用户</button>
<%--		        <button class="layui-btn layui-btn-small  layui-btn-primary " onclick="help(<%=PMenuId %>)"  style="height: 35px;  color:#A9A9A9; background: rgb(245, 245, 245);"><i class="layui-icon" >&#xe60c;</i>帮助</button>--%>
		    </div>
	      <form id="file_form" action="../../../../Api/v1/importExcel" enctype="multipart/form-data"     class="layui-form"     method="post" style="padding-top: 10px;float:left">
	          <div id="field">
	           <%
	           		String tablename="teacher_basic";
	           %> 
	           	<input type='hidden' name="tablename"  value="<%=tablename %>" />
	           </div>
	           <div>
	           			    <a href="javascript:;" class="layui-btn" id="test1" style="position: relative;">
							  <i class="layui-icon">&#xe67c;</i>上传Excel
							  <input type="file" name="file" id="file_input" style="position: absolute;left: 0;top: 0;height:38px;opacity: 0;filter:alpha(opacity=0);width: 120px;" />
							</a>
							<input type="submit" class="layui-btn" value="文件上传" id='upFile-btn'>
							<input type="text" class="layui-btn" value="" id='wenjianname' readonly placeholder="请上传Excel" style="background: rgb(227, 227, 227); color:black;">
							  <a href ="./jiaozhigong.xls" target="_blank" style="font-size:16px;margin-left:15px;">模板下载</a>   
<%--			        <input type="file" name="file" id="file_input" /> --%>
<%--			        <input type="submit" value="文件上传" id='upFile-btn'>--%>
		        </div>
	    </form>   
<%--		   <div id="asc" class="form_top layui-form" style="display: flex;    float: right;">--%>
<%--		        <div class="layui-inline">--%>
<%--					    <label class="layui-form-label" style="color: #19a094;font-size: 20px; margin-top: 4px;">导出:</label>--%>
<%--					    <div class="layui-input-inline" style="margin-top: 4px;">--%>
<%--					      <select name="gender" lay-verify="required"  lay-filter="Export">--%>
<%--					        <option value="请选择格式" selected="">请选择格式</option>--%>
<%--					         <%--%>
<%--					        	String Export_sql = "select name,value from export";--%>
<%--					        	ResultSet base = db.executeQuery(Export_sql);--%>
<%--					        	while(base.next()){--%>
<%--					         %>--%>
<%--					         	<option value="<%=base.getString("value") %>" > <%=base.getString("name") %> </option>--%>
<%--					         <%}if(base!=null){base.close();}%>--%>
<%--					      </select>--%>
<%--					    </div>--%>
<%--				</div>--%>
<%--		    </div>--%>
	    	<table class="cuoz" id="table" data-toggle="table" data-show-toggle="true" data-show-columns="true" data-show-export="true" >
		        <thead>
		            <tr>
		            	  <th  data-checkbox="true"><input type="checkbox" name="check" ></th>
		                <th data-field="教师编号"  data-sortable="true" data-filter-control="select"  data-visible="true">教师编号</th>
		                <th data-field="专业编号"  data-sortable="true" data-filter-control="select"  data-visible="true">教师姓名</th>
		                <th data-field="性别"  data-sortable="true" data-filter-control="select"  data-visible="true">性别</th>
	              	    <th data-field="身份证号码"  data-sortable="true" data-filter-control="select"  data-visible="true">身份证号码</th>
	              	    <th data-field="籍贯"  data-sortable="true" data-filter-control="select"  data-visible="true">籍贯</th>
		                <th data-field="教研室"  data-sortable="true" data-filter-control="select"  data-visible="true">教研室</th>
		                <th data-field="联系电话"  data-sortable="true" data-filter-control="select"  data-visible="true">联系电话</th>
		                <th data-field="更新时间"  data-sortable="true" data-filter-control="select"  data-visible="true">更新时间</th>
		               
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
	    		var teaching_staff_office='<%=jiaoyanshi%>';
	    		
	    		if(search_val.length>=1){
	    			modify('search',search_val);
	    		}
	    		if(dict_departments_id.length>=1){
	    			modify('dict_departments_id',dict_departments_id);
	    		}
	    		if(teaching_staff_office.length>=1){
	    			modify('teaching_staff_office',teaching_staff_office);
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
		         
			    layui.use(['form', 'layedit', 'laydate','laypage'], function(){
				  var laypage = layui.laypage,
				  form = layui.form
				  ,layer = layui.layer;
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
								    	var teaching_staff_office = $("#teaching_staff_office").val();
								    	var searchval = $('#search').val();
									       window.location.href="?ac=&val="+searchval+"&dict_departments_id="+dict_departments_id+"&teaching_staff_office="+teaching_staff_office+"&pag="+curr+"&limit="+limit;
								    }
						      }
					    });
						 form.on('select(department)',function(data){
								if(data.value!="0"){
									var obj_str1 = {"departments_id":data.value};
									var obj1 = JSON.stringify(obj_str1)
									var ret_str1=PostAjx('../../../../Api/v1/?p=web/info/teachingResearch',obj1,'<%=Suid%>','<%=Spc_token%>');
									obj1 = JSON.parse(ret_str1);
									$("#teaching_staff_office").html(obj1.data);
									form.render('select');
								}
							})
					    form.render();
				});

				$("#batchUserWorker").click(function(){
					var ids ="";
					$('tbody').find('.selected').each(function(){
						ids = ids + $(this).attr("id") +",";
					})
					if(ids==''){
						layer.msg('请至少选择一行');
						return false;
					}
					ids = ids.substring(0,ids.length-1);
					var str = {"ids":ids};
					var obj = JSON.stringify(str);
					var ret_str=PostAjx('../../../../Api/v1/?p=web/do/TerinUserWorker',obj,'<%=Suid%>','<%=Spc_token%>');
					var obj = JSON.parse(ret_str);
					if(obj.success && obj.resultCode=="1000"){
							layer.confirm(obj.msg);
					}else{
						layer.confirm(obj.msg);
					}
			});
				
			    	var fileInput = document.getElementById('file_input');
			    	fileInput.addEventListener('change', function(event) {
			    		var fileName = document.getElementsByClassName('file-name')[0];
			    		if (fileName) {
			    			document.getElementsByClassName('layui-form')[0].removeChild(fileName)
			    		}
			    		// 获取到选择文件集合对象 类型是数组  因为单文件上传所以取第一个
			    	    var file = fileInput.files[0];
			    	    $('#wenjianname').val(file.name);
			    	}, false);
			    
				$(function() {
			        $("#file_form").submit(
			                function() {
			                    //首先验证文件格式
			                    var fileName = $('#file_input').val();
			                    if (fileName === '') {
			                        alert('请选择文件');
			                        return false;
			                    }
			                    var fileType = (fileName.substring(fileName
			                            .lastIndexOf(".") + 1, fileName.length))
			                            .toLowerCase();
			                    if (fileType !== 'xls' && fileType !== 'xlsx') {
			                        alert('文件格式不正确，excel文件！');
			                        return false;
			                    }

			                    var updaetFiled = 'teacher_name,old_name,id_number,old_id_number,sex,nation,telephone,birthday,education,graduate_shcool,work_time,duty,administrative_level,register_date,political_status,teacher_number,faculty';
			                    var other = "";
		                    	var tablename = $('input[name="tablename"]').val();
								$("#file_form").attr("action","../../../../Api/v1/importExcel?table="+tablename+"&field="+updaetFiled+"&other="+other);
			                    $("#file_form").ajaxSubmit({
			                        dataType : "json",
			                        success : function(data, textStatus) {
				                        if (data.state == 'success') {
				                            layer.confirm("本次导入 更新 : "+data.updateNum+" 条,插入 :"+data.insertNum +" 条, 错误数据 :"+data.wrong, {icon: 3, title:'提示'}, function(index){
				                            	  layer.close(index);
				                            	  window.location.reload();
				                            	});
			                            } else {
			                                layer.confirm("文件读取失败,请检查文件", {icon: 3, title:'提示'}, function(index){
				                            	  layer.close(index);
				                            	  window.location.reload();
				                            	});
			                            }
			                            return false;
			                        }
			                    });
			                    return false;
			                });

			    });
			    
		        //执行
		        function ac_tion() {
		        	var dict_departments_id = $("#dict_departments_id").val();
			    	var teaching_staff_office = $("#teaching_staff_office").val();
			    	var searchval = $('#search').val();
				       window.location.href="?ac=&val="+searchval+"&dict_departments_id="+dict_departments_id+"&teaching_staff_office="+teaching_staff_office;
				}
		        //删除操作
		        function delete_class(id){
		        	layer.confirm("确认要删除吗，删除后不能恢复", { title: "删除确认" }, function (index) { 
		                layer.close(index);
		                window.location.href="?ac=deletet&id="+id+"";   						 
		            }); 
			    }
		        
		        
		        function look(id){
		           layer.open({
		     		 type: 2,
		     		  title: '查看教职工信息',
		     		  maxmin:1,
		     		  shade: 0.5,
		     		  area: ['100%', '100%'],
		     		  content: 'detail_teach_staff_info.jsp?id='+id 
		     		});
		         }
		        function edit(id){
		           layer.open({
		     		 type: 2,
		     		  title: '编辑教职工信息',
		     		  maxmin:1,
		     		  shade: 0.5,
		     		  area: ['100%', '100%'],
		     		  content: 'edit_teach_staff_info.jsp?id='+id 
		     		});
		         }
		       
			     function newup_class(){
			    	 layer.open({
			    		 type: 2,
			    		  title: '新建教职工信息',
			    		  maxmin:1,
			    		  shade: 0.5,
			    		  area: ['100%', '100%'],
			    		  content: 'new_teach_staff_info.jsp' 
			    		});
			     }

				 function help(val) {//帮助页面
					 layer.open({
						  type: 2,
						  title: '帮助页面',
						  offset: 't',//靠上打开
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
	   String dsql="DELETE FROM teacher_basic WHERE id='"+id+"';";
	   if(db.executeUpdate(dsql)==true){
		   out.println("<script>parent.layer.msg('删除成功');window.location.replace('./teach_staff_info.jsp');</script>");
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
