<%@ page trimDirectiveWhitespaces="true" %>
<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@ page language="java" import="service.file.FileAc"%>
<%@page import="service.dao.db.Page"%>
<%@page import="autocode.action.GetKeyJsonString"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="net.sf.json.JSONArray"%>


<% String MMenuId="60"; //自动代码生成器-执行模块编号%>
<%@ include file="../../cookie.jsp"%>
<head> 
    <meta charset="utf-8"> 
    <meta name="viewport" content="width=device-width, initial-scale=1"> 
    <title><%=Mokuai%></title> 

<link href="../../css/base.css" rel="stylesheet">
<link rel="stylesheet" href="../../../custom/easyui/easyui.css">
<link rel="stylesheet" href="../../css/providers.css">

    <script type="text/javascript" src="../../../custom/jquery.min.js"></script>
    <script type="text/javascript" src="../../../custom/jquery.easyui.min.js"></script>
    <script type="text/javascript" src="../../../custom/easyui-lang-zh_CN.js"></script>
    <script type="text/javascript" src="../../js/adminpub.js"></script>


      <script src="../../js/layer/layer.js"></script>
      <script src="../../js/layui/layui.js"></script>
     <link rel="stylesheet" href="../../js/layui/css/layui.css">


<style>

.site-title{ margin: 30px 0 20px;}
.site-title fieldset{border: none; padding: 0; border-top: 1px solid #eee;}
.site-title fieldset legend{margin-left: 20px;  padding: 0 10px; font-size: 22px; font-weight: 300;}
.site-content{margin-left: 30px;width:95%;}
.site-text a{color: #01AAED;}
.site-h1{margin-bottom: 20px; line-height: 60px; padding-bottom: 10px; color: #393D49; border-bottom: 1px solid #eee;  font-size: 28px; font-weight: 300;}
.site-h1 .layui-icon{position: relative; top: 5px; font-size: 50px; margin-right: 10px;}
.site-text{position:relative;}
.site-text p{margin-bottom: 10px;  line-height:22px;}
.site-text em{padding: 0 3px; font-weight: 500; font-style: italic; color: #666;}
.site-text code{margin:0 5px; padding: 3px 10px; border: 1px solid #e2e2e2; background-color: #fbfbfb; color: #666; border-radius: 2px;}

.site-demo-laytpl div span {
  display: inline-block;
  text-align: center;
  background: #101010;
  color: #fff;
}
site-demo-laytpl textarea, .site-demo-laytpl div span {
  width: 40%;
  padding: 15px;
  margin: 0 15px;
}

.site-demo-laytpl textarea, .site-demo-laytpl div span {
  width: 40%;
  padding: 0px;
  margin: 0 15px;
}

.site-demo-laytpl textarea {
  height: 300px;
  border: none;
  background-color: #3F3F3F;
  color: #E3CEAB;
  font-family: Courier New;
  resize: none;
}

</style>
</head> 
<body>

<div class="site-content">

 

    <h1 class="site-h1">API JAVA代码生成器</h1>
    <div class="site-tips site-text">
      <p>
         在Request与Response <em>设定</em> 设定模拟json数据，代码自动生成 <em>模块</em> 来完成各种交互。
      </p>
    </div>
    <blockquote class="site-text layui-elem-quote">联调测试模块：<a href="../../../../dev/json/" target="_blank">json_api</a> <span>（请注意：如果文件重名，生成失败）</span></blockquote>
    





    
    <div class="site-title">
      <fieldset><legend><a name="use">开始爽吧</a></legend></fieldset>
    </div>
    
    
    
    <div class="site-text site-block">
      <form class="layui-form" method="post" action="?ac=add">
      
      <div class="site-demo-laytpl">
        
        <div>
          <span>Request发送数据</span>
          <span>Response响应数据</span>
        </div>
      
        <textarea class="site-demo-text layui-code" name="data1">
{
   手机发送json数据
} </textarea>
       <textarea class="site-demo-text" name="data2">
{
  服务器响应代码。
} </textarea>
  </div>
      
       <div class="layui-form-item">
          <label class="layui-form-label">api请求资源路径</label>
          <div class="layui-input-block">
            <input type="text" name="apipath"  required="" lay-verify="required" placeholder="请输入资源路径，例如：app/add/device" autocomplete="on" class="layui-input">
          </div>
        </div>
      
        <div class="layui-form-item">
          <label class="layui-form-label">包名</label>
          <div class="layui-input-block">
            <input type="text" name="javapackage"  required="" lay-verify="required" placeholder="请输入包名，例如：autocode.action" autocomplete="on" class="layui-input">
          </div>
        </div>
        
          <div class="layui-form-item">
          <label class="layui-form-label">类名</label>
          <div class="layui-input-block">
            <input type="text" name="javaname" required="" lay-verify="required" placeholder="请输入java类名,例如：AutoCodeList" autocomplete="on" class="layui-input">
          </div>
        </div>
        
      <div class="layui-form-item">
          <label class="layui-form-label">数据库表名</label>
          <div class="layui-input-block">
            <input type="text" name=tables_name required="" lay-verify="required" placeholder="请输入数据库表名" autocomplete="on" class="layui-input">
          </div>
        </div>
        
       <div class="layui-form-item">
          <label class="layui-form-label">功能说明</label>
          <div class="layui-input-block">
            <input type="text" name="javaexplain" required="" lay-verify="required" placeholder="请输入本类功能模块说明,例如：代码生成" autocomplete="on" class="layui-input">
          </div>
        </div>
        
   
         <div class="layui-form-item">
          <label class="layui-form-label">workspace工程目录</label>
          <div class="layui-input-block">
            <input type="text" name="workspace" required="" lay-verify="required" placeholder="" autocomplete="on" value="<%=Sworkspace %>" class="layui-input">
          </div>
        </div>
       
       <div class="layui-form-item">
          <label class="layui-form-label">是否生成数据表</label>
          <div class="layui-input-block">
            <input type="text" name="CREATETABLE" required="" lay-verify="required" placeholder="" autocomplete="on" value="YES/NO" class="layui-input">
          </div>
        </div>  
       
        <div class="layui-form-item">
          <div class="layui-input-block">
            <button class="layui-btn" lay-submit="" lay-filter="formDemo" type="submit" >立即自动化创建</button>
            <button type="reset" class="layui-btn layui-btn-primary">重置</button>
          </div>
        </div>
      </form>
    </div>
  
</div>
 </body> 
</html>
<%
//插入常用菜单日志
int   TagMenu=db.Row("SELECT COUNT(*) as row FROM  menu_worker  WHERE sysmenuid='"+MMenuId+"' and  workerid='"+Suid+"' and  companyid="+Scompanyid);
if(TagMenu==0){
  db.executeUpdate("INSERT INTO `menu_worker`(`sysmenuid`,`workerid`,`countes`,`companyid`) VALUES ('"+MMenuId+"','"+Suid+"','1','"+Scompanyid+"');"); 
}else{
 db.executeUpdate("UPDATE  `menu_worker` SET `countes`=countes+1,`usetime`=now() WHERE  sysmenuid='"+MMenuId+"' and  workerid='"+Suid+"' and  companyid="+Scompanyid);
}
 %>
<%
//开始生成
if("add".equals(ac)){ 
String javapackage=request.getParameter("javapackage").replaceAll("\\.","\\\\").replaceAll(" ","");
String javaname=request.getParameter("javaname").replaceAll("\\.java","").replaceAll(" ","");
String javaexplain=request.getParameter("javaexplain").replaceAll(" ",""); //java类文件说明
String tables_name=request.getParameter("tables_name").replaceAll(" ",""); //表名
String apipath=request.getParameter("apipath").replaceAll(" ",""); //apipath 资源路径
String CREATETABLE=request.getParameter("CREATETABLE"); //是否创建数据表

String data1=request.getParameter("data1");
String data2=request.getParameter("data2");


String workspace=request.getParameter("workspace");//开发主目录
String templatename=request.getParameter("templatename");//模板文件名

javaname=javaname.substring(0,1).toUpperCase()+javaname.substring(1); //类名都一个字母大写

FileAc fileAc = new FileAc();

//读取模板

String javabody = fileAc.read(workspace,"\\autocode\\template\\java\\defaul.t");
 
javabody=javabody.replaceAll("#包名#",javapackage.replaceAll("\\\\","\\."));
javabody=javabody.replaceAll("#作者#",Susername);
javabody=javabody.replaceAll("#email#",Semail);
javabody=javabody.replaceAll("#创建时间#",server.getTimeA());
javabody=javabody.replaceAll("#类名#",javaname);
javabody=javabody.replaceAll("#本类功能说明#",javaexplain);


//解析Request发送数据,替换#定义json接受字段列表#------------------------data1------------------

String keyesString=GetKeyJsonString.jsonkey(data1);

String jsonkeylist="";
if(keyesString.indexOf("err")!=-1){
	out.print("<script>layer.alert('解析Request发送数据,json格式错误', {icon: 2}); layer.close();</script>");
	if(db!=null)db.close();db=null;if(server!=null)server=null;
   return; 
}
 

 for(int j=0;j<keyesString.split("#").length;j++){
    jsonkeylist=jsonkeylist+"\r\n"+"           String "+keyesString.split("#")[j]+"=\"\";";
  }


//System.out.println(keyesString);
//System.out.println(jsonkeylist);
javabody=javabody.replaceAll("#定义json接受字段列表#",jsonkeylist);

//添加json解析 #定义json解析字段列表#
jsonkeylist="";
 for(int j=0;j<keyesString.split("#").length;j++){
    jsonkeylist=jsonkeylist+"\r\n"+"						 "+keyesString.split("#")[j]+"= obj.get(\""+keyesString.split("#")[j]+"\") + \"\";";
  }
 javabody=javabody.replaceAll("#定义json解析字段列表#",jsonkeylist);
 
 
 
//解析Response响应数据,替换#定义json接受字段列表#------------------------data2---------------------------

 keyesString=GetKeyJsonString.jsonkey(data2);

 jsonkeylist="";
 if(keyesString.indexOf("err")!=-1){
 	out.print("<script>layer.alert('解析Response响应数据,json格式错误', {icon: 2}); layer.close();</script>");
 	if(db!=null)db.close();db=null;if(server!=null)server=null;
    return; 
 }

   
  for(int j=0;j<keyesString.split("#").length;j++){
     jsonkeylist=jsonkeylist+"\r\n"+"                    json.put(\""+keyesString.split("#")[j]+"\", \"\"+RS.getString(\""+keyesString.split("#")[j]+"\"));"; //获取数据代码部分
   }
  
 javabody=javabody.replaceAll("#定义得到总记录数语句#"," SELECT COUNT(*) as row FROM  `"+tables_name+"` ");
 javabody=javabody.replaceAll("#定义主查询语句#"," SELECT * FROM `"+tables_name+"`  ");
 javabody=javabody.replaceAll("#定义json.put列表#",jsonkeylist);

 //添加json解析 #定义json解析字段列表#
 jsonkeylist="";
  for(int j=0;j<keyesString.split("#").length;j++){
     jsonkeylist=jsonkeylist+"\r\n"+"						 "+keyesString.split("#")[j]+"= obj.get(\""+keyesString.split("#")[j]+"\") + \"\";";
   }
  javabody=javabody.replaceAll("#定义json解析字段列表#",jsonkeylist);

  
  //生成建表语句-------------------------------------3------------------------
  String table_sql="CREATE TABLE `"+tables_name+"` (";
         table_sql=table_sql+"\r\n `id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,";
         table_sql=table_sql+"\r\n #SQL字段集合#";
         table_sql=table_sql+"\r\n PRIMARY KEY (`id`)";
         table_sql=table_sql+"\r\n ) ENGINE=MYISAM DEFAULT CHARSET=utf8";
         jsonkeylist="";        
    for(int j=0;j<keyesString.split("#").length;j++){
             jsonkeylist=jsonkeylist+"\r\n"+"  `"+keyesString.split("#")[j]+"` VARCHAR(255) DEFAULT \'\'\'\',"; //获取数据代码部分 \'\'\'\' 多加一倍防止sql写入2个变一个 
           }
    table_sql=table_sql.replaceAll("#SQL字段集合#",jsonkeylist.replaceFirst("\r\n",""));
    // System.out.println(table_sql);
  
    //在api.java 追加映射-------------------4--------------------
    String reptxt="app";
    if(apipath.indexOf("web")!=-1){ //判断要追加的是app子块，还是web子块
    	reptxt="web";
    }
    //在api.java 追加映射-------------------4--------------------
    String replatxt="app";
    if(apipath.indexOf("web")!=-1){ //判断要追加的是app子块，还是web子块
    	reptxt="web";
    }
    //读取api.java文件
    String apijavabody = fileAc.read(workspace,"\\v1\\Api.java");
    
    //替换本接口说明
     apijavabody=apijavabody.replaceAll("#"+replatxt+"接口说明#",javaexplain+"接口，"+Susername+"创建于"+server.getTimeA());
    //在下面新增一条映射
    String javanameUpper=javaname.substring(0,1).toUpperCase()+javaname.substring(1); //大写
    String javanameLowe=javaname.substring(0,1).toLowerCase()+javaname.substring(1);//小写
    apijavabody=apijavabody.replaceAll("\\/\\/#新增一条"+replatxt+"映射#"," else if (Path.equals(\""+apipath+"\")) {\r\n			"+javanameUpper+" "+javanameLowe+"=new "+javanameUpper+"(request, response);\r\n			"+javanameLowe+".Transmit(Token, UUID, USERID,DID, Mdels, NetMode, ChannelId, RequestJson,ip, GPS,GPSLocal,AppKeyType,TimeStart);\r\n		}		\r\n		\\/\\/#"+replatxt+"接口说明#\r\n		\\/\\/#新增一条"+replatxt+"映射#");
 	 
 // 写入api.java
    String string1 = fileAc.write(workspace+"\\v1\\", "Api.java", apijavabody);
    
    

//为java新建类创建目录
fileAc.MDir(workspace+javapackage,0);

// 写入java新建类文件
String servercallback = fileAc.write(workspace+javapackage, javaname+".java", javabody);
//System.out.println(workspace+javapackage); 



//添加一条生成任务
db.executeUpdate("INSERT INTO `auto_code`(`title`,`codename`,`codepath`,`apipath`,`codetype`,`code`,`table_sql`,`workerid`,`state`,`addtime`) VALUES ('"+javaexplain+"','"+javaname+"','"+javapackage.replaceAll("\\\\","\\.")+"','"+apipath+"','java','"+data1+"#@@#"+data2+"','"+table_sql+"','"+Suid+"','1',now());");
 out.print("<script>layer.open({ title: '生成成功',content: '1>生成成功请见"+workspace.replaceAll("\\\\","\\\\\\\\")+javapackage.replaceAll("\\\\","\\\\\\\\")+javaname+".java <br> 2>主引导api.java文件中，"+apipath+"映射已经写入，请打开导入 import "+javapackage.replaceAll("\\\\","\\.")+"."+javaname+"实体类',offset: '50px'}); </script> ");
//创建数据表
if("YES".equals(CREATETABLE)){
	 table_sql=table_sql.replaceAll("\'\'\'\'","\'\'").replaceAll("\r\n"," ");
	 System.out.println(table_sql);
	 db.executeUpdate(table_sql);
}

//更新用户的工作路径workspacecookie
db.executeUpdate(" UPDATE  `user_worker` SET `workspace`='"+workspace.replaceAll("\\\\","\\\\\\\\")+"' WHERE `uid`='"+Suid+"'");
 
}//添加结束
%>
 
<%if(db!=null)db.close();db=null;if(server!=null)server=null;%>
 