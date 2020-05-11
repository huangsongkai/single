



/**
 * 依赖layer,成功提示信息
 * @return
 */
function successMsg(msg){
	layer.msg(msg,{icon:1,time:1000,offset:'150px'},function(){
		 //刷新当前页面
		 window.parent.location.reload(true);
         var index = parent.layer.getFrameIndex(window.name); 
		 parent.layer.close(index);
		//调取刷新左侧菜单栏页面
		// shuaxin();
		
   });
	
}


/**
 * 依赖layer,错误提示信息
 * @param msg
 * @return
 */
function errorMsg(msg){
	layer.msg(msg,{icon:2,time:1000,offset:'150px'},function(){
		 //刷新当前页
		 window.parent.location.reload(true);
         var index = parent.layer.getFrameIndex(window.name); 
		 parent.layer.close(index);
		//调取刷新左侧菜单栏页面
		// shuaxin();
   });
	
}

/**
 * 刷新左侧页面
 * @return
 */
function shuaxin(){
	//获取当前所在ifram中id的值 
	//var frameId = parent.window.frameElement && parent.window.frameElement.id || '';
   	//截取frame获取一级菜单id
   	//var first_id = frameId.split("_")[0];
	//刷新左侧菜单栏
	 parent.parent.window.ac_tionz();
}