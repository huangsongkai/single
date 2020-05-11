<%@ page trimDirectiveWhitespaces="true" %>
<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@page import="service.dao.db.Page"%>
<%@include file="../../cookie.jsp"%>
<!DOCTYPE html>
<html>

	<head>
		<meta charset="utf-8">
		<meta name="renderer" content="webkit">
		<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
		<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
		<meta name="apple-mobile-web-app-status-bar-style" content="black">
		<meta name="apple-mobile-web-app-capable" content="yes">
		<meta name="format-detection" content="telephone=no">
		<link rel="stylesheet" href="../../js/layui/css/layui.css" media="all" />
		<script type="text/javascript" src="../../../custom/jquery.min.js"></script>
		<script type="text/javascript" src="../../js/layui/layui.js"></script>
	</head>
	<body>
	<script>
	
	<%
	String role_id 		= request.getParameter("usernameid"); 		if(role_id==null){role_id="";}//获取角色id
	
	String role_name 	= request.getParameter("role_name"); 	if(role_name==null){role_name="";}//获取角色名称
	String available 	= request.getParameter("available"); 	if(available==null){available="";}//是否禁用
	String role_type 	= request.getParameter("role_type"); 	if(role_type==null){role_type="";}//权限类型
	String role_homepage= request.getParameter("role_homepage");if(role_homepage==null){role_homepage="";}//角色是否有首页 
	
	/**
	 *更新角色基本信息
	 */
	
	boolean up_role_state=false;
	String up_zRole="UPDATE zk_role  SET name = '"+role_name+"' , available = '"+available+"' , type = '"+role_type+"' , homepage = '"+role_homepage+"' WHERE id = '"+role_id+"' ;";
	up_role_state=db.executeUpdate(up_zRole);
	if(up_role_state){//角色基本信息更新成功
		
		/**
		 *更新角色编辑的表单
		 *更新角色查看的表单
		 */ 
		 
		 //查询出  角色表单关联表  原有数据 
		 String roleFromSql_str="";//更新该角色表单数据 
		 String  roleFromSql=db.executeQuery_str("SELECT  IFNULL(GROUP_CONCAT( CONCAT('(',roleid,',',fromid,',',CODE,',','now()',',',createid,',','now()',',',updateid,')') SEPARATOR ','),'')as str FROM role_from WHERE roleid='"+role_id+"' ");
		 
		 boolean up_state=false;
	 	 boolean hu_state=false;
	 	 
		 //拼写角色查看的表单 的更新语句
		 String see_list_sql="";
		 String see_from	= request.getParameter("see_from"); 		if(see_from==null){see_from="";}//角色查看的表单
		 
		 if(see_from.length()>0){
		 	 String see_from_str[]=see_from.split(","); 		ArrayList <String> see_list =new ArrayList<String>();
			 see_list.clear();
			 for(int see=0;see<see_from_str.length;see++){
				see_list.add("('"+role_id+"','"+see_from_str[see]+"','0',now(),'"+Suid+"',now(),'"+Suid+"')");
			 }
			 if(see_list.size()>0){
			 	see_list_sql=see_list.toString().replaceAll("\\[","").replaceAll("\\]","");
			 }
		 }
		 //拼写角色编写的表单 的更新语句
		 String edit_list_sql="";
		 String edit_from	= request.getParameter("role_edit_from"); 	if(edit_from==null){edit_from="";}//角色编辑表单的id 
		 if(edit_from.length()>0){
		 	String edit_from_str[]=edit_from.split(",");  ArrayList <String> edit_list =new ArrayList<String>();
		 	for(int edit=0;edit<edit_from_str.length;edit++){
				edit_list.add("('"+role_id+"','"+edit_from_str[edit]+"','1',now(),'"+Suid+"',now(),'"+Suid+"')");
			}
			if(edit_list.size()>0){
			    String connect="";
			    if(see_from.length()>0){
					connect=",";			    
				}
			 	edit_list_sql=connect+edit_list.toString().replaceAll("\\[","").replaceAll("\\]","");
			}
		}
		String up_roleFromSql="";
		String hu_roleFromSql="";
		if(roleFromSql.length()>0){//角色表单关联表 的 原有数据   存在 
			boolean delete_roleFromSql=db.executeUpdate("DELETE FROM role_from WHERE roleid = '"+role_id+"' ;");
			if(delete_roleFromSql){//删除成功 
				if((see_list_sql+edit_list_sql).length()>0){
					up_roleFromSql="INSERT INTO role_from  (roleid, fromid, CODE, createtime, createid, updatetime, updateid) VALUES "+see_list_sql+edit_list_sql+";";
					System.out.println("up_roleFromSql=="+up_roleFromSql);
					up_state=db.executeUpdate(up_roleFromSql);
					if(up_state){//数据写入成功
					
					System.out.println("edit_from==="+edit_from);
			%>	
						name('修改成功！');
						window.setTimeout(success,1500);
			<%		}else{//数据写入失败  回滚数据
			
						hu_roleFromSql="INSERT INTO role_from  (roleid, fromid, CODE, createtime, createid, updatetime, updateid) VALUES "+roleFromSql_str;
				    	hu_state=db.executeUpdate(hu_roleFromSql);	
				    	if(hu_state){//回滚成功
			%>					
							name('角色关联表数据修改失败！请重试！');
						    window.setTimeout(fail,1500);
			<%			}else{//回滚失败
			%>					
							name('角色关联表数据修改失败！请重试！角色关联表数据已初始化！');
							window.setTimeout(fail,1500);
			<%			}	
			%>	
						name('角色关联表数据修改失败！请重试！');
						window.setTimeout(fail,1500);
			<%		}
				}
			}else{//删除失败   
		%>	
				name('角色关联表数据修改失败！请重试！角色关联表数据初始化失败');
				window.setTimeout(fail,1500);
				
		<%	}
		}else{//角色表单关联表 不存在该角色 数据   直接更新 
		
			if((see_list_sql+edit_list_sql).length()>0){
				up_roleFromSql="INSERT INTO role_from  (roleid, fromid, CODE, createtime, createid, updatetime, updateid) VALUES "+see_list_sql+edit_list_sql+";";
				System.out.println("up_roleFromSql=="+up_roleFromSql);
				up_state=db.executeUpdate(up_roleFromSql);
				if(up_state){//数据写入成功
		%>
						name('修改成功！');
						window.setTimeout(success,1500);
		
		<%		}else{
		%>
						name('角色关联表数据修改失败！请重试！');
						window.setTimeout(fail,1500);
		<%		
				}
			}else{
		%>
						name('修改成功！qqq');
						window.setTimeout(success,1500);
		<%	}
		}
			
			
			
	}else{%>
		name('修改失败');
		window.setTimeout(fail,1500);
	<%}
	
	%>
	function name(obj) {
		layui.use('layer', function(){
		  var layer = layui.layer;
		 layer.open({
			time:1500,
			content:obj
		 }); 
		}); 
	}
	function success(){ 
		parent.location.href='role_list.jsp'; 
	}
	function fail(){ 
		window.location.href='edit_role.jsp?id=<%=role_id%>';
	}
	</script>
	</body>
</html>
<%
//插入常用菜单日志
int   TagMenu=db.Row("SELECT COUNT(1) as row FROM  menu_worker  WHERE sysmenuid='"+PMenuId+"' and  workerid='"+Suid+"' and  companyid="+Scompanyid);
if(TagMenu==0){
  		db.executeUpdate("INSERT INTO `menu_worker`(`sysmenuid`,`workerid`,`countes`,`companyid`) VALUES ('"+PMenuId+"','"+Suid+"','1','"+Scompanyid+"');"); 
}else{
   		db.executeUpdate("UPDATE  `menu_worker` SET `countes`=countes+1,`usetime`=now() WHERE  sysmenuid='"+PMenuId+"' and  workerid='"+Suid+"' and  companyid="+Scompanyid);
}
%>
<%if(db!=null)db.close();db=null;if(server!=null)server=null;%>