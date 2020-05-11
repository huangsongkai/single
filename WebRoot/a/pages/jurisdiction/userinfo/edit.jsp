<%@ page trimDirectiveWhitespaces="true" %>
<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@page import="service.dao.db.Page"%>
<%@include file="../../cookie.jsp"%>
<%@page import="org.apache.commons.lang3.StringUtils"%>
<%
/**
 *  用户列表
 */
String uid = request.getParameter("uid"); if(uid==null){uid="";}//获取用户uid
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
		<link rel="stylesheet" href="../../js/layui/css/layui.css" media="all" />
		<script type="text/javascript" src="../../js/layui/layui.js"></script>
		<script type="text/javascript" src="../../js/layui/layui.js"></script>
		<script src="../../../pages/js/layui/layui.js"></script>
		 	<!-- zTree -->
		<link rel="stylesheet" href="../../js/zTree/css/demo.css" type="text/css">
		<link rel="stylesheet" href="../../js/zTree/css/zTreeStyle/zTreeStyle.css" type="text/css">
		<script type="text/javascript" src="../../js/zTree/js/jquery-1.4.4.min.js"></script>
		<script type="text/javascript" src="../../js/zTree/js/jquery.ztree.core.js"></script>
		<script type="text/javascript" src="../../js/zTree/js/jquery.ztree.excheck.js"></script>
		<script src="../../../pages/js/ajaxs.js"></script>
		<title>用户信息编辑页面</title> 
	    <style type="text/css">
			.inline{ position: relative; display: inline-block; margin-right: 10px; }
	    </style>
	</head>

	<body>
		<div style="margin: 15px;">
			<fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
				<legend>用户基本信息</legend>
			</fieldset>

			<form class="layui-form" action="?ac=userionfo" method="post">
				
				<%
					//String userinfo="SELECT uid,(SELECT sys_role_id FROM zk_user_role WHERE zk_user_role.sys_user_id=user_worker.uid)as role_id ,nickname, username, sex, usermob, email, add_time, state, regionalcode,userole,teacherid  FROM  user_worker where uid='"+uid+"'; ";
					String userinfo="SELECT uid,nickname, username, sex, usermob, email, add_time, state, user_association,userole  FROM  user_worker where uid='"+uid+"'; ";
					//获取角色id
					String sql_roleids = "select sys_role_id from zk_user_role where sys_user_id = '"+ uid + "' ";
					ResultSet roleSet = db.executeQuery(sql_roleids);
					List<String> list = new ArrayList<String>();
					while (roleSet.next()) {
						list.add(roleSet.getString("sys_role_id"));
					}
					ResultSet user_rs =db.executeQuery(userinfo);
					
					int roleid=0;
					if(user_rs.next()){
						//roleid=user_rs.getInt("role_id");
					
				%>
				<div class="layui-form-item inline">
					<label class="layui-form-label">用户id</label>
					<div class="layui-input-inline">
						<input type="text" name="user_id" lay-verify="uid" autocomplete="off" class="layui-input" disabled="disabled" value="<%=user_rs.getString("uid")%>">
					</div>
				</div>
				<input type="hidden" name="usernameid" lay-verify="nickname" autocomplete="off" class="layui-input" value="<%=user_rs.getString("uid")%>">
				<div class="layui-form-item inline">
					<label class="layui-form-label">用户昵称</label>
					<div class="layui-input-inline">
						<input type="text" name="nickname" lay-verify="nickname" autocomplete="off" class="layui-input" value="<%=user_rs.getString("nickname")%>">
					</div>
				</div>
				<div class="layui-form-item inline">
					<label class="layui-form-label">用户姓名</label>
					<div class="layui-input-inline">
						<input type="text" name="username" lay-verify="username" autocomplete="off" class="layui-input" value="<%=user_rs.getString("username")%>">
					</div>
				</div>
				<div class="layui-form-item inline">
					<label class="layui-form-label">性别</label>
					<div class="layui-input-inline">
						<select name="sex" lay-verify="required"> 
							<option value=""></option>
						        <%
						        	int sex=user_rs.getInt("sex");
						        	String  sex_syst="";
						        	if(sex==1){//值为1时是男性，值为2时是女性，值为0时是未知
						        		sex_syst="<option value=\"1\" selected=\"\"> 男</option> <option value=\"2\" > 女</option>";
						        	}else{
						        		sex_syst="<option value=\"1\" > 男</option> <option value=\"2\" selected=\"\"> 女</option>";
						        	}
						        %>
							   <%=sex_syst%>
						</select>
					</div>
				</div>
				<div class="layui-form-item inline">
					<label class="layui-form-label">用户手机号</label>
					<div class="layui-input-inline">
						<input type="text" name="usermob" lay-verify="usermob" autocomplete="off" class="layui-input" value="<%=user_rs.getString("usermob")%>">
						<input type="hidden" name="oldusermob"  value="<%=user_rs.getString("usermob") %>"/>
					</div>
				</div>
				<div class="layui-form-item inline">
					<label class="layui-form-label">用户邮箱</label>
					<div class="layui-input-inline">
						<input type="text" name="email" lay-verify="email" autocomplete="off" class="layui-input" value="<%=user_rs.getString("email")%>">
					</div>
				</div>
				<div class="layui-form-item inline">
					<label class="layui-form-label">是否禁用</label>
					<div class="layui-input-inline">
						<select name="state">
							<option value=""></option>
						        <%
						        	int state=user_rs.getInt("state");
						        	String  state_syst="";
						        	if(state==1){//1正常 0 禁止
						        		state_syst="<option value=\"1\" selected=\"\"> 正常</option> <option value=\"0\" > 禁用</option>";
						        	}else{
						        		state_syst="<option value=\"1\" > 正常</option> <option value=\"0\" selected=\"\"> 禁用</option>";
						        	}
						        %>
							   <%=state_syst%>
						</select>
					</div>
				</div>
<%--				<div class="layui-form-item inline">--%>
<%--					<label class="layui-form-label">所属公司</label>--%>
<%--					<div class="layui-input-inline">--%>
<%--						<select name="regionalcode">--%>
<%--							<%--%>
<%--								String s_regional_sql="SELECT regionalcode,regionalname,IF(regionalcode='"+user_rs.getString("regionalcode")+"',TRUE,FALSE)as disabled FROM s_regional_table";--%>
<%--								ResultSet s_regional_rs=db.executeQuery(s_regional_sql);--%>
<%--								while(s_regional_rs.next()){--%>
<%--								String  selected="";--%>
<%--								if(s_regional_rs.getInt("disabled")==1){--%>
<%--									selected="selected";--%>
<%--								}--%>
<%--								--%>
<%--							%>	--%>
<%--								<option value="<%=s_regional_rs.getString("regionalcode")%>" <%=selected %>> <%=s_regional_rs.getString("regionalname")%></option>--%>
<%--							<%--%>
<%--								}if(s_regional_rs!=null){s_regional_rs.close();}--%>
<%--							%>--%>
<%--						</select>--%>
<%--					</div>--%>
<%--				</div>--%>
				<div class="layui-form-item inline">
					<label class="layui-form-label">用户类别</label>
					<div class="layui-input-inline">
						<select name='userole' lay-filter='userole'>
							<option value=""></option>
								<%
									String userole = user_rs.getString("userole");
									System.out.println("userrole "+userole);
									if(userole==null) userole="0";
									if(userole.equals("1")){
										out.println("<option value='1' selected>教职工</option><option value='2'>学生</option><option value='3'>家长</option><option value='4'>管理员</option>");
									}else if(userole.equals("2")){
										out.println("<option value='1' >教职工</option><option value='2' selected>学生</option><option value='3'>家长</option><option value='4'>管理员</option>");
									}else if(userole.equals("3")){
										out.println("<option value='1' >教职工</option><option value='2'>学生</option><option value='3' selected>家长</option><option value='4'>管理员</option>");
									}else if(userole.equals("4")){
										out.println("<option value='1' >教职工</option><option value='2'>学生</option><option value='3' >家长</option><option value='4' selected >管理员</option>");
									}
									else{
										out.println("<option></option><option value='1' >教师</option><option value='2'>学生</option><option value='3' >家长</option><option value='4'>管理员</option>");
									}
								%>
						</select>
					</div>
				</div>
					<div class="layui-form-item inline">
					<label class="layui-form-label">用户角色</label>
					<div class="layui-input-inline">
						<div class="layui-input-inline">
							<%
								String role_sql="SELECT t.sys_role_id,t1.name FROM zk_user_role t,zk_role t1 where t1.id=t.sys_role_id and t.sys_user_id ="+uid;
								ResultSet role_rs=db.executeQuery(role_sql);
								String roleids ="";
								String rolenames ="";
								while(role_rs.next()){
									roleids =roleids + role_rs.getString("sys_role_id")+",";
									rolenames =rolenames + role_rs.getString("name")+",";
								}if(role_rs!=null){role_rs.close();}
								if(roleids.indexOf(",")>0){
									roleids = roleids.substring(0,roleids.length()-1);
									rolenames = rolenames.substring(0,rolenames.length()-1);
								}
							%>
						<input type="text"  id="citySel"  lay-verify="required" autocomplete="off" class="layui-input" onclick="showMenu(); return false;" readonly="readonly" value="<%=rolenames %>">
						<input type="hidden"  id="role_id" name="role_id"  value="<%=roleids %>" > 
					</div>
					<div id="menuContent" class="menuContent" style="display:none; position: absolute;z-index:999;margin-top: 39px;margin-left: 5px;">
						<ul id="treeDemo" class="ztree" style="margin-top:0; width:220px;"></ul>
					</div>
					</div>
				</div>
						<div class="layui-form-item inline">
					<label class="layui-form-label">用户列表</label>
					<div class="layui-input-inline">
						<input type="hidden" name="userolelistid" value="<%=user_rs.getString("user_association") %>"  id="userolelistid" />
						<select name="userolelist" lay-filter="userolelist"  lay-verify="required" lay-search>
								<option value="">无</option>
						</select>
					</div>
				</div>
				<%}if(user_rs!=null){user_rs.close();} %>
				<div class="layui-form-item">
					<div class="layui-input-block">
						<button class="layui-btn" lay-submit="" ;>立即提交</button>
					</div>
				</div>
			</form>
		</div>
		<SCRIPT type="text/javascript">
					var setting = {
						check: {
							enable: true
						},
						data: {
							simpleData: {
								enable: true
							}
						},
						callback: {
							//beforeClick: beforeClick,
							onCheck: onCheck
						}
					};
					var zNodes =[
								 ];
					function onCheck(e, treeId, treeNode) {
						var treeObj = $.fn.zTree.getZTreeObj("treeDemo");
						var nodes = treeObj.getCheckedNodes(true);
						v = "";
						code = "";
						nodes.sort(function compare(a,b){return a.id-b.id;});
						for (var i=0, l=nodes.length; i<l; i++) {
							v += nodes[i].name + ",";
							code += nodes[i].id + ",";
						}
						if (v.length > 0 ) v = v.substring(0, v.length-1);
						if (code.length > 0 ) code = code.substring(0, code.length-1);
						 $("#citySel").attr("value", v);
						$('#role_id').attr('value',code);
						//hideMenu();
					}
					function showMenu() {
						var cityObj = $("#citySel");
						var cityOffset = $("#citySel").offset();
						$("#menuContent").slideDown("fast");
						$("body").bind("mousedown", onBodyDown);
					}
					function hideMenu() {
						$("#menuContent").fadeOut("fast");
						$("body").unbind("mousedown", onBodyDown);
					}
					function onBodyDown(event) {
						if (!(event.target.id == "menuBtn" || event.target.id == "menuContent" || $(event.target).parents("#menuContent").length>0)) {
							hideMenu();
						}
					}
					var code;
					function setCheck() {
						var zTree = $.fn.zTree.getZTreeObj("treeDemo"),
						py = $("#py").attr("checked")? "p":"",
						sy = $("#sy").attr("checked")? "s":"",
						pn = $("#pn").attr("checked")? "p":"",
						sn = $("#sn").attr("checked")? "s":"",
						type = { "Y":py + sy, "N":pn + sn};
						
						if(zTree==undefined){
							return false;
						}else{
							zTree.setting.check.chkboxType = type;
				    	}
						
						
						
						showCode('setting.check.chkboxType = { "Y" : "' + type.Y + '", "N" : "' + type.N + '" };');
					}
					function showCode(str) {
						if (!code) code = $("#code");
						code.empty();
						code.append("<li>"+str+"</li>");
					}
					
					$(document).ready(function(){
						$.fn.zTree.init($("#treeDemo"), setting, zNodes);
						setCheck();
						$("#py").bind("change", setCheck);
						$("#sy").bind("change", setCheck);
						$("#pn").bind("change", setCheck);
						$("#sn").bind("change", setCheck);
					});
				</SCRIPT>
		<script>
			layui.use(['form', 'layedit', 'laydate'], function() {
				var form = layui.form(),
					layer = layui.layer,
					layedit = layui.layedit,
					laydate = layui.laydate;
				
					form.on('select(userole)', function(data){
						$('#citySel').val('');
						$('#role_id').val('');
				    	role();
				        checkUserlist();
					}); 

					$(function(){
						role();
					    checkUserlist();
					})
					
				    //如果角色是教师或学生 需要绑定教师或学生信息
				    function checkUserlist(){
				    	var roleval = $('select[name="userole"]').val();
				    	
					    if(roleval==1||roleval==2){
							$('select[name="userolelist"]').attr('lay-verify',"required");
						    }else{
							$('select[name="userolelist"]').attr('lay-verify',"");
							 }
					    }
				    
					function role(){
						var userole = $('select[name="userole"]').val();
						if(userole==''||typeof(userole)==undefined){
							return;
							}
				    var uid = '<%=Suid%>';
				  	var token = '<%=Spc_token%>';
				  	var xhr = new XMLHttpRequest();
				   xhr.open('post', '../../../../Api/v1/?p=web/rolerList/all' );
				  xhr.setRequestHeader("Content-type","application/x-www-form-urlencoded");
				  xhr.setRequestHeader("X-USERID-type",uid);
				  xhr.setRequestHeader("X-AppId","8381b915c90c615d66045e54900feeab");
				  xhr.setRequestHeader("X-AppKey","72393aaa69c41a24d0d40e851301647a");
				  xhr.setRequestHeader("Token",token);
				  xhr.setRequestHeader("X-UUID","pc");
				  xhr.setRequestHeader("X-Mdels","pc");
				  //发送请求
				  xhr.send('id='+userole);
				  xhr.onreadystatechange = function () {
				    if (xhr.readyState == 4 && xhr.status == 200) {
						var obj = JSON.parse(xhr.responseText);
			    		if(obj.success && obj.resultCode=="1000"){
			    			var opdata =obj.teacherData;
				    		$('select[name="userolelist"]').html(opdata);
				    		var teacherrid = $('#userolelistid').val();
				    		$('select[name="userolelist"]').val(teacherrid);
			    			zNodes = obj.data;
			    			$.fn.zTree.init($("#treeDemo"), setting, zNodes);
			    		}else{
			    		}
						form.render('select');  
				    } 
				  };
						}
					
				    function role1(){
						var userole = $('select[name="userole"]').val();
					  		var str = {"userole":userole};
							var obj = JSON.stringify(str);
				    		var ret_str=PostAjx('../../../../Api/v1/?p=web/rolerList/all',obj,'<%=Suid%>','<%=Spc_token%>');
				    		var obj = JSON.parse(ret_str);
				    		if(obj.success && obj.resultCode=="1000"){
					    		var opdata ='<option></option>'+obj.data;
					    		$('select[name="role_id"]').html(opdata);
				    		}else{
				    		}
							form.render('select');  
						}		
						
				//提交成功	
				function Success(){
					layer.confirm('用户数据修改成功！', {icon: 1,  closeBtn:0,btn: ['关闭'] ,title:'提示'}, function(index){
					  parent.location.reload();   
					  layer.close(index);
					});			
				}
				
				//提交失败	
				function fail(str){
					layer.confirm(str, {icon: 2,  closeBtn:0,btn: ['关闭'] ,title:'提示'}, function(index){
					  layer.close(index);
					  parent.location.reload();   
					});		
				}
			
			<%
			    if("userionfo".equals(ac)){
					String userid="",nickname="",username="",sex="",usermob="",email="",add_time="",state="",role_id="";
					userid=request.getParameter("usernameid"); 			if(userid==null){userid="0";}//获取用户id
					nickname=request.getParameter("nickname"); 			if(nickname==null){nickname="";}//获取用户昵称
					username=request.getParameter("username"); 			if(username==null){username="";}//获取用户姓名
					sex=request.getParameter("sex"); 					if(sex==null){sex="";}//获取用户性别
					usermob=request.getParameter("usermob"); 			if(usermob==null){usermob="";}//获取用户手机号
					email=request.getParameter("email"); 				if(email==null){email="";}//获取用户邮箱
					state=request.getParameter("state"); 				if(state==null){state="";}//获取用户是否禁用状态
					//regionalcode=request.getParameter("regionalcode");  if(regionalcode==null){regionalcode="";}//获取用户所属公司
					
					String userole = request.getParameter("userole");  if(userole==null){userole="";}
					String userolelist = request.getParameter("userolelist"); 
					 if(StringUtils.isBlank(userolelist)){userolelist="0";}
					//新增获取角色集合
					 role_id=request.getParameter("role_id"); 
					String[] role_ids = role_id.split(",");
					
					String	user_upsql="UPDATE  user_worker  SET nickname='"+nickname+"',userole='"+userole+"',user_association='"+userolelist+"',username='"+username+"',sex     ='"+sex+"',usermob ='"+usermob +"',email   ='"+email+"',state   ='"+state+"' WHERE uid = '"+userid+"' ;";
					boolean checkModState =true;//检验手机号
					String checkSql ="";
					checkSql = "select uid,usermob from user_worker where usermob ='"+usermob+"'";
					ResultSet checkRs = db.executeQuery(checkSql);
					while(checkRs.next()){
						if(!checkRs.getString("uid").equals(userid)){
							checkModState = false;
							break;
						}
					}if(checkRs!=null)checkRs.close();
					//检查 绑定身份是否已绑定
					boolean checkListState = true;
					if(userole.equals("1")||userole.equals("2")){
						 checkSql = "select uid,userole,user_association from user_worker where userole='"+userole+"' and user_association="+userolelist;
						ResultSet chekRs  = db.executeQuery(checkSql);
						while(chekRs.next()){
							if(!chekRs.getString("uid").equals(userid)){
								checkListState = false;
								break;
							}
						}if(chekRs!=null)chekRs.close();
					}
					
					if(checkModState&&checkListState){
						boolean user_state= db.executeUpdate(user_upsql);
						if(user_state){//更新用户信息成功 
							//String user_uprole="";
							//int user_rol_num=db.Row(" SELECT COUNT(1) as Row FROM zk_user_role WHERE sys_user_id='"+userid+"' ");
							//if(user_rol_num==0){
							//	user_uprole="INSERT INTO zk_user_role ( sys_user_id,  sys_role_id ) VALUES ('"+userid+"', '"+role_id+"');";
							//}else{
							//	user_uprole="UPDATE zk_user_role  SET  sys_role_id = '"+role_id+"' WHERE sys_user_id = '"+userid+"' ;";
						//	}
							db.executeUpdate("DELETE from zk_user_role where sys_user_id="+userid);
							boolean userRole_state = false;
							for(int i=0; i< role_ids.length;i++){
								String user_uprole="INSERT INTO zk_user_role  ( sys_user_id, sys_role_id) VALUES ('"+userid+"', '"+role_ids[i]+"');";
								userRole_state= db.executeUpdate(user_uprole);
							}
							
							if(userRole_state){//更新用户角色信息成功
								
								out.println("Success()");
							}else{
								out.println("fail('用户档案修改失败');");
							}
						}else{
								out.println("fail('用户档案修改失败');");
						}
					}else{
								out.println("fail('用户手机号或教师已绑定');");
					}
				}
			%>
			});
			
		</script>
	</body>
</html>





<%

//插入常用菜单日志
int   TagMenu=db.Row("SELECT COUNT(*) as row FROM  menu_worker  WHERE sysmenuid='"+PMenuId+"' and  workerid='"+Suid+"' and  companyid="+Scompanyid);
if(TagMenu==0){
  		db.executeUpdate("INSERT INTO `menu_worker`(`sysmenuid`,`workerid`,`countes`,`companyid`) VALUES ('"+PMenuId+"','"+Suid+"','1','"+Scompanyid+"');"); 
}else{
   		db.executeUpdate("UPDATE  `menu_worker` SET `countes`=countes+1,`usetime`=now() WHERE  sysmenuid='"+PMenuId+"' and  workerid='"+Suid+"' and  companyid="+Scompanyid);
}
%>
<%
if(db!=null)db.close();db=null;if(server!=null)server=null;
%>