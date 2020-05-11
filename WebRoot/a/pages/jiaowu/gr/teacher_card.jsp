<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page trimDirectiveWhitespaces="true" %>
<%@page contentType="text/html; charset=UTF-8" language="java"%>
<%@page import="service.dao.db.Page"%>
<%@page import="v1.haocheok.commom.common"%>
<%@page import="v1.haocheok.commom.entity.UserEntity"%>
<%@page import="org.apache.commons.lang3.StringUtils"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="net.sf.json.JSONArray"%>
<%@include file="../../cookie.jsp"%>

<!DOCTYPE html> 
<html>
  <head>
    <meta charset="utf-8"> 
    <meta name="viewport" content="width=device-width, initial-scale=1"> 
    <title><%=Mokuai %></title>
     <link rel="stylesheet" href="../../../pages/css/sy_style.css">	    
    <link rel="stylesheet" href="../../js/layui2/css/layui.css">
	<script type="text/javascript" src="../../js/jquery-1.9.1.js" ></script><!--通用jquery-->
	<script src="../../js/layui2/layui.js"></script>
	<script type="text/javascript" src="../../js/tableExport/js/table-sort.js" ></script><!--表格排序js  css-->
	<script type="text/javascript" chartset="utf8" src="../../js/tableExport/js/table_list.js " ></script><!--表格导出js  css-->
 	<script src="../../js/ajaxs.js"></script>
    <link href="../css/jw.css" rel="stylesheet">
  </head>
  <body>
  	<%
  	if(Suserole.equals("1")){
  		String teacherRowSql =" select count(id) row  from teacher_basic where id="+Sassociationid + " and state=1 and teacher_mark=1" ;
		int row = db.Row(teacherRowSql);
  		if(row>0){
  			
  			String teacherSql =" select id,teacher_name,teacher_number from teacher_basic where id="+Sassociationid + " and state=1 and teacher_mark=1" ;
  		
  	%>
  	<div class="layui-tab">
	  <ul class="layui-tab-title">
	    <li class="layui-this">个人信息</li>
	    <li>开课通知单</li>
	    <li>任课情况</li>
	    <li>警衔</li>
	    <li>工资</li>
	    <li>党员</li>
	    <li>发放情况</li>
	    <li>银行卡号</li>
	  </ul>
	  <div class="layui-tab-content">
	    <div class="layui-tab-item layui-show">
<%--			<jsp:include page="../teaching_staff_magnt/detail_teach_staff_info.jsp"/ >--%>
			<jsp:include page="../teaching_staff_magnt/detail_teach_staff_info.jsp" flush="true">     
			     <jsp:param name="id" value="<%=Sassociationid%>"/> 
			</jsp:include> 
		</div>
	    <div class="layui-tab-item">
	    	<div class="" style="padding-bottom: 0px;margin-left: 1%;margin-right: 1%; height:auto;">  
        	<%
		        //String bank_sql= "select t.*,t1.birthday,t1.nation,t1.work_time,t1.education,t1.administrative_level  from staff_rank  t LEFT JOIN teacher_basic t1 ON t.id_number=t1.id_number ";
			        	String kaike_sql = "SELECT *,"+
							"		teaching_task_teacher.teacherid as teacher_id,		"+
			        	"		marge_class.class_grade_number as class_grade_numberssss	"+
				        "FROM teaching_task                                                  "+
				        "		LEFT JOIN teaching_task_teacher ON ( teaching_task.id = teaching_task_id and teaching_task_teacher.state=1)"+
				        "	  LEFT JOIN teacher_basic    ON teaching_task_teacher.teacherid = teacher_basic.id "+
				        "	  LEFT JOIN dict_courses     ON teaching_task.course_id = dict_courses.id	"+
				        "	  LEFT JOIN marge_class      ON teaching_task.marge_class_id = marge_class.id "+
				        "WHERE "+ 
				        "    typestate=2	AND "+
				        "    marge_state = 0		 "+
				        "   AND teacher_basic.id ="+Sassociationid+
				        "    order by teaching_task.id DESC ";
			        System.out.println(kaike_sql);
				String html_str5 = "";
				String class_name = "";		//班级名称
		   		int shangkerenshu = 0;	//上课人数
		   		common common = new common();
				StringBuffer sb5 = new StringBuffer();
            		ResultSet groups5 = db.executeQuery(kaike_sql);
            		while(groups5.next()){
            			  String marge_name = groups5.getString("marge_name");
      		  			if(marge_name!=null){
      		  				class_name = marge_name;
      		  				shangkerenshu = groups5.getInt("class_grade_numberssss");
      		  			}else{
      		  				class_name = common.idToFieidName("class_grade","class_name",groups5.getString("class_id"));
      		  				shangkerenshu =0; 
      		  				String people_number_nan = common.idToFieidName("class_grade","people_number_nan",groups5.getString("class_id")); 
      		  				String people_number_woman =common.idToFieidName("class_grade","people_number_woman",groups5.getString("class_id")); 
      		  				if(StringUtils.isBlank(people_number_nan)){
      		  					people_number_nan="0";
      		  				}
      		  				if(StringUtils.isBlank(people_number_woman)){
      		  					people_number_woman="0";
      		  				}
      		  				shangkerenshu = Integer.parseInt(people_number_nan) + Integer.parseInt(people_number_woman);
      		  			}
            			String course_name = groups5.getString("course_name");
                     	if(StringUtils.isBlank(course_name)){course_name="";}
            			String test_semester = groups5.getString("test_semester");
                     	if(StringUtils.isBlank(test_semester)){test_semester="";}
            			String class_begins_weeks = groups5.getString("class_begins_weeks");
                     	if(StringUtils.isBlank(class_begins_weeks)){class_begins_weeks="";}
            			String classes_weekly = groups5.getString("classes_weekly");
                     	if(StringUtils.isBlank(classes_weekly)){classes_weekly="";}
            			String start_semester = groups5.getString("start_semester");
                     	if(StringUtils.isBlank(start_semester)){start_semester="";}
            			html_str5 = "<tr>"
   							+"<td class=\"\">"+ course_name +"</td>          "
   							+"<td class=\"\">"+test_semester+"</td>          "
   							+"<td class=\"\">"+class_name +"</td>          "
   							+"<td class=\"\">"+class_begins_weeks +"</td>          "
   							+"<td class=\"\">"+shangkerenshu +"</td>          "
   							+"<td class=\"\">"+classes_weekly+"</td>          "
   							+"<td class=\"\">"+start_semester +"</td>          "
   							+"<td class=\"\">"+groups5.getString("semester") +"</td>          "
						+"</tr>"; 
						sb5.append(html_str5);
            		}if(groups5!=null){groups5.close();}
		         %>
		    </div>
    <table class="cuoz" id="table" data-toggle="table" >
        <thead>
            <tr>
              <th data-field="课程名称"      data-filter-control="select" data-visible="true" >课程名称</th>
              <th data-field="考试学期"      data-filter-control="select" data-visible="true" >考试学期</th>
              <th data-field="上课班级"     data-filter-control="select" data-visible="true" >上课班级</th>
              <th data-field="讲课周次"     data-filter-control="select" data-visible="true" >讲课周次</th>
              <th data-field="上课人数"     data-filter-control="select" data-visible="true" >上课人数</th>
              <th data-field="周数"      data-filter-control="select" data-visible="true" >周数</th>
              <th data-field="周学时" data-filter-control="select" data-visible="true" >周学时</th>
              <th data-field="学期" data-filter-control="select" data-visible="true" >学期</th>
            </tr>
          </thead>
          <tbody>
          	<%=sb5.toString()%>
        </tbody>
      </table>
	    </div>
	    <div class="layui-tab-item">
		<jsp:include page="../jx/personal_schedule.jsp" flush="true">     
<%--			     <jsp:param name="id" value="<%=Sassociationid%>"/> --%>
			</jsp:include> 
	</div>
	    <div class="layui-tab-item">
			  <div class="" style="padding-bottom: 0px;margin-left: 1%;margin-right: 1%; height:auto;">  
        	<%
		        //String bank_sql= "select t.*,t1.birthday,t1.nation,t1.work_time,t1.education,t1.administrative_level  from staff_rank  t LEFT JOIN teacher_basic t1 ON t.id_number=t1.id_number ";
				String staff_sql =" SELECT                                                                                  "+
								"				t.*, t1.birthday,                                                           "+
								"				t1.nation,                                                                  "+
								"				t1.work_time,                                                               "+
								"				t1.education,                                                               "+
								"				t1.administrative_level                                                     "+
								"			FROM                                                                            "+
								"				staff_rank t                                                                "+
								"			LEFT JOIN teacher_basic t1 ON t.id_number = t1.id_number                        "+
								"			WHERE t.id_number in (SELECT id_number from teacher_basic where id="+Sassociationid+")";
				String html_str = "";
				StringBuffer sb = new StringBuffer();
            		ResultSet groups = db.executeQuery(staff_sql);
            		while(groups.next()){
            			String police_num = groups.getString("police_num");
                     	if(StringUtils.isBlank(police_num)){police_num="";}
            			String id_number = groups.getString("id_number");
                     	if(StringUtils.isBlank(id_number)){id_number="";}
            			String name = groups.getString("name");
                     	if(StringUtils.isBlank(name)){name="";}
            			String birthday = groups.getString("birthday");
                     	if(StringUtils.isBlank(birthday)){birthday="";}
            			String nation = groups.getString("nation");
                     	if(StringUtils.isBlank(nation)){nation="";}
            			String work_time = groups.getString("work_time");
                     	if(StringUtils.isBlank(work_time)){work_time="";}
            			String education = groups.getString("education");
                     	if(StringUtils.isBlank(education)){education="";}
            			String administrative_level = groups.getString("administrative_level");
                     	if(StringUtils.isBlank(administrative_level)){administrative_level="";}
            			String rank_time = groups.getString("rank_time");
                     	if(StringUtils.isBlank(rank_time)){rank_time="";}
            			String rank = groups.getString("rank");
                     	if(StringUtils.isBlank(rank)){rank="";}
            			String type = groups.getString("type");
                     	if(StringUtils.isBlank(type)){type="";}
            			String bianhua = groups.getString("bianhua");
                     	if(StringUtils.isBlank(bianhua)){bianhua="";}
            			html_str = "<tr>"
   							+"<td class=\"\">"+ police_num +"</td>          "
   							+"<td class=\"\">"+id_number+"</td>          "
   							+"<td class=\"\">"+name +"</td>          "
   							+"<td class=\"\">"+birthday +"</td>          "
   							+"<td class=\"\">"+nation +"</td>          "
   							+"<td class=\"\">"+work_time+"</td>          "
   							+"<td class=\"\">"+education +"</td>          "
   							+"<td class=\"\">"+administrative_level+"</td>          "
   							+"<td class=\"\">"+rank_time +"</td>          "
   							+"<td class=\"\">"+rank +"</td>          "
   							+"<td class=\"\">"+type +"</td>          "
   							+"<td class=\"\">"+bianhua +"</td>          "
						+"</tr>"; 
						sb.append(html_str);
            		}if(groups!=null){groups.close();}
		         %>
		    </div>
    <table class="cuoz" id="table" data-toggle="table" >
        <thead>
            <tr>
              <th data-field="警号"      data-filter-control="select" data-visible="true" >警号</th>
              <th data-field="身份证号"      data-filter-control="select" data-visible="true" >身份证号</th>
              <th data-field="姓名"     data-filter-control="select" data-visible="true" >姓名</th>
              <th data-field="生日"     data-filter-control="select" data-visible="true" >生日</th>
              <th data-field="民族"     data-filter-control="select" data-visible="true" >民族</th>
              <th data-field="工作时间"      data-filter-control="select" data-visible="true" >工作时间</th>
              <th data-field="文化程度" data-filter-control="select" data-visible="true" >文化程度</th>
              <th data-field="行政级别"  data-filter-control="select" data-visible="true" >行政级别</th>
              <th data-field="授衔时间" data-filter-control="select" data-visible="true" >授衔时间</th>
              <th data-field="警衔"  data-filter-control="select" data-visible="true" >警衔</th>
              <th data-field="类别"  data-filter-control="select" data-visible="true" >类别</th>
              <th data-field="变动情况"  data-filter-control="select" data-visible="true" >变动情况</th>
            </tr>
          </thead>
          <tbody>
          	<%=sb.toString()%>
        </tbody>
      </table>
		</div>
		
	    <div class="layui-tab-item">
	    	<div class="" style="padding-bottom: 0px;margin-left: 1%;margin-right: 1%; height:auto;">  
        	<%
		       	
		        String gongzi_sql= "SELECT t.*,t1.sex FROM teacher_wages t LEFT JOIN teacher_basic t1 ON t.id_number=t1.id_number  WHERE t.id_number in (SELECT id_number from teacher_basic where id="+Sassociationid+")";
				System.out.println("gongzi_sql "+gongzi_sql);
        		String html_str1 = "";
				StringBuffer sb1 = new StringBuffer();
            		ResultSet groups1 = db.executeQuery(gongzi_sql);
            		while(groups1.next()){
            	    	String sex ="";
            			String id_number = groups1.getString("id_number");
                     	if(StringUtils.isBlank(id_number)){id_number="";}
            			 sex = groups1.getString("sex");
                     	if(StringUtils.isBlank(sex)){sex="";}
                     	if(sex.equals("1")){
                     		sex="男";
                     	}else{
                     		sex ="女";
                     	}
            			String name = groups1.getString("name");
                     	if(StringUtils.isBlank(name)){name="";}
            			String job_salary = groups1.getString("job_salary");
                     	if(StringUtils.isBlank(job_salary)){job_salary="";}
            			String level_wage = groups1.getString("level_wage");
                     	if(StringUtils.isBlank(level_wage)){level_wage="";}
                     	
            			html_str1 = "<tr>"
   							+"<td class=\"\">"+name +"</td>          "
   							+"<td class=\"\">"+groups1.getString("date")  +"</td>          "
   							+"<td class=\"\">"+id_number+"</td>          "
   							+"<td class=\"\">"+sex+"</td>          "
   							+"<td class=\"\">"+job_salary +"</td>          "
   							+"<td class=\"\">"+level_wage +"</td>          "
   							+"<td class=\"\">"+groups1.getString("work_subsidy") +"</td>          "
   							+"<td class=\"\">"+groups1.getString("life_subsidy") +"</td>          "
   							+"<td class=\"\">"+groups1.getString("doctor_subsidy") +"</td>          "
   							+"<td class=\"\">"+groups1.getString("sanitation_fee")  +"</td>          "
   							+"<td class=\"\">"+groups1.getString("hui_subsidy")  +"</td>          "
   							+"<td class=\"\">"+groups1.getString("houser_subsidy")  +"</td>          "
   							+"<td class=\"\">"+groups1.getString("rand_subsidy")  +"</td>          "
   							+"<td class=\"\">"+groups1.getString("repaired_wage")  +"</td>          "
   							+"<td class=\"\">"+groups1.getString("person_tax")  +"</td>          "
   							+"<td class=\"\">"+groups1.getString("accumulation_fund")  +"</td>          "
   							+"<td class=\"\">"+groups1.getString("medical_insurance")  +"</td>          "
   							+"<td class=\"\">"+groups1.getString("old_insurance")  +"</td>          "
   							+"<td class=\"\">"+groups1.getString("house_fee")  +"</td>          "
   							+"<td class=\"\">"+groups1.getString("person_own")  +"</td>          "
   							+"<td class=\"\">"+groups1.getString("garnishment")  +"</td>          "
   							+"<td class=\"\">"+groups1.getString("real_wage")  +"</td>          "
   							+"<td class=\"\">"+groups1.getString("add_time")  +"</td>          "
						+"</tr>"; 
						sb1.append(html_str1);
            		}if(groups1!=null){groups1.close();}
		         %>
		    </div>
    <table class="cuoz" id="table" data-toggle="table" >
        <thead>
            <tr>
              <th data-field="姓名"     data-filter-control="select" data-visible="true" >姓名</th>
              <th data-field="发放日期"     data-filter-control="select" data-visible="true" >发放日期</th>
              <th data-field="身份证号"     data-filter-control="select" data-visible="true" >身份证号</th>
              <th data-field="性别"     data-filter-control="select" data-visible="true" >性别</th>
              <th data-field="职务(技等)工资"     data-filter-control="select" data-visible="true" >职务(技等)工资</th>
              <th data-field="级别(岗位)工资"     data-filter-control="select" data-visible="true" >级别(岗位)工资</th>
              <th data-field="工作性补贴     data-filter-control="select" data-visible="true" >工作性补贴</th>
              <th data-field="生活性补贴" data-filter-control="select" data-visible="true" >生活性补贴</th>
              <th data-field="博士津补" data-filter-control="select" data-visible="true" >博士津补</th>
              <th data-field="卫生费" data-filter-control="select" data-visible="true" >卫生费</th>
              <th data-field="回民补助" data-filter-control="select" data-visible="true" >回民补助</th>
              <th data-field="住房补贴" data-filter-control="select" data-visible="true" >住房补贴</th>
              <th data-field="警衔补贴" data-filter-control="select" data-visible="true" >警衔补贴</th>
              <th data-field="应发工资" data-filter-control="select" data-visible="true" >应发工资</th>
              <th data-field="个人所得税" data-filter-control="select" data-visible="true" >个人所得税</th>
              <th data-field="公积金" data-filter-control="select" data-visible="true" >公积金</th>
              <th data-field="医疗保险" data-filter-control="select" data-visible="true" >医疗保险</th>
              <th data-field="养老保险" data-filter-control="select" data-visible="true" >养老保险</th>
              <th data-field="房费" data-filter-control="select" data-visible="true" >房费</th>
              <th data-field="个人欠费" data-filter-control="select" data-visible="true" >个人欠费</th>
              <th data-field="扣发小计" data-filter-control="select" data-visible="true" >扣发小计</th>
              <th data-field="实发工资" data-filter-control="select" data-visible="true" >实发工资</th>
              <th data-field="更新时间" data-filter-control="select" data-visible="true" >更新时间</th>
            </tr>
          </thead>
          <tbody>
          	<%=sb1.toString()%>
        </tbody>
      </table>
         </div>
	    <div class="layui-tab-item">
	    	<div class="" style="padding-bottom: 0px;margin-left: 1%;margin-right: 1%; height:auto;">  
        	<%
		        String dyan_sql= "select t.*,t1.birthday,t1.nation,t1.sex,t1.work_time,t1.education,t1.administrative_level  from staff_party  t LEFT JOIN teacher_basic t1 ON t.id_number=t1.id_number  WHERE t.id_number in (SELECT id_number from teacher_basic where id="+Sassociationid+")";
				String html_str2 = "";
				StringBuffer sb2 = new StringBuffer();
            		ResultSet groups2 = db.executeQuery(dyan_sql);
            		while(groups2.next()){
            			String sex = groups2.getString("sex");
                     	if(StringUtils.isBlank(sex)){sex="1";}
                     	if(sex.equals("1")){
                     		sex="男";
                     	}else{
                     		sex ="女";
                     	}
            			String id_number = groups2.getString("id_number");
                     	if(StringUtils.isBlank(id_number)){id_number="";}
            			String name = groups2.getString("name");
                     	if(StringUtils.isBlank(name)){name="";}
            			String birthday = groups2.getString("birthday");
                     	if(StringUtils.isBlank(birthday)){birthday="";}
            			String nation = groups2.getString("nation");
                     	if(StringUtils.isBlank(nation)){nation="";}
            			String work_time = groups2.getString("work_time");
                     	if(StringUtils.isBlank(work_time)){work_time="";}
            			String education = groups2.getString("education");
                     	if(StringUtils.isBlank(education)){education="";}
                     	
            			String in_party_time = groups2.getString("in_party_time");
                     	if(StringUtils.isBlank(in_party_time)){in_party_time="";}
            			String in_party_address = groups2.getString("in_party_address");
                     	if(StringUtils.isBlank(in_party_address)){in_party_address="";}
            			String party_time = groups2.getString("party_time");
                     	if(StringUtils.isBlank(party_time)){party_time="";}
            			String party_address = groups2.getString("party_address");
                     	if(StringUtils.isBlank(party_address)){party_address="";}
            			String introducer = groups2.getString("introducer");
                     	if(StringUtils.isBlank(introducer)){introducer="";}
            			String dangfee = groups2.getString("dangfee");
                     	if(StringUtils.isBlank(dangfee)){dangfee="";}
            			String position = groups2.getString("position");
                     	if(StringUtils.isBlank(position)){position="";}
            			String in_branch_time = groups2.getString("in_branch_time");
                     	if(StringUtils.isBlank(in_branch_time)){in_branch_time="";}
            			String remark = groups2.getString("remark");
                     	if(StringUtils.isBlank(remark)){remark="";}
            			String add_time = groups2.getString("add_time");
                     	if(StringUtils.isBlank(add_time)){add_time="";}
                     	
            			html_str2 = "<tr>"
   							+"<td class=\"\">"+name +"</td>          "
   							+"<td class=\"\">"+sex +"</td>          "
   							+"<td class=\"\">"+id_number+"</td>          "
   							+"<td class=\"\">"+birthday +"</td>          "
   							+"<td class=\"\">"+nation +"</td>          "
   							+"<td class=\"\">"+work_time+"</td>          "
   							+"<td class=\"\">"+in_party_time +"</td>          "
   							+"<td class=\"\">"+in_party_address +"</td>          "
   							+"<td class=\"\">"+party_time +"</td>          "
   							+"<td class=\"\">"+party_address +"</td>          "
   							+"<td class=\"\">"+introducer +"</td>          "
   							+"<td class=\"\">"+dangfee +"</td>          "
   							+"<td class=\"\">"+position +"</td>          "
   							+"<td class=\"\">"+in_branch_time +"</td>          "
   							+"<td class=\"\">"+remark +"</td>          "
   							+"<td class=\"\">"+add_time +"</td>          "
						+"</tr>"; 
						sb2.append(html_str2);
            		}if(groups2!=null){groups2.close();}
		         %>
		    </div>
    <table class="cuoz" id="table"  data-toggle="table" >
        <thead>
            <tr>
              <th data-field="姓名"     data-filter-control="select" data-visible="true" >姓名</th>
              <th data-field="性别"     data-filter-control="select" data-visible="true" >性别</th>
              <th data-field="身份证号"     data-filter-control="select" data-visible="true" >身份证号</th>
              <th data-field="生日"     data-filter-control="select" data-visible="true" >生日</th>
              <th data-field="民族"     data-filter-control="select" data-visible="true" >民族</th>
              <th data-field="工作时间"     data-filter-control="select" data-visible="true" >工作时间</th>
              <th data-field="入党时间" data-filter-control="select" data-visible="true" >入党时间</th>
              <th data-field="入党所在支部" data-filter-control="select" data-visible="true" >入党所在支部</th>
              <th data-field="转正时间" data-filter-control="select" data-visible="true" >转正时间</th>
              <th data-field="转正所在支部" data-filter-control="select" data-visible="true" >转正所在支部</th>
              <th data-field="入党介绍人" data-filter-control="select" data-visible="true" >入党介绍人</th>
              <th data-field="月应交党费" data-filter-control="select" data-visible="true" >月应交党费</th>
              <th data-field="党内职务" data-filter-control="select" data-visible="true" >党内职务</th>
              <th data-field="进入党支部时间" data-filter-control="select" data-visible="true" >进入党支部时间</th>
              <th data-field="备注" data-filter-control="select" data-visible="true" >备注</th>
              <th data-field="更新时间" data-filter-control="select" data-visible="true" >更新时间</th>
            </tr>
          </thead>
          <tbody>
          	<%=sb2.toString()%>
        </tbody>
      </table>
         </div>
	    <div class="layui-tab-item">
			<div class="" style="padding-bottom: 0px;margin-left: 1%;margin-right: 1%; height:auto;">  
        	<%
		        String fafang_sql= "SELECT t.*,t1.id_number FROM teacher_wages_distribution t LEFT JOIN wealth_bank t1 ON t.bankcard=t1.bankcard WHERE t1.id_number in (SELECT id_number from teacher_basic where id="+Sassociationid+")";
        	String html_str3 = "";
				StringBuffer sb3 = new StringBuffer();
            		ResultSet groups3 = db.executeQuery(fafang_sql);
            		while(groups3.next()){
            			String name = groups3.getString("name");
            			String id_number = groups3.getString("id_number");
            			if(StringUtils.isBlank(id_number))id_number="";
            			String bankcard = groups3.getString("bankcard");
            			String wage = groups3.getString("wage");
            			String tax = groups3.getString("tax");
            			String remark = groups3.getString("remark");
            			String date = groups3.getString("date");
            			String add_time = groups3.getString("add_time");
            			html_str3 = "<tr>"
   							+"<td class=\"\">"+ name +"</td>          "
   							+"<td class=\"\">"+id_number+"</td>          "
   							+"<td class=\"\">"+bankcard +"</td>          "
   							+"<td class=\"\">"+wage +"</td>          "
   							+"<td class=\"\">"+tax +"</td>          "
   							+"<td class=\"\">"+remark+"</td>          "
   							+"<td class=\"\">"+date +"</td>          "
   							+"<td class=\"\">"+add_time+"</td>          "
						+"</tr>"; 
						sb3.append(html_str3);
            		}if(groups3!=null){groups3.close();}
		         %>
		    </div>
    <table class="cuoz" id="table" data-toggle="table"  >
        <thead>
            <tr>
              <th data-field="姓名"     data-filter-control="select" data-visible="true" >姓名</th>
              <th data-field="身份证号"     data-filter-control="select" data-visible="true" >身份证号</th>
              <th data-field="银行卡号"     data-filter-control="select" data-visible="true" >银行卡号</th>
              <th data-field="金额"     data-filter-control="select" data-visible="true" >金额</th>
              <th data-field="税款"     data-filter-control="select" data-visible="true" >税款</th>
              <th data-field="摘要" data-filter-control="select" data-visible="true" >摘要</th>
              <th data-field="发放日期" data-filter-control="select" data-visible="true" >审批日期</th>
              <th data-field="更新时间" data-filter-control="select" data-visible="true" >更新时间</th>
            </tr>
          </thead>
          <tbody>
          	<%=sb3.toString()%>
        </tbody>
      </table>
         </div>
         
	    <div class="layui-tab-item">
		<div class="" style="padding-bottom: 0px;margin-left: 1%;margin-right: 1%; height:auto;">  
		<%
       	String zhanghu_sql="select t.*,t1.teacher_name,t1.teacher_number,t1.sex,t1.native_place,t1.teachering_office from wealth_bank t LEFT JOIN teacher_basic t1 ON t1.id_number=t.id_number   WHERE t1.id_number in (SELECT id_number from teacher_basic where id="+Sassociationid+")";
       	String html_str4="";  
       	ArrayList<String> list = new ArrayList<String>();
        ResultSet Rs = db.executeQuery(zhanghu_sql);
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
         	html_str4="<tr>\r\n"+
         	"<td >"+teacher_number+"</td>"+
         	"<td >"+teacher_name+"</td>"+
         	"<td >"+sex+"</td>"+
         	"<td >"+native_place+"</td>"+
         	"<td >"+teaching_research+"</td>"+
         	"<td >"+Rs.getString("name")+"</td>"+
			"<td >"+Rs.getString("id_number")+"</td>"+
			"<td >"+Rs.getString("bankcard")+"</td>"+
				      "</tr>";
		   list.add(html_str4);
       }if(Rs!=null){Rs.close();}
%>
	    	<table class="cuoz" id="table" data-toggle="table"  >
		        <thead>
		            <tr>
		                <th data-field="编号"  data-filter-control="select"  data-visible="true">编号</th>
		                <th data-field="姓名"  data-filter-control="select"  data-visible="true">姓名</th>
		                <th data-field="性别"  data-filter-control="select"  data-visible="true">性别</th>
		                <th data-field="籍贯"  data-filter-control="select"  data-visible="true">籍贯</th>
		                <th data-field="教研室"  data-filter-control="select"  data-visible="true">教研室</th>
		                <th data-field="开户行"  data-filter-control="select"  data-visible="true">开户行</th>
		                <th data-field="身份证号"  data-filter-control="select"  data-visible="true">身份证号</th>
		                <th data-field="银行卡"  data-filter-control="select"  data-visible="true">银行卡</th>
		            </tr>
		        </thead>
		        <tbody id="tbody">
					<%=list.toString().replaceAll("\\[","").replaceAll("\\]","").replaceAll(",","").replaceAll("@#@",",")%>
		        </tbody>
	        </table>
		</div>
	  </div>
  	</div>
    </div>
  			<%
  		}
  	}else{
  		%>
  		<%
  	}
  	%>
  </body>
  
  <script>
//注意：选项卡 依赖 element 模块，否则无法进行功能性操作
//layui.use('element', function(){
  layui.use(['form', 'layedit', 'laydate','laypage','element'], function(){
	  var laypage = layui.laypage,
	  form = layui.form
	  ,layer = layui.layer
	  ,element = layui.element;
});
</script>
</html>
<%
//插入常用菜单日志
int   TagMenu=db.Row("SELECT COUNT(*) as row FROM  menu_worker  WHERE sysmenuid='"+PMenuId+"' and  workerid='"+Suid+"' and  companyid="+Scompanyid);
if(TagMenu==0){
  db.executeUpdate("INSERT INTO `menu_worker`(`sysmenuid`,`workerid`,`countes`,`companyid`) VALUES ('"+PMenuId+"','"+Suid+"','1','"+Scompanyid+"');"); 
}else{
 db.executeUpdate("UPDATE  `menu_worker` SET `countes`=countes+1,`usetime`=now() WHERE  sysmenuid='"+PMenuId+"' and  workerid='"+Suid+"' and  companyid="+Scompanyid);
}
 %>
<% 
if(db!=null)db.close();db=null;if(server!=null)server=null;%>