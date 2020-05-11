<%@ page trimDirectiveWhitespaces="true" %>
<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<% String MMenuId="39"; //功能分类管理模块编号%>
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
     else  if("2".equals(mdepth)){mtxt="与 "+mtxt+" 同级"; mdepthtxt="二级分类";}
     else{mtxt="功能模块下不能分类"; mdepthtxt="功能模块下不能分类";}
   }
   
 %>
<%if(ac.length()<1){ %>
<!DOCTYPE html> 
<html lang="zh_CN"> 
<head> 
    <meta charset="utf-8"> 
    <meta name="viewport" content="width=device-width, initial-scale=1"> 
    <title>基本信息</title> 
    <link href="../../css/base.css" rel="stylesheet">
    <link rel="stylesheet" href="../../../custom/easyui/easyui.css">
    <link href="../../css/basic_info.css" rel="stylesheet">
     <script type="text/javascript" src="../../../custom/jquery.min.js"></script>
    <script type="text/javascript" src="../../../custom/jquery.easyui.min.js"></script>
    <script type="text/javascript" src="../../js/pub.js"></script>
    <style type="text/css">
    	#left-tree{height:500px;overflow:hidden;}
    	.easyui-tabs1{height:520px;overflow:hidden;border:#bfbfbf 1px solid;padding:0 10px;}
    	#wrapper{height:500px;overflow:scroll;}
    	
    </style>
</head> 
<body>
	<div class="container" >
	  
	<div class="left-tree" id="left-tree">
	<div id="wrapper">	
			分类载入中...		
		 </div>
		</div>
		<div class="content" >
			<div class="easyui-tabs1" style="width:100%;">
		      <div title="分类添加" data-options="closable:false" class="basic-info">

				<div class="column"><span class="current">请点击左侧菜单添加新的分类，如果顶级分类可不用点击选择</span></div>
		      	<table class="kv-table">
					<tbody>
					<input type="hidden" id="mid" value="<%=mid %>"/>
					<input type="hidden" id="mdepth" value="<%=mdepth %>"/>
					
						<tr>
							<td class="kv-label">功能分类名</td>
							<td class="kv-content"><input type="text"  id="menuname" class="textbox-text validatebox-text textbox-prompt" autocomplete="off" placeholder="" style="margin-left: 0px; margin-right: 0px; padding-top: 0px; padding-bottom: 0px; height: 33px; line-height: 33px; width: 150px;"></td>
							<td class="kv-label">功能图标</td>
							<td class="kv-content" colspan="3"><input  id="ico" type="text" class="textbox-text validatebox-text textbox-prompt" autocomplete="off" placeholder="" style="margin-left: 0px; margin-right: 0px; padding-top: 0px; padding-bottom: 0px; height: 33px; line-height: 33px; width: 150px;" onclick="icon_fun()" value=""><span onclick="icon_fun()" class="iconfont">&#xe623;</span></td>
						</tr>
						<tr>
							<td class="kv-label">是否左侧显示</td>
							<td class="kv-content"><select id="leftshow" class="easyui-combobox combobox-f combo-f textbox-f" style="height: 35px; width: 166px; display: none;" textboxname="language" comboname="language"><option>显示</option><option>隐藏</option></select></td>
							<td class="kv-label">是否显示</td>
							<td class="kv-content" colspan="3"><select id="showstate" class="easyui-combobox combobox-f combo-f textbox-f" style="height: 35px; width: 166px; display: none;" textboxname="language" comboname="language"><option>显示</option><option>隐藏</option></select></td>
						</tr>
						<tr>
							<td class="kv-label">所属分类</td>
							<td class="kv-content"><select  disabled="disabled" class="easyui-combobox combobox-f combo-f textbox-f" style="height: 35px; width: 166px; display: none;" textboxname="language" comboname="language" ><div id="ssfl"></div><option><%=mtxt %></option></select></td>
							<td class="kv-label">分类深度</td>
							<td class="kv-content" colspan="3"><select  disabled="disabled" class="easyui-combobox combobox-f combo-f textbox-f" style="height: 35px; width: 166px; display: none;" textboxname="language" comboname="language"><option><%=mdepthtxt %></option></select></td>
						</tr>
					</tbody>
					
				
				</table>
					<div align="center">
					<a href="javascript:chongzhi();" class="easyui-linkbutton l-btn l-btn-small l-btn-selected" data-options="selected:false" group="" id=""><span class="l-btn-left"><span class="l-btn-text" >重置页面</span></span></a>
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					<a href="javascript:addfenlei();" class="easyui-linkbutton l-btn l-btn-small l-btn-selected" data-options="selected:true" group="" id=""><span class="l-btn-left"><span class="l-btn-text" >新增功能分类</span></span></a>
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					
					</div>					
			 
             <%for(int a=1;a<35;a++){ out.print("<br>"); } %>
		      </div>
		      <div title="分类编辑" data-options="closable:false" class="basic-info">
		      
		      	<div class="column"><span class="current">请编辑该分类</span></div>
		      	<table class="kv-table">
					<tbody>
						<tr>
							<td class="kv-label">公司电话</td>
							<td class="kv-content">0512-69168010</td>
							<td class="kv-label">传真</td>
							<td class="kv-content">0512-69168010</td>
							<td class="kv-label">公司网站</td>
							<td class="kv-content">www.szlf.com</td>
						</tr>
						<tr>
							<td class="kv-label">联系人</td>
							<td class="kv-content">左江胜</td>
							<td class="kv-label">联系手机</td>
							<td class="kv-content">15158966547</td>
							<td class="kv-label">联系人邮箱</td>
							<td class="kv-content">zhs88@szlf.com</td>
						</tr>
					</tbody>
				</table>
		      </div>
		    </div>
		</div>
	</div>
	
</body> 
</html>
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
   var datapc =PostpcApi("sys_functional_class.jsp?ac=show_left_tree",AppId,AppKey,token,strvalue);
   
     $("#left-tree #wrapper").fadeIn();
     $("#left-tree #wrapper").html(datapc);
  }
  function fuzhi(mdepth,mid,mtxt){ //点击左侧赋值到右面页面
   $("#ssfl").html(mtxt);
  // alert(mdepth);
   //alert(mid);
  // alert(mtxt);
  if(mdepth==1){
    location.href="sys_functional_class.jsp?mdepth="+mdepth+"&mid="+mid+"&mtxt="+mtxt;
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
    location.href="sys_functional_class.jsp";
   }
  
  function addfenlei(){//添加数据
    var  menuname=document.getElementById("menuname").value;
    var  ico=document.getElementById("ico").value;
    var  mid=document.getElementById("mid").value;
    var  mdepth=document.getElementById("mdepth").value;
    
   // alert(menuname+ico+"mid="+mid+"mdepth="+mdepth);
     location.href="sys_functional_class.jsp?ac=addfenlei&pmenuname="+menuname+"&pmid="+mid+"&pmdepth="+mdepth+"&pico="+ico;
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
      ResultSet Rs1=db.executeQuery("SELECT id,menuname,ico FROM  `menu_sys`   where depth=1  and showstate=1  ORDER  by Sortid asc");  
      while(Rs1.next()){    
      menuname1=Rs1.getString("menuname");
	  menuico1=Rs1.getString("ico");
	  menuid1=Rs1.getString("id");
	%>     <ul class="easyui-tree">
				<li id="1#<%=menuid1 %>" data-options="state:'closed'">
					<span><%=menuname1 %></span>
					<ul>
				<% //二级分类
				Rs2=db.executeQuery("SELECT id,menuname,ico FROM  `menu_sys`  where depth=2  and showstate=1 and fatherid="+menuid1+"  ORDER  by Sortid asc");  
                   while(Rs2.next()){   menuid2=Rs2.getString("id");%>		
						<li  id="2#<%=menuid2%>"  data-options="state:'closed'">
							<span><%=Rs2.getString("menuname")%></span>
							<ul>
							<% //二级分类
				              Rs3=db.executeQuery("SELECT id,menuname,ico FROM  `menu_sys`  where depth=3   and showstate=1 and fatherid="+menuid2+"  ORDER  by Sortid asc");  
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
 <%//添加分类
if("addfenlei".equals(ac)){
 String pmenuname = request.getParameter("pmenuname"); 
 String pmdepth = request.getParameter("pmdepth"); 
 String pmid = request.getParameter("pmid"); 
 String pico = "";
 if("1".equals(pmdepth) && !"0".equals(pmid) ){ pmdepth="2";  }
 if(pico==null){pico="&#xe623;";} 
 pmenuname=mysqlCode(pmenuname);
 System.out.println("pmenuname="+pmenuname);
 System.out.println("pmdepth="+pmdepth);
  System.out.println("pmid="+pmid);
   db.executeUpdate("insert into `menu_sys` (`menuname`, `ico`, `Sortid`, `fatherid`, `depth`, `menulink`, `menutxt`, `leftshow`, `showstate`, `state`) values('"+pmenuname+"','"+pico+"','1','"+pmid+"','"+pmdepth+"','#','','1','1','1');"); 
 out.print("<script language=\"JavaScript\">\r\n <!--\r\n alert(\"添加成功\"); \r\n location.href='sys_functional_class.jsp'; \r\n// -->\r\n  </script>");
 
}%>
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
if(db!=null)db.close();db=null;if(server!=null)server=null;%>