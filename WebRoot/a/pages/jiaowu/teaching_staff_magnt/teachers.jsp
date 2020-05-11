<%@ page trimDirectiveWhitespaces="true" %>
<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@page import="service.dao.db.Page"%>
<%@page import="v1.haocheok.commom.common"%>
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
 <link rel="stylesheet" href="../../../custom/easyui/tree.css" />
		<script type="text/javascript" src="../../js/jquery.form.js" ></script>
    <title>师资查询</title> 
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
<body >
       <div class="" style="padding-bottom: 0px;margin-left: 1%;margin-right: 1%; height:auto;">  
	<div id="tb" class="form_top layui-form"  style="display: flex;"><br>
       <br><input id="search" type="text" class="layui-input textbox-text" placeholder="请输入姓名或身份证号">
        <button class="layui-btn "  onclick="ac_tion('search')">搜索</button>
        <button class="layui-btn " onclick="location.reload()" > 刷新</button>
        	<%
		       	//获取文件后面的对象 数据
		       	String search_val = request.getParameter("val"); 
		       	if(search_val==null){search_val="";}else{search_val=search_val.replaceAll("\\s*", "");}
		       	search_val = new Page().mysqlCode(search_val);//防止sql注入
				search_val=search_val.toUpperCase();
				search_val=search_val.replaceAll(" ","");
				common common=new common();
				//查询的字段局部语句
		 		String search="";
		 		if(search_val.length()>=1){
		 			search="where t.name like '%"+search_val+"%'  or t.id_number like '%"+search_val+"%' ";
		 		}else{
		 			search = "where 1=1";
		 		}
		 		//计算出总页数
				String zpag_sql="select count(t.id)  row from staff_position t   "+search;
				int zpag= db.Row(zpag_sql);					
				
				//当前页数
		       	String pag = request.getParameter("pag");  	if(pag==null){pag="1";}
		       	int pages=Integer.parseInt(pag);
		       	
		        //当前页条数
		       	String limit = request.getParameter("limit"); if(limit==null){limit="10";}
		       	int limits=Integer.parseInt(limit);
		       	
		        String bank_sql= "select t.*,t1.birthday,t1.sex,t1.nation,t1.work_time,t1.education,t1.degree,t1.graduate_shcool  from staff_position  t LEFT JOIN teacher_basic t1 ON t.id_number=t1.id_number "+search+"  limit "+(pages-1)*limits+","+limits+";";
				String html_str = "";
				StringBuffer sb = new StringBuffer();
            		ResultSet groups = db.executeQuery(bank_sql);
            		while(groups.next()){
            	    	String sex ="";
            			String id_number = groups.getString("id_number");
                     	if(StringUtils.isBlank(id_number)){id_number="";}
            			 sex = groups.getString("sex");
                     	if(StringUtils.isBlank(sex)){sex="";}
                     	if(sex.equals("1")){
                     		sex="男";
                     	}else{
                     		sex ="女";
                     	}
            			String name = groups.getString("name");
                     	if(StringUtils.isBlank(name)){name="";}
            			String birthday = groups.getString("birthday");
                     	if(StringUtils.isBlank(birthday)){birthday="";}
            			String nation = groups.getString("nation");
                     	if(StringUtils.isBlank(nation)){nation="";}
            			String education = groups.getString("education");
                     	if(StringUtils.isBlank(education)){education="";}
            			String degree = groups.getString("degree");
                     	if(StringUtils.isBlank(degree)){degree="";}
            			String graduate_shcool = groups.getString("graduate_shcool");
                     	if(StringUtils.isBlank(graduate_shcool)){graduate_shcool="";}
            			String title_category = groups.getString("title_category");
                     	if(StringUtils.isBlank(title_category)){title_category="";}
            			String technical_qualification = groups.getString("technical_qualification");
                     	if(StringUtils.isBlank(technical_qualification)){technical_qualification="";}
            			String teacher_category = groups.getString("teacher_category");
                     	if(StringUtils.isBlank(teacher_category)){teacher_category="";}
            			String promotion_time = groups.getString("promotion_time");
                     	if(StringUtils.isBlank(promotion_time)){promotion_time="";}
            			String work_level = groups.getString("work_level");
                     	if(StringUtils.isBlank(work_level)){work_level="";}
                     	///String work_level = common.idToFieidName("type","typename",groups.getString("work_level"));
                     //	System.out.println(groups.getString("work_level")+"-------"+work_level);
                     	if(StringUtils.isBlank(work_level)){work_level="";}
            			String work_date = groups.getString("work_date");
                     	if(StringUtils.isBlank(work_date)){work_date="";}
            			String add_time = groups.getString("add_time");
                     	if(StringUtils.isBlank(add_time)){add_time="";}
                     	
            			html_str = "<tr>"
   							+"<td class=\"\">"+name +"</td>          "
   							+"<td class=\"\">"+id_number+"</td>          "
   							+"<td class=\"\">"+sex+"</td>          "
   							+"<td class=\"\">"+nation +"</td>          "
   							+"<td class=\"\">"+birthday +"</td>          "
   							+"<td class=\"\">"+education +"</td>          "
   							+"<td class=\"\">"+degree+"</td>          "
   							+"<td class=\"\">"+graduate_shcool+"</td>          "
   							//+"<td class=\"\">"+groups.getString("work_time") +"</td>          "
   							//+"<td class=\"\">"+groups.getString("education_degree") +"</td>          "
   							//+"<td class=\"\">"+groups.getString("executive_level") +"</td>          "
   							+"<td class=\"\">"+title_category +"</td>          "
   							+"<td class=\"\">"+technical_qualification +"</td>          "
   							+"<td class=\"\">"+teacher_category +"</td>          "
   							+"<td class=\"\">"+promotion_time +"</td>          "
   							+"<td class=\"\">"+work_level +"</td>          "
   							+"<td class=\"\">"+work_date +"</td>          "
   							+"<td class=\"\">"+add_time +"</td>          "
   							//+"<td class=\"\">"+groups.getString("category") +"</td>          "
   							+"<td class=\"\"> <a onclick=\"delete_class("+groups.getString("id")+")\">删除</a>"+"</td> "
						+"</tr>"; 
						sb.append(html_str);
            		}if(groups!=null){groups.close();}
		         %>
		    </div>
		    <div style="">
	      <form id="file_form" action="../../../../Api/v1/importExcel" enctype="multipart/form-data"     class="layui-form"     method="post" style="padding-top: 10px;">
	          <div id="field">
	           <%
	           		String tablename="staff_position";
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
		        		     <a href ="./shizi.xlsx" target="_blank" style="font-size:16px;margin-left:15px;">模板下载</a>   
		        </div>
		   
	    </form>   
	    </div>
    <table class="cuoz" id="table" data-toggle="table" data-show-toggle="true" data-show-columns="true" data-show-export="true"  >
        <thead>
            <tr>
              <th data-field="姓名"     data-sortable="true" data-filter-control="select" data-visible="true" >姓名</th>
              <th data-field="身份证号"     data-sortable="true" data-filter-control="select" data-visible="true" >身份证号</th>
              <th data-field="性别"     data-sortable="true" data-filter-control="select" data-visible="true" >性别</th>
              <th data-field="民族"     data-sortable="true" data-filter-control="select" data-visible="true" >民族</th>
              <th data-field="生日"     data-sortable="true" data-filter-control="select" data-visible="true" >生日</th>
              <th data-field="学历"     data-sortable="true" data-filter-control="select" data-visible="true" >学历</th>
              <th data-field="学位" data-sortable="true" data-filter-control="select" data-visible="true" >学位</th>
              <th data-field="毕业学校" data-sortable="true" data-filter-control="select" data-visible="true" >毕业学校</th>
<%--              <th data-field="工作时间" data-sortable="true" data-filter-control="select" data-visible="true" >工作时间</th>--%>
<%--              <th data-field="文化程度" data-sortable="true" data-filter-control="select" data-visible="true" >文化程度</th>--%>
<%--              <th data-field="行政级别" data-sortable="true" data-filter-control="select" data-visible="true" >行政级别</th>--%>
              <th data-field="职称类别" data-sortable="true" data-filter-control="select" data-visible="true" >职称类别</th>
              <th data-field="技术资格" data-sortable="true" data-filter-control="select" data-visible="true" >技术资格</th>
              <th data-field="教师类别" data-sortable="true" data-filter-control="select" data-visible="true" >教师类别</th>
              <th data-field="晋级时间" data-sortable="true" data-filter-control="select" data-visible="true" >晋级时间</th>
              <th data-field="聘任级别" data-sortable="true" data-filter-control="select" data-visible="true" >聘任级别</th>
              <th data-field="聘任时间" data-sortable="true" data-filter-control="select" data-visible="true" >聘任时间</th>
              <th data-field="更新时间" data-sortable="true" data-filter-control="select" data-visible="true" >更新时间</th>
              <th data-field="操作" data-sortable="true" data-filter-control="select" data-visible="true" >操作</th>
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
    
    //删除操作
    function delete_class(id){
    	layer.confirm("确认要删除吗，删除后不能恢复", { title: "删除确认" }, function (index) { 
            layer.close(index);
            window.location.href="?ac=deletet&id="+id+"";   						 
        }); 
    }
        
    layui.use(['form', 'layedit', 'laydate'], function(){
		  var form = layui.form
		  ,layer = layui.layer
		  ,layedit = layui.layedit
		  ,laydate = layui.laydate;
			form.render(); 

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
		                    var updaetFiled = '';
		                    var updateFiledid = "";
		                   	var updaetFiled = 'name,id_number,title_category,technical_qualification,promotion_time,teacher_category,work_level,work_date';
	                    	var tablename = $('input[name="tablename"]').val();
							$("#file_form").attr("action","../../../../Api/v1/importExcel?table="+tablename+"&field="+updaetFiled+"&fieldnum="+updateFiledid);
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
  </script>  
    
</body> 
</html>
<% 
//删除操作
if("deletet".equals(ac)){ 
	 String id=request.getParameter("id");
	 if(id==null){id="";}
	try{
	   String dsql="DELETE FROM staff_position WHERE id='"+id+"';";
	   if(db.executeUpdate(dsql)==true){
		   out.println("<script>parent.layer.msg('删除成功');window.location.replace('./teachers.jsp');</script>");
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