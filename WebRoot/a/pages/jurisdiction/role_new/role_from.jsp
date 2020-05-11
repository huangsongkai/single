<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%--角色相关表单页面 --%>
<%@include file="../../cookie.jsp"%>
<%String roleid = request.getParameter("roleid"); if(roleid==null){roleid="";}//获取角色id%>

<style>
	.layui-form-select .layui-input {padding-right: 0px;}
	.layui-form-checkbox span { height: 6%;}
</style>

<div class="layui-tab layui-tab-card" style="margin: -10px;">
  <ul class="layui-tab-title">
    <li class="layui-this">查看权限</li>
    <li>编辑权限</li>
  </ul>
  <div class="layui-tab-content "  >
		<%---查看权限 --%>
	    <div class="layui-tab-item layui-show" >
				<form class="layui-form"  action="?ac=role_from_see"  method="post" style="height: 80%;"  >
					  <div class="layui-form-item" pane="" style="width:100%;">
						    <div class="layui-input-block" id="role_from_see">
						      <%
					        	String   role_See_from="SELECT id,formname,IF(FIND_IN_SET(id,(SELECT IFNULL(GROUP_CONCAT(fromid),0) FROM role_from WHERE  roleid='"+roleid+"' AND CODE =0))=0,'false','true' )AS checked  FROM  form_name";
					        	ResultSet role_See_rs=db.executeQuery(role_See_from);
					        	String Table_comment="";
					        	int from_num=0;
					        	String role_See_checked="";
					        	while(role_See_rs.next()){
						        	if(role_See_rs.getBoolean("checked")){
						        		role_See_checked="checked=\"checked\"";
						        	}else{
						        		role_See_checked="";
						        	}
						        	Table_comment=role_See_rs.getString("formname");
					         %>
						      
						      <input type="checkbox"  lay-filter="checkbox"  name="fromname<%=from_num%>" lay-skin="primary" title="<%=Table_comment%>" value="<%=role_See_rs.getString("id")%>" <%=role_See_checked%>>
						     <%
					        	from_num++;
					        	} if(role_See_rs!=null){role_See_rs.close();}
					         %>
						    </div>
					  </div>
					  
					  <input type="hidden" name="roleid" id="roleid" value="<%=roleid%>" >
					  <input type="hidden" name="see_from" id="see_from" value="" >
					  <div class="layui-form-item" style="width:100%;">
					    <div class="layui-input-block" style="  float: right; margin-top: 5%;" >
					      <button class="layui-btn" lay-submit="role_from_see" lay-filter="role_from_see">立即提交</button>
					      <button type="reset" class="layui-btn layui-btn-primary">重置</button>
					    </div>
					  </div>
				</form>
	    </div>
	    <%---编辑权限--%>
	    <div class="layui-tab-item">
				<form class="layui-form"  action="?ac=role_edit_from"  method="post" style="height: 80%;"  >
					  <div class="layui-input-block" >
							<select name="dite_from" lay-filter="aihao">
								<option value="0">无</option>
							
								<%
						        	String   role_edit_from="SELECT id,formname,IF(FIND_IN_SET(id,(SELECT IFNULL(GROUP_CONCAT(fromid),0) FROM role_from WHERE  roleid='"+roleid+"' AND CODE =1))=0,'false','true' )AS checked ,(SELECT FIND_IN_SET(form_name.id,(SELECT GROUP_CONCAT(form_name.id) FROM role_from LEFT JOIN  form_name ON role_from.fromid=form_name.id WHERE role_from.code=1 AND role_from.roleid<>'"+roleid+"')))AS ifprohibit  FROM  form_name ";						        	
						        	ResultSet role_edit_rs=db.executeQuery(role_edit_from);
						        	String role_edit_checked="";
						        	String ifprohibit="";
						        	while(role_edit_rs.next()){
						        		if(role_edit_rs.getBoolean("checked")){
						        			role_edit_checked="selected=\"\"";
							        	}else{
							        		role_edit_checked="";
							        	}
							        	
							        	if(role_edit_rs.getInt("ifprohibit")>0){
						        			ifprohibit="disabled=\"\"";
							        	}else{
							        		ifprohibit="";
							        	}
						        %>
						        		<option value="<%=role_edit_rs.getString("id") %>" <%=role_edit_checked%>  <%=ifprohibit %>><%=role_edit_rs.getString("formname") %></option>
						        <%
						        	} if(role_edit_rs!=null){role_edit_rs.close();}
						        %>
						   </select>
					</div>
					  <input type="hidden" name="roleid" id="roleid" value="<%=roleid%>" >
					<div class="layui-form-item" style="width:100%;">
					    <div class="layui-input-block" style="  float: right; margin-top: 5%;" >
					      <button class="layui-btn" lay-submit="role_from_dite" lay-filter="role_from_dite">立即提交</button>
					      <button type="reset" class="layui-btn layui-btn-primary">重置</button>
					    </div>
				   </div>
				</form>
	     </div>
	</div>	
 </div>
<script>
var array = $('#role_from_see').find('input');
var arr = new Array();　
$.each( array , function(i, item){
    var state = $(item).prop('checked');
    if(state == true)  { arr.push(item.value); }
});

			layui.use(['form'], function() {
				var form = layui.form();
				<%--监听 查看权限的表单提交--%>
				
			
				form.on('checkbox(checkbox)', function(data){
				 var varlue=data.value;
				 
				  if(data.elem.checked){
				  	 arr.push(varlue);
				  }else{
				  	var result=0;
				  	result = $.inArray(varlue, arr);
				  	arr.splice(result,1);
				  }
				  
				  $("#see_from").val(arr)
				}); 
				
				form.on('submit(role_from_see)', function(data) {
				    return true;
				});
				<%--监听 修改权限的表单提交--%>
				form.on('submit(role_from_dite)', function(data) {
					//layer.alert(JSON.stringify(data.field), {
				    //  title: '最终的提交信息'
				    //});
					return false;
				});
			});
</script>


<% if(db!=null)db.close();db=null;if(server!=null)server=null; %>