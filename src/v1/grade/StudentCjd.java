package v1.grade;


import cn.afterturn.easypoi.excel.ExcelExportUtil;
import cn.afterturn.easypoi.excel.entity.TemplateExportParams;
import org.apache.commons.lang.StringUtils;
import org.apache.poi.ss.usermodel.Workbook;

import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.math.BigDecimal;
import java.net.URLEncoder;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import static v1.grade.DBHelper.ResultType.STRING;


public class StudentCjd extends HttpServlet {
    public StudentCjd() {
        super();
    }

    public void destroy() {
        super.destroy(); // Just puts "destroy" string in log

    }

    /**
     * api 接口总入口 接受变量引导
     */
    String address ="/Users/huang/work/ceshi/";

    public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("**********************进入学生成绩表打印");
        String path = request.getSession().getServletContext().getRealPath("/");//获取tomcat根目录
        address = path;
        System.out.println("项目路径------------------"+path);
        int student_id= Integer.parseInt(request.getParameter("student_id"));

        try {
            studentCjd( student_id, response);
        } catch (SQLException e) {
            e.printStackTrace();
        } catch (ParseException e) {
            e.printStackTrace();
        }


//
    }

    public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("进入了统计dopost");
        String path = request.getSession().getServletContext().getRealPath("/");//获取tomcat根目录
        address = path;
        System.out.println("项目路径------------------"+path);
    }
    public String s_d(String s){
        if (StringUtils.isNotBlank(s)){
            Double sd = Double.valueOf(s);
            BigDecimal b = new BigDecimal(sd);
            double d = b.setScale(2, BigDecimal.ROUND_HALF_UP).doubleValue();
            return d+"";
        }
        return s;
    }

    public boolean isNumeric(String str){
        Pattern pattern = Pattern.compile("[0-9]*");
        Matcher isNum = pattern.matcher(str);
        if( !isNum.matches() ){
            return false;
        }
        return true;
    }

    //----------------------------------------------------学生成绩卡----------------------------------------
    /**
     * 学生成绩卡打印
     * @param response
     * @throws IOException
     */
    public void studentCjd(int student_id, HttpServletResponse response) throws IOException, SQLException, ParseException {
        String sql = "SELECT" +
                " IFnull(dd.departments_name,'空'), " +
                " IFnull(m.major_name,'空'), " +
                " IFnull(cg.class_name,'空'), " +
                " IFnull(sb.student_number,'空'), " +
                " IFnull(sb.stuname,'空'), " +
                " IFnull(sb.sex,'空'), " +
                " IFnull(sb.idcard,'空'), " +
                " IFnull(sb.birth,'空'), " +
                " IFnull(sb.start_date,'空'), " +
                " IFnull(sb.graduation_date,'空')," +
                " IFnull(sb.number,'空'), " +
                " IFnull(sb.candidate_number,'空')" +
                " FROM " +
                " student_basic sb" +
                " LEFT JOIN major m ON sb.major = m.id " +
                " LEFT JOIN dict_departments dd on dd.id = m.departments_id" +
                " LEFT JOIN class_grade cg on cg.classroom_id and cg.id = sb.classroomid" +
                " WHERE 1=1 ";

        String sql1 = " SELECT" +
                " IFnull(tv.semester,'空')," +
                " IFnull(course.course_name,'空')," +
                " IFnull(tv.course_nature_id,'空'),  " +
                " IFnull(tv.semester_hours,'空')," +
                " IFnull(tv.credits_term, 0)," +
                " IFnull(gs.final_exam_grade,'空')," +
                " IFnull(tv.assessment_id, 0), " +
                " IFnull(gs.totel_grade, 0)  " +
                " FROM" +
                " teaching_task_view AS tv" +
                " INNER JOIN dict_courses AS course ON tv.course_id = course.id" +
                " INNER JOIN student_basic AS sb " +
                " INNER JOIN exam_plan AS ep ON tv.id = ep.teaching_task_id" +
                " INNER JOIN grade_student AS gs ON ep.id = gs.exam_plan_id AND gs.student_id = sb.id" +
                " WHERE 1=1 AND ep.check_state = 2 ";


        String student_id_str = String.valueOf(student_id);
        if (student_id_str != null && student_id_str.length() != 0) {
            sql += " and sb.id = " + student_id + "";
            sql1 += "and sb.id = " + student_id + "";
        } else {

        }
        System.out.println("学生成绩sql--"+sql);
        System.out.println("学生成绩sql--"+sql1);

        List<Map<String, Object>> xscjk = DBHelper.getReader().doQuery(sql, new Object[0],
                DBHelper.keyAndTypes("departments_name", STRING, "major_name", STRING,
                        "class_name", STRING, "student_number", STRING,
                        "stuname", STRING, "sex", STRING, "idcard", STRING, "birth", STRING, "start_date", STRING, "graduation_date", STRING
                        , "number", STRING, "candidate_number", STRING));
        List<Map<String, Object>> xscjkList = DBHelper.getReader().doQuery(sql1, new Object[0],
                DBHelper.keyAndTypes("semester", STRING, "course_name", STRING,
                        "course_nature_id", STRING, "semester_hours", STRING,
                        "credits_term", STRING,
                        "final_exam_grade", STRING,
                        "assessment_id", STRING,
                        "totel_grade", STRING));

        TemplateExportParams params = new TemplateExportParams(address + "temp.xls");
        Map<String, Object> map = new HashMap<String, Object>();
        List<Map<String, String>> listMap = new ArrayList<Map<String, String>>();
        List<Map<String, String>> listMap1 = new ArrayList<Map<String, String>>();
        if (xscjk.size() != 0) {
            Map<String, Object> xscjkMap = xscjk.get(0);
            String departments_name = xscjkMap.get("departments_name").toString();
            String major_name = xscjkMap.get("major_name").toString();
            String class_name = xscjkMap.get("class_name").toString();
            String student_number = xscjkMap.get("student_number").toString();
            String stuname = xscjkMap.get("stuname").toString();
            String sex = xscjkMap.get("sex").toString();
            String idcard = xscjkMap.get("idcard").toString();
            String birth = xscjkMap.get("birth").toString();
            SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
            String start_date = xscjkMap.get("start_date").toString();
            String graduation_date = xscjkMap.get("graduation_date").toString();
            String number = xscjkMap.get("number").toString();
            String candidate_number = xscjkMap.get("candidate_number").toString();
            int zxf = 0;
            int bxxf = 0;
            int xxxf = 0;
            for (int i = 0; i < xscjkList.size(); i++) {
                Map<String, Object> xscjkList1 = xscjkList.get(i);
                int credits_term = Integer.valueOf(xscjkList1.get("credits_term").toString()); //学分
                int course_nature_id = Integer.valueOf(xscjkList1.get("course_nature_id").toString()); ///*1--必修  2--限选 3--任选  4--选修*/
                zxf = zxf + credits_term;
                if (course_nature_id == 1) {
                    bxxf = bxxf + credits_term;
                } else if (course_nature_id == 4) {
                    xxxf = xxxf + credits_term;
                }

            }
            map.put("yx", departments_name);
            map.put("zy", major_name);
            map.put("bj", class_name);
            map.put("xh", student_number);
            map.put("xm", stuname);
            map.put("xb", sex);
            map.put("sfzh", idcard);
            map.put("csny", birth);
            map.put("rxsj", start_date);
            map.put("bysj", graduation_date);
            map.put("byzh", number);
            map.put("xwzh", candidate_number);
            map.put("bylw", " ");
            map.put("cj", " ");
            map.put("zxf", zxf);
            map.put("bxxf", bxxf);
            map.put("xxxf", xxxf);
            SimpleDateFormat sDateFormat=new SimpleDateFormat("yyyy年MM月dd日");
            map.put("date", sDateFormat.format(new Date()));



            for (int i = 0; i < (xscjkList.size()); i++) {
                Map<String, String> lm = new HashMap<String, String>();//存入数据的map
                if (i<=xscjkList.size()){
                    Map<String, Object> xscjkListMap = xscjkList.get(i);
                    String semester = xscjkListMap.get("semester").toString();
                    String course_name = xscjkListMap.get("course_name").toString();
                    String course_nature_id = xscjkListMap.get("course_nature_id").toString();
                    String semester_hours = xscjkListMap.get("semester_hours").toString();
                    String credits_term = xscjkListMap.get("credits_term").toString();
                    String final_exam_grade = xscjkListMap.get("final_exam_grade").toString();
                    String assessment_id = xscjkListMap.get("assessment_id").toString();
                    String totel_grade = xscjkListMap.get("totel_grade").toString();
                    totel_grade = s_d(totel_grade);
                    //如果是考查课总成绩应该用等级方式assessment_id = 2 为考察
                    if ("1".equals(assessment_id)){
                        if (totel_grade != null && totel_grade != ""){
                            double totel_grade_int = Double.parseDouble(totel_grade);
                            if (totel_grade_int < 60){
                                totel_grade = "不及格";
                            }
                            if (totel_grade_int >= 60 && totel_grade_int < 70  ){
                                totel_grade = "及格";
                            }
                            if (totel_grade_int >= 70 && totel_grade_int < 80  ){
                                totel_grade = "中等";
                            }
                            if (totel_grade_int >= 80 && totel_grade_int < 90  ){
                                totel_grade = "良好";
                            }
                            if (totel_grade_int >= 90 && totel_grade_int < 100  ){
                                totel_grade = "优秀";
                            }
                        }

                    }
                    switch (Integer.valueOf(course_nature_id)) {
                        case 1:
                            course_nature_id = "必修";
                            break;
                        case 2:
                            course_nature_id = "限选";
                            break;
                        case 3:
                            course_nature_id = "任选";
                            break;
                        case 4:
                            course_nature_id = "选修";
                            break;
                    }
                    lm.put("xq", semester);
                    lm.put("kc", course_name);
                    lm.put("xz", course_nature_id);
                    lm.put("xs", semester_hours);
                    lm.put("xf", credits_term);
                    if (final_exam_grade != null && final_exam_grade != "") {
                        double cj = Double.parseDouble(final_exam_grade);
                       // Integer cj = Integer.valueOf(final_exam_grade);
                        if (cj < 60.0) {
                            final_exam_grade = "不及格";
                        }
                        if (cj >= 60.0 && cj >= 79.0) {
                            final_exam_grade = "及格";
                        }
                        if (cj >= 79.0 && cj >= 80.0) {
                            final_exam_grade = "良好";
                        }
                        if (cj >= 90.0 && cj >= 100.0) {
                            final_exam_grade = "优秀";
                        }
                    }
                    lm.put("cj", totel_grade);
                }
                if (i+1<xscjkList.size()){
                        Map<String, Object> xscjkListMap = xscjkList.get(i+1);
                        String semester = xscjkListMap.get("semester").toString();
                        String course_name = xscjkListMap.get("course_name").toString();
                        String course_nature_id = xscjkListMap.get("course_nature_id").toString();
                        String semester_hours = xscjkListMap.get("semester_hours").toString();
                        String credits_term = xscjkListMap.get("credits_term").toString();
                        String final_exam_grade = xscjkListMap.get("final_exam_grade").toString();
                        String assessment_id = xscjkListMap.get("assessment_id").toString();
                        String totel_grade = xscjkListMap.get("totel_grade").toString();
                        totel_grade = s_d(totel_grade);
                    //如果是考查课总成绩应该用等级方式assessment_id = 2 为考察
                    if ("1".equals(assessment_id)){
                        if (totel_grade != null && totel_grade != ""){
                            double totel_grade_int = Double.parseDouble(totel_grade);
                            if (totel_grade_int < 60){
                                totel_grade = "不及格";
                            }
                            if (totel_grade_int >= 60 && totel_grade_int < 70  ){
                                totel_grade = "及格";
                            }
                            if (totel_grade_int >= 70 && totel_grade_int < 80  ){
                                totel_grade = "中等";
                            }
                            if (totel_grade_int >= 80 && totel_grade_int < 90  ){
                                totel_grade = "良好";
                            }
                            if (totel_grade_int >= 90 && totel_grade_int < 100  ){
                                totel_grade = "优秀";
                            }
                        }

                    }
                        switch (Integer.valueOf(course_nature_id)) {
                            case 1:
                                course_nature_id = "必修";
                                break;
                            case 2:
                                course_nature_id = "限选";
                                break;
                            case 3:
                                course_nature_id = "任选";
                                break;
                            case 4:
                                course_nature_id = "选修";
                                break;
                        }
                        lm.put("xq1", semester);
                        lm.put("kc1", course_name);
                        lm.put("xz1", course_nature_id);
                        lm.put("xs1", semester_hours);
                        lm.put("xf1", credits_term);
                        if (final_exam_grade != null && final_exam_grade != "") {
                            double cj = Double.parseDouble(final_exam_grade);
                           // Integer cj = Integer.valueOf(final_exam_grade);
                            if (cj < 60) {
                                final_exam_grade = "不及格";
                            }
                            if (cj >= 60 && cj >= 79) {
                                final_exam_grade = "及格";
                            }
                            if (cj >= 79 && cj >= 80) {
                                final_exam_grade = "良好";
                            }
                            if (cj >= 90 && cj >= 100) {
                                final_exam_grade = "优秀";
                            }
                        }
                        lm.put("cj1",  totel_grade);
                    i=i+1;

                }
                    listMap.add(lm);

           }
            map.put("maplist", listMap);
        }

        Workbook workbook = ExcelExportUtil.exportExcel(params, map);
        File savefile = new File(address);
        if (!savefile.exists()) {
            savefile.mkdirs();
        }
        FileOutputStream fos = new FileOutputStream(address + "黑龙江司法警官职业学院学生成绩单.xls");
        workbook.write(fos);
        fos.close();

        //读取要下载的文件
        File f = new File(address + "黑龙江司法警官职业学院学生成绩单.xls");
        if (f.exists()) {
            FileInputStream fis = new FileInputStream(f);
            String filename = URLEncoder.encode(f.getName(), "utf-8"); //解决中文文件名下载后乱码的问题
            byte[] b = new byte[fis.available()];
            fis.read(b);
            response.setCharacterEncoding("utf-8");
            response.setHeader("Content-Disposition", "attachment; filename=" + filename + "");
            //获取响应报文输出流对象
            ServletOutputStream out = response.getOutputStream();
            //输出
            out.write(b);
            out.flush();
            out.close();
        }

    }




}
