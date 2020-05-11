<%@ page trimDirectiveWhitespaces="true" %>
<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@ include file="../../cookie.jsp"%>
<!DOCTYPE html> 
<html>
<head>
<meta charset="utf-8">
<title>教师任课通知书</title>
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
.my_table{width: 1000px;height: auto;overflow: auto;margin:0 auto;}
.layui-table .my_center{text-align: center} 
.layui-table td{text-align: center;}
.layui-table .table_img_b {padding:0;background: url(../images/img1.png) no-repeat; 
	background-size:228px;width: 120px;height: 88px;}
.layui-table .table_img_s {padding:0;background: url(../images/img2.png) no-repeat; 
	background-size:48px;width: 48px;height: auto;}
.layui-table td, .layui-table th {padding: 9px 9px;}

.layui-table tbody tr:hover{ background-color: #fff;}
/*.layui-table tbody td:hover{ background-color: #F2F2F2;}*/
</style>
</head>
<body>
	
<div id="box">
	<blockquote class="layui-elem-quote" style="padding: 5px">
		&nbsp;&nbsp;&nbsp;
		教师任课通知书:<span style="margin-left: 15px;">[学年学期号：2009-2010-1]</span>
	</blockquote>
	<div class="layui-field-box">
	
		<%
			String sql = "SELECT * FROM teaching_task left join teaching_task_teacher on teaching_task_teacher.teaching_task_id = teaching_task.id WHERE typestate = 2 GROUP BY teacherid";
			ResultSet set = db.executeQuery(sql);
			while(set.next()){
		%>
	
	
		<%} %>
	
	    <div class="my_table">
		  <table class="layui-table" style="width: 880px;">
		    <colgroup>
		      <col width="80">
		      <col width="160">
		      <col width="80">
		      <col width="80">
		      <col width="80">
		      <col width="80">
		      <col width="80">
		      <col width="80">
		      <col width="80">
		      <col>   
		    </colgroup>
		    <thead>
		      <tr>
		        <th colspan="10"><h3>法律事务(三年制)</h3></th>
		      </tr> 
		    </thead>
		    <tbody>
		      <tr>
		        <td>班级</td>
		        <td colspan="2">09级高中高职法律事务1-4班</td>
		        <td>周总学时</td>
		        <td>20</td>
		        <td>教学周数</td>
		        <td colspan="2">13</td>
		        <td>开课门数</td>
		        <td>6</td>
		      </tr>
		      <tr>
		        <td rowspan="2">序号</td>
		        <td colspan="2">课程名称</td>
		        <td colspan="5">学时分配</td>
		        <td colspan="2"></td>
		      </tr>
		      <tr>
		        <td>考试科目</td>
		        <td>考查科目</td>
		        <td>总学时</td>
		        <td>已完成</td>
		        <td>本学期</td>
		        <td>周学时</td>
		        <td>教学学期</td>
		        <td>教材版本</td>
		        <td>任课教师</td>		        
		      </tr>
		      <tr>
		      	<td>1</td>
		        <td>思想道德与法律修养</td>
		        <td></td>
		        <td>26</td>
		        <td></td>
		        <td>26</td>
		        <td>2</td>
		        <td>1</td>
		        <td></td>
		        <td>张晓娟1-4</td>		        
		      </tr>		      
		    </tbody>
		  </table>
		</div>
		 <div class="my_table">
		  <table class="layui-table" style="width: 880px;">
		    <colgroup>
		      <col width="80">
		      <col width="160">
		      <col width="80">
		      <col width="80">
		      <col width="80">
		      <col width="80">
		      <col width="80">
		      <col width="80">
		      <col width="80">
		      <col>   
		    </colgroup>
		    <thead>
		      <tr>
		        <th colspan="10"><h3>法律事务(三年制)</h3></th>
		      </tr> 
		    </thead>
		    <tbody>
		      <tr>
		        <td>班级</td>
		        <td colspan="2">09级高中高职法律事务1-4班</td>
		        <td>周总学时</td>
		        <td>20</td>
		        <td>教学周数</td>
		        <td colspan="2">13</td>
		        <td>开课门数</td>
		        <td>6</td>
		      </tr>
		      <tr>
		        <td rowspan="2">序号</td>
		        <td colspan="2">课程名称</td>
		        <td colspan="5">学时分配</td>
		        <td colspan="2"></td>
		      </tr>
		      <tr>
		        <td>考试科目</td>
		        <td>考查科目</td>
		        <td>总学时</td>
		        <td>已完成</td>
		        <td>本学期</td>
		        <td>周学时</td>
		        <td>教学学期</td>
		        <td>教材版本</td>
		        <td>任课教师</td>		        
		      </tr>
		      <tr>
		      	<td>1</td>
		        <td>思想道德与法律修养</td>
		        <td></td>
		        <td>26</td>
		        <td></td>
		        <td>26</td>
		        <td>2</td>
		        <td>1</td>
		        <td></td>
		        <td>张晓娟1-4</td>		        
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