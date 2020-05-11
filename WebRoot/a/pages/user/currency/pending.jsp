<%@ page trimDirectiveWhitespaces="true" %>
<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@page import="service.dao.db.Page"%>
<%@include file="../../cookie.jsp"%>

<%
/**
 *未接单
 */
		//获取搜索数据
		String val = request.getParameter("val"); if(val==null){val="";}
		val = new Page().mysqlCode(val);//防止sql注入
		val=val.replaceAll(" ","");
		String search="";
		
		if(val.length()>=1){
			search="AND order_customerfile.customername  LIKE '%"+val+"%'  ";
		}else{
			search="";
		}
		
		//计算出总页数
		String zpag_sql="SELECT COUNT(1) as row "+
						"FROM (SELECT  orderid ,MAX(STATUS) STATUS,processid,nodeid  FROM process_log WHERE  rolecode='"+Srolecode+"' AND process_log.regionalcode LIKE '"+Sregionalcode+"%'   GROUP BY orderid)process_log "+
					         "LEFT JOIN order_sheet ON process_log.orderid=order_sheet.id "+ 
							 "LEFT JOIN order_customerfile ON order_customerfile.id= order_sheet.customeruid  "+
						"WHERE   STATUS=0 "+
						" "+search+" ";
		int zpag= db.Row(zpag_sql);
		zpag=(zpag+10-1)/10;
		
		//获取页数数
       	String pag = request.getParameter("pag"); if(pag==null){pag="1";}
       	int pages=Integer.parseInt(pag);
       	
       	
       	
       	String orderid="",process="",nodeid="";
       	ArrayList<String> list = new ArrayList<String>();
		String customer_sql="";
        	if("".equals(ac)){//默认首页  （正序）
	          	 	customer_sql = "SELECT "+
										"order_sheet.id as orderid , "+
										"process_log.processid,"+
										"process_log.nodeid,"+
										"order_sheet.ordercode as ordercode , "+
										"order_sheet.loantype AS loantype, "+
										"order_sheet.policyname AS policyname,"+
										"order_customerfile.customername AS customername,"+
										"order_customerfile.contactaddress AS contactaddress,"+
										"order_customerfile.phonenumber AS phonenumber,"+
										"order_sheet.updatetime "+
									"FROM (SELECT  orderid ,MAX(STATUS) STATUS,processid,nodeid  FROM process_log WHERE  rolecode='"+Srolecode+"' AND process_log.regionalcode LIKE '"+Sregionalcode+"%'   GROUP BY orderid)process_log "+
								         "LEFT JOIN order_sheet ON process_log.orderid=order_sheet.id "+ 
										 "LEFT JOIN order_customerfile ON order_customerfile.id= order_sheet.customeruid  "+
									"WHERE   STATUS=0 "+
										search+
										"ORDER BY order_sheet.updatetime ASC "+
										"LIMIT "+(pages-1)*10+",10 ";

			}		          	

System.out.println("customer_sql===="+customer_sql);

          	ResultSet customerPrs = db.executeQuery(customer_sql);
          	int i = 1;
          	while(customerPrs.next()){
          		  orderid=customerPrs.getString("orderid");
          		  process=customerPrs.getString("processid");
          		  nodeid=customerPrs.getString("nodeid");
          		  
		          list.add("<tr>\r\n"+
					        "<td ><input type=\"checkbox\" name=\"\" lay-skin=\"primary\"></td>\r\n"+
					        "<td class=\"\" >"+i+"</td>\r\n"+
							"<td class=\"\">"+customerPrs.getString("ordercode")+"</td>\r\n"+
							"<td class=\"\">"+customerPrs.getString("loantype") +"</td>\r\n"+
							"<td class=\"\">"+customerPrs.getString("policyname")+"</td>\r\n"+
							"<td class=\"\">"+customerPrs.getString("customername")+"</td>\r\n"+
							"<td class=\"\">"+customerPrs.getString("contactaddress") +"</td>\r\n"+
							"<td class=\"\">"+customerPrs.getString("phonenumber")+"</td>\r\n"+
							"<td class=\"\">"+customerPrs.getString("updatetime") +"</td>\r\n"+
							"<td class=\"\">\r\n"+
							 "<div class=\"layui-btn-group\">\r\n"+
							    "<button class=\"layui-btn\"  onclick=\" orders()\">接单</button>\r\n"+
							  "</div>\r\n"+
							"</td>\r\n"+
					      "</tr>\r\n");
		        i++;
		    }
		    String tbodyhtml= list.toString().replaceAll(", ","").replaceAll("\\[","").replaceAll("\\]","");
%>


<html>
	<head> 
	    <meta charset="utf-8"> 
	    <meta name="viewport" content="width=device-width, initial-scale=1"> 
	     <link rel="stylesheet" href="../../../pages/css/sy_style.css?22">	    
	    <link rel="stylesheet" href="../../js/layui/css/layui.css">
		<script type="text/javascript" src="../../js/jquery-1.9.1.js" ></script><!--通用jquery-->
		<script src="../../js/layui/layui.js"></script>
		<script type="text/javascript" src="../../js/tableExport/js/table-sort.js" ></script><!--表格排序js  css-->
		<script type="text/javascript" chartset="utf8" src="../../js/tableExport/js/table_list.js " ></script><!--表格导出js  css--><script src="../../js/ajaxs.js"></script>
	    
	    <title>未接单列表</title> 
	    <style type="text/css">
			th {
		      background-color: white;
		    }
		    td {
		      background-color: white;
		    }
		    .btn-group-vertical>.btn, .btn-group>.btn{height:33px;}
		</style>
 	</head> 
	<body>
		<input type="hidden" value="0" id="mark">
	    <div class="" style="padding-bottom: 0px;margin-left: 1%;margin-right: 1%; height:auto;">  
			<div id="tb" class="form_top layui-form" style="">
		        <input id="search" type="text" class="layui-input textbox-text" placeholder="输入客户姓名进行查询" style="">
		        <button class="layui-btn layui-btn-small  layui-btn-primary" onclick="ac_tion('')"> <i class="layui-icon"></i> 搜索</button>
		        <button class="layui-btn layui-btn-small layui-btn-primary"  onclick="ac_tion('refresh')"> <i class="layui-icon">ဂ</i>刷新</button>
		         <div class="layui-inline">
					    <label class="layui-form-label">导出</label>
					    <div class="layui-input-inline">
					      <select name="gender" lay-verify="required"  lay-filter="Export">
					        <option value="请选择格式" selected="">请选择格式</option>
					         <%
					        	String sql = "select name,value from export";
					        	ResultSet base = db.executeQuery(sql);
					        	while(base.next()){
					         %>
					         	<option value="<%=base.getString("value") %>" > <%=base.getString("name") %> </option>
					         <% }%>
					      </select>
					    </div>
				</div>
		    </div>
	    	<table class="cuoz" id="table" data-toggle="table" data-show-toggle="true" data-show-columns="true" data-show-export="true" >
		        <thead>
		            <tr>
		             	<th data-field="state"   data-checkbox="true"><input type="checkbox" name="" ></th>
		              	<th data-field="编号"     data-sortable="true" data-filter-control="select"  data-visible="true">编号</th>
		              	<th data-field="订单编号"  data-sortable="true" data-filter-control="select"  data-visible="true">订单编号</th>
		              	<th data-field="贷款类别"  data-sortable="true" data-filter-control="select"  data-visible="true">贷款类别</th>
		              	<th data-field="收费政策"  data-sortable="true" data-filter-control="select"  data-visible="true">收费政策</th>
		              	<th data-field="姓名"     data-sortable="true" data-filter-control="select"  data-visible="true">姓名</th>
		               	<th data-field="家庭住址"  data-sortable="true" data-filter-control="select"  data-visible="true">家庭住址</th>
		                <th data-field="联系电话"  data-sortable="true" data-filter-control="select"  data-visible="true">联系电话</th>
		                <th data-field="时间"     data-sortable="true" data-filter-control="select"  data-visible="true">时间</th>
		              	<th data-field="操作"     data-sortable="true" data-filter-control="select"  data-visible="true">操作</th>
		            </tr>
		        </thead>
		        <tbody>
		        	<%=tbodyhtml%>
		        </tbody>
	        </table>
			<div id="pages"></div>
	    </div>    
	    <script type="text/javascript"> 
	      
		     function orders(){
				var str = {"placeid":<%=orderid%>,"process":<%=process%>,"nodeid":<%=nodeid%>,"status":"1","common":""};
	    		var obj = JSON.stringify(str)
	    		var ret_str=PostAjx('<%=apiurl%>',obj,'<%=Suid%>','<%=Spc_token%>');
	    		var obj = JSON.parse(ret_str);
	    		if(obj.success && obj.resultCode=="1000"){
	    			 layer.msg('接单成功',{icon:1,time:1000},function(){
	    			 
		                location.reload();//刷新当前页面
		            });
	    		}else{
	    		
	    			layer.msg("接单出现问题");
	    		}
		     }
		     
		     function ac_tion(ac) {
			       if(ac=='refresh'){//刷新
			       		window.location.href="?ac=&pag=1";
			       }else{
			       		window.location.href="?ac=&val="+$('#search').val()+"&pag=1";
			       }
			       
			       
				
			}

	    </script> 
	    	    
		<script>
				<% if(val.length()>=1){%>
					$('#search').val('<%=val%>');
				<%}%>
			    layui.use(['laypage', 'layer'], function(){
				  var laypage = layui.laypage
				  ,layer = layui.layer;
				   
						laypage({
						    cont: 'pages'
						    ,pages: <%=zpag%>  //总页数
						    ,curr:  <%=pages%>     //当前页数 
						    ,skip: true
						    ,jump: function(obj, first){
								    //得到了当前页，用于向服务端请求对应数据
								     var curr = obj.curr;
								     if(curr!=<%=pages%>){//防止死循环 
								     	window.location.href="?ac=&val="+$('#search').val()+"&pag="+curr;
								     }
								  }
					    });
				});
		</script> 
	</body> 
</html>
<% if(db!=null)db.close();db=null;if(server!=null)server=null;%>