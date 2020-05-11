//package service.common;
//
//import java.io.UnsupportedEncodingException;
//import java.util.Date;
//import java.util.Properties;
//
//import javax.mail.Authenticator;
//import javax.mail.Message;
//import javax.mail.MessagingException;
//import javax.mail.PasswordAuthentication;
//import javax.mail.Session;
//import javax.mail.Transport;
//import javax.mail.internet.InternetAddress;
//import javax.mail.internet.MimeMessage;
//
//
//
//public class SendMail {
//
//
//
//	public  void send(String nick,String title, String body,String tomails) {
//		//SMTP邮件服务器发送配置
//		  final String smtpserver =MailServerConf.get("smtpserver");  //服务器  smtpserver
//		  final String username= MailServerConf.get("username");      //发件用户   username
//		  final String password = MailServerConf.get("password");     //发件用户密码   password
//		  final String mailtype= MailServerConf.get("mailtype");      //发送邮件内容   mailtype
//		  final String type=MailServerConf.get("type");      //发送邮件内容   mailtype
//		  int typ=Integer.parseInt(type);
//
//		  if(typ>9){typ=0;}
//		  switch (typ) {
//			  case 0: MailServerConf.set("type",""+(typ+1)+"");  MailServerConf.set("username","flashpush_zero@163.com"); break;
//			  case 1: MailServerConf.set("type",""+(typ+1)+"");  MailServerConf.set("username","flashpush_one@163.com"); break;
//			  case 2: MailServerConf.set("type",""+(typ+1)+"");  MailServerConf.set("username","flashpush_two@163.com"); break;
//			  case 3: MailServerConf.set("type",""+(typ+1)+"");  MailServerConf.set("username","flashpush_three@163.com"); break;
//			  case 4: MailServerConf.set("type",""+(typ+1)+"");  MailServerConf.set("username","flashpush_four@163.com"); break;
//			  case 5: MailServerConf.set("type",""+(typ+1)+"");  MailServerConf.set("username","flashpush_five@163.com"); break;
//			  case 6: MailServerConf.set("type",""+(typ+1)+"");  MailServerConf.set("username","flashpush_six@163.com"); break;
//			  case 7: MailServerConf.set("type",""+(typ+1)+"");  MailServerConf.set("username","flashpush_seven@163.com"); break;
//			  case 8: MailServerConf.set("type",""+(typ+1)+"");  MailServerConf.set("username","flashpush_eight@163.com"); break;
//			  case 9: MailServerConf.set("type",""+(typ+1)+"");  MailServerConf.set("username","flashpush_nine@163.com"); break;
//			  default:  break;
//		  }
//
//	 try {
//		  System.out.println("smtpserver===="+smtpserver);
//	      String SSL_FACTORY = "javax.net.ssl.SSLSocketFactory";
//		  Properties props = System.getProperties();
//		  props.setProperty("mail.smtp.host", smtpserver);
//		  props.setProperty("mail.smtp.socketFactory.class", SSL_FACTORY);
//		  props.setProperty("mail.smtp.socketFactory.fallback", "false");
//		  props.setProperty("mail.smtp.port", "465");
//		  props.setProperty("mail.smtp.socketFactory.port", "465");
//		  props.put("mail.smtp.auth", "true");
//
//		  Session sendMailSession;
//		  sendMailSession = Session.getInstance(props, new Authenticator(){
//			  protected PasswordAuthentication getPasswordAuthentication() {
//				  return new PasswordAuthentication(username,password);
//			  }
//		  });
//
//
//		  // -- Create a new message --
//		  Message msg = new MimeMessage(sendMailSession);
//
//		   String[] tosendES = tomails.split("#");
//		   System.out.println("邮件个数==:"+tosendES.length);
//		   for (int p = 0; p < tosendES.length; p++) {
//
//			   System.out.println("邮箱====:"+tosendES[p]);
//			   // -- Set the FROM and TO fields --设置表单和字段
//				try{
//
//					System.out.println("邮件名===:"+nick);
//					nick=javax.mail.internet.MimeUtility.encodeText(nick);
//
//				}catch(UnsupportedEncodingException e) {
//					 e.printStackTrace();
//					 System.out.println("发送邮件出错："+e);
//				}
//
//				msg.setFrom(new InternetAddress(nick+"<"+username+">"));
//
//				msg.setRecipients(Message.RecipientType.TO,InternetAddress.parse(tosendES[p],false));
//
//
//				msg.setSubject(title);
//			    if(mailtype.indexOf("txt")!=-1){
//					  msg.setText(body); //发送纯文本
//				}else{
//				     msg.setContent(body,"text/html;charset=gb2312"); //发送HTML 邮件
//			    }
//
//			    msg.setSentDate(new Date());
//
//			    Transport.send(msg);
//	            System.out.println("发送邮件成功：->"+tosendES[p]);
//          }
//
//	 }catch(MessagingException m) {
//		  System.out.println("发送邮件出错：-->"+m.toString());
//		  send( nick,title, body, tomails);
//	 }
//
//	}
//
//	/**
//	 * @测试类
//	 */
//	public static void main(String[] args) {
//
//
//		SendMail sendMail=new SendMail();
//		 //sendMail.send("标题","内容","发送的邮箱【可发送多个】");
////		 sendMail.send("0452e大齐圈","***邮件密码取回通知", "内容测试一下</br>支持HTML发一个图<img border=\"0\" src=\"http://svn.haocheok.com/img/bitnami.png\"  ><hr>", "524101359@qq.com#932246@qq.com#dong5213140@qq.com");
//		//sendMail.send("0452e大齐圈","***邮件密码取回通知", "内容测试一下</br>支持HTML发一个图<img border=\"0\" src=\"http://svn.haocheok.com/img/bitnami.png\"  ><hr>", "1503631902@qq.com");
////		 sendMail.send("0452e大齐圈","***邮件密码取回通知", "内容测试一下</br>支持HTML发一个图<img border=\"0\" src=\"http://svn.haocheok.com/img/bitnami.png\"  ><hr>", "support@easemob.com");
//			sendMail.send(
//		               "奥萌社区",
//		               "接口出错",
//		               "出错接口模块:1231321<br><br>" +
//		               		"出错接口模块:1231321<br><br>" +
//		               		"出错日志:1231321<br><br>" +
//		               		"报错所在行数:1231321",
//		               "1503631902@qq.com"
//		           );
//
//	}
//
//}