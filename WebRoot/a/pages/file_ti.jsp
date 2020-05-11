<%@ page trimDirectiveWhitespaces="true" %>
<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<% String MMenuId="34"; //供应商2模块编号%>
<%@ include file="cookie.jsp"%>
<head> 
    <meta charset="utf-8"> 
    <meta name="viewport" content="width=device-width, initial-scale=1"> 
    <script src="js/layui/layui.js"></script>
    <link rel="stylesheet" href="js/layui/css/layui.css">
     <link rel="stylesheet" href="css/sy_style.css?22">
 
    <title>档案列表</title> 
  <style>
  .layui-colla-title{text-align:center;}
  	.layui-colla-icon{ top:0;font-size:14px;margin-left:10px;position:initial;}
  	.layui-form-item{width:900px;margin:0 auto}
  	h4{text-align:center;margin-bottom:20px}
  </style>
 </head> 
<body>
<div class="layui-collapse" lay-accordion>
	  <div class="layui-colla-item">
	    <h2 class="layui-colla-title">档案信息</h2>
	    <div class="layui-colla-content ">
	     <!-- 档案 内容 -->
	     <h4 >一、基本信息</h4>
	     <div class="layui-form-item">
			    <div class="layui-inline">
			      <label class="layui-form-label">姓名</label>
			      <div class="layui-input-inline">
			        <input type="text" required readonly="readonly" value="88888" class="layui-input">
			      </div>
			    </div>
			    <div class="layui-inline">
			      <label class="layui-form-label">性别</label>
			    <div class="layui-input-inline">
			      <input type="text" name="" readonly="readonly"  value="88888" class="layui-input">
			    </div>
			    </div>
			    <div class="layui-inline">
			      <label class="layui-form-label">单位名称</label>
			      <div class="layui-input-inline">
			        <input type="text" name="" readonly="readonly"  value="88888" class="layui-input">
			      </div>
			    </div>
			    <div class="layui-inline">
			      <label class="layui-form-label">单位地址</label>
			      <div class="layui-input-inline">
			        <input type="text" name="" readonly="readonly" value="88888" class="layui-input">
			      </div>
			    </div>
		  </div>
    		<div class="layui-form-item">
			    <div class="layui-inline">
			      <label class="layui-form-label">联系电话</label>
			      <div class="layui-input-inline">
			        <input type="text" readonly="readonly" value="88888" class="layui-input">
			      </div>
			    </div>
			    <div class="layui-inline">
			      <label class="layui-form-label">联系地址</label>
			      <div class="layui-input-inline">
			        <input type="text" name="address" readonly="readonly" value="88888" class="layui-input">
			      </div>
			    </div>
			    <div class="layui-inline">
			      <label class="layui-form-label">身份证号</label>
			      <div class="layui-input-inline">
			        <input type="text" name="" readonly="readonly" value="88888" class="layui-input">
			      </div>
			    </div>
			    <div class="layui-inline">
			      <label class="layui-form-label">手机号码</label>
			      <div class="layui-input-inline">
			        <input type="text"  name="phone" readonly="readonly" value="88888" class="layui-input">
			      </div>
			    </div>
		  </div>
		  <div class="layui-form-item">
			    <div class="layui-inline">
			      <label class="layui-form-label">单位电话</label>
			      <div class="layui-input-inline">
			        <input type="text" readonly="readonly" class="layui-input" value="88888">
			      </div>
			    </div>
			    <div class="layui-inline">
			      <label class="layui-form-label">民族</label>
			      <div class="layui-input-inline">
			        <input type="text" name="" readonly="readonly"  class="layui-input" value="88888">
			      </div>
			    </div>
			    <div class="layui-inline">
			      <label class="layui-form-label">行业类别</label>
			      <div class="layui-input-inline">
			        <input type="text" class="layui-input" readonly="readonly" value="88888">

			      </div>
			    </div>
			    <div class="layui-inline">
			      <label class="layui-form-label">婚姻状况</label>
			      <div class="layui-input-inline"  >
			       	 <input type="text" class="layui-input" readonly="readonly" value="88888">

			      </div>
			    </div>
		  </div>
		  
		  <h4>二、婚姻信息</h4>
		  <div class="layui-form-item">
			    <div class="layui-inline">
			      <label class="layui-form-label">配偶姓名</label>
			      <div class="layui-input-inline">
			        <input type="text" class="layui-input" readonly="readonly" value="88888">
			      </div>
			    </div>
			    <div class="layui-inline">
			      <label class="layui-form-label">身份证号</label>
			      <div class="layui-input-inline">
			        <input type="text" name="" readonly="readonly" value="88888" class="layui-input">
			      </div>
			    </div>
			    <div class="layui-inline">
			      <label class="layui-form-label">联系电话</label>
			      <div class="layui-input-inline">
			       <input type="text" name="" readonly="readonly" value="88888" class="layui-input">
			      </div>
			    </div>
			    <div class="layui-inline">
			      <label class="layui-form-label">单位名称</label>
			      <div class="layui-input-inline" >
			       <input type="text" name="" readonly="readonly" value="88888" class="layui-input">
			      </div>
			    </div>
			 </div>
			 <div class="layui-form-item">
			    <div class="layui-inline">
			      <label class="layui-form-label">单位地址</label>
			      <div class="layui-input-inline" >
			       <input type="text" name="" readonly="readonly" value="88888" class="layui-input">
			      </div>
			    </div>
			    <div class="layui-inline">
			      <label class="layui-form-label">单位电话</label>
			      <div class="layui-input-inline" >
			       <input type="text" name="" readonly="readonly" value="88888" class="layui-input">
			      </div>
			    </div>
			     <div class="layui-inline">
			      <label class="layui-form-label">结婚证号</label>
			      <div class="layui-input-inline" >
			       <input type="text" name="" readonly="readonly" value="88888" class="layui-input">
			      </div>
			    </div>
		  </div>
		  
		   <div class="layui-form-item">
		  <div class="layui-block">
		  	
		 	</div>
		  </div>
		  <!-- 档案 内容 -->
	    </div>
	  </div>
	  <div class="layui-colla-item">
	    <h2 class="layui-colla-title">继承基本信息</h2>
	    <div class="layui-colla-content ">
	    <!--  -->
	    <div class="layui-form-item">
			    <div class="layui-inline">
			      <label class="layui-form-label">业务员</label>
			      <div class="layui-input-inline">
			        <input type="text"  readonly="readonly" class="layui-input">
			      </div>
			    </div>
			    <div class="layui-inline">
			      <label class="layui-form-label">经销商</label>
			    <div class="layui-input-inline">
			      <input type="text"  readonly="readonly" class="layui-input">
			    </div>
			    </div>
			    <div class="layui-inline">
			      <label class="layui-form-label">政策类型</label>
			      <div class="layui-input-inline">
			        <input type="text"  readonly="readonly" class="layui-input">
			      </div>
			    </div>
			    <div class="layui-inline">
			      <label class="layui-form-label">银行</label>
			      <div class="layui-input-inline">
			       <input type="text"  readonly="readonly" class="layui-input">
			      </div>
			    </div>
		  </div>
    		<div class="layui-form-item">
			    <div class="layui-inline">
			      <label class="layui-form-label">姓名</label>
			      <div class="layui-input-inline">
			       <input type="text"  readonly="readonly" class="layui-input">
			      </div>
			    </div>
			    <div class="layui-inline">
			      <label class="layui-form-label">性别</label>
			      <div class="layui-input-inline">
			        <input type="text"  readonly="readonly" class="layui-input">
			      </div>
			    </div>
			    <div class="layui-inline">
			      <label class="layui-form-label">身份证号</label>
			      <div class="layui-input-inline">
			        <input type="text"  readonly="readonly" class="layui-input">
			      </div>
			    </div>
			    <div class="layui-inline">
			      <label class="layui-form-label">出生年月</label>
			      <div class="layui-input-inline">
			        <input type="text"  readonly="readonly" class="layui-input">
			      </div>
			    </div>
		  </div>
		  <div class="layui-form-item">
			    <div class="layui-inline">
			      <label class="layui-form-label">行业</label>
			      <div class="layui-input-inline">
			       <input type="text"  readonly="readonly" class="layui-input">
			      </div>
			    </div>
			    <div class="layui-inline">
			      <label class="layui-form-label">家庭住址</label>
			      <div class="layui-input-inline">
			        <input type="text"  readonly="readonly" class="layui-input">
			      </div>
			    </div>
			    <div class="layui-inline">
			      <label class="layui-form-label">联系方式</label>
			      <div class="layui-input-inline">
			        <input type="text"  readonly="readonly" class="layui-input">
			      </div>
			    </div>
			    <div class="layui-inline">
			      <label class="layui-form-label">所购车型</label>
			      <div class="layui-input-inline"  >
			        <input type="text"  readonly="readonly" class="layui-input">
			      </div>
			    </div>
		  </div>
	    <!--  -->
	    </div>
	  </div>
	  <div class="layui-colla-item">
	    <h2 class="layui-colla-title">继承谁谁谁表单</h2>
	    <div class="layui-colla-content ">
	       <div class="layui-form-item layui-form-text">
			    <label class="layui-form-label">谁谁谁建议</label>
			    <div class="layui-input-block">
			      <textarea name="desc" placeholder="请输入内容"  readonly="readonly"  class="layui-textarea"></textarea>
			    </div>
			  </div>
	    </div>
	  </div>
	  <form action="">
	  <div class="layui-form-item layui-form-text" style="margin:10px 15px">
		<label class="layui-form-label">备注</label>
		 <div class="layui-input-block">
   			<textarea name="" required lay-verify="required" placeholder="请输入备注" class="layui-textarea mar_20"></textarea>
		</div>
	</div>  
	 <div class="layui-form-item mar_20" >
		<button class="layui-btn">同意</button>
		<button class="layui-btn layui-btn-primary">拒单</button>
	</div>  
	</form>
	</div>		 
	<script>
		//注意：折叠面板 依赖 element 模块，否则无法进行功能性操作
		layui.use('element', function(){
		  var element = layui.element;
		
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