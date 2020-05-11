<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%--生成任务书分类列表可以添加查询创建 --%>
<%@page trimDirectiveWhitespaces="true" %>
<%@page contentType="text/html; charset=UTF-8" language="java"%>
<%@page import="service.dao.db.Page"%>
<%@page import="v1.haocheok.commom.common"%>
<%@page import="v1.haocheok.commom.entity.UserEntity"%>
<%@include file="../../cookie.jsp"%>
<% 
common common=new common();
String dict_departments_id= request.getParameter("dict_departments_id");  //获得传入院系id
String school_year= request.getParameter("school_year");  //获得传入入学年份
String keyword= request.getParameter("keyword");  //获得传入入学年份

//过滤非法字符
if(regex_num(dict_departments_id)==false ){dict_departments_id="0";}
if(regex_num(school_year)==false ){school_year="0";}
if(regex_num(keyword)==false ){keyword="";}
%>
<%
//统计条数
 //收集制定计划id
ResultSet tpcRs=db.executeQuery("SELECT id FROM  teaching_task_class");
while(tpcRs.next()){
	int zkcsRs=db.Row("SELECT  count(1) as row FROM  teaching_task WHERE  typestate=1 and teaching_task_class_id="+tpcRs.getString("id")+";");
	db.executeUpdate("UPDATE  `teaching_task_class` SET data_num="+zkcsRs+" WHERE id="+tpcRs.getString("id")+";");
}if(tpcRs!=null){tpcRs.close();} 
%>
<%
//获取文件后面的对象 数据
        //院系先过滤重复的院系凭接院系初始化查询语句
         String sqlwhereYx=""; //凭接院系查询SQL语句
         ResultSet yxcfRs = db.executeQuery("SELECT  DISTINCT dict_departments_id FROM  teaching_plan_class   ORDER BY dict_departments_id ASC;");
          while(yxcfRs.next()){
        	  sqlwhereYx=sqlwhereYx+" or t.dict_departments_id='"+yxcfRs.getString("dict_departments_id")+"'"; 
          }if(yxcfRs!=null){yxcfRs.close();} 
          sqlwhereYx=sqlwhereYx.replaceFirst("or","");
         
		//查找字段名称
		
		//查询的字段局部语句
 		String search="   ";
 		//如果院系没有选择就执行院系去重的凭接sqlwhereYx语句
		   if("0".equals(dict_departments_id)){ 
			   search=search+" AND ("+sqlwhereYx+")"; 
			} else{			   
				search=search+" and t.dict_departments_id='"+dict_departments_id+"'"; 
			}
 		 if(!"0".equals(school_year)){
 			search=search+"  and t.school_year='"+school_year+"'  ";
 		  }     
 	    if(keyword.length()>0){
	       search=search+"  and t.teaching_task_name like '%"+keyword.replaceAll(" ","%")+"%' ";
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
		String zpag_sql="SELECT  count(1) as row FROM  teaching_task_class AS t WHERE 1=1 "+search+"; ";
		int zpag= db.Row(zpag_sql);			
		 	
		//SQL语句
       	String sql="SELECT 											"+
	  "     	  t.id                  AS taskid,                  "+
	  "     	  m.id                  AS major_id,                "+
	  "     	  m.major_name,                                     "+
	  "     	  m.majors_number,                                  "+
	  "     	  d.id                  AS did,                     "+
	  "     	  d.departments_name,                               "+
	  "     	  t.add_worker_id,                                  "+
	  "     	  t.addtime,                                        "+
	  "     	  t.dict_departments_id,                            "+
	  "     	  t.teaching_task_name,                             "+
	  "     	  t.school_year,                                    "+
	  "     	  t.data_num,                                       "+
	  "     	  c.class_name,                                     "+
	  "     	  t.start_semester                                  "+
	  "     	FROM teaching_task_class AS t                       "+
	  "     	  LEFT JOIN class_grade AS c                        "+
	  "     	    ON t.class_grade_id = c.id                      "+
	  "     	  LEFT JOIN major AS m                              "+
	  "     	    ON t.major_id = m.id                            "+
	  "     	  LEFT JOIN dict_departments AS d                   "+
	  "     	    ON t.dict_departments_id = d.id                 "+
      "			WHERE 1=1											"+
      search+" order by t.id desc limit  "+(pages-1)*limits+","+limits+";";

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
			<script type="text/javascript" src="../../js/ajaxs.js" ></script>
		<script type="text/javascript" src="../../js/layerCommon.js" ></script>
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
		    <input id="keyword" type="text" class="layui-input textbox-text" placeholder="输入计划关键字" value="<%=keyword %>" style="width: 125px; height: 35px; color: #272525; background: rgb(227, 227, 227);">
            <select name="dict_departments_id" id="dict_departments_id" lay-verify="required" >
              <option value="0">全部院系</option>
            <%
            //查询院系
            String selectDsql="SELECT  DISTINCT p.dict_departments_id,d.departments_name,d.departments_name,ELT(INTERVAL(CONV(HEX(LEFT(CONVERT(d.departments_name USING gbk),1)),16,10),0xB0A1,0xB0C5,0xB2C1,0xB4EE,0xB6EA,0xB7A2,0xB8C1,0xB9FE,0xBBF7,0xBFA6,0xC0AC,0xC2E8,0xC4C3,0xC5B6,0xC5BE,0xC6DA,0xC8BB,0xC8F6,0xCBFA,0xCDDA,0xCEF4,0xD1B9,0xD4D1),'A','B','C','D','E','F','G','H','J','K','L','M','N','O','P','Q','R','S','T','W','X','Y','Z') AS PY FROM  teaching_task_class AS p, dict_departments AS d WHERE   p.dict_departments_id=d.id  ORDER BY py ASC;";
            ResultSet yxRs = db.executeQuery(selectDsql);
            while(yxRs.next()){
            %>
              <option value="<%=yxRs.getString("dict_departments_id") %>"  <%if(yxRs.getString("dict_departments_id").equals(dict_departments_id)){out.print("selected=\"selected\"");} %>><%=yxRs.getString("py") %>-<%=yxRs.getString("departments_name") %></option>
             <%}if(yxRs!=null){yxRs.close();} %>
            </select>
            <select name="school_year"  id="school_year" lay-verify="required">
               <option value="0">全部年份</option>
            <%
            //查询入学年份
            String school_yearSql="SELECT  DISTINCT school_year FROM  teaching_plan_class     ORDER BY school_year ASC;";
            ResultSet school_yearRs = db.executeQuery(school_yearSql);
            while(school_yearRs.next()){
            %>
              <option value="<%=school_yearRs.getString("school_year") %>" <%if(school_yearRs.getString("school_year").equals(school_year)){out.print("selected=\"selected\"");} %>><%=school_yearRs.getString("school_year") %></option>
             <%}if(school_yearRs!=null){school_yearRs.close();} %>
            </select>
         
		        <button class="layui-btn layui-btn-small  layui-btn-primary" onclick="ac_tion('')"  style="height: 35px;  color: white; background: rgb(25, 160, 148);"> <i class="layui-icon" style="color: #FFF;">&#xe615;</i> 搜索</button>
		    	<button class="layui-btn layui-btn-small  layui-btn-primary" onclick="Refresh();ac_tion('')"  style="height: 35px;  color: white; background: rgb(25, 160, 148);"> <i class="layui-icon" style="color: #FFF;">&#x1002;</i> 刷新</button>
		        <button class="layui-btn layui-btn-small  layui-btn-primary" onclick="add();"  style="height: 35px;  color: white; background: rgb(25, 160, 148);"> <i class="layui-icon" style="color: #FFF;">&#xe61f;</i> 制定任务书</button>
		        <button class="layui-btn layui-btn-small  layui-btn-primary " onclick="help(<%=PMenuId %>)"  style="height: 35px;  color:#A9A9A9; background: rgb(245, 245, 245);"><i class="layui-icon" >&#xe60c;</i>帮助</button>
		    </div>
    
	    	<table class="cuoz" id="table" data-toggle="table" data-show-toggle="true" data-show-columns="true" data-show-export="true" >
		        <thead>
		            <tr>  
                         <th data-field="任务书名"  data-sortable="true" data-filter-control="select"  data-visible="true">任务书名</th>
		                 <th data-field="院系名称"  data-sortable="true" data-filter-control="select"  data-visible="true">院系名称</th>
		                 <th data-field="入学年份"  data-sortable="true" data-filter-control="select"  data-visible="true">入学年份</th>
		                 <th data-field="开课学期"  data-sortable="true" data-filter-control="select"  data-visible="true">开课学期</th>
		                 <th data-field="专业名称"  data-sortable="true" data-filter-control="select"  data-visible="true">专业名称</th>
		                 <th data-field="班级名称"  data-sortable="true" data-filter-control="select"  data-visible="true">班级名称</th>
		                 <th data-field="删除任务书"  data-sortable="true" data-filter-control="select"  data-visible="true">删除任务书</th>                  
		                 <th data-field="添加时间"    data-sortable="false" data-filter-control="false"  data-visible="false">添加时间</th>
		                 <th data-field="操作人"    data-sortable="false" data-filter-control="false"  data-visible="false">操作人</th>
		            </tr>
		     </thead>
		        <tbody id="tbody">
		        <%		      
		        ResultSet Rs=null; //具体的记录list查询
		        Rs = db.executeQuery(sql);
		       
		        while(Rs.next()){ 
		       //学期
		        int start_semester=Integer.parseInt(Rs.getString("start_semester"));
		       //年份
		        int year=Integer.parseInt(Rs.getString("school_year"));
		     
		       //求学期学号
		        int yearq=((start_semester-1)/2);
		       
		        int yeary=start_semester%2;
		        String years="";
		        if(yeary==0){
		        	years=(year+yearq)+"-"+(year+yearq+1)+"-"+2;
		        }else{
		        	years=(year+yearq)+"-"+(year+yearq+1)+"-"+1;
		        }
		        %>
		        <tr>
		            <td><%=Rs.getString("teaching_task_name")%></td>
		            <td><%=Rs.getString("departments_name")%></td>
		            <td><%=year%></td>
		             <td><%=years%></td>
		            <td>
		            <a href="teach_plan_list.jsp?class_id=<%=Rs.getString("taskid")%>&school_year=<%=years%>&departments_name=<%=Rs.getString("departments_name")%>">
		                                [<%=Rs.getString("majors_number")%>]<%=Rs.getString("major_name")%> <span class="layui-badge"><%=Rs.getString("data_num")%>条</td>	           
		             </a></strong></td>
		             <td><%=Rs.getString("class_name")%></td>
		           <td><button class="layui-btn" onclick="delete_ren('<%=Rs.getString("taskid")%>')">删除任务书</button></td>
		            <td><%=Rs.getString("addtime")%></td>
		            <td><%=common.getusernameTouid(Rs.getString("add_worker_id"))%></td>
		           <%}if(Rs!=null){Rs.close();} %>
		           </tr>
		        </tbody>
	        </table>
	         <div id="asc" class="form_top layui-form" style="display: flex;    ">
		    </div>

	        <div id="pages"  style="float: right;"></div>
	    </div>    
	    <script type="text/javascript">  
	    
	    		//搜索内容
	    		var dict_departments_id=<%=dict_departments_id%>;
	    		 
	    		if(dict_departments_id.length>=1){
	    			modify('search',dict_departments_id);
	    		}
	    		//改变某个id的值
	    		function modify (id,dict_departments_id){
	    			$("#"+id+"").val(""+dict_departments_id+"")
	    		} 
	    		 //清空 搜索输入框
	    		function Refresh(){
	    			$("#keword").val("");
	    		} 
	    		 //刷新整个页面
	    		function shuaxin(){
	    			 location.reload();
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
									         
									     	 window.location.href="?ac=&dict_departments_id="+$('#dict_departments_id').val()+"&school_year="+$('#school_year').val()+"&state_approve_id="+$('#state_approve_id').val()+"&keyword="+$('#keyword').val()+"&pag="+curr+"&limit="+limit; 
								    }
						      }
					    });
				});
			    
		         
		        //执行
		        function ac_tion() {
				       window.location.href="?ac=&dict_departments_id="+$('#dict_departments_id').val()+"&school_year="+$('#school_year').val()+"&keyword="+$('#keyword').val();
				}

				//删除任务书
				function delete_ren(id){
					layer.confirm('确定删除?', function(index){
				
						var str = {"teaching_task_class_id":id};
						var obj = JSON.stringify(str);
						var ret_str=PostAjx('../../../../Api/v1/?p=web/do/doDelTasks',obj,'<%=Suid%>','<%=Spc_token%>');
						var obj = JSON.parse(ret_str);
						if(obj.success && obj.resultCode=="1000"){
							layer.msg("删除成功",{icon:1,time:1000,offset:'150px'},function(){
								 window.location.reload(true);
						   });
						}else{
							layer.msg("删除失败",{icon:2,time:1000,offset:'150px'},function(){
								 window.location.reload(true);
						   });
						}
						  layer.close(index);
						}); 
					//layer.confirm("确认要删除吗，删除后不能恢复", { title: "删除确认" }, function (index) { 
		             //   layer.close(index);
		              //  window.location.href="?ac=deletet&delid="+id+"";   						 
		            //}); 
				}
			
                //生成任务书
			     function add(){
			    	 layer.open({
			    		 type: 2,
			    		  title: '生成任务书',
			    		  shadeClose: true,
			    		  maxmin:1,
			    		  shade: 0.5,
			    		  area:['940px', '80%'],
			    		  content: 'new_create_plan.jsp' 
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
	
	 String delid=request.getParameter("delid");
	 if(delid==null){delid="";}
	try{
	   String dsql="DELETE FROM teaching_task_class WHERE id='"+delid+"';";
	   String base_dsql = "DELETE FROM teaching_task WHERE teaching_task_class_id='"+delid+"';";
	   if(db.executeUpdate(dsql)==true){
		   if(db.executeUpdate(base_dsql)==true){
			   out.println("<script>parent.layer.msg('删除成功');window.location.replace('./create_plan_list.jsp');</script>");
		   }else{
			   out.println("<script>parent.layer.msg('删除失败');</script>");
		   }
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