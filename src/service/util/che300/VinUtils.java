package service.util.che300;

import service.net.RemoteCallUtil;
import net.sf.json.JSONArray;

/**
 * che300工具
 * @company 010jiage
 * @author zhoukai04171019
 * @date:2017-10-13 下午01:42:46
 */
public class VinUtils {

	/**
	 * 通过vin码获取车型号
	 * @param vin
	 * @return
	 */
	public static JSONArray  getVin2Models(String vin){
		String url = "http://dbs.haocheok.com/che300/haocheok/?VIN="+vin+"";
		String result = RemoteCallUtil.getUrlValue(url, RemoteCallUtil.UTF_8);
		JSONArray arr = new JSONArray();
		System.out.println(result.indexOf("errmsg"));
		if("-1".equals(String.valueOf(result.indexOf("errmsg")))){
			arr = JSONArray.fromObject(result);
		}
		
		return arr;
	}
	
}
