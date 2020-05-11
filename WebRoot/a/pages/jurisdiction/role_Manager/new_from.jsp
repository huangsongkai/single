<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@ page import="net.sf.json.JSONArray" %>
<%@ page import="net.sf.json.JSONObject"%>
<%@ page import="service.dao.db.Page"%>
<%@ page import="service.sys.Atm"%>
<%@ include file="../../cookie.jsp"%>


<!DOCTYPE HTML>
<html>
 <head>
    
  <title>拖拽式表单设计器</title>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="author" content="leipi.org">
    <link rel="stylesheet" href="../../js/layui/css/layui.css" media="all" />
    <link href="../../universalForm/Public/css/bootstrap/css/bootstrap.css?2024" rel="stylesheet" type="text/css" />
    <link rel="stylesheet" href="../../css/form.css?22">
    <script type="text/javascript" src="../../js/layui/layui.js"></script>
 </head>
<body>

<div class="container">
    <div class="span6">
      <div class="clearfix">
        <h2>新建表单</h2>
        <hr>
        <div id="build">
            <form id="target" class="form-horizontal" style="padding-top: 0px;"; Method="post" action="?ac=up_from">
                  <fieldset>
                        <div id="legend" class="component" rel="popover" title="编辑属性" trigger="manual"
                          data-content="
                          <form class='form'>
                            <div class='controls'>
                              <label class='control-label'>表单名称</label> 
                                  <input type='text'  id='fromChinese' placeholder='表单名称（中文）'  >
                               <label class='control-label'>表单表名</label> 
                                  <input type='text'  id='fromEnglish' placeholder='请输入表单表名'>
                              <hr/>
                              <button class='btn btn-info' type='button' >确定</button>
                            </div>
                          </form>"
                          >
                          <input  type="hidden" id="from_id" name="form_name"  fromChinese=""  fromEnglish="" class="leipiplugins" leipiplugins="form_name"/>
                          <legend id="form_name_id" class="leipiplugins-orgvalue">点击填写表单名</legend>
                        </div>
                  </fieldset>
                  <input id="json" type="hidden" name="json" value="";>
                   <div  id="memostatus_div" style="border-radius: 6px;line-height: 30px;padding: 5px;left: 70%;bottom:15px;background-color: #f0f0f0;width: 115px;height: 31px; position: absolute;">
                   		<input type='radio'  name='memostatus' value='0' checked="checked"/>有备注 
                        <input type='radio'  name='memostatus' value='1'/>无备注
                   </div>
                   <button class="layui-btn" lay-submit="" lay-filter="demo1" style=" margin: 0 auto; position: absolute;  left: 48%;  bottom: 20px;" >
                   		创建表单
                   </button>
            </form>
            
        </div>
      </div>
    </div>

    <div class="span6">
        <h2>拖拽下面的组件到左侧</h2>
        <hr>
      <div class="tabbable">
        <ul class="nav nav-tabs" id="navtab">
          <li class="active"><a href="#1" data-toggle="tab">组件</a></li>
        </ul>
        <form class="form-horizontal" id="components"   Method="post" action="?ac=up_from">
          <fieldset>
          
            <div class="tab-content"  style=" border: 1px solid #ccc; padding: 10px; ">
              <!--常用组件-->
              <div class="tab-pane active" id="1">
                    <!-- Text start -->
                    <div class="control-group component" rel="popover" title="文本框组件" trigger="manual"
                      data-content="
                      <div id='wang'>
                      <form class='form'>
                        <div class='controls' style='width: 110%;' >
                            <div class='k_attribute'>
                              <label class='control-label'>组件名称（中文）</label>  
                              <input type='text' id='chineseComponent'  placeholder='组件名称（中文）'   >
                            </div>

                            <div class='k_attribute'>
                              <label class='control-label'>组件字段名称（英文）</label>  
                              <input type='text' id='englishComponent'  placeholder='组件字段名称（英文）'>
                            </div>

                            <div class='k_attribute'>
                              <label class='control-label'>提示值</label>   
                              <input type='text' id='promptValue' placeholder='提示值'>
                            </div>

                            <div class='k_attribute'>
                              <label class='control-label'>必填状态 </label>   
                              <input type='radio'  name='theclick' id='theRequiredState' value='0'  checked='checked' />非必填
                              <input type='radio'  name='theclick' id='theRequiredState' value='1' />必填
                            </div>

                            <!--<label class='control-label'>多选下拉框</label>-->
                                <input type='hidden' id='drop_downbox'  value='' >

                            <div class='k_attribute'>
                              <label class='control-label'>组件宽度</label>  
                              <input type='text' id='assemblyWidth'  placeholder='组件宽度' value='0'>
                            </div>

                            <div class='k_attribute'>
                              <label class='control-label'>组件高度</label>    
                              <input type='text' id='assemblyHeight' placeholder='组件高度' value='0'>
                            </div>

                            <div class='k_attribute'>
                              <label class='control-label'>数据类型</label>   
                                <dir style='display: inline-table;'>
                                  <select name='click' lay-filter='aihao' id='dataType'>
									<option value='INT(10)'>数字类型  [INT(10)]</option>
									<option value='VARCHAR(225)' selected=''>字符串类型  [VARCHAR(225)]</option>
									<option value='VARCHAR(500)' >字符串类型  [VARCHAR(500)]</option>
									<option value='TEXT'>文本类型  [TEXT]</option>
									<option value='DATE'>时间类型  [DATE]</option>
									<option value='DATETIME'>时间类型  [DATETIME]</option>
								  </select>
                                </dir>
                            </div>

                            <div class='k_attribute'>
                              <label class='control-label'>组件类型</label>
                                <div style='display: inline-table;'>
                                  <input type='radio'  name='click' checked='checked' id='componentType' value='1'/> 单行文本
                                  <input type='radio'  name='click' id='componentType' value='2' /> 多行文本 
                                  <br> 
                                  <input type='radio'  name='click' id='componentType' value='6'/> 普通文本 
                                  <input type='radio'  name='click' id='componentType' value='7'/> 数字框
                                  <br> 
                                  <input type='radio'  name='click' id='componentType' value='8'/> 日期
                                  <input type='radio'  name='click' id='componentType' value='9'/> 时间
                                 
                                </div>
                             </div>
                          <hr/>
                          <button class='btn btn-info' type='button'>确定</button><button class='btn btn-danger' type='button'>取消</button>
                        </div>
                      </form>
                      </div>"
                      >
                      <!-- Text -->
                      <label class="control-label leipiplugins-orgname">文本框</label>
                      <div class="controls" wang="wang">
                        <input cid="1" name="leipiNewField" type="text"  a="abc"  b="bbc"   placeholder="默认值" title="文本框" value="" class="leipiplugins" leipiplugins="text"/>
                      </div>
                    </div>
                    <!-- Text end -->


                    <!-- Select start -->
                    <div class="control-group component" rel="popover" title="下拉菜单|单选|多选 组件" trigger="manual"
                      data-content="
                      <form class='form'>
                        <div class='controls' style='width: 110%;' >
                            <div class='k_attribute'>
                              <label class='control-label'>组件名称（中文）</label>  
                              <input type='text' id='chineseComponent'  placeholder='组件名称（中文）'>
                            </div>

                            <div class='k_attribute'>
                              <label class='control-label'>组件字段名称（英文）</label>  
                              <input type='text' id='englishComponent'  placeholder='组件字段名称（英文）'>
                            </div>

                            <div class='k_attribute'>
                              <label class='control-label'>提示值</label>   
                              <input type='text' id='promptValue' placeholder='提示值'>
                            </div>

                            <div class='k_attribute'>
                              <label class='control-label'>必填状态 </label>   
                              <input type='radio'  name='click1' id='theRequiredState' value='0'  checked='checked' />非必填
                              <input type='radio'  name='click1' id='theRequiredState' value='1' />必填
                            </div>

                            <div class='k_attribute'>
                              <label class='control-label'>下拉选项</label>
                              <textarea style='min-height: 100px' id='drop_downbox' autofocus >一行对应一个选项</textarea>
                            </div>
                           
                            
                            <div class='k_attribute'>
                              <label class='control-label'>组件宽度</label>  
                              <input type='text' id='assemblyWidth'  placeholder='组件宽度' value='0'>
                            </div>

                            <div class='k_attribute'>
                              <label class='control-label'>组件高度</label>    
                              <input type='text' id='assemblyHeight' placeholder='组件高度'  value='0'>
                            </div>

                            <div class='k_attribute'>
                              <label class='control-label'>数据类型</label>   
                                <dir style='display: inline-table;'>
                                  <select name='click' lay-filter='aihao' id='dataType'>
									<option value='INT(10)'>数字类型  [INT(10)]</option>
									<option value='VARCHAR(225)' selected=''>字符串类型  [VARCHAR(225)]</option>
									<option value='VARCHAR(500)' >字符串类型  [VARCHAR(500)]</option>
									<option value='TEXT'>文本类型  [TEXT]</option>
									<option value='DATE'>时间类型  [DATE]</option>
									<option value='DATETIME'>时间类型  [DATETIME]</option>
								  </select>
                                </dir>
                            </div>

                            <div class='k_attribute'>
                              <label class='control-label'>组件类型</label>
                                <div style='display: inline-table;'>
                                   <input type='radio'  name='click' checked='checked' id='componentType' value='3'/>  下拉框
                                   <input type='radio'  name='click' id='componentType' value='4'/>  单选框
                                   <input type='radio'  name='click' id='componentType' value='5'/>  复选框
                                </div>
                             </div>
                          <hr/>
                          <button class='btn btn-info' type='button'>确定</button><button class='btn btn-danger' type='button'>取消</button>
                        </div>
                      </form>"
                      >
                      <!-- Select -->

                      <label class="control-label leipiplugins-orgname">下拉菜单|单选|多选</label>
                      <div class="controls" wang="wang">
                        <select name="leipiNewField" title="下拉菜单" class="leipiplugins" leipiplugins="select">
                        </select>
                      </div>
                    </div>
                   


                    <div class="control-group component" rel="popover" title="上传组件" trigger="manual"
                      data-content="
                      <form class='form'>
                        <div class='controls' style='width: 110%;' >
                            <div class='k_attribute'>
                              <label class='control-label'>组件名称（中文）</label>  
                              <input type='text' id='chineseComponent'  placeholder='组件名称（中文）'>
                            </div>

                            <div class='k_attribute'>
                              <label class='control-label'>组件字段名称（英文）</label>  
                              <input type='text' id='englishComponent'  placeholder='组件字段名称（英文）'>
                            </div>

                            <div class='k_attribute'>
                              <label class='control-label'>提示值</label>   
                              <input type='text' id='promptValue' placeholder='提示值'>
                            </div>

                            <div class='k_attribute'>
                              <label class='control-label'>必填状态 </label>   
                              <input type='radio'  name='theclick' id='theRequiredState' value='0'  checked='checked' />非必填
                              <input type='radio'  name='theclick' id='theRequiredState' value='1' />必填
                            </div>

                            <!--<label class='control-label'>多选下拉框</label>-->
                                <input type='hidden' id='drop_downboxs'  value='' >

                            <div class='k_attribute'>
                              <label class='control-label'>组件宽度</label>  
                              <input type='text' id='assemblyWidth'  placeholder='组件宽度' value='0'>
                            </div>

                            <div class='k_attribute'>
                              <label class='control-label'>组件高度</label>    
                              <input type='text' id='assemblyHeight' placeholder='组件高度' value='0'>
                            </div>

                            <div class='k_attribute'>
                              <label class='control-label'>数据类型</label>   
                                <dir style='display: inline-table;'>
                                  <select name='click' lay-filter='aihao' id='dataType'>
									<option value='INT(10)'>数字类型  [INT(10)]</option>
									<option value='VARCHAR(225)' selected=''>字符串类型  [VARCHAR(225)]</option>
									<option value='VARCHAR(500)' >字符串类型  [VARCHAR(500)]</option>
									<option value='TEXT'>文本类型  [TEXT]</option>
									<option value='DATE'>时间类型  [DATE]</option>
									<option value='DATETIME'>时间类型  [DATETIME]</option>
								  </select>
                                </dir>
                            </div>

                            <div class='k_attribute'>
                              <label class='control-label'>组件类型</label>
                                <div style='display: inline-table;'>  
 
  
                                 <input type='radio'  name='click' checked='checked' id='componentType' value='10'/> 文件上传
                                  <input type='radio'  name='click'id='componentType' value='11' />  视频上传
                                  <br> 
                                  <input type='radio'  name='click'id='componentType' value='12'/> 图片上传
                                </div>
                             </div>
                          <hr/>
                          <button class='btn btn-info' type='button'>确定</button><button class='btn btn-danger' type='button'>取消</button>
                        </div>
                      </form>"
                      >
                      <!-- Text -->
                      <label class="control-label leipiplugins-orgname">上传组件</label>
                      <div class="controls" wang="wang">
                        <input cid="1" name="leipiNewField" type="text"  a="abc"  b="bbc"   placeholder="默认值" title="文本框" value="" class="leipiplugins" leipiplugins="text"/>
                      </div>
                    </div>
              </div>
            </div>
            
          </fieldset>

        </form>
        </div><!--tab-content-->
        </div><!---tabbable-->
      
    </div> <!-- /container -->

<script type="text/javascript" charset="utf-8" src="../../universalForm/Public/js/jquery-1.7.2.min.js?2024"></script>
<script type="text/javascript"  src="../../universalForm/Public/js/formbuild/bootstrap/js/bootstrap.min.js?2024"></script>




<script type="text/javascript">
layui.use(['form'], function() {
	var form = layui.form(),
		layer = layui.layer,
		layedit = layui.layedit,
		laydate = layui.laydate;

		//监听提交
		form.on('submit(demo1)', function() {
				//表单英文名
				    var fromEnglish=$("#legend input").attr('fromEnglish');
				    if(typeof(fromEnglish) == "undefined" || fromEnglish.length==0 ){
				    	$('#form_name_id').trigger("click");
				    	$('#fromEnglish').focus();
				    	jrumble('请填写表单英文名称');
				    	 return false;
				    }
				    //表单中文名 
				    var fromChinese= $("#legend input").attr('fromChinese');
				    if(typeof(fromChinese) == "undefined" || fromChinese.length==0 ){
				        $('#form_name_id').trigger("click");
				        $('#fromChinese').focus();
				        jrumble('请填写表单中文名称');
				         return false;
				    }
				    
				    //是否有备注
				    var array2 = $('#memostatus_div').find('input');
					var memostatus="1";
					$.each( array2 , function(i, item){
					    var state1 = $(item).prop('checked');
					    if(state1 == true) {
					    memostatus=item.value;
					    }
					});
					
				    /**
				     *组件信息 
				     */
				    var num= $("#target .control-group").length;//组件个数
				    var fieldInfo  = new Array();
				    for (var i=0;i<num;i++){// alert("共有组件"+num);
				      var objstr=$("#target .control-group").eq(i).find('input,textarea,select');
				      
				       
				       //组件类型      (必填)
				       var componentType    =objstr.attr('componentType');   
				       if(typeof(componentType) == "undefined" || componentType.length<1) {
				      		 objstr.trigger("click");//模拟点击当前事件
				       		 jrumble('请填写组件类型');
				       		 return false;
				       }
				       //组件名中文 (必填)
				       var chineseComponent =objstr.attr('chineseComponent');  
				       if( typeof(chineseComponent) == "undefined" || chineseComponent.length<1){
				       		objstr.trigger("click");//模拟点击当前事件
				       		jrumble('请填写组件名中文');
				       		return false;
				       }
				       //组件名英文 (必填)
				       var englishComponent =objstr.attr('englishComponent'); 
				       if( typeof(englishComponent) == "undefined" || englishComponent.length<1){
				       		objstr.trigger("click");//模拟点击当前事件
				       		jrumble('请填写组件名英文');
				       		return false;
				       }
					   //必填状态   (必填)
				       var theRequiredState =objstr.attr('theRequiredState');  
				       if(typeof(theRequiredState) == "undefined" || theRequiredState.length<1){
				       		objstr.trigger("click");//模拟点击当前事件
				       		jrumble('请填写组件必填状态');
				       		return false;
				       }
				       //组件宽度      (必填)
				       var assemblyWidth    =objstr.attr('assemblyWidth');     
				       if(typeof(assemblyWidth) == "undefined" || assemblyWidth.length<1){
				       		objstr.trigger("click");//模拟点击当前事件
				       		jrumble('请填写组件宽度 ');
				       		return false;
				       }
				       //组件高度     (必填)
				       var assemblyHeight   =objstr.attr('assemblyHeight');   
				       if(typeof(assemblyHeight) == "undefined" || assemblyHeight.length<1){
				       		objstr.trigger("click");//模拟点击当前事件
				       		jrumble('请填写组件高度');
				       		return false;
				       }
					   //数据类型           (必填) 
					   var dataType         =objstr.attr('dataType');     
					   if(typeof(dataType) == "undefined" || dataType.length<1 ){
				       		objstr.trigger("click");//模拟点击当前事件
				       		jrumble('请填写组件数据类型  ');
				       		return false;
					   }
				       //下拉框json
				       var drop_downbox     ="["+objstr.attr('drop_downboxs')+"]"; 
				       
				       if(typeof(drop_downbox) == "undefined" || drop_downbox.length<1){ drop_downbox="" }   
				       //提示值  
				       var promptValue      =objstr.attr('promptValue');      
				       if(promptValue.length<1){ promptValue="" }
				      
				      var arrList = new Array();
				      arrList [0] =componentType;      arrList [1] =chineseComponent;  arrList [2] =englishComponent;     
				      arrList [3] =theRequiredState;   arrList [4] =assemblyWidth;     arrList [5] =assemblyHeight;
				      arrList [6] =dataType;
				      if($.inArray("", arrList)>-1){ 
				      		objstr.trigger("click");//模拟点击当前事件
				       		jrumble('该组件出现位置错误，请重新填写');
				       		return false; 
				      }
				      arrList[7] =drop_downbox;
				      arrList[8] =promptValue;
				
				      //拼接返回服务器端的组件属性数组；
				      fieldInfo[i] = arrList;
				    } 
				    if(fieldInfo.length==0){//
				     	jrumble('请最少添加一个组件');
				      	return false;
				    }
				    //拼接返回服务器端的json 串；
				    var student = new Object();
				    student.fromname = fromChinese;
				    student.formEnglish = fromEnglish;
				    student.memostatus = memostatus;
				    student.fieldInfo =fieldInfo;
				    var json = JSON.stringify(student);
				    if(json.length<1){
				    	jrumble('不能创建空的表单');
				      	return false;
				    }else{
				   		 $('#json').val(json);
				   		 return true;
				    }
				    
			
		});
});


//判断必填项是否为空
function verification(obj){
	layui.use('layer', function(){
	var layer = layui.layer;
	
		var state=true;//默认不执行提示 信息 
	    var attr_val=$(obj).val();//控件值
	    var attr_id=$(obj).attr("id");//控件id
		
	    if ($(obj).val().replace(/(^s*)|(s*$)/g, "").length ==0){ //为空
	    		 $(obj).focus();//添加焦点
	    		 $(obj).focus();//添加焦点
				 layer.msg('该选项为必填项！', {time:1000}); 
	    }else{//不为空
	        if(attr_id=="drop_downbox"){//下拉选择组件
	            //判断选项是否有重复
	            var options = attr_val.split("\n");
	            var ary=$.makeArray(options);
	            var nary=ary.sort();
	            for(var i=0;i<ary.length;i++){  if(nary[i]==nary[i+1]){  state=false; } }
	         }
	          if(state==false){ //提示消息相关
	             //下拉选择组件
	             if(attr_id=="drop_downbox"){  
	             	$(obj).focus();//添加焦点
	             	layer.msg('下拉选项存在重复内容！', {time:1000}); 
	             }
	          }
	    }
		
	}); 
}
//提交组件信息提示框 
function jrumble(obj){
	layui.use('layer', function(){
	var layer = layui.layer;
		layer.msg(obj, {time:1000}); 
	}); 
}

//信息提示确认框 
function jrumblebut(e){
	layui.use('layer', function(){
	var layer = layui.layer;
	
		layer.open({
		  content: 'test'
		  ,closeBtn: 0
		  ,btn: [ '保留', '移除']
		  ,btn2: function(index, layero){//按钮【移除】的回调
		  	console.log("e=="+e.html());
		  }
		  ,btn3: function(index, layero){  //按钮【保留】的回调
		  }
		});
	}); 
}
$("body").click(function(event){  
	var ifdisplay=$('.in').css('display');
	if(ifdisplay=='block'){
		$(".tabbable").hide(900);
	}else{
		$(".tabbable").show(900);
	}
});  
<%
/**
 *创建万能表单 
 */
if("up_from".equals(ac)){
String ltype="[pc_端]";//操作类型 
String title="创建万能表单";//


		String json = request.getParameter("json"); if(json==null){json="";} //获取文件后面的对象 数据
		//System.out.println(json);
		
		String fromChinese="";  //表单中文名
		String fromEnglish="";  //表单英文名
		String memostatus="";   //是否有备注 
		
		int fid=0;//
		
		ArrayList<String> establish = new ArrayList<String>();//创建表语句
		String up_record_sheet = "";//更新表单记录表
		ArrayList<String> up_template_table = new ArrayList<String>();//更新表单模版表 
		
		ArrayList<String> list = new ArrayList<String>();

		try { // 解析开始
			JSONArray from_date = JSONArray.fromObject("[" + json + "]");
			for (int i = 0; i < from_date.size(); i++) {
				JSONObject obj = from_date.getJSONObject(i);
				
				fromChinese = obj.get("fromname") + "";
				fromEnglish = obj.get("formEnglish") + "";
				memostatus =  obj.get("memostatus")  + "";
				
				if(i==0){
				//更新表单记录表
					up_record_sheet="INSERT INTO form_name "+
										"(formname, datafrom, createtime, createid, updatetime, updateid )"+
									"VALUES"+
										"('"+fromChinese+"', '"+fromEnglish+"', now(), '"+Suid+"', now(), '"+Suid+"' );";
				    fid=db.executeUpdateRenum(up_record_sheet);
				}
								
				JSONArray fieldInfo = JSONArray.fromObject(obj.get("fieldInfo"));
				for (int j = 0; j < fieldInfo.size(); j++) {
					JSONArray obj_one =fieldInfo.getJSONArray(j);//单个组件 属性 
						//System.out.println("组件类型=="+obj_one.getString(0));//组件类型 {单行文本 。。。} //System.out.println("组件中文名*==="+obj_one.getString(1));//组件中文名* //System.out.println("组件英文名=="+obj_one.getString(2));//组件英文名* //System.out.println("组件是否必填=="+obj_one.getString(3));//组件是否必填 //System.out.println("组件宽度   =="+obj_one.getString(4));//组件宽度 //System.out.println("组件高度   =="+obj_one.getString(5));//组件高度 //System.out.println("数据类型   =="+obj_one.getString(6));//数据类型 //System.out.println("下拉选项值  =="+obj_one.getString(7));//下拉选项值 //System.out.println("提示值    =="+obj_one.getString(8));//提示值
						
						up_template_table.add("((SELECT cid FROM  form_type WHERE cid ='"+obj_one.getString(0)+"'),'"+fid+"',(SELECT ftypename FROM  form_type WHERE cid ='"+obj_one.getString(0)+"'),(SELECT ftypename_en FROM  form_type WHERE cid ='"+obj_one.getString(0)+"'),'"+obj_one.getString(1)+"','"+obj_one.getString(8)+"','"+obj_one.getString(3)+"','"+obj_one.getString(7).replaceAll("\\[","").replaceAll("\\]","")+"','"+obj_one.getString(4)+"','"+obj_one.getString(5)+"','"+j+"','"+obj_one.getString(2)+"',(SELECT ftypename_en FROM  form_type WHERE cid ='"+obj_one.getString(0)+"'))");
						
						//创建表语句
						String sql_str="";
						String dataType=obj_one.getString(6);
						if("INT(10)".equals(dataType)){//int 类型 
							sql_str="`"+obj_one.getString(2)+"` "+dataType+" NOT NULL DEFAULT COMMENT '"+obj_one.getString(1)+"'";
						}else if("VARCHAR(225)".equals(dataType)){//字符串类型
						   sql_str="`"+obj_one.getString(2)+"` "+dataType+" COLLATE utf8_bin NOT NULL COMMENT '"+obj_one.getString(1)+"'";
						}else if("VARCHAR(500)".equals(dataType)){//字符串类型
						   sql_str="`"+obj_one.getString(2)+"` "+dataType+" COLLATE utf8_bin NOT NULL COMMENT '"+obj_one.getString(1)+"'";
						}else if("TEXT".equals(dataType)){//文本类型
						   sql_str="`"+obj_one.getString(2)+"` "+dataType+" COLLATE utf8_bin NOT NULL COMMENT '"+obj_one.getString(1)+"'";
						}else if("DATE".equals(dataType)){//时间类型
						   sql_str="`"+obj_one.getString(2)+"` "+dataType+" DEFAULT NULL COMMENT '"+obj_one.getString(1)+"'";
						}else if("DATETIME".equals(dataType)){//时间类型
						   sql_str="`"+obj_one.getString(2)+"` "+dataType+" DEFAULT NULL COMMENT '"+obj_one.getString(1)+"'";
						}
						establish.add(sql_str);//创建表单数据表 
				}
			}
		}catch (Exception e) {
		   out.println(" jrumble('表单数据异常请重试');");
		   db.executeUpdate("DELETE FROM form_name  WHERE id = '"+fid+"' ;");
		   System.out.println("e=="+e);
		}
		//判断是否有备注
	    String memostatus_sql="";//备注字段创建 语句 
		if("0".equals(memostatus)){//有备注
		  memostatus_sql="`remarks` TEXT COLLATE utf8_bin COMMENT '备注',";
		}
		
		boolean establish_state=false;
		boolean up_template_state=false;
		
		
		if(fid>0){//更新表名记录成功
			//创建表单语句
			String establish_sql="CREATE TABLE `"+fromEnglish+"` ("+
									   "`id` INT(10) UNSIGNED NOT NULL COMMENT '自增id    ["+fromChinese+"]',"+
									   "`orderid` INT(10) NOT NULL DEFAULT '0' COMMENT '订单id',"+
									   establish.toString().replaceAll("\\[","").replaceAll("\\]","")+","+
									   memostatus_sql+
									   "`createtime` DATETIME DEFAULT NULL COMMENT '创建时间',"+
									   "`createid` INT(10) NOT NULL DEFAULT '0' COMMENT '创建者id',"+
									   "`updatetime` DATETIME DEFAULT NULL COMMENT '修改时间',"+
									   "`updateid` INT(10) NOT NULL DEFAULT '0' COMMENT '修改者id',"+
									   "PRIMARY KEY (`id`)"+
									 ") ENGINE=MYISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin CHECKSUM=1 DELAY_KEY_WRITE=1 ROW_FORMAT=DYNAMIC COMMENT='"+fromChinese+"'";
			establish_state=db.executeUpdate(establish_sql);
			if(establish_state){//创建表单成功
				//更新表单模版表 
				String up_template_table_sql="INSERT INTO form_template_confg "+
												"( cid, fid, ftype_name, ftype_tag, title, prompt, tmust_input, teams, width, height, sort, strname, datatype)"+
											 "VALUES"+
												up_template_table.toString().replaceAll("\\[","").replaceAll("\\]","")+";";
												
				//System.out.println("up_template_table_sql=="+up_template_table_sql);
				up_template_state=db.executeUpdate(up_template_table_sql);
				if(up_template_state){//更新表单模版表成功 
				
					//刷新父页面 
					out.println(" jrumble('创建【"+fromEnglish+"】表单成功');");
					out.println(" function foo(){ parent.location.reload();}");
					out.println(" foo();");
					//记录系统日志
					Atm.LogSys(ltype, title, "创建【"+fromEnglish+"】表单成功 ", "0", Suid, request.getRemoteAddr());
				}else{
					//删除创建的表   
					db.executeUpdate("DROP TABLE `"+fromEnglish+"`;");
					//创建表单失败 删除 表名记录数据 
					db.executeUpdate("DELETE FROM form_name  WHERE id = '"+fid+"' ;");
					//记录系统日志
				   Atm.LogSys(ltype, title, "创建【"+fromEnglish+"】表单失败 ", "1", Suid, request.getRemoteAddr());
				}
			}else{//创建表单失败 删除 表名记录数据 
				db.executeUpdate("DELETE FROM form_name  WHERE id = '"+fid+"' ;");
				//记录系统日志
				Atm.LogSys(ltype, title, "创建【"+fromEnglish+"】表单失败 ", "1", Suid, request.getRemoteAddr());
			}
		}
	
}%>


</script>
<script type="text/javascript" charset="utf-8" src="../../universalForm/Public/js/formbuild/leipi.form.build.core.js?2024"></script>
<script type="text/javascript" charset="utf-8" src="../../universalForm/Public/js/formbuild/leipi.form.build.plugins.js?2024"></script>
</body>
</html>


<%

	

	//插入常用菜单日志
	int TagMenu=db.Row("SELECT COUNT(*) as row FROM  menu_worker  WHERE sysmenuid='"+PMenuId+"' and  workerid='"+Suid+"' and  companyid="+Scompanyid);
	if(TagMenu==0){
	   db.executeUpdate("INSERT INTO `menu_worker`(`sysmenuid`,`workerid`,`countes`,`companyid`) VALUES ('"+PMenuId+"','"+Suid+"','1','"+Scompanyid+"');"); 
	}else{
	  db.executeUpdate("UPDATE  `menu_worker` SET `countes`=countes+1,`usetime`=now() WHERE  sysmenuid='"+PMenuId+"' and  workerid='"+Suid+"' and  companyid="+Scompanyid);
	}
	
	
	
%>
<%if(db!=null)db.close();db=null;if(server!=null)server=null;%>
