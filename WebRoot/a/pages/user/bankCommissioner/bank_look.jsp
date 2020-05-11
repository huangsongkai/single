<%@ page trimDirectiveWhitespaces="true" %>
<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@page import="v1.haocheok.enums.ProcessCode"%>
<%@page import="service.util.tool.StringUtil"%>
<%@page import="com.alibaba.fastjson.JSONObject"%>
<%@include file="../../cookie.jsp"%>

<%
		
		
		//获取session 用户信息     UserEntity user = (UserEntity)session.getAttribute("UserList"); roleid=user.getRoleid();
		
		String roleid=Sroleid;//用户角色id  直接获取cookie 的值
		String orderid = request.getParameter("orderid"); if(orderid==null){orderid="0";}
		String nodeid = request.getParameter("nodeid");if(nodeid==null){nodeid="0";}
		String process = request.getParameter("process");if(process==null){process="0";}
		
		//查询用户所有的表单
		String user_from1="SELECT form_name.datafrom as datafrom,role_from.code as code  FROM role_from LEFT JOIN form_name ON role_from.fromid=form_name.id WHERE  role_from.roleid='"+roleid+"'  ORDER BY role_from.code DESC ;";
		ResultSet from_rs= db.executeQuery(user_from1);
		
		while(from_rs.next()){
		
				from_rs.getString("datafrom");//表单名
				from_rs.getString("code");//表单权限
				
		
		}if(from_rs!=null){from_rs.close();}
		
       	ArrayList<String> list = new ArrayList<String>();
       	
       	//赋值内容：
       	String sql = "select remarks from f_bank_industry where orderid='"+orderid+"'";
       	ResultSet base = db.executeQuery(sql);
       	String remarks = "";
       	if(base.next()){
       		remarks = base.getString("remarks");
       	}
	
%>
<head> 
    <meta charset="utf-8"> 
    <meta name="viewport" content="width=device-width, initial-scale=1"> 
    <script type="text/javascript" src="../../../custom/jquery.min.js"></script>
    <script src="../../js/ajaxs.js"></script>
    <script src="../../js/layui2/layui.js"></script>
    <link rel="stylesheet" href="../../js/layui2/css/layui.css">
     <link rel="stylesheet" href="../../css/sy_style.css?22">
 
    <title>银行专员内业任务编辑页面</title> 
  <style>
  .layui-colla-title{text-align:center;}
  	.layui-colla-icon{ top:0;font-size:14px;margin-left:10px;position:initial;}
  	.layui-form-item{width:960px;margin:0 auto}
  	h4{text-align:center;margin-bottom:20px}
  	.layui-collapse{border:none;height:100%;}
  	.layui-btn-danger{margin:0;padding:0 18px;}
	.layui-collapse .ab{position:fixed; bottom:0;width:100%;height:50px;background:rgba(255,255,255,0.8);padding-top:10px;border-top:1px solid #ccc}
	.marbo{margin-bottom:80px}
	.layui-form-label{width:90px;}
  </style>
 </head> 
<body>
<div class="layui-collapse" lay-accordion>
	  <!-- 引入公共页面， {客户信息，订单基本信息，}-->
	<%request.setCharacterEncoding("utf-8");%>
	  <jsp:include page="../common/customerBasic.jsp">
	    <jsp:param value="<%=orderid%>" name="orderid"/><!-- 订单id， -->
	  </jsp:include>
	<!-- 引入公共页面, 继承查看表单信息--> 
	  <jsp:include page="../common/inheritanceForm.jsp">
	    <jsp:param value="<%=orderid%>" name="orderid"/><!-- 订单id， -->
	    <jsp:param value="<%=roleid%>" name="roleid"/>  <!-- 角色id， -->
	  </jsp:include>
	  
	<form class="layui-form" action="?ac=post&nodeid=<%=nodeid %>&process=<%=process %>&orderid=<%=orderid %>" method="post">
		<div class="layui-form-item layui-form-text marbo" >
			<label class="layui-form-label">备注</label>
			<div class="layui-input-block">
				<textarea name="remarks"  placeholder="请输入备注" class="layui-textarea mar_20" readonly><%=remarks %></textarea>
			</div>
		</div>  
		<!-- jsontemplate 数据 -->
		<input type="hidden" name="jsontemplate" id="jsontemplate" value="" />
		<div class="layui-form-item mar_20 ab" style="text-align:center;">
			<button class="layui-btn layui-btn-normal" type="button" onclick="withdraw('<%=orderid %>','<%=nodeid %>','<%=process %>')">撤回</button>
			
		</div>
	</form>
	
	
	
	   
	</div>		 
	<script>
		//撤回功能
		function withdraw(orderid,nodeid,process){
    		var str = {"placeid":orderid,"process":process,"nodeid":nodeid,"status":"<%=ProcessCode.Withdraw.getReasonPhrase() %>","common":""};
    		//json字符串
    		var obj = JSON.stringify(str)
    		var ret_str=PostAjx('<%=apiurl%>',obj,'<%=Suid%>','<%=Spc_token%>');
    		var obj = JSON.parse(ret_str);
    		if(obj.success && obj.resultCode=="1000"){
    			successMsg("撤回成功");	    			 
    		}else{
    			errorMsg("下级已经接单,不能撤回!");
    		}

		}


	
		//驳回 功能
		function Reject(orderid,nodeid,process){
				
				var sha = $("#hhh").val();
	    		var str = {"placeid":orderid,"process":process,"nodeid":nodeid,"status":"<%=ProcessCode.Reject.getReasonPhrase() %>","common":sha};
	    		//json字符串
	    		var obj = JSON.stringify(str)
	    		var ret_str=PostAjx('../../../../Api/v1/?p=web/amdin/doreject',obj,'<%=Suid%>','<%=Spc_token%>');
	    		var obj = JSON.parse(ret_str);
	    		if(obj.success && obj.resultCode=="1000"){
	    			successMsg("驳回成功");	    			 
	    		}else{
	    			errorMsg("驳回失败");
	    		}
		}

		//提交成功提示
		function successMsg(msg){
			layer.msg(msg,{icon:1,time:1000},function(){
    			 window.parent.location.reload();
	             var index = parent.layer.getFrameIndex(window.name); 
				 parent.layer.close(index);
            });
		}

		//提示失败提示
		function errorMsg(msg){
			layer.msg(msg);
   			window.parent.location.reload();
            var index = parent.layer.getFrameIndex(window.name); 
			parent.layer.close(index);
		}

		
		//注意：折叠面板 依赖 element 模块，否则无法进行功能性操作
		layui.use(['element','form','layer'], function(){
			var element = layui.element;
			var layer = layui.layer;
			var form    = layui.form;
			//监听表单提交（同意）
			form.on('submit(formDemo)', function(data){
				console.log(data);
			    //layer.msg(JSON.stringify(data.field));
			    console.log(JSON.stringify(data.field));
			    $("#jsontemplate").val(JSON.stringify(data.field));
			    return true;
			});
			//同意 功能
			function agree(orderid,nodeid,process,common){
					
		    		var str = {"placeid":orderid,"process":process,"nodeid":nodeid,"status":"6","common":common};
		    		//json字符串
		    		var obj = JSON.stringify(str)
		    		var ret_str=PostAjx('<%=apiurl%>',obj,'<%=Suid%>','<%=Spc_token%>');
		    		var obj = JSON.parse(ret_str);
		    		if(obj.success && obj.resultCode=="1000"){
		    			successMsg("同意成功");
		    		}else{
		    			errorMsg("同意失败");
		    		}
			}

		});

		


		
	</script>
   
</body> 
</html>
<% 
if(db!=null)db.close();db=null;if(server!=null)server=null;%>