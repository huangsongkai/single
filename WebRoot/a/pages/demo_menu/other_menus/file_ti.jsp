<%@ page trimDirectiveWhitespaces="true" %>
<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@ include file="../../cookie.jsp"%>
<%
/**
 * 手风琴展示
 */
%>
<head> 
    <meta charset="utf-8"> 
    <meta name="viewport" content="width=device-width, initial-scale=1"> 
    <script src="../../js/jquery-1.9.1.js"></script>
    <script src="../../js/layui2/layui.js"></script>
    <link rel="stylesheet" href="../../js/layui2/css/layui.css">
     <link rel="stylesheet" href="../../css/sy_style.css?22">
 
    <title>档案列表</title> 
  <style>
  .layui-colla-title{text-align:center;}
  	.layui-colla-icon{ top:0;font-size:14px;margin-left:10px;position:initial;}
  	.layui-form-item{width:900px;margin:0 auto}
  	.layui-form-item.mar_20{margin-top:20px;}
  	h4{text-align:center;margin-bottom:20px}
  	.layui-collapse{border:none;padding-bottom:20px;}
  
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
	  <form class="layui-form" action="">
	 <div class="more">
		 <div class="layui-form-item dingwei" >
			 <div class="layui-inline">
				<label class="layui-form-label">GPS类型</label>
				 <div class="layui-input-inline">
		   			<input type="text" name="" lay-verify="required" placeholder="请填写" class="layui-input">
				</div>
			</div>
			<div class="layui-inline">
				<label class="layui-form-label" >型号</label>
				 <div class="layui-input-inline">
		   			<input type="text" name="" lay-verify="required" placeholder="请填写" class="layui-input">
				</div>
			</div>
			<div class="layui-inline">
				<label class="layui-form-label">机器编号</label>
				 <div class="layui-input-inline">
		   			<input type="text" name="" lay-verify="required" placeholder="可更改" class="layui-input">
				</div>
			</div>
			<div class="layui-inline">
				<label class="layui-form-label" >SIM卡号</label>
				 <div class="layui-input-inline">
		   			<input type="text" name="" lay-verify="required" placeholder="可更改" class="layui-input">
				</div>
			</div>
		 </div>  
	 
	   <a class="tianjia">添加&nbsp;<font size="4">+</font></a>
	 </div>
	 
	<div class="layui-form-item mar_20" style="text-align:center;">
			<button class="layui-btn" >同意</button>
			<button class="layui-btn layui-btn-primary">拒单</button>
		</div>   
	</form>
	</div>		 
	<script>
		//注意：折叠面板 依赖 element 模块，否则无法进行功能性操作
		layui.use(['element','form','upload'], function(){
		   var $    = layui.jquery ,
			form    = layui.form,
			element = layui.element,
			upload = layui.upload;
		    
			
		});
		var i=2;
		$(".more .tianjia").click(function(){
		i++;
			 $(this).before('<div class="layui-form-item dingwei" >'+
			 '<div class="layui-inline" style="margin-right:4px;">'+
				'<label class="layui-form-label">GPS类型</label>'+
				' <div class="layui-input-inline">'+
		   		'	<input type="text" name="" lay-verify="required" placeholder="请填写" class="layui-input">'+
				'</div>'+
			'</div>'+
			'<div class="layui-inline" style="margin-right:4px;">'+
			'	<label class="layui-form-label" >型号</label>'+
			'	 <div class="layui-input-inline">'+
		   	'		<input type="text" name="" lay-verify="required" placeholder="请填写" class="layui-input">'+
			'	</div>'+
			'</div>'+
			'<div class="layui-inline" style="margin-right:3px;">'+
			'	<label class="layui-form-label" >机器编号</label>'+
			'	 <div class="layui-input-inline">'+
		   	'		<input type="text" name="" lay-verify="required" placeholder="可更改" class="layui-input">'+
			'	</div>'+
			'</div>'+
			'<div class="layui-inline">'+
			'	<label class="layui-form-label" >SIM卡号</label>'+
			'	 <div class="layui-input-inline">'+
		   	'		<input type="text" name="" lay-verify="required" placeholder="可更改" class="layui-input">'+
			'	</div>'+
			'</div>'+
		' </div> ');
		
		 $(".more .layui-form-item").last().append('<a class="shan" style="display:none"><font size="6">×</font></a>').siblings('.layui-form-item').children(".shan").remove();
		})
		//鼠标放上显示隐藏 和删除
			$("body").on("mouseenter",".layui-form-item",function(){
				$(this).children(".shan").show();
			}).on("mouseleave",".layui-form-item",function(){
				$(this).children(".shan").hide();
			});
			$("body").on("click",".shan",function(){
				$(this).parent(".dingwei").remove();
				$(".more .layui-form-item:not(:first)").last().append('<a class="shan" style="display:none"><font size="6">×</font></a>');
				
			});
	</script>
   
</body> 
</html>
<% 
if(db!=null)db.close();db=null;if(server!=null)server=null;%>