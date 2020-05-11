<%@ page trimDirectiveWhitespaces="true" %>
<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@ include file="../../cookie.jsp"%>
<head> 
    <meta charset="utf-8"> 
    <meta name="viewport" content="width=device-width, initial-scale=1"> 
    <title><%=Mokuai%></title> 

<link href="../../css/base.css" rel="stylesheet">
<link rel="stylesheet" href="../../../custom/easyui/easyui.css">
<link rel="stylesheet" href="../../css/providers.css">

    <script type="text/javascript" src="../../../custom/jquery.min.js"></script>
    <script type="text/javascript" src="../../../custom/jquery.easyui.min.js"></script>
    <script type="text/javascript" src="../../../custom/easyui-lang-zh_CN.js"></script>
    <script type="text/javascript" src="../../js/adminpub.js"></script>


      <script src="../../js/layer/layer.js"></script>
      <script src="../../js/layui/layui.js"></script>
     <link rel="stylesheet" href="../../js/layui/css/layui.css">


</head> 
<body>




    <div class="container">
       <table id="dg" style="width:100%;height:554px" title="全部<%=Mokuai%>最新1000条"  data-options="
                rownumbers:true,
                singleSelect:false,
                autoRowHeight:false,
                pagination:true,
                fitColumns:true,
                striped:true,
                checkOnSelect:false,
                selectOnCheck:false,
                collapsible:true,
                toolbar:'#tb',
                pageSize:10">
               
            <thead> 
                <tr>
                    <th field="id" width="60">系统id</th>
                    <th field="title" width="380">代码标题</th>
                     <th field="codepath" width="400">代码路径</th>
                    <th field="codetype" width="100">代码类型</th>
                    <th field="workerid" width="100">开发者ID</th>
                    <th field="state" width="300">状态</th>
                    <th field="addtime" width="150">生成时间</th>
                   
                    
                </tr>
             </thead>
              
        </table>
      <div id="tb" style="padding:0 30px;">
        代码标题/代码内容 <input class="easyui-textbox"  id="searchword" type="text" style="width:266px;height:35px;line-height:35px;"></input>
        <button class="layui-btn" onclick="searchword()"> <i class="layui-icon">&#xe615;</i> 查询</button>
        <button class="layui-btn layui-btn-primary" onclick="chongzhi()"> <i class="layui-icon">&#x1002;</i>刷新</button>
        
        <button class="layui-btn" id="btn-add-code"><i class="layui-icon"></i> 添加代码</button>
       
        
      </div>
     
    </div>


    <script type="text/javascript">
    $("#btn-add-code").click(function(){
          layer.open({
       	  type: 2, 
       	  anim:1,
       	  maxmin: true,
       	  title :'添加一个模块代码',
       	  area: ['80%', '80%'],
       	  content: 'autocode_make.jsp' 
       	}); 
     
    	})
    	    
   
 function opensql(id){
            var sqlcontent= $("#sqid"+id).val()
            //alert(sqlcontent);
        	layer.open({
        		  type: 1
        		  ,title: false //不显示标题栏
        		  ,closeBtn: false
        		  ,area: '400px;'
        		  ,shade: 0.8
        		  ,id: 'LAY_layuipro' //设定一个id，防止重复弹出
        		  ,resize: false
        		  ,btn: ['要马上创建表吗？', '手工创建']
        		  ,btnAlign: 'c'
        		  ,moveType: 1 //拖拽模式，0或者1
        		  ,content: '<div style="padding: 50px; line-height: 22px; background-color: #393D49; color: #fff; font-weight: 300;">'+sqlcontent+'</div>'
        		  ,success: function(layero){
        		    var btn = layero.find('.layui-layer-btn');
        		    btn.find('.layui-layer-btn0').attr({
        		      href: '#'
        		      ,target: ''
        		    });
        		  }
        		});
         }
    	    
   
    </script>
  

    
    <script type="text/javascript">
     
   // alert(postjson());
    // alert(obj.threads);
  function chongzhi (){
            $('#dg').datagrid({data:getData('')}).datagrid('clientPaging');
         } 
        
   function searchword (){
           var searchword=document.getElementById("searchword").value;
         
           if(searchword.length==0){
           //  alert("请输入搜索关键词");
           //弹出一个tips层
               layer.tips('请输入搜索关键词', '.layui-btn');
            return;
            }
           
            $('#dg').datagrid({data:getData(searchword)}).datagrid('clientPaging');
     } 

    
function postjson(keyword){
       
     ajaxLoading();

    var AppId="d42b46df6e583ca9a1b3e819dc42cfak";
    var UUID="<%=Suid%>";
    var AppKey="23548ad081d91ca0bdc66b22ca59cfc6";
    var token="<%=Spc_token%>";
    var strvalue="{\"page\":\"1\",\"listnum\":\"1000\",\"keyword\":\""+keyword+"\"}";
    var datapc =PostpcApi("<%=apiurl%>",AppId,AppKey,token,UUID,strvalue);
     ajaxLoadEnd();
    return datapc;
    
  }
    
            (function($){
            function pagerFilter(data){
                if ($.isArray(data)){   // is array
                    data = {
                        total: data.length,
                        rows: data
                    }
                }
                var target = this;
                var dg = $(target);
                var state = dg.data('datagrid');
                var opts = dg.datagrid('options');
                if (!state.allRows){
                    state.allRows = (data.rows);
                }
                if (!opts.remoteSort && opts.sortName){
                    var names = opts.sortName.split(',');
                    var orders = opts.sortOrder.split(',');
                    state.allRows.sort(function(r1,r2){
                        var r = 0;
                        for(var i=0; i<names.length; i++){
                            var sn = names[i];
                            var so = orders[i];
                            var col = $(target).datagrid('getColumnOption', sn);
                            var sortFunc = col.sorter || function(a,b){
                                return a==b ? 0 : (a>b?1:-1);
                            };
                            r = sortFunc(r1[sn], r2[sn]) * (so=='asc'?1:-1);
                            if (r != 0){
                                return r;
                            }
                        }
                        return r;
                    });
                }
                var start = (opts.pageNumber-1)*parseInt(opts.pageSize);
                var end = start + parseInt(opts.pageSize);
                data.rows = state.allRows.slice(start, end);
                return data;
            }

            var loadDataMethod = $.fn.datagrid.methods.loadData;
            var deleteRowMethod = $.fn.datagrid.methods.deleteRow;
            $.extend($.fn.datagrid.methods, {
                clientPaging: function(jq){
                    return jq.each(function(){
                        var dg = $(this);
                        var state = dg.data('datagrid');
                        var opts = state.options;
                        opts.loadFilter = pagerFilter;
                        var onBeforeLoad = opts.onBeforeLoad;
                        opts.onBeforeLoad = function(param){
                            state.allRows = null;
                            return onBeforeLoad.call(this, param);
                        }
                        var pager = dg.datagrid('getPager');
                        pager.pagination({
                            onSelectPage:function(pageNum, pageSize){
                                opts.pageNumber = pageNum;
                                opts.pageSize = pageSize;
                                pager.pagination('refresh',{
                                    pageNumber:pageNum,
                                    pageSize:pageSize
                                });
                                dg.datagrid('loadData',state.allRows);
                            }
                        });
                        $(this).datagrid('loadData', state.data);
                        if (opts.url){
                            $(this).datagrid('reload');
                        }
                    });
                },
                loadData: function(jq, data){
                    jq.each(function(){
                        $(this).data('datagrid').allRows = null;
                    });
                    return loadDataMethod.call($.fn.datagrid.methods, jq, data);
                },
                deleteRow: function(jq, index){
                    return jq.each(function(){
                        var row = $(this).datagrid('getRows')[index];
                        deleteRowMethod.call($.fn.datagrid.methods, $(this), index);
                        var state = $(this).data('datagrid');
                        if (state.options.loadFilter == pagerFilter){
                            for(var i=0; i<state.allRows.length; i++){
                                if (state.allRows[i] == row){
                                    state.allRows.splice(i,1);
                                    break;
                                }
                            }
                            $(this).datagrid('loadData', state.allRows);
                        }
                    });
                },
                getAllRows: function(jq){
                    return jq.data('datagrid').allRows;
                }
            })
        })(jQuery);

        function getData(keyword){
            var obj = jQuery.parseJSON(postjson(keyword));
           //alert(JSON.stringify(obj.threads));
           //alert(obj.threads.length);
            if(parseInt(obj.resultCode)!=1000)
            {
              layer.msg("接口拒绝:"+JSON.stringify(obj.msg)+"(错误代码"+JSON.stringify(obj.resultCode)+")");
              return;
             }
           
            var rows = [];
            for(var i=0; i<obj.threads.length; i++){
                 
               rows.push({
               //ExeTime: JSON.stringify(obj.threads[i].ExeTime),
                    id: obj.threads[i].id,
                    title: obj.threads[i].title,
                    codepath: obj.threads[i].codepath,
                    codetype: obj.threads[i].codetype,
                    code: obj.threads[i].code,
                    workerid: obj.threads[i].workerid,
                    state: obj.threads[i].state,
                    addtime: obj.threads[i].addtime
                
                });
            }
            return rows;
        }
        
        $(function(){
            $('#dg').datagrid({data:getData('')}).datagrid('clientPaging');
         });   
        
       
              
    </script>
</body> 
</html>
<%
//插入常用菜单日志
int   TagMenu=db.Row("SELECT COUNT(1) as row FROM  menu_worker  WHERE sysmenuid='"+PMenuId+"' and  workerid='"+Suid+"' and  companyid="+Scompanyid);
if(TagMenu==0){
  db.executeUpdate("INSERT INTO `menu_worker`(`sysmenuid`,`workerid`,`countes`,`companyid`) VALUES ('"+PMenuId+"','"+Suid+"','1','"+Scompanyid+"');"); 
}else{
 db.executeUpdate("UPDATE  `menu_worker` SET `countes`=countes+1,`usetime`=now() WHERE  sysmenuid='"+PMenuId+"' and  workerid='"+Suid+"' and  companyid="+Scompanyid);
}
 %>
<% 
if(db!=null)db.close();db=null;if(server!=null)server=null;%>