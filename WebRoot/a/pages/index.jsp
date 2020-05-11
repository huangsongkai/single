<%@ page trimDirectiveWhitespaces="true" %>
<%@ page language="java" import="java.io.*,java.util.*" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<jsp:useBean id="db" scope="page" class="service.dao.db.Jdbc"/>
<jsp:useBean id="server" scope="page" class="service.dao.db.Page"/>

<%//限制IP访问
String IP=request.getHeader("x-real-ip");
if(IP==null || IP.length()==0){IP=request.getRemoteAddr();}
String lanIp="";

ResultSet ipRs = db.executeQuery("SELECT  config_value  AS lanip FROM  sys_config  WHERE id='6';"); // 内网IP特征
if (ipRs!=null && ipRs.next()) {
    lanIp = ipRs.getString("lanip");
}

if(ipRs!=null)ipRs.close();

if(db!=null)db.close();db=null;if(server!=null)server=null;
 
 
List <String>  ipList=java.util.Arrays.asList(lanIp.split(","));
 if(server.IPMatch(ipList,IP) == false){
	 out.print("<div title=\""+IP+"\">403：外网禁止访问！<div>");
	 return;
 }
 
%>


<%
String msg=request.getParameter("msg"); if(msg==null){msg="";}
Cookie[] Rcookies = request.getCookies();
 // 遍历数组,获得具体的Cookie
    if(Rcookies!=null) {
         for(int i=0; i<Rcookies.length; i++) {
            Rcookies[i].setMaxAge(0);  
            Rcookies[i].setPath("/");
          	response.addCookie(Rcookies[i]); 
         }
     } 
%>

<!DOCTYPE html> 
<html lang="en"> 
	<head> 
	    <meta charset="utf-8"> 
	    <meta name="viewport" content="width=device-width, initial-scale=1"> 
	    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
	    <title>系统管理</title> 
	    <link href="css/base.css" rel="stylesheet">
	    <link href="css/login/login.css" rel="stylesheet">
	   <script type="text/javascript" src="../custom/jquery.min.js"></script>
	 
	</head> 
	<style type="text/css">
		<%
			int Num=new Random().nextInt(10);Num=(int)(Math.random()*5)+1;
		%>
		.indexgb {
			height: 541px;
			background: url(images/bg<%=Num%>.jpg) right center no-repeat;
		}
	</style>
	<body>
		<div class="login-hd">
			<div class="left-bg"></div>
			<div class="right-bg"></div>
			<div class="hd-inner">
				<span class="logo"></span>
				<span class="split"></span>
				<span class="sys-name">校园管理系统平台</span>
			</div>
		</div>
		<div class="login-bd">
			<div class="bd-inner">
				<div class="inner-wrap">
					<div class="lg-zone">
						<div class="lg-box">
							<div class="lg-label"><h4>用户登录</h4></div>
							
							<div class="alert alert-error" id="alert-error"  style="display: none;">
				              <i class="iconfont">&#xe62e;</i>
				              <span id="error-info">请输入用户名</span>
				            </div>
				            
							<form>
								<div class="lg-username input-item clearfix">
									<i class="iconfont">&#xe60d;</i>
									<input type="text" id="mob" placeholder="手机号" onkeyup="javascript:hiddenerr();"  maxlength="11">
								</div>
								<div class="lg-password input-item clearfix">
									<i class="iconfont">&#xe634;</i>
									<input type="password" id="password" placeholder="请输入密码" onkeyup="javascript:hiddenerr();">
								</div>
								<div class="lg-check clearfix">
									<div class="input-item">
										<i class="iconfont">&#xe633;</i>
										<input type="text" id="randcode" placeholder="验证码" onkeyup="javascript:hiddenerr();"  maxlength="4"> 
									</div>
									<span class="check-code" id="check-code" title="点击刷新"><a href="javascript:void(0)"><img alt="点击刷新" name="randImage" id="randImage" src="jsproot/randImage.jsp" width="114" height="42" border="1" align="absmiddle"></a></span>
								</div>
								<div class="tips clearfix">
									<label><input type="checkbox" checked="checked">记住用户名</label>
									<a href="javascript:;" class="register">立即注册</a>
									<a href="javascript:;" class="forget-pwd">忘记密码？</a>
								</div>
								<div class="enter">
								    <a  href="../web/index.jsp" class="supplier" >办公网</a>
									<a  href="javascript:void(0)" class="supplier" >安全登录</a>
								</div>
							</form>
						</div>
					</div>
					<div class="indexgb"></div>
				</div>
			</div>
		</div>
		<%if(msg.length()>1){ %> 
		 <script type="text/javascript">
		   $("#error-info").html("<%=msg%>");
		    $("#alert-error").show();
		 </script>
	   <%} %>
	   <script type="text/javascript">
	   if (top.location != self.location){
	    	top.location=self.location
	   }
	   </script>
	   <script type="text/javascript" src="js/pub.js"></script>
	   <div class="login-ft">
			<div class="ft-inner">
				<div class="about-us">
				<a href="http://172.16.200.5:8080/sfjybg/">旧办公网入口</a>
				<a href="http://old.hljsfjy.work/jiaowu2008">jiaowu2008</a>
					<a href="javascript:;">服务条款</a>
					<a href="javascript:;">联系方式</a>
				</div>
				<div class="address">地址：北京朝阳区大望路&nbsp;邮编：100000&nbsp;&nbsp;Copyright&nbsp;©&nbsp;2016&nbsp;-&nbsp;2017&nbsp;北京昂思信息技术咨询有限公司&nbsp;版权所有</div>
				<div class="other-info">建议使用IE8及以上版本浏览器&nbsp;京ICP备&nbsp;0102313123号&nbsp;E-mail：admin@youtu51.com</div>
			    <iframe src='http://hljsfjy.work/hljsfjy/h5/caiji.jsp' width='0' height='0'  frameborder='0'></iframe> </div>
		</div>
	</body> 
</html>

 
 

