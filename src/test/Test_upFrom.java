package test;


import java.io.IOException;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import service.dao.db.Jdbc;
import service.dao.db.Page;
import service.sys.ErrMsg;
import v1.haocheok.commom.entity.InfoEntity;

/**
 * 
 * @author Administrator
 * @date 2017-8-9
 * @file_name Test_upFrom.java
 * @Remarks   测试 动态关联表单模版表
 */
public class Test_upFrom {
	
	public void test_upFrom(HttpServletRequest request, HttpServletResponse response,String RequestJson,InfoEntity info) throws ServletException, IOException {
		
		Jdbc db = new Jdbc();
		Page page = new Page();
		
		response.setContentType("text/html;charset=UTF-8");
		request.setCharacterEncoding("UTF-8");
		response.setCharacterEncoding("UTF-8");
		
		String from_name="";
		try { // 解析开始
			   JSONArray arr = JSONArray.fromObject("[" + RequestJson + "]");
			   for(int i = 0; i < arr.size(); i++){
				   JSONObject obj = arr.getJSONObject(i);
				   from_name = obj.get("from_name") + "";//表名
				   System.out.println("from_name=="+from_name);
			   }
		   }catch(Exception e){
			   ErrMsg.falseErrMsg(request, response, "500", "json格式解析异常");
			   return;
		   }
		   from_name="f_personnel";//表单名字
		 String up_sql="";
		
		String select_from="SELECT " +
								"(SELECT id FROM form_name WHERE datafrom='"+from_name+"') fid ," +
								"column_name, " +
								"column_comment, " +
								"data_type  " +
							"FROM INFORMATION_SCHEMA.Columns  " +
							"WHERE table_name='"+from_name+"' ;";
		
		System.out.println("select_from=="+select_from);
		ResultSet rs=db.executeQuery(select_from);
		ArrayList<String> list = new ArrayList<String> ();
		try {
			list.clone();
			while(rs.next()){
				String fid=rs.getString("fid");//取出一条  
				String column_name=rs.getString("column_name");  //字段名
				String column_comment=rs.getString("column_comment");//字段备注
				String data_type=rs.getString("data_type");     //字段类型
//				System.out.println("---------------");
//				System.out.println(column_name);
				System.out.println(!column_name.equals("id")&& !column_name.equals("createtime") && !column_name.equals("createid")&& !column_name.equals("updatetime") && !column_name.equals("updateid") && !column_name.equals("jsontemplate"));
//				System.out.println(column_name!="id");
//				System.out.println("---------------");
				if(
						!column_name.equals("id")&& 
						!column_name.equals("createtime")&& 
						!column_name.equals("createid")&&
						!column_name.equals("updatetime")&& 
						!column_name.equals("updateid")&& 
						!column_name.equals("jsontemplate")
				){
					
					System.out.println(column_name);
					/** 
					  int      {4 单选  判断是否存在 （select） 性别 }  [{"option":"0","option_value":"男"},{"option":"1","option_value":"女"}]
                               {8 数字框 判断是否存在（num）}
                      decimal   8 数字框
                      
                      varchar   
                      		{1 txt 单行文本}
                      		{8 数字框 判断是否存在 （数字）}  
                      		{ 3  （下拉菜单） 判断是否存在 （下拉菜单） } [{"option":"0","option_value":"否"},[{"option":"1","option_value":"是"}]
                      		{ 12 图片上传 判断是否包含（图片）或者 （image）}
                      		{ 2 判断是否包含（多行文本）}
                      datetime  10 时间
                      date      9 日期
                      text      2  多行文本
					*/
					
					if("int".endsWith(data_type)){
							if(column_comment.indexOf("（select）")!=-1 && column_comment.indexOf("性别")!=-1 ){
								up_sql="(" +
											"'4', " +
											"'"+fid+"', " +
											"(SELECT ftypename FROM form_type WHERE cid='4'), " +
											"(SELECT ftypename_en FROM  form_type  WHERE cid='4'), " +
											"'"+column_comment+"', " +
											"'"+column_comment+"', " +
											"'', " +
											"'1', " +
											"'[{\"option\":\"0\",\"option_value\":\"男\"},{\"option\":\"1\",\"option_value\":\"女\"}]', " +
											"'1', " +
											"'30', " +
											"'1', " +
											"'3', " +
											"'0', " +
											"'"+column_name+"', " +
											"'"+data_type+"')";
							}else if(column_comment.indexOf("（num）")!=-1 ){
								up_sql="(" +
											"'8', " +
											"'"+fid+"', " +
											"(SELECT ftypename FROM form_type WHERE cid='8'), " +
											"(SELECT ftypename_en FROM  form_type  WHERE cid='8'), " +
											"'"+column_comment+"', " +
											"'"+column_comment+"', " +
											"'', " +
											"'1', " +
											"'', " +
											"'1', " +
											"'30', " +
											"'1', " +
											"'3', " +
											"'0', " +
											"'"+column_name+"', " +
											"'"+data_type+"')";
							}else {
								up_sql="(" +
											"'8', " +
											"'"+fid+"', " +
											"(SELECT ftypename FROM form_type WHERE cid='8'), " +
											"(SELECT ftypename_en FROM  form_type  WHERE cid='8'), " +
											"'"+column_comment+"', " +
											"'"+column_comment+"', " +
											"'', " +
											"'1', " +
											"'', " +
											"'1', " +
											"'30', " +
											"'1', " +
											"'3', " +
											"'0', " +
											"'"+column_name+"', " +
											"'"+data_type+"')";
							}
					}else if("decimal".endsWith(data_type)){
								up_sql="(" +
											"'8', " +
											"'"+fid+"', " +
											"(SELECT ftypename FROM form_type WHERE cid='8'), " +
											"(SELECT ftypename_en FROM  form_type  WHERE cid='8'), " +
											"'"+column_comment+"', " +
											"'"+column_comment+"', " +
											"'', " +
											"'1', " +
											"'', " +
											"'1', " +
											"'30', " +
											"'1', " +
											"'3', " +
											"'0', " +
											"'"+column_name+"', " +
											"'"+data_type+"')";
							
					}else if("varchar".endsWith(data_type)){
						if(column_comment.indexOf("（数字）")!=-1 ){
								up_sql="(" +
											"'8', " +
											"'"+fid+"', " +
											"(SELECT ftypename FROM form_type WHERE cid='8'), " +
											"(SELECT ftypename_en FROM  form_type  WHERE cid='8'), " +
											"'"+column_comment+"', " +
											"'"+column_comment+"', " +
											"'', " +
											"'1', " +
											"'', " +
											"'1', " +
											"'30', " +
											"'1', " +
											"'3', " +
											"'0', " +
											"'"+column_name+"', " +
											"'"+data_type+"')";
							
						}else if(column_comment.indexOf("（下拉菜单）")!=-1){
								up_sql="(" +
											"'3', " +
											"'"+fid+"', " +
											"(SELECT ftypename FROM form_type WHERE cid='3'), " +
											"(SELECT ftypename_en FROM  form_type  WHERE cid='3'), " +
											"'"+column_comment+"', " +
											"'"+column_comment+"', " +
											"'', " +
											"'1', " +
											"'[{\"option\":\"0\",\"option_value\":\"否\"},{\"option\":\"1\",\"option_value\":\"是\"}]', " +
											"'1', " +
											"'30', " +
											"'1', " +
											"'3', " +
											"'0', " +
											"'"+column_name+"', " +
											"'"+data_type+"')";	
						}else if(column_comment.indexOf("（图片）")!=-1 && column_comment.indexOf("（image）")!=-1){
							
								up_sql="(" +
											"'12', " +
											"'"+fid+"', " +
											"(SELECT ftypename FROM form_type WHERE cid='12'), " +
											"(SELECT ftypename_en FROM  form_type  WHERE cid='12'), " +
											"'"+column_comment+"', " +
											"'"+column_comment+"', " +
											"'', " +
											"'1', " +
											"'', " +
											"'1', " +
											"'30', " +
											"'1', " +
											"'3', " +
											"'0', " +
											"'"+column_name+"', " +
											"'"+data_type+"')";
							
						}else if(column_comment.indexOf("（多行文本）")!=-1){
								up_sql="(" +
											"'2', " +
											"'"+fid+"', " +
											"(SELECT ftypename FROM form_type WHERE cid='2'), " +
											"(SELECT ftypename_en FROM  form_type  WHERE cid='2'), " +
											"'"+column_comment+"', " +
											"'"+column_comment+"', " +
											"'', " +
											"'1', " +
											"'', " +
											"'1', " +
											"'30', " +
											"'1', " +
											"'3', " +
											"'0', " +
											"'"+column_name+"', " +
											"'"+data_type+"')";
						}else {
								up_sql="(" +
											"'1', " +
											"'"+fid+"', " +
											"(SELECT ftypename FROM form_type WHERE cid='1'), " +
											"(SELECT ftypename_en FROM  form_type  WHERE cid='1'), " +
											"'"+column_comment+"', " +
											"'"+column_comment+"', " +
											"'', " +
											"'1', " +
											"'', " +
											"'1', " +
											"'30', " +
											"'1', " +
											"'3', " +
											"'0', " +
											"'"+column_name+"', " +
											"'"+data_type+"')";
						}
					}else if("datetime".endsWith(data_type)){
								up_sql="(" +
											"'10', " +
											"'"+fid+"', " +
											"(SELECT ftypename FROM form_type WHERE cid='10'), " +
											"(SELECT ftypename_en FROM  form_type  WHERE cid='10'), " +
											"'"+column_comment+"', " +
											"'"+column_comment+"', " +
											"'', " +
											"'1', " +
											"'', " +
											"'1', " +
											"'30', " +
											"'1', " +
											"'3', " +
											"'0', " +
											"'"+column_name+"', " +
											"'"+data_type+"')";							
					}else if("date".endsWith(data_type)){
								up_sql="(" +
											"'9', " +
											"'"+fid+"', " +
											"(SELECT ftypename FROM form_type WHERE cid='9'), " +
											"(SELECT ftypename_en FROM  form_type  WHERE cid='9'), " +
											"'"+column_comment+"', " +
											"'"+column_comment+"', " +
											"'', " +
											"'1', " +
											"'', " +
											"'1', " +
											"'30', " +
											"'1', " +
											"'3', " +
											"'0', " +
											"'"+column_name+"', " +
											"'"+data_type+"')";							
					}else if("text".endsWith(data_type)){
								up_sql="(" +
											"'2', " +
											"'"+fid+"', " +
											"(SELECT ftypename FROM form_type WHERE cid='2'), " +
											"(SELECT ftypename_en FROM  form_type  WHERE cid='2'), " +
											"'"+column_comment+"', " +
											"'"+column_comment+"', " +
											"'', " +
											"'1', " +
											"'', " +
											"'1', " +
											"'30', " +
											"'1', " +
											"'3', " +
											"'0', " +
											"'"+column_name+"', " +
											"'"+data_type+"')";							
					}
					
					list.add(up_sql);
				}
			}if(rs!=null){rs.close();}
		} catch (SQLException e) {
			e.printStackTrace();
			 ErrMsg.falseErrMsg(request, response, "500", "查询 "+from_name+"表 数据  异常");
			 return;
		}
		
		System.out.println(list.toString().replaceAll("\\[","").replaceAll("\\]",""));
//		out.println(list.toString().replaceAll("\\[","").replaceAll("\\]",""));
	Page.colseDP(db, page);
	}
	
	public static boolean isChineseChar(String str){     
		boolean temp = false;       
		Pattern p=Pattern.compile("[\u4e00-\u9fa5]");        
		Matcher m=p.matcher(str);        
		if(m.find()){
			temp =  true;        
		}        
		return temp;    
	}
	
	public static void main(String[] args) {
		System.out.println(isChineseChar("az"));
	}
}
