<%@ page trimDirectiveWhitespaces="true" %>
<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@ include file="../../cookie.jsp"%>

<%
	String sqlwhere ="";
	String base_sql = "";
	String xueqi = request.getParameter("xueqi");
	
	int hunhuan = 20;
	if(xueqi==null ){xueqi=""; sqlwhere +="	";  }else{
		
		sqlwhere +="	AND teaching_task.semester = '"+xueqi+"'";   base_sql +="	AND	semester = '"+xueqi+"'";
		
		String cishu = "select academic_weeks from academic_year where academic_year = '"+xueqi+"'";
		ResultSet ss = db.executeQuery(cishu);
		while(ss.next()){
			hunhuan = ss.getInt("academic_weeks");
		}if(ss!=null){ss.close();}
	
	}

%>

<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>开课通知单学时汇总</title>
<meta name="renderer" content="webkit">
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
<meta name="apple-mobile-web-app-status-bar-style" content="black"> 
<meta name="apple-mobile-web-app-capable" content="yes">
<meta name="format-detection" content="telephone=no">
<link rel="stylesheet" href="../../js/layui2/css/layui.css">
<script type="text/javascript" src="../../js/jquery-1.9.1.js" ></script><!--通用jquery-->
<script src="../../js/layui2/layui.js"></script>
<style>
body{padding: 10px;}
.layui-btn{background: #f4f4f4;border: 1px #e6e6e6 solid;color: #3f3f3f;}
.layui-btn:hover{color: #000000;}
.layui-field-box {padding: 10px 0px;}
.layui-input-block {margin-left: 0px;}
.layui-btn-primary:hover{border-color: #e6e6e6;}
.lever{width: 128px;margin: 20px auto;height: 40px;}
blockquote span{margin-right: 20px;}
.my_table{width: 100%;height: auto;overflow: auto;margin:0 auto;}
.layui-table .my_center{text-align: center} 
.layui-table td{text-align: center;}
.layui-table .table_img_b {padding:0;background: url(../images/img1.png) no-repeat; 
	background-size:228px;width: 120px;height: 88px;}
.layui-table .table_img_s {padding:0;background: url(../images/img2.png) no-repeat; 
	background-size:48px;width: 48px;height: auto;}
.layui-table td, .layui-table th {padding: 9px 9px;}

.layui-table tbody tr:hover{ background-color: #fff;}
.red_color{color:red;}
.blue_color{color:blue;}
/*.layui-table tbody td:hover{ background-color: #F2F2F2;}*/
</style>
</head>
<body>
	
<div id="box">
	<div id="tb" class="form_top layui-form" style="display: flex;">
		<select name="xueqi" id="xueqi">
				<option value="0">请选择学期号</option>
				<%
					String xueqi_sql = "select academic_year from academic_year";
					ResultSet xueqi_set = db.executeQuery(xueqi_sql);
					while(xueqi_set.next()){
				%>
					<option value="<%=xueqi_set.getString("academic_year") %>" <%if("".equals(xueqi)){out.println("selected='selected'");}else{if(xueqi.equals(xueqi_set.getString("academic_year"))){out.println("selected='selected'");}} %>><%=xueqi_set.getString("academic_year") %></option>
				<%}if(xueqi_set!=null){xueqi_set.close();} %>
		</select>
			<button class="layui-btn layui-btn-small  layui-btn-primary" onclick="fanhui()" style="height: 35px;  color: white; background: rgb(25, 160, 148);"> <i class="layui-icon" style="color: #FFF;">&#xe65c;</i> 返回</button>
			<button class="layui-btn layui-btn-small  layui-btn-primary" onclick="ac_tion('')"  style="height: 35px;  color: white; background: rgb(25, 160, 148);"> <i class="layui-icon" style="color: #FFF;">&#xe615;</i> 搜索</button>
			<button class="layui-btn layui-btn-small  layui-btn-primary" onclick="shuaxin()" style="height: 35px;  color: white; background: rgb(25, 160, 148);"> <i class="layui-icon" style="color: #FFF;">ဂ</i> 刷新</button>
	</div>
	<div class="layui-field-box">
	    <div class="my_table">
		  <table class="layui-table" style="width: 5000px;">
		    <tbody>
		      <tr>
		        <td rowspan="2">课程</td>
		        <%
		        	for(int i =1 ; i<=hunhuan;i++){
		        
		        %>
		        	<td colspan="3">第<%=i %>周</td>
		        <%} %>
		      </tr>
		      <tr>
		      <%
		      	for(int j=1 ; j<=hunhuan;j++){
		      %>
		        <td>讲课</td>
		        <td>实验</td>
		        <td>上机</td>
		      <%} %>
		      </tr>
		     
		      <%
		      	String sql = "SELECT											" +
		      		"	start_semester,											"+
					"	experiment,												"+
					"		computer_week_time,"+
				   "   	  dict_courses.course_name AS course_name,              " +
				   "   	  class_begins_weeks,                                   " +
				   "   	  GROUP_CONCAT( class_begins_weeks) AS rrr              " +
				   "   	FROM arrage_coursesystem                                      " +
				   "   	  LEFT JOIN dict_courses                                " +
				   "   	    ON arrage_coursesystem.course_id = dict_courses.id        " +
				   "   	WHERE typestate = 2   "+sqlwhere+"                                  "+
				   "   	GROUP BY course_id";
		      
		      	ResultSet set = db.executeQuery(sql);
		      	while(set.next()){
		      
		      %>
		       <tr>
		        <td><%=set.getString("course_name") %></td>
		        <%
		        	//周次集合
		        	ArrayList<String> totle_list = new ArrayList<String>();
		        	String rrr = set.getString("rrr");
		        	ArrayList<String> list = 	new ArrayList(Arrays.asList(rrr.split(",")));
		        	for(int l = 0; l<list.size();l++){
		        		String t = list.get(l);
		        		if(t.indexOf("-")==-1){
		        			//不存在周数范围
		        			totle_list.add(t);
		        		}else{
		        			//存在周数范围
		        			String [] ss = t.split("-");
		        			for(int g = Integer.valueOf(ss[0]) ;g<=Integer.valueOf(ss[1]);g++){
		        				totle_list.add(String.valueOf(g));
		        			}
		        			
		        		}
		        	}
		        	System.out.println("totle_list===="+totle_list);
		        
		        	for(int m=1; m<=hunhuan;m++){
		        		int cishu = Collections.frequency(totle_list,String.valueOf(m));
		        %>
		        	<td class="blue_color jiangke_<%=m%>"><%=(set.getInt("start_semester"))*cishu %></td>
			        <td class="blue_color shiyan_<%=m %>"><%=(set.getInt("experiment"))*cishu %></td>
			        <td class="red_color  shangji_<%=m %>"><%=(set.getInt("computer_week_time"))*cishu %></td>
		        <%} %>
		         </tr>
		        <% }if(set!=null){set.close();}%> 
		     
		      <tr>
		        <td>合计</td>
		        <%
		        	for(int e=1;e<=hunhuan;e++){
		        %>
		        <td class="blue_color jiangkezong_<%=e%>">0</td>
		        <td class="blue_color shiyanzong_<%=e %>">0</td>
		        <td class="red_color shangjizong_<%=e %>">0</td>
		        <%} %>
		      </tr>	      
		    </tbody>
		  </table>
		</div>
		 
		</div>
    </div>
</div>

<br><br><br>

<script>
$(function(){

	for(var i = 1 ; i<=<%=hunhuan%> ; i++){
		var jiangkezong = 0;
		var shiyanzong = 0;
		var shangjizong = 0;
		$(".jiangke_"+i+"").each(function(){
			jiangkezong +=Number($(this).text());
		})
		$(".shiyan_"+i+"").each(function(){
			shiyanzong += Number($(this).text())  ;
		})
		
		$(".shangji_"+i+"").each(function(){
			shangjizong += Number($(this).text());
		})

		$(".jiangkezong_"+i+"").text(jiangkezong);
		$(".shiyanzong_"+i+"").text(shiyanzong);
		$(".shangjizong_"+i+"").text(shangjizong);
	}

	
})




layui.use(['form','layer','jquery'], function(){
	var form = layui.form;
	var $ = layui.jquery;
});
//返回
function fanhui(){
	window.location.replace('./school_sum.jsp');
}

//刷新整个页面
function shuaxin(){
	 //location.reload();
	window.location.href="?ac=";
}

//执行
function ac_tion() {
	var xueqi = $("#xueqi").val();
	var zhoushu = $("#zhoushu").val();
	if(xueqi==null||xueqi==0){
		layer.msg("请选择学期学号");
	}
	
	window.location.href="?ac=&xueqi="+xueqi+"&zhoushu="+zhoushu+"";
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
 %>
<% 
if(db!=null)db.close();db=null;if(server!=null)server=null;%>