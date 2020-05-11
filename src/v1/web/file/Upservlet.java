package v1.web.file; 

import net.sf.json.JSONObject;
import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileUploadException;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.apache.commons.io.output.ByteArrayOutputStream;
import service.dao.db.Jdbc;
import service.dao.db.Md5;
import service.dao.db.Page;
import service.file.FileAc;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.*;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;
//import sun.org.mozilla.javascript.internal.regexp.SubString;




/**
 * 
 * @ClassName: 李高颂 E-mail: 932246@qq.com
 * @version 创建时间： 2017-3-10 下午02:38:11
 * @Description: TODO(图片上传)
 */
@SuppressWarnings("serial")	
public class Upservlet extends HttpServlet {
	  static String  PubUrl="";
 
	
    public void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException 
            {
    			doPost(request, response);
            }
 
	public void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException 
     {
    	//设置编码格式
        request.setCharacterEncoding("utf-8");
        response.setCharacterEncoding("utf-8");
        PrintWriter out = response.getWriter();
        String str = request.getParameter("str");
    	String USERID="";
		String username="";
        String AppId="";
        String Token="";
        String responsejson="";
        String classname = "上传文件";
        String Path="";
        String claspath = this.getClass().getName();
        String markKey="markKey";
       
        String Service_stamp=""; //业务戳
        String entrepotid="";//仓库id
        String jobid=""; //其他业务扩展id
        
        if(Service_stamp==null){
        	Service_stamp="0";
        }
        if(entrepotid==null){
        	entrepotid="0";
        }
        if(jobid==null){
        	jobid="0";
        }
        
        String URLpath = request.getContextPath();
        String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+URLpath+"/";
        basePath=basePath.replaceAll(":80", "").replaceAll("https", "http");
        
        String appIdes = "#d72fee85a054369957741be620767060#be7ffb36743431d13e49ccd34a622462#017ecf0f394e0f1b5e03c4c2dd2f0def#";
		

        //获取资源
        Jdbc db = new Jdbc();
		Page page = new Page();
		Md5 md5ac=new Md5();
		JSONObject json = new JSONObject();
		ArrayList Jslist = new ArrayList();
		//创建文件方法
        FileAc fileAc = new FileAc();
		

   	 
    	// 创建文件项目工厂对象
		DiskFileItemFactory factory = new DiskFileItemFactory();

		// 设置文件上传路径
//		String upload = this.getServletContext().getRealPath("/images/customer");
//		String upload = "D:\\wwwroot\\dev.e168.cn\\webapps\\haocheok_finance\\images\\"; // 获得上传路径
		String upload = "D:\\jianbiao11\\finance\\XHOrders\\";
		String path_two = "customer";
		upload = upload+"/"+path_two;
		fileAc.MDir(upload, 0);//创建文件夹
		
		// 获取系统默认的临时文件保存路径，该路径为Tomcat根目录下的temp文件夹
		String temp = System.getProperty("java.io.tmpdir");
		// 设置缓冲区大小为 5M
		factory.setSizeThreshold(1024 * 1024 * 5);
		// 设置临时文件夹为temp
		factory.setRepository(new File(temp));
		// 用工厂实例化上传组件,ServletFileUpload 用来解析文件上传请求
		ServletFileUpload servletFileUpload = new ServletFileUpload(factory);
	 
		System.out.println("---------开始长传---------------");
		
		
		
		
		// 解析结果放在List中
		try
		{
			List<FileItem> list = servletFileUpload.parseRequest(request);
			 
			 int listsize=list.size()-1; //上传文件数
			 
			for (FileItem item : list)
			{   
				System.out.println("-------------------------------");
				String ContentType=item.getContentType(); //文件类型
				String name=item.getFieldName(); //input name 表单名
				String getName=item.getName(); //原始文件名
				//getName=getName.toLowerCase();
				long getSize=item.getSize(); //文件大小
				
				String FileExt="";//文件扩展名
				String Filenme="";//文件名不带扩展名
				if(getName!=null && getName.lastIndexOf(".")!=-1){
					
					 Filenme=getName.substring(0,getName.lastIndexOf("."));
					 FileExt = getName.substring(getName.lastIndexOf(".")).toLowerCase();
				}
				
				//过滤文件类型
				String fileExtes=".doc|.docx|.jpg|.png|.bmp|.pdf|.mp4|.xlsx|.xls|.ppt|";
				
				InputStream is = item.getInputStream();
				
				 
			 
				System.out.println("1:name="+name);
				System.out.println("2:getContentType="+ContentType);
				System.out.println("3:getName="+getName);
			    System.out.println("4:getSize="+getSize);
			    System.out.println("5:文件名Filenme="+Filenme);
			    System.out.println("6:扩展名FileExt="+FileExt);
				
				if (name.equals("Token"))
				{    String strs=inputStream2String(is);
				     Token=new String(strs.getBytes("ISO-8859-1"), "UTF-8");
					 //out.println("Token="+Token);
				} 
				if (name.equals("Service_stamp"))
				{    String strs=inputStream2String(is);
				     Service_stamp=new String(strs.getBytes("ISO-8859-1"), "UTF-8");
					 //out.println("Service_stamp="+Service_stamp);
				} 
				if (name.equals("entrepotid"))
				{    String strs=inputStream2String(is);
			      	 entrepotid=new String(strs.getBytes("ISO-8859-1"), "UTF-8");
					 //out.println("Service_stamp="+Service_stamp);
				} 
				if (name.equals("jobid"))
				{    String strs=inputStream2String(is);
				     jobid=new String(strs.getBytes("ISO-8859-1"), "UTF-8");
					 //out.println("Service_stamp="+Service_stamp);
				} 
				
				
				else if(name.equals("file"))
				{ 
				 
				 if(ContentType!=null && getName.indexOf(".")!=-1 && fileExtes.indexOf(FileExt)!=-1){//文件类型判断
					
				  System.out.println("-------------写入中-----------------");
				  //过滤文件大小
				  if(getSize>10000000){
					  out.print("文件超过10MB");
					  break;
				  }
				  
					   try
					  { 
						String newfileString=md5ac.md5(Token+"随机文件名"+Calendar.getInstance().getTimeInMillis())+FileExt;
						inputStream2File(is, upload + "\\" +newfileString);
						//out.println(newfileString+"<br>");
						 
						json.put("filename",""+newfileString);
						//这个是线上的路径
//						json.put("imageurl","https://dev.e168.cn/haocheok_finance/images/"+path_two+"/"+newfileString);
						//本地测试路径
						json.put("imageurl","http://localhost:4567/XHOrders/"+path_two+"/"+newfileString);
						json.put("filesize",""+getSize/1000);
						Jslist.add(json.toString()); //放到数组前要格式化成字符串
						
					  } catch (Exception e)
					  { 
						e.printStackTrace();
					  }
					
				  }//tentType!=null  end
				}
				
		 
			} //for
			
			//out.write("success");
		} catch (FileUploadException e)
		{
			e.printStackTrace();
			//out.write("failure");
			responsejson = "{\"success\":\"false\",\"resultCode\":\"500\",\"msg\":\""+Path+classname+"失败,服务器故障\",\"threads\":[]}";
			out.print(responsejson);
		}

		
		responsejson = "{\"success\":\"true\",\"resultCode\":\"1000\",\"files\":"+Jslist.toString()+"}";
		out.print(responsejson);
		
	 
       	
	if (db != null) db.close();db = null;
	if (page != null) page = null;
	
 
	

	out.flush();
	out.close();
	return;// 程序关闭
    }
	
	
 

	// 流转化成字符串
	public static String inputStream2String(InputStream is) throws IOException
	{
		ByteArrayOutputStream baos = new ByteArrayOutputStream();
		int i = -1;
		while ((i = is.read()) != -1)
		{
			baos.write(i);
		}
		return baos.toString();
	}

	// 流转化成文件
	public static void inputStream2File(InputStream is, String savePath)
			throws Exception
	{
		//System.out.println("文件保存路径为:" + savePath);
		File file = new File(savePath);
		InputStream inputSteam = is;
		BufferedInputStream fis = new BufferedInputStream(inputSteam);
		FileOutputStream fos = new FileOutputStream(file);
		int f;
		while ((f = fis.read()) != -1)
		{
			fos.write(f);
		}
		fos.flush();
		fos.close();
		fis.close();
		inputSteam.close();
		
	}

}

