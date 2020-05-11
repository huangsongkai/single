<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%--教学指导计划分类列表可以添加查询创建 --%>
<%@page trimDirectiveWhitespaces="true" %>
<%@page contentType="text/html; charset=UTF-8" language="java"%>
<%@page import="service.dao.db.Page"%>
<%@page import="v1.haocheok.commom.common"%>
<%@page import="v1.haocheok.commom.entity.UserEntity"%>
<%@include file="../../cookie.jsp"%>
<%
	//获取登录人所属系
	String depSql ="SELECT t1.faculty from user_worker t LEFT JOIN teacher_basic t1 ON t.user_association=t1.id where t.userole=1 and t.uid="+Suid;
	ResultSet depRs = db.executeQuery(depSql);
	String faculty = "";
	while(depRs.next()){
		faculty = depRs.getString("faculty");
	}if(depRs!=null)depRs.close();
%>
<% 
common common=new common();
String dict_departments_id= request.getParameter("dict_departments_id");  //获得传入院系id
String school_year= request.getParameter("school_year");  //获得传入入学年份
String keyword= request.getParameter("keyword");  //获得传入入学年份
String state_approve_id= request.getParameter("state_approve_id");  //获得传入状态
//过滤非法字符
if(regex_num(dict_departments_id)==false ){dict_departments_id="0";}
if(regex_num(school_year)==false ){school_year="0";}
if(regex_num(state_approve_id)==false ){state_approve_id="0";}
if(regex_num(keyword)==false ){keyword="";}
%>
<%
//统计条数
 //收集制定计划id
ResultSet tpcRs=db.executeQuery("SELECT id,state_approve_id FROM  teaching_plan_class_guidance");
while(tpcRs.next()){
	int zkcsRs=db.Row("SELECT  count(*) as row FROM  teaching_plan_guidance WHERE class_guidance_id="+tpcRs.getString("id")+";");
	if(zkcsRs>0 && "1".equals(tpcRs.getString("state_approve_id"))){
		db.executeUpdate("UPDATE  `teaching_plan_class_guidance` SET data_num="+zkcsRs+",state_approve_id=2 WHERE id="+tpcRs.getString("id")+";");
	}else{
	db.executeUpdate("UPDATE  `teaching_plan_class_guidance` SET data_num="+zkcsRs+" WHERE id="+tpcRs.getString("id")+";");}
}if(tpcRs!=null){tpcRs.close();} 
%>
<%
//获取文件后面的对象 数据
        //院系先过滤重复的院系凭接院系初始化查询语句
         String sqlwhereYx=""; //凭接院系查询SQL语句
         ResultSet yxcfRs = db.executeQuery("SELECT  DISTINCT dict_departments_id FROM  teaching_plan_class_guidance   ORDER BY dict_departments_id ASC;");
          while(yxcfRs.next()){
        	  sqlwhereYx=sqlwhereYx+" or dict_departments_id='"+yxcfRs.getString("dict_departments_id")+"'"; 
          }if(yxcfRs!=null){yxcfRs.close();} 
          sqlwhereYx=sqlwhereYx.replaceFirst("or","");
 
		//查找字段名称
		
		//查询的字段局部语句
 		String search=" WHERE p.major_id=m.id AND p.dict_departments_id=d.id and dict_departments_id= '"+faculty+"'";
		if("4".equals(Suserole)){
 		 search=" WHERE p.major_id=m.id AND p.dict_departments_id=d.id ";
		}
		System.out.println(search);
 		//如果院系没有选择就执行院系去重的凭接sqlwhereYx语句
		   if("0".equals(dict_departments_id) && !"".equals(sqlwhereYx)){ 
			   search=search+" and ("+sqlwhereYx+")"; 
			} else{			   
				search=search+" and p.dict_departments_id='"+dict_departments_id+"'"; 
			}
 		 if(!"0".equals(school_year)){
 			search=search+"  and p.school_year='"+school_year+"'  ";
 		  }     
 	    if(keyword.length()>0){
	       search=search+"  and p.teaching_plan_name like '%"+keyword.replaceAll(" ","%")+"%' ";
 	     }     	    	
 	   	if(!"0".equals(state_approve_id)){
			   search=search+"  and p.state_approve_id = '"+state_approve_id+"' ";
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
		String zpag_sql="select count(1) as row  FROM  teaching_plan_class_guidance AS p,major AS m,dict_departments AS d  "+search;
		int zpag= db.Row(zpag_sql);			
		 	
		//SQL语句
       	String sql="SELECT  p.id as sysid,m.id AS major_id,m.major_name,m.majors_number,d.id AS did,d.departments_name,p.add_worker_id,p.addtime,p.dict_departments_id,p.teaching_plan_name,p.school_year,p.data_num,p.state_approve_id FROM  teaching_plan_class_guidance AS p,major AS m,dict_departments AS d   "+search+" order by p.id desc limit  "+(pages-1)*limits+","+limits+";";
       	
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
		     <input id="keyword" type="text" class="layui-input textbox-text" placeholder="输入计划关键字" value="<%=keyword %>" style="width: 125px; height: 35px; color: #272525; background: rgb(227, 227, 227);">
            <select name="dict_departments_id" id="dict_departments_id" lay-verify="required" >
              <option value="0">全部院系</option>
            <%
            //查询院系
            String selectDsql="SELECT  DISTINCT p.dict_departments_id,d.departments_name,d.departments_name,ELT(INTERVAL(CONV(HEX(LEFT(CONVERT(d.departments_name USING gbk),1)),16,10),0xB0A1,0xB0C5,0xB2C1,0xB4EE,0xB6EA,0xB7A2,0xB8C1,0xB9FE,0xBBF7,0xBFA6,0xC0AC,0xC2E8,0xC4C3,0xC5B6,0xC5BE,0xC6DA,0xC8BB,0xC8F6,0xCBFA,0xCDDA,0xCEF4,0xD1B9,0xD4D1),'A','B','C','D','E','F','G','H','J','K','L','M','N','O','P','Q','R','S','T','W','X','Y','Z') AS PY FROM  teaching_plan_class_guidance AS p, dict_departments AS d WHERE   p.dict_departments_id=d.id  ORDER BY py ASC;";
            ResultSet yxRs = db.executeQuery(selectDsql);
            while(yxRs.next()){
            %>
              <option value="<%=yxRs.getString("dict_departments_id") %>"  <%if(yxRs.getString("dict_departments_id").equals(dict_departments_id)){out.print("selected=\"selected\"");} %>><%=yxRs.getString("py") %>-<%=yxRs.getString("departments_name") %></option>
             <%}if(yxRs!=null){yxRs.close();}%>
            </select>
            <select name="school_year"  id="school_year" lay-verify="required">
               <option value="0">全部年份</option>
            <%
            //查询入学年份
            String school_yearSql="SELECT  DISTINCT school_year FROM  teaching_plan_class_guidance     ORDER BY school_year ASC;";
            ResultSet school_yearRs = db.executeQuery(school_yearSql);
            while(school_yearRs.next()){
            %>
              <option value="<%=school_yearRs.getString("school_year") %>" <%if(school_yearRs.getString("school_year").equals(school_year)){out.print("selected=\"selected\"");} %>><%=school_yearRs.getString("school_year") %></option>
             <%}if(school_yearRs!=null){school_yearRs.close();} %>
            </select>
          <select size="1" name="state_approve_id" id="state_approve_id" style="width: 83; height: 23">
           <option value="0">全部状态</option>
             <%
            //查询状态
             ResultSet stateRs = db.executeQuery("SELECT  * FROM  dict_state_approve   ORDER BY id ASC;");
            while(stateRs.next()){
            %>
             <option value="<%=stateRs.getString("id") %>" <%if(stateRs.getString("id").equals(state_approve_id)){out.print("selected=\"selected\"");} %>>[<%=stateRs.getString("id") %>]<%=stateRs.getString("state_name") %></option>
           <%}if(stateRs!=null){stateRs.close();} %>
        </select>
		        <button class="layui-btn layui-btn-small  layui-btn-primary" onclick="ac_tion('')"  style="height: 35px;  color: white; background: rgb(25, 160, 148);"> <i class="layui-icon" style="color: #FFF;">&#xe615;</i> 搜索</button>
		    	<button class="layui-btn layui-btn-small  layui-btn-primary" onclick="Refresh();ac_tion('')"  style="height: 35px;  color: white; background: rgb(25, 160, 148);"> <i class="layui-icon" style="color: #FFF;">&#x1002;</i> 刷新</button>

		        <button class="layui-btn layui-btn-small  layui-btn-primary " onclick="help(<%=PMenuId %>)"  style="height: 35px;  color:#A9A9A9; background: rgb(245, 245, 245);"><i class="layui-icon" >&#xe60c;</i>帮助</button>
		    </div>
    
	    	<table class="cuoz" id="table" data-toggle="table" data-show-toggle="true" data-show-columns="true" data-show-export="true" >
		        <thead>
		            <tr>  

                         <th data-field="计划名"  data-sortable="true" data-filter-control="select"  data-visible="true">计划名</th>
		                 <th data-field="院系名称"  data-sortable="true" data-filter-control="select"  data-visible="true">院系名称</th>
		                 <th data-field="入学年份"  data-sortable="true" data-filter-control="select"  data-visible="true">入学年份</th>
		                 <th data-field="专业名称"  data-sortable="true" data-filter-control="select"  data-visible="true">专业名称</th>
		                 <th data-field="教学进程表"  data-sortable="true" data-filter-control="select"  data-visible="true">教学进程表</th>
		                 <th data-field="审批状态"  data-sortable="true" data-filter-control="select"  data-visible="true">审批状态</th>
	             		 <!--  
		                  <th data-field="送往审核"     data-sortable="true" data-filter-control="select"  data-visible="true">返回修改</th>
		                 -->
		                  <th data-field="查看意见"     data-sortable="true" data-filter-control="select"  data-visible="true">签字</th>
		            </tr>
		        </thead>
		        <tbody id="tbody">
		        <%
		      
		        ResultSet Rs=null; //具体的记录list查询
		        Rs = db.executeQuery(sql);
		        
		        while(Rs.next()){ String stateid=Rs.getString("state_approve_id");%>
		        <tr>
		            <td><%=Rs.getString("teaching_plan_name")%></td>
		            <td><%=Rs.getString("departments_name")%></td>
		            <td><%=Rs.getString("school_year")%></td>
		            <td><a href="guide_batch.jsp?class_id=<%=Rs.getString("sysid")%>&major_id=<%=Rs.getString("major_id")%>&school_year=<%=Rs.getString("school_year")%>&dict_departments_id=<%=Rs.getString("dict_departments_id")%>&departments_name=<%=Rs.getString("departments_name")%>">
		                                [<%=Rs.getString("majors_number")%>]<%=Rs.getString("major_name")%> <span class="layui-badge"><%=Rs.getString("data_num")%>条</td>
		            <td><strong>教学进程表 </span>
		             </a></strong></td>
		             
		             
		             
		           <td><%=common.idToFieidName("dict_state_approve","state_name",stateid) %></td>
		           <%if("5".equals(stateid)||"7".equals(stateid)){%>
		           <!-- 
		            <td><button class="layui-btn" onclick="modify('<%=Rs.getString("sysid")%>')">返回修改</button></td>
		            -->
		           <td><button class="layui-btn" onclick="signature('<%=Rs.getString("sysid")%>')">签字</button></td>
		           
		           <%}else{%>
		           <!--  
		          <td>未送来签字</td>
		          -->
		           <td>待提交</td>
		           <%}%>
		           <%}if(Rs!=null){Rs.close();} %>
		           </tr>
		        </tbody>
	        </table>
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
				       window.location.href="?ac=&dict_departments_id="+$('#dict_departments_id').val()+"&school_year="+$('#school_year').val()+"&keyword="+$('#keyword').val()+"&state_approve_id="+$('#state_approve_id').val();
				}
		      //返回修改
				function modify(sysid){
					 window.location.href="?ac=modify&sysid="+sysid;
				}
				function signature(sysid){
					 layer.open({
			    		 type: 2,
			    		  title: '签字意见',
			    		  shadeClose: true,
			    		  maxmin:1,
			    		  shade: 0.5,
			    		  area: ['940px', '80%'],
			    		  content: 'new_guide_audit.jsp?sysid='+sysid 
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
	 <%if("modify".equals(ac)) {
		String sysid=request.getParameter("sysid");
		 if(db.executeUpdate("UPDATE  `teaching_plan_class_guidance` SET `state_approve_id`=4 WHERE `id`='"+sysid+"';")==true){
			   out.print("<script> alert('已返回修改'); </script>");
			   }else{  out.println("发往签字失败"); }  
	}%> 
	       
      <%if(request.getParameter("index_id")!=null){//接受从首页过来的变量 直接打开某个任务%> 
	    <script>  look('<%=request.getParameter("index_id")%>','<%=request.getParameter("index_name")%>'); </script> 
	 <%} %>
 
	</body> 
</html>
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