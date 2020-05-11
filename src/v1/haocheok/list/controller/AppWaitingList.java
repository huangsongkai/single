package v1.haocheok.list.controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import service.dao.db.Jdbc;
import service.dao.db.Page;
import service.sys.ErrMsg;
import v1.haocheok.commom.common;
import v1.haocheok.commom.entity.InfoEntity;
import v1.haocheok.list.service.impl.WaitingServiceImpl;

public class AppWaitingList {

	public void waitingList(HttpServletRequest request, HttpServletResponse response,String RequestJson,InfoEntity info) throws ServletException, IOException {

		Jdbc db = new Jdbc();
		Page page = new Page();

        String claspath=this.getClass().getName();//当前类名
        
		response.setContentType("text/html;charset=UTF-8");
		request.setCharacterEncoding("UTF-8");
		response.setCharacterEncoding("UTF-8");
		
    	PrintWriter out = response.getWriter();
	    	
    		//定义接收变量值
    		String regionalcode="";
           	String rolecode="";
           	String keyword="";      // 查询关键词
		    String Dpage = "1";     //当前页面
			String listnum="10";    //每页条数
			String buttoncode = "";
		   
		   try { // 解析开始
			   
			   System.out.println("待结单列表模块接收数据："+RequestJson);
			   
			   JSONArray arr = JSONArray.fromObject("[" + RequestJson + "]");
			   
			   for (int i = 0; i < arr.size(); i++) {
				   JSONObject obj = arr.getJSONObject(i);
				   rolecode = obj.get("rolecode") + "";
				   regionalcode = obj.get("regionalcode") + "";
				   keyword= obj.get("keywd") + "";
				   Dpage = obj.get("page") + "";
				   listnum = obj.get("listnum") + "";
				   buttoncode = obj.get("buttoncode") + "";
				   
			   }
		   }catch(Exception e){
			   ErrMsg.falseErrMsg(request, response, "500", "json格式解析异常");
			   return;
		   }
		 
		   System.out.println(keyword);
			//判断过滤非法字符: 
		    /*if(!Page.regex(userid) || !Page.regex(userid)){ 
		    	ErrMsg.falseErrMsg(request, response, "500", "数据格式不匹配");
			    Page.colseDOP(db, out, page);
			    return;//跳出程序只行 
		    }   */ 
			    
			//token 认证过滤
		    System.out.println("token 认证过滤==="+"SELECT COUNT(*) as row FROM  user_worker WHERE uid ='"+info.getUSERID()+"' AND app_token='"+ info.getToken() + "'");
			int TokenTag=db.Row("SELECT COUNT(*) as row FROM  user_worker WHERE uid ='"+info.getUSERID()+"' AND app_token='"+ info.getToken() + "'");
			if(TokenTag!=1){
				ErrMsg.falseErrMsg(request, response, "403", "请登录！");
				Page.colseDOP(db, out, page);
				return;//跳出程序只行 
			}  
			//获取分页信息
			if(Dpage==null || Dpage.indexOf("null")!=-1  ||  Dpage.length()<1){Dpage="1";}
			if(listnum==null || listnum.indexOf("null")!=-1 ||  listnum.length()<1){listnum="10";}
			if(keyword==null || keyword.indexOf("null")!=-1 || keyword.length()==0){keyword="";}

			//分页计算
			HashMap<String, Object> map = common.pagenumMap(Dpage, listnum);

			//调用应用层实现类接口
			WaitingServiceImpl waitingServiceImpl = new WaitingServiceImpl();
			String outputString = waitingServiceImpl.getwaitingList(rolecode,regionalcode ,info,map,keyword,buttoncode);
			out.println(outputString);
			
			//记录日志
			page.colseDP(db, page);
			out.flush();
			out.close();
	}
	
	
}
