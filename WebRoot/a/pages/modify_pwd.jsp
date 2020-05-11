<%@ page trimDirectiveWhitespaces="true" %>
<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<% String MMenuId="0"; //个人密码修改模块编号%>
<%@ include file="cookie.jsp"%>
<%@page import="v1.haocheok.commom.common"%>
<!DOCTYPE html> 
<html lang="zh_CN"> 
<head> 
    <meta charset="utf-8"> 
    <meta name="viewport" content="width=device-width, initial-scale=1"> 
    <title>修改密码</title> 
    <link href="css/base.css" rel="stylesheet">
    <link rel="stylesheet" href="../custom/easyui/easyui.css">
    <link href="css/basic_info.css" rel="stylesheet">
    <script type="text/javascript" src="js/jquery-1.9.1.js"></script>
    <script type="text/javascript" src="../custom/jquery.easyui.min.js"></script>
	<link rel="stylesheet" href="../pages/css/sy_style.css?22">
	<script src="../pages/js/layui2/layui.js"></script>
	<link rel="stylesheet" href="js/layui2/css/layui.css" media="all" />
<style>
.container {
  position: relative;
  padding-left: 10px;
  position: relative;
}
</style>
</head> 
<body>
	<div class="container">
		<div class="content">
			<div class="easyui-tabs1" style="width:100%;">
		      <div title="密码修改" data-options="closable:false" class="basic-info">
		      		<form class="layui-form" action="?ac=post" method="post" id="formSub">
				<div class="column"><span class="current">请修改自己的密码，如果修改其他信息请联系管理员</span></div>
		      	<table class="kv-table pwd_div">
		      			<%
			          		String user_sql = "select t.* from user_worker t  where 1=1 and  t.uid = "+Suid;
			          		ResultSet user = db.executeQuery(user_sql);
			          		int i = 1;
			          		while(user.next()){
			         %>
					<tbody>
						<tr>
							<td class="kv-label">用户姓名</td>
							<td class="kv-content"><%=user.getString("username") %></td>
						</tr>
						<tr>
							<td class="kv-label">性别</td>
							<td class="kv-content">
								   <%
							        	Map<String ,String> map = common.getDicMap("gender");
							        	for(Map.Entry<String,String> entry:map.entrySet()){
							        		if(user.getString("sex").equals(entry.getKey())){
							        			out.println(entry.getValue());
							        	}
							        	}
							         %>
							</td>
						</tr>
						<tr>
							<td class="kv-label">原密码</td>
							<td class="kv-content">
							<input name="oldpwd" type="password" class="textbox-text validatebox-text textbox-prompt layui-input " style='width:150px;' id="oldpwd"  lay-verify="required"   placeholder="请输入原密码" /></td>
						</tr>
							<tr>
							<td class="kv-label">新密码</td>
							<td class="kv-content">
							<input name="newpwd" type="password" class="textbox-text validatebox-text textbox-prompt layui-input " style='width:150px;'  id="newpwd" lay-verify="required"   placeholder="请输入新密码"  onblur="check_pwd();"/>
							<span class="tix"></span>
							</td>
						</tr>
							<tr>
							<td class="kv-label">确认新密码</td>
							<td class="kv-content " colspan="3">
							<input name="compwd" type="password" class="textbox-text validatebox-text textbox-prompt layui-input " style='width:150px;' id="compwd"  lay-verify="required"  placeholder="确认新密码"  onblur="check_pwd();"/>
							<span class="tix"></span>
							</td>
						</tr>
					</tbody>
						<%i++;}if(user!=null)user.close(); %>
				</table>
				 	<div align="center">
					<button class="layui-btn" lay-submit=""  lay-filter="formDemo">确认修改</button>
					</div>
				 </form>
				</div>
		    </div>
		</div>
	</div>
	
</body> 
 <script>
 var ValidatePwd = {  
	        Pwd : {  
	            color: ['#E6EAED', '#AC0035', '#FFCC33', '#639BCC', '#246626'],
	            text: ['太短', '弱', '一般', '很好', '极佳']
	        },  
	        Result : 0,  
	        Evaluate : function(word,name) {   
	            if (word == "") {  
	                this.Result = 0;  
	            } 
	            else if (word.length < 6) {  
	                this.Result =  1;  
	            }
	            else {
	                this.Result =  word.match(/[a-z](?![^a-z]*[a-z])|[A-Z](?![^A-Z]*[A-Z])|\d(?![^\d]*\d)|[^a-zA-Z\d](?![a-zA-Z\d]*[^a-zA-Z\d])/g).length;  
	            }
	            
	            $('input[name="'+name+'"]').next().html("<span> "+this.Pwd.text[this.Result]+"</span>");
	            $('input[name="'+name+'"]').css('color',this.Pwd.color[this.Result]);
	       }
	    }  
		$(function(){
			$('input[name="newpwd"]').keydown(function(){
			        ValidatePwd.Evaluate($(this).val(),'newpwd');  
			    }); 
			$('input[name="compwd"]').keydown(function(){
			        ValidatePwd.Evaluate($(this).val(),'compwd');  
			    }); 
			})
	function check_pwd(){
		var newpwd = $('input[name="newpwd"]').val();
		var compwd = $('input[name="compwd"]').val();
		if(newpwd==''){
			 $('input[name="newpwd"]').next().html("");
			return;
			}
		if(compwd==''){
			$('input[name="compwd"]').next().html("");
			return;
			}
			if(newpwd!=compwd){
				 layer.msg("请保证确认密码与新密码相同");	
				}
			}

	layui.use(['form', 'layedit', 'laydate'], function() {
		 form = layui.form,
			layer = layui.layer,
			layedit = layui.layedit,
			laydate = layui.laydate;
		//监听表单提交（同意）
		form.on('submit(formDemo)', function(data){
		    var newpwd = data.field.newpwd;
		    var compwd = data.field.compwd;
		    if(newpwd==compwd){
				return true;
			    }else{
				    layer.alert("请保证确认密码与新密码相同");	
		 		   return false;
				    }
		});
		<%	
		if(ac.equals("post")){
			String oldpwd = "";
			String newpwd = "";
			String compwd = "";
			oldpwd =  request.getParameter("oldpwd");
			newpwd = request.getParameter("newpwd");
			compwd = request.getParameter("compwd");
			int countNum = 0 ;
			String check_sql = "select * from user_worker t where t.uid="+Suid+" and t.password='"+oldpwd+"'" ;
			System.out.println(check_sql);
			ResultSet rs = db.executeQuery(check_sql);
			rs.last();
			countNum = rs.getRow(); 
			if(countNum==0){
				out.print("layer.alert('原密码错误')");
			}else{
				String sql = "update user_worker t set password='"+newpwd+"' where t.uid = "+Suid;		
				boolean status = db.executeUpdate(sql);
				if(status){
				 	out.print("layer.alert('修改成功'); setTimeout(\"location.href='index.jsp?msg=安全退出'\", 1000); ");
				 }else{
				 	out.print("layer.alert('提交错误')");
				 }
			}
		}
		%>
	});

 </script>
 <script type="text/javascript">
	$('.easyui-tabs1').tabs({
      tabHeight: 36
    });
    $(window).resize(function(){
    	$('.easyui-tabs1').tabs("resize");
    }).resize();
</script>
</html>


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