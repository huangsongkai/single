package v1.web.admin.system.systemFunction;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Calendar;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang3.ArrayUtils;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import service.dao.db.Jdbc;
import service.dao.db.Page;
import service.sys.Atm;
import v1.haocheok.commom.entity.InfoEntity;

/**
 * 
 * @author Administrator
 * @date 2017-8-1
 * @file_name CreateUniversalForms.java
 * @Remarks  创建万能表单 
 */
public class CreateUniversalForms  {

	public void createUniversalForms (HttpServletRequest request, HttpServletResponse response,InfoEntity info,String Token,String UUID,String USERID,String DID,String Mdels,String NetMode,String ChannelId,String RequestJson,String ip,String GPS,String GPSLocal,String AppKeyType,long TimeStart) throws ServletException, IOException{
		
		/**
		 * 1.  创建订单表
		 * 2.  写入表单名称表  form_name
		 * 3.  写入表单模板表  form_template_confg
		 */
		Jdbc db = new Jdbc();
		Page page = new Page();

	    String classname="系统工具-创建万能表单";
        String claspath=this.getClass().getName();
        
		response.setContentType("text/html;charset=UTF-8");
		request.setCharacterEncoding("UTF-8");
		response.setCharacterEncoding("UTF-8");
		
		PrintWriter out = response.getWriter();
		
		
    	JSONObject json = new JSONObject();
		
		//解析表单数据
		
		String fromname="";//表单名（中文）
		String formEnglish="";//表单名（英文）
		JSONArray fieldInfos ;//表单组件
		JSONArray fieldInfo ;//表单组件属性
		
		boolean EstablishStat=false;
		
		ArrayList<String> establish_from = new ArrayList<String> ();
	    
		JSONArray arr = JSONArray.fromObject("[" + RequestJson + "]");
		for (int i = 0; i < arr.size(); i++) {
			JSONObject obj = arr.getJSONObject(i);
			fromname	=obj.getString("fromname");
			formEnglish =obj.getString("formEnglish");
			
			//判断表名是否被存在
			formEnglish="f_"+formEnglish;
			int dbnumber=db.Row("SELECT COUNT(1) FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='"+formEnglish+"';");
			
			if(dbnumber>0){//该表明已经存在  403 资源禁止调用 
				json.put("success",true);
				json.put("resultcode","403");
				json.put("msg","改表名已经存在 ");
				out.println(json);
				
				long ExeTime = Calendar.getInstance().getTimeInMillis()-info.getTimeStart();// 记录执行日志
				Atm.AppuseLong(info, "",  claspath, classname, "", ExeTime);// 记录执行日志
				Atm.LogSys("创建万能表单", "系统后台--创建万能表单", "创建万能表单错误,表单  组件属性不全", "0",USERID, info.getIp());//添加操作日志
				Page.colseDOP(db, out, page);
				return;
			}
			
			fieldInfos = JSONArray.fromObject(obj.getString("fieldInfo"));
			//解析表单 组件
			for (int j = 0; j < fieldInfos.size(); j++) {
				fieldInfo=JSONArray.fromObject(fieldInfos.getJSONObject(i));
				//解析表单组件属性
				for (int f = 0; f < fieldInfo.size(); f++) {
					//判断 表单  组件属性 是否缺失
					if(JSONArray.fromObject(fieldInfo.getJSONObject(f)).size()<9){
						json.put("success",true);
						json.put("resultcode","403");
						json.put("msg","表单  组件属性不全 ");
						out.println(json);
						
						long ExeTime = Calendar.getInstance().getTimeInMillis()-info.getTimeStart();// 记录执行日志
						Atm.AppuseLong(info, "",  claspath, classname, "", ExeTime);// 记录执行日志
						Atm.LogSys("创建万能表单", "系统后台--创建万能表单", "创建万能表单错误,表单  组件属性不全", "0",USERID, info.getIp());//添加操作日志
						Page.colseDOP(db, out, page);
						return;
						
					}else{
						//0 组件类型      (必填) 1 组件名中文 (必填) 2 组件名英文 (必填) 3 必填状态   (必填) 4 组件宽度      (必填) 5 组件高度     (必填) 6 数据类型           (必填) 7 下拉框json   8 提示值
						
						String datatype="";
						if("INT".equals(fieldInfo.getInt(8))){
							datatype="INT(10)";
						}else if("VARCHAR".equals(fieldInfo.getInt(8))){
							datatype="VARCHAR(250)";
						}else{
							datatype=fieldInfo.getInt(8)+"";
						}
						establish_from.add("`"+fieldInfo.getInt(2)+"` "+datatype+"  NOT NULL COMMENT '"+fieldInfo.getInt(1)+"'");//控件名（英文）[0]  + 数据类型     [11]
					}
				}
				//生成创建数据表的sql语句;
				String foundfrom="" +
								"CREATE TABLE "+formEnglish+"( " +
													"`id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '自增id    ["+fromname+"]'," +
													 establish_from.toString()+
													"PRIMARY KEY (`id`) " +
												")" +
								" ENGINE=MYISAM  " +
								" CHECKSUM=1 " +
								" COMMENT='' " +
								" DELAY_KEY_WRITE=1   " +
								" ROW_FORMAT=DYNAMIC " +
								" CHARSET=utf8 " +
								" COLLATE=utf8_bin  ;" ; 
				 EstablishStat = db.executeUpdate(foundfrom);//创建表单数据表
				
			}
			if(EstablishStat){
				
				json.put("success", "true");
				json.put("resultCode", "1000");
				json.put("msg", "接创建表单成功");
				
			}else{
				
				json.put("success", "true");
				json.put("resultCode", "500");
				json.put("msg", "创建表单失败");
				
			}
			
			
			
			

			
		}
		
		
		//创建表单
//		db.executeUpdate("");
		
		
	}
	@SuppressWarnings("null")
	public static void main(String[] args) {
		
		String[] myList = {"a","b","c","d","e"};
		System.out.println(Page.useArrayUtils(myList, "da"));
		
	}

}
