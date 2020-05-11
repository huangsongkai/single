<%@ page trimDirectiveWhitespaces="true" %>
<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@page import="v1.haocheok.commom.common"%>
<%@ include file="../../cookie.jsp"%>
<%@ page import="v1.haocheok.commom.controller.AdoptController"%> 
<html>
	<head> 
	    <meta charset="utf-8"> 
	    <meta name="viewport" content="width=device-width, initial-scale=1"> 
	   
		 <link rel="stylesheet" href="../../../pages/css/sy_style.css?22">
	     <link rel="stylesheet" href="../../../pages/js/layui2/css/layui.css">
	  	 <script type="text/javascript" src="../../../custom/jquery.min.js"></script>
	  	 <script src="../../../pages/js/ajaxs.js"></script>
	  	 <script src="../../../pages/js/layui2/layui.js" charset="utf-8"></script>
	  	 <%-- ▼▼▼上传附件▼▼▼  --%>
		 <script src="../../../pages/js/upload/up_file.js" charset="utf-8"></script>
		 <script>
				var heads= {"X-AppId"  :"<%=AppId_web%>","X-AppKey" :"<%=AppKey_web%>","Token"    :"<%=Spc_token%>","X-UUID"   :"<%=Spc_token%>","X-AppId"  :"<%=AppId_web%>","x-real-ip":"<%=getIpAddr(request)%>"};
				//[文件大小],[tbody id],[文件上传类型],[选取文件按钮id],[上传按钮id],[用户id],[保存附件地址的input id],[请求头]
				up_file(1,'demoList','','testList','testListAction','<%=Suid%>','Credit_report','<%=basePath%>/Api/v1/up',heads);   
		 </script>
		 <%-- ▲▲▲上传附件▲▲▲  --%>
	     <style>
	     	.layui-form-item .layui-input-inline{width:182px;}
	     	 .layui-upload{margin:40px 20px;zoom:1;overflow:hidden;}
	     </style>
	    <title>新建客户档案</title> 
	</head>
	<body>
	    <div class="container">   
	    	<form class="file_new layui-form" id="formid" action="?ac=post" method="post">
	    		
	    		<input type="hidden" name="Suid" value="<%=Suid%>">
	    		<h4>一、基本信息</h4>
	    		<div class="layui-form-item">
				    <div class="layui-inline">
							<label class="layui-form-label">姓名</label>
							<div class="layui-input-inline">
							  	<input type="text" name="customername" required lay-verify="required" class="layui-input">
							</div>
				    </div>
				    <div class="layui-inline">
						  	<label class="layui-form-label">性别</label>
							<div class="layui-input-inline">
							  <select name="sex" lay-verify="required" >
							  	<option value="">请选择</option>
								    <%
							        	Map<String ,String> map = common.getDicMap("gender");
							        	for(Map.Entry<String,String> entry:map.entrySet()){
							        		out.println("<option value='"+entry.getKey()+"'>"+entry.getValue()+"</option>");
							        	}
							        %>
							  </select>
							</div>
				    </div>
				    <div class="layui-inline">
							<label class="layui-form-label">出生日期</label>
							<div class="layui-input-inline">
								<input type="date" name="birthdate" id="birthdate" lay-verify="date" placeholder="yyyy-mm-dd" autocomplete="off" class="layui-input" ">
							</div>
				    </div>
				    <div class="layui-inline">
							<label class="layui-form-label">身份证号</label>
							<div class="layui-input-inline">
							  	<input type="text" name="identityid" required lay-verify="identity"  class="layui-input">
							</div>
				    </div>
	    	  		<div class="layui-inline">
							<label class="layui-form-label">手机号码</label>
							<div class="layui-input-inline">
							  	<input type="text" name="phonenumber" required lay-verify="phone" class="layui-input">
							</div>
				    </div>
				    <div class="layui-inline">
							<label class="layui-form-label">联系电话</label>
							<div class="layui-input-inline">
							  	<input type="text" name="contactnumber" required lay-verify="required" class="layui-input">
							</div>
				    </div>
				    <div class="layui-inline">
							<label class="layui-form-label">联系地址</label>
							<div class="layui-input-inline">
							 	 <input type="text" name="contactaddress" required lay-verify="required" class="layui-input">
							</div>
				    </div>
				    <div class="layui-inline">
							<label class="layui-form-label">单位名称</label>
							<div class="layui-input-inline">
							 	 <input type="text" name="companyname" required lay-verify="required" class="layui-input">
							</div>
				    </div>
			  		<div class="layui-inline">
							<label class="layui-form-label">单位地址</label>
							<div class="layui-input-inline">
							  	<input type="text"  name="companyaddress" required lay-verify="required" class="layui-input">
							</div>
				    </div>
				    <div class="layui-inline">
							<label class="layui-form-label">单位电话</label>
							<div class="layui-input-inline">
							  	<input type="text" required lay-verify="required" name="companyphone" class="layui-input">
							</div>
				    </div>
				    <div class="layui-inline">
							<label class="layui-form-label">民族</label>
							<div class="layui-input-inline">
							  	<select name="nation" class="nation" lay-verify="required">
								    <option value="">请选择</option>
								  	 <%
							        	Map<String ,String> nation_map = common.getDicMap("nation");
							        	for(Map.Entry<String,String> entry:nation_map.entrySet()){
							        		out.println("<option value='"+entry.getKey()+"'>"+entry.getValue()+"</option>");
							        	}
							        %>
							 	</select>
							</div>
				    </div>
				    <div class="layui-inline">
					        <label class="layui-form-label">婚姻状况</label>
					        <div class="layui-input-inline" >
					        	<select name="maritalstatus" lay-verify="required" lay-filter="Marriage" >
					        		<option value="">请选择</option>
					        		<%
							        	Map<String ,String> maritalStatus = common.getDicMap("maritalStatus");
							        	for(Map.Entry<String,String> entry:maritalStatus.entrySet()){
							        		out.println("<option value='"+entry.getKey()+"'>"+entry.getValue()+"</option>");
							        	}
							        %>
					        	</select>
					        </div>
				    </div>
				    <%-- ▼▼▼行业类别相关▼▼▼  --%>
			        <div class="layui-form-item" id="industry">
			        		<%--- 行业表深度 --%>
			        		<%int depth=db.Row("SELECT MAX(depth)as row FROM config_industry");%>
							<label class="layui-form-label">行业类别</label>
							<div class="layui-input-inline" id="depth1">
								<select name="industrycategory1" lay-filter="industry" lay-verify="industry">
									 <option value='|1'>请选择</option>
									 <%
											String industry_sql="SELECT id,industry_name,depth FROM config_industry WHERE depth=1 ;"; 
											ResultSet industry_rs= db.executeQuery(industry_sql);
											while(industry_rs.next()){
												out.println(" <option value='"+industry_rs.getString("id")+"|"+(industry_rs.getInt("depth"))+"'>"+industry_rs.getString("industry_name")+"</option>");
											}if(industry_rs!=null){industry_rs.close();}
									  %>
								</select>
							</div>
							<%for(int i=1;i<depth;i++){out.println("<div class='layui-input-inline' id='depth"+(i+1)+"' style='margin-left: 5px;'></div>");}%>
					</div>
					<input type="hidden" name="industrycategory"  id="industrycategory" value="" >
					<%-- ▲▲▲行业类别相关▲▲▲  --%>
					
			  </div>
			  <div id="spo" style="display:none;">
			  	  <h4>二、婚姻信息</h4>
				  <div class="layui-form-item">
					    <div class="layui-inline">
								<label class="layui-form-label">配偶姓名</label>
								<div class="layui-input-inline">
								  	<input type="text" name="spousename" class="layui-input" >
								</div>
					    </div>
					    <div class="layui-inline">
								<label class="layui-form-label">身份证号</label>
								<div class="layui-input-inline">
								  	<input type="text" name="spouseidnum" class="layui-input">
								</div>
					    </div>
					    <div class="layui-inline">
								<label class="layui-form-label">联系电话</label>
								<div class="layui-input-inline">
								 	<input type="text" name="spousephone" class="layui-input">
								</div>
					    </div>
					    <div class="layui-inline">
								<label class="layui-form-label">单位名称</label>
								<div class="layui-input-inline" >
								 	<input type="text" name="spousecompany" class="layui-input">
								</div>
					    </div>
				  </div>
				  <div class="layui-form-item">
					    <div class="layui-inline">
								<label class="layui-form-label">单位地址</label>
								<div class="layui-input-inline" >
								 	<input type="text" name="spousecomaddress" class="layui-input">
								</div>
					    </div>
					    <div class="layui-inline">
								<label class="layui-form-label">单位电话</label>
								<div class="layui-input-inline" >
								 	<input type="text" name="spousecomphone" class="layui-input">
								</div>
					    </div>
					    <div class="layui-inline">
								<label class="layui-form-label">结婚证号</label>
								<div class="layui-input-inline" >
								 	<input type="text" name="marriagenum"  class="layui-input">
								</div>
					    </div>
				  </div>
			  </div>
			  
			  <h4>3、征信信息</h4>
			  <div class="layui-form-item">
			  		<div class="layui-inline">
							<label class="layui-form-label">征信状态</label>
							<div class="layui-input-inline" >
							 	<select name="creditStatus" lay-verify="required">
							 		 <option value=''>请选择</option>
							 		 <%
							        	Map<String ,String> creditStatus_map = common.getDicMap("creditStatus");
							        	for(Map.Entry<String,String> entry:creditStatus_map.entrySet()){
							        		out.println("<option value='"+entry.getKey()+"'>"+entry.getValue()+"</option>");
							        	}
							         %>
							    </select>
							</div>
				    </div>
			  		<div class="layui-inline">
							<label class="layui-form-label">征信等级</label>
							<div class="layui-input-inline" >
							 	<select name="creditrating" lay-verify="required">
							 		 <option value=''>请选择</option>
							 		 <%
							        	Map<String ,String> creditrating_map = common.getDicMap("creditrating");
							        	for(Map.Entry<String,String> entry:creditrating_map.entrySet()){
							        		out.println("<option value='"+entry.getKey()+"'>"+entry.getValue()+"</option>");
							        	}
							         %>
							    </select>
							</div>
				    </div>
			  		<div class="layui-inline">
							<label class="layui-form-label">授信银行</label>
							<div class="layui-input-inline" >
								<input type="text" name="creditBank" class="layui-input"   required lay-verify="required" >
							</div>
				    </div>
			  		 <input id="Credit_report" type="hidden" name="Creditreport" value="" lay-verify="Credit_report">
			  		 <input id="file" type="hidden"  value="">
					 <div class="layui-upload">
					 <div style="float:left;width:120px;">
					  <button type="button" class="layui-btn layui-btn-normal" id="testList" >选择多文件</button> 
					 <button type="button" class="layui-btn" id="testListAction" style="margin-top:10px;padding:0 24px;">开始上传</button>
					</div>
					  <div class="layui-upload-list" style="float:left;margin:0;margin-left:20px;width:770px;">
					  
					    <table class="layui-table" style="margin:0">
					      <thead>
					        <tr><th>文件名</th>
					        <th>大小</th>
					        <th>状态</th>
					        <th>操作</th>
					      </tr></thead>
					      <tbody id="demoList"></tbody>
					    </table>
					  </div>
					  <br />
					 
					</div> 
			 		
			  </div>
			  
			  <div class="layui-form-item">
				    <div class="layui-input-block">
					      <button class="layui-btn" lay-submit lay-filter="formDemo">立即提交</button>
					      <button type="reset" class="layui-btn layui-btn-primary">重置</button>
				    </div>
			  </div>
	    	</form>
	    </div>   
	 <script type="text/javascript">
		 <%-- ▼▼▼行业类别相关▼▼▼  --%>
		 var Suid='<%=Suid%>';<%--用户id--%>
		 var Spc_token='<%=Spc_token%>';<%--用户token--%>
		 var depth="";
		 <%-- ▲▲▲行业类别相关▲▲▲  --%>
		 layui.use(['form', 'layedit', 'laydate','upload'], function(){
			  var $       = layui.jquery 
			     ,form    = layui.form
			     ,layer   = layui.layer
			     ,layedit = layui.layedit
			     ,laydate = layui.laydate
			     ,upload  = layui.upload;
  
			     <%-- ▼▼▼行业类别相关▼▼▼  --%>
				//监听行业下拉菜单
	 			form.on('select(industry)', function(data){
	 			
						var strs= new Array(); //定义一数组 
						strs=data.value.split("|"); //字符分割 
						var str=Number(strs[1])+1;//下一级数
						depth="#depth"+str;<%--不是第一级 的div id--%>
						
						$(depth).empty();<%--清空下一级div内容--%>
						var strss="";
						if((data.value).length>2){
							strss=strs[0];<%--当前选项的原始id值--%>
						}else{<%--下拉菜单 第一选项 【请选则】--%>
								 $("div[id^='depth']").each(function(){
								    var reg = /\d+/g;
								    var str = $(this).attr('id');
								    var ms = str.match(reg)
								    <%--清空小于当前级数的div--%>
								    if(Number(ms.join(','))>Number(strs[1])){
								    	var dom=$(this).attr('id');
								        $("#"+dom).empty();<%--清空当前div内容--%>
								    }
								 });
							strss="0";<%--为0时请求的数据为空--%>
						}
						<%--传出当前级数    获取下一级 数据     ☆☆☆☆☆重要标记--%>
						var select_html=PostAjx('industry_select.jsp?val='+strss+'','',Suid,Spc_token);
						<%--将获取到的下一级 数据 填充到对应的div 里--%>
						$(depth).append(select_html);
						<%--重新渲染select 下拉选择框--%>
						form.render('select'); 
						<%-- 将  当前选项的原始id值  填充到指定的input内 --%>
						$('#industrycategory').val(strs[0]);
				});
				<%-- ▲▲▲行业类别相关▲▲▲  --%>			
				
				//监听婚姻下拉菜单
	 			form.on('select(Marriage)', function(data){
	 				if(15==data.value){<%-- 数据字典里的已婚状态为15  --%>
	 					$("#spo").css('display','block');
		 				$("#spo input").each(function(){
							$(this).attr('lay-verify','required');  
						});
					}else{
						$("#spo").css('display','none');
						$("#spo input").each(function(){
							$(this).removeAttr('lay-verify'); 
						}); 
					}
	 			});
				
				//自定义验证规则
				form.verify({
					industry: function(value) {
						if(value.length < 3) {<%--有效的初始值长度为3--%>
							return '请选择客户所在行业';
						}
					},
					Credit_report: function(value) {
						if(value.length < 1) {<%--有效的初始值长度为1--%>
							return '请上传客户的 征信附件';
						}
					}
				});
				
				//监听表单提交
				form.on('submit(formDemo)', function(data){
					
				    //layer.msg(JSON.stringify(data.field));
				    $("#Credit_report").val()
				    //console.log(JSON.stringify(data.field));
				    return true;
				});
				
				
				<%
					if("post".equals(ac)){
						
						 String customername     =request.getParameter("customername");    //用户名
						 String sex              =request.getParameter("sex");  		   //性别
						 String birthdate        =request.getParameter("birthdate");       //出生日期
						 String identityid       =request.getParameter("identityid");      //身份证号码
						 String phonenumber      =request.getParameter("phonenumber");     //手机号码
						 String contactnumber    =request.getParameter("contactnumber");   //联系电话
						 String contactaddress   =request.getParameter("contactaddress");  //联系地址 
						 String companyname      =request.getParameter("companyname");     //单位名称
						 String companyaddress   =request.getParameter("companyaddress");  //单位地址
						 String companyphone     =request.getParameter("companyphone");    //单位电话
						 String nation           =request.getParameter("nation");          //民族
						 String industrycategory =request.getParameter("industrycategory");//行业类别
						 String maritalstatus    =request.getParameter("maritalstatus");   //婚姻状态
						 String spousename       =request.getParameter("spousename");      //配偶姓名
						 String spouseidnum      =request.getParameter("spouseidnum");     //配偶身份证号
						 String spousephone      =request.getParameter("spousephone");     //配偶联系电话
						 String spousecompany    =request.getParameter("spousecompany");   //配偶公司名
						 String spousecomaddress =request.getParameter("spousecomaddress");//配偶单位地址
						 String spousecomphone   =request.getParameter("spousecomphone");  //配偶单位电话
						 String marriagenum      =request.getParameter("marriagenum");     //结婚证号
						 String creditStatus     =request.getParameter("creditStatus");    //征信状态
						 String creditrating       =request.getParameter("creditrating");  //征信等级
						 String creditBank       =request.getParameter("creditBank");      //授信银行
						 String userid       	 =request.getParameter("Suid");            //当前用户id
						 
						 String Credit_report    =request.getParameter("Creditreport");   //征信附件
						 System.out.println("Credit_report=="+Credit_report);
						 
						 
						 ArrayList<String> list_id_sql = new  ArrayList<String>();
						 ArrayList<String> list_id_sql_b = new  ArrayList<String>();//数据回滚使用
						 //获取附件id
						 if(Credit_report.indexOf("|")!=-1){//多个附件
						 	String Credit_reportid [] =Credit_report.split("\\|");
						 	list_id_sql.clear();
						 	list_id_sql_b.clear();
						 	for(int i=0;i<Credit_reportid.length;i++){
							 	String idarr []=Credit_reportid[i].toString().split("id=");
							 	list_id_sql.add("("+idarr[1]+",0)");
							 	list_id_sql_b.add("("+idarr[1]+",-1)");
						 	}
						 }else{//单个附件
							String idarr []=Credit_report.split("=");
							list_id_sql.add("("+idarr[1]+",0)");
							list_id_sql_b.add("("+idarr[1]+",-1)");
						 }

						 //更新附件状态语句  (更新为客户征信状态 【不可删除】)
						 String up_attachment_sql="INSERT INTO order_attachment (attachmentid,orderid) VALUES "+list_id_sql.toString().replaceAll("\\[","").replaceAll("\\]","")+" ON DUPLICATE KEY UPDATE orderid=VALUES(orderid)";					
						 //更新附件状态语句  【可删除】
						 String up_attachment_sql_b="INSERT INTO order_attachment (attachmentid,orderid) VALUES "+list_id_sql.toString().replaceAll("\\[","").replaceAll("\\]","")+" ON DUPLICATE KEY UPDATE orderid=VALUES(orderid)";					
						 //客户信息
						 String customer_sql="INSERT INTO order_customerfile "+
															"(customername,sex,birthdate,identityid,phonenumber,contactnumber,contactaddress,companyname,companyaddress,companyphone,nation,industrycategory,maritalstatus,spousename,spouseidnum,spousephone,spousecompany,spousecomaddress,spousecomphone,marriagenum,creditStatus,creditrating,creditBank,creationdate,creationid,updatetime,upuid)"+
														"VALUES "+
															"('"+customername+"','"+sex+"','"+birthdate+"','"+identityid+"','"+phonenumber+"','"+contactnumber+"','"+contactaddress+"','"+companyname+"','"+companyaddress+"','"+companyphone+"','"+nation+"','"+industrycategory+"','"+maritalstatus+"','"+spousename+"','"+spouseidnum+"','"+spousephone+"','"+spousecompany+"','"+spousecomaddress+"','"+spousecomphone+"','"+marriagenum+"','"+creditStatus+"','"+creditrating+"','"+creditBank+"',NOW(),'"+userid+"',NOW(),'"+userid+"');";
					     int customerid=db.executeUpdateRenum(customer_sql);
					     
					     
					     //写入征信记录表语句
						 String customer_instert="INSERT INTO f_creditreport  ( customerid, creditReportCount, cratetime, createid, updatetime, updateid, jsontemplate)VALUES('"+customerid+"' , '"+Credit_report.replaceAll("\\|","#")+"',  now(), '"+userid+"', now(), '"+userid+"', '{\"creditReportCount\": \""+Credit_report.replaceAll("\\|","#")+"\"}');";					
					     
					     if(customerid>0){//创建客户数据成功
					     	boolean up_attachment_sql_stat= db.executeUpdate(up_attachment_sql);//更新附件状态
					     	if(up_attachment_sql_stat){//更新附件状态成功
					     		boolean customer_instert_stat =db.executeUpdate(customer_instert);//写入征信报告表
					     		if(customer_instert_stat==false){//写入征信报告表失败
						     		//删除客户数据
									db.executeUpdate("DELETE FROM order_customerfile WHERE id = '"+customerid+"' ;");
						     		//修改附件状态
						     		db.executeUpdate(up_attachment_sql_b);
						     		out.println("layer.confirm('新建客户档案失败,请联系管理员', {icon: 2, title:'提示'}, function(index){ layer.close(index); location.replace(location.href);});");
					     		}else{
					     			out.println("layer.confirm('客户档案创建完成', {icon: 1, title:'提示'}, function(index){ layer.close(index); parent.location.reload();  });");
					     		}
					     	}else{
								//删除客户数据
								db.executeUpdate("DELETE FROM order_customerfile WHERE id = '"+customerid+"' ;");
								out.println("layer.confirm('新建客户档案失败,请联系管理员', {icon: 2, title:'提示'}, function(index){ layer.close(index); location.replace(location.href); });");
							}
					     }else{//创建客户数据失败
					     	out.println("layer.confirm('新建客户档案失败,请联系管理员', {icon: 2, title:'提示'}, function(index){ layer.close(index); location.replace(location.href);});");
					     }
					}
				%>
		});
	 </script>
	</body> 
</html>
<%if(db!=null)db.close();db=null;if(server!=null)server=null;%>