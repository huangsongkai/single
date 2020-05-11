package service.common; 
/** 
 * @author LiGaoSong  E-mail: 932246@qq.com 
 * @version 创建时间：2016-9-10 下午03:45:37  
 * @file name  autop.java
 * 类说明：自动化运行
 */
 

import java.net.URL;
import java.net.URLConnection;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;

public class Autop extends HttpServlet {

    private MyThreades thread;

    // public static void main(String[] arg) {
    // MyThreades thread = new MyThreades();
    // System.out.println("............run1");
    //
    // thread.start(); 
    //
    // System.out.println("............run2");
    // }

    public void init() throws ServletException {
thread = new MyThreades();
System.out.println("............自动化激发线程开始加载");
thread.start();
System.out.println("............自动化激发线程加载成功");
    }

    public void destory() {
thread.stop();
    }

}

class MyThreades extends Thread {

    private String TEST_URL = "";

    @Override
    public void run() {

for (; true;) {

try {
   Thread.currentThread().sleep(1000 * 10);
} catch (InterruptedException e) {

}

   String url = "http://m.yinuowang.cn/weixin/pushsend.jsp#http://m.yinuowang.cn/weixin/pushsend_shengji.jsp";
   String urlname = "NO1 PUSHSEND START  #NO2 AUTO UPDATA USERLEV";
   String[] URLes = url.split("#");
   String[] URLnames = urlname.split("#");

   for (int iu = 0; iu < URLes.length; iu++) {
  	
  	 try {
  	   Thread.currentThread().sleep(1000 * 10);
  	} catch (InterruptedException e) { 	} 
  	 
//System.out.println(URLes[iu]);
TEST_URL = URLes[iu];
// System.out.println("激发rar程序..............");
 
System.out.println(URLnames[iu]+"线程开始->");

String sCurrentLine;
String sTotalString;
sCurrentLine = "";
sTotalString = "";
java.io.InputStream l_urlStream;
// System.out.println("/////////。。。");
try {

   java.net.URL l_url = new java.net.URL(TEST_URL);
   java.net.HttpURLConnection l_connection = (java.net.HttpURLConnection) l_url
   .openConnection();
   l_connection.connect();
   l_urlStream = l_connection.getInputStream();
   java.io.BufferedReader l_reader = new java.io.BufferedReader(
   new java.io.InputStreamReader(l_urlStream));
   /*
    * while ((sCurrentLine = l_reader.readLine()) != null) {
    * sTotalString += sCurrentLine;
    * 
    * }
    */
   java.text.SimpleDateFormat formatter = new java.text.SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
   java.util.Date currentTime_1 = new java.util.Date();

   System.out.println(URLnames[iu]+" : "+TEST_URL + " net ok"
   + formatter.format(currentTime_1));

   // return;

}catch(Exception e){
   System.out.println(URLnames[iu]+" : "+TEST_URL + "net err");

}
   }// 循环出RUL
}

    }// runsend

    private boolean isConnection() {
boolean result = true;

URL l_url = null;
URLConnection conn = null;
try {
   l_url = new URL(this.TEST_URL);
   conn = l_url.openConnection();
   conn.connect();
} catch (Exception e) {
   this.saveErrorLog(e);
   result = false;
}

return result;
    }

    private void saveErrorLog(Exception e) {

    }

}