package test;
/** 
 * @author 王巨星 E-mail:  
 * @version 自动创建时间：2017-10-20 11:41:17
 * 类说明 测试生产菜单接口
 */


import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.LinkedList;
import java.util.List;
import java.sql.ResultSet;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang3.StringUtils;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import service.dao.db.Jdbc;
import service.dao.db.Page;
import service.sys.ErrMsg;

public class TestData {

	private HttpServletRequest request;
	private HttpServletResponse response;

	public TestData (HttpServletRequest request, HttpServletResponse response) {
		this.request = request;
		this.response = response;
	}
	
	public void Transmit(String Token,String UUID,String USERID,String DID,String Mdels,String NetMode,String ChannelId,String RequestJson,String ip,String GPS,String GPSLocal,String AppKeyType,long TimeStart) throws ServletException, IOException {
		    Jdbc db = new Jdbc();
		    Page page = new Page();
		
            response.setContentType("text/html;charset=UTF-8");
			request.setCharacterEncoding("UTF-8");
			response.setCharacterEncoding("UTF-8");
			PrintWriter out = response.getWriter();

		    String classname="测试生产菜单接口";
	        String claspath=this.getClass().getName();

	    	//定义json接受字段列表
            
           String Dpage="";
           String listnum="";
             
		   JSONObject json = new JSONObject();
		   ArrayList list = new ArrayList();
		   
		  
			    
      //生产菜单
	  try {   
		    out.print(RequestJson);
		  
		  String [] ClassArr=RequestJson.split("#");//分割2级标题
		   
		  for(int i=0;i<ClassArr.length;i++){
			 String [] ClassArry=ClassArr[i].split("，");//分割3级标题
			  // System.out.println(ClassArry[0]);
			 //添加2级标题
			 String sql="INSERT INTO  menu_sys(`menuname`,`ico`,`fatherid`,`depth`,`menutxt`)VALUES ('"+ClassArry[0]+"','&#xe623;',210,2,'"+ClassArry[0]+"');";
			 db.executeUpdate(sql);
			 for(int j=1;j<ClassArry.length;j++){
				
				  String SQL=" SELECT * FROM menu_sys WHERE menuname='"+ClassArry[0]+"'";
				    
			      ResultSet RS = db.executeQuery(SQL);
			      while (RS.next()) {
				    //RS.getString("id");
			    	  //添加3级标题
				    String sqls="INSERT INTO  menu_sys(`menuname`,`ico`,`fatherid`,`depth`,`menutxt`)VALUES ('"+ClassArry[j]+"','&#xe623;','"+ RS.getString("id")+"',3,'"+ClassArry[0]+"');";
					db.executeUpdate(sqls);
			      }
			 }
			 
		  }
	           String responsejson=""; //返回客户端数据 

		        //记录日志
      		    	long ExeTime = Calendar.getInstance().getTimeInMillis()-TimeStart;
      			    String InsertSQLlog = "INSERT INTO  ec_appuse_log (`uuid`,`Mdels`,`NetMode`,`GPS`,`GPSLocal`,`username`,`did`,`uid`,`ExeTime`,`classpath`,`classname`,`ip`,`logintime`,`requestjson`,`responsejson`) VALUES ('"+UUID+"','"+Mdels+"','"	+NetMode+"','"+GPS+"','"+GPSLocal+"','"	+USERID+"','"+DID+"','"+USERID+"','"+ExeTime+"','"+claspath+"','"+classname+"','"+ip+"',now(),'"+RequestJson+"','"+responsejson+"');";
      			    db.executeUpdate(InsertSQLlog);
      			// 记录日志end     

      	} catch (Exception e) {
			 
				int ErrLineNumber = e.getStackTrace()[0].getLineNumber();
				ErrMsg.falseErrMsg(request, response, "500", "服务器开小差啦-"+ErrLineNumber);
			    db.executeUpdate(" INSERT INTO `log_sys`(`ltype`,`title`,`body`,`uid`,`ip`,`addtime`) VALUES ('系统错误','"+classname+"模块系统出错','错误信息详见 "+claspath+",第"+ErrLineNumber+"行。','"+USERID+"','"+ip+"',now());;");
			    if (db != null) { db.close(); db = null; 	}
                if (page != null) { 	page = null; 	}
                out.flush();
				out.close();
			    return;
		}		    
		//关闭数据与serlvet.out
		if (db != null) { db.close(); db = null; }
		if (page != null) {page = null;}
				
		out.flush();
		out.close();
	}
	

	
	
	public static ArrayList<ArrayList<String>> toArrayList(String str){
		
		str = "1*2*3*4#1*2*3*4";
		
		
		ArrayList<ArrayList<String>> textList = new ArrayList<ArrayList<String>>();
 		
		
		
		ArrayList list = new ArrayList(Arrays.asList(str.split("#")));
		
		for(int i =0; i <list.size(); i++ ){
			textList.add(new ArrayList<String>(Arrays.asList(((String) list.get(i)).split("\\*"))));
		}
		
		
		
		return textList;
	}
	
	
	
	
	public static String toStringfroList(ArrayList<ArrayList<String>> testList,String a,String b){
		
		//一位数组
		ArrayList<Object> te1 = new ArrayList<Object>();
		
		for(int i =0 ; i < testList.size() ;i++){
			ArrayList<String> tttArrayList = testList.get(i);
			String www= StringUtils.join(tttArrayList,a);
			te1.add(www);
		}
		String reStr = StringUtils.join(te1,b);
		return reStr;
	}
	
	
 
    public static String[][] toArray(String str) {
        String[] split = str.split("\\$");
        String[][] array = new String[split.length][];
        for (int i = 0; i < split.length; i++) {
            array[i] = split[i].split(";");
        }
        return array;
    }


    public static void main(String[] args) throws Exception {
    	String ssString = "[{\"week\":18,\"threadid\":\"4\",\"threadname\":\" ◆ \"},{\"week\":20,\"threadid\":\"4\",\"threadname\":\" ◆ \"}]";
    	
    	ArrayList<Integer> ttArrayList = new ArrayList<Integer>();
    	JSONArray arr = JSONArray.fromObject(ssString);
		for (int i = 0; i < arr.size(); i++) {
			JSONObject obj = arr.getJSONObject(i);
			if(!"15".equals(obj.getString("threadid"))){
				ttArrayList.add(Integer.valueOf(obj.getString("week")));
			}
			
		}
		System.out.println("ttarrayList==="+ttArrayList);
		
		System.out.println(getweekStr(ttArrayList,20));
    	
    }
    
    
    
    public static String getweekStr(ArrayList<Integer> list, int weeks ){
    	
    	String str = "";
    	ArrayList<Integer> testArrayList = new ArrayList<Integer>();
    	for(int i =1 ;i<=weeks;i++){
    		testArrayList.add(i);
    	}
    	testArrayList.removeAll(list);
        List<Integer> c = new LinkedList<Integer>(); // 连续的子数组
        c.add(testArrayList.get(0));
        for (int i = 0; i < testArrayList.size() - 1; ++i) {
            if (testArrayList.get(i) + 1 == testArrayList.get(i+1)) {
                c.add(testArrayList.get(i+1));
            } else {
                if (c.size() > 1) {
                    str += c.get(0)+"-"+c.get(c.size()-1)+","  ;
                }else if(c.size()==1){
                	str += c.get(0)+",";
                }
                c.clear();
                c.add(testArrayList.get(i+1));
            }
        }
        if (c.size() > 1) {
            str += c.get(0)+"-"+c.get(c.size()-1);
        }else if(c.size()==1){
        	str += c.get(0);
        }
    	return str;
    	
    }
    
    
}
