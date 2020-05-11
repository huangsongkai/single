<%@ page trimDirectiveWhitespaces="true" %>
<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@page import="service.dao.db.Page"%>
<%@include file="../../cookie.jsp"%>
<%
/**
 *  角色列表
 */

%>

<%
				String id = request.getParameter("id"); if(id==null){id="";}//获取角色id
				
				if("upjurisdiction".equals(ac)){
					/**
					 * 更新 pc端权限 
					 */
						String pc_permissions = request.getParameter("pc_permissions"); if(pc_permissions==null){pc_permissions="";}//pc 端权限id
						//查询出原有数据,预防回滚 
						String original_data=db.executeQuery_str("select menu_sys_id as str from zk_role where id='"+id+"' ");					
						
						//更新pc 端语句
						pc_permissions=pc_permissions.replaceAll(",","#");
						String upsql="UPDATE zk_role SET menu_sys_id='#0#"+pc_permissions+"' WHERE id='"+id+"';";
						
						boolean upsql_syate= db.executeUpdate(upsql);
						
					/**
					 * 更新 手机端权限 
					 
						String mobile_rights = request.getParameter("mobile_rights"); if(mobile_rights==null){mobile_rights="";}//手机 端权限id
						
						//查询出原有数据,预防回滚 
						String mobile_data=db.executeQuery_str("SELECT  IFNULL(GROUP_CONCAT( CONCAT('(',roleid,',',buttonid,',','now()',',',createid,',','now()',',',updateid,')') SEPARATOR ','),'') FROM z_role_button WHERE roleid='"+id+"'");
						
						//手机端权限id 转数组 
						String mobileid_num[]=mobile_rights.split(",");
						ArrayList<String> list = new ArrayList<String>();	
						
						if(mobile_rights.length()>=1){//角色手机权限不为空 
							//清空该角色所有权限
							boolean delete_state=db.executeUpdate("DELETE FROM z_role_button  WHERE roleid = '"+id+"' ;");
							if(delete_state){//删除成功
								//写入最新的角色 的权限 数据 
								list.clear();			
								for(int i=0;i<mobileid_num.length;i++){
									list.add("('"+id+"', '"+mobileid_num[i]+"', now(), '"+Suid+"', now(), '"+Suid+"')");
								}
							}
						}else{
							//清空该角色所有权限
							db.executeUpdate("DELETE FROM z_role_button  WHERE roleid = '"+id+"' ;");
						}
						
					
						if(list.size()>0){
							 //写入  手机端权限 
							 String insert="INSERT INTO z_role_button  (roleid, buttonid, createtime, createid, updatetime, updateid) VALUES "+list.toString().replaceAll("\\[","").replaceAll("\\]","");
							 boolean insert_state=db.executeUpdate(insert);
							 if(insert_state==false){
							 	//回滚原有数据
							 	db.executeUpdate("INSERT INTO z_role_button  (roleid, buttonid, createtime, createid, updatetime, updateid) VALUES "+mobile_data+";");
							 	out.println("<script>");
							 	out.println("window.location.href='?ac=\"\"?id="+id+"';");
							 	out.println("</script>");
								if(db!=null)db.close();db=null;if(server!=null)server=null;
								return;
							 }else{
							 	if(upsql_syate==false){//更新角色  手机端 权限 失败 
							 		out.println("<script>");
									out.println("window.location.href='?ac=\"\"?id="+id+"';");
									out.println("</script>");
									if(db!=null)db.close();db=null;if(server!=null)server=null;
									return;
								}else{
									out.println("<script>");
									out.println("alert('修改成功!');");
									out.println("parent.location.href='edit_role.jsp?id="+id+"';");
									out.println("</script>");
									if(db!=null)db.close();db=null;if(server!=null)server=null;
									return;
								}
							 }
						}
						*/	
						
						if(upsql_syate==false){//更新角色 pc端 权限 失败 
							    out.println("<script>");
								out.println("window.location.href='?ac=\"\"?id="+id+"';");
								out.println("</script>");
								if(db!=null)db.close();db=null;if(server!=null)server=null;
								return;
						}else{
								out.println("<script>");
								out.println("alert('修改成功!');");
								out.println("parent.location.href='edit_role.jsp?id="+id+"';");
								out.println("</script>");
								if(db!=null)db.close();db=null;if(server!=null)server=null;
								return;
						}
				 }else{
%>
<!doctype html>
<html>

	<head>
		<meta charset="utf-8">
		<title>权限</title>
		<meta name="renderer" content="webkit">
		<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
		<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
		<link rel="stylesheet" href="../../js/layui/css/layui.css" />
		<script src="../../js/layui/layui.js" charset="utf-8"></script>
		<style type="text/css">
			body{
				height: 1200px;
			}
			#demo{
				margin: 30px 100px;
			}
			.descripttion{
				width: 1000px;
				margin: 50px;
			}
			body>ul{
				display: inline-block;
				width: 400px;
				margin: 20px;
			} 
		</style>
	</head>

	<body style="height: 100%;">
		<form  Method="post" action="?ac=upjurisdiction&id=<%=id%>">
			<fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
				<legend>pc端权限</legend>
			</fieldset>
				<input type="hidden" name="pc_permissions" id="pc_permissions" value=""><!--pc端权限-->
				<ul id="tree1" style="margin-left: 10%;"></ul>
			<fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
				<legend>手机端权限</legend>
			</fieldset>
				 <input type="hidden" name="mobile_rights" id="mobile_rights" value="" ><!--手机端权限-->	
				<ul id="tree2" style="margin-left: 10%;"></ul>
			<div class="layui-form-item" style="margin-top: 10%;" >
					<div class="layui-input-block">
						<button class="layui-btn" lay-submit="" lay-filter="demo1" >立即提交</button>
						<button type="reset" class="layui-btn layui-btn-primary">重置</button>
					</div>
	   		</div>
		</form>
		
		<script>
			layui.use('tree',function() {
				var $ = layui.jquery;
				
				var tree = layui.tree({
					elem: '#tree1', //指定元素，生成的树放到哪个元素上
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
				
				var tree = layui.tree({
					elem: '#tree2', //指定元素，生成的树放到哪个元素上
					check: 'checkbox', //勾选风格
					skin: 'as', //设定皮肤
					drag: true,//点击每一项时是否生成提示信息
					checkboxName: 'aa',//复选框的name属性值
					checkboxStyle: "",//设置复选框的样式，必须为字符串，css样式怎么写就怎么写
					nodes: [ //节点
								<%
						        	String   role_edit_from="SELECT id,NAME,IF((SELECT COUNT(1) FROM z_role_button,z_buttonfuntion WHERE z_role_button.buttonid=z_buttonfuntion.id AND  button.id = z_buttonfuntion.buttonid AND z_role_button.roleid="+id+")>0,'true','false')AS checked  FROM button where id != 2 ";
						        	
						        	System.out.println("role_edit_from "+role_edit_from);
						        	
						        	ResultSet role_edit_rs=db.executeQuery(role_edit_from);
						        	String phone_name="";
						        	String checked_state="";
						        	String phone_value="";
						        	while(role_edit_rs.next()){
							        	
										phone_name=role_edit_rs.getString("name");
										checked_state=role_edit_rs.getString("checked");
										phone_value=role_edit_rs.getString("id");
						        %>
									{	
										name: '<%=phone_name%>', //节点名称
										checked: <%=checked_state%>,//节点是否勾选
										checkboxValue: <%=phone_value%>,//复选框的值
										children: 	[
														<%
															String sql4="SELECT id ,z_buttonfuntion.buttonname AS buttonname,buttonid,IF(FIND_IN_SET(id,(SELECT GROUP_CONCAT(z_role_button.buttonid) FROM z_buttonfuntion,z_role_button WHERE z_buttonfuntion.buttonid = "+phone_value+" AND z_role_button.roleid = "+id+" AND z_buttonfuntion.id = z_role_button.buttonid))!=0,'true','false') as checked FROM z_buttonfuntion WHERE z_buttonfuntion.buttonid = "+phone_value+";";
															System.out.println("sql4+++==="+sql4);
															ResultSet rs_sql4=db.executeQuery(sql4);
															while(rs_sql4.next()){
																String phone_name1=rs_sql4.getString("buttonname");
																String checked_state1=rs_sql4.getString("checked");
																String phone_value1=rs_sql4.getString("id");
														%>
															{
																name: '<%=phone_name1%>',
																checked: <%=checked_state1%>,
																checkboxValue: <%=phone_value1%> ,
																<%
																	if("1".equals(rs_sql4.getString("buttonid"))){
																%>
																	children:[
																		<%
																			String sql5 = "SELECT id,buttonname  ,IF(FIND_IN_SET(id,(SELECT GROUP_CONCAT(z_role_button.buttonid) FROM z_buttonfuntion,z_role_button WHERE  z_role_button.roleid = "+id+" AND z_buttonfuntion.id = z_role_button.buttonid))!=0,'true','false') AS checked FROM z_buttonfuntion WHERE fatherid = '"+phone_value1+"' ;";
																			System.out.println("sql5======"+sql5);
																			ResultSet rs_sql5 = db.executeQuery(sql5);
																			while(rs_sql5.next()){
																				String phone_name2=rs_sql5.getString("buttonname");
																				String checked_state2=rs_sql5.getString("checked");
																				String phone_value2=rs_sql5.getString("id");
																		
																		%>
																		
																		
																		{
																			name: '<%=phone_name2%>',
																			checked: <%=checked_state2%>,
																			checkboxValue: <%=phone_value2%> ,
																		},
																	
																		<%}%>
																	]
																	
																	
																<%		
																	}
																%>
														    },
														<%}if(rs_sql4!=null){rs_sql4.close();}%>
													]
								    },	
									
								<%	
									}if(role_edit_rs!=null){role_edit_rs.close();}
								%>
								
					        ]
				});

				$('button').click(function() {
					//pc端权限数据集合
					var array = $('#tree1').find('input');
					var arr = [];
					$.each( array , function(i, item){
					    var state = $(item).prop('checked');
					    if(state == true)  {
					    	//alert(item.value); //console.log(item);
					    	arr.push(item.value); 
					    }
					});
					//console.log("pc端："+arr);
					$('#pc_permissions').val(arr);
					
					//app端权限数据集合
					var array2 = $('#tree2').find('input');
					var arr2 = [];
					$.each( array2 , function(i, item){
					    var state1 = $(item).prop('checked');
					    if(state1 == true) {
					    	//alert(item.value); //console.log(item);
					    	arr2.push(item.value); 
					    }
					});
					//console.log("手机端："+unique(arr2));
					$('#mobile_rights').val(unique(arr2));
					
					return true ;
				});
			});
			//去除重复数组
			function unique(arr){
				var tmp = new Array();
			 
				for(var m in arr){
					tmp[arr[m]]=1;
				}
				//再把键和值的位置再次调换
				var tmparr = new Array();
				 
				for(var n in tmp){
					tmparr.push(n);
				}
			 return tmparr;
			}
		</script>
	</body>
</html>
<%}

//插入常用菜单日志
int   TagMenu=db.Row("SELECT COUNT(*) as row FROM  menu_worker  WHERE sysmenuid='"+PMenuId+"' and  workerid='"+Suid+"' and  companyid="+Scompanyid);
if(TagMenu==0){
  		db.executeUpdate("INSERT INTO `menu_worker`(`sysmenuid`,`workerid`,`countes`,`companyid`) VALUES ('"+PMenuId+"','"+Suid+"','1','"+Scompanyid+"');"); 
}else{
   		db.executeUpdate("UPDATE  `menu_worker` SET `countes`=countes+1,`usetime`=now() WHERE  sysmenuid='"+PMenuId+"' and  workerid='"+Suid+"' and  companyid="+Scompanyid);
}
%>
<%if(db!=null)db.close();db=null;if(server!=null)server=null;%>