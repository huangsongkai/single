<%@ page trimDirectiveWhitespaces="true" %>
<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@ include file="../../../cookie.jsp"%>
<%@page import="org.apache.commons.lang3.StringUtils"%>
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
	<title>排课先后顺序设置</title> 
<body>
	<%
	String semester = request.getParameter("semester"); if(semester==null){semester="";}
	
	String qSql = "select * from arrage_course_order t where t.semester='"+semester+"'";
	ResultSet qSqlRs = db.executeQuery(qSql);
	StringBuffer sb = new StringBuffer();
	while(qSqlRs.next()){
		sb.append(qSqlRs.getString("totalid")+",");
	}if(qSqlRs!=null)qSqlRs.close();
	%>
<div id="box">
<form class="select_move">
    <blockquote class="elem-quote" style="padding: 5px">&nbsp;&nbsp;&nbsp;排课先后顺序设置</blockquote>     
    <div class="select_move_1">
     <select name="first" size="10" id="first" multiple="multiple"> 
      <option value="宝马">宝马</option> 
      <option value="丰田">丰田</option> 
      <option value="奥迪">奥迪</option> 
      <option value="凯迪拉克">凯迪拉克</option> 
      <option value="现代">现代</option> 
      <option value="奔驰">奔驰</option> 
      <option value="法拉利">法拉利</option>         
     </select>
    </div> 
     <div class="select_move_2" style="padding-top: 30px;">
        <input class="my-btn" type="button" value="&uarr;上移" onclick="moveUp()"/><br /> 
        <input class="my-btn" type="button" value="&darr;下移" onclick="moveDown()"/>
        <br><br>
        <input class="my-btn" type="button" value="恢复默认" style="margin-top: 3px;">
     </div> 
    <div class="clear"></div>
    <!-- 下面 -->
    <div class="lever">      
      <p style="font-size: 14px;">
        <span>升序：</span>从小到大或从少到多
      </p>
      <p style="font-size: 14px;">
        <span>降序：</span>从大到小或从多到少
      </p>
      <p style="font-size: 14px;">
        <span>已指定</span>为大，<span>未指定</span>为小  
      </p>
      <p style="font-size: 14px;">
        <span>双击</span>列表中的某一项，改变升序或降序
      </p> 
           
    </div> 
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

	$(function(){
			var a = $('input[name="totalid"]').val();
			var as = a.split(',');
			for(var i =0;i<as.length-1;i++){
				 $("input[name='classinfo']").each(function(){
					    var value2 = $(this).attr('value2');
					    if(as[i].indexOf(value2)==0){
					    	var d = as[i].substr(as[i].lastIndexOf('|')+1);
					    	$(this).val(as[i]);
						    $(this).next().find('select').val(d);
						    }
					  });
				}
			form.render('select');  
		})
  //单元格双击事件
  $('td').dblclick(function(event) {
  	var isLock = $(this).text();
  	isLock === '锁定' ? $(this).text('') : $(this).text('锁定');
  });

  //课表分割设置
  // $('#fenGe').click(function(event) {
  //  		layer.open({
		//   type: 2, 
		//   content: 'ke_baio_fen_ge.html',
		//   area: ['900px', '600px'],
		//   maxmin: true
		// });
  //  });

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
    var b = $(this).parent().parent().parent().parent().find('.classinfo').attr('value2');
    b = b+"|"+data.value;
     $(this).parent().parent().parent().parent().find('.classinfo').val(b);
  });
  
  form.on('checkbox', function(data){
    console.log(this.checked, data.elem.checked);
  });

  <%
	if("sequence".equals(ac)){
		String[] classinfos=request.getParameterValues("classinfo"); 
		 semester = request.getParameter("semester");
			boolean states = false;
			for(int l =0;l<classinfos.length;l++){
				if(classinfos[l].split("\\|").length>2){
					String[] b = classinfos[l].split("\\|");
					String checkSql = "select count(id) row from arrage_course_order t where t.section_id="+b[0]+" and class_big_id = "+b[1]+" and semester= '"+semester+"'" ;
					System.out.println("checkSql "+checkSql);
					String sql ="";
					if(db.Row(checkSql)>0){
						sql = "update arrage_course_order set state="+b[2]+",totalid='"+classinfos[l]+"' where section_id="+b[0]+" and class_big_id = "+b[1]+" and semester= '"+semester+"'"  ;
					}else{
					 sql = "insert into arrage_course_order (section_id,class_big_id,state,semester,totalid) values ('"+b[0]+"','"+b[1]+"','"+b[2]+"','"+semester+"','"+classinfos[l]+"')";
					}
					System.out.println("sql   "+sql);
					states = db.executeUpdate(sql);
				}
			}
			if(states==true){
				out.println("successMsg('成功');");
			}else{
				out.println("errorMsg('失败');");
			}
	}
%>
});
</script>

</body>
</html>

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