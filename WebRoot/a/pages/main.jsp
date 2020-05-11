<%@ page trimDirectiveWhitespaces="true" %>
<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@ include file="cookie.jsp"%>
<%@page import="org.apache.commons.lang3.StringUtils"%>
<!DOCTYPE html> 
<html lang="zh_CN"> 
<head> 

    <meta charset="utf-8"> 
    <meta name="viewport" content="width=device-width, initial-scale=1"> 
    <title><%=Scompanyname %>@<%=SYSname %></title> 
	<link href="css/base.css" rel="stylesheet">
	<link href="css/platform.css" rel="stylesheet">
	<link rel="stylesheet" href="../custom/easyui/easyui.css">
	<script type="text/javascript" src="../custom/jquery.min.js"></script>
	<script src="js/layer/layer.js"></script>
	<style>
	.menu-text{padding-left:8px;}
	.window-mask{position:absolute;left:0;top:0;width:100%;height:100%;filter:alpha(opacity=0);opacity:0;font-size:1px;*zoom:1;overflow:hidden;}
	</style>

</head> 
<body>
    <div class="container">
        <div id="pf-hd">
            <div class="pf-logo">
               <a href="javascript:showlefmenu_my();"> <img src="images/main/login_logo.png" alt="logo"></a>
            </div>
            <div class="pf-nav-wrap">
              <div class="pf-nav-ww ">
                <ul class="pf-nav">
	                  <li class="pf-nav-item project" data-menu="org-manage">
	                      <a href="javascript:showlefmenu_my();">
	                          <span class="iconfont">&#xe671;</span>
	                          <span class="pf-nav-title">我的首页</span>
	                      </a>
	                  </li>
				      <%
				      //用户主菜单     
				      String menuname="", menuico="", menuid="";
				     
				      String roleSql = "select sys_role_id from zk_user_role t where t.sys_user_id="+Suid;
				      ResultSet roleSet = db.executeQuery(roleSql);
				      TreeSet<String> tset = new TreeSet<String>();
				      while(roleSet.next()){
				    	  String menuIdSql = "SELECT  REPLACE (REPLACE ( menu_sys_id, '#', ',' ),',0,','0,') menuids FROM zk_role  WHERE id= "+roleSet.getString("sys_role_id");
				    	  ResultSet menuSet = db.executeQuery(menuIdSql);
				    	  while(menuSet.next()){
				    		  String[] menuids = menuSet.getString("menuids").substring(1).split(",");
				    		  for (String string : menuids) {
				    			  if(StringUtils.isNotBlank(menuids+"")){
				    					tset.add(string);
				    				}
				    			}
				    	  }
				      }
				      Iterator<String> iter = tset.iterator();  
						StringBuffer c = new StringBuffer();
						while(iter.hasNext()){  
							c.append(iter.next()+",");
						} 
						
				      //ResultSet Rs=db.executeQuery("SELECT id,menuname,ico FROM  `menu_sys`  WHERE FIND_IN_SET(id,(SELECT  REPLACE (REPLACE ( menu_sys_id, '#', ',' ),',0,','0,')FROM zk_role  WHERE id='"+Sroleid+"')) AND depth=1 AND showstate=1 AND leftshow=1   ORDER  by Sortid asc");  
				      ResultSet Rs=db.executeQuery("SELECT id,menuname,ico FROM  `menu_sys`  WHERE id in ("+c.substring(0,c.toString().length()-1)+") AND depth=1 AND showstate=1 AND leftshow=1   ORDER  by Sortid asc");  
				      while(Rs.next()){    
					      menuname=Rs.getString("menuname");
						  menuico=Rs.getString("ico");
						  menuid=Rs.getString("id");
					 %>
	                 <li class="pf-nav-item project" data-menu="org-manage">
	                      <a href="javascript:showlefmenu(<%=menuid %>);">
	                          <span class="iconfont"><%=menuico %></span>
	                          <span class="pf-nav-title"><%=menuname %></span>
	                      </a>
	                  </li>
	     			<%} if(Rs!=null)Rs.close(); %>   
            	</ul>
             </div>
             <a href="javascript:;" class="pf-nav-prev disabled iconfont">&#xe606;</a>
             <a href="javascript:;" class="pf-nav-next iconfont">&#xe607;</a>
          </div>
		  <style>
			#round {
			    padding:1px; width:40px; height:40px;
			    border: 1px solid #dedede;
			    -moz-border-radius: 15px;      
			    -webkit-border-radius: 15px;   
			    border-radius:40px;           
				}
		  </style>
          <div class="pf-user">
				 <div class="pf-user-photo">
					<%if(Sheadimgurl.length()>5){ %>
						<img id="round" src="<%=Sheadimgurl %>" alt="" style="margin-left: 0.1rem;">
					<%}else{ %>
					    <img src="images/main/user.png"  alt="默认头像，请上传自己的头像">
					<%}%>   
				  </div>
		          <h4 class="pf-user-name ellipsis"><%=Susername %>@<%=Scompanyname %></h4>
		          <i class="iconfont xiala">&#xe607;</i>
				  <div class="pf-user-panel">
		                <ul class="pf-user-opt">
		                    <li>
		                        <a href="javascript:;" onclick="addTab('我的信息','user_infos.jsp')">
		                            <i class="iconfont">&#xe60d;</i>
		                            <span class="pf-opt-name">用户信息</span>
		                        </a>
		                    </li>
		                    <li class="pf-modify-pwd">
		                        <a href="javascript:;" onclick="addTab('修改密码','modify_pwd.jsp')">
		                            <i class="iconfont">&#xe634;</i>
		                            <span class="pf-opt-name">修改密码</span>
		                        </a>
		                    </li>
		                    <li class="pf-logout">
		                        <a href="index.jsp?msg=安全退出">
		                            <i class="iconfont">&#xe60e;</i>
		                            <span class="pf-opt-name">退出</span>
		                        </a>
		                    </li>
		                </ul>
		          </div>
   		  </div>
       </div>
       <div id="pf-bd">
            <div id="pf-sider">
                <h2 class="pf-model-name">
                    <span class="iconfont">&#xe64a;</span>
                    <span class="pf-name">我的首页</span>
                    <span class="toggle-icon"></span>
                </h2>
                <ul class="sider-nav">
                     <li class="current">
                        <a href="javascript:;" >
                            <span class="iconfont sider-nav-icon">&#xe620;</span>
                            <span class="sider-nav-title">数据加载中...</span>
                            <i class="iconfont">&#xe642;</i>
                        </a>
                        <ul class="sider-nav-s">
                           <li class="active"><a href="javascript:;">数据加载中...</a></li>
                         </ul>
                     </li>
                 </ul> 
            </div>
            <div id="pf-page">
                <div class="easyui-tabs1" id="add" style="width:100%;height:100%;">
                  <div title="首页" style="padding:10px 5px 5px 10px;">
                    <iframe class="page-iframe" src="workbench.jsp" frameborder="no"   border="no" height="100%" width="100%" scrolling="auto"></iframe>
                  </div>
                </div>
            </div>
        </div>
        <div id="pf-ft">
            <div class="system-name">
              <i class="iconfont">&#xe6fe;</i>
              <span><%=SYSname %>&nbsp;v1.0</span>
            </div>
            <div class="copyright-name">
              <span>CopyRight&nbsp;2017&nbsp;&nbsp;haocheok.com&nbsp;版权所有</span>
              <i class="iconfont" >&#xe6ff;</i>
            </div>
        </div>
    </div>
<div id="mm" class="easyui-menu" style="width:120px;">
    <div id="mm-tabclosrefresh" data-options="name:6">刷新</div>
    <div id="mm-tabclose" data-options="name:1">关闭</div>
    <div id="mm-tabcloseall" data-options="name:2">全部关闭</div>
    <div id="mm-tabcloseother" data-options="name:3">关闭其他</div>
    <div class="menu-sep"></div>
    <div id="mm-tabcloseright" data-options="name:4">关闭右侧全部标签</div>
    <div id="mm-tabcloseleft" data-options="name:5">关闭左侧全部标签</div>
</div>
	
	<script type="text/javascript" src="../custom/jquery.easyui.min.js"></script>
    <script type="text/javascript" src="js/main.js"></script>
    <script type="text/javascript"><!--
    
    //删除Tabs
    
    function closeTab(menu, type) {
        var allTabs = $(".easyui-tabs1").tabs('tabs');
        var allTabtitle = [];
        $.each(allTabs, function (i, n) {
            var opt = $(n).panel('options');
            if (opt.closable)
                allTabtitle.push(opt.title);
        });
        var curTabTitle = $(menu).data("tabTitle");
        var curTabIndex = $(".easyui-tabs1").tabs("getTabIndex", $(".easyui-tabs1").tabs("getTab", curTabTitle));
        switch (type) {
            case 1:
                $(".easyui-tabs1").tabs("close", curTabIndex);
                return false;
                break;
            case 2:
                for (var i = 0; i < allTabtitle.length; i++) {
                    $('.easyui-tabs1').tabs('close', allTabtitle[i]);
                }
                break;
            case 3:
                for (var i = 0; i < allTabtitle.length; i++) {
                    if (curTabTitle != allTabtitle[i])
                        $('.easyui-tabs1').tabs('close', allTabtitle[i]);
                }
                $('.easyui-tabs1').tabs('select', curTabTitle);
                break;
            case 4:
                for (var i = curTabIndex; i < allTabtitle.length; i++) {
                    $('.easyui-tabs1').tabs('close', allTabtitle[i]);
                }
                $('.easyui-tabs1').tabs('select', curTabTitle);
                break;
            case 5:
                for (var i = 0; i < curTabIndex-1; i++) {
                    $('.easyui-tabs1').tabs('close', allTabtitle[i]);
                }
                $('.easyui-tabs1').tabs('select', curTabTitle);
                break;
           
        }
    }
    $("#mm-tabclosrefresh").click(function(){
   		 var currentTab = $('.easyui-tabs1').tabs('getSelected');
		  RefreshTab(currentTab);
    })
      function RefreshTab(currentTab) {
          var url = $(currentTab.panel('options')).attr('href');
          $('.easyui-tabs1').tabs('update', {
              tab: currentTab,
              options: {
                 href: url
              }
          });
         currentTab.panel('refresh');
   }

    $(".easyui-tabs1").tabs({
	   	onBeforeClose:function(title,index){
			var target = this;
			 $.messager.defaults = { ok: "是", cancel: "取消" };  
			$.messager.confirm({
			    width: 280,
			    height: 160, 
			    title: '操作确认',
			    msg: '您确定要关闭<b style="color:#ea130e;">'+title+'</b>吗？</br></br>未提交的表单数据将会丢失！',
			    fn: function (r) {
					if (r){
						var opts = $(target).tabs('options');
						var bc = opts.onBeforeClose;
						opts.onBeforeClose = function(){};  // allowed to close now
						$(target).tabs('close',index);
						opts.onBeforeClose = bc;  // restore the event function
					}
			    }
			});
			return false;
	   	}
   })
    
	    $(function(){
			 $('.easyui-tabs1').tabs({
            onContextMenu: function (e, title, index) {
                e.preventDefault();
                if (index > 0) {
                    $('#mm').menu('show', {
                        left: e.pageX,
                        top: e.pageY
                    }).data("tabTitle", title);
                }
            }
	        });
	        //右键菜单click
	        $("#mm").menu({
	            onClick: function (item) {
	                closeTab(this, item.name);
	            }
	        });
		});
		
		
	    function addTab(title, url){
	       if ($('.easyui-tabs1').tabs('exists', title)){
	             $('.easyui-tabs1').tabs('select', title);
	       }else{
	           	 var content = '<iframe scrolling="auto" frameborder="0"  src="'+url+'" style="width:100%;height:100%;"></iframe>';
		         $('.easyui-tabs1').tabs('add',{
			         title:title,
			         content:content,
			         closable:true
	       		 });
	      } 
	    }
		$(".sider-nav-s li").click(function(){
		  $(this).addClass("active").siblings("li").removeClass("active")
		})
	    $('.easyui-tabs1').tabs({
	      tabHeight: 44,
	      onSelect:function(title,index){
	        var currentTab = $('.easyui-tabs1').tabs("getSelected");
	        if(currentTab.find("iframe") && currentTab.find("iframe").size()){
	          //  currentTab.find("iframe").attr("src",currentTab.find("iframe").attr("src"));
	        	   /**/
		          if(title=='首页'){
		                // alert("首页刷新");
			        	$('.easyui-tabs1').tabs('update',{
			        	tab:currentTab,
			        	options : {
			        	   content : '<iframe scrolling="auto" frameborder="0" src="workbench.jsp" style="width:100%;height:100%;"></iframe>'
			        	}
			        	});
				    }
		          /**/  
	        }
	      }
	    })
	    $(window).resize(function(){
	          $('.tabs-panels').height($("#pf-page").height()-46);
	          $('.panel-body').height($("#pf-page").height()-76)
	    }).resize();
	    var page = 0,
	        pages = ($('.pf-nav').height() / 70) - 1;
	    if(pages === 0){
	      $('.pf-nav-prev,.pf-nav-next').hide();
	    }
	    $(document).on('click', '.pf-nav-prev,.pf-nav-next', function(){
	      if($(this).hasClass('disabled')) return;
	      if($(this).hasClass('pf-nav-next')){
	        page++;
	        $('.pf-nav').stop().animate({'margin-top': -70*page}, 200);
	        if(page == pages){
	          $(this).addClass('disabled');
	          $('.pf-nav-prev').removeClass('disabled');
	        }else{
	          $('.pf-nav-prev').removeClass('disabled');
	        }
	        
	      }else{
	        page--;
	        $('.pf-nav').stop().animate({'margin-top': -70*page}, 200);
	        if(page == 0){
	          $(this).addClass('disabled');
	          $('.pf-nav-next').removeClass('disabled');
	        }else{
	          $('.pf-nav-next').removeClass('disabled');
	        }
	        
	      }
	    })
    
	    function showlefmenu(id){
		    $("#pf-sider").fadeOut();
		    $("#pf-sider").html("数据获取中...");
		    var AppId="d42b46df6e583ca9a1b3e819dc42cfak";
		    var AppKey="23548ad081d91ca0bdc66b22ca59cfc6";
		    var token="main";
		    var strvalue="{\"menuid\":\""+id+"\"}";
		    var datapc =PostpcApi("lefmenu_ac.jsp?id="+id,AppId,AppKey,token,strvalue);
		    $("#pf-sider").fadeIn();
		    $("#pf-sider").html(datapc);
	  	}
 
	   function  showlefmenu_my(){
	    	$("#pf-sider").fadeOut();
	    	$("#pf-sider").html("数据获取中...");
		    var AppId="d42b46df6e583ca9a1b3e819dc42cfak";
		   	var AppKey="23548ad081d91ca0bdc66b22ca59cfc6";
		   	var token="myindex";
		   	var strvalue="{\"menuid\":\"my\"}";
		   	var datapc =PostpcApi("myindex.jsp",AppId,AppKey,token,strvalue);
	     	$("#pf-sider").fadeIn();
	     	$("#pf-sider").html(datapc);
	   } 
	</script>
	<script type="text/javascript" src="js/pub.js"></script>
	<script type="text/javascript">showlefmenu_my();</script>
</body> 
</html>
<% if(db!=null)db.close();db=null;if(server!=null)server=null;%>
