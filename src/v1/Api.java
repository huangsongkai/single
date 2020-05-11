package v1;

import autocode.action.AutoCodeList;
import service.common.SetupConf;
import service.dao.db.Page;
import service.sys.ErrMsg;
import test.TestData;
import test.data.AppgetData;
import test.from.FromData;
import v1.haocheok.commom.controller.GetVinToModelController;
import v1.haocheok.commom.entity.InfoEntity;
import v1.haocheok.list.controller.AppWaitingList;
import v1.haocheok.login.controller.UserLogin;
import v1.web.admin.controller.DoAdopt;
import v1.web.admin.log.WebAppApiLog;
import v1.web.admin.log.WebSysLog;
import v1.web.admin.powergroup.PermissionRoleList;
import v1.web.admin.powergroup.PowerGroupList;
import v1.web.admin.system.arrange.ArrangeConfigService;
import v1.web.admin.system.bankConfig.BankConfigService;
import v1.web.admin.system.bankConfig.ImportConfigService;
import v1.web.admin.system.management.WebCompanyList;
import v1.web.admin.system.regionConfig.RegionConfigService;
import v1.web.admin.system.sysDictionary.DoDelSysDictionary;
import v1.web.attachment.SelectIdByPath;
import v1.web.cms.articles.*;
import v1.web.cms.classAll.ClassAll;
import v1.web.cms.classAll.InfoDeCalssAll;
import v1.web.cms.classAll.ScheduleBase;
import v1.web.cms.classAll.ScheduleInfo;
import v1.web.cms.classify.*;
import v1.web.plan.EditPlan;
import v1.web.plan.SelectCourses;
import v1.web.publicInformation.SelectMultistage;
import v1.web.users.*;
import v1.web.vod.GetStudenList;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.Calendar;


/**
 * @author LiGaoSong E-mail: 932246@qq.com
 * @version 创建时间：2016-7-24 下午02:05:33 类说明 ：app api 接口主入口
 */
@SuppressWarnings("serial")
public class Api extends HttpServlet {

	public Api() {
		super();
	}

	public void destroy() {
		super.destroy(); // Just puts "destroy" string in log

	}

	/**
	 * api 接口总入口 接受变量引导
	 */

	public void doGet(HttpServletRequest request, HttpServletResponse response)throws ServletException, IOException {
		System.out.println("api 主入口doget输出测试");
		System.out.println("appapi 主入口doget输出测试");
			/* 允许跨域的主机地址 */
		response.setHeader("Access-Control-Allow-Origin", "*");
			/* 允许跨域的请求方法GET, POST, HEAD 等 */
		response.setHeader("Access-Control-Allow-Methods", "*");
			/* 重新预检验跨域的缓存时间 (s) */
		response.setHeader("Access-Control-Max-Age", "3600");
			/* 允许跨域的请求头 */
		response.setHeader("Access-Control-Allow-Headers", "*");
			/* 是否携带cookie */
		response.setHeader("Access-Control-Allow-Credentials", "true");
		process(request, response);
	}

	public void doPost(HttpServletRequest request, HttpServletResponse response)throws ServletException, IOException {
		System.out.println("api 主入口doPost输出测试");
		System.out.println("appapi 主入口doget输出测试");
			/* 允许跨域的主机地址 */
		response.setHeader("Access-Control-Allow-Origin", "*");
			/* 允许跨域的请求方法GET, POST, HEAD 等 */
		response.setHeader("Access-Control-Allow-Methods", "*");
			/* 重新预检验跨域的缓存时间 (s) */
		response.setHeader("Access-Control-Max-Age", "3600");
			/* 允许跨域的请求头 */
		response.setHeader("Access-Control-Allow-Headers", "*");
			/* 是否携带cookie */
		response.setHeader("Access-Control-Allow-Credentials", "true");
		process(request, response);
	}

	/**
	 * @category 构建一个process方法
	 */
	private void process(HttpServletRequest request,HttpServletResponse response) throws ServletException, IOException {
		long TimeStart = Calendar.getInstance().getTimeInMillis();// 性能测试;
		long TimeEnd = 0;
		
		
		
	    @SuppressWarnings("unused")
		SetupConf setupConf=new SetupConf();
	    Page Page=new Page();

		response.setContentType("text/html;charset=UTF-8");
		request.setCharacterEncoding("UTF-8");
		response.setCharacterEncoding("UTF-8");

		String ip = request.getHeader("x-real-ip");
		if (ip == null || ip.length() == 0) {
			ip = request.getRemoteAddr();
		}
		
		String Path=request.getParameter("p"); //资源路径
		String AppId = request.getHeader("X-AppId"); // 标明正在运行的是哪个App程序
		String AppKey = request.getHeader("X-AppKey"); // 授权鉴定终端
		String Token=request.getHeader("Token");
		
		String UUID = request.getHeader("X-UUID");   //必填设备串码
		String USERID = request.getHeader("X-USERID");  //非登陆用户请求可为空
		String DID = request.getHeader("X-DeviceId");  //设备id
		String Mdels=request.getHeader("X-Mdels");  //必填 "IOS7.0/安卓4.3" 
		String NetMode=request.getHeader("X-NetMode");  // 必填 网络制式
		String ChannelId=request.getHeader("X-ChannelId");  // 渠道ID 用于区分应用的下载渠道
		String GPS=request.getHeader("X-GPS");  // GPS定位信息
		String GPSLocal=request.getHeader("X-GPSLocal");  // GPS定位信息
		
		String theClassName="";
		/*过滤非法字符*/
		if (Path == null) {Path = ""; }
		if (AppId == null) {AppId = ""; }
		if (AppKey == null) {AppKey = ""; }
		if (Token == null) {Token = ""; }
		if (UUID == null) {UUID = ""; }
		if (USERID == null) {USERID = "0"; }
	    if (Mdels == null) {Mdels = ""; }
	    if (ChannelId == null) {ChannelId = "0"; }
	    if (DID == null) {DID = "0"; }
	    
	     Path=Path.replaceFirst("/app/", "app/");
		 AppId=Page.mysqlCode(AppId);
		 AppKey=Page.mysqlCode(AppKey);
		 Token=Page.mysqlCode(Token);
		 UUID=Page.mysqlCode(UUID);
		 USERID=Page.mysqlCode(USERID);
		 Mdels=Page.mysqlCode(Mdels);
		 NetMode=Page.mysqlCode(NetMode);
		 ChannelId=Page.mysqlCode(ChannelId);
		 GPS=Page.mysqlCode(GPS);
		 //GPSLocal=Page.mysqlCode(GPSLocal);
		 /*过滤非法字符*/
		
		 
		/* 
		 System.out.println("UUID="+UUID);
		 System.out.println("AppId="+AppId);
		 System.out.println("AppKey="+AppKey);
		 System.out.println("Token="+Token);
	 	*/ 
	    
	    String AppKeyType=""; //AppKey类型
	    String RequestJson = "";//接受json
		
	    /* 验证过滤判断   */
		 /*if(!SetupConf.get("AppId").equals(AppId)){
			 
			   ErrMsg.falseErrMsg(request, response,"403", "appid非法的设备请求");
			   
			   return;
		 } 
		 
		 
		 if(SetupConf.get("IOSAppKey").equals(AppKey)){
			   AppKeyType="IOS";
			 } 
		 else  if(SetupConf.get("androidAppKey").equals(AppKey)){
			   AppKeyType="Android";
		     } 
		 else  if(SetupConf.get("webAppKey").equals(AppKey)){
			   AppKeyType="WEB";
		   } 
	     else {
			  ErrMsg.falseErrMsg(request, response,"403", "appid非法的设备请求");
			return;
	 	 }  */
		 
		  /* 验证过滤判断结束  */
		  
		
	    /*
	     * 启动二进制获取发送过来的数据
		 */
		 
			String  InputString = null; // 读取请求内容
			try {

				BufferedReader br = new BufferedReader(new InputStreamReader(request.getInputStream(), "UTF-8"));// json进行uf8编码
				String line = null;
				StringBuilder sb = new StringBuilder();
				
				while ((line = br.readLine()) != null) {
					sb.append(line);
				} br.close();//关闭2进制流
				
				InputString = sb.toString();
              	System.out.println("InputString "+InputString);
				//替换sql文敏感字
				RequestJson=Page.mysqlCode(InputString);
//				RequestJson=InputString;
				
			} catch (Exception e) {
				e.printStackTrace();
			}
			
			/*
			 * 启动二进制获取发送过来的数据结束
			 */
		 
			//封装接收收据，保存到日志中的数据
			InfoEntity info = new InfoEntity( UUID, Token, USERID, DID, Mdels, NetMode, ChannelId, ip, GPS, GPSLocal, AppKeyType,TimeStart,RequestJson);
			
			/*
			 * 业务处理模块开始
			 */
			if(Path.indexOf("app/")!=-1){ //app 模块判断		
					
				if (Path.equals("app/user/login")) {
					theClassName="用户登录";
					UserLogin userLogin=new UserLogin();
					userLogin.userLogin(request, response, RequestJson, info);
					
				}
				if (Path.equals("app/person/data")) {
					theClassName="获取学期列表和当前apptonken登录教师";
					BankConfigService banConfig=new BankConfigService();
					banConfig.findSemesterTea(request, response, RequestJson, info);
					
				}
				
				else if (Path.equals("app/user/waitingList")) {
					
					theClassName="待接单列表";
					AppWaitingList appWaitingList=new AppWaitingList();
					appWaitingList.waitingList(request,response,RequestJson,info);
					
				}
				
				else if (Path.equals("app/test/getdata")) {

					theClassName="测试获取数据接口";
					AppgetData appgetData=new AppgetData(request, response);
					appgetData.Transmit(Token, UUID, USERID,DID, Mdels, NetMode, ChannelId, RequestJson,ip, GPS,GPSLocal,AppKeyType,TimeStart);
					
				}
				
				else if (Path.equals("app/test/Testdata")) {

					theClassName="测试生产菜单接口";
					TestData testData=new TestData(request, response);
					testData.Transmit(Token, UUID, USERID,DID, Mdels, NetMode, ChannelId, RequestJson,ip, GPS,GPSLocal,AppKeyType,TimeStart);
					
				}
				
				else if (Path.equals("app/test/from")) {
					
					theClassName="返回表单接口";
//					FromData fromData=new FromData(request, response);
//					fromData.Transmit(Token, UUID, USERID,DID, Mdels, NetMode, ChannelId, RequestJson,ip, GPS,GPSLocal,AppKeyType,TimeStart);
					FromData fromData=new FromData();
					fromData.fromData(request, response, RequestJson, info);
				}
				
				
				// 性能debug输出
				TimeEnd = Calendar.getInstance().getTimeInMillis();
				System.out.println();
				System.out.println("============================");
				System.out.println("appid 	:"+AppId);
				System.out.println("appkey	:"+AppKey);
				System.out.println("模块           :"+Path);
				System.out.println("模块说明 :"+theClassName);
				System.out.println("业务信息 :"+RequestJson);
				System.out.println("耗时:"+(TimeEnd - TimeStart) + "ms");
				return;
			//app大类模块判断结束
			}else if(Path.indexOf("web/")!=-1){ // web 大类模块开始
	 
			 /*
			  * WEB 接口大类模块
			  */
				if (Path.equals("web/admin/app_api_log")) {
					
					theClassName="WEB系统管理接口执行日志接口";
					WebAppApiLog webAppApiLog=new WebAppApiLog();
					webAppApiLog.webAppApiLog(request, response, info, Token, UUID, USERID, DID, Mdels, NetMode, ChannelId, RequestJson, ip, GPS, GPSLocal, AppKeyType, TimeStart);
				
				}
				
				/************************************学校接口开始*************************************************/
				else if (Path.equals("web/class/all")) {
					
					theClassName="WEB获取班级信息";
					ClassAll classAll = new ClassAll();
					classAll.getClassAll(request, response, info, Token, UUID, USERID, DID, Mdels, NetMode, ChannelId, RequestJson, ip, GPS, GPSLocal, AppKeyType, TimeStart);
				}
				
				else if (Path.equals("web/info/teachingResearch")) {
					
					theClassName="WEB通过院系获取教研室信息";
					InfoDeCalssAll infoDeCalssAll = new InfoDeCalssAll();
					infoDeCalssAll.teachingResearch(request, response, RequestJson, info,theClassName);
				}
				
				
				
				
				
				else if (Path.equals("web/info/campusGetDepartment")) {
					
					theClassName="WEB通过校区获得院系";
					InfoDeCalssAll infoDeCalssAll = new InfoDeCalssAll();
					infoDeCalssAll.campusGetDepartment(request, response, RequestJson, info,theClassName);
				}
				
				
				
				else if (Path.equals("web/info/getteacherToDepartment")) {
					
					theClassName="WEB通过院系获得老师";
					InfoDeCalssAll infoDeCalssAll = new InfoDeCalssAll();
					infoDeCalssAll.getTeacherToDepartment(request, response, RequestJson, info,theClassName);
				}
				
				else if (Path.equals("web/info/getteacherToDepartmentAndjiao")) {
					
					theClassName="WEB通过院系和教研室获得老师";
					InfoDeCalssAll infoDeCalssAll = new InfoDeCalssAll();
					infoDeCalssAll.getteacherToDepartmentAndjiao(request, response, RequestJson, info,theClassName);
				}
				
				else if (Path.equals("web/info/getbuildeToCampu")) {
					
					theClassName="WEB通过分校获得教学区";
					InfoDeCalssAll infoDeCalssAll = new InfoDeCalssAll();
					infoDeCalssAll.getbuildeToCampu(request, response, RequestJson, info,theClassName);
				}
				
				
				else if (Path.equals("web/info/getclassroomTobuilde")) {
					
					theClassName="WEB通过教学区获得教室";
					InfoDeCalssAll infoDeCalssAll = new InfoDeCalssAll();
					infoDeCalssAll.getclassroomTobuilde(request, response, RequestJson, info,theClassName);
				}
				
				
				
				else if (Path.equals("web/info/getMajor")) {
					
					theClassName="WEB获取专业信息";
					InfoDeCalssAll infoDeCalssAll = new InfoDeCalssAll();
					infoDeCalssAll.getMajor(request, response, RequestJson, info,theClassName);
				}
				
				else if (Path.equals("web/info/getClassGrade")) {
					
					theClassName="WEB通过专业获取班级信息";
					InfoDeCalssAll infoDeCalssAll = new InfoDeCalssAll();
					infoDeCalssAll.getClassGrade(request, response, RequestJson, info,theClassName);
				}
				else if (Path.equals("web/info/getArrageParameters")) {
					
					theClassName="WEB通过排课类别获取排课参数";
					InfoDeCalssAll infoDeCalssAll = new InfoDeCalssAll();
					infoDeCalssAll.getArrageParameters(request, response, RequestJson, info,theClassName);
				}
				
				else if (Path.equals("web/userList/all")) {
					theClassName="WEB获取教师信息";
					UserListService userList = new UserListService();
					userList.getUserList(request, response, info, Token, UUID, USERID, DID, Mdels, NetMode, ChannelId, RequestJson, ip, GPS, GPSLocal, AppKeyType, TimeStart);
				}
				
				else if (Path.equals("web/rolerList/all")) {
					theClassName="WEB获取角色信息";
					UserListService userList = new UserListService();
					userList.getRoleList(request, response, info, Token, UUID, USERID, DID, Mdels, NetMode, ChannelId, RequestJson, ip, GPS, GPSLocal, AppKeyType, TimeStart);
				}
				
				else if (Path.equals("web/kebiao/getScheduleInfo")) {
					
					theClassName="WEB获取课表信息按照班级查询";
					ScheduleInfo scheduleInfo = new ScheduleInfo();
					scheduleInfo.getScheduleInfo(request, response, RequestJson, info,theClassName);
				}
				
				else if (Path.equals("web/kebiao/getScheduleTeacherInfo")) {
					
					theClassName="WEB获取课表信息按照教师查询";
					ScheduleInfo scheduleInfo = new ScheduleInfo();
					scheduleInfo.getScheduleTeacherInfo(request, response, RequestJson, info,theClassName);
				}
				
				else if (Path.equals("web/kebiao/getClassroomInfo")) {
					
					theClassName="WEB获取课表信息按照教室查询";
					ScheduleInfo scheduleInfo = new ScheduleInfo();
					scheduleInfo.getClassroomInfo(request, response, RequestJson, info,theClassName);
				}
				
				else if (Path.equals("web/kebiao/timetableAdjustment")) {
					
					theClassName="WEB课表调整按班级调整";
					ScheduleInfo scheduleInfo = new ScheduleInfo();
					scheduleInfo.timetableAdjustment(request, response, RequestJson, info,theClassName);
				}
				
				else if (Path.equals("web/kebiao/timetableAdjustmentTeacher")) {
					
					theClassName="WEB课表调整按教师调整";
					ScheduleInfo scheduleInfo = new ScheduleInfo();
					scheduleInfo.timetableAdjustmentTeacher(request, response, RequestJson, info,theClassName);
				}
				
				else if (Path.equals("web/kebiao/timetableAdjustmentClassroom")) {
					
					theClassName="WEB课表调整按教室调整";
					ScheduleInfo scheduleInfo = new ScheduleInfo();
					scheduleInfo.timetableAdjustmentClassroom(request, response, RequestJson, info,theClassName);
				}
				
				
				else if (Path.equals("web/kebiao/getAllSchoolTimetable")) {
					
					theClassName="WEB获取全校课表按班级";
					ScheduleInfo scheduleInfo = new ScheduleInfo();
					scheduleInfo.getAllSchoolTimetable(request, response, RequestJson, info,theClassName);
				}
				
				else if (Path.equals("web/kebiao/getAllSchoolRoom")) {
					
					theClassName="WEB获取全校课表按教室";
					ScheduleInfo scheduleInfo = new ScheduleInfo();
					scheduleInfo.getAllSchoolRoom(request, response, RequestJson, info,theClassName);
				}
				else if (Path.equals("web/kebiao/getAllSchoolTeacher")) {
					
					theClassName="WEB获取全校课表按教室";
					ScheduleInfo scheduleInfo = new ScheduleInfo();
					scheduleInfo.getAllSchoolTeacher(request, response, RequestJson, info,theClassName);
				}
				
				else if (Path.equals("web/kebiao/getWeeklySchedule")) {
					
					theClassName="WEB判断周进度分配";
					ScheduleInfo scheduleInfo = new ScheduleInfo();
					scheduleInfo.getWeeklySchedule(request, response, RequestJson, info,theClassName);
				}
				
				else if (Path.equals("web/kebiao/LeakingCourseTreatment")) {
					
					theClassName="WEB排课漏课管理";
					ScheduleInfo scheduleInfo = new ScheduleInfo();
					scheduleInfo.LeakingCourseTreatment(request, response, RequestJson, info,theClassName);
				}
				
				else if (Path.equals("web/kebiao/getTeacherCom")) {
					
					theClassName="WEB获取教师备注信息";
					ScheduleInfo scheduleInfo = new ScheduleInfo();
					scheduleInfo.getTeacherCom(request, response, RequestJson, info,theClassName);
				}
				
				else if (Path.equals("web/kebiao/getTeacherCom")) {
					
					theClassName="WEB获取教师备注信息";
					ScheduleInfo scheduleInfo = new ScheduleInfo();
					scheduleInfo.getTeacherCom(request, response, RequestJson, info,theClassName);
				}
				
				
				else if (Path.equals("web/kebiao/LeakingClassConflict")) {
					
					theClassName="WEB漏课冲突";
					ScheduleInfo scheduleInfo = new ScheduleInfo();
					scheduleInfo.LeakingClassConflict(request, response, RequestJson, info,theClassName);
				}
				
				else if (Path.equals("web/base/print")) {
					
					theClassName="WEB是否打印";
					ScheduleBase scheduleBase = new ScheduleBase();
					scheduleBase.print(request, response, RequestJson, info, theClassName);
				}
				
				
				/************************************学校接口结束*************************************************/
				
				
				/************************************VOD直播接口开始*************************************************/
				else if (Path.equals("web/vod/GetStudenList")) {
					
					theClassName="通过班级号获取该班级所有学生";
					GetStudenList getStudenList = new GetStudenList();
					getStudenList.getUserList(request, response, info, Token, UUID, USERID, DID, Mdels, NetMode, ChannelId, RequestJson, ip, GPS, GPSLocal, AppKeyType, TimeStart, theClassName);
				}
				else if (Path.equals("web/vod/ttos")) {
					theClassName="老师对学生聊天";
					//UserListService userList = new UserListService();
					//userList.getUserList(request, response, info, Token, UUID, USERID, DID, Mdels, NetMode, ChannelId, RequestJson, ip, GPS, GPSLocal, AppKeyType, TimeStart);
				}
				
				else if (Path.equals("web/vod/stot")) {
					theClassName="学生对聊天聊天";
					//UserListService userList = new UserListService();
					//userList.getRoleList(request, response, info, Token, UUID, USERID, DID, Mdels, NetMode, ChannelId, RequestJson, ip, GPS, GPSLocal, AppKeyType, TimeStart);
				}
				/************************************VOD直播接口结束*************************************************/
				
				
				
				else if (Path.equals("web/admin/sys_api_log")) {
					
					theClassName="WEB系统管理接口系统日志接口";
					WebSysLog webSysLog=new WebSysLog();
					webSysLog.webSysLog(request, response, info, Token, UUID, USERID, DID, Mdels, NetMode, ChannelId, RequestJson, ip, GPS, GPSLocal, AppKeyType, TimeStart);
				
				}
				
				else if (Path.equals("web/admin/company/management")) {
					
					theClassName="WEB系统管理公司列表接口";
					WebCompanyList webCompanyList=new WebCompanyList();
					webCompanyList.webCompanyList(request, response, info, Token, UUID, USERID, DID, Mdels, NetMode, ChannelId, RequestJson, ip, GPS, GPSLocal, AppKeyType, TimeStart);
				
				}
				
				else if (Path.equals("web/admin/worker_power_group/list")) {
					
					theClassName="WEB系统管理权限列表接口";
					PowerGroupList powerGroupList=new PowerGroupList();
					powerGroupList.powerGroupList(request, response, info, Token, UUID, USERID, DID, Mdels, NetMode, ChannelId, RequestJson, ip, GPS, GPSLocal, AppKeyType, TimeStart);
				
				}
				
				else if (Path.equals("web/admin/AutoCode/list")) {
					
					theClassName="WEB系统管理代码生成器列表接口";
					AutoCodeList autoCodeList=new AutoCodeList();
					autoCodeList.autoCodeList(request, response, info, Token, UUID, USERID, DID, Mdels, NetMode, ChannelId, RequestJson, ip, GPS, GPSLocal, AppKeyType, TimeStart);
				
				}
				
				else if (Path.equals("web/admin/worker_power_group/wanglist")) {
				
					theClassName="WEB系统管理权限列表接口[wang]";
					PermissionRoleList permissionRoleList=new PermissionRoleList();
					permissionRoleList.permissionRoleList(request, response, info, Token, UUID, USERID, DID, Mdels, NetMode, ChannelId, RequestJson, ip, GPS, GPSLocal, AppKeyType, TimeStart);
				
				}
				
				/*else if (Path.equals("web/amdin/docustomer")) {
					
					theClassName="WEB提交客户档案信息";
					DoCustomer doCustomer=new DoCustomer();
					doCustomer.setcustomer(request, response, RequestJson, info);
					
				}
				
				else if (Path.equals("web/amdin/credit/report")) {
					
					theClassName="WEB提交报件信息";//w
					Report report=new Report();
					report.report(request, response, RequestJson, info);
					
				}
				
				else if (Path.equals("web/amdin/common/ordersprocess")) {				
					theClassName="WEB通用流程接口";
					OrdersProcess ordersProcess = new OrdersProcess();
					ordersProcess.getinfo(request, response, RequestJson, info);
					
				}
				
				else if (Path.equals("web/amdin/dowithdraw")) {
					
					theClassName="WEB撤回功能";
					DoWithdraw doWithdraw = new DoWithdraw();
					doWithdraw.Withdraw(request, response, RequestJson, info);
					
				}
				
				else if (Path.equals("web/amdin/doorders")) {
					
					theClassName="WEB接单操作";
					DoOrders doOrders = new DoOrders();
					doOrders.doOrders(request, response, RequestJson, info);
					
				}
				
				else if (Path.equals("web/amdin/doreject")) {
					
					theClassName="WEB驳回操作";
					DoReject doreject = new DoReject();
					doreject.dobohui(request, response, RequestJson, info);
					
				}
				
				else if (Path.equals("web/amdin/dorejected")) {
					
					theClassName="WEB拒绝操作";
					DoReject doreject = new DoReject();
					doreject.dobohui(request, response, RequestJson, info);
					
				}*/
				else if (Path.equals("web/amdin/doadopt")) {
					
					theClassName="WEB通过接口";
					DoAdopt doAdopt = new DoAdopt();
					doAdopt.Doadp(request, response, RequestJson, info);
					
				}
				
				else if(Path.equals("web/do/doDelSysDictionary")){
					theClassName="WEB删除数组字典";
					DoDelSysDictionary doDelDic = new DoDelSysDictionary();
					doDelDic.del(request, response, RequestJson, info);
				}
				
				else if(Path.equals("web/do/doDelSysDictionaryInfo")){
					theClassName="WEB删除数组字典值";
					DoDelSysDictionary doDelDic = new DoDelSysDictionary();
					doDelDic.delInfo(request, response, RequestJson, info);
				}
				//删除教师相关警官学院 gf start
				else if(Path.equals("web/do/doDelTeacher")){
					theClassName="WEB删除教师相关";
					BankConfigService doDelBank = new BankConfigService();
					doDelBank.del(request, response, RequestJson, info);
				}
				
				else if(Path.equals("web/do/doDelArrTeacher")){
					theClassName="WEB删除排课教师配置";
					BankConfigService doDelBank = new BankConfigService();
					doDelBank.delArrange(request, response, RequestJson, info);
				}
				else if(Path.equals("web/do/doDelArrDep")){
					theClassName="WEB删除排课部门配置";
					BankConfigService doDelBank = new BankConfigService();
					doDelBank.delArrangeDep(request, response, RequestJson, info);
				}
				else if(Path.equals("web/do/doDelTime")){
					theClassName="WEB删除排课时间配置";
					BankConfigService doDelBank = new BankConfigService();
					doDelBank.delTime(request, response, RequestJson, info);
				}
				
				else if(Path.equals("web/do/doDelArrange")){
					theClassName="WEB删除排课安排表";
					ArrangeConfigService arrService = new ArrangeConfigService();
					arrService.delArrange(request, response, RequestJson, info);
				}
				else if(Path.equals("web/do/doDelTask")){
					theClassName="WEB删除任务书里单条数据";
					ArrangeConfigService arrService = new ArrangeConfigService();
					arrService.delDelTask(request, response, RequestJson, info);
				}
				else if(Path.equals("web/do/doDelTasks")){
					theClassName="WEB删除任务书";
					ArrangeConfigService arrService = new ArrangeConfigService();
					arrService.delDelTasks(request, response, RequestJson, info);
				}
				
				else if(Path.equals("web/do/teacherMany")){
					theClassName="WEB多教师判断";
					ArrangeConfigService arrService = new ArrangeConfigService();
					arrService.teacherMany(request, response, RequestJson, info);
				}
				
				else if(Path.equals("web/do/getTeacherWeek")){
					theClassName="WEB显示教师已设置周次";
					BankConfigService doDelBank = new BankConfigService();
					doDelBank.findTeacherWeek(request, response, RequestJson, info);
				}
				else if(Path.equals("web/do/getTimeWeek")){
					theClassName="WEB显示时间已设置周次";
					BankConfigService doDelBank = new BankConfigService();
					doDelBank.findTimeWeek(request, response, RequestJson, info);
				}
				else if(Path.equals("web/do/getDepWeek")){
					theClassName="WEB显示部门已设置周次";
					BankConfigService doDelBank = new BankConfigService();
					doDelBank.findDepWeek(request, response, RequestJson, info);
				}
				
				//保存周计划分配相关警官学院
				else if(Path.equals("web/do/doSaveWeek")){
					theClassName="WEB保存周分配计划";
					BankConfigService doDelBank = new BankConfigService();
					doDelBank.save(request, response, RequestJson, info);
				}
				//学生导入登录user_worker
				else if(Path.equals("web/do/inUserWorker")){
					theClassName="WEB 学生导入user_worker";
					ImportConfigService config = new ImportConfigService();
					config.studentInWorker(request, response, RequestJson, info);
				}
				//教职工导入登录user_worker
				else if(Path.equals("web/do/TerinUserWorker")){
					theClassName="WEB 教师导入user_worker";
					ImportConfigService config = new ImportConfigService();
					config.teacherInWorker(request, response, RequestJson, info);
				}
				//gf end
				
				//ajax查询数据，无处理数据动作接口
				
				else if(Path.equals("web/get/teaching_plan")){
					theClassName = "WEB 查询教学计划详情" ;
					BankConfigService doDelBank = new BankConfigService();
					doDelBank.findTeachingPlan(request, response, RequestJson, info);
				}
				else if(Path.equals("web/get/teaching_plan1")){
					theClassName = "WEB 教师id获取课程班级信息";
					BankConfigService doDelBank = new BankConfigService();
					doDelBank.findTeachingPlan1(request, response, RequestJson, info);
				}
				
				
				else if(Path.equals("web/get/checkRegionNum")){
					theClassName = "WEB 新建查询区域编码是否存在" ;
					RegionConfigService regionConfig = new RegionConfigService();
					regionConfig.check(request, response, RequestJson, info);
				}
/************************************学校文章接口开始*************************************************/
				//学校文章模块
				else if(Path.equals("web/cms/class/add")){
					theClassName = "WEB CMS分类接口-新增分类";
					Add add = new Add(request, response);
					add.Transmit(Token, UUID, USERID, DID, Mdels, NetMode, ChannelId, RequestJson, ip, GPS, GPSLocal, AppKeyType, TimeStart);
				}
			
				else if(Path.equals("web/cms/classify/selectClassify")){
	                	theClassName = "WEB CMS分类接口-查找分类";
	                	SelectClassify selectClassify= new SelectClassify(request, response);
	                	selectClassify.Transmit(Token,UUID, USERID, DID, Mdels, NetMode, ChannelId, RequestJson, ip, GPS, GPSLocal, AppKeyType, TimeStart);
				}
				else if(Path.equals("web/cms/classify/selectClassifyById")){
                	theClassName = "WEB CMS分类接口-通过id查找分类";
                	SelectClassifyById selectClassifyById= new SelectClassifyById(request, response);
                	selectClassifyById.Transmit(Token,UUID, USERID, DID, Mdels, NetMode, ChannelId, RequestJson, ip, GPS, GPSLocal, AppKeyType, TimeStart);
			    }
				else if(Path.equals("web/cms/classify/selectClassifyToDao")){
                	theClassName = "WEB CMS分类接口-内网通过查找导航分类";
                	SelectClassifyToDao selectClassifyById= new SelectClassifyToDao(request, response);
                	selectClassifyById.Transmit(Token,UUID, USERID, DID, Mdels, NetMode, ChannelId, RequestJson, ip, GPS, GPSLocal, AppKeyType, TimeStart);
			    }
				else if(Path.equals("web/cms/classify/selectClassifyToDaoA")){
                	theClassName = "WEB CMS分类接口-后台通过查找导航分类";
                	SelectClassifyToDaoA selectClassifyByIdA= new SelectClassifyToDaoA(request, response);
                	selectClassifyByIdA.Transmit(Token,UUID, USERID, DID, Mdels, NetMode, ChannelId, RequestJson, ip, GPS, GPSLocal, AppKeyType, TimeStart);
			    }
				else if(Path.equals("web/attachment/selectIdByPath")){
                	theClassName = "WEB 附件接口";
                	SelectIdByPath selectClassifyById= new SelectIdByPath(request, response);
                	selectClassifyById.Transmit(Token,UUID, USERID, DID, Mdels, NetMode, ChannelId, RequestJson, ip, GPS, GPSLocal, AppKeyType, TimeStart);
			    }
				else if(Path.equals("web/cms/classify/editClassify")){
                	theClassName = "WEB CMS分类接口-编辑分类";
                	EditClassify editClassify= new EditClassify(request, response);
                	editClassify.Transmit(Token,UUID, USERID, DID, Mdels, NetMode, ChannelId, RequestJson, ip, GPS, GPSLocal, AppKeyType, TimeStart);
			    }
				else if(Path.equals("web/cms/classify/delClassify")){
                	theClassName = "WEB CMS分类接口-删除分类";
                	Delclassify editClassify= new Delclassify(request, response);
                	editClassify.Transmit(Token,UUID, USERID, DID, Mdels, NetMode, ChannelId, RequestJson, ip, GPS, GPSLocal, AppKeyType, TimeStart);
			    }
                else if(Path.equals("web/cms/articles/addArticles")){
                	theClassName = "WEB CMS文章接口-添加文章";
					AddArticles addArticles = new AddArticles(request, response);
					addArticles.Transmit(Token, UUID, USERID, DID, Mdels, NetMode, ChannelId, RequestJson, ip, GPS, GPSLocal, AppKeyType, TimeStart);
				}
                else if(Path.equals("web/cms/articles/selectArticles")){
                	theClassName = "WEB CMS文章接口-查询文章";
					SelectArticles selectArticles = new SelectArticles(request, response);
					selectArticles.Transmit(Token,UUID, USERID, DID, Mdels, NetMode, ChannelId, RequestJson, ip, GPS, GPSLocal, AppKeyType, TimeStart);
				}
                else if(Path.equals("web/cms/articles/selectArticlesState")){
                	theClassName = "WEB CMS文章接口-赋予审核权限的用户查询文章";
					SelectArticles selectArticles = new SelectArticles(request, response);
					selectArticles.Transmit(Token,UUID, USERID, DID, Mdels, NetMode, ChannelId, RequestJson, ip, GPS, GPSLocal, AppKeyType, TimeStart);
				}
                else if(Path.equals("web/cms/articles/selectArticlesByState")){
                	theClassName = "WEB CMS文章接口-通过审核状态查询文章";
                	SelectArticlesByState selectArticlesByState = new SelectArticlesByState(request, response);
                	selectArticlesByState.Transmit(Token,UUID, USERID, DID, Mdels, NetMode, ChannelId, RequestJson, ip, GPS, GPSLocal, AppKeyType, TimeStart);
				}
                else if(Path.equals("web/cms/articles/selectArticlesName")){
                	theClassName = "WEB CMS文章接口-内网查询导航栏文章";
					SelectArticlesName selectArticles = new SelectArticlesName(request, response);
					selectArticles.Transmit(Token,UUID, USERID, DID, Mdels, NetMode, ChannelId, RequestJson, ip, GPS, GPSLocal, AppKeyType, TimeStart);
				}
                else if(Path.equals("web/cms/articles/selectArticlesNameAdmin")){
                	theClassName = "WEB CMS文章接口-后台导航对应栏目查询文章";
					SelectArticlesNameAdmin selectArticles = new SelectArticlesNameAdmin(request, response);
					selectArticles.Transmit(Token,UUID, USERID, DID, Mdels, NetMode, ChannelId, RequestJson, ip, GPS, GPSLocal, AppKeyType, TimeStart);
				}
                else if(Path.equals("web/publicInformation/selectMultistage")){
                	theClassName = "WEB 公共信息多级联动-院系-教研室";
                	SelectMultistage selectMultistage = new SelectMultistage(request, response);
                	selectMultistage.Transmit(Token,UUID, USERID, DID, Mdels, NetMode, ChannelId, RequestJson, ip, GPS, GPSLocal, AppKeyType, TimeStart);
				}
				//
                else if(Path.equals("web/users/selectUserBydtp")){
                	theClassName = "WEB 查找人员";
                	SelectUserBydtp selectUserBydtp = new SelectUserBydtp(request, response);
                	selectUserBydtp.Transmit(Token,UUID, USERID, DID, Mdels, NetMode, ChannelId, RequestJson, ip, GPS, GPSLocal, AppKeyType, TimeStart);
				}
                else if(Path.equals("web/users/selectUserBydIds")){
                	theClassName = "WEB 通过id集查找所有人员";
                	SelectUserBydIds selectUserBydtp = new SelectUserBydIds(request, response);
                	selectUserBydtp.Transmit(Token,UUID, USERID, DID, Mdels, NetMode, ChannelId, RequestJson, ip, GPS, GPSLocal, AppKeyType, TimeStart);
				}
				//通过栏目id查找拥有该栏目审核和发布权限的所有人员
                else if(Path.equals("web/users/selectUserBycmsId")){
                	theClassName = "WEB 通过栏目id查找所有人员";
                	SelectUserBycmsId selectUserBydtp = new SelectUserBycmsId(request, response);
                	selectUserBydtp.Transmit(Token,UUID, USERID, DID, Mdels, NetMode, ChannelId, RequestJson, ip, GPS, GPSLocal, AppKeyType, TimeStart);
				}
				//通过用户id查找用户姓名
                else if(Path.equals("web/users/selectUserBydId")){
                	theClassName = "WEB 通过id查找对应人的名字";
                	SelectUserBydId selectUserBydtp = new SelectUserBydId(request, response);
                	selectUserBydtp.Transmit(Token,UUID, USERID, DID, Mdels, NetMode, ChannelId, RequestJson, ip, GPS, GPSLocal, AppKeyType, TimeStart);
				}
                else if(Path.equals("web/cms/articles/selectArticlesById")){
                	theClassName = "WEB CMS文章接口-通过id查询文章";
                	SelectArticlesById selectArticlesById = new SelectArticlesById(request, response);
                	selectArticlesById.Transmit(Token,UUID, USERID, DID, Mdels, NetMode, ChannelId, RequestJson, ip, GPS, GPSLocal, AppKeyType, TimeStart);
				}
				//删除栏目的时候判断该栏目是否被文章使用
                else if(Path.equals("web/cms/articles/selectArticlesByTwoId")){
                	theClassName = "WEB CMS文章接口-通过TwoId查询文章用来判断栏目是否被占用";
                	SelectArticlesByName selectArticlesById = new SelectArticlesByName(request, response);
                	selectArticlesById.Transmit(Token,UUID, USERID, DID, Mdels, NetMode, ChannelId, RequestJson, ip, GPS, GPSLocal, AppKeyType, TimeStart);
				}
                else if(Path.equals("web/cms/articles/editArticles")){
                	theClassName = "WEB CMS文章接口-编辑文章";
                	EditArticles editArticles= new EditArticles(request, response);
                	editArticles.Transmit(Token,UUID, USERID, DID, Mdels, NetMode, ChannelId, RequestJson, ip, GPS, GPSLocal, AppKeyType, TimeStart);
				}
                else if(Path.equals("web/cms/articles/editOpinion")){
                	theClassName = "WEB CMS文章接口-审核文章";
                	EditOpinion editOpinion= new EditOpinion(request, response);
                	editOpinion.Transmit(Token,UUID, USERID, DID, Mdels, NetMode, ChannelId, RequestJson, ip, GPS, GPSLocal, AppKeyType, TimeStart);
				}
                else if(Path.equals("web/cms/articles/delArticles")){
                	theClassName = "WEB CMS文章接口-删除文章";
                	DelArticles delArticles= new DelArticles(request, response);
                	delArticles.Transmit(Token,UUID, USERID, DID, Mdels, NetMode, ChannelId, RequestJson, ip, GPS, GPSLocal, AppKeyType, TimeStart);
				}
	/************************************学校文章接口结束*************************************************/
	//教学计划模块接口目前没有用到
                else if(Path.equals("web/plan/editOpinion")){
                	theClassName = "WEB 教学计划每个字段修改";
                	EditPlan editPlan= new EditPlan(request, response);
                	editPlan.Transmit(Token,UUID, USERID, DID, Mdels, NetMode, ChannelId, RequestJson, ip, GPS, GPSLocal, AppKeyType, TimeStart);
				}
				else if(Path.equals("web/plan/selectCourses")){
                	theClassName = "WEB 通过院系id查找课程";
                	SelectCourses selectCourses= new SelectCourses(request, response);
                	selectCourses.Transmit(Token,UUID, USERID, DID, Mdels, NetMode, ChannelId, RequestJson, ip, GPS, GPSLocal, AppKeyType, TimeStart);
				}
				
				//#web接口说明#
				//#新增一条web映射#
				 //小类类其他情况
				  else {
					 ErrMsg.falseErrMsg(request, response,"404", "web模块没有对应的资源路径");
				  }
				// 性能debug输出
				TimeEnd = Calendar.getInstance().getTimeInMillis();
				System.out.println();
				System.out.println("============================");
				System.out.println("appid 	:"+AppId);
				System.out.println("appkey	:"+AppKey);
				System.out.println("Token	:"+Token);
				System.out.println("UUID	:"+UUID);
				System.out.println("USERID	:"+USERID);
				System.out.println("模块           :"+Path);
				System.out.println("模块说明 :"+theClassName);
				System.out.println("业务信息 :"+RequestJson);
				System.out.println("耗时:"+(TimeEnd - TimeStart) + "ms");
				return;
				// web 大类模块结束	
			}else if(Path.indexOf("common/")!=-1){
				//common大类  ， 公共接口
				if(Path.equals("common/get/vin")){
					theClassName = "通过vin码查询车型" ;
					GetVinToModelController getVinToModelController = new GetVinToModelController();
					getVinToModelController.getVin(request, response, RequestJson, info);
				}
					
				
				else {//#common接口说明# #新增一条common映射# //小类类其他情况
					
					ErrMsg.falseErrMsg(request, response,"404", "app模块没有对应的资源路径");
					
				}
				// 性能debug输出
				TimeEnd = Calendar.getInstance().getTimeInMillis();
				System.out.println();
				System.out.println("============================");
				System.out.println("appid 	:"+AppId);
				System.out.println("appkey	:"+AppKey);
				System.out.println("模块           :"+Path);
				System.out.println("模块说明 :"+theClassName);
				System.out.println("业务信息 :"+RequestJson);
				System.out.println("耗时:"+(TimeEnd - TimeStart) + "ms");
				return;
			}else{//大类其他情况
				ErrMsg.falseErrMsg(request, response,"404", "没有对应的资源路径");
			}
		// 性能debug输出
		TimeEnd = Calendar.getInstance().getTimeInMillis();
		System.out.println();
		System.out.println("============================");
		System.out.println("appid 	:"+AppId);
		System.out.println("appkey	:"+AppKey);
		System.out.println("模块           :"+Path);
		System.out.println("业务信息 :"+RequestJson);
		System.out.println("耗时:"+(TimeEnd - TimeStart) + "ms");
	}
}
