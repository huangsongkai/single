package service.util.map;

import java.io.UnsupportedEncodingException;
import java.util.HashMap;
import java.util.Random;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import service.net.RemoteCallUtil;

/**
 * @ClassName: microfar E-mail: 932246@qq.com
 * @version 创建时间： 2016-10-11 下午10:53:40
 * @Description: TODO 高德坐标与地址互换
 */
public class GaoDeLatLngAddress {

	/**
	 * @category输入地址返回经纬度坐标
	 *@param key  传入  lng(经度), lat(纬度)
	 *@param 返回地址例如   ：北京市西城区文津街
	 */

	public static String getAddress(double lng, double lat) {
		String Address = "不明地址";
        String key="a6dc88b6619ece3226abf15ee2e4deb0";
        String geturlString="http://restapi.amap.com/v3/geocode/regeo?key="+key+"&location="+lng+","+lat+"";
         
		Address = RemoteCallUtil.getUrlValue(geturlString, "utf-8");
		String result = "";
	   
		try { // 解析开始

			JSONArray arr = JSONArray.fromObject("[" + Address + "]");
			for (int i = 0; i < arr.size(); i++) {
				JSONObject obj = arr.getJSONObject(i);
				result = obj.get("regeocode") + "";
			}
		} catch (Exception e) {
			return Address = "";
		}

		JSONArray arr = JSONArray.fromObject("[" + result + "]");

		try {
			for (int i = 0; i < arr.size(); i++) {
				JSONObject obj = arr.getJSONObject(i);
				Address = obj.get("formatted_address") + "";
			}
		} catch (Exception e) {
			return Address = "";
		}

		return Address;
	}

	/**
	 * @category输入地址返回经纬度坐标
	 * @param Address 中文地址
	 * @param  返回 {lng(经度),lat(维度)}
	 *    
	 */

	public static String getCoordinate(String Address) {
		 
		String Coordinate = "";
		String result = "";
		try {
			Address=java.net.URLEncoder.encode(Address,"utf-8"); //编码
		} catch (UnsupportedEncodingException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}
		
		System.out.println("1Address="+Address);
		
		String key="a6dc88b6619ece3226abf15ee2e4deb0";
		String geturlString="http://restapi.amap.com/v3/geocode/geo?address="+Address+"&output=json&key="+key+"";
        //System.out.println(geturlString);
		Address = RemoteCallUtil.getUrlValue(geturlString, "utf-8");
		System.out.println("2Address="+Address);
		try { // 解析开始

			JSONArray arr = JSONArray.fromObject("[" + Address + "]");
			for (int i = 0; i < arr.size(); i++) {
				JSONObject obj = arr.getJSONObject(i);
				result = obj.get("geocodes") + "";
			}
		} catch (Exception e) {
			return Coordinate = "";
		}
		 //System.out.println(result);

		try {
			JSONArray arr = JSONArray.fromObject("" + result + "");
			for (int i = 0; i < arr.size(); i++) {
				JSONObject obj = arr.getJSONObject(i);
				Coordinate = obj.get("location") + "";
			}
		} catch (Exception e) {
			return Coordinate = "";
		}
		 //System.out.println(result);
		// if(result.indexOf(",")!=-1){
		 //Coordinate=""+result.split(",")[1]+","+result.split(",")[0]+"";
		// }else{ Coordinate=""; }

		return Coordinate; //返回 lat(维度),lng(经度)
	}

	// 测试方法
	public static void main(String[] args) {
		  //System.out.println(getAddress(113.666197,34.752453));
		  System.out.println(getCoordinate("长春市"));

	}
}
