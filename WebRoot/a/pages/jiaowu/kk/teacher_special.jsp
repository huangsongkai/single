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


String laoshi = request.getParameter("laoshi");
if(laoshi==null || "0".equals(laoshi)){laoshi="";}else{sqlwhere += "	AND	arrage_teacher_special.teacherid='"+laoshi+"'	";}

String xueqi = request.getParameter("xueqi");
if(xueqi==null || "0".equals(xueqi)){
	
	String xueqi_sql = "select academic_year,this_academic_tag from  academic_year";
	ResultSet xueqi_set = db.executeQuery(xueqi_sql);
	while(xueqi_set.next()){
		if(xueqi_set.getString("this_academic_tag").equals("true")){
			xueqi = xueqi_set.getString("academic_year");
			sqlwhere +="	AND arrage_teacher_special.semester = '"+xueqi_set.getString("academic_year")+"'";
		}
	}if(xueqi_set!=null){xueqi_set.close();}
	
	
}else{
	
	sqlwhere +="	AND arrage_teacher_special.semester = '"+xueqi+"'";
	
}

String jiaoyanshi = request.getParameter("jiaoyanshi");
if(jiaoyanshi==null || "0".equals(jiaoyanshi)){jiaoyanshi="";}else{sqlwhere +="		AND teaching_research.id = '"+jiaoyanshi+"' ";}

String dict_departments_id = request.getParameter("dict_departments_id");
if(dict_departments_id==null || "0".equals(dict_departments_id)){dict_departments_id="";}else{sqlwhere +="	AND dict_departments.id = '"+dict_departments_id+"'";}


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

            <select name="dict_departments_id" id="dict_departments_id" >
              <option value="0">全部院系</option>
            <%
            //查询院系
            String selectDsql="select * from dict_departments";
            ResultSet yxRs = db.executeQuery(selectDsql);
            while(yxRs.next()){
            %>
              <option value="<%=yxRs.getString("id") %>"  <%if(yxRs.getString("id").equals(dict_departments_id)){out.print("selected=\"selected\"");} %>><%=yxRs.getString("departments_name") %></option>
             <%}if(yxRs!=null){yxRs.close();} %>
            </select>
			<select name="jiaoyanshi" id="jiaoyanshi">
				<option value="0">请选择教研室</option>
			<% 
				//教研室
				String jiaoyan_sql = "select id,teaching_research_name from teaching_research";
				ResultSet jiaoyan_set = db.executeQuery(jiaoyan_sql);
				while(jiaoyan_set.next()){
			%>
				<option value="<%=jiaoyan_set.getString("id") %>" <%if(jiaoyanshi.equals(jiaoyan_set.getString("id"))){out.print("selected=\"selected\"");} %>><%=jiaoyan_set.getString("teaching_research_name") %></option>
			<%}if(jiaoyan_set!=null){jiaoyan_set.close();} %>			
			</select>  
			<select name="laoshi" id="laoshi">
				<option value="0">请选择老师</option>
				<%
					String laoshi_sql = "select id,teacher_name from teacher_basic";
					ResultSet laoshi_set = db.executeQuery(laoshi_sql);
					while(laoshi_set.next()){
				%>
					<option value="<%=laoshi_set.getString("id") %>" <%if(laoshi.equals(laoshi_set.getString("id"))){out.print("selected=\"selected\"");} %>><%=laoshi_set.getString("teacher_name") %></option>
				<%}if(laoshi_set!=null){laoshi_set.close();} %>
			</select>  
	<button class="layui-btn layui-btn-small  layui-btn-primary" onclick="ac_tion('')"  style="height: 35px;  color: white; background: rgb(25, 160, 148);"> <i class="layui-icon" style="color: #FFF;">&#xe615;</i> 搜索</button>
	<button class="layui-btn layui-btn-small  layui-btn-primary" onclick="shuaxin()" style="height: 35px;  color: white; background: rgb(25, 160, 148);"> <i class="layui-icon" style="color: #FFF;">ဂ</i> 刷新</button>
	<button class="layui-btn layui-btn-small  layui-btn-primary" onclick="add()"  style="height: 35px;  color: white; background: rgb(25, 160, 148);"> <i class="layui-icon" style="color: #FFF;">&#xe61f;</i> 增加</button>

</div>

<!-- test --> 
<div id="LAY_preview">
<table border="1" width="100%" bordercolorlight="#588FC7" cellspacing="0" cellpadding="0" bordercolor="#19A094"   id="tab1">
  <tbody>
    <tr>
      <td  width="46" height="24" align="center"> 审核 </td>
      <td width="22" height="24" ><p align="center">教师</p></td>
      <td width="46" height="24" ><p align="center">院系</p></td>
      <td width="65" height="24"><p align="center">教研室</td>
      <td width="115" height="24"><p align="center">职称</p></td>
      <td width="60" height="24"><p align="center">排课特殊需求</p></td>
      <td width="115" height="24"><p align="center">状态</p></td>
      <td width="34" height="24"><p align="center">操作</p></td>
    </tr>
    <% 
	    String sql = "SELECT																"+
	    "   	  *,                                                                    "+
	    "   	  dict_departments.departments_name AS departments_name,                "+
	    "   	  teacher_title.teacher_title_name  AS teacher_title_name               "+
	    "   	FROM arrage_teacher_special                                             "+
	    "   	  LEFT JOIN teacher_basic                                               "+
	    "   	    ON arrage_teacher_special.teacherid = teacher_basic.id              "+
	    "   	  LEFT JOIN dict_departments                                            "+
	    "   	    ON dict_departments.id = teacher_basic.faculty                      "+
	    "   	  LEFT JOIN teacher_title                                               "+
	    "   	    ON teacher_basic.technical_title = teacher_title.id                 "+
	    "   	  LEFT JOIN teaching_research                                           "+
	    "   	    ON teaching_research.id = teacher_basic.teachering_office           "+
	    "			where 1=1		"+sqlwhere+"					"+
	    "   	GROUP BY teacherid";
    
    
   		ResultSet bgRs1=null; 
        String course_nature_id="",course_category_id="",course_id="",sysid="";
        bgRs1=db.executeQuery(sql);  //一级循环
        while(bgRs1.next()){    
  %>
    <tr>
      <td width="40" align="center"><input type="checkbox" name="check"  value="<%=bgRs1.getString("arrage_teacher_special.teacherid") %>" /> </td>
      <td width="22" align="center"><%=bgRs1.getString("teacher_basic.teacher_name") %></td>  
      <td width="22" align="center"><%=bgRs1.getString("departments_name") %></td> 
      <td width="22" align="center"><%=bgRs1.getString("teaching_research.teaching_research_name") %></td> 
      <td width="22" align="center"><%=bgRs1.getString("teacher_title_name") %></td> 
      <td width="22" align="center"><%=bgRs1.getString("arrage_teacher_special.remarks") %></td> 
      <td width="22" align="center"><%if("0".equals(bgRs1.getString("arrage_teacher_special.applystate"))){out.println("审批中");}else if("1".equals(bgRs1.getString("arrage_teacher_special.applystate"))){out.println("不通过");}else if("2".equals(bgRs1.getString("arrage_teacher_special.applystate"))){out.println("通过");} %></td>
      <td width="34" >
      	<div  style="margin:5px" align="center">
      		<button class="layui-btn" onclick="xiugai('<%=bgRs1.getString("arrage_teacher_special.teacherid") %>','<%=bgRs1.getString("arrage_teacher_special.semester") %>')">修改</button>
      		<button class="layui-btn" onclick="deleteCourse('<%=bgRs1.getString("arrage_teacher_special.teacherid") %>')">删除</button>
      	</div>
      </td>
    </tr>
  <%}if(bgRs1!=null){bgRs1.close();} %>
  <tr>
	  <td colspan="18">
	  	<input type="button" onclick="shenhe()" value="审核" id="my_btn" style="padding: 7px 20px;margin: 8px;">
	    <select name="my_select" id="shenhe" style="width: 87px;height: 36px;">
	      <option value="2">通过</option>
	      <option value="1">不通过</option>
	    </select>
	  </td>
  </tr>
  </tbody>
</table>
          </div>
          
        </div>
      </div>

<script>
//删除课程

function deleteCourse(id){
	layer.confirm("确认要删除吗，删除后不能恢复", { title: "删除确认" }, function (index) { 
        layer.close(index);
        var xueqi_new = $("#xueqi").val();
        window.location.href="?ac=deletet&delid="+id+"&xueqi_new="+xueqi_new+"";   						 
       
    }); 
}

//审核
function shenhe(){
	if(!confirm("确定要审核吗？")){
        return ;
    }
	var xueqi = $("#xueqi").val();
    
	var cks=document.getElementsByName("check");
	var str= new Array();
	for(var i =0 ; i < cks.length;i++){
		if(cks[i].checked){
            str.push(cks[i].value);
        }
	}
	if(str.length>0){
		if(str.length>1){
			layer.msg("只能选择一个");
			return;
		}
		var shenhestate = $("#shenhe").val();
		str = str.join();
		var url = "?ac=shenhe&teacherid="+str+"&shenhestate="+shenhestate+"&xueqi="+xueqi;
		window.location.href=url;
	}else{
		layer.msg("必须选择一个");
		return ;
	}
	
}



function add(){
	var xueqi = $("#xueqi").val();
	if(xueqi==null || xueqi==0 || xueqi==""){

		layer.msg("请选择学期!");
		return;
	}
	
	layer.open({
		  type: 2,
		  title: '设置教师特殊需求',
		  offset: 't',//靠上打开
		  shadeClose: true,
		  maxmin:1,
		  shade: 0.5,
		  area: ['100%', '100%'],
		  content: 'new_teacher_special.jsp?semester='+xueqi
	});
	
}




//明细
function xiugai(teacherid,school_year){
	layer.open({
		  type: 2,
		  title: '设置教师',
		  offset: 't',//靠上打开
		  shadeClose: true,
		  maxmin:1,
		  shade: 0.5,
		  area: ['100%', '100%'],
		  content: 'new_teacher_special.jsp?teacherid='+teacherid+'&semester='+school_year
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



//执行
function ac_tion() {
	var xueqi = $("#xueqi").val();
	var banji = $("#banji").val();
	var zhuanye = $("#zhuanye").val();
	var laoshi = $("#laoshi").val();
	var jiaoyanshi = $("#jiaoyanshi").val();
	var dict_departments_id = $("#dict_departments_id").val();
	
	window.location.href="?ac=&xueqi="+xueqi+"&banji="+banji+"&zhuanye="+zhuanye+"&laoshi="+laoshi+"&jiaoyanshi="+jiaoyanshi+"&dict_departments_id="+dict_departments_id+"";
}
//导出
layui.use('table', function(){
  var table = layui.table;
  
});

</script> 
  </body>
</html>

<%
	if("deletet".equals(ac)){
		String delid = request.getParameter("delid");
		String xueqi_new1 = request.getParameter("xueqi_new");
		System.out.println("delid====="+delid);
		if(delid!=null && !"".equals(delid)){
			String sql_num = "SELECT 	COUNT(1) AS ROW		"+
			"	FROM                            "+
			"	arrage_teacher_special          "+
			"	WHERE teacherid='"+delid+"'  AND applystate=2 ;";
			int num = db.Row(sql_num);
			if(num>0){
				out.println("<script>parent.layer.msg('审核已通过 请勿删除');window.location.replace('./teacher_special.jsp?ac=&xueqi="+xueqi_new1+"');</script>");
				return;
			}
			String del_sql = "DELETE FROM arrage_teacher_special WHERE teacherid = '"+delid+"' ;";
			boolean state = db.executeUpdate(del_sql);
			if(state){
				out.println("<script>parent.layer.msg('删除特殊需求成功');window.location.replace('./teacher_special.jsp?ac=&xueqi="+xueqi_new1+"');</script>");
			}else{
				out.println("<script>parent.layer.msg('删除失败');</script>");
			}
		}else{
			out.println("<script>parent.layer.msg('删除失败');</script>");
		}
		
		
	}


%>



<%
	if("shenhe".equals(ac)){
		//获取信息
		String teacherid_id = request.getParameter("teacherid");
		String shenhestate = request.getParameter("shenhestate");
		String xueqi_new = request.getParameter("xueqi");
		
		String sql_num = "SELECT 	COUNT(1) AS ROW		"+
					"	FROM                            "+
					"	arrage_teacher_special          "+
					"	WHERE teacherid='"+teacherid_id+"'  AND applystate=2 ;";
		int num = db.Row(sql_num);
		if(num>0){
			out.println("<script>parent.layer.msg('审核已通过 请勿重复操作');window.location.replace('./teacher_special.jsp?ac=&xueqi="+xueqi_new+"');</script>");
			return;
		}
		
		
		
		String update_sql = "UPDATE arrage_teacher_special 	"+
					"		SET                             "+
					"		applystate = '"+shenhestate+"'      "+
					"		WHERE                           "+
					"		teacherid = '"+teacherid_id+"' ;";
		boolean state = db.executeUpdate(update_sql);
		if(state){
			//插入到自动排课规则表中
			String insert = "INSERT INTO arrage_course_teacher 				"+
					"			(                                           "+
					"			teacher_id,                                 "+
					"			section_id,                                 "+
					"			week_id,                                    "+
					"			weekly,                                     "+
					"			state,                                      "+
					"			semester,                                   "+
					"			remarks,                                    "+
					"			totalid                                     "+
					"			)                                           "+
					"			SELECT 	                                    "+
					"			teacherid,                                  "+
					"			section_id,                                 "+
					"			week_id,                                    "+
					"			weekly,                                     "+
					"			state,                                      "+
					"			semester,                                   "+
					"			remarks,                                    "+
					"			totalid                                     "+
					"			FROM                                        "+
					"			arrage_teacher_special                      "+
					"			WHERE teacherid = '"+teacherid_id+"' ;";
			boolean state11 = db.executeUpdate(insert);
			if(state11){
				out.println("<script>parent.layer.msg('审核成功');window.location.replace('./teacher_special.jsp?ac=&xueqi="+xueqi_new+"');</script>");
			}else{
				out.println("<script>parent.layer.msg('审核失败');</script>");
			}
		}else{
			out.println("<script>parent.layer.msg('审核失败');</script>");
		}
	}


%>



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