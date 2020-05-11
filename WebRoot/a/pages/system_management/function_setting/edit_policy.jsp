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
						<input type="text" name="policyname" lay-verify="required" autocomplete="off" class="layui-input"  value="<%=policys.getString("policyname") %>">
					</div>
				</div>
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">实际贷款额(x)</label>
					<div class="layui-input-inline">
						<input type="text" name="x" lay-verify="required" autocomplete="off" class="layui-input" value="<%=policys.getString("x") %>" readonly="readonly">
					</div>
				</div>
				
					<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">贷款比例</label>
					<div class="layui-input-inline">
			      	<input type="text" name="loanratio" id="rate"  lay-verify="number" value="<%=policys.getString("loanratio") %>" class="layui-input" >
			      </div>
				</div>
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">还款期数(months)</label>
					<div class="layui-input-inline">
						<input type="text" name="months" lay-verify="required|isInt" autocomplete="off" class="layui-input" value="<%=policys.getString("months") %>" >
					</div>
				</div>
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">尚融贷款额(y)</label>
					<div class="layui-input-inline">
							<input type="text" name="y" id="rate"  lay-verify="" value="<%=policys.getString("y") %>" class="layui-input" >
					</div>	
				</div>
					<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">收入(w)</label>
					<div class="layui-input-inline">
						<input type="text" name="w" lay-verify="" autocomplete="off" class="layui-input" value="<%=policys.getString("w") %>" >
					</div>
				</div>
					<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">月还款系数(z)</label>
					<div class="layui-input-inline">
						<input type="text" name="z" lay-verify="" autocomplete="off" class="layui-input" value="<%=policys.getString("z") %>" >
					</div>
				</div>
					<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">月还款方式</label>
					<div class="layui-input-inline">
						<input type="text" name="mode" lay-verify="" autocomplete="off" class="layui-input" value="<%=policys.getString("mode") %>" >
					</div>
				</div>
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">担保费(o)</label>
					<div class="layui-input-inline">
						<input type="text" name="o" lay-verify="" autocomplete="off" class="layui-input" value="<%=policys.getString("o") %>" >
					</div>
				</div>
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">服务费(p)</label>
					<div class="layui-input-inline">
						<input type="text" name="p" lay-verify="" autocomplete="off" class="layui-input" value="<%=policys.getString("p") %>" >
					</div>
				</div>
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">其他费(q)</label>
					<div class="layui-input-inline">
						<input type="text" name="q" lay-verify="" autocomplete="off" class="layui-input" value="<%=policys.getString("q") %>" >
					</div>
				</div>
					<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">履约保证金</label>
					<div class="layui-input-inline">
						<input type="text" name="warranty" lay-verify="" autocomplete="off" class="layui-input" value="<%=policys.getString("warranty") %>" >
					</div>
				</div>
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">还款月数(m)</label>
					<div class="layui-input-inline">
						<input type="text" name="m"  lay-verify="required|isInt"  autocomplete="off" class="layui-input" value="<%=policys.getString("m") %>" >
					</div>
				</div>
					<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">月还款固定金额(f)</label>
					<div class="layui-input-inline">
						<input type="text" name="f" lay-verify="" autocomplete="off" class="layui-input" value="<%=policys.getString("f") %>" >
					</div>
				</div>
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">月还款金额(h)</label>
					<div class="layui-input-inline">
						<input type="text" name="h" lay-verify="" autocomplete="off" class="layui-input" value="<%=policys.getString("h") %>" >
					</div>
				</div>
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">本金(n)</label>
					<div class="layui-input-inline">
						<input type="text" name="n" lay-verify="" autocomplete="off" class="layui-input" value="<%=policys.getString("n") %>" >
					</div>
				</div>
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">综合费用(s)</label>
					<div class="layui-input-inline">
						<input type="text" name="s" lay-verify="" autocomplete="off" class="layui-input" value="<%=policys.getString("s") %>" >
					</div>
				</div>
					<%i++;} %>
				<div class="layui-form-item" style="margin-bottom:45px">
					<div class="layui-input-block"  style="margin-left:540px">
						<button class="layui-btn" lay-submit="" ;>确认</button>
						<button type="reset" class="layui-btn layui-btn-primary">重置</button>
					</div>
				</div>
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
				//自定义验证规则
				form.verify({
					Required: function(value) {
							if(value.length <0) {
								return '该选项为必填项';
							}
						},
					isInt:[/^[1-9]*[1-9][0-9]*$/,'必须为整数'],
				});
			});
			
			<%	
	
	if(ac.equals("post")){
	 	String policyname = "";//政策名称
	 	String x = "";//实际贷款额
	 	String loanratio = "";//贷款比例
	 	String y = "";//贷款额
	 	String w ="";//收入
	 	String z ="";//月还款系数
	 	String mode = "";//月还款方式
	 	String o = "";//担保费
	 	String p = "";//服务费
	 	String q = "";//其他服务费
	 	String months = "";//月数
	 	String warranty = "";//履约保证金
	 	String m  = "";//还款期数
	 	String f = "";//	月还款固定金额
	 	String h ="";//月应还款金额
	 	String n ="";//本金
	 	String s ="";//综合服务费
	 	
		policyname = request.getParameter("policyname");
		x = request.getParameter("x").toLowerCase();
		loanratio = request.getParameter("loanratio");
		y = request.getParameter("y").toLowerCase();
		w = request.getParameter("w").toLowerCase();
		z = request.getParameter("z").toLowerCase();
		mode = request.getParameter("mode").toLowerCase();
		o = request.getParameter("o").toLowerCase();
		p = request.getParameter("p").toLowerCase();
		q = request.getParameter("q").toLowerCase();
		months = request.getParameter("months").toLowerCase();
		warranty = request.getParameter("warranty").toLowerCase();
		m = request.getParameter("m").toLowerCase();
		f = request.getParameter("f").toLowerCase();
		h = request.getParameter("h").toLowerCase();
		n = request.getParameter("n").toLowerCase();
		s = request.getParameter("s").toLowerCase();
		
		int ids = Integer.parseInt(request.getParameter("id"));
		//String sql = "update typegroup t set typegroupcode='"+typegroupcode+"',typegroupname='"+typegroupname+ "' where t.id = "+id;
		String sql = "update g_policy t set policyname='"+policyname+"',x='"+x+ "',loanratio='"+loanratio+"',y='"+y+"',w='"+w+"',z='"+z+"',mode='"+mode+"',o='"+o+"',p='"+p+"',q='"+q+"',months='"+months+"',warranty='"+warranty+"',m='"+m+"',h='"+h+"',f='"+f+"',n='"+n+"',s='"+s+"'"+" where t.id = "+ids;
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