<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*,java.io.*" %>
<%@page import="java.util.Date"%>
<%@page import="service.dao.db.Page"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@include file="../../cookie.jsp"%> 
<script src="../../js/layui2/layui.js"></script>
<script type="text/javascript" src="../../../custom/jquery.min.js"></script>
<script type="text/javascript">
 var index = parent.layer.getFrameIndex(window.name);
 function add(){
	 layer.open({
		 type: 2,
		  title: '新的教学计划名',
		  shadeClose: true,
		  maxmin:1,
		  shade: 0.5,
		  area: ['940px', '80%'],
		  content: 'new_guide_enact.jsp' 
		});}
</script>
<%
 String departments_id=request.getParameter("departments_id");
 String major_id=request.getParameter("major_id");
 String school_year=request.getParameter("school_year");
 String author=request.getParameter("author");
 SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");//设置日期格式
 
try{
   String sql="INSERT INTO teaching_plan_class (`addtime`,`add_worker_id`,`dict_departments_id`,`school_year`,`major_id`,`teaching_plan_name`)  VALUES ('"+df.format(new Date())+"','"+Suid+"','"+departments_id+"','"+school_year+"','"+major_id+"','"+author+"')";
   if(db.executeUpdate(sql)==true){
	   out.println("<script> parent.layer.msg('添加 成功');parent.layer.close(index);window.parent.location.reload();</script>");
   }else{
	   out.println("<script>alert('添加 失败!请重新输入');parent.location.reload();</script>");
   }
} catch (Exception e){
	if (db != null) { db.close(); db = null;}
    if (page != null) { page = null;}
    out.println("<script>parent.layer.msg('添加 失败');location.reload()</script>");
    return;
}
//关闭数据与serlvet.out
if (db != null) { db.close(); }
if (page != null) {page = null;}
%>
  

<%if(db!=null)db.close();db=null;if(server!=null)server=null;%>
