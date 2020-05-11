package service.util.tool; 
/** 
 * @author LiGaoSong  E-mail: 932246@qq.com 
 * @version 创建时间：2016-8-1 下午01:07:32 
 * 类说明  秒变时间
 */
public class seoToTime {


	public static String secToTime(int time) {  
	    String timeStr = null;  
	    int hour = 0;  
	    int minute = 0;  
	    int second = 0;  
	    if (time <= 0)  
	        return "00:00";  
	    else {  
	        minute = time / 60;  
	        if (minute < 60) {  
	            second = time % 60;  
	            timeStr = unitFormat(minute) + ":" + unitFormat(second);  
	        } else {  
	            hour = minute / 60;  
	            if (hour > 99)  
	                return "99:59:59";  
	            minute = minute % 60;  
	            second = time - hour * 3600 - minute * 60;  
	            timeStr = unitFormat(hour) + ":" + unitFormat(minute) + ":" + unitFormat(second);  
	        }  
	    }  
	    return timeStr;  
	}  

	public static String unitFormat(int i) {  
	    String retStr = null;  
	    if (i >= 0 && i < 10)  
	        retStr = "0" + Integer.toString(i);  
	    else  
	        retStr = "" + i;  
	    return retStr;  
	}  
	
	public static void main(String[] args) {
		seoToTime TF=new seoToTime();
		System.out.println(TF.secToTime(3400));
		System.out.println(secToTime(13500));
	}
	
}
 

 
 