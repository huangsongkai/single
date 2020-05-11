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

<style>
body{padding: 10px;}
/*#box{width: 900px;margin: 0 auto;}*/
.layui-btn{background: #f4f4f4;border: 1px #e6e6e6 solid;color: #3f3f3f;}
.layui-btn:hover{color: #000000;}
.layui-field-box {padding: 10px 0px;}
.layui-input-block {margin-left: 0px;}
.layui-btn-primary:hover{border-color: #e6e6e6;}
.lever{width: 128px;margin: 20px auto;height: 40px;}
blockquote span{margin-right: 20px;}
.layui-form-item .layui-inline{line-height: 38px;}
.layui-table tbody tr:hover{ background-color: #fff;}
.layui-table tbody td, .layui-table thead th{ text-align: center;}
</style>
</head>
	<title>排课顺序设置</title> 
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
	<blockquote class="layui-elem-quote" style="padding: 5px">
		&nbsp;&nbsp;&nbsp;
		课程大类排课顺序设置:<span style="margin-left: 15px;">[学年学期号：<%=semester %>]</span>
	</blockquote>
	<div class="layui-field-box">
	    <form class="layui-form" action="?ac=sequence" method="post">
			<input name="semester" value="<%=semester%>" type="hidden"/>
			<input name="totalid" value="<%=sb.toString()%>" type="hidden"/>
			
			<table class="layui-table">
				<thead>
					<tr>
						<th></th>
						<%
							String bigClassSql = "SELECT * FROM dict_courses_class_big t where t.show_mark=1 ";
							ResultSet bigClassSet = db.executeQuery(bigClassSql);
							String[] a = new String[]{};
							ArrayList<String> bigAry = new ArrayList<String>();
							while(bigClassSet.next()){
								String name = bigClassSet.getString("courses_bigclass_name");
								String id = bigClassSet.getString("id");
								bigAry.add(id);
								out.println("<th>"+name+"<input name='bigclass' value='"+id+","+name+"' type='hidden'></th>");
							}if(bigClassSet!=null)bigClassSet.close();
						%>
					</tr>
					</thead>
					<tbody>
					<%
						String  xiaoClassSql = "SELECT * FROM arrage_section";
						ResultSet xiaoClassSet = db.executeQuery(xiaoClassSql);
						while(xiaoClassSet.next()){
							String xiaoname = xiaoClassSet.getString("sectionname");
							String id = xiaoClassSet.getString("id");
							String htm = "";
							htm = "<tr><td>"+xiaoname+"<input name='xiaoclass' value='"+id+","+xiaoname+"' type='hidden'></td>";
							int j=0;
							while(j<bigAry.size()){
								htm = htm + "<td><div class='layui-inline'><input name='classinfo' value2='"+id+"|"+bigAry.get(j)+"'   class='classinfo' value='"+id+"|"+bigAry.get(j)+"' type='hidden' > "+
															    "<div class='layui-input-inline' style='width: 80px;'>"+
															      	"<select name='quiz'  lay-verType='tips' lay-filter='changeval'>"+
															          "<option value=' '> </option>"+
															          "<option value='1'>一级</option>"+
															          "<option value='2'>二级</option>"+
															          "<option value='3'>三级</option>"+
															          "<option value='4'>四级</option>"+
															          "<option value='5'>锁定</option>"+
															        "</select>"+
															    "</div>"+
														    "</div></td>";
								j++;
							}
							htm = htm + "</tr>";
							out.println(htm);
						}if(xiaoClassSet!=null)xiaoClassSet.close();
					%>
				</tbody>
			</table>
			<!-- 表格 -->
			<!-- 底部按钮 -->
			<div class="layui-form-item">
			    <div class="layui-input-block" style="width: 400px;margin:40px auto;">
			      <input id="fenGe" type="button" value="排课先后顺序设置" class="layui-btn">
			      <input id="fenGe2" type="button" value="课程分类设置" class="layui-btn" >
			      <button class="layui-btn" lay-submit lay-filter="formDemo">确定</button>
			    </div>
		    </div>
		</form>
    </div>
</div>

<br><br><br>

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
  	 $('#fenGe').click(function(event) {
  		layer.open({
			  type: 2,
			  title: '排课先后顺序设置',
			  maxmin:1,
			  offset: 't',
			  shade: 0.5,
			  area: ['100%', '530px'],
			  content: 'set_up_order.jsp' 
			});
	  });
  	 $('#fenGe2').click(function(event) {
  		layer.open({
			  type: 2,
			  title: '课程分类设置',
			  maxmin:1,
			  offset: 't',
			  shade: 0.5,
			  area: ['100%', '530px'],
			  content: 'curriculum_classification.jsp?semester=<%=semester%>' 
			});
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