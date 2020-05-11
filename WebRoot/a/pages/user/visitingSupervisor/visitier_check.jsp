<%@ page trimDirectiveWhitespaces="true" %>
<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@ include file="../../cookie.jsp"%>
<%
		
		
		//获取session 用户信息     UserEntity user = (UserEntity)session.getAttribute("UserList"); roleid=user.getRoleid();
		
		String roleid=Sroleid;//用户角色id  直接获取cookie 的值
		String orderid = request.getParameter("orderid"); if(orderid==null){orderid="0";}
		String nodeid = request.getParameter("nodeid");if(nodeid==null){nodeid="0";}
		String process = request.getParameter("process");if(process==null){process="0";}
		System.out.println("nodeid===="+nodeid);
		System.out.println("process===="+process);
		
		//查询用户所有的表单
		String user_from="SELECT form_name.datafrom as datafrom,role_from.code as code  FROM role_from LEFT JOIN form_name ON role_from.fromid=form_name.id WHERE  role_from.roleid='"+roleid+"'  ORDER BY role_from.code DESC ;";
		ResultSet from_rs= db.executeQuery(user_from);
		
		while(from_rs.next()){
		
				from_rs.getString("datafrom");//表单名
				from_rs.getString("code");//表单权限
				
		
		}if(from_rs!=null){from_rs.close();}
		
       	ArrayList<String> list = new ArrayList<String>();
	
%> 
    <meta charset="utf-8"> 
    <meta name="viewport" content="width=device-width, initial-scale=1"> 
    <script src="../../js/layui/layui.js"></script>
    <link rel="stylesheet" href="../../js/layui/css/layui.css">
     <link rel="stylesheet" href="../../css/sy_style.css?22">
 
    <title>家访主管已完成查询详情页面</title> 
  <style>
  .layui-colla-title{text-align:center;}
  	.layui-colla-icon{ top:0;font-size:14px;margin-left:10px;position:initial;}
  	.layui-form-item{width:900px;margin:0 auto}
  	h4{text-align:center;margin-bottom:20px}
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
	  
	  
	  <!-- 
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
	   -->
	  <form action="">
	  <%
			        		String id = request.getParameter("orderid");
			          		String vist_sql = "select t.* from f_visiting_supervisor t  where 1=1 and  t.orderid = "+id;
			          		ResultSet vist = db.executeQuery(vist_sql);
			          		int i = 1;
			          		while(vist.next()){
			         %>
			         <div class="layui-form-item layui-form-text marbo"  style="margin-bottom: 30px;">
						<label class="layui-form-label">家访主管意见</label>
						 <div class="layui-input-block">
				   			<textarea name="proposal" id="proposal"  class="layui-textarea mar_20"   readonly="readonly"><%=vist.getString("proposal")%></textarea>
						</div>
					</div> 
					 <div class="layui-form-item layui-form-text marbo" >
						<label class="layui-form-label">备注</label>
						 <div class="layui-input-block">
				   			<textarea name="remarks" id="remarks" class="layui-textarea mar_20"  readonly="readonly"><%=vist.getString("remarks")%></textarea>
						</div>
					</div>  
	 <div class="layui-form-item mar_20" style="text-align:center;">
	</div>  
	<%i++;} %>
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
if(db!=null)db.close();db=null;if(server!=null)server=null;%>