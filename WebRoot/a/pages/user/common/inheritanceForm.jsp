<%@ page trimDirectiveWhitespaces="true" %>
<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@page import="service.dao.db.Page"%>

<%@include file="../../cookie.jsp"%>
<%

//订单id，
	String orderid= request.getParameter("orderid");
//System.out.println("orderid==="+orderid);  
//角色id，
	String roleid= request.getParameter("roleid");
//System.out.println("roleid==="+roleid); 
//查询用户所有的表单
	String user_from="SELECT  "+
						   "form_name.datafrom ,"+
						   "form_name.formname ,"+
						   "form_name.id "+
					 "FROM role_from "+
					 	   "LEFT JOIN form_name ON role_from.fromid=form_name.id "+
					 "WHERE  role_from.roleid='"+roleid+"' and role_from.code=0  ORDER BY role_from.code DESC ;";
	ResultSet from_rs= db.executeQuery(user_from);
	
	
	//表单英文名 
	String english_from="";
	//表单中文名 Chinese 
	String chinese_from="";
	while(from_rs.next()){
			english_from=from_rs.getString("form_name.datafrom");
			chinese_from=from_rs.getString("form_name.formname");
			
			String from_str_sql="SELECT GROUP_CONCAT('\"',title,'\",',strname) as str FROM form_template_confg WHERE  fid='"+from_rs.getString("form_name.id")+"';";
			System.out.println("from_str_sql===="+from_str_sql);
			String field_str=db.executeQuery_str(from_str_sql);
			ArrayList<String> z_fieldList= new ArrayList<String>();
			ArrayList<String> y_fieldList= new ArrayList<String>();
			String arrstr[]=field_str.split(",");
			for(int i=0;i<arrstr.length;i++){
				if(i%2==0){
					z_fieldList.add(arrstr[i]);
				}else{
					y_fieldList.add(arrstr[i]);
				}
			}
			

			String test_sql="SELECT  "+y_fieldList.toString().replaceAll("\\[","").replaceAll("\\]","")+"   FROM "+from_rs.getString("form_name.datafrom")+"   WHERE orderid='"+orderid+"';";
			
			
			ResultSet test_rs= db.executeQuery(test_sql);
			while(test_rs.next()){
%>			

		
			<div class="layui-colla-item">
			    <h2 class="layui-colla-title"><%=chinese_from%></h2>
			    <div class="layui-colla-content ">
			     <div class="layui-form-item">
				<%for(int i=0;i<y_fieldList.size();i++){%>
				
	 				<div class="layui-inline">
				      <label class="layui-form-label"><%=z_fieldList.get(i).replaceAll("\"","") %></label>
				      <div class="layui-input-inline">
				        <input type="text" required readonly="readonly" value="<%=test_rs.getString(y_fieldList.get(i))%>" class="layui-input">
				      </div>
				    </div>
				 
				<%}%>
				 </div>
				</div>
			</div>


<% 			
			}if(test_rs!=null){test_rs.close();}
	}if(from_rs!=null){from_rs.close();}
%>	
 
<% if(db!=null)db.close();db=null;if(server!=null)server=null; %>
