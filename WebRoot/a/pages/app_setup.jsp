<%@ page trimDirectiveWhitespaces="true" %>
<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<% String MMenuId="0"; //个人密码修改模块编号%>
<%@ include file="cookie.jsp"%>
<%@page import="v1.haocheok.commom.common"%>
<%String cid=request.getParameter("cid");
if(cid==null){cid="1";}
%>
<!DOCTYPE html> 
<html lang="zh_CN"> 
<head> 
    <meta charset="utf-8"> 
    <meta name="viewport" content="width=device-width, initial-scale=1"> 
    <title>APP设置</title> 
    <link href="css/base.css" rel="stylesheet">
    <link rel="stylesheet" href="../custom/easyui/easyui.css">
	    <link rel="stylesheet" href="./js/layui2/css/layui.css">
		<script type="text/javascript" src="./js/jquery-1.9.1.js" ></script>
 <script src="./js/layui2/layui.js"></script>
</head> 
<body>
<style>
.container {
  position: relative;
  padding-left: 10px;
  position: relative;
}
.kv-table > input {margin-left: 0px; margin-right: 0px; padding-top: 0px; padding-bottom: 0px; height: 33px; line-height: 33px; width: 180px;}
a{text-decoration:none}
</style>
<br>
<div class="layui-tab layui-tab-card"  STYLE="width:98%;align:center;margin:0 auto; ">
  <ul class="layui-tab-title">
    <li <%if("1".equals(cid)){out.print("class=\"layui-this\"");}%>><a href="?cid=1">老师教务菜单设置</a></li>
    <li <%if("2".equals(cid)){out.print("class=\"layui-this\"");}%>><a href="?cid=2">学生菜单设置</a></li>
    <li <%if("3".equals(cid)){out.print("class=\"layui-this\"");}%>><a href="?cid=3">家长菜单设置</a></li>
    <li <%if("4".equals(cid)){out.print("class=\"layui-this\"");}%>><a href="?cid=4">管理员菜单设置</a></li>
   
  </ul>
  <div class="layui-tab-content">
    <div class="layui-tab-item layui-show">
  <button class="layui-btn"  onclick="addMenu(0,'<%=cid %>',1);"><i class="layui-icon">&#xe654;</i>添加功能菜单</button>
  
<%--  <div   id="addclass">--%>
<%-- 	<table width="98%" class="layui-table" lay-even="" lay-skin="row">--%>
<%--		  <tbody>--%>
<%--			  <tr>--%>
<%--			    <td width="49%" bgcolor="#f2f2f2">请输入分类名称：<input type="text" name="title" required  lay-verify="required" placeholder="请输入分类名称" autocomplete="off" class="layui-input"></td>--%>
<%--			    <td width="25%" bgcolor="#f2f2f2"><i class="layui-icon">  </i> <i class="layui-icon"></i></td>--%>
<%--			    <td width="18%" bgcolor="#f2f2f2">操作</td>--%>
<%--			  </tr>--%>
<%--			</tbody>--%>
<%--	</table>--%>
<%--</div>--%>
  
  <table width="98%"  class="layui-table" lay-even="" lay-skin="row">
		   <%
		   ResultSet menuRs=null;
		   String ClassId="",ClassName="";
		   String menuid="",menuname="",showstate="";
		   ResultSet ClassRs = db.executeQuery("SELECT * FROM `app_menu_sys`  where userole='"+cid+"'   order by Sortid  ");
				   while(ClassRs.next()){
					   ClassId=ClassRs.getString("id");
					   ClassName=ClassRs.getString("menuname");
					   showstate=ClassRs.getString("showstate");
			  %>
		  <tr class="<%=ClassId%>">
		    <td width="2%"><span class="layui-badge layui-bg-orange"><%=ClassRs.getString("Sortid") %></span></td>
		    <td width="20%"><%=ClassName %></td>
		    <td width="10%"><a href="<%=ClassRs.getString("menulink") %>" target="_blank"><img src="<%=ClassRs.getString("ico") %>" width="40" height="40" border="0" /></a></td>
		  
		    <td width="12%">排序 &nbsp;&nbsp;<span class="layui-badge layui-bg-green"  onclick="downOrder(this,'<%=ClassId %>','<%=ClassRs.getString("Sortid") %>')">↓</span> &nbsp;&nbsp;<span class="layui-badge layui-bg-green" onclick="upOrder(this,'<%=ClassId %>','<%=ClassRs.getString("Sortid") %>')">↑</span></td>
		    <td width="20%"><%=ClassRs.getString("menutxt") %></td>
		    <td width="10%"><%
		    		if(showstate.equals("0")){out.println("隐藏");}
		    		if(showstate.equals("1")){out.println("显示");}
		    %></td>
		    <td width="20%"><button class="layui-btn"  onclick="editMenu('<%=ClassId %>','<%=cid %>');" ><i class="layui-icon"   ></i></button>
		        <button class="layui-btn layui-btn-danger" onclick="delMenu('<%=ClassId %>');" ><i class="layui-icon"></i></button></td>
		   </tr>
		     <%} if(ClassRs!=null){ClassRs.close();}%> 
		    
</table> 
    </div>
  </div>
</div>

</body> 
<script>
	//	添加教师一级菜单
	function delMenu(id){
		  layer.confirm("确认要删除吗，删除后不能恢复", { title: "删除确认" }, function (index) { 
              layer.close(index);
              window.location.href="?ac=deletet&id="+id+"";   						 
          }); 
		}

    layui.use(['laypage', 'layer'], function(){
		  var layer = layui.layer;
		});

	function downOrder(con,menuid,sortid){
		var a = $(con).parent().parent().next().find('.layui-bg-green').html();//如果下一元素有箭头可以移动，没有不能
		if(typeof(a)=='undefined'){
			layer.msg('已经到底部');
			return false;
			}
		var nextSort = $(con).parent().parent().next().children(" :first").find(".layui-bg-orange").html();
		var nextMenuId = $(con).parent().parent().next().attr('class');
		 window.location.href="?ac=update&menuid="+menuid+"&sortid="+sortid+"&nextMenuId="+nextMenuId+"&nextSort="+nextSort;   		
	}
	function upOrder(con,menuid,sortid){
		var a = $(con).parent().parent().prev().find('.layui-bg-green').html();//如果上一元素有箭头可以移动，没有不能
		if(typeof(a)=='undefined'){
			layer.msg('已经到头部');
			return false;
			}
		var nextSort = $(con).parent().parent().prev().children(" :first").find(".layui-bg-orange").html();
		var nextMenuId = $(con).parent().parent().prev().attr('class');
		 window.location.href="?ac=update&menuid="+menuid+"&sortid="+sortid+"&nextMenuId="+nextMenuId+"&nextSort="+nextSort;   	
	}
	 function addMenu(fatherid,cid,depth){
    	 layer.open({
    		  type: 2,
    		  title: '新建菜单',
    		  shade: 0.5,
    		  area: ['940px', '80%'],
    		  content: 'new_app_setup.jsp?fatherid='+fatherid+'&userole='+cid +'&depth='+depth
    		});
     }
	 function editMenu(id,cid){
    	 layer.open({
    		  type: 2,
    		  title: '编辑菜单',
    		  shade: 0.5,
    		  area: ['940px', '80%'],
    		  content: 'edit_app_setup.jsp?id='+id+'&userole='+cid 
    		});
     }
     
</script>
</html>
<% if("update".equals(ac)){ 
	  menuid=request.getParameter("menuid");
	  String sortid=request.getParameter("sortid");
	 String nextMenuId=request.getParameter("nextMenuId");
	 String nextSort=request.getParameter("nextSort");
	try{
		boolean state = true;
		String sql1 = "update  app_menu_sys set Sortid = "+nextSort +" where id="+menuid;
		String sql2 = "update  app_menu_sys set Sortid = "+sortid +" where id="+nextMenuId;
		if(db.executeUpdate(sql1)&&db.executeUpdate(sql2)){
			out.println("<script>window.location.replace('./app_setup.jsp');</script>");
		}else{
			  out.println("<script>layer.msg('更新菜单失败');</script>");
		}
	 }catch (Exception e){
	    out.println("<script>parent.layer.msg('更新菜单失败');</script>");
	    return;
	 }
	//关闭数据与serlvet.out
	if (page != null) {page = null;}
}%>
<% if("deletet".equals(ac)){ 
	 String id=request.getParameter("id");
	 if(id==null){id="";}
	try{
		boolean state = true;
		String checkSql = "select count(id) row from app_menu_sys where fatherid="+id;
		if(db.Row(checkSql)>0){
			state= false;
		}
		if(state){
			   String dsql="DELETE FROM app_menu_sys WHERE id='"+id+"';";
			   if(db.executeUpdate(dsql)==true){
				   out.println("<script>parent.layer.msg('删除菜单成功');window.location.replace('./app_setup.jsp');</script>");
			   }
			   else{
				   out.println("<script>parent.layer.msg('删除菜单失败');</script>");
			   }
		}else{
			 out.println("<script>parent.layer.msg('请先删除子菜单');</script>");
		}
	 }catch (Exception e){
	    out.println("<script>parent.layer.msg('删除菜单失败');</script>");
	    return;
	 }
	//关闭数据与serlvet.out
	if (page != null) {page = null;}
}%>
<%
//插入常用菜单日志
int   TagMenu=db.Row("SELECT COUNT(*) as row FROM  menu_worker  WHERE sysmenuid='"+MMenuId+"' and  workerid='"+Suid+"' and  companyid='"+Scompanyid+"'");
if(TagMenu==0){
  db.executeUpdate("INSERT INTO `menu_worker`(`sysmenuid`,`workerid`,`countes`,`companyid`) VALUES ('"+MMenuId+"','"+Suid+"','1','"+Scompanyid+"');"); 
}else{
 db.executeUpdate("UPDATE  `menu_worker` SET `countes`=countes+1,`usetime`=now() WHERE  sysmenuid='"+MMenuId+"' and  workerid='"+Suid+"' and  companyid='"+Scompanyid+"'");
}
 %>
<% 
if(db!=null)db.close();db=null;if(server!=null)server=null;%>