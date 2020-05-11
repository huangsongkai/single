<%@ page trimDirectiveWhitespaces="true" %>
<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@include file="../../cookie.jsp"%>

<%
		
		
		//获取session 用户信息     UserEntity user = (UserEntity)session.getAttribute("UserList"); roleid=user.getRoleid();
		
		String roleid=Sroleid;//用户角色id  直接获取cookie 的值
		String orderid = request.getParameter("orderid"); if(orderid==null){orderid="0";}
		String nodeid = request.getParameter("nodeid");if(nodeid==null){nodeid="0";}
		String process = request.getParameter("process");if(process==null){process="0";}
		
		//查询用户所有的表单
		String user_from="SELECT form_name.datafrom as datafrom,role_from.code as code  FROM role_from LEFT JOIN form_name ON role_from.fromid=form_name.id WHERE  role_from.roleid='"+roleid+"'  ORDER BY role_from.code DESC ;";
		ResultSet from_rs= db.executeQuery(user_from);
		
		while(from_rs.next()){
		
				from_rs.getString("datafrom");//表单名
				from_rs.getString("code");//表单权限
				
		
		}if(from_rs!=null){from_rs.close();}
		
       	ArrayList<String> list = new ArrayList<String>();
	
%>
<head> 
    <meta charset="utf-8"> 
    <meta name="viewport" content="width=device-width, initial-scale=1"> 
    <script type="text/javascript" src="../../../custom/jquery.min.js"></script>
    <script src="../../js/ajaxs.js"></script>
    <link rel="stylesheet" href="../../js/layui/css/layui.css"  media="all">
    <script src="../../../pages/js/layui/layui.js"></script>
    <script src="../../js/layui/layui.js"></script>
     <link rel="stylesheet" href="../../css/sy_style.css?22">
 
    <title>档案列表</title> 
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
	  
	  
	  
	  
	  
	  <div class="layui-form-item layui-form-text marbo" >
		<label class="layui-form-label">备注</label>
		 <div class="layui-input-block">
   			<textarea name="common" id="hhh" placeholder="请输入备注" class="layui-textarea mar_20"></textarea>
		</div>
	</div>  
	 <div class="layui-form-item mar_20 ab" style="text-align:center;">
		<button class="layui-btn" onclick="agree('<%=orderid %>','<%=nodeid %>','<%=process %>')">确认归档</button>
		<button class="layui-btn layui-btn-warm" onclick="assessment()">重置</button>
	</div>  
	</div>		 
	<script>
		//注意：折叠面板 依赖 element 模块，否则无法进行功能性操作
		layui.use(['element','layer'], function(){
		  var element = layui.element;
		  var layer = layui.layer;
		
		});
		
		function assessment(){
		
			layer.msg("重置成功!");
			
		}
		
		function agree(orderid,nodeid,process){
				
				var sha = $("#hhh").val();
	    		var str = {"placeid":orderid,"process":process,"nodeid":nodeid,"status":"6","common":sha};
	    		//json字符串
	    		var obj = JSON.stringify(str)
	    		var ret_str=PostAjx('<%=apiurl%>',obj,'<%=Suid%>','<%=Spc_token%>');
	    		var obj = JSON.parse(ret_str);
	    		if(obj.success && obj.resultCode=="1000"){
	    			 layer.msg('提交成功',{icon:1,time:1000},function(){
	    			 window.parent.location.reload();
		             var index = parent.layer.getFrameIndex(window.name); 
					 parent.layer.close(index);
		            });
	    			 
	    		}else{
	    			layer.msg("提交失败");
	    		}
		}
		
	</script>
   
</body> 
</html>
<% 
if(db!=null)db.close();db=null;if(server!=null)server=null;%>