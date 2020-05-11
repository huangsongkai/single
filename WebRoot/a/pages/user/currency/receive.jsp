<%@ page trimDirectiveWhitespaces="true" %>
<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@page import="service.dao.db.Page"%>

<%@include file="../../cookie.jsp"%>

<%
		
		
		//获取session 用户信息     UserEntity user = (UserEntity)session.getAttribute("UserList"); roleid=user.getRoleid();
		
		String roleid=Sroleid;//用户角色id  直接获取cookie 的值
		String orderid = request.getParameter("orderid"); if(orderid==null){orderid="0";}
		
		//查询用户所有的表单
		String user_from="SELECT form_name.datafrom as datafrom,role_from.code as code  FROM role_from LEFT JOIN form_name ON role_from.fromid=form_name.id WHERE  role_from.roleid='"+roleid+"'  ORDER BY role_from.code DESC ;";
		ResultSet from_rs= db.executeQuery(user_from);
		
		while(from_rs.next()){
		
				from_rs.getString("datafrom");//表单名
				from_rs.getString("code");//表单权限
				
		
		}if(from_rs!=null){from_rs.close();}
		
       	ArrayList<String> list = new ArrayList<String>();
	
%>
<html>
<head> 
    <meta charset="utf-8"> 
    <meta name="viewport" content="width=device-width, initial-scale=1"> 
    <script src="../../js/layui/layui.js"></script>
    <link rel="stylesheet" href="../../js/layui/css/layui.css">
     <link rel="stylesheet" href="../../css/sy_style.css?22">
 
    <title>档案列表</title> 
  <style>
  .layui-colla-title{text-align:center;}
  	.layui-colla-icon{ top:0;font-size:14px;margin-left:10px;position:initial;}
  	.layui-form-item{width:900px;margin:0 auto}
  	h4{text-align:center;margin-bottom:20px}
  </style>
</head> 
<body>
<div class="layui-collapse" >

	<!-- 引入公共页面， {客户信息，订单基本信息，}-->
	<%request.setCharacterEncoding("utf-8");%>
	  <jsp:include page="aa.jsp">
	    <jsp:param value="<%=orderid%>" name="orderid"/><!-- 订单id， -->
	  </jsp:include>
	<!-- 引入公共页面, 继承查看表单信息--> 
	  <jsp:include page="bb.jsp">
	    <jsp:param value="<%=orderid%>" name="orderid"/><!-- 订单id， -->
	    <jsp:param value="<%=roleid%>" name="roleid"/>  <!-- 角色id， -->
	  </jsp:include>
	  
	<!--用户可编辑表单-->  
	<form> 
		<div class="layui-form-item mar_20" style="text-align:center;">
			<button class="layui-btn">同意</button>
			<button class="layui-btn layui-btn-primary">拒单</button>
		</div>  
	</form>
	</div>		 
	<script>
		//注意：折叠面板 依赖 element 模块，否则无法进行功能性操作
		layui.use(['element', 'layer'], function(){
		  var element = layui.element
		  ,layer = layui.layer;
		
		});
		
		
		//附件弹出展示
		
		function open_file(url){
			layer.open({
			  type: 2, 
			  //这里content是一个URL，如果你不想让iframe出现滚动条，你还可以content: ['http://sentsin.com', 'no']
			  //content: 'http://sentsin.com' 
			  content: [url, 'no']  
			}); 
		}
		
		
		/*function bigImg(x){
			layer.msg('点击查看大图', {
			  icon: 1,
			  time: 300 //8毫秒关闭（如果不配置，默认是3秒）
			}, function(){
			  //do something
			});
			 
		}
		
		function normalImg(x){
			x.style.width="50px";
		}
	*/
	</script>
   
</body> 
</html>



<% if(db!=null)db.close();db=null;if(server!=null)server=null; %>