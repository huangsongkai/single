<%@ page trimDirectiveWhitespaces="true" %>
<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%String msg=request.getParameter("msg"); if(msg==null){msg="";} %>
<!DOCTYPE html> 
<html lang="zh_CN"> 
<head> 
    <meta charset="utf-8"> 
    <meta name="viewport" content="width=device-width, initial-scale=1"> 
    <title>出错信息</title> 
    <link href="../../css/base.css" rel="stylesheet">
    <link rel="stylesheet" href="../../../custom/easyui/easyui.css">
    <link href="../../css/basic_info.css" rel="stylesheet">
    
       <script type="text/javascript" src="../../../custom/jquery.min.js"></script>
    <script type="text/javascript" src="../../../custom/jquery.easyui.min.js"></script>
      <script src="../../js/layer/layer.js"></script>
    <script src="../../js/layui/layui.js"></script>
     <link rel="stylesheet" href="../../js/layui/css/layui.css">
</head> 
<body>
<style>
.container {
  position: relative;
  padding-left: 10px;
  position: relative;

}</style>



 


	<div class="container">
	 
		<div class="content">
			<div class="easyui-tabs1" style="width:100%;">
			
		      <div title="错误提示信息" data-options="closable:false" class="basic-info">
		      	
			 
				<div class="column"><span class="current">错误详情</span></div>
		      	<table class="kv-table">
					 
				</table>
		         <table align="center" class="kv-table yes-not">
					<tbody>
						<tr>
							<td class="kv-label"><font  color="#FF0000" size="+4"><%=msg %><a href="javascript: history.go(-1)">返回上一步</a>,<a href="../../">或重新登录</a>.</font></td>
						</tr>
					</tbody>
				</table>

		      </div>
		   
		      
		       
		    </div>
		</div>
	</div>
	
</body> 
</html>
 
<script type="text/javascript">
	$('.easyui-tabs1').tabs({
      tabHeight: 36
    });
    $(window).resize(function(){
    	$('.easyui-tabs1').tabs("resize");
    }).resize();
</script> 