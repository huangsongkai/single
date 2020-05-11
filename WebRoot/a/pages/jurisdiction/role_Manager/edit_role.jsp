<%@ page trimDirectiveWhitespaces="true" %>
<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@page import="service.dao.db.Page"%>
<%@include file="../../cookie.jsp"%>
<%
/**
 *  角色列表
 */
String id = request.getParameter("id"); if(id==null){id="";}//获取角色id

%>
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
		<link rel="stylesheet" href="../../js/layui/css/layui.css">
     	<link rel="stylesheet" href="../../css/sy_style.css?22">
		<title>角色编辑页面</title> 
	    <style type="text/css">
			.inline{ position: relative; display: inline-block; margin-right: 10px; }
	    </style>
	</head>
	<script type="text/javascript">
	
		alert(<%=id%>);
	
	</script>
	<body>
		<div style="margin: 15px;">
			<fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
				<legend>角色编辑</legend>
			</fieldset>

			<form class="layui-form" action="up_roleFrom.jsp" method="post">
				
				<%
					String userinfo="SELECT id,name,rolecode,available,type,homepage FROM zk_role where id='"+id+"' ";
					
					ResultSet user_rs =db.executeQuery(userinfo);
					
					if(user_rs.next()){
					
				%>
				<div class="layui-form-item inline">
					<label class="layui-form-label">角色id</label>
					<div class="layui-input-inline">
						<input type="text" name="role_id" lay-verify="uid" autocomplete="off" class="layui-input" disabled="disabled" value="<%=user_rs.getString("id")%>">
					</div>
				</div>
				<input type="hidden" name="usernameid" lay-verify="nickname" autocomplete="off" class="layui-input" value="<%=user_rs.getString("id")%>">
				<div class="layui-form-item inline">
					<label class="layui-form-label">角色标识</label>
					<div class="layui-input-inline">
						<input type="text" name="rolecode" lay-verify="nickname" disabled autocomplete="off" class="layui-input" value="<%=user_rs.getString("rolecode")%>">
					</div>
				</div>
				<div class="layui-form-item inline">
					<label class="layui-form-label">角色名称</label>
					<div class="layui-input-inline">
						<input type="text" name="role_name" lay-verify="username" autocomplete="off" class="layui-input" value="<%=user_rs.getString("name")%>">
					</div>
				</div>
				<div class="layui-form-item inline">
					<label class="layui-form-label">是否禁用</label>
					<div class="layui-input-inline">
						<select name="available"> 
							<option value=""></option>
						        <%
						        	int available=user_rs.getInt("available");
						        	String  available_syst="";
						        	if(available==1){//是否可用,1：可用，0不可用
						        		available_syst="<option value=\"1\" selected=\"\">启用</option> <option value=\"0\" >禁用</option>";
						        	}else{
						        		available_syst="<option value=\"1\" >启用</option> <option value=\"0\" selected=\"\">禁用</option>";
						        	}
						        %>
							   <%=available_syst%>
						</select>
					</div>
				</div>
				<div class="layui-form-item inline"> 
					<label class="layui-form-label">权限类型</label>
					<div class="layui-input-inline">
						<select name="role_type">
							<option value=""></option>
						        <%
						        	int type=user_rs.getInt("type");
						        	String  state_type="";
						        	if(type==0){// 0:显示，1:不显示
						        		state_type="<option value=\"0\" selected=\"\">app端</option> <option value=\"1\" >PC端</option>  <option value=\"2\" > 全部</option>";
						        	}else if(type==0){
						        		state_type="<option value=\"0\" >app端</option> <option value=\"1\" selected=\"\">PC端</option>  <option value=\"2\" > 全部</option>";
						        	}else{
						        		state_type="<option value=\"0\" >app端</option> <option value=\"1\" >PC端</option> <option value=\"2\" selected=\"\" > 全部</option>";
						        	}
						        %>
							   <%=state_type%>
						</select>
					</div>
				</div>
				<div class="layui-form-item inline">
					<label class="layui-form-label">是否有首页</label>
					<div class="layui-input-inline">
						<select name="role_homepage">
							<option value=""></option>
						        <%
						        	int state=user_rs.getInt("homepage");
						        	String  state_syst="";
						        	if(state==0){// 0:显示，1:不显示
						        		state_syst="<option value=\"0\" selected=\"\"> 有首页</option> <option value=\"1\" > 无首页</option>";
						        	}else{
						        		state_syst="<option value=\"1\" > 有首页</option> <option value=\"1\" selected=\"\"> 无首页</option>";
						        	}
						        %>
							   <%=state_syst%>
						</select>
					</div>
				</div>
				<fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
					<legend>角色操作的表单</legend>
				</fieldset>
				<div class="layui-form-item">
					<label class="layui-form-label">角色查看的</label>
					<div class="layui-input-block" style="padding-left: 10px;border: 1px solid #d8d7d7;" id="role_See_fromid">
								<%
						        	String   role_See_from="SELECT id,formname,IF(FIND_IN_SET(id,(SELECT IFNULL(GROUP_CONCAT(fromid),0) FROM role_from WHERE  roleid='"+id+"' AND CODE =0))=0,'false','true' )AS checked  FROM  form_name";
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
						        	    <input type="checkbox" name="fromname<%=from_num%>" lay-skin="primary" title="<%=Table_comment%>" value="<%=role_See_rs.getString("id")%>" <%=role_See_checked%>>
						        	    <input type="hidden" name="see_from" id="see_from" value="" >
						        <%
						        	from_num++;
						        	} if(role_See_rs!=null){role_See_rs.close();}
						        %>
					</div>
				</div>
				<div class="layui-form-item">
					<label class="layui-form-label">角色编辑的</label>
					<div class="layui-input-block" >
							<select name="role_edit_from" lay-filter="aihao">
								<option value="0">无</option>
							
								<%
						        	String   role_edit_from="SELECT id,formname,IF(FIND_IN_SET(id,(SELECT IFNULL(GROUP_CONCAT(fromid),0) FROM role_from WHERE  roleid='"+id+"' AND CODE =1))=0,'false','true' )AS checked ,(SELECT FIND_IN_SET(form_name.id,(SELECT GROUP_CONCAT(form_name.id) FROM role_from LEFT JOIN  form_name ON role_from.fromid=form_name.id WHERE role_from.code=1 AND role_from.roleid<>'"+id+"')))AS ifprohibit  FROM  form_name ";						        	
						        	System.out.println("role_edit_from=="+role_edit_from);
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
				</div>
				<fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
					<legend>角色拥有的权限</legend>
				</fieldset>
				<div id="role_Jurisdiction">
					<b class="layui-btn" style="margin-left: 2%;"  onclick="Jurisdiction_edit(<%=user_rs.getString("id")%>)">修改角色权限</b>
				</div>	
				<%}if(user_rs!=null){user_rs.close();} %>
				<div class="layui-form-item" style="margin-top: 3%;">
					<div class="layui-input-block">
						<button class="layui-btn" lay-submit="" lay-filter="submit" >立即提交</button>
						<button type="reset" class="layui-btn layui-btn-primary">重置</button>
					</div>
				</div>
			</form>
		</div>
		<script type="text/javascript" src="../../../custom/jquery.min.js"></script>
		<script type="text/javascript" src="../../pages/js/layui/layui.js"></script>
		<script src="../../../pages/js/layui/layui.js"></script>
		<script>
		
		function Jurisdiction_edit(obj){
			layer.open({
				  type: 2,
				  title: '修改角色权限',
				  shadeClose: true,
				  maxmin:1,
				  shade: 0.5,
				  area: ['300px', '400px'],
				  content: 'jurisdiction_edit.jsp?id='+obj 
				}); 
		}
			layui.use(['form', 'layedit', 'laydate'], function() {
				var form = layui.form(),
					layer = layui.layer,
					layedit = layui.layedit,
					laydate = layui.laydate;
					
				$('button').click(function() {
					
					var array = $('#role_See_fromid').find('input');
					var arr = [];
					$.each( array , function(i, item){
					    var state = $(item).prop('checked');
					    if(state == true)  {
					    	arr.push(item.value); 
					    }
					});
					$('#see_from').val(arr);
					window.location.href="?ac=up_roleinfo&id=<%=id%>";
				});
			});
			layui.use('tree',function() {
				var $ = layui.jquery;
				
				var tree = layui.tree({
					elem: '#demo', //指定元素，生成的树放到哪个元素上
					check: 'checkbox', //勾选风格
					skin: 'as', //设定皮肤
					drag: true,//点击每一项时是否生成提示信息
					checkboxName: 'aa',//复选框的name属性值
					checkboxStyle: "",//设置复选框的样式，必须为字符串，css样式怎么写就怎么写
					nodes: [ //节点
								<%  
									//String filenum_sql="SELECT depth as Row FROM menu_sys ORDER BY depth DESC LIMIT 1";
									//int filenum=db.Row(filenum_sql);
									
									String file_sql1="SELECT id,menuname,IF(FIND_IN_SET(id,REPLACE ( (SELECT menu_sys_id FROM zk_role WHERE  id="+id+"), '#', ',' )) =0,'false','true' )AS checked   FROM menu_sys WHERE depth=1 and fatherid=0;";
									ResultSet rs_file1=db.executeQuery(file_sql1);
									while(rs_file1.next()){
									String rs_file1_id=rs_file1.getString("id");
									String rs_file1_menuname=rs_file1.getString("menuname");
									String rs_file1_checked=rs_file1.getString("checked");
								%>	
									{	
										name: '<%=rs_file1_menuname%>', //节点名称
										checked: <%=rs_file1_checked%>,//节点是否勾选
										checkboxValue: <%=rs_file1_id%>,//复选框的值
										children: 	[
														<%
															String file_sql2="SELECT id,menuname, IF(FIND_IN_SET(id,REPLACE ( (SELECT menu_sys_id FROM zk_role WHERE  id="+id+"), '#', ',' )) =0,'false','true' )AS checked  FROM menu_sys WHERE depth=2 and fatherid="+rs_file1_id+";";
															ResultSet rs_file2=db.executeQuery(file_sql2);
															while(rs_file2.next()){
																String rs_file2_id=rs_file2.getString("id");
																String rs_file2_menuname=rs_file2.getString("menuname");
																String rs_file2_checked=rs_file2.getString("checked");
														%>
															{
																name: '<%=rs_file2_menuname%>',
																checked: <%=rs_file2_checked%>,
																checkboxValue: <%=rs_file2_id%> ,
																children:   [
																				<%
																					String file_sql3="SELECT id,menuname, IF(FIND_IN_SET(id,REPLACE ( (SELECT menu_sys_id FROM zk_role WHERE  id="+id+"), '#', ',' )) =0,'false','true' )AS checked  FROM menu_sys WHERE depth=3 and fatherid="+rs_file2_id+";";
																					ResultSet rs_file3=db.executeQuery(file_sql3);
																					while(rs_file3.next()){
																						String rs_file3_id=rs_file3.getString("id");
																						String rs_file3_menuname=rs_file3.getString("menuname");
																						String rs_file3_checked=rs_file3.getString("checked");
																				%>
																						{
																							name: '<%=rs_file3_menuname%>',
																							checked: <%=rs_file3_checked%>,
																							checkboxValue: <%=rs_file3_id%> ,
																					    },
																				<%}if(rs_file3!=null){rs_file3.close();}%>
																				
																			]
														    },
														<%}if(rs_file2!=null){rs_file2.close();}%>
												 	]
								    },	
									
								<%	
									}if(rs_file1!=null){rs_file1.close();}
								%>
								
					        ]
				});

			});
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
<%
if(db!=null)db.close();db=null;if(server!=null)server=null;
%>