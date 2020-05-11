<%@ page trimDirectiveWhitespaces="true" %>
<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@page import="service.dao.db.Page"%>
<%---客户基本信息 --%>
<%@include file="../../cookie.jsp"%>
<%

//订单id，
	String orderid= request.getParameter("orderid");
	
	//查询客户基本信息，
	String sql = "SELECT "+  
					  "customername,        			    "+  /*客户姓名，*/
					  "IF(sex=0,'男','女')as sex,				"+  /*客户性别，*/
					  "nation,                              "+  /*客户民族，*/
					  "identityid,                          "+  /*客户身份证号码，*/
					  "phonenumber,                         "+  /*客户手机号，*/
					  "contactnumber,                       "+  /*客户联系方式，*/
					  "contactaddress,                      "+  /*客户地址，*/
					  "IFNULL((SELECT industry_name FROM config_industry WHERE id=industrycategory),'自由职业')as industrycategory,		"+  /*客户行业，*/
					  "ifnull(companyname,'无')as companyname,            	"+  /*客户公司名，*/
					  "ifnull(companyaddress,'无')as companyaddress,         	"+  /*客户公司地址，*/
					  "ifnull(companyphone,'无')as companyphone,           	"+  /*客户公司电话，*/
					  "ifnull((SELECT typename FROM TYPE WHERE id=order_customerfile.creditStatus),'无')as creditStatus, "+ /* 征信状态*/
					  "ifnull( (SELECT typename FROM TYPE WHERE id=order_customerfile.creditrating),'无')as creditrating,           	"+  /*征信等级，*/
					  "ifnull(order_customerfile.creditBank,'无')as creditBank,           	"+  /*授信银行，*/
					  "(SELECT typename FROM TYPE WHERE id=maritalstatus) as maritalStatus,      "+  /*婚姻状况，*/
					  "spousename,                          "+  /*配偶姓名*/
					  "spouseidnum,                         "+  /*配偶身份证号*/
					  "spousephone,                         "+  /*配偶联系电话*/
					  "ifnull(spousecompany,'无')as spousecompany,          	"+  /*配偶公司名*/
					  "ifnull(spousecomaddress,'无')as spousecomaddress,       	"+  /*配偶单位地址*/
					  "ifnull(spousecomphone,'无')as spousecomphone,         	"+  /*配偶单位电话*/
					  "marriagenum                          "+  /*结婚证号*/
				 "FROM order_sheet  "+  
					 " LEFT JOIN order_customerfile ON order_sheet.customeruid = order_customerfile.id  "+  
				 "WHERE order_sheet.id = '"+orderid+"'";
System.out.println("客户基本信息:"+sql);
	ResultSet Customer_rs = db.executeQuery(sql);

	while(Customer_rs.next()){
%>	
	<div class="layui-colla-item">
	    <h2 class="layui-colla-title">客户档案信息</h2>
	    <div class="layui-colla-content ">
	     <!-- 档案 内容 -->
	     <h4 >一、基本信息</h4>
	     <div class="layui-form-item">
			    <div class="layui-inline">
			      <label class="layui-form-label">姓名</label>
			      <div class="layui-input-inline">
			        <input type="text" required readonly="readonly" value="<%=Customer_rs.getString("customername")%>" class="layui-input">
			      </div>
			    </div>
			    <div class="layui-inline">
			      <label class="layui-form-label">性别</label>
			    <div class="layui-input-inline">
			      <input type="text" name="" readonly="readonly"  value="<%=Customer_rs.getString("sex")%>" class="layui-input">
			    </div>
			    </div>
			    <div class="layui-inline">
			      <label class="layui-form-label">民族</label>
			      <div class="layui-input-inline">
			        <input type="text" name="" readonly="readonly"  value="<%=Customer_rs.getString("nation")%>" class="layui-input">
			      </div>
			    </div>
			    <div class="layui-inline">
			      <label class="layui-form-label">身份证号码</label>
			      <div class="layui-input-inline">
			        <input type="text" name="" readonly="readonly" value="<%=Customer_rs.getString("identityid")%>" class="layui-input">
			      </div>
			    </div>
		  </div>
    		<div class="layui-form-item">
			    <div class="layui-inline">
			      <label class="layui-form-label">手机号</label>
			      <div class="layui-input-inline">
			        <input type="text" readonly="readonly" value="<%=Customer_rs.getString("phonenumber")%>" class="layui-input">
			      </div>
			    </div>
			    <div class="layui-inline">
			      <label class="layui-form-label">联系方式</label>
			      <div class="layui-input-inline">
			        <input type="text" name="address" readonly="readonly" value="<%=Customer_rs.getString("contactnumber")%>" class="layui-input">
			      </div>
			    </div>
			    <div class="layui-inline">
			      <label class="layui-form-label">地址</label>
			      <div class="layui-input-inline">
			        <input type="text" name="" readonly="readonly" value="<%=Customer_rs.getString("contactaddress")%>" class="layui-input">
			      </div>
			    </div>
			    <div class="layui-inline">
			      <label class="layui-form-label">行业类别</label>
			      <div class="layui-input-inline">
			        <input type="text" class="layui-input" readonly="readonly" value="<%=Customer_rs.getString("industrycategory")%>">
			      </div>
			    </div>
		  </div>
		  <div class="layui-form-item">
		  		<div class="layui-inline">
			      <label class="layui-form-label">公司名称</label>
			      <div class="layui-input-inline">
			        <input type="text"  name="phone" readonly="readonly" value="<%=Customer_rs.getString("companyname")%>" class="layui-input">
			      </div>
			    </div>
			    <div class="layui-inline">
			      <label class="layui-form-label">公司地址</label>
			      <div class="layui-input-inline">
			        <input type="text" readonly="readonly" class="layui-input" value="<%=Customer_rs.getString("companyaddress")%>">
			      </div>
			    </div>
			    <div class="layui-inline">
			      <label class="layui-form-label">公司联系电话</label>
			      <div class="layui-input-inline">
			        <input type="text" name="" readonly="readonly"  class="layui-input" value="<%=Customer_rs.getString("companyphone")%>">
			      </div>
			    </div>
			    <div class="layui-inline">
			      <label class="layui-form-label">征信状态</label>
			      <div class="layui-input-inline">
			        <input type="text"  readonly="readonly" class="layui-input" value="<%=Customer_rs.getString("creditStatus") %>">
			      </div>
			    </div>
			    <div class="layui-inline">
			      <label class="layui-form-label">征信等级</label>
			      <div class="layui-input-inline">
			        <input type="text"  readonly="readonly" class="layui-input" value="<%=Customer_rs.getString("creditrating") %>">
			      </div>
			    </div>
			    <div class="layui-inline">
			      <label class="layui-form-label">授信银行</label>
			      <div class="layui-input-inline">
			        <input type="text"  readonly="readonly" class="layui-input" value="<%=Customer_rs.getString("creditBank") %>">
			      </div>
			    </div>
			    <div class="layui-inline">
			      <label class="layui-form-label">婚姻状况</label>
			      <div class="layui-input-inline"  >
			       	 <input type="text" class="layui-input" readonly="readonly" value="<%=Customer_rs.getString("maritalStatus")%>">
			      </div>
			    </div>
		  </div>
<%
 	if("已婚".equals(Customer_rs.getString("maritalStatus"))){
%>
		  <h4>二、婚姻信息</h4>
		  <div class="layui-form-item">
			    <div class="layui-inline">
			      <label class="layui-form-label">配偶姓名</label>
			      <div class="layui-input-inline">
			        <input type="text" class="layui-input" readonly="readonly" value="<%=Customer_rs.getString("spousename")%>">
			      </div>
			    </div>
			    <div class="layui-inline">
			      <label class="layui-form-label">配偶身份证号</label>
			      <div class="layui-input-inline">
			        <input type="text" name="" readonly="readonly" value="<%=Customer_rs.getString("spouseidnum")%>" class="layui-input">
			      </div>
			    </div>
			    <div class="layui-inline">
			      <label class="layui-form-label">配偶联系电话</label>
			      <div class="layui-input-inline">
			       <input type="text" name="" readonly="readonly" value="<%=Customer_rs.getString("spousephone")%>" class="layui-input">
			      </div>
			    </div>
			    <div class="layui-inline">
			      <label class="layui-form-label">配偶单位名称</label>
			      <div class="layui-input-inline" >
			       <input type="text" name="" readonly="readonly" value="<%=Customer_rs.getString("spousecompany")%>" class="layui-input">
			      </div>
			    </div>
			 </div>
			 <div class="layui-form-item">
			    <div class="layui-inline">
			      <label class="layui-form-label">配偶单位地址</label>
			      <div class="layui-input-inline" >
			       <input type="text" name="" readonly="readonly" value="<%=Customer_rs.getString("spousecomaddress")%>" class="layui-input">
			      </div>
			    </div>
			    <div class="layui-inline">
			      <label class="layui-form-label">配偶单位电话</label>
			      <div class="layui-input-inline" >
			       <input type="text" name="" readonly="readonly" value="<%=Customer_rs.getString("spousecomphone")%>" class="layui-input">
			      </div>
			    </div>
			     <div class="layui-inline">
			      <label class="layui-form-label">结婚证号</label>
			      <div class="layui-input-inline" >
			       <input type="text" name="" readonly="readonly" value="<%=Customer_rs.getString("marriagenum")%>" class="layui-input">
			      </div>
			    </div>
		  </div>
<%} %>		  
		   <div class="layui-form-item">
		  <div class="layui-block">
		  	
		 	</div>
		  </div>
		  <!-- 档案 内容 -->
	    </div>
	  </div>
	
<%	
	}if(Customer_rs!=null){Customer_rs.close();}
	
	//查询订单基本信息，
	String report_info="SELECT "+
									  "salesmanname, "+                           /*业务员*/
									  "g_distributor.name, "+                     /*经销商*/
									  "policyname, "+                             /*政策类型*/
									  "bankname, "+                               /*银行*/
									  "models, "+                                 /*所购车型*/
									  "t_yewumian.liuchengname, "+                /*报件类型*/
									  "(SELECT t_yewumian.liuchengname FROM t_yewumian WHERE t_yewumian.id=order_sheet.homevisits ) AS homevisitsType, "+  /*家访类型*/
									  "t_yewumian.priceDescription, "+            /*价格说明*/
									  "evaluateprice, "+                          /*车辆价格*/
									  "IFNULL(s_eveluatetype.eveluatatypename,'')as eveluatatypename ,"+/*评估类型*/
									  "loantype, "+                               /*贷款类型*/
									  "order_paydetails.payments, "+              /*首付比例*/
									  "order_paydetails.loanAmount, "+                  /*上融贷款额*/
									  "order_paydetails.actualloan, "+            /*实际贷款额，*/
									  "order_paydetails.monthlyamount, "+         /*月还款额*/
									  "order_paydetails.guaranteefee, "+          /*担保费*/
									  "order_paydetails.bond, "+                  /*履约还款保证金*/
									  "order_paydetails.colligatesrevicefee, "+   /*综合服务费*/
									  "order_paydetails.srevicefee, "+            /*服务费*/
									  "order_paydetails.Collection, "+            /*代收*/
									  "order_paydetails.twograderebate, "+        /*二级返利*/
									  "order_paydetails.income, "+                /*收入*/
									  "order_paydetails.total, "+                 /*合计*/
									  "(SELECT form_name.datafrom FROM role_from  LEFT JOIN zk_role ON zk_role.id=role_from.roleid  LEFT JOIN form_name ON role_from.fromid=form_name.id WHERE zk_role.id=2) as remarkTable"+  /*征信备注表名*/
								" FROM order_sheet "+
									  "LEFT JOIN g_distributor ON g_distributor.id=order_sheet.distributorid "+
									  "LEFT JOIN t_yewumian ON t_yewumian.id=order_sheet.processid "+
									  "LEFT JOIN s_eveluatetype ON s_eveluatetype.eveluatetypeid=order_sheet.eveluatetypeid "+
									  "LEFT JOIN order_paydetails ON order_paydetails.orderid=order_sheet.id "+
								"WHERE order_sheet.id = '"+orderid+"'";
	
System.out.println("报件基本信息:"+report_info);
	ResultSet report_info_rs = db.executeQuery(report_info);
	while(report_info_rs.next()){
%>	
	  <div class="layui-colla-item">
	    <h2 class="layui-colla-title">报件基本信息</h2>
	    <div class="layui-colla-content ">
	     <h4 >一、基本信息</h4>
	    <div class="layui-form-item">
			    <div class="layui-inline">
			      <label class="layui-form-label">业务员</label>
			      <div class="layui-input-inline">
			        <input type="text"  readonly="readonly" class="layui-input" value="<%=report_info_rs.getString("salesmanname") %>">
			      </div>
			    </div>
			    <div class="layui-inline">
			      <label class="layui-form-label">经销商</label>
			    <div class="layui-input-inline">
			      <input type="text"  readonly="readonly" class="layui-input" value="<%=report_info_rs.getString("g_distributor.name") %>">
			    </div>
			    </div>
			    <div class="layui-inline">
			      <label class="layui-form-label">政策类型</label>
			      <div class="layui-input-inline">
			        <input type="text"  readonly="readonly" class="layui-input" value="<%=report_info_rs.getString("policyname") %>">
			      </div>
			    </div>
			    <div class="layui-inline">
			      <label class="layui-form-label">银行</label>
			      <div class="layui-input-inline">
			       <input type="text"  readonly="readonly" class="layui-input" value="<%=report_info_rs.getString("bankname") %>">
			      </div>
			    </div>
		  </div>
		  <div class="layui-form-item">
		  	    <div class="layui-inline">
			      <label class="layui-form-label">所购车型</label>
			      <div class="layui-input-inline"  >
			        <input type="text"  readonly="readonly" class="layui-input" value="<%=report_info_rs.getString("models") %>">
			      </div>
			    </div>
			    <div class="layui-inline">
			      <label class="layui-form-label">报件类型</label>
			      <div class="layui-input-inline">
			       <input type="text"  readonly="readonly" class="layui-input" value="<%=report_info_rs.getString("t_yewumian.liuchengname") %>">
			      </div>
			    </div>
			    <div class="layui-inline">
			      <label class="layui-form-label">家访类型</label>
			      <div class="layui-input-inline">
			        <input type="text"  readonly="readonly" class="layui-input" value="<%=report_info_rs.getString("homevisitsType") %>">
			      </div>
			    </div>
		  </div>
		  <div class="layui-form-item">
		   		<div class="layui-inline">
			      <label class="layui-form-label"><%=report_info_rs.getString("t_yewumian.priceDescription") %></label><!-- 价格说明 -->
			      <div class="layui-input-inline">
			       <input type="text"  readonly="readonly" class="layui-input" value="<%=report_info_rs.getString("evaluateprice") %>">
			      </div>
			    </div>
<%
		if("手车".equals(report_info_rs.getString("t_yewumian.liuchengname"))){//报价类型为二手车时显示
%>
			    <div class="layui-inline">
			      <label class="layui-form-label">评估类型</label>
			      <div class="layui-input-inline">
			       <input type="text"  readonly="readonly" class="layui-input" value="<%=report_info_rs.getString("eveluatatypename") %>">
			      </div>
			    </div>
			    <div class="layui-inline">
			      <label class="layui-form-label">贷款类型</label>
			      <div class="layui-input-inline">
			        <input type="text"  readonly="readonly" class="layui-input" value="<%=report_info_rs.getString("loantype") %>">
			      </div>
			    </div>
<%		}
%>
		  </div>
	    </div>
	    	    <div class="layui-colla-content ">
	     <h4 >二、缴费明细</h4>
	    <div class="layui-form-item">
			    <div class="layui-inline">
			      <label class="layui-form-label">首付比例</label>
			      <div class="layui-input-inline">
			        <input type="text"  readonly="readonly" class="layui-input" value="<%=report_info_rs.getString("order_paydetails.payments") %>">
			      </div>
			    </div>
			    <div class="layui-inline">
			      <label class="layui-form-label">上融贷款额</label>
			    <div class="layui-input-inline">
			      <input type="text"  readonly="readonly" class="layui-input" value="<%=report_info_rs.getString("order_paydetails.loanAmount") %>">
			    </div>
			    </div>
			    <div class="layui-inline">
			      <label class="layui-form-label">实际贷款额</label>
			      <div class="layui-input-inline">
			        <input type="text"  readonly="readonly" class="layui-input" value="<%=report_info_rs.getString("order_paydetails.actualloan") %>">
			      </div>
			    </div>
			    <div class="layui-inline">
			      <label class="layui-form-label">月还款额</label>
			      <div class="layui-input-inline">
			       <input type="text"  readonly="readonly" class="layui-input" value="<%=report_info_rs.getString("order_paydetails.monthlyamount") %>">
			      </div>
			    </div>
		  </div>
		  <div class="layui-form-item">
		  	    <div class="layui-inline">
			      <label class="layui-form-label">担保费</label>
			      <div class="layui-input-inline"  >
			        <input type="text"  readonly="readonly" class="layui-input" value="<%=report_info_rs.getString("order_paydetails.guaranteefee") %>">
			      </div>
			    </div>
			    <div class="layui-inline">
			      <label class="layui-form-label">履约还款保证金</label>
			      <div class="layui-input-inline">
			       <input type="text"  readonly="readonly" class="layui-input" value="<%=report_info_rs.getString("order_paydetails.bond") %>">
			      </div>
			    </div>
			    <div class="layui-inline">
			      <label class="layui-form-label">综合服务费</label>
			      <div class="layui-input-inline">
			        <input type="text"  readonly="readonly" class="layui-input" value="<%=report_info_rs.getString("order_paydetails.colligatesrevicefee") %>">
			      </div>
			    </div>
			    <div class="layui-inline">
			      <label class="layui-form-label">服务费</label>
			      <div class="layui-input-inline">
			        <input type="text"  readonly="readonly" class="layui-input" value="<%=report_info_rs.getString("order_paydetails.srevicefee") %>">
			      </div>
			    </div>
		  </div>
		  <div class="layui-form-item">
		 		<div class="layui-inline">
			      <label class="layui-form-label">代收</label>
			      <div class="layui-input-inline">
			        <input type="text"  readonly="readonly" class="layui-input" value="<%=report_info_rs.getString("order_paydetails.Collection") %>">
			      </div>
			    </div>
		   		<div class="layui-inline">
			      <label class="layui-form-label">二级返利</label><!-- 价格说明 -->
			      <div class="layui-input-inline">
			       <input type="text"  readonly="readonly" class="layui-input" value="<%=report_info_rs.getString("order_paydetails.twograderebate") %>">
			      </div>
			    </div>
			    <div class="layui-inline">
			      <label class="layui-form-label">收入</label>
			      <div class="layui-input-inline">
			       <input type="text"  readonly="readonly" class="layui-input" value="<%=report_info_rs.getString("order_paydetails.income") %>">
			      </div>
			    </div>
			    <div class="layui-inline">
			      <label class="layui-form-label">合计</label>
			      <div class="layui-input-inline">
			        <input type="text"  readonly="readonly" class="layui-input" value="<%=report_info_rs.getString("order_paydetails.total") %>">
			      </div>
			    </div>
		  </div>
	    </div>
	  </div>
	   

<%	
	}if(report_info_rs!=null){report_info_rs.close();}

%>
 
 
 
<% if(db!=null)db.close();db=null;if(server!=null)server=null; %>
