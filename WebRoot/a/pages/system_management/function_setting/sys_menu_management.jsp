<%@ page trimDirectiveWhitespaces="true" %>
<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@ include file="../../cookie.jsp"%>
<% String mdepth = request.getParameter("mdepth"); //上级传来的深度
   String mid = request.getParameter("mid"); 
   String mtxt = request.getParameter("mtxt"); 
   String mdepthtxt="一级分类";
   //过滤SQL注入
   mdepth=mysqlCode(mdepth).replaceAll(" ","");
   mid=mysqlCode(mid).replaceAll(" ","");
   mtxt=mysqlCode(mtxt).replaceAll(" ","");
   if(mtxt.length()<1){//初始化顶级分类
     mdepth="1";
     mid="0";
     mtxt="顶级分类";
   }else{
     if("1".equals(mdepth)){mdepthtxt="二级分类";}
     else  if("2".equals(mdepth)){mtxt=""+mtxt+""; mdepthtxt="三级(具体模块)";}
     else{mtxt="此分类不能创建模块"; mdepthtxt="此分类不能创建模块";}
   }
 %>
<%if(ac.length()<1){ %>
<!DOCTYPE html> 
<html lang="zh_CN"> 
<head> 
    <meta charset="utf-8"> 
    <meta name="viewport" content="width=device-width, initial-scale=1"> 
    <title><%=Mokuai %></title> 
    <link href="../../css/base.css" rel="stylesheet">
    <link rel="stylesheet" href="../../../custom/easyui/easyui.css">
    <link href="../../css/basic_info.css" rel="stylesheet">
     <link href="../../css/highlight.min.css" rel="stylesheet">
     <script type="text/javascript" src="../../js/highlight.min.js"></script>
      <style type="text/css">
    	#left-tree{height:500px;overflow:hidden;}
    	.easyui-tabs1{height:520px;overflow:hidden;border:#bfbfbf 1px solid;padding:0 10px;}
    	#wrapper{height:500px;overflow:scroll;}
    </style>
</head> 
<body>
	<div class="container">
		<div class="left-tree" id="left-tree">
			<div id="wrapper">			
			<%=Mokuai %>载入中...
			 	
		 </div>
		</div>
		<div class="content">
			<div class="easyui-tabs1" style="width:100%;">
		      <div title="功能模块添加" data-options="closable:false" class="basic-info">
	                <input type="hidden" id="mid" value="<%=mid %>"/>
					<input type="hidden" id="mdepth" value="<%=mdepth %>"/>
				<div class="column"><span class="current">请点击左侧菜单第三级添加新的功能模块</span></div>
		      	<table class="kv-table">
  <tbody>
  
    <tr>
      <td class="kv-label">模块动作链接（.jsp）</td>
      <td colspan="2" class="kv-content"><input name="text" type="text" class="textbox-text validatebox-text textbox-prompt"  id="menulink" style="margin-left: 0px; margin-right: 0px; padding-top: 0px; padding-bottom: 0px; height: 33px; line-height: 33px; width: 280px;" autocomplete="on" placeholder="xxx_xxx_xxx" /></td>
      <td class="kv-content" colspan="3">&nbsp;</td>
    </tr>
     <tr>
      <td class="kv-label">模块Api</td>
      <td colspan="2" class="kv-content"><input name="text" type="text" class="textbox-text validatebox-text textbox-prompt"  id="apiurl" style="margin-left: 0px; margin-right: 0px; padding-top: 0px; padding-bottom: 0px; height: 33px; line-height: 33px; width: 280px;" autocomplete="on" placeholder="xxx_xxx_xxx" /></td>
      <td class="kv-content" colspan="3">&nbsp;</td>
    </tr>
    <tr>
      <td class="kv-label">模块中文名</td>
      <td class="kv-content"><input name="text2" type="text" class="textbox-text validatebox-text textbox-prompt"  id="menuname" style="margin-left: 0px; margin-right: 0px; padding-top: 0px; padding-bottom: 0px; height: 33px; line-height: 33px; width: 150px;" autocomplete="off" placeholder="" /></td>
      <td class="kv-label">功能图标</td>
      <td class="kv-content" colspan="3"><input name="text2" style="float:left" onclick="icon_fun()" type="text" class="textbox-text validatebox-text textbox-prompt"  id="ico" style="margin-left: 0px; margin-right: 0px; padding-top: 0px; padding-bottom: 0px; height: 33px; line-height: 33px; width: 150px;" value="" autocomplete="off" placeholder="" />
          <a class="iconfont" style="cursor:pointer;display:block;float:left;width:10px;height:10px; " onclick="icon_fun()" id=“icondj”>&#xe623;</a></td>
    </tr>
    <tr>
      <td class="kv-label">是否左侧显示</td>
      <td class="kv-content"><select name="leftshow" class="easyui-combobox combobox-f combo-f textbox-f" id="leftshow" style="height: 35px; width: 166px; display: none;" textboxname="language" comboname="language">
        <option value="1">显示</option>
        <option value="0">隐藏</option>
      </select></td>
      <td class="kv-label">是否显示</td>
      <td class="kv-content" colspan="3"><select name="showstate" class="easyui-combobox combobox-f combo-f textbox-f" id="showstate" style="height: 35px; width: 166px; display: none;" textboxname="language" comboname="language">
        <option value="1">显示</option>
        <option value="0">隐藏</option>
      </select></td>
    </tr>
    <tr>
      <td class="kv-label">所属分类</td>
      <td class="kv-content"><select name="select"  disabled="disabled" class="easyui-combobox combobox-f combo-f textbox-f" style="height: 35px; width: 166px; display: none;" textboxname="language" comboname="language" >
        <div id="ssfl">
        </div>
        <option><%=mtxt %></option>
      </select></td>
      <td class="kv-label">分类深度</td>
      <td class="kv-content" colspan="3"><select name="select"  disabled="disabled" class="easyui-combobox combobox-f combo-f textbox-f" style="height: 35px; width: 166px; display: none;" textboxname="language" comboname="language">
        <option><%=mdepthtxt %></option>
      </select></td>
    </tr>
  </tbody>
</table>
					<div align="center">
					<a href="javascript:chongzhi();" class="easyui-linkbutton l-btn l-btn-small l-btn-selected" data-options="selected:false" group="" id=""><span class="l-btn-left"><span class="l-btn-text" >重置页面</span></span></a>
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					<a href="javascript:addfile();" class="easyui-linkbutton l-btn l-btn-small l-btn-selected" data-options="selected:true" group="" id=""><span class="l-btn-left"><span class="l-btn-text" >新增功能模块</span></span></a>
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					
					</div>
             <%for(int a=1;a<35;a++){ out.print("<br>"); } %>
		      </div>
		      
		        <div title="查看该模块代码" data-options="closable:false" class="basic-info">	      
		      	
		      	<div class="column"><span class="current">请编辑该文件</span></div>
    <%String editmenuname3="";
       ResultSet Rs0=db.executeQuery("SELECT id,menuname,ico FROM  `menu_sys`  where depth=3 and showstate=1 and id="+mid);  
       if(Rs0.next()){    
         editmenuname3=Rs0.getString("menuname"); 
       }  if(Rs0!=null)Rs0.close(); 
      %>      	
<p><%=editmenuname3 %>.jsp代码：</p>
<pre><code class="javascript">
//numbering for pre&gt;code blocks
$(function(){
    $('pre code').each(function(){
        var lines = $(this).text().split('\n').length - 1;
        var $numbering = $('&lt;ul/&gt;').addClass('pre-numbering');
        $(this)
            .addClass('has-numbering')
            .parent()
            .append($numbering);
        for(i=1;i&lt;=lines;i++){
            $numbering.append($('&lt;li/&gt;').text(i));
        }
    });
});
</code></pre>
       </div>
		      		      
		      <div title="功能模块编辑" data-options="closable:false" class="basic-info">
		      
		      	<div class="column"><span class="current">请编辑该该模块</span></div>
		      	<table class="kv-table">
					<tbody>
						<tr>
							<td class="kv-label">公司电话</td>
							<td class="kv-content">010-11111111</td>
							<td class="kv-label">传真</td>
							<td class="kv-content">010-11111111</td>
							<td class="kv-label">公司网站</td>
							<td class="kv-content">www.baidu.com</td>
						</tr>
						<tr>
							<td class="kv-label">联系人</td>
							<td class="kv-content">先生</td>
							<td class="kv-label">联系手机</td>
							<td class="kv-content">13666666666</td>
							<td class="kv-label">联系人邮箱</td>
							<td class="kv-content">1234@qq.com</td>
						</tr>
					</tbody>
				</table>
		      
		      </div>
		     
		    </div>
		</div>
	</div>
</body> 
</html>
    <script type="text/javascript" src="../../../custom/jquery.min.js"></script>
    <script type="text/javascript" src="../../../custom/jquery.easyui.min.js"></script>
    <script type="text/javascript" src="../../js/pub.js"></script>
    <script type="text/javascript" src="../../js/layer/layer.js"></script>
<script type="text/javascript">
   	  
    $('.easyui-tabs1').tabs({ 
      tabHeight: 36
    });
    $(window).resize(function(){
    	$('.easyui-tabs1').tabs("resize");
    }).resize();
    
 function show_left_tree(){
   
   $("#left-tree #wrapper").html("数据获取中...");
   
   var AppId="<%=AppId_web%>";
   var AppKey="<%=AppKey_web%>";
   var token="<%=Spc_token%>";
   var strvalue="{\"ac\":\"show_left_tree\"}";
   var datapc =PostpcApi("sys_menu_management.jsp?ac=show_left_tree",AppId,AppKey,token,strvalue);
   
     $("#left-tree #wrapper").fadeIn();
     $("#left-tree #wrapper").html(datapc);
  }
  function fuzhi(mdepth,mid,mtxt){ //点击左侧赋值到右面页面
   $("#ssfl").html(mtxt);
   //alert(mdepth);
   //alert(mid);
  // alert(mtxt);
  if(mdepth==2){
    location.href="sys_menu_management.jsp?mdepth="+mdepth+"&mid="+mid+"&mtxt="+mtxt;
   }
  }
 
  show_left_tree();//初始化 
  
    $(".easyui-tree").tree({  
          onClick:function(node){  
         
               var mtxt=node.text;
               var mdepth=node.id.split("#")[0];
               var mid=node.id.split("#")[1];
               fuzhi(mdepth,mid,mtxt);
              
            }  
      }); 

   function chongzhi(){ //重置页面
    location.href="sys_menu_management.jsp";
   }
  
  function addfile(){//添加数据
    var  menuname=document.getElementById("menuname").value;
    var  ico=document.getElementById("ico").value;
    var  mid=document.getElementById("mid").value;
    var  mdepth=document.getElementById("mdepth").value;
    var  menulink=document.getElementById("menulink").value;
    var  apiurl=document.getElementById("apiurl").value;
    var  leftshow=document.getElementById("leftshow").value;
    var  showstate=document.getElementById("showstate").value;
   // alert(menuname+ico+"mid="+mid+"mdepth="+mdepth);
     location.href="sys_menu_management.jsp?ac=addfile&pmenuname="+menuname+"&pmid="+mid+"&pmdepth="+mdepth+"&pmenulink="+menulink+"&papiurl="+apiurl+"&leftshow="+leftshow+"&showstate="+showstate+"&pico="+ico+"";
   }
  
  function icon_fun(){
	  
	     layer.open({
	    	  title: '功能图标地址'
	    	  ,type: 2
	    	  ,area: ['380px', '330px']
	    	  ,content:'../../syst/icon_copy.jsp'
	       });
	  }
</script>
<%}//默认页面%>
<%
//动态获取分类页面
if("show_left_tree".equals(ac)){

      //一级分类   
      String menuname1="", menuico1="", menuid1="",menuid2="";
      ResultSet Rs2=null;ResultSet Rs3=null;
      ResultSet Rs1=db.executeQuery("SELECT id,menuname,ico FROM  `menu_sys`  where depth=1 and showstate=1 and showstate=1 ORDER  by Sortid asc");  
      while(Rs1.next()){    
      menuname1=Rs1.getString("menuname");
	  menuico1=Rs1.getString("ico");
	  menuid1=Rs1.getString("id");
	%>     <ul class="easyui-tree">
				<li id="1#<%=menuid1 %>" data-options="state:'closed'">
					<span><%=menuname1 %></span>
					<ul>
				<% //二级分类
				Rs2=db.executeQuery("SELECT id,menuname,ico FROM  `menu_sys`  where depth=2   and showstate=1 and fatherid="+menuid1+"  ORDER  by Sortid asc");  
                   while(Rs2.next()){   menuid2=Rs2.getString("id");%>		
						<li  id="2#<%=menuid2%>"  data-options="state:'closed'">
							<span><%=Rs2.getString("menuname")%></span>
							<ul>
							<% //二级分类
				              Rs3=db.executeQuery("SELECT id,menuname,ico FROM  `menu_sys`  where depth=3  and fatherid="+menuid2+"  ORDER  by Sortid asc");  
                                while(Rs3.next()){  %>	
								<li  id="3#<%=Rs3.getString("id") %>"><%=Rs3.getString("menuname")%></li><%} //RS3 END%>
							</ul>
						</li><%} //RS2 END%>				 
					</ul>
				</li>
	  </ul>
	  <!-- 顶级分割线 -->
	 <%   } if(Rs1!=null)Rs1.close();   if(Rs2!=null)Rs1.close();  if(Rs3!=null)Rs1.close(); 
 }//动态获取分类结束
 %>
 <%//添加一个程序文件
if("addfile".equals(ac)){
 String pmenuname = request.getParameter("pmenuname"); 
 String pmdepth = request.getParameter("pmdepth"); 
 String pmid = request.getParameter("pmid"); 
 String pmenulink = request.getParameter("pmenulink"); 
 String papiurl= request.getParameter("papiurl");
 String pleftshow= request.getParameter("leftshow");
 String pshowstate= request.getParameter("showstate");
 String pico = "";
  pmdepth="3"; 
  
 if(pico==null){pico="&#xe623;";} 
 if(papiurl==null){papiurl="";} 
 pmenuname=mysqlCode(pmenuname);
 System.out.println("pmenuname="+pmenuname);
 System.out.println("pmdepth="+pmdepth);
  System.out.println("pmid="+pmid);
   db.executeUpdate("insert into `menu_sys` (`menuname`, `ico`, `Sortid`, `fatherid`, `depth`, `menulink`, `apiurl`,`menutxt`,`helpinfo`, `leftshow`, `showstate`, `state`) values('"+pmenuname+"','"+pico+"','1','"+pmid+"','"+pmdepth+"','"+pmenulink+"','"+papiurl+"','"+pmenuname+"','"+pmenuname+"帮助页面','"+pleftshow+"','"+pshowstate+"','1');"); 
   //out.print("<script language=\"JavaScript\">\r\n <!--\r\n alert(\"添加成功\"); \r\n location.href='sys_menu_management.jsp'; \r\n// -->\r\n  </script>");
}%>

<%
//插入常用菜单日志
int   TagMenu=db.Row("SELECT COUNT(*) as row FROM  menu_worker  WHERE sysmenuid='"+PMenuId+"' and  workerid='"+Suid+"' and  companyid="+Scompanyid);
if(TagMenu==0){
  db.executeUpdate("INSERT INTO `menu_worker`(`sysmenuid`,`workerid`,`countes`,`companyid`) VALUES ('"+PMenuId+"','"+Suid+"','1','"+Scompanyid+"');"); 
}else{
 db.executeUpdate("UPDATE  `menu_worker` SET `countes`=countes+1,`usetime`=now() WHERE  sysmenuid='"+PMenuId+"' and  workerid='"+Suid+"' and  companyid="+Scompanyid);
}
 %>
<% 
if(db!=null)db.close();db=null;if(server!=null)server=null;%>