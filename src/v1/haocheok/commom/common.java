package v1.haocheok.commom;

import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Random;
import java.util.Set;

import org.apache.commons.lang3.StringUtils;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import service.dao.db.Jdbc;
import service.dao.db.Page;
import service.util.date.DateUtils;
import v1.haocheok.commom.utiles.OrderUtils;

/**
 * 公共方法类
 * @company 010jiage
 * @date:2017-9-21 上午10:37:18
 */
public class common {
	
	public static void VerificationToken(String Token){
		Jdbc db = new Jdbc();
		Page page = new Page();
	}
	/**
	 * 通过uid 查找到username
	 * @param uid
	 * @return
	 */
	public static String getusernameTouid(String uid){
		Jdbc db = new Jdbc();
		Page page = new Page();
		String username = ""; 
		String username_sql = "select username from `user_worker` where uid = '"+uid+"' ;";
		try {
			ResultSet prsResultSet = db.executeQuery(username_sql);
			if(prsResultSet.next()){
				username = prsResultSet.getString("username");
			}
		} catch (SQLException e) {
			
			e.printStackTrace();
		}
		Page.colseDP(db, page);
		return username;
	}
	/**
	 * 数据分页 返回page页数，listnum 每页条数
	 * @param db
	 * @param sql
	 * @param page
	 * @param limitnum
	 * @param keyword
	 * @return
	 */
	public static HashMap<String, Object> pagemap(Jdbc db, String sql ,String page,String limitnum,String keyword){
		//分页 search
		int   listnum2=Integer.parseInt(limitnum);
		int   Asum2 = db.Row(sql);
		int Zongshu=Asum2;
		   int pages2=Integer.parseInt(page);
		   int Zpages2=0;
			
			if(Asum2%listnum2==0){  
			Zpages2=(Asum2/listnum2);  
			}else{ 
				Zpages2=(Asum2/listnum2)+1;  
			}
			int DQcount2=(pages2*listnum2)-listnum2;  
		     if(DQcount2<0){DQcount2=0;}
		     HashMap<String, Object> map = new HashMap<String, Object>();
		     map.put("DQcount2", DQcount2);
		     map.put("listnum2", listnum2);
		return map;
	}
	
	/**
	 * 数据分页，前段传递来 页数，每页显示数
	 * @param listnum
	 * @param Dpage
	 * @return
	 */
	public static HashMap<String, Object> pagenumMap(String Dpage,String listnum){
		
		int listnum2=Integer.parseInt(listnum);
		int pagenum =Integer.parseInt(Dpage) ;
		int currentpage = (pagenum-1)*listnum2;
		HashMap<String, Object> map = new HashMap<String, Object>();
		map.put("DQcount2", currentpage);
	    map.put("listnum2", listnum2);
		return map;
		
	}
	/**
	 * 生成订单号
	 * @return
	 */
	public static String getNumCode(){
		Jdbc db = new Jdbc();
		Page page = new Page();
		int count = 0;
		Calendar now = Calendar.getInstance();  
		Integer y=now.get(Calendar.YEAR);
		String year_sql = "select count from curriculum_seq where year = '"+y+"'";  
		ResultSet yearResultSet = db.executeQuery(year_sql);
		try {
			if(yearResultSet.next()){
				count = yearResultSet.getInt("count");
			}if(yearResultSet!=null){yearResultSet.close();}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		//原有基础上加一
		count = count+1;
		String update_sql = "update `curriculum_seq` set count = '"+count+"' where year = '"+y+"'";
		boolean  status = db.executeUpdate(update_sql);
		String orderCode=OrderUtils.getOrderNum(count);
		page.colseDP(db, page);
		return orderCode;
	}
	
	/**
	 * 通过code 返回信息info,数据字典
	 * @param typegroupcode
	 * @param typecode
	 * @return
	 */
	public static String getDis4info(String typegroupcode,String typecode){
		Jdbc db = new Jdbc();
		Page page = new Page();
		String sqlString = "SELECT type.typename FROM typegroup,TYPE WHERE typegroup.typegroupcode = '"+typegroupcode+"' AND typegroup.id = type.typegroupid AND type.typecode = '"+typecode+"';";
		
		ResultSet baseResultSet = db.executeQuery(sqlString);
		String nameString = "";
		try {
			if(baseResultSet.next()){
				nameString = baseResultSet.getString("typename");
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
		page.colseDP(db, page);
		return nameString;
	}
	
	/**
	 * 通过groupcode 获得map集合
	 * @param groupCode
	 * @return
	 */
	public static Map<String, String> getDicMap(String groupCode){
		Jdbc db = new Jdbc();
		Page page = new Page();
		String sql = "SELECT type.typename,type.typecode FROM typegroup,TYPE WHERE typegroup.typegroupcode = '"+groupCode+"' AND typegroup.id = type.typegroupid";
		ResultSet baseResultSet = db.executeQuery(sql);
		Map<String,String> map=new HashMap<String, String>();
		try {
			while(baseResultSet.next()){
				map.put(baseResultSet.getString("typecode"), baseResultSet.getString("typename"));
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
		page.colseDP(db, page);
		return map;
	}
	
	/**
	 * 
	 * @param rolecode
	 * @param orderid
	 * @return
	 */
	public static Map<String, String> getStateTime(String rolecode,String orderid){
		Jdbc db = new Jdbc();
		Page page = new Page();
		Map<String, String> map = new HashMap<String, String>();
		String sql = "SELECT status,creation_date FROM (SELECT STATUS,creation_date FROM process_log WHERE orderid = "+orderid+" AND rolecode='"+rolecode+"' ORDER BY creation_date DESC) AS temp GROUP BY STATUS ";
		String adopttime = "";
		String ordertime = "";
		String time_consuming = "";
		
		ResultSet sql_PrSet = db.executeQuery(sql);
		try {
			while(sql_PrSet.next()){
				if("1".equals(sql_PrSet.getString("status"))){
					ordertime = sql_PrSet.getString("creation_date");
				}
				if("6".equals(sql_PrSet.getString("status")) && ordertime.compareTo(sql_PrSet.getString("creation_date")) <= 0 ){
					adopttime = sql_PrSet.getString("creation_date");
				}
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		if(!"".equals(adopttime) && !"".equals(ordertime)){
			time_consuming = DateUtils.getDatePoor_fen(Timestamp.valueOf(adopttime),Timestamp.valueOf(ordertime));
		}
		//接单时间
		map.put("ordertime", ordertime);
		//通过时间
		map.put("adopttime", adopttime);
		//耗时时间
		map.put("time_consuming", time_consuming);
		page.colseDP(db, page);
		return map;
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
	
	/**
	 * @author 李高颂
	 * @category 通过某个表名与对应的字段传入索引值得到值的vluae
	 * @param tableName 表名
	 * @param Field 字段名
	 * @id 字段索引id
	 * 
	 */
	
	 public String idToFieidName(String tableName,String Field,String id) {
			String fieidValue = " ";
			Jdbc db = new Jdbc();
			Page page = new Page();
			Field = "IFNULL("+Field+",'')";
			if(id==null || "".equals(id)){
				id = "0";
			}
			try{
				String SQL="SELECT "+Field+" FROM "+tableName+" WHERE id="+id+"";
				
			   ResultSet  RS=db.executeQuery(SQL);  
			   while(RS.next()){
				   fieidValue=RS.getString(Field);
			   }
				
			} catch (Exception stre) {
				System.err.println((new StringBuilder("mysql famt code:")).append(stre.getMessage()).toString());
			}
			page.colseDP(db, page);
			return fieidValue;
		}
	 
	 /**
	  * @category 取type表查找类型名字
	  * @param typecode 字典类型
	  * @param id 字典 id
	  * @return fieidValue 字典名称
	  * @作者：王巨星
	  */
	 public String fidToTypeTable(String typecode,int id) {
			String fieidValue = " ";
			Jdbc db = new Jdbc();
			Page page = new Page();
			try{
				String SQL="SELECT typename FROM type WHERE typegroupid='"+id+"' AND typecode='"+typecode+"';";
				
			   ResultSet  RS=db.executeQuery(SQL);  
			   while(RS.next()){
				   fieidValue=RS.getString("typename");
			   }
			} catch (Exception stre) {
				System.err.println((new StringBuilder("mysql famt code:")).append(stre.getMessage()).toString());
			}
			page.colseDP(db, page);
			return fieidValue;
		}
	 
		/**
		 * @author ligaosong
		 * @category 公共sql查询 封装
		 * @param SqlField 要查询的字段
		 * @param Sql 语句 例子 SELECT ? FROM  `zk_user_role`;
		 * @param Where 要查询的条件  例子  WHERE sys_user_id=46
		 * @return  List<Map<String, Object>>
		 */
		public static List<Map<String, Object>>  getPubSqlData( ArrayList<String> SqlField,String Sql,String Where){
			 
			List<Map<String, Object>> dataList  = new ArrayList<Map<String, Object>>();
			
			Jdbc db = new Jdbc();
			Page page = new Page();
			
			Sql=Sql.replaceAll("\\?", SqlField.toString().replaceAll("\\[", "").replaceAll("\\]", ""))+" "+Where;
		  	ResultSet rs = db.executeQuery(Sql);
			try {
				while(rs.next()){
					Map<String, Object> map = new HashMap<String, Object>();
					 for(int i = 0 ; i < SqlField.size() ; i++) { //把所有字段循环获取
					     map.put(SqlField.get(i),rs.getString(SqlField.get(i))); 
					   }
					  dataList.add(map);//加入到list
				   } if(rs!=null){rs.close();}
			} catch (SQLException e) {
				e.printStackTrace();
			}
		 
			page.colseDP(db, page);
			return dataList ;
		}
		/*调用用例子：
		 *  ArrayList<String> coursesField= new ArrayList<String>();
		    List<Map<String, Object>> coursesResult = new ArrayList<Map<String, Object>>();
		    
            coursesField.add("p.id");
            coursesField.add("p.teaching_plan_name");
            coursesResult=common.getPubSqlData(coursesField,"SELECT ?   FROM  teaching_plan_class AS p,major AS m,dict_departments AS d ","");
        
            for(int i=0;i<coursesResult.size();i++){
			   System.out.println(coursesResult.size.get(i).get("id")+"<br>");
		   };
		 */
	 
		
		
		
		
}
