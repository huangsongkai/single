<%@ page trimDirectiveWhitespaces="true" %>
<%@ page contentType="text/html; charset=UTF-8" language="java"  import="java.util.regex.*,java.sql.*,java.util.*,java.io.*,service.net.RemoteCallUtil"%>

<jsp:useBean id="db" scope="page" class="service.dao.db.Jdbc"/>
<jsp:useBean id="server" scope="page" class="service.dao.db.Page"/>
<%@page import="org.apache.commons.lang3.StringUtils"%>

<%//限制IP访问
String IP=request.getHeader("x-real-ip");
if(IP==null || IP.length()==0){IP=request.getRemoteAddr();}
String lanIp="";

ResultSet ipRs = db.executeQuery("SELECT  config_value  AS lanip FROM  sys_config  WHERE id='2';"); // 内网IP特征采集专用
if (ipRs.next()) {
    lanIp = ipRs.getString("lanip"); 
} if(ipRs!=null)ipRs.close();

List <String>  ipList=java.util.Arrays.asList(lanIp.split(","));
 if(server.IPMatch(ipList,IP) == false){
	 out.print(IP+"---！！！NOip");
	 if(db!=null)db.close();db=null;if(server!=null)server=null;
	 return; 
 } 
 
%>

<%
/**
* 本文件实现具体采集，通过新闻id，判断数据库不存在就插入一条。
*/

String newsId=request.getParameter("id"); //新闻id
String lanip=request.getParameter("lanip"); //内网要采集的服务器ip地址

String newsServer="http://"+lanip+"/";//配置要采集的服务器地址
String newsInfoUrl=newsServer+"news_mx.php?id="+newsId; //重要通知 诊改工作 	学院新闻

//String newsInfoUrl = "http://www.hljsfjy.org.cn/news_mx.php?id="+newsId;
String picInfoUlr=newsServer+"pic_mx.php?id="+newsId; //系部动态 教学科研信息 团学活动
//String picInfoUlr = "http://www.hljsfjy.org.cn/pic_mx.php?id="+newsId;

ArrayList<String> urls = new ArrayList<String>();

urls.add(newsInfoUrl);
urls.add(picInfoUlr);

for(int i =0 ;i<urls.size();i++){
	String newsHtml=""; //获得新闻内容

	//抓取到网页
	newsHtml=RemoteCallUtil.getUrlValue(urls.get(i),"gb2312");//远程网页编码 可以是utf8
	//out.print(newsHtml);
	
	//抓取到所属类别名称
	 String classname="";

	 Matcher classnameRs=Pattern.compile("<span class=\"list13\"><strong>(.*?)</strong></span></td>").matcher(newsHtml);   
	 while(classnameRs.find()){   
		classname=classnameRs.group(0).replaceAll("<\\/?[^>]+>","").replaceAll(" ","");
	 }  
	 out.print("classname : "+classname);
	 
	 
	//抓取到标题
	 String title="";
	 Matcher titleRs=Pattern.compile("<td height=\"22\" align=\"center\" class=\"jy_e_font_t STYLE2\">(.*?)</td>").matcher(newsHtml);   
	 while(titleRs.find()){   
		 title=titleRs.group(0).replaceAll("<\\/?[^>]+>","");
	 }  
	 out.print("title : "+title+"<br>");
	 
	//抓取到发布时间
	 String adddata="";
	 Matcher adddataRs=Pattern.compile("<span class=\"STYLE3\">发表时间： (.*?)&nbsp;&nbsp; 点击次数").matcher(newsHtml);   
	 while(adddataRs.find()){   
		 adddata=adddataRs.group(0).replaceAll("<\\/?[^>]+>","").replaceAll("发表时间：","").replaceAll(" ","").replaceAll("&nbsp;","").replaceAll("点击次数","");
	 }  
	 
	 if(StringUtils.isBlank(adddata)){
		  adddataRs=Pattern.compile("<td height=\"22\" align=\"center\">(.*?)点击次数").matcher(newsHtml);
		 while(adddataRs.find()){   
			 adddata=adddataRs.group(0).replaceAll("<\\/?[^>]+>","").replaceAll("发表时间：","").replaceAll(" ","").replaceAll("&nbsp;","").replaceAll("点击次数","");
		 }  
	 }
	 if(StringUtils.isBlank(adddata)){
		 adddata="0000-00-00";
	 }
	 out.print("adddata : "+adddata+"<br>");

	//抓取到点击次数
	 String hits="";
	 Matcher hitsRs=Pattern.compile("&nbsp;&nbsp; 点击次数：(.*?)</span></td>").matcher(newsHtml);   
	 while(hitsRs.find()){   
		 hits=hitsRs.group(0).replaceAll("<\\/?[^>]+>","").replaceAll(" ","").replaceAll(":","").replaceAll("&nbsp;","").replaceAll("点击次数：","");
	 }  
	 if(hits.length()>3){
		 hits = hits.substring(0,3);
	 }
	 out.print(" hits : "+hits+"<br>");

	//抓取到点新闻内容
	 String newsbody="";

	 Matcher newsbodyRs=Pattern.compile("<td height=\"22\" align=\"left\"><font color=\"#000000\">(.*?)</table>").matcher(newsHtml);   
	 if(newsbodyRs.find()){   
		 newsbody=newsbodyRs.group(0).replaceAll("</td>            </tr>		        </table><br>","").replaceAll("点击次数","");  
	 }  
	 newsbody=newsbody.replaceAll("src=\"/userfiles/", "src=\"http://172.16.200.4/userfiles/");
	 
	 if(StringUtils.isBlank(newsbody)){
		  newsbodyRs=Pattern.compile("<td height=\"22\" align=\"left\" class=\"input\"><font color=\"#000000\">(.*?)</table>").matcher(newsHtml);   
		 if(newsbodyRs.find()){   
			 newsbody=newsbodyRs.group(0).replaceAll("</td>            </tr>		        </table><br>","").replaceAll("点击次数","");  
		 }  
		 newsbody=newsbody.replaceAll("src=\"/userfiles/", "src=\"http://172.16.200.4/userfiles/");
	 }
	 
	 
	 String bodyimg="";// 新闻中的图片
	 Matcher newsbodyimgRs=Pattern.compile("src=(.*?)[^>]*?>").matcher(newsbody);   
	 if(newsbodyimgRs.find()){ 
		  bodyimg=newsbodyimgRs.group(0).replaceAll("<\\/?[^>]+>","").replaceAll("src=\"|/>|\"","").replaceAll(" ","");  
	  }
	 
	 //out.print(newsbody+"<br>");
	 
	 //out.println(bodyimg+"<br>");
	 
	 int tag=0; //判断是否存在默认不存在
	 String pxid = "0"; // 定义类别
	 System.out.println(classname);
	 if(StringUtils.isNotBlank(classname)){
			if ("学院新闻".equals(classname)) {
				pxid = "1"; //1
			}else if ("重要通知".equals(classname)) {
				pxid = "2"; //1
			}
			else if ("系部动态".equals(classname)) {
				pxid = "3"; //1
			}
			else if ("教学科研信息".equals(classname)) {
				pxid = "4"; //1
			}
			else if ("团学活动".equals(classname)) {
				pxid = "5"; //1
			}else if("诊改工作".equals(classname)){//
				pxid = "6";
			}else{
				pxid= "7";//不是以上6中类型
			}
			 tag=db.Row("SELECT COUNT(*) AS ROW  FROM `db_news` WHERE oid="+newsId +" and pxid="+pxid);
			 if(tag==0 && classname.length()>2 && title.length()>2){ //如果不存在就插入一条
					out.print("成功获得newsId="+newsId+" title="+title); 
				   db.executeUpdate("INSERT INTO  `db_news`(`oid`,`pxid`,`nclass`,`title`,`content`,`adddate`,`hits`,`thumb`) VALUES ( '"+newsId+"','"+pxid+"','"+classname+"','"+title+"','"+newsbody+"','"+adddata+"','"+hits+"','"+bodyimg+"');");
			 }else{
					out.print("没有得到或者已经存在的newsId="+newsId+" "+title); 
			 }
	 }else{
		 out.print("newsInfoUlr下没有对应文章");
	 }
}
%>
<% if(db!=null)db.close();db=null;if(server!=null)server=null;%>
 