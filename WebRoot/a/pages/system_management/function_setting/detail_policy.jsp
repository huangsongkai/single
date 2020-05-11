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
		<link rel="stylesheet" href="../../../pages/js/layui/css/layui.css">
     	<link rel="stylesheet" href="../../../pages/css/sy_style.css?22">
		<link rel="stylesheet" href="../../js/layui/css/layui.css" media="all" />
		<title>政策配置编辑页面</title> 
	    <style type="text/css">
			.inline{ position: relative; display: inline-block; margin-right: 10px; }
	    </style>
	</head>
	<body>
		
		<div style="margin: 15px;">
			<fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
				<legend>编辑政策配置</legend>
			</fieldset>

			<form class="layui-form" action="?ac=post" method="post">
				<%
			        		String id = request.getParameter("id");
			          		String policy_sql = "select t.* from g_policy t  where 1=1 and  t.id = "+id;
			          		ResultSet policys = db.executeQuery(policy_sql);
			          		int i = 1;
			          		while(policys.next()){
			         %>
				<div class="layui-form-item inline" style="width: 40%">
					<label class="layui-form-label" style=" width: 30%">名称</label>
					<input type="hidden" name="id" value="<%=policys.getString("id") %>">
					<div class="layui-input-inline">
						<input type="text" name="policyname" lay-verify="required" autocomplete="off" class="layui-input"  value="<%=policys.getString("policyname").toLowerCase()%>" readonly="readonly">
					</div>
				</div>
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">实际贷款额(x)</label>
					<div class="layui-input-inline">
						<input type="text" name="x" lay-verify="required|number" autocomplete="off" class="layui-input" value="<%=policys.getString("x").toLowerCase()%>" readonly="readonly">
					</div>
				</div>
				
					<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">贷款比例</label>
					<div class="layui-input-inline">
			      	<input type="text" name="loanratio" id="rate"  lay-verify="required|number" value="<%=policys.getString("loanratio").toLowerCase()%>" class="layui-input"  readonly="readonly">
			      </div>
				</div>
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">尚融贷款额(y)</label>
					<div class="layui-input-inline">
							<input type="text" name="y" id="rate"  lay-verify="required" value="<%=policys.getString("y").toLowerCase()%>" class="layui-input"  readonly="readonly">
					</div>	
				</div>
					<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">收入(w)</label>
					<div class="layui-input-inline">
						<input type="text" name="w" lay-verify="required|number" autocomplete="off" class="layui-input" value="<%=policys.getString("w").toLowerCase()%>"  readonly="readonly">
					</div>
				</div>
					<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">月还款系数(z)</label>
					<div class="layui-input-inline">
						<input type="text" name="z" lay-verify="required" autocomplete="off" class="layui-input" value="<%=policys.getString("z").toLowerCase()%>"  readonly="readonly">
					</div>
				</div>
					<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">月还款方式</label>
					<div class="layui-input-inline">
						<input type="text" name="mode" lay-verify="required" autocomplete="off" class="layui-input" value="<%=policys.getString("mode").toLowerCase()%>"  readonly="readonly">
					</div>
				</div>
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">担保费(o)</label>
					<div class="layui-input-inline">
						<input type="text" name="o" lay-verify="" autocomplete="off" class="layui-input" value="<%=policys.getString("o").toLowerCase()%>"  readonly="readonly">
					</div>
				</div>
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">服务费(p)</label>
					<div class="layui-input-inline">
						<input type="text" name="o" lay-verify="" autocomplete="off" class="layui-input" value="<%=policys.getString("p").toLowerCase()%>"  readonly="readonly">
					</div>
				</div>
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">其他费(q)</label>
					<div class="layui-input-inline">
						<input type="text" name="q" lay-verify="" autocomplete="off" class="layui-input" value="<%=policys.getString("q").toLowerCase()%>"  readonly="readonly">
					</div>
				</div>
					<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">履约保证金</label>
					<div class="layui-input-inline">
						<input type="text" name="warranty" lay-verify="" autocomplete="off" class="layui-input" value="<%=policys.getString("warranty").toLowerCase()%>"  readonly="readonly">
					</div>
				</div>
					<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">月还款固定金额(f)</label>
					<div class="layui-input-inline">
						<input type="text" name="f" lay-verify="" autocomplete="off" class="layui-input" value="<%=policys.getString("f").toLowerCase()%>"  readonly="readonly">
					</div>
				</div>
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">月还款金额(h)</label>
					<div class="layui-input-inline">
						<input type="text" name="h" lay-verify="" autocomplete="off" class="layui-input" value="<%=policys.getString("h").toLowerCase()%>"  readonly="readonly">
					</div>
				</div>
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">本金(n)</label>
					<div class="layui-input-inline">
						<input type="text" name="n" lay-verify="" autocomplete="off" class="layui-input" value="<%=policys.getString("n").toLowerCase()%>"  readonly="readonly">
					</div>
				</div>
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">综合费用(s)</label>
					<div class="layui-input-inline">
						<input type="text" name="s" lay-verify="" autocomplete="off" class="layui-input" value="<%=policys.getString("s").toLowerCase()%>"  readonly="readonly">
					</div>
				</div>
					<%i++;} %>
			</form>
		</div>
		<script type="text/javascript" src="../../../custom/jquery.min.js"></script>
		<script type="text/javascript" src="../../js/layui/layui.js"></script>
		<script src="../../../pages/js/layui/layui.js"></script>
		<script>
			layui.use(['form', 'layedit', 'laydate'], function() {
				var form = layui.form(),
					layer = layui.layer,
					layedit = layui.layedit,
					laydate = layui.laydate;
			});
			
			<%	
	
	if(ac.equals("post")){
		String bankName = "";
		String rate = "";
		String bankrate = "";
		String regioncode = "";
		bankName = request.getParameter("bankName");
		rate = request.getParameter("rate");
		bankrate =  request.getParameter("bankrate");
		regioncode = request.getParameter("regionalcode");
		int ids = Integer.parseInt(request.getParameter("id"));
		//String sql = "update typegroup t set typegroupcode='"+typegroupcode+"',typegroupname='"+typegroupname+ "' where t.id = "+id;
		String sql = "update g_bank t set bankName='"+bankName+"',rate='"+rate+ "',bankrate='"+bankrate+"',regioncode='"+regioncode+"',updateid='"+Suid+"',updatetime="+"now()"+" where t.id = "+id;
System.out.println("sql========="+sql);
		boolean status = db.executeUpdate(sql);
		if(status){
		 	out.print("var index = parent.layer.getFrameIndex(window.name); parent.layer.close(index); parent.location.reload();");
		 }else{
		 	out.print("layer.msg('提交错误')");
		 }
		 
		
	}
	%>
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