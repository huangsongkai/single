<%@ page language="java" import="java.util.*" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="net.sf.json.JSONArray"%>
<jsp:useBean id="db" scope="page" class="service.dao.db.Jdbc"/>

    <%
    	String roleid = request.getParameter("roleid");
		String sql = "SELECT id,depth,fatherid,buttonname,IF((SELECT COUNT(1) FROM z_role_button,z_buttonfuntion WHERE z_role_button.buttonid=z_buttonfuntion.id  AND z_role_button.roleid="+roleid+")>0,'true','false')AS checked  FROM z_buttonfuntion ";
		
		ResultSet Tree = db.executeQuery(sql);
		JSONArray jsonArray = new JSONArray();
		Map map = new HashMap();
		while(Tree.next()){
			map.put("id",Tree.getString("id"));
			map.put("text",Tree.getString("buttonname"));
			if("0".equals(Tree.getString("fatherid"))){
				map.put("state","closed");
			}
			map.put("fid",Tree.getString("fatherid"));
			map.put("checked",true);
			jsonArray.add(map);
		
		}
		
		System.out.println(getTree(jsonArray,0).toString());
		out.println(getTree(jsonArray,0).toString());
	 %>
     <%!
     public JSONArray getTree(JSONArray menuList , int parentId){
     	JSONArray childMenu = new JSONArray();  
		for (Object object : menuList) {  
		    JSONObject jsonMenu = JSONObject.fromObject(object);  
		    int menuId = jsonMenu.getInt("id");  
		    int pid = jsonMenu.getInt("fid");  
		    jsonMenu.discard("children");
		    if (parentId == pid) {  
		        JSONArray c_node = getTree(menuList, menuId);  
		        jsonMenu.put("children", c_node);  
		        childMenu.add(jsonMenu);  
		    }  
		}  
		return childMenu;  
     
     }
      %>
<%if(db!=null)db.close();db=null;%>
