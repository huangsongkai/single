<%@ page trimDirectiveWhitespaces="true" %>
<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@ include file="../../cookie.jsp"%>

<!DOCTYPE html>
<html>
<head>
	  <meta charset="utf-8">
	  <title>多文件上传演示</title>
	  <meta name="renderer" content="webkit">
	  <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
	  <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
	  <link rel="stylesheet" href="../../../pages/js/layui2/css/layui.css">
	  <script src="../../../pages/js/layui2/layui.js" charset="utf-8"></script>
</head>
<body>
	 <input id="file" type="hidden" value="">
	 <div class="layui-upload">
	  <button type="button" class="layui-btn layui-btn-normal" id="testList">选择多文件</button> 
	  <div class="layui-upload-list">
	    <table class="layui-table">
	      <thead>
	        <tr><th>文件名</th>
	        <th>大小</th>
	        <th>状态</th>
	        <th>操作</th>
	      </tr></thead>
	      <tbody id="demoList"></tbody>
	    </table>
	  </div>
	  <button type="button" class="layui-btn" id="testListAction">开始上传</button>
	</div> 
<!-- 注意：如果你直接复制所有代码到本地，上述js路径需要改成你本地的 -->
<script>
layui.use('upload', function(){
  var $ = layui.jquery
  ,upload = layui.upload;


  <%--单独的一个方法传参数使用--%>
  var M=0;//文件大小限制    兆为单位
  var tbodyid='';//tbody 的id
  var up_type='';//支持上传的类型
  var selectid='';//选取文件按钮id
  var updataid='';//上传按钮id
  var uid='<%=Suid%>';//用户id
  //[文件大小],[tbody id],[文件上传类型],[选取文件按钮id],[上传按钮id]
  up_file(1,'demoList','','testList','testListAction'); 
  
  
  //关键数据重构
  function up_file(file_Size,tbody_id,updete_type,select_id,updata_id,){
  	if(updete_type.length<1){up_type="jpg|png|gif|ptf|wps|ppt|xls|doc|txt|mp4|mp3|zip";}else{up_type=updete_type;}
  	if(file_Size.length<1){M=30;}else{M=file_Size;}
  	tbodyid=tbody_id;
  	selectid=select_id;
  	updataid=updata_id;
  }
  
  //多文件列表示例
  var demoListView = $('#'+tbodyid)
  ,uploadListIns = upload.render({
  	method:'post'  //http 请求类型
  	,data:{uid:uid}// 附加数据
  	,exts: up_type//指定上传附件的类型
    ,elem: '#'+selectid//选取文件按钮id
    ,url: '<%=basePath%>/Api/v1/up'//上传附件接口  http://192.168.1.74/haocheok_finance_2017/Api/v1/up
    ,size:1024*M
    ,accept: 'file'//上传类型 普通文件
    ,multiple: true//是否允许多文件上传
    ,auto: false//是否选完文件后自动上传
    ,bindAction: '#'+updataid//上传按钮id
    ,choose: function(obj){   
      var files = obj.pushFile(); //将每次选择的文件追加到文件队列
      //读取本地文件
      obj.preview(function(index, file, result){
        var tr = $(['<tr id="upload-'+ index +'">'
          ,'<td>'+ file.name+'</td>'
          ,'<td>'+ (file.size/1014).toFixed(1) +'kb</td>'
          ,'<td>等待上传</td>'
          ,'<td>'
            ,'<button class="layui-btn layui-btn-mini demo-reload layui-hide">重传</button>'
            ,'<button class="layui-btn layui-btn-mini layui-btn-danger demo-delete">删除</button>'
            ,'<button class="layui-btn layui-btn-mini preview">预览</button>'
          ,'</td>'
        ,'</tr>'].join(''));
        
        //单个重传
        tr.find('.demo-reload').on('click', function(){
           obj.upload(index, file);
        });
        
        //删除
        tr.find('.demo-delete').on('click', function(){
          delete files[index]; //删除对应的文件
          tr.remove();
        });
        //预读本地文件示例，不支持ie8
        tr.find('.preview').on('click', function(){
			window.open(result); //在新窗口打开
        });
        demoListView.append(tr);
      });
    }
    ,done: function(res, index, upload){
      if(res.code == 1000){ //上传成功
	         var tr = demoListView.find('tr#upload-'+ index)
	         ,tds = tr.children();
	         tds.eq(2).html('<span style="color: #5FB878;">上传成功</span>');
	         (tds.eq(3).find('.layui-hide')).css('display','none'); //隐藏删除
	         (tds.eq(3).find('.demo-delete')).css('display','none'); //隐藏重传
	         tds.eq(3).find('.demo-reload').removeClass('preview'); //显示预览
	      	 //获取上传成功后的文件url 并 依次填充到指定的input 里面
	      	 file=$("#file").val();
	         if(file==null || file.length<1){
	       		file="";
	       	 }else{
	       		file=file+"|"
	       	 }
        	$("#file").val(file+res.list);
        	
        return;
      }
      this.error(index, upload);
    }
    ,error: function(index, upload){
      var tr = demoListView.find('tr#upload-'+ index)
      ,tds = tr.children();
      tds.eq(2).html('<span style="color: #FF5722;">上传失败</span>');
      tds.eq(3).find('.demo-reload').removeClass('layui-hide'); //显示重传
    },
    headers : {
            "X-AppId":"<%=AppId_web%>",           
            "X-AppKey":"<%=AppKey_web%>",          
            "Token":"<%=Spc_token%>",          
            "X-UUID":"<%=Spc_token%>",             
            "X-AppId":"<%=AppId_web%>",    
            "x-real-ip":"<%=getIpAddr(request)%>",         
	    }  
  });
  });

</script>

</body>
</html>


<%if(db!=null)db.close();db=null;if(server!=null)server=null;%>