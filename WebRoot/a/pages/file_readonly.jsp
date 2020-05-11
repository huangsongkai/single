<%@ page trimDirectiveWhitespaces="true" %>
<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<% String MMenuId="34"; //供应商2模块编号%>
<%@ include file="cookie.jsp"%>
<head> 
    <meta charset="utf-8"> 
    <meta name="viewport" content="width=device-width, initial-scale=1"> 
   
    <script src="js/umeditor/third-party/jquery.min.js"></script>
   <script src="js/layui/layui.js"></script>
    <link rel="stylesheet" href="js/layui/css/layui.css">
     <link rel="stylesheet" href="css/sy_style.css?22">
    <title>供应商报件</title> 
 </head> 
<body>
    <div class="container">   
  	<form class="lang_form layui-form">
    		<h4>一、基本信息</h4>
    		
    		<div class="layui-form-item">
			    <div class="layui-inline">
			      <label class="layui-form-label">业务员</label>
			      <div class="layui-input-inline">
			        <input type="text"  readonly="readonly" class="layui-input">
			      </div>
			    </div>
			    <div class="layui-inline">
			      <label class="layui-form-label">经销商</label>
			    <div class="layui-input-inline">
			      <input type="text"  readonly="readonly" class="layui-input">
			    </div>
			    </div>
			    <div class="layui-inline">
			      <label class="layui-form-label">政策类型</label>
			      <div class="layui-input-inline">
			        <input type="text"  readonly="readonly" class="layui-input">
			      </div>
			    </div>
			    <div class="layui-inline">
			      <label class="layui-form-label">银行</label>
			      <div class="layui-input-inline">
			       <input type="text"  readonly="readonly" class="layui-input">
			      </div>
			    </div>
		  </div>
    		<div class="layui-form-item">
			    <div class="layui-inline">
			      <label class="layui-form-label">姓名</label>
			      <div class="layui-input-inline">
			       <input type="text"  readonly="readonly" class="layui-input">
			      </div>
			    </div>
			    <div class="layui-inline">
			      <label class="layui-form-label">性别</label>
			      <div class="layui-input-inline">
			        <input type="text"  readonly="readonly" class="layui-input">
			      </div>
			    </div>
			    <div class="layui-inline">
			      <label class="layui-form-label">身份证号</label>
			      <div class="layui-input-inline">
			        <input type="text"  readonly="readonly" class="layui-input">
			      </div>
			    </div>
			    <div class="layui-inline">
			      <label class="layui-form-label">出生年月</label>
			      <div class="layui-input-inline">
			        <input type="text"  readonly="readonly" class="layui-input">
			      </div>
			    </div>
		  </div>
		  <div class="layui-form-item">
			    <div class="layui-inline">
			      <label class="layui-form-label">行业</label>
			      <div class="layui-input-inline">
			       <input type="text"  readonly="readonly" class="layui-input">
			      </div>
			    </div>
			    <div class="layui-inline">
			      <label class="layui-form-label">家庭住址</label>
			      <div class="layui-input-inline">
			        <input type="text"  readonly="readonly" class="layui-input">
			      </div>
			    </div>
			    <div class="layui-inline">
			      <label class="layui-form-label">联系方式</label>
			      <div class="layui-input-inline">
			        <input type="text"  readonly="readonly" class="layui-input">
			      </div>
			    </div>
			    <div class="layui-inline">
			      <label class="layui-form-label">所购车型</label>
			      <div class="layui-input-inline"  >
			        <input type="text"  readonly="readonly" class="layui-input">
			      </div>
			    </div>
		  </div>
		   <div class="layui-form-item">
			    <div class="layui-inline">
			      <label class="layui-form-label">报件车型</label>
			      <div class="layui-input-inline">
			       <input type="text"  readonly="readonly" class="layui-input">
			      </div>
			    </div>
			    <div class="layui-inline">
			      <label class="layui-form-label">征信等级</label>
			      <div class="layui-input-inline">
			        	<input type="text"  readonly="readonly" class="layui-input">
			      </div>
			    </div> 
		  </div>
		   <div class="layui-form-item newcar">
			    <div class="layui-inline">
			      <label class="layui-form-label">发票价</label>
			      <div class="layui-input-inline">
			        <input type="text"  readonly="readonly" class="layui-input">
			      </div>
			    </div>
			    <div class="layui-inline">
			      <label class="layui-form-label">家访类型</label>
			      <div class="layui-input-inline">
			      <input type="text"  readonly="readonly" class="layui-input">
			      </div>
			    </div> 
		  </div>
		  <div class="layui-form-item oldcar">
			    <div class="layui-inline">
			      <label class="layui-form-label">评估类型</label>
			      <div class="layui-input-inline">
			        <input type="text"  readonly="readonly" class="layui-input">
			      </div>
			    </div>
			    <div class="layui-inline">
			      <label class="layui-form-label">家访类型</label>
			      <div class="layui-input-inline">
			       <input type="text"  readonly="readonly" class="layui-input">
			      </div>
			    </div> 
			    <div class="layui-inline">
			      <label class="layui-form-label">预评估价</label>
			      <div class="layui-input-inline">
			        <input type="text"  readonly="readonly" class="layui-input">
			      </div>
			    </div>
			    <div class="layui-inline">
			      <label class="layui-form-label">贷款类型</label>
			      <div class="layui-input-inline">
			        <input type="text"  readonly="readonly" class="layui-input">
			      </div>
			    </div>
		  </div>
		  <h4>二、缴费明细</h4>
		  <div class="layui-form-item">
			    <div class="layui-inline">
			      <label class="layui-form-label">首付比例</label>
			      <div class="layui-input-inline">
			        <input type="text" readonly="readonly" class="layui-input">
			      </div>
			    </div>
			    <div class="layui-inline">
			      <label class="layui-form-label">上融贷款额</label>
			      <div class="layui-input-inline">
			        <input type="text" name="" readonly="readonly" class="layui-input">
			      </div>
			    </div>
			    <div class="layui-inline">
			      <label class="layui-form-label">实际贷款额</label>
			      <div class="layui-input-inline">
			       <input type="text" name="" readonly="readonly" class="layui-input">
			      </div>
			    </div>
			    <div class="layui-inline">
			      <label class="layui-form-label">月还金额</label>
			      <div class="layui-input-inline" >
			       <input type="text" name="" readonly="readonly" class="layui-input">
			      </div>
			    </div>
			 </div>
			 <div class="layui-form-item">
			    <div class="layui-inline">
			      <label class="layui-form-label">担保费</label>
			      <div class="layui-input-inline" >
			       <input type="text" name="" readonly="readonly" class="layui-input">
			      </div>
			    </div>
			    <div class="layui-inline">
			      <label class="layui-form-label">履约还款保证金</label>
			      <div class="layui-input-inline" >
			      <input type="text"  readonly="readonly" class="layui-input">
			      </div>
			    </div>
			     <div class="layui-inline">
			      <label class="layui-form-label">综合服务费</label>
			      <div class="layui-input-inline" >
			       <input type="text" name="" readonly="readonly" class="layui-input">
			      </div>
			    </div>
			     <div class="layui-inline">
			      <label class="layui-form-label">服务费</label>
			      <div class="layui-input-inline" >
			       <input type="text" name="" readonly="readonly" class="layui-input">
			      </div>
			    </div>
		  </div>
		  <div class="layui-form-item">
			    <div class="layui-inline">
			      <label class="layui-form-label">代收</label>
			      <div class="layui-input-inline" >
			       <input type="text"  readonly="readonly" class="layui-input">
			      </div>
			    </div>
			    <div class="layui-inline">
			      <label class="layui-form-label">二级返利</label>
			      <div class="layui-input-inline" >
			      <input type="text"  readonly="readonly" class="layui-input">
			      </div>
			    </div>
			     <div class="layui-inline">
			      <label class="layui-form-label">收入</label>
			      <div class="layui-input-inline" >
			       <input type="text"  readonly="readonly" class="layui-input">
			      </div>
			    </div>
			     <div class="layui-inline">
			      <label class="layui-form-label">合计</label>
			      <div class="layui-input-inline" >
			       <input type="text"  readonly="readonly" class="layui-input">
			      </div>
			    </div>
		  </div>
		   <h4>三、备注</h4>
		   <div class="layui-form-item">
		  <div class="layui-block">
			      <label class="layui-form-label file">征信报告</label>
		  	<div class="layui-box layui-upload-button file"><span class="layui-upload-icon">titlte</span></div>
		 	</div>
		  </div>

    	</form>
    </div>  
    <script type="text/javascript" src="layui/lay/dest/layui.all.js"></script>  
  
</body> 
</html>
<%
//插入常用菜单日志
int   TagMenu=db.Row("SELECT COUNT(*) as row FROM  menu_worker  WHERE sysmenuid='"+MMenuId+"' and  workerid='"+Suid+"' and  companyid="+Scompanyid);
if(TagMenu==0){
  db.executeUpdate("INSERT INTO `menu_worker`(`sysmenuid`,`workerid`,`countes`,`companyid`) VALUES ('"+MMenuId+"','"+Suid+"','1','"+Scompanyid+"');"); 
}else{
 db.executeUpdate("UPDATE  `menu_worker` SET `countes`=countes+1,`usetime`=now() WHERE  sysmenuid='"+MMenuId+"' and  workerid='"+Suid+"' and  companyid="+Scompanyid);
}
 %>
<% 
if(db!=null)db.close();db=null;if(server!=null)server=null;%>