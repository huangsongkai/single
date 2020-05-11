<%@ page trimDirectiveWhitespaces="true" %>
<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<% String MMenuId="59"; //自动代码生成器模块编号%>
<%@ include file="cookie.jsp"%>
<head> 
    <meta charset="utf-8"> 
    <meta name="viewport" content="width=device-width, initial-scale=1"> 
    <title><%=Mokuai%></title> 

<link href="css/base.css" rel="stylesheet">
<link rel="stylesheet" href="../custom/easyui/easyui.css">
 
<link rel="stylesheet" href="css/providers.css">
</head> 
<body>
    <div class="container">
       <table id="dg" style="width:100%;height:554px" title="全部<%=Mokuai%>最新100条"  data-options="
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
                    <th field="uid" width="50">用户UID</th>
                    <th field="ltype" width="80">日志类型</th>
                     <th field="title" width="130">日志标题</th>
                    <th field="body" width="500">日志内容</th>
                    <th field="ip" width="60">IP地址</th>
                    <th field="addtime" width="100">时间</th>
                    
                </tr>
             </thead>
              
        </table>
      <div id="tb" style="padding:0 30px;">
        模块/用户UID: <input class="easyui-textbox" type="text" id="searchword" name=keyword style="width:266px;height:35px;line-height:35px;"></input>
      
        <a href="javascript:(0);" class="easyui-linkbutton" iconCls="icon-search" data-options="selected:true" onclick="searchword()">查询</a>
        <a href="javascript:(0);" class="easyui-linkbutton" iconCls="icon-reload" onclick="chongzhi();">重置</a>
        
      </div>
     
    </div>
    <script type="text/javascript" src="../custom/jquery.min.js"></script>
    <script type="text/javascript" src="../custom/jquery.easyui.min.js"></script>
    <script type="text/javascript" src="../custom/easyui-lang-zh_CN.js"></script>
    <script type="text/javascript" src="js/adminpub.js"></script>


    
  

    
    <script type="text/javascript">
     
    //alert(postjson());
    // alert(obj.threads);
  function chongzhi (){
            $('#dg').datagrid({data:getData('')}).datagrid('clientPaging');
         } 
        
   function searchword (){
           var searchword=document.getElementById("searchword").value;
         
           if(searchword.length==0){
             alert("请输入搜索关键词");
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
    var strvalue="{\"page\":\"1\",\"listnum\":\"100\",\"keyword\":\""+keyword+"\"}";
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
              alert("接口拒绝:"+JSON.stringify(obj.msg)+"(错误代码"+JSON.stringify(obj.resultCode)+")");
              return;
             }
           
            var rows = [];
            for(var i=0; i<obj.threads.length; i++){
                 
               rows.push({
               //ExeTime: JSON.stringify(obj.threads[i].ExeTime),
                    uid: obj.threads[i].uid,
                    ltype: obj.threads[i].ltype,
                    ip: obj.threads[i].ip,
                    body: obj.threads[i].body,
                    title: obj.threads[i].title,
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
int   TagMenu=db.Row("SELECT COUNT(*) as row FROM  menu_worker  WHERE sysmenuid='"+MMenuId+"' and  workerid='"+Suid+"' and  companyid="+Scompanyid);
if(TagMenu==0){
  db.executeUpdate("INSERT INTO `menu_worker`(`sysmenuid`,`workerid`,`countes`,`companyid`) VALUES ('"+MMenuId+"','"+Suid+"','1','"+Scompanyid+"');"); 
}else{
 db.executeUpdate("UPDATE  `menu_worker` SET `countes`=countes+1,`usetime`=now() WHERE  sysmenuid='"+MMenuId+"' and  workerid='"+Suid+"' and  companyid="+Scompanyid);
}
 %>
<% 
if(db!=null)db.close();db=null;if(server!=null)server=null;%>