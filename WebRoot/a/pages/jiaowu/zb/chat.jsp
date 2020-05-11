<%@ page trimDirectiveWhitespaces="true" %>
<%@page contentType="text/html; charset=UTF-8" language="java"%>
<%@ page import="java.text.*"%>
<%@page import="service.dao.db.Page"%>
<%@page import="v1.haocheok.commom.common"%>
<%@page import="v1.haocheok.commom.entity.UserEntity"%>
<%@page import="service.dao.db.Md5"%>
<%@include file="../../cookie.jsp"%>
 
<%String id = request.getParameter("id"); %>
 
<%  ResultSet laoshiRs=null;
    int selfTag=0; //默认不是主讲人的标记
 
  Md5 md5=new Md5();
  
  //通过当前id，查找老师id
      String teacherId="",teacherName="";
      laoshiRs = db.executeQuery("SELECT t.id,t.teacher_name FROM   teacher_basic AS t,user_worker AS w WHERE t.id=w.uid AND w.uid='"+Suid+"'");
	 while (laoshiRs.next()) {  
		 teacherId=laoshiRs.getString("id");
		 teacherName=laoshiRs.getString("teacher_name");
      }if(laoshiRs==null){ laoshiRs.close();}  
      if(teacherId==null){teacherId="";}
      if(teacherId.length()==0){teacherId="";}
  
      
  
  int stag=0;
  String SYSID="",livename="",limg="",content="",status="",startime="",endtime="",addtime="";
  String studentNum="",teacherIds="",ztstatus="",UerIdSQL="";
  ResultSet Rs = db.executeQuery(" SELECT * FROM  `zb_live`  where   id='"+id+"' ");
	 if (Rs.next()) {stag=stag+1;
		 
		livename=Rs.getString("livename");
		content=Rs.getString("content");
	    startime=Rs.getString("startime");
	    endtime=Rs.getString("endtime");
		teacherIds=Rs.getString("teacherIds");
		status=Rs.getString("status");
		addtime=Rs.getString("addtime");
		limg=Rs.getString("img");
	 }  if(Rs!=null){ Rs.close();} 
	 
	 int yaoqingshu=db.Row("SELECT COUNT(*) as row FROM  zb_live_learn  WHERE liveid='"+id+"'");
	
//计算2个时间差
     SimpleDateFormat dfs = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        long between = 0;
        try {
            java.util.Date begin = dfs.parse(server.getTimeA());
            java.util.Date end = dfs.parse(endtime);
            between = (end.getTime() - begin.getTime());// 得到两者的毫秒数
        } catch (Exception ex) {
            ex.printStackTrace();
        }	
	    between=between/1000;//秒变1分钟
	   System.out.print("between="+between);
	 

	   String FMSSERVER="";
	   ResultSet FMSRs = db.executeQuery(" SELECT config_value   FROM  sys_config  where   id=1");
	   	 if (FMSRs.next()) {
	   		FMSSERVER=FMSRs.getString("config_value");
	    } if(FMSRs==null){ FMSRs.close();} 
	    
 
	 //判断操作人是否是主讲人
	   if(teacherIds.indexOf("|")!=-1){
       String[] arr = teacherIds.split("\\|");
        for(int i=0;i<arr.length;i++){
    	  if(Suid.equals(arr[i])){selfTag=1;} //如果里面有操作人，赋值为是在主讲人里面
          }	//
       }
	    
	    
 //FMSSERVER="218.9.156.196:1935";
 
if(livename.length()<1){
if(db!=null)db.close();db=null;if(server!=null)server=null;
out.print("<script language=\"JavaScript\">\r\n <!--\r\n alert(\"编号为:"+id+"的课时 不存在\"); \r\n location.href='javascript:history.back(1)'; \r\n// -->\r\n  </script>");
return;
}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title><%=livename %>-<%=SYSname %></title>
<link href="../../vod/css/public.css" rel="stylesheet" type="text/css" />
<link href="../../vod/css/jiaoyu.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="../../vod/js/jquery-1.9.1.js"></script>
<script type="text/javascript" src="../../vod/js/iscroll.js"></script>
<script type="text/javascript" src="../../vod/js/jquery-browser.js"></script>
<script type="text/javascript" src="../../vod/js/jquery.qqFace.js"></script>
<script type="text/javascript" src="../../vod/js/techerchat.js"></script>
<script src="../../js/layui2/layui.js"></script>
</head>

<body>
 
 <%if(selfTag==0){ %>
 <script>alert("提示：您不是本直播教室的主讲老师，只能查看，不能接受学生互动信息。");</script>
 <%} %>
 
	 <div align="center"><a href="educational_live.jsp" title="点击回到直播列表"><img src="../../images/chattop.jpg" width="500" height="110"></img></a></div>
        <!---->
        
          <div class="zhibo_div">
		  <div class="wapper_1000">
    		
    		
    		
    		    <div class="lt zuo_zhi_div">
    			<div class="keshi_tit zhibo_tit">直播信息</div>
    			<div class="tu_div"><span><%=status %></span><img  style="width: 99%; height: 100px;" src="<%=limg %>"/></div>
    			<hr/>
    			<div class="keshi_tit zhibo_tit">听课学生-<%=yaoqingshu %>人</div>
    			<div>
	    			<div id="wrapper1">
		    			<ul id="studentlist">
		    				<li><a>加载中...</a></li>
		    				<%for(int j=0;j<=yaoqingshu;j++) {%>
		    				<li><a></a></li><%} %>
		    			 
		    				
		    				
		    			</ul>
	    			</div>
    			</div>
    		</div>
        
        
        
         
    	   
    	   

    		<div class="lt zhong_zhi_div">
    			<h4><%=livename %></h4>
    			<p class="xinxi">课程时间信息：<%=startime %>&nbsp;  到<%=endtime %>&nbsp;&nbsp;还剩<font color="#d10707"><span id="mss">mss</span></font>结束</p>

    			<p class="xilie" ><span>主讲：<font color="#d10707">  <%
      if(teacherIds.indexOf("|")!=-1){
       String[] arr = teacherIds.split("\\|");
      for(int i=0;i<arr.length;i++){
      UerIdSQL=UerIdSQL+ " or id="+arr[i];
      }	//
      UerIdSQL=UerIdSQL.replaceFirst("or","");
      //out.print(UerIdSQL+"<br>");
           
       laoshiRs = db.executeQuery(" SELECT id,teacher_name FROM  `teacher_basic` where "+UerIdSQL+"");
	 while (laoshiRs.next()) {  
	     out.print(laoshiRs.getString("teacher_name")+" ");
      }if(laoshiRs==null){ laoshiRs.close();}   
   }// .indexOf("\\|")!=-1 end
         UerIdSQL=""; 	
    %></span></font> <a class="red_bg">邀请了<%=yaoqingshu%>人<a class="red_bg">完成课程目标<%=db.Row("SELECT COUNT(*) as row FROM  zb_live_learn  WHERE liveid='"+id+"' and status=1") %>人</a><a class="xiazai">目前<%=db.Row("SELECT COUNT(*) as row FROM  zb_live_learn  WHERE liveid='"+id+"' and chatonline=1") %>人在线</a></p>
    			<div class="zhibodiv">
    				<div class="zhi_div">
    					<!-- <img src="images/paly_img.png"/> -->
    					<div class="video" id="CuPlayer" >
		<SCRIPT LANGUAGE=JavaScript>
		<!--
		/*
		* 跨平台方案X1（基于普通HTTP协议）=============
		* @param {Object} vID        ID
		* @param {Object} vWidth     播放器宽度设置
		* @param {Object} vHeight    播放器高度设置
		* @param {Object} vFile      播放器配置文件
		* @param {Object} vPlayer    播放器文件
		* @param {Object} vPic       视频缩略图
		* @param {Object} vCssurl    移动端CSS应用文件
		* @param {Object} vServer    RTMP服务器地址
		* @param {Object} vMp4url    RTMP视频文件地址
		* @param {Object} vIosurl    视频文件地址
		
		* 跨平台方案X1说明=============
		* 本实例请在IIS/Apache等网站环境下测试
		* 本实例主要为了实现直播的跨平台
		* 本实例要求用户有RTMP流媒体环境/并且实现M3u8流
		*/
		var vID        = ""; 
		var vWidth     = "100%";            //播放器宽度设置
		var vHeight    = 301;               //播放器高度设置
		var vFile      = "../../vod/CuSunV2setLive.xml";  //播放器配置文件
		var vPlayer    = "../../vod/player.swf?v=2.5";//播放器文件
		var vPic       = "../../vod/images/start.jpg";//视频缩略图
		var vCssurl    = "../../vod/images/mini.css"; //移动端CSS应用文件
	     
		  //直播PC端
		 var vServer    = "rtmp://<%=FMSSERVER%>/live/"; //RTMP点播服务器地址
		 var vMp4url    = "<%= md5.md5(id)%>";                   //RTMP点视频文件地址
		 
		//安卓端,iOS端
		var vIosurl    = "http://<%=FMSSERVER %>/live/<%= md5.md5(id)%>/playlist.m3u8"; //视频文件地址
		
		
		//-->
		</SCRIPT> 
		<script class="CuPlayerVideo" data-mce-role="CuPlayerVideo" type="text/javascript" src="../../vod/CuSunL2W.min.js"></script>
		</div>
    				</div>
    			</div>
    		</div>

    		<div class="rt you_zhi_div">
    		<input type="hidden" id="stuname" value="请从左面选择学生"/>
    		<input type="hidden" id="stuno" value="没有选择">
    		<input type="hidden" id="teachername" value="<%=Snickname %>">
    		<input type="hidden" id="tid" value="<%=Suid %>">
    		<input type="hidden" id="timg" value="<%=Sheadimgurl %>">
    		
    			<div class="keshi_tit zhibo_tit" id="chat_title">互动聊天</div>
    			<div class="zhibo_l_div">
	    			<div id="wrapper">
	    				<div class="duihua" id="duihua">
						    
						      <ol>
						     <span id="duihualit">
						     
						      <dl> 
						      <dd class="lt"><img src="../../images/empty_page_nothing.png"></dd>
		    					<dt class="lt">
		    						<p class="name">系统提示:</p>
		    						<p class="time"> <%=server.getTimeA() %></p>
		    						<p>小贴士：如果要查看与某个学生更多的历史记录请发送【历史消息】4个关键词即可。</p>
		    					 </dt>
		    				  </dl>
		    				  </span>
		    				  </ol>
		    			    
		    			 
					 
		    			 
		    			 
		    				
						</div>
	    			</div>
	    			<%if(selfTag==1){ %>
	    			<textarea id="saytext" name="saytext">说点什么吧</textarea>
	    			<p class="fasong_p"><input class="fasong" value="发送" type="submit" onclick="addchat()"/><span class="emotion"></span></p>
	    			<%}else{ %>
	    			  <textarea id="saytext" name="saytext" disabled="disabled">您不是主讲老师不能参与互动</textarea>
	    			  <p class="fasong_p"><input class="fasong" value="不能参与沟通" type="submit"  disabled="disabled"/><span class="emotion"></span></p>
	    			  
	    			<%} %>
    			</div>
    		</div>
    	</div>
    </div>
      <input id="liveid" value="<%=id %>" type="hidden" />
        <!---->
        <div class="footer">
        	
        <section class="copyrights">
         <section class="mainWrap">
                <div class="copyrights_t">
                	<span class="info"><span>Copyright © 2016 hljsfjy.org.cn 版权所有</span><span> 黑ICP备12000865号 </span></span>
                </div>
                <div class="copyrights_b">
                    <span class="info"><span>地址：哈尔滨市南岗区学府路503号 邮编：150069 办公电话：0451-88079148 </span><span>请与我联系：招生咨询电话：0451-88079117 88079106 88079550  </span></span>
                </div>
            </section>
        </section>
        </div>
    </div>
</body>
<script type="text/javascript">
 
   window.onload=function(){
     
        daojishi();
     }

      var counttime=<%=between%>;//总秒钟
     
      function daojishi(){
      if(counttime>=0){
             var ms = counttime%60;//余数 89%60==29秒
             var mis = Math.floor(counttime/60);//分钟
             if(mis>=60){
              var hour=Math.floor(mis/60);

     mis=Math.floor((counttime-hour*60*60)/60);

              document.getElementById("mss").innerHTML=hour+"小时"+mis+"分"+ms+"秒数";
              
             }else if(mis>=1){
              document.getElementById("mss").innerHTML=mis+"分"+ms+"秒数"; 
             }else{
              document.getElementById("mss").innerHTML=ms+"秒数"; 
             }

   
              counttime--;
              vartt =  window.setTimeout("daojishi()",1000);
   }else{
       window.clearTimeout(vartt);
       window.confirm("直播结束,请单击结束"); 
       tijiao();
      
   }

   
     }
     
     function tijiao(){
       // document.forms[0].submit();
     }

</script>

<script>
		$('input:text').each(function(){  
var txt = $(this).val();  
$(this).focus(function(){  
if(txt === $(this).val()) $(this).val("");  
}).blur(function(){  
if($(this).val() == "") $(this).val(txt);  
});  
})  

		$("#saytext").focus(function(){
			if($("#saytext").html("说点什么吧")){
				$("#saytext").html("");
			}
		})
		$("#saytext").blur(function(){
			if($("#saytext").html("")){
				$("#saytext").html("说点什么吧");
			}
		})
		$('.emotion').qqFace({
			id : 'facebox', 
			assign:'saytext', 
			path:'images/arclist/'	//表情存放的路径
		});


           function loadedleft(){
                    
                   var scroll2 = new iScroll('wrapper1');
                   }
          window.addEventListener("DOMContentLoaded",loadedleft,false);
          
         function loadedriht(){
                   var  myscrol=new iScroll("wrapper");
                  }  
         
         HttpConnection();//HTTP长连接        
        
         </script>
         <script>



function newmsg(msg,id){
 layer.tips(msg,id);
}
newmsg('小提示：聊天时候需要点击这里选择一个学生', '#studentlist');
</script>
</html>
<%  if(db!=null)db.close();db=null;if(server!=null)server=null;%>