package service.net;
 
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.net.URL;
import java.net.URLConnection;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.Map;

import org.apache.commons.codec.digest.DigestUtils;
 
/**
 * DBS获取接口
 * @param url
 * @return
 */


public class Synch {
	 	public static String SendGet(String url, String param) {
		String result = "";
		BufferedReader in = null;
		try {
			//String urlNameString = url + "?" + param;
			String urlNameString = url;
			URL realUrl = new URL(urlNameString);
			 
			URLConnection connection = realUrl.openConnection();
			 
			 
			connection.setRequestProperty("User-Agent","Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/46.0.2490.76 Mobile Safari/537.36");
			connection.setRequestProperty("Cookie","uuid=\"w:66534460cbb548379e923892d20c790c\"; W2atIF=1; csrftoken=14a77b4e09af858644674bcf0f5dc0fb; tt_webid=12928325053");
			 
			connection.setRequestProperty("X-ChannelId", "mhaoche");
			connection.setRequestProperty("Connection", "Keep-Alive");
			connection.setRequestProperty("Charset", "UTF-8");
			//connection.setRequestProperty("Accept-Charset", "GBK,utf-8;q=0.7,*;q=0.3");
			 
			connection.connect();
		 
			Map<String, List<String>> map = connection.getHeaderFields();
			 
			for (String key : map.keySet()) {
				//System.out.println(key + "--->" + map.get(key));
			}
		 
			in = new BufferedReader(new InputStreamReader(
					connection.getInputStream()));
			String line;
			while ((line = in.readLine()) != null) {
				result += line;
			}
		} catch (Exception e) {
			System.out.println("get err" + e);
			e.printStackTrace();
		}
	 
		finally {
			try {
				if (in != null) {
					in.close();
				}
			} catch (Exception e2) {
				e2.printStackTrace();
			}
		}
		return result;
	}
 
	public static String SendPost(String url, String param) {
		PrintWriter out = null;
		BufferedReader in = null;
		String result = "";
		try {
			URL realUrl = new URL(url);
			 
			URLConnection conn = realUrl.openConnection();
			
			conn.setRequestProperty("Content-Type", "application/form-data; charset=utf-8");
			conn.setRequestProperty("Cookie","uuid=\"w:66534460cbb548379e923892d20c790c\"; W2atIF=1; csrftoken=14a77b4e09af858644674bcf0f5dc0fb; tt_webid=12928325053");
			conn.setRequestProperty("X-AppId","824016aa3a79375f6530683cfb1f0c18");
			conn.setRequestProperty("Charset", "	UTF-8");
			conn.setRequestProperty("Accept-Charset", "utf-8;q=0.7,*;q=0.3");
			 
			 
			conn.setDoOutput(true);
			conn.setDoInput(true);
			 
			out = new PrintWriter(conn.getOutputStream());
			 
			out.print(param);
			 
			out.flush();
			 
			in = new BufferedReader(
					new InputStreamReader(conn.getInputStream()));
			String line;
			while ((line = in.readLine()) != null) {
				result += line;
			}
		} catch (Exception e) {
			 
			System.out.println(" api url-err"
					+ e);

			e.printStackTrace();
		}
		 
		finally {
			try {
				if (out != null) {
					out.close();
				}
				if (in != null) {
					in.close();
				}
			} catch (IOException ex) {
				ex.printStackTrace();
			}
		}
		return result;
	}

	public static String SendJsonPost(String url, String param) {
		PrintWriter out = null;
		BufferedReader in = null;
		String result = "";
		try {
			URL realUrl = new URL(url);
			 
			URLConnection conn = realUrl.openConnection();
			
			conn.setRequestProperty("Content-Type", "application/form-data; charset=utf-8");
			conn.setRequestProperty("Cookie","uuid=\"w:66534460cbb548379e923892d20c790c\"; W2atIF=1; csrftoken=14a77b4e09af858644674bcf0f5dc0fb; tt_webid=12928325053");
			conn.setRequestProperty("X-AppId","824016aa3a79375f6530683cfb1f0c18");
			conn.setRequestProperty("Charset", "	UTF-8");
			conn.setRequestProperty("Accept-Charset", "utf-8;q=0.7,*;q=0.3");
			 
			conn.setDoOutput(true);
			conn.setDoInput(true);
			 
			out = new PrintWriter(conn.getOutputStream());
			 
			out.print(param);
			 
			out.flush();
			 
			in = new BufferedReader(
					new InputStreamReader(conn.getInputStream()));
			String line;
			while ((line = in.readLine()) != null) {
				result += line;
			}
		} catch (Exception e) {
			 
			System.out.println(" api url-err"
					+ e);

			e.printStackTrace();
		}
		 
		finally {
			try {
				if (out != null) {
					out.close();
				}
				if (in != null) {
					in.close();
				}
			} catch (IOException ex) {
				ex.printStackTrace();
			}
		}
		return result;
	}

 /**
  * @测试
  */
	public static void main(String[] args) {
		//test
		 String sr ="";
		   sr=Synch.SendPost("https://a1.easemob.com/easemob-demo/chatdemoui/users","");
	System.out.println(sr);
	}
	
	public static void SynchAc(String Str,String pattern) {  
		 String sr ="sadfasdfasfas";

		 if(pattern!=null && pattern.equals("GET")){ 
            sr = Synch.SendGet("http://127.0.0.1/zf/test", Str);
		 }
		  if(pattern!=null && pattern.equals("POST")){ 
            sr = Synch.SendPost("http://127.0.0.1/zf/test", Str);
		 }
		 
 
		//System.out.println(postinfo + "\r\n");
		  System.out.println(sr);
	}
}