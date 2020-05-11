package service.common;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;

import service.sys.PropsUtils;

/**
 * @author Mike 
 * @version 创建时间：2017-6-24 下午11:09:14    
 * @类说明： 实现发送短信与语音验证码功能
 */

public class SendCodes
{
	/**
	 * 发送验证码
	 * @phone : 手机号码
	 * @Code  : 验证码
	 */
	public static String SmsCode (String authmobile,int randomCode ){
		
		String line, ServerSmsInfo = "";
		//互亿无线 配置文件
		String postUrl=PropsUtils.getKey("postUrl",SystemPath.aa()+"sendCode.properties");
		String account=PropsUtils.getKey("account",SystemPath.aa()+"sendCode.properties");//查看用户名请登录用户中心->验证码、通知短信->帐户及签名设置->APIID
		String password=PropsUtils.getKey("password",SystemPath.aa()+"sendCode.properties");//查看密码请登录用户中心->验证码、通知短信->帐户及签名设置->APIKEY
		String content=PropsUtils.getKey("content",SystemPath.aa()+"sendCode.properties");
		
//		String postUrl = "http://106.ihuyi.cn/webservice/sms.php?method=Submit";
//		String account = "C00569244"; //查看用户名请登录用户中心->验证码、通知短信->帐户及签名设置->APIID
//		String password = "bb82be122171c3de15aec4f7f5973328";  //查看密码请登录用户中心->验证码、通知短信->帐户及签名设置->APIKEY
//		String mobile = authmobile;
//		String content = new String("您的验证码是：" + randomCode + "。请不要把验证码泄露给其他人。");
		
		String mobile = authmobile;

		try{
				System.out.println("postUrl=="+postUrl);
				URL url = new URL(postUrl);
				HttpURLConnection connection = (HttpURLConnection) url.openConnection();
				connection.setDoOutput(true);//允许连接提交信息
				connection.setRequestMethod("POST");//网页提交方式“GET”、“POST”
				connection.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");
				connection.setRequestProperty("Connection", "Keep-Alive");
				StringBuffer sb = new StringBuffer();
				sb.append("account="+account);
				sb.append("&password="+password);
				sb.append("&mobile="+mobile);
				sb.append("&content="+content.replaceAll("##", ""+randomCode+""));
				OutputStream os = connection.getOutputStream();
				os.write(sb.toString().getBytes());
				os.close();
			
				BufferedReader in = new BufferedReader(new InputStreamReader(connection.getInputStream(), "utf-8"));
				while((line = in.readLine()) != null){
					ServerSmsInfo += line + "\n";
				}in.close();

		}catch(IOException e){
			e.printStackTrace(System.out);
		}
		
			if (ServerSmsInfo.indexOf("成功") != -1) 
			{
				return "true";
			}else if(ServerSmsInfo.indexOf("同一手机号验证码短信发送超出5条") != -1)
			{
				return "同一手机号验证码短信发送超出5条";
			}else{
				return "false";
			}
	}
	/**
	 *@测试模块：
	 *@方法名：发送验证码
	 *@创建时间：2017-4-22 下午01:26:00
	 */
	public static void main(String[] args) {
		System.out.println(SmsCode("15844793377", 123456));
	}
}
