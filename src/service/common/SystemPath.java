package service.common;
import javax.servlet.http.HttpServlet;

/**
 * @ClassName: WangXuDong E-mail: 1503631902@qq.com
 * @version 创建时间： 2016-12-13 上午11:27:32
 * @Description: TODO(路径配置类)
 * @调用方法：传入要获取的路径类型   返回路径信息
 */
@SuppressWarnings("serial")
public class SystemPath extends HttpServlet{
	
	 public String getCurrentPath(){  
		 
	        String currentPath2=getClass().getResource("").getFile().toString(); 
	        String[] bb=currentPath2.split("class"); 
	        
	        return bb[0];         
	 }
	 public static  String aa(){
		 SystemPath path = new SystemPath();
		 String msg= path.getCurrentPath();
		 return msg;
	 }
	 
	 public static void main(String[] args) {
		 System.out.println(SystemPath.aa());
	}
		
}