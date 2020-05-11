<%@ page trimDirectiveWhitespaces="true"%>
<%@ page contentType="text/html; charset=UTF-8" language="java"  import="java.util.regex.*,java.net.*,java.util.*,net.sf.json.*"%>
<%String title = request.getParameter("title");
String uid = request.getParameter("uid"); 
String token = request.getParameter("token");
%> 
<html>
<head>
 <link rel="stylesheet" href="../../../a/pages/css/sy_style.css">	  
</head>
<body>
</body>
	<script language="JavaScript">
		var token ='<%=token%>';
		 window.location.href = '../../../a/pages/html/kebiao.html?apptoken='+token
	</script>
</html>