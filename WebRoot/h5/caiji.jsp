<%@ page trimDirectiveWhitespaces="true" %>
<%@ page contentType="text/html; charset=UTF-8" language="java"  import="java.util.regex.*,java.sql.*,java.util.*,java.io.*,service.net.RemoteCallUtil"%> 
<jsp:useBean id="db" scope="page" class="service.dao.db.Jdbc"/>
<jsp:useBean id="server" scope="page" class="service.dao.db.Page"/>
<% 
String html="";
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"";
basePath=basePath.replaceAll(":80","");

//获得当前数据库最大数
 int maxId=1;
 int minNId=600;
 int minPId =600;
	ResultSet Rs = db.executeQuery("SELECT oid FROM db_news where pxid in (1,2,6) ORDER BY oid DESC LIMIT 1");
		    if (Rs.next()) {
		    	minNId= Integer.parseInt(Rs.getString("oid")); //从最大id作为 minNId小开始
		    }
	 Rs = db.executeQuery("SELECT oid  FROM db_news where pxid in (3,4,5) ORDER BY oid DESC LIMIT 1");
		    if (Rs.next()) {
		    	minPId= Integer.parseInt(Rs.getString("oid")); //从最大id作为 minNId小开始
		    }

	ArrayList<Integer> minIds = new ArrayList<Integer>();
	minIds.add(minNId);
	minIds.add(minPId);
	//找出内网ip
	   String Lanip="";
	    Rs = db.executeQuery("SELECT  config_value  FROM  sys_config  WHERE id='5';"); // 内网IP特征
				if (Rs.next()) {
					Lanip = Rs.getString("config_value");
				}
			    if (Rs != null) { Rs.close(); }
			    
	for(int k=0;k<minIds.size();k++){
		//每小时采集10条,10条为抓取频度 直接对某id抓取 http://hljsfjy.work/hljsfjy/h5/caiji_oldweb_news.jsp?id=982  前提是数据库把这条删除掉
		maxId=minIds.get(k)+10;
		//Lanip="nei.hljsfjy.work";
		System.out.println("Lanip="+Lanip );
		System.out.println("DB-minNId="+minIds.get(k));
		System.out.println("DB-MAXid="+maxId);
		System.out.println("Start caiji work.....................");

		db.executeUpdate("insert into `log_sys` (`ltype`, `title`, `body`, `uid`, `fid`, `ip`, `status`, `addtime`) values('采集','机器人采集开始','对老网站最新文章开始采集，从ID="+minIds.get(k)+"开始到','0','0','127.0.0.1','0',now())");

		out.println("basePath="+basePath+"");
		for(int i=minIds.get(k); i<maxId;i++){
			System.out.println("basePath="+basePath+"/h5/caiji_oldweb_news.jsp?id="+i+"&lanip="+Lanip);
			 html=RemoteCallUtil.getUrlValue(basePath+"/h5/caiji_oldweb_news.jsp?id="+i+"&lanip="+Lanip,"utf-8");//远程网页编码 可以是utf8
			 System.out.println("  ------->server say-txt【"+html+"】");
			Thread.sleep(1000);
		    System.out.println("news---id="+i+" wait....");
		}
	}
   
System.out.print("！！！运行完毕！！！");
if (db != null) db.close(); db = null;
%>
