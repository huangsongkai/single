package v1.haocheok.function.controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Iterator;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import service.dao.db.Jdbc;
import service.dao.db.Page;
import service.sys.Atm;
import service.sys.ErrMsg;
import v1.haocheok.commom.common;
import v1.haocheok.commom.controller.AdoptController;
import v1.haocheok.commom.entity.InfoEntity;

/**
 * 
 * @company 010jiage
 * @author wangxudong(1503631902@qq.com)
 * @date:2017-10-17 上午08:20:10
 */
public class DoFormDataController {
	@SuppressWarnings("unchecked")
	public void DoFormData(HttpServletRequest request, HttpServletResponse response, String RequestJson, InfoEntity info) throws ServletException, IOException {

		Jdbc db = new Jdbc();
		Page page = new Page();

		String claspath = this.getClass().getName();//当前类名
		String classname = "接收万能表单";
		
		response.setContentType("text/html;charset=UTF-8");
		request.setCharacterEncoding("UTF-8");
		response.setCharacterEncoding("UTF-8");
		
		String username = common.getusernameTouid(info.getUSERID());
		PrintWriter out = response.getWriter();
		JSONObject json = new JSONObject();
		
		//定义接收变量值
		String from_name="";   //表单名称  【数据库表名】
		String nodeid="";      //节点id  
		String processid="";   //流程id 
		String placeid="";     //订单id
		String common="";      //意见
		String dateid="";      //当前数据id  如果为零=写入
		String sqlStr="";      //
		
		
		
		//拦截登陆信息
        int TokenTag=db.Row("SELECT COUNT(1) as row FROM  user_worker WHERE uid ='"+info.getUSERID()+"' AND app_token='"+ info.getToken() + "'");
		if(TokenTag!=1){
			ErrMsg.falseErrMsg(request, response, "403", "请登录！");
			Page.colseDOP(db, out, page);
			return;//跳出程序只行 
		} 
		
		ArrayList<String> listfather= new ArrayList<String>();      //更新语句集合    key=value

		int iforderid=0;//订单是否存在
		//int stat=0;//更新==0，写入==1
		
		
		try { // 解析开始
			JSONArray formdateArr;
			
			JSONArray from_date = JSONArray.fromObject("[" + RequestJson + "]");
			for (int i = 0; i < from_date.size(); i++) {
				
				JSONObject obj = from_date.getJSONObject(i);
				nodeid = obj.get("nodeid") + "";      //节点id
				processid = obj.get("processid") + "";//流程id
				placeid = obj.get("placeid") + "";    //订单id
				
				formdateArr=JSONArray.fromObject(obj.get("content"));
				//解析表单数据
				for (int j = 0; j < formdateArr.size(); j++) {
					ArrayList<String> list_key= new ArrayList<String>();   //key 集合
					ArrayList<String> list_value= new ArrayList<String>(); //value 集合
					
					JSONObject jsonsqlDate = new JSONObject();//更新语句，与表名称3
					ArrayList<String> listson= new ArrayList<String>();    //更新语句集合    key=value
					
					
					JSONObject formDate;
					
					JSONObject formObj = formdateArr.getJSONObject(j);
					from_name = formObj.get("formname") + "";    //表单名称
					dateid = formObj.get("dateid") + "";      //当前表单唯一id  dateid=0  执行写入    else  执行更新
					//判断该订单是否存在
					iforderid=db.Row("select count(1) as row from "+from_name+" where orderid="+placeid);
					
					
					formDate=JSONObject.fromObject(formObj.get("content"));

					Iterator keys = formDate.keys();
					while(keys.hasNext()){ 
					    String key = keys.next().toString();
					    String value=formDate.get(key).toString();
					    //拼接更新语句 
			    		list_key.add("`"+key+"`");
			    		list_value.add("'"+value+"'");
			    		listson.add(""+key+"="+"'"+value+"'");
			    		
			    		//备注  所有表单 的 备注字段为  remarks
					    if(key.equals("remarks")){
					    	common=value;
					    }
					}
					//更新语句编写
					String sql="";
					if(iforderid>0){//当前表单已存在数据
						//编写更新语句
						if("0".equals(dateid)){
							sql="UPDATE  "+from_name+" SET "+listson.toString().replaceAll("\\[","").replaceAll("\\]","")+" ,updatetime=now()  ,updateid='"+info.getUSERID()+"'  where orderid='"+placeid+"';";
						}else{
							sql="UPDATE  "+from_name+" SET "+listson.toString().replaceAll("\\[","").replaceAll("\\]","")+" ,updatetime=now()  ,updateid='"+info.getUSERID()+"'  where id='"+dateid+"';";
						}
					}else{//当前表单不存在数据  
						
						//编写写入语句
						sql="INSERT INTO "+from_name+" "+list_key.toString().replaceAll("\\[", "(").replaceAll("\\[", "")+",`createtime`,`createid`,`updatetime`,`updateid`,`jsontemplate`,`orderid`) VALUES "+list_value.toString().replaceAll("\\[", "(").replaceAll("\\[", "")+",now(),'"+info.getUSERID()+"',now(),'"+info.getUSERID()+"','"+listson.toString().replaceAll("\\[","").replaceAll("\\]","")+"','"+placeid+"' );";
					}
					jsonsqlDate.put("sql", sql);
					jsonsqlDate.put("fromName", from_name);
					listfather.add(jsonsqlDate.toString());
				}
			}
		}catch (Exception e) {
			ErrMsg.falseErrMsg(request, response, "500", "json格式解析异常");
			Page.colseDOP(db, out, page);
			return;
		}
		
	
		//执行数据写入|更新
		for(int i=0;i<listfather.size();i++){
			
			JSONObject form_info =JSONObject.fromObject(listfather.get(i));
			//form_info.get("sql")       //执行的sql语句
			//form_info.get("fromName"); //执行的sql语句的表单
			boolean update_state= db.executeUpdate(form_info.get("sql").toString());
			if(update_state==false){//执行失败
				json.put("success", "true");
    			json.put("resultCode", "500");
    			json.put("msg", "保存表单数据失败——"+form_info.get("fromName"));
    			System.out.println(form_info.get("sql"));	
    			out.println(json);
    			long ExeTime = Calendar.getInstance().getTimeInMillis()-info.getTimeStart();
    			// 记录执行日志
    			Atm.AppuseLong(info, username,  claspath, classname, json.toString(), ExeTime);
    			Atm.LogSys(info.getAppKeyType(), "用户APP端  提交表单数据失败", "保存表单数据失败——："+form_info.get("sql")+" ","1", info.getUSERID(), info.getIp());//添加操作日志
    			//程序结束
    			Page.colseDOP(db, out, page);
    			return;
			}
		}
		
		
		JSONObject json2 = new JSONObject();//通过接口所需数据
		json2.put("placeid",placeid);//订单id
		json2.put("status","6");//状态id
		json2.put("processid",processid);//流程id
		json2.put("common",common);//意见
		json2.put("nodeid",nodeid);//节点id
		
		//调用流程通过接口
		AdoptController adopt = new AdoptController();
		boolean state = adopt.Doappoint(placeid, "6", common, nodeid, processid, info.getUSERID());
		if(state){
			json.put("success", "true");
			json.put("resultCode", "1000");
			json.put("msg", "接收表单数据成功");
		}else{
			json.put("success", "true");
			json.put("resultCode", "500");
			json.put("msg", "提交流程失败");
			long ExeTime = Calendar.getInstance().getTimeInMillis()-info.getTimeStart();
			// 记录执行日志
			Atm.AppuseLong(info, username,  claspath, classname, json.toString(), ExeTime);
			Atm.LogSys(info.getAppKeyType(), "用户APP端  提交流程失败", "提交流程失败   执行sql：{"+sqlStr+"} ","1", info.getUSERID(), info.getIp());//添加操作日志
		}
		
	    //返回前台
	    out.print(json);
System.out.println("json==="+json);
	    //记录日志时间
	    long ExeTime = Calendar.getInstance().getTimeInMillis()-info.getTimeStart();
		// 记录执行日志
		Atm.AppuseLong(info, username,  claspath, classname, json.toString(), ExeTime);
		//添加操作日志
		Atm.LogSys("接收表单数据成功", "用户APP端  提交表单数据", "接收表单数据成功   执行sql：{"+sqlStr+"} ", "0",info.getUSERID(), info.getIp());
		//程序结束
		Page.colseDOP(db, out, page);

	}
}
