<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@include file="../../cookie.jsp"%>
<%--角色基本信息页面 --%>
<%String roleid = request.getParameter("roleid"); if(roleid==null){roleid="";}//获取角色id%>

<style>
.layui-form-select .layui-input {
    padding-right: 0px;
}
</style>
      <form class="layui-form" action="?ac=role_info"  method="post" style="height: 80%;"  >
      	  <%
				String userinfo="SELECT id,name,rolecode,available,type,homepage FROM zk_role where id='"+roleid+"' ";
					
				ResultSet user_rs =db.executeQuery(userinfo);
					
				if(user_rs.next()){
		  %>
		  			<div class="layui-form-item" style="width:100%;" >
			  			<div class="layui-inline">
							 <label class="layui-form-label">角色id:</label>
					      	 <div class="layui-input-block">
					       	     <input type="text"  name="id" readonly="readonly" value="<%=user_rs.getString("id")%>" class="layui-input">
					         </div>
						</div>
						<div class="layui-inline">
					      	  <label class="layui-form-label">角色标识:</label>
						      <div class="layui-input-block">
						        	<input type="text" name="rolecode" readonly="readonly"  value="<%=user_rs.getString("rolecode")%>" class="layui-input">
						      </div>
						</div>
						<div class="layui-inline">
							  <label class="layui-form-label">角色名称:</label>
							  <div class="layui-input-block">
						  			<input type="text" name="name"  value="<%=user_rs.getString("name")%>" class="layui-input">
							  </div>
						</div>
					    <div class="layui-inline">
							<label class="layui-form-label">启用状态:</label>
							<div class="layui-input-block" >
								<%--available 0:禁用状态 1:启用状态 --%>
								<select name="available" lay-filter="aihao">
									<%if("1".equals(user_rs.getString("available"))){%>
										<option value="0" >禁用状态</option>
										<option value="1" selected="">启用状态</option>
									<%}else{%>
										<option value="0" selected="">禁用状态</option>
										<option value="1" >启用状态</option>
									<%}%>
								</select>
							</div>
					    </div>
					    <div class="layui-inline">
							<label class="layui-form-label">权限状态:</label>
							<div class="layui-input-block">
								<%--type 0:pc端 1:手机端，2：手机与pc --%>
								<select name="type" lay-filter="aihao">
									<%if("0".equals(user_rs.getString("type"))){%>
										<option value="0" selected="">pc端</option>
										<option value="1" >app端</option>
										<option value="2" >全部</option>
									<%}else if("1".equals(user_rs.getString("type"))){%>
										<option value="0" >pc端</option>
										<option value="1" selected="">app端</option>
										<option value="2" >全部</option>
									<%}else {%>
										<option value="0" >pc端</option>
										<option value="1" >app端</option>
										<option value="2" selected="">全部</option>
									<%}%>
								</select>
							</div>
					    </div>
					    <div class="layui-inline">
							<label class="layui-form-label">首页状态:</label>
							<div class="layui-input-block">
								<%--homepage  是否显示首页 0:显示，1:不显示--%>
								<select name="homepage" lay-filter="aihao">
									<%if("0".equals(user_rs.getString("homepage"))){%>
										<option value="0" selected="">首页启用</option>
										<option value="1" >首页禁用</option>
									<%}else {%>
										<option value="0" >首页启用</option>
										<option value="1" selected="">首页禁用</option>
									<%}%>
								</select>
							</div>
					    </div>
				   </div>
		  <%				
				}
		  %>
		   <input type="hidden" value="" name="date" id="date">
		  <div class="layui-form-item" style="width:100%;">
			<div class="layui-input-block" style="margin-left: 75%;">
				<button class="layui-btn" lay-submit="" lay-filter="role_info">立即提交</button>
				<button type="reset" class="layui-btn layui-btn-primary">重置</button>
			</div>
		</div>
	  </form>    
<script>
			layui.use(['form'], function() {
				var form = layui.form();
				//监听提交
				form.on('submit(role_info)', function(data) {
				$("#date").val(JSON.stringify(data.field));
				return true;
				});
			});
</script>


<% if(db!=null)db.close();db=null;if(server!=null)server=null; %>