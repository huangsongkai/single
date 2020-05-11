<%--获取家访类型下拉菜单--%>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<jsp:useBean id="db" scope="page" class="service.dao.db.Jdbc"/>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<jsp:useBean id="server" scope="page" class="service.dao.db.Page"/>
<%
 			//获取文件后面的对象 数据
      	String select_val = request.getParameter("val"); if(select_val==null){select_val="";}else{select_val=select_val.replaceAll("\\s*", "");}
	
		ArrayList<String> select_list = new ArrayList<String>();
		String select_html="";
		
		
		if(!"0".equals(select_val)){
		
			String industry_son_sql="SELECT id,liuchengname FROM t_yewumian WHERE parentid="+select_val+" ;"; 
			System.out.println(industry_son_sql);
			ResultSet industry_son_rs= db.executeQuery(industry_son_sql);
			select_list.clear();
			while(industry_son_rs.next()){
				select_list.add(" <option value='"+industry_son_rs.getString("id")+"'>"+industry_son_rs.getString("liuchengname")+"</option>");
			}if(industry_son_rs!=null){industry_son_rs.close();}
			if(select_list.size()>0){	
				select_html=" <select name='home_visiting_type' lay-filter='home_visiting' lay-verify='order_sheet_Required' > <option value=''>请选择</option> "+select_list.toString().replaceAll("\\[","").replaceAll(",","").replaceAll("\\]","")+"</select> ";
			}
			out.print(select_html);		
		}else{
			out.print(select_html);
		}
		
		
%>
<%if(db!=null)db.close();db=null;if(server!=null)server=null;%>