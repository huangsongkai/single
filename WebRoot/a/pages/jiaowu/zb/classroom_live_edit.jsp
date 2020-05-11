<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
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
<%//直播教室编辑模块
/** 
 * @author LiGaoSong  E-mail: 932246@qq.com 
 * @version 创建时间：2017-9-3 下午01:07:32 
 *  题库添加：表live
 */
 String eid=request.getParameter("eid");
String ename=request.getParameter("ename");
if(eid==null){eid="0";}
 %>
 <%//获得当前eid
 int Dlivetag=0; 
 ResultSet laoshiRs=null;
 String Dhits="",Dcalltag="",Dliveid="",Dlimitmin="",Dimg="",Dstatus="",Dlivename="",Dcontent="",Dstartime="",Dendtime="",DteacherIds="";
 ResultSet DliveRs = db.executeQuery("SELECT * FROM zb_live  WHERE id='"+eid+"';");
	 if (DliveRs.next()) {
	     Dlivetag=Dlivetag+1;
         Dhits=DliveRs.getString("hits");
         Dliveid=DliveRs.getString("id");
         Dimg=DliveRs.getString("img");
         Dcontent=DliveRs.getString("content");
         Dlivename=DliveRs.getString("livename");
         Dstartime=DliveRs.getString("startime");
         Dendtime=DliveRs.getString("endtime");
         Dlimitmin=DliveRs.getString("limitmin");
         Dstatus=DliveRs.getString("status");
         Dcalltag=DliveRs.getString("calltag");
         DteacherIds=DliveRs.getString("teacherIds");
       }  if(DliveRs!=null){ DliveRs.close();}   
       
       String datasString="",UerIdSQL=""; 
      DliveRs = db.executeQuery("SELECT stuo,stuName FROM zb_live_learn  WHERE liveid='"+Dliveid+"';");
	 while (DliveRs.next()) {
	           datasString=datasString+"\r\n"+DliveRs.getString("stuo")+"#"+DliveRs.getString("stuName");
         }  if(DliveRs!=null){ DliveRs.close();}    
       
      %>
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
    <input name="eid" type="hidden" value="<%=eid %>"/>
    <input name="ename" type="hidden" value="<%=ename %>"/>
    <div id="infos1">
    
    <dl><dt>直播教室名称：</dt><dd><input name="title" id="title" type="text" class="int"   value="<%=Dlivename %>" style="width:300px;"></dd><dd>
    </dd></dl>
   <dl><dt>课程目标：</dt><dd><input name="limitmin" id="limitmin" type="text" class="int" onKeyUp="value=value.replace(/[^\d.]/g,'')"   value="<%=Dlimitmin %>" style="width:30px;">分钟</dd><dd class="t">最少需要收看5分钟算完成课程指标</dd><dd>
    </dd></dl>
 
  <dl><dt>状态：</dt>
      <dd>
     <select name="status">
     <option value="<%=Dstatus %>"><%=Dstatus %></option>
     <option value="待开始">待开始</option>
     <option value="即将开始">即将开始</option>
     <option value="直播中">直播中</option>
      <option value="直播结束">直播结束</option>
    </select>
    </dd></dl>
    
   <dl><dt>是否电话通知</dt>
      <dd>
     <select name="calltag">
     <%if("0".equals(Dcalltag)) {%>
     <option value="0"  selected="selected" >不通知</option>
     <option value="1">电话通知</option>
     <%}else{ %>
     <option value="0">不通知</option>
     <option value="1"  selected="selected" >电话通知</option>
     <%} %>
   
    </select>
    </dd><dd class="t">会在系统设定的提取N小时通知主播老师与被邀请听课的学生</dd></dl> 
    
    
       <dl><dt>直播老师：</dt>
      <dd>
     
   <div align="left">
     <%  
     int brtag=0;
     String laoshiname="";
     laoshiRs = db.executeQuery(" SELECT sex,teacher_name,id FROM  `teacher_basic` order by teacher_name desc");
	 while (laoshiRs.next()) {
		 laoshiname=laoshiRs.getString("teacher_name");
		 brtag=brtag+1;%>
	 <input type="checkbox" name="laoshi"
	 <%if(DteacherIds.equals(laoshiRs.getString("id")+"|")){ %>checked="checked" <%} %>
	  value="<%=laoshiRs.getString("id") %>"><%if(laoshiname.length()<3){out.print(laoshiname+"&nbsp;&nbsp;&nbsp;");}else{out.print(laoshiname);} %>(<%=laoshiRs.getString("sex") %>)&nbsp;
      <%if(brtag%10==0){ out.print("<br>");}%>
   <%}if(laoshiRs==null){ laoshiRs.close();} %>
   	</div>
  
     
    </dd></dl>
    
     <dl><dt>直播开始时间：</dt><dd><input name="startTime" id="startTime" type="text" class="int" value="<%=Dstartime%>" onClick="jeDate({dateCell:'#startTime',isTime:true,format:'YYYY-MM-DD hh:mm:ss'})"><dd class="t">选择直播开始时间需要填写</dd></dd>
     <dl><dt>直播结束时间：</dt><dd><input name="endTime" id="endTime" type="text" class="int" value="<%=Dendtime %>" onClick="jeDate({dateCell:'#endTime',isTime:true,format:'YYYY-MM-DD hh:mm:ss'})"><dd class="t">选择直播结束时间需要填写</dd></dd>
      <dd>&nbsp;</dd>
    </dl>
    
      
   <dl id="litpicover" class="fileover" style=""><dt>&nbsp;</dt></dl>
    <dl><dt>直播室缩略图：</dt><dd><input name="img" id="img" type="text" class="int" value="<%=Dimg %>"><dd class="t">例：images/demo.jpg尺寸建议420*283像素</dd></dd>
     <dd>&nbsp;</dd>
    </dl>
    <span id="fieldsinfo"></span>
    <dl><dt>课时简介：</dt>
      <dd> 
 
		<textarea  name="body" cols="100" rows="8" style="width:700px;height:200px;visibility:hidden;"><%=Dcontent %></textarea>
		   
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
    <textarea name="studenlist" id="studenlist" cols="100" rows="8" onkeyup="hangshu()"><%=datasString %></textarea>
    
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
    <dl><dt>操作理由</dt>
      <dd>
     <select name="liyou">
     <option value="请选择">请选择*必选项</option>
     <option value="只修改直播室状态与信息">只修改直播室状态与编辑其信息</option>
     <option value="新添所选听课同学">新添所选听课同学</option>
     <option value="删除所选听课同学">删除所选听课同学</option>
      <option value="更新为所选同学">更新为所选同学-重新电话通知</option>
    </select>
    </dd><dd class="t">必须选择，你到底要干什么</dd></dl>
    <div id="infos2"  >
     <dl><dt>点击次数：</dt><dd><input name="hits" type="text" class="int" onKeyUp="value=value.replace(/[^\d.]/g,'')" value="<%=Dhits%>"></dd></dl>
        <dl> 
      </dd></dl>
    </div>
    <dl><dt>&nbsp;</dt><dd><input type="submit" id="submit" value="编辑直播教室" class="btnbig"></dd></dl>
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

String pid=request.getParameter("eid");//
String ptitle=request.getParameter("title");//
String pcontent=request.getParameter("body");
String pimg=request.getParameter("img");
String pliyou=request.getParameter("liyou");


if(request.getParameter("laoshi")==null)
	{out.print("<script language=\"JavaScript\">\r\n \r\n alert(\"老师必须填写!\"); \r\n location.href='javascript:history.back(1)'; \r\n// \r\n  </script>");
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

String studenlist=request.getParameter("studenlist");
String[] studenlistARRhang=studenlist.split("\r\n"); //得到学生


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
 
System.out.println("pteacherIds="+pteacherIds); 
 
if(ptitle.length()<1)
	{out.print("<script language=\"JavaScript\">\r\n \r\n alert(\"直播教室名必须填写!\"); \r\n location.href='javascript:history.back(1)'; \r\n// \r\n  </script>");
if(db!=null)db.close();db=null;if(server!=null)server=null;
return;
}


//判断操作理由---------------------
String SQL="",cgmsg=""; int students=0;
if ("只修改直播室状态与信息".equals(pliyou))  {
  SQL="UPDATE `zb_live` SET `livename`='"+ptitle+"',`content`='"+pcontent+"',`limitmin`='"+plimitmin+"',`img`='"+pimg+"',`teacherIds`='"+pteacherIds+"',`startime`='"+pstartTime+"',`endtime`='"+pendTime+"',`hits`='"+phits+"',`calltag`='"+pcalltag+"',`status`='"+pstatus+"',`userId`='"+puserId+"' WHERE `id`='"+pid+"';";
  db.executeUpdate(SQL);
  cgmsg="修改直播室状态与信息相关信息成功！";
}



else if ("新添所选听课同学".equals(pliyou)){

for(int i=0;i<studenlistARRhang.length;i++){  
 if(studenlistARRhang[i].indexOf("#")!=-1){
  students=students+1;
      String[] list2=studenlistARRhang[i].split("#");
         out.print(list2[0]+list2[1]+"<br>"); 
        //排查已经存在的
         if(db.Row("SELECT COUNT(*) as row FROM   zb_live_learn  WHERE  liveid='"+pid+"' and stuo='"+list2[0]+"' ")==0){
            db.executeUpdate(" INSERT INTO  `zb_live_learn`(`liveid`,`stuo`,`stuName`,`addtime`) VALUES ('"+pid+"','"+list2[0]+"','"+list2[1]+"','"+server.getTimeA()+"');");
         } else{  }
    } //indexoF end
  }//i++ end
  cgmsg="新添所选听课同学息成功,一共邀请了"+students+"个学生。\\n 如果该课程设置了电话提醒，会重新电话通知这"+students+"学生。\\n 注意：这些同学需要重新学习！";
  
 } //liyou end


else if ("删除所选听课同学".equals(pliyou)){

for(int i=0;i<studenlistARRhang.length;i++){  
 if(studenlistARRhang[i].indexOf("#")!=-1){
  students=students+1;
      String[] list2=studenlistARRhang[i].split("#");
         out.print(list2[0]+list2[1]+"<br>"); 
        //排查已经存在的
            db.executeUpdate(" DELETE FROM  `zb_live_learn` WHERE liveid='"+pid+"' and stuo='"+list2[0]+"';");
          
    } //indexoF end
  }//i++ end
  cgmsg="删除所选听课同学相关信息成功,一共清掉了"+students+"个学生。\\n 这"+students+"学生的学习记录将被清掉。";
  
 
}
else if ("更新为所选同学".equals(pliyou)){

for(int i=0;i<studenlistARRhang.length;i++){  
 if(studenlistARRhang[i].indexOf("#")!=-1){
  students=students+1;
      String[] list2=studenlistARRhang[i].split("#");
         out.print(list2[0]+list2[1]+"<br>"); 
          db.executeUpdate(" DELETE FROM  `zb_live_learn` WHERE liveid='"+pid+"' and stuo='"+list2[0]+"';");
        //排查已经存在的
         if(db.Row("SELECT COUNT(*) as row FROM   zb_live_learn  WHERE  liveid='"+pid+"' and stuo='"+list2[0]+"' ")==0){
            db.executeUpdate(" INSERT INTO  `zb_live_learn`(`liveid`,`stuo`,`stuName`,`addtime`) VALUES ('"+pid+"','"+list2[0]+"','"+list2[1]+"','"+server.getTimeA()+"');");
         } else{  }
    } //indexoF end
  }//i++ end
  cgmsg="新添所选听课同学息成功,一共邀请了"+students+"个学生。\\n 如果该课程设置了电话提醒，会重新电话通知这"+students+"学生。\\n 注意：这些同学需要重新学习！";
  
}


else {out.print("<script language=\"JavaScript\">\r\n \r\n alert(\"操作理由必须填写!\"); \r\n location.href='javascript:history.back(1)'; \r\n// \r\n  </script>");
if(db!=null)db.close();db=null;if(server!=null)server=null;
return;}
 

 
 
 //添加日志
  
String logsql="insert into `log_sys` ( `ltype`, `title`, `body`, `uid`, `fid`, `ip`, `status`, `addtime`) values('用户操作','"+Susername+"电脑修改直播室','"+Susername+" 编辑直播室:"+ptitle+"->[开播时间"+pstartTime+"]邀请了"+students+"个学生','1','0','"+ip+"','0',now());";
db.executeUpdate(logsql);
 
//System.out.println(java.net.URLEncoder.encode(SQL,"utf-8"));
out.print("<script language=\"JavaScript\">\r\n \r\n alert(\""+cgmsg+"\"); \r\n location.href='classroom_live_edit.jsp?eid="+pid+"&ename="+ptitle+"'; \r\n// \r\n  </script>");
 }  %>
 
 
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
 </body>
 
</html>

 