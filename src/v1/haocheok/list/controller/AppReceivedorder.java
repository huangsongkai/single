package v1.haocheok.list.controller;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import service.dao.db.Jdbc;
import service.dao.db.Page;
import service.sys.ErrMsg;
import v1.haocheok.commom.entity.InfoEntity;
import v1.haocheok.list.service.impl.ReceivelistServiceImpl;
import v1.haocheok.list.service.impl.WaitingServiceImpl;

public class AppReceivedorder {

	public void Receivedorder(HttpServletRequest request, HttpServletResponse response,String RequestJson,InfoEntity info) throws ServletException, IOException {

		Jdbc db = new Jdbc();
		Page page = new Page();

        String claspath=this.getClass().getName();//当前类名
        
		response.setContentType("text/html;charset=UTF-8");
		request.setCharacterEncoding("UTF-8");
		response.setCharacterEncoding("UTF-8");
		
    	PrintWriter out = response.getWriter();
	    	
    		//定义接收变量值
           	String userid="";
           	String rolecode="";
		   
		   try { // 解析开始
			   
			   System.out.println("待结单列表模块接收数据："+RequestJson);
			   
			   JSONArray arr = JSONArray.fromObject("[" + RequestJson + "]");
			   
			   for (int i = 0; i < arr.size(); i++) {
				   JSONObject obj = arr.getJSONObject(i);
				   rolecode = obj.get("rolecode") + "";
			   }
		   }catch(Exception e){
			   ErrMsg.falseErrMsg(request, response, "500", "json格式解析异常");
			   return;
		   }
		 
/*
			//判断过滤非法字符: 
		    if(!Page.regex(userid) || !Page.regex(userid)){ 
		    	ErrMsg.falseErrMsg(request, response, "500", "数据格式不匹配");
			    Page.colseDOP(db, out, page);
			    return;//跳出程序只行 
		    }    
			    */
			//token 认证过滤
		    System.out.println("token 认证过滤==="+"SELECT COUNT(*) as row FROM  user_worker WHERE uid ='"+info.getUSERID()+"' AND app_token='"+ info.getToken() + "'");
			int TokenTag=db.Row("SELECT COUNT(*) as row FROM  user_worker WHERE uid ='"+info.getUSERID()+"' AND app_token='"+ info.getToken() + "'");
			if(TokenTag!=1){
				ErrMsg.falseErrMsg(request, response, "403", "请登录！");
				Page.colseDOP(db, out, page);
				return;//跳出程序只行 
			}  
			  
			//调用应用层实现类接口
			ReceivelistServiceImpl receivelistServiceImpl = new ReceivelistServiceImpl();
			String outputString = receivelistServiceImpl.getReceivedlist(rolecode, info);
				
			outputString = "{\"success\":true,\"msg\":\"操作成功\",\"resultCode\":\"1000\",\"info\":[{\"orderid\":28,\"ordercode\":\"201606141465895998714\",\"loanname\":\"刘浩然\",\"loantype\":\"抵押贷款\",\"loanmode\":\"贷后贷缴\",\"phone\":\"13694067782\",\"familyaddress\":\"黑龙江省哈尔滨友谊小区\"},{\"orderid\":29,\"ordercode\":\"201606141465895998714\",\"loanname\":\"刘德华\",\"loantype\":\"抵押贷款\",\"loanmode\":\"贷后贷缴\",\"phone\":\"13694067782\",\"familyaddress\":\"黑龙江省哈尔滨友谊小区12132123\"}]}";
			out.println(outputString);
			
			//记录日志
			page.colseDP(db, page);
			out.flush();
			out.close();
	}
	
	
}
