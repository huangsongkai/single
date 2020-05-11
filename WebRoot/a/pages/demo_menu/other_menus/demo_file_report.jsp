<%@ page trimDirectiveWhitespaces="true" %>
<%@ page contentType="text/html; charset=UTF-8" language="java"%>

<%@ include file="../../cookie.jsp"%>
<head> 
    <meta charset="utf-8"> 
    <meta name="viewport" content="width=device-width, initial-scale=1"> 
   
    <script src="../../js/umeditor/third-party/jquery.min.js"></script>
   <script src="../../js/layui/layui.js"></script>
    <link rel="stylesheet" href="../../js/layui/css/layui.css">
     <link rel="stylesheet" href="../../css/sy_style.css?22">
    <title>供应商报件</title> 
 </head> 
<body>
    <div class="container">   
  		<h5 class="right_top">新车报价</h5>
  		<form class="lang_form layui-form">
    		<h4>一、基本信息</h4>
    		
    		<div class="layui-form-item">
			    <div class="layui-inline">
			      <label class="layui-form-label">业务员</label>
			      <div class="layui-input-inline">
			        <input type="text" required lay-verify="required" class="layui-input">
			      </div>
			    </div>
			    <div class="layui-inline">
			      <label class="layui-form-label">经销商</label>
			    <div class="layui-input-inline">
			      <select name="distribution" lay-verify="required">
			        <option value="">性别</option>
			        <option value="男" selected="">男</option>
			        <option value="女">女</option>
			      </select>
			    </div>
			    </div>
			    <div class="layui-inline">
			      <label class="layui-form-label">政策类型</label>
			      <div class="layui-input-inline">
			        <select name="policy" lay-verify="required">
			        <option value="">性别</option>
			        <option value="男" selected="">男</option>
			        <option value="女">女</option>
			      </select>
			      </div>
			    </div>
			    <div class="layui-inline">
			      <label class="layui-form-label">银行</label>
			      <div class="layui-input-inline">
			       <select name="bank" lay-verify="required">
			        <option value="">性别</option>
			        <option value="男" selected="">男</option>
			        <option value="女">女</option>
			      </select>
			      </div>
			    </div>
		  </div>
    		<div class="layui-form-item">
			    <div class="layui-inline">
			      <label class="layui-form-label">姓名</label>
			      <div class="layui-input-inline">
			        <input type="tel" required lay-verify="required" class="layui-input">
			      </div>
			    </div>
			    <div class="layui-inline">
			      <label class="layui-form-label">性别</label>
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
			      <label class="layui-form-label">出生年月</label>
			      <div class="layui-input-inline">
			      	<input type="text" name="phone" id="date" required lay-verify="date" placeholder="2000-01-01" autocomplete="off" class="layui-input" onclick="layui.laydate({elem: this})">
			      </div>
			    </div>
		  </div>
		  <div class="layui-form-item">
			    <div class="layui-inline">
			      <label class="layui-form-label">行业</label>
			      <div class="layui-input-inline">
			        <input type="tel" required lay-verify="required" class="layui-input">
			      </div>
			    </div>
			    <div class="layui-inline">
			      <label class="layui-form-label">家庭住址</label>
			      <div class="layui-input-inline">
			        <input type="text" name="" required lay-verify="required" class="layui-input">
			      </div>
			    </div>
			    <div class="layui-inline">
			      <label class="layui-form-label">联系方式</label>
			      <div class="layui-input-inline">
			        <input type="text" name="" required lay-verify="required" class="layui-input">
			      </div>
			    </div>
			    <div class="layui-inline">
			      <label class="layui-form-label">所购车型</label>
			      <div class="layui-input-inline"  >
			        <input type="text" name="" required lay-verify="required" class="layui-input">
			      </div>
			    </div>
		  </div>
		   <div class="layui-form-item">
			    <div class="layui-inline">
			      <label class="layui-form-label">报件车型</label>
			      <div class="layui-input-inline">
			        <select name="models" lay-verify="required" lay-filter="carx">
			         <option value="二手车" selected="">二手车</option>
				        <option value="新车" >新车</option>
				       
				      </select>
			      </div>
			    </div>
			    <div class="layui-inline">
			      <label class="layui-form-label">征信等级</label>
			      <div class="layui-input-inline">
			        	<select name="grade" lay-verify="required">
				        	<option value="优" selected="">优</option>
				        	<option value="良">良</option>
				           <option value="中">中</option>
				          <option value="差">差</option>
				      </select>
			      </div>
			    </div> 
			    <div class="layui-inline">
			      <label class="layui-form-label">垫款</label>
			      <div class="layui-input-inline"  >
			        <input type="text" name="" required lay-verify="required" class="layui-input">
			      </div>
			    </div>
		  </div>
		  <div class="newcar">
		  <div class="layui-form-item ">
			    <div class="layui-inline">
			      <label class="layui-form-label">评估类型</label>
			      <div class="layui-input-inline">
			        <select name="evaluation" lay-verify="required">
				        <option value="预评" selected="">预评</option>
				        <option value="直评">直评</option>
				     	<option value="试单">试单</option>
				      </select>
			      </div>
			    </div>
			    <div class="layui-inline">
			      <label class="layui-form-label">家访类型</label>
			      <div class="layui-input-inline">
			       <select name="visits2" lay-verify="required">
				        <option value="电核" selected="">电核</option>
				        <option value="家访">家访</option>
				     
				      </select>
			      </div>
			    </div> 
			    <div class="layui-inline">
			      <label class="layui-form-label">预评估价</label>
			      <div class="layui-input-inline">
			        <input type="text" name="" required lay-verify="required" class="layui-input">
			      </div>
			    </div>
			    <div class="layui-inline">
			      <label class="layui-form-label">贷款类型</label>
			      <div class="layui-input-inline">
			        <select name="loantype" lay-verify="required">
			         <option value="反贷" selected="">家访</option>
				        <option value="交易" >电核</option>
				      </select>
			      </div>
			    </div>
			      </div>
			   <div class="layui-form-item ">
			    <div class="layui-inline">
			      <label class="layui-form-label">征信等级</label>
			      <div class="layui-input-inline">
			        <input type="text" name="" required lay-verify="required" class="layui-input">
			      </div>
			    </div>
			
		  </div>
		   
		  </div>
		   <div class="oldcar">
		  <div class="layui-form-item ">
			    <div class="layui-inline">
			      <label class="layui-form-label">发票价</label>
			      <div class="layui-input-inline">
			        <input type="text" name="" required lay-verify="required" class="layui-input" id="invoice">
			      </div>
			    </div>
			    <div class="layui-inline">
			      <label class="layui-form-label">家访类型</label>
			      <div class="layui-input-inline">
			      <select name="visits1" lay-verify="required">
				        <option value="电核" selected="">电核</option>
				        <option value="家访">家访</option>
				     
				      </select>
			      </div>
			    </div> 
		  </div>
		  <h4>二、缴费明细</h4>
		  <div class="layui-form-item">
			    <div class="layui-inline">
			      <label class="layui-form-label">首付比例</label>
			      <div class="layui-input-inline">
			        <input type="text" class="layui-input all" id="payment">
			      </div>
			    </div>
			    <div class="layui-inline">
			      <label class="layui-form-label">上融贷款额</label>
			      <div class="layui-input-inline">
			        <input type="text" name="" readonly="readonly" class="layui-input all">
			      </div>
			    </div>
			    <div class="layui-inline">
			      <label class="layui-form-label">实际贷款额</label>
			      <div class="layui-input-inline">
			       <input type="text" name="" readonly="readonly" class="layui-input all">
			      </div>
			    </div>
			    <div class="layui-inline">
			      <label class="layui-form-label">月还金额</label>
			      <div class="layui-input-inline" >
			       <input type="text" name="" readonly="readonly" class="layui-input all">
			      </div>
			    </div>
			 </div>
			 <div class="layui-form-item">
			    <div class="layui-inline">
			      <label class="layui-form-label">担保费</label>
			      <div class="layui-input-inline" >
			       <input type="text" name="" readonly="readonly" class="layui-input all">
			      </div>
			    </div>
			    <div class="layui-inline">
			      <label class="layui-form-label">履约还款保证金</label>
			      <div class="layui-input-inline" >
			       <input type="text" name="" readonly="readonly"  class="layui-input all">
			      </div>
			    </div>
			     <div class="layui-inline">
			      <label class="layui-form-label">综合服务费</label>
			      <div class="layui-input-inline" >
			       <input type="text" name="" readonly="readonly" class="layui-input all">
			      </div>
			    </div>
			     <div class="layui-inline">
			      <label class="layui-form-label">服务费</label>
			      <div class="layui-input-inline" >
			       <input type="text" name="" readonly="readonly" class="layui-input all">
			      </div>
			    </div>
		  </div>
		  <div class="layui-form-item">
			    <div class="layui-inline">
			      <label class="layui-form-label">代收</label>
			      <div class="layui-input-inline" >
			       <input type="text" name="" class="layui-input">
			      </div>
			    </div>
			    <div class="layui-inline">
			      <label class="layui-form-label">二级返利</label>
			      <div class="layui-input-inline" >
			       <input type="text" name="" readonly="readonly"  class="layui-input all">
			      </div>
			    </div>
			     <div class="layui-inline">
			      <label class="layui-form-label">收入</label>
			      <div class="layui-input-inline" >
			       <input type="text" name="" readonly="readonly" class="layui-input all">
			      </div>
			    </div>
			     <div class="layui-inline">
			      <label class="layui-form-label">合计</label>
			      <div class="layui-input-inline" >
			       <input type="text" name="" readonly="readonly" class="layui-input all">
			      </div>
			    </div>
		  </div>
		   </div>
		   <h4>三、备注</h4>
		   <div class="layui-form-item">
		  <div class="layui-block">
			      <label class="layui-form-label file">征信报告</label>
		  	<div class="layui-box layui-upload-button file"><input type="file" name="file1" lay-type="file" class="layui-upload-file"><span class="layui-upload-icon"><i class="layui-icon"></i>上传文件</span></div>
		 	</div>
		  </div>
		  <div class="layui-form-item">
		    <div class="layui-input-block" style="text-align:center;margin-left:0">
		      <button class="layui-btn layui-btn-danger" lay-submit lay-filter="*" style="">提交</button>
		    </div>
		  </div>
    	</form>
    
    </div>   
    
    <script type="text/javascript">  
    layui.use(['form', 'layedit', 'laydate'], function(){
		  var form = layui.form()
		  ,layer = layui.layer
		  ,layedit = layui.layedit
		  ,laydate = layui.laydate;
		  form.on('select(carx)', function(data){
			  if(data.value=="二手车"){
			  	$(".newcar").show();
			  	$(".oldcar").hide();
			 }else{
			   $(".oldcar").show();
			  	$(".newcar").hide();
			 }
			});
			form.render(); 
	});

	
	$("#invoice").blur(function(){
		if($(this).val()==""){
			$(".all").val('');
		}else{
			$(".all").val('2');
		}
	})
	
	$("#payment").blur(function(){
		if($(this)!=""){
			$(".all").val('3');
		}
	})
      </script>
</body> 
</html>
