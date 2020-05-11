<%@ page trimDirectiveWhitespaces="true" %>
<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@page import="v1.haocheok.commom.common"%>
<%@page import="service.dao.db.Page"%>
<%@page import="java.net.URLDecoder"%>
<%@ include file="../../cookie.jsp"%>
<%if(ac.length()==0){%>
<%    String class_id=request.getParameter("class_id"); //获取分类id
      String major_id=request.getParameter("major_id"); //获取专业id
      String major_name=request.getParameter("major_name"); //获取专业id
      String dict_departments_id=request.getParameter("dict_departments_id");
	  String xn=request.getParameter("school_year");
 	  String major=request.getParameter("major_id");
 	  String ArrupField="";
        //学年       
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
 			search=search+"and (academic_year like '%"+search_val+"%' or academic_yaer_as like '%"+search_val+"%') ";
 		}  		
         //过滤非法字符
 		if(regex_num(xn)==false ){xn="0";}
 		if(regex_num(major)==false){major="0";}
 		if(regex_num(dict_departments_id)==false){dict_departments_id="0";}
 		if(regex_num(class_id)==false){class_id="0";}	
 		int majorId=Integer.parseInt(major);
 		int xnxq=Integer.parseInt(xn);
%>
 <%
          //SQL语
     	//开始查询专业表
      ResultSet Rs = db.executeQuery("select eductional_systme_id,school_year from major where id='"+major_id+"';");
      //学制
     int xz=0;
    
      while(Rs.next()){
             xz=Rs.getInt("eductional_systme_id");       
     }if(Rs!=null){Rs.close();}
  %>
<!DOCTYPE html> 
<html>
  <head>
    <meta charset="utf-8"> 
    <meta name="viewport" content="width=device-width, initial-scale=1"> 
    <title><%=Mokuai %></title>
        <link href="../../css/combo.select.css" rel="stylesheet" type="text/css" />
	    <link rel="stylesheet" href="../../js/layui2/css/layui.css">
		<script type="text/javascript" src="../../js/jquery-1.9.1.js" ></script><!--通用jquery-->
		<script type="text/javascript" src="../../js/jquery.combo.select.js" ></script><!--通用jquery-->
		<script src="../../js/layui2/layui.js"></script>
		
<style type="text/css">
.myinput {BACKGROUND-COLOR: #e6f3ff; BORDER-BOTTOM: #ffffff 1px groove; BORDER-LEFT: #ffffff 1px groove; BORDER-RIGHT: #ffffff 1px groove; BORDER-TOP: #ffffff 1px groove; COLOR: #000000; FONT: 24px Verdana,Geneva,sans-serif; HEIGHT: 36px; WIDTH: 60px"}
</style>
<style type="text/css"> 
	    th { background-color: white; }
	    .btn-group-vertical>.btn, .btn-group>.btn{height:33px;}
        table tr:hover{background:#eeeeee;color:#19A094;}
</style>
  </head>
  <body>
<div class="" style="padding-bottom: 0px;margin-left: 1%;margin-right: 1%; height:auto;">  
 
<div id="tb" class="form_top layui-form" style="display: flex;">
		        <button class="layui-btn layui-btn-small  layui-btn-primary" onclick="fanhui()" style="height: 35px;  color: white; background: rgb(25, 160, 148);"><i class="layui-icon" style="color: #FFF;">&#xe65c;</i> 返回</button>
		    	<button class="layui-btn layui-btn-small  layui-btn-primary" onclick="shuaxin()" style="height: 35px;  color: white; background: rgb(25, 160, 148);"> <i class="layui-icon" style="color: #FFF;">ဂ</i> 刷新</button>
		        <button class="layui-btn layui-btn-small  layui-btn-primary" onclick="addCourse(<%=class_id%>,'0')" style="height: 35px;  color: white; background: rgb(25, 160, 148);"> <i class="layui-icon" style="color: #FFF;"></i> 增加课程</button>
		        <button class="layui-btn layui-btn-small  layui-btn-primary" onclick="addCourse(<%=class_id%>,'1')" style="height: 35px;  color: white; background: rgb(25, 160, 148);"> <i class="layui-icon" style="color: #FFF;"></i> 增加进程</button>
				<input type="button" name="xxx" value="导出excel" onclick="method5('my-table1');" class="layui-btn">
<%--		        <button class="layui-btn layui-btn-small  layui-btn-primary " onclick="help(<%=PMenuId %>)" style="height: 35px;  color:#A9A9A9; background: rgb(245, 245, 245);"><i class="layui-icon"></i>帮助</button>--%>
		    </div>
    <input type="hidden" id="class_id" value="<%=class_id %>">
    <input type="hidden" id="major_id" value="<%=major_id %>">
    <input type="hidden" id="dict_departments_id" value="<%=dict_departments_id %>">
    <input type="hidden" id="xn" value="<%=xn%>">
<div  style="display:block;clear:both;">

<!-- test --> 
<div id="LAY_preview">

<table border="1" width="100%" bordercolorlight="#588FC7" cellspacing="0" cellpadding="0" bordercolor="#19A094" id="my-table1"  >
  <tbody>
    <tr>
	     <td colspan="<%=15+xz*2%>"  align="center">
	     	<h2><%=xn%>级<%=major_name%>专业人才培养方案进程表</h2>
	     </td>
     </tr>
    <tr>
      <td width="68" height="24" rowspan="4" colspan="2"><p align="center">课程<br/>分类</p></td>
      <td width="65" height="24" rowspan="4"><p align="center">序号</td>
      <td width="115" height="24" rowspan="4"><p align="center">课程名称<br/>或教学内容</p></td>
      <td width="60" height="24" rowspan="4"><p align="center">课程编号</p></td>
      <td height="60" colspan="4"><p align="center">计划学时数</p></td>
      <td width="60" height="24" rowspan="4"><p align="center">考试学期</p></td>
      <td width="60" height="24" rowspan="4"><p align="center">考查学期</p></td>
      <td height="40" colspan="<%=xz*2%>"><p align="center">学期分配周课时数</p></td>
      <td width="79" height="24" rowspan="4"><p align="center">学分</p></td>
      <td width="79" height="24" rowspan="4"><p align="center">开课周次</p></td>
      <td width="34" height="24" rowspan="4" class="delete"><p align="center">操作</p></td>
      <td rowspan="4" width="33"   class="delete" align="center">全选<input type="checkbox" name="C_SelectALL" value="ON" onclick="javascript:swapCheck();" title="选择/取消选择全部记录" /></td>
    </tr>
    <tr>
      <td width="80" height="34" rowspan="3" align="center">课程<br />总学时</td>
      <td width="60" height="34" rowspan="3" align="center">理论<br />教学</td>
      <td width="60" height="34" colspan="2" align="center">实践教学</td>
      <%
      //学年计算通过学制
      //q是第一个学期h是第二个学期
      int q=Integer.parseInt(xn),h=0;
      for(int i=0;i<xz;i++){
             h=q+1;
       %>
       <td height="16" colspan="2" align="center"><%=q%>-<%=h%>学年</td>
       <%
       q++;
       h++;
      }%>
    </tr>
    <tr>
    <td width="80" height="34" rowspan="2" align="center">课内</td>
    <td width="60" height="34" rowspan="2" align="center">独立<br/>设置</td>
    <%for(int j=1;j<=xz*2;j++){%>
      <td width="95" height="15" align="center"><p align="center"><%=j %></p></td>
    <%}%>
    </tr>
    <tr>
     <%
     ResultSet zzRs=null;
     zzRs=db.executeQuery("SELECT *   FROM teaching_plan_class_guidance WHERE id='"+class_id+"';"); 
     int row =1;
     while(zzRs.next()){  
     for(int j=1;j<=xz*2;j++){ %>
       <td width="95" height="16" align="center" id="semester_weekly<%=j%>_<%=class_id%>"><div ondblclick="jxchange('<%=class_id%>','semester_weekly<%=j%>')"><%if(zzRs.getString("semester_weekly"+""+j).length()!=0){out.print(zzRs.getString("semester_weekly"+""+j));}else{out.print("&nbsp;&nbsp;");}%></div></td>
       <%}
     }%>
    </tr> 
    <% 
    ResultSet bgRs1=null; ResultSet bgRs2=null; ResultSet bgRs3=null;
    int j1=0;int j2=0;int j3=0;  
           String course_nature_id="",course_category_id="",course_id="",sysid="" ,courserprocess="",process_id="";//进程还是课程;
           bgRs1=db.executeQuery("SELECT DISTINCT course_category_id   FROM teaching_plan_guidance WHERE  class_guidance_id='"+class_id+ "' order by course_category_id  ASC ;" );  //一级循环 按course_category_id排序
           while(bgRs1.next()){ j1=j1+1;     
           course_category_id=bgRs1.getString("course_category_id");//课程类别
        	   int bg1=db.Row("SELECT COUNT(*) as row FROM teaching_plan_guidance where course_category_id='"+course_category_id+"' and class_guidance_id='"+class_id+"';");  //课程类别总数         	   
        	   bgRs2=db.executeQuery("SELECT DISTINCT course_nature_id   FROM teaching_plan_guidance where course_category_id='"+course_category_id+"' and class_guidance_id='"+class_id+"';");  //二级循环
        	   while(bgRs2.next()){        		  	
        		   course_nature_id=bgRs2.getString("course_nature_id");//课程性质    		  
        		   int bg2=db.Row("SELECT COUNT(*) as row FROM teaching_plan_guidance where course_category_id='"+course_category_id+"' AND course_nature_id='"+course_nature_id+"' and class_guidance_id='"+class_id+"';");  //课程性质总数        	   
        		   bgRs3=db.executeQuery("SELECT  *  FROM teaching_plan_guidance where course_nature_id='"+course_nature_id+"' and course_category_id='"+course_category_id+"' and class_guidance_id='"+class_id+"' ORDER BY sort;");  //三级循环
            	   while(bgRs3.next()){j2=j2+1;
            	       sysid=bgRs3.getString("id");//行索引id 
            		   course_id=bgRs3.getString("course_id"); 	
            		   dict_departments_id=bgRs3.getString("dict_departments_id");
            		   courserprocess = bgRs3.getString("courserprocess");			//进程还是课程
            		   process_id = bgRs3.getString("process_id");
            		  
  	   %>
  	
    <tr>
        <%if(j1==1){%>
      <td width="22" colspan="1" rowspan="<%=bg1+1%>"><%=common.idToFieidName("dict_course_category","category",course_category_id)%></td>
          <%}%>
          <%if(j2==1){%>
      <td width="46" colspan="1" rowspan="<%=bg2%>"><%=common.idToFieidName("dict_course_nature","nature",course_nature_id)%></td>
          <%}%>
<%--      <td width="40"  id="sort_<%=sysid %>"><div ondblclick="change('<%=sysid%>','sort')" ><%if(bgRs3.getString("sort").length()!=0){out.print(bgRs3.getString("sort"));}else{out.print("&nbsp;&nbsp;");}%></div></td>--%>
      <td width="40"  id="sort_<%=sysid %>">
      	<div ondblclick="change('<%=sysid%>','sort')" >
      		<%
      		if(bgRs3.getInt("sort")>0)
      		{
      			out.print(bgRs3.getString("sort"));
      			
      		}else{
		    	 
		    	  out.print(row);
		    	  
		      }%>
		</div>
	  </td>
      <%row++; %>
      <%
      	if("0".equals(courserprocess)){
      		//课程
      %>
			<% if("0".equals(course_id)){%> <td style="background:red" width="115" id="course_id_<%=sysid %>"  ondblclick="selectChane('<%=sysid %>','course_id','<%=course_id %>')">请双击选择课程</td>
			<%}else{%>
			<td width="115" id="course_id_<%=sysid %>"  ondblclick="selectChane('<%=sysid %>','course_id','<%=course_id %>')"><%=common.idToFieidName("dict_courses","course_name",course_id)%></td>
			<%}%>
			<td width="56" id="course_code_<%=sysid %>" style="vnd.ms-excel.numberformat:@"><%=common.idToFieidName("dict_courses","course_code",course_id)%></td>
      <%}else{ //进程%>
      		<% if("0".equals(process_id)){%> <td style="background:red" width="115" id="process_id_<%=sysid %>"  ondblclick="selectChaneOne('<%=sysid %>','process_id','<%=process_id %>')">请双击选择进程</td>
			<%}else{%>
			<td width="115" id="process_id_<%=sysid %>"  ondblclick="selectChaneOne('<%=sysid %>','process_id','<%=process_id %>')"><%=common.idToFieidName("dict_process_symbol","process_symbol_name",process_id)%></td>
			<%}%>
			<td width="56" id="course_code_<%=sysid %>">暂无</td>
      <%} %>
  
  
      <td width="40"  id="total_classes_<%=sysid %>"><div ondblclick="change('<%=sysid%>','total_classes')"><%if(bgRs3.getString("total_classes").length()!=0){out.print(bgRs3.getString("total_classes"));}else{out.print("&nbsp;&nbsp;");}%></div></td>
      <td width="40"  id="lecture_classes_<%=sysid %>"><div  ondblclick="change('<%=sysid%>','lecture_classes')"><%if(bgRs3.getString("lecture_classes").length()!=0){out.print(bgRs3.getString("lecture_classes"));}else{out.print("&nbsp;&nbsp;");}%></div></td>
      <td width="40"  id="class_in_<%=sysid %>"><div ondblclick="change('<%=sysid%>','class_in')"><%if(bgRs3.getString("class_in").length()!=0){out.print(bgRs3.getString("class_in"));}else{out.print("&nbsp;&nbsp;");}%></div></td>
      <td width="40"  id="extracurricular_practice_hour_<%=sysid %>"><div ondblclick="change('<%=sysid%>','extracurricular_practice_hour')"><%if(bgRs3.getString("extracurricular_practice_hour").length()!=0){out.print(bgRs3.getString("extracurricular_practice_hour"));}else{out.print("&nbsp;&nbsp;");}%></div></td>
      <td width="40"  id="test_semester_<%=sysid %>" style="vnd.ms-excel.numberformat:@"><div ondblclick="change('<%=sysid%>','test_semester')"><%if(bgRs3.getString("test_semester").length()!=0){out.print(bgRs3.getString("test_semester"));}else{out.print("&nbsp;&nbsp;");}%></div></td>
      <td width="40"  id="check_semester_<%=sysid %>" style="vnd.ms-excel.numberformat:@"><div ondblclick="change('<%=sysid%>','check_semester')"><%if(bgRs3.getString("check_semester").length()!=0){out.print(bgRs3.getString("check_semester"));}else{out.print("&nbsp;&nbsp;");}%></div></td>
     <%
      int kkxq=1; //开课学期
      for(int j=1;j<=xz*2;j++){//每年2个学期循环
      %>
      <td width="95" align="center" id="start_semester<%=j%>_<%=sysid %>"><div  ondblclick="change('<%=sysid %>','start_semester<%=j%>')"><%if(bgRs3.getString("start_semester"+""+j).length()!=0){out.print(bgRs3.getString("start_semester"+""+j));}else{out.print("&nbsp;&nbsp;");}%></div></td>
    <%}%>
      <td width="79" id="credits_<%=sysid %>"><div ondblclick="change('<%=sysid%>','credits')"><%if(bgRs3.getString("credits").length()!=0){out.print(bgRs3.getString("credits"));}else{out.print("&nbsp;&nbsp;");}%></div></td>
      <td width="79" id="weeks_<%=sysid %>" style="vnd.ms-excel.numberformat:@"><div ondblclick="change('<%=sysid%>','weeks')"><%if(bgRs3.getString("weeks").length()!=0){out.print(bgRs3.getString("weeks"));}else{out.print("&nbsp;&nbsp;");}%></div></td>
      <td width="34" class="delete">
         <a id="edit_<%=sysid %>" href="javascript:rowAllchange('<%=sysid %>','edit');" style="display:block"><i class="layui-icon">&#xe642;</i></a>
         <a id="ok_<%=sysid %>" href="javascript:rowAllchange('<%=sysid %>','ok');");" style="display:none"><i class="layui-icon">&#xe616;</i></a>
      </td>
      <td align="center" class="delete"><input type="checkbox" name="checks" value="<%=sysid%>_<%=common.idToFieidName("dict_courses","course_name",course_id)%>"/></td>
    </tr>
    <%  j1=0; } //三级
            	   j2=0; }//二级
    %>
    <!-- 加入小计 -->   
    <tr>
       <td colspan="4" rowspan="1">
        <div align="center"><strong>小计</strong></div>
      </td>
          
      <td width="80" ><div ><strong><%=db.Row("SELECT SUM(total_classes) AS ROW FROM `teaching_plan_guidance` WHERE course_category_id='"+course_category_id+"' and  class_guidance_id='"+class_id+"';") %></strong></div></td>
      <td width="60" ><div ><strong><%=db.Row("SELECT SUM(lecture_classes) AS ROW FROM `teaching_plan_guidance` WHERE course_category_id='"+course_category_id+"' and  class_guidance_id='"+class_id+"';") %></strong></div></td>
      <td width="60" ><div><strong><%=db.Row("SELECT SUM(class_in) AS ROW FROM `teaching_plan_guidance` WHERE course_category_id='"+course_category_id+"' and  class_guidance_id='"+class_id+"';") %></strong></div></td>
      <td width="60" ><div><strong><%=db.Row("SELECT SUM(extracurricular_practice_hour) AS ROW FROM `teaching_plan_guidance` WHERE course_category_id='"+course_category_id+"' and  class_guidance_id='"+class_id+"';") %></strong></div></td>
<%--      <td width="60" ><div><strong><%=db.Row("SELECT SUM(test_semester) AS ROW FROM `teaching_plan_guidance` WHERE course_category_id='"+course_category_id+"' and  class_guidance_id='"+class_id+"';") %></strong></div></td>--%>
<%--      <td width="60" ><div><strong><%=db.Row("SELECT SUM(check_semester) AS ROW FROM `teaching_plan_guidance` WHERE course_category_id='"+course_category_id+"' and  class_guidance_id='"+class_id+"';") %></strong></div></td>--%>
     <td width="60" ></td>
     <td width="60" ></td>
     <%
    int kkxq2=1;
      for(int j=1;j<=xz*2;j++){  //每年2个学期循环
       %>
      <td width="95" align="center" id=""><div>
      <strong><%=db.Row("SELECT  SUM(start_semester"+""+j+") as row FROM teaching_plan_guidance WHERE course_category_id='"+course_category_id+"' and  class_guidance_id='"+class_id+"' and start_semester"+""+j+" REGEXP '^[0-9]+$' and start_semester"+""+j+"<26;")%></strong>    
      </div></td>
    <%}%>
<%--    <td width="60" ><div><strong><%=db.Row("SELECT SUM(credits) AS ROW FROM `teaching_plan_guidance` WHERE course_category_id='"+course_category_id+"' and  class_guidance_id='"+class_id+"';") %></strong></div></td>--%>
	    <td width="60" ><div><strong>
	    <%
  		//String creSql ="SELECT SUM(credits) AS ROW FROM `teaching_plan_guidance` WHERE class_guidance_id='"+class_id+"' and course_nature_id!=4;";
  		String creSql ="SELECT SUM(credits) AS ROW FROM `teaching_plan_guidance` WHERE  course_category_id='"+course_category_id+"' and  class_guidance_id='"+class_id+"';";
  		ResultSet rs = db.executeQuery(creSql);
  		String totalCre ="";
  		while(rs.next()){
  			totalCre = rs.getString("ROW");
  		}if(rs!=null)rs.close();
  		out.print(totalCre);
%></strong></div></td>
      <td width="79"><div></div></td>
      <td colspan="3" class="delete"><div align="center"></div></td>
    </tr>
     <!-- 加入小计结束 -->   	 
      <%        
      
      }if(bgRs1!=null)bgRs1.close(); //一级 %>
    <!-- 加入总计开始 -->   
    <tr>
       <td colspan="5" rowspan="1">
        <div align="center"><strong>总计（学时、周学时，不含选修课）</strong></div>
      </td>  
      <td width="80" ><div ><strong><%=db.Row("SELECT SUM(total_classes) AS ROW FROM `teaching_plan_guidance` WHERE class_guidance_id='"+class_id+"' and course_nature_id!=4;") %></strong></div></td>
      <td width="60" ><div ><strong><%=db.Row("SELECT SUM(lecture_classes) AS ROW FROM `teaching_plan_guidance` WHERE class_guidance_id='"+class_id+"' and course_nature_id!=4;") %></strong></div></td>
      <td width="60" ><div><strong><%=db.Row("SELECT SUM(class_in) AS ROW FROM `teaching_plan_guidance` WHERE class_guidance_id='"+class_id+"' and course_nature_id!=4;") %></strong></div></td>
      <td width="60" ><div><strong><%=db.Row("SELECT SUM(extracurricular_practice_hour) AS ROW FROM `teaching_plan_guidance` WHERE class_guidance_id='"+class_id+"' and course_nature_id!=4;") %></strong></div></td>
<%--      <td width="60" ><div><strong><%=db.Row("SELECT SUM(test_semester) AS ROW FROM `teaching_plan_guidance` WHERE class_guidance_id='"+class_id+"' and course_nature_id!=4;") %></strong></div></td>--%>
<%--      <td width="60" ><div><strong><%=db.Row("SELECT SUM(check_semester) AS ROW FROM `teaching_plan_guidance` WHERE class_guidance_id='"+class_id+"' and course_nature_id!=4;") %></strong></div></td>--%>
     	<td width="60" ></td>
     <td width="60" ></td>
     <%
    int kkxq2=1; ArrupField="course_id#total_classes#lecture_classes#class_in#extracurricular_practice_hour#test_semester#check_semester#weeks";
      for(int j=1;j<=xz*2;j++){ //每年2个学期循环
    	  ArrupField=ArrupField+"#"+"start_semester"+""+j;
       %>
      <td width="95" align="center" id=""><div>
      <strong><%=db.Row("SELECT  SUM(start_semester"+""+j+") as row FROM teaching_plan_guidance WHERE class_guidance_id='"+class_id+"'  and start_semester"+""+j+" REGEXP '^[0-9]+$' and course_nature_id!=4 and start_semester"+""+j+"<26 ;")%></strong>    
      </div></td>
    <%}%>
      <td width="60" ><div><strong>
      <%
      		String creSql ="SELECT SUM(credits) AS ROW FROM `teaching_plan_guidance` WHERE class_guidance_id='"+class_id+"' and course_nature_id!=4;";
      		ResultSet rs = db.executeQuery(creSql);
      		String totalCre ="";
      		while(rs.next()){
      			totalCre = rs.getString("ROW");
      		}if(rs!=null)rs.close();
      		out.print(totalCre);
      %></strong></div></td>
      <td width="79"><div></div></td>
      <td colspan="2" class="delete"><div align="center"><button class="layui-btn" onclick="deleteCourse()">删除</button></div></td>
    </tr>
     <!-- 加入总计结束 -->    
  </tbody>
</table>

         </div>
        </div>
      </div>
<p>　</p>
<p>　</p>
<p>　</p>
<p>　</p>
<p>　</p>
<p>　</p>
<p>　</p>

<script> 


//excel
  var idTmr;  
  function  getExplorer() {  
      var explorer = window.navigator.userAgent ;  
      //ie  
      if (explorer.indexOf("MSIE") >= 0) {  
          return 'ie';  
      }  
      //firefox  
      else if (explorer.indexOf("Firefox") >= 0) {  
          return 'Firefox';  
      }  
      //Chrome  
      else if(explorer.indexOf("Chrome") >= 0){  
          return 'Chrome';  
      }  
      //Opera  
      else if(explorer.indexOf("Opera") >= 0){  
          return 'Opera';  
      }  
      //Safari  
      else if(explorer.indexOf("Safari") >= 0){  
          return 'Safari';  
      }  
  }  
  function method5(tableid) {  
      
      if(getExplorer()=='ie')  
      {  
          var curTbl = document.getElementById(tableid);  
          var oXL = new ActiveXObject("Excel.Application");  
          var oWB = oXL.Workbooks.Add();  
          var xlsheet = oWB.Worksheets(1);  
          var sel = document.body.createTextRange();  
          //sel.moveToElementText(curTbl);  
          //sel.select();  
          sel.moveToElementText(document.getElementById("ieid"))
          sel.execCommand("Copy");  
          xlsheet.Paste();    
          oXL.Visible = true;

          try {  
              var fname = oXL.Application.GetSaveAsFilename("Excel.xls", "Excel Spreadsheets (*.xls), *.xls");  
          } catch (e) {  
              print("Nested catch caught " + e);  
          } finally {  
              oWB.SaveAs(fname);  
              oWB.Close(savechanges = false);  
              oXL.Quit();  
              oXL = null;  
              idTmr = window.setInterval("Cleanup();", 1);  
          }  

      }  
      else  
      {  
          tableToExcel(tableid)  
      }  
  }  
  function Cleanup() {  
      window.clearInterval(idTmr);  
      CollectGarbage();  
  }  
  var tableToExcel = (function() {  
      var uri = 'data:application/vnd.ms-excel;base64,',  
              template = '<html><head><meta charset="UTF-8"></head><body><table border="1" align="center">{table}</table></body></html>',  
              base64 = function(s) { return window.btoa(unescape(encodeURIComponent(s))) },  
              format = function(s, c) {  
                  return s.replace(/{(\w+)}/g,  
                          function(m, p) { return c[p]; }) }  
      return function(table, name) { 
          var aaa= $("#my-table1").html();
          var colspan=$("#my-table1 tbody tr td").eq(0).attr("colspan");
          $("#my-table1 tbody tr td").eq(0).attr("colspan",$("#my-table1 tbody tr td").eq(0).attr("colspan")-2);
          $(".delete").remove();

          for(i=0;i<$("#my-table1 tbody tr td").size();i++){
		//	  if (i>19) {
       // 	   $("#"+table+" tbody tr td").eq(i).html($("#"+table+" tbody tr td").eq(i).html().replace(/(\d+(\-\d+)+)/g, "　$1"));
	//	 $("#"+table+" tbody tr td").eq(i).html($("#"+table+" tbody tr td").eq(i).html().replace(/(\d\d\d\d\d\d\d)/g, "'$1"));}
        //  不在需要进行替换处理了用 style="vnd.ms-excel.numberformat:@" 在表格输出前设置数字格式 文本输出
          }
		  
          if (!table.nodeType) table = document.getElementById(table)  
          var ctx = {worksheet: name || 'Worksheet', table: table.innerHTML}  
          console.log(uri + base64(format(template, ctx)) );
          window.location.href = uri + base64(format(template, ctx))  
          $("#my-table1").html(aaa);
      }  
  })()  



/**
 * 搜索内容
 */
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

function fanhui(){
	 self.location='./guide_enact_list.jsp';
}
 //刷新整个页面
function shuaxin(){
	 location.reload();
}
layui.use('form', function() {
	
	layer = layui.layer,
	layedit = layui.layedit,
	laydate = layui.laydate;
	
	})
//执行
function ac_tion() {
       window.location.href="?ac=&val="+$('#search').val()+"";
}
//导出
layui.use('table', function(){
  var table = layui.table;
});
</script> 
<script> 
/**
 * 动态修改表格属性值，李高颂
 */
 /****************input框逻辑*****************/
 function change(sysid,upField){ //变成输入框

	 var upFieldValue=document.getElementById(upField+"_"+sysid).innerHTML;
	 upFieldValue=upFieldValue.replace(/<[^>]+>/g,"").trim(); 
	 if(upFieldValue.length==0){upFieldValue="0";}
	     
			 document.getElementById(upField+"_"+sysid).innerHTML="<div id=\""+upField+"_"+sysid+"\" ondblclick=\"upchange('"+sysid+"','"+upField+"')\"><input type=\"text\" id=\""+upField+"_up"+sysid+"\" value=\""+upFieldValue+"\" class=\"myinput\"  style=\"width:45px;\"></div>";
			 document.getElementById(upField+"_up"+sysid).focus();
			   //重置
	 sysid=""; upField=""; upFieldValue="";
  }

 function upchange(sysid,upField){ // 输入框双击更新
		//debugger;
		if(upField=='total_classes'){
			var zongke = $("#total_classes_up"+sysid).val();
			var xuefen =0.0;
			var newxuefen =0.0;
			if(parseFloat(zongke)<18){
					xuefen =0.5;
				}else{
					xuefen = parseFloat(zongke)/18;
					newxuefen =Math.round(xuefen);
					if(newxuefen>xuefen){
						xuefen = newxuefen-0.5;
					}else{
						xuefen = newxuefen;
					}
				}
			$("#credits_"+sysid).text(xuefen);
			upchange(sysid,'credits');
	}
		
	 var upFieldValue=document.getElementById(upField+"_up"+sysid);
	 if(null==upFieldValue){
		 upFieldValue=$("#"+upField+"_"+sysid).text();
		 }else{
			 upFieldValue=$("#"+upField+"_up"+sysid).val();
		}
	 upFieldValu=Trim(upFieldValue,"g");
	 //获取教学周数
	  var s=upField.substr(0,upField.length-1)
	  if(s=="start_semester"){
	  var index=upField.substr(upField.length-1,1)
	  var class_id=document.getElementById("class_id").value;
	  var weekly=document.getElementById("semester_weekly"+index+"_"+class_id).firstChild.innerText;
	    }
	 //更新数据库
     var updata=PostApi("upField="+upField+"&upld="+sysid+"&upldValue="+upFieldValu+"&weekly="+weekly+"","guide_enact.jsp?ac=updata_Field_ac");
   
	  document.getElementById(upField+"_"+sysid).innerHTML="<div id=\""+upField+"_"+sysid+"\" ondblclick=\"change('"+sysid+"','"+upField+"')\">"+upFieldValue+"</div>";
   //重置
     
     layer.msg(updata);
     //是修改排序
     if(upField=="sort"){
         shuaxin();}
	 sysid=""; upField=""; upFieldValue="";updata="";
  }
 //过滤字符串中的空格
 function Trim(str,is_global)
 {
  var result;
  result = str.replace(/(^\s+)|(\s+$)/g,"");
  if(is_global.toLowerCase()=="g")
  {
   result = result.replace(/\s/g,"");
   }
  return result;
}
 /**
  * 动态修改表格属性值，王巨星
  */
 /****************教学周数input框逻辑*****************/
 function jxchange(sysid,upField){ //变成输入框
	
	 var upFieldValue=document.getElementById(upField+"_"+sysid).innerHTML;
	 upFieldValue=upFieldValue.replace(/<[^>]+>/g,"").trim(); 
	 if(upFieldValue.length==0){upFieldValue="0";}
	     
			 document.getElementById(upField+"_"+sysid).innerHTML="<div id=\""+upField+"_"+sysid+"\" ondblclick=\"jxupchange('"+sysid+"','"+upField+"')\"><input type=\"text\" id=\""+upField+"_up"+sysid+"\" value=\""+upFieldValue+"\" class=\"myinput\"  style=\"width:45px;\"></div>";
			 document.getElementById(upField+"_up"+sysid).focus();
			   //重置
	 sysid=""; upField=""; upFieldValue="";
  }

 function jxupchange(sysid,upField){ // 输入框双击更新
	 var upFieldValue=document.getElementById(upField+"_up"+sysid).value;
	 upFieldValu=Trim(upFieldValue,"g");
	 //更新数据库
     var updata=PostApi("upField="+upField+"&upld="+sysid+"&upldValue="+upFieldValu+"","guide_enact.jsp?ac=updata_jx_ac");
   
	  document.getElementById(upField+"_"+sysid).innerHTML="<div id=\""+upField+"_"+sysid+"\" ondblclick=\"jxchange('"+sysid+"','"+upField+"')\">"+upFieldValue+"</div>";
   //重置
     
     layer.msg(updata);
    
	 sysid=""; upField=""; upFieldValue="";updata="";
  }
/****************下拉框逻辑*****************/
  
  function selectChane(sysid,upField,upFieldValue){//下拉框双击弹出
	 
	  var updata=PostApi("upField="+upField+"&upld="+sysid+"&upldValue="+upFieldValue+"","guide_enact.jsp?ac=getSelect_ac");
	    document.getElementById("course_id_"+sysid).innerHTML="<div style='heigth:100%;' id=\""+upField+"_"+sysid+"\">"+updata+"</div>";
			var a =$('#'+upField+"_"+sysid+" select").last();
			kejin('a','0',a);
 }

  function selectChaneOne(sysid,upField,upFieldValue){//下拉框双击弹出
		 
	  var updata=PostApi("upField="+upField+"&upld="+sysid+"&upldValue="+upFieldValue+"","guide_enact.jsp?ac=getSelect_acOne");
	    document.getElementById("process_id_"+sysid).innerHTML="<div style='heigth:100%;' id=\""+upField+"_"+sysid+"\">"+updata+"</div>";
 }

  function upselectChane(upFieldValue,sysid,upField){ //下拉框单击击更新
		    //更新数据库
	      var updata=PostApi("upField="+upField+"&upld="+sysid+"&upldValue="+upFieldValue+"","guide_enact.jsp?ac=updata_Field_ac");
			if(document.getElementById(upField+"_"+sysid)==undefined){
				return;
				}
	      document.getElementById(upField+"_"+sysid).innerHTML="<div id=\""+upField+"_"+sysid+"\" ondblclick=\"selectChane('"+sysid+"','"+upField+"')\">"+upFieldValue+"</div>";
	   //重置
	   	 //alert(updata);
	     shuaxin();
		 sysid=""; upField=""; upFieldValue="";updata="";
	  }

  function rowAllchange(sysid,ac){ 
	  //批量修改某条记录
       var ArrupField="<%=ArrupField%>";
       var Fields=ArrupField.split("#");
       var Field="";
           for(var i=0; i<Fields.length;i++){
                Field=Fields[i];
                if(Field.indexOf("course_id")!=-1) {
                              }else{
                                  if("edit"==ac){
                                	  document.getElementById("edit_"+sysid).style.display = "none";
                                	  document.getElementById("ok_"+sysid).style.display = "block";
                                          change(sysid,Field);
                                         }else{
                                        	 document.getElementById("ok_"+sysid).style.display = "none";
                                        	 document.getElementById("edit_"+sysid).style.display = "block";
                                             upchange(sysid,Field); 
                                         } 
                             }
           }
	  }

  //添加课程和进程 state=0 表示课程  state=1 表示进程
 function addCourse(teachPlanClass,state){
	 //获取专业
	 var major_id=document.getElementById("major_id").value;
	 //获取院系
	 var dict_departments_id=document.getElementById("dict_departments_id").value;
	 //获取入学年份
	 var xn=document.getElementById("xn").value;
	 var updata=PostApi("teachPlanClass="+teachPlanClass+"","guide_enact.jsp?ac=add_teachPlanClass&major_id="+major_id+"&dict_departments_id="+dict_departments_id+"&xn="+xn+"&state="+state+"");
	// alert(updata);
     shuaxin();
     teachPlanClass="";
	}
	//删除课程
function deleteCourse(){
	var id = document.getElementsByName('checks');
    var checks="";
    var delect_courses="";
    var course_name="";
    for(var i = 0; i < id.length; i++){
          var ids="";
          var names="";
          
          if(id[i].checked){
        	checks=id[i].value; 
        	
        	var strs= new Array(); //定义一数组 
        	strs=checks.split("_"); //字符分割         
        
        		delect_courses+=strs[0]+",";  
        		course_name+="【"+strs[1]+"】";             
         }
    }
    layer.confirm("是否删除"+course_name+"?", {
    	  btn: ['删除','不删除'] //按钮
    	}, function(){
    		var updata=PostApi("delect_courses="+delect_courses+"","guide_enact.jsp?ac=delect_course");
    	    //alert(updata);
    	    shuaxin();
    	    checks="";
    	}, function(){
    	
    	});
    
}
//ajax请求函数
  function PostApi(str,acurl){
	  
	  var backdata;
	  $.ajax( {
	  	 		// 提交数据的类型 POST GET
	  	 		type : "GET",
	  	 		// 提交的网址
	  	 		url : acurl+"&"+str,
	  	 		// 提交的数据
	  	 		data :'{}',
	  	 		// 返回数据的格式
	  	 		async : false,//不是同步的话 返回值娶不到
	  	 		datatype : "txt",// "xml", "html", "script", "json", "jsonp",
	  	 		// "text".
	  	 		// 成功返回之后调用的函数
	  	 		success : function(data){
		             backdata=data;              
	  	        },
	  	 		 headers : {
	  	 			"Content-type" : "application/x-www-form-urlencoded",
	  	 			"X-AppId" : "<%=AppId_web%>",
	  	 			"X-AppKey" : "<%=AppKey_web%>",
	  	 			"Token" : "<%=Spc_token%>",
	  	 			"X-USERID": "<%=Suid%>",
	  	 			"X-UUID": "<%=uuid%>",
	  	 		 }, 
	  	 		// 调用执行后调用的函数
	  	 		complete : function(XMLHttpRequest, textStatus){
	  	 		  if (textStatus == "成功"){
	  	 			  //$("#msg").html(XMLHttpReques.=XMLHttpRequest.responseText;);
	  	 			  //alert(data1);
	  	            }
	  	 		 },
	  	 	    // 调用出错执行的函数
	  	 		error : function(){
	  	 			 backdata="系统消息：网络故障与服务器失去联系";
	  	 		 }
	  	 	}); 
	 	return backdata;
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
  //checkbox 全选/取消全选  
  var isCheckAll = false;  
  function swapCheck() {  
      if (isCheckAll) {  
          $("input[type='checkbox']").each(function() {  
              this.checked = false;  
          });  
          isCheckAll = false;  
      } else {  
          $("input[type='checkbox']").each(function() {  
              this.checked = true;  
          });  
          isCheckAll = true;  
      }  
  }  
  //课程进程选择
  function kejin(radioV,upFieldValue,thi){
	    var updata=PostApi("radioV="+radioV+"&upldValue="+upFieldValue+"","guide_enact.jsp?ac=kejin"); 
	    document.getElementById("dict_courses").innerHTML=updata; 
		$(thi).comboSelect();
		
		$(thi).removeAttr("onclick");
	  }
 
</script>
 
  </body>
</html>
<%}else if("getSelect_ac".equals(ac)) { 
	//查询课程
	 String upField=request.getParameter("upField");
	 String upld=request.getParameter("upld");
	 String upldValue=request.getParameter("upldValue");
	 if(upField==null){upField="";}
	 if(upldValue==null){upldValue="";}
	 if(upld==null){upld="";}
	 System.out.println("//查询课程upField="+upField);
	 System.out.println("//查询课程upldValue="+upldValue);
	 System.out.println("//查询课程upld="+upld);
	//下拉框
%>
<div>
	课程类别:
	<select name="course_category" id="course_category"  onchange="upselectChane(this.value,'<%=upld %>','course_category_id')">
		<option value="0">请选择课程类别</option>
		 <%
			 if(upld.length()<1 || upld.length()<1 || upldValue.length()<1 ){
				  out.println("查询错误");
				  return;
			 }
		   	 ArrayList<String> categoryField= new ArrayList<String>();
		     categoryField.add("id");
		     categoryField.add("category_code");
		     categoryField.add("category");
		    
		  	 List<Map<String, Object>> categoryResult = new ArrayList<Map<String, Object>>();
		     categoryResult=common.getPubSqlData(categoryField,"SELECT ? FROM  `dict_course_category`"," ");
		     for(int i=0;i<categoryResult.size();i++){
		  %>      <option value="<%=categoryResult.get(i).get("id") %>"  <%if(categoryResult.get(i).get("id").equals(upldValue)){out.print("selected=\"selected\"");} %> >[<%=categoryResult.get(i).get("category_code") %>]<%=categoryResult.get(i).get("category")%></option>
		 <%  }%>
     </select>
</div> 
<div>
	课程性质:
	<select name="course_nature" id="course_nature"  onchange="upselectChane(this.value,'<%=upld %>','course_nature_id')">
		<option value="0">请选择课程性质</option>
		<%
		 if(upld.length()<1 || upld.length()<1 || upldValue.length()<1 ){
			  out.println("查询错误");
			  return;
		 }
  		 ArrayList<String> natureField= new ArrayList<String>();
	     natureField.add("id");
	     natureField.add("nature_code");
	     natureField.add("nature");
 		 List<Map<String, Object>> natureResult = new ArrayList<Map<String, Object>>();
       	 natureResult=common.getPubSqlData(natureField,"SELECT ? FROM  `dict_course_nature`"," ");
       	 for(int i=0;i<natureResult.size();i++){%>
       	 <option value="<%=natureResult.get(i).get("id") %>"  <%if(natureResult.get(i).get("id").equals(upldValue)){out.print("selected=\"selected\"");} %> >[<%=natureResult.get(i).get("nature_code") %>]<%=natureResult.get(i).get("nature")%></option>
       <%}%>
    </select>
</div>
<div id="dict_c">
	选择:	
	<select name="dict_courses" id="dict_courses" style="width: 150px;display:inline-block;" onclick="kejin('a','<%=upldValue %>',this)"  onchange="upselectChane(this.value,'<%=upld %>','<%=upField %>')">
    </select>
    <button class="layui-btn" onclick="shuaxin()">确认</button>
 </div>
<%}else if("getSelect_acOne".equals(ac)) { 	//进程
	 String upField=request.getParameter("upField");
	 String upld=request.getParameter("upld");
	 String upldValue=request.getParameter("upldValue");
	 if(upField==null){upField="";}
	 if(upldValue==null){upldValue="";}
	 if(upld==null){upld="";}
	//下拉框
%>
<div>课程类别:<select name="course_category" id="course_category"  onchange="upselectChane(this.value,'<%=upld %>','course_category_id')">
<option value="0">请选择课程类别</option>
 <%
 if(upld.length()<1 || upld.length()<1 || upldValue.length()<1 ){
	  out.println("查询错误");
	  return;
 }
   ArrayList<String> categoryField= new ArrayList<String>();
      categoryField.add("id");
      categoryField.add("category_code");
      categoryField.add("category");
    
  List<Map<String, Object>> categoryResult = new ArrayList<Map<String, Object>>();
         categoryResult=common.getPubSqlData(categoryField,"SELECT ? FROM  `dict_course_category`"," ");
       for(int i=0;i<categoryResult.size();i++){%><option value="<%=categoryResult.get(i).get("id") %>"  <%if(categoryResult.get(i).get("id").equals(upldValue)){out.print("selected=\"selected\"");} %> >[<%=categoryResult.get(i).get("category_code") %>]<%=categoryResult.get(i).get("category")%></option>
       <%}%>
  </select></div> 
<div>课程性质:<select name="course_nature" id="course_nature"  onchange="upselectChane(this.value,'<%=upld %>','course_nature_id')">
<option value="0">请选择课程性质</option>
 <%
 if(upld.length()<1 || upld.length()<1 || upldValue.length()<1 ){
	  out.println("查询错误");
	  return;
 }
   ArrayList<String> natureField= new ArrayList<String>();
     natureField.add("id");
     natureField.add("nature_code");
     natureField.add("nature");
  List<Map<String, Object>> natureResult = new ArrayList<Map<String, Object>>();
        natureResult=common.getPubSqlData(natureField,"SELECT ? FROM  `dict_course_nature`"," ");
       for(int i=0;i<natureResult.size();i++){%><option value="<%=natureResult.get(i).get("id") %>"  <%if(natureResult.get(i).get("id").equals(upldValue)){out.print("selected=\"selected\"");} %> >[<%=natureResult.get(i).get("nature_code") %>]<%=natureResult.get(i).get("nature")%></option>
       <%}%>
  </select></div>
<div id="dict_c">选择:
<select name="dict_courses" id="dict_courses" style="width: 150px;display:inline-block;" onchange="upselectChane(this.value,'<%=upld %>','<%=upField %>')">
	<option value="0">请选择进程</option>
	<%
		String select_sqqsl = "select id,process_symbol_name from dict_process_symbol";
		ResultSet selelset = db.executeQuery(select_sqqsl);
		while(selelset.next()){
	%>
		<option value="<%=selelset.getString("id")%>"><%=selelset.getString("process_symbol_name") %></option>
	<%}if(selelset!=null){selelset.close();} %>
  </select>
  <button class="layui-btn" onclick="shuaxin()">确认</button></div>

<%}%>

<%else if("updata_Field_ac".equals(ac)) {  
 //更新传输过来的字段名与id
 String upField=request.getParameter("upField");
 String upld=request.getParameter("upld");
 String upldValue=request.getParameter("upldValue").trim();
 String weekly=request.getParameter("weekly");
 if(upField==null){upField="";}
 if(upldValue==null){upldValue="";}
 upldValue=URLDecoder.decode(upldValue, "UTF-8");

 upldValue = upldValue.trim();
 upldValue= upldValue.replaceAll(" ", "");
 
 if(upld==null){upld="";}
 System.out.println("更新upField="+upField);
 System.out.println("更新upldValue="+upldValue);
 System.out.println("更新upld="+upld);
 System.out.println("UPDATE  `teaching_plan_guidance` SET `"+upField+"`='"+upldValue+"' WHERE `id`='"+upld+"';");
 if(upld.length()<1){
	  out.println("更新错误");
  }else{
	  String field=upField.substring(0, upField.length()-1);
	  if("start_semester".equals(field)){
		 if(upldValue.contains("*")){ 
	       if(db.executeUpdate("UPDATE  `teaching_plan_guidance` SET `"+upField+"`='"+upldValue+"' WHERE `id`='"+upld+"';")==true){
	    	   int leng=upldValue.indexOf("*");
	    	   char Field=upField.charAt(upField.length()-1);
	    	   String result=upldValue.substring(0,leng);
	    	   db.executeUpdate("UPDATE  `teaching_plan_guidance` SET `classes_weekly"+Field+"`='"+result+"' WHERE `id`='"+upld+"';");
	         out.println("成功更新数值为:"+upldValue);
	         }else{out.println("更新失败：输入格式不对！");}
		 }else{
			 if(db.executeUpdate("UPDATE  `teaching_plan_guidance` SET `"+upField+"`='"+upldValue+"' WHERE `id`='"+upld+"';")==true){
				 char Field=upField.charAt(upField.length()-1);
				 db.executeUpdate("UPDATE  `teaching_plan_guidance` SET `classes_weekly"+Field+"`='"+weekly+"' WHERE `id`='"+upld+"';");
		         out.println("成功更新数值为:"+upldValue);
		         }else{out.println("更新失败：输入格式不对！");} 
	       }	       
	  }else{
		  if(db.executeUpdate("UPDATE  `teaching_plan_guidance` SET `"+upField+"`='"+upldValue+"' WHERE `id`='"+upld+"';")==true){
		         out.println("成功更新数值为:"+upldValue);
		    }else{out.println("更新失败：输入格式不对！");}
		  
	  }
  }
 //更新教学周数
}else if("updata_jx_ac".equals(ac)) {  
	 //更新传输过来的字段名与id
	 String upField=request.getParameter("upField");
	 String upld=request.getParameter("upld");
	 String upldValue=request.getParameter("upldValue");
	 if(upField==null){upField="";}
	 if(upldValue==null){upldValue="";}
	 upldValue=URLDecoder.decode(upldValue, "UTF-8");

	 upldValue = upldValue.trim();
	 upldValue= upldValue.replaceAll(" ", "");
	 
	 if(upld==null){upld="";}
	 System.out.println("更新upField="+upField);
	 System.out.println("更新upldValue="+upldValue);
	 System.out.println("更新upld="+upld);
	 System.out.println("UPDATE  `teaching_plan_class_guidance` SET `"+upField+"`='"+upldValue+"' WHERE `id`='"+upld+"';");
	 if(upld.length()<1){
		  out.println("更新错误");
	  }else{
		   if(db.executeUpdate("UPDATE  `teaching_plan_class_guidance` SET `"+upField+"`='"+upldValue+"' WHERE `id`='"+upld+"';")==true){
			   char Field=upField.charAt(upField.length()-1);
			   db.executeUpdate("UPDATE  `teaching_plan_guidance` SET `classes_weekly"+Field+"`='"+upldValue+"' WHERE `class_guidance_id`='"+upld+"' AND `start_semester"+Field+"` NOT LIKE '%*%';");
			   
		         out.println("成功更新数值为:"+upldValue);
		   }else{out.println("更新失败：输入格式不对！");}   
	  }
 }else if("add_teachPlanClass".equals(ac)) {  
	 
 //增加计划里的课程
 String teachPlanClass=request.getParameter("teachPlanClass");
 String state = request.getParameter("state");
 if(teachPlanClass==null){teachPlanClass="";}
 teachPlanClass=teachPlanClass.replaceAll(" ","");

 String major_id=request.getParameter("major_id");
 if(major_id==null){major_id="";}
 major_id=major_id.replaceAll(" ","");
 
 String dict_departments_id=request.getParameter("dict_departments_id");
 if(dict_departments_id==null){dict_departments_id="";}
 dict_departments_id=dict_departments_id.replaceAll(" ","");
 
 String xn=request.getParameter("xn");
 if(xn==null){xn="";}
 xn=xn.replaceAll(" ","");
 
 int sotr001=db.Row("select (sort+1) Row from teaching_plan_guidance where class_guidance_id='"+ teachPlanClass +"' order by sort desc limit 1; ");
 if(sotr001==0){sotr001=1;}
 if(teachPlanClass.length()<1 ){
	  out.println("添加课程失败");
 }else{
	   if(db.executeUpdate("INSERT INTO `teaching_plan_guidance` (`major_id`,`dict_departments_id`,`school_year`,`course_category_id`,`course_nature_id`,`class_guidance_id`,`courserprocess`,`sort`) VALUES ('"+major_id+"','"+dict_departments_id+"','"+xn+"','0','0','"+teachPlanClass+"','"+state+"','"+sotr001+"');")==true){
	   out.println("添加空白行成功，请红色区域设置课程参数");
	   }else{  out.println("添加课程失败"); }   
 }
 }else if("delect_course".equals(ac)) {  
	 //删除计划里的课程
	 String checks=request.getParameter("delect_courses");
	 if(checks==null){checks="";};
	
	 if(checks.length()<1 ){
		  out.println("删除错误");
	 }else{
		 String str=checks.substring(0,checks.length());
		  if(str.length()>1){ String[] strArry=str.split(",");
		       for(int i=0;i<strArry.length;i++){
		    	   System.out.println(strArry[i]);
		    	   if(db.executeUpdate("DELETE FROM `teaching_plan_guidance` WHERE id="+strArry[i]+";")==true){
		    		      out.print("删除成功");
		    		   }else{  out.println("删除失败"); }
		       }
		  }else if(str.length()==1){ if(db.executeUpdate("DELETE FROM `teaching_plan_guidance` WHERE id="+str+";")==true){
		      out.print("删除成功");
		   }else{  out.println("删除失败"); }};    
	 }
 }else if("kejin".equals(ac)){
	 String radioV=request.getParameter("radioV");
	 String upldValue=request.getParameter("upldValue");
	 if( upldValue.length()<1 ){
		  out.println("查询错误");
		  return;
	 }
	 if("a".equals(radioV)){
	   ArrayList<String> coursesField= new ArrayList<String>();
	     coursesField.add("id");
	     coursesField.add("course_name");
	     coursesField.add("course_code");
	    
  		List<Map<String, Object>> coursesResult = new ArrayList<Map<String, Object>>();
	     // coursesResult=common.getPubSqlData(coursesField,"SELECT ? FROM  `dict_courses` WHERE curriculum_type=2"," ");
	      coursesResult=common.getPubSqlData(coursesField,"SELECT ? FROM  `dict_courses` "," ");
	      %>
	      <option value="">请选择课程</option>
	      <%
	       for(int i=0;i<coursesResult.size();i++){%><option value="<%=coursesResult.get(i).get("id") %>"  <%if(coursesResult.get(i).get("id").equals(upldValue)){out.print("selected=\"selected\"");} %> >[<%=coursesResult.get(i).get("course_code") %>]<%=coursesResult.get(i).get("course_name")%></option>
	       
	       <% }
	       }
	}%>

<%
//插入常用菜单日志 
int   TagMenu=db.Row("SELECT COUNT(*) as row FROM  menu_worker  WHERE sysmenuid='"+PMenuId+"' and  workerid='"+Suid+"' and  companyid="+Scompanyid);
if(TagMenu==0){
  db.executeUpdate("INSERT INTO `menu_worker`(`sysmenuid`,`workerid`,`countes`,`companyid`) VALUES ('"+PMenuId+"','"+Suid+"','1','"+Scompanyid+"');"); 
}else{
 db.executeUpdate("UPDATE  `menu_worker` SET `countes`=countes+1,`usetime`=now() WHERE  sysmenuid='"+PMenuId+"' and  workerid='"+Suid+"' and  companyid="+Scompanyid);
}
long TimeEnd=Calendar.getInstance().getTimeInMillis();
System.out.println("执行时间"+ (TimeEnd-TimeStart)+"ms");
 %>
<% 
if(db!=null)db.close();db=null;if(server!=null)server=null;%>