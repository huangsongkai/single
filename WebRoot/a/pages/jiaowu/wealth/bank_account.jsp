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
		common common=new common();
 		String search="where t.id>0 ";  
 		if(search_val.length()>=1){
 			search=search+"and ( t1.teacher_name like '%"+search_val+"%' or t.id_number like '%"+search_val+"%') ";
 		}     	
       	String pag = request.getParameter("pag");  	if(pag==null){pag="1";}
       	int pages=Integer.parseInt(pag);
       	String limit = request.getParameter("limit"); if(limit==null){limit="10";}
       	int limits=Integer.parseInt(limit);
		String zpag_sql="select count(1) as row from wealth_bank t "+search+";";
		int zpag= db.Row(zpag_sql);			
       	String sql="select t.*,t1.teacher_name,t1.teacher_number,t1.sex,t1.native_place,t1.teachering_office from wealth_bank t LEFT JOIN teacher_basic t1 ON t1.id_number=t.id_number   "+search+" order by t.id asc limit  "+(pages-1)*limits+","+limits+";";
       	String html_str="";  
       	ArrayList<String> list = new ArrayList<String>();
        ResultSet Rs = db.executeQuery(sql);
        while(Rs.next()){
        	String sex = Rs.getString("sex");
         	if(StringUtils.isBlank(sex)){sex="";}
         	if(sex.equals("1")){
         		sex="男";
         	}else if(sex.equals("2")){
         		sex ="女";
         	}
        	String teacher_number = Rs.getString("teacher_number");
         	if(StringUtils.isBlank(teacher_number)){teacher_number="";}
         	String teacher_name = Rs.getString("teacher_name");
         	if(StringUtils.isBlank(teacher_name)){teacher_name="";}
         	String native_place = Rs.getString("native_place");
         	if(StringUtils.isBlank(native_place)){native_place="";}
         	String teaching_research = common.idToFieidName("teaching_research","teaching_research_name",Rs.getString("teachering_office"));
         	if(StringUtils.isBlank(teaching_research)){teaching_research="";}
         	html_str="<tr>\r\n"+
         	"<td >"+teacher_number+"</td>"+
         	"<td >"+teacher_name+"</td>"+
         	"<td >"+sex+"</td>"+
         	"<td >"+native_place+"</td>"+
         	"<td >"+teaching_research+"</td>"+
         	"<td >"+Rs.getString("name")+"</td>"+
			"<td >"+Rs.getString("id_number")+"</td>"+
			"<td >"+Rs.getString("bankcard")+"</td>"+
						"<td >"+
						    "<div class=\"layui-btn-group\">"+
						    "<button class=\"layui-btn\" onclick=\"edit_wealth_bank_manage('"+Rs.getString("id")+"')\">修改</button>"+
				             "<button class=\"layui-btn\" onclick=\"deletet('"+Rs.getString("id")+"')\">删除</button>"+
					 	"</div>"+
						"</td>"+
				      "</tr>";
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
		        <br><input id="search" type="text" class="layui-input textbox-text" placeholder="输入身份证号或姓名进行查询" style="height: 35px; color: #272525;">
		        <button class="layui-btn layui-btn-small  layui-btn-primary" onclick="ac_tion('')"  style="height: 35px;  color: white; background: rgb(25, 160, 148);"> <i class="layui-icon" style="color: #FFF;">&#xe615;</i> 搜索</button>
		    	<button class="layui-btn layui-btn-small  layui-btn-primary" onclick="Refresh();ac_tion('')"  style="height: 35px;  color: white; background: rgb(25, 160, 148);"> <i class="layui-icon" style="color: #FFF;">&#x1002;</i> 刷新</button>
		        <button class="layui-btn layui-btn-small  layui-btn-primary" onclick="new_wealth_bank_manage()"  style="height: 35px;  color: white; background: rgb(25, 160, 148);"> <i class="layui-icon" style="color: #FFF;">&#xe61f;</i> 增加</button>
<%--		        <button class="layui-btn layui-btn-small  layui-btn-primary " onclick="help(<%=PMenuId %>)"  style="height: 35px;  color:#A9A9A9; background: rgb(245, 245, 245);"><i class="layui-icon" >&#xe60c;</i>帮助</button>--%>
		    </div>
		    <div style="">
	      <form id="file_form" action="../../../../Api/v1/importExcel" enctype="multipart/form-data"     class="layui-form"     method="post" style="padding-top: 10px;">
	          <div id="field">
	           <%
	           		String tablename="wealth_bank";
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
		       				  <a href ="../teaching_staff_magnt/fafang.xls" target="_blank" style="font-size:16px;margin-left:15px;">模板下载</a>   
		        </div>
	    </form>   
	    </div>
	    	<table class="cuoz" id="table" data-toggle="table" data-show-toggle="true" data-show-columns="true" data-show-export="true" >
		        <thead>
		            <tr>
		                <th data-field="编号"  data-sortable="true" data-filter-control="select"  data-visible="true">编号</th>
		                <th data-field="姓名"  data-sortable="true" data-filter-control="select"  data-visible="true">姓名</th>
		                <th data-field="性别"  data-sortable="true" data-filter-control="select"  data-visible="true">性别</th>
		                <th data-field="籍贯"  data-sortable="true" data-filter-control="select"  data-visible="true">籍贯</th>
		                <th data-field="教研室"  data-sortable="true" data-filter-control="select"  data-visible="true">教研室</th>
		                <th data-field="开户行"  data-sortable="true" data-filter-control="select"  data-visible="true">开户行</th>
		                <th data-field="身份证号"  data-sortable="true" data-filter-control="select"  data-visible="true">身份证号</th>
		                <th data-field="银行卡"  data-sortable="true" data-filter-control="select"  data-visible="true">银行卡</th>
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
					                        layer.alert('请选择文件');
					                        return false;
					                    }
					                    var fileType = (fileName.substring(fileName
					                            .lastIndexOf(".") + 1, fileName.length))
					                            .toLowerCase();
					                    if (fileType !== 'xls' && fileType !== 'xlsx') {
					                        layer.alert('文件格式不正确，excel文件！');
					                        return false;
					                    }
					                    var other = "";
					                   	var updaetFiled = 'name,id_number,bankcard';
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
				});
			    
		         
		        //执行
		        function ac_tion() {
				       window.location.href="?ac=&val="+$('#search').val()+"";
				}
		        function new_wealth_bank_manage(){
			    	 layer.open({
			    		  type: 2,
			    		  title: '添加银行卡号信息',
			    		  maxmin:1,
			    		  shade: 0.5,
			    		  area: ['940px', '80%'],
			    		  content: 'new_bank_account.jsp' 
			    		});
			     }
			     function edit_wealth_bank_manage(id){
			    	 layer.open({
			    		  type: 2,
			    		  title: '编辑银行卡号信息',
			    		  maxmin:1,
			    		  shade: 0.5,
			    		  area: ['940px', '80%'],
			    		  content: 'edit_bank_account.jsp?id='+id 
			    		});
			     }
				 function help(val){//帮助页面
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
	    <script>  look('<%=request.getParameter("index_id")%>','<%=request.getParameter("index_name")%>'); </script> 
	 <%} %>
	
	</body> 
</html>
<%if("deletet".equals(ac)){
	 String id=request.getParameter("id");
	 if(id==null){id="";}
	try{
	   String dsql="DELETE FROM wealth_bank WHERE id='"+id+"';";
	   if(db.executeUpdate(dsql)==true){
		   out.println("<script>parent.layer.msg('删除成功');window.location.replace('./bank_account.jsp');</script>");
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
