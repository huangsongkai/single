//当前项目路径 （包含项目名）
var curWwwPath=window.document.location.href; 
var pathName=window.document.location.pathname; 
var pos=curWwwPath.indexOf(pathName); 
var localhostPaht=curWwwPath.substring(0,pos); 
//var projectName = localhostPaht+pathName.substring(0, pathName.substr(1).indexOf('/')+1)+'/';//地址+项目名
var  projectName =pathName.substring(0, pathName.substr(1).indexOf('/')+1)+'/';
document.write("<link rel='stylesheet' type='text/css' href='"+projectName+"a/pages/js/tableExport/css/bootstrap.min.css'       >");
document.write("<link rel='stylesheet' type='text/css' href='"+projectName+"a/pages/js/tableExport/css/bootstrap-table.min.css' >");
document.write("<script type='text/javascript' chartset='utf8' src='"+projectName+"a/pages/js/tableExport/js/jquery-latest.min.js'          ></script>");
document.write("<script type='text/javascript' chartset='utf8' src='"+projectName+"a/pages/js/tableExport/js/bootstrap.min.js' 				></script>");
document.write("<script type='text/javascript' chartset='utf8' src='"+projectName+"a/pages/js/tableExport/js/bootstrap-table.min.js'        ></script>");
document.write("<script type='text/javascript' chartset='utf8' src='"+projectName+"a/pages/js/tableExport/js/tableExport.js '               ></script>");


