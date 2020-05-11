<%@ page trimDirectiveWhitespaces="true" %>
<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@ include file="../../../cookie.jsp"%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <title></title>
  <meta name="renderer" content="webkit">
  <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
  <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
  <meta name="apple-mobile-web-app-status-bar-style" content="black"> 
  <meta name="apple-mobile-web-app-capable" content="yes">
  <meta name="format-detection" content="telephone=no">

   <link rel="stylesheet" href="../../../../pages/css/sy_style.css">	    
   <link rel="stylesheet" href="../../../js/layui2/css/layui.css">
	<script type="text/javascript" src="../../../js/jquery-1.9.1.js" ></script><!--通用jquery-->
	<script src="../../../js/layui2/layui.js"></script>

<style>
body{padding: 10px;}
/*#box{width: 900px;margin: 0 auto;}*/
.layui-btn{background: #f4f4f4;border: 1px #e6e6e6 solid;color: #3f3f3f;}
.layui-btn:hover{color: #000000;}
.layui-field-box {padding: 10px 0px;}
.layui-input-block {margin-left: 0px;}
.layui-btn-primary:hover{border-color: #e6e6e6;}
.lever{width: 128px;margin: 20px auto;height: 40px;}
blockquote span{margin-right: 20px;}
.layui-form-item .layui-inline{line-height: 38px;}
.layui-table tbody tr:hover{ background-color: #fff;}
.layui-table tbody td, .layui-table thead th{ text-align: center;}
</style>
</head>
	<title>课表分割</title> 
<body>
	<%
	String semester = request.getParameter("semester"); if(semester==null){semester="";}//获取用户uid
	%>
<div id="box">
	<blockquote class="layui-elem-quote" style="padding: 5px">
		&nbsp;&nbsp;&nbsp;
		课表分割设置
	</blockquote>
	<div class="layui-field-box">
	    <form class="layui-form layui-form-pane1" action="">
	    	<div class="layui-form-item">
		  		<div class="layui-inline">
				    <label class="layui-form-label">每天</label>
				    <div class="layui-input-inline" style="width: 100px;">
				      	<select name="quiz" lay-verify="required" lay-verType="tips">
				          <option value="">0</option>
				          <option value="你工作的第一个城市">1</option>
				          <option value="你的工号" disabled>2</option>
				          <option value="你最喜欢的老师">30</option>
				        </select>
				    </div>大节课
			    </div>		  				  
			</div>
			
			<!-- 表格 -->
			<form class="layui-form layui-form-pane1" action="">				
				<table class="layui-table">
				  <thead>
				    <tr>
				      <th>大节ID</th>
				      <th>占用小节次</th>
				      <th>大节名</th>
				      <th>大节打印名</th>
				      <th>总课表显示名</th>
				    </tr> 
				  </thead>
				  <tbody>
				    <tr>
				      <td>1</td>
				      <td>
				      	<div class="layui-inline">
						    <div class="layui-input-inline" style="width: 40px;">
						       <input type="text" name="" value="1" class="layui-input">
						    </div>
				      	</div>
				      	<div class="layui-inline">
						    <div class="layui-input-inline" style="width: 40px;">
						       <input type="text" name="" value="2" class="layui-input">
						    </div>
				      	</div>
				      	<div class="layui-inline">
						    <div class="layui-input-inline" style="width: 40px;">
						       <input type="text" name="" value="" class="layui-input">
						    </div>
				      	</div>
				      </td>
				      <td>
				      	<div class="layui-inline">
						    <div class="layui-input-inline">
						       <input type="text" name="" value="1" class="layui-input">
						    </div>
				      	</div>
				      </td>
				      <td>
						<div class="layui-inline">
						    <div class="layui-input-inline">
						       <input type="text" name="" value="1" class="layui-input">
						    </div>
				      	</div>
				      </td>
				      <td>
						<div class="layui-inline">
						    <div class="layui-input-inline">
						       <input type="text" name="" value="1" class="layui-input">
						    </div>
				      	</div>
				      </td>
				    </tr>
				    <tr>
				      <td>2</td>
				      <td>
						<div class="layui-inline">
						    <div class="layui-input-inline" style="width: 40px;">
						       <input type="text" name="" value="3" class="layui-input">
						    </div>
				      	</div>
				      	<div class="layui-inline">
						    <div class="layui-input-inline" style="width: 40px;">
						       <input type="text" name="" value="4" class="layui-input">
						    </div>
				      	</div>
				      	<div class="layui-inline">
						    <div class="layui-input-inline" style="width: 40px;">
						       <input type="text" name="" value="" class="layui-input">
						    </div>
				      	</div>
				      </td>
				      <td>
						<div class="layui-inline">
						    <div class="layui-input-inline">
						       <input type="text" name="" value="1" class="layui-input">
						    </div>
				      	</div>
				      </td>
				      <td>
						<div class="layui-inline">
						    <div class="layui-input-inline">
						       <input type="text" name="" value="1" class="layui-input">
						    </div>
				      	</div>
				      </td>
				      <td>
						<div class="layui-inline">
						    <div class="layui-input-inline">
						       <input type="text" name="" value="1" class="layui-input">
						    </div>
				      	</div>
				      </td>
				    </tr>
				    <tr>
				      <td>3</td>
				      <td>
						<div class="layui-inline">
						    <div class="layui-input-inline" style="width: 40px;">
						       <input type="text" name="" value="5" class="layui-input">
						    </div>
				      	</div>
				      	<div class="layui-inline">
						    <div class="layui-input-inline" style="width: 40px;">
						       <input type="text" name="" value="6" class="layui-input">
						    </div>
				      	</div>
				      	<div class="layui-inline">
						    <div class="layui-input-inline" style="width: 40px;">
						       <input type="text" name="" value="" class="layui-input">
						    </div>
				      	</div>
				      </td>
				      <td>
						<div class="layui-inline">
						    <div class="layui-input-inline">
						       <input type="text" name="" value="1" class="layui-input">
						    </div>
				      	</div>
				      </td>
				      <td>
						<div class="layui-inline">
						    <div class="layui-input-inline">
						       <input type="text" name="" value="1" class="layui-input">
						    </div>
				      	</div>
				      </td>
				      <td>
						<div class="layui-inline">
						    <div class="layui-input-inline">
						       <input type="text" name="" value="1" class="layui-input">
						    </div>
				      	</div>
				      </td>
				    </tr>
				    <tr>
				      <td>4</td>
				      <td>
						<div class="layui-inline">
						    <div class="layui-input-inline" style="width: 40px;">
						       <input type="text" name="" value="7" class="layui-input">
						    </div>
				      	</div>
				      	<div class="layui-inline">
						    <div class="layui-input-inline" style="width: 40px;">
						       <input type="text" name="" value="8" class="layui-input">
						    </div>
				      	</div>
				      	<div class="layui-inline">
						    <div class="layui-input-inline" style="width: 40px;">
						       <input type="text" name="" value="" class="layui-input">
						    </div>
				      	</div>
				      </td>
				      <td>
						<div class="layui-inline">
						    <div class="layui-input-inline">
						       <input type="text" name="" value="1" class="layui-input">
						    </div>
				      	</div>
				      </td>
				      <td>
						<div class="layui-inline">
						    <div class="layui-input-inline">
						       <input type="text" name="" value="1" class="layui-input">
						    </div>
				      	</div>
				      </td>
				      <td>
						<div class="layui-inline">
						    <div class="layui-input-inline">
						       <input type="text" name="" value="1" class="layui-input">
						    </div>
				      	</div>
				      </td>
				    </tr>
				  </tbody>
				</table>
			</form>

			<!-- 底部按钮 -->
			<div class="layui-form-item">
			    <div class="layui-input-block" style="width: 70px;margin:40px auto;">
			      <input type="button" value="保存" class="layui-btn"  lay-submit lay-filter="*">
			    </div>
		    </div>
		</form>
    </div>
</div>
<br><br><br>

<script>

layui.use(['form','layer','jquery'], function(){
  var form = layui.form;
  var $ = layui.jquery;

  //自定义验证规则
  form.verify({
    title: function(value){
      if(value.length < 5){
        return '标题也太短了吧';
      }
    }
    ,pass: [/(.+){6,12}$/, '密码必须6到12位']
  });
  
  //监听提交
  form.on('submit(*)', function(data){
    console.log(data)
    return false;
  });
  
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