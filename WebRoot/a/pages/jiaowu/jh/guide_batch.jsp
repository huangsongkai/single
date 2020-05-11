<%@ page trimDirectiveWhitespaces="true" %>
<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@page import="v1.haocheok.commom.common"%>
<%@page import="service.dao.db.Page"%>
<%@include file="../../cookie.jsp"%>
<%    String class_id=request.getParameter("class_id"); //获取分类id
      String major_id=request.getParameter("major_id"); //获取专业id
      //String major_name=request.getParameter("major_name"); //获取专业id
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
 		if(regex_num(class_id)==false ){class_id="0";}	
 		int majorId=Integer.parseInt(major);
 		int xnxq=Integer.parseInt(xn);
 		
%>
 <%
          //SQL语
     	//开始查询专业表
      ResultSet Rs = db.executeQuery("select eductional_systme_id,school_year,major_name from major where id='"+major_id+"';");
      //学制
     int xz=0;
      String major_name ="";
      while(Rs.next()){
             xz=Rs.getInt("eductional_systme_id");       
             major_name = Rs.getString("major_name");
     }if(Rs!=null){Rs.close();}
  %>
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
		        <button class="layui-btn layui-btn-small  layui-btn-primary" onclick="fanhui()" style="height: 35px;  color: white; background: rgb(25, 160, 148);"> <i class="layui-icon" style="color: #FFF;">&#xe65c;</i> 返回</button>
	
		    	<button class="layui-btn layui-btn-small  layui-btn-primary" onclick="shuaxin()" style="height: 35px;  color: white; background: rgb(25, 160, 148);"> <i class="layui-icon" style="color: #FFF;">ဂ</i> 刷新</button>
		    	<input type="button" name="xxx" value="导出excel" onclick="method5('my-table1');" class="layui-btn">
<%--		        <button class="layui-btn layui-btn-small  layui-btn-primary " onclick="help(<%=PMenuId %>)" style="height: 35px;  color:#A9A9A9; background: rgb(245, 245, 245);"><i class="layui-icon"></i>帮助</button>--%>
		    </div>
    
<div  style="display:block;clear:both;">

<!-- test --> 
<div id="LAY_preview">

<table border="1" width="100%" bordercolorlight="#588FC7" cellspacing="0" cellpadding="0" bordercolor="#19A094"   id="my-table1" >
  <tbody>
     <tr>
	     <td colspan="<%=14+xz*2%>"  align="center">
	     	<h2><%=xn%>级<%=major_name%>专业人才培养方案进程表</h2>
	     </td>
     </tr>
    <tr>
      <td width="46" height="20" rowspan="4" colspan="2"><p align="center">课程<br />分类</p></td>
      <td width="22" height="20" rowspan="4" ><p align="center">序号</td>
      <td width="165" height="20" rowspan="4"><p align="center">课程名称<br/>或教学内容</p></td>
      <td width="66" height="20" rowspan="4"><p align="center">课程编号</p></td>
      <td height="20" colspan="4"><p align="center">计划学时数</p></td>
      <td width="28" height="20" rowspan="4"><p align="center">考试学期</p></td>
      <td width="28" height="20" rowspan="4"><p align="center">考查学期</p></td>
      <td height="20" colspan="<%=xz*2%>"><p align="center">学期分配周课时数</p></td>
      <td width="30" height="20" rowspan="4"><p align="center">学分</p></td>
      <td width="30" height="20" rowspan="4"><p align="center">开课周次</p></td>
      <td width="34" height="20" rowspan="4"  class="delete"><p align="center">操作</p></td>
    </tr>
    <tr>
      <td width="34" height="20" rowspan="3" align="center">课程<br />总学时</td>
      <td width="34" height="20" rowspan="3" align="center">理论<br />教学</td>
      <td width="60" height="20" colspan="2" align="center">实践教学</td>
      <%
      //学年计算通过学制
      //q是第一个学期h是第二个学期
      int q=Integer.parseInt(xn),h=0;
      for(int i=0;i<xz;i++){
             h=q+1;
      %>
      <td width="22" height="16" colspan="2" align="center"><%=q%>-<%=h%>学年</td>
      <%
      q++;
      h++;
      }%>
    </tr>
    <tr>
    <td width="34" height="20" rowspan="2" align="center">课内</td>
    <td width="34" height="20" rowspan="2" align="center">独立<br/>设置</td>
    <%for(int j=1;j<=xz*2;j++){%>
      <td width="22" height="15" align="center"><p align="center"><%=j %></p></td>
    <%}%>
    </tr>
     <tr>
     <%
     ResultSet zzRs=null;
     zzRs=db.executeQuery("SELECT *   FROM teaching_plan_class_guidance WHERE id='"+class_id+"';"); 
     int row =1;
     while(zzRs.next()){  
     for(int j=1;j<=xz*2;j++){%>
       <td width="22" height="16" align="center" ><div ><%if(zzRs.getString("semester_weekly"+""+j).length()!=0){out.print(zzRs.getString("semester_weekly"+""+j));}else{out.print("&nbsp;&nbsp;");}%></div></td>
       <%}
     }%>
    </tr> 
    <% 
    ResultSet bgRs1=null; ResultSet bgRs2=null; ResultSet bgRs3=null;
    int j1=0;int j2=0;int j3=0;  
           String course_nature_id="",course_category_id="",course_id="",sysid="" ,courserprocess="",process_id="";
           bgRs1=db.executeQuery("SELECT DISTINCT course_category_id   FROM teaching_plan_guidance WHERE  class_guidance_id='"+class_id+"';");  //一级循环
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
        <%if(j1==1){ %>
      <td width="22" colspan="1" rowspan="<%=bg1+1%>"><%=common.idToFieidName("dict_course_category","category",course_category_id)%></td>
          <%} %>
          <%if(j2==1){%>
      <td width="22" colspan="1" rowspan="<%=bg2%>"><%=common.idToFieidName("dict_course_nature","nature",course_nature_id)%></td>
          <%}%>
<%--      <td width="40"  id="sort_<%=sysid %>"><div ><%=row%></div></td>--%>
      <td width="22"  id="sort_<%=sysid %>"><div ondblclick="change('<%=sysid%>','sort')" ><%if(bgRs3.getString("sort").length()!=0&&!bgRs3.getString("sort").equals("0")){out.print(bgRs3.getString("sort"));}else{out.print(row);}%></div></td>
     	    <% row++; %>
     	    
      <%
      	if("0".equals(courserprocess)){
      		//课程
      %>
			<% if("0".equals(course_id)){%> <td style="background:red" width="115" id="course_id_<%=sysid %>"  ondblclick="selectChane('<%=sysid %>','course_id','<%=course_id %>')">请双击选择课程</td>
			<%}else{%>
			<td width="165" id="course_id_<%=sysid %>"  ondblclick="selectChane('<%=sysid %>','course_id','<%=course_id %>')"><%=common.idToFieidName("dict_courses","course_name",course_id)%></td>
			<%}%>
			<td width="66" id="course_code_<%=sysid %>" style="vnd.ms-excel.numberformat:@" ><%=common.idToFieidName("dict_courses","course_code",course_id)%></td>
      <%}else{ //进程%>
      		<% if("0".equals(process_id)){%> <td style="background:red" width="115" id="process_id_<%=sysid %>"  ondblclick="selectChaneOne('<%=sysid %>','process_id','<%=process_id %>')">请双击选择进程</td>
			<%}else{%>
			<td width="165" id="process_id_<%=sysid %>"  ondblclick="selectChaneOne('<%=sysid %>','process_id','<%=process_id %>')"><%=common.idToFieidName("dict_process_symbol","process_symbol_name",process_id)%></td>
			<%}%>
			<td width="56" id="course_code_<%=sysid %>">暂无</td>
      <%} %>
      
      
      
  
      <td width="24"  id="total_classes_<%=sysid %>"><div ><%if(bgRs3.getString("total_classes").length()!=0){out.print(bgRs3.getString("total_classes"));}else{out.print("&nbsp;&nbsp;");}%></div></td>
      <td width="22"  id="lecture_classes_<%=sysid %>"><div ><%if(bgRs3.getString("lecture_classes").length()!=0){out.print(bgRs3.getString("lecture_classes"));}else{out.print("&nbsp;&nbsp;");}%></div></td>
      <td width="22"  id="class_in_<%=sysid %>"><div ><%if(bgRs3.getString("class_in").length()!=0){out.print(bgRs3.getString("class_in"));}else{out.print("&nbsp;&nbsp;");}%></div></td>
      <td width="22"  id="extracurricular_practice_hour_<%=sysid %>"><div ><%if(bgRs3.getString("extracurricular_practice_hour").length()!=0){out.print(bgRs3.getString("extracurricular_practice_hour"));}else{out.print("&nbsp;&nbsp;");}%></div></td>
      <td style="vnd.ms-excel.numberformat:@" width="28"  id="test_semester_<%=sysid %>"><div><%if(bgRs3.getString("test_semester").length()!=0){out.print(bgRs3.getString("test_semester"));}else{out.print("&nbsp;&nbsp;");}%></div></td>
      <td style="vnd.ms-excel.numberformat:@" width="28"  id="check_semester_<%=sysid %>"><div ><%if(bgRs3.getString("check_semester").length()!=0){out.print(bgRs3.getString("check_semester"));}else{out.print("&nbsp;&nbsp;");}%></div></td>
     <%
      int kkxq=1; //开课学期
      for(int j=1;j<=xz*2;j++){  //每年2个学期循环
      %>
      <td width="22" align="center" id="start_semester<%=j%>_<%=sysid %>"><div  ><%if(bgRs3.getString("start_semester"+""+j).length()!=0){out.print(bgRs3.getString("start_semester"+""+j));}else{out.print("&nbsp;&nbsp;");}%></div></td>
    <%}%>
    <td width="30" id="credits_<%=sysid %>"><div ondblclick="change('<%=sysid%>','credits')"><%if(bgRs3.getString("credits").length()!=0){out.print(bgRs3.getString("credits"));}else{out.print("&nbsp;&nbsp;");}%></div></td>
      <td style="vnd.ms-excel.numberformat:@" width="36" id="weeks_<%=sysid %>"><div ><%if(bgRs3.getString("weeks").length()!=0){out.print(bgRs3.getString("weeks"));}else{out.print("&nbsp;&nbsp;");}%></div></td>
      <td width="34" class="delete">
       
      </td>
     
    </tr>
    <%  j1=0; } //三级
            	   j2=0; }//二级
    %>
    
    <!-- 加入小计 -->   
    <tr>
       <td colspan="4" rowspan="1">
        <div align="center"><strong>小计</strong></div>
      </td>
          
      <td width="28" ><div ><strong><%=db.Row("SELECT SUM(total_classes) AS ROW FROM `teaching_plan_guidance` WHERE course_category_id='"+course_category_id+"' and  class_guidance_id='"+class_id+"';") %></strong></div></td>
      <td width="22" ><div ><strong><%=db.Row("SELECT SUM(lecture_classes) AS ROW FROM `teaching_plan_guidance` WHERE course_category_id='"+course_category_id+"' and  class_guidance_id='"+class_id+"';") %></strong></div></td>
      <td width="22" ><div><strong><%=db.Row("SELECT SUM(class_in) AS ROW FROM `teaching_plan_guidance` WHERE course_category_id='"+course_category_id+"' and  class_guidance_id='"+class_id+"';") %></strong></div></td>
      <td width="22" ><div><strong><%=db.Row("SELECT SUM(extracurricular_practice_hour) AS ROW FROM `teaching_plan_guidance` WHERE course_category_id='"+course_category_id+"' and  class_guidance_id='"+class_id+"';") %></strong></div></td>
<%--      <td width="22" ><div><strong><%=db.Row("SELECT SUM(test_semester) AS ROW FROM `teaching_plan_guidance` WHERE course_category_id='"+course_category_id+"' and  class_guidance_id='"+class_id+"';") %></strong></div></td>--%>
<%--      <td width="22" ><div><strong><%=db.Row("SELECT SUM(check_semester) AS ROW FROM `teaching_plan_guidance` WHERE course_category_id='"+course_category_id+"' and  class_guidance_id='"+class_id+"';") %></strong></div></td>--%>
    	 <td width="22" ></td>
    	 <td width="22" ></td>
     <%
    int kkxq2=1;
      for(int j=1;j<=xz*2;j++){  //每年2个学期循环
       %>
      <td width="22" align="center" id=""><div>
      <strong><%=db.Row("SELECT  SUM(start_semester"+""+j+") as row FROM teaching_plan_guidance WHERE course_category_id='"+course_category_id+"' and  class_guidance_id='"+class_id+"' and start_semester"+""+j+" REGEXP '^[0-9]+$';")%></strong>    
      </div></td>
    <%}%>
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
      <td width="30"><div></div></td>
      <td class="delete" colspan="2"><div align="center"></div></td>
    </tr>
     <!-- 加入小计结束 -->   	 
    
      <%        	   
      }if(bgRs1!=null)bgRs1.close(); //一级 %>
   
    <!-- 加入总计开始 -->   
    <tr>
       <td colspan="5" rowspan="1">
        <div align="center"><strong>总计（学时、周学时，不含选修课）</strong></div>
      </td>  
      <td width="30" ><div ><strong><%=db.Row("SELECT SUM(total_classes) AS ROW FROM `teaching_plan_guidance` WHERE class_guidance_id='"+class_id+"' and course_nature_id!=4;") %></strong></div></td>
      <td width="30" ><div ><strong><%=db.Row("SELECT SUM(lecture_classes) AS ROW FROM `teaching_plan_guidance` WHERE class_guidance_id='"+class_id+"' and course_nature_id!=4;") %></strong></div></td>
      <td width="22" ><div><strong><%=db.Row("SELECT SUM(class_in) AS ROW FROM `teaching_plan_guidance` WHERE class_guidance_id='"+class_id+"' and course_nature_id!=4;") %></strong></div></td>
      <td width="22" ><div><strong><%=db.Row("SELECT SUM(extracurricular_practice_hour) AS ROW FROM `teaching_plan_guidance` WHERE class_guidance_id='"+class_id+"' and course_nature_id!=4;") %></strong></div></td>
<%--      <td width="22" ><div><strong><%=db.Row("SELECT SUM(test_semester) AS ROW FROM `teaching_plan_guidance` WHERE class_guidance_id='"+class_id+"' and course_nature_id!=4;") %></strong></div></td>--%>
<%--      <td width="22" ><div><strong><%=db.Row("SELECT SUM(check_semester) AS ROW FROM `teaching_plan_guidance` WHERE class_guidance_id='"+class_id+"' and course_nature_id!=4;") %></strong></div></td>--%>
    	   <td width="22" ></td>
    	   <td width="22" ></td>
     <%
    int kkxq2=1; 
      for(int j=1;j<=xz*2;j++){  //每年2个学期循环
    	 
       %>
      <td width="30" align="center" id=""><div>
      <strong><%=db.Row("SELECT  SUM(start_semester"+""+j+") as row FROM teaching_plan_guidance WHERE class_guidance_id='"+class_id+"' and start_semester"+""+j+" REGEXP '^[0-9]+$' and course_nature_id!=4;")%></strong>    
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
      <td width="30"><div></div></td>
      
      <td class="delete" colspan="2"><div align="center"></div></td>
    </tr>
     <!-- 加入总计结束 -->    
  </tbody>
</table>
           
          </div>
          
        </div>
      </div>

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
		//xlsheet.ActiveSheet.Columns(A:B).ColumnWidth=2;
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
        var id=table;
        var aaa= $("#"+table).html();
        var colspan=$("#"+table+" tbody tr td").eq(0).attr("colspan");
        $("#"+table+" tbody tr td").eq(0).attr("colspan",$("#"+table+" tbody tr td").eq(0).attr("colspan")-2);
        $(".delete").remove();
        // for(i=0;i<$("#"+table+" tbody tr td").size();i++){
      	//   if (i>19) {
        //	   $("#"+table+" tbody tr td").eq(i).html($("#"+table+" tbody tr td").eq(i).html().replace(/(\d+(\-\d+)+)/g, "　$1"));
		// $("#"+table+" tbody tr td").eq(i).html($("#"+table+" tbody tr td").eq(i).html().replace(/(\d\d\d\d\d\d\d)/g, "'$1"));}
		//  }
        
        if (!table.nodeType) table = document.getElementById(table)  
        var ctx = {worksheet: name || 'Worksheet', table: table.innerHTML}  
        console.log(uri + base64(format(template, ctx)) );
        window.location.href = uri + base64(format(template, ctx))  
        //$("#"+id+"").html(aaa);
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
 //刷新整个页面
function shuaxin(){
	 location.reload();
}


function fanhui(){
	 self.location='./guide_audit_list.jsp';
}


 
//执行
function ac_tion() {
       window.location.href="?ac=&val="+$('#search').val()+"";
}
//导出
layui.use('table', function(){
  var table = layui.table;
  
});
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

  </body>
</html>
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