	function doExport(selector, params) {
    	var worksheetname=$("title").html();
      var options = {
        //tableName: '文件名',
        worksheetName: worksheetname////工作表标签名称
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
    
    
    
    //当前项目路径 （包含项目名）
    var curWwwPath=window.document.location.href; 
    var pathName=window.document.location.pathname; 
    var pos=curWwwPath.indexOf(pathName); 
    var localhostPaht=curWwwPath.substring(0,pos); 
    //var projectName = localhostPaht+pathName.substring(0, pathName.substr(1).indexOf('/')+1)+'/';//地址+项目名
    var  projectName =pathName.substring(0, pathName.substr(1).indexOf('/')+1)+'/';

    document.write("<script type='text/javascript' chartset='utf8' src='"+projectName+"a/pages/js/tableExport/libs/jsPDF/jspdf.min.js'                        ></script>");
    document.write("<script type='text/javascript' chartset='utf8' src='"+projectName+"a/pages/js/tableExport/libs/jsPDF-AutoTable/jspdf.plugin.autotable.js' ></script>");
    document.write("<script type='text/javascript' chartset='utf8' src='"+projectName+"a/pages/js/tableExport/libs/html2canvas/html2canvas.min.js'            ></script>");
    document.write("<script type='text/javascript' chartset='utf8' src='"+projectName+"a/pages/js/tableExport/js/tableExport.js '                             ></script>");
    document.write("<script type='text/javascript' chartset='utf8' src='"+projectName+"a/pages/js/tableExport/libs/js-xlsx/xlsx.core.min.js'                  ></script>");
    document.write("<script type='text/javascript' chartset='utf8' src='"+projectName+"a/pages/js/tableExport/libs/FileSaver/FileSaver.min.js'                ></script>");
    
    
    //监听导出选项
    layui.use(['form', 'layedit', 'laydate'], function(){
		  var form = layui.form
		  ,layer = layui.layer
		  ,layedit = layui.layedit
		  ,laydate = layui.laydate;
		  form.on('select(Export)', function(data){
			 if(data.value=="CSV"){
				 doExport('#table', {type: 'csv'});
			 }else if(data.value=="XLS"){
				 doExport('#table', {type: 'excel'});
			 }else if(data.value=="XLSX"){
				 doExport('#table', {
					 					type: 'xlsx',
					 					table: [
	                                              'width',
                                                  'height',
                                                  'background-color', 
                                                  'color',
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
                                                  'font-weight'
                                                ]
                                        }
				 );
			 }else if(data.value=="PDF"){

				 $('#table th').css("background-color","white");
				 $('#table td').css("background-color","white");
				 doExport('#table', {type: 'pdf', jspdf: {orientation: 'l', unit: 'mm', margins: {right: 0, left: 5, top: 10, bottom: 10}, autotable: false}});
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
