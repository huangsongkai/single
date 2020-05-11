package v1.haocheok.commom.utiles;

import java.util.Calendar;

public class OrderUtils {

	public static void main(String[] args) {
		System.out.println(getOrderNum(1));
		
	}
	
	
	/**
	 * 生成好车帮订单号算法
	 * @param count
	 * @return "XH-HY"+"yyMMXXXXX" => "XH-HY160710000"
	 */
	public static String getOrderNum(Integer seqcount) {
	   String firstStr="SFJGXY-";
	   Calendar now = Calendar.getInstance();  
	   Integer y=now.get(Calendar.YEAR);
	   String currentyear=y.toString(); 
	   String year=currentyear.substring(currentyear.length()-2,currentyear.length());
	   
	   Integer m=now.get(Calendar.MONTH) + 1;
	   String currentmonth=m.toString();
	   if(currentmonth.length()==1){
		   currentmonth="0"+currentmonth;
	   }
	   
	   String secondStr=year+currentmonth;
//	   String secondStr = year;
	   String thirdStr=String.format("%05d", seqcount);
//	   String thirdStr = String.valueOf(seqcount);
	   String ordercode=firstStr+secondStr+thirdStr;
	   return ordercode;
	}
	
	/**
	 * 身份证校验
	 * @param identityid
	 * @return
	 */
	 public static boolean noValidate(String identityid)
	   {
	      // 对身份证号进行长度等简单判断
	      if (identityid == null || identityid.length() != 18 || !identityid.matches("\\d{17}[0-9X]"))
	      {
	         return false;
	      }
	      // 1-17位相乘因子数组
	      int[] factor = { 7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2 };
	      // 18位随机码数组
	      char[] random = "10X98765432".toCharArray();
	      // 计算1-17位与相应因子乘积之和
	      int total = 0;
	      for (int i = 0; i < 17; i++)
	      {
	         total += Character.getNumericValue(identityid.charAt(i)) * factor[i];
	      }
	      // 判断随机码是否相等
	      return random[total % 11] == identityid.charAt(17);
	   }
}
