<%@ page trimDirectiveWhitespaces="true" %>
<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@page import="net.sf.json.JSONArray"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="service.common.SendMail"%>
<%--角色编辑页面 --%>

<%@include file="../../cookie.jsp"%>

<%
	String role_id = request.getParameter("role_id"); if(role_id==null){role_id="0";}
%>
<html>
<head> 
	<meta charset="utf-8">
	<meta name="renderer" content="webkit">
	<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
	<meta name="apple-mobile-web-app-status-bar-style" content="black">
	<meta name="apple-mobile-web-app-capable" content="yes">
	<meta name="format-detection" content="telephone=no">
	
	<script type="text/javascript" src="../../../custom/jquery.min.js"></script>
	<link rel="stylesheet" href="../../js/layui/css/layui.css">
    <script src="../../js/layui/layui.js"></script>
    	
    <title>档案列表</title> 
  <style>
  	.layui-colla-title{text-align:center;}
  	.layui-colla-icon{ top:0;font-size:14px;margin-left:10px;position:initial;}
  	.layui-form-item{width:900px;margin:0 auto}
  	h4{text-align:center;margin-bottom:20px}
	.inline{ position: relative; display: inline-block; margin-right: 10px; }
	#green1 {background: #337ab7; color: white;}
	#green2 {background: #5fb878; color: white;}
	.layui-tab-card{border:none;box-shadow:none;}
  </style>
</head> 
<body>
<div class="layui-tab layui-tab-card" style="margin: 0px;">
  <ul class="layui-tab-title">
    <li class="layui-this">角色基本信息</li>
    <%-- <li>角色分配表单</li> --%>
    <li>角色分配权限</li>
  </ul>
  <%request.setCharacterEncoding("utf-8");%>
  <div class="layui-tab-content" style="h">
  	<%---角色基本信息 --%>
    <div class="layui-tab-item layui-show">
	  <jsp:include page="role_basic.jsp">
	    <jsp:param value="<%=role_id%>" name="roleid"/><!-- 角色id， -->
	  </jsp:include>
	</div>
	<%---角色分配表单
    <div class="layui-tab-item">
	  <jsp:include page="role_from.jsp">
	    <jsp:param value="<%=role_id%>" name="roleid"/>  <!-- 角色id， -->
	  </jsp:include>
    </div>
    
    <%---角色分配权限 --%>
    <div class="layui-tab-item">
	  <jsp:include page="role_jurisdiction.jsp">
	    <jsp:param value="<%=role_id%>" name="roleid"/>  <!-- 角色id， -->
	  </jsp:include>
	</div>	
    </div>
  </div>
</body> 	
	<script>
		layui.use(['layer', 'form', 'element'], function(){
		  var layer = layui.layer
		  ,form = layui.form
		  ,element = layui.element
		 
		 	function truess(str,roleid){
			    layer.ready(function(){
			    		layer.open({
							  closeBtn: 0,
							  content: str,
							  yes: function(index, layero){
									window.location.href="role_edit.jsp?role_id="+roleid;
					    			layer.close(index); //如果设定了yes回调，需进行手工关闭
					  			}
						}); 
			    }); 
			} 
				<%
					//发送邮箱
					SendMail sendMail = new SendMail();
					
					/**修改角色基本信息**/
					if("role_info".equals(ac)){
						String date = request.getParameter("date"); if(date==null){date="";}
						String roleid="",name="",available="",type="",homepage="";
						try {
							JSONArray arr = JSONArray.fromObject("[" + date + "]");
							for (int i = 0; i < arr.size(); i++) {
							   JSONObject obj = arr.getJSONObject(i);
							   roleid=obj.get("id").toString();				//角色id
							   name=obj.get("name").toString();             //角色名称
							   available=obj.get("available").toString();   //角色是否禁用
							   type=obj.get("type").toString();				//角色权限类型  （pc or app  or pc And app）
							   homepage=obj.get("homepage").toString();		//角色首页是否显示
							}
						}catch(Exception e) {
							out.println("layer.msg('系统错误,请刷新重试！');");
						}
						boolean up_role_state=false;
						String up_zRole="UPDATE zk_role  SET name = '"+name+"' , available = '"+available+"' , type = '"+type+"' , homepage = '"+homepage+"' WHERE id = '"+roleid+"' ;";
						up_role_state=db.executeUpdate(up_zRole);
						if(up_role_state){
							out.println("truess('修改成功','"+roleid+"');");
						}else{
							out.println("layer.msg('修改失败,请联系管理员！');");
						}
					/**修改角色查看权限的表单**/
					}else if("role_from_see".equals(ac)){
						String roleid = request.getParameter("roleid"); 
						if(roleid==null || roleid.length()==0){
							out.println("layer.msg('修改失败,请联系管理员！[角色id获取失败]');");
							
						}//角色id
						String see_from = request.getParameter("see_from"); if(see_from==null){see_from="";}//选中的表单id
System.out.println("see_from==="+see_from);						
						ArrayList<String> list =new ArrayList<String>();
						String see_from_arr[]=see_from.split(",");
						list.clear();
						for(int i=0;i<see_from_arr.length;i++){
							//拼写角色更新sql语句 
							list.add("( '"+roleid+"', '"+see_from_arr[i]+"', '0', NOW(), '"+Suid+"',  NOW(), '"+Suid+"')");
						}
						//该角色原有数据备份
						String role_fromid=db.executeQuery_str("SELECT GROUP_CONCAT(fromid )as str FROM role_from WHERE roleid= '"+roleid+"' AND  CODE='0'");
						//删除角色原有数据 
						boolean delete_role_state=false;						
						String delete_roleFrom="DELETE FROM role_from WHERE roleid= '"+roleid+"' AND  code='0' ";
						delete_role_state=db.executeUpdate(delete_roleFrom);
System.out.println("delete_role_state==="+delete_role_state);
System.out.println("list==="+list);
						if(delete_role_state){//删除成功
							//写入新的角色表单数据
							String insert_roleFrom="INSERT INTO role_from  ( roleid, fromid, CODE, createtime, createid, updatetime, updateid) VALUES "+list.toString().replaceAll("\\[","").replaceAll("\\]","");
							boolean up_role_state=false;
							up_role_state=db.executeUpdate(insert_roleFrom);
							if(up_role_state){
								out.println("truess('修改成功','"+roleid+"');");
							}else{
								out.println("layer.msg('修改失败,请联系管理员！');");
								
								sendMail.send(
					               "好车帮金融", 
					               "pc_管理角色出错", 
					               "出错接口模块:pc_管理角色【修改角色查看权限的表单】<br><br>" +
					               		"原有数据：表单id{"+role_fromid+"}<br><br>" +
					               		"报错所在行数:154",
					               "1503631902@qq.com"
					            );
							}
						}else{
							out.println("layer.msg('修改失败,请联系管理员！');");
							
							sendMail.send(
					               "好车帮金融", 
					               "pc_管理角色出错", 
					               "出错接口模块:pc_管理角色【修改角色查看权限的表单】<br><br>" +
					               		"原有数据：表单id{"+role_fromid+"}<br><br>" +
					               		"报错所在行数:166",
					               "1503631902@qq.com"
					        );
						}
					/***修改角色编辑权限的表单**/
					}else if("role_edit_from".equals(ac)){
						String roleid = request.getParameter("roleid"); 
						if(roleid==null || roleid.length()==0){
							out.println("layer.msg('修改失败,请联系管理员！[角色id获取失败]');");
							
						}//角色id
						String dite_from = request.getParameter("dite_from"); if(dite_from==null){dite_from="";}//选中的表单id
						//该角色原有数据备份
						String role_fromid=db.executeQuery_str("SELECT GROUP_CONCAT(fromid )as str FROM role_from WHERE roleid= '"+roleid+"' AND  CODE='1'");
						//删除角色原有数据
						boolean delete_role_state=false;						
						String delete_roleFrom="DELETE FROM role_from WHERE roleid= '"+roleid+"' AND  code='1' " ;
						delete_role_state=db.executeUpdate(delete_roleFrom);
						if(delete_role_state){//删除成功
							//写入新的角色表单数据
							String insert_roleFrom="INSERT INTO role_from  ( roleid, fromid, CODE, createtime, createid, updatetime, updateid) VALUES ( '"+roleid+"', '"+dite_from+"', '1', NOW(), '"+Suid+"',  NOW(), '"+Suid+"')";
							boolean up_role_state=false;
							up_role_state=db.executeUpdate(insert_roleFrom);
							if(up_role_state){
								out.println("truess('修改成功','"+roleid+"');");
							}else{
								out.println("layer.msg('修改失败,请联系管理员！');");
							}
						}else{
							out.println("layer.msg('修改失败,请联系管理员！');");
						}
						
					//修改角色pc端权限
					}else if("pc_role_info".equals(ac)){
						String roleid = request.getParameter("roleid"); 
						if(roleid==null || roleid.length()==0){
							out.println("layer.msg('修改失败,请联系管理员！[角色id获取失败]');");
							
						}//角色id
						String pc_roleid = request.getParameter("pc_roleid"); if(pc_roleid==null){pc_roleid="";}//选中的pc端权限id
						
				 
						
						//当前角色原有pc端权限
						String role_pcid=db.executeQuery_str("select menu_sys_id as str from zk_role where id='"+roleid+"';");
						
						//更新 pc端新权限
						boolean update_role_state=false;						
						String update_role="UPDATE zk_role SET menu_sys_id='#"+pc_roleid.replaceAll(",","#")+"#' WHERE id='"+roleid+"';";
						update_role_state=db.executeUpdate(update_role);
						if(update_role_state){//修改成功
							
							out.println("truess('修改成功','"+roleid+"');");
						}else{
							out.println("layer.msg('修改失败,请联系管理员！');");
							sendMail.send(
					               "好车帮金融", 
					               "pc_管理角色出错", 
					               "出错接口模块:pc_管理角色【更新 pc端新权限】<br><br>" +
					               		"原有数据：表单id{"+role_pcid+"}<br><br>" +
					               		"报错所在行数:242",
					               "1503631902@qq.com"
					        );
							
						}
					
					
					
					//修改角色app端角色
					}else if("app_role_info".equals(ac)){
						
						String roleid = request.getParameter("roleid"); 
						if(roleid==null || roleid.length()==0){
							out.println("layer.msg('修改失败,请联系管理员！[角色id获取失败]');");
							
						}//角色id
						String app_roleid = request.getParameter("app_roleid"); if(app_roleid==null){app_roleid="";}//角色app端  权限id
						
						//当前角色原有pc端权限
						String role_appid=db.executeQuery_str("SELECT GROUP_CONCAT(buttonid )as str FROM z_role_button_bak WHERE roleid='"+roleid+"'");
						//更新 app端新权限
						boolean delete_role_state=false;						
						String delete_role="DELETE FROM z_role_button_bak  WHERE roleid = '"+roleid+"' ;";
						delete_role_state=db.executeUpdate(delete_role);
						if(delete_role_state){//修改成功
							
								if(app_roleid==null || app_roleid.length()==0){//没有权限
									out.println("truess('修改成功','"+roleid+"');");
								}else{
										ArrayList<String> app_rolesql=new ArrayList<String>();
										String app_roleid_arr[]=app_roleid.split(",");
										app_rolesql.clear();
										for(int i=0;i<app_roleid_arr.length;i++){
											app_rolesql.add("( '"+roleid+"',  '"+app_roleid_arr[i]+"', NOW(),  '"+Suid+"', NOW(),   '"+Suid+"')");
										}
										
										
										boolean update_role_state=false;						
										String update_role="INSERT INTO z_role_button_bak  (  roleid,  buttonid,  createtime,  createid, updatetime,  updateid ) VALUES "+app_rolesql.toString().replaceAll("\\[","").replaceAll("\\]","")+";";
										update_role_state=db.executeUpdate(update_role);
										if(update_role_state){//修改成功
											out.println("truess('修改成功','"+roleid+"');");
										}else{
											out.println("layer.msg('修改失败,请联系管理员！');");
											sendMail.send(
									               "好车帮金融", 
									               "pc_管理角色出错", 
									               "出错接口模块:pc_管理角色【更新 app端新权限】<br><br>" +
									               		"原有数据：表单id{"+role_appid+"}<br><br>" +
									               		"报错所在行数:291",
									               "1503631902@qq.com"
									        );
											
										}
								}
						}else{
							out.println("layer.msg('修改失败,请联系管理员！');");
							sendMail.send(
					               "好车帮金融", 
					               "pc_管理角色出错", 
					               "出错接口模块:pc_管理角色【更新 app端新权限】<br><br>" +
					               		"原有数据：表单id{"+role_appid+"}<br><br>" +
					               		"报错所在行数:304",
					               "1503631902@qq.com"
					        );
							
						}
						
					}
					
				%>
		});
	</script>
</html>
<% if(db!=null)db.close();db=null;if(server!=null)server=null; %>