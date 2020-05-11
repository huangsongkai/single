package service.common;

import java.io.IOException;

import service.net.RemoteCallUtil;

/**
 * @author Mike 
 * @version 创建时间：2017-6-24 下午11:09:14    
 * @类说明： 实现发送短信与语音验证码功能
 */

public class SendCode {

	 
	String msg = "";// 返回值
 

	/**
	 * @author 发送验证码方法SendCode
	 * @param authmobile
	 *            需要验证的手机号
	 * @param authtype
	 *            验证类型 0 短信 1语音
	 * @throws IOException 
	 */
	public String SendCode(String mobile, String RandomCode,int Sendtype,String callinfo) throws IOException {
	      String msg="";
		if(Sendtype==1){//判断认证类型
			//String callinfo= "您在友兔注册的验证码是："+RandomCode+"，重复收听验证码："+RandomCode;
			 callinfo=callinfo.replaceAll("0","零");
			 callinfo=callinfo.replaceAll("1","一");
			 callinfo=callinfo.replaceAll("2","二");
			 callinfo=callinfo.replaceAll("3","三");
			 callinfo=callinfo.replaceAll("4","四");
			 callinfo=callinfo.replaceAll("5","五");
			 callinfo=callinfo.replaceAll("6","六");
			 callinfo=callinfo.replaceAll("7","七");
			 callinfo=callinfo.replaceAll("8","八");
			 callinfo=callinfo.replaceAll("9","九"); 
		     String callbackString=sendVoice.Send_Msg(mobile,callinfo);
		     System.out.println(callbackString);
			 if(callbackString.indexOf("\"resultCode\":\"1000\"")!=-1){
				  msg = "{\"success\":\"true\",\"resultCode\":\"1000\",\"msg\":\"语音发送成功\",\"mobcode\":\""+ RandomCode + "\"}";
			      }else{
				  msg = "{\"success\":\"true\",\"resultCode\":\"404\",\"msg\":\"语音验网关故障\",\"mobcode\":\"\"}";
			   }
			 	}else{//判断认证类型
		      // 验证码发送
			SetupConf setupConf=new SetupConf();
		   String ServerSmsInfo = RemoteCallUtil.getUrlValue(setupConf.get("SmsUrl")+ mobile+ "&content=您的验证码是：【"+ RandomCode+ "】。请不要把验证码泄露给其他人。如非本人操作，可不用理会！", "utf-8");
              System.out.println(ServerSmsInfo);
		    if (ServerSmsInfo.indexOf("成功") != -1) {
			  msg = "{\"success\":\"true\",\"resultCode\":\"1000\",\"msg\":\"短信发送成功\",\"mobcode\":\""
					+ RandomCode + "\"}";
		     }
		     else if (ServerSmsInfo.indexOf("超出") != -1) {
		    	  msg = "{\"success\":\"true\",\"resultCode\":\"404\",\"msg\":\"同一手机号验证码短信发送超出5条\",\"mobcode\":\"\"}";
		    }
		    else {
			  msg = "{\"success\":\"true\",\"resultCode\":\"404\",\"msg\":\"短信验证码网关故障\"}";
		    }
		} //判断认证类型end
        return msg;
 
	}

	
}
