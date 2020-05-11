package service.util.map;

import java.util.HashMap;
import java.util.Random;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import service.net.RemoteCallUtil;

/**
 * @ClassName: microfar E-mail: 932246@qq.com
 * @version 创建时间： 2016-10-11 下午10:53:40
 * @Description: TODO 坐标与地址互换
 */
public class BaiDuLatLngAddress {

	/**
	 * @category输入地址返回经纬度坐标
	 *@param key
	 *            传入 lng(经度),lat(纬度)
	 *@param 返回地址例如
	 *            ：北京市西城区文津街
	 */

	public static String getAddress(String lat, String lng) {
		String Address = "不明地址";
//String KeyArr = "DMFLhWBGxbj4cP5OT4S1hFwv1W4FGbfS#tH1CL9f9gL6xWnDv8RNVcvkZ0r1BNHsI#c2rQgApIENOt69F3nEnNM5BOaoDmaGG4#FAeae47f0526a7aea6d99e3698d6bed7#15773d9021485df7ee413122667d575e#F9576b16fa05d0ff0b661e569ae48d1b#1b34912e7e2eb2107935f43d79687196#DB6b9e5da378bd5c8320a599fc5ab805";
        
		String KeyArr = "9l559NValOEniLtiIpGOBGhE49svMmBq#wBQPbU8Xs4d34rdKKyxUlrf1Tl21ipxf";

		// 随机使用key，防止被封杀
		int max = KeyArr.split("#").length - 1;
		int min = 0;
		Random random = new Random();
		int s = random.nextInt(max) % (max - min + 1) + min;
		// System.out.println("第"+s+"个key");

		Address = RemoteCallUtil.getUrlValue(
				"http://api.map.baidu.com/geocoder/v2/?output=json&ak="
						+ KeyArr.split("#")[s] + "&location=" + lat + "," + lng
						+ "", "utf-8");
		String result = "";
		try { // 解析开始

			JSONArray arr = JSONArray.fromObject("[" + Address + "]");
			for (int i = 0; i < arr.size(); i++) {
				JSONObject obj = arr.getJSONObject(i);
				result = obj.get("result") + "";
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
	 * @param Address
	 * @param 返回
	 *            lat(维度),lng(经度)
	 */

	public static String getCoordinate(String Address) {
		String lat = ""; // lat(纬度)
		String lng = ""; // lng(经度)
		String Coordinate = "";
		String result = "";
		//String KeyArr = "DMFLhWBGxbj4cP5OT4S1hFwv1W4FGbfS#tH1CL9f9gL6xWnDv8RNVcvkZ0r1BNHsI#c2rQgApIENOt69F3nEnNM5BOaoDmaGG4#FAeae47f0526a7aea6d99e3698d6bed7#15773d9021485df7ee413122667d575e#F9576b16fa05d0ff0b661e569ae48d1b#1b34912e7e2eb2107935f43d79687196#DB6b9e5da378bd5c8320a599fc5ab805";
        
		String KeyArr = "9l559NValOEniLtiIpGOBGhE49svMmBq#wBQPbU8Xs4d34rdKKyxUlrf1Tl21ipxf";

		
		// 随机使用key，防止被封杀
		int max = KeyArr.split("#").length - 1;
		int min = 0;
		Random random = new Random();
		int s = random.nextInt(max) % (max - min + 1) + min;
		// System.out.println("第"+s+"个key");
		Coordinate = RemoteCallUtil.getUrlValue(
				"http://api.map.baidu.com/geocoder/v2/?output=json&ak="
						+ KeyArr.split("#")[s] + "&address=" + Address + "",
				"utf-8");

		try { // 解析开始

			JSONArray arr = JSONArray.fromObject("[" + Coordinate + "]");
			for (int i = 0; i < arr.size(); i++) {
				JSONObject obj = arr.getJSONObject(i);
				result = obj.get("result") + "";
			}
		} catch (Exception e) {
			return Coordinate = "";
		}

		try {
			JSONArray arr = JSONArray.fromObject("[" + result + "]");
			for (int i = 0; i < arr.size(); i++) {
				JSONObject obj = arr.getJSONObject(i);
				result = obj.get("location") + "";
			}
		} catch (Exception e) {
			return Coordinate = "";
		}

		JSONArray arr = JSONArray.fromObject("[" + result + "]");
		try {
			for (int i = 0; i < arr.size(); i++) {
				JSONObject obj = arr.getJSONObject(i);
				lat = obj.get("lat") + "";
				lng = obj.get("lng") + "";
				Coordinate = lat + "," + lng;
			}
		} catch (Exception e) {
			return Coordinate = "";
		}

		return Coordinate;
	}

	// 测试方法
	public static void main(String[] args) {
		System.out.println(getAddress("39.929242,116.395327", null));
		System.out.println(getCoordinate("北京市西城区文津街"));

	}
}
