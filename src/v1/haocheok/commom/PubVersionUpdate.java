//package v1.haocheok.commom;
//
//import java.io.IOException;
//import java.io.PrintWriter;
//import java.sql.ResultSet;
//import java.sql.SQLException;
//
//import javax.servlet.ServletException;
//import javax.servlet.http.HttpServletRequest;
//import javax.servlet.http.HttpServletResponse;
//
//import net.sf.json.JSONObject;
//import service.dao.db.Jdbc;
//import service.sys.Atm;
//import v1.haocheok.commom.entity.InfoEntity;
//
///**
// * 
// * @ClassName: WangXuDong E-mail: 1503631902@qq.com
// * @version 创建时间： 2016-10-11 下午10:53:40
// * @Description: TODO(app 检查版本更新)
// */
//public class PubVersionUpdate
//	{
//		public void pubVersionUpdate(HttpServletRequest request, HttpServletResponse response,String RequestJson,InfoEntity info)
//		throws ServletException, IOException
//		{ 
//			Jdbc db = new Jdbc();
//			
//			String clasname = "app 检查版本更新";
//			
//			JSONObject json = new JSONObject();
//			
//			
//			String select="SELECT * FROM pw_versionupdate ORDER BY TIME DESC LIMIT 1";
//			ResultSet rs = db.executeQuery(select);
//			
//			try {
//				while(rs.next()){
//					json.put("versionNumber", rs.getString("bid"));//版本id
//					json.put("UpdateContent", rs.getString("updateContent"));//text更新内容
//					json.put("UpUrl", rs.getString("url"));//text更新内容
//				}if(rs!=null)rs.close();
//				out.print(json);
//			}catch (SQLException e) {
//				e.printStackTrace();
//				out.print( return_json.return_json( "500", clasname+"查询版本出错",this.getClass().getName(),clasname,"查询版本出错"+select, "错误所在行:"+OtherSettings.getLineInfo()));
//			}
//			
//			Atm.LogAdd( USERID, UUID, USERID, this.getClass().getName(), clasname, "{请求类型："+apptype+"   返回的json:["+json+"]}",ip );  /* 记录日志 */
//			
//			
//			return;
//		}
//	}

