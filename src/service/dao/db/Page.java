package service.dao.db;

import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.net.Inet4Address;
import java.net.NetworkInterface;
import java.net.SocketException;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.Enumeration;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Set;
import java.util.TimeZone;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.apache.commons.httpclient.HttpException;
import org.apache.commons.lang3.ArrayUtils;

public class Page {

	static long current=System.currentTimeMillis();//当前时间毫秒数
    static long zero=current/(1000*3600*24)*(1000*3600*24)-TimeZone.getDefault().getRawOffset();//今天零点零分零秒的毫秒数
    static long twelve=zero+24*60*60*1000-1;//今天23点59分59秒的毫秒数
    long yesterday=System.currentTimeMillis()-24*60*60*1000;//昨天的这一时间的毫秒数
    
	int intpage;

	public Page() {
		intpage = 1;
	}
	
	/*
	 * 关闭db，关闭out,关闭page
	 */
	public  static void colseDOP(Jdbc db,PrintWriter out,Page page){
		
	   	if (db != null){db.close(); db = null;}
		if (page != null) {page = null;}
		out.flush(); out.close();
		
	}
	/*
	 * 关闭db，关闭page
	 */
	public  static void colseDP(Jdbc db,Page page){
		
	   	if (db != null){db.close(); db = null;}
		if (page != null) {page = null;}
		
	}
	/*
	 *生成json字符串
	 */
	public  static String returnjson(String resultCode,String msg){
		
		JSONObject json = new JSONObject();
		json.put("success", "true");
		json.put("resultCode", resultCode);
		json.put("msg", msg);
		
		return json.toString();
	}
	
	/*
	 * java _ 获取行号
	 */
	public static String getLineInfo() {
		
		StackTraceElement ste = new Throwable().getStackTrace()[1];
		return ste.getFileName() + ": Line " + ste.getLineNumber();
		
	}
	/*
	 * java _ 获取文件名
	 */
	public static String getCurrentPath() {

		String relativelyPath=System.getProperty("user.dir"); 
		return relativelyPath;
		
	}
	
	/*
	 * 判断数组里是否包含某字符
	 * String[] myList = {"a","b","c","d","e"};
	 * System.out.println(Page.useArrayUtils(myList, "da"));
	 */
	public static boolean useArrayUtils(String[] arr, String targetValue) {
		  return ArrayUtils.contains(arr,targetValue);
	}
	
	/**
	 * @author 王
	 * @throws SocketException 
	 * @date 2017-10-13
	 * @file_name 获取当前ip
	 */
	
	public static String ips() throws SocketException {
		Enumeration allNetInterfaces = NetworkInterface.getNetworkInterfaces();
		Inet4Address ip = null;
		while (allNetInterfaces.hasMoreElements())
		{
		NetworkInterface netInterface = (NetworkInterface) allNetInterfaces.nextElement();
		System.out.println(netInterface.getName());
		Enumeration addresses = netInterface.getInetAddresses();
		while (addresses.hasMoreElements())
		{
		ip = (Inet4Address) addresses.nextElement();
		if (ip != null && ip instanceof Inet4Address)
		{
		System.out.println("本机的IP = " + ip.getHostAddress());
		} 
		}
		}
		return ip.getHostAddress();
	}
	
	
	/*
	 * @author wang
	 * @date 2017-8-4
	 * @file_name Page.java
	 * @Remarks   传入查询出来的结果集，转换成json
	 */
	public static String resultSetToJson(ResultSet rs) throws SQLException 
	{  
	   // json数组  
	   JSONArray array = new JSONArray();  
	    
	   // 获取列数  
	   ResultSetMetaData metaData = rs.getMetaData();  
	   int columnCount = metaData.getColumnCount();  
	    
	   // 遍历ResultSet中的每条数据  
	    while (rs.next()) {  
	        JSONObject jsonObj = new JSONObject();  
	         
	        // 遍历每一列  
	        for (int i = 1; i <= columnCount; i++) {  
	            String columnName =metaData.getColumnLabel(i);  
	            String value = rs.getString(columnName);  
	            jsonObj.put(columnName, value);  
	        }   
	        array.add(jsonObj);
	    }if(rs!=null){rs.close();} 
	    
	   return array.toString();  
	}  
	
	/*
	 * @author wang
	 * @date 2017-8-4
	 * @file_name Page.java
	 * @Remarks   传入两个 json 串  进行合并    
	 */
	public static ArrayList<String> mergeJson(String json1,String json2) 
	{  
		 ArrayList<String> list=new ArrayList<String> ();
         try { // 解析开始
 			JSONArray arr = JSONArray.fromObject("["+json1+"]");
 			for (int i = 0; i < arr.size(); i++) {
 				JSONObject obj = arr.getJSONObject(i);
	    				JSONArray arr2 = JSONArray.fromObject(obj.getString("threads"));
	    				JSONObject json_2=JSONObject.fromObject(json2);
	    				
 	    			for (int l = 0; l < arr2.size(); l++) {
 	    				
 	    				JSONObject obj2 = arr2.getJSONObject(l);
 	    				
 	    		       		if(obj2.getString("ftype_tag").equals("select") || obj2.getString("ftype_tag").equals("radio") || obj2.getString("ftype_tag").equals("checkbox")){
 	    		       		    JSONArray arr_teams = JSONArray.fromObject(obj2.getString("teams"));
 	    		       		    for (int teams_i = 0; teams_i < arr_teams.size(); teams_i++) {
 	    		       		    	
	 	    		       			JSONObject obj_teams=arr_teams.getJSONObject(teams_i);
System.out.println("test1==="+getType(String.valueOf(json_2.get(obj2.getString("fieldname")))));
System.out.println("test2==="+getType(String.valueOf(obj_teams.get("option"))));
									//出现问题 两个变量类型不同，使用equals 比较 不准确
	 	    		       			if(String.valueOf(json_2.get(obj2.getString("fieldname"))).equals(String.valueOf(obj_teams.get("option")))){
	 	    		       				obj2.put("fieldvaluename", obj_teams.get("option_value"));
	 	    		       			}
	 	    		       		}
	    		        	}else{
	    		        		obj2.put("fieldvaluename", "");
	    		        	}
 	    		            obj2.put("fieldnamevalue", json_2.get(obj2.getString("fieldname")));
 	 	    				list.add(obj2.toString());
 	    			}
	    	}
 		} catch (Exception e) {
 			e.printStackTrace();
 		}
	   return list;  
	}  
	
	/**
	 * 获取变量类型
	 * @author zhoukai04171019
	 * @param o
	 * @return
	 */
	public static String getType(Object o){ //获取变量类型方法
		return o.getClass().toString(); //使用int类型的getClass()方法
		
	}
	
	
	
	
	//获取当前时间戳   （int）
	public static int int_time (){
		
		int dtime =(int)(System.currentTimeMillis()/1000);
		return dtime;
	}
	//获取当天0点时间戳   （int）
	public static int int_Zerooint (){
		
		return (int) (zero/1000);
	}
	//获取当天23点59时间戳   （int）
	public static int int_LastDay (){
		
	   return (int) (twelve/1000);
	}
	//获取前一天时间戳   （int）
	public static int int_Ptime (){
		
		int dtime =(int)(System.currentTimeMillis()/1000);
		return dtime-86400;
	}
	//获取当前时间戳   （long）
	public static long long_time (){
		
		long dtime =System.currentTimeMillis();
		return dtime;
	}
	//获取当前时间格式   （yyyy-MM-dd）
	public static String Str_time_yMd (){
		
		SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");//设置日期格式
		String time=df.format(new Date());
		return time;
	}
	//获取当前时间格式   （yyyy-MM）
	public static String Str_time_yM (){
		
		SimpleDateFormat df = new SimpleDateFormat("yyyy-MM");//设置日期格式
		String time=df.format(new Date());
		return time;
	}
	//获取当前时间格式   （yyMM）
	public static String ym (){
		
		SimpleDateFormat df = new SimpleDateFormat("yyMM");//设置日期格式
		String time=df.format(new Date());
		return time;
	}
	//获取当前时间格式   （HH:mm:ss）
	public static String Str_time_d_Hms (){
		
		SimpleDateFormat df = new SimpleDateFormat("HH:mm:ss");//设置日期格式
		String time=df.format(new Date());
		return time;
	}
	//获取当前时间格式   （MM月dd号 HH:mm:ss）
	public static String Str_time_Md_Hms (){
		
		SimpleDateFormat df = new SimpleDateFormat("MM月dd号 HH:mm:ss");//设置日期格式
		String time=df.format(new Date());
		return time;
	}
	//获取当前时间格式   （yyyy年 MM月 dd日 HH:mm:ss）
	public static String Str_time_YMD_Hms (){
		
		SimpleDateFormat df = new SimpleDateFormat("yyyy年 MM月 dd日  HH:mm:ss");//设置日期格式
		String time=df.format(new Date());
		return time;
	}
	
	//获取当前时间格式   （yyyy- MM月-dd  HH:mm:ss）
	public static String StrTimeYMD_Hms (){
		
		SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd  HH:mm:ss");//设置日期格式
		String time=df.format(new Date());
		return time;
	}
	
	/**
	 * 
	 * @author Administrator
	 * @date 2017-8-8
	 * @file_name Page.java   
	 * @Remarks  两个数组对比，删除 在a数组发现存在b数组的元素  使用实例   Set<String> sameElementSet = getIds(array1,array2);  
	 */
	public static Set<String> getIds(String[] a, String[] b){  
	      Set<String> same = new HashSet<String>();  //用来存放两个数组中相同的元素  
	      Set<String> temp = new HashSet<String>();  //用来存放数组a中的元素 
	      //把数组a中的元素放到Set中，可以去除重复的元素  
	      for (int i = 0; i < a.length; i++) {  temp.add(a[i]); }  
	      //把数组b中的元素添加到temp中  //如果temp中已存在相同的元素，则temp.add（b[j]）返回false  
	      for (int j = 0; j < b.length; j++) { if(!temp.add(b[j])) same.add(b[j]); }  
	      //删除相同的数组元素
	      for(String i : same) {   temp.remove(i);}  
	      
	    return temp;   
	  }
	/**
	 * 
	 * @author Administrator
	 * @date 2017-8-8
	 * @file_name Page.java   
	 * @Remarks  两个list对比，删除 在list数组发现存在list数组的元素  使用实例   Set<String> sameElementSet = getIds(array1,array2);  
	 */
	public static ArrayList<String> deleteListElement(ArrayList<String> list1,ArrayList<String> list2){
    	ArrayList<String> result = new ArrayList<String>();
        for (String integer : list2) {//遍历list1
            if(list1.contains(integer)){//如果存在这个数
            	list1.remove(integer);
                result.add(integer);//放进一个list里面，这个list就是交集
            }
        }
        return list1;
    }
	/** 
     * 大陆手机号码11位数，匹配格式：前三位固定格式+后8位任意数 
     * 此方法中前三位格式有： 
     * 13+任意数 
     * 15+除4的任意数 
     * 18+除1和4的任意数 
     * 17+除9的任意数 
     * 147 
     */  
    public static boolean isChinaPhoneLegal(String str) {  
        String regExp = "^((13[0-9])|(15[^4])|(18[0,2,3,5-9])|(17[0-8])|(147))\\d{8}$";  
        Pattern p = Pattern.compile(regExp);  
        Matcher m = p.matcher(str);  
        return m.matches();  
    } 
    
    
    
    /** 
     * 判断是否为数字
     */  
    public static boolean isnumber(String str) {  
    	
    	
    	Pattern pattern = Pattern.compile("[0-9]*");
        Matcher isNum = pattern.matcher(str);
        if(isNum.matches()) {
        	return true;
        } else {
        	return false;
        }
    } 
	
	
	
	
	/**
	 * 
	 * @author 王
	 * @date 2017-8-18
	 * @file_name Page.java
	 * @Remarks  判断是否为中文
	 */
	public static boolean isChineseChar(String str){     
		boolean temp = false;       
		Pattern p=Pattern.compile("[\u4e00-\u9fa5]");        
		Matcher m=p.matcher(str);        
		if(m.find()){
			temp =  true;        
		}        
		return temp;    
	}
	
	public int absolutepage(int pagecount, int pagesize, String page) {
		int absolute = 0;
		try {
			if (page != null) {
				if (page.trim().length() > 0) {
					intpage = Integer.parseInt(page);
				} else {
					intpage = 1;
				}
			} else if (intpage < 1) {
				intpage = 1;
			}
			if (intpage > pagecount) {
				intpage = pagecount;
			}
			absolute = (intpage - 1) * pagesize + 1;
		} catch (Exception abso) {
			System.err.println((new StringBuilder(
					"page is error----------absolutepage page.servlets.abso"))
					.append(abso.getMessage()).toString());
		}
		return absolute;
	}

	public String pages(int pagecount, String page, int pagesize,
			String pagename) {
		String pages = "";
		try {
			if (pagecount > 0) {
				if (page != null) {
					if (page.trim().length() > 0) {
						intpage = Integer.parseInt(page);
					} else {
						intpage = 1;
					}
				} else if (intpage < 1) {
					intpage = 1;
				}
				if (intpage > pagecount) {
					intpage = pagecount;
				}
				String next;
				if (pagecount > intpage) {
					next = (new StringBuilder("<a href=")).append(pagename)
							.append("page=").append(intpage + 1).append(
									"><img src=img/03.gif border=0></a>")
							.toString();
				} else {
					next = "<img src=img/03.gif border=0>";
				}
				String top;
				if (intpage > 1) {
					top = (new StringBuilder("<a href=")).append(pagename)
							.append("page=").append(intpage - 1).append(
									"><img src=img/02.gif border=0></a>")
							.toString();
				} else {
					top = "<img src=img/02.gif border=0>";
				}
				String counts;
				if (pagecount > 1) {
					counts = (new StringBuilder("<a href=")).append(pagename)
							.append("page=").append(pagecount).append(
									"><img src=img/04.gif border=0></a>")
							.toString();
				} else {
					counts = "<img src=img/04.gif border=0>";
				}
				String neo;
				if (pagecount > 1) {
					neo = (new StringBuilder("<a href=")).append(pagename)
							.append("page=1><img src=img/01.gif border=0></a>")
							.toString();
				} else {
					neo = "<img src=img/01.gif border=0>";
				}
				pages = (new StringBuilder("THis Page<font color=red>"))
						.append(intpage).append("</font>/").append(pagecount)
						.append(neo).append(top).append(next).append(counts)
						.toString();
			} else {
				pages = "<img src=img/01.gif border=0><img src=img/03.gif border=0><img src=img/02.gif bo"
						+ "rder=0><img src=img/04.gif border=0>";
			}
		} catch (Exception e) {
			System.err
					.println((new StringBuilder("page is error page.servlets"))
							.append(e.getMessage()).toString());
		}
		return pages;
	}

	public String page_china(int pagecount, String page, int pagesize,
			String pagename) {
		String pages = "";
		try {
			if (pagecount > 0) {
				if (page != null) {
					if (page.trim().length() > 0) {
						intpage = Integer.parseInt(page);
					} else {
						intpage = 1;
					}
				} else if (intpage < 1) {
					intpage = 1;
				}
				if (intpage > pagecount) {
					intpage = pagecount;
				}
				String next;
				if (pagecount > intpage) {
					next = (new StringBuilder("<a href=")).append(pagename)
							.append("page=").append(intpage + 1).append(
									">\u4E0B\u4E00\u9875</a>&nbsp;").toString();
				} else {
					next = "\u4E0B\u4E00\u9875&nbsp;";
				}
				String top;
				if (intpage > 1) {
					top = (new StringBuilder("<a href=")).append(pagename)
							.append("page=").append(intpage - 1).append(
									">\u4E0A\u4E00\u9875</a>&nbsp;").toString();
				} else {
					top = "\u4E0A\u4E00\u9875&nbsp;";
				}
				String counts;
				if (pagecount > 1) {
					counts = (new StringBuilder("<a href=")).append(pagename)
							.append("page=").append(pagecount).append(
									">\u5C3E\u9875</a>&nbsp;").toString();
				} else {
					counts = "\u5C3E\u9875&nbsp;";
				}
				String neo;
				if (pagecount > 1) {
					neo = (new StringBuilder("<a href=")).append(pagename)
							.append("page=1>\u9996\u9875</a>&nbsp;").toString();
				} else {
					neo = "\u9996\u9875&nbsp;";
				}
				pages = (new StringBuilder("\u5F53\u524D<font color=red>"))
						.append(intpage).append("</font>/").append(pagecount)
						.append("&nbsp;").append(neo).append(top).append(next)
						.append(counts).toString();
			} else {
				pages = "\u9996\u9875&nbsp;\u4E0A\u4E00\u9875&nbsp;\u4E0B\u4E00\u9875&nbsp;\u6700\u540E\u9875"
						+ "&nbsp;";
			}
		} catch (Exception e) {
			System.err
					.println((new StringBuilder("page is error page.servlets"))
							.append(e.getMessage()).toString());
		}
		return pages;
	}

	public boolean kong(String p) {
		String straa = "";
		int strlen = 0;
		try {
			straa = p.trim();
			strlen = straa.length();
		} catch (Exception strse) {
			System.err.println(strse.getMessage());
		}
		return strlen != 0;
	}
	
	public String HTMLENCODE(String x) {
		String body = " ";
		try {
			if (x != null && x.length() > 1) {
				body = x.replaceAll("  ", "&nbsp;");
				body = body.replaceAll("\r\n", "<br>");
				body = body.replaceAll("\r", "<br>");
				body = body.replaceAll("\n", "<br>");
			}
		} catch (Exception stre2) {
			System.err.println((new StringBuilder("Htmlencode - \tE:")).append(
					stre2).toString());
		}
		return body;
	}

	public String URLencode(String x) {
		String body = " ";
		try {
			if (x != null && x.length() > 1) {
				body = x.replaceAll(" ", "%20");
			}
		} catch (Exception stre2) {
			System.err.println((new StringBuilder("Htmlencode - \tE:")).append(
					stre2).toString());
		}
		return body;
	}

	public String HTMLDECODE(String x) {
		String body = " ";
		try {
			if (x != null && x.length() > 1) {
				body = x.replaceAll("&nbsp;", " ");
				body = body.replaceAll("<br>", "\r\n");
			}
		} catch (Exception stre2) {
			System.err.println((new StringBuilder("Htmlencode - \tE:")).append(
					stre2).toString());
		}
		return body;
	}

	public String htmlencode(String s) {
		String b = "";
		@SuppressWarnings("unused")
		String c = "";
		try {
			String a = s.replaceAll("<", "&lt;");
			b = a.replaceAll(">", "&gt;");
		} catch (Exception e) {
			System.err.println("htmlcode is 500 error");
		}
		return b;
	}
	public String htmlencode3(String s) {
		
		String b = "";
		try {
			
			b = s.replaceAll("\\\"", "*");
		} catch (Exception e) {
			System.err.println("htmlcode is 500 error");
		}
		return b;
	}
	public String string2Json(String s) {       
	    StringBuffer sb = new StringBuffer ();       
	    for (int i=0; i<s.length(); i++) {       
	     
	        char c = s.charAt(i);       
	        switch (c) {       
	        case '\"':       
	            sb.append("\\");       
	            break;          
	        default:       
	            sb.append(c);       
	        }
	    }
	    return sb.toString();      
	 }    
	public String htmlencode2(String s) {
		String a = "";
		String b = "";
		try {
			a = s.replaceAll("\n", "<br>");
			b = a.replaceAll(" ", "&nbsp;");
		} catch (Exception e) {
			System.err.println("htmlcode is 500 error");
		}
		return b;
	}

	public String Htmlencode(String x) {
		@SuppressWarnings("unused")
		String f = "";
		String a = "";
		@SuppressWarnings("unused")
		String b = "";
		String c = "";
		String d = "";
		String e = " ";
		try {
			if (x.length() > 1) {
				a = x.replaceAll("<br>", "\n");
				c = a.replaceAll("&nbsp;", " ");
				d = c.replaceAll("<", "&lt;");
				e = d.replaceAll(">", "&gt;");
			}
		} catch (Exception stre2) {
			System.err.println((new StringBuilder("Htmlencode - \tE:")).append(
					stre2).toString());
		}
		return e;
	}
   
	public String Htmlencode_b(String x) {
		@SuppressWarnings("unused")
		String f = "";
		String a = "";
		@SuppressWarnings("unused")
		String b = "";
		String c = "";
		String d = "";
		String e = " ";
		try {
			if (x != null && x.length() > 1) {
				a = x.replaceAll("<br>", "\n");
				c = a.replaceAll("&nbsp;", " ");
				d = c.replaceAll("<", "&lt;");
				e = d.replaceAll(">", "&gt;");
			}
		} catch (Exception stre2) {
			System.err.println((new StringBuilder("Htmlencode - \tE:")).append(
					stre2).toString());
		}
		return e;
	}

	public String codestring(String strs) {
		String stres = " ";
		try {
			if (strs != null && strs.length() > 0) {
				byte strss[] = strs.getBytes();
				stres = new String(strss, "8859_1");
				stres = mysqlCode(stres);
			}
		} catch (Exception stre) {
			System.err.println((new StringBuilder("string code:")).append(
					stre.getMessage()).toString());
		}
		return stres;
	}

	/**
	 * 
	 * @author Administrator
	 * @date 2017-7-25
	 * @file_name Page.java  mysqlCode
	 * @Remarks 过滤sql注入
	 */
	public  String mysqlCode(String strs) {
		String stres = " ";
		try {
			if (strs != null && strs.length() > 0) {
				strs=strs.toLowerCase();
				strs = strs.replaceAll("\\\\", "\\\\\\\\");
				strs = strs.replaceAll("databases", "");
				strs = strs.replaceAll("%", "％");
//				strs = strs.replaceAll("form", "ｆｏｒｍ");
//				strs = strs.replaceAll("or", "");
				//strs = strs.replaceAll("and", "");
				strs = strs.replaceAll("exec", "");
				strs = strs.replaceAll("insert", "");
				strs = strs.replaceAll("select", "");
				strs = strs.replaceAll("delete", "");
				strs = strs.replaceAll("update", "");

				
				//strs = strs.replaceAll("\"", "＂");
				strs = strs.replaceAll("'", "");
				strs = strs.replaceAll("\'", "");
				stres = strs;
				 
			}
		} catch (Exception stre) {
			System.err.println((new StringBuilder("mysql famt code:")).append(stre.getMessage()).toString());
		}
		return stres;
	}
	
	
	
	/**
	 * 
	 * @author Administrator
	 * @date 2017-7-25
	 * @file_name Page.java  mysqlCode
	 * @Remarks 过滤sql注入     只提示   不替换
	 */
	public static String filter_sql(String str)

	{
		str=str.toLowerCase();//统一转为小写 
		String inj_str = "'|*|%|;|,|/**/|(|)|+|exec|insert|select|delete|update|count|chr|mid|master|truncate|char|declare|" +
						 "char|declare|sitename|net user|xp_cmdshell|like'|and|exec|execute|insert|create|drop|" +  
						 "table|from|grant|use|group_concat|column_name|" +  
						 "information_schema.columns|table_schema|union|where|select|delete|update|order|by|count| ";

		//这里的东西还可以自己添加

		String[] inj_stra=inj_str.split("\\|");

		for (int i=0 ; i<inj_stra.length; i++ ){

			if (str.indexOf(inj_stra[i])!=-1){

				return "您输入的字符串包含【"+inj_stra[i]+"】非法字符";
			}
		}
		
			return "安全";

	}

	public String codeString(String strs) {
		String stres = " ";
		try {
			if (strs != null && strs.length() > 0) {
				stres = new String(strs.getBytes("ISO-8859-1"), "gb2312");
			}
		} catch (Exception stre) {
			System.err.println((new StringBuilder("string code:")).append(
					stre.getMessage()).toString());
		}
		return stres;
	}

	public String getTimeA() {
		String value = "";
		try {
			SimpleDateFormat formatter = new SimpleDateFormat(
					"yyyy-MM-dd HH:mm:ss");
			Date currentTime_1 = new Date();
			value = (new StringBuilder()).append(
					formatter.format(currentTime_1)).toString();
		} catch (Exception erra) {
			System.err.println((new StringBuilder(
					"guest.page--------- \u51FA\u9519:")).append(erra)
					.toString());
		}
		return value;
	}

	public String getTimeB() {
		String value = "";
		try {
			SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
			Date currentTime_1 = new Date();
			value = (new StringBuilder()).append(
					formatter.format(currentTime_1)).toString();
		} catch (Exception errb) {
			System.err.println((new StringBuilder(
					"guest.page--------- \u51FA\u9519:")).append(errb)
					.toString());
		}
		return value;
	}

	public String getTimeC() {
		String value = "";
		try {
			SimpleDateFormat formatter = new SimpleDateFormat("MM-dd HH:mm:ss");
			Date currentTime_1 = new Date();
			value = (new StringBuilder()).append(
					formatter.format(currentTime_1)).toString();
		} catch (Exception errc) {
			System.err.println((new StringBuilder(
					"guest.page--------- \u51FA\u9519:")).append(errc)
					.toString());
		}
		return value;
	}

	public String getFormatTime(String formatString) {
		String value = "";
		try {
			SimpleDateFormat formatter = new SimpleDateFormat(formatString);
			Date currentTime_1 = new Date();
			value = (new StringBuilder()).append(
					formatter.format(currentTime_1)).toString();
		} catch (Exception errc) {
			System.err.println((new StringBuilder(
					"guest.page--------- \u51FA\u9519:")).append(errc)
					.toString());
		}
		return value;
	}

	public String getTimeD() {
		String value = "";
		try {
			SimpleDateFormat formatter = new SimpleDateFormat(
					"yyyy\u5E74MM\u6708dd\u65E5HH\u70B9mm\u5206ss\u79D2");
			Date currentTime_1 = new Date();
			value = (new StringBuilder()).append(
					formatter.format(currentTime_1)).toString();
		} catch (Exception errd) {
			System.err.println((new StringBuilder(
					"guest.page--------- \u51FA\u9519:")).append(errd)
					.toString());
		}
		return value;
	}

	public String getTimeE() {
		String value = "";
		try {
			SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss");
			Date currentTime_1 = new Date();
			value = (new StringBuilder()).append(
					formatter.format(currentTime_1)).toString();
		} catch (Exception errd) {
			System.err.println((new StringBuilder(
					"guest.page--------- \u51FA\u9519:")).append(errd)
					.toString());
		}
		return value;
	}

	public String getTimeYY() {
		String value = "";
		try {
			SimpleDateFormat formatter = new SimpleDateFormat("yyyy");
			Date currentTime_1 = new Date();
			value = (new StringBuilder()).append(
					formatter.format(currentTime_1)).toString();
		} catch (Exception erra) {
			System.err.println((new StringBuilder(
					"guest.page--------- \u51FA\u9519:")).append(erra)
					.toString());
		}
		return value;
	}

	public String getTimeMM() {
		String value = "";
		try {
			SimpleDateFormat formatter = new SimpleDateFormat("MM");
			Date currentTime_1 = new Date();
			value = (new StringBuilder()).append(
					formatter.format(currentTime_1)).toString();
		} catch (Exception erra) {
			System.err.println((new StringBuilder(
					"guest.page--------- \u51FA\u9519:")).append(erra)
					.toString());
		}
		return value;
	}

	public String getTimeDD() {
		String value = "";
		try {
			SimpleDateFormat formatter = new SimpleDateFormat("dd");
			Date currentTime_1 = new Date();
			value = (new StringBuilder()).append(
					formatter.format(currentTime_1)).toString();
		} catch (Exception erra) {
			System.err.println((new StringBuilder(
					"guest.page--------- \u51FA\u9519:")).append(erra)
					.toString());
		}
		return value;
	}

	public String Fcode(String s) {
		String value = "";
		int i = 0;
		try {
			if (s != null) {
				char ENCODE_TABLE[] = { '0', '1', '2', '3', '4', '5', '6', '7',
						'8', '9', 'A', 'B', 'C', 'D', 'E', 'F' };
				byte bytes[] = s.getBytes();
				StringBuffer result = new StringBuffer();
				for (i = 0; i < bytes.length; i++) {
					byte c = bytes[i];
					if (c >= 48 && c <= 57 || c >= 97 && c <= 122 || c >= 65
							&& c <= 90) {
						result.append((char) c);
					} else {
						result.append('%');
						result.append(ENCODE_TABLE[c >> 4 & 0xf]);
						result.append(ENCODE_TABLE[c & 0xf]);
					}
				}

				value = result.toString();
				result = null;
				ENCODE_TABLE = (char[]) null;
			}
		} catch (Exception e) {
			System.out.print((new StringBuilder("server.urlcode is err:"))
					.append(e).toString());
		}
		return value;
	}

	public static void saveFile(String path, String body, boolean b) {
		try {
			FileWriter w = new FileWriter(path, b);
			PrintWriter p = new PrintWriter(w);
			p.print(body);
			p.close();
			w.close();
		} catch (Exception e) {
			System.out.println((new StringBuilder()).append(e.toString()).toString());
		}
	}
	
	/**
	 * 
	 * @author Administrator
	 * @date 2017-7-25
	 * @file_name Page.java  regex
	 * @Remarks  正则验证
	 */
	public static   boolean regex(String str){ 
		if(str==null || str.length()==0){str="  @";}
		java.util.regex.Pattern p=null; //正则表达式 
		java.util.regex.Matcher m=null; //操作的字符串 
		boolean value=true; 
		try{ 
		p = java.util.regex.Pattern.compile("[^0-9A-Za-z]"); 
		m = p.matcher(str); 
		if(m.find()) { 

		value=false; 
		} 
		}catch(Exception e){} 
		return value; 
		} 
	
	/**
	 * @category 字符串7,1,4,9 冒泡法从小到大排序方法
	 * @param string   传入的字符串
	 * @exception StringSort  ("89,123,1231,1,24,4")
	 * @return Bubble
	 */

	public static String StringSort(String string) throws HttpException,
			IOException {
		String Bubble = "";
        try {
		String ids[] = string.replaceAll(" ", "").split(",");
		int arr[] = new int[ids.length];
		for (int i = 0; i < ids.length; i++) {
			arr[i] = Integer.parseInt(ids[i]);
		}

		// 冒泡算法
		for (int i = arr.length - 1; i > 0; i--) {// 让比较的范围不停的减掉最后一个单元
			for (int j = 1; j <= i; j++) {
				if (arr[j - 1] > arr[j]) {// 让2个数之间大的数排后面
					int tmp = arr[j - 1];
					arr[j - 1] = arr[j];
					arr[j] = tmp;
				}

			}
		}
		   Bubble = Arrays.toString(arr).replaceAll(" ", "").replaceAll("\\[", "").replaceAll("\\]", "");
		 } catch (Exception e) {
			Bubble="0"; //如果传入字符串不符合纯数字返回0
		}
		return Bubble;

	}
	
	/**
	 * 正则判断是否是数字
	 * @param str
	 * @return
	 */
	public boolean regex_num(String str){ 
		java.util.regex.Pattern p=null;  
		java.util.regex.Matcher m=null; 
		boolean value=true; 
		try{ 
			p = java.util.regex.Pattern.compile("[^0-9]"); 
			m = p.matcher(str); 
			if(m.find()) { 
				value=false; 
			} 
		}catch(Exception e){
			
		} 
			return value; 
	}
	
	
	public static  void  json_replace(String str) {
		
    	//一维
//    	String a="{\"success\":\"true\",\"resultCode\":\"1000\",\"msg\":\"返回表单成功\",\"moudel\":[{\"name\":\"档案管理\",\"basetable\":\"archives\",\"threads\":[{\"uniquelyid\":\"22\",\"ftype_name\":\"单行文本\",\"ftype_tag\":\"txt\",\"title\":\"名字\",\"prompt\":\"输入名字\",\"tmust_input\":\"\",\"teams\":\"123321\",\"fieldname\":\"name\",\"fieldnamvalue\":\"111\",\"editstatus\":\"1\",\"datatype\":\"string\"},{\"uniquelyid\":\"23\",\"ftype_name\":\"单行文本\",\"ftype_tag\":\"txt\",\"title\":\"年龄\",\"prompt\":\"年龄\",\"tmust_input\":\"\",\"teams\":\"\",\"fieldname\":\"age\",\"fieldnamvalue\":\"111\",\"editstatus\":\"1\",\"datatype\":\"num\"},{\"uniquelyid\":\"24\",\"ftype_name\":\"单选\",\"ftype_tag\":\"radio\",\"title\":\"性别\",\"prompt\":\" \",\"tmust_input\":\"\",\"teams\":[{\"option\":\"1\",\"option_value\":\"女\"},{\"option\":\"0\",\"option_value\":\"男\"}],\"fieldname\":\"sex\",\"fieldnamvalue\":\"111\",\"editstatus\":\"1\",\"datatype\":\"radio\"},{\"uniquelyid\":\"25\",\"ftype_name\":\"下拉\",\"ftype_tag\":\"select\",\"title\":\"婚姻状况\",\"prompt\":\" \",\"tmust_input\":\"\",\"teams\":[{\"option\":\"0\",\"option_value\":\"未婚\"},{\"option\":\"1\",\"option_value\":\"已婚\"},{\"option\":\"2\",\"option_value\":\"离异\"},{\"option\":\"3\",\"option_value\":\"丧偶\"}],\"fieldname\":\"marriage\",\"fieldnamvalue\":\"111\",\"editstatus\":\"1\",\"datatype\":\"select\"},{\"uniquelyid\":\"26\",\"ftype_name\":\"单行文本\",\"ftype_tag\":\"txt\",\"title\":\"家庭地址\",\"prompt\":\"家庭地址\",\"tmust_input\":\"\",\"teams\":\"\",\"fieldname\":\"address\",\"fieldnamvalue\":\"111\",\"editstatus\":\"1\",\"datatype\":\"string\"},{\"uniquelyid\":\"27\",\"ftype_name\":\"单行文本\",\"ftype_tag\":\"txt\",\"title\":\"公司名字\",\"prompt\":\"公司名字\",\"tmust_input\":\"\",\"teams\":\"\",\"fieldname\":\"companyname\",\"fieldnamvalue\":\"111\",\"editstatus\":\"1\",\"datatype\":\"string\"},{\"uniquelyid\":\"28\",\"ftype_name\":\"单行文本\",\"ftype_tag\":\"txt\",\"title\":\"公司地址\",\"prompt\":\"公司地址\",\"tmust_input\":\"\",\"teams\":\"\",\"fieldname\":\"companyaddress\",\"fieldnamvalue\":\"111\",\"editstatus\":\"1\",\"datatype\":\"string\"}]},{\"name\":\"基础信息\",\"basetable\":\"baseinfo\",\"threads\":[{\"uniquelyid\":\"22\",\"ftype_name\":\"单行文本\",\"ftype_tag\":\"txt\",\"title\":\"名字\",\"prompt\":\"输入名字\",\"tmust_input\":\"\",\"teams\":\"\",\"fieldname\":\"name\",\"fieldnamvalue\":\"111\",\"editstatus\":\"1\",\"datatype\":\"string\"},{\"uniquelyid\":\"23\",\"ftype_name\":\"单行文本\",\"ftype_tag\":\"txt\",\"title\":\"年龄\",\"prompt\":\"年龄\",\"tmust_input\":\"\",\"teams\":\"\",\"fieldname\":\"age\",\"fieldnamvalue\":\"111\",\"editstatus\":\"1\",\"datatype\":\"num\"},{\"uniquelyid\":\"24\",\"ftype_name\":\"单选\",\"ftype_tag\":\"radio\",\"title\":\"性别\",\"prompt\":\" \",\"tmust_input\":\"\",\"teams\":[{\"option\":\"1\",\"option_value\":\"女\"},{\"option\":\"0\",\"option_value\":\"男\"}],\"fieldname\":\"sex\",\"fieldnamvalue\":\"111\",\"editstatus\":\"1\",\"datatype\":\"radio\"},{\"uniquelyid\":\"25\",\"ftype_name\":\"下拉\",\"ftype_tag\":\"select\",\"title\":\"婚姻状况\",\"prompt\":\" \",\"tmust_input\":\"\",\"teams\":[{\"option\":\"0\",\"option_value\":\"未婚\"},{\"option\":\"1\",\"option_value\":\"已婚\"},{\"option\":\"2\",\"option_value\":\"离异\"},{\"option\":\"3\",\"option_value\":\"丧偶\"}],\"fieldname\":\"marriage\",\"fieldnamvalue\":\"111\",\"editstatus\":\"1\",\"datatype\":\"select\"},{\"uniquelyid\":\"26\",\"ftype_name\":\"单行文本\",\"ftype_tag\":\"txt\",\"title\":\"家庭地址\",\"prompt\":\"家庭地址\",\"tmust_input\":\"\",\"teams\":\"\",\"fieldname\":\"address\",\"fieldnamvalue\":\"111\",\"editstatus\":\"1\",\"datatype\":\"string\"},{\"uniquelyid\":\"27\",\"ftype_name\":\"单行文本\",\"ftype_tag\":\"txt\",\"title\":\"公司名字\",\"prompt\":\"公司名字\",\"tmust_input\":\"\",\"teams\":\"\",\"fieldname\":\"companyname\",\"fieldnamvalue\":\"111\",\"editstatus\":\"1\",\"datatype\":\"string\"},{\"uniquelyid\":\"28\",\"ftype_name\":\"单行文本\",\"ftype_tag\":\"txt\",\"title\":\"公司地址\",\"prompt\":\"公司地址\",\"tmust_input\":\"\",\"teams\":\"\",\"fieldname\":\"companyaddress\",\"fieldnamvalue\":\"111\",\"editstatus\":\"1\",\"datatype\":\"string\"}]}]}";
    
		   JSONArray arr = JSONArray.fromObject("[" + str + "]");
		   
		   for(int i = 0; i < arr.size(); i++){
			   
			    JSONObject obj = arr.getJSONObject(i);
				Iterator iterator = obj.keys();
				while(iterator.hasNext()){
		        	String key = (String) iterator.next();
		            String value = obj.getString(key);
		            
		            if(value.lastIndexOf("[",0)!=-1){
		            	jsonArr(value);
		            }else{
		            	if(value.lastIndexOf("{",0)!=-1){
		    				JSONObject obj2=JSONObject.fromObject(obj);
		    				Iterator<Object> iterator1 = obj2.keys();
		    				while(iterator1.hasNext()){
		    				    jsonObj( obj2.getString((String) iterator1.next()));
		    				}
		    			}else{
//		    				 mysqlCode(value);
		    				System.out.println("value==="+value);
		    			}
	            	}
				}
		   }
    
    
    }
	
	/**
	  * 
	  * @author Administrator
	  * @date 2017-8-15
	  * @file_name Page.java
	  * @Remarks  解析jsonArr
	  */
	 public static String jsonArr(String arr) {
		 JSONArray arr2 = JSONArray.fromObject(arr);
		 for(int j = 0; j < arr2.size(); j++){
			 if(arr2.getString(j).lastIndexOf("[",0)!=-1){
     			jsonArr(arr2.getString(j));
     		}else{
     			jsonObj(arr2.getString(j));
     		}
     	 }
		return "";
	}
	 /**
	  * 
	  * @author Administrator
	  * @date 2017-8-15
	  * @file_name Page.java
	  * @Remarks  解析json对象
	  */
	public static String jsonObj(String obj) {
		if(obj.lastIndexOf("{",0)!=-1){
			JSONObject obj2=JSONObject.fromObject(obj);
			Iterator<Object> iterator = obj2.keys();
			while(iterator.hasNext()){
			        	String key = (String) iterator.next();
			            String value = obj2.getString(key);
			            if(value.lastIndexOf("{",0)!=-1){
			            	jsonObj(value);
						}else if(value.lastIndexOf("[",0)!=-1){
							jsonArr(value);
						}else{
							obj2.put(key, "111");
						}
			}
			System.out.println(obj2);
		}else{
			jsonArr(obj);
		}
		return "";
	}
	
	
	/**
	 * 判断ip是否在ip列表里面
	 * @param ips
	 * @param ip
	 * @return
	 */
	public static boolean IPMatch(List ips, String ip) {  
//        if (ips.contains(ip)) {
//            return true;
//        }
//
//        for (int i = 0; i < ips.size(); i++) {
//            List lip = Arrays.asList(ips.get(i).toString().split("\\."));
//            String re = "^";
//            for (int j = 0; j < lip.size(); j++) {
//                String num = lip.get(j).toString();
//                if (num != "*") {
//                    re += num + ".";
//                } else {
//                    re += "\\d{0,3}.";
//                }
//                if (j == lip.size()) {
//                    re = re.substring(0, re.length() - 1).toString() + "\\$";
//                }
//            }
//
//            Pattern pattern = Pattern.compile(re);
//            Matcher matcher = pattern.matcher(ip);
//            if (matcher.matches()) {
//                return true;
//            }
//        }
        return true;
    }  
	
	
	public static void main(String[] args) throws SocketException {
		//System.out.println(isnumber("188131654651a"));
		
		String ipes = "218.7.10.5,218.7.10.5,218.7.10.*,";
		List <String>  ipList=java.util.Arrays.asList(ipes.split(","));
		System.out.println(IPMatch(ipList,"218.7.255.228"));
		
		 
		
		}
}
