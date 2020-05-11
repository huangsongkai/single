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
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import static v1.grade.DBHelper.ResultType.STRING;


public class CourseCjd extends HttpServlet {
    public CourseCjd() {
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
        System.out.println("************************进入了课程成绩查询");
        String path = request.getSession().getServletContext().getRealPath("/");//获取tomcat根目录
        address = path;
        System.out.println("项目路径------------------"+path);
        String exam_plan_id = request.getParameter("exam_plan_id");
        try {
            courseCjd(exam_plan_id, response);
        } catch (SQLException e) {
            e.printStackTrace();
        }

        }

    public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("进入了统计dopost");
        String path = request.getSession().getServletContext().getRealPath("/");//获取tomcat根目录
        address = path;
        System.out.println("项目路径------------------"+path);
    }
    public String s_d(String s){
        if (StringUtils.isNotBlank(s) && isNumeric(s)){
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




    /**
     * https://blog.csdn.net/qiunian144084/article/details/78226314
     * 课程成绩单导出Excel
     */
    public void courseCjd(String exam_plan_id, HttpServletResponse response) throws IOException, SQLException {
        //查询数据
        String sql1 = " SELECT" +
                " sb.student_number," +
                " sb.stuname," +
                " gs.regular_grade," +
                " gs.midterm_grade," +
                " gs.final_exam_grade," +
                " gs.totel_grade," +
                " gs.exam_state " +       //这一项  0-6 分别对应 正常考试, 免修,学分互认,缓考,旷考,舞弊,其它
                " FROM" +
                " exam_plan AS ep" +
                " INNER JOIN grade_student AS gs ON ep.id = gs.exam_plan_id" +
                " INNER JOIN student_basic AS sb ON sb.id = gs.student_id" +
                " WHERE 1=1  ";

        String sql2 = " SELECT" +
                " course.course_code," +
                " course.course_name," +
                " tb.teacher_name," +
                " cv.class_name," +
                " tv.semester," +
                " tv.assessment_id,  " +
                " tv.course_nature_id,  " +
                " course.course_system_name," +
                " tv.credits_term," +
                " tv.semester_hours," +
                " ep.regular_per," +
                " ep.medium_per," +
                " ep.finalexam_per" +
                " FROM" +
                " exam_plan AS ep" +
                " INNER JOIN teaching_task_view AS tv ON ep.teaching_task_id = tv.id" +
                " INNER JOIN dict_courses AS course ON tv.course_id = course.id" +
                " INNER JOIN teacher_basic AS tb ON tv.teacher_id = tb.id" +
                " INNER JOIN class_view AS cv ON tv.class_id = cv.id" +
                " INNER JOIN teaching_task AS tt ON ep.teaching_task_id = tt.id" +
                " WHERE 1=1 " +
                " and ep.id = " + exam_plan_id + "";
        String sql3 = "SELECT" +
                " SUM(CASE WHEN gs.exam_state in (1,2) THEN 0 ELSE 1 END) as yk," +
                " SUM(CASE WHEN gs.exam_state in (3,4) THEN 1 ELSE 0 END) as qk," +
                " SUM(CASE WHEN gs.totel_grade>=90 THEN 1 ELSE 0 END) as d1," +
                " SUM(CASE WHEN gs.totel_grade>=80 AND gs.totel_grade <90 THEN 1 ELSE 0 END) as d2," +
                " SUM(CASE WHEN gs.totel_grade>=70 AND gs.totel_grade <80 THEN 1 ELSE 0 END) as d3," +
                " SUM(CASE WHEN gs.totel_grade>=60 AND gs.totel_grade <70 THEN 1 ELSE 0 END) as d4," +
                " SUM(CASE WHEN gs.totel_grade <60 THEN 1 ELSE 0 END) as d5," +
                " round(AVG(gs.totel_grade),2) AS pjf" +
                " FROM" +
                " exam_plan AS ep" +
                " INNER JOIN grade_student AS gs ON ep.id = gs.exam_plan_id" +
                " WHERE 1=1 ";

        String sql4 = " SELECT" +
                " sb.student_number AS student_number1," +
                " sb.stuname AS stuname1," +
                " gs.regular_grade AS regular_grade1," +
                " gs.midterm_grade AS midterm_grade1," +
                " gs.final_exam_grade AS final_exam_grade1," +
                " gs.totel_grade < 60 AS totel_grade1," +
                " tt.assessment_id  in (5,4)  AS exam_state1" +       //这一项  0-6 分别对应 正常考试, 免修,学分互认,缓考,旷考,舞弊,其它
                " FROM" +
                " exam_plan AS ep" +
                " INNER JOIN grade_student AS gs ON ep.id = gs.exam_plan_id" +
                " INNER JOIN student_basic AS sb ON sb.id = gs.student_id" +
                " INNER JOIN teaching_task AS tt ON ep.teaching_task_id = tt.id" +
                " WHERE 1=1 " +
                " and ep.id = " + exam_plan_id + "";
        if (exam_plan_id != null && exam_plan_id.length() != 0) {
            sql1 += " and ep.id = " + exam_plan_id + "" +
                    " ORDER BY sb.student_number ";
            sql2 += " and ep.id = " + exam_plan_id + "";
            sql3 += " and ep.id = " + exam_plan_id + "";
            sql4 += " and ep.id = " + exam_plan_id + "" +
                    " ORDER BY sb.student_number ";
        } else {
            sql1 += " ORDER BY sb.student_number ";
            sql4 += " ORDER BY sb.student_number ";
        }

        System.out.println(sql1);
        List<Map<String, Object>> cjd = DBHelper.getReader().doQuery(sql1, new Object[0],
                DBHelper.keyAndTypes("student_number", STRING, "stuname", STRING,
                        "regular_grade", STRING, "midterm_grade", STRING,
                        "final_exam_grade", STRING, "totel_grade", STRING, "exam_state", STRING));
        List<Map<String, Object>> cjdt = DBHelper.getReader().doQuery(sql2, new Object[0],
                DBHelper.keyAndTypes("course_code", STRING, "course_name", STRING,
                        "teacher_name", STRING, "class_name", STRING,
                        "semester", STRING, "assessment_id", STRING, "course_nature_id", STRING
                        , "course_system_name", STRING, "credits_term", STRING, "semester_hours", STRING
                        , "regular_per", STRING, "medium_per", STRING, "finalexam_per", STRING));
        List<Map<String, String>> listMap = new ArrayList<Map<String, String>>();
        List<Map<String, String>> listMap1 = new ArrayList<Map<String, String>>();
        Map<String, Object> map = new HashMap<String, Object>();
        TemplateExportParams params = new TemplateExportParams(address + "kccjd.xls");
        if (cjdt.size()!=0){
        Map<String, Object> cjdtMap = cjdt.get(0);
        String course_code = cjdtMap.get("course_code").toString();
        String course_name = cjdtMap.get("course_name").toString();
        String teacher_name = cjdtMap.get("teacher_name").toString();
        String class_name = cjdtMap.get("class_name").toString();
        String semester = cjdtMap.get("semester").toString();
        String assessment_id = cjdtMap.get("assessment_id").toString();
        String course_nature_id = cjdtMap.get("course_nature_id").toString();
        String course_system_name = cjdtMap.get("course_system_name").toString();
        String credits_term = cjdtMap.get("credits_term").toString();
        String semester_hours = cjdtMap.get("semester_hours").toString();
        String regular_per = cjdtMap.get("regular_per").toString();
        String medium_per = cjdtMap.get("medium_per").toString();
        String finalexam_per = cjdtMap.get("finalexam_per").toString();
        switch (Integer.valueOf(assessment_id)) {
            case 1:
                assessment_id = "考查";
                break;
            case 2:
                assessment_id = "考试";
                break;
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
        List<Map<String, Object>> cjfxd = DBHelper.getReader().doQuery(sql3, new Object[0],
                DBHelper.keyAndTypes("yk", STRING, "qk", STRING,
                        "d1", STRING, "d2", STRING,
                        "d3", STRING, "d4", STRING, "d5", STRING, "pjf", STRING));

        Map<String, Object> cjfxdMap = cjfxd.get(0);
        String yk = cjfxdMap.get("yk").toString();
        String qk = cjfxdMap.get("qk").toString();
        String d1 = cjfxdMap.get("d1").toString();
        String d2 = cjfxdMap.get("d2").toString();
        String d3 = cjfxdMap.get("d3").toString();
        String d4 = cjfxdMap.get("d4").toString();
        String d5 = cjfxdMap.get("d5").toString();
        String pjf = cjfxdMap.get("pjf").toString();
        List<Map<String, Object>> cjdxdbjg = DBHelper.getReader().doQuery(sql4, new Object[0],
                DBHelper.keyAndTypes("student_number1", STRING, "stuname1", STRING,
                        "regular_grade1", STRING, "midterm_grade1", STRING,
                        "final_exam_grade1", STRING, "totel_grade1", STRING, "exam_state1", STRING));


        map.put("kcbm", course_code);
        map.put("kcmc", course_name);
        map.put("rkjs", teacher_name);
        map.put("skbj", class_name);
        map.put("kkxq", semester);
        map.put("khfs", assessment_id);
        map.put("kcxz", course_nature_id);
        map.put("kclb", course_system_name);
        map.put("xf", credits_term);
        map.put("xs", semester_hours);
        map.put("zb1", s_d(regular_per));
        map.put("zb2", s_d(medium_per));
        map.put("zb3", s_d(finalexam_per));
        map.put("ykrs", s_d(yk));
        map.put("qkrs",s_d( qk));
        map.put("fs1", s_d(d1));
        map.put("fs2", s_d(d2));
        map.put("fs3", s_d(d3));
        map.put("fs4", s_d(d4));
        map.put("fs5", s_d(d5));
        map.put("pjf", s_d(pjf));


        for (int i = 0; i < (cjd.size()); i++) {
            Map<String, String> lm = new HashMap<String, String>();//存入数据的map
            if (i<=cjd.size()){
                Map<String, Object> cjdMap = cjd.get(i);
                String student_number = cjdMap.get("student_number").toString();
                String stuname = cjdMap.get("stuname").toString();
                String regular_grade = cjdMap.get("regular_grade").toString();
                String midterm_grade = cjdMap.get("midterm_grade").toString();
                String final_exam_grade = cjdMap.get("final_exam_grade").toString();
                String totel_grade = cjdMap.get("totel_grade").toString();
                //如果是考查课总成绩应该用等级方式assessment_id = 2 为考察
                if ("考查".equals(assessment_id)){
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
                String exam_state = cjdMap.get("exam_state").toString();
                switch (Integer.valueOf(exam_state)) {
                    case 0:
                        exam_state = " ";
                        break;
                    case 1:
                        exam_state = "免修";
                        break;
                    case 2:
                        exam_state = "缓考";
                        break;
                    case 3:
                        exam_state = "旷考";
                        break;
                    case 4:
                        exam_state = "舞弊";
                        break;
                    case 5:
                        exam_state = "其它";
                        break;
                }
                lm.put("xh", student_number);
                lm.put("name", stuname);
                lm.put("ps", s_d(regular_grade));
                lm.put("qz", s_d(midterm_grade));
                lm.put("qm", s_d(final_exam_grade));
                lm.put("zcj", s_d(totel_grade));
                lm.put("bz", exam_state);
            }
            if (i+1 < cjd.size()){
                Map<String, Object> cjdMap = cjd.get(i+1);
                String student_number = cjdMap.get("student_number").toString();
                String stuname = cjdMap.get("stuname").toString();
                String regular_grade = cjdMap.get("regular_grade").toString();
                String midterm_grade = cjdMap.get("midterm_grade").toString();
                String final_exam_grade = cjdMap.get("final_exam_grade").toString();
                String totel_grade = cjdMap.get("totel_grade").toString();
                //如果是考查课总成绩应该用等级方式assessment_id = 2 为考察
                if ("考查".equals(assessment_id)){
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

                String exam_state = cjdMap.get("exam_state").toString();
                switch (Integer.valueOf(exam_state)) {
                    case 0:
                        exam_state = "";
                        break;
                    case 1:
                        exam_state = "免修";
                        break;
                    case 2:
                        exam_state = "缓考";
                        break;
                    case 3:
                        exam_state = "旷考";
                        break;
                    case 4:
                        exam_state = "舞弊";
                        break;
                    case 5:
                        exam_state = "其它";
                        break;
                }
                lm.put("xh1", student_number);
                lm.put("name1", stuname);
                lm.put("ps1", s_d(regular_grade));
                lm.put("qz1",s_d( midterm_grade));
                lm.put("qm1", s_d(final_exam_grade));
                lm.put("zcj1",s_d( totel_grade));
                lm.put("bz1", exam_state);
                i=i+1;
            }
            //判断换列
                listMap.add(lm);

        }
        map.put("maplist", listMap);
      }
        Workbook workbook = ExcelExportUtil.exportExcel(params, map);
        File savefile = new File(address);
        if (!savefile.exists()) {
            savefile.mkdirs();
        }
        FileOutputStream fos = new FileOutputStream(address + "黑龙江司法警官职业学院课程成绩单.xls");
        workbook.write(fos);
        fos.close();

        //读取要下载的文件
        File f = new File(address+"黑龙江司法警官职业学院课程成绩单.xls");
        if(f.exists()){
            FileInputStream fis = new FileInputStream(f);
            String filename= URLEncoder.encode(f.getName(),"utf-8"); //解决中文文件名下载后乱码的问题
            byte[] b = new byte[fis.available()];
            fis.read(b);
            response.setCharacterEncoding("utf-8");

            response.setHeader("Content-Disposition","attachment; filename="+filename+"");
            //获取响应报文输出流对象
            ServletOutputStream out =response.getOutputStream();
            //输出
            out.write(b);
            out.flush();
            out.close();
        }
    }


}
