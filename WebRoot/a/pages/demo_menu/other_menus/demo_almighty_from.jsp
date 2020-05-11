<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@ include file="../../cookie.jsp"%>

<!DOCTYPE HTML>
<html>
 <head>
    
  <title>拖拽式表单设计器</title>
  <meta name="keyword" content="拖拽式表单设计器,Web Formbuilder,Formbuild,专业表单设计器,高级表单设计器,智能表单设计器,WEB表单设计器,web formdesign,formdesigner">
  <meta name="description" content="拖拽式表单设计器Formbuild是强大的在线WEB表单设计器，它通常在、OA系统、问卷调查系统、考试系统、等领域发挥着重要作用，你可以在此基础上任意修改使功能无限强大！">

    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="author" content="leipi.org">
    <link href="../../universalForm/Public/css/bootstrap/css/bootstrap.css?2024" rel="stylesheet" type="text/css" />
     <link rel="stylesheet" href="../../css/form.css?22">
    <!--[if lte IE 6]>
    <link rel="stylesheet" type="text/css" href="Public/css/bootstrap/css/bootstrap-ie6.css?2024">
    <![endif]-->
    <!--[if lte IE 7]>
    <link rel="stylesheet" type="text/css" href="Public/css/bootstrap/css/ie.css?2024">
    <![endif]-->
 </head>
<body>

<div class="container">
    <div class="span6">
      <div class="clearfix">
        <h2>新建表单</h2>
        <hr>
        <div id="build">
            <form id="target" class="form-horizontal">
                  <fieldset>
                        <div id="legend" class="component" rel="popover" title="编辑属性" trigger="manual"
                          data-content="
                          <form class='form'>
                            <div class='controls'>
                              <label class='control-label'>表单名称</label> 
                                  <input type='text' onblur='verification(this)' id='fromChinese' placeholder='请输入表单名称'>
                               <label class='control-label'>表单表名</label> 
                                  <input type='text' onblur='verification(this)' id='fromEnglish' placeholder='请输入表单表名'>
                              <hr/>
                              <button class='btn btn-info' type='button' onclick='validate(this)'>确定</button>
                              <button class='btn btn-danger' type='button'>取消</button>
                            </div>
                          </form>"
                          >
                          <input  type="hidden" name="form_name"  fromChinese=""  fromEnglish="" class="leipiplugins" leipiplugins="form_name"/>
                          <legend   class="leipiplugins-orgvalue">点击填写表单名</legend>
                        </div>
                  </fieldset>
                   <a class="submt btn btn-info">提交</a>
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
        <form class="form-horizontal" id="components">
          <fieldset>
            <div class="tab-content"  style=" border: 1px solid #ccc; padding: 10px; ">
              <!--常用组件-->
              <div class="tab-pane active" id="1">
                    <!-- Text start -->
                    <div class="control-group component" rel="popover" title="文本框组件" trigger="manual"
                      data-content="
                      <form class='form'>
                        <div class='controls' style='width: 110%;' >
                            <div class='k_attribute'>
                              <label class='control-label'>组件名称（中文）</label>  
                              <input type='text' id='chineseComponent' onblur='verification(this)' placeholder='组件名称（中文）'>
                            </div>

                            <div class='k_attribute'>
                              <label class='control-label'>组件字段名称（英文）</label>  
                              <input type='text' id='englishComponent' onblur='verification(this)' placeholder='组件字段名称（英文）'>
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
                              <input type='text' id='assemblyWidth' onblur='verification(this)' placeholder='组件宽度'>
                            </div>

                            <div class='k_attribute'>
                              <label class='control-label'>组件高度</label>    
                              <input type='text' id='assemblyHeight'onblur='verification(this)' placeholder='组件高度'>
                            </div>

                            <div class='k_attribute'>
                              <label class='control-label'>数据类型</label>   
                                <dir style='display: inline-table;'>
                                  <input type='radio' id='dataType' name='clicktype' value='INT' checked='checked' /> 数字类型
                                  <input type='radio' id='dataType' name='clicktype' value='VARCHAR' /> 字符窜类型
                                   <br> 
                                  <input type='radio' id='dataType' name='clicktype' value='TEXT'/> 文本类型  
                                  <input type='radio' id='dataType' name='clicktype' value='DATE'/> 时间类型
                                </dir>
                            </div>

                            <div class='k_attribute'>
                              <label class='control-label'>组件类型</label>
                                <div style='display: inline-table;'>
                                 <input type='radio'  name='click' checked='checked' id='componentType' value='1'/> 单行文本
                                  <input type='radio'  name='click'id='componentType' value='2' /> 多行文本 
                                  <br> 
                                  <input type='radio'  name='click'id='componentType' value='6'/> 普通文本 
                                  <input type='radio'  name='click'id='componentType' value='7'/> 数字框
                                  <br> 
                                  <input type='radio'  name='click'id='componentType' value='8'/> 日期
                                  <input type='radio'  name='click'id='componentType' value='9'/> 时间
                                 
                                </div>
                             </div>
                          <hr/>
                          <button class='btn btn-info' type='button'>确定</button><button class='btn btn-danger' type='button'>取消</button>
                        </div>
                      </form>"
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
                              <input type='text' id='chineseComponent' onblur='verification(this)' placeholder='组件名称（中文）'>
                            </div>

                            <div class='k_attribute'>
                              <label class='control-label'>组件字段名称（英文）</label>  
                              <input type='text' id='englishComponent' onblur='verification(this)' placeholder='组件字段名称（英文）'>
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
                               <input type='hidden' id='drop_downbox'  value='' >
                              <textarea style='min-height: 100px' id='drop_downbox' onblur='verification(this)' >一行对应一个选项</textarea>
                            </div>
                            
                            <div class='k_attribute'>
                              <label class='control-label'>组件宽度</label>  
                              <input type='text' id='assemblyWidth' onblur='verification(this)' placeholder='组件宽度'>
                            </div>

                            <div class='k_attribute'>
                              <label class='control-label'>组件高度</label>    
                              <input type='text' id='assemblyHeight'onblur='verification(this)' placeholder='组件高度'>
                            </div>

                            <div class='k_attribute'>
                              <label class='control-label'>数据类型</label>   
                                <dir style='display: inline-table;'>
                                  <input type='radio' id='dataType' name='clicktype' value='INT' checked='checked' /> 数字类型
                                  <input type='radio' id='dataType' name='clicktype' value='VARCHAR' /> 字符窜类型
                                   <br> 
                                  <input type='radio' id='dataType' name='clicktype' value='TEXT'/> 文本类型  
                                  <input type='radio' id='dataType' name='clicktype' value='DATE'/> 时间类型
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
                              <input type='text' id='chineseComponent' onblur='verification(this)' placeholder='组件名称（中文）'>
                            </div>

                            <div class='k_attribute'>
                              <label class='control-label'>组件字段名称（英文）</label>  
                              <input type='text' id='englishComponent' onblur='verification(this)' placeholder='组件字段名称（英文）'>
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
                              <input type='text' id='assemblyWidth' onblur='verification(this)' placeholder='组件宽度'>
                            </div>

                            <div class='k_attribute'>
                              <label class='control-label'>组件高度</label>    
                              <input type='text' id='assemblyHeight'onblur='verification(this)' placeholder='组件高度'>
                            </div>

                            <div class='k_attribute'>
                              <label class='control-label'>数据类型</label>   
                                <dir style='display: inline-table;'>
                                  <input type='radio' id='dataType' name='clicktype' value='INT' checked='checked' /> 数字类型
                                  <input type='radio' id='dataType' name='clicktype' value='VARCHAR' /> 字符窜类型
                                   <br> 
                                  <input type='radio' id='dataType' name='clicktype' value='TEXT'/> 文本类型  
                                  <input type='radio' id='dataType' name='clicktype' value='DATE'/> 时间类型
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
       
      <div id="div-msg"    style="  ">
        <p style='font-size: 20px; color: #fff; '>该字段不可以为空哦！</p>
      </div>
      
    </div> <!-- /container -->

<script type="text/javascript" charset="utf-8" src="../../universalForm/Public/js/jquery-1.7.2.min.js?2024"></script>
<script type="text/javascript"> $('#div-msg').hide();//隐藏消息提示  </script>
<script type="text/javascript" src="../../js/pub.js"></script>  <!-- ajax -->  
<script type="text/javascript"  src="../../universalForm/Public/js/formbuild/bootstrap/js/bootstrap.min.js?2024"></script>
 <script type="text/javascript" src="../../universalForm/Public/js/jquery-jrumble.js"></script>  <!-- 抖动 -->

<!--<script type="text/javascript" charset="utf-8" src="../universalForm/Public/js/formbuild/leipi.form.build.plugins.js?2024"></script>-->
<script type="text/javascript" charset="utf-8" src="../../layer/layer.js" ></script>
 <link rel="stylesheet" href="../../layer/skin/default/layer.css?22">


<script type="text/javascript">
 var ptxt="  <p    style='font-size: 20px; color: #fff; '>该字段不可以为空哦！</p>";
 var ptxt1=" <p    style='font-size: 20px; color: #fff; '>下拉选项存在重复内容！</p>";
 var ptxt2=" <p    style='font-size: 20px; color: #fff; '>该组件属性值不完整请重新添加！</p>";
 var ptxt3=" <p    style='font-size: 20px; color: #fff; '>请补充完整 表单名！</p>";
 var ptxt4=" <p    style='font-size: 20px; color: #fff; '>至少添加一个组件！</p>";

$(".submt").click(function(){
    var fromEnglish=$("#legend input").attr('fromEnglish');//表单英文名
    var fromChinese= $("#legend input").attr('fromChinese');//表单中文名 
    if( typeof(fromEnglish) == "undefined" || typeof(fromChinese) == "undefined" ||  fromEnglish.length==0  || fromChinese.length==0 ){
         $('#fromNames').focus();//添加焦点
         $('#div-msg').show();//显示提示信息
         $("#div-msg").find("p").html("请补充完整 表单名！")//修改提示内容
         $("#div-msg").find("p").jrumble({ rumbleEvent: 'constant'   });//抖动提示信息框
         setTimeout(function(){$("#div-msg").empty();$("#div-msg").append(ptxt3);}, 1000);//1秒后取消抖动
         return false;
    }else{
    	validate(fromEnglish);
    }
    
    
    var num= $("#target .control-group").length;//组件个数
    var fieldInfo  = new Array();
    for (var i=0;i<num;i++){// alert("共有组件"+num);
      var objstr=$("#target .control-group").eq(i).find('input,textarea,select');
      var componentType    =objstr.attr('componentType');//组件类型      (必填)
      var chineseComponent =objstr.attr('chineseComponent');//组件名中文 (必填)
      var englishComponent =objstr.attr('englishComponent');//组件名英文 (必填)
      var theRequiredState =objstr.attr('theRequiredState');//必填状态   (必填)
      var assemblyWidth    =objstr.attr('assemblyWidth');//组件宽度      (必填)
      var assemblyHeight   =objstr.attr('assemblyHeight');//组件高度     (必填)
      var dataType         =objstr.attr('dataType');//数据类型           (必填)
      var drop_downbox     =objstr.attr('drop_downbox');//下拉框json     
      var promptValue      =objstr.attr('promptValue');//提示值
      
      var arrList = new Array();
      arrList [0] =componentType;      arrList [1] =chineseComponent;  arrList [2] =englishComponent;     
      arrList [3] =theRequiredState;   arrList [4] =assemblyWidth;     arrList [5] =assemblyHeight;
      arrList [6] =dataType;
      if($.inArray("", arrList)>-1){

          $(objstr).focus();//添加焦点
          $('#div-msg').show();//显示提示信息
          $("#div-msg").find("p").html("该组件属性值不完整请重新填写！")//修改提示内容
          $("#div-msg").find("p").jrumble({ rumbleEvent: 'constant'});//抖动提示信息框
          setTimeout(function(){$("#div-msg").empty();$("#div-msg").append(ptxt2);}, 1000);//1秒后取消抖动
          return false;
      }
      arrList[7] =drop_downbox;
      arrList[8] =promptValue;

      //拼接返回服务器端的组件属性数组；
      fieldInfo[i] = arrList;
    } 
    if(fieldInfo.length==0){//
          $('#div-msg').show();//显示提示信息
          $("#div-msg").find("p").html("至少添加一个组件")//修改提示内容
          $("#div-msg").find("p").jrumble({ rumbleEvent: 'constant'   });//抖动提示信息框
          setTimeout(function(){$("#div-msg").empty();$("#div-msg").append(ptxt4);}, 1000);//1秒后取消抖动
          return false;
    }
    //拼接返回服务器端的json 串；
    var student = new Object();
    student.fromname = fromChinese;
    student.formEnglish = fromEnglish;
    student.fieldInfo =fieldInfo;

    var json = JSON.stringify(student);
    
    console.log("json==="+json);
});

//判断必填项是否为空
 function verification(obj){
    var state=true;//默认执行隐藏信息 
    var attr_val=$(obj).val();//控件值
    var attr_id=$(obj).attr("id");//控件id
    if ($(obj).val().replace(/(^s*)|(s*$)/g, "").length ==0){ //为空
          $(obj).focus();//添加焦点
          $('#div-msg').show();//显示提示信息
          $("#div-msg").find("p").jrumble({ rumbleEvent: 'constant'   });//抖动提示信息框
          setTimeout(function(){$("#div-msg").empty();$("#div-msg").append(ptxt);}, 1000);//1秒后取消抖动
   }else{//不为空
           if(attr_id=="drop_downbox"){//下拉选择组件
              //判断选项是否有重复
              var options = attr_val.split("\n");
              var ary=$.makeArray(options);
              var nary=ary.sort();
              for(var i=0;i<ary.length;i++){
                 if(nary[i]==nary[i+1]){  state=false; }
              }
           }
          //提示消息相关
          if(state){
             $('#div-msg').hide(500);//隐藏消息提示
          }else{
             if(attr_id=="drop_downbox"){//下拉选择组件
                  $(obj).focus();//添加焦点
                  $('#div-msg').show();//显示提示信息
                  $("#div-msg").find("p").html("下拉选项存在重复内容！")//修改提示内容
                  $("#div-msg").find("p").jrumble({ rumbleEvent: 'constant' });//抖动提示信息框
                  setTimeout(function(){$("#div-msg").empty();$("#div-msg").append(ptxt1);}, 1000);//1秒后取消抖动
              }
          }
   }
}

function validate(str){//验证表单名是否存在
    var AppId="d42b46df6e583ca9a1b3e819dc42cfak";
    var UUID="<%=Suid%>";
    var AppKey="23548ad081d91ca0bdc66b22ca59cfc6";
    var token="<%=Spc_token%>";
    //var strvalue="{\"page\":\"1\",\"listnum\":\"100\",\"keyword\":\""+keyword+"\"}";
    var datapc =PostpcApi("../../jsproot/MyJsptest.jsp",AppId,AppKey,token,UUID,"");
     console.log("验证表单名是否存在");
     console.log(datapc);
     

}

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
