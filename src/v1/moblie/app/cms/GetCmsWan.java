package v1.moblie.app.cms;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Calendar;
import java.util.List;

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
 * @author 李高颂
 * @version 创建时间：2018-4-1 01:17:54
 * @category 获取学校老网站db_new表的数据。 @ （外网：GetCmsWan ） （内网： GetCmsLan）
 */

public class GetCmsWan {

	public void process(HttpServletRequest request, HttpServletResponse response, InfoEntity info, String theClassName) throws ServletException, IOException {

		Jdbc db = new Jdbc();
		Page page = new Page();

		response.setContentType("text/html;charset=UTF-8");
		request.setCharacterEncoding("UTF-8");
		response.setCharacterEncoding("UTF-8");

		PrintWriter out = response.getWriter();

		String responsejson = ""; // 读取分类配置文件
		String webstateurl = "";
		String lanip = "";
		String lanipduan = "";
		String formip = info.getIp();
		String c = "";
		String pid = "";
		String m = "";
		String pages = "";

		try { // 解析开始
			JSONArray arr = JSONArray.fromObject("[" + info.getRequestJson() + "]");
			for (int i = 0; i < arr.size(); i++) {
				JSONObject obj = arr.getJSONObject(i);
				c = obj.get("c") + "";
				m = obj.get("m") + "";
				pid = obj.get("pid") + "";
				pages = obj.get("page") + "";

			}
		} catch (Exception e) {
			ErrMsg.falseErrMsg(request, response, "500", "json格式异常");
			Page.colseDOP(db, out, page);
			return;

		}

		if (m == null || "null".equals(m)) {
			m = "";
		}
		if (c == null || "null".equals(m)) {
			c = "";
		}
		if (pages == null || "null".equals(pages)) {
			pages = "1";
		}

		if (pid == null || "null".equals(pid)) {
			pid = "";
		} // 解析结束

		if (m.length() < 1) {
			ErrMsg.falseErrMsg(request, response, "403", "未知模块请求-1");
			Page.colseDOP(db, out, page);
			return;
		}

		// 外网新闻请求userid和token不需要任何限制
		System.out.println("c=" + c);
		System.out.println("m=" + m);
		System.out.println("page=" + pages);
		System.out.println("pid=" + pid);

		// 取出配置文件
		try {
			ResultSet Rs = null;

			Rs = db.executeQuery("SELECT  config_value  FROM  sys_config  WHERE id='3'; ");// 得到配置json
			if (Rs.next()) {

				responsejson = Rs.getString("config_value");
			}

			Rs = db.executeQuery("SELECT  config_value  FROM  sys_config  WHERE id='2';"); // 内网IP特征
			if (Rs.next()) {
				lanipduan = Rs.getString("config_value");
			}

			Rs = db.executeQuery("SELECT  config_value  FROM  sys_config  WHERE id='4';"); // 找外部网址
			if (Rs.next()) {
				webstateurl = Rs.getString("config_value");
			}
			if (Rs != null) {
				Rs.close();
			}

			Rs = db.executeQuery("SELECT  config_value  FROM  sys_config  WHERE id='5';"); // 找内部网址
			if (Rs.next()) {
				lanip = Rs.getString("config_value");
			}
			if (Rs != null) {
				Rs.close();
			}

			// 判断是否是内网
			List <String>  ipList=java.util.Arrays.asList(lanipduan.split(","));
			 if(page.IPMatch(ipList,formip) == true){
				 webstateurl = lanip; //如果是内网就给内部网址
			 }
		 
	 
			 System.err.println("GET ip:"+info.getIp());
			 System.err.println("ip is LAN="+page.IPMatch(ipList,formip));
			 System.err.println("webstateurl="+webstateurl);

		} catch (Exception e) {
			ErrMsg.falseErrMsg(request, response, "500", " SQL错误见模块" + this.getClass() + "");
			Page.colseDOP(db, out, page);
			return; 
		}
		/**
		 * 开始业务逻辑分析
		 */
		// 取出文章分类
		if ("app".equals(c) && "articleclass".equals(m)) {
			
			out.print(responsejson);
		}

		// 取出文章banner 最新5张
		else if ("app".equals(c) && "banner".equals(m)) {
			theClassName="手机获取最新首页5张top图";
			JSONArray array = new JSONArray();
			ResultSet bannerRs = db.executeQuery("SELECT  id,title,thumb  FROM  db_news  WHERE LENGTH(thumb)>5 ORDER BY id DESC LIMIT 5;;"); // 找内部网址
			try {
				while (bannerRs.next()) {
				 
					JSONObject object = new JSONObject();
					object.put("aid", bannerRs.getString("id"));
					object.put("cid",  bannerRs.getString("title"));
					object.put("thumb",  bannerRs.getString("thumb").replaceAll("172.16.200.4", webstateurl));
					//object.put("url", "http//"+webstateurl+"/hljsfjy/h5/marticle.jsp?id=" + bannerRs.getString("id"));
					object.put("url", "");
                    array.add(object);
				}if (bannerRs != null) {
					bannerRs.close();
				}
			} catch (SQLException e) {
				ErrMsg.falseErrMsg(request, response, "500", " SQL错误见模块" + this.getClass() + "");
				Page.colseDOP(db, out, page);
				e.printStackTrace();
				return; 
				
			}
			
			
			responsejson = "{\"success\":true,\"resultCode\":\"1000\",\"msg\":\"文章TOPbanner接口读取成功\",\"threads\":"+array.toString()+"}";
			out.print(responsejson);
			if(array!=null){array.clear();}
		 
		}

		// 取出文章的分类列表
		else if ("app".equals(c) && "articleslist".equals(m)) {
			theClassName="手机获取文章的分类列表";
			responsejson="";
			String aidString = "", classid = "", title = "", source = "黑司警院", publishedTime = "", thumb = "", url = "", hits = "";

			String PUBSQL = ""; // 定义查询条件
			if (pid.equals("0")) {
				PUBSQL = " "; //查询全部
			}else if(pid.equals("1")){
				PUBSQL = " where  pxid='1' ";
			}
			else if(pid.equals("2")){
				PUBSQL = " where  pxid='2' ";
			}
			else if(pid.equals("3")){
				PUBSQL = " where  pxid='3' ";
			}
			else if(pid.equals("4")){
				PUBSQL = " where  pxid='4' ";
			}
			else if(pid.equals("5")){
				PUBSQL = " where  pxid='5' ";
			}
			else if(pid.equals("6")){
				PUBSQL = " where  pxid='6' ";
			}
			
			else{
				PUBSQL = "";
			}

			// 分页
			int InPages = 0;
			InPages = Integer.parseInt(pages);
			if (InPages == 0) {
				InPages = 1;
			}
			int listnum = 10;
			int Asum = db.Row("SELECT COUNT(*) as row FROM  db_news " + PUBSQL);

			int Zpages = 0;

			if (Asum % listnum == 0) { // 正好是总数的倍数
				Zpages = (Asum / listnum); // 总页数
			} else {
				Zpages = (Asum / listnum) + 1; // 总页数
			}

			// if(pages>Zpages){pages=1;}
			int DQcount = (InPages * listnum) - listnum; // 当前要显示的记录开始目数

			// System.out.println("DQcount="+DQcount);
			if (DQcount < 0) {
				DQcount = 0;
			}

			JSONArray array = new JSONArray();
			String RSSQL = "select id,title,hits, adddate,thumb from db_news " + PUBSQL + " order by adddate desc  limit " + DQcount + ", " + listnum + "";

			System.out.println("RSSQL="+RSSQL);
			try {
				
			ResultSet classrs = db.executeQuery(RSSQL);
                 while (classrs.next()) {

					url = classrs.getString("id");
					title = classrs.getString("title");
					publishedTime = classrs.getString("adddate");
					thumb= classrs.getString("thumb");
					hits = classrs.getString("hits");
					thumb=thumb.replaceAll("172.16.200.4", webstateurl);

					JSONObject object = new JSONObject();
					object.put("aid", url);
					object.put("cid", classid);
					object.put("title", title);
					object.put("source", source);
					object.put("publishedTime", publishedTime);
					object.put("thumb", thumb);
					object.put("hits", hits);
					object.put("url", "");

					array.add(object);

				}if (classrs != null) {
					classrs.close();
				}
			} catch (Exception e) {
				ErrMsg.falseErrMsg(request, response, "500", " SQL错误见模块" + this.getClass() + "");
				Page.colseDOP(db, out, page);
				e.printStackTrace();
				return; 
			}

			
			if (db != null)
				db.close();
			db = null;

			responsejson="{\"success\":true,\"resultCode\":\"1000\",\"pages\":\"" + Zpages + "\",\"page\":\"" + pages + "\",\"msg\":\"文章某分类列表文章接口读取成功\",\"ArticleList\":" + array + "}";
	 		out.print(responsejson);
	 		if(array!=null){array.clear();}
			 
		}
		
		
		// 取出某个id的文章，文章详情
		else if ("app".equals(c) && "shownews".equals(m)) {
			theClassName="手机获得新闻具体内容";
			String content="";
			JSONArray array = new JSONArray();
			ResultSet bannerRs = db.executeQuery("SELECT  *  FROM  db_news  WHERE  id='"+pid+"';"); // 找内部网址
			try {
				if (bannerRs.next()) {
					
					content=bannerRs.getString("content");
					content=content.replaceAll("172.16.200.4", webstateurl);
					content=content.replaceAll("<span([^>]{0,})>", "");
					content=content.replaceAll("</span>", "");
					
					content=content.replaceAll("<td height=\"22\" align=\"left\">", "");
					content=content.replaceAll("<font color=\"#000000\"><p>", "<p>");
					content=content.replaceAll("<table>", "");
					content=content.replaceAll("<td>", "");
					content=content.replaceAll("<tr>", "");
					content=content.replaceAll("</table>", "");
					content=content.replaceAll("</td>", "");
					content=content.replaceAll("</tr>", "");
				 
					JSONObject object = new JSONObject();
					object.put("success",  "success");
					object.put("resultCode", "1000");
					object.put("msg","外网文章具体内容接口读取成功");
					object.put("title",  bannerRs.getString("title"));
					object.put("nclass",  bannerRs.getString("nclass"));
					object.put("content",content);
					object.put("num","0"); //公开序号
					object.put("adddate",bannerRs.getString("adddate"));
					object.put("hits",  bannerRs.getString("hits"));
				
                     array.add(object);
				}if (bannerRs != null) {
					bannerRs.close();
					db.executeUpdate(" UPDATE  `db_news` SET `hits`=hits+1 WHERE `id`='"+pid+"';"); //阅读次数加1
				}
			} catch (SQLException e) {
				ErrMsg.falseErrMsg(request, response, "500", " SQL错误见模块" + this.getClass() + "");
				Page.colseDOP(db, out, page);
				e.printStackTrace();
				return; 
				
			}
			
			
			responsejson =array.toString().replaceAll("\\[", "").replaceAll("\\]", "");
			out.print(responsejson);
			if(array!=null){array.clear();}
		 
		}

		else {
			ErrMsg.falseErrMsg(request, response, "403", "未知模块请求-2");
			Page.colseDOP(db, out, page);
			return;
		}

		// 记录执行日志
		long ExeTime = Calendar.getInstance().getTimeInMillis() - info.getTimeStart();
		Atm.AppuseLong(info, info.getUSERID(), this.getClass().getName(), theClassName, responsejson, ExeTime);
		
		Page.colseDOP(db, out, page);

		out.flush();
		out.close();
	}
}
