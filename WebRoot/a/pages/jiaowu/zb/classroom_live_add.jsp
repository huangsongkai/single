<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%--//直播教室添加模块 --%>
<%@page trimDirectiveWhitespaces="true" %>
<%@page contentType="text/html; charset=UTF-8" language="java"%>
<%@page import="service.dao.db.Page"%>
<%@page import="v1.haocheok.commom.common"%>
<%@page import="v1.haocheok.commom.entity.UserEntity"%>
<%@page import="service.dao.db.Md5"%>
<%@include file="../../cookie.jsp"%>
<%  String ip = request.getHeader("x-forwarded-for");
if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip))
{
  ip = request.getHeader("Proxy-Client-IP");
}
if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip))
{
  ip = request.getHeader("WL-Proxy-Client-IP");
}
if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip))
{
  ip = request.getRemoteAddr();
} %>
 
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
 <title><%=Mokuai %></title> 
<link href="images/favicon1e5b3a.ico"  rel="Shortcut Icon">
<link rel="stylesheet" type="text/css" href="../../vod/css/layout_head20273e.css"/>
<link rel="stylesheet" type="text/css" href="../../vod/css/base204f7e.css"/>
<link rel="stylesheet" type="text/css" href="../../vod/css/lib1ffa7e.css"/>
<link href="../../vod/css/page_index1ec663.css" rel="stylesheet" type="text/css">
 <link href="../../vod/css/admin.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" href="../../vod/css/kindeditor/themes/default/default.css" />
<script type="text/javascript" src="../../vod/jeDate/jedate.js"></script>
<link type="text/css" rel="stylesheet" href="../../vod/jeDate/skin/jedate.css">

	<link rel="stylesheet" href="../../vod/kindeditor/plugins/code/prettify.css" />
	<script charset="utf-8" src="../../vod/kindeditor/kindeditor-min.js"></script>
	<script charset="utf-8" src="../../vod/kindeditor/lang/zh-CN.js"></script>
	<script charset="utf-8" src="../../vod/kindeditor/plugins/code/prettify.js"></script>
	<script charset="utf-8" src="../../vod/js/pubajx.js"></script>
	<script>
		KindEditor.ready(function(K) {
			var editor1 = K.create('textarea[name="body"]', {
				cssPath : '../../vod/kindeditor/plugins/code/prettify.css',
				uploadJson : '../../vod/kindeditor/upload_json.jsp',
				fileManagerJson : '../../vod/admin/kindeditor/file_manager_json.jsp',
				allowFileManager : true,
				afterCreate : function() {
					var self = this;
					K.ctrl(document, 13, function() {
						self.sync();
						document.forms['example'].submit();
					});
					K.ctrl(self.edit.doc, 13, function() {
						self.sync();
						document.forms['example'].submit();
					});
				}
			});
			prettyPrint();
		});
	</script>
	
	
    </head>
    
 
    <body class="zh_CN">
 
  <style type="text/css">    
   *{padding:0;margin:0;}  
    body{background-color: #fff;}
   
  </style>
  
   
	 
	   <div class="col_main">
	   <div class="main_hd">
    
	  <div class="main">
 
	<div class="info">
    <form action="?ac=adddata" method="post" id="gform">
    <input name="eid" type="hidden" value=""/>
    <input name="ename" type="hidden" value=""/>
    <div id="infos1">
    
    <dl><dt>直播教室名称：</dt><dd><input name="title" id="title" type="text" class="int"   value="" style="width:300px;"></dd><dd>
    </dd></dl>
   <dl><dt>课程目标：</dt><dd><input name="limitmin" id="limitmin" type="text" class="int" onkeyup="value=value.replace(/[^\d.]/g,'')"  value="5" style="width:30px;">分钟</dd><dd class="t">最少需要收看5分钟算完成课程指标</dd><dd>
    </dd></dl>
 
  <dl><dt>状态：</dt>
      <dd>
     <select name="status">
      <option value="待开始">待开始</option>
     <option value="即将开始">即将开始</option>
     <option value="直播中">直播中</option>
      <option value="直播结束">直播结束</option>
    </select>
    </dd></dl>
    
   <dl><dt>是否电话通知</dt>
      <dd>
     <select name="calltag">
      <option value="1">电话通知</option>
     <option value="0">不通知</option>
    
   
    </select>
    </dd><dd class="t">会在系统设定的提取N小时通知被邀请听课的学生</dd></dl> 
    
    
       <dl><dt>直播老师：</dt>
      <dd>
     
   <%
   int brtag=0;
   String laoshiname="";
   ResultSet laoshiRs = db.executeQuery(" SELECT sex,teacher_name,id FROM  `teacher_basic` limit 50");
	 while (laoshiRs.next()) {
         laoshiname=laoshiRs.getString("teacher_name");
		 brtag=brtag+1;%>
	 <input type="checkbox" name="laoshi" value="<%=laoshiRs.getString("id") %>"><%if(laoshiname.length()<3){out.print(laoshiname+"&nbsp;&nbsp;&nbsp;");}else{out.print(laoshiname);} %>(<%=laoshiRs.getString("sex") %>)&nbsp;
     <%if(brtag%8==0){ out.print("<br>");}%>
   <%}if(laoshiRs==null){ laoshiRs.close();} %>
   
    
     
    </dd></dl>
    
     <dl><dt>直播开始时间：</dt><dd><input name="startTime" id="startTime" type="text" class="int" value="<%=server.getTimeA() %>" onClick="jeDate({dateCell:'#startTime',isTime:true,format:'YYYY-MM-DD hh:mm:ss'})"><dd class="t">选择直播类型需要填写</dd></dd>
     <dl><dt>直播结束时间：</dt><dd><input name="endTime" id="endTime" type="text" class="int" value="<%=server.getTimeA() %>" onClick="jeDate({dateCell:'#endTime',isTime:true,format:'YYYY-MM-DD hh:mm:ss'})"><dd class="t">选择直播类型需要填写</dd></dd>
      <dd>&nbsp;</dd>
    </dl>
    
      
   <dl id="litpicover" class="fileover" style=""><dt>&nbsp;</dt></dl>
    <dl><dt>直播室缩略图：</dt><dd><input name="img" id="img" type="text" class="int" value="../../images/demo.jpg"><dd class="t">例：images/demo.jpg,尺寸建议420*283像素</dd></dd>
     <dd>&nbsp;</dd>
    </dl>
    <span id="fieldsinfo"></span>
    <dl><dt>课时简介：</dt>
      <dd> 
 
		<textarea name="body" cols="80" rows="8" style="width:400px;height:200px;visibility:hidden;"></textarea>
		   
		<br />
	 
 

	 </dd></dl>
 
 
       </div>
      
    <div id="infos2"  >
     <dl><dt>听课学生选择</dt><dd>
    <select name="select" id="classlist">
    <option value="班级名" selected="selected">班级名</option>
   <%   ResultSet ClssRs = db.executeQuery(" SELECT id,class_name,class_number FROM class_grade order by class_number desc");
	 while (ClssRs.next()) {
	 %>
    <option value="<%=ClssRs.getString("id") %>"><%=ClssRs.getString("class_number") %>→<%=ClssRs.getString("class_name") %></option>
      <%}  if(ClssRs!=null){ ClssRs.close();} %>
  </select>  <br>
  <input type="button" id="submit" value="+添加到->" class="btnbig"  onclick="selectac()">
    <br>
    <textarea name="studenlist" id="studenlist" cols="80" rows="8" onkeyup="hangshu()"></textarea>
 </dd></dl>
        <dl> 
      </dd></dl>
      
          <dl><dt>所选学生数：</dt><dd id="snum">0</dd></dl>
        <dl> 
      </dd></dl>  
    </div>
    <input type="hidden" id="X-UUID" value="UUID-admin-<%=Suid%>">
    <input type="hidden" id="Token" value="<%=Spc_token%>">
    <input type="hidden" id="X-NetMode" value="admin-pc-wifi">  
  <script>
 function selectac(){
  var  classlist=document.getElementById("classlist").value;
  var Postjson="{\"classroomid\":\""+classlist+"\"}"; //发送字符串
  PubAtion(<%=Suid %>,Postjson,'studenlist','累加'); //发送-破坏者不用尝试了，已经做过安全认证了。
  //hangshu();
}
 function hangshu(){
   var studenlist=document.getElementById("studenlist").value;
   var  snum=0;
     if( studenlist.indexOf("#")!=-1){
            snum=document.getElementById("studenlist").value.split("\n").length; 
         }else{snum=0;}
  
   document.getElementById("snum").innerHTML =snum+"位学生，提交后系统会自动过滤重复的"
}
hangshu();

</script>   
    
    <div id="infos2"  >
     <dl><dt>点击次数：</dt><dd><input name="hits" type="text" class="int" onKeyUp="value=value.replace(/[^\d.]/g,'')" value="1"></dd></dl>
        <dl> 
      </dd></dl>
    </div>
    <dl><dt>&nbsp;</dt><dd><input type="submit" id="submit" value="创建新的直播教室" class="btnbig"></dd></dl>
    </form>
    </div>
</div>






	   </div>
	 
                 
   <div class="faq">
   <ul class="links"> </ul>
  </div>
 </div>
 
 <%!
private String htmlspecialchars(String str) {
	str = str.replaceAll("&", "&amp;");
	str = str.replaceAll("<", "&lt;");
	str = str.replaceAll(">", "&gt;");
	str = str.replaceAll("\"", "&quot;");
	return str;
}
%>
 

<%if( ac.equals("adddata")){

 
String ptitle=request.getParameter("title");//
String pcontent=request.getParameter("body");
String pimg=request.getParameter("img");

if(request.getParameter("laoshi")==null)
	{out.print("<script language=\"JavaScript\">\r\n \r\n alert(\"老师必须选择一位!\"); \r\n location.href='javascript:history.back(1)'; \r\n// \r\n  </script>");
if(db!=null)db.close();db=null;if(server!=null)server=null;
return;
}

String[] laoshiARR=request.getParameterValues("laoshi"); 
String pteacherIds="";
for(int i=0;i<laoshiARR.length;i++){  pteacherIds=pteacherIds+laoshiARR[i]+"|";  }
 

String pstartTime=request.getParameter("startTime");
String pendTime=request.getParameter("endTime");
 
String phits=request.getParameter("hits"); 
String pstatus=request.getParameter("status");
String plimitmin=request.getParameter("limitmin");
String pcalltag=request.getParameter("calltag");

 


String puserId=Suid; //  编辑者ID
String pusername=Susername;//  编辑者名字
 
 /*
out.print("ptitle="+ptitle+"<br>");
out.print("plength="+plength+"<br>");
out.print("ptype="+ptype+"<br>");
out.print("pstartTime="+pstartTime+"<br>");
out.print("pendTime="+pendTime+"<br>");

out.print("pstatus="+pstatus+"<br>");
out.print("pmediaDir="+pmediaDir+"<br>");
out.print("pmediaName="+pmediaName+"<br>");
out.print("pcontent="+pcontent+"<br>");

out.print("pcreatedTime="+pcreatedTime+"<br>");
out.print("pviewedNum="+pviewedNum+"<br>");*/
 
 
if(ptitle.length()<1)
	{out.print("<script language=\"JavaScript\">\r\n \r\n alert(\"直播教室名必须填写!\"); \r\n location.href='javascript:history.back(1)'; \r\n// \r\n  </script>");
if(db!=null)db.close();db=null;if(server!=null)server=null;
return;
}






String  SQL="";
//SQL="INSERT INTO  course(`title`,`length`,`giveCredit`,`status`,`smallPicture`,`middlePicture`,`about`,`teacherIds`,`hitNum`,`userId`,`createdTime`) VALUES ('"+ptitle+"','"+psubtitle+"','"+pgiveCredit+"','"+pstatus+"','"+psmallPicture+"','"+pmiddlePicture+"','"+pbody+"','"+pteacherIds+"','"+phits+"','"+adminid+"',UNIX_TIMESTAMP('"+ppublishedTime+"') );";

SQL="INSERT INTO  `zb_live`(`calltag`,`limitmin`,`livename`,`content`,`img`,`teacherIds`,`startime`,`endtime`,`hits`,`status`,`userId`,`addtime`) VALUES";
SQL=SQL+"('"+pcalltag+"','"+plimitmin+"','"+ptitle+"','"+pcontent+"','"+pimg+"','"+pteacherIds+"','"+pstartTime+"','"+pendTime+"','"+phits+"','"+pstatus+"','"+puserId+"','"+server.getTimeA()+"');";

 //out.print("KKK="+SQL);

 db.executeUpdate(SQL);


//添加学生
String maxid=""; int students=0;
     ResultSet getclassidRs = db.executeQuery(" SELECT MAX(id) as id FROM  `zb_live`  WHERE userid='"+Suid+"';");
	 if (getclassidRs.next()) {
	 maxid=getclassidRs.getString("id");
	 }  if(getclassidRs!=null){ getclassidRs.close();} 
	
//选课的学生
if(maxid!=null){
String studenlist=request.getParameter("studenlist");
String[] studenlistARRhang=studenlist.split("\r\n");
for(int i=0;i<studenlistARRhang.length;i++){  
 if(studenlistARRhang[i].indexOf("#")!=-1){
      String[] list2=studenlistARRhang[i].split("#");
         out.print(list2[0]+list2[1]+"<br>"); 
         System.out.print(list2[0]+list2[1]+"<br>"); 
         if(db.Row("SELECT COUNT(*) as row FROM   zb_live_learn  WHERE  liveid='"+maxid+"' and stuo='"+list2[0]+"' ")==0){
         db.executeUpdate(" INSERT INTO  `zb_live_learn`(`liveid`,`stuo`,`stuName`,`addtime`) VALUES ('"+maxid+"','"+list2[0]+"','"+list2[1]+"','"+server.getTimeA()+"');");
        students=students+1;
        }//排查已经存在的
    }
 }	
 }// maxid end
 
 //添加日志
String logsql="insert into `log_sys` ( `ltype`, `title`, `body`, `uid`, `fid`, `ip`, `status`, `addtime`) values('用户操作','"+Susername+"电脑创建直播室','"+Susername+" 创建直播室:"+ptitle+"->[开播时间"+pstartTime+"]邀请了"+students+"个学生','1','0','"+ip+"','0',now());";
db.executeUpdate(logsql);
 

//System.out.println(java.net.URLEncoder.encode(SQL,"utf-8"));
 out.print("<script language=\"JavaScript\">\r\n \r\n alert(\"添加直播教室成功,一共邀请了"+students+"个学生\"); \r\n location.href='classroom_live_add.jsp'; \r\n// \r\n  </script>");
 }  %>
 
 </body>
 
</html>


<%
long TimeEnd = Calendar.getInstance().getTimeInMillis();
System.out.println(Mokuai+"耗时:"+(TimeEnd - TimeStart) + "ms");
//插入常用菜单日志
int   TagMenu=db.Row("SELECT COUNT(*) as row FROM  menu_worker  WHERE sysmenuid='"+PMenuId+"' and  workerid='"+Suid+"'");
if(TagMenu==0){
     db.executeUpdate("INSERT INTO `menu_worker`(`sysmenuid`,`workerid`,`countes`) VALUES ('"+PMenuId+"','"+Suid+"','1');"); 
   }else{
  db.executeUpdate("UPDATE  `menu_worker` SET `countes`=countes+1,`usetime`=now() WHERE  sysmenuid='"+PMenuId+"' and  workerid='"+Suid+"'");
}
 %>
<%if(db!=null)db.close();db=null;if(server!=null)server=null;%>

 