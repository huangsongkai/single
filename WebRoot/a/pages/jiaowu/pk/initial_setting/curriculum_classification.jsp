<%@ page trimDirectiveWhitespaces="true" %>
<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@ include file="../../../cookie.jsp"%>
<%@page import="org.apache.commons.lang3.StringUtils"%>

<%
	String semester = request.getParameter("semester");
	if(semester==null){
		semester = "";
	}


%>

<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <title></title>
  <meta name="renderer" content="webkit">
  <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
  <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
  <meta name="apple-mobile-web-app-status-bar-style" content="black"> 
  <meta name="apple-mobile-web-app-capable" content="yes">
  <meta name="format-detection" content="telephone=no">

   <link rel="stylesheet" href="../../../../pages/css/sy_style.css">	    
   <link rel="stylesheet" href="../../../js/layui2/css/layui.css">
	<script type="text/javascript" src="../../../js/jquery-1.9.1.js" ></script><!--通用jquery-->
	<script type="text/javascript" src="../../../js/layerCommon.js" ></script><!--通用jquery-->
	<script src="../../../js/layui2/layui.js"></script>
<style type="text/css"> 
  .select_move {width: 900px;margin: 30px auto;height: auto;}
  select{width: 370px;height: 230px;overflow-y: scroll;border: 1px solid #e6e6e6;} 
  .select_move_1, .select_move_2{ float:left;width: 50%;text-align: center;}
  .clear{clear: both;} 
  .my-btn{width:66px;height: 30px;border: 1px solid #d3d3d3;display: block;margin: 0 auto;
    font-size: 12px;color: #3f3f3f;background: #f4f4f4;}
  .elem-quote {margin-bottom: 30px;padding: 15px;line-height: 22px;border-left: 5px solid #009688;
    border-radius: 0 2px 2px 0;background-color: #f2f2f2;font-size:13px;}
  .elem-quote span{margin-right: 24px;}
  .lever{margin:40px 0 0 40px;}
  .lever p{margin:6px 0;}
  .lever span{color:#ff0000;}
</style> 
</head>
	<title>课程分类设置</title> 
<body>
<div id="box">
<form class="select_move">
    <blockquote class="elem-quote" style="padding: 5px">&nbsp;&nbsp;&nbsp;课程分类排课优先顺序设置</blockquote>     
    <div class="select_move_1">
     <select name="first" size="10" id="first" multiple="multiple"> 
     
     <%
     	String sql = "select id,category from dict_course_category";
     	ResultSet set = db.executeQuery(sql);
     	while(set.next()){
     
     %>
     	<option value="<%=set.getString("id") %>"><%=set.getString("category") %></option>
     
     <%}if(set!=null){set.close();} %>
     
     </select>
    </div> 
     <div class="select_move_2" style="padding-top: 30px;">
        <input class="my-btn" type="button" value="&uarr;上移" onclick="moveUp()"/><br /> 
        <input class="my-btn" type="button" value="&darr;下移" onclick="moveDown()"/>
        <br><br>
        <input class="my-btn" type="button" value="确定" onclick="setOrder('<%=semester %>')" style="margin-top: 3px;">
     </div> 
    <div class="clear"></div>
  </form> 
</div>

<br><br><br>

<script type="text/javascript">  
    
  // 选中的元素向上移动
  function moveUp() {       
    var selectElement = document.getElementById("first");
    var index = selectElement.selectedIndex; // 选中索引
    if (index === -1) {
      alert('请选择一个');
    } else {
      var y = document.createElement('option');
      y.text = selectElement.options[index].text;
      y.value = selectElement.options[index].value;
      y.setAttribute("selected","selected");
      selectElement.remove(index);
      selectElement.add(y,index-1);
    }
  }    
    
  // 选中的元素向下移动
  function moveDown() {  
    var selectElement = document.getElementById("first");
    var index = selectElement.selectedIndex; // 选中索引
    if (index === -1) {
      alert('请选择一个');
    } else {
      var y = document.createElement('option');
      y.text = selectElement.options[index].text;
      y.value = selectElement.options[index].value;
      y.setAttribute("selected","selected");
      selectElement.remove(index);
      selectElement.add(y,index+1);
    }
  } 
</script>
<script>

layui.use(['form','layer','jquery'], function(){
  var form = layui.form;
  var $ = layui.jquery;
  
	form.on('submit(formDemo)', function(data){
		
	    return true;
	});

  //单元格双击事件
  $('td').dblclick(function(event) {
  	var isLock = $(this).text();
  	isLock === '锁定' ? $(this).text('') : $(this).text('锁定');
  });


  //自定义验证规则
  form.verify({
    title: function(value){
      if(value.length < 5){
        return '标题也太短了吧';
      }
    }
    ,pass: [/(.+){6,12}$/, '密码必须6到12位']
  });

  
  form.on('select(changeval)', function(data){
  });
  
  form.on('checkbox', function(data){
    console.log(this.checked, data.elem.checked);
  });

});
</script>

<script type="text/javascript">

	function setOrder(semester){
		var arr = new Array();		//定义数组
		var arr_order = new Array();
		var i = 1;
		$("#first option").each(function(){
			var value = $(this).val();
			if(value!=''){
				arr.push(value);
				arr_order.push(i);
			}
			i++;
		})
		var category_str = arr.join();
		console.log(category_str);
		var order_str = arr_order.join();
		var url = "?ac=add&category_str="+category_str+"&order_str="+order_str+"&semester="+semester+"";
		window.location.href=url;
	}


</script>



</body>
</html>

<%
	if("add".equals(ac)){
		String category_str = request.getParameter("category_str");
		String order_str = request.getParameter("order_str");
		String semester_new = request.getParameter("semester");			//学期学号
		String [] cartegory_arr = category_str.split(",");
		String [] order_arr = order_str.split(",");
		
		boolean state = true;
		
		
		for(int i =0 ;i<cartegory_arr.length;i++){
			String insert_sql = "INSERT INTO arrage_course_category_set 	"+
					"			(                                           "+
					"			semester,                                   "+
					"			categoryid,                                 "+
					"			sort                                       "+
					"			)                                           "+
					"			VALUES                                      "+
					"			(                                           "+
					"			'"+semester_new+"',                                 "+
					"			'"+cartegory_arr[i]+"',                               "+
					"			'"+order_arr[i]+"'                                     "+
					"			);";
					
			state = db.executeUpdate(insert_sql);
			if(!state){
				break;
			}
					
		}
		if(state){
			out.println("<script>parent.layer.msg('设置成功', {icon:1,time:1000,offset:'150px'},function(){var index = parent.layer.getFrameIndex(window.name); parent.layer.close(index);}); </script>");
		}else{
			out.println("<script>parent.layer.msg('合并班级 失败');</script>");
		}
		
		
	}


%>



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
if(db!=null)db.close();db=null;if(server!=null)server=null;%>