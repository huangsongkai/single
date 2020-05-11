<%@ page trimDirectiveWhitespaces="true" %>
<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@page import="v1.haocheok.commom.commonCourse"%>
<%@ include file="../../cookie.jsp"%>

<%
String sqlwhere ="";
String base_sql = "";
String xueqi = request.getParameter("xueqi");

int hunhuan = 0;
if(xueqi==null || "0".equals(xueqi)){xueqi=""; sqlwhere +="	AND arragne_sys_classroom.semester = '"+xueqi+"'";   base_sql +="	AND	semester = '"+xueqi+"'";}else{
	
	sqlwhere +="	AND arragne_sys_classroom.semester = '"+xueqi+"'";   base_sql +="	AND	semester = '"+xueqi+"'";
	
	String cishu = "select academic_weeks from academic_year where academic_year = '"+xueqi+"'";
	ResultSet ss = db.executeQuery(cishu);
	while(ss.next()){
		hunhuan = ss.getInt("academic_weeks");
	}if(ss!=null){ss.close();}

}
String zhoushu = request.getParameter("zhoushu");
if(zhoushu!=null && !"0".equals(zhoushu) && !"100".equals(zhoushu)){
	hunhuan = Integer.valueOf(zhoushu);
}

%>

<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>教室占用情况</title>
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
.red_color{color:red;}
.blue_color{color:blue;}
.layui-table tbody tr:hover{ background-color: #fff;}
/*.layui-table tbody td:hover{ background-color: #F2F2F2;}*/
</style>
</head>
<body>
	
<div id="box">
	<div id="tb" class="form_top layui-form" style="display: flex;">
		<select name="zhoushu" id="zhoushu">
				<option value="0">请选择学期号</option>
				<option value="100">全部周数</option>
				<%
					String sqlzhou = "select academic_weeks from academic_year where academic_year = '"+xueqi+"'";
					ResultSet zhouset = db.executeQuery(sqlzhou);
					int academic_weeks = 0;
					int k = 1;
					while(zhouset.next()){
						academic_weeks = zhouset.getInt("academic_weeks");
					}if(zhouset!=null){zhouset.close();}
					for(int n = 1; n<= academic_weeks;n++){
				%>
					<option value="<%=n%>" <%if(n==Integer.valueOf(zhoushu==null?"0":zhoushu) ){out.println("selected='selected'");} %>>第<%=n %>周</option>
				<%} %>
				<option></option>
		</select>
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
		        <td rowspan="2">教室</td>
		        <%
		        	for(int g=1;g<=hunhuan;g++){
		        %>
		        	 <td colspan="3">第<%=g %>周</td>
		        <%} %>
		       
		      </tr>
		      <tr>
		      <%
		      	for(int l=0;l<hunhuan;l++){
		      %>
		      	<td>总学时</td>
		        <td>占用学时</td>
		        <td>可用学时</td>
		      <%} %>
		        
		      </tr>
		      
		      
		      	<%
		      		String zong_sql = "SELECT count(1) as row					"+
					      		"	FROM classroom                                                          "+
					      		"	  LEFT JOIN arragne_sys_classroom                                       "+
					      		"	    ON (classroom.id = arragne_sys_classroom.classroomid	 "+sqlwhere+" )";
		      		int zong_num = db.Row(zong_sql);
		      	
		      	
		      		String sql = "SELECT classroom.classroomname AS classroomname,					"+
		      			"	classroom.id as id,														"+
			      		"	timetable                                                               "+
			      		"	FROM classroom                                                          "+
			      		"	  LEFT JOIN arragne_sys_classroom                                       "+
			      		"	    ON (classroom.id = arragne_sys_classroom.classroomid	 "+sqlwhere+" )";
		      		System.out.println("sql====="+sql);
		      		ResultSet set = db.executeQuery(sql);
		      		int num_id = 1;
		      		while(set.next()){
		      	
		      	%>
		     <tr> 
		      
		        <td><%=set.getString("classroomname") %></td>
		        <%
		        	for(int i =1 ; i<=hunhuan;i++){
		        		
		        	
		        
		        %>
		        
		        	<%
		        		//计算总学时
		        		int totlenum = 0;
		        		int jiatotle = 0;
		        		int jiantotle = 56;
		        		//1.查询出排课时间
		        		String sql2 = "SELECT state,weekly FROM arrage_course_nottime WHERE academic_year = '"+xueqi+"'";
		        		System.out.println("sql2==="+sql2);
		        		ResultSet set2 = db.executeQuery(sql2);
		        		int notimenum = db.Row("SELECT count(1) as row FROM arrage_course_nottime WHERE academic_year = '"+xueqi+"'");
		        		if(notimenum>0){
		        			while(set2.next()){
			        			if("3".equals(set2.getString("state"))){
			        				if("0".equals(set2.getString("weekly"))){
			        					jiantotle--;
			        					totlenum = jiantotle;
			        				}else{
			        					if((String.valueOf(i)).equals(set2.getString("weekly"))){
			        						jiantotle--;
			        						totlenum = jiantotle;
			        					}
			        				}
			        			}else if("1".equals(set2.getString("state"))){
			        				if("0".equals(set2.getString("weekly"))){
			        					jiatotle++;
			        					totlenum = jiatotle;
			        				}else{
			        					if((String.valueOf(i)).equals(set2.getString("weekly"))){
			        						jiatotle++;
			        						totlenum = jiatotle;
			        					}
			        				}
			        			}
			        			
			        		}if(set2!=null){set2.close();}
		        		}else{
		        			//2.查询初始化条件
				        	String sql1 = "SELECT course_class FROM arrage_course WHERE school_number = '"+xueqi+"'	";
		        			System.out.println("sql1====="+sql1);
			        		ResultSet set1 = db.executeQuery(sql1);
			        		
			        		while(set1.next()){
			        			if(set1.getString("course_class")!=null){
			        				totlenum = set1.getInt("course_class")*8;
			        			}
			        		}if(set1!=null){set1.close();}
		        		}
		        		
		        		
		        		
		        	%>
		        
		        
		        
		        	<td class="blue_color hh_<%=i%>" ><%=totlenum %></td>		<!-- 总学时 -->
		        	<%
		        	
			        	int suodingclassroom = 0;		//占用学时
		        		int jian = 40;
		        		//计算占用学时，教室规则条件
		        		String sql_suoding = "select state,zhouci from arrage_classroom where classroom_id = '"+set.getString("id")+"' "+base_sql+" ";
		        		ResultSet suodingset = db.executeQuery(sql_suoding);
		        		while(suodingset.next()){
		        			
		        			if("2".equals(suodingset.getString("state"))){
		        				if("0".equals(suodingset.getString("zhouci"))){
		        					suodingclassroom++;
		        				}else if((String.valueOf(i)).equals(suodingset.getString("zhouci"))){
		        					suodingclassroom++;
		        				}
		        			}else if("1".equals(suodingset.getString("state"))){
		        				if("0".equals(suodingset.getString("zhouci"))){
		        					jian--;
		        					suodingclassroom = jian;
		        				}else if((String.valueOf(i)).equals(suodingset.getString("zhouci"))){
		        					jian--;
		        					suodingclassroom = jian;
		        				}
		        			}
		        		}if(suodingset!=null){suodingset.close();}
		        		
		        		
		        		//排课信息占用教室情况
		        		String paike_classroom = "SELECT timetable FROM arragne_sys_classroom WHERE classroomid = '"+set.getString("id")+"'   "+base_sql+"";
		        		ResultSet paike_classset = db.executeQuery(paike_classroom);
		        		commonCourse commonCourse = new commonCourse();
		        		String timetable = "";
		        		while(paike_classset.next()){
		        			timetable = paike_classset.getString("timetable");
		        			
		        			ArrayList<ArrayList<String>> result = commonCourse.toArrayList(timetable,"*","#");
		        			for(int j =0 ; j<result.size();j++){
		        				
		        				for(int h =0 ;h<result.get(j).size();h++){
		        					if("0".equals(result.get(j).get(h))){
		        						suodingclassroom++;
		        					}
		        				}
		        			}
		        			
		        		}if(paike_classset!=null){paike_classset.close();}
		        	%>
		        	
		        	
		        	
			        <td class="blue_color zz_<%=i%>"><%=suodingclassroom %></td>		<!-- 占用学时 -->
			        <td class="red_color keyongz_<%=i%>"><%=totlenum-suodingclassroom %></td>		<!-- 可用时间 (总学时-占用学时)-->
		        
		        
		        <%} %>
		        
		        
		      </tr>  
		      <% num_id++;}if(set!=null){set.close();} %>
		      
		      <tr>
		        <td>合计</td>
		        <%
		        	for(int m = 1 ; m<=hunhuan;m++){
		        %>
			        <td class="blue_color heji_<%=m%>">0</td>
			        <td class="blue_color hejizz_<%=m%>">0</td>
			        <td class="red_color keyong_<%=m%>">0</td>
		      	<%} %>
		      </tr>      
		    </tbody>
		  </table>
		</div>
		 
		</div>
    </div>

<br><br><br>

<script>
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

$(function(){
	


	for(var i = 1;i<=20;i++){
		var zong = 0;
		var zhan = 0;
		var keyong = 0;
		$(".hh_"+i+"").each(function(){
			zong += Number($(this).text());
		})
		$(".zz_"+i+"").each(function(){
			zhan += Number($(this).text());
		})
		$(".keyongz_"+i+"").each(function(){
			keyong += Number($(this).text());
		})
		
		$(".heji_"+i+"").text(zong);
		$(".hejizz_"+i+"").text(zhan);
		$(".keyong_"+i+"").text(keyong);
	}

	

	console.log(zong);
	
})


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