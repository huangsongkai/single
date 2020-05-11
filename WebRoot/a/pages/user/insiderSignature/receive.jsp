<%@page trimDirectiveWhitespaces="true" %>
<%@page contentType="text/html; charset=UTF-8" language="java"%>
<%@page import="service.dao.db.Page"%>
<%@page import="v1.haocheok.commom.common"%>

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
<html>
<head> 
    <meta charset="utf-8"> 
    <meta name="viewport" content="width=device-width, initial-scale=1"> 
    <script src="../../js/layui2/layui.js"></script>
    <link rel="stylesheet" href="../../js/layui2/css/layui.css">
    <link rel="stylesheet" href="../../css/sy_style.css?22">
    <script type="text/javascript" src="../../../custom/jquery.min.js"></script>
    <script src="../../js/ajaxs.js"></script>
 
    <title>编辑页面</title> 
  <style>
	 .layui-colla-title{text-align:center;}
  	.layui-colla-icon{ top:0;font-size:14px;margin-left:10px;position:initial;}
  	.layui-form-item{width:900px;margin:0 auto}
  	.layui-form-item.mar_20{margin-top:20px;}
  	h4{text-align:center;margin-bottom:20px}
  	.layui-collapse{border:none;padding-bottom:20px;}
  	.layui-btn{height:30px;line-height:30px;}
  	.layui-form h4{font-weight:400;}
  	button.upload{width:100%;border:2px dotted #ccc;background:none;color:#ccc}
  	button.upload:hover{color:#ccc}
  </style>
</head> 
<body>
<div class="layui-collapse" >

	<!-- 引入公共页面， {客户信息，订单基本信息，}-->
	<%request.setCharacterEncoding("utf-8");%>
	  <jsp:include page="customerDasicInformation.jsp">
	    <jsp:param value="<%=orderid%>" name="orderid"/><!-- 订单id， -->
	  </jsp:include>
	<!-- 引入公共页面, 继承查看表单信息--> 
	  <jsp:include page="inheritanceLnformation.jsp">
	    <jsp:param value="<%=orderid%>" name="orderid"/><!-- 订单id， -->
	    <jsp:param value="<%=roleid%>" name="roleid"/>  <!-- 角色id， -->
	  </jsp:include>
	<!-- 自己需要编辑页面 -->
	  <form class="layui-form" action="?ac=post&nodeid=<%=nodeid %>&process=<%=process %>" method="post">
	  <!-- 表单信息 -->
	  <input type="hidden" name="orderid" value="<%=orderid %>" />
	   <h4 >填写表单</h4>
	  <div class="layui-form-item layui-form-text" >
	   <div class="layui-inline">
		<label class="layui-form-label">垫款类型</label>
		 <div class="layui-input-inline">
   			<select name="advancetype" lay-filter="interest" lay-verify="required">
		        <option value="">请选择</option>
		     <%
		     	String sql = " SELECT id,liuchengname,priceDescription FROM t_yewumian WHERE  parentid =( SELECT ty.id FROM t_yewumian AS ty,order_sheet AS os WHERE os.processid = ty.id AND os.id="+orderid+")";
		     	System.out.println("sqlllll===="+sql);
		     	ResultSet ba = db.executeQuery(sql);
		     	String priceDescription = "";
		     	while(ba.next()){
		     		out.println("<option value='"+ba.getString("id")+"'>"+ba.getString("liuchengname")+"</option>");
		     		priceDescription = ba.getString("priceDescription");
		     	}
		      %>
		     </select>
		</div>
		</div>
	 </div>  
	 <div class="layui-form-item " >
		 <div class="layui-inline">
			<label class="layui-form-label">填写VIN码</label>
			 <div class="layui-input-inline">
	   			<input type="text" name="vinnum"  value="" class="layui-input">
			</div>
		</div>
		<div class="layui-inline">
			<label class="layui-form-label" style="width:100px;">上传车辆合格证</label>
			 <div class="layui-input-inline">
	   			<div class="layui-upload">
				  <button type="button" class="layui-btn upload" id="Certificate">请上传</button>
				  <input type="hidden" name="vehiclecar" value="" />
				</div>
			</div>
		</div>
		<div class="layui-inline">
		<%
			String order_sql = "select evaluateprice,pricetype,toMakeAdvances from order_sheet where id = '"+orderid+"'";
			ResultSet orderSet = db.executeQuery(order_sql);
			Double evaluateprice = 0.00;
			String pricetype = "";
			Double toMakeAdvances = 0.00;
			if(orderSet.next()){
				pricetype = orderSet.getString("pricetype");
				evaluateprice = orderSet.getDouble("evaluateprice");
				toMakeAdvances = orderSet.getDouble("toMakeAdvances");
			}
			if("0".equals(pricetype)){
		 %>
		 	<label class="layui-form-label" style="width:70px;">发票价</label>
		 	<div class="layui-input-inline">
	   			<input type="text"  value="<%=evaluateprice %>" class="layui-input">
			</div>
			<div class="layui-inline">
				<label class="layui-form-label" style="width:70px;">垫款</label>
				 <div class="layui-input-inline">
		   			<input type="text" name=""  readonly="readonly" value="<%=toMakeAdvances %>" class="layui-input">
				</div>
			</div>
		 <%}else{ %>
			<label class="layui-form-label" style="width:70px;">评估价</label>
			<div class="layui-input-inline">
	   			<input type="text" readonly="readonly" value="<%=evaluateprice %>" class="layui-input">
			</div>
		 <%} %>
		</div>
		
	 </div>  
	 <div class="layui-form-item " >
	 	<div class="layui-inline">
			<label class="layui-form-label">是否减免</label>
			 <div class="layui-input-inline">
		   		<select name="reduction" lay-filter="reduction" >
			        <option value="">请选择</option><!--
			        <option value="0">是</option>
			        <option value="1">否</option>
			        -->
			        <%
			        	//获取数据字典值
			        	Map<String ,String> map = common.getDicMap("reduction");
			        	for(Map.Entry<String,String> entry:map.entrySet()){
			        		out.println("<option value='"+entry.getKey()+"'>"+entry.getValue()+"</option>");
			        	}
			        
			         %>
			     </select>
			</div>
		</div>
		<div class="accounts1 layui-inline" style="display:none;">
			<div class="layui-inline">
				<label class="layui-form-label"  style="width:100px;">减免金额</label>
				 <div class="layui-input-inline">
		   			<input type="text" name="reductionmony" value="" class="layui-input">
				</div>
			</div>
			
			<div class="layui-inline">
				<label class="layui-form-label"  style="width:70px;">上传签字条</label>
				 <div class="layui-input-inline">
		   			<div class="layui-upload">
					  <button type="button" class="layui-btn upload"  id="Signature">请上传</button>
					  <input type="hidden" name="reductionsign" value="" />
					</div>
				</div>
			</div>
		</div>
	 </div>
	 <h4 >二、支付方式</h4>
	  <div class="layui-form-item " >
	 	<div class="layui-inline">
			<label class="layui-form-label">支付方式</label>
			 <div class="layui-input-inline">
		   		<select name="paymentmethod" lay-filter="paymentmethod" >
			        <option value="">请选择</option><!--
			        <option value="0">转账</option>
			        <option value="1">现金</option>
			     -->
			      <%
			      		//获取数据字典值
			        	Map<String ,String> map1 = common.getDicMap("paymentmethod");
			        	for(Map.Entry<String,String> entry:map1.entrySet()){
			        		out.println("<option value='"+entry.getKey()+"'>"+entry.getValue()+"</option>");
			        	}
			        
			         %>
			     </select>
			</div>
		</div>
		<div class="accounts layui-inline" style="display:none;">
		<div class="layui-inline">
			<label class="layui-form-label">账户</label>
			 <div class="layui-input-inline">
	   			<input type="text" name="account"  value="" class="layui-input">
			</div>
		</div>
		<div class="layui-inline">
			<label class="layui-form-label" >开户行</label>
			 <div class="layui-input-inline">
	   			<input type="text" name="bankname" value="" class="layui-input">
			</div>
		</div>
		<div class="layui-inline">
			<label class="layui-form-label" >行户名</label>
			 <div class="layui-input-inline">
	   			<input type="text" name="accountname" value="" class="layui-input">
			</div>
		</div>
		</div>
	 </div>
	 <h4 >三、垫款信息</h4>
	  <div class="layui-form-item " >
	  	<div class="layui-inline">
			<label class="layui-form-label" >垫款电话号码</label>
			 <div class="layui-input-inline">
	   			<input type="text" name="telephone" value="" class="layui-input">
			</div>
		</div>
	  </div>
	   <h4 >四、二手车评估报告</h4>
	 <div class="layui-form-item mar_20" style="text-align:center;">
		<div class="layui-block">
			<label class="layui-form-label" >上传</label>
			 <div class="layui-input-block">
	   			<button type="button" class="layui-btn upload" id="Presentation">请上传二手车评估报告</button>
	   			<input type="hidden" name="report" value="" />
			</div>
		</div>
		<div class="layui-block">
			<label class="layui-form-label" >上传</label>
			 <div class="layui-input-block">
	   			<button type="button" class="layui-btn upload"  id="Photo">上传手持证件的照片</button>
	   			<input type="hidden" name="certificates" value="" />
			</div>
		</div>
		<div class="layui-block">
			<label class="layui-form-label" >备注</label>
			<div class="layui-input-block">
		      <textarea placeholder="请填写" name="remarks" style="height:30px;" class="layui-textarea" ></textarea>
		    </div>
		</div>
	</div> 
	<!--<div class="layui-form-item mar_20" style="text-align:center;">
			<button class="layui-btn" >同意</button>
			<button class="layui-btn layui-btn-primary">拒单</button>
	</div>   
	-->
	<!-- jsontemplate 数据 -->
	<input type="hidden" name="jsontemplate" value="" id="jsontemplate" />
	<!--用户可编辑表单-->  
		<div class="layui-form-item mar_20" style="text-align:center;">
			<button class="layui-btn" lay-submit lay-filter="formDemo">同意</button>
			<button class="layui-btn layui-btn-primary" onclick="asd()">拒单</button>
		</div>  
	</form>
	  
	  
	  
	  
	
</div>		 
	<script>
		//注意：折叠面板 依赖 element 模块，否则无法进行功能性操作
		//layui.use(['element','layer'], function(){
		  //var element = layui.element;
		  //var layer = layui.layer;		
		//});
		//注意：折叠面板 依赖 element 模块，否则无法进行功能性操作
		//注意：折叠面板 依赖 element 模块，否则无法进行功能性操作
		layui.use(['element','form','upload','layer'], function(){
		   var $    = layui.jquery ,
			form    = layui.form,
			layer   = layui.layer,
			element = layui.element,
			upload = layui.upload;
		    form.render('select');  
		    form.on('select(paymentmethod)', function(data){
					if(data.value==0){//新车
						$(".accounts").show();	
					}else{
						$(".accounts").hide();
					}
			}); 
			form.on('select(reduction)', function(data){
					if(data.value==0){//新车
						$(".accounts1").hide();	
					}else{
						$(".accounts1").show();
					}
			}); 
			
			//监听表单提交
			form.on('submit(formDemo)', function(data){
				
			    //layer.msg(JSON.stringify(data.field));
			    console.log(JSON.stringify(data.field));
			    $("#jsontemplate").val(JSON.stringify(data.field));
			    return true;
			});
			
			var uploadCertificate = upload.render({
			    elem: '#Certificate' //绑定元素
			    ,url: '/upload/' //上传接口
			    ,done: function(res){
			      //上传完毕回调
			    }
			    ,error: function(){
			      //请求异常回调
			    }
			  });
			var uploadSignature = upload.render({
			    elem: '#Signature' //绑定元素
			    ,url: '/upload/' //上传接口
			    ,done: function(res){
			      //上传完毕回调
			    }
			    ,error: function(){
			      //请求异常回调
			    }
			  });
			  
			  var uploadPresentation = upload.render({
			    elem: '#Presentation' //绑定元素
			    ,url: '/upload/' //上传接口
			    ,done: function(res){
			      //上传完毕回调
			    }
			    ,error: function(){
			      //请求异常回调
			    }
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
		
		
		
		//调用流程
		function agree(orderid,nodeid,process,common){
				
	    		var str = {"placeid":orderid,"process":process,"nodeid":nodeid,"status":"6","common":common};
	    		//json字符串
	    		var obj = JSON.stringify(str)
	    		var ret_str=PostAjx('../../../../Api/v1/?p=web/amdin/doadopt',obj,'<%=Suid%>','<%=Spc_token%>');
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
		
		function asd(){
		
			layer.msg("nihaio");
		}
		
		//开始处理接收表单信息
		<%
			if("post".equals(ac)){
				//收集流程信息
				String nodeid1 = request.getParameter("nodeid");
				String process1 = request.getParameter("process");
				
				System.out.println("nodeid1=="+nodeid1);
				System.out.println("process1=="+process1);
			
				
				//收集表单信息
				String advancetype = ""; 	//垫款leixing
				String vinnum = "";		 	//vim码
				String vehiclecar = "";	 	//车辆合格证图片
				String reduction = "";		 	//是否减免
				String reductionmony = ""; 	//减免金额
				String reductionsign = ""; 	//签字条图片
				String paymentmethod = "";		   	//支付方式
				String account = "";		//账户
				String bankname = "";		//开户行
				String accountname = "";	//开户行名
				String telephone = "";		//垫款电话
				String report = "";			//上传二手车评估报告
				String certificates = "";	//手持身份证
				String remarks = "";		//备注
				String jsontemplate = "";	//jsontemplate
				
				orderid = request.getParameter("orderid");
				advancetype = request.getParameter("advancetype");
				vinnum = request.getParameter("vinnum");
				vehiclecar = request.getParameter("vehiclecar");
				reduction = request.getParameter("reduction");		//是否减免
				reductionmony = request.getParameter("reductionmony");		//减免金额
				reductionsign = request.getParameter("reductionsign");		//减免签字图片
				paymentmethod = request.getParameter("paymentmethod");						//支付方式
				account = request.getParameter("account");
				bankname = request.getParameter("bankname");
				accountname = request.getParameter("accountname");
				telephone = request.getParameter("telephone");
				report = request.getParameter("report");
				certificates = request.getParameter("certificates");
				remarks = request.getParameter("remarks");
				jsontemplate = request.getParameter("jsontemplate");
				
				
				String insert_sql = "INSERT INTO dev_hcbjinrong.f_insidersignature "+
																		"	(	orderid,                    "+
																		"		advancetype,                "+
																		"		vinnum,                     "+
																		"		vehiclecar,                 "+
																		"		reduction,                  "+
																		"		reductionmony,              "+
																		"		reductionsign,              "+
																		"		paymentmethod,              "+
																		"		account,                    "+
																		"		bankname,                   "+
																		"		accountname,                "+
																		"		telephone,                  "+
																		"		report,                     "+
																		"		certificates,               "+
																		"		remarks,                    "+
																		"		createtime,                 "+
																		"		createid,                   "+
																		"		updatetime,                 "+
																		"		updateid,                   "+
																		"		jsontemplate                "+
																		"		)                           "+
																		"		VALUES    (                 "+
																		"		'"+orderid+"',                  "+
																		"		'"+advancetype+"',              "+
																		"		'"+vinnum+"',                   "+
																		"		'"+vehiclecar+"',               "+
																		"		'"+reduction+"',                "+
																		"		'"+reductionmony+"',            "+
																		"		'"+reductionsign+"',            "+
																		"		'"+paymentmethod+"',            "+
																		"		'"+account+"',                  "+
																		"		'"+bankname+"',                 "+
																		"		'"+accountname+"',              "+
																		"		'"+telephone+"',                "+
																		"		'"+report+"',                   "+
																		"		'"+certificates+"',             "+
																		"		'"+remarks+"',                  "+
																		"		now(),               "+
																		"		'"+Suid+"',                 "+
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
		
		});
		
		
	</script>
   
</body> 
</html>



<% if(db!=null)db.close();db=null;if(server!=null)server=null; %>