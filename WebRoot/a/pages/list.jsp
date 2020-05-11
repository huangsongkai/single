<%@ page trimDirectiveWhitespaces="true" %>
<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<% String MMenuId="34"; //供应商2模块编号%>
<%@ include file="cookie.jsp"%>
<head> 
    <meta charset="utf-8"> 
    <meta name="viewport" content="width=device-width, initial-scale=1"> 
   
    <script src="js/umeditor/third-party/jquery.min.js"></script>
   <script src="js/layui/layui.js"></script>
    <link rel="stylesheet" href="js/layui/css/layui.css">
     <link rel="stylesheet" href="css/sy_style.css?22">
    <title>供应商报件</title> 
 </head> 
<body>
    <div class="container">   
  		<div class="layui-form">  
			<div class="right_top no_bg" style="">
		      <div class="layui-form-item">
			    <div class="layui-inline">
			      <label class="layui-form-label">条件</label>
			      <div class="layui-input-inline">
			        <input type="tel" class="layui-input">
			      </div>
			    </div>
			    <div class="layui-inline">
			      <label class="layui-form-label">条件</label>
			      <div class="layui-input-inline">
			        <input type="text" name=""  class="layui-input">
			      </div>
			    </div>
			    <div class="layui-inline">
			      <label class="layui-form-label">条件</label>
			      <div class="layui-input-inline">
			        <input type="text" name="" class="layui-input">
			      </div>
			    </div>
			    <div class="layui-inline">
			      <label class="layui-form-label">条件</label>
			      <div class="layui-input-inline">
			        <input type="text"  name=""  class="layui-input">
			      </div>
			    </div>
		  </div>
		     </div>
		     
		<div class="form_top no_bg" style="">
			 <button class="layui-btn layui-btn-small layui-btn-primary rt mar_l10" > <i class="layui-icon">ဂ</i>刷新</button>
		     <button class="layui-btn layui-btn-small  layui-btn-primary rt mar_l10"> <i class="layui-icon"></i> 搜索</button>
		     <input type="text" class="layui-input textbox-text rt mar_l10" placeholder="" style="">
 
		 </div>
		<table class="layui-table">
		    <colgroup>
		      <col width="50">
		      <col width="50">
		      <col width="120">
		       <col width="120">
		        <col width="120">
		       <col width="260">
		        <col width="120">
		         <col width="120">
		      <col width="150">
		      <col>
		    </colgroup>
	    <thead>
	      <tr>
	        <th><input type="checkbox" name="" lay-skin="primary" lay-filter="allChoose"><div class="layui-unselect layui-form-checkbox" lay-skin="primary"><i class="layui-icon"></i></div></th>
	        <td class="" >编号</td>
			<td class="">贷款类别</td>
			<td class="">收费政策</td>
			<td class="">姓名</td>
			<td class="">家庭住址</td>
			<td class="">联系电话</td>
			<td class="">时间</td>
			<td class="">操作</td>
	      </tr> 
	    </thead>
	    <tbody>
	      <tr>
	        <td><input type="checkbox" name="" lay-skin="primary"><div class="layui-unselect layui-form-checkbox" lay-skin="primary"><i class="layui-icon"></i></div></td>
	        <td class="" >1</td>
			<td class="">上融</td>
			<td class="">金融熟揭</td>
			<td class="">张春生</td>
			<td class="">家家庭住址家庭住址家庭住址庭住址</td>
			<td class="">联系电话</td>
			<td class="">2017-06-36</td>
			<td class=""><a>接单</a></td>
	      </tr>
	    </tbody>
     </table>
      </div>
    </div>  
    <script type="text/javascript" src="layui/lay/dest/layui.all.js"></script>  
   <script type="text/javascript">  
    //全选
        var $ = layui.jquery,  
            form = layui.form();  
        //全选  
        form.on('checkbox(allChoose)', function(data){  
            var child = $(data.elem).parents('table').find('tbody input[type="checkbox"]');  
            child.each(function(index, item){  
              item.checked = data.elem.checked;  
            });  
            form.render('checkbox');  
        });  
    </script>  
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
if(db!=null)db.close();db=null;if(server!=null)server=null;%>