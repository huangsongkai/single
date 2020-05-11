<%@page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page trimDirectiveWhitespaces="true" %>
<%@page contentType="text/html; charset=UTF-8" language="java"%>
<%@page import="service.dao.db.Page"%>
<%@page import="v1.haocheok.commom.common"%>
<%@page import="v1.haocheok.commom.commonCourse"%>
<%@page import="v1.haocheok.commom.entity.UserEntity"%>
<%@page import="org.apache.commons.lang3.StringUtils"%>
<%@include file="../../cookie.jsp"%>
<%
       	//获取文件后面的对象 数据
       		String semester = request.getParameter("semester");//获取学期
			if(StringUtils.isBlank(semester)){
				String semSql = "SELECT academic_year from academic_year where this_academic_tag='true' ";
				ResultSet semRs = db.executeQuery(semSql);
				while(semRs.next()){
					semester=semRs.getString("academic_year");
				}
				if(semRs!=null)semRs.close();
			}
			String dict_departments_id = request.getParameter("dict_departments_id"); 
	       	String jiaoyanshi = request.getParameter("teaching_office"); // 教职工所填写教研室
	       	if(StringUtils.isBlank(dict_departments_id)){dict_departments_id="0";}
	       	if(StringUtils.isBlank(jiaoyanshi)){jiaoyanshi="0";}
       	String search_val = request.getParameter("val"); if(search_val==null){search_val="";}else{search_val=search_val.replaceAll("\\s*", "");}
    	semester = semester.replaceAll("\"","");
    	
		//查找字段名称
		common common=new common();
		//查询的字段局部语句
 		String search="where 1=1 ";
 		if(semester.length()!=0&&!semester.equals("0")){
 			//search=search+"and (majors_number like '%"+search_val+"%' or major_name like '%"+search_val+"%' or major_field like '%"+search_val+"%') ";
 			//search="where teacher_name like '%"+search_val+"%'";
 			search = search +" and  t1.semester='"+semester+"' ";
 		}  	
 		if(search_val.length()>0){
 			search = search +" and t2.id = '"+search_val+"'";
 		}
 		if(StringUtils.isNotBlank(dict_departments_id)&&!dict_departments_id.equals("0")){
 			search=search +" and t2.faculty="+dict_departments_id;
 		}
 		if(StringUtils.isNotBlank(jiaoyanshi)&&!jiaoyanshi.equals("0")){
 			search=search +" and t2.teachering_office="+jiaoyanshi;
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
		String zpag_sql="select count(1) as row from arrage_details t LEFT JOIN arrage_coursesystem t1 ON t.arrage_coursesystem_id=t1.id LEFT JOIN teacher_basic t2 ON t.teacher_id = t2.id     "+search+";";
		int zpag= db.Row(zpag_sql);			
		 
		//SQL语句
       //	String sql="select * from teacher_basic  "+search+" order by id asc limit  "+(pages-1)*limits+","+limits+";";
       	String sql ="SELECT       t1.id,t1.teaching_task_id,                                                                                  "+
						"       		t2.teacher_number,                                                            "+
						"       		t2.teacher_name,                                                              "+
						"       		t2.sex,                                                                       "+
						"       		ifnull(t5.teacher_title_name,'') teacher_title_name,                                                        "+
						"       		t.course_id, t6.course_name,                                                                 "+
						"       		t.classid,                                                                   "+
						"       		t3.class_name,                                                                "+
						"       		t3.people_number_nan,t3.people_number_woman,                                                                "+
						"       		t.timetable,                                                             "+
						"       		t4.classroomname,                                                             "+
						"       		t.weeks                                                             "+
						"       	FROM                                                                              "+
						"       		arrage_details t                                                         "+
						"       	LEFT JOIN arrage_coursesystem t1 ON t.arrage_coursesystem_id=t1.id                                 "+
						"       	LEFT JOIN teacher_basic t2 ON t.teacher_id = t2.id                         "+
						"       	LEFT JOIN teacher_title t5 ON t2.technical_title = t5.id                                  "+
						"       	LEFT JOIN class_grade t3 ON t.classid = t3.id                                  "+
						"       	LEFT JOIN dict_courses t6 ON t.course_id = t6.id                                    "+
						"       	LEFT JOIN classroom t4 ON t.classroomid = t4.id  "+search+" order by t.id asc limit  "+(pages-1)*limits+","+limits+";";

       	System.out.println("sql "+sql);
       	String html_str="";  //页面代码
       	//开始查询
       	StringBuffer sb1 = new StringBuffer();
        ResultSet Rs = db.executeQuery(sql);
        while(Rs.next()){
         	String sex ="";
         	if(Rs.getString("sex")!=null&&Rs.getString("sex").equals("1")){
         		sex="男";
         	}else{
         		sex ="女";
         	}
         	StringBuffer sb = new StringBuffer();
         	if(StringUtils.isNotBlank(Rs.getString("timetable"))){
         		ArrayList<ArrayList<String>> ary = commonCourse.toArrayList(Rs.getString("timetable"),"*","#");
         		for(int i=0;i<ary.size();i++){
         			if(ary.get(i).contains("0")){
         			sb.append("周"+(i+1)+commonCourse.getSection(ary.get(i))+" ");
         			}
         		}
         	}
         	
         	html_str="<tr>"+
			"<td ><strong>"+Rs.getString("teacher_number")+"</strong></td>"+
			"<td ><strong>"+Rs.getString("teacher_name")+"</strong></td>"+
			"<td ><strong>"+sex+"</strong></td>"+
			"<td ><strong>"+Rs.getString("teacher_title_name")+"</strong></td>"+
			"<td ><strong>"+Rs.getString("course_name")+"</strong></td>"+
			"<td ><strong>"+Rs.getString("class_name")+"</strong></td>"+
			"<td ><strong>"+(Rs.getInt("people_number_nan")+Rs.getInt("people_number_woman"))+"</strong></td>"+
			"<td ><strong>"+sb.toString()+"</strong></td>"+
			//"<td ><strong>"+Rs.getString("timetable")+"</strong></td>\r\n"+
			"<td ><strong>"+Rs.getString("classroomname")+"</strong></td>"+
			"<td ><strong>"+Rs.getString("weeks")+"</strong></td>"+
						"<td >"+
						    "<div class=\"layui-btn-group\">"+
					             "<button class=\"layui-btn\" onclick=\"edit('"+Rs.getString("teaching_task_id")+"')\">明细</button>"+
					 	"</div>"+
						"</td>"+
				      "</tr>";
		sb1.append(html_str);
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
		 	<script src="../../js/ajaxs.js"></script>
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
						    <select id="search"  lay-search>
						<option value="">请选择老师</option>
						<option value="无">无</option>
						<%
							String laoshi_sql = "select id,teacher_name from teacher_basic";
							ResultSet laoshi_set = db.executeQuery(laoshi_sql);
							while(laoshi_set.next()){
						%>
							<option value="<%=laoshi_set.getString("id") %>" ><%=laoshi_set.getString("teacher_name") %></option>
						<%}if(laoshi_set!=null){laoshi_set.close();} %>
				</select>
				  <select name=semester  id="semester" lay-verify="required" lay-filter="semester" lay-search>
	            	<option value="0" selected>全部</option>
	            	<%
	            		String semesterSql =  "SELECT t.academic_year FROM academic_year t order by t.academic_year desc ";
	            		ResultSet semesterRs = db.executeQuery(semesterSql);
	            		while(semesterRs.next()){
	            				if(semester.equals(semesterRs.getString("academic_year"))){
	            					%>
	            				<option value="<%=semesterRs.getString("academic_year") %>"  selected><%=semesterRs.getString("academic_year") %></option>
	            					<%}else{%>
	            				<option value="<%=semesterRs.getString("academic_year") %>" ><%=semesterRs.getString("academic_year") %></option>
	            			<%}}%>
	            </select>
					
		        <button class="layui-btn layui-btn-small  layui-btn-primary" onclick="ac_tion('')"  style="height: 35px;  color: white; background: rgb(25, 160, 148);"> <i class="layui-icon" style="color: #FFF;">&#xe615;</i> 搜索</button>
		    	<button class="layui-btn layui-btn-small  layui-btn-primary" onclick="Refresh();ac_tion('')"  style="height: 35px;  color: white; background: rgb(25, 160, 148);"> <i class="layui-icon" style="color: #FFF;">&#x1002;</i> 刷新</button>
		        </div>
		    </div>
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
		                <th data-field="教师编号"  data-sortable="true" data-filter-control="select"  data-visible="true">教师编号</th>
		                <th data-field="专业编号"  data-sortable="true" data-filter-control="select"  data-visible="true">教师姓名</th>
		                <th data-field="性别"  data-sortable="true" data-filter-control="select"  data-visible="true">性别</th>
	              	    <th data-field="职称"  data-sortable="true" data-filter-control="select"  data-visible="true">职称</th>
	              	    <th data-field="开课课程"  data-sortable="true" data-filter-control="select"  data-visible="true">开课课程</th>
		                <th data-field="上课班级"  data-sortable="true" data-filter-control="select"  data-visible="true">上课班级</th>
		                <th data-field="人数"  data-sortable="true" data-filter-control="select"  data-visible="true">人数</th>
		                <th data-field="上课时间"  data-sortable="true" data-filter-control="select"  data-visible="true">上课时间</th>
		                <th data-field="上课地点"  data-sortable="true" data-filter-control="select"  data-visible="true">上课地点</th>
		                <th data-field="上课周次"  data-sortable="true" data-filter-control="select"  data-visible="true">上课周次</th>
		                <th data-field="操作"     data-sortable="true" data-filter-control="select"  data-visible="true">操作</th>
		            </tr>
		        </thead>
		        <tbody id="tbody">
					<%=sb1.toString()%>
		        </tbody>
	        </table>
	        <div id="pages"  style="float: right;"></div>
	    </div>    
	    <script type="text/javascript">  
	    
	    		//搜索内容
	    		var semester='<%=semester%>';
	    		var search_val='<%=search_val%>';
	    		var dict_departments_id='<%=dict_departments_id%>';
				var teaching_office='<%=jiaoyanshi%>';
	    		search_val=search_val.replace(/(^\s*)|(\s*$)/g, "");//处理空格
	    		
	    		if(search_val.length>=1){
	    			modify('search',search_val);
	    		}
	    		if(semester>=1){
	    			modify('semester',semester);
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
				  ,layer = layui.layer
				  ,form = layui.form;
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
									     	 window.location.href="?ac=&semester="+$('#semester').val()+"&dict_departments_id="+dict_departments_id+"&teaching_office="+teaching_office+"&pag="+curr+"&limit="+limit;
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
<%--					 	form.on('select(semester)', function(data){--%>
<%--						    var semesterval = JSON.stringify(data.value);--%>
<%--						    if(semesterval=='0'){--%>
<%--								return false;--%>
<%--							    }else{--%>
<%--								    window.location.href="teacher_classtime.jsp?ac=&semester="+semesterval+"&val="+$('#search').val()--%>
<%--									return true;--%>
<%--								    }--%>
<%--						});--%>
				});
   
		        //执行
		        function ac_tion() {
			           	var dict_departments_id = $("#dict_departments_id").val();
				    	var teaching_office = $("#teaching_office").val();
			        	var semesterval = $('#semester').val();
		        		window.location.href="teacher_classtime.jsp?ac=&semester="+semesterval+"&val="+$('#search').val()+"&dict_departments_id="+dict_departments_id+"&teaching_office="+teaching_office;
				     //  window.location.href="?ac=&val="+$('#search').val()+"";
				}

		        function edit(id){
		        	var semester = $('#semester').val();
		           layer.open({
		     		 type: 2,
		     		  title: '明细',
		     		  maxmin:1,
		     		  shade: 0.5,
		     		  area: ['100%', '100%'],
		     		 content: 'teach_shezhi.jsp?id='+id+'&school_year='+semester+"&state=0"
		     		});
		         }
	    </script>
	      
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
