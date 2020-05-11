package service.util.random; 
 
import java.util.Random;

 

/** 
 * @author microfar  E-mail: 932246@qq.com 
 * @version 创建时间：2016-7-25 下午07:06:34 
 * 类说明 :随机生成自定义数字
 */
public class RandomNum {
	 
    /**
     * @category 传入整形最大最小数，生成max-min之间
     */
	private static  int ac(int max,int min) {
		  Random random = new Random();
		  int s = random.nextInt(max) % (max - min + 1) + min;
		  return s;
	}

	//test
	public static void main(String[] args) {
	 	System.out.print(RandomNum.ac(100000000,900000000));

}

	
}
 

 
 