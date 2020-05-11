<%@ page trimDirectiveWhitespaces="true" %>
<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@page import="v1.haocheok.commom.common"%>
<%@page import="service.dao.db.Page"%>
<%@page import="org.apache.commons.lang3.StringUtils"%>
<%@page import="com.sun.rowset.internal.Row"%>
<%@ include file="../../cookie.jsp"%>
<%
	String xueqi = request.getParameter("xueqi");
	if(StringUtils.isBlank(xueqi)||"0".equals(xueqi)){
		String semSql = "SELECT academic_year from academic_year where this_academic_tag='true' ";
		ResultSet semRs = db.executeQuery(semSql);
		while(semRs.next()){
			xueqi=semRs.getString("academic_year");
		}
		if(semRs!=null)semRs.close();
	}
//获取文件后面的对象 数据
  	String search_val = request.getParameter("val"); if(search_val==null){search_val="";}else{search_val=search_val.replaceAll("\\s*", "");}
  	search_val = new Page().mysqlCode(search_val);//防止sql注入
	search_val=search_val.toUpperCase();
	search_val=search_val.replaceAll(" ","");
	
	
	//筛选信息查询
	String sqlwhere = "";		//拼凑where 条件的sql语句
	
	sqlwhere +="	AND teaching_task.semester = '"+xueqi+"'";
	
	String search = request.getParameter("search");
	if(search==null || "0".equals(search)){search="";}else{sqlwhere += "	AND 	teacher_basic.id = '"+search+"'		";}
	
	
	
 common common=new common();
 String  sql1 = "SELECT																			"+
		"		  teaching_task.id,                                                             "+
		"		  teaching_task.class_id,                                                       "+
		"		  teaching_task.course_id,                                                      "+
		"		  teaching_task.course_nature_id,                                               "+
		"		  teaching_task.start_semester,                                                        "+
		"		  teaching_task_teacher.teacherid AS teacher_id,                                "+
		"		  marge_class.marge_name,                                                       "+
		"		  marge_class.id                  AS margeid,                                   "+
		"		  teacher_basic.technical_title ,                                               "+
		"			IFNULL(marge_class.class_grade_number,(class_grade.people_number_nan+class_grade.people_number_woman)) AS totle	"+
		"		FROM teaching_task                                                              "+
		"		  LEFT JOIN marge_class                                                         "+
		"		    ON teaching_task.marge_class_id = marge_class.id                            "+
		"		  LEFT JOIN teaching_task_teacher                                               "+
		"		    ON teaching_task.parent_id = teaching_task_teacher.teaching_task_id         "+
		"		  LEFT JOIN teacher_basic                                                       "+
		"		    ON teacher_basic.id = teaching_task_teacher.teacherid                       "+
		"			LEFT JOIN class_grade ON class_grade.id = teaching_task.class_id			"+
		"		WHERE teaching_task.is_merge_class != 1                                         "+
		"		    AND typestate = 2          "+sqlwhere+"                                                 "+
		"		    AND marge_state = 0";                                                                  
System.out.println("教学计划安排表====="+sql1);

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
.table-title{height: 47px;background: #C4C4C4; text-align: left;line-height: 47px;font-size: 16px;font-weight: inherit;padding-left: 30px;}
.table-title span{margin-left:20px;}
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
    <div id="tb" class="form_top layui-form" style="display: flex;width:1200px;">
    		
    		<select id="search" name="search"  lay-search>
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
    
			<select name="xueqi" id="xueqi" lay-search>
				<option value="0">请选择学期号</option>
				<%
					String xueqi_sql = "select academic_year from academic_year";
					ResultSet xueqi_set = db.executeQuery(xueqi_sql);
					while(xueqi_set.next()){
				%>
					<option value="<%=xueqi_set.getString("academic_year") %>" <%if(xueqi.equals(xueqi_set.getString("academic_year"))){out.println("selected='selected'");} %>><%=xueqi_set.getString("academic_year") %></option>
				<%}if(xueqi_set!=null){xueqi_set.close();} %>
			</select>
	<button class="layui-btn layui-btn-small  layui-btn-primary" onclick="ac_tion()"  style="height: 35px;  color: white; background: rgb(25, 160, 148);margin-left:10px;"> <i class="layui-icon" style="color: #FFF;">&#xe615;</i> 搜索</button>
	<button class="layui-btn layui-btn-small  layui-btn-primary" onclick="shuaxin()" style="height: 35px;  color: white; background: rgb(25, 160, 148);"> <i class="layui-icon" style="color: #FFF;">ဂ</i> 刷新</button>
</div>
    
    
    
    
    
<div  style="display:block;clear:both;">

<!-- test --> 
<div id="LAY_preview">
<table border="1" width="100%" bordercolorlight="#588FC7" cellspacing="0" cellpadding="0" bordercolor="#19A094"   id="tab1" style="margin-top: 20px;">
  <tbody>
  	<tr>
      <td colspan="9" height="24" ><p class="table-title">任课教师表<span>[学年学期号<%=xueqi %>]</span></p></td>   
    </tr>
  	<tr>
  	  <td height="24" align="center">选择</td>
  	  <td height="24" align="center">学期</td>
      <td  height="24" ><p align="center">课程</p></td>
      <td  height="34" align="center">性质</td>
      <td  height="34" align="center">周学时</td>
      <td  height="24"><p align="center">教师</td>
      <td  height="24"><p align="center">职称</p></td>
      <td height="24"><p align="center">上课班级</p></td>
      <td height="60" ><p align="center">学生数</p></td>
    </tr>
    <%
    	ResultSet teacherListSet = db.executeQuery(sql1);
    	while(teacherListSet.next()){
    %>
    <tr>
      <td align="center" height="50"><input type="checkbox" style="width:20px;height:20px" /> </td>
      <td align="left"><%=xueqi%></td>
      <td align="left"><%=common.idToFieidName("dict_courses","course_name",teacherListSet.getString("course_id")) %></td>
      <td align="center"><%=common.idToFieidName("dict_course_nature","nature",teacherListSet.getString("course_nature_id")) %></td>
      <td align="center"><%=teacherListSet.getString("start_semester") %></td>
      <td align="center"><%=common.idToFieidName("teacher_basic","teacher_name",teacherListSet.getString("teacher_id")) %></td>
      <td align="center"><%=common.idToFieidName("teacher_title","teacher_title_name",teacherListSet.getString("technical_title")==null?"0":teacherListSet.getString("technical_title")) %></td>
      <td align="left"><%if(teacherListSet.getString("marge_name")==null){out.println(common.idToFieidName("class_grade","class_name",teacherListSet.getString("class_id"))+"["+teacherListSet.getString("totle") +"]");}else{out.println(teacherListSet.getString("marge_name"));} %></td>
      <td align="center"><%=teacherListSet.getString("totle") %></td>
    </tr>
    
    <%}if(teacherListSet!=null){teacherListSet.close();} %>
    
    
  </tbody>
</table>
           
          </div>
          
        </div>
      </div>

<script> 
/**
 * 搜索内容
 */
var xueqi='<%=xueqi%>';
var search='<%=search%>';

if(xueqi.length>=1){
	modify('xueqi',xueqi);
}
if(search.length>=1){
	modify('search',search);
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
	 //location.reload();
	window.location.href="?ac=";
}

//执行
function ac_tion() {
	var xueqi = $("#xueqi").val();
	var search =$("#search").val();
	window.location.href="?ac=&xueqi="+xueqi+"&search="+search+"";
}

//合并 id,teaching_task_detailed_id(教学计划详情id) marge_id (合班id)
function hebing(id,teaching_task_detailed_id,marge_id){
	if(teaching_task_detailed_id==null || teaching_task_detailed_id=="0" || teaching_task_detailed_id==""){
			alert("请先设定教师");
			return;
	}
	 layer.open({
		  type: 2,
		  title: '合并班级',
		  offset: 't',//靠上打开
		  shadeClose: true,
		  maxmin:1,
		  shade: 0.5,
		  area: ['100%', '100%'],
		  content: 'xbj.jsp?id='+id+'&teaching_task_detailed_id='+teaching_task_detailed_id+'&marge_id='+marge_id
	});
	
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
		  content: 'teach_shezhi.jsp?id='+id+'&school_year='+school_year+"&state=1"
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