<%@ page trimDirectiveWhitespaces="true" %>
<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@page import="v1.haocheok.enums.ProcessCode"%>
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
	
%>
<html>
<head> 
    <meta charset="utf-8"> 
    <meta name="viewport" content="width=device-width, initial-scale=1"> 
    <script src="../../js/layui2/layui.js"></script>
    <link rel="stylesheet" href="../../js/layui2/css/layui.css">
    <link rel="stylesheet" href="../../css/sy_style.css?22">
    <script type="text/javascript" src="../../../custom/jquery.min.js"></script>
    <script src="../../js/ajaxs.js"></script>
 
    <title>家访主管任务编辑页面</title> 
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
	  
	  
	  	<!-- 自己需要编辑页面 -->
	  <form class="layui-form" id="subForm" action="?ac=post&nodeid=<%=nodeid %>&process=<%=process %>&orderid=<%=orderid %>" method="post">
	  <!-- 表单信息 -->
	   <h4 >填写表单</h4>
		
	<!-- jsontemplate 数据 -->
	<input type="hidden" name="jsontemplate" value=""  id="jsontemplate"/>
	<!--用户可编辑表单-->  
		<div class="layui-form-item layui-form-text marbo"  style="margin-bottom: 30px;">
			<label class="layui-form-label">家访主管意见</label>
			 <div class="layui-input-block">
	   			<textarea name="proposal" id="proposal" placeholder="写明同意、拒绝或是转入审贷中心的原因" class="layui-textarea mar_20"></textarea>
			</div>
		</div> 
		 <div class="layui-form-item layui-form-text marbo" >
			<label class="layui-form-label">备注</label>
			 <div class="layui-input-block">
	   			<textarea name="remarks" id="remarks" placeholder="请输入备注" class="layui-textarea mar_20"></textarea>
			</div>
		</div>  
	 
		 <div class="layui-form-item mar_20 ab" style="text-align:center;">
			<button class="layui-btn"   lay-submit  lay-filter="formDemo"  >同意</button>
			<button class="layui-btn layui-btn-normal"  onclick="Reject('<%=orderid %>','<%=nodeid %>','<%=process %>')">驳回</button>
			<button class="layui-btn layui-btn-danger">拒单</button>
			<button class="layui-btn layui-btn-warm" onclick="assessment()">转入审贷中心</button>
		</div>  
	</form>
	  	
	  	
	 
	</div>		 
	<script>
		layui.use(['element','form','upload','layer'], function(){
		   var $    = layui.jquery ,
			form    = layui.form,
			 layer   = layui.layer,
			element = layui.element,
			upload = layui.upload;
		    form.render('select');  
			
			//监听表单提交(同意)
			form.on('submit(formDemo)', function(data){
			    $("#jsontemplate").val(JSON.stringify(data.field));
			    return true;
			});
			
			  var uploadPhoto = upload.render({
			    elem: '#Photo' //绑定元素
			    ,url: '/upload/' //上传接口
			    ,done: function(res){
			      //上传完毕回调
			    }
			    ,error: function(){
			      //请求异常回调
			    }
			  });
		
		//开始处理接收表单信息
		<%
			if("post".equals(ac)){
				//收集流程信息
				String nodeid1 = request.getParameter("nodeid");
				String process1 = request.getParameter("process");
				orderid = request.getParameter("orderid");
				
				//收集表单信息
				String proposal = ""; 	//建议
				String remarks = "";		//备注
				String jsontemplate = "";	//jsontemplate
				jsontemplate = request.getParameter("jsontemplate");
				//获取jsontemplate后，去掉jsontemplate 中不需要信息
				if(!"".equals(jsontemplate)){
					System.out.println("jsontemplate======"+jsontemplate);
					Map<String,Object> json =  (Map<String, Object>)JSONObject.parse(jsontemplate);
					json.remove("jsontemplate");
					jsontemplate = json.toString();
				}
				
				proposal = request.getParameter("proposal");
				remarks = request.getParameter("remarks");
			
				
				String insert_sql = "INSERT INTO f_visiting_supervisor "+
																		"	(	orderid,                    "+
																		"		proposal,                 "+
																		"		remarks,                 "+
																		"		createid,                 "+
																		"		createtime,                   "+
																		"		updatetime,                 "+
																		"		updateid,                   "+
																		"		jsontemplate                "+
																		"		)                           "+
																		"		VALUES    (                 "+
																		"		'"+orderid+"',                  "+
																		"		'"+proposal+"',              "+
																		"		'"+remarks+"',                  "+
																		"		'"+Suid+"',                 "+
																		"		now(),               "+
																		"		now(),               "+
																		"		'"+Suid+"',                 "+
																		"		'"+jsontemplate+"'              "+
																		"		);";
				System.out.println("insert_sql====="+insert_sql);
				
			 	boolean state = db.executeUpdate(insert_sql);
				if(state){
					out.println("agree('"+orderid+"','"+nodeid1+"','"+process1+"','"+remarks+"')");
					//out.println("layer.confirm('内业提交完成', {icon: 1, title:'提示'}, function(index){ layer.close(index); parent.location.reload();  });");
				}else{
					out.println("layer.confirm('内业提交失败', {icon: 1, title:'提示'}, function(index){ layer.close(index); parent.location.reload();  });");
				}
			}
		
		%>
		})
	</script>
   	<script type="text/javascript">
   		//同意 功能
		function agree(orderid,nodeid,process,common){
	    		var str = {"placeid":orderid,"process":process,"nodeid":nodeid,"status":"6","common":common};
	    		var obj = JSON.stringify(str)
	    		var ret_str=PostAjx('<%=apiurl%>',obj,'<%=Suid%>','<%=Spc_token%>');
	    		var obj = JSON.parse(ret_str);
   				if(obj.success && obj.resultCode=="1000"){
	    			successMsg("同意成功");
	    		}else{
	    			errorMsg("同意失败");
	    		}
		}
		
		//驳回 功能
		function Reject(orderid,nodeid,process){
				var sha = $("#remarks").val();
	    		var str = {"placeid":orderid,"process":process,"nodeid":nodeid,"status":"<%=ProcessCode.Reject.getReasonPhrase() %>","common":sha};
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
   	</script>
</body> 
</html>
<% 
if(db!=null)db.close();db=null;if(server!=null)server=null;%>