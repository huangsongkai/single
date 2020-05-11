<%@ page trimDirectiveWhitespaces="true" %>
<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<% String MMenuId="64"; //权限%>
<%@ include file="../../cookie.jsp"%>
<%@ page import="v1.web.admin.powergroup.Jurisdiction"%>
<%
		String aaaa=Jurisdiction.test();
%>

<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>HTML table Export</title>
  <script src="https://code.jquery.com/jquery-3.2.1.min.js"></script>
  <!--
  <script type="text/javascript" src="http://code.jquery.com/jquery-latest.min.js"></script>
  <script src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
  <script src="https://code.jquery.com/jquery-2.2.4.min.js"></script>
  <script src="https://code.jquery.com/jquery-3.2.1.min.js"></script>
  -->
  <script type="text/javascript" src="../tableExport/tableExport/libs/js-xlsx/xlsx.core.min.js"></script>
  <script type="text/javascript" src="../tableExport/tableExport/libs/FileSaver/FileSaver.min.js"></script>
  <!--
  <script type="text/javascript" src="../libs/pdfmake/pdfmake.min.js"></script>
  <script type="text/javascript" src="../libs/pdfmake/vfs_fonts.js"></script>
  -->
  <script type="text/javascript" src="../tableExport/tableExport/libs/jsPDF/jspdf.min.js"></script>
  <script type="text/javascript" src="../tableExport/tableExport/libs/jsPDF-AutoTable/jspdf.plugin.autotable.js"></script>
  <script type="text/javascript" src="../tableExport/tableExport/libs/html2canvas/html2canvas.min.js"></script>
  <script type="text/javascript" src="../tableExport/tableExport/libs/tableExport.js"></script>
  <style type="text/css">
   

   

   

    table  {
      border-collapse: collapse;/*表格线样式*/
    }

    table > thead > tr > td,
    table > thead > tr > th {
      background-color: gray;
      border: 1px solid #000000;
      color: white;
      padding: 0.2rem;
    }

    table > tbody > tr > td {
      border: 1px solid #000000;/*tbody  表格线样式*/
      padding: 1.2rem;
    }

   
    td{
      height:100px;
      color: #611fb5;
    }
    th {
      background-color: gray;
      color: white;
      
      
    }


  </style>
  <script type="text/javaScript">

    function doExport(selector, params) {
      var options = {
        //ignoreRow: [1,11,12,-2],
        //ignoreColumn: [0,-1],
        //pdfmake: {enabled: true},
        tableName: 'Countries',
        worksheetName: 'Countries by population'
      };

      $.extend(true, options, params);

      $(selector).tableExport(options);
    }

    function DoOnCellHtmlData(cell, row, col, data) {
      var result = "";
      if (data != "") {
        var html = $.parseHTML( data );

        $.each( html, function() {
          if ( typeof $(this).html() === 'undefined' )
            result += $(this).text();
          else if ( $(this).is("input") )
            result += $('#'+$(this).attr('id')).val();
          else if ( $(this).is("select") )
            result += $('#'+$(this).attr('id')+" option:selected").text();
          else if ( $(this).hasClass('no_export') !== true )
            result += $(this).html();
        });
      }
      return result;
    }

    function DoOnMsoNumberFormat(cell, row, col) {
      var result = "";
      if (row > 0 && col == 0)
        result = "\\@";
      return result;
    }

  </script>
</head>
<body>
  <section>
    <h1>
      HTML Table Export<br>
    </h1>
  </section>
  <section>
    <ul>
      <li>
          <a href="#" onClick="doExport('#excelstyles', 
                                        {
                                          type: 'xls',
                                          numbers: {
                                                    html: {
                                                              decimalMark: '.',
                                                              thousandsSeparator: ','
                                                          },
                                                    output: {
                                                              decimalMark: ',',
                                                              thousandsSeparator: ''
                                                            }
                                                    },
                                          excelstyles: [ 
                                                        'background-color', 
                                                        'border-bottom-color', 
                                                        'border-bottom-style', 
                                                        'border-bottom-width',
                                                        'border-top-color', 
                                                        'border-top-style', 
                                                        'border-top-width',
                                                        'border-left-color', 
                                                        'border-left-style', 
                                                        'border-left-width',
                                                        'border-right-color', 
                                                        'border-right-style', 
                                                        'border-right-width',
                                                        'font-family', 
                                                        'font-size', 
                                                        'font-weight',
                                                        'padding',
                                                        'margin',
                                                        'color',
                                                        'width',
                                                        'height'
                                                        ],
                                          onMsoNumberFormat: DoOnMsoNumberFormat, 
                                          worksheetName: '王旭东测试',

                                        });"> 
          <img src='icons/csv.png' alt="CSV" style="width:24px"> CSV</a>
      </li>
    </ul>
    
      <table id="excelstyles" data-toggle="table" data-show-toggle="true" data-show-columns="true" >
          <thead>
            <tr>
              <th lay-data="{field:'username', width:80px,height:80px}" rowspan="3">联系人</th>
              <th lay-data="{field:'amount', width:120,height:80}" rowspan="3">金额</th>
              <th lay-data="{align:'center'}" colspan="5">地址1</th>
              <th lay-data="{align:'center'}" colspan="2">地址2</th>
              <th lay-data="{fixed: 'right', width: 160,height:80, align: 'center', toolbar: '#barDemo'}" rowspan="3">操作</th>
            </tr>
            <tr>
              <th lay-data="{field:'province', width:80 ,height:80}" rowspan="2">省</th>
              <th lay-data="{field:'city', width:80,height:80}" rowspan="2">市</th>
              <th lay-data="{align:'center'}" colspan="3">详细</th>
              <th lay-data="{field:'province', width:80,height:80}" rowspan="2">省</th>
              <th lay-data="{field:'city', width:80,height:80}" rowspan="2">市</th>
            </tr>
            <tr>
              <th lay-data="{field:'street', width:120,height:80}" >街道</th>
              <th lay-data="{field:'address', width:120,height:80}">小区</th>
              <th lay-data="{field:'house', width:120,height:80}">单元</th>
            </tr>
          </thead>
           <tbody>
                <tr>
                  <td>张三</td>
                  <td>11</td>
                  <td>12</td>
                  <td>21</td>
                  <td>22</td>
                  <td>23</td>
                  <td>24</td>
                  <td>31</td>
                  <td>32</td>
                  <td>33</td>
                </tr>
                <tr>
                  <td>Joe Smith</td>
                  <td>41</td>
                  <td>42</td>
                  <td>51</td>
                  <td>52</td>
                  <td>53</td>
                  <td>54</td>
                  <td>61</td>
                  <td>62</td>
                  <td>63</td>
                </tr>
              </tbody>
        </table>


      
  
  </section>
</body>
</html>




<% if (db != null) db.close();db = null;%>