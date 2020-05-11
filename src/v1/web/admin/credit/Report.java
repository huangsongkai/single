package v1.web.admin.credit;

import java.io.IOException;
import java.io.PrintWriter;
import java.net.URLDecoder;
import java.util.Calendar;
import java.util.Date;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import service.dao.db.Jdbc;
import service.dao.db.Page;
import service.sys.Atm;
import v1.haocheok.commom.common;
import v1.haocheok.commom.controller.AdoptController;
import v1.haocheok.commom.entity.InfoEntity;
import v1.haocheok.commom.entity.UserEntity;


/**
 * @company 010jiage
 * @author wangxudong(1503631902@qq.com)
 * @date:2017-10-14 下午09:25:31
 *  接收报件表单
 */
public class Report {
	
	public void report(HttpServletRequest request, HttpServletResponse response,String RequestJson,InfoEntity info) throws ServletException, IOException {
	
		Jdbc db = new Jdbc();
		Page page = new Page();

	    String classname="接收报件表单";
        String claspath=this.getClass().getName();

        long TimeStart = new Date().getTime();// 程序开始时间，统计效率
        
		response.setContentType("text/html;charset=UTF-8");
		request.setCharacterEncoding("UTF-8");
		response.setCharacterEncoding("UTF-8");
		
    	PrintWriter out = response.getWriter();
    	
    	JSONObject json = new JSONObject();
    	
		//实体类user信息
    	UserEntity user = (UserEntity)request.getSession().getAttribute("UserList");

		//公用  //客户id，业务员id，经销商，政策类型，银行，所购车型，家访类型，报件类型
		String customerid="",salesman="",distributor="",policy_type="",bank="",purchased_models="",home_visiting_type="",reportType="",pricetype="";
		
		//公用字段  //【{二手车:预评价},{新车:发票价}】  
		String Price="";
		String loantype="";		 	//二手车//贷款类型          
		String toMakeAdvances="0";	//新车    //垫款金额
		int paydetailsId=0;			//缴费明细id	
		int orderid=0;				//订单id
		//缴费明细
		String down_payment_ratio="",amount_of_financing_loans="",actual_loan_amount="",monthly_amount="",guarantee_fee="",performance_bond="",consolidated_service_charge="",service_charge="",collection="",two_grade_rebate="",income="",total="";				        
		
		try {//解析开始
			JSONArray from_date = JSONArray.fromObject("[" + URLDecoder.decode(RequestJson,"UTF8") + "]");
			
			for (int i = 0; i < from_date.size(); i++) {
				
					JSONObject obj = from_date.getJSONObject(i);
					
					//接收公用字段
					customerid     		=obj.getString("customerid");		//客户id    
					salesman      		=obj.getString("salesman");			//业务员id      
					policy_type   		=obj.getString("policy_type");		//政策类型               
					distributor   		=obj.getString("distributor");		//政策类型               
					bank   				=obj.getString("bank");				//银行
					purchased_models   	=obj.getString("purchased_models"); //所购车型   
					home_visiting_type  =obj.getString("home_visiting_type");//家访类型        
					reportType     		=obj.getString("reporttype");		//报件类型          
					pricetype			=obj.getString("pricetype");
					//接收新车字段
					if("2".equals(reportType)){//新车
				          Price      				=  obj.getString("invoiceprice");       		 		//发票价    
				          toMakeAdvances    		=  obj.getString("tomakeadvances");     				//垫款金额  

						  down_payment_ratio 		=obj.getString("down_payment_ratio");	 				//首付比例                                                             
						  amount_of_financing_loans =obj.getString("amount_of_financing_loans");			//上融贷款额                                             
						  actual_loan_amount 		=obj.getString("actual_loan_amount");	 				//实际贷款额                                                           
						  monthly_amount 			=obj.getString("monthly_amount");	 					//月还金额                                                                     
						  guarantee_fee 			=obj.getString("guarantee_fee");	 					//担保费                                                                         
						  performance_bond 			=obj.getString("performance_bond");	 					//履约还款保证金                                                           
						  consolidated_service_charge =obj.getString("consolidated_service_charge");	 	//综合服务费                     
					  	  service_charge 			=obj.getString("service_charge");	 					//服务费                                                                       
						  collection 				=obj.getString("collection");	 						//代收                                                                                 
						  two_grade_rebate 			=obj.getString("two_grade_rebate");	 					//二级返利                                                                 
						  income 					=obj.getString("income");	 							//收入                                                                                         
						  total 					=obj.getString("total");	 							//合计                                                                                           
						
					//接收二手车字段	
					}else{
				          Price       				=  obj.getString("creditrating");       		 		//预评价格           
				          loantype            		=  obj.getString("loantype");      		 		 		//贷款类型                
					}
			}
		}catch(Exception e) {
			long ExeTime = Calendar.getInstance().getTimeInMillis()-TimeStart;// 程序结束时间，统计效率
    		out.print(fail(claspath, classname, RequestJson, ExeTime, info, "解析数据异常 ：【"+e+"】,请重新提交订单","解析数据异常  ：{"+e+"}"));
			Page.colseDOP(db, out, page);
			return;// 程序关闭
		}
		
		//是否执行创建    订单逻辑代码  
		boolean  sheet_state=false;
		
		//执行新车流程
		if("2".equals(reportType)){
			//一写入缴费明细表
			String insert_paydetails="INSERT INTO order_paydetails "+
										"( payments, NAME, loanAmount, actualloan, monthlyamount, guaranteefee, bond, colligatesrevicefee, srevicefee, Collection, twograderebate, income, total, createtime, createid, updatetime, updateid)"+
										"VALUES "+
										"( '"+down_payment_ratio+"', '上融等信息名称', '"+amount_of_financing_loans+"', '"+actual_loan_amount+"', '"+monthly_amount+"', '"+guarantee_fee+"', '"+performance_bond+"', '"+consolidated_service_charge+"', '"+service_charge+"', '"+collection+"', '"+two_grade_rebate+"', '"+income+"', '"+total+"', NOW(), '"+info.getUSERID()+"',NOW(), '"+info.getUSERID()+"');";	
			paydetailsId= db.executeUpdateRenum(insert_paydetails);
			
			if(paydetailsId==0){//写入缴费明细表  失败
				long ExeTime = Calendar.getInstance().getTimeInMillis()-TimeStart;// 程序结束时间，统计效率
				out.print(fail(claspath, classname, RequestJson, ExeTime, info, "写入缴费明细表 失败,请重新提交订单", "写入缴费明细表失败  ：{"+insert_paydetails+"}"));
				Page.colseDOP(db, out, page);
				return;// 程序关闭
			//	写入缴费明细表  成功
			}else{
				sheet_state=true;
			}
			
		//执行二手车流程
		}else{
			sheet_state=true;
		}
		
		//创建    订单逻辑代码
		if(sheet_state){
			
			
			//是否执行提交流程代码 
			boolean  adopt_state=false;
			
			//写入订单数据
			String insert_sheet="INSERT INTO order_sheet "+
										"( processid, customeruid, salesmanname, salesmanid, distributorid, policyid, policyname, bankid, bankname, paymentdetails, models, eveluatetypeid, ordercode, homevisits, evaluateprice, loantype,toMakeAdvances, regionalcode, guaranteenum, state, createtime, createid, updatetime, updateid,pricetype)"+
										"VALUES "+
										"( '"+home_visiting_type+"', '"+customerid+"', (SELECT username FROM user_worker WHERE uid='"+salesman+"'), '"+salesman+"', '"+distributor+"', '"+policy_type+"', (SELECT policyname FROM g_policy WHERE id='"+policy_type+"'), '"+bank+"', (SELECT bankName FROM g_bank WHERE id='"+bank+"'), '"+paydetailsId+"', '"+purchased_models+"', '"+home_visiting_type+"', '"+common.getNumCode()+"', '"+home_visiting_type+"', '"+Price+"', '"+loantype+"','"+toMakeAdvances+"', (SELECT regionalcode FROM user_worker WHERE uid='"+info.getUSERID()+"'), '0', '0', NOW(), '"+info.getUSERID()+"', NOW(), '"+info.getUSERID()+"','"+pricetype+"');";
			orderid=db.executeUpdateRenum(insert_sheet);
			
			//订单创建成功
			if(orderid>0){
				
				//判断流程 
				if("2".equals(reportType)){//新车
					String order_paydetails_sql="UPDATE order_paydetails  SET orderid = '"+orderid+"' WHERE  id = '"+paydetailsId+"' ;";
					
					//更新交费明细失败
					if(db.executeUpdate(order_paydetails_sql)==false){
						long ExeTime = Calendar.getInstance().getTimeInMillis()-TimeStart;// 程序结束时间，统计效率
			        	//进行数据回滚  {删除 缴费明细,删除订单}
						db.executeUpdate("DELETE FROM order_paydetails  WHERE id = '"+paydetailsId+"' ;");
						db.executeUpdate("DELETE FROM order_sheet  WHERE id = '"+orderid+"' ;");
			    		
			    		out.print(fail(claspath, classname, RequestJson, ExeTime, info, "更新交费明细失败","更新交费明细失败：{"+order_paydetails_sql+"}"));
						Page.colseDOP(db, out, page);
						return;// 程序关闭
					//更新交费明细成功
					}else{
						adopt_state=true;
					}
				}else{
					adopt_state=true;
				}
				
				//提交流程：
				if(adopt_state){
					 	AdoptController adopt = new AdoptController();
					 	boolean tong_status = adopt.Doappoint(String.valueOf(orderid),"6","征信通过","1",home_visiting_type,user.getUserid());
				        if(tong_status){
				        	json.put("success", true);
				    		json.put("resultCode", "1000");
				    		json.put("orderid", orderid);
				    		json.put("msg", "提交成功");
				    		out.print(json);
				        }else{
				        	long ExeTime = Calendar.getInstance().getTimeInMillis()-TimeStart;// 程序结束时间，统计效率
				    		out.print(fail(claspath, classname, RequestJson, ExeTime, info, "流程写入失败", "流程写入失败  ：{"+json+"}"));
							Page.colseDOP(db, out, page);
							return;// 程序关闭
				        }
				}
			//订单创建失败
			}else{
				long ExeTime = Calendar.getInstance().getTimeInMillis()-TimeStart;// 程序结束时间，统计效率
	    		out.print(fail(claspath, classname, RequestJson, ExeTime, info, "写入订单主表失败", "写入订单主表失败  ：{"+insert_sheet+"}"));
				Page.colseDOP(db, out, page);
				return;// 程序关闭
			}
			
		}
		
        long ExeTime = Calendar.getInstance().getTimeInMillis()-TimeStart;// 程序结束时间，统计效率
		Atm.AppuseLong(info, "",claspath,classname, "返回的数据", ExeTime);
		Atm.LogSys("报件表单上传", classname, "报件表单上传成功","0", info.getUSERID(), info.getIp());
		Page.colseDOP(db, out, page);
		return;// 程序关闭
	}
	
	
	
	/**
	 * 
	 * @author Administrator
	 * @date 2017-10-15
	 * @Remarks 出错处理方法
	 */
	public static  JSONObject  fail(String claspath,String classname,String RequestJson,long  ExeTime,InfoEntity info,String msg,String sql_str){
		JSONObject json =new JSONObject();
		json.put("success", false);
		json.put("resultCode", "500");
		json.put("msg", msg);
		//记录出错日志
		Atm.AppuseLong(info, "",claspath,classname, RequestJson, ExeTime);
		//记录出错日
		Atm.LogSys("系统错误", classname + "模块系统出错", "写入订单主表失败  ：{"+sql_str+"}","1", info.getUSERID(), info.getIp());
		return json;
	}
	
}

