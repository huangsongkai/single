<meta http-equiv="Refresh" content="5" />
<%
String agentname=(String)session.getAttribute("agentname");
String project_name=(String)session.getAttribute("project_name"); 

if(agentname==null){
 out.print("<script language=\"javascript\">");
out.print("if(self.location!=top.location)");
out.print("{");
out.print("	top.location=self.location;");
out.print("}");
out.print("</script>");

out.print("<script language=\"JavaScript\">\r\n <!--\r\n alert(\"您没有登陆或者登陆超时,请重新登陆!\"); \r\n location.href='index.jsp'; \r\n// -->\r\n  </script>");
return ;
}
%>