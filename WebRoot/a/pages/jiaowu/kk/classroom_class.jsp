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
		sqlwhere += "	AND	classroom.classroom_number='"+bianhao+"'	";
	}
	}

String xueqi = request.getParameter("xueqi");
if(xueqi==null || "0".equals(xueqi)){xueqi="";}else{sqlwhere +="	AND arrage_coursesystem.semester = '"+xueqi+"'";}

String jiaoxuequ = request.getParameter("jiaoxuequ");
if(jiaoxuequ==null || "0".equals(jiaoxuequ)){jiaoxuequ="";}else{sqlwhere +="		AND teaching_area.id = '"+jiaoxuequ+"' ";}

String jiaoshimingcheng = request.getParameter("jiaoshimingcheng");
if(jiaoshimingcheng==null || "0".equals(jiaoshimingcheng)){jiaoshimingcheng="";}
else{
	if("".equals(jiaoshimingcheng)){
		sqlwhere +="";
	}else{
		sqlwhere += "		AND classroom.classroomname='"+jiaoshimingcheng+"'";
	}
	
	
}

String jiaoxueluo = request.getParameter("jiaoxueluo");
if(jiaoxueluo==null || "0".equals(jiaoxueluo)){jiaoxueluo="";}else{sqlwhere +="	AND teaching_building.id = '"+jiaoxueluo+"'";}

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
					String xueqi_sql = "select academic_year,this_academic_tag from academic_year";
					ResultSet xueqi_set = db.executeQuery(xueqi_sql);
					while(xueqi_set.next()){
				%>
					<option value="<%=xueqi_set.getString("academic_year") %>" <%if(xueqi.equals(xueqi_set.getString("academic_year"))){out.println("selected='selected'");}else if("true".equals(xueqi_set.getString("this_academic_tag"))){out.println("selected='selected'");sqlwhere +="	AND arrage_coursesystem.semester = '"+xueqi_set.getString("academic_year")+"'";} %>><%=xueqi_set.getString("academic_year") %></option>
				<%}if(xueqi_set!=null){xueqi_set.close();} %>
			</select>

            <select name="jiaoxueluo" id="jiaoxueluo" >
              <option value="0">教学楼</option>
              <%
              		String teaching_building_sql = "select id,building_name from teaching_building";
              		ResultSet teaching_building_set = db.executeQuery(teaching_building_sql);
              		while(teaching_building_set.next()){
              %>
              	<option value="<%=teaching_building_set.getString("id") %>" <%if(jiaoxueluo.equals(teaching_building_set.getString("id"))){out.println("selected='selected'");} %> ><%=teaching_building_set.getString("building_name") %></option>
              <%}if(teaching_building_set!=null){teaching_building_set.close();} %>
            </select>
			<select name="jiaoxuequ" id="jiaoxuequ">
				<option value="0">教学区</option>
				<%
					String dict_campus_sql = "select id,campus_name from dict_campus";
					ResultSet diec_campus_set = db.executeQuery(dict_campus_sql);
					while(diec_campus_set.next()){				
				%>
					<option value="<%=diec_campus_set.getString("id") %>" <%if(jiaoxuequ.equals(diec_campus_set.getString("id"))){out.println("selected='selected'");} %>><%=diec_campus_set.getString("campus_name") %></option>
				<%}if(diec_campus_set!=null){diec_campus_set.close();} %>
				
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
			
			教室编号:<input name="bianhao" id="bianhao"  value="<%=bianhao %>" />
			教室名称:<input name="jiaoshimingcheng" id="jiaoshimingcheng"  value="<%=jiaoshimingcheng %>" />
	<button class="layui-btn layui-btn-small  layui-btn-primary" onclick="fanhui()" style="height: 35px;  color: white; background: rgb(25, 160, 148);"> <i class="layui-icon" style="color: #FFF;">&#xe65c;</i> 返回</button>
	<button class="layui-btn layui-btn-small  layui-btn-primary" onclick="ac_tion('')"  style="height: 35px;  color: white; background: rgb(25, 160, 148);"> <i class="layui-icon" style="color: #FFF;">&#xe615;</i> 搜索</button>
	<button class="layui-btn layui-btn-small  layui-btn-primary" onclick="shuaxin()" style="height: 35px;  color: white; background: rgb(25, 160, 148);"> <i class="layui-icon" style="color: #FFF;">ဂ</i> 刷新</button>
</div>

<!-- test --> 
<div id="LAY_preview">
<table border="1" width="100%" bordercolorlight="#588FC7" cellspacing="0" cellpadding="0" bordercolor="#19A094"   id="tab1">
  <tbody>
    <tr>
      <td width="22" height="24" ><p align="center">教室编号</p></td>
      <td width="22" height="24" ><p align="center">教室名称</p></td>
      <td width="22" height="24" ><p align="center">教学功能区</p></td>
      <td width="22" height="24" ><p align="center">教学楼名称</p></td>
      <td width="22" height="24" ><p align="center">容纳人数</p></td>
      <td width="22" height="24" ><p align="center">上课班级</p></td>
    </tr>
    <% 
    String sql = "SELECT														"+
    "		classroom.id as id,	"+
    " 	  classroom_number,                                             "+
    " 	  classroomname,                                                "+
    " 	  teaching_area_name,                                           "+
    " 	  building_name,                                                "+
    " 	  goclass_number,                                                "+
    "		 IFNULL(GROUP_CONCAT(DISTINCT class_name),'') AS rrr				"+
    " 	FROM classroom                                                  "+
    " 	  LEFT JOIN teaching_area                                       "+
    " 	    ON teaching_area.id = classroom.teaching_area_id            "+
    " 	  LEFT JOIN teaching_building                                   "+
    " 	    ON teaching_building.id = classroom.building_id"+
    "	LEFT JOIN arrage_details ON classroom.id = arrage_details.classroomid		"+
    "	LEFT JOIN arrage_coursesystem ON arrage_coursesystem.id = arrage_details.arrage_coursesystem_id"+
    "	LEFT JOIN class_grade ON arrage_coursesystem.class_id = class_grade.id			"+
    "	where	1=1 "+sqlwhere+"	GROUP BY classroom.id";
    
    System.out.println("条件sql===="+sql);
    	ResultSet bgRs1=null; 
          String course_nature_id="",course_category_id="",course_id="",sysid="";
          bgRs1=db.executeQuery(sql);  //一级循环
          while(bgRs1.next()){    
  %>
    <tr>
    	<td width="40" align="center"><%=bgRs1.getString("classroom_number") %></td>
    	<td width="40" align="center"><%=bgRs1.getString("classroomname") %></td>
    	<td width="40" align="center"><%=bgRs1.getString("teaching_area_name") %></td>
    	<td width="40" align="center"><%=bgRs1.getString("building_name") %></td>
    	<td width="40" align="center"><%=bgRs1.getString("goclass_number") %></td>
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
	var jiaoxuequ = $("#jiaoxuequ").val();
	var jiaoxueluo = $("#jiaoxueluo").val();
	var fenxiao = $("#fenxiao").val();
	
	window.location.href="?ac=&xueqi="+xueqi+"&jiaoshimingcheng="+jiaoshimingcheng+"&bianhao="+bianhao+"&jiaoxuequ="+jiaoxuequ+"&jiaoxueluo="+jiaoxueluo+"&fenxiao="+fenxiao+"";
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