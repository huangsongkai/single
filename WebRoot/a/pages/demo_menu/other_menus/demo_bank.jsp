<%@ page trimDirectiveWhitespaces="true" %>
<%@ page contentType="text/html; charset=UTF-8" language="java"%>

<html>
	<head> 
	    <meta charset="utf-8"> 
	    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
		<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
		<meta name="apple-mobile-web-app-status-bar-style" content="black">
		<meta name="apple-mobile-web-app-capable" content="yes">
		<meta name="format-detection" content="telephone=no">
	    <link rel="stylesheet" href="../../../pages/css/sy_style.css?22">	    
	    <link rel="stylesheet" href="../../js/layui/css/layui.css">
		<script type="text/javascript" src="../../js/jquery-1.9.1.js" ></script><!--通用jquery-->
		<script src="../../js/layui/layui.js"></script>
		<script type="text/javascript" src="../../js/tableExport/js/table-sort.js" ></script><!--表格排序js  css-->
		<script type="text/javascript" chartset="utf8" src="../../js/tableExport/js/table_list.js " ></script><!--表格导出js  css--> <script src="../../js/ajaxs.js"></script>
	 
	    <title>银行放款表单</title> 
	    <style type="text/css">
			th {
		      background-color: white;
		    }
		    td {
		      background-color: white;
		    }
		    .test{width: 110px}
		    .btn-group-vertical>.btn, .btn-group>.btn{height:33px;}
		</style>
 	</head> 
	<body>
	    <div class="" style="padding-bottom: 0px;margin-left: 1%;margin-right: 1%; height:auto;">  
			<div id="tb" class="form_top layui-form" style="width:100%">
				<div style="text-align: center;text-align: center;margin-top: 20px;margin-bottom: 50px;">	
		        <button class="layui-btn layui-btn-small  layui-btn-primary" style=" width: 172px; height: 42px;margin-right: 30px;margin-left: 30px;" onclick="allShow()">  资料齐全</button>
		        <button class="layui-btn layui-btn-small layui-btn-primary" style=" width: 172px; height: 42px;margin-right: 30px;margin-left: 30px;"  onclick="someShow()">资料不齐全</button>
		    	</div>
		    </div>
		  </div>
		  <!-- 资料齐全 -->
		  <div id="qiquan">
		  		<form id="qiquanForm">
		  		<div class="layui-form-item" style="width:100%">
						    <div class="layui-inline" style="width:30%">
						      <label class="layui-form-label" style="width:30%">放款金额</label>
						      <div class="layui-input-inline">
						        <input type="text" readonly="readonly" class="layui-input" value="">	
						      </div>
						    </div>
						    <div class="layui-inline" style="width:30%">
						      <label class="layui-form-label test" style="width:40%">确认放款金额</label>
						    <div class="layui-input-inline" style="margin-top: 5px;">
						       <input type="radio" name="loanStatus" value="0">已确认 &nbsp;&nbsp;
      						   <input type="radio" name="loanStatus"  value="1" checked="checked">未确认
						    </div>
						    </div>
						      <div class="layui-inline" style="width:30%">
						    <div class="layui-input-inline" style="margin-top: 5px;">
						    	<p style="color:red">开始时间:1小时26分30秒</p>
						    </div>
						    </div>
					  </div>
					  <div class="layui-form-item"  style="width:100%">
						    <div class="layui-inline" style="width:30%">
						      <label class="layui-form-label" style="width:30%">放款时间</label>
						      <div class="layui-input-inline">
						        <input type="text"  id=""  name="loanTime"  class="layui-input" value="" placeholder="请填写">
						      </div>
						    </div>
						    <div class="layui-inline" style="width: 30%">
						      <label class="layui-form-label" style="width:40%">上传附件</label>
						    <div class="layui-input-inline">
						    		<button 	class="layui-btn layui-btn-primary"> 请上传</button>
						    </div>
						    </div>
					  </div>
		  		<div class="layui-form-item layui-form-text marbo" >
					<label class="layui-form-label" >备注</label>
					 <div class="layui-input-block"  style="width: 80%;"> 
			   			<textarea name="common" id="hhh" placeholder="请输入备注" class="layui-textarea mar_20" ></textarea>
					</div>
				</div> 
				<div class="layui-form-item"  style="width:100%">
				  <div class="layui-input-inline" style="text-align: center;width: 100%;">
				    		<!--<button 	class="layui-btn layui-btn-primary" style="width: 128px;" name="sbumitForm" disabled="disabled"  > 提&nbsp;&nbsp;交</button>-->
				  			<input type="button"  class="layui-btn layui-btn-primary" style="width: 128px;" disabled="disabled"  name="sbumitForm" id='formSubmit()' value=" 提&nbsp;&nbsp;交">
				    </div>
				    </div>
				 </form>
		  </div>
		  <!-- 资料不齐全 -->
		  <div id="noqiquan">
		  		<form id="noqiquanForm">
				<div class="layui-form-item layui-form-text marbo" >
					<label class="layui-form-label"  style="width: 18%;"><p style="color:red">开始时间:1小时26分30秒</p></label>
				</div> 
		  		<div class="layui-form-item layui-form-text marbo" >
					<label class="layui-form-label" >备注</label>
					 <div class="layui-input-block"  style="width: 80%;"> 
			   			<textarea name="common" id="hhh" placeholder="请输入备注" class="layui-textarea mar_20" ></textarea>
					</div>
				</div> 
				<div class="layui-form-item"  style="width:100%">
				  <div class="layui-input-inline" style="text-align: center;width: 100%;">
				  			<input type="button"  class="layui-btn layui-btn-primary" style="width: 128px;" disabled="disabled"  name="sbumitForm" onclick="noFormSubmit()" value=" 提&nbsp;&nbsp;交">
				    </div>
				    </div>
				   </form>
		  </div>
		  <script>
		  		$(function(){
		  			$("#qiquan").hide();
		  			$("#noqiquan").hide();
		  			  $(":radio").click(function(){
							if($(this).val()=='0'){//已确认
								$("input[name='sbumitForm']").removeAttr("disabled");
								$("input[name='sbumitForm']").attr("style","width: 128px");
							}
							if($(this).val()=='1'){//未确认
									$("input[name='sbumitForm']").attr("disabled",true);
									$("input[name='sbumitForm']").attr("style","width: 128px;background:#777");
							}
						  });
		  		})
		  		//资料齐全点击事件
		  		function allShow(){
		  			$("#qiquan").show();
		  			$("#noqiquan").hide();
		  			var loanStatus = $("input[name='loanStatus']:checked").val();
		  			if(loanStatus=="0"){
		  				$("input[name='sbumitForm']").removeAttr("disabled");
		  				$("input[name='sbumitForm']").attr("style","width: 128px");
		  			}
		  			if(loanStatus == "1"){
		  				$("input[name='sbumitForm']").attr("disabled",true);
		  				$("input[name='sbumitForm']").attr("style","width: 128px;background:#777");
		  			}
		  		}
		  		//资料不齐全点击事件
		  		function someShow(){
		  			$("#noqiquan").show();
		  			$("#qiquan").hide();
		  			$("input[name='sbumitForm']").removeAttr("disabled");
		  			$("input[name='sbumitForm']").attr("style","width: 128px");
		  		}
		  		//资料齐全表单提交
		  		function formSubmit(){
		  			var data = $("#qiquanForm").serialize();
		  		}
		  		//资料不齐全表单提交
		  		function noFormSubmit(){
		  			var data = $("#noqiquanForm").serialize();
		  		}
		  </script>
	</body> 
</html>


