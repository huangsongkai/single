<%@ page trimDirectiveWhitespaces="true" %>
<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@ include file="../../cookie.jsp"%>
<!DOCTYPE html> 
<html lang="zh_CN"> 
<head> 
    <meta charset="utf-8"> 
    <meta name="viewport" content="width=device-width, initial-scale=1"> 
    <title>基本信息</title> 
    <link href="../../css/base.css" rel="stylesheet">
    <link rel="stylesheet" href="../../../custom/easyui/easyui.css">
    <link href="../../css/basic_info.css" rel="stylesheet">
    
       <script type="text/javascript" src="../../../custom/jquery.min.js"></script>
    <script type="text/javascript" src="../../../custom/jquery.easyui.min.js"></script>
      <script src="../../js/layer/layer.js"></script>
    <script src="../../js/layui/layui.js"></script>
     <link rel="stylesheet" href="../../js/layui/css/layui.css">
</head> 
<body>
<style>
.container {
  position: relative;
  padding-left: 10px;
  position: relative;

}</style>




<a href="javascript:;" class="layui-btn">多窗口模式，层叠置顶</a>
  <a href="javascript:;" method="confirmTm" class="layui-btn">配置一个透明的询问框</a>
  <a href="javascript:;" method="notice" class="layui-btn">示范一个公告层</a>
  
  <a href="javascript:;" method="offset" data-type="t" class="layui-btn layui-btn-normal">上弹出</a>
  <a href="javascript:;" method="offset" data-type="r" class="layui-btn layui-btn-normal">右弹出</a>
  <a href="javascript:;" method="offset" data-type="b" class="layui-btn layui-btn-normal">下弹出</a>
  <a href="javascript:;" method="offset" data-type="l" class="layui-btn layui-btn-normal">左弹出</a>
  <a href="javascript:;" method="offset" data-type="lt" class="layui-btn layui-btn-normal">左上弹出</a>
  <a href="javascript:;" method="offset" data-type="lb" class="layui-btn layui-btn-normal">左下弹出</a>
  <a href="javascript:;" method="offset" data-type="rt" class="layui-btn layui-btn-normal">右上弹出</a>
  <a href="javascript:;" method="offset" data-type="rb" class="layui-btn layui-btn-normal">右下弹出</a>
  <a href="javascript:;" method="offset" data-type="auto" class="layui-btn layui-btn-normal">居中弹出</a>

<script>
var demo = {
  confirmTm: function(){
    layer.closeAll();
    layer.msg('大部分参数都是可以公用的<br>合理搭配，展示不一样的风格', {
      time: 20000, //20s后自动关闭
      btn: ['明白了', '知道了', '哦']
    });
  }
  ,notice: function(){
    layer.open({
      type: 1
      ,title: false //不显示标题栏
      ,closeBtn: false
      ,area: '300px;'
      ,shade: 0.8
      ,id: 'LAY_layuipro' //设定一个id，防止重复弹出
      ,resize: false
      ,content: '<div style="padding: 50px; line-height: 22px; background-color: #393D49; color: #e2e2e2; font-weight: 300;">你知道吗？亲！<br>layer ≠ layui<br><br>layer只是作为Layui的一个弹层模块，由于其用户基数较大，所以常常会有人以为layui是layerui<br><br>layer虽然已被 Layui 收编为内置的弹层模块，但仍然会作为一个独立组件全力维护、升级。<br><br>我们此后的征途是星辰大海 ^_^</div>'
      ,btn: ['火速围观', '残忍拒绝']
      ,btnAlign: 'c'
      ,moveType: 1 //拖拽模式，0或者1
      ,success: function(layero){
        var btn = layero.find('.layui-layer-btn');
        btn.find('.layui-layer-btn0').attr({
          href: 'http://www.layui.com/'
          ,target: '_blank'
        });
      }
    });
  }
  ,offset: function(othis){
    var type = othis.data('type')
    ,text = othis.text();
    
    layer.open({
      type: 1
      ,offset: type //具体配置参考：http://www.layui.com/doc/modules/layer.html#offset
      ,id: 'LAY_demo'+type //防止重复弹出
      ,content: '<div style="padding: 20px 100px;">'+ text +'</div>'
      ,btn: '关闭全部'
      ,btnAlign: 'c'
      ,shade: 0
      ,yes: function(){
        layer.closeAll();
      }
    });
  }
};

$('.layui-btn').on('click', function(){
  var othis = $(this), method = othis.attr('method');
  var demo1 = $('#demo1'), p = demo1.find('p').eq(othis.index());
  demo[method] ? demo[method].call(this, othis) : new Function('that', p.html())(this);
});
</script>





	<div class="container">
	 
		<div class="content">
			<div class="easyui-tabs1" style="width:100%;">
			
		      <div title="个人信息" data-options="closable:false" class="basic-info">
		      	
				<div class="column"><span class="current">部门信息</span></div>
		      	<table class="kv-table">
					<tbody>
						<tr>
							<td class="kv-label">所属部门</td>
							<td class="kv-content">计算机估计配件</td>
							<td class="kv-label">权限角色</td>
							<td class="kv-content" colspan="3"><a href="javascript:;">超级管理员</a></td>
						</tr>
						<tr>
							<td class="kv-label">身份证号</td>
							<td class="kv-content">05185532342342369</td>
							<td class="kv-label">身份证扫描照</td>
							<td class="kv-content" colspan="3"><a href="javascript:;">身份证.jpg</a></td>
						</tr>
						<tr>
							<td class="kv-label">工号</td>
							<td class="kv-content">1000001</td>
							<td class="kv-label">头像图片</td>
							<td class="kv-content" colspan="3"><a href="javascript:;">头像图片.jpg</a></td>
						</tr>
					</tbody>
				</table>
				<div class="column"><span class="current">账号信息</span></div>
		      	<table class="kv-table">
					<tbody>
						<tr>
							<td class="kv-label">姓名</td>
							<td class="kv-content"><%=Susername %></td>
							<td class="kv-label">昵称</td>
							<td class="kv-content"><%=Snickname %></td>
							<td class="kv-label">备注信息</td>
							<td class="kv-content"><%=Sremarks%></td>
						</tr>
						<tr>
							<td class="kv-label">联系手机</td>
							<td class="kv-content"><%=Susermob%>(作为系统登录账号)</td>
							<td class="kv-label">其他联系方式</td>
							<td class="kv-content">15158966547</td>
							<td class="kv-label">应急联系人</td>
							<td class="kv-content">1389000000</td>
						</tr>
					</tbody>
				</table>
				<table class="kv-table yes-not">
					<tbody>
						<tr>
							<td class="kv-label">QQ</td>
							<td class="kv-content" colspan="2">234234234</td>
							<td class="kv-label">微信号</td>
							<td class="kv-content" colspan="2">323445345</td>
						</tr>
					</tbody>
				</table>

		      </div>
		      <div title="公司信息" data-options="closable:false" class="basic-info">
		      <div class="column"><span class="current">公司信息</span></div>
		      	<table class="kv-table">
					<tbody>
						<tr>
							<td class="kv-label">企业名称</td>
							<td class="kv-content"><%=Scompanyname %></td>
							<td class="kv-label">企业法人</td>
							<td class="kv-content">左江胜</td>
							<td class="kv-label">注册资金(万元)</td>
							<td class="kv-content">103</td>
						</tr>
						<tr>
							<td class="kv-label">企业类型</td>
							<td class="kv-content">其他</td>
							<td class="kv-label">企业性质</td>
							<td class="kv-content">贸易商</td>
							<td class="kv-label">主公品类</td>
							<td class="kv-content">IT设备</td>
						</tr>
						<tr>
							<td class="kv-label">注册地址</td>
							<td class="kv-content" colspan="5">河南郑州</td>
						</tr>
						<tr>
							<td class="kv-label">公司地址</td>
							<td class="kv-content" colspan="5">河滨路88号</td>
						</tr>
						<tr>
							<td class="kv-label">邮编</td>
							<td class="kv-content">214000</td>
							<td class="kv-label">成立年份</td>
							<td class="kv-content" colspan="3">2016</td>
						</tr>
						<tr>
							<td class="kv-label">公司电话</td>
							<td class="kv-content">0371-91312312</td>
							<td class="kv-label">公司传真</td>
							<td class="kv-content">037161-12312123</td>
							<td class="kv-label">公司网站</td>
							<td class="kv-content">www.baidu.com</td>
						</tr>
					</tbody>
				</table>
				</div>
		      
		       
		    </div>
		</div>
	</div>
	
</body> 
</html>
 
<script type="text/javascript">
	$('.easyui-tabs1').tabs({
      tabHeight: 36
    });
    $(window).resize(function(){
    	$('.easyui-tabs1').tabs("resize");
    }).resize();
</script>
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