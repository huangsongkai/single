<%@ page trimDirectiveWhitespaces="true" %>
<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<% String MMenuId="34"; //供应商2模块编号%>
<%@ include file="cookie.jsp"%>
<head> 
    <meta charset="utf-8"> 
    <meta name="viewport" content="width=device-width, initial-scale=1"> 
     <link rel="stylesheet" href="add/dev/css/index.css" />
  <link rel="stylesheet" href="js/layui/css/layui.css" />
    <title>供应商报件</title> 
</head> 
  <body>
  <div class="tab-body">
   <p class="page-tab"><span class="layui-breadcrumb" lay-separator="&gt;"><a href="">首页</a><a><cite>订单列表</cite></a></span></p>
   <div class="handle-box">
    <ul>
     <li class="handle-item"><span class="layui-form-label">输入用户名：</span>
      <div class="layui-input-inline">
       <input type="text" autocomplete="off" placeholder="请输入搜索条件" class="layui-input" />
      </div><button class="layui-btn mgl-20">查询</button><button class="layui-btn mgl-20" id="refresh">刷新</button><span class="fr"><a class="layui-btn layui-btn-danger radius btn-delect" id="btn-delect-all"><i class="linyer icon-delect"></i> 批量删除</a><a class="layui-btn btn-add btn-default" id="btn-adduser"><i class="linyer icon-add"></i> 添加订单</a></span></li>
    </ul>
   </div>
   <div class="layui-clear">
    <div class="tableTools fr"></div>
   </div>
   <table class="table-box table-sort" id="orderTable">
    <thead>
     <tr>
      <th><input type="checkbox" class="btn-checkall fly-checkbox" /></th>
      <th>订单号</th>
      <th>用户名</th>
      <th>性别</th>
      <th>手机</th>
      <th>身份证号码</th>
      <th>邮箱</th>
      <th>地址</th>
      <th>加入时间</th>
      <th>状态</th>
      <th>操作</th>
     </tr>
    </thead>
    <tbody></tbody>
    <tfoot>
     <tr>
      <th><input type="checkbox" class="btn-checkall fly-checkbox" /></th>
      <th>订单号</th>
      <th>用户名</th>
      <th>性别</th>
      <th>手机</th>
      <th>身份证号码</th>
      <th>邮箱</th>
      <th>地址</th>
      <th>加入时间</th>
      <th>状态</th>
      <th>操作</th>
     </tr>
    </tfoot>
   </table>
  </div>
  <script src="layui/layui.js"></script>
  <script src="add/common.js"></script>
  <script src="add/order.js"></script>
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