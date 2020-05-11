<%@ page trimDirectiveWhitespaces="true" %>
<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@page import="service.dao.db.Page"%>
<%@include file="../../cookie.jsp"%>
<%@page import="org.apache.commons.lang3.StringUtils"%>
<%@page import="v1.haocheok.commom.commonCourse"%>
<!DOCTYPE html>
<html>
<head> 
    <meta charset="utf-8"> 
    <meta name="viewport" content="width=device-width, initial-scale=1"> 
     <link rel="stylesheet" href="../../../pages/css/sy_style.css?22">	    
	    <link rel="stylesheet" href="../../js/layui2/css/layui.css">
		<script type="text/javascript" src="../../js/jquery-1.9.1.js" ></script><!--通用jquery-->
		<script src="../../js/layui2/layui.js"></script>
		<script type="text/javascript" src="../../js/tableExport/js/table-sort.js" ></script><!--表格排序js  css-->
		<script type="text/javascript" chartset="utf8" src="../../js/tableExport/js/table_list.js " ></script><!--表格导出js  css-->
	 <script type="text/javascript" src="../../../custom/jquery.easyui.min.js"></script>
 <link rel="stylesheet" href="../../../custom/easyui/tree.css" />
    <title>修改课时</title> 
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
<body style="height: 100%">
	<%
		String semester ="";
		String semSql = "SELECT academic_year from academic_year where this_academic_tag='true' ";
		ResultSet semRs = db.executeQuery(semSql);
		while(semRs.next()){
			semester=semRs.getString("academic_year");
		}
		if(semRs!=null)semRs.close();
	%>
       <div class="" style="padding-bottom: 0px;margin-left: 1%;margin-right: 1%; height:auto;">  
	<div id="tb" class="form_top layui-form"  style="display: flex;"><br>
        	<%
				commonCourse  commonCourse= new commonCourse();
		 		String bank_sql ="SELECT        t1.id,                                                                         "+
								"		 			t2.class_begins_weeks,                                            "+
								"		 			t2.teaching_week_time,                                            "+
								"		 			t2.teacherid,                                                     "+
								"		 			t3.people_number_nan,                                             "+
								"		 			t3.people_number_woman,                                           "+
								"		 			t3.class_name,                                                    "+
								"		 			t4.course_name                                                    "+
								"		 		FROM                                                                  "+
								"		 			teaching_task t1                                                  "+
								"		 		RIGHT JOIN teaching_task_teacher t2 ON t1.id = t2.teaching_task_id    "+
								"		 		LEFT JOIN class_grade t3 ON t1.class_id=t3.id                         "+
								"		 		LEFT JOIN dict_courses t4 ON t1.course_id=t4.id                       "+
								"		 		WHERE                                                                 "+
								"		 			t1.typestate = 2                                                  "+
								"		 		AND t1.semester = '"+semester+"'                                       "+
								"		 		AND teacherid = "+Sassociationid+"";

		 		String teacherWeekSql = "SELECT  t.id,   t.teaching_task_id,                                                                  "+
												"	 			t.week,                                               "+
												"	 			t.teaching_time,                                      "+
												"	 			t.teacherid,                                          "+
												"	 			t3.people_number_nan,                                 "+
												"	 			t3.people_number_woman,                               "+
												"	 			t3.class_name,                                        "+
												"	 			t4.course_name, t.state,                                       "+
												"	 			t.remark ,t.add_time                                       "+
												"	 		FROM                                                      "+
												"	 			teacher_week t                                        "+
												"	 		LEFT JOIN teaching_task t1 ON t.teaching_task_id = t1.id  "+
												"	 		LEFT JOIN class_grade t3 ON t1.class_id = t3.id           "+
												"	 		LEFT JOIN dict_courses t4 ON t1.course_id = t4.id         "+
												"	 		WHERE                                                     "+
												"	 			t.teacherid = "+Sassociationid+"                                        "+
												"	 		AND t1.semester = '"+semester+"'";
		 		System.out.println(teacherWeekSql);
		 		System.out.println(bank_sql);
		 		
				int totalWeekTime =0; //总课时
		 		int totalNum =0; //总条数
		 		int totalCheck =0; //总送审数
		 		int totalPassCheck =0 ; //总送审通过
		        StringBuffer sb = new StringBuffer();
		        String html_str ="";
		 		if(Suserole.equals("1")){
		 		ArrayList<String> weekd = new ArrayList<String>();
		 		ResultSet teaWeRs = db.executeQuery(teacherWeekSql);
		 
		 		while(teaWeRs.next()){
		 			
		 			int boyNum =0;
        			int girlNum =0;
        			if(StringUtils.isNotBlank(teaWeRs.getString("people_number_nan"))){
        				boyNum =Integer.parseInt(teaWeRs.getString("people_number_nan"));
        			}
        			if(StringUtils.isNotBlank(teaWeRs.getString("people_number_woman"))){
        				girlNum =Integer.parseInt(teaWeRs.getString("people_number_woman"));
        			}
        			String marks = teaWeRs.getString("remark");
        			if(StringUtils.isBlank(teaWeRs.getString("remark"))){
        				marks ="";
        			}
        			String add_time = teaWeRs.getString("add_time");
        			if(StringUtils.isBlank(teaWeRs.getString("add_time"))){
        				add_time ="";
        			}
        			String stateName = "";
        			String buttHtml  ="";
        			if(teaWeRs.getString("state").equals("1")){
        				stateName ="未送审";
        				buttHtml ="<a onclick='editWeeks("+teaWeRs.getString("id")+")'>修改</a><a onclick='sendCheck("+teaWeRs.getString("id")+")'>送审</a>";
        			}else if(teaWeRs.getString("state").equals("2")){
        				stateName ="已送审";
        				buttHtml ="";
        				totalCheck++;
        			}else if(teaWeRs.getString("state").equals("3")){
        				stateName ="已签字";
        				buttHtml ="";
        				totalPassCheck++;
        			}else  if(teaWeRs.getString("state").equals("4")){
        				stateName ="已拒绝";
        				buttHtml ="<a onclick='editWeeks("+teaWeRs.getString("id")+")'>修改</a><a onclick='sendCheck("+teaWeRs.getString("id")+")'>送审</a>";
        			}
		 			weekd.add(teaWeRs.getString("week")+","+teaWeRs.getString("teaching_task_id"));
		 			totalWeekTime = totalWeekTime+teaWeRs.getInt("teaching_time");
		 			totalNum++;
		 			
		 			html_str =  "<tr id='"+teaWeRs.getString("id")+"'>"
						//	+"<td ><input type='checkbox' name='' lay-skin='primary'></td> "
							+"<td class=\"\">"+teaWeRs.getString("week") +"</td>          "
							+"<td class=\"\">"+teaWeRs.getString("course_name")+"</td>         "
							+"<td class=\"\">"+teaWeRs.getString("class_name")+"</td>         "
							+"<td class=\"\">"+teaWeRs.getString("teaching_time")+"</td>         "
							+"<td class=\"\">"+(boyNum+girlNum)+"</td>         "
							+"<td class=\"\">"+marks+"</td>         "
							+"<td class=\"\">"+stateName+"</td>         "
							+"<td class=\"\">"+add_time+"</td>         "
							//+"<td class=\"\"> <a onclick='editWeeks("+teaWeRs.getString("id")+")'>修改</a><a onclick='sendCheck("+teaWeRs.getString("id")+")'>送审</a>"+"</td> "
							+"<td class=\"\"> "+buttHtml+"</td> "
					+"</tr>"; 
		 			sb.append(html_str);
		 		}if(teaWeRs!=null)teaWeRs.close();
		
            		ResultSet groups = db.executeQuery(bank_sql);
            		while(groups.next()){
            			int boyNum =0;
            			int girlNum =0;
            			String taskid = groups.getString("id");
            			if(StringUtils.isNotBlank(groups.getString("people_number_nan"))){
            				boyNum =Integer.parseInt(groups.getString("people_number_nan"));
            			}
            			if(StringUtils.isNotBlank(groups.getString("people_number_woman"))){
            				girlNum =Integer.parseInt(groups.getString("people_number_woman"));
            			}
            			
            			ArrayList<String> weeks = new ArrayList<String>();
            			ArrayList<String> weekinfo = new ArrayList<String>();
            		
            			if(StringUtils.isNotBlank(groups.getString("class_begins_weeks"))){
            				weeks = commonCourse.setWeekly(groups.getString("class_begins_weeks"));
            				for(int i=0;i<weeks.size();i++){
            					weekinfo.add(weeks.get(i)+","+taskid);
            				}
            			}
            			weekinfo.removeAll(weekd);
            			weeks = weekinfo;
            			for(int i=0;i<weeks.size();i++){
            				
            				totalWeekTime = totalWeekTime+groups.getInt("teaching_week_time");
        		 			totalNum++;
            			html_str = "<tr>"
						//	+"<td ><input type='checkbox' name='' lay-skin='primary'></td> "
   							+"<td class=\"\">"+weeks.get(i).substring(0,weeks.get(i).indexOf(",")) +"</td>          "
   							+"<td class=\"\">"+groups.getString("course_name")+"</td>         "
   							+"<td class=\"\">"+groups.getString("class_name")+"</td>         "
   							+"<td class=\"\">"+groups.getString("teaching_week_time")+"</td>         "
   							+"<td class=\"\">"+(boyNum+girlNum)+"</td>         "
   							+"<td class=\"\"></td>         "
   							+"<td class=\"\">未送审</td>         "
   							+"<td class=\"\"></td>         "
   							+"<td class=''> <a onclick='editnewWeeks("+groups.getString("id")+","+groups.getString("teacherid")+","+weeks.get(i).substring(0,weeks.get(i).indexOf(","))+","+groups.getString("teaching_week_time")+")'>修改</a><a onclick='sendNewCheck("+groups.getString("id")+","+groups.getString("teacherid")+","+weeks.get(i).substring(0,weeks.get(i).indexOf(","))+","+groups.getString("teaching_week_time")+")'>送审</a>"+"</td> "
						+"</tr>"; 
        	 			sb.append(html_str);
            			}
            		}if(groups!=null){groups.close();}
		 		}
		         %>
		    </div>
		    <div style=" padding-top: 53px;margin-bottom: 20px;">
			    <h4><strong>学期 : <%=semester %>&nbsp;&nbsp;  总条数 :<%=totalNum %> &nbsp;&nbsp;&nbsp;    送审条数 : <%=totalCheck %>   &nbsp;&nbsp;&nbsp;  送审通过 : <%=totalPassCheck %>  &nbsp;&nbsp;&nbsp;   课时总计 : <%=totalWeekTime %></strong></h4>
		    </div>
    <table class="cuoz" id="table" data-toggle="table"  >
        <thead>
            <tr>
<%--            	<th data-field="state"   data-checkbox="true"><input type="checkbox" name="" ></th>--%>
              <th data-field="周次"     data-sortable="true" data-filter-control="select" data-visible="true" >周次</th>
              <th data-field="课程"     data-sortable="true" data-filter-control="select" data-visible="true" >课程</th>
              <th data-field="班级"     data-sortable="true" data-filter-control="select" data-visible="true" >班级</th>
              <th data-field="周学时"     data-sortable="true" data-filter-control="select" data-visible="true" >周学时</th>
              <th data-field="人数"     data-sortable="true" data-filter-control="select" data-visible="true" >人数</th>
              <th data-field="备注"     data-sortable="true" data-filter-control="select" data-visible="true" >备注</th>
              <th data-field="状态"     data-sortable="true" data-filter-control="select" data-visible="true" >状态</th>
              <th data-field="通过/拒绝时间"     data-sortable="true" data-filter-control="select" data-visible="true" >通过/拒绝时间</th>
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
		});
    layui.use(['form', 'layedit', 'laydate'], function(){
		  var form = layui.form
		  ,layer = layui.layer
		  ,layedit = layui.layedit
		  ,laydate = layui.laydate;
			form.render(); 
	});   
    
     function editnewWeeks(taskid,teacherid,week,teaching_time){
    	 layer.open({
			  type: 2,
			  title: '修改课时',
			  offset: 't',
			  maxmin:1,
			  shade: 0.5,
			  area: ['100%', '100%'],
			  content: 'insert_teacher_week.jsp?taskid='+taskid+'&teacherid='+teacherid+'&week='+week+'&teaching_time='+teaching_time
		});
    } 
     function editWeeks(id){
    	 layer.open({
			  type: 2,
			  title: '修改课时',
			  offset: 't',
			  maxmin:1,
			  shade: 0.5,
			  area: ['100%', '100%'],
			  content: 'insert_teacher_week.jsp?id='+id
		});
    } 

     function sendCheck(id){
     	layer.confirm("确认要送审吗", { title: "送审确认" }, function (index) { 
             layer.close(index);
             window.location.href="?ac=sendCheck&id="+id+"";   						 
         }); 
	    }

     function sendNewCheck(taskid,teacherid,week,teaching_time){
    		layer.confirm("确认要送审吗", { title: "送审确认" }, function (index) { 
             layer.close(index);
             window.location.href="?ac=sendNewCheck&taskid="+taskid+"&teacherid="+teacherid+"&week="+week+"&teaching_time="+teaching_time+"";   						 
         }); 
	    }
    
  </script>  
    
</body> 
</html>
<% 
if("sendCheck".equals(ac)){ 
	 String id=request.getParameter("id");
	 if(id==null){return;}
	try{
		String upSql =" update teacher_week set state=2 where id="+id;
	   if(db.executeUpdate(upSql)==true){
		   out.println("<script>parent.layer.msg('送审成功');window.location.replace('./teacher_week.jsp');</script>");
	   }
	   else{
		   out.println("<script>parent.layer.msg('送审失败');</script>");
	   }
	 }catch (Exception e){
	    out.println("<script>parent.layer.msg('送审失败');</script>");
	    return;
	 }
	//关闭数据与serlvet.out
	if (page != null) {page = null;}
}%>
<% 
if("sendNewCheck".equals(ac)){ 
	 String taskid = request.getParameter("taskid");
	 String teacherid = request.getParameter("teacherid");
	 String  teaching_time = request.getParameter("teaching_time");
	 String  week = request.getParameter("week");
	try{
		String	 sql = "insert into  teacher_week 	(teaching_task_id,teacherid,week,teaching_time,leixing,state)		"+
		"		values ("+taskid+","+teacherid+","+week+","+teaching_time+",1,2)                                             ";
	   if(db.executeUpdate(sql)==true){
		   out.println("<script>parent.layer.msg('送审成功');window.location.replace('./teacher_week.jsp');</script>");
	   }
	   else{
		   out.println("<script>parent.layer.msg('送审失败');</script>");
	   }
	 }catch (Exception e){
	    out.println("<script>parent.layer.msg('送审失败');</script>");
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