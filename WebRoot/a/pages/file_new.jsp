<%@ page trimDirectiveWhitespaces="true" %>
<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<% String MMenuId="34"; //供应商2模块编号%>
<%@ include file="cookie.jsp"%>
<head> 
    <meta charset="utf-8"> 
    <meta name="viewport" content="width=device-width, initial-scale=1"> 
    <link href="css/base.css" rel="stylesheet">
   <script src="js/layui/layui.js"></script>
    <link rel="stylesheet" href="js/layui/css/layui.css">
     <link rel="stylesheet" href="css/sy_style.css?22">
    <title>供应商列表</title> 
 </head> 
<body>
    <div class="container">   
    	<form class="file_new layui-form">
    		<h4>一、基本信息</h4>
    		
    		<div class="layui-form-item">
			    <div class="layui-inline">
			      <label class="layui-form-label">姓名</label>
			      <div class="layui-input-inline">
			        <input type="text" required lay-verify="required" class="layui-input">
			      </div>
			    </div>
			    <div class="layui-inline">
			      <label class="layui-form-label">性别</label>
			    <div class="layui-input-inline">
			      <select name="gender" lay-verify="required">
			        <option value="">性别</option>
			        <option value="男" selected="">男</option>
			        <option value="女">女</option>
			      </select>
			    </div>
			    </div>
			    <div class="layui-inline">
			      <label class="layui-form-label">单位名称</label>
			      <div class="layui-input-inline">
			        <input type="text" name="" required lay-verify="required"  class="layui-input">
			      </div>
			    </div>
			    <div class="layui-inline">
			      <label class="layui-form-label">单位地址</label>
			      <div class="layui-input-inline">
			        <input type="text" name="" required lay-verify="required" class="layui-input">
			      </div>
			    </div>
		  </div>
    		<div class="layui-form-item">
			    <div class="layui-inline">
			      <label class="layui-form-label">联系电话</label>
			      <div class="layui-input-inline">
			        <input type="text" required lay-verify="required" class="layui-input">
			      </div>
			    </div>
			    <div class="layui-inline">
			      <label class="layui-form-label">联系地址</label>
			      <div class="layui-input-inline">
			        <input type="text" name="address" required lay-verify="required" class="layui-input">
			      </div>
			    </div>
			    <div class="layui-inline">
			      <label class="layui-form-label">身份证号</label>
			      <div class="layui-input-inline">
			        <input type="text" name="" required lay-verify="required" class="layui-input">
			      </div>
			    </div>
			    <div class="layui-inline">
			      <label class="layui-form-label">手机号码</label>
			      <div class="layui-input-inline">
			        <input type="text"  name="phone" required lay-verify="required" class="layui-input">
			      </div>
			    </div>
		  </div>
		  <div class="layui-form-item">
			    <div class="layui-inline">
			      <label class="layui-form-label">单位电话</label>
			      <div class="layui-input-inline">
			        <input type="text" required lay-verify="required" class="layui-input">
			      </div>
			    </div>
			    <div class="layui-inline">
			      <label class="layui-form-label">民族</label>
			      <div class="layui-input-inline">
			        <input type="text" name="" required lay-verify="required" class="layui-input">
			      </div>
			    </div>
			    <div class="layui-inline">
			      <label class="layui-form-label">行业类别</label>
			      <div class="layui-input-inline">
			        <select name="industry" lay-verify="required">
			        <option value="">性别</option>
			        <option value="男" selected="">男</option>
			        <option value="女">女</option>
			      </select>
			      </div>
			    </div>
			    <div class="layui-inline">
			      <label class="layui-form-label">婚姻状况</label>
			      <div class="layui-input-inline"  >
			        <select name="marriage" lay-verify="required">
			        <option value="">性别</option>
			        <option value="男" selected="">男</option>
			        <option value="女">女</option>
			      </select>
			      </div>
			    </div>
		  </div>
		  
		  <h4>二、婚姻信息</h4>
		  <div class="layui-form-item">
			    <div class="layui-inline">
			      <label class="layui-form-label">配偶姓名</label>
			      <div class="layui-input-inline">
			        <input type="text" class="layui-input">
			      </div>
			    </div>
			    <div class="layui-inline">
			      <label class="layui-form-label">身份证号</label>
			      <div class="layui-input-inline">
			        <input type="text" name="" class="layui-input">
			      </div>
			    </div>
			    <div class="layui-inline">
			      <label class="layui-form-label">联系电话</label>
			      <div class="layui-input-inline">
			       <input type="text" name="" class="layui-input">
			      </div>
			    </div>
			    <div class="layui-inline">
			      <label class="layui-form-label">单位名称</label>
			      <div class="layui-input-inline" >
			       <input type="text" name="" class="layui-input">
			      </div>
			    </div>
			 </div>
			 <div class="layui-form-item">
			    <div class="layui-inline">
			      <label class="layui-form-label">单位地址</label>
			      <div class="layui-input-inline" >
			       <input type="text" name="" class="layui-input">
			      </div>
			    </div>
			    <div class="layui-inline">
			      <label class="layui-form-label">单位电话</label>
			      <div class="layui-input-inline" >
			       <input type="text" name="" class="layui-input">
			      </div>
			    </div>
			     <div class="layui-inline">
			      <label class="layui-form-label">结婚证号</label>
			      <div class="layui-input-inline" >
			       <input type="text" name="" class="layui-input">
			      </div>
			    </div>
		  </div>
		  
		   <div class="layui-form-item">
		  <div class="layui-block">
			      <label class="layui-form-label file">上传</label>
		  	<div class="layui-box layui-upload-button">
		 		 <input type="file" name="file" class="layui-upload-file">
		 		 <span class="layui-upload-icon"><i class="layui-icon"></i>上传图片</span>
		 	</div>
		 	</div>
		  </div>
		  
		  
		  
		  
		  <div class="layui-form-item">
		    <div class="layui-input-block" style="text-align:center;margin-left:0">
		      <button class="layui-btn layui-btn-danger" lay-submit lay-filter="*" style="">新建</button>
		    </div>
		  </div>
    	</form>
    </div>   
 <script type="text/javascript">
 	layui.use(['form', 'layedit', 'laydate'], function(){
		  var form = layui.form();
	});
 </script>
</body> 
</html>
<%
//插入常用菜单日志
int   TagMenu=db.Row("SELECT COUNT(*) as row FROM  menu_worker  WHERE sysmenuid='"+MMenuId+"' and  workerid='"+Suid+"' and  companyid="+Scompanyid);
if(TagMenu==0){
  db.executeUpdate("INSERT INTO `menu_worker`(`sysmenuid`,`workerid`,`countes`,`companyid`) VALUES ('"+MMenuId+"','"+Suid+"','1','"+Scompanyid+"');"); 
}else{
 db.executeUpdate("UPDATE  `menu_worker` SET `countes`=countes+1,`usetime`=now() WHERE  sysmenuid='"+MMenuId+"' and  workerid='"+Suid+"' and  companyid="+Scompanyid);
}
 %>
<% 
if(db!=null)db.close();db=null;if(server!=null)server=null;%>