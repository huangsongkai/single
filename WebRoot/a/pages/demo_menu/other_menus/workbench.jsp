<!-- 工作台 -->
<%@ page trimDirectiveWhitespaces="true" %>
<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<% String MMenuId="0"; //模块编号%>
<%@ include file="../../cookie.jsp"%>
<!DOCTYPE html> 
<html lang="zh_CN"> 
<head> 
    <meta charset="utf-8"> 
    <meta name="viewport" content="width=device-width, initial-scale=1"> 
    <title>工作台</title> 

<link href="../../css/base.css" rel="stylesheet">
<link rel="stylesheet" href="../../../custom/easyui/easyui.css">
<link rel="stylesheet" href="../../css/workbench.css">
</head> 
<body>
    <div class="container">
        <div id="hd">
            
        </div>

        <div id="bd">
            <div class="bd-content">
                <div class="right-zone">
                    <div class="inform item-box">
                        <div class="inform-hd">
                            <label>通知公告</label>
                            <a href="javascript:;">更多<span>&gt;</span></a>
                        </div>
                        <ul>
                            <li>
                                <span></span>
                                <a href="javascript:;" class="ellipsis">信息管理<i></i></a>
                                <label>04-13</label>
                            </li>
                            <li>
                                <span></span>
                                <a href="javascript:;" class="ellipsis">业绩表彰大会明天上午8点开<i></i></a>
                                <label>04-12</label>
                            </li>
                            <li>
                                <span></span>
                                <a href="javascript:;" class="ellipsis">业绩表彰大会明天上午8点开</a>
                                <label>04-11</label>
                            </li>
                            <li>
                                <span></span>
                                <a href="javascript:;" class="ellipsis">业绩表彰大会明天上午8点开</a>
                                <label>04-10</label>
                            </li>
                            <li>
                                <span></span>
                                <a href="javascript:;" class="ellipsis">业绩表彰大会明天上午8点开</a>
                                <label>04-09</label>
                            </li>
                            <li>
                                <span></span>
                                <a href="javascript:;" class="ellipsis">业绩表彰大会明天上午8点开</a>
                                <label>04-08</label>
                            </li>
                        </ul>
                    </div>
                    <div class="price item-box">
                        <div class="inform-hd">
                            <label>公司制度</label>
                            <a href="javascript:;">更多<span>&gt;</span></a>
                        </div>
                        <ul>
                            <li>
                                <span></span>
                                <a href="javascript:;" class="ellipsis">本月迟到考勤通知</a>
                                <label>04-13</label>
                            </li>
                            <li>
                                <span></span>
                                <a href="javascript:;" class="ellipsis">如何做好一个二手房租赁销售</a>
                                <label>04-12</label>
                            </li>
                            <li>
                                <span></span>
                                <a href="javascript:;" class="ellipsis">新员工培训制度</a>
                                <label>04-11</label>
                            </li>
                            <li>
                                <span></span>
                                <a href="javascript:;" class="ellipsis">新员工培训制度</a>
                                <label>04-10</label>
                            </li>
                            <li>
                                <span></span>
                                <a href="javascript:;" class="ellipsis">新员工培训制度</a>
                                <label>04-09</label>
                            </li>
                            <li>
                                <span></span>
                                <a href="javascript:;" class="ellipsis">新员工培训制度</a>
                                <label>04-08</label>
                            </li>
                            <li>
                                <span></span>
                                <a href="javascript:;" class="ellipsis">新员工培训制度</a>
                                <label>04-07</label>
                            </li>
                        </ul>
                    </div>
                    <div class="attached item-box">
                        <div class="inform-hd">
                            <label>常用附件下载</label>
                            <a href="javascript:;">更多<span>&gt;</span></a>
                        </div>
                        <div class="attached-tab">
                            <a href="javascript:;" class="current item-left" attached="public-attached">公开附件</a>
                            <a href="javascript:;" class="item-right" attached="inner-attached">内部附件</a>
                        </div>
                        <ul class="public-attached">
                            <li>
                                <span></span>
                                <a href="javascript:;" class="ellipsis">常用新客户签约合同模板</a>
                            </li>
                            <li>
                                <span></span>
                                <a href="javascript:;" class="ellipsis">续费催费模板</a>
                            </li>
                            <li>
                                <span></span>
                                <a href="javascript:;" class="ellipsis">续费催费模板</a>
                            </li>
                            <li>
                                <span></span>
                                <a href="javascript:;" class="ellipsis">续费催费模板</a>
                            </li>
                            <li>
                                <span></span>
                                <a href="javascript:;" class="ellipsis">续费催费模板</a>
                            </li>
                            <li>
                                <span></span>
                                <a href="javascript:;" class="ellipsis">续费催费模板</a>
                            </li>
                        </ul>
                        <ul class="inner-attached hide">
                           <li>
                                <span></span>
                                <a href="javascript:;" class="ellipsis">解约合同模板</a>
                            </li>
                            <li>
                                <span></span>
                                <a href="javascript:;" class="ellipsis">解约合同模板2</a>
                            </li>
                            <li>
                                <span></span>
                                <a href="javascript:;" class="ellipsis">解约合同模板</a>
                            </li>
                            <li>
                                <span></span>
                                <a href="javascript:;" class="ellipsis">解约合同模板</a>
                            </li>
                            <li>
                                <span></span>
                                <a href="javascript:;" class="ellipsis">解约合同模板</a>
                            </li>
                            <li>
                                <span></span>
                                <a href="javascript:;" class="ellipsis">解约合同模板</a>
                            </li>
                        </ul>
                    </div>
                </div>
                <div class="center-part">
                    <div class="center-items todo">
                        <div class="calendar-part">
                             <div class="easyui-calendar" style="width:205px;height:231px;"></div>
                        </div>
                        <ul class="work-items clearfix">
                            <li>
                                <div class="work-inner">
                                    <div class="work-item green">
                                        <i class="iconfont">&#xe61f;</i>
                                        <span class="num">14&nbsp;<span class="unit">个</span></span>
                                        <label>待办未处理</label>
                                    </div>
                                </div>
                            </li>
                            <li>
                                <div class="work-inner">
                                    <div class="work-item red">
                                         <i class="iconfont">&#xe622;</i>
                                        <span class="num">6&nbsp;<span class="unit">条</span></span>
                                        <label>预警信息未读</label>
                                    </div>
                                </div>
                            </li>
                            <li>
                                <div class="work-inner">
                                    <div class="work-item yellow">
                                         <i class="iconfont">&#xe61d;</i>
                                        <span class="num">9&nbsp;<span class="unit">个</span></span>
                                        <label>客户催费提醒</label>
                                    </div>
                                </div>
                            </li>
                            <li>
                                <div class="work-inner">
                                    <div class="work-item blue">
                                         <i class="iconfont">&#xe621;</i>
                                        <span title="2000,00万" class="num">2000,00&nbsp;<span class="unit">万</span></span>
                                        <label>上个月完成合同金额</label>
                                    </div>
                                </div>
                            </li>
                            <li>
                                <div class="work-inner">
                                    <div class="work-item purple">
                                         <i class="iconfont">&#xe61e;</i>
                                        <span title="2000,00万" class="num">100,00&nbsp;<span class="unit">万</span></span>
                                        <label>本月已完成的合同金额</label>
                                    </div>
                                </div>
                            </li>
                            <li>
                                <div class="work-inner">
                                    <div class="work-item gray">
                                         <i class="iconfont">&#xe620;</i>
                                        <span class="num">10&nbsp;<span class="unit">个</span></span>
                                        <label>我的看房客户</label>
                                    </div>
                                </div>
                            </li>
                        </ul>
                    </div>
                    <div class="center-items chart0 clearfix">
                        <div class="chart0-item">
                            <div class="item-inner">
                                <div class="item-content">
                                    <div class="content-hd">客户比例</div>
                                    <div class="chart-chart" id="chart0"></div>
                                </div>
                            </div>
                        </div>
                        <div class="chart0-item">
                            <div class="item-inner">
                                <div class="item-content">
                                    <div class="content-hd">业绩走势</div>
                                    <div class="chart-chart" id="chart1"></div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="center-items chart1">
                        <div class="chart1-inner">
                             <div class="item-hd">询价客户</div>
                             <div class="chart1-chart" id="chart3"></div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div id="ft"></div>
    </div>
    <div class="todo-panel green-panel">
         <div class="todo-title">
            <i class="iconfont">&#xe61f;</i>
            <span class="num">14&nbsp;<span class="unit">个</span></span>
            <label>待办未处理</label>
        </div>
        <div class="todo-items">
            <ul>
                <li>
                    <span></span>
                    <a href="javascript:;" class="ellipsis">您有<span>2条</span>交房费申请未处理<i></i></a>
                    <label>04-13</label>
                </li>
                <li>
                    <span></span>
                    <a href="javascript:;" class="ellipsis">您有<span>2条</span>交房费申请未处理<i></i></a></a>
                    <label>04-13</label>
                </li>
                <li>
                    <span></span>
                    <a href="javascript:;" class="ellipsis">您有<span>0条</span>申请未处理，请及时审批<i></i></a></a>
                    <label>04-13</label>
                </li>
                <li>
                    <span></span>
                    <a href="javascript:;" class="ellipsis">您有<span>1条</span>申请未处理，请及时审批</a></a>
                    <label>04-13</label>
                </li>
                <li>
                    <span></span>
                    <a href="javascript:;" class="ellipsis">您有<span>4条</span>申请未处理，请及时审批</a></a>
                    <label>04-13</label>
                </li>
                <li>
                    <span></span>
                    <a href="javascript:;" class="ellipsis">您有<span>6条</span>申请未处理，请及时审批，未处理会导致失效</a></a>
                    <label>04-13</label>
                </li>
                <li>
                    <span></span>
                    <a href="javascript:;" class="ellipsis">您有<span>2条</span>申请未处理，请及时审批，未处理会导致失效</a></a>
                    <label>04-13</label>
                </li>
                <li>
                    <span></span>
                    <a href="javascript:;" class="ellipsis">您有<span>2条</span>申请未处理，请及时审批，未处理会导致失效</a></a>
                    <label>04-13</label>
                </li>
               
                </li>
            </ul>
        </div>
        
    </div>
    
    <div class="todo-panel yellow-panel">
         <div class="todo-title">
            <i class="iconfont">&#xe61d;</i>
            <span class="num">14&nbsp;<span class="unit">个</span></span>
            <label>客户催费提醒</label>
        </div>
        <div class="todo-items">
            <ul>
                <li>
                    <span></span>
                    <a href="javascript:;" class="ellipsis">您有<span>2条</span>交房费申请未处理</a>
                    <label>04-13</label>
                </li>
                <li>
                    <span></span>
                    <a href="javascript:;" class="ellipsis">您有<span>2条</span>交房费申请未处理</a>
                    <label>04-13</label>
                </li>
                <li>
                    <span></span>
                    <a href="javascript:;" class="ellipsis">您有<span>0条</span>申请未处理，请及时审批</a>
                    <label>04-13</label>
                </li>
                <li>
                    <span></span>
                    <a href="javascript:;" class="ellipsis">您有<span>1条</span>申请未处理，请及时审批</a>
                    <label>04-13</label>
                </li>
                <li>
                    <span></span>
                    <a href="javascript:;" class="ellipsis">您有<span>4条</span>申请未处理，请及时审批</a>
                    <label>04-13</label>
                </li>
                <li>
                    <span></span>
                    <a href="javascript:;" class="ellipsis">您有<span>6条</span>申请未处理，请及时审批，未处理会导致失效</a>
                    <label>04-13</label>
                </li>
                <li>
                    <span></span>
                    <a href="javascript:;" class="ellipsis">您有<span>2条</span>申请未处理，请及时审批，未处理会导致失效</a>
                    <label>04-13</label>
                </li>
                <li>
                    <span></span>
                    <a href="javascript:;" class="ellipsis">您有<span>2条</span>申请未处理，请及时审批，未处理会导致失效</a>
                    <label>04-13</label>
                </li>
               
                <li>o</li>
            </ul>
        </div>
        
    </div>
    <script type="text/javascript" src="../../../custom/jquery.min.js"></script>
    <script type="text/javascript" src="../../../custom/jquery.easyui.min.js"></script>
    <!-- <script type="text/javascript" src="js/menu.js"></script> -->
    <script type="text/javascript" src="../../js/echarts-all.js"></script>
    
  

    
    <script type="text/javascript">
    //chart0

    $(document).ready(function(){
        var option0 = {
            tooltip : {
                trigger: 'item',
                formatter: "{a} <br/>{b} : {c} ({d}%)"
            },
            legend: {
                orient : 'vertical',
                x : 'left',
                data:['直接客户','普通客户','签约客户','退租客户','垃圾客户'],
                show:false
            },
            toolbox: {
                show : false,
                feature : {
                    mark : {show: true},
                    dataView : {show: true, readOnly: false},
                    magicType : {
                        show: true, 
                        type: ['pie', 'funnel'],
                        option: {
                            funnel: {
                                x: '25%',
                                width: '50%',
                                funnelAlign: 'center',
                                max: 1548
                            }
                        }
                    },
                    restore : {show: true},
                    saveAsImage : {show: true}
                }
            },
            calculable : true,
            series : [
                {
                    name:'客户分析',
                    type:'pie',
                    radius : ['50%', '70%'],
                    itemStyle : {
                        normal : {
                            label : {
                                show : false
                            },
                            labelLine : {
                                show : false
                            }
                        },
                        emphasis : {
                            label : {
                                show : true,
                                position : 'center',
                                textStyle : {
                                    fontSize : '30',
                                    fontWeight : 'bold'
                                }
                            }
                        }
                    },
                    data:[
                        {value:335, name:'直接客户'},
                        {value:310, name:'普通客户'},
                        {value:234, name:'签约客户'},
                        {value:135, name:'退租客户'},
                        {value:1548, name:'无效客户'}
                    ]
                }
            ]
        };

      var myChart0 = echarts.init(document.getElementById('chart0'));
      myChart0.setOption(option0);

      //chart1
     var option1 = {
            tooltip : {
                trigger: 'axis'
            },
            legend: {
                data:['直接客户','普通客户','签约客户','退租客户','垃圾客户'],
                show:false
            },
            toolbox: {
                show : false,
                feature : {
                    mark : {show: true},
                    dataView : {show: true, readOnly: false},
                    magicType : {show: true, type: ['line', 'bar', 'stack', 'tiled']},
                    restore : {show: true},
                    saveAsImage : {show: true}
                }
            },
            calculable : true,
            xAxis : [
                {
                    type : 'category',
                    boundaryGap : false,
                    data : ['第一周','第二周','第三周','第四周','第五周','第六周','第七周']
                }
            ],
            yAxis : [
                {
                    type : 'value'
                }
            ],
            series : [
                {
                    name:'邮件营销',
                    type:'line',
                    stack: '总量',
                    data:[120, 132, 101, 134, 90, 230, 210]
                },
                {
                    name:'联盟广告',
                    type:'line',
                    stack: '总量',
                    data:[220, 182, 191, 234, 290, 330, 310]
                },
                {
                    name:'视频广告',
                    type:'line',
                    stack: '总量',
                    data:[150, 232, 201, 154, 190, 330, 410]
                },
                {
                    name:'直接访问',
                    type:'line',
                    stack: '总量',
                    data:[320, 332, 301, 334, 390, 330, 320]
                },
                {
                    name:'搜索引擎',
                    type:'line',
                    stack: '总量',
                    data:[820, 932, 901, 934, 1290, 1330, 1320]
                }
            ]
        };
        var myChart1 = echarts.init(document.getElementById('chart1'));
        myChart1.setOption(option1);

        var option3 = {
            tooltip : {
                trigger: 'axis'
            },
            legend: {
                data:['看房量'],
                show:false
            },
            toolbox: {
                show : false,
                feature : {
                    mark : {show: true},
                    dataView : {show: true, readOnly: false},
                    magicType : {show: true, type: ['line', 'bar']},
                    restore : {show: true},
                    saveAsImage : {show: true}
                }
            },
            calculable : true,
            xAxis : [
                {
                    type : 'category',
                    data : ['第一周','第二周','第三周','第四周','第5周','第6周','第7周']
                }
            ],
            yAxis : [
                {
                    type : 'value'
                }
            ],
            series : [
                {
                    name:'看房量',
                    type:'bar',
                    data:[60, 45, 73, 23, 37, 48, 18],
                    markPoint : {
                        data : [
                            {type : 'max', name: '最多'},
                            {type : 'min', name: '最少'}
                        ]
                    },
                    markLine : {
                        data : [
                            {type : 'average', name: '平均值'}
                        ]
                    }
                }
            ]
        };

        var myChart3 = echarts.init(document.getElementById('chart3'));
        myChart3.setOption(option3);         
          
        //我的待办点击事件
        $(document).on('click','.work-item.green',function(event){
            var width = (2 * $(this).width()) + 10;
            $(".green-panel").width(width -2).css({top:$(this).offset().top,left:$(this).offset().left}).show();
            event.stopPropagation();
            $(".red-panel").hide();
            $(".yellow-panel").hide();
        });  
         $(document).on('click','.work-item.red',function(event){
            var width = (2 * $(this).width()) + 10;
            $(".red-panel").width(width -2).css({top:$(this).offset().top,left:$(this).offset().left}).show();
            event.stopPropagation();
             $(".green-panel").hide();
             $(".yellow-panel").hide();
        });  
         $(document).on('click','.work-item.yellow',function(event){
            var width = (2 * $(this).width()) + 10;
            $(".yellow-panel").width(width -2).css({top:$(this).offset().top,left:$(this).offset().left}).show();
            event.stopPropagation();
             $(".green-panel").hide();
            $(".red-panel").hide();
        });  
        $(".green-panel,.red-panel,.yellow-panel").click(function(){
             event.stopPropagation();
             $(this).hide();
        });    
        $(document).click(function(){
            $(".green-panel").hide();
            $(".red-panel").hide();
            $(".yellow-panel").hide();
        });      

    });
        
    //公开附件tab事件处理
    $(".attached-tab").on("click","a",function(){
        $(this).closest(".attached-tab").find("a").removeClass("current");
        $(this).addClass("current");
        $(this).closest(".attached").find("ul").addClass("hide");   
        $(this).closest(".attached").find("ul." + $(this).attr("attached")).removeClass("hide");    
    })
                    
    </script>
</body> 
</html>
<%
//插入常用菜单日志
int   TagMenu=db.Row("SELECT COUNT(*) as row FROM  menu_worker  WHERE sysmenuid='"+PMenuId+"' and  workerid='"+Suid+"' and  companyid="+Scompanyid);
System.out.println("TagMenu="+TagMenu);
if(TagMenu==0){
  db.executeUpdate("INSERT INTO `menu_worker`(`sysmenuid`,`workerid`,`countes`,`companyid`) VALUES ('"+PMenuId+"','"+Suid+"','1','"+Scompanyid+"');"); 
}else{
  db.executeUpdate("UPDATE  `menu_worker` SET `countes`=countes+1,`usetime`=now() WHERE  sysmenuid='"+PMenuId+"' and  workerid='"+Suid+"' and  companyid="+Scompanyid);
}
 %>
<% if(db!=null)db.close();db=null;if(server!=null)server=null;%>
