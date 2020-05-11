package v1.web.file; 
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Date;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONObject;
import service.common.SetupConf;
import service.dao.db.Jdbc;
import service.dao.db.Page;
import service.file.FileAc;
import service.sys.Atm;

import com.jspsmart.upload.File;
import com.jspsmart.upload.Files;
import com.jspsmart.upload.SmartUpload;

/**
 * 
 * @author Administrator
 * @date 2017-8-13
 * @file_name Report_Upservlet.java
 * @Remarks   pc_端     接收 附件图片
 */
@SuppressWarnings("serial")
public class Report_Upservlet extends HttpServlet {

    public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request, response);
    }
    //上传方法
    public void doPost(HttpServletRequest request, HttpServletResponse response)throws ServletException, IOException {
    	//获取资源
        Jdbc db = new Jdbc();
        Page page = new Page();
        
        long TimeStart = new Date().getTime();// 程序开始时间，统计效率
        
		String classname = " pc_端   -上传附件";
		String claspath = this.getClass().getName();
        
        //创建文件方法
        FileAc fileAc = new FileAc();
        
        //设置编码格式
        request.setCharacterEncoding("utf-8");
        response.setCharacterEncoding("utf-8");
        PrintWriter out = response.getWriter();
        
        // 获取用户传来的参数
		String ip = request.getHeader("x-real-ip"); if (ip == null || ip.length() == 0) {ip = request.getRemoteAddr();}
		String AppId = request.getHeader("X-AppId");  if(AppId==null){AppId="";}  // 标明正在运行的是哪个App程序
		String AppKey = request.getHeader("X-AppKey");if(AppKey==null){AppKey="";}  // 授权鉴定终端
		String Token=request.getHeader("Token");      if(Token==null){Token="";} 
		String UUID = request.getHeader("X-UUID");    if(UUID==null){UUID="";}   //必填设备串码
		String GPS=request.getHeader("X-GPS");        if(GPS==null){GPS="";} // GPS定位信息
		String GPSLocal=request.getHeader("X-GPSLocal");if(GPSLocal==null){GPSLocal="";}   // GPS定位信息
		String AppKeyType = "";
        
		 String uid ="";//用户id
		
        //获取时间   格式nnyy
        String ny=Page.ym();      //时间年月简写
        
        //设置路径
        String up_Path = "";	  //上传路径
        
        up_Path=SetupConf.get("img_path"); // 获得上传路径
		
		//判断有没有改文件夹 没有就创建
		fileAc.MDir(up_Path+ny, 0);//创建文件夹
		up_Path=up_Path+ny+"\\";
    	
		//返回手机端 json对象
		JSONObject json = new JSONObject();
        
        //第一步:新建一个对象
        SmartUpload smart=new SmartUpload();
        //第二步:初始化
        smart.initialize(super.getServletConfig(),request,response);
        
        //第三步:设置上传文件的类型
        smart.setAllowedFilesList("jpg,png,gif,txt,mp4,mp3");
        
    	//附件集合地址
        ArrayList<String> list = new ArrayList<String>();
        //附件id
        ArrayList<String> list_id = new ArrayList<String>();
        try {
            //第三步:上传文件
            smart.upload();
            //接收不是filer 的其他值
            String Attachment_from  =smart.getRequest().getParameter("Attachment_from"); // 附件所存表单表名
            String field_name  =smart.getRequest().getParameter("field_name"); // 附件所存组件名
            String orderid  =smart.getRequest().getParameter("orderid"); // 订单id
            uid  =smart.getRequest().getParameter("uid"); // 当前用户id
        	
            
            //第四步：保存文件
            //smart.save("/imges");
            //对文件进行重命名
            Files fs= smart.getFiles();//得到所有的文件
            
            for (int i = 0; i <fs.getCount(); i++) {//对文件个数进行循环
            	
                File f=fs.getFile(i);
                if (f.isMissing()==false) {//判断文件是否存在
                	
                	  //图片命名【时间戳_第几个文件.文件类型】
                	  String attachmentName = uid + "_" + System.currentTimeMillis()+ "_" + i + "." + f.getFileExt();
                      //保存路径
                	  f.saveAs(up_Path + attachmentName); // 写入文件
                	  
                	  int attachmenttype=0;
                	  if(f.getFileExt()=="jpg" || f.getFileExt()=="png" ||  f.getFileExt()=="jpeg" ||  f.getFileExt()=="pdf" ){
                		  attachmenttype=0;
                	  }else if(f.getFileExt()=="txt"){
                		  attachmenttype=1;
                	  }else if(f.getFileExt()=="mp4"){
                		  attachmenttype=2;
                	  }
                	  //调试输出
                	  
                	  
                	  //编写附件保存语句
                	  String insert=" INSERT INTO order_attachment "+
				                		 	"(orderid, fromname, fromid, attachmenttype, attachmentpath, attachmentname, createtime, createid, updatetime, updateid) "+
				                		" VALUES "+
				                			"('"+orderid+"', '"+Attachment_from+"', (	SELECT form_template_confg.tid FROM form_template_confg LEFT JOIN  form_name  ON form_template_confg.fid=form_name.id WHERE  form_name.datafrom='"+Attachment_from+"' AND form_template_confg.strname='"+field_name+"'), '"+attachmenttype+"', 'attachmentpath', '"+attachmentName+"', now(), '"+uid+"', now(), '"+uid+"');";
                	  int attaid= db.executeUpdateRenum(insert);
                	 
                	  if(attaid>0){//保存数据库成功
                		//将图片地址放进list
                    	  list.add(SetupConf.get("img_URL")+attachmentName+"?"+attaid); 
                    	  list_id.add(attaid+"");
                	  }else{//保存数据库失败
                		  //删除已经上传的图片
                		  db.executeUpdate("DELETE FROM dev_hcbjinrong.order_attachment  WHERE attachmentid IN ("+list_id.toString().replace("\\[", "").replace("\\]", "")+");");
                	  }
                }
            }
            String aa="INSERT INTO f_creditreport "+
						"	(orderid, creditReportCount, cratetime, createid, updatetime, updateid, jsontemplate)"+
						"VALUES "+
						"	( '"+orderid+"', 'creditReportCount', now(), '"+uid+"', now(), '"+uid+"', '{\"(slect form_template_confg.tid FROM form_template_confg LEFT JOIN  form_name  ON form_template_confg.fid=form_name.id WHERE  form_name.datafrom='"+Attachment_from+"' AND form_template_confg.strname='"+field_name+"')\":}');";

            
        }catch (Exception e) {
            e.printStackTrace(); 
System.out.println("上传图片异常");
            Atm.AppuseLong2( UUID, uid,"","","", GPS, GPSLocal,"", ip,claspath, classname, "",json.toString(), TimeStart);
            Atm.LogSys(AppKeyType, "用户Pc端附件上传操作", "接单操作者"+uid+" 附件上传成失败","1", uid, ip);//添加操作日志
    		Page.colseDOP(db, out, page);
        }
       
        
        Atm.AppuseLong2( UUID, uid,"","","", GPS, GPSLocal,"", ip,claspath, classname, "",json.toString(), TimeStart);
		Atm.LogSys(AppKeyType, "用户Pc端附件上传操作", "接单操作者"+uid+" 附件上传成成功","1", uid, ip);//添加操作日志
		Page.colseDOP(db, out, page);
    }
    
    
}

 