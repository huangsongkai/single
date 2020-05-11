package service.sys;

import v1.haocheok.commom.entity.InfoEntity;

import javax.servlet.ServletException;
import java.io.IOException;


/**
 * 
 * @author Administrator （王）
 * 异步执行代码
 *
 */
public class Atm{

	/*
	 * 演示一个异步触发线程，不管B运行多少时间，A触发B后，不会影响A的执行效率。
	 */
	public void exec() {
		final String str = "好的。拨打电话";
		System.out.println("A程序运行开始--------------------------");
		Thread thread = new Thread(){
			@Override
			public void run() {
				new B().Task(str);//创建一个线程。保证线程安全，不会被重写，用new一个B类。
			}
		};
		thread.start();//线程开始
		System.out.println("A程序已经运行完啦。。。。。。。。。。。。。。。。。。。。。。。");
	}
	
	/**                          
	 *                           
	 * @author 王                 
	 * @date 2017-9-18           
	 * @file_name  AppuseLong     
	 * @Remarks	   	   {记录接口操作日志}       
	 * @info           基本信息(封装)   
	 * @username       用户名     
	 * @claspath       请求接口路径
	 * @classname      请求接口名   
	 * @responsejson   响应数据
	 * @ExeTime        执行时间
	 */ 
	public static void AppuseLong(final InfoEntity info,final String username,final String claspath,final String classname,final String responsejson,final long ExeTime)
	{
		Thread thread = new Thread() {
			@Override
			public void run() {
				try {
					new AppuseLog().LogAdd(info.getUUID(), info.getUSERID(), info.getDID(), info.getMdels(), info.getNetMode(), info.getGPS(), info.getGPSLocal(), username, info.getIp(), claspath, classname, info.getRequestJson(), responsejson, ExeTime);
				} catch (ServletException e) {
					e.printStackTrace();
				} catch (IOException e) {
					e.printStackTrace();
				}//创建一个线程。保证线程安全，不会被重写，用new一个B类。
			}
		};
		thread.start();//线程开始
	}
	
	
	/**                          
	 *                           
	 * @author 王                 
	 * @date 2017-9-18           
	 * @file_name  AppuseLong2     
	 * @Remarks	   	   {记录接口操作日志}       
	 * @UUID           设备串码     
	 * @USERID         用户id     
	 * @DID            设备id     
	 * @Mdels          设备类型     
	 * @NetMode        上网方式     
	 * @GPS            地理坐标     
	 * @GPSLocal       地理位置     
	 * @username       用户名      
	 * @ip             当前ip     
	 * @claspath       请求接口路径   
	 * @classname      请求接口名称   
	 * @RequestJson    请求数据     
	 * @responsejson   响应数据     
	 * @ExeTime        执行时间     
	 */ 
	public static void AppuseLong2(final String UUID,final String USERID,final String DID,final String Mdels,final String NetMode,final String GPS,final String GPSLocal,final String username,final String ip,final String claspath,final String classname,final String RequestJson,final String responsejson,final long ExeTime) 
	{                                                           
		Thread thread = new Thread() {
			@Override
			public void run() {
				try {
					new AppuseLog().LogAdd(UUID,USERID,DID,Mdels,NetMode,GPS,GPSLocal,username,ip,claspath,classname,RequestJson,responsejson,ExeTime);
				} catch (ServletException e) {
					e.printStackTrace();
				} catch (IOException e) {
					e.printStackTrace();
				}//创建一个线程。保证线程安全，不会被重写，用new一个B类。
			}
		};
		thread.start();//线程开始
	}
	
	/**                          
	 *                           
	 * @author 王                 
	 * @date 2017-9-18           
	 * @file_name  LogSys     
	 * @Remarks	   {记录操作日志}       
	 * @ltype      操作类型        
	 * @title      操作标题        
	 * @body       操作内容        
	 * @status     执行状态        
	 * @uid        用户id        
	 * @ip         当前ip        
	 */                          
	public static void LogSys(final String ltype,final String title,final String body,final String status,final String uid,final String ip)            //当前ip
	{                                                       
		
		Thread thread = new Thread() {
			@Override
			public void run() {
				try {
					new LogSys().logSys(ltype, title, body,status, uid, ip);
				} catch (ServletException e) {
					e.printStackTrace();
				} catch (IOException e) {
					e.printStackTrace();
				}//创建一个线程。保证线程安全，不会被重写，用new一个B类。
			}
		};
		thread.start();//线程开始
	}

	
	
//	/**
 //	 *
 //	 * @author 王
 //	 * @date 2017-9-18
 //	 * @file_name SendEmil
 //	 * @Remarks	  {延时发送邮件}
 //	 * nick		  发件人
 //	 * title    邮件标题
 //	 * body     邮件内容
 //	 * tomails  收件人
 //	 */
//	public static void SendEmil( final String nick,final String title,final String body,final String tomails){
//		Thread thread = new Thread() {
//			@Override
//			public void run() {
//				new SendMail().send(nick, title, body, tomails);
//			}
//		};
//		thread.start();//线程开始
//	}
//
//
//	/*
//	 * 测试代码
//	 */
//	public static void main(String[] args) {
//		SendEmil("1111","22222","333","1503631902@qq.com");
//
//	}

}
