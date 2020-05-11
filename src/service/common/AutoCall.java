package service.common;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.ResultSet;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import service.dao.db.Jdbc;
import service.dao.db.Md5;
import service.dao.db.Page;
import service.sys.ErrMsg;
 

/**
 * @category 每3秒自动扫描autocall_log表拨打电话
 * @author u
 *
 */

public class AutoCall extends HttpServlet {
 
	public AutoCall() {
		super();
	}

	 
	public void destroy() {
		super.destroy(); // Just puts "destroy" string in log
		// Put your code here
	}

 
	public void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		 
			Jdbc db = new Jdbc();
			Page page = new Page();
			Md5 md5ac = new Md5();	
		    
		    String classname="自动电话网关";
	        String claspath=this.getClass().getName();
		    response.setContentType("text/html");
		    PrintWriter out = response.getWriter();
		

		//系统配置
		 int DyueSys=0; int Dyue=0;
		  String guanliyuan="",guanlimob="";
		  ResultSet SysRs=db.executeQuery("SELECT adminname,adminmob,yue FROM  `sys_company`  WHERE id='1';");  
		  
			try {
				if(SysRs.next()){    
				     guanliyuan=SysRs.getString("adminname");
				  	 guanlimob=SysRs.getString("adminmob");
				  	 DyueSys=Integer.parseInt(SysRs.getString("yue")); //系统当前剩余条数 单位条数
				 }   if(SysRs!=null)SysRs.close();
		 
		 	 } catch (Exception e) {
		 		ErrMsg.falseErrMsg(request, response, "500", "服务器开小差啦");
		 	 }		   
				 


		
		  try{
			  
			  ResultSet  YErs=null;
				 String Sid="",beizhu="",Username="",moblie="",info="";
				 String   servermsg ="";
			  
		ResultSet Prs=db.executeQuery("SELECT *  FROM  `autocall_log`  where   state='0';");  //查询要拨打的电话
		 while(Prs.next()){  
		    Sid=Prs.getString("id");
		    moblie=Prs.getString("moblie");
		    Username=Prs.getString("Username");
		    info=Prs.getString("info").replaceAll(",","，").replaceAll("\\.", "。").replaceAll(":", "：");//过滤内容
		 
		   
		      
			 //判断欠费

		    YErs=db.executeQuery("SELECT yue FROM  `sys_company`  WHERE id='1';");  
		      if(YErs.next()){    
		      	Dyue=Integer.parseInt(YErs.getString("yue"));//当前剩余条数
		      } if(YErs!=null)YErs.close();
		     
		      DyueSys=Dyue;
		      
		      
		 
		//判断欠费 end
   
		   System.out.println("开始打电话："+moblie);
		   System.out.print("接电话人名："+Username);
		   System.out.print("内容："+info);
		   
		   System.out.println("");
		   System.out.println("");
		   System.out.println("当前余额============="+Dyue);
		   System.out.println("系统余额============="+DyueSys);
		   
			 //-----------------------call
		  
		   sendVoice sendVoice=new sendVoice(); 
		   servermsg=sendVoice.Send_Msg(moblie, info);//拨打电话
		   
		 System.out.print(servermsg+"<hr>");
		 if(servermsg.indexOf("1000")!=-1){
		   System.out.println(Username+moblie+beizhu+"拨打成功");
		     db.executeUpdate("UPDATE  `sys_company` SET `yue`=(yue-1) where id='1';"); //余额减去一次
		     db.executeUpdate("UPDATE `autocall_log` SET   state='1', servermsg='拨打成功', feiyong='1', sendtime='"+page.getTimeA()+"' where id='"+Sid+"';");
		     } else{ 
		    System.out.println(Username+moblie+info+"拨打失败");
			db.executeUpdate("UPDATE `autocall_log` SET    state='4', servermsg='拨打失败', feiyong='0', sendtime='"+page.getTimeA()+"' where id='"+Sid+"';");
		    }
			 
			 //------------------------callend
		 
             }if(Prs!=null)Prs.close();
             
             
	   } catch (Exception e) {
		    int ErrLineNumber = e.getStackTrace()[0].getLineNumber();
		    ErrMsg.falseErrMsg(request, response,"500","服务器开小差啦-"+ErrLineNumber);
		    db.executeUpdate(" INSERT INTO `log_sys`(`ltype`,`title`,`body`,`uid`,`ip`,`addtime`) VALUES ('系统错误','"+classname+"模块系统出错','错误信息详见 "+claspath+",第"+ErrLineNumber+"行。','0','127.0.0.1',now());;");
		    if (db != null) { db.close(); db = null; 	}
            if (page != null) { 	page = null; 	}
            out.flush();
			out.close();
		    return;
	  }
			
			
		  //余额不足通知
	 
		    System.out.println("语音网关剩余条数："+DyueSys);
		    
		      
		   if(DyueSys<100){
		     int   ERRTAG=db.Row("SELECT COUNT(*) as row FROM   `autocall_log`  WHERE  sysyue='sysyue'  and  moblie='"+guanlimob+"' AND TO_DAYS(sendtime) = TO_DAYS(NOW());");
		     	if(ERRTAG==0){
		     	 String addsqlString="insert into `autocall_log` (`moblie`, `Username`, `info`, `servermsg`, `feiyong`, `state`,`sysyue`, `sendtime`) values('"+guanlimob+"','"+guanliyuan+"','亲爱的"+guanliyuan+"，神通物流系统电话提醒系统提示：语音通知功能剩余了"+DyueSys+"次，已经不足100次，请联系开发商北京昂思科技公司，电话：13611093304及时充值！再见！','0','0','0','sysyue','"+page.getTimeA()+"');";
		  	    db.executeUpdate(addsqlString); //插入一条告警记录
		  	   System.out.println("电话余额不足提醒===========不足100条，当前"+DyueSys+"条=================");
		  	} //如果一天内	已经发过警告就不在插入
	     } //余额不足通知 end  
			
			
		
			if (db != null) {
				db.close();
				db = null;
			}

			if (page != null) {
				page = null;
			}

		out.flush();
		out.close();
		
	
	
	}

	 
	public void doPut(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		// Put your code here
	}

	/**
	 * Initialization of the servlet. <br>
	 *
	 * @throws ServletException if an error occurs
	 */
	public void init() throws ServletException {
		// Put your code here
	}

}
