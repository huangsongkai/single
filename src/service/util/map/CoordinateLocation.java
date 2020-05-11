package service.util.map;

import java.util.HashMap;

/**
 * @ClassName: WangXuDong E-mail: 1503631902@qq.com
 * @version 创建时间： 2016-10-11 下午10:53:40
 * @Description: TODO(计算经纬度)
 */
public class CoordinateLocation {

	/**
	 *@category 返回数组 传递经纬度与距离，返回在方圆半径的最大和最小经纬度 纬度，经度，米数
	 *@param lat纬度
	 *            39.945542
	 *@param lon经度
	 *            116.797028
	 *@param raidus
	 *            距离 单位米 5000
	 *@see {minLng=116.8556282775082, maxLat=39.990468198610394,
	 *      minLat=39.90061580138961, maxLng=116.73842772249179}
	 */

	public HashMap<Object, Object> getAroundMap(Double lat, Double lon, int raidus) {

		HashMap<Object, Object> dataMap = new HashMap<Object, Object>();

		Double PI = 3.14159265;
		Double latitude = lat;
		Double longitude = lon;
		Double degree = (24901 * 1609) / 360.0;
		int raidusMile = raidus;
		Double dpmLat = 1 / degree;
		Double radiusLat = dpmLat * raidusMile;
		Double minLat = latitude - radiusLat;
		Double maxLat = latitude + radiusLat;
		dataMap.put("minLat", minLat);// 最小纬度
		dataMap.put("maxLat", maxLat);// 最大纬度
		// System.out.println("最小纬度="+minLat);
		// System.out.println("最大纬度="+maxLat);
		Double mpdLng = degree * (Math.cos(latitude * (PI / 180)));
		Double dpmLng = 1 / mpdLng;
		Double radiusLng = dpmLng * raidusMile;
		Double maxLng = longitude - radiusLng;
		Double minLng = longitude + radiusLng;
		dataMap.put("minLng", minLng);// 最小经度
		dataMap.put("maxLng", maxLng);// 最大经度
		// System.out.println(dataMap.toString());
		// System.out.println("最小经度="+minLng);
		// System.out.println("最大经度="+maxLng);
		return dataMap;
	}
	
	

	/**
	 *@category 返回SQL 传递经纬度与距离，返回在方圆半径的最大和最小经纬度 纬度，经度，米数
	 *@param lat纬度
	 *            39.945542
	 *@param lon经度
	 *            116.797028
	 *@param raidus
	 *            距离 单位米 5000
	 *@see
	 */

	public static String getAroundSql(Double lat, Double lon, int raidus) {

		HashMap<Object, Object> dataMap = new HashMap<Object, Object>();

		Double PI = 3.14159265;
		Double latitude = lat;// 纬度
		Double longitude = lon;// 经度
		Double degree = (24901 * 1609) / 360.0;
		int raidusMile = raidus;
		Double dpmLat = 1 / degree;
		Double radiusLat = dpmLat * raidusMile;
		Double minLat = latitude - radiusLat;
		Double maxLat = latitude + radiusLat;
		// dataMap.put("minLat", minLat);//最小纬度
		// dataMap.put("maxLat", maxLat);//最大纬度

		Double mpdLng = degree * (Math.cos(latitude * (PI / 180)));
		Double dpmLng = 1 / mpdLng;
		Double radiusLng = dpmLng * raidusMile;
		Double maxLng = longitude - radiusLng;
		Double minLng = longitude + radiusLng;
		// dataMap.put("minLng",minLng);//最小经度
		// dataMap.put("maxLng", maxLng);//最大经度
		// System.out.println(dataMap.toString());

		String msg = "lat>" + minLat + " AND  lat<" + maxLat + " AND lng<"+ minLng + " AND lng>" + maxLng;

		return msg;
	}

	// 测试方法
	public static void main(String[] args) {
		CoordinateLocation coordinateLocation = new CoordinateLocation();
		String ARR = coordinateLocation.getAroundMap(39.945542, 116.797028, 5000).toString();
		String whereSql = CoordinateLocation.getAroundSql(39.945542, 116.797028,5000);

		System.out.println(ARR);
		System.out.println(whereSql);
		/*
		 * 
SELECT
  room_list.address   AS address,
  room_list.rid       AS rid,
  room_list.room_name AS NAME,
  ROUND(6378.138 * 2 * ASIN(SQRT(POW(SIN((116.1050913 * PI() / 180 - room_list.lng * PI() / 180) / 2), 2) + COS(116.1050913 * PI() / 180) * COS(room_list.lng * PI() / 180) * POW(SIN((39.1069421 * PI() / 180 - room_list.lat * PI() / 180) / 2), 2))) * 1000) AS distance
FROM `room_list`
WHERE lat > 39.09795686027792
    AND lat < 39.11592733972208
    AND lng < 116.11667066500847
    AND lng > 116.09351193499153
ORDER BY distance ASC
		 */
	}
}
