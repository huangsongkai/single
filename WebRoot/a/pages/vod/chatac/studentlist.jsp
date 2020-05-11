<%@ page trimDirectiveWhitespaces="true" %>
<%@page contentType="text/html; charset=UTF-8" language="java"%>
<%@ page import="java.text.*"%>
<%@page import="service.dao.db.Page"%>
<%@page import="v1.haocheok.commom.common"%>
<%@page import="v1.haocheok.commom.entity.UserEntity"%>
<%@page import="service.dao.db.Md5"%>
<%@include file="../../cookie.jsp"%>
<% Md5 md5=new Md5();
String id = request.getParameter("id");
int msgshu=0; int msgshu2=0;%>

<%
//通过当前id，查找老师id
String teacherId="",teacherName="";
ResultSet laoshiRs = db.executeQuery("SELECT t.id,t.teacher_name FROM   teacher_basic AS t,user_worker AS w WHERE t.id=w.uid AND w.uid='"+Suid+"'");
while (laoshiRs.next()) {  
	 teacherId=laoshiRs.getString("id");
	 teacherName=laoshiRs.getString("teacher_name");
}if(laoshiRs==null){ laoshiRs.close();}  
if(teacherId==null){teacherId="";}
if(teacherId.length()==0){teacherId="";}

%>

<% String chatusername="",chatuserstuo="",chatonline="";
 db.executeUpdate("update  `zb_live_learn` set `chatonline`='0' where  (UNIX_TIMESTAMP()-updatedTime)>15;"); //超出15秒没有活动的全为离线
ResultSet chatUerRs = db.executeQuery(" SELECT * FROM  `zb_live_learn` where liveid='"+id+"' and chatonline='1' order by saydatedTime desc ");
	 while (chatUerRs.next()) { 
		 chatusername=chatUerRs.getString("stuName");
		 chatuserstuo=chatUerRs.getString("stuo");
		 chatonline=chatUerRs.getString("chatonline");
		 msgshu=db.Row("SELECT COUNT(*) as row FROM  zb_chat  WHERE fromId='"+chatuserstuo+"'  AND toId='"+teacherId+"' AND selftag='0' AND readtag='0' ");
		 msgshu2=msgshu2+msgshu;
	
	 %>
	 <li><a href="javascript:chatstat('<%=chatusername %>','<%=chatuserstuo %>');"> <%if(msgshu>0){ %>(<%=msgshu %>)✉<%} %><font color="red" title="在线"><%=chatusername %>(<%=chatuserstuo %>)</font></a></li>
	<%msgshu=0;} if(chatUerRs==null){ chatUerRs.close();} %>
	<% chatUerRs = db.executeQuery(" SELECT * FROM  `zb_live_learn` where liveid='"+id+"' and chatonline='0' order by saydatedTime desc ");
	 while (chatUerRs.next()) { 
		 chatusername=chatUerRs.getString("stuName");
		 chatuserstuo=chatUerRs.getString("stuo");
		 chatonline=chatUerRs.getString("chatonline");
		 msgshu=db.Row("SELECT COUNT(*) as row FROM  zb_chat  WHERE fromId='"+chatuserstuo+"'  AND toId='"+teacherId+"' AND selftag='0' AND readtag='0' ");
		 msgshu2=msgshu2+msgshu;
	 %>
	 <li><a href="javascript:chatstat('<%=chatusername %>','<%=chatuserstuo %>');"> <%if(msgshu>0){ %>(<%=msgshu %>✉<%} %><font color="#cccccc" title="离线状态"><%=chatusername %>(<%=chatuserstuo %>)</font></a></li></li>
       <% msgshu=0; } if(chatUerRs==null){ chatUerRs.close();} %>
      
      
      
      
      
<%  if(db!=null)db.close();db=null;if(server!=null)server=null;%>
<%if(msgshu2>0){ %>
 <audio  autoplay="autoplay">
  <source src="chatac/notify.ogg" type="audio/ogg" />
  <source src="chatac/notify.mp3" type="audio/mpeg" />
notify not support !
</audio>
<script>
eval("alert(1)");

</script>
 
<%}%>