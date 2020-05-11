package autocode.action;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

import java.util.ArrayList;
import java.util.Calendar;

import org.apache.commons.httpclient.HttpException;
import org.apache.http.client.methods.RequestBuilder;
import org.apache.http.entity.StringEntity;



 
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

public class GetKeyJsonString {

	 
	/**
	 * @param 通过josn字符串得到key值
	 * @return keyes
	 */
	public static String jsonkey (String jsonString){
		 String key="";
		 String keyes="";
		 try {
			
		
		 JSONObject jsonObj = JSONObject.fromObject(jsonString);  
         Iterator it = jsonObj.keys();  
         List<String> keyListstr = new ArrayList<String>();  
         while(it.hasNext()){  
             key =(String) it.next();
             keyes=keyes+"#"+key;
            } 
		 } catch (Exception e) {
			 keyes="err:json格式错误";
			}
         return keyes.replaceFirst("#", "");
	}
	
	/**
	 * 
	 * @param 得到key与value
	 * @throws HttpException
	 * @throws IOException
	 */
	public static void post( Map<String, String> str) throws HttpException, IOException {
	 System.out.println("====");
		if (str != null) {
			Iterator<Entry<String, String>> it = str.entrySet().iterator();
			while (it.hasNext()) {
				Entry<String, String> entry = it.next();
                System.out.println(entry.getKey()+entry.getValue());
				 
			}
		}
	 
	 
	}
	
	//测试代码
	public static void main(String[] args) {
	//Map<String, String> map = new HashMap<String, String>();
		 
      // map.put("\"nearby\"", "value1");
      // map.put("2", "value2");
      // map.put("3", "value3");
     
      
     //System.out.println(map.toString());
     //testjson.post(map.toString());
     
	//	
		 
		
		String keyesString=jsonkey("{\"nearby\":\"116.797028,39.945542,50000\",\"price\":\"500,99999999\",\"queryarr\":\"32,54,60,71,8,9,10,18,1,2,3,4\",\"horder\":\"0\",\"districtid\":\"1\",\"recommend\":\"\",\"keyword\":\"\",\"page\":\"1\",\"listnum\":\"10\"}");
		System.out.println(keyesString);
	}

 

}
