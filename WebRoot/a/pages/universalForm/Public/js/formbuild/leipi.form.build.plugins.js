/*e.preventDefault();//阻止元素发生默认的行为(例如,当点击提交按钮时阻止对表单的提交*/

function colce (act,l){
	act.popover("hide");
    l.genSource();//重置源代码
}

/* 文本框控件 text
acc  是 class="component" 的DIV 
e 是 class="leipiplugins" 的控件
*/
LPB.plugins['text'] = function (active_component,leipiplugins) {


  var plugins = 'text',popover = $(".popover");

  //下移组件弹出框
  var topnum=0;
  topnum=parseFloat(popover.css("top"))+184;
  popover.css("top",topnum);
  
  //右弹form  初始化值
  a=$(popover).find("#orgname").val($(leipiplugins).attr("title"));
  b=$(popover).find("#orgvalue").val($(leipiplugins).val());
  //console.log("b==="+b);
  //右弹form  取消控件
  $(popover).delegate(".btn-danger", "click", function(e){
	  active_component.popover("hide");
  });
  
  //右弹form  确定控件
  $(popover).delegate(".btn-info", "click", function(e){

      var inputs = $(popover).find("input");
      if($(popover).find("textarea").length>0){
          inputs.push($(popover).find("textarea")[0]);
      }
      if($(popover).find("select").length>0){
	      inputs.push($(popover).find("select")[0]);
	  }
      $.each(inputs, function(i,e){

	      var attr_name = $(e).attr("id");//属性名称
	      var attr_val = $(e).val();//属性值
	      switch(attr_name)
          {
           
          	case 'chineseComponent'://"组件中文"
          		
          			$(leipiplugins).attr("title",attr_val);//显示的
                      $(leipiplugins).attr("chineseComponent",attr_val);
                      active_component.find(".leipiplugins-orgname").text(attr_val);
          		 
              break;
          	case 'englishComponent'://"组件英文"
          		
          			$(leipiplugins).attr("englishComponent",attr_val);
          		
             break;
            case 'promptValue'://
            		
            		$(leipiplugins).attr("placeholder", attr_val);//显示的
            		$(leipiplugins).attr("promptValue", attr_val);//发给后台的
            		
              break;
            case 'theRequiredState'://必填状态
				    var array2 = $(e).prop('checked');//$('#theRequiredState'
					if(array2){
						$(leipiplugins).attr(attr_name, attr_val);
					}
              break;
            case 'dataType'://组件数据类型
						$(leipiplugins).attr(attr_name, attr_val);
			  break;
            case 'componentType'://组件类型
				    var array2 = $(e).prop('checked');//$('#theRequiredState'
					if(array2){
						$(leipiplugins).attr(attr_name, attr_val);
					}
        	  break;
            default:
                   $(leipiplugins).attr(attr_name, attr_val);
         }
      });
      if ($('#chineseComponent').val().length<=0){//组件中文名
    	  $('#chineseComponent').focus();
    	  jrumble("请输入组件名称");
      }else if($('#englishComponent').val().length<=0){////组件英文名
    	  $('#englishComponent').focus();
    	  jrumble("请输入组件名称");
      }else{
    	  colce(active_component,LPB);
    	
      }

  });
}
/* 下拉框控件 select
 *	acc  是 class="component" 的DIV 
 *	e 是 class="leipiplugins" 的控件
 */
LPB.plugins['select'] = function (active_component,leipiplugins) {
  
	var plugins = 'select',popover = $(".popover");

	//下移组件弹出框
	var topnum=0;
	    topnum=parseFloat(popover.css("top"))+218;
	    popover.css("top",topnum);
    //右弹form  初始化值
	    $(popover).find("#orgname").val($(leipiplugins).attr("title"));
	    var val = $.map($(leipiplugins).find("option"), function(e,i){return $(e).text()});
	    val = val.join("\r");
	    $(popover).find("#orgvalue").text(val);
    //右弹form  取消控件
	    $(popover).delegate(".btn-danger", "click", function(e){
		  active_component.popover("hide");
	    });
    //右弹form  确定控件
    $(popover).delegate(".btn-info", "click", function(e){
    	
    	
    	var inputs = $(popover).find("input");
	    if($(popover).find("textarea").length>0){
	         inputs.push($(popover).find("textarea")[0]);
	    }
	    if($(popover).find("select").length>0){
		      inputs.push($(popover).find("select")[0]);
		}
	    
        $.each(inputs, function(i,e){
        	var attr_name = $(e).attr("id");//属性名称
        	var attr_val = $(e).val();
        	
        	switch(attr_name)
            {
             
            	case 'chineseComponent'://"组件中文"
            		
            			$(leipiplugins).attr("title",attr_val);//显示的
                        $(leipiplugins).attr("chineseComponent",attr_val);
                        active_component.find(".leipiplugins-orgname").text(attr_val);
            		 
                  break;
            	case 'englishComponent'://"组件英文"
            		
            			$(leipiplugins).attr("englishComponent",attr_val);
            		
  	              break;
	            case 'drop_downbox'://下拉组件
	            	 
	            	 	var options = attr_val.split("\n");
	            	 		$(leipiplugins).html("");
	            	 		
	            	 		
	            	 		for(var i = 0 ;i<options.length;i++){ 
	            	 		 if(options[i] == "" || typeof(options[i]) == "undefined"){  
	            	 			options.splice(i,1);   i= i-1;  
            	             }  
	            	        }
	            	 		
	            	 		var arr = new Array();
	            	 		$.each(options, function(i,e){
		            	 		$(leipiplugins).append("\n      ");
		            	 		$(leipiplugins).append($("<option>").text(e));
		            	 		var student = new Object();
		            	 		student.option=i;
		            	 		student.option_value=e;
		            	 		var json = JSON.stringify(student);
		            	 		arr.push(json);
		            	 	});
	            	 		$(leipiplugins).attr('drop_downboxs', arr);
	              break;
	            case 'theRequiredState'://必填状态
					    var array2 = $(e).prop('checked');//$('#theRequiredState'
						if(array2){
							$(leipiplugins).attr(attr_name, attr_val);
						}
	              break;
	            case 'dataType'://组件数据类型
							$(leipiplugins).attr(attr_name, attr_val);
				  break;
	            case 'componentType'://组件类型
					    var array2 = $(e).prop('checked');//$('#theRequiredState'
						if(array2){
							$(leipiplugins).attr(attr_name, attr_val);
						}
	        	  break;
	            default:
	                   $(leipiplugins).attr(attr_name, attr_val);
	         }
      });
        
      if ($('#chineseComponent').val().length<=0){//组件中文名
    	  $('#chineseComponent').focus();
    	  jrumble("请输入组件名称");
      }else if($('#englishComponent').val().length<=0){////组件英文名
    	  $('#englishComponent').focus();
    	  jrumble("请输入组件名称");
      }else if($('#drop_downbox').val().length<=0){////组件英文名
    	  $('#drop_downbox').focus();
    	  jrumble("请输入组件名称");
      }else{
    	  var state=true;
    	  
    	  //判断下拉框是否有重复的
    	  var downbox= $('#drop_downbox').val();
    	  var ary=downbox.split("\n");
    	  
    	  var s = ary.join(",")+",";
    	  for(var i=0;i<ary.length;i++) {

	    	  if(s.replace(ary[i]+",","")==(ary[i]+",")) {
	
	        	  $('#drop_downbox').focus();
	        	  jrumble("下拉选项有重复元素：" + ary[i]);
	        	  state=false;
	    		  break;
	    	  }
    	  }
    	  if(state){
    		  colce(active_component,LPB);
    	  }
      }
  });
}





/* 上传控件 uploadfile
acc  是 class="component" 的DIV 
e 是 class="leipiplugins" 的控件
*/
LPB.plugins['uploadfile'] = function (active_component,leipiplugins) {
  var plugins = 'uploadfile',popover = $(".popover");
  //右弹form  初始化值
  $(popover).find("#orgname").val($(leipiplugins).attr("title"));
  //右弹form  取消控件
  $(popover).delegate(".btn-danger", "click", function(e){
     active_component.popover("hide");
  });
  //右弹form  确定控件
  $(popover).delegate(".btn-info", "click", function(e){
      var inputs = $(popover).find("input");
      if($(popover).find("textarea").length>0) {
          inputs.push($(popover).find("textarea")[0]);
      }
      if($(popover).find("select").length>0){
	      inputs.push($(popover).find("select")[0]);
	  }
      
      $.each(inputs, function(i,e){
          var attr_name = $(e).attr("id");//属性名称
          var attr_val = $(e).val();
          
          switch(attr_name)
          {
           
          	case 'chineseComponent'://"组件中文"
          		
          			$(leipiplugins).attr("title",attr_val);//显示的
                      $(leipiplugins).attr("chineseComponent",attr_val);
                      active_component.find(".leipiplugins-orgname").text(attr_val);
          		 
              break;
          	case 'englishComponent'://"组件英文"
          		
          			$(leipiplugins).attr("englishComponent",attr_val);
          		
	          break;
	        case 'orgname'://显示
	            	 
	        	  $(leipiplugins).attr("title",attr_val);
	              active_component.find(".leipiplugins-orgname").text(attr_val);
	          break;
            case 'theRequiredState'://必填状态
				    var array2 = $(e).prop('checked');//$('#theRequiredState'
					if(array2){
						$(leipiplugins).attr(attr_name, attr_val);
					}
	          break;
	        case 'dataType'://组件数据类型
					$(leipiplugins).attr(attr_name, attr_val);
			  break;
	        case 'componentType'://组件类型
			    var array2 = $(e).prop('checked');//$('#theRequiredState'
				if(array2){
					$(leipiplugins).attr(attr_name, attr_val);
				}
	    	  break;
	         default:
	                   $(leipiplugins).attr(attr_name, attr_val);
	      }
          
          if ($('#chineseComponent').val().length<=0){//组件中文名
        	  $('#chineseComponent').focus();
        	  jrumble("请输入组件名称");
          }else if($('#englishComponent').val().length<=0){////组件英文名
        	  $('#englishComponent').focus();
        	  jrumble("请输入组件名称");
          }else{
        		 colce(active_component,LPB);
          }
      });

  });
}