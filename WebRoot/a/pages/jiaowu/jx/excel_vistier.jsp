<%@ page contentType="application/vnd.ms-excel; charset=utf8" %>
<%@ page language="java" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.text.DecimalFormat"%>
<%@ page import="v1.haocheok.commom.common"%>
<%@ page language="java" import="java.util.regex.*"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<jsp:useBean id="db" scope="page" class="service.dao.db.Jdbc"/>
<jsp:useBean id="server" scope="page" class="service.dao.db.Page"/>
<%
	String teachering_office = request.getParameter("teachering_office");
	if(teachering_office==null||teachering_office.equals("")){
		teachering_office ="0";
	}
    String filename = new String(("部门课时导出").getBytes("GBK"),"ISO-8859-1"); 
    response.addHeader("Content-Disposition", "filename="+filename+".xls");
%>

<html>
  <head>
<title>部门课时导出</title>
<style type="text/css">
       *{margin:0;font-family: "微软雅黑";padding: 0;}
       h2{width: 1000px;margin: 15px auto;text-align: center;font-weight: normal;}
          table,table tr th, table tr td { border:1px solid #ccc; padding: 2px;}
        table {width: 1000px;margin: 0 auto;text-align: center; border-collapse: collapse;line-height: 20px} 
    
</style>
</head>
  
  <body style="background: #fff">
  
    <div class="d_table table-striped" >
    <h2>部门课时导出</h2>
		<table id="table" style="width:160%;table-layout: fixed;" >
			  <thead>
			   <tr>
			      <th >姓名</th>
			      <th>授课班级</th>
			      <th>人数</th>
			       <th>课程</th>
			        <th >1</th>
			        <th >2</th>
			        <th >3</th>
			        <th >4</th>
			        <th >5</th>
			        <th >6</th>
			        <th >7</th>
			        <th >8</th>
			        <th >9</th>
			        <th >10</th>
			        <th >11</th>
			        <th >12</th>
			        <th >13</th>
			        <th >14</th>
			        <th >15</th>
			        <th >16</th>
			        <th >17</th>
			      <th >小计</th>
			    </tr>
		  </thead>
		 
		   <tbody>
		   		<%
					
		   		String sql ="	select t.teaching_task_id,	ifnull(t3.people_number_nan,0) people_number_nan,                                                       "+
								"		ifnull(t3.people_number_woman,0) people_number_woman,                                                                         "+
								"		t3.class_name,                                                                                  "+
								"		t4.course_name,                                                                                 "+
								"		t5.teacher_name,                                                                                "+
								"	sum(case when t.week='1' then t.teaching_time else 0 end) '1',                                      "+
								"	sum(case when t.week='2' then t.teaching_time else 0 end) '2',                                      "+
								"	sum(case when t.week='3' then t.teaching_time else 0 end) '3',                                      "+
								"	sum(case when t.week='4' then t.teaching_time else 0 end) '4',                                      "+
								"	sum(case when t.week='5' then t.teaching_time else 0 end) '5',                                      "+
								"	sum(case when t.week='6' then t.teaching_time else 0 end) '6',                                      "+
								"	sum(case when t.week='7' then t.teaching_time else 0 end) '7',                                      "+
								"	sum(case when t.week='8' then t.teaching_time else 0 end) '8',                                      "+
								"	sum(case when t.week='9' then t.teaching_time else 0 end) '9',                                      "+
								"	sum(case when t.week='10' then t.teaching_time else 0 end) '10',                                    "+
								"	sum(case when t.week='11' then t.teaching_time else 0 end) '11',                                    "+
								"	sum(case when t.week='12' then t.teaching_time else 0 end) '12',                                    "+
								"	sum(case when t.week='13' then t.teaching_time else 0 end) '13',                                    "+
								"	sum(case when t.week='14' then t.teaching_time else 0 end) '14',                                    "+
								"	sum(case when t.week='15' then t.teaching_time else 0 end) '15',                                    "+
								"	sum(case when t.week='16' then t.teaching_time else 0 end) '16',                                    "+
								"	sum(case when t.week='17' then t.teaching_time else 0 end) '17'                                     "+
								"	from teacher_week t LEFT JOIN teaching_task t1 ON t.teaching_task_id = t1.id                        "+
								"	LEFT JOIN class_grade t3 ON t1.class_id = t3.id LEFT JOIN teacher_basic t5 ON t5.id=t.teacherid     "+
								"	LEFT JOIN dict_courses t4 ON t1.course_id = t4.id where t.state=3 and t5.teachering_office="+teachering_office+" GROUP BY t.teaching_task_id ";		   		
		   			System.out.println(sql);
		   			ResultSet set = db.executeQuery(sql);
		   			while(set.next()){
		   		%>
		   		
		   		<tr>
			       <th><%=set.getString("teacher_name")%></th>
			      <th><%=set.getString("class_name")%></th>
			      <th><%=(set.getInt("people_number_nan")+set.getInt("people_number_woman"))%></th>
			       <th><%=set.getString("course_name")%></th>
			      <th><%=set.getString("1")%></th>
			      <th><%=set.getString("2")%></th>
			      <th><%=set.getString("3")%></th>
			      <th><%=set.getString("4")%></th>
			      <th><%=set.getString("5")%></th>
			      <th><%=set.getString("6") %></th>
			      <th><%=set.getString("7")%></th>
			      <th><%=set.getString("8")%></th>
			      <th><%=set.getString("9")%></th>
			      <th><%=set.getString("10")%></th>
			      <th><%=set.getString("11")%></th>
			      <th><%=set.getString("12")%></th>
			      <th><%=set.getString("13")%></th>
			      <th><%=set.getString("14")%></th>
			      <th><%=set.getString("15")%></th>
			      <th><%=set.getString("16")%></th>
			      <th><%=set.getString("17")%></th>
			      <th><%
			      		int total =0;
			      		for(int i=1;i<18;i++){
			      			total = total + set.getInt(i+"");
			      		}
			      		out.print(total);
			      %></th>
		     </tr>
		        <%}if(set!=null){set.close();}%>
		      </tbody>
		</table>
    </div>

  </body>
</html>
 <%if(db!=null)db.close();db=null;if(server!=null)server=null;%>