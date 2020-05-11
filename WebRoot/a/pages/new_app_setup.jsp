<%@ page trimDirectiveWhitespaces="true" %>
<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@page import="service.dao.db.Page"%>
<%@include file="cookie.jsp"%>
<%@page import="org.apache.commons.lang3.StringUtils"%>
<%
	String userole = request.getParameter("userole");
%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="utf-8">  
	    <meta name="viewport" content="width=device-width, initial-scale=1"> 
	    <link rel="stylesheet" href="../pages/css/sy_style.css">	    
	    <link rel="stylesheet" href="./js/layui2/css/layui.css">
		<script type="text/javascript" src="./js/jquery-1.9.1.js" ></script><!--通用jquery-->
		<script src="./js/layui2/layui.js"></script>
		<script src="./js/ajaxs.js"></script>
		<link rel="stylesheet" type="text/css" href="./js/webuploader/webuploader.css">
		<script type="text/javascript" src="./js/webuploader/webuploader.js"></script>
		<title>新建菜单</title>
	    <style type="text/css">     
			.inline{position: relative; display: inline-block; margin-right: 10px;}
	    </style>
	</head> 
	<body>
		<div style="margin: 15px;">  
			<fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
				<legend>新建app菜单</legend>
			</fieldset>
			<form class="layui-form" action="new_app_setup.jsp?ac=add&userole=<%=userole %>"  method="post" >
				    <div class="layui-form-item inline" style="width: 40%">
					<label class="layui-form-label" style=" width: 30%">菜单名字</label>	 				
					<div class="layui-input-inline">
						<input type="text" id="menuname"  lay-verify="required" name="menuname" class="layui-input" value="">
					</div>
				</div>
				<div class="layui-form-item inline" style="width: 40%">
					<label class="layui-form-label" style=" width: 30%">动作链接</label>	 				
					<div class="layui-input-inline">
						<input type="text" id="menulink"  lay-verify="required" name="menulink" class="layui-input" value="">
					</div>
				</div>
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">API地址</label>
					<div class="layui-input-inline">
						<input type="text" id="apiurl"    name="apiurl" class="layui-input" value="">
					</div>
				</div>
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">功能说明</label>
					<div class="layui-input-inline">
						<input type="text" id="menutxt"  name="menutxt" class="layui-input" value="">
					</div>
				</div>
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">菜单类型</label>
					<div class="layui-input-inline">
						<select name='menutype' lay-filter=""  lay-verify="required"   >
							<option value='1' selected>教师</option>
							<option value='2'>学生</option>
							<option value='3'>家长</option>
							<option value='0'>个人中心</option>
						</select>
					</div>
				</div>
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">排序</label>
					<div class="layui-input-inline">
						<input type="text" id="Sortid" lay-verify="required"  name="Sortid" class="layui-input" value="">
					</div>
				</div>
				<div class="layui-form-item inline" style=" width: 40%">
					<label class="layui-form-label" style=" width: 30%">用户角色</label>
					<div class="layui-input-inline">
						<select name='userole' lay-filter='userole' disabled lay-verify="required"   >
								<%
									if(userole==null) userole="0";
									if(userole.equals("1")){
										out.println("<option value='1' selected>教职工</option><option value='2'>学生</option><option value='3'>家长</option><option value='4'>管理员</option>");
									}else if(userole.equals("2")){
										out.println("<option value='1' >教职工</option><option value='2' selected>学生</option><option value='3'>家长</option><option value='4'>管理员</option>");
									}else if(userole.equals("3")){
										out.println("<option value='1' >教职工</option><option value='2'>学生</option><option value='3' selected>家长</option><option value='4'>管理员</option>");
									}
									else{
										out.println("<option></option><option value='1' >教职工</option><option value='2'>学生</option><option value='3' >家长</option><option value='4' selected>管理员</option>");
									}
								%>
						</select>
					</div>
				</div>
				
				<div class="layui-form-item inline" style="width: 40%">
					<label class="layui-form-label" style=" width: 30%">显示标记</label>	 				
					<div class="layui-input-inline">
						<select name="showstate" class="layui-input" lay-filter="showstate">
                          <option value="1" >显示</option>    
                          <option value="0" >隐藏</option> 
                        </select> 
					</div>
				</div>		
				<div class="layui-form-item inline" style="width: 40%">
					<label class="layui-form-label" style=" width: 30%">ico</label>	 				
					<div class="layui-input-inline">
							<div id="uploader-demo">
							    <div id="filePicker">选择图片</div>
							    <div id="fileList" class="uploader-list">
							    </div>
							</div>	
					</div>
				</div>		
				 	
				<div class="layui-form-item" style="margin-bottom:45px">
					<div class="layui-input-block"  style="margin-left:540px">			
						<button  class="layui-btn"  lay-submit >确认</button> 
					</div>
				</div>
			</form>
		</div>
	</body>
<script>
	 layui.use('form', function(){
		 layer = layui.layer,
		layedit = layui.layedit,
		laydate = layui.laydate;
		var form = layui.form;
		var $ = layui.jquery;
	})
	 var index = parent.layer.getFrameIndex(window.name);
</script>

<script type="text/javascript">
	//单张图片上传
		var uploader = WebUploader.create({
		    auto: true,
		    swf:  './js/webuploader/Uploader.swf',
		    server: '../../Api/v1/up',
		    pick: '#filePicker',
		    accept: {
		        title: 'Images',
		        extensions: 'gif,jpg,jpeg,bmp,png',
		        mimeTypes: 'image/*'
		    },
		    fileNumLimit: 1
		});

		// 当有文件添加进来的时候
		uploader.on( 'fileQueued', function( file ) {
			  var fileName = file.name.replace(/,/g, "_");//将文件名逗号替换
              var fileNameArray = file.name.split(".");
              if (fileNameArray.length > 2) {
                  alert('上传图片名不正确，图片名不能带有中英文的单双引号逗号和句号');
                  return false;
              }
              var fileSize = file.size;
              var types = ["jpg", "jpeg", "gif", "bmp", "png", "JPG", "JPEG", "GIF", "BMP", "PNG"];
              var ext = fileName.substring(fileName.length - 3).toLowerCase();
              var sing = false;
              for (var i = 0; i < types.length; i++) {
                  if (ext == types[i] && fileSize < 2097152) {
                      sing = true;
                  }
              }
              if (!sing) {
                  alert("只允许上传jpg/gif/bmp/png格式的图片,且不大于2M");
                  return false;
              }
              
		    var $li = $(
		            '<div id="' + file.id + '" class="file-item thumbnail">' +
		                '<img><input type="hidden" name="ico" value="" />' +
		                '<div class="info">' + file.name + '</div>' +
		            '</div>'
		            ),
		        $img = $li.find('img');
			    var $btns = $('<div class="file-panel">' +
	                    '<span class="remove-this handing">删除</span>'
	            ).appendTo($li);
		
		    // $list为容器jQuery实例
		    $('#fileList').append( $li );
		    $('#fileList').on('click', '.remove-this', function () {
			    $(this).parent().parent().remove();
			    uploader.reset();
            })
		    // 创建缩略图
		    uploader.makeThumb( file, function( error, src ) {
		        if ( error ) {
		            $img.replaceWith('<span>不能预览</span>');
		            return;
		        }
		        $img.attr( 'src', src );
		    }, '100', '100' );
		});
		//文件上传过程中创建进度条实时显示。
		uploader.on( 'uploadProgress', function( file, percentage ) {
		    var $li = $( '#'+file.id ),
		        $percent = $li.find('.progress span');
		    // 避免重复创建
		    if ( !$percent.length ) {
		        $percent = $('<p class="progress"><span></span></p>')
		                .appendTo( $li )
		                .find('span');
		    }
		    $percent.css( 'width', percentage * 100 + '%' );
		});
		
		// 文件上传成功，给item添加成功class, 用样式标记上传成功。
		uploader.on( 'uploadSuccess', function( file,response ) {
			var jsonObj =  JSON.parse(response._raw);
			var url = jsonObj.list;
			$('input[name="ico"]').val(url[0]);
		    $( '#'+file.id ).addClass('upload-state-done');
		    uploader.removeFile(file);
		});
		// 文件上传失败，显示上传出错。
		uploader.on( 'uploadError', function( file,response ) {
		    var $li = $( '#'+file.id ),
		        $error = $li.find('div.error');
		    // 避免重复创建
		    if ( !$error.length ) {
		        $error = $('<div class="error"></div>').appendTo( $li );
		    }
		    $error.text('上传失败');
		});
		
		// 完成上传完了，成功或者失败，先删除进度条。
		uploader.on( 'uploadComplete', function( file ) {
		    $( '#'+file.id ).find('.progress').remove();
		});
		
</script>


</html>
<% if("add".equals(ac)){ 
	String menuname = request.getParameter("menuname");
	String ico = request.getParameter("ico");
	String Sortid = request.getParameter("Sortid");
	 userole = request.getParameter("userole");
	String menulink = request.getParameter("menulink");
	String apiurlText = request.getParameter("apiurl");
	String menutype = request.getParameter("menutype");
	String menuTxt = request.getParameter("menutxt");
	String showstate = request.getParameter("showstate");

	try{
	   String sql="insert into  app_menu_sys (menuname,ico,Sortid,userole,menulink,apiurl,menutxt,showstate,menutype) values ('"+menuname+"','"+ico+"','"+Sortid+"','"+userole+"','"+menulink+"','"+apiurlText+"','"+menuTxt+"','"+showstate+"','"+menutype+"')" ;
	   if(db.executeUpdate(sql)==true){
		   out.println("<script>parent.layer.msg('新建成功'); parent.layer.close(index); parent.location.reload();</script>");
	   }else{
		   out.println("<script>parent.layer.msg('新建失败!请重新输入');</script>");
	   }
	 }catch (Exception e){		 
	    out.println("<script>parent.layer.msg('新建失败');</script>");
	    return;
	}
	//关闭数据与serlvet.out
	if (page != null) {page = null;}
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
if(db!=null)db.close();db=null;if(server!=null)server=null;
%>