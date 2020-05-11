package v1.haocheok.file;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import service.dao.db.Jdbc;
import service.dao.db.Page;
import service.sys.Atm;
import v1.haocheok.commom.entity.InfoEntity;

/**
 * 
 * @author Administrator
 * @date   2017-8-8
 * @file_name DeleteAttachment.java
 * @Remarks   手机端-删除附件
 */
public class DeleteAttachment {

	@SuppressWarnings("unchecked")
	public void deleteAttachment(HttpServletRequest request, HttpServletResponse response, String RequestJson, InfoEntity info) throws ServletException, IOException {

		response.setContentType("text/html;charset=UTF-8");
		request.setCharacterEncoding("UTF-8");
		response.setCharacterEncoding("UTF-8");
		
		// 获取资源
		Jdbc db = new Jdbc();
		Page page = new Page();
		long TimeStart = new Date().getTime();// 程序开始时间，统计效率
		PrintWriter out = response.getWriter();
		
		String claspath = this.getClass().getName();// 当前类名
		String classname = "手机端-删除附件";

		JSONObject json = new JSONObject();
		ArrayList<String> list = new ArrayList<String> ();//附件id 组合
		
		ArrayList<String> delete_list = new ArrayList<String> ();//删除的附件id 组合
		ArrayList<String> existence = new ArrayList<String> ();//原有的附件id 组合
		
		
		String str_img="";//去除删除附件后的字符串；
		
		JSONObject obj_delect = new JSONObject();
		
		String orderid="",fromname="",fromid="";
		try { // 解析开始
			JSONArray arr = JSONArray.fromObject("[" + RequestJson + "]");
			for (int i = 0; i < arr.size(); i++) {
				JSONObject obj = arr.getJSONObject(i);
				list.addAll(obj.getJSONArray("enclosureid"));
			}
		} catch (Exception e) {
			e.printStackTrace();
			json.put("success", "ture");
			json.put("resultCode", "500");
			json.put("msg", "json解析异常！  "+RequestJson);
			out.print(json);
			long ExeTime = Calendar.getInstance().getTimeInMillis()-TimeStart;// 记录执行日志
			Atm.AppuseLong(info, claspath, classname, "删除附件失败  json解析异常！  "+RequestJson, json.toString(), ExeTime);// 记录执行日志
			Atm.LogSys(info.getAppKeyType(), "用户APP端附件删除操作", "删除附件失败  json解析异常！  "+RequestJson,"1", info.getUSERID(), info.getIp());//添加操作日志
			Page.colseDOP(db, out, page);
			return;// 程序关闭
		}
		//查询删除的附件地址
		String select_img="SELECT orderid,fromname,fromid,CONCAT(attachmentpath,'?',attachmentid)AS attachmentpath   FROM  order_attachment  WHERE attachmentid IN ("+list.toString().replaceAll("\\[","").replaceAll("\\]","")+")";
//		System.out.println("select_img=="+select_img);
		ResultSet img_rs =db.executeQuery(select_img);
		try{
			while(img_rs.next()){
				orderid=img_rs.getString("orderid");//订单id
				fromname=img_rs.getString("fromname");//表单表名
				fromid=img_rs.getString("fromid");//表单组件字段名称
				delete_list.add(img_rs.getString("attachmentpath"));
			}if(img_rs!=null){img_rs.close();}
		}catch (SQLException e) {
			e.printStackTrace();
			json.put("success", "ture");
			json.put("resultCode", "500");
			json.put("msg", "删除附件失败！1");
			out.print(json);
			long ExeTime = Calendar.getInstance().getTimeInMillis()-TimeStart;// 记录执行日志
			Atm.AppuseLong(info, claspath, classname, "删除附件失败", json.toString(), ExeTime);// 记录执行日志
			Atm.LogSys(info.getAppKeyType(), "用户APP端附件删除操作", "删除附件操作者"+info.getUSERID()+" 查询附件信息失败","1", info.getUSERID(), info.getIp());//添加操作日志
			Page.colseDOP(db, out, page);
			return;// 程序关闭
		}
		//查询表单表 
		String select_f_from="SELECT "+fromid+" as control,jsontemplate FROM "+fromname+" WHERE  orderid='"+orderid+"' ";
		ResultSet f_from =db.executeQuery(select_f_from);
		try{
			while(f_from.next()){
				String f_image[]= f_from.getString("control").split("\\#");//附件缓存字段
				for(int i=0;i<f_image.length;i++){
					existence.add(f_image[i]);
				}
				
				try { // 解析开始
					JSONArray arr = JSONArray.fromObject("[" + f_from.getString("jsontemplate") + "]");
					for (int i = 0; i < arr.size(); i++) {
						obj_delect = arr.getJSONObject(i);
						 //直接覆盖原有的值
						str_img=Page.deleteListElement(existence,delete_list).toString().replaceAll("\\[", "").replaceAll("\\]", "").replaceAll(",", "#").replaceAll(" ", "").replaceAll("\\\n","").replaceAll("\\\t","").replaceAll("\\\r","");
//						System.out.println("str_img======"+str_img);
						obj_delect.put(fromid,str_img);
					}
				} catch (Exception e) {
					json.put("success", "true");
					json.put("resultCode", "500");
					json.put("msg", "附件删除失败2");
					out.println(json);
					long ExeTime = Calendar.getInstance().getTimeInMillis()-TimeStart;// 记录执行日志
					Atm.AppuseLong(info, claspath, classname, "删除附件失败 {查询表单表  语句["+f_from.getString("jsontemplate")+"]}", json.toString(), ExeTime);// 记录执行日志
					Atm.LogSys(info.getAppKeyType(), "用户APP端附件删除操作", "删除附件失败 {查询表单表  语句["+f_from.getString("jsontemplate")+"]}","1", info.getUSERID(), info.getIp());//添加操作日志
					Page.colseDOP(db, out, page);
					return;// 程序关闭;
				}
			}if(f_from!=null){f_from.close();}
			
			//更新表单附件相关字段
			String up_from="UPDATE "+fromname+" SET "+fromid+"='"+str_img+"', jsontemplate = '"+obj_delect+"' WHERE orderid='"+orderid+"' ;";
			boolean upstate=db.executeUpdate(up_from);
			
			if(upstate){
				String delect_sql="DELETE FROM order_attachment WHERE attachmentid in ("+list.toString().replaceAll("\\[","").replaceAll("\\]","")+") ;";
				boolean delect_state=db.executeUpdate(delect_sql);
				if(delect_state){
					
					
					json.put("success", "true");
					json.put("resultCode", "1000");
					json.put("imges",str_img );
					json.put("msg", "附件删除成功");
				}else{
					json.put("success", "true");
					json.put("resultCode", "500");
					json.put("msg", "附件删除失败3");
					out.println(json);
					long ExeTime = Calendar.getInstance().getTimeInMillis()-TimeStart;// 记录执行日志
					Atm.AppuseLong(info, claspath, classname, "删除附件失败 {"+delect_sql+"}", json.toString(), ExeTime);// 记录执行日志
					Atm.LogSys(info.getAppKeyType(), "用户APP端附件删除操作", "删除附件操作者"+info.getUSERID()+"删除附件失败 {"+delect_sql+"}","1", info.getUSERID(), info.getIp());//添加操作日志
					Page.colseDOP(db, out, page);
					return;// 程序关闭
				}
			}else{
				json.put("success", "true");
				json.put("resultCode", "500");
				json.put("msg", "附件删除失败4");
				out.println(json);
				long ExeTime = Calendar.getInstance().getTimeInMillis()-TimeStart;// 记录执行日志
				Atm.AppuseLong(info, claspath, classname, "删除附件失败 {更新表单附件相关字段  语句["+up_from+"]}", json.toString(), ExeTime);// 记录执行日志
				Atm.LogSys(info.getAppKeyType(), "用户APP端附件删除操作", "删除附件操作者"+info.getUSERID()+"删除附件失败 {更新表单附件相关字段  语句["+up_from+"]}","1", info.getUSERID(), info.getIp());//添加操作日志
				Page.colseDOP(db, out, page);
				return;// 程序关闭
			}
		}catch (SQLException e) {
			e.printStackTrace();
			json.put("success", "ture");
			json.put("resultCode", "500");
			json.put("msg", "删除附件失败！5");
			out.print(json);
			long ExeTime = Calendar.getInstance().getTimeInMillis()-TimeStart;// 记录执行日志
			Atm.AppuseLong(info, claspath, classname, "删除附件失败", json.toString(), ExeTime);// 记录执行日志
			Atm.LogSys(info.getAppKeyType(), "用户APP端附件删除操作", "删除附件操作者"+info.getUSERID()+" 查询附件信息失败","1", info.getUSERID(), info.getIp());//添加操作日志
			Page.colseDOP(db, out, page);
			return;// 程序关闭
		}
		out.println(json);
		
//		System.out.println("-------+");
//		System.out.println(json);
//		System.out.println("-------+");
		
		
		long ExeTime = Calendar.getInstance().getTimeInMillis()-TimeStart;// 记录执行日志
		Atm.AppuseLong(info, claspath, classname, "删除附件成功", json.toString(), ExeTime);// 记录执行日志
		Atm.LogSys(info.getAppKeyType(), "用户APP端附件删除操作", "删除附件操作者"+info.getUSERID()+"删除附件成功","1", info.getUSERID(), info.getIp());//添加操作日志
		Page.colseDOP(db, out, page);
	}
}
