<%@ page trimDirectiveWhitespaces="true" %>
<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@page import="v1.haocheok.commom.common"%>
<%@page import="service.dao.db.Page"%>
<%@page import="com.sun.rowset.internal.Row"%>
<%@ include file="../../cookie.jsp"%>
<%
//获取文件后面的对象 数据
	
	//获取id
	String id = request.getParameter("id");
 	common common=new common();
 	String  sql1 = "SELECT"+
				"			*,																				"+
				"			t2.class_name                                                                  "+
				"		FROM                                                                               "+
				"			arrage_coursesystem t                                                          "+
				"		LEFT JOIN class_grade t2 ON t2.id = t.class_id where t.id="+id;
 
 	System.out.println("sdasdweasddfs===="+sql1);
 	ResultSet set = db.executeQuery(sql1);
 	String course_id = "";
 	String teacher_id = "";
 	String semester = "";
 	String start_semester = "";
 	String experiment = "";
 	String semester_amongshangji = "";
 	String class_begins_weeks = "";
 	String experiment_weeks = "";
 	String computer_weeks = "";
 	String union_class_code = "";
 	String teaching_area_id = "";
 	String appoint_roomid  = "";
 	String experiment_area_id = "";
 	String strictlystate = "";
 	String schedulesort = "";
 	String timetablestate = "";
 	if(set.next()){
 		course_id = set.getString("course_id");
 		semester = set.getString("semester");
 		teacher_id = set.getString("teacher_id");
 		start_semester = set.getString("start_semester");
 		experiment = set.getString("experiment");
 		semester_amongshangji = set.getString("semester_amongshangji");
 		class_begins_weeks = set.getString("class_begins_weeks");
 		experiment_weeks = set.getString("experiment_weeks");
 		computer_weeks = set.getString("computer_weeks");
 		union_class_code = set.getString("union_class_code");
 		teaching_area_id = set.getString("teaching_area_id");
 		appoint_roomid = set.getString("appoint_roomid");
 		experiment_area_id = set.getString("experiment_area_id");
 		strictlystate = set.getString("strictlystate");
 		schedulesort = set.getString("schedulesort");
 		timetablestate = set.getString("timetablestate");
 	}if(set!=null){set.close();}
 	
	String qSql = "select * from arrage_appoint t where t.semester='"+semester+"' and t.arrange_coursesystem_id='"+id+"'";
	ResultSet qSqlRs = db.executeQuery(qSql);
	StringBuffer sb = new StringBuffer();
	while(qSqlRs.next()){
		sb.append(qSqlRs.getString("totalid")+",");
	}if(qSqlRs!=null)qSqlRs.close();

%>
<!DOCTYPE html> 
<html>
  <head>
    <meta charset="utf-8"> 
    <meta name="viewport" content="width=device-width, initial-scale=1"> 
    <title>排课数据管理指定</title>
        <link rel="stylesheet" href="../../../pages/css/sy_style.css">	    
	    <link rel="stylesheet" href="../../js/layui2/css/layui.css">
		<script type="text/javascript" src="../../js/jquery-1.9.1.js" ></script><!--通用jquery-->
		<script src="../../js/layui2/layui.js"></script>
		<script src="../../js/ajaxs.js"></script>
		<style type="text/css">
		.myinput {BACKGROUND-COLOR: #e6f3ff; BORDER-BOTTOM: #ffffff 1px groove; BORDER-LEFT: #ffffff 1px groove; BORDER-RIGHT: #ffffff 1px groove; BORDER-TOP: #ffffff 1px groove; COLOR: #000000; FONT: 24px Verdana,Geneva,sans-serif; HEIGHT: 36px; WIDTH: 60px"}
		</style>
		<style type="text/css"> 
		.select_move {width: 1000px;margin: 30px auto;height: auto;} 
		.select_move_1{ float:left;width: 40%;}
		.select_move_2{ float:left;width: 60%;text-align: center;}
		.clear{clear: both;} 
		.my-btn{width:66px;height: 30px;border: 1px solid #d3d3d3;display: block;margin: 0 auto;
		  font-size: 12px;color: #3f3f3f;background: #f4f4f4;}
		.elem-quote {margin-bottom: 30px;padding: 15px;line-height: 22px;border-left: 5px solid #009688;
		  border-radius: 0 2px 2px 0;background-color: #f2f2f2;font-size:13px;}
		.elem-quote span{margin-right: 8px;}
		.lever{margin:0px 0 0 40px;}
		.lever p{margin:6px 0;}
		.lever span{color:#ff0000;}
		.layui-btn{background: #f4f4f4;border: 1px #e6e6e6 solid;color: #3f3f3f;}
		.layui-btn:hover{color: #000000;}
		.layui-input{width: 130px;display: inline-block;}
		.layui-form-label {width: 84px;}
		td .box{width: 58px;height:37px;border:none;background: #fff;margin:-9px;}
		.layui-table tbody tr:hover{ background-color: #fff;}
		.layui-table th, .layui-table td { padding: 9px 9px;}
		.layui-select-title input{width:330px}
		</style> 
  </head>
  <body>
  <form class="layui-form" action="?ac=add" method="post">
  	<input type="hidden" name="arrageid" value="<%=id%>" />
    <blockquote class="elem-quote" style="padding: 5px">
    <input type="hidden"  value="<%=semester%>"  name="semester" />
    <input name="totalid" value="<%=sb.toString()%>" type="hidden"/>
    <input name="teacher_id" value="<%=teacher_id %>" type="hidden"	/>
    <span>[开课编号:200901000365]</span>
    <span>[开课编号:200901000365]</span>
    <span>[课程:<%=common.idToFieidName("dict_courses","course_name",course_id) %>]</span>
    <span>[教师:<%=common.idToFieidName("teacher_basic","teacher_name",teacher_id) %>]</span>
    <span>[讲课周学时:<%=start_semester %>]</span>
    <span>[实验周学时:<%=experiment %>]</span>
    <span>[上机周学时:<%=semester_amongshangji %>]</span>
    </blockquote>     
    <div class="select_move_1" style="">
        <div class="layui-form-item">
          <label class="layui-form-label">指定讲课周次</label>
          <div class="layui-input-block">
            <input type="text" value="<%=class_begins_weeks %>" name="class_begins_weeks" autocomplete="off" class="layui-input">
          </div>
        </div>
        <div class="layui-form-item">
          <label class="layui-form-label">指定实验周次</label>
          <div class="layui-input-block">
            <input type="text" value="<%=experiment_weeks %>" name="experiment_weeks" autocomplete="off" class="layui-input">
          </div>
        </div>
        <div class="layui-form-item">
          <label class="layui-form-label">指定上机周次</label>
          <div class="layui-input-block">
            <input type="text" value="<%=computer_weeks %>" name="computer_weeks" autocomplete="off" class="layui-input">
          </div>
        </div>
        <div class="layui-form-item">
            <div class="layui-input-block">
              <input type="checkbox" name="strictlystate" title="指定单双周上课" value="1" <%if("1".equals(strictlystate)){out.println("checked='checked'");} %>  lay-skin="primary">
            </div>
        </div>
        
        
        <div class="layui-form-item">
            <div class="layui-input-block">
              <input type="checkbox" name="schedulesort" title="指定优先排课" value="0" <%if("0".equals(schedulesort)){out.println("checked='checked'");} %>  lay-skin="primary">
            </div>
        </div>
        
        <div class="layui-form-item">
            <div class="layui-input-block">
              <input type="checkbox" name="timetablestate" title="指定不予排课" value="3" <%if("3".equals(timetablestate)){out.println("checked='checked'");} %>  lay-skin="primary">
            </div>
        </div>
        
        <div class="layui-form-item">
          <label class="layui-form-label">联合课码</label>
          <div class="layui-input-block">
            <input type="text" value="<%=union_class_code %>" name="union_class_code" autocomplete="off" class="layui-input">
          </div>
        </div>
        <div class="layui-form-item">
          <label class="layui-form-label">指定教学区</label>
          <div class="layui-input-block">
            <select name="teaching_area_id" lay-search lay-filter="teaching_area_id"   id="teaching_area_id" >
            	<option value="0">请选择教学区</option>
            	<%
            		String sql = "select id,teaching_area_name from teaching_area";
            		ResultSet set1 = db.executeQuery(sql);
            		while(set1.next()){
            	%>
            		<option value="<%=set1.getString("id")%>" <%if(teaching_area_id.equals(set1.getString("id"))){out.println("selected='selected'");} %>><%=set1.getString("teaching_area_name") %></option>
            	<%}if(set1!=null){set1.close();} %>
            </select>
          </div>
        </div>
        <div class="layui-form-item">
          <label class="layui-form-label">指定上课教室</label>
          <div class="layui-input-block"  >
            <select name="appoint_roomid"  id="appoint_roomid"  lay-search>
            	<option value="0">请选择上课教室</option>
            	<%
            		String sql2 = "select id,classroomname from classroom";
            		ResultSet set2 = db.executeQuery(sql2);
            		while(set2.next()){
            	%>
            		<option value="<%=set2.getString("id")%>" <%if(appoint_roomid.equals(set2.getString("id"))){out.println("selected='selected'");} %>><%=set2.getString("classroomname") %></option>
            	<%}if(set2!=null){set2.close();} %>
            
            </select>
          </div>
        </div>
    </div> 
     <div class="select_move_2">
        <!-- 表格 -->
        <table style="margin-bottom: 30px;" class="layui-table">
          <thead>
            <tr>
              <th>
                <input type="checkbox" name="" title="选择" lay-skin="primary">
              </th>
              <%
			      	String weekSql = "select * from arrage_week ";
			      	ResultSet weekRs = db.executeQuery(weekSql);
			      	ArrayList<String> bigAry = new ArrayList<String>();
			      	while(weekRs.next()){
			      		String fid = weekRs.getString("id");
			      		String weekday = weekRs.getString("weekday");
			      		bigAry.add(fid);
			      		%>
			      		 <th>
							<%=weekday %>
					      </th>
			      		<%
			      	}if(weekRs!=null)weekRs.close();
			      %>
            </tr> 
          </thead>
          <tbody>
          	<%
			  	String sectionSql = "select * from arrage_section";
			  	ResultSet sectionRs = db.executeQuery(sectionSql);
			  	while(sectionRs.next()){
			  		String ids = sectionRs.getString("id");
			  		String sectionname = sectionRs.getString("sectionname");
			  		%>
			  		  <tr>
					      <td class="changetd">
								<%=sectionname %>
					      </td>
					      <%
					      int j=0;
							while(j<bigAry.size()){
								%>
								<td class="jjj">
								<input name='classinfo' value2='<%=ids+"|"+bigAry.get(j) %>'   class='classinfo' value='<%=ids+"|"+bigAry.get(j) %>' type='hidden' >
						      </td>
							<%j++;}%>
					    </tr>
			  		<%	}if(sectionRs!=null)sectionRs.close(); %>		
            <tr>
              <td colspan="8">
                <input type="button" class="layui-btn" name="" value="删除指定">
<%--                <input type="button" class="layui-btn paike" name="" value="排课">--%>
<%--                <input type="button" class="layui-btn paike" name="" value="不排课">--%>
                <input type="radio" name="sex" value="3" title="排课" checked>
				<input type="radio" name="sex" value="1" title="不排课" >
              </td>
            </tr>
          </tbody>
        </table>
		<!-- 教师备注 -->
		<p id="beizhu">可以的额</p>
        <!-- 表格 -->
     </div> 
    <div class="clear"></div>
    <div class="lever">
        <div class="layui-form-item">
            <div class="layui-input-block"  style="margin-left: 10px;text-align: right;">
              <a class="layui-btn layui-btn-primary">排课必读帮助</a>
              <a class="layui-btn layui-btn-primary">精确指定课表</a>
              <button class="layui-btn">保存</button>
            </div>
        </div>    
    </div> 
  </form>
<script>

//获取教师备注
$(function(){
	var teacher_id = $("input[name='teacher_id']").val();				//教师id
	var semester = $("input[name='semester']").val();		//学年学期号

	var obj_str2 = {"xueqi":semester,"teacher_id":teacher_id};
	var obj2 = JSON.stringify(obj_str2)
	var ret_str2=PostAjx('../../../../Api/v1/?p=web/kebiao/getTeacherCom',obj2,'<%=Suid%>','<%=Spc_token%>');
	obj2 = JSON.parse(ret_str2);

	$("#beizhu").text("教师备注是:	"+obj2.msg);
	

})




layui.use(['form','layer','jquery'], function(){
  var form = layui.form;
  var $ = layui.jquery;

	//教学区获取教室
	form.on('select(teaching_area_id)',function(data){
		var obj_str1 = {"teaching_area_id":data.value};
		var obj1 = JSON.stringify(obj_str1)
		var ret_str1=PostAjx('../../../../Api/v1/?p=web/info/getclassroomTobuilde',obj1,'<%=Suid%>','<%=Spc_token%>');
		obj1 = JSON.parse(ret_str1);
		$("#appoint_roomid").html(obj1.data);
		form.render('select');

	})
	
  $(function(){
		var a = $('input[name="totalid"]').val();
		var as = a.split(',');
		var astate ="1";
		for(var i =0;i<as.length-1;i++){
			 $("input[name='classinfo']").each(function(){
				    var value2 = $(this).attr('value2');
				    if(as[i].indexOf(value2)==0){
				    	$(this).val(as[i]);
				    	astate = as[i].substring(as[i].lastIndexOf('|')+1);
				    	if(astate=='1'){
				    		$(this).parent().append("不排课");
					    }if(astate=='3'){
					    	$(this).parent().append("排课");
						    }
					    }
				  });
			}
			console.log(astate);
			$(":radio[name='sex'][value='" + astate + "']").attr("checked", "checked");
			form.render();
	})
	
  $('.jjj').click(function(event) {
	  	var paike = $('input[name="sex"]:checked').attr('title');
	  	var paikeid =$("input[name='sex']:checked").val();
	  	var isLock = $(this).html();
	  	var vale = $(this).find('input').attr('value2');
	  	if(isLock.indexOf(paike)>=0){
	  		$(this).html(isLock.replace(paike,''))
	  		$(this).find('input').val(vale);
	  	  	}else{
	  	  	$(this).html(isLock+paike);
	  	  $(this).find('input').val(vale+"|"+paikeid);
	  	  	  }
	  });

  form.on('radio', function(data){
	  $('.jjj').each(function(){
			var value2 = $(this).find('input').attr('value2');
			$(this).html('<input name="classinfo" value2="'+value2+'"   class="classinfo"  value="'+value2+'" type="hidden" />');
		  })
	});
  
  // 默认不排课
  $("input[value='不排课']")
    .attr('disabled','disabled')
    .css('color','#c2c2c2')
    .parents('table')
    .find("input[type='checkbox']")
    .attr('msg','不排课');
 
  $("input[value='排课']").click(function(event) {
    $(this)
      .attr('disabled','disabled')
      .css('color','#c2c2c2')
      .next()
      .removeAttr('disabled')
      .css('color','#3f3f3f')
      .parents('table')
      .find("input[type='checkbox']")
      .attr('msg','排课');
  });

  $("input[value='不排课']").click(function(event) {
    $(this)
      .attr('disabled','disabled')
      .css('color','#c2c2c2')
      .prev()
      .removeAttr('disabled')
      .css('color','#3f3f3f')
      .parents('table')
      .find("input[type='checkbox']")
      .attr('msg','不排课');
  });

  //单元格单击事件
   $('.box').click(function(event) {
        this.onfocus = this.blur();
        var checkDom = $(this).parents('table').find("input[type='checkbox']")[0];
        checkDom.checked ? $(this).val(checkDom.getAttribute('msg')) : layer.msg('请先勾选复选框');
   });

});
</script> 
    
</body> 
</html>

<%

	if("add".equals(ac)){
		//讲课周次
		String arrageid = request.getParameter("arrageid");
		String class_begins_weeks_new = request.getParameter("class_begins_weeks");
		String experiment_weeks_new = request.getParameter("experiment_weeks");
		String computer_weeks_new = request.getParameter("computer_weeks");
		String strictlystate_new = request.getParameter("strictlystate")==null?"0":request.getParameter("strictlystate");
		String union_class_code_new = request.getParameter("union_class_code");
		String teaching_area_id_new = request.getParameter("teaching_area_id")==null?"0":request.getParameter("teaching_area_id");
		String appoint_roomid_new = request.getParameter("appoint_roomid")==null?"0":request.getParameter("appoint_roomid");
		String[] classinfos=request.getParameterValues("classinfo"); 
		semester=request.getParameter("semester"); 
		String schedulesort_new = request.getParameter("schedulesort")==null?"1":request.getParameter("schedulesort");
		String timetablestate_new = request.getParameter("timetablestate")==null?"0":request.getParameter("timetablestate");
		
		if(strictlystate_new==null){
			strictlystate_new = "0";
		}
		
		
		String sql_insert = "UPDATE arrage_coursesystem 			"+
					"			SET                             	"+
					"			class_begins_weeks = '"+class_begins_weeks_new+"',	"+
					"			experiment_weeks = '"+experiment_weeks_new+"',	"+
					"			computer_weeks = '"+computer_weeks_new+"',	"+
					"			strictlystate = '"+strictlystate_new+"',	"+
					"			union_class_code = '"+union_class_code_new+"',	"+
					"			teaching_area_id = '"+teaching_area_id_new+"',	"+
					"			schedulesort = '"+schedulesort_new+"'	,		"+
					"			timetablestate = '"+timetablestate_new+"',		"+
					"			appoint_roomid = '"+appoint_roomid_new+"'	"+
					"			WHERE                           "+
					"			id = '"+arrageid+"' ;";
					
		boolean state = db.executeUpdate(sql_insert);
		if(state){
			boolean states = true;
			String delSql = "delete from arrage_appoint where semester= '"+semester+"' and arrange_coursesystem_id='"+arrageid+"'" ;
			 db.executeUpdate(delSql);
			for(int l =0;l<classinfos.length;l++){
				if(classinfos[l].split("\\|").length>2){
					String[] b = classinfos[l].split("\\|");
					String	sql12 = "insert into arrage_appoint (section_id,week_id,state,semester,totalid,arrange_coursesystem_id) values ('"+b[0]+"','"+b[1]+"','"+b[2]+"','"+semester+"','"+classinfos[l]+"','"+arrageid+"')";
					states = db.executeUpdate(sql12);
				}
			}
			
			out.println("<script>parent.layer.msg('指定设置 成功', {icon:1,time:1000,offset:'150px'},function(){var index = parent.layer.getFrameIndex(window.name); parent.layer.close(index); })</script>");
		}else{
			out.println("<script>parent.layer.msg('指定设置 失败', {icon:2,time:1000,offset:'150px'},function(){var index = parent.layer.getFrameIndex(window.name);parent.layer.close(index);})</script>");
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
long TimeEnd=Calendar.getInstance().getTimeInMillis();
System.out.println("执行时间"+ (TimeEnd-TimeStart)+"ms");
 %>
<%
if(db!=null)db.close();db=null;if(server!=null)server=null;%>