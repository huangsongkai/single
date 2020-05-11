<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%--万能表单列表--%>
<%@page trimDirectiveWhitespaces="true" %>
<%@page contentType="text/html; charset=UTF-8" language="java"%>
<%@page import="service.util.tool.StringUtil"%><%--字符串处理方法--%>
<%@page import="net.sf.json.JSONArray"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="service.sys.Atm"%>
<%@include file="../../cookie.jsp"%>


<%
       String fieldid = request.getParameter("fieldid"); if(fieldid==null){fieldid="";}else{fieldid=fieldid.replaceAll("\\s*", "").replaceAll(" ", "");}
		
       	String sql="SELECT "+
						"froms.COLUMN_NAME as column_name,"+
						"CONCAT(froms.DATA_TYPE,IFNULL(CONCAT('(',froms.character_maximum_length,')'),'')) as data_type,"+
						"froms.column_comment as column_comment,"+
						"form_template_confg.title as title,"+
						"form_template_confg.prompt as prompt,"+
						"form_template_confg.form_regex as form_regex,"+
						"form_template_confg.tmust_input as tmust_input,"+
						"form_template_confg.teams as teams,"+
						"form_template_confg.ispost as ispost,"+
						"form_name.datafrom as form_name "+
					"FROM form_template_confg "+
						"LEFT JOIN form_name ON form_template_confg.fid=form_name.id "+
						"LEFT JOIN INFORMATION_SCHEMA.Columns froms ON froms.COLUMN_NAME=form_template_confg.strname  "+ 
					"WHERE form_template_confg.tid='"+fieldid+"' AND froms.table_name=form_name.datafrom;";
        
       	String html_str="";  //页面代码
       	ArrayList<String> list = new ArrayList<String>();
       	
       	String column_name="";//字段名称
       	String data_type="";//字段数据类型
       	String column_comment="";//字段备注
       	String form_name="";//表单名称
       	String title="";//组件名称
       	String prompt="";//组件提示
       	String form_regex="";//组件正则
       	String tmust_input="";//必填状态
       	String teams="";//组件下拉选项
       	String ispost="";//组件请求接口
       	
       	
       	//开始查询
        ResultSet customerPrs = db.executeQuery(sql);
        while(customerPrs.next()){
         	column_name=customerPrs.getString("column_name");
         	data_type  =customerPrs.getString("data_type");
         	column_comment=customerPrs.getString("column_comment");
         	title=customerPrs.getString("title");
         	prompt=customerPrs.getString("prompt");
         	form_regex=customerPrs.getString("form_regex");
         	tmust_input=customerPrs.getString("tmust_input");
         	teams=customerPrs.getString("teams");
         	ispost=customerPrs.getString("ispost");
         	form_name=customerPrs.getString("form_name");
       }if(customerPrs!=null){customerPrs.close();}
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head> 
	    <meta charset="utf-8"> 
	    <meta name="viewport" content="width=device-width, initial-scale=1"> 
	    
	    <link rel="stylesheet" href="../../js/layui/css/layui.css">
		<script type="text/javascript" src="../../js/jquery-1.9.1.js" ></script><!--通用jquery-->
		<script src="../../js/layui/layui.js"></script>
	    <title>编辑万能表单</title> 
 	</head> 
	<body>
	    <div class="layui-tab-item layui-show" >
				<form class="layui-form"  action="?ac=edit_field"  method="post" style="height: 80%; margin-top: 3%;"  >
					<fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
						<legend>数据库相关</legend>
				    </fieldset>
					<div class="layui-form-item" style="width:100%;" >
			  			<div class="layui-inline">
							 <label class="layui-form-label">字段名称</label>
					      	 <div class="layui-input-block">
					       	     <input type="text"  name="column_name" readonly="readonly" value="<%=column_name%>" class="layui-input"><%--不准许修改 --%>
					         </div>
						</div>
						<div class="layui-inline">
							<label class="layui-form-label">字段类型</label>
							<div class="layui-input-block">
								<select name="data_type" lay-filter="aihao">
									<option value="<%=data_type%>" selected=""><%=data_type%></option>
									<option value="VARCHAR(100)" >VARCHAR(100)</option>
									<option value="VARCHAR(250)">VARCHAR(250)</option>
									<option value="VARCHAR(500)">VARCHAR(500)</option>
									<option value="int(1)">int(1)</option>
									<option value="int(10)">int(10)</option>
									<option value="int(11)">int(11)</option>
									<option value="text">text</option>
									<option value="date">date</option>
									<option value="datetime">datetime</option>
									<option value="decimal(10,2)">decimal(10,2)</option>
									<option value="decimal(10,3)">decimal(10,3)</option>
									<option value="decimal(10,5)">decimal(10,5)</option>
								</select>
							</div>
						</div>
						<div class="layui-inline">
							  <label class="layui-form-label">字段说明</label>
							  <div class="layui-input-block">
						  			<input type="text" name="column_comment"  lay-verify="title" value="<%=column_comment%>" class="layui-input">
							  </div>
						</div>
				   </div>
				   <fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
						<legend>组件展示相关</legend>
				   </fieldset>
				   <div class="layui-form-item" style="width:100%;" >
						<div class="layui-inline">
							<label class="layui-form-label">组件标题</label>
					      	 <div class="layui-input-block">
					       	     <input type="text"  name="title" lay-verify="title"  value="<%=title%>" class="layui-input"><%--不准许修改 --%>
					         </div>
						</div>
						<div class="layui-inline">
							<label class="layui-form-label">组件提示</label>
					      	 <div class="layui-input-block">
					       	     <input type="text"  name="prompt"  value="<%=prompt%>" class="layui-input"><%--不准许修改 --%>
					         </div>
						</div>
						<div class="layui-inline">
							<label class="layui-form-label">组件正则</label>
					      	 <div class="layui-input-block">
					       	     <input type="text"  name="form_regex"  value="<%=form_regex%>" class="layui-input"><%--不准许修改 --%>
					         </div>
						</div>
						<div class="layui-inline">
							<label class="layui-form-label">组件必填</label>
					      	 <div class="layui-input-block">
					       	    <select name="tmust_input" >
					       	    	<% 
					       	    		String  tmust_inputsql="";
					       	    		if("1".equals(tmust_input)){
					       	    			tmust_inputsql="<option value=\"1\" selected=\"\">必填项</option><option value=\"0\"  >非必填</option>";
					       	    		}else{
					       	    			tmust_inputsql="<option value=\"1\" >必填项</option><option value=\"0\"  selected=\"\">非必填</option>";
					       	    		}
					       	    	%>
					       	    	<%=tmust_inputsql%>
								</select>
					         </div>
						</div>
						<div class="layui-inline">
							<label class="layui-form-label">请求接口</label>
					      	 <div class="layui-input-block">
					       	     <input type="text"  name="ispost"  value="<%=ispost%>" class="layui-input"><%--不准许修改 --%>
					         </div>
						</div>
						<div class="layui-inline">
							<label class="layui-form-label">组件类型</label>
							<div class="layui-input-block">
								<select name="interest" >
								  <%
										String fieldinfo="SELECT cid,ftypename,ftypename_en FROM form_type  ";
											
										ResultSet field_rs =db.executeQuery(fieldinfo);
											
										while(field_rs.next()){
								  %>
								  		<option value="<%=field_rs.getString("cid")%>"><%=field_rs.getString("ftypename")%></option>
								  <% }if(field_rs!=null){field_rs.close();}%>
								</select>
							</div>
						</div>
					</div>
					<div class="layui-form-item layui-form-text">
							<label class="layui-form-label">下拉选项</label>
					      	 <div class="layui-input-block">
					      	 	 <textarea class="layui-textarea" name="teams"  placeholder="例子：[{'option':'1','option_value':'女'},{'option':'0','option_value':'男'}]"  lay-filter="teams" ><%=teams%></textarea>
					         </div>
				    </div>
				    <input type="hidden"  name="formName"  value="<%=form_name%>" class="layui-input"><%--不准许修改 --%>
				    <input type="hidden"  name="date"  id="date" class="layui-input"><%--不准许修改 --%>
				    <input type="hidden"  name=fieldid  value="<%=fieldid%>" class="layui-input"><%--不准许修改 --%>
					<div class="layui-form-item">
						<div class="layui-input-block">
							<button class="layui-btn" lay-submit="" lay-filter="form_name">立即提交</button>
							<button type="reset" class="layui-btn layui-btn-primary">重置</button>
						</div>
					</div>
				</form>
	    </div>   
	    <script type="text/javascript">  
		     layui.use(['form', 'layer'], function(){
		     	var form = layui.form(),
					layer = layui.layer,
					layedit = layui.layedit,
					laydate = layui.laydate;
				
				//自定义验证规则
				form.verify({
					title: function(value) {
						if(value.length < 1) {
							return '标题至少得1个字符啊';
						}
					}
				});
				
				//监听提交
				form.on('submit(form_name)', function(data) {
					//JSON.stringify(data.field);
					
					var date=data.field;
					//console.log(date);
					
					if((date.teams).length==0){
						date.teams="[]";
					}
					if((date.ispost).length==0){
						date.ispost="{}";
					}
					$("#date").val(JSON.stringify(date));
					
					return true;
				});
				
				<%
					if("edit_field".equals(ac)){
						String date = request.getParameter("date"); if(date==null){date="";}else{date=date.replaceAll("\\s*", "").replaceAll(" ", "");}
						
						String columnName="";//字段名称
				       	String dataType="";//字段数据类型
				       	String columComment="";//字段备注
				       	String formTabeName="";//表单名称
				       	String titleName="";//组件名称
				       	String interest="";//组件类型
				       	String promptTile="";//组件提示
				       	String formRegex="";//组件正则
				       	String tmustLnput="";//必填状态
				       	String team="";//组件下拉选项
				       	String ispos="";//组件请求接口 
						
						JSONObject json = new JSONObject();
	        
				        try {//解析开始
							JSONArray arr = JSONArray.fromObject("[" + date + "]");
							   for(int i = 0; i < arr.size(); i++) {
								   JSONObject obj = arr.getJSONObject(i);

								   formTabeName=obj.get("formName") + "";//表单名称
								   fieldid=obj.get("fieldid") + "";//表单名称
								   
								   columnName=obj.get("column_name") + "";//字段名称
								   dataType=obj.get("data_type") + "";//字段数据类型
								   columComment=obj.get("column_comment") + "";//字段备注
								   interest=obj.get("interest") + "";//组件类型
								   titleName=obj.get("title") + "";//组件名称
								   promptTile=obj.get("prompt") + "";//组件提示
								   formRegex=obj.get("form_regex") + "";//组件正则
								   tmustLnput=obj.get("tmust_input") + "";//必填状态
								   team=obj.get("teams") + "";//组件下拉选项
								   ispos=obj.get("ispost") + "";//组件请求接口 
							   }
						 }catch(Exception e){
								out.print(e);
								return;// 程序关闭
						 }
						 
						 String Default=null;
						 
						 if(dataType.indexOf("VARCHAR")!=-1){//包含
						 		Default="DEFAULT '' ";
						 }else if(dataType.indexOf("int")!=-1){
						 		Default="DEFAULT 0 ";
						 }else if(dataType.indexOf("text")!=-1){
						 		dataType="text";
						 		Default="DEFAULT ";
						 }else if(dataType.indexOf("date")!=-1){
						 		Default="DEFAULT 00000000";
						 }else if(dataType.indexOf("datetime")!=-1){
						 		Default="DEFAULT 00000000";
						 }else if(dataType.indexOf("decimal")!=-1){
						 		Default="DEFAULT 0.0";
						 }
						 
						 
						if(db.executeUpdate("ALTER TABLE `"+formTabeName+"` CHANGE `"+columnName+"` `"+columnName+"` "+dataType+"  "+Default+" NULL  COMMENT '"+columComment+"';")){
							
							String up_sql="UPDATE form_template_confg  SET "+
																	"cid = '"+interest+"' ,"+ 
																	"ftype_name = (SELECT ftypename FROM form_type WHERE cid='"+interest+"' ), "+
																	"ftype_tag =(SELECT ftypename_en FROM form_type WHERE cid='"+interest+"' ), "+
																	"title = '"+titleName+"' ,"+ 
																	"prompt = '"+promptTile+"' ,"+ 
																	"form_regex = '"+formRegex+"' ,"+ 
																	"tmust_input = '"+tmustLnput+"' ,"+ 
																	"teams = '"+team+"' ,"+  
																	"datatype = '"+ StringUtil.replace(dataType)+"' ,"+ 
																	"ispost = '"+ispos+"' "+
																"WHERE "+
																	"tid = '"+fieldid+"' ;";
							boolean up_state=db.executeUpdate(up_sql);
							if(up_state){
								out.println( " layer.alert('修改成功！', function(index){ parent.location.reload(); layer.close(index);});   ");
							}else{
								out.println( " layer.alert('修改失败请重试！', function(index){ parent.location.reload(); layer.close(index);});   ");
							}
						}else{
							out.println( " layer.alert('修改失败请重试!', function(index){ parent.location.reload(); layer.close(index);});   ");
						}
					}
				%>
		     });  
	    </script>  
	</body> 
</html>
<%if(db!=null)db.close();db=null;if(server!=null)server=null;%>