<%@ page trimDirectiveWhitespaces="true" %>
<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<% String MMenuId="64"; //权限%>
<%@ include file="../cookie.jsp"%>
<%@ page import="v1.web.admin.powergroup.Jurisdiction"%>
<%
		String aaaa=Jurisdiction.test();
%>



<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>HTML table Export</title>
   <link rel="stylesheet" href="../css/sy_style.css?22">	    
	    <link rel="stylesheet" href="../js/layui/css/layui.css">
		<script type="text/javascript" src="../js/jquery-1.9.1.js" ></script><!--通用jquery-->
		<script src="../js/layui/layui.js"></script>
		<script type="text/javascript" src="../js/tableExport/js/table-sort.js" ></script><!--表格排序js  css-->
		<script type="text/javascript" chartset="utf8" src="../js/tableExport/js/table_list.js " ></script><!--表格导出js  css-->
	 

  <style type="text/css">
  /**
   *  th  背景不能为黑色
   *  td  背景不能为黑色
   */
   th {
      
      background-color: white;
    }
     td {
      background-color: white;
    }
  </style>
  </head>
  <body>
  <script type="text/javascript" src="../tableExport/tableExport/tableFunction.js" type="text/javascript" chartset="utf8"></script>

	<div id="tb" class="form_top layui-form" style="">
       <input type="text" class="layui-input textbox-text" placeholder="" style="">
        <button class="layui-btn layui-btn-small  layui-btn-primary"> <i class="layui-icon"></i> 搜索</button>
        <button class="layui-btn layui-btn-small layui-btn-primary" > <i class="layui-icon">ဂ</i>刷新</button>
         <div class="layui-inline">
			      <label class="layui-form-label">导出</label>
			    <div class="layui-input-inline">
			      <select name="gender" lay-verify="required"  lay-filter="Export">
			        <option value="请选择格式" selected="">请选择格式</option>
			        <option value="CSV" > CSV </option>
			        <option value="XLS"> XLS</option>
			        <option value="XLSX"  > XLSX</option>
			        <option value="PDF" > PDF</option>
			        <option value="XML" > XML</option>
			        <option value="SQL" > SQL</option>
			        <option value="Word" > Word</option>
			        <option value="PNG" > PNG</option>
			        <option value="JSON" > JSON</option>
			        <option value="TXT" > TXT</option>
			      </select>
			    </div>
			 </div>
     </div>
    
      <table id="table" data-toggle="table" data-show-toggle="true" data-show-columns="true" >
        <thead>
            <tr>
              <th data-field="姓名"     data-sortable="true"  data-filter-control="select"  data-visible="true"   >姓名</th>
              <th data-field="年龄"     data-sortable="true"  data-filter-control="input"   data-visible="false"  >年龄</th>
              <th data-field="照片"     data-sortable="true"  data-filter-control="select"  data-visible="true"   >照片</th>
              <th data-field="手机号码" data-sortable="true"  data-filter-control="select"  data-visible="false"  >手机号码</th>
              <th data-field="身份证号码"   data-sortable="true"  data-filter-control="select"  data-visible="true"   >身份证</th>
            </tr>
          </thead>
          <tbody>
          <tr>
            <td>王旭东</td>
            <td>20</td>
            <td>
              <img src="http://zxpic.imtt.qq.com/zxpic_imtt/abstractimage/2017/07/28/0140/014030_446567244_3_192_144.jpg" style=" width:30px; height:30px; ">
            </td>
            <td>18813165488</td>
            <td>13098578841555</td>
          </tr>
          <tr>
            <td>王旭</td>
            <td>22</td>
            <td>
              <img src="http://zxpic.imtt.qq.com/zxpic_imtt/abstractimage/2017/07/28/0140/014030_446567244_3_192_144.jpg" style=" width:30px; height:30px; ">
            </td>
            <td>18813165489</td>
            <td>13098578841556</td>
          </tr>
          <tr>
            <td>旭</td>
            <td>23</td>
            <td>
              <img src="http://zxpic.imtt.qq.com/zxpic_imtt/abstractimage/2017/07/28/0140/014030_446567244_3_192_144.jpg" style=" width:30px; height:30px; ">
            </td>
            <td>18813165489</td>
            <td>13098578841546</td>
          </tr>
          <tr>
            <td>张旭</td>
            <td>25</td>
            <td>
              <img src="http://zxpic.imtt.qq.com/zxpic_imtt/abstractimage/2017/07/28/0140/014030_446567244_3_192_144.jpg" style=" width:30px; height:30px; ">
            </td>
            <td>18813165484</td>
            <td>13098578841516</td>
          </tr>
        </tbody>
      </table>
<br>
      <a href="#" onClick="doExport('#issue53a', {type: 'excel'});"> 
        XLS (issue53 I: 复杂的表格表头的行合并单元格)
      </a>
      <table id="issue53a" data-toggle="table">
      <thead>
        <tr>
          <th rowspan="2">Name</th><th colspan="2">detail1</th>
          <th colspan="4">detail2</th><th colspan="4">detail3</th>
        </tr>
        <tr>
          <th>d11</th><th>d12</th>
          <th>d21</th><th>d22</th><th>d23</th><th>d24</th>
          <th>d31</th><th>d32</th><th>d33</th><th>d34</th>
        </tr>
      </thead>
      <tbody>
        <tr>
          <td>张三</td>
          <td>11</td><td>12</td>
          <td>21</td><td>22</td><td>23</td><td>24</td>
          <td>31</td><td>32</td><td>33</td><td>34</td>
        </tr>
        <tr>
          <td>Joe Smith</td>
          <td>41</td><td>42</td>
          <td>51</td><td>52</td><td>53</td><td>54</td>
          <td>61</td><td>62</td><td>63</td><td>64</td>
        </tr>
      </tbody>
    </table>


  </body>
   <script type="text/javascript">   
      
      layui.use(['form', 'layedit', 'laydate'], function(){
		  var form = layui.form()
		  ,layer = layui.layer
		  ,layedit = layui.layedit
		  ,laydate = layui.laydate;
		  form.on('select(Export)', function(data){
			  if(data.value=="CSV"){
			  	doExport('#table', {type: 'csv'});
			 }else if(data.value=="XLS"){
			  doExport('#table', {type: 'excel'});
			 }else if(data.value=="XLSX"){
			 doExport('#table', {type: 'xlsx'});
			 }else if(data.value=="PDF"){
			 doExport('#table', {type: 'pdf', jspdf: {orientation: 'l', unit: 'mm', margins: {right: 5, left: 5, top: 10, bottom: 10}, autotable: false}});
			 }else if(data.value=="XML"){
			  doExport('#table', {type: 'xml'});
			 }else if(data.value=="SQL"){
			  doExport('#table', {type: 'sql'});
			 }else if(data.value=="Word"){
			  doExport('#table', {type: 'doc'});
			 }else if(data.value=="PNG"){
			  doExport('#table', {type: 'png'});
			 }else if(data.value=="JSON"){
			  doExport('#table', {type: 'json', tfootSelector: ''});
			 }else if(data.value=="TXT"){
			  doExport('#table', {type: 'txt'});
			 }
			});
			form.render(); 
	});     
    
    </script>  
</html>




<% if (db != null) db.close();db = null;%>