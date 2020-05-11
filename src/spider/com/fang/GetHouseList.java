package spider.com.fang; 

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.apache.http.HttpException;

import service.net.HttpRequest;
import service.net.RemoteCallUtil;;
 
 

/** 
 * @author LiGaoSong  E-mail: 932246@qq.com 
 * @version 创建时间：2016-11-3 下午10:28:21  
 * 类说明：得到房天下的数据列表
 */
public class GetHouseList {
	
	/***
	 * @category  得到用戶信息的  方法
	 * @param  weixnNo 微信id号
	 * @param  openid 微信用户的 openid
	 */
	
	
	
	
	public static String GetInfo(String url) throws IOException{
		 String result="";
		 
		Map<String, String> headers = new HashMap<String, String>();
		headers.put("Content-Type", "application/json; charset=GBK");
		headers.put("cookie", "JSESSIONID=aaaGZMbsbPzL3d1mjaMYv; global_cookie=534b9624-1497433674581-0c6615c9; global_wapandm_cookie=op4m6epl4mty7977r0uxjqaqs7wj3wtchqm; zhcity=%E5%8C%97%E4%BA%AC; encity=bj; addr=%E5%8C%97%E4%BA%AC%E5%B8%82; sfliveykwap=yk_wap_59411fc5dcced; unique_cookie=U_534b9624-1497433674581-0c6615c9*1; Captcha=334856576F786D345366652F5835756337386F2B6A362F6C50714439567672464B2B4D6B41446C6379702F47384A4B4357324568594F5852514D41733256733761644368482B5A475A6B343D; __utmt_t0=1; __utmt_t1=1; unique_wapandm_cookie=U_op4m6epl4mty7977r0uxjqaqs7wj3wtchqm*18; __utma=147393320.873553647.1497433674.1497440148.1497444371.3; __utmb=147393320.4.10.1497444371; __utmc=147393320; __utmz=147393320.1497433674.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none); mencity=bj");
		headers.put("referer", "https://m.fang.com/zf/bj/s0/");
		headers.put("user-agent", "Mozilla/5.0 (iPhone; CPU iPhone OS 9_1 like Mac OS X) AppleWebKit/601.1.46 (KHTML, like Gecko) Version/9.0 Mobile/13B143 Safari/601.1");

		JSONObject data = new JSONObject();
     	  // data.put("x-requested-with", "XMLHttpRequest");
	   
	  try {
	  	result=HttpRequest.get(url, headers,data);//发送请求
	  	//System.out.println("getok="+result);
    } catch (HttpException e) {
    	result="err：得到房屋信息列表信息网络异常，请重新获得此方法";
   // e.printStackTrace();
    }
    
	  return result;
	}
	
	public static String GetInfo2(String url) throws IOException{
		 String result="";
		 
		Map<String, String> headers = new HashMap<String, String>();
		headers.put("Content-Type", "application/json; charset=GBK");
		headers.put("cookie", "JSESSIONID=aaaGZMbsbPzL3d1mjaMYv; global_cookie=534b9624-1497433674581-0c6615c9; global_wapandm_cookie=op4m6epl4mty7977r0uxjqaqs7wj3wtchqm; zhcity=%E5%8C%97%E4%BA%AC; encity=bj; addr=%E5%8C%97%E4%BA%AC%E5%B8%82; sfliveykwap=yk_wap_59411fc5dcced; unique_cookie=U_534b9624-1497433674581-0c6615c9*1; Captcha=334856576F786D345366652F5835756337386F2B6A362F6C50714439567672464B2B4D6B41446C6379702F47384A4B4357324568594F5852514D41733256733761644368482B5A475A6B343D; __utmt_t0=1; __utmt_t1=1; unique_wapandm_cookie=U_op4m6epl4mty7977r0uxjqaqs7wj3wtchqm*18; __utma=147393320.873553647.1497433674.1497440148.1497444371.3; __utmb=147393320.4.10.1497444371; __utmc=147393320; __utmz=147393320.1497433674.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none); mencity=bj");
		headers.put("referer", "https://m.fang.com/zf/bj/s0/");
		headers.put("user-agent", "Mozilla/5.0 (iPhone; CPU iPhone OS 9_1 like Mac OS X) AppleWebKit/601.1.46 (KHTML, like Gecko) Version/9.0 Mobile/13B143 Safari/601.1");

		JSONObject data = new JSONObject();
    	  // data.put("x-requested-with", "XMLHttpRequest");
	   
	  try {
	  	result=HttpRequest.get(url, headers,data);//发送请求
	  	//System.out.println("getok="+result);
   } catch (HttpException e) {
   	result="err：得到房屋信息列表信息网络异常，请重新获得此方法";
  // e.printStackTrace();
   }
   
	  return result;
	}
	
	public static String getVin(String url) throws IOException{
		String result = "";
		Map<String, String> headers = new HashMap<String, String>();
		headers.put("Content-Type", "application/json; charset=GBK");
		headers.put("cookie", "JSESSIONID=aaaGZMbsbPzL3d1mjaMYv; global_cookie=534b9624-1497433674581-0c6615c9; global_wapandm_cookie=op4m6epl4mty7977r0uxjqaqs7wj3wtchqm; zhcity=%E5%8C%97%E4%BA%AC; encity=bj; addr=%E5%8C%97%E4%BA%AC%E5%B8%82; sfliveykwap=yk_wap_59411fc5dcced; unique_cookie=U_534b9624-1497433674581-0c6615c9*1; Captcha=334856576F786D345366652F5835756337386F2B6A362F6C50714439567672464B2B4D6B41446C6379702F47384A4B4357324568594F5852514D41733256733761644368482B5A475A6B343D; __utmt_t0=1; __utmt_t1=1; unique_wapandm_cookie=U_op4m6epl4mty7977r0uxjqaqs7wj3wtchqm*18; __utma=147393320.873553647.1497433674.1497440148.1497444371.3; __utmb=147393320.4.10.1497444371; __utmc=147393320; __utmz=147393320.1497433674.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none); mencity=bj");
		headers.put("referer", "https://m.fang.com/zf/bj/s0/");
		headers.put("user-agent", "Mozilla/5.0 (iPhone; CPU iPhone OS 9_1 like Mac OS X) AppleWebKit/601.1.46 (KHTML, like Gecko) Version/9.0 Mobile/13B143 Safari/601.1");

		JSONObject data = new JSONObject();
		try {
		  	result=HttpRequest.get(url,headers,data);//发送请求
		  	//System.out.println("getok="+result);
	   } catch (HttpException e) {
	   	result="err：得到房屋信息列表信息网络异常，请重新获得此方法";
	  // e.printStackTrace();
	   }
	   return result;
	}

	/**
	 * @param args 测试类
	 * @throws IOException 
	 */
	public static void main(String[] args) throws IOException {
	   //System.out.println(GetInfo("https://m.fang.com/zf/?purpose=%D7%A1%D5%AC&housetype=jx&city=%D6%A3%D6%DD&renttype=cz&c=zf"));
	   /*String starString=RemoteCallUtil.getUrlValue("https://m.fang.com/zf/?purpose=%D7%A1%D5%AC&housetype=jx&city=%D6%A3%D6%DD&renttype=cz&c=zf", "gbk"); 
     System.out.println(starString);*/
     
     	String url = RemoteCallUtil.getUrlValue(" http://dbs.haocheok.com/che300/haocheok/?VIN=LSVFA49J2R4037048",RemoteCallUtil.UTF_8);
     	/*JSONArray arr = JSONArray.fromObject(url);
     	System.out.println(arr.getJSONObject(0).getString("PP"));*/
     	System.out.println(url);
//     	System.out.println(getVin(url));
	}

}
 

 
 