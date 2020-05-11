package service.common;
import java.io.IOException;
import java.net.URLEncoder;
import java.util.HashMap;
import java.util.Map;

import net.sf.json.JSONObject;

import org.apache.http.HttpException;

import service.net.HttpRequest;

public class sendVoice {

	public static String Send_Msg(String phone,String callinfo) throws IOException{
		 String result="";
		 
			 
		 String url = "http://apiv2.haocheok.com/api/v2.0/common/sendVoice?mobile="+phone+"&content="+URLEncoder.encode(callinfo,"UTF-8")+"&type=message"; 
		Map<String, String> headers = new HashMap<String, String>();
		headers.put("X-AppId", "d42b46df6e583ca9a1b3c819dc42cfas");
		headers.put("X-AppKey", "w19b2s4b8f749c10v2c4c125tc62cdek");
		headers.put("Content-Type", "application/json; charset=utf-8");
		headers.put("Accept", "application/json; charset=utf-8");
		JSONObject data = new JSONObject();
      // data.put("access_token", access_token);
       try {
	     	result=HttpRequest.get(url, headers, data);
	     	//System.out.println(data.toString());
   } catch (HttpException e) {
        	result="err：网络错误-"+Thread.currentThread().getStackTrace()[1].getMethodName();
     e.printStackTrace();
   }
	  return result;
	}
	
	
	/**
	 * @param args
	 */
	public static void main(String[] args) {
		try {
			System.out.println(Send_Msg("13846288168","您好，田斌！友兔租房提醒您，房租3天后到期，请续费，姿势不对起来重睡，再见！"));
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

	}

}
