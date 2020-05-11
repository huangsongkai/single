package v1.haocheok.commom;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.Random;

import net.sf.json.JSONArray;

import org.apache.commons.lang.math.IntRange;
import org.apache.commons.lang3.StringUtils;
import org.apache.poi.hssf.record.DBCellRecord;

//import com.fasterxml.jackson.core.util.DefaultPrettyPrinter.Indenter;
//import com.sun.xml.internal.bind.v2.runtime.unmarshaller.XsiNilLoader.Array;

import service.dao.db.Jdbc;
import service.dao.db.Page;

public class commonCourse {

	
	

	/**
	 * @author zhoukai
	 * @category 字符串转换成二维数组
	 * @param str 二维数组的字符串，a 表示二维数组的字符  *，b 表示 一维数组的字符   #
	 * @return  ArrayList<ArrayList<String>>
	 */
	public static ArrayList<ArrayList<String>> toArrayList(String str,String a ,String b){
		ArrayList<ArrayList<String>> textList = new ArrayList<ArrayList<String>>();
		if(str==null || "".equals(str)){
			return textList;
		}
		ArrayList list = new ArrayList(Arrays.asList(str.split(b)));
		for(int i =0; i <list.size(); i++ ){
			textList.add(new ArrayList<String>(Arrays.asList(((String) list.get(i)).split("\\\\"+a))));
		}
		return textList;
	}
	
	
	
	/**
	 * @author zhoukai
	 * @category 二维数组转成字符串转
	 *  二维数组的字符串，a 表示二维数组的字符 * ，b 表示 一维数组的字符  #
	 * @return  ArrayList<ArrayList<String>>
	 */
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
	
	
	/**
	 * 排课使用，获取班级信息
	 * @param classid
	 * @param semester
	 */
	public static HashMap<String, String> getclassInfo(String classid,String semester){
		Jdbc db = new Jdbc();
		Page page = new Page();
		String sql = "select id,timetable from arrange_sys_class where classid='"+classid+"' AND semester = '"+semester+"';";
		ResultSet set = db.executeQuery(sql);
		HashMap<String, String> map = new HashMap<String, String>();
		try {
			if(set.next()){
				map.put("id", set.getString("id"));
				map.put("timetable", set.getString("timetable"));
			}if(set!=null){set.close();}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		page.colseDP(db, page);
		return map;
		
		
		
	}
	
	/**
	 * 排课使用 获取老师信息
	 * @param teacher		老师id
	 * @param semester		学期学号
	 * @return
	 */
	public static HashMap<String, String> getTeacherinfo(String teacher,String semester){
		
		Jdbc db = new Jdbc();
		Page page = new Page();
		String sql = "select id,timetable from arrange_sys_teacher where teacherid='"+teacher+"' AND semester = '"+semester+"';";
		ResultSet set = db.executeQuery(sql);
		HashMap<String, String> map = new HashMap<String, String>();
		try {
			if(set.next()){
				map.put("id", set.getString("id"));
				map.put("timetable", set.getString("timetable"));
			}if(set!=null){set.close();}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		page.colseDP(db, page);
		return map;
	}
	
	
	/**
	 * 获取教室信息
	 * @param classroomid
	 * @param semester
	 * @return
	 */
	public static HashMap<String, String> getClassroomInfo(String classroomid,String semester){
		Jdbc db = new Jdbc();
		Page page = new Page();
		String sql = "select id,timetable from arragne_sys_classroom where classroomid='"+classroomid+"' AND semester = '"+semester+"';";
		ResultSet set = db.executeQuery(sql);
		HashMap<String, String> map = new HashMap<String, String>();
		try {
			if(set.next()){
				map.put("id", set.getString("id"));
				map.put("timetable", set.getString("timetable"));
			}if(set!=null){set.close();}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		page.colseDP(db, page);
		return map;
		
		
	}
	
	
	
	
	/**
	 * 新增 排课班级信息
	 * @param arrage_coursesystem_id
	 * @param classid
	 * @param semester
	 * @param timetable
	 * @return
	 */
	public static boolean insertClassinfo(String classid ,String semester,String timetable){
		Jdbc db = new Jdbc();
		Page page = new Page();
		String sql = "INSERT into arrange_sys_class 		"+
					"	(                            "+
					"	classid,                        "+
					"	semester,                       "+
					"	timetable                       "+
					"	)                               "+
					"	VALUES                          "+
					"	(	                          "+
					"	'"+classid+"',                      "+
					"	'"+semester+"',                     "+
					"	'"+timetable+"'                     "+
					"	);";
		boolean state = db.executeUpdate(sql);
		page.colseDP(db, page);
		return state;
	}
	
	/**
	 *更新班级 排课表 
	 * @param id
	 * @param timetable
	 * @return
	 */
	public static boolean updateClassinfo(String id,String timetable){
		Jdbc db = new Jdbc();
		Page page = new Page();
		String sql =  "UPDATE arrange_sys_class 		"+
		"	SET                             "+
		"	timetable = '"+timetable+"'         "+
		"	WHERE                           "+
		"	id = '"+id+"' ;";
		boolean state = db.executeUpdate(sql);
		page.colseDP(db, page);
		return state;
	}
	/**
	 * 更新班级 排课表 根据classid 与 semester
	 * @param id
	 * @param timetable
	 * @return
	 */
	public static boolean updateClassForid(String classid,String semester,String timetable){
		Jdbc db = new Jdbc();
		Page page = new Page();
		String sql =  "UPDATE arrange_sys_class 		"+
		"	SET                             "+
		"	timetable = '"+timetable+"'         "+
		"	WHERE                           "+
		"	classid = '"+classid+"'	AND semester = '"+semester+"' ;";
		boolean state = db.executeUpdate(sql);
		page.colseDP(db, page);
		return state;
	}
	
	/**
	 * 新增老师 排课表		
	 * @param teaching_task_id		教学安排表id
	 * @param arrage_coursesystem_id
	 * @param teacherid
	 * @param semester
	 * @param timetable
	 * @return
	 */
	public static boolean insertTeacherInfo( String teacherid ,String semester,String timetable){
		Jdbc db = new Jdbc();
		Page page = new Page();
		String sql = "INSERT INTO arrange_sys_teacher 	"+
			"			(                               "+
			"			teacherid,                      "+
			"			semester,                       "+
			"			timetable                       "+
			"			)                               "+
			"			VALUES                          "+
			"			(                               "+
			"			'"+teacherid+"',                    "+
			"			'"+semester+"',                     "+
			"			'"+timetable+"'                     "+
			"			);";
		
		boolean state = db.executeUpdate(sql);
		page.colseDP(db, page);
		return state;
	}
	
	/**
	 * 更新老师 排课表
	 * @param id
	 * @param timetable
	 * @return
	 */
	public static boolean updateTeacherInfo(String id,String timetable){
		Jdbc db = new Jdbc();
		Page page = new Page();
		
		String sql = "UPDATE arrange_sys_teacher 	"+
				"		SET                         "+
				"		timetable = '"+timetable+"'     "+
				"		WHERE                       "+
				"		id = '"+id+"' ;";
		boolean state = db.executeUpdate(sql);
		page.colseDP(db, page);
		
		return state;
	}
	
	/**
	 * 
	 * @param teacherid
	 * @param semester
	 * @param timetable
	 * @return
	 */
	public static boolean updateTeacherforid(String teacherid,String semester,String timetable){
		Jdbc db = new Jdbc();
		Page page = new Page();
		
		String sql = "UPDATE arrange_sys_teacher 	"+
				"		SET                         "+
				"		timetable = '"+timetable+"'     "+
				"		WHERE                       "+
				"		teacherid = '"+teacherid+"' AND  semester='"+semester+"';";
		boolean state = db.executeUpdate(sql);
		page.colseDP(db, page);
		
		return state;
	}
	
	/**
	 * 安排教室
	 * @param totlenum
	 * @param state
	 * @param classid
	 * @param i
	 * @param j
	 * @param semester
	 * @param classroom1
	 * @param classroom2
	 * @param class_grade_number
	 * @param querynum
	 * @param jiaoxuequ				教学区
	 * @return
	 */
	public static String test(String totlenum,String state,String classid,int i ,int j,String semester,String classroom1,String classroom2,String class_grade_number,String querynum,String jiaoxuequ){
		Jdbc db = new Jdbc();
		Page page = new Page();
		
		if(class_grade_number!=null &&!"null".equals(class_grade_number)){
			totlenum = class_grade_number;
		}
		String idString = "";				//教室id
		String stateString = "";			//教室可用状态
		int goclass_number = 0;				//教室容纳人数
		if("1".equals(state)){
			//1.固定
			try {
				//1.查询固定教室id
				String sqlString = "SELECT goclass_number,classroom_id,classroom.teaching_area_id,classroom.state as state,classroom.goclass_number as goclass_number FROM class_grade LEFT JOIN classroom ON class_grade.classroom_id = classroom.id where class_grade.id = '"+classid+"';";
				ResultSet set = db.executeQuery(sqlString);
				
				//固定教室id
				if(set.next()){
					idString = set.getString("classroom_id");
					stateString = set.getString("state");
					goclass_number = set.getInt("goclass_number");
				}if(set!=null){set.close();}
				
				//查询这个教室课表信息
				if(idString!=null && !"".equals(idString) && !"0".equals(idString)){
					if("1".equals(classroom2)&&"0".equals(stateString)){
						page.colseDP(db, page);
						return null;
					}
					if(goclass_number< Integer.valueOf(totlenum) && "1".equals(classroom1)){
						page.colseDP(db, page);
						return null;
					}
					
					
					String timetable = "";
					String arrage_class_sql = "select timetable from arragne_sys_classroom where classroomid='"+idString+"' AND semester='"+semester+"' ;";
					ResultSet arrage_setResultSet = db.executeQuery(arrage_class_sql);
					if(arrage_setResultSet.next()){
						timetable = arrage_setResultSet.getString("timetable");
					}if(arrage_setResultSet!=null){arrage_setResultSet.close();}
					
					if(!"".equals(timetable)){
						ArrayList<ArrayList<String>> list = toArrayList(timetable, "*","#");
						ArrayList<String> list1 = list.get(i);
						String Identification = list1.get(j);
						if(!"0".equals(Identification)&&!"9".equals(Identification)){
							page.colseDP(db, page);
							return idString;
						}else{
							//重新查找教室
							int biaoshi = 0;
							idString = findClassid(totlenum, stateString, classid, i, j, semester, class_grade_number,  biaoshi,querynum,jiaoxuequ);
						}
					}else{
						page.colseDP(db, page);
						return idString;
					}
					
				}else{
					//不固定 查找教室
					int biaoshi = 0;
					idString = findClassid(totlenum, stateString, classid, i, j, semester, class_grade_number,  biaoshi, querynum,jiaoxuequ);
				}
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}else{
			//不固定 查找教室
			int biaoshi = 0;
			idString = findClassid(totlenum, stateString, classid, i, j, semester, class_grade_number,  biaoshi, querynum,jiaoxuequ);
		}
		page.colseDP(db, page);
		return idString;
	}
	
	
	/**
	 * 查找教室id
	 * @param totlenum
	 * @param state
	 * @param classid
	 * @param i
	 * @param j
	 * @param semester
	 * @param class_grade_number
	 * @param biaoshi
	 * @return
	 */
	public static String findClassid(String totlenum,String state,String classid,int i ,int j,String semester,String class_grade_number,int biaoshi,String querynum,String jiaoxuequ){
		
		Jdbc db = new Jdbc();
		Page page = new Page();
		
		String idString = "";
		
		//如果合班人数存在 按照合班人数查找教室
		if(class_grade_number!=null &&!"null".equals(class_grade_number)){
			totlenum = class_grade_number;
		}
		
		//判断教学区是否存在
		String sql_where = "";
		if(jiaoxuequ!=null&&!"".equals(jiaoxuequ)&&!"0".equals(jiaoxuequ)){
			sql_where = "	AND teaching_area_id='"+jiaoxuequ+"'				";
		}
		
		
		int num = Integer.valueOf(totlenum);
		int num_statr = num;
		int num_end = num+100;
		String sql = "SELECT id,state FROM classroom WHERE   goclass_number > "+num_statr+" AND goclass_number< "+num_end+"   "+sql_where+"  ORDER BY RAND() LIMIT 1;";
		ResultSet set1 = db.executeQuery(sql);
		try {
			if(set1.next()){
				idString = set1.getString("id");
			}if(set1!=null){set1.close();}
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		String timetable = "";
		String arrage_class_sql = "select timetable from arragne_sys_classroom where classroomid='"+idString+"' AND semester='"+semester+"' ;";
		ResultSet arrage_setResultSet = db.executeQuery(arrage_class_sql);
		try {
			if(arrage_setResultSet.next()){
				timetable = arrage_setResultSet.getString("timetable");
			}if(arrage_setResultSet!=null){arrage_setResultSet.close();}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
		if(!"".equals(timetable)){
			ArrayList<ArrayList<String>> list = toArrayList(timetable, "*","#");
			ArrayList<String> list1 = list.get(i);
			String Identification = list1.get(j);
			if(!"0".equals(Identification)&&!"9".equals(Identification)){
				page.colseDP(db, page);
				return idString;
			}else{
				//重新查找教室
				if(biaoshi==Integer.valueOf(querynum)){
					page.colseDP(db, page);
					return null;
				}else{
					findClassid(totlenum, state, classid, i, j, semester, class_grade_number,  ++biaoshi,querynum,jiaoxuequ);
				}
			}
			
		}else{
			page.colseDP(db, page);
			return idString;
		}
		
		page.colseDP(db, page);
		return idString;
		
	}
	
	/**
	 * 判断是否是全部课表占用
	 * @param list
	 * @return
	 */
	public static boolean judgeStr(ArrayList<ArrayList<String>> list){
		boolean state = false;
		for(int i =0 ; i< list.size();i++){
			for(int j =0 ; j<list.get(i).size();j++){
				if(!"0".equals(list.get(i).get(j))&&!"9".equals(list.get(i).get(j))){
					state = true;
					return state;
				}
			}
		}
		return state;
	}
	
	
	
	
	/**
	 * 漏课处理
	 * @param id
	 * @return
	 */
	public static boolean LeakageClass(String id){
		
		Jdbc db = new Jdbc();
		Page page = new Page();
		boolean state = true;
		String sql = "UPDATE arrage_coursesystem SET timetablestate = 2 WHERE id = '"+id+"' ;";
		state = db.executeUpdate(sql);
		page.colseDP(db, page);
		return state;
	}
	
	
	
	
	
	
	/**
	 * 获取查找 适应班级的教室
	 * @param totlenum   学生人数
	 * @param state   	 是否启动固定教室	1：启动     2：不启动
	 * @param classid	班级id
	 * @param i			星期下标
	 * @param j			节次下标
	 * @param semester	学期学年
	 * @param classroom1	容纳人数不足状态	1：漏课	2：忽略
	 * @param classroom2	1:教室状态不可用-->漏课	2:教室状态不可用-->忽略	
	 * @param class_grade_number		合班人数		
	 * @return
	 */
	public static String selectClassroom(String totlenum,String state,String classid,int i ,int j,String semester,String classroom1,String classroom2,String class_grade_number){
		Jdbc db = new Jdbc();
		Page page = new Page();
		String idString = "";
		int goclass_number = 0;
		String teaching_area_id = "";		//教学区id
		
		//如果合班人数存在 按照合班人数查找教室
		if(class_grade_number!=null &&!"null".equals(class_grade_number)){
			totlenum = class_grade_number;
		}
		
		String state_sql = "";
		// 教室状态 不可用时 是漏课还是忽略
		if("1".equals(classroom2)){
			state_sql = "  	state=1  ADN		";
		}
		
		if("1".equals(state)){
			//如果是等于1 表示启动， 查询教室id
			String sqlString = "SELECT goclass_number,classroom_id,classroom.teaching_area_id FROM class_grade LEFT JOIN classroom ON class_grade.classroom_id = classroom.id where class_grade.id = '"+classid+"';";
			ResultSet set = db.executeQuery(sqlString);
			try {
				if(set.next()){
					idString = set.getString("classroom_id");	
					goclass_number = set.getInt("goclass_number");
					teaching_area_id = set.getString("teaching_area_id");
				}if(set!=null){set.close();}
			} catch (SQLException e) {
				e.printStackTrace();
			}
			//如果教室容纳人数 小于上课总人数  重新查找
			if(goclass_number<Integer.valueOf(totlenum)){
				if("1".equals(classroom1)){
					//容纳人数不足 漏课
					idString = "";
					page.colseDP(db, page);
					return idString;
				}else{
					//容纳人数不足 忽略
					int num = Integer.valueOf(totlenum);
					int num_statr = num+10;
					int num_end = num+100;
					
					String sql = "SELECT id FROM classroom WHERE goclass_number > "+num_statr+" AND goclass_number< "+num_end+" AND "+state_sql+" teaching_area_id ='"+teaching_area_id+"' ORDER BY RAND() LIMIT 1;";
					ResultSet set1 = db.executeQuery(sql);
					try {
						if(set1.next()){
							idString = set1.getString("id");
						}if(set1!=null){set1.close();}
					} catch (Exception e) {
						e.printStackTrace();
					}
				}
				
			}else{
				//判断这个教室是否被占用
				String timetable = "";
				String arrage_class_sql = "select timetable from arragne_sys_classroom where classroomid='"+idString+"' AND semester='"+semester+"' ;";
				ResultSet arrage_setResultSet = db.executeQuery(arrage_class_sql);
				try {
					if(arrage_setResultSet.next()){
						timetable = arrage_setResultSet.getString("timetable");
					}if(arrage_setResultSet!=null){arrage_setResultSet.close();}
				} catch (SQLException e) {
					e.printStackTrace();
				}
				if(!"".equals(timetable)){
					ArrayList<ArrayList<String>> list = toArrayList(timetable, "*","#");
					ArrayList<String> list1 = list.get(i);
					String hString = list1.get(j);
					if("0".equals(hString)){
						int num = Integer.valueOf(totlenum);
						int num_statr = num+10;
						int num_end = num+100;
						
						String sql = "SELECT id FROM classroom WHERE goclass_number > "+num_statr+" AND goclass_number< "+num_end+" AND "+state_sql+"	 teaching_area_id ='"+teaching_area_id+"' ORDER BY RAND() LIMIT 1;";
						ResultSet set1 = db.executeQuery(sql);
						try {
							if(set1.next()){
								idString = set1.getString("id");
							}if(set1!=null){set1.close();}
						} catch (Exception e) {
							e.printStackTrace();
						}
					}
					
				}
			}
		}else{
			int num = Integer.valueOf(totlenum);
			int num_statr = num+10;
			int num_end = num+100;
			String sql = "SELECT id FROM classroom WHERE  "+state_sql+" goclass_number > "+num_statr+" AND goclass_number< "+num_end+"  ORDER BY RAND() LIMIT 1;";
			ResultSet set1 = db.executeQuery(sql);
			try {
				if(set1.next()){
					idString = set1.getString("id");
				}if(set1!=null){set1.close();}
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		page.colseDP(db, page);
		return idString;
	}
	
	/**
	 * 更新教室 排课表
	 * @param id
	 * @param timetable
	 * @return
	 */
	public static boolean updateClassroom(String id,String timetable){
		Jdbc db = new Jdbc();
		Page page = new Page();
		
		String sql = "UPDATE arragne_sys_classroom 	"+
				"		SET                         "+
				"		timetable = '"+timetable+"'     "+
				"		WHERE                       "+
				"		id = '"+id+"' ;";
		boolean state = db.executeUpdate(sql);
		page.colseDP(db, page);
		
		return state;
	}
	
	/**
	 * 更新教室 排课表 根据教室id 与学期
	 * @param classroomid
	 * @param semester
	 * @param timetable
	 * @return
	 */
	public static boolean updateClassroomForid(String classroomid,String semester,String timetable){
		Jdbc db = new Jdbc();
		Page page = new Page();
		
		String sql = "UPDATE arragne_sys_classroom 	"+
				"		SET                         "+
				"		timetable = '"+timetable+"'     "+
				"		WHERE                       "+
				"		classroomid = '"+classroomid+"' AND semester = '"+semester+"' ;";
		boolean state = db.executeUpdate(sql);
		page.colseDP(db, page);
		
		return state;
	}
	
	
	
	public static boolean insertClassroom(String classroomid,String semester,String timetable ){
		Jdbc db = new Jdbc();
		Page page = new Page();
		
		String sql = "INSERT INTO arragne_sys_classroom 	"+
				"		(                                   "+
				"		classroomid,                        "+
				"		semester,                           "+
				"		timetable                           "+
				"		)                                   "+
				"		VALUES                              "+
				"		(                                   "+
				"		'"+classroomid+"',                      "+
				"		'"+semester+"',                         "+
				"		'"+timetable+"'                         "+
				"		);";
		
		boolean state = db.executeUpdate(sql);
		page.colseDP(db, page);
		
		return state;
	}
	
	/**
	 * 获取 相应的节次信息
	 * @author zhoukai
	 * @param list
	 * @return
	 */
	public static String getSection(ArrayList<String> list){
		
		String section = "";
		
		for(int i =0 ; i < list.size(); i++){
			if("0".equals(list.get(i))){
				section += sectionSet(Integer.valueOf(i))+",";
			}
		}
		return section;
	}
	
	
	public static String sectionSet(int subscript1){
		
		String section = "";
		
		switch (subscript1) {
		case 0:
			section = "第12节";
			break;
		case 1:
			section = "第34节";
			break;
		case 2:
			section = "第56节";
			break;
		case 3:
			section = "第78节";
			break;
		default:
			section = "";
			break;
		}
		
		return section;
	}
	
	/**
	 * 获取某个范围的随机数
	 * @return
	 */
	public static Integer getRand(int min, int max){
		Random random = new Random();
	    int s = random.nextInt(max) % (max - min + 1) + min;
	    return s;
	}
	
	/**
	 * 获取 星期 和 节次的list  生成课表  
	 * @param weeknum		星期数 为4  表示星期五
	 * @param jiecinum		节次数 为3  表示四大节
	 * @return
	 */
	public static ArrayList<String> setWeekList(int weeknum,int jiecinum){
		ArrayList<String> result = new ArrayList<String>(); 	
		
		for(int i=0 ; i <=weeknum; i++){
			for(int j =0 ; j <=jiecinum;j++){
				result.add(String.valueOf(i)+String.valueOf(j));
			}
		}
		return result;
	}
	
	
	
	/**
	 * 获取一个乱序的list
	 * @param list
	 * @return
	 */
	public static ArrayList<String> getOutOfOrder(ArrayList<String> list ){
		ArrayList<String> result = new ArrayList<String>(); 	//保存乱序的list
		Random rand = new Random();  
		  
        // 取得集合的长度，for循环使用  
        int size = list.size();  
  
        // 遍历整个items数组  
        for (int i = 0; i < size; i++) {  
            // 任意取一个0~size的整数，注意此处的items.size()是变化的，所以不能用前面的size会发生数组越界的异常  
            int myRand = rand.nextInt(list.size());  
            //将取出的这个元素放到存放结果的集合中  
            result.add(list.get(myRand));  
            //从原始集合中删除该元素防止重复。注意，items数组大小发生了改变  
            list.remove(myRand);  
        }
        return result;
        
	}
	
	
	/**
	 * 获取 条件下的课表 list (排课时间，排课顺序)
	 * @param semester			学期学号
	 * @param course_mode		排课方式 5天制  6天制  7天制
	 * @return
	 */
	public static ArrayList<String> getSetupWeek(String semester,String course_mode,String courseid){
		Jdbc db = new Jdbc();
		Page page = new Page();
		
		//排课时间
		ArrayList<String> totleList = setWeekList(6,3);				//星期一到星期日的 全课表 信息
		int week_id = 0;
		int section_id = 0;
		int state = 0;
		
		ArrayList<String> list = new ArrayList<String>();
		String sql = "SELECT week_id,section_id,state FROM arrage_course_nottime WHERE academic_year='"+semester+"' ORDER BY week_id,section_id";
		int num = db.Row("SELECT count(1) as row FROM arrage_course_nottime WHERE academic_year='"+semester+"' ");
		if(num>0){
			//有数据说明，已经设置排课时间
			ResultSet set = db.executeQuery(sql);
			try {
				while(set.next()){
					state = set.getInt("state");
					week_id = set.getInt("week_id")-1;
					section_id = set.getInt("section_id")-1;
					list.add(String.valueOf(week_id)+String.valueOf(section_id));
				}if(set!=null){set.close();}
			} catch (SQLException e) {
				e.printStackTrace();
			}
			
			if(state==3){
				totleList.removeAll(list);
			}
			
		}else{
			if(course_mode==null || "".equals(course_mode)){
				totleList = setWeekList(4, 3);
			}else{
				int h = Integer.valueOf(course_mode)-1;
				totleList = setWeekList(h, 3);
			}
		}
		
		
		
		
		
		//排课顺序
		String paikeorder_sql = "SELECT																				"+
								"		  arrage_course_order.section_id as section_id,                                                             "+
								"		  arrage_course_order.state as state                                                             "+
								"		FROM dict_courses                                                                   "+
								"		  LEFT JOIN arrage_course_order                                                     "+
								"		    ON arrage_course_order.class_big_id = dict_courses.dict_courses_class_big_id    "+
								"		  LEFT JOIN dict_courses_class_big                                                  "+
								"		    ON dict_courses_class_big.id = arrage_course_order.class_big_id                 "+
								"		WHERE dict_courses.id = '"+courseid+"'                                                        "+
								"		    AND arrage_course_order.semester = '"+semester+"'	ORDER BY arrage_course_order.state asc	;";  
		String paie_num = "SELECT																				"+
		"		  count(1) as row                                                             "+
		"		FROM dict_courses                                                                   "+
		"		  LEFT JOIN arrage_course_order                                                     "+
		"		    ON arrage_course_order.class_big_id = dict_courses.dict_courses_class_big_id    "+
		"		  LEFT JOIN dict_courses_class_big                                                  "+
		"		    ON dict_courses_class_big.id = arrage_course_order.class_big_id                 "+
		"		WHERE dict_courses.id = '"+courseid+"'                                                        "+
		"		    AND arrage_course_order.semester = '"+semester+"'		;";  
		
		int paikenum = db.Row(paie_num);
		if(paikenum>0){
			//说明用排课顺序
			ArrayList<String> xinList = new ArrayList<String>();
			ResultSet paike_set = db.executeQuery(paikeorder_sql);
			try {
				while(paike_set.next()){
					for(int i =0 ; i<totleList.size();i++){
						String tt = totleList.get(i);
						char c = tt.charAt(1);
						String hh = String.valueOf(c);
						int jiecixiabiao = paike_set.getInt("section_id")-1;
						if("5".equals(paike_set.getString("state"))){
							if(jiecixiabiao==Integer.valueOf(hh)){
								totleList.remove(i);
							}
						}else{
							if(jiecixiabiao==Integer.valueOf(hh)){
								xinList.add(totleList.get(i));
							}
						}
					}
				}if(paike_set!=null){paike_set.close();}
				
				totleList.removeAll(xinList);		//去除符合条件的元素
				xinList.addAll(getOutOfOrder(totleList));	//把剩余的元素乱序加入到 新生成的list中
				totleList = xinList;
				page.colseDP(db, page);
				return totleList;
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
		page.colseDP(db, page);
		return getOutOfOrder(totleList);
	}
	
	
	
	/*public static void main(String[] args) {
		
		ArrayList<String> textArrayList = new ArrayList<String>();
		textArrayList.add("1");
		textArrayList.add("0");
		
		
		ArrayList<String> totleArrayList = setWeekList(6,3);
		System.out.println("totle===="+totleArrayList);
		
		ArrayList<String> xinList = new ArrayList<String>();
		
		for(int i =0 ; i<textArrayList.size();i++){
			
			for(int j = 0 ; j<totleArrayList.size();j++){
				String ttString = totleArrayList.get(j);
				char c = ttString.charAt(1);
				String hhString = String.valueOf(c);
				if((textArrayList.get(i)).equals(hhString)){
					xinList.add(totleArrayList.get(j));
				}
			}
		}
		
		totleArrayList.removeAll(xinList);
		
		xinList.addAll(totleArrayList);
		
		
		System.out.println("xinli===="+xinList);
		System.out.println("totleArrayList===="+totleArrayList);
		
		
			for(int j =0  ; j <totleArrayList.size();j++){
				
				
				for(int u=0;u<totleArrayList.size()-j-1;u++){
					String ttString = totleArrayList.get(u);
					char c = ttString.charAt(1);
					String hhString = String.valueOf(c);
					if("1".equals(hhString)||"0".equals(hhString)){
						String item = totleArrayList.get(u);
						totleArrayList.set(u, totleArrayList.get(u+1));
						totleArrayList.set(u+1, item);
					}else if("3".equals(hhString)){
						totleArrayList.remove(u);
					}
				}
				
			}
			Collections.reverse(totleArrayList);
		System.out.println("totle===="+totleArrayList);
		
	}*/
	
	/**
	 * 生成二维数组课表
	 * @param first
	 * @param two
	 * @return
	 */
	public static ArrayList<ArrayList<String>> setTwoArray(int first,int two){
		
		ArrayList<ArrayList<String>> common_list = new ArrayList<ArrayList<String>>();			//公共list 为了保存课程的信息
		
		for(int i = 0 ; i<=first ; i++){
			ArrayList<String> comm1_list = new ArrayList<String>();
			for(int j =1 ; j <=two;j++){
				comm1_list.add(String.valueOf(j));
			}
			common_list.add(comm1_list);
		}
		
		return common_list;
		
	}
	
	
	/**
	 * 初始化课表 保证有锁定的 使用9代替被锁定状态
	 * @param semester
	 * @param course_mode
	 * @return
	 */
	public static ArrayList<ArrayList<String>> setInitializationList(String semester,String course_mode){
		Jdbc db = new Jdbc();
		Page page = new Page();
		
		
		ArrayList<ArrayList<String>> totleList = setTwoArray(6,4);				//星期一到星期日的 全课表 信息
		
		int week_id = 0;
		int section_id = 0;
		int state = 0;
		
		String sql = "SELECT week_id,section_id,state FROM arrage_course_nottime WHERE academic_year='"+semester+"' ORDER BY week_id,section_id";
		int num = db.Row("SELECT count(1) as row FROM arrage_course_nottime WHERE academic_year='"+semester+"' ");
		if(num>0){
			//有数据说明，已经设置排课时间
			ResultSet set = db.executeQuery(sql);
			try {
				while(set.next()){
					state = set.getInt("state");
					week_id = set.getInt("week_id")-1;
					section_id = set.getInt("section_id")-1;
					
					if(state==3){
						totleList.get(week_id).set(section_id, "9");
					}
				}if(set!=null){set.close();}
			} catch (SQLException e) {
				e.printStackTrace();
			}
			
		}else{
			if(course_mode==null || "".equals(course_mode)){
				totleList = setTwoArray(4, 4);
			}else{
				int h = Integer.valueOf(course_mode)-1;
				totleList = setTwoArray(h, 4);
			}
		}
		page.colseDP(db, page);
		return totleList;
	}
	
	
	/**
	 * 查看教师条件
	 * @param base_list		基本课表
	 * @param teacherid		老师id
	 * @param semester		学期学号
	 * @return
	 */
	public static ArrayList<ArrayList<String>> setTeacherCondition(ArrayList<ArrayList<String>> base_list,String teacherid,String semester){
		
		Jdbc db = new Jdbc();
		Page page = new Page();
		ArrayList<ArrayList<String>> resuList = base_list;
		
		ArrayList<ArrayList<String>> linshi = new ArrayList<ArrayList<String>>();		//保存排课的。
		String sql = "SELECT state,section_id,week_id FROM arrage_course_teacher WHERE teacher_id = '"+teacherid+"' AND semester = '"+semester+"'   ;";
		int num = db.Row("SELECT count(1) as row FROM arrage_course_teacher WHERE teacher_id = '"+teacherid+"' AND semester = '"+semester+"'   ;");
		
		if(num>0){
			ResultSet set = db.executeQuery(sql);
			try {
				while(set.next()){
					if("1".equals(set.getString("state"))){
						int week_id = set.getInt("week_id")-1;
						int jieci = set.getInt("section_id")-1;
						resuList.get(week_id).set(jieci, "9");				//选定的节次 设置为9 是说明9被锁定
					}else if("3".equals(set.getString("state"))){
						//1.先把课表都锁定，再排课
						for(int i =0 ; i< resuList.size();i++){
							ArrayList<String> arr1 = new ArrayList<String>();
							for(int j =0 ;j < resuList.get(i).size();j++){
								arr1.add(String.valueOf("9"));				//全部课表内容都设定为9 全部锁定
							}
							linshi.add(arr1);
							
						}
						//2.相应的课表 排课 设置相应的节次
						int week_id = set.getInt("week_id")-1;
						int jieci = set.getInt("section_id");
						linshi.get(week_id).set(jieci-1,String.valueOf(jieci) );
						resuList = linshi;
					}
					
				}if(set!=null){set.close();}
			} catch (SQLException e) {
				page.colseDP(db, page);
				e.printStackTrace();
			}
		}
		
		page.colseDP(db, page);
		return resuList;
	}
	
	
	/**
	 * 周进度分配转换为 [1-2,5]-->3-5,5-n
	 * @param list	占用周进度的数组
	 * @param weeks	学期总周数
	 * @return
	 */
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
	
	/**
	 * 周进度分配转换为 [1,2,5]-->1-2,5
	 * @param list
	 * @param weeks
	 * @return
	 */
	public static String getweekOStr(ArrayList<Integer> list, int weeks ){
		String str = "";
		ArrayList<Integer> testArrayList = new ArrayList<Integer>();
	
		testArrayList = list;
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
	
	
	/**
	 * 保存排课信息及详情
	 * @param arrage_coursesystem_id
	 * @param course_id
	 * @param teacherid
	 * @param classroomid
	 * @param class_begins_weeks
	 * @return
	 */
	public static boolean setCourse(String arrage_coursesystem_id,String course_id,String teacherid,String classroomid,ArrayList<ArrayList<String>> list,String class_id,String class_begins_weeks,String semester){
		
		Jdbc db = new Jdbc();
		Page page = new Page();
		
		String timetable = toStringfroList(list,"*","#");
		
		
		boolean state = true;
		//更新主表
		String update_sql = "UPDATE arrage_coursesystem 	SET		"+
		"		timetable = '"+timetable+"' ,               "+
		"		timetablestate = '1'       "+
		"		WHERE                                   "+
		"		id = '"+arrage_coursesystem_id+"' ;";
		
		if(!db.executeUpdate(update_sql)){
			state = false;
			page.colseDP(db, page);
			return state;
		}
		//修改详情表
		//插入
		String insert_sql = "INSERT INTO arrage_details "+
					"			(                                   "+
					"			arrage_coursesystem_id,                "+
					"			semester,								"+
					"			course_id,                             "+
					"			classid,                               "+
					"			teacher_id,                            "+
					"			classroomid,                           "+
					"			weeks,                                 "+
					"			timetable,                              "+
					"			classtime								"+
					"			)                                      "+
					"			VALUES                                 "+
					"			(                                 "+
					"			'"+arrage_coursesystem_id+"',              "+
					"			'"+semester+"',							"+
					"			'"+course_id+"',                           "+
					"			'"+class_id+"',                             "+
					"			'"+teacherid+"',                          "+
					"			'"+classroomid+"',                         "+
					"			'"+class_begins_weeks+"',                               "+
					"			'"+timetable+"',                            "+
					"			'"+getClasstime(timetable)+"'								"+
					"			);";
		int num = db.executeUpdateRenum(insert_sql);
		
		if(num>0){
			//插入到arrage_detailes_weekly
			
			//list 课表
			for(int i = 0;i<list.size();i++){
				for(int j = 0 ; j < list.get(i).size();j++){
					//等于0 说明排课 安排了
					if("0".equals(list.get(i).get(j)) || "9".equals(list.get(i).get(j))){
						ArrayList<String> weekly = setWeekly(class_begins_weeks);
						for(int g = 0 ; g< weekly.size();g++){
							String arrage_deatles_week = "INSERT INTO arrage_details_weekly 	"+
											"			(                                       "+
											"			arrage_details_id,                      "+
											"			weekly,                                 "+
											"			WEEK,                                   "+
											"			section,                                "+
											"			state                                   "+
											"			)                                       "+
											"			VALUES                                  "+
											"			(                                       "+
											"			'"+num+"',                    "+
											"			'"+weekly.get(g)+"',                               "+
											"			'"+(i+1)+"',                                 "+
											"			'"+(j+1)+"',                              "+
											"			'"+list.get(i).get(j)+"'                                 "+
											"			);";   
							db.executeUpdate(arrage_deatles_week);
						}
					}
					
				}
			}
		}
		
		page.colseDP(db, page);
		return state;
	}
	
	
	
	/**
	 * 获取上课时间		40102	表示星期四的12节
	 * @param timetable
	 * @return
	 */
	public static String getClasstime(String timetable){
	
		ArrayList<ArrayList<String>> list = toArrayList(timetable,"*","#");
		ArrayList<String> result = new ArrayList<String>();
		String base = "";
		for(int i =0 ; i < list.size();i++){
			for(int j =0 ; j<list.get(i).size();j++){
				if("0".equals(list.get(i).get(j))){
					String str = "";
					str += String.valueOf(i+1);
					str += jieci(j);
					result.add(str);
				}
			}
		}
		
		base = StringUtils.join(result,",");
		
		return base;
	}
	
	public static String jieci(int subscript1){
			
		String section = "";
		
		switch (subscript1) {
		case 0:
			section = "0102";
			break;
		case 1:
			section = "0304";
			break;
		case 2:
			section = "0506";
			break;
		case 3:
			section = "0708";
			break;
		default:
			section = "";
			break;
		}
		
		return section;
	}
	
	/**
	 * 获取周次数据
	 * @param weekly 字符串周次
	 * @return
	 */
	public static ArrayList<String> setWeekly(String weekly){
		
		
		ArrayList<String> totle_list = new ArrayList<String>();
			//存在多个
			ArrayList<String> list = 	new ArrayList(Arrays.asList(weekly.split(",")));
	    	for(int l = 0; l<list.size();l++){
	    		String t = list.get(l);
	    		if(t.length()>0){
		    		if(t.indexOf("-")==-1){
		    			//不存在周数范围
		    			totle_list.add(t);
		    		}else{
		    			//存在周数范围
		    			String [] ss = t.split("-");
		    			for(int g = Integer.valueOf(ss[0]) ;g<=Integer.valueOf(ss[1]);g++){
		    				totle_list.add(String.valueOf(g));
		    			}
		    			
		    		}
	    		
	    		}
	    		
	    	}
    	return totle_list;
	}
	
	public static void main(String[] args) {
		System.out.println(setWeekly("1-12,5,6-12").size());
	}
	
	
	/**
	 * 遍历重复数组 
	 * cornerMap {去重后的数组元素:数组所在的角标}
	 * @param str
	 * @return cornerMap
	 */
	public static Map<Object, Object> Arrcoot (String  str ){
		
		
		/*将字符串转成数组*/
	    String strArr[]=str.split("\\|");
	    
	    /*集合用来存放去重的值*/
	    ArrayList<Object> element=new ArrayList<Object>();
	    
	    Map<Object, Object> cornerMap = new HashMap<Object, Object>();
	    
	    int cornerVal=0;
	    for(String str_son : strArr){
	    
	    	ArrayList<Object> cornerArr=new ArrayList<Object>();
	    	
	    	if(!element.contains(str_son)){
	    		/*记录当前角标*/
	    		element.add(str_son);
	    		cornerArr.add(cornerVal);
	    		cornerMap.put(str_son, cornerArr);
	    	}else{
	    		
	    		if(cornerMap.get(str_son)!=null){
	    			JSONArray cornerArr2 =JSONArray.fromObject(cornerMap.get(str_son));
	    			cornerArr2.add(cornerVal);
	    			cornerMap.put(str_son, cornerArr2);
	    		}
	    	}
	    	cornerVal++;
	    }
	    
	    
		
	    return cornerMap;
		
	}

	
	/**
	 * 保存排课错误日志信息
	 */
	public static void setArrageLog(String arrage_coursesystem_id,String common){
		
		Jdbc db = new Jdbc();
		Page page = new Page();
		
		String sql = "INSERT INTO arrage_log 				"+
				"		(                                "+
				"		arrage_coursesystem_id,             "+
				"		common                              "+
				"		)                                   "+
				"		VALUES                              "+
				"		(                              "+
				"		'"+arrage_coursesystem_id+"',           "+
				"		'"+common+"'                            "+
				"		);";
		
		db.executeUpdate(sql);
		page.colseDP(db, page);
	}
	
	
	
	/**
	 * 删除信息
	 * @param arrage_coursesystem_id
	 * @return
	 */
	public static boolean setDelete(String arrage_coursesystem_id,String semester){
		Jdbc db = new Jdbc();
		Page page = new Page();
		
		//修改班级，教师，教室信息，
		String sql = "SELECT																				"+
		"				  arrage_coursesystem.id          AS id,                                        "+
		"				  arrage_details.timetable        AS onetimetable,                              "+
		"				  arrage_details.classid          AS classid,                                   "+
		"				  arrage_details.classroomid      AS classroomid,                               "+
		"				  arrage_details.teacher_id       AS teacher_id,                                "+
		"				  arrange_sys_class.timetable     AS classtimetable,                            "+
		"				  arragne_sys_classroom.timetable AS classroomtimetable,                        "+
		"				  arrange_sys_teacher.timetable   AS teachertimetable                           "+
		"				FROM arrage_coursesystem                                                        "+
		"				  LEFT JOIN arrage_details                                                      "+
		"				    ON arrage_coursesystem.id = arrage_details.arrage_coursesystem_id           "+
		"				  LEFT JOIN arrange_sys_class                                                   "+
		"				    ON arrange_sys_class.classid = arrage_details.classid                       "+
		"				  LEFT JOIN arragne_sys_classroom                                               "+
		"				    ON arragne_sys_classroom.classroomid = arrage_details.classroomid           "+
		"				  LEFT JOIN arrange_sys_teacher                                                 "+
		"				    ON arrange_sys_teacher.teacherid = arrage_details.teacher_id"+
		"				WHERE 1=1 		AND arrage_coursesystem.id = '"+arrage_coursesystem_id+"'	AND arrage_coursesystem.semester='"+semester+"'	;	";
		ResultSet set = db.executeQuery(sql);
		//当前课程上课时间
		String onetimetable = "";
		String classtimetable = "";
		String classroomtimetable = "";
		String teachertimetable = "";
		String classid = "";
		String classroomid = "";
		String teacher_id = "";
		try {
			while(set.next()){
				onetimetable = set.getString("onetimetable");
				classtimetable = set.getString("classtimetable");
				classroomtimetable = set.getString("classroomtimetable");
				teachertimetable = set.getString("teachertimetable");
				classid = set.getString("classid");
				classroomid = set.getString("classroomid");
				teacher_id = set.getString("teacher_id");
				
				if(onetimetable!=null && !"".equals(onetimetable)){
					ArrayList<ArrayList<String>> list =toArrayList(onetimetable,"*","#");
					
					ArrayList<ArrayList<String>> class_list = toArrayList(classtimetable,"*","#");
					ArrayList<ArrayList<String>> classroom_list = toArrayList(classroomtimetable,"*","#");
					ArrayList<ArrayList<String>> teacher_list = toArrayList(teachertimetable,"*","#");
					
					
					for(int i = 0 ;i<list.size();i++){
						for(int j =0 ; j<list.get(i).size();j++){
							if("0".equals(list.get(i).get(j))){
								//修改班级
								if(!class_list.isEmpty()){
									class_list.get(i).set(j, String.valueOf(Integer.valueOf(j+1)));
									commonCourse.updateClassForid(classid,semester,commonCourse.toStringfroList(class_list,"*","#"));
								}
								
								//修改教室
								if(!classroom_list.isEmpty()){
									classroom_list.get(i).set(j, String.valueOf(Integer.valueOf(j+1)));
									commonCourse.updateClassroomForid(classroomid,semester,commonCourse.toStringfroList(classroom_list,"*","#"));
								}
								
								//修改教师
								if(!teacher_list.isEmpty()){
									teacher_list.get(i).set(j, String.valueOf(Integer.valueOf(j+1)));
									commonCourse.updateTeacherforid(teacher_id,semester,commonCourse.toStringfroList(teacher_list,"*","#"));
								}
							}
						}
					}
				}
				
			}if(set!=null){set.close();}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
		//删除排课信息
		
		String del_sql = "DELETE arrage_details,	"+
		"		  arrage_details_weekly      "+
		"		FROM  arrage_details,   "+
		"		  arrage_details_weekly   "+
		"	WHERE arrage_details.id = arrage_details_weekly.arrage_details_id AND arrage_details.arrage_coursesystem_id = '"+arrage_coursesystem_id+"'";
		
		
		String del_base_sql = "	DELETE FROM arrage_coursesystem  WHERE id = '"+arrage_coursesystem_id+"' ;		";
		
		boolean sttta = db.executeUpdate(del_base_sql);
		
		boolean state = db.executeUpdate(del_sql);
		
		
		
		page.colseDP(db, page);
		return state;
	}
	
	
	
	
	
	/**
	 * 清空排课类别排课
	 */
	public static boolean setScheduleCategory(String semester ,String course_class){
		Jdbc db = new Jdbc();
		Page page = new Page();
		
		
		try {
			String sqlWhere = "";
			
			if(!"0".equals(course_class)){
				sqlWhere = "	AND	course_class = '"+course_class+"'			";
			
				//查询需要清空的数据， 并且修改班级，教师，教室相对应的上课情况
				String sql = "SELECT																				"+
					"				  arrage_coursesystem.id          AS id,                                        "+
					"				  arrage_details.timetable        AS onetimetable,                              "+
					"				  arrage_details.classid          AS classid,                                   "+
					"				  arrage_details.classroomid      AS classroomid,                               "+
					"				  arrage_details.teacher_id       AS teacher_id,                                "+
					"				  arrange_sys_class.timetable     AS classtimetable,                            "+
					"				  arragne_sys_classroom.timetable AS classroomtimetable,                        "+
					"				  arrange_sys_teacher.timetable   AS teachertimetable                           "+
					"				FROM arrage_coursesystem                                                        "+
					"				  LEFT JOIN arrage_details                                                      "+
					"				    ON arrage_coursesystem.id = arrage_details.arrage_coursesystem_id           "+
					"				  LEFT JOIN arrange_sys_class                                                   "+
					"				    ON arrange_sys_class.classid = arrage_details.classid                       "+
					"				  LEFT JOIN arragne_sys_classroom                                               "+
					"				    ON arragne_sys_classroom.classroomid = arrage_details.classroomid           "+
					"				  LEFT JOIN arrange_sys_teacher                                                 "+
					"				    ON arrange_sys_teacher.teacherid = arrage_details.teacher_id"+
					"				WHERE 1=1 	"+sqlWhere+"	AND arrage_coursesystem.semester = '"+semester+"';	";
				
				
				ResultSet set = db.executeQuery(sql);
				//当前课程上课时间
				String onetimetable = "";
				String classtimetable = "";
				String classroomtimetable = "";
				String teachertimetable = "";
				String classid = "";
				String classroomid = "";
				String teacher_id = "";
				
				
				while(set.next()){
					onetimetable = set.getString("onetimetable");
					classtimetable = set.getString("classtimetable");
					classroomtimetable = set.getString("classroomtimetable");
					teachertimetable = set.getString("teachertimetable");
					classid = set.getString("classid");
					classroomid = set.getString("classroomid");
					teacher_id = set.getString("teacher_id");
					
					if(onetimetable!=null && !"".equals(onetimetable)){
						ArrayList<ArrayList<String>> list =toArrayList(onetimetable,"*","#");
						
						ArrayList<ArrayList<String>> class_list = toArrayList(classtimetable,"*","#");
						ArrayList<ArrayList<String>> classroom_list = toArrayList(classroomtimetable,"*","#");
						ArrayList<ArrayList<String>> teacher_list = toArrayList(teachertimetable,"*","#");
						
						
						for(int i = 0 ;i<list.size();i++){
							for(int j =0 ; j<list.get(i).size();j++){
								if("0".equals(list.get(i).get(j))){
									//修改班级
									if(!class_list.isEmpty()){
										class_list.get(i).set(j, String.valueOf(Integer.valueOf(j+1)));
										commonCourse.updateClassinfo(classid,commonCourse.toStringfroList(class_list,"*","#"));
									}
									//修改教室
									if(!classroom_list.isEmpty()){
										classroom_list.get(i).set(j, String.valueOf(Integer.valueOf(j+1)));
										commonCourse.updateClassroom(classroomid,commonCourse.toStringfroList(classroom_list,"*","#"));
									}
									//修改教师
									if(!teacher_list.isEmpty()){
										teacher_list.get(i).set(j, String.valueOf(Integer.valueOf(j+1)));
										commonCourse.updateTeacherInfo(teacher_id,commonCourse.toStringfroList(teacher_list,"*","#"));
									}
								}
							}
						}
					}
					
				}if(set!=null){set.close();}
			
			}else{
				//直接删除 （全部）
				db.executeUpdate("DELETE FROM arragne_sys_classroom WHERE semester = '"+semester+"';");
				db.executeUpdate("DELETE FROM arrange_sys_class WHERE semester = '"+semester+"';");
				db.executeUpdate("DELETE FROM arrange_sys_teacher WHERE semester = '"+semester+"';");
			}
			
			//修改主表
			String update_sql = "UPDATE arrage_coursesystem  SET timetable = '' ,  timetablestate = '0'  WHERE 1=1   "+sqlWhere+"  AND  semester = '"+semester+"' ;";
			db.executeUpdate(update_sql);
			String del_sql = "DELETE arrage_details,																												"+
					"		  arrage_details_weekly                                                                                                                 "+
					"		FROM arrage_coursesystem, arrage_details,                                                                                               "+
					"		  arrage_details_weekly                                                                                                                 "+
					"		WHERE	1=1		"+sqlWhere+"	AND	 arrage_coursesystem.id = arrage_details.arrage_coursesystem_id AND  arrage_details.id = arrage_details_weekly.arrage_details_id   "+
					"		    AND arrage_coursesystem.semester = '"+semester+"';";
			
			db.executeUpdate(del_sql);
			db.executeUpdate("DELETE arrage_details,arrage_details_weekly FROM arrage_details,arrage_details_weekly WHERE arrage_details.semester = '"+semester+"' AND arrage_details.id =  arrage_details_weekly.arrage_details_id;");
			
			
			
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
		
		page.colseDP(db, page);
		return true;
		
	}
	
	
	/**
	 * 增加调课记录
	 * @param arrage_coursesystem_id
	 * @param classtime_old
	 * @param classtime_new
	 * @param biaoshi
	 * @param biaoshi_id
	 */
	public static void setLectureLog(String arrage_coursesystem_id,String classtime_old,String classtime_new,String biaoshi,String biaoshi_id) {
		Jdbc db = new Jdbc();
		Page page = new Page();
		common common = new common();
		
		
		String remark = "";
		
		String name = "";
		if("teacher".equals(biaoshi)){
			name = common.idToFieidName("teacher_basic", "teacher_name", biaoshi_id);
		}
		
		if("class".equals(biaoshi)){
			name = common.idToFieidName("class_grade", "class_name", biaoshi_id);
		}
		
		if("classroom".equals(biaoshi)){
			name = common.idToFieidName("classroom", "classroomname", biaoshi_id);
		}
		
		
		remark = name +":上课时间由"+classtime_old+"修改到"+classtime_new;
		
		
		
		
		String insert_sqlString = "INSERT INTO arrage_lecture_log 		"+
						"			(                               "+
						"			arrage_coursesystem_id,             "+
						"			classtime_old,                      "+
						"			classtime_new,                      "+
						"			common,                             "+
						"			createtime                          "+
						"			)                                   "+
						"			VALUES                              "+
						"			(                              "+
						"			'"+arrage_coursesystem_id+"',           "+
						"			'"+classtime_old+"',                    "+
						"			'"+classtime_new+"',                    "+
						"			'"+remark+"',                           "+
						"			now()                        "+
						"			);";
		db.executeUpdate(insert_sqlString);
		page.colseDP(db, page);
		
	}
	
	
	/**
	 * 获取班级合并之后的时间表
	 * @param semester
	 * @param course_mode
	 * @param timetablestr
	 * @return
	 */
	public static ArrayList<ArrayList<String>> getclassList(String semester,String course_mode,ArrayList<String> timetablestr){
		
		ArrayList<ArrayList<String>> baseList = setInitializationList(semester,course_mode);
		
		//循环集合
		for(int i =0 ; i < timetablestr.size();i++){
			ArrayList<ArrayList<String>> class_list = toArrayList(timetablestr.get(i), "*","#");
			for(int w = 0; w<class_list.size();w++){
				for(int jc = 0 ; jc < class_list.get(w).size();jc++){
					if("0".equals(class_list.get(i).get(jc)) ){
						baseList.get(i).set(jc, "0");
					}else if( "9".equals(class_list.get(i).get(jc))){
						baseList.get(i).set(jc, "9");
					}
				}
			}
		}
		return baseList;
	}
	
	
}
