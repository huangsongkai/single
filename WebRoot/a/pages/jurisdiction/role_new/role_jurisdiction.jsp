<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%--角色权限分配页面 --%>
<%@include file="../../cookie.jsp"%>
<%@ page import="net.sf.json.JSONArray" %>
<%@ page import="net.sf.json.JSONObject" %>
 
<%String roleid = request.getParameter("roleid"); if(roleid==null){roleid="";}//获取角色id%>

<style>
	.layui-form-select .layui-input {padding-right: 0px;}
	.layui-form-checkbox span { height: 6%;}
</style>
<script type="text/javascript" src="../../../custom/jquery.easyui.min.js"></script>
<link rel="stylesheet" href="../../../custom/easyui/tree.css">
<link rel="stylesheet" href="../../js/zTree/css/demo.css" type="text/css">
<link rel="stylesheet" href="../../js/zTree/css/zTreeStyle/zTreeStyle.css" type="text/css">
<script type="text/javascript" src="../../js/zTree/js/jquery-1.4.4.min.js"></script>
<script type="text/javascript" src="../../js/zTree/js/jquery.ztree.core.js"></script>
<script type="text/javascript" src="../../js/zTree/js/jquery.ztree.excheck.js"></script>
<div class="layui-tab layui-tab-card" style="margin: -10px;">
	  <ul class="layui-tab-title">
	    <li class="layui-this">pc端权限</li>
	   <%---  <li>app端权限</li> --%>
	  </ul>
	  
	  <div class="layui-tab-content" style="h">
		  	<%---pc端权限--%>
		    <div class="layui-tab-item layui-show">
				<form class="layui-form" action="?ac=pc_role_info"  method="post" style="height: 80%;"  >
		    			
		    			<%--zTree 树形结构 --%>
		    			<div>
							<ul id="pc_tree" class="ztree" 
								style="
										background: #fefefe;
									    margin-top: -1.5%;
									    margin-left: -1.5%;
									    width: 100%;
									    height: 100%;
									    border-width: inherit;"
						    ></ul>
							<input type="hidden" id="pc_treeid" name="pc_roleid" value =""  />
							<input type="hidden" id="roleid" name="roleid" value ="<%=roleid%>"  />
						</div>
						<div class="layui-form-item" style="width:100%;">
						    <div class="layui-input-block" style="  float: right; margin-top: 5%;" >
						      	<button class="layui-btn" lay-submit="" lay-filter="pc_role">立即提交</button>
						      	<button type="reset" class="layui-btn layui-btn-primary">重置</button>
						    </div>
					    </div>
				</form>
			</div>
			
			<%---app端权限--%>
		    <div class="layui-tab-item">
		    	<form class="layui-form" action="?ac=app_role_info"  method="post" style="height: 80%;"  >
		    			
		    			<%--zTree 树形结构 --%>
		    			<div>
							<ul id="app_tree" class="ztree" 
								style="
										background: #fefefe;
									    margin-top: -1.5%;
									    margin-left: -1.5%;
									    width: 100%;
									    height: 100%;
									    border-width: inherit;"
						    ></ul>
							<input type="hidden" id="app_treeid" name="app_roleid" value =""  />
							<input type="hidden" id="roleid" name="roleid" value ="<%=roleid%>"  />
						</div>
						<div class="layui-form-item" style="width:100%;">
						    <div class="layui-input-block" style="  float: right; margin-top: 5%;" >
						      	<button class="layui-btn" lay-submit="" lay-filter="app_role">立即提交</button>
						      	<button type="reset" class="layui-btn layui-btn-primary">重置</button>
						    </div>
					    </div>
				</form>
		    </div>
	  </div>
</div>

<script>
	layui.use(['form'], function() {
				var form = layui.form(),layer = layui.layer;
				
				//监听pc权限提交
				form.on('submit(pc_role)', function(data) {
					get_pcnode();
				});
				//监听app权限提交
				form.on('submit(app_role)', function(data) {
					get_appnode();
				});
				
				
	});
	<%--树形结构--%>
	var setting = {
			check: {
				enable: true,
				chkboxType : { "Y" : "", "N" : "" }
			},
			data: {
				simpleData: {
					enable: true
				}
			}
	};

	<%--pc端权限数据--%>	
	var pcNodes =[
		<%--查询当前角色的pc端权限--%>
		<%
			String pcrole="SELECT id,fatherid,menuname,IF(FIND_IN_SET(id,REPLACE ( (SELECT menu_sys_id FROM zk_role WHERE  id='"+roleid+"'), '#', ',' )) <>0,'true','false' )AS checked FROM menu_sys  ";
			ResultSet pc_rs=db.executeQuery(pcrole);
			while(pc_rs.next()){
			String nocheck="";
				out.println("{ id:"+pc_rs.getInt("id")+", pId:"+pc_rs.getInt("fatherid")+", name:\""+pc_rs.getString("menuname")+"\", open:false,checked:"+pc_rs.getString("checked")+", \"nocheck\":false},");
			}if(pc_rs!=null){pc_rs.close();}
		%>
		
	];
	$(document).ready(function(){
			$.fn.zTree.init($("#pc_tree"), setting, pcNodes);
	});
	<%--获取节点id数据的值--%>
	function get_pcnode(){
		var treeObj = $.fn.zTree.getZTreeObj("pc_tree");
		var nodes = treeObj.getCheckedNodes(true);
		var nodesid = new Array();
		for(var i = 0 ; i < nodes.length ; i++ ){
			var id = nodes[i].id;
			nodesid.push(id);
		}
		$("#pc_treeid").val(nodesid);
	}	
	
	
	
	<%--app端权限数据--%>	
	var appNodes =[
		<%--查询当前角色的app端权限--%>
		<%
			String approle="SELECT id,fatherid,buttonname,IF(FIND_IN_SET(id,REPLACE ( (SELECT GROUP_CONCAT(buttonid SEPARATOR '#')  FROM z_role_button_bak WHERE  roleid='"+roleid+"'), '#', ',' )) <>0,'true','false')AS checked FROM z_buttonfuntion_bak ";
			System.out.println("approle=="+approle);
			ResultSet app_rs=db.executeQuery(approle);
			while(app_rs.next()){
			String nocheck="";
				if(app_rs.getInt("fatherid")==0){
				nocheck="\"nocheck\":true";
				}
				out.println("{ id:"+app_rs.getInt("id")+", pId:"+app_rs.getInt("fatherid")+", name:\""+app_rs.getString("buttonname")+"\", open:false,checked:"+app_rs.getString("checked")+", "+nocheck+"},");
			}if(app_rs!=null){app_rs.close();}
		%>
		
	];
	$(document).ready(function(){
			$.fn.zTree.init($("#app_tree"), setting, appNodes);
	});
	<%--获取节点id数据的值--%>
	function get_appnode(){
		var treeObj = $.fn.zTree.getZTreeObj("app_tree");
		var nodes = treeObj.getCheckedNodes(true);
		var nodesid = new Array();
		for(var i = 0 ; i < nodes.length ; i++ ){
			var id = nodes[i].id;
			nodesid.push(id);
		}
		$("#app_treeid").val(nodesid);
		<%--console.log($("#ztreeid").val());--%>
	}	
		
		
		
</script>






<% if(db!=null)db.close();db=null;if(server!=null)server=null; %>