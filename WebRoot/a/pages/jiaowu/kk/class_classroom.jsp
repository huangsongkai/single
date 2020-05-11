<%@ page trimDirectiveWhitespaces="true" %>
<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@page import="v1.haocheok.commom.common"%>
<%@page import="service.dao.db.Page"%>
<%@page import="com.sun.rowset.internal.Row"%>
<%@ include file="../../cookie.jsp"%>

<%    
//获取文件后面的对象 数据
	String search_val = request.getParameter("val"); if(search_val==null){search_val="";}else{search_val=search_val.replaceAll("\\s*", "");}
	search_val = new Page().mysqlCode(search_val);//防止sql注入
search_val=search_val.toUpperCase();
search_val=search_val.replaceAll(" ","");


//筛选信息查询
String sqlwhere = "";		//拼凑where 条件的sql语句



String bianhao = request.getParameter("bianhao");
if(bianhao==null || "0".equals(bianhao)){bianhao="";}
else{
	if("".equals(bianhao)){
		sqlwhere +="";
	}else{
		sqlwhere += "	AND	class_grade.class_number='"+bianhao+"'	";
	}
	}

String xueqi = request.getParameter("xueqi");
if(xueqi==null || "0".equals(xueqi)){xueqi="";
		String xueqi_sql = "select academic_year,this_academic_tag from  academic_year";
		ResultSet xueqi_set = db.executeQuery(xueqi_sql);
		while(xueqi_set.next()){
			if(xueqi_set.getString("this_academic_tag").equals("true")){
				xueqi = xueqi_set.getString("academic_year");
				sqlwhere +="	AND arrage_coursesystem.semester = '"+xueqi_set.getString("academic_year")+"'";
			}
		}if(xueqi_set!=null){xueqi_set.close();}
}else{
	sqlwhere +="	AND arrage_coursesystem.semester = '"+xueqi+"'";
	
}

String dict_departments_id = request.getParameter("dict_departments_id");
if(dict_departments_id==null || "0".equals(dict_departments_id)){dict_departments_id="";}else{sqlwhere +="		AND class_grade.departments_id = '"+dict_departments_id+"' ";}

String jiaoshimingcheng = request.getParameter("jiaoshimingcheng");
if(jiaoshimingcheng==null || "0".equals(jiaoshimingcheng)){jiaoshimingcheng="";}
else{
	if("".equals(jiaoshimingcheng)){
		sqlwhere +="";
	}else{
		sqlwhere += "		AND class_grade.class_name='"+jiaoshimingcheng+"'";
	}
	
	
}

String zhuanye = request.getParameter("zhuanye");
if(zhuanye==null || "0".equals(zhuanye)){zhuanye="";}else{sqlwhere +="	AND major.id = '"+zhuanye+"'";}

String fenxiao = request.getParameter("fenxiao");
if(fenxiao==null || "0".equals(fenxiao)){fenxiao="";}else{sqlwhere +="	AND teaching_building.dict_campus_id = '"+fenxiao+"'";}

common common=new common();
		
       

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
			<select name="xueqi" id="xueqi">
				<option value="0">请选择学期号</option>
				<%
					String xueqi_sql = "select academic_year from academic_year";
					ResultSet xueqi_set = db.executeQuery(xueqi_sql);
					while(xueqi_set.next()){
				%>
					<option value="<%=xueqi_set.getString("academic_year") %>" <%if(xueqi.equals(xueqi_set.getString("academic_year"))){out.println("selected='selected'");} %>><%=xueqi_set.getString("academic_year") %></option>
				<%}if(xueqi_set!=null){xueqi_set.close();} %>
			</select>

            <select name="zhuanye" id="zhuanye">
				<option value="0">请选择专业</option>
				<%
					String zhuanye_sql = "select id,major_name from major";
					ResultSet zhuanye_set = db.executeQuery(zhuanye_sql);
					while(zhuanye_set.next()){
				%>
					<option value="<%=zhuanye_set.getString("id") %>" <%if(zhuanye.equals(zhuanye_set.getString("id"))){out.println("selected='selected'");} %>><%=zhuanye_set.getString("major_name") %></option>
				<%}if(zhuanye_set!=null){zhuanye_set.close();} %>
			</select>
			<select name="dict_departments_id" id="dict_departments_id" >
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
			<select name="fenxiao" id="fenxiao">
				<option value="0">请选择分校</option>
				<%
					String fenxiao_sql = "select id,campus_name from dict_campus";
					ResultSet fenxiao_set = db.executeQuery(fenxiao_sql);
					while(fenxiao_set.next()){
				%>
					<option value="<%=fenxiao_set.getString("id") %>" <%if(fenxiao.equals(fenxiao_set.getString("id"))){} %>><%=fenxiao_set.getString("campus_name") %></option>
				<%}if(fenxiao_set!=null){fenxiao_set.close();} %>
			</select>
			
			班级编号:<input name="bianhao" id="bianhao"  value="<%=bianhao %>" />
			班级名称:<input name="jiaoshimingcheng" id="jiaoshimingcheng"  value="<%=jiaoshimingcheng %>" />
	<button class="layui-btn layui-btn-small  layui-btn-primary" onclick="fanhui()" style="height: 35px;  color: white; background: rgb(25, 160, 148);"> <i class="layui-icon" style="color: #FFF;">&#xe65c;</i> 返回</button>
	<button class="layui-btn layui-btn-small  layui-btn-primary" onclick="ac_tion('')"  style="height: 35px;  color: white; background: rgb(25, 160, 148);"> <i class="layui-icon" style="color: #FFF;">&#xe615;</i> 搜索</button>
	<button class="layui-btn layui-btn-small  layui-btn-primary" onclick="shuaxin()" style="height: 35px;  color: white; background: rgb(25, 160, 148);"> <i class="layui-icon" style="color: #FFF;">ဂ</i> 刷新</button>
</div>

<!-- test --> 
<div id="LAY_preview">
<table border="1" width="100%" bordercolorlight="#588FC7" cellspacing="0" cellpadding="0" bordercolor="#19A094"   id="tab1">
  <tbody>
    <tr>
      <td width="22" height="24" ><p align="center">班级编号</p></td>
      <td width="22" height="24" ><p align="center">班级名称</p></td>
      <td width="22" height="24" ><p align="center">班级人数</p></td>
      <td width="22" height="24" ><p align="center">专业</p></td>
      <td width="22" height="24" ><p align="center">院系</p></td>
      <td width="22" height="24" ><p align="center">使用教室</p></td>
    </tr>
    <% 
    String sql = "SELECT																								"+
	   " 	  class_grade.class_number AS class_number,                                                                 "+
	   " 	  class_grade.class_name   AS class_name,                                                                   "+
	   " 	  (IFNULL(class_grade.people_number_nan,0)+IFNULL(class_grade.people_number_woman,0)) AS num,               "+
	   " 	  major_name,                                                                                               "+
	   " 	  departments_name,                                                                                         "+
	   " 	  IFNULL(GROUP_CONCAT(DISTINCT classroomname),'') AS rrr                                                    "+
	   " 	FROM class_grade                                                                                            "+
	   " 	  LEFT JOIN arrage_details                                                                             "+
	   " 	    ON class_grade.id = arrage_details.classid                                                        "+
	   "	LEFT JOIN arrage_coursesystem ON arrage_coursesystem.id = arrage_details.arrage_coursesystem_id			"+
	   " 	  LEFT JOIN classroom                                                                                       "+
	   " 	    ON arrage_details.classroomid = classroom.id                                                       "+
	   " 	  LEFT JOIN dict_departments                                                                                "+
	   " 	    ON class_grade.departments_id = dict_departments.id                                                     "+
	   " 	  LEFT JOIN major                                                                                           "+
	   " 	    ON class_grade.majors_id = major.id                                                                     "+
	   "	where 1=1 "+sqlwhere+"	"+
	   " 	GROUP BY class_grade.id";                                                                                   
    
    System.out.println("条件sql===="+sql);
    	ResultSet bgRs1=null; 
          String course_nature_id="",course_category_id="",course_id="",sysid="";
          bgRs1=db.executeQuery(sql);  //一级循环
          while(bgRs1.next()){    
  %>
    <tr>
    	<td width="40" align="center"><%=bgRs1.getString("class_number") %></td>
    	<td width="40" align="center"><%=bgRs1.getString("class_name") %></td>
    	<td width="40" align="center"><%=bgRs1.getString("num") %></td>
    	<td width="40" align="center"><%=bgRs1.getString("major_name") %></td>
    	<td width="40" align="center"><%=bgRs1.getString("departments_name") %></td>
    	<td width="40" align="center"><%=bgRs1.getString("rrr") %></td>
    </tr>
  <%}if(bgRs1!=null){bgRs1.close();} %>
  </tbody>
</table>
          </div>
          
        </div>
      </div>

<script>

//返回
function fanhui(){
	window.location.replace('./school_sum.jsp');
}

function zhuanchu(){
	if(!confirm("确定要转出到开课通知单吗？")){
        return ;
    }
	var cks=document.getElementsByName("check");
	var str= new Array();
	for(var i =0 ; i < cks.length;i++){
		if(cks[i].checked){
            str.push(cks[i].value);
        }
	}
	if(str.length>0){
		str = str.join();
		var url = "?ac=daochu&id="+str;
		window.location.href=url;
	}else{
		layer.msg("必须选择一个");
	}
	
}
function ckAll(){
    var flag=document.getElementById("allChecks").checked;
    var cks=document.getElementsByName("check");
    for(var i=0;i<cks.length;i++){
        cks[i].checked=flag;
    }
}




//明细
function mingxi(id,school_year){
	layer.open({
		  type: 2,
		  title: '设置教师',
		  offset: 't',//靠上打开
		  shadeClose: true,
		  maxmin:1,
		  shade: 0.5,
		  area: ['100%', '100%'],
		  content: 'teach_shezhi.jsp?id='+id+'&school_year='+school_year+"&state=0"
	});

}




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
	$("#keyword").val("");
} 
 //刷新整个页面
function shuaxin(){
	 //location.reload();
	window.location.href="?ac=";
}

//删除课程

function deleteCourse(id){
	layer.confirm("确认要删除吗，删除后不能恢复", { title: "删除确认" }, function (index) { 
        layer.close(index);
        window.location.href="?ac=deletet&delid="+id+"";   						 
       
    }); 
}

//执行
function ac_tion() {
	var xueqi = $("#xueqi").val();
	var jiaoshimingcheng = $("#jiaoshimingcheng").val();
	var bianhao = $("#bianhao").val();
	var dict_departments_id = $("#dict_departments_id").val();
	var zhuanye = $("#zhuanye").val();
	var fenxiao = $("#fenxiao").val();
	
	window.location.href="?ac=&xueqi="+xueqi+"&jiaoshimingcheng="+jiaoshimingcheng+"&bianhao="+bianhao+"&dict_departments_id="+dict_departments_id+"&zhuanye="+zhuanye+"&fenxiao="+fenxiao+"";
}
//导出
layui.use('table', function(){
  var table = layui.table;
  
});

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