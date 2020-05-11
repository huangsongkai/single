package service.dao.db;

import java.lang.reflect.Field;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

public class Jdbc {

	Connection conn;
	Statement sm;
	ResultSet rs;
	DataSource ds;

	Connection conn2;
	Statement sm2;
	ResultSet rs2;
	DataSource ds2;

	public Jdbc() {
		conn = null;
		sm = null;
		rs = null;
		ds = null;

		conn2 = null;
		sm2 = null;
		rs2 = null;
		ds2 = null;
		try {

		} catch (Exception e) {
			System.err.println((new StringBuilder("jdbc-Context---conn err:"))
					.append(e.getMessage()).toString());
		}
	}

	public Connection getConnection() {
		return conn;
	}

	public PreparedStatement getPreparedStatement(String sql) {
		PreparedStatement ps = null;

		try {
			ps = conn.prepareStatement(sql);

		} catch (Exception qe) {
			System.err.println((new StringBuilder("jdbc--java.sql.PreparedStatement getPreparedStatement(String sql)-conn err:"))
							.append(qe.getMessage()).toString());
		}
		return ps;
	}

	public ResultSet executeQuery(String sql) {
		rs = null;
		try {
		   
			if(conn==null){
				Context initCtx = new InitialContext();
			    ds = (DataSource) initCtx.lookup("java:comp/env/jdbc/mysqldb_read");
			    conn = ds.getConnection();
			}
			sm = conn.createStatement();
			rs = sm.executeQuery(sql);
		} catch (Exception qe) {
			System.out.println("executeQuery err：" + qe);
			System.err.println("executeQuery sql_str：" + sql);
		}
		return rs;
	}
	
	
	public HashMap<String, String> executeQuery_map(String sql_only) {
		rs = null;
		HashMap<String, String> map = new HashMap<String, String>(); 
		try {
		   
			if(conn==null){
				Context initCtx = new InitialContext();
			    ds = (DataSource) initCtx.lookup("java:comp/env/jdbc/mysqldb_read");
			    conn = ds.getConnection();
			}
			sm = conn.createStatement();
			rs = sm.executeQuery(sql_only);
			ResultSetMetaData data = rs.getMetaData();
			
			 while (rs.next()) {  
		            for (int i = 1; i <= data.getColumnCount(); i++) {// 数据库里从 1 开始  
		  
		                String c = data.getColumnName(i);  
		                String v = rs.getString(c);  
		                map.put(c, v);  
		            }  
		        }  
		} catch (Exception qe) {
			System.out.println("executeQuery_map err：" + qe);
			System.out.println("executeQuery_map sql_str：" + sql_only);
		}
		return map;
	}
	/**
	 * 
	 * @author Administrator
	 * @date 2017-8-10
	 * @file_name Jdbc.java
	 * @Remarks  查询语句返回string
	 */
	public String executeQuery_str(String sql) {
		String executeQuery_str = "";
		ResultSet rs = null;
		try {
			if(conn==null){
				Context initCtx = new InitialContext();
			    ds = (DataSource) initCtx.lookup("java:comp/env/jdbc/mysqldb_read");
			    conn = ds.getConnection();
			}
			sm = conn.createStatement();
			rs = sm.executeQuery(sql);
			if (rs.next()) {
				executeQuery_str = rs.getString("str");
			}if(rs!=null){rs.close();}
			sm.close();
			sm = null;
			rs.close();
		} catch (Exception inte) {
			System.out.println("executeQuery_str err：" + inte);
			System.out.println("executeQuery_str sql_str：" + sql);
		}
		System.out.println("executeQuery_str：" + executeQuery_str);
		return executeQuery_str;
	}

	/**
	 * 
	 * @author Administrator
	 * @date 2017-8-10
	 * @file_name Jdbc.java
	 * @Remarks   设置 GROUP函数 长度
	 */
	public boolean executeUpdate_GROUP(String sql) {
		rs = null;
		try {
		   
			if(conn==null){
				Context initCtx = new InitialContext();
			    ds = (DataSource) initCtx.lookup("java:comp/env/jdbc/mysqldb_read");
			    conn = ds.getConnection();
			}
			sm = conn.createStatement();
			sm.executeUpdate(sql);
		} catch (Exception qe) {
			System.out.println("executeUpdate_GROUP err：" + qe);
			System.out.println("executeUpdate_GROUP sql_str：" + sql);
			return false;
		}
		return true;
	}
	
	public boolean executeUpdate(String sql) {
		rs = null;
		try {
			if(conn2==null){
			  Context initCtx = new InitialContext();
			  ds2 = (DataSource) initCtx.lookup("java:comp/env/jdbc/mysqldb_write");
			  conn2 = ds2.getConnection();
			}
			sm2 = conn2.createStatement();
			sm2.executeUpdate(sql);
		} catch (Exception ue) {
			System.out.println("executeUpdate err：" + ue);
			System.out.println("executeUpdate sql_str：" + sql);
			return false;
		}
		return true;
	}
	/**
	 * 
	 * @author Administrator
	 * @date 2017-8-7
	 * @file_name Jdbc.java
	 * @Remarks  （更新|写入）返回当前数据的id  不反回ture  或者 false  
	 */
	public int executeUpdateRenum(String sql) {
		rs = null;
		int id = 0;
		try {
			if(conn2==null){
			  Context initCtx = new InitialContext();
			  ds2 = (DataSource) initCtx.lookup("java:comp/env/jdbc/mysqldb_write");
			  conn2 = ds2.getConnection();
			}
			sm2 = conn2.createStatement();
			sm2.executeUpdate(sql);
			ResultSet results = sm2.getGeneratedKeys();
			if(results.next()){
				id = results.getInt(1);
			}
		} catch (Exception ue) {
			System.out.println("executeUpdateRenum err：" + ue);
			System.out.println("executeUpdateRenum sql_str：" + sql);
			return id;
		}
		return id;
	}

	public int Row(String sql) {
		int row = 0;
		int pagecount = 0;
		ResultSet rs = null;
		try {
			if(conn==null){
				Context initCtx = new InitialContext();
			    ds = (DataSource) initCtx.lookup("java:comp/env/jdbc/mysqldb_read");
			    conn = ds.getConnection();
			}
			sm = conn.createStatement();
			rs = sm.executeQuery(sql);
			if (rs.next()) {
				row = rs.getInt("row");
			}
			sm.close();
			sm = null;
			rs.close();
			rs = null;
		} catch (Exception inte) {
			System.out.println("executeUpdateRenum err：" + inte);
			System.out.println("executeUpdateRenum sql_str：" + sql);
			
		}
		return row;
	}

	public void connclose() {
		try {
			if (sm != null) {
				sm.close();
			}
			if (conn != null) {
				conn.close();
			}

			if (sm2 != null) {
				sm2.close();
			}
			if (conn2 != null) {
				conn2.close();
			}
		} catch (Exception cone) {
			System.err.println((new StringBuilder("sm err")).append(
					cone.getMessage()).toString());
		}
	}

	public void close() {
		try {
			if (sm != null) {
				sm.close();
			}
			if (conn != null) {
				conn.close();
			}

			if (sm2 != null) {
				sm2.close();
			}
			if (conn2 != null) {
				conn2.close();
			}
		} catch (Exception cone) {
			System.err.println((new StringBuilder("gsm close err")).append(
					cone.getMessage()).toString());
		}
	}
	
	
	/*
     * 将rs结果转换成对象列表
     * @param rs jdbc结果集
     * @param clazz 对象的映射类
     * return 封装了对象的结果列表
     * zk
     */
	public static List populate(ResultSet rs , Class clazz) throws SQLException, InstantiationException, IllegalAccessException{
        //结果集的元素对象 
        ResultSetMetaData rsmd = rs.getMetaData();
        //获取结果集的元素个数
         int colCount = rsmd.getColumnCount();
         //返回结果的列表集合
         List list = new ArrayList();
         //业务对象的属性数组
         Field[] fields = clazz.getDeclaredFields();
         while(rs.next()){//对每一条记录进行操作
             Object obj = clazz.newInstance();//构造业务对象实体
             //将每一个字段取出进行赋值
             for(int i = 1;i<=colCount;i++){
                 Object value = rs.getObject(i);
                 //寻找该列对应的对象属性
                 for(int j=0;j<fields.length;j++){
                     Field f = fields[j];
                     //如果匹配进行赋值
                     if(f.getName().equalsIgnoreCase(rsmd.getColumnName(i))){
                         boolean flag = f.isAccessible();
                         f.setAccessible(true);
                         f.set(obj, value);
                         f.setAccessible(flag);
                     }
                 }
             }
             list.add(obj);
         }
        return list;
    }
}
