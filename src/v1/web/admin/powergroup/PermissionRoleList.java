package v1.web.admin.powergroup;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import service.dao.db.Jdbc;
import service.dao.db.Page;
import service.sys.Atm;
import service.sys.ErrMsg;
import v1.haocheok.commom.entity.InfoEntity;
 

/**
 * 
 * @author wangxudong
 * @date 2017-7-25
 * @file_name Jurisdiction.java
 * @Remarks  类说明 系统管理-权限角色-列表-数据接口  
 */
public class PermissionRoleList {
	
		public void permissionRoleList(HttpServletRequest request, HttpServletResponse response,InfoEntity info,String Token,String UUID,String USERID,String DID,String Mdels,String NetMode,String ChannelId,String RequestJson,String ip,String GPS,String GPSLocal,String AppKeyType,long TimeStart) throws ServletException, IOException {

			String classname="类说明 系统管理-权限角色-列表-数据接口 【wang】";
			String claspath=this.getClass().getName();
			
			Jdbc db = new Jdbc();
			Page page = new Page();
			
			response.setContentType("text/html;charset=UTF-8");
			request.setCharacterEncoding("UTF-8");
			response.setCharacterEncoding("UTF-8");
		
	    	PrintWriter out = response.getWriter();
			
	    	JSONObject json = new JSONObject();
  	    
	  	    int pag=0;
	  	    //解析json
	  	    System.out.println("RequestJson==="+RequestJson);
	  	    try{//解析开始
				JSONArray arr = JSONArray.fromObject("[" + RequestJson + "]");
				for (int i = 0; i < arr.size(); i++) {
					JSONObject obj = arr.getJSONObject(i);
					pag = Integer.parseInt(obj.get("page")+"");//页数
				}
			} catch (Exception e) {
				ErrMsg.falseErrMsg(request, response, "500", "json格式解析异常");
				Page.colseDOP(db, out, page);
				return;
			}
  	    
	  	    
			//查询语句
			System.out.println("pag=="+pag);
			String sql="SELECT  "+
							"CONCAT("+
							"'<tr>',CHAR(13), "+
							"'    <td>',NAME,'</td>',CHAR(13), "+
							"'    <td>',rolecode,'</td>',CHAR(13), "+
							"'    <td>',IF(available=1,'可用','不可用'),'</td>',CHAR(13), "+
							"'    <td>', "+
							"	CASE  "+
							"	WHEN TYPE=0 THEN 'pc端'  "+
							"	WHEN TYPE=1 THEN '手机端' "+
							"	ELSE '全部' "+
							"END,    "+
							"'    </td>',CHAR(13), "+
							"'    <td>',CHAR(13), "+
							"'          <span title=\"修改权限\" class=\"handle-btn handle-btn-edit\"><i class=\"linyer icon-edit\"></i></span>',CHAR(13), "+
							"'    </td>',CHAR(13), "+
							"'</tr>',CHAR(13) "+
							") AS shtml "+
			
//			"NAME,rolecode,available "+
					"FROM zk_role limit "+(pag-1)*10+",10 ;";
			System.out.println("系统管理-权限角色-列表-数据接口 ==="+sql);
			ResultSet rs = db.executeQuery(sql);
			
			JSONObject jsontabe = new JSONObject();
			ArrayList<String> list = new  ArrayList<String>();
			
			try {
				list.clear();
				while(rs.next()){
//					jsontabe.put("NAME",rs.getString("NAME"));
//					jsontabe.put("rolecode",rs.getString("rolecode"));
//					jsontabe.put("available",rs.getString("available"));
//					list.add(jsontabe.toString());
					list.add(rs.getString("shtml"));
				}if(rs!=null){rs.close();}
			} catch (SQLException e) {
				
				json.put("success", true);
				json.put("resultCode", "500");
				json.put("msg", "哎呀，出错了！");
				json.put("list", list.toString().replaceAll(", <","<").replaceAll("\\[", "").replaceAll("\\]", ""));
//				json.put("list", list);
				out.println(json);
			    Atm.LogSys("系统错误", classname+"模块系统出错","错误信息详见 "+claspath, "1",USERID, ip);
			    Page.colseDOP(db, out, page);
			    return;
			}
			
			if(list.size()>=1){
				json.put("success", true);
				json.put("resultCode", "1000");
				json.put("msg", "请求成功");
				json.put("list", list.toString().replaceAll(", <","<").replaceAll("\\[", "").replaceAll("\\]", ""));
//				json.put("list", list);
			}else{
				json.put("success", true);
				json.put("resultCode", "1000");
				json.put("msg", "没有更多了");
				json.put("list", list.toString().replaceAll(", <","<").replaceAll("\\[", "").replaceAll("\\]", ""));
//				json.put("list", list);
			}
			out.println(json);
			Page.colseDOP(db, out, page);
	}
}
