<%@ page trimDirectiveWhitespaces="true" %>
<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@page import="service.dao.db.Page"%>
<%@page import="org.apache.commons.lang3.StringUtils"%>
<%@include file="../../cookie.jsp"%>
<%
/**
 * 新建用户
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
     	<link rel="stylesheet" href="../../css/sy_style.css">
		<link rel="stylesheet" href="../../js/layui2/css/layui.css" media="all" />
		<script src="../../../pages/js/ajaxs.js"></script>
	  	<script src="../../../pages/js/layui2/layui2.js" charset="utf-8"></script>
	  	<!-- zTree -->
		<link rel="stylesheet" href="../../js/zTree/css/demo.css" type="text/css">
		<link rel="stylesheet" href="../../js/zTree/css/zTreeStyle/zTreeStyle.css" type="text/css">
		<script type="text/javascript" src="../../js/zTree/js/jquery-1.4.4.min.js"></script>
		<script type="text/javascript" src="../../js/zTree/js/jquery.ztree.core.js"></script>
		<script type="text/javascript" src="../../js/zTree/js/jquery.ztree.excheck.js"></script>
		<script src="../../../pages/js/ajaxs.js"></script>
		
		 <style>
	     	.layui-form-item .layui-input-inline{width:182px;}
	     	 .layui-upload{margin:20px 20px;zoom:1;overflow:hidden;}
	     	 .layui-input{height:38px;line-height:38px;}
	     	 .inline{ position: relative; display: inline-block; margin-right: 10px; }
			.layui-form-item select[multiple]+.layui-form-select{border :1px solid #e6e6e6;border-radius:2px;}
			.layui-form-item select[multiple]+.layui-form-select .layui-input{border:0;width:99%}
			.layui-select-title .multiSelect{height:auto;}
			.layui-input-block{margin-left:108px;}
	     </style>
		<title>新建用户信息页面</title> 
	   
	</head>

	<body>
		<div style="margin: 15px;">
			<fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
				<legend>用户基本信息</legend>
			</fieldset>

			<form class="layui-form" action="?ac=userionfo" method="post">
				<input type="hidden" name="usernameid" lay-verify="nickname" autocomplete="off" class="layui-input" value="">
				<div class="layui-form-item inline">
					<label class="layui-form-label">用户昵称</label>
					<div class="layui-input-inline">
<%--						<input type="text" name="account" lay-verify="required" placeholder="不能使用汉字" id="account" onblur="vailAccount()" autocomplete="off" class="layui-input" value="">--%>
						<input type="text" name="nickname" lay-verify="required" placeholder="" id="account" autocomplete="off" class="layui-input" value="">
					</div>
				</div>
				<div class="layui-form-item inline">
					<label class="layui-form-label">用户姓名</label>
					<div class="layui-input-inline">
						<input type="text" name="username" lay-verify="required" autocomplete="off" class="layui-input" value="">
					</div>
				</div>
				<div class="layui-form-item inline">
					<label class="layui-form-label">用户性别</label>
					<div class="layui-input-inline">
						<select name="sex" lay-verify="required"> <%-----值为1时是男性，值为2时是女性，值为0时是未知 --%>
							<option value=""></option>
							<option value="1">男</option>
							<option value="2">女</option>
						</select>
					</div>
				</div>
				<div class="layui-form-item inline">
					<label class="layui-form-label">用户手机号</label>
					<div class="layui-input-inline">
						<input type="text" name="usermob" lay-verify="required|phone" id="phone" autocomplete="off" class="layui-input" value="">
					</div>
				</div>
				<div class="layui-form-item inline">
					<label class="layui-form-label">用户邮箱</label>
					<div class="layui-input-inline">
						<input type="text" name="email" lay-verify="required|email" autocomplete="off"   class="layui-input" value="">
					</div>
				</div>
				<div class="layui-form-item inline">
					<label class="layui-form-label">是否禁用</label>
					<div class="layui-input-inline">
						<select name="state" lay-verify="required"><%---1正常 0 禁止 --%>
							<option value=""></option>
							<option value="1">正常</option>
							<option value="0">禁止</option>
						       
						</select>
					</div>
				</div>
<%--				<div class="layui-form-item inline">--%>
<%--					<label class="layui-form-label">所属公司</label>--%>
<%--					<div class="layui-input-inline">--%>
<%--						<select name="regionalcode" lay-search lay-verify="required">--%>
<%--							<option value="" > 请选择</option>--%>
<%--							<%--%>
<%--								String s_regional_sql="SELECT regionalcode,regionalname FROM s_regional_table";--%>
<%--								ResultSet s_regional_rs=db.executeQuery(s_regional_sql);--%>
<%--								while(s_regional_rs.next()){--%>
<%--							%>	--%>
<%--								<option value="<%=s_regional_rs.getString("regionalcode")%>"> <%=s_regional_rs.getString("regionalname")%></option>--%>
<%--							<%--%>
<%--								}if(s_regional_rs!=null){s_regional_rs.close();}--%>
<%--							%>--%>
<%--						</select>--%>
<%--					</div>--%>
<%--				</div>--%>
				<div class="layui-form-item inline">
					<label class="layui-form-label">用户类别</label>
					<div class="layui-input-inline">
						<select name="userole" lay-filter="userole"  lay-verify="required">
								<option value=""></option>
								<option value="1" >教职工</option>
								<option value="2" >学生</option>
								<option value="3" >家长</option>
								<option value="4" >管理员</option>
						</select>
					</div>
				</div>
					<div class="layui-form-item inline" >
					<label class="layui-form-label">角色</label>
					<div class="layui-input-inline">
						<input type="text"  id="citySel"  lay-verify="required" autocomplete="off" class="layui-input" value=""  onclick="showMenu(); return false;" readonly="readonly">
						<input type="hidden"  id="role_id" name="role_id"  >
					</div>
					<div id="menuContent" class="menuContent" style="display:none; position: absolute;z-index:999;margin-top: 39px;margin-left: 115px;">
						<ul id="treeDemo" class="ztree" style="margin-top:0; width:220px;"></ul>
					</div>
				</div>
				<div class="layui-form-item inline">
					<label class="layui-form-label">用户列表</label>
					<div class="layui-input-inline">
						<select name="userolelist" lay-filter="userolelist"  lay-search>
								<option value="">无</option>
						</select>
					</div>
				</div>
			
				<div class="layui-form-item">
					<div class="layui-input-block">
						<button class="layui-btn" lay-submit lay-filter="formDemo">立即提交</button>
					</div>
				</div>
			</form>
		</div>
<%--		<script type="text/javascript" src="../../../custom/jquery.min.js"></script>--%>
			
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
						zTree.setting.check.chkboxType = type;
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
		
		 layui.use(['form','layer','layedit', 'laydate'], function(){
			    var form = layui.form
			    ,layer = layui.layer
			    ,layedit = layui.layedit
			    ,laydate = layui.laydate;
			    form.on('select(userole)', function(data){
			    	$('#citySel').val('');
					$('#role_id').val('');
				    role();
				    checkUserlist();
			}); 

				$(function(){
					checkUserlist();
					})	
					
			    //如果角色是教师或学生 需要绑定教师或学生信息
			    function checkUserlist(){
			    	var roleval = $('select[name="userole"]').val();
				    console.log(roleval);
				    if(roleval==1||roleval==2){
						$('select[name="userolelist"]').attr('lay-verify',"required");
					    }else{
						$('select[name="userolelist"]').attr('lay-verify',"");
						 }
				    }
			    
				function role(){
					var userole = $('select[name="userole"]').val();
					if(userole==''){
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
		    			zNodes = obj.data;
		    			$.fn.zTree.init($("#treeDemo"), setting, zNodes);
		    		}else{
		    		}
					form.render('select');  
			    } 
			  };
					}
<%--				form.on('submit(formDemo)', function(data){--%>
<%--					var state = vailAccount();				--%>
<%--				    return state;--%>
<%--				});--%>
			    
			   //提交成功	
				function Success(){
					layer.confirm('创建用户成功！', {icon: 1,  closeBtn:0,btn: ['关闭'] ,title:'提示'}, function(index){
					  parent.location.reload();   
					  layer.close(index);
					});			
				}
				
				//提交失败	
				function fail(str){
					layer.confirm(str, {icon: 2,  closeBtn:0,btn: ['关闭'] ,title:'提示'}, function(index){
					  layer.close(index);
					});			
				}
			
				//监听提交
				
				<%
				    if("userionfo".equals(ac)){
						String userid=request.getParameter("usernameid"); 			if(userid==null){userid="0";}//获取用户昵称
						String nickname=request.getParameter("nickname"); 			if(nickname==null){nickname="";}//获取用户昵称
						String username=request.getParameter("username"); 			if(username==null){username="";}//获取用户账号
						String sex=request.getParameter("sex"); 					if(sex==null){sex="";}//获取用户性别
						String usermob=request.getParameter("usermob"); 			//获取用户手机号
						
						String email=request.getParameter("email"); 				if(email==null){email="";}//获取用户邮箱
						String add_time=request.getParameter("add_time"); 			if(add_time==null){add_time="";}//获取用户创建时间
						String state=request.getParameter("state"); 				if(state==null){state="";}//获取用户是否禁用状态
						//String regionalcode=request.getParameter("regionalcode");  if(regionalcode==null){regionalcode="";}//获取用户所属公司
						
						String userole = request.getParameter("userole");  if(userole==null){userole="";}
						String userolelist = request.getParameter("userolelist"); 
						 if(StringUtils.isBlank(userolelist)){userolelist="0";}
						//新增获取角色集合
						String role_id=request.getParameter("role_id"); 
						String[] role_ids = role_id.split(",");
						
						
						if(usermob==null){//获取用户手机号
							usermob="";
						}else{
							//检验手机号
							boolean checkModState =true;
							
							String checkSql ="";
							checkSql = "select count(1) row from user_worker where usermob ='"+usermob+"'";
							int ifusermob=db.Row(checkSql);
							if(ifusermob>0){
								checkModState = false;
							}
							
							//校验身份
							boolean checkListState = true;
							if(userole.equals("1")||userole.equals("2")){
								checkSql = "select count(1) row from user_worker where userole='"+userole+"' and user_association="+userolelist;
								int ifusermob2 =db.Row(checkSql);
								if(ifusermob2>0){
									checkListState = false;
								}
							}
								
							if(checkModState==false||checkListState==false){
								out.println("layer.msg('用户手机号或教师已绑定')");
							}else{
								String user_upsql="INSERT user_worker "+
								"(wid,fid,did,nickname, username, sex, usermob, email,  LANGUAGE, state,PASSWORD,userole,user_association)"+
								"VALUES "+
								"('1','1','0','"+nickname+"', '"+username+"', '"+sex+"','"+usermob +"','"+email+"',  'zh_CN', '"+state+"','111111','"+userole+"','"+userolelist+"');";

								int userId= db.executeUpdateRenum(user_upsql);
								if(userId>0){//更新用户信息成功 
									boolean userRole_state = true;
									for(int i=0; i< role_ids.length;i++){
										String user_uprole="INSERT INTO zk_user_role  ( sys_user_id, sys_role_id) VALUES ('"+userId+"', '"+role_ids[i]+"');";
										userRole_state= db.executeUpdate(user_uprole);
									}
									if(userRole_state){//更新用户角色信息成功
										out.println("Success()");
									}else{
										//out.println("layer.confirm('用户档案创建失败！, {icon: 2, title:'提示'}, function(index){ layer.close(index); window.parent.dialogArguments.document.execCommand('Refresh');   });");
										out.println("fail('用户档案创建失败');");
									}
								}else{
										out.println("fail('用户档案创建失败');");
								}
							}
						}
					}
				%>
			});	
		</script>
	</body>
</html>

<%if(db!=null)db.close();db=null;if(server!=null)server=null;%>