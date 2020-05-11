<%@ page trimDirectiveWhitespaces="true" %>
<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@page import="service.dao.db.Page"%>
<%@include file="../../../cookie.jsp"%>
<%@page import="org.apache.commons.lang3.StringUtils"%>
<html>
<head> 
    <meta charset="utf-8"> 
    <meta name="viewport" content="width=device-width, initial-scale=1"> 
     <link rel="stylesheet" href="../../../../pages/css/sy_style.css?22">	    
	    <link rel="stylesheet" href="../../../js/layui2/css/layui.css">
		<script type="text/javascript" src="../../../js/jquery-1.9.1.js" ></script><!--通用jquery-->
		<script src="../../../js/layui2/layui.js"></script>
			<script type="text/javascript" src="../../../js/ajaxs.js" ></script>
		<script type="text/javascript" src="../../../js/tableExport/js/table-sort.js" ></script><!--表格排序js  css-->
		<script type="text/javascript" chartset="utf8" src="../../../js/tableExport/js/table_list.js " ></script><!--表格导出js  css-->
	 <script type="text/javascript" src="../../../../custom/jquery.easyui.min.js"></script>
 <link rel="stylesheet" href="../../../../custom/easyui/tree.css" />
  <script type="text/javascript" src="../../../js/jquery.form.js" ></script>
    <title>学生综合信息</title> 
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
       <br><input id="search" type="text" class="layui-input textbox-text" placeholder="请输入姓名或 身份证号">
       	<div class="layui-input-inline">
		            <select name="dict_departments_id" id="dict_departments_id" lay-search  lay-filter="department">
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
					<select name="zhuanye" id="zhuanye" lay-search lay-filter="zhuanye">
						<option value="0">全部专业</option>
						<%
							String zhuanye_sql = "select id,major_name from major";
							ResultSet zhuanye_set = db.executeQuery(zhuanye_sql);
							while(zhuanye_set.next()){
						%>
							<option value="<%=zhuanye_set.getString("id") %>" ><%=zhuanye_set.getString("major_name") %></option>
						<%}if(zhuanye_set!=null){zhuanye_set.close();} %>
					</select>
				</div>
				<div class="layui-input-inline">
					<select name="banji" id="banji" lay-search>
						<option value="0" selected>全部班级</option>
						<%
							String banji_sql = "select id,class_name from class_grade";
							ResultSet banji_set = db.executeQuery(banji_sql);
							while(banji_set.next()){
						%>
							<option value="<%=banji_set.getString("id") %>" ><%=banji_set.getString("class_name") %></option>
						<%} %>
					</select>
				</div>
       
        <button class="layui-btn "  onclick="ac_tion('search')">搜索</button>
        <button class="layui-btn " onclick="location.reload()" > 刷新</button>
        <button class="layui-btn "  id="batchUserWorker" data-type="getCheckData"> 批量导入到用户</button>
<!--        <button class="layui-btn " >删除</button>-->
        <button class="layui-btn "  onclick="newDistrbutor()" >新建学生</button>
         <button class="layui-btn "  id="batchDelr" > 批量删除</button>
        	<%
		       	//获取文件后面的对象 数据
		       	String search_val = request.getParameter("val"); 
		       	String dict_departments_id = request.getParameter("dict_departments_id"); 
		       	if(StringUtils.isBlank(dict_departments_id)){dict_departments_id="0";}
		       	String zhuanye = request.getParameter("zhuanye"); 
		       	if(StringUtils.isBlank(zhuanye)){zhuanye="0";}
		       	String banji = request.getParameter("banji"); 
		       	if(StringUtils.isBlank(banji)){banji="0";}
		       	if(search_val==null){search_val="";}else{search_val=search_val.replaceAll("\\s*", "");}
		       	search_val = new Page().mysqlCode(search_val);//防止sql注入
				//search_val=search_val.toUpperCase();
				search_val=search_val.replaceAll(" ","");
				
				//查询的字段局部语句
		 		String search="where 1=1 ";
		 		if(search_val.length()>=1){
		 			search=search + " and  (t.stuname like '%"+search_val+"%'   or t.idcard like '%"+search_val+"%') ";
		 		}
		 		if(StringUtils.isNotBlank(dict_departments_id)&&!dict_departments_id.equals("0")){
		 			search=search +" and t.faculty="+dict_departments_id;
		 		}
		 		if(StringUtils.isNotBlank(zhuanye)&&!zhuanye.equals("0")){
		 			search=search +" and t.major="+zhuanye;
		 		}
		 		if(StringUtils.isNotBlank(banji)&&!banji.equals("0")){
		 			search=search +" and classroomid="+banji;
		 		}
		 		//计算出总页数
				String zpag_sql="select count(t.id)  row from student_basic t   "+search;
				int zpag= db.Row(zpag_sql);					
				
				//当前页数
		       	String pag = request.getParameter("pag");  	if(pag==null){pag="1";}
		       	int pages=Integer.parseInt(pag);
		       	
		        //当前页条数
		       	String limit = request.getParameter("limit"); if(limit==null){limit="10";}
		       	int limits=Integer.parseInt(limit);
		       	
		        String bank_sql= "select t.*,t1.major_name,t2.class_name  from student_basic  t LEFT JOIN major t1 ON t1.id=t.major LEFT JOIN class_grade t2 ON t2.id=t.classroomid "+search+"  limit "+(pages-1)*limits+","+limits+";";
			System.out.println(bank_sql);
				String html_str = "";
		        ArrayList<String> list  = new ArrayList<String>();
            		ResultSet groups = db.executeQuery(bank_sql);
            		while(groups.next()){
            			String sex ="";
            			if(groups.getString("sex").equals("1")){sex ="男";}else{sex = "女";}
            			String class_name ="";
            			if(StringUtils.isBlank(groups.getString("class_name"))){class_name ="";
            			}else{
            				class_name = groups.getString("class_name");
            			}
            			String birth =groups.getString("birth");
            			if(StringUtils.isBlank(groups.getString("birth"))){
            				birth="";
            			}
            			String start_date =groups.getString("start_date");
            			if(StringUtils.isBlank(groups.getString("start_date"))){
            				start_date="";
            			}
            			html_str = "<tr id='"+groups.getString("id")+"'>"
            				+"<td ><input type='checkbox' name='check' ></td> "
   							+"<td class=\"\">"+groups.getString("stuname") +"</td>          "
   							+"<td class=\"\">"+groups.getString("student_number") +"</td>          "
   							+"<td class=\"\">"+groups.getString("alarm") +"</td>          "
   							+"<td class=\"\">"+groups.getString("idcard") +"</td>          "
   							+"<td class=\"\">"+sex +"</td>          "
   							+"<td class=\"\">"+groups.getString("nation") +"</td>          "
   							+"<td class=\"\">"+birth+"</td>          "
   							+"<td class=\"\">"+start_date+"</td>          "
   							+"<td class=\"\">"+groups.getString("major_name") +"</td>          "
   							+"<td class=\"\">"+groups.getString("telephone") +"</td>          "
   							+"<td class=\"\">"+groups.getString("native_place") +"</td>          "
   							+"<td class=\"\">"+class_name+"</td>         "
   							+"<td class=\"\"> <a onclick=\"editBank("+groups.getString("id")+")\">编辑</a><a onclick=\"deletet("+groups.getString("id")+")\">删除</a>"+"</td> "
						+"</tr>"; 
            			 list.add(html_str);
            		}if(groups!=null){groups.close();}
		         %>
		    </div>
		    <form id="file_form" action="../../../../Api/v1/importExcel" enctype="multipart/form-data"     class="layui-form"     method="post" style="padding-top: 10px;float:left">
	          <div id="field">
	           <%
	           		String tablename="student_basic";
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
							  <a href ="./xuesheng.xls" target="_blank" style="font-size:16px;margin-left:15px;">模板下载</a>   
		        </div>
	    </form>   
    <table class="cuoz" id="table" data-toggle="table" data-show-toggle="true" data-show-columns="true" data-show-export="true" >
        <thead>
            <tr>
            	<th  data-checkbox="true"><input type="checkbox" name="check" ></th>
              <th data-field="姓名"     data-sortable="true" data-filter-control="select" data-visible="true" >姓名</th>
              <th data-field="学号"     data-sortable="true" data-filter-control="select" data-visible="true" >学号</th>
              <th data-field="警号"     data-sortable="true" data-filter-control="select" data-visible="true" >警号</th>
              <th data-field="身份证号"     data-sortable="true" data-filter-control="select" data-visible="true" >身份证号</th>
              <th data-field="性别"     data-sortable="true" data-filter-control="select" data-visible="true" >性别</th>
              <th data-field="民族"     data-sortable="true" data-filter-control="select" data-visible="false" >民族</th>
              <th data-field="出生日期"     data-sortable="true" data-filter-control="select" data-visible="false" >出生日期</th>
              <th data-field="入学日期"     data-sortable="true" data-filter-control="select" data-visible="true" >入学日期</th>
              <th data-field="专业"     data-sortable="true" data-filter-control="select" data-visible="true" >专业</th>
              <th data-field="电话号码"     data-sortable="true" data-filter-control="select" data-visible="true" >电话号码</th>
              <th data-field="籍贯"     data-sortable="true" data-filter-control="select" data-visible="true" >籍贯</th>
              <th data-field="所属班级"     data-sortable="true" data-filter-control="select" data-visible="true" >所属班级</th>
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
	var dict_departments_id='<%=dict_departments_id%>';
	var zhuanye='<%=zhuanye%>';
	var banji='<%=banji%>';
	search_val=search_val.replace(/(^\s*)|(\s*$)/g, "");//处理空格
	
	if(search_val.length>=1){
		modify('search',search_val);
	}
	if(dict_departments_id.length>=1){
		modify('dict_departments_id',dict_departments_id);
	}
	if(zhuanye.length>=1){
		modify('zhuanye',zhuanye);
	}
	if(banji.length>=1){
		modify('banji',banji);
	}
	//改变某个id的值
	function modify (id,search_val){
		$("#"+id+"").val(""+search_val+"")
	}

	 //清空 搜索输入框
	function Refresh(){
		$("#search").val("");
	} 
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

                var updaetFiled = 'test_number,idcard,alarm,student_number,classroomid,stuname,sex,faculty,major,nation,politics_status,exam_score,native_place,telephone,regist';
                var other = "";
            	var tablename = $('input[name="tablename"]').val();
				$("#file_form").attr("action","../../../../../Api/v1/importExcel?table="+tablename+"&field="+updaetFiled+"&other="+other);
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
    	var zhuanye = $("#zhuanye").val();
    	var banji = $("#banji").val();
    	var searchval = $('#search').val();
	       window.location.href="?ac=&val="+searchval+"&dict_departments_id="+dict_departments_id+"&zhuanye="+zhuanye+"&banji="+banji;
	} 
	
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
							    	var zhuanye = $("#zhuanye").val();
							    	var banji = $("#banji").val();
							    	var searchval = $('#search').val();
							     	 window.location.href="?ac=&val="+searchval+"&dict_departments_id="+dict_departments_id+"&zhuanye="+zhuanye+"&banji="+banji+"&pag="+curr+"&limit="+limit;
						    }
				      }
			    });
				 form.on('select(department)',function(data){
						if(data.value!="0"){
							var obj_str1 = {"departments_id":data.value};
							var obj1 = JSON.stringify(obj_str1)
							var ret_str1=PostAjx('../../../../../Api/v1/?p=web/info/getMajor',obj1,'<%=Suid%>','<%=Spc_token%>');
							obj1 = JSON.parse(ret_str1);
							$("#zhuanye").html(obj1.data);
							form.render('select');
						}
					})
					
				 form.on('select(zhuanye)',function(data){
						if(data.value!="0"){
							var obj_str1 = {"major_id":data.value};
							var obj1 = JSON.stringify(obj_str1)
							var ret_str1=PostAjx('../../../../../Api/v1/?p=web/info/getClassGrade',obj1,'<%=Suid%>','<%=Spc_token%>');
							obj1 = JSON.parse(ret_str1);
							$("#banji").html(obj1.data);
							form.render('select');
						}
					})
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
				var ret_str=PostAjx('../../../../../Api/v1/?p=web/do/inUserWorker',obj,'<%=Suid%>','<%=Spc_token%>');
				var obj = JSON.parse(ret_str);
				if(obj.success && obj.resultCode=="1000"){
						layer.confirm(obj.msg);
				}else{
					layer.confirm(obj.msg);
				}
		});
		
    function newDistrbutor(){
    	layer.open({
		 type: 2,
		  title: '新建学生',
		  maxmin:1,
		  shade: 0.5,
		  offset: 't',
		  area: ['940px', '100%'],
		  content: 'new_student_syn.jsp'
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
			          data : { id: id,table:"student_basic"},  
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
    
     function editBank(id){
		layer.open({
		 type: 2,
		  title: '编辑学生',
		  maxmin:1,
		  shade: 0.5,
		  offset: 't',
		  area: ['940px', '100%'],
		  content: 'edit_student_syn.jsp?id='+id 
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
	   		 dsql="DELETE FROM student_basic WHERE id='"+id[i]+"';";
	   		 System.out.println(dsql);
	   		delState = db.executeUpdate(dsql);
		}
	   if(delState){
		   out.println("<script>parent.layer.msg('删除成功');window.location.replace('./student_syn.jsp');</script>");
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