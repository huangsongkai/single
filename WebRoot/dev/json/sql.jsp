<%@ page trimDirectiveWhitespaces="true"%>
<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@ page import="java.util.*"%>
<%@ page language="java" import="java.util.regex.*"%>
<title>SQL生成器</title>
<%
	String bianliang = request.getParameter("bianliang");
	String biaoming = request.getParameter("biaoming");
	String ac = request.getParameter("ac");
	if (biaoming == null) {
		biaoming = "【表名】";
	}
	if (bianliang == null) {
		bianliang = "";
	}
	if (ac == null) {
		ac = "";
	}
	bianliang=bianliang.replaceAll("%","").replaceAll("<\\/?[^>]+>","");
	biaoming=biaoming.replaceAll("%","").replaceAll("<\\/?[^>]+>","");
	ac=ac.replaceAll("%","").replaceAll("<\\/?[^>]+>","");
%>
<form action="" method="post">
	<div align="center">

		<table width="90%" border="0" align="center" cellpadding="0"
			cellspacing="0" bgcolor="#CCCCCC">
			<tr>
				<td>
					请运行sql查找您需要的字段：
					<br>
					select COLUMN_NAME,column_comment from INFORMATION_SCHEMA.Columns
					where table_name='<%=biaoming%>' and table_schema='数据库名'
				</td>
			</tr>
		</table>
		<br>
		<p>
			<textarea name="bianliang" cols="50" rows="30"><% if (bianliang != null) { out.print(bianliang); }%></textarea>
			</br>
			表名：
			<input name="biaoming" type="text" value="<%if (biaoming != null) { out.print(biaoming);}%>" onkeyup="value=value.replace(/\s/gi,'')" />

		</p>
		<p>
			生成类型
			<label>
				<select name="ac" id="select">
					<option value="SC"
						<%if ("SC".equals(ac)) {
				out.print(" selected=\"selected\"");
			}%>>
						String 程序
					</option>
					<option value="SCprint"
						<%if ("SCprint".equals(ac)) {
				out.print(" selected=\"selected\"");
			}%>>
						String -out.print程序
					</option>
					<option value="yc"
						<%if ("yc".equals(ac)) {
				out.print(" selected=\"selected\"");
			}%>>
						隐藏input
					</option>
					<option value="sqlup"
						<%if ("sqlup".equals(ac)) {
				out.print(" selected=\"selected\"");
			}%>>
						更新SQL语句
					</option>
					<option value="sqladd"
						<%if ("sqladd".equals(ac)) {
				out.print(" selected=\"selected\"");
			}%>>
						添加SQL语句
					</option>
				</select>
			</label>
		</p>
		<p>
			<label>
				<input type="submit" name="button" id="button" value="生成程序">
			</label>
		</p>
		<p>
			&nbsp;
		</p>
		<p>
			&nbsp;
		</p>
	</div>
</form>


<%
	if (ac != null && ac.equals("SC")) {
		int count = 0;
		String[] list = bianliang.split("\r\n");
		for (int i = 0; i < list.length; i++) {
			count = count + 1;

			if (list[i].length() > 1) {
				out.print("String " + list[i].trim() + "=request.getParameter(\"" + list[i].trim() + "\");");
				out.print("<br>");
			}

		}
		out.print("<hr>一共生成了" + count + " 个String"); //-------------string 

	}
%>


<%
	if (ac != null && ac.equals("SCprint")) {
		int count = 0;
		String[] list = bianliang.split("\r\n");
		for (int i = 0; i < list.length; i++) {
			count = count + 1;

			if (list[i].length() > 1) {

				out.print("out.print(\"" + list[i].trim() + "=\"+" + list[i].trim() + "+\"&lt;br&gt\");<br>");

			}

		}
		out.print("<hr>一共生成了" + count + " 个String-print"); //-------------string 

	}
%>

<%
	if (ac != null && ac.equals("yc")) {
		int count = 0;
		String[] list = bianliang.split("\r\n");
		for (int i = 0; i < list.length; i++) {
			count = count + 1;

			if (list[i].length() > 1) {
				//out.print("String "+list[i].trim()+"=request.getParameter(\""+list[i].trim()+"\");");
				out.print("&lt;input type=\"hidden\" name=\"" + list[i].trim() + "\" id=\"daikuan\" value=\"&lt;%=" + list[i].trim() + "%&gt;\">");
				out.print("<br>");
			}

		}
		out.print("<hr>一共生成了" + count + " 个String"); //-------------string 
		 
	}
%>


<%
	if (ac != null && ac.equals("sqlup")) {
		out.print(getupSql(bianliang, biaoming)); //调用更新方法
	}

	if (ac != null && ac.equals("sqladd")) {
		out.print(getaddSql(bianliang, biaoming)); //调用添加方法
	}
%>
<%!public static String getupSql(String Fieldes, String TableNname) { //拼接SQL更新语句
		String strSql = "";//组装SQl
		Fieldes = Fieldes.replaceAll(" ", "").trim();
		try {
			List<String> listSql = java.util.Arrays.asList(Fieldes.split("\r\n"));
			List<String> listSqlstr = new ArrayList<String>();
			List<String> listSqlstrrn = new ArrayList<String>();
			for (int i = 0; i < listSql.size(); i++) {
				listSqlstr.add("`" + listSql.get(i) + "`='\"+" + listSql.get(i) + "+\"'");
				listSqlstrrn.add("&nbsp;&nbsp;&nbsp;&nbsp;+\"`" + listSql.get(i) + "`='\"+" + listSql.get(i) + "+\"'"); //换行格式
			}
			strSql = "添加语句生成一行格式如下<hr>";
			strSql = strSql + "UPDATE `" + TableNname + "`  SET " + listSqlstr.toString().replaceAll("\\[", "").replaceAll("\\]", "");
			strSql = strSql + " where  【该语句没有条件慎重哦！！！，错误运行数据丢了后悔没有商量】;";
			strSql = strSql + "<hr>换多行格式如下：<hr>";
			strSql = strSql + "String sqlString=\"UPDATE `" + TableNname + "` \"<br> &nbsp;&nbsp;+\"SET\"<br>" + listSqlstrrn.toString().replaceAll("\\[", "").replaceAll("\\]", "\"").replaceAll(",", ",\"<br>")+"  <br>&nbsp;&nbsp;+\" WHERE \" <br>&nbsp;&nbsp;&nbsp;&nbsp;+\"id=注意条件判断小心 \";";
			strSql = strSql + "<hr>一共生成了" + listSql.size() + " 个要添加的字段";

		} catch (Exception e) {
			strSql = ("组装UPDATE SQL失败！失败详情---" + e);
		}
		return strSql;
	}%>
	
	
	 

<%!public static String getaddSql(String Fieldes, String TableNname) { //拼接SQL更新语句
		String strSql = "";//组装SQl
		Fieldes = Fieldes.replaceAll(" ", "").trim();
		try {
			List<String> listSql = java.util.Arrays.asList(Fieldes.split("\r\n"));
			List<String> listSqlField = new ArrayList<String>(); //字段
			List<String> listSqlValue = new ArrayList<String>(); //字段值
			List<String> listSqlFieldrn = new ArrayList<String>(); //字段
			List<String> listSqlValuern = new ArrayList<String>(); //字段值
			for (int i = 0; i < listSql.size(); i++) {
				listSqlField.add("`" + listSql.get(i) + "`");
				listSqlValue.add("'\"+" + listSql.get(i) + "+\"'");
				
				listSqlFieldrn.add("<br>&nbsp;&nbsp;&nbsp;&nbsp;+\"`" + listSql.get(i) + "`\"");   //换行格式
				listSqlValuern.add("<br>&nbsp;&nbsp;&nbsp;&nbsp;+\"'\"+" + listSql.get(i) + "+\"'\"");//换行格式
			}
			String addField=listSqlField.toString().replaceAll("\\[", "(").replaceAll("\\]", ")");
			String addFieldValue=listSqlValue.toString().replaceAll("\\[", "(").replaceAll("\\]", ")");
			
			String addFieldrn=listSqlFieldrn.toString().replaceAll("\\[", "(\"").replaceAll("\\]", "<br>+\")").replaceAll("\",",",\"");   //换行格式
			String addFieldValuern=listSqlValuern.toString().replaceAll("\\[", "(\"").replaceAll("\\]", "<br>+\")").replaceAll("\",",",\"");//换行格式
			
			strSql = "添加语句生成一行格式如下<hr>";
			strSql = strSql + "INSERT INTO `" + TableNname + "`"+addField+" VALUES "+addFieldValue+" ;";
			
			strSql = strSql + "<hr>换多行格式如下：<hr>";
			strSql = strSql + "String sqlString=\"INSERT INTO `" + TableNname + "`\"  <br> +\"  "+addFieldrn+"  \"  <br> +\"VALUES\"  <br> +\"  "+addFieldValuern+" ;  \";";
			
			strSql = strSql + "<hr>一共生成了" + listSql.size() + " 个要添加的字段";

		} catch (Exception e) {
			strSql = ("组装adddata SQL失败！失败详情---" + e);// INSERT INTO `test`.`test`(`id`,`name`,`xiaoqu`) VALUES ( NULL,'name','21341234234');
		}
		return strSql;
	}%>

<br>
<br>
<br>
<br>
<br>
