<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@ page import="java.sql.*" %>
<%@page import="v1.haocheok.commom.common"%>
<%@ page import="java.util.*" %>
<%@include file="../../cookie.jsp"%>
<!DOCTYPE html>
<html>
	<head>
		<title>征信角色-报件</title> 
		<meta name="renderer" content="webkit">
		<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
		<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
		<meta name="apple-mobile-web-app-status-bar-style" content="black">
		<meta name="apple-mobile-web-app-capable" content="yes">
		<meta name="format-detection" content="telephone=no">

		<link rel="stylesheet" href="../../../pages/css/sy_style.css?22">
		 <link rel="stylesheet" href="../../../pages/js/layui2/css/layui.css">
		<style type="text/css">
			.inline{ position: relative; display: inline-block; margin-right: 10px; }
		</style>
		
		<script src="../../js/jquery-1.9.1.js"></script>
        <script src="../../../pages/js/layui2/layui.js" charset="utf-8"></script>
        <script src="report.js"></script>
		

        <script src="../../js/ajaxs.js"></script>
	</head>
	<body>
		<div style="margin: 15px;">
		  <form class="layui-form"  ><%---- action="<%=apiurl%>" method="post" --%>
				<fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
					<legend>客户基本信息</legend>
				</fieldset>
				<div class="layui-form-item inline">
					<div class="layui-form-item inline" id="user_full_name" >
				          <label class="layui-form-label">客户姓名</label>
				          <!--姓名               full_name  		   -->
				          <div class="layui-input-inline">
				            	<span  id="select_userinfo" class="layui-btn layui-btn-primary layui-btn-big" onclick="chauser()">点击添加用户信息</span>
				          </div>
			        </div>
					<% 
				      if("user".equals(ac)){
				        
				        	String uid = request.getParameter("uid"); if(uid==null){uid="0";}//获取文件后面的对象 数据
				        
				        	String id="",customername="",creditrating="",sex="",identityid="",birthdate="",industrycategory="",contactaddress="",phonenumber="";
				        	
				        	String sql_userinfo="select id,customername,sex,creditrating,identityid,birthdate,(SELECT industry_name FROM config_industry WHERE  id=industrycategory)industrycategory,contactaddress,phonenumber from order_customerfile where id='"+uid+"' ;";
				        	
				        	ResultSet rs_user=db.executeQuery(sql_userinfo);
					
							if(rs_user.next()){
									id= 				rs_user.getString("id");//客户id
									customername= 		rs_user.getString("customername");//客户姓名
									creditrating= 		rs_user.getString("creditrating");//征信等级
									sex= 				rs_user.getString("sex");//客户性别
									identityid= 		rs_user.getString("identityid");//客户身份证号
									birthdate= 			rs_user.getString("birthdate");//出生年月
									industrycategory=   rs_user.getString("industrycategory");//行业
									contactaddress=     rs_user.getString("contactaddress");//家庭住址
									phonenumber=        rs_user.getString("phonenumber");//联系方式
									
									
						   }if(rs_user!=null){rs_user.close();}
				    %>
				        <script type="text/javascript">
				        	$('#user_full_name').css('display','none');
				        	
				        </script>
				        <div class="layui-form-item inline">
				        <input type="hidden" name="customerid" value="<%=id %>" />
				          <label class="layui-form-label">姓名</label>
				          <!--姓名               full_name                        -->
				          <div class="layui-input-inline">
				            <input id="full_name_id" type="tel" name="full_name" lay-verify="" autocomplete="off" class="layui-input" value="<%=customername%>"; disabled="disabled">
				          </div>
				        </div>
				        <div class="layui-form-item inline">
				          <!--性别               gender                           -->
				          <label class="layui-form-label">性别</label>
				          <div class="layui-input-inline">
				            <div class="layui-input-inline">
				            <input type="tel" name="gender" lay-verify="" autocomplete="off" class="layui-input" value="<%=common.getDis4info("gender",sex)%>"; disabled="disabled">
				          </div>   
				          </div>
				        </div>
				        <div class="layui-form-item inline">
				          <label class="layui-form-label">身份证号</label>
				          <div class="layui-input-inline">
				            <!--身份证号           id_number                        -->
				            <input type="tel" name="id_number" lay-verify="" autocomplete="off" class="layui-input" value="<%=identityid%>" disabled="disabled">
				          </div>
				        </div>
				        <div class="layui-form-item inline">
				          <label class="layui-form-label">出生年月</label>
				          <div class="layui-input-inline">
				            <!--出生年月           
			                    -->
				            <input type="tel" name="date_of_birth" lay-verify="" autocomplete="off" class="layui-input" value="<%=birthdate%>" disabled="disabled">
				          </div>
				        </div>
				        <div class="layui-form-item inline">
				          <label class="layui-form-label">行业</label>
				          <div class="layui-input-inline">
				            <!--行业               industry                         -->
				            <input type="tel" name="industry" lay-verify="" autocomplete="off" class="layui-input" value="<%=industrycategory%>" disabled="disabled">
				          </div>
				        </div>
				        <div class="layui-form-item inline">
				          <label class="layui-form-label">家庭住址</label>
				          <div class="layui-input-inline">
				            <!--家庭住址           home_address                     -->
				            <input type="tel" name="home_address" lay-verify="" autocomplete="off" class="layui-input" value="<%=contactaddress%>" disabled="disabled">
				          </div>
				        </div>
				        <div class="layui-form-item inline">
				          <label class="layui-form-label">联系方式</label>
				          <div class="layui-input-inline">
				            <!--联系方式           contact_information              -->
				            <input type="tel" name="contact_information" lay-verify="" autocomplete="off" class="layui-input" value="<%=phonenumber%>" disabled="disabled">
				          </div>
				        </div>
				        <div class="layui-form-item inline">
				          <label class="layui-form-label">征信等级</label>
				          <div class="layui-input-inline">
				            <p style="margin-top: 8px;"><%=common.getDis4info("creditrating",creditrating)%></p>
				          </div>
				        </div>
				        <div class="layui-form-item inline">
				        	<label class="layui-form-label">更换客户</label>
					        <div class="layui-input-inline">
					          <span  id="select_userinfo" class="layui-btn layui-btn-primary layui-btn-big" onclick="chauser()">点击更换客户信息</span>
					        </div>
				        </div>
				</div>
				<div id="basic_info" >
					<fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
						<legend>基本信息</legend>
					</fieldset>
			        <div class="layui-form-item inline">
				          <label class="layui-form-label">业务员</label>
				          <%
				          String salesman_sql="SELECT uid,username "+
				                      "FROM user_worker "+
				                      "LEFT JOIN zk_user_role ON user_worker.uid=zk_user_role.sys_user_id "+ 
				                      "LEFT JOIN zk_role ON  zk_user_role.sys_role_id =zk_role.id "+ 
				                    "WHERE  zk_role.id=19 "+  
				                      "AND  user_worker.regionalcode LIKE (SELECT CONCAT('%',regionalcode,'%') FROM user_worker WHERE uid='"+Suid+"');";
				            %>
				          <div class="layui-input-inline">
				          <!--业务员             salesman                         -->
					          	<select name="salesman" lay-filter="salesman" lay-verify="order_sheet_Required">
					          		<option value="">请选择业务员</option>
						            <% 
						                ResultSet rs_salesman=db.executeQuery(salesman_sql);
						                while(rs_salesman.next()){
						              %>
						                 <option value="<%=rs_salesman.getString("uid")%>"><%=rs_salesman.getString("username")%></option>
						            <%    
						              }if(rs_salesman!=null){rs_salesman.close();} 
						            %>
					            </select> 
				          </div>
			        </div>
			        <div class="layui-form-item inline">
			          	  <label class="layui-form-label">经销商</label>
				          <div class="layui-input-inline">
					            <!--经销商             distributor                      -->
					            <select name="distributor" lay-verify="order_sheet_Required"  id="distributor">
					              <option value="">请选择经销商</option>
					              <% 
					              	//登录人区域
					              	String regioncode = Sregionalcode;
					                ResultSet rs=db.executeQuery("SELECT id,name FROM g_distributor");
					                while(rs.next()){
					              %>
					                 <option value="<%=rs.getString("id")%>"><%=rs.getString("name")%></option>
					             <%    
					               }if(rs!=null){rs.close();} 
					             %>
					            </select>     
			          	  </div>
			        </div>
			        <div class="layui-form-item inline">
				          <label class="layui-form-label">政策类型</label>
				          <!--政策类型           policy_type                      -->
				          <div class="layui-input-inline">
					            <select name="policy_type" lay-filter="policy_config" lay-verify="order_sheet_Required" id="policy_type"  >
					            <option value="">请选择经政策类型</option>
					            	 <% 
					                ResultSet prs=db.executeQuery("SELECT * FROM g_policy");
					                while(prs.next()){
					              %>
					                 <option value="<%=prs.getString("id")%>"><%=prs.getString("policyname")%></option>
					             <%    
					               }if(rs!=null){prs.close();} 
					             %>
					            </select>     
				          </div>
			        </div>
			        <div class="layui-form-item inline">
				          <label class="layui-form-label">银行</label>
				          <!--银行               bank                             -->
				          <div class="layui-input-inline">
					            <select name="bank" lay-filter="bank_config" lay-verify="order_sheet_Required"  id="bank"    >
					               <option value="">请选择银行</option>
						            <% 
						                ResultSet rs_bank=db.executeQuery("SELECT id,bankName FROM g_bank");
						                while(rs_bank.next()){
						              %>
						                 <option value="<%=rs_bank.getString("id")%>"><%=rs_bank.getString("bankName")%></option>
						            <%    
						              }if(rs_bank!=null){rs_bank.close();} 
						            %>
					            </select>     
				          </div>
			        </div>
			        <div class="layui-form-item inline">
				          <label class="layui-form-label">所购车型</label>
				          <div class="layui-input-inline">
				            <!--所购车型           purchased_models                 -->
				            <input type="tel" name="purchased_models" lay-verify="order_sheet_Required" autocomplete="off" class="layui-input">
				          </div>
			        </div>
			        <div class="layui-form-item inline" >
				          <label class="layui-form-label">报件类型</label>
				          <div class="layui-input-inline">
					            <!--报件车型                        newspaper_model     -->
					            <select name="reportType" lay-filter="baojian_style" lay-verify="order_sheet_Required" id="newpager_model">
					            <option value="">请选择</option>
					            <% 
					                            ResultSet rs_classify=db.executeQuery("SELECT id,liuchengname FROM t_yewumian WHERE parentid=0;");
					                            while(rs_classify.next()){
					            %>
					                                 <option value="<%=rs_classify.getString("id")%>"><%=rs_classify.getString("liuchengname")%></option>
					                     		<%     
					                           		}if(rs_bank!=null){rs_bank.close();} 
					                        	%>
					            </select>     
				          </div>
			        </div>
			        <div class="layui-form-item inline" id="hometype_id">
				          <label class="layui-form-label">家访类型</label>
				          <div class="layui-input-inline" id="homeTypeId">
					           
				          </div>
			        </div>
			        <!--价格类型内容 start -->
			        <input type="hidden" name="pricetype" value="" id="pricetype" />
			        <!--价格类型内容end  -->
			        <!-- 报件车型为旧车，有的输入框 start -->
				    <div id="oldCar" style="display:none;">
					     <div class="layui-form-item inline">
					          <label class="layui-form-label">预评估价</label>
					          <div class="layui-input-inline">
					            <!--预估评价           creditrating                    -->
					            <input type="tel" name="creditrating" lay-verify="num" autocomplete="off" class="layui-input">
					          </div>
					    </div>
					     <div class="layui-form-item inline">
					          <label class="layui-form-label">贷款类型</label>
					          <div class="layui-input-inline">
					            <!--贷款类型                              -->
					            <select name="loantype"  lay-verify="oldCar" id="贷款类型">
					           	<option value="">请选择</option>
					            <% 
					                            ResultSet rs_creditrating=db.executeQuery("SELECT id,typename FROM TYPE WHERE typegroupid=9;");
					                            while(rs_creditrating.next()){
					            %>
					                                 <option value="<%=rs_creditrating.getString("id")%>"><%=rs_creditrating.getString("typename")%></option>
					                     		<%     
					                           		}if(rs_creditrating!=null){rs_creditrating.close();} 
					                        	%>
					            </select>   
					          </div>
					    </div>
				    </div>
			       	<!-- 报件车型为旧车，有的输入框 end -->
			        <!-- 报件车型新车，有的输入框（新旧共有家访类型） start-->
				    <div id="newCar" style="display:none;">
					     <div id="invoicePrice" class="layui-form-item inline">
					          <label class="layui-form-label">发票价</label>
					          <div class="layui-input-inline">
					            <!--发票价             invoice_price                    -->
					            <input type="tel" id="invoice_price" name="invoiceprice" lay-verify="newCar" autocomplete="off" class="layui-input" >
					          </div>
					     </div>
					     <div id="" class="layui-form-item inline">
					     	  <label class="layui-form-label">垫款</label>
					          <div class="layui-input-inline">
					            <!--垫款             toMakeAdvances                    -->
					            <input type="tel" id="" name="toMakeAdvances" lay-verify="newCar" autocomplete="off" class="layui-input">
					          </div>	
					     </div>
				    </div>
			        <!-- 报件车型新车，有的输入框（新旧共有家访类型） end-->
	            </div>
	            <%}%>
				<div id="payinfo">
			        <fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
			          <legend>缴费明细</legend>
			        </fieldset>
			        <div class="layui-form-item inline">
				          <label class="layui-form-label">首付比例</label>
				          <div class="layui-input-inline">
				            <!--首付比例           down_payment_ratio               -->
				            <input type="tel" name="down_payment_ratio" lay-verify="" autocomplete="off" class="layui-input"  readonly="readonly">
				          </div>
			        </div>
			        <div class="layui-form-item inline">
				          <label class="layui-form-label">上融贷款额</label>
				          <div class="layui-input-inline">
				            <!--上融贷款额         amount_of_financing_loans        -->
				            <input type="tel" name="amount_of_financing_loans" lay-verify="payinfo" autocomplete="off" class="layui-input" readonly="readonly" >
				          </div>
			        </div>
			        <div class="layui-form-item inline">
				          <label class="layui-form-label">实际贷款额</label>
				          <div class="layui-input-inline">
				            <!--实际贷款额         actual_loan_amount               -->
				            <input type="tel" name="actual_loan_amount" lay-verify="payinfo" autocomplete="off" class="layui-input" readonly="readonly">
				          </div>
			        </div>
			        <div class="layui-form-item inline">
				          <label class="layui-form-label">月还金额</label>
				          <div class="layui-input-inline">
				            <!--月还金额           monthly_amount                   -->
				            <input type="tel" name="monthly_amount" lay-verify="payinfo" autocomplete="off" class="layui-input" readonly="readonly">
				          </div>
			        </div>
			        <div class="layui-form-item inline">
				          <label class="layui-form-label">担保费</label>
				          <div class="layui-input-inline">
				            <!--担保费             guarantee_fee                    -->
				            <input type="tel" name="guarantee_fee" lay-verify="payinfo" autocomplete="off" class="layui-input" readonly="readonly">
				          </div>
			        </div>
<!-- 要修改 -->	        <div class="layui-form-item inline">
				          <label class="layui-form-label">履约还款保证金</label>
				          <div class="layui-input-inline">
				            <!--履约还款保证金     performance_bond                 -->
				            <input type="tel" name="performance_bond" lay-verify="payinfo" autocomplete="off" class="layui-input" readonly="readonly"  value="111">
				          </div>
			        </div>
<!-- 要修改 -->	        <div class="layui-form-item inline">
				          <label class="layui-form-label">综合服务费</label>
				          <div class="layui-input-inline">
				            <!--综合服务费         consolidated_service_charge      -->
				            <input type="tel" name="consolidated_service_charge" lay-verify="payinfo" autocomplete="off" class="layui-input" readonly="readonly"  value="111">
				          </div>
			        </div>
			        <div class="layui-form-item inline">
				          <label class="layui-form-label">服务费</label>
				          <div class="layui-input-inline">
				            <!--服务费             service_charge                   -->
				            <input type="tel" name="service_charge" lay-verify="payinfo" autocomplete="off" class="layui-input" readonly="readonly">
				          </div>
			        </div>
			        <div class="layui-form-item inline">
				          <label class="layui-form-label">代收</label>
				          <div class="layui-input-inline">
				            <!--代收               collection                       -->
				            <input type="tel" name="collection" lay-verify="payinfo" autocomplete="off" class="layui-input"  placeholder="请填写">
				          </div>
			        </div>
<!-- 要修改 -->			<div class="layui-form-item inline">
				          <label class="layui-form-label">二级返利</label>
				          <div class="layui-input-inline">
				            <!--二级返利           two_grade_rebate                 -->
				            <input type="tel" name="two_grade_rebate" lay-verify="payinfo" autocomplete="off" class="layui-input" readonly="readonly" value="111">
				          </div>
			        </div>
<!-- 要修改 -->			<div class="layui-form-item inline">
				          <label class="layui-form-label">收入</label>
				          <div class="layui-input-inline">
				            <!--收入               income                           -->
				            <input type="tel" name="income" lay-verify="payinfo" autocomplete="off" class="layui-input" readonly="readonly" value="111">
				          </div>
			        </div>
<!-- 要修改 -->			<div class="layui-form-item inline">
				          <label class="layui-form-label">合计</label>
				          <div class="layui-input-inline">
				            <!--合计               total                            -->
				            <input type="tel" name="total" lay-verify="payinfo" autocomplete="off" class="layui-input" readonly="readonly" value="111">
				          </div>
			        </div>
		        </div>
				<input   type="hidden" id="orderid"  name="orderid" value="" />  <!--订单id-->
				<input   type="hidden" id="uid"  name="uid" value="<%=Suid%>" />  <!--用户id-->
				<div class="layui-form-item">
				  <div class="layui-input-block" style="text-align:center; margin-top: 5%;margin-left: 0;">
				    <button class="layui-btn" lay-submit="" lay-filter="demo1" >立即创建</button>
				    <button type="reset" class="layui-btn layui-btn-primary">重置</button>
				  </div>
				</div>
		</form>
	</div>
		<script>
		var Suid='<%=Suid%>';<%--用户id--%>
		var Spc_token='<%=Spc_token%>';<%--用户token--%>
			$(function(){
				//判断报件类型
				var carStyle = $('#newpager_model  option:selected').text();
				console.log(carStyle);
				if( carStyle.indexOf('新车')>-1){
						$('#payinfo').css('display','block');
						
				}else{
						$('#payinfo').css('display','none');
				}
			})
			$('#invoice_price').blur(function(){
					countFee();
			});
			
			function chauser(){
				layer.open({
				    shadeClose: true,
				    maxmin:1,
				    shade: 0.5,
				    area: ['700px', '400px'],
					type: 2,
				  	content: 'puery_user.jsp',
				  	btn: ['确定', '取消'],
				  	yes: function(index, layero){
				    	var body = layer.getChildFrame('body', index);
				    	
				    	if(body.find('#user_id').val()>0){
				    		window.location.href="?ac=user&uid="+body.find('#user_id').val();
				    	}else{
				    		layer.alert('请添加客户信息');
				    	}
				    }
				}); 
		     }
			function reaction(obj){
				if(obj=="ture"){
					return true ;
				}else{
					return false ;
				}
			}
			function inputimg() {
        		$("#dbimg").css('display','none'); 
				$("#upimg").css('display','block'); 
			}

			layui.use(['form', 'layedit', 'laydate'], function(){
			    var $    = layui.jquery ,
			    	form    = layui.form,
					layer = layui.layer,
					layedit = layui.layedit,
					laydate = layui.laydate;

				 
					form.render('select');  
				//自定义验证规则
				form.verify({
					order_sheet_Required: function(value) {
						if(value.length < 1) {
							return '该选项为必填项';
						}
					},
					oldCar: function(value) {//二手车
						if("block"==$("#oldCar").css("display")){
							if(value.length < 1) {
								return '该选项为必填项';
							}
						}
						
					},
					newCar: function(value) {//新车
						if("block"==$("#newCar").css("display")){
							if(value.length < 1) {
								return '该选项为必填项';
							}else{
								if(isNaN(value)){
									return '该选项只能为数字';
								}
							}
						}
					},
					num: function(value) {//二手车
						if("block"==$("#oldCar").css("display")){
							if(value.length < 1) {
								return '该选项为必填项';
							}else{
								if(isNaN(value)){
									return '该选项只能为数字';
								}
							}
						}
					},
					payinfo: function(value) {//新车交费明细
						if("block"==$("#payinfo").css("display")){
							if(value.length < 1) {
								return '该选项为必填项';
							}else{
								if(isNaN(value)){
									return '该选项只能为数字';
								}
							}
						}
					}
				});
				
				//监听银行
				form.on('select(bank_config)', function(data){
				 	countFee();
				}); 
				//监听政策
				form.on('select(policy_config)', function(data){
				 	countFee();
				}); 
				//监听下拉 报件车型选项
				form.on('select(baojian_style)', function(data){
					if(data.value==2){//新车
								<%--重新渲染    家访类型下拉菜单--%>
								$("#homeTypeId").html("");						
					  			var select_html=PostAjx('../common/jiafangType.jsp?val='+data.value+'','',Suid,Spc_token);	
								$("#homeTypeId").append(select_html);
								form.render('select'); 
						  		<%--重新渲染    家访类型下拉菜单--%>
				  		
				  		$('#payinfo').css('display','block');//展示缴费明细
				  		$("#newCar").css("display","block");//展示 发票价  垫款
				  		$("#oldCar").css("display","none");//隐藏 预评估价 贷款类型
				  		//添加价格类型
						$('#pricetype').val("0");
				  	 	countFee();
					}else{//二手车
								<%--重新渲染    家访类型下拉菜单--%>
								$("#homeTypeId").html("");						
					  			var select_html=PostAjx('../common/jiafangType.jsp?val='+data.value+'','',Suid,Spc_token);	
								$("#homeTypeId").append(select_html);
								form.render('select'); 
				  				<%--重新渲染    家访类型下拉菜单--%>
				  		
				  		$('#payinfo').css('display','none');//隐藏缴费明细 
				  		$('#newCar').css("display","none");//隐藏  发票价  垫款
				  		$("#oldCar").css("display","block");//展示 预评估价 贷款类型
				  		//添加价格类型
						$('#pricetype').val("1");
					
					}
				}); 
				
				//监听提交
				form.on('submit(demo1)', function(data) {
					//判断是否添加了客户信息
					if(typeof($('#full_name_id').val())!="undefined"){
					
						//console.log(JSON.stringify(data.field));
						//提交 表单数据
						var json= PostAjx('<%=apiurl%>',JSON.stringify(data.field),Suid,Spc_token);
						var jsondom= eval("("+json+")");
						if(jsondom.success==true){
							layer.confirm(
											''+jsondom.msg+'',
											{icon: 1,btn: ['确定'],title:'提示'}, 
										    function(index){
												  layer.close(index);
												  parent.location.reload();
										    }
							);
						}else{
							layer.confirm(
											''+jsondom.msg+',请重新提交',
											{icon: 2,btn: ['确定'],title:'提示'}, 
										    function(index){
												  layer.close(index);
										    }
							);
						}
					}else{
						layer.alert('请添加客户信息');
						location.href = "#select_userinfo"; 
					}
					return false;
				});
			});
		</script>
	</body>
</html>
<% 
if(db!=null)db.close();db=null;if(server!=null)server=null;%>