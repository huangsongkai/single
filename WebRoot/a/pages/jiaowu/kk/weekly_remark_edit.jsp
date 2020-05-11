<%@ page trimDirectiveWhitespaces="true" %>
<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@page import="service.dao.db.Page"%>
<%@include file="../../cookie.jsp"%>
<%@page import="v1.haocheok.commom.common"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="org.apache.commons.lang3.StringUtils"%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head> 
	    <meta charset="utf-8"> 
	    <meta name="viewport" content="width=device-width, initial-scale=1"> 
		    <link rel="stylesheet" href="../../../pages/css/sy_style.css">	    
		    <link rel="stylesheet" href="../../js/layui2/css/layui.css">
			<script type="text/javascript" src="../../js/jquery-1.9.1.js" ></script><!--通用jquery-->
			<script src="../../js/layui2/layui.js"></script>
			<script type="text/javascript" src="../../js/tableExport/js/table-sort.js" ></script><!--表格排序js  css-->
			<script type="text/javascript" chartset="utf8" src="../../js/tableExport/js/table_list.js " ></script><!--表格导出js  css-->
		 	<script src="../../js/layerCommon.js"></script>
	    <title><%=Mokuai %></title> 
	   <style type="text/css"> 
	    th { background-color: white; }
	    .btn-group-vertical>.btn, .btn-group>.btn{height:33px;}
        table tr:hover{background:#eeeeee;color:#19A094;}
       </style>
 	</head> 
  <body>
  	
  	<%
		String semester = request.getParameter("semester");if(semester==null){semester="";}
		System.out.println(semester);
		String remarkSql = "select remark from weekly_schedule_remark where semester='"+semester+"'";

		ResultSet rs = db.executeQuery(remarkSql);
		String remark = "";
		if(rs.next()){
			if(StringUtils.isNotBlank(rs.getString("remark"))){
				remark = rs.getString("remark");
			}
		}
		if(rs!=null){rs.close();}
%>
	<form class="layui-form" action="?ac=post" method="post">
						<div class="layui-form-item dingwei width280"  >
							 <div class="layui-inline" style="width:80%">
							 	 <!-- id隐藏域 -->
							 	 <input type="hidden" name="semester" value="<%=semester%>" />
								 <label class="layui-form-label" >备注</label>
								 <div class="layui-input-inline"   style="width:80%">
								 	<textarea name="remark" required lay-verify="required" placeholder="请输入" class="layui-textarea"><%=remark %></textarea>
								 </div>
								 <font class='must'>*</font>
							  </div>
						</div>  
		 <div class="layui-form-item center ab">
		    <button class="layui-btn" lay-submit="" lay-filter="demo2"  style="margin-right: 250px;float: right;">保存</button>
		  </div>
		 
</form>
  </body>
  <script>
	layui.use(['form', 'layedit', 'laydate'], function(){
		 var form = layui.form;
		 form.verify({
		    required: function(value){
		      if(value.length==''){
		        return '备注为必填项';
		      }
		    }
		  });

		 form.on('submit(demo2)', function(data){
		    console.log(JSON.stringify(data.field));
		    return true;
		  });

		 <%
			if("post".equals(ac)){
				//接收流程信息
				 semester = request.getParameter("semester");
				remark = request.getParameter("remark");
				int id = 0;
				boolean state = false;
				String checkSql = "SELECT count(1) as row  FROM weekly_schedule_remark t where t.semester='"+semester+"'";	
				int checkRow = db.Row(checkSql);
				String sql ="";
				if(checkRow>0){//更新
					sql = "update weekly_schedule_remark set remark='"+remark+"',updatetime=now(),update_worker_id="+Suid+" where semester='"+semester+"'";
				}else{//插入
					sql = "insert into weekly_schedule_remark  (semester,remark,addtime,add_worker_id) values('"+semester+"','"+remark+"',now(),'"+Suid+"')";
				}
				state = db.executeUpdate(sql);
				if(state){
					out.println("successMsg('保存成功');");
				}else{
					out.println("errorMsg('保存失败')");
				}
			}
		%>
    });
</script>
</html>
<% 
if(db!=null)db.close();db=null;if(server!=null)server=null;%>