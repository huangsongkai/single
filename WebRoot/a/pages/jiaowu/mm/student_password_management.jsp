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
    <title>学生密码管理</title> 
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
       <br><input id="search" type="text" class="layui-input textbox-text" placeholder="请输入名称">
					<div class="layui-input-inline" style="width: 170px;">
						<select name="classroomid"  class="layui-input"  lay-search  id="classroomid">
								<option value="0">全部</option>
							<%
								String classSql =" SELECT id,class_name FROM `class_grade`";
								ResultSet classSqlRs = db.executeQuery(classSql);
								while(classSqlRs.next()){
									out.println("<option value='"+classSqlRs.getString("id")+"'>"+classSqlRs.getString("class_name")+"</option>");
								}if(classSqlRs!=null)classSqlRs.close();
							%>
						</select>
					</div>
        <button class="layui-btn "  onclick="ac_tion('search')">搜索</button>
        <button class="layui-btn " onclick="location.reload()" > 刷新</button>
          <button class="layui-btn "  id="batchDelr" > 批量修改</button>
        	<%
		       	//获取文件后面的对象 数据
		       	String search_val = request.getParameter("val"); 
        		String classroomid =  request.getParameter("classroomid"); 
        		if(classroomid==null){classroomid="";}
		       	if(search_val==null){search_val="";}else{search_val=search_val.replaceAll("\\s*", "");}
		       	search_val = new Page().mysqlCode(search_val);//防止sql注入
				search_val=search_val.replaceAll(" ","");
				
				//查询的字段局部语句
		 		String search="where 1=1 and userole=2  AND t.user_association!=0   ";
		 		if(search_val.length()>=1){
		 			search= search+" and t1.stuname like '%"+search_val+"%'";
		 		}
		 		if(classroomid.length()>0&&!classroomid.equals("0")){
		 			search= search+" and t1.classroomid ="+classroomid;
		 		}
		 		//计算出总页数
				String zpag_sql="select count(1)  row from user_worker t 	LEFT JOIN student_basic t1 ON t.user_association=t1.id  "+search;
				int zpag= db.Row(zpag_sql);					
				
				//当前页数
		       	String pag = request.getParameter("pag");  	if(pag==null){pag="1";}
		       	int pages=Integer.parseInt(pag);
		       	
		        //当前页条数
		       	String limit = request.getParameter("limit"); if(limit==null){limit="10";}
		       	int limits=Integer.parseInt(limit);
		       	
		        //String bank_sql= "SELECT 	uid,nickname, username, sex, usermob, email, add_time, state,userole FROM  user_worker t "+search+"  limit "+(pages-1)*limits+","+limits+";";
				String bank_sql ="SELECT                                                                                "+
									"				t1.student_number,  t1.id,                                                "+
									"				t1.stuname,                                                         "+
									"				t1.sex,                                                             "+
									"				t2.departments_name,                                                "+
									"				t3.major_name,                                                      "+
									"				ifnull(t4.class_name,'') class_name,                                                      "+
									"				t1.idcard,                                                      "+
									"				t.state                                                             "+
									"			FROM                                                                    "+
									"				user_worker t                                                       "+
									"			LEFT JOIN student_basic t1 ON t.user_association = t1.id                "+
									"			LEFT JOIN dict_departments t2 ON t1.faculty=t2.id                       "+
									"			LEFT JOIN major t3 ON t3.id=t1.major                                    "+
									"			LEFT JOIN class_grade t4 ON t4.id=t1.classroomid "+search+"  limit "+(pages-1)*limits+","+limits+";";          
		        System.out.println(bank_sql);
				String html_str = "";
				StringBuffer sb = new StringBuffer();
            		ResultSet customerPrs = db.executeQuery(bank_sql);
            		while(customerPrs.next()){
            			String sex="";
            			String state = "";
			          	if(customerPrs.getInt("sex")==1){ sex="男";}else{sex="女";}
			          	if(customerPrs.getInt("state")==1){ state="正常";}else{state="禁止";}
			          	String locked ="";
			          	if(customerPrs.getInt("state")==1){ locked="锁定";}else{locked="解锁";}
                     	
            			html_str = "<tr id='"+customerPrs.getString("id")+"'>"
   							+"<td ><input type='checkbox' name='' lay-skin='primary'></td> "
   							+"<td class=\"\">"+ customerPrs.getString("student_number") +"</td>          "
   							+"<td class=\"\">"+customerPrs.getString("stuname")+"</td>          "
   							+"<td class=\"\">"+sex +"</td>          "
   							+"<td class=\"\">******</td>          "
   							+"<td class=\"\">"+customerPrs.getString("departments_name") +"</td>          "
   							+"<td class=\"\">"+customerPrs.getString("major_name")+"</td>          "
   							+"<td class=\"\">"+customerPrs.getString("class_name") +"</td>          "
   							+"<td class=\"\">"+customerPrs.getString("idcard") +"</td>          "
   							+"<td class=\"\">"+state +"</td>          "
   							+"<td class=\"\"><a onclick=\"edit("+customerPrs.getString("id")+")\">恢复密码</a> <a onclick=\"locked("+customerPrs.getString("id")+","+customerPrs.getInt("state")+")\">"+locked+"</a>"+"</td> "
						+"</tr>"; 
						sb.append(html_str);
            		}if(customerPrs!=null){customerPrs.close();}
		         %>
		    </div>
    <table class="cuoz" id="table" data-toggle="table" data-show-toggle="true" data-show-columns="true" data-show-export="true"  >
           <thead>
		            <tr>
		             	<th data-field="state"   data-checkbox="true"><input type="checkbox" name="" ></th>
		              	<th data-field="学号"  data-sortable="true" data-filter-control="select"  data-visible="true">学号</th>
		              	<th data-field="姓名"  data-sortable="true" data-filter-control="select"  data-visible="true">姓名</th>
		              	<th data-field="性别"  data-sortable="true" data-filter-control="select"  data-visible="true">性别</th>
		              	<th data-field="密码"  data-sortable="true" data-filter-control="select"  data-visible="true">密码</th>
		              	<th data-field="院系"  data-sortable="true" data-filter-control="select"  data-visible="true">院系</th>
		              	<th data-field="专业"  data-sortable="true" data-filter-control="select"  data-visible="false">专业</th>
		              	<th data-field="班级"  data-sortable="true" data-filter-control="select"  data-visible="true">班级</th>
		               	<th data-field="身份证号 "  data-sortable="true" data-filter-control="select"  data-visible="true">身份证号</th>
		                <th data-field="状态"  data-sortable="true" data-filter-control="select"  data-visible="true">状态</th>
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
	var search_role='<%=classroomid%>';
	search_val=search_val.replace(/(^\s*)|(\s*$)/g, "");//处理空格
	
	if(search_val.length>=1){
		modify('search',search_val);
	}
	if(search_role.length>=1){
		modify('classroomid',search_role);
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
	       window.location.href="?ac=&val="+$('#search').val()+"&classroomid="+$('#classroomid').val();
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
							     	 window.location.href="?ac=&val="+$('#search').val()+"&classroomid="+$('#classroomid').val()+"&pag="+curr+"&limit="+limit;
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
		layer.confirm('确定要恢复密码为学号?', function(index){
			  layer.close(index);
			ids = ids.substring(0,ids.length-1);
			 window.location.href="?ac=update&id="+ids+"";   
		}); 
});
	
    //锁定
    function locked(id,state){
            window.location.href="?ac=locked&state="+state+"&id="+id+"";   						 
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
	 
	 function edit(val) {//恢复密码
			layer.confirm('确定要恢复密码为学号?', function(index){
				  layer.close(index);
				 window.location.href="?ac=update&id="+val+"";   
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
//锁定操作
if("locked".equals(ac)){ 
	 String ids=request.getParameter("id");
	 String state=request.getParameter("state");
	 if(state.equals("1")){
		 state="2";
	 }else{
		 state ="1";
	 }
	 String dsql = "";
	 boolean delState =  false;
	 if(ids==null){ids="";}
	try{
		String[]  id = ids.split(",");
		for(int i=0;i<id.length;i++){
	   		 dsql="update user_worker set state="+state+" where userole=2 and user_association="+id[i];
	   		delState = db.executeUpdate(dsql);
		}
	   if(delState){
		   out.println("<script>parent.layer.msg('操作成功');window.location.replace('./student_password_management.jsp');</script>");
	   }
	   else{
		   out.println("<script>parent.layer.msg('操作失败');</script>");
	   }
	 }catch (Exception e){
	    out.println("<script>parent.layer.msg('操作失败');</script>");
	    return;
	 }
	//关闭数据与serlvet.out
	if (page != null) {page = null;}
}%>
<% 
//删除操作
if("update".equals(ac)){ 
	 String ids=request.getParameter("id");
	 String dsql = "";
	 boolean delState =  false;
	 if(ids==null){ids="";}
	try{
		String[]  id = ids.split(",");
		for(int i=0;i<id.length;i++){
	   		 dsql="update user_worker set password=(SELECT student_number from student_basic where id="+id[i]+") where userole=2 and user_association="+id[i];
	   		delState = db.executeUpdate(dsql);
		}
	   if(delState){
		   out.println("<script>parent.layer.msg('更新成功');window.location.replace('./student_password_management.jsp');</script>");
	   }
	   else{
		   out.println("<script>parent.layer.msg('更新失败');</script>");
	   }
	 }catch (Exception e){
	    out.println("<script>parent.layer.msg('更新失败');</script>");
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