M=0;//文件大小   数字类型
tbodyid='';//展示上传文件 的 tbody_id
up_type='';//文件上传类型
selectid='';//选取文件按钮id
updataid='';//上传文件按钮id
userid='';//用户id
heade=new Object();//请求头    对象类型
file_input_id='';//上传成功后保存input 的id
up_url='';//上传附件接口

/**关键数据重构*/
function up_file(file_Size,tbody_id,updete_type,select_id,updata_id,uid,file_inputid,upapi_url,headers){
	if(updete_type.length<1){up_type="jpg|jpeg|png|gif|ptf|mp3|mp4|pdf|wps|ppt|xls|txt|zip|rar";}else{up_type=updete_type;}
	if(file_Size.length<1){M=30;}else{M=file_Size;}
	tbodyid=tbody_id;
	selectid=select_id;
	updataid=updata_id;
	userid=uid;
	heade=headers;
	file_input_id=file_inputid;
	up_url=upapi_url;
	
	up();
}

function up(){
		layui.use(['form', 'layedit', 'laydate','upload'], function(){
					  var $       = layui.jquery 
					     ,layer   = layui.layer
					     ,laydate = layui.laydate
					     ,upload  = layui.upload;
		
		
		//多文件列表示例
		var demoListView = $('#'+tbodyid)
			,uploadListIns = upload.render({
								  	method:'post'  //http 请求类型
								  	,data:{uid:userid}// 附加数据
								  	,exts: up_type//指定上传附件的类型
								    ,elem: '#'+selectid//选取文件按钮id
								    ,url: up_url 
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
																	            ,'<button class="layui-btn layui-btn-mini layui-btn-danger demo-delete" style="margin-top:0">删除</button>'
																	            ,'<button class="layui-btn layui-btn-mini preview">预览</button>'
																	          ,'</td>'
																	        ,'</tr>'
																	        ].join(''));
														        
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
									         (tds.eq(3).find('.demo-delete')).css('display','none'); //隐藏删除
									         tds.eq(3).find('.demo-reload').removeClass('preview'); //显示预览
									      	 //获取上传成功后的文件url 并 依次填充到指定的input 里面
									      	 file=$("#"+file_input_id).val();
									         if(file==null || file.length<1){
									       		file="";
									       	 }else{
									       		file=file+"|"
									       	 }
								        	$("#"+file_input_id).val(file+res.list);
								        return;
								      }
								      this.error(index, upload);
								    }
								    ,error: function(index, upload){
								      var tr = demoListView.find('tr#upload-'+ index)
								      ,tds = tr.children();
								      tds.eq(2).html('<span style="color: #FF5722;">上传失败</span>');
								      tds.eq(3).find('.demo-reload').removeClass('layui-hide'); //显示重传
								    }
								    ,headers:heade
			});
		
		});
}