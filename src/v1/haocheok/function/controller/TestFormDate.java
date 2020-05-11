package v1.haocheok.function.controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.ResultSet;
import java.sql.SQLException;
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
import service.sys.ErrMsg;
import v1.haocheok.commom.entity.InfoEntity;
  
public class TestFormDate {
	/**
	 * 测试接收from表单
	 * @param request
	 * @param response
	 * @param RequestJson
	 * @param info
	 * @throws ServletException
	 * @throws IOException
	 */
	@SuppressWarnings("unchecked")
	public void testFormDate(HttpServletRequest request, HttpServletResponse response, String RequestJson, InfoEntity info) throws ServletException, IOException {

		Jdbc db = new Jdbc();
		Page page = new Page();

		String claspath = this.getClass().getName();//当前类名
		
		String classname = "测试接收from表单";
		response.setContentType("text/html;charset=UTF-8");
		request.setCharacterEncoding("UTF-8");
		response.setCharacterEncoding("UTF-8");

		PrintWriter out = response.getWriter();
		JSONObject json = new JSONObject();
		
		//定义接收变量值
		String from_name = ""; //表单名称  【数据库表名】
		
		String sqlStr="";
		
		
		ArrayList<String> list_key= new ArrayList<String>();//key 集合
		ArrayList<String> list_value= new ArrayList<String>();//value 集合
		ArrayList<String> lists= new ArrayList<String>();//更新语句集合    key=value

		int iforderid=0;//订单是否存在
		int stat=0;//更新==0，写入==1
		String orderid="";//订单id
		
		try { // 解析开始

			System.out.println("测试接收from表单：" + RequestJson);

			
			JSONObject field;
			JSONArray from_date = JSONArray.fromObject("[" + RequestJson + "]");
			
			for (int i = 0; i < from_date.size(); i++) {
				JSONObject obj = from_date.getJSONObject(i);
				from_name = obj.get("formName") + "";
				field=JSONObject.fromObject(obj.get("content"));
				Iterator keys = field.keys();  
				while(keys.hasNext()){  
				    String key = keys.next().toString();
				    String value=field.get(key).toString();
				    //拼接更新语句 
		    		
		    		list_key.add("'"+key+"'");
		    		list_value.add("'"+value+"'");
		    		lists.add("'"+key+"'="+"'"+value+"'");
		    		
		    		
				    //判断orderid 是否存在表单数据表
		    		//如果表单是新创建的 orderid 默认值为0 
				    if(key.equals("orderid")){
				    	orderid=value;
				    	iforderid=db.Row("select count(1) as row from "+from_name+" where orderid="+orderid);
				    }
				}

			}
		}catch (Exception e) {
			ErrMsg.falseErrMsg(request, response, "500", "json格式解析异常");
			return;
		}
		
		if(iforderid>0){//存在数据库
    		//提取原有数据
    		ResultSet rs = db.executeQuery("select * from "+from_name+" where orderid="+orderid);
    		try {
				String log=Page.resultSetToJson(rs);//获取json 串
			} catch (SQLException e) {
				e.printStackTrace();
				
			}
    		
    		//留痕
//    		String logsql="";//写入表单留痕日志表
//    		boolean state=db.executeUpdate(logsql);
//    		if(state==false){//写入留痕日志表失败 程序结束
//    			//通知管理员 （发送邮件）
//    			//记录日志
//					long ExeTime = Calendar.getInstance().getTimeInMillis()-info.getTimeStart();
////					Atm.AppuseLong(info, username,  claspath, classname, responsejson, ExeTime);
////					//添加操作日志
////					Atm.LogSys("登陆", "用户APP端登录失败", "用户:"+mobile+" 手机端没有对应角色", "1",info.getUSERID(), info.getIp());
//				//返回前台友好信息
//    			json.put("success", "true");
//				json.put("resultCode", "500");
//				json.put("msg", "网络异常！请稍后重试");
//    			out.print(json);
//    			//程序结束
//    			Page.colseDOP(db, out, page);
//    		}
    		//拼接更新语句
    		sqlStr="UPDATE ec_members  SET  "+lists.toString().replaceAll("\\[", "").replaceAll("\\]", "")+ " where orderid='"+orderid+"';";
    		System.out.println("拼接更新语句=="+sqlStr);
    	}else{//不存在
    		
    		//拼接写入语句
    		sqlStr="INSERT INTO ec_members "+
	    				list_key.toString().replaceAll("\\[", "(").replaceAll("\\]", ")")
	    		      +" VALUES "+
	    		        list_value.toString().replaceAll("\\[", "(").replaceAll("\\]", ")")+
	    		        ";";
    		System.out.println("拼接写入语句=="+sqlStr);
    	}
		
		//执行表单数据写入|更新
//	    boolean upstate=db.executeUpdate(sqlStr);
	    
//	    if(upstate){
//	    	
//			json.put("success", "true");
//			json.put("resultCode", "1000");
//			json.put("msg", "接收表单数据成功");
//			
//	    }else{
//	    	json.put("success", "true");
//			json.put("resultCode", "500");
//			json.put("msg", "接收表单数据失败");
//			
//			//通知管理员 （发送邮件）
//	    }
//	    
		
	    //返回前台
	    out.print(json);
	    //记录日志
	    
	    
		//程序结束
		Page.colseDOP(db, out, page);

	}
	
	
	
	
	
	
	public static void main(String[] args) {
		String RequestJson="{\"formName\":\"f_test\",\"content\":{\"orderid\":\"订单id1\",\"key1\":1,\"key2\":2,\"key3\":3,\"key4\":4,\"key5\":5}}";
		JSONObject field;
		String from_name="";
		JSONArray from_date = JSONArray.fromObject("[" + RequestJson + "]");
		for (int i = 0; i < from_date.size(); i++) {
			JSONObject obj = from_date.getJSONObject(i);
			from_name = obj.get("formName") + "";
			field=JSONObject.fromObject(obj.get("content"));
			 Iterator keys = field.keys();  
			while(keys.hasNext()){  
			    String key = keys.next().toString(); 
				System.out.println("key=="+key+"   value=="+field.get(key));
			}
		}
	}
}
