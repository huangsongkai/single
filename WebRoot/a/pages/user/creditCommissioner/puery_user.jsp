<%@ page trimDirectiveWhitespaces="true" %>
<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@page import="v1.haocheok.commom.common"%>
<%@page import="service.dao.db.Page"%>
<%@ include file="../../cookie.jsp"%>

<head> 
     <meta charset="utf-8"> 
     <meta name="viewport" content="width=device-width, initial-scale=1"> 
     <link rel="stylesheet" href="../../js/layui/css/layui.css"  media="all">
     <script src="../../js/jquery-1.9.1.js"></script>
     <script src="../../js/layui/layui.js"></script>
    
     <title>查询用户信息</title> 
     <style type="text/css">
			.inline{
					position: relative;
    				display: inline-block;
    				margin-right: 10px;
    		}
	</style>
 </head> 
<body>
    <div class="container">   
    	<form class="file_new layui-form" id="formid" action="?ac=post" method="post" >
		    <div class="layui-form-item inline" style=" margin-top: 5%;margin-left: -11%;">
			      <label class="layui-form-label" style="width:100px;">姓名:</label>
			      <div class="layui-input-inline" style="display: -webkit-box;">
			        	<input type="text" name="name" required lay-verify="required" class="layui-input" placeholder="输入客户姓名 或 身份证号码">
			        	<span><button class="layui-btn" lay-submit="" lay-filter="demo1" >查询</button></span>
			      </div>
		    </div>
    	</form>
    </div>   
 <script type="text/javascript">
 //function aa(){
 	//alert('aa1');
 	//console.log('bb');			
	
//};
 </script>
	<%
	if(ac.equals("post")){
		String name = request.getParameter("name");
		name = new Page().mysqlCode(name);//防止sql注入
		boolean state = new Page().isChineseChar(name);//判断是否为中文
		
		String s_sql="customername like '%"+name+"%' ";
		//if(state){
		//	s_sql="customername='"+name+"' ";
		//}else{
		//	s_sql="identityid='"+name+"' ";
		//}
		String row_sql="select count(1) Row from order_customerfile where "+s_sql+" ";
		
		int ifuser= db.Row(row_sql);
		
		if(ifuser<1){

			out.println(" <script> alert('该客户不存在！请重新输入！'); </script>");
		}else{
	%>
 	<%
 			//查询用户信息
 			String userInfo="select id,customername,sex,identityid,birthdate,industrycategory,contactaddress,phonenumber from order_customerfile where "+s_sql+" ";
 		
 			ResultSet rs=db.executeQuery(userInfo);
		
			String id="",customername="",sex="",identityid="",birthdate="",industrycategory="",contactaddress="",phonenumber="";
			out.println("  <from>");
			out.println("<table  class=\"layui-table admin-table\" style=\"margin-left: 2%; width: 96%;\">");
			out.println("  <thead>");
			out.println("        <tr>");
			out.println("            <th ></th>");
			out.println("            <th >姓名</th>");
			out.println("            <th >性别</th>");
			out.println("            <th >身份证号</th>");
			out.println("            <th >家庭住址</th>");
			out.println("            <th >联系方式</th>");
			out.println("        </tr>");
			out.println("  </thead>");
			out.println("  <tbody>"); 
			int checked_stat=0;
			while(rs.next()){
				id= rs.getString("id");//客户id
				customername= rs.getString("customername");//客户姓名
				sex= rs.getString("sex");//客户性别
				identityid= rs.getString("identityid");//客户身份证号
				birthdate= rs.getString("birthdate");//出生年月
				industrycategory= rs.getString("industrycategory");//行业
				contactaddress= rs.getString("contactaddress");//家庭住址
				phonenumber= rs.getString("phonenumber");//联系方式
				
				
				String checked="";
				if(checked_stat==0){
					checked="checked=\"\"";
				}else{
					checked="";
				}
				
				out.println("        <tr>");
				out.println("            <td ><input  name=\"Fruit\" type=\"radio\" value=\""+id+"\"  onclick=\"user_id(this)\" /></td>");
				out.println("            <td >"+customername+"</td>");
				out.println("            <td >"+common.getDis4info("gender",sex)+"</td>");
				out.println("            <td >"+identityid+"</td>");
				out.println("            <td >"+contactaddress+"</td>");
				out.println("            <td >"+phonenumber+"</td>");
				out.println("        </tr>");
			}if(rs!=null){rs.close();}
			out.println("  </tbody>");
			out.println("</table>");
			out.println("  </from>");
			out.println(" <input type=\"hidden\" id=\"user_id\" value=\"\">");
			out.println("  <script>");
			out.println("  		function user_id (obj){ ");
			out.println("  			$('#user_id').val('')");
			out.println("  			$('#user_id').val($(obj).val())");
			out.println("  			");
			out.println("  		}");
			out.println("  </script>");
		}
	}
 	%>
</body> 
</html>
<% 
if(db!=null)db.close();db=null;if(server!=null)server=null;%>