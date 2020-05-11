<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%--直播教室 --%>
<%@page trimDirectiveWhitespaces="true" %>
<%@page contentType="text/html; charset=UTF-8" language="java"%>
<%@page import="service.dao.db.Page"%>
<%@page import="v1.haocheok.commom.common"%>
<%@page import="v1.haocheok.commom.entity.UserEntity"%>
<%@page import="service.dao.db.Md5"%>
<%@include file="../../cookie.jsp"%>
<%
String livestate = request.getParameter("livestate"); if(livestate==null){livestate="";}//获得直播教室状态	
Md5 md5=new Md5();
String FMSSERVER="";
ResultSet FMSRs = db.executeQuery(" SELECT config_value   FROM  sys_config  where   id=1");
	 if (FMSRs.next()) {
		FMSSERVER=FMSRs.getString("config_value");
 } if(FMSRs==null){ FMSRs.close();} 
 

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
 			search=search+"and (livename like '%"+search_val+"%' or content like '%"+search_val+"%') ";
 		}  
 		if(livestate.length()>=1){
 			search=search+"and status = '"+livestate+"'";
 		} 
 		
 		System.out.println("search="+search);
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
		String zpag_sql="select count(1) as row from zb_live "+search+";";
		int zpag= db.Row(zpag_sql);			
		 
		//SQL语句
       	String sql="select * from zb_live  "+search+" order by id desc limit  "+(pages-1)*limits+","+limits+";";
        
    
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
		        <button class="layui-btn layui-btn-small  layui-btn-primary" onclick="new_teach_manage()"  style="height: 35px;  color: white; background: rgb(25, 160, 148);"> <i class="layui-icon" style="color: #FFF;">&#xe61f;</i> 增加</button>
		        <button class="layui-btn layui-btn-small  layui-btn-primary " onclick="help(<%=PMenuId %>)"  style="height: 35px;  color:#A9A9A9; background: rgb(245, 245, 245);"><i class="layui-icon" >&#xe60c;</i>帮助</button>
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
		                <th data-field="院系名称"  data-sortable="true" data-filter-control="select"  data-visible="true">直播教室名称</th>
		                <th data-field="状态"  data-sortable="true" data-filter-control="select"  data-visible="true">状态</th>
		                <th data-field="直播教室名称"  data-sortable="true" data-filter-control="select"  data-visible="true">直播地址</th>
		                <th data-field="直播时间安排"  data-sortable="true" data-filter-control="select"  data-visible="true">直播时间安排</th>
		                <th data-field="主播老师"  data-sortable="true" data-filter-control="select"  data-visible="true">主播老师</th>
		                <th data-field="听课人数"  data-sortable="true" data-filter-control="select"  data-visible="true">听课人数</th>
		                
	              	
		                <th data-field="操作"     data-sortable="true" data-filter-control="select"  data-visible="true">操作</th>
		            </tr>
		        </thead>
		        <tbody id="tbody">
		       
		        <%
		        String SYSID="",livename="",limg="",content="",status="",startime="",endtime="",addtime="";
		        String studentNum="",teacherIds="",ztstatus="",UerIdSQL="";
		        int msgshu=0;
		        ResultSet laoshiRs=null;
		        ResultSet Rs = db.executeQuery(sql);
		        while(Rs.next()){ 
		        	SYSID=Rs.getString("id");
		    		livename=Rs.getString("livename");
		    		content=Rs.getString("content");
		    	 
		    	    startime=Rs.getString("startime");
		    	    endtime=Rs.getString("endtime");
		    		teacherIds=Rs.getString("teacherIds");
		    		status=Rs.getString("status");
		    		addtime=Rs.getString("addtime");
		    		limg=Rs.getString("img");
		        %> <tr>
					<td >
					
					<div align="center"><%if("直播中".equals(status)){%>
					<a href="chat.jsp?id=<%=SYSID %>" target="_blank"><img src="<%=limg %>" width="40" height="30"><br/>
					 <strong><%=Rs.getString("livename") %></strong></a>
					    <%}else{ %>
                       <img src="<%=limg %>" width="40" height="30"><br/>
                       <strong><%=Rs.getString("livename") %></strong>
                      <%} %>
					
					</div></td> 
					
					<td><div align="center">
					<% msgshu=db.Row("SELECT COUNT(*) as row FROM  zb_chat  WHERE   toId='"+Suid+"' AND selftag='0' AND readtag='0' "); %>
               <%if("直播中".equals(status)){%><%=status %><br/><a href="chat.jsp?id=<%=SYSID %>" target="_blank">场控聊天</a>
               <%}else{ %>
                    <%=status %>
                 <%} %>
                  <%if(msgshu>0){ %>(<font color="red"><%=msgshu %>个新留言)<%} %></font>
              </div>
					
					</td>
					
					<td ><strong>FMSURL <font color='red'>rtmp://<%=FMSSERVER %>/live/</font><br>串码流 <font color='red'><%= md5.md5(SYSID)%></font></strong></td> 
					
             <td>
            
           开始时间:<%=startime %><br>结束时间:<%=endtime %></td>

					<td ><span class="STYLE1">
      <%
      if(teacherIds.indexOf("|")!=-1){
       String[] arr = teacherIds.split("\\|");
      for(int i=0;i<arr.length;i++){
      UerIdSQL=UerIdSQL+ " or id="+arr[i];
      }	//
      UerIdSQL=UerIdSQL.replaceFirst("or","");
      //out.print(UerIdSQL+"<br>");
           
       laoshiRs = db.executeQuery(" SELECT id,teacher_name FROM  `teacher_basic` where "+UerIdSQL+"");
	 while (laoshiRs.next()) {  
	     out.print(laoshiRs.getString("teacher_name")+"<br>");
      }if(laoshiRs==null){ laoshiRs.close();}   
   }// .indexOf("\\|")!=-1 end
         UerIdSQL=""; 	
    %></span></td> 
					<td >
					<%=db.Row("SELECT COUNT(*) as row FROM   zb_live_learn  WHERE status=0 and liveid='"+SYSID+"' ") %>/
                    <%=db.Row("SELECT COUNT(*) as row FROM   zb_live_learn  WHERE status=1 and liveid='"+SYSID+"' ") %>

                    </td> 
                    
					<td ><div class="layui-btn-group">
					  <button class="layui-btn" onclick="edit_teach_manage('<%=SYSID %>')">编辑</button>
					  <button class="layui-btn" onclick="deletet('<%=SYSID %>')" style="background-color: #ff0000;">删除</button></div>
					</td>
					</tr>
					
				
					<%}if(Rs!=null){Rs.close();}	  %>
				 
					
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

		        function deletet(id){
					  layer.confirm("确认要删除吗，删除后不能恢复", { title: "删除确认" }, function (index) { 
					                layer.close(index);
					                window.location.href="?ac=deletet&id="+id+"";   						 
					            
					            }); 
				}
				 function new_teach_manage(){
			    	 layer.open({
			    		  type: 2,
			    		  title: '添加教研室',
			    		  shadeClose: true,
			    		  maxmin:1,
			    		  shade: 0.5,
			    		  area: ['1200px', '80%'],
			    		  content: 'classroom_live_add.jsp' 
			    		});
			     }
				 function edit_teach_manage(id){
			    	 layer.open({
			    		  type: 2,
			    		  title: '编辑教研室',
			    		  shadeClose: true,
			    		  maxmin:1,
			    		  shade: 0.5,
			    		  area: ['940px', '80%'],
			    		  content: 'classroom_live_edit.jsp?eid='+id 
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
<% if("deletet".equals(ac)){ 
	
	 String id=request.getParameter("id");
	 if(id==null){id="";}
	try{
	   String dsql="DELETE FROM zb_live WHERE id='"+id+"';";
	   if(db.executeUpdate(dsql)==true){
		   out.println("<script>parent.layer.msg('删除直播室成功');window.location.replace('./classroom_list.jsp');</script>");
	   }
	   else{
		   out.println("<script>parent.layer.msg('删除直播室失败');</script>");
	   }
	 }catch (Exception e){
	    out.println("<script>parent.layer.msg('删除直播室失败');</script>");
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