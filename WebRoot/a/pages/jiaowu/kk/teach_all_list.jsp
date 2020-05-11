<%@ page trimDirectiveWhitespaces="true" %>
<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@page import="v1.haocheok.commom.common"%>
<%@page import="service.dao.db.Page"%>
<%@page import="com.sun.rowset.internal.Row"%>
<%@ include file="../../cookie.jsp"%>

<%    
         String class_id=request.getParameter("class_id"); //获取分类id
         String school_year=request.getParameter("school_year"); //获取年份
         String departments_name=request.getParameter("departments_name"); //获取院系名称
         String years = request.getParameter("years");			//获取学期期数
         String sqlw = " AND semester='"+years+"'";
         if(years==null){
        	 sqlw = "";
         }
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
         String start_semester="";
          ResultSet Rs1=db.executeQuery("SELECT start_semester FROM teaching_task_class WHERE id="+class_id+";");  //一级循环
          while(Rs1.next()){start_semester=Rs1.getString("start_semester");}
 		if(regex_num(class_id)==false ){class_id="0";}
        String sql="SELECT p.*,t.* FROM teaching_task as p,teaching_task_class as t WHERE t.teaching_plan_class_id=p.teaching_plan_class_id "+sqlw+" AND p.start_semester!='0' AND LENGTH(p.start_semester)>0 ;";
       
%>
<!DOCTYPE html> 
<html>
  <head>
    <meta charset="utf-8"> 
    <meta name="viewport" content="width=device-width, initial-scale=1"> 
    <title><%=Mokuai%></title>
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
		        <button class="layui-btn layui-btn-small  layui-btn-primary" onclick="history.go(-1)" style="height: 35px;  color: white; background: rgb(25, 160, 148);"> <i class="layui-icon" style="color: #FFF;">&#xe65c;</i> 返回</button>
	
		    	<button class="layui-btn layui-btn-small  layui-btn-primary" onclick="shuaxin()" style="height: 35px;  color: white; background: rgb(25, 160, 148);"> <i class="layui-icon" style="color: #FFF;">ဂ</i> 刷新</button>
		        <button class="layui-btn layui-btn-small  layui-btn-primary " onclick="help(<%=PMenuId %>)" style="height: 35px;  color:#A9A9A9; background: rgb(245, 245, 245);"><i class="layui-icon"></i>帮助</button>
		    </div>
    
<div  style="display:block;clear:both;">

<!-- test --> 
<div id="LAY_preview">
<div>学年学期号：<%=school_year%></div>
<table border="1" width="100%" bordercolorlight="#588FC7" cellspacing="0" cellpadding="0" bordercolor="#19A094"   id="tab1">
  <tbody>
    <tr>
      <td width="22" height="24" ><p align="center">课程 编码</p></td>
      <td width="46" height="24" ><p align="center">课程名称</p></td>
      <td width="65" height="24"><p align="center">课程<br/>性质</td>
      <td width="115" height="24"><p align="center">课程类别</p></td>
      <td width="60" height="24"><p align="center">开课院系</p></td>
      <td height="60" ><p align="center">上课班级</p></td>
      <td width="60" height="24"><p align="center">上课人数</p></td>
      <td width="60" height="24"><p align="center">教学周数</p></td>
      <td height="40"><p align="center">周学时数</p></td>
      <td width="79" height="24"><p align="center">讲课学时</p></td>
      <td width="80" height="34" align="center">实践<br>学时</td>
      <td width="60" height="34" align="center">独立<br/>设置</td>
      <td width="60" height="34" align="center">合班操作</td>
      <td width="60" height="34" align="center">授课教师</td>
      <td width="34" height="24"><p align="center">操作</p></td>
    </tr>
    <% 
    ResultSet bgRs1=null; 
          String course_nature_id="",course_category_id="",course_id="",sysid="";
          bgRs1=db.executeQuery(sql);  //一级循环
          while(bgRs1.next()){    
  %>
    <tr>
      <td width="22" align="center"><%=common.idToFieidName("dict_courses","course_code",bgRs1.getString("course_id"))%></td>      
      <td width="40" align="center"><%=common.idToFieidName("dict_courses","course_name",bgRs1.getString("course_id"))%></td>
      <td width="56" align="center"><%=common.idToFieidName("dict_course_nature","nature",bgRs1.getString("course_nature_id"))%></td>
      <td width="40" align="center"><%=common.idToFieidName("dict_course_category","category",bgRs1.getString("course_category_id"))%></td>
      <td width="40" align="center"><%=common.idToFieidName("dict_departments","departments_name",bgRs1.getString("course_category_id"))%></td>
      <td width="40" align="center"><%=common.idToFieidName("class_grade","class_name",bgRs1.getString("class_grade_id"))%></td>
      <td width="40" align="center"><%=common.idToFieidName("class_grade","people_number_nan",bgRs1.getString("class_grade_id"))%></td>
      <td width="40" align="center"><%=bgRs1.getString("classes_weekly")%></td>
      <td width="40" align="center"><%=bgRs1.getString("start_semester")%></td>
      <td width="40" align="center"><%=bgRs1.getString("lecture_classes")%></td>
      <td width="95" align="center"><%=bgRs1.getString("class_in")%></td>
      <td width="79" align="center"><%=bgRs1.getString("extracurricular_practice_hour")%></td>
      <td width="34" align="center"><a href="http://www.baidu.com" ><font color="#EEB4B4" >跳转</font></a></td>
      <td width="34" align="center"><%=common.idToFieidName("teacher_basic","teacher_name",bgRs1.getString("teacher_id"))%></td>
      <td width="34" ><div  style="margin:5px" align="center"><button class="layui-btn" onclick="setupTeacher('<%=bgRs1.getString("p.id") %>','<%=school_year %>')">教师设置</button></div></td>
    </tr>
  <%} %>
  </tbody>
</table>
           
          </div>
          
        </div>
      </div>

<script> 
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

//设置教师页面
function setupTeacher(id,school_year){
	layer.open({
		  type: 2,
		  title: '设置教师',
		  offset: 't',//靠上打开
		  shadeClose: true,
		  maxmin:1,
		  shade: 0.5,
		  area: ['100%', '100%'],
		  content: 'teach_shezhi.jsp?id='+id+'&school_year='+school_year
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