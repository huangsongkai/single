package service.file;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Date;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import net.sf.json.JSONObject;
import service.common.SetupConf;
import service.dao.db.Jdbc;
import service.dao.db.Page;
import service.sys.Atm;
import v1.haocheok.commom.entity.UserEntity;

import com.jspsmart.upload.File;
import com.jspsmart.upload.Files;
import com.jspsmart.upload.SmartUpload;

/**
 * 
 * @company 010jiage
 * @author wangxudong(1503631902@qq.com)
 * @date:2017-9-28 下午11:46:08
 * 接收文件上传{d-y}
 */
@SuppressWarnings("serial")
public class UpFile extends HttpServlet {

    public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request, response);
    }
    //上传方法
    public void doPost(HttpServletRequest request, HttpServletResponse response)throws ServletException, IOException {
    	//获取资源
        Jdbc db = new Jdbc();
        Page page = new Page();
        
        long TimeStart = new Date().getTime();// 程序开始时间，统计效率
        HttpSession session = request.getSession();  
        UserEntity user = (UserEntity) session.getAttribute("UserList");
		String classname = "上传附件";
		String claspath = this.getClass().getName();
        
System.out.println("上传附件");
		
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
		uid = user.getUserid();
		
        //设置路径
      // String up_Path = "D:\\resin\\webapps\\hljsfjy\\images\\uploadImg";	  //上传路径
        String up_Path = request.getSession().getServletContext().getRealPath("")+"\\images\\uploadImg";
        up_Path = up_Path.replaceAll("\\\\", "/");
        System.out.println(up_Path);
		
		//判断有没有改文件夹 没有就创建
		fileAc.MDir(up_Path, 0);//创建文件夹
		up_Path=up_Path+"/";
    	
		//返回  客户端  json对象
		JSONObject json = new JSONObject();
        
        //第一步:新建一个对象
        SmartUpload smart=new SmartUpload();
        //第二步:初始化
        smart.initialize(super.getServletConfig(),request,response);
        //第三步:设置上传文件的类型  {d-y}
        smart.setAllowedFilesList(db.executeQuery_str("SELECT GROUP_CONCAT(file_typerule)as str FROM config_file_type"));
    	//附件集合地址
        ArrayList<String> list = new ArrayList<String>();
        try {
            //第三步:上传文件
            smart.upload();

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
                	  String filePath = up_Path+attachmentName;
                	  f.saveAs(up_Path + attachmentName); // 写入文件
                	  //将附件地址保存到数据库
//                	  int fileid=db.executeUpdateRenum("INSERT INTO order_attachment"+
//														 "( orderid, fromname, fromid, attachmenttype, attachmentpath, attachmentpPhysical,attachmentname, createtime, createid, updatetime, updateid)"+
//														 "VALUES "+
//														 "( '-1', '', '', (SELECT file_code FROM config_file_type  WHERE file_typerule LIKE '%"+f.getFileExt()+"%'), '"+SetupConf.get("img_URL")+attachmentName+"','"+up_Path.replaceAll("\\\\", "\\\\/")+"', '"+attachmentName+"', NOW(), '"+uid+"', NOW(), '"+uid+"');");
                	  
            		  //将图片地址放进list
                	  //list.add(SetupConf.get("img_URL")+attachmentName+"?id="+fileid); 
                	  filePath = filePath.substring(filePath.indexOf("/hljsfjy/"));
                	  list.add(filePath);
                }
            }
        	json.put("code", 1000);
        	json.put("list", list);
        	
        }catch (Exception e) {
            e.printStackTrace(); 
            Atm.AppuseLong2( UUID, uid,"","","", GPS, GPSLocal,"", ip,claspath, classname, "",json.toString(), TimeStart);
            Atm.LogSys(AppKeyType, "附件上传操作", "接单操作者"+uid+" 附件上传成失败","1", uid, ip);//添加操作日志
    		Page.colseDOP(db, out, page);
        }
        
        out.println(json);
        Atm.AppuseLong2( UUID, uid,"","","", GPS, GPSLocal,"", ip,claspath, classname, "",json.toString(), TimeStart);
		Atm.LogSys(AppKeyType, "附件上传操作", "接单操作者"+uid+" 附件上传成成功","1", uid, ip);//添加操作日志
		Page.colseDOP(db, out, page);
    }
    
    
}

 