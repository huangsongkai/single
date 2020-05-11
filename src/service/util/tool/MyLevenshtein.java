package service.util.tool; 
/** 
 * @author LiGaoSong  E-mail: 932246@qq.com 
 * @version 创建时间：2016-9-8 下午05:27:33  
 * @file name  CosineSimilarAlgorithm.java
 * 类说明：   模块：       操作的数据表
 */
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
 
/**
 * 
 * <p>Title:</p>
 * <p>Description: 余弦获取文章相似性
 * </p>
 * @createDate：2013-8-26
 * @author xq
 * @version 1.0
 */
public class MyLevenshtein  {
 
	/**
	 * 
	* @Title: MyLevenshtein 
	* @Description: 获取两个文件相似性
	* @param @param firstFile
	* @param @param secondFile
	* @param @return    
	* @return Double   
	* @throws
	 */
  public static void main(String[] args) {  
    //要比较的两个字符串  
    String str1 = "冬瓜、黄瓜、西瓜、南瓜都能吃，什么瓜不能吃？";  
    String str2 = "黄瓜、西瓜、冬瓜、南瓜都能吃，什么瓜不能吃";  
     
    System.out.println(levenshtein(str1,str2) );
}  

/** 
 * 　　DNA分析 　　拼字检查 　　语音辨识 　　抄袭侦测 
 * @return 
 *  
 * @createTime 2012-1-12 
 */  
public static float levenshtein(String str1,String str2) {  
    //计算两个字符串的长度。  
	  float similarity=0;
    int len1 = str1.length();  
    int len2 = str2.length();  
    //建立上面说的数组，比字符长度大一个空间  
    int[][] dif = new int[len1 + 1][len2 + 1];  
    //赋初值，步骤B。  
    for (int a = 0; a <= len1; a++) {  
        dif[a][0] = a;  
    }  
    for (int a = 0; a <= len2; a++) {  
        dif[0][a] = a;  
    }  
    //计算两个字符是否一样，计算左上的值  
    int temp;  
    for (int i = 1; i <= len1; i++) {  
        for (int j = 1; j <= len2; j++) {  
            if (str1.charAt(i - 1) == str2.charAt(j - 1)) {  
                temp = 0;  
            } else {  
                temp = 1;  
            }  
            //取三个值中最小的  
            dif[i][j] = min(dif[i - 1][j - 1] + temp, dif[i][j - 1] + 1,  
                    dif[i - 1][j] + 1);  
        }  
    }  
    //System.out.println("字符串\""+str1+"\"与\""+str2+"\"的比较");  
    //取数组右下角的值，同样不同位置代表不同字符串的比较  
    //System.out.println("差异步骤："+dif[len1][len2]);  
    //计算相似度  
      similarity =1 - (float) dif[len1][len2] / Math.max(str1.length(), str2.length());  
    //System.out.println("相似度："+similarity);  
    return similarity;
}  

//得到最小值  
private static int min(int... is) {  
    int min = Integer.MAX_VALUE;  
    for (int i : is) {  
        if (min > i) {  
            min = i;  
        }  
    }  
    return min;  
}  

}  