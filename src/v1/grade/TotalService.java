package v1.grade;


import net.sf.json.JSONObject;
import org.apache.commons.lang3.BooleanUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.poifs.filesystem.POIFSFileSystem;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.xssf.streaming.SXSSFWorkbook;

import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.*;
import java.net.URLEncoder;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import static v1.grade.DBHelper.ResultType.STRING;


public class TotalService extends HttpServlet {
    public TotalService() {
        super();
    }

    public void destroy() {
        super.destroy(); // Just puts "destroy" string in log

    }

    /**
     * api 接口总入口 接受变量引导
     */
    String address ="/Users/huang/work/ceshi/";

    public void doGet(HttpServletRequest request, HttpServletResponse response, String exam_plan_id , int student_class_id, String semester,  int student_id) throws ServletException, IOException, SQLException {
        System.out.println("进入了统计doget");
        String path = request.getSession().getServletContext().getRealPath("/");//获取tomcat根目录
        address = path;
        System.out.println("项目路径------------------"+path);
        //根据变量进行入口调整
        if(exam_plan_id != null && exam_plan_id.length() != 0){
            outputExcel(exam_plan_id, response);
        }

        String student_class_id_str = String.valueOf(student_class_id);
        if(student_class_id_str != null && student_class_id_str.length() != 0 && semester != null && semester.length() != 0 ){
            outputExcel1(semester, student_class_id, response);
        }

        String student_id_str = String.valueOf(student_id);
        if(student_id_str != null && student_id_str.length() != 0 ){
            outputExcel2( student_id, response);
        }

        outputExcel3(response);

//
    }

    public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("进入了统计dopost");
        String path = request.getSession().getServletContext().getRealPath("/");//获取tomcat根目录
        address = path;
        System.out.println("项目路径------------------"+path);
    }




    public static void tongji(String jsonString) {
        System.out.println("进入统计了统计");
    }

    /**
     * https://blog.csdn.net/qiunian144084/article/details/78226314
     * 课程成绩单导出Excel
     */
    public void outputExcel(String exam_plan_id, HttpServletResponse response) throws IOException, SQLException {
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
                " WHERE ep.id = "+exam_plan_id+"" +
                " ORDER BY sb.student_number ";
        System.out.println(sql1);
        List<Map<String, Object>> cjd = DBHelper.getReader().doQuery(sql1, new Object[0],
                DBHelper.keyAndTypes("student_number", STRING, "stuname", STRING,
                        "regular_grade", STRING, "midterm_grade", STRING,
                        "final_exam_grade", STRING, "totel_grade", STRING, "exam_state", STRING));
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
                " WHERE" +
                " ep.id = "+exam_plan_id+"";
        List<Map<String, Object>> cjdt = DBHelper.getReader().doQuery(sql2, new Object[0],
                DBHelper.keyAndTypes("course_code", STRING, "course_name", STRING,
                        "teacher_name", STRING, "class_name", STRING,
                        "semester", STRING, "assessment_id", STRING, "course_nature_id", STRING
                        , "course_system_name", STRING, "credits_term", STRING, "semester_hours", STRING
                        , "regular_per", STRING, "medium_per", STRING, "finalexam_per", STRING));

        Map<String, Object> cjdtMap= cjdt.get(0);
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
        switch(Integer.valueOf(assessment_id)){
            case 1:
                assessment_id = "考试";
                break;
            case 2:
                assessment_id = "考察";
                break;
        }
        switch(Integer.valueOf(course_nature_id)){
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
        String sql3 = "SELECT" +
                " SUM(CASE WHEN gs.exam_state in (1,2) THEN 0 ELSE 1 END) as yk," +
                " SUM(CASE WHEN gs.exam_state in (3,4) THEN 1 ELSE 0 END) as qk," +
                " SUM(CASE WHEN gs.totel_grade>=90 THEN 1 ELSE 0 END) as d1," +
                " SUM(CASE WHEN gs.totel_grade>=80 AND gs.totel_grade <90 THEN 1 ELSE 0 END) as d2," +
                " SUM(CASE WHEN gs.totel_grade>=70 AND gs.totel_grade <80 THEN 1 ELSE 0 END) as d3," +
                " SUM(CASE WHEN gs.totel_grade>=60 AND gs.totel_grade <70 THEN 1 ELSE 0 END) as d4," +
                " SUM(CASE WHEN gs.totel_grade <60 THEN 1 ELSE 0 END) as d5," +
                " AVG(gs.totel_grade) AS pjf" +
                " FROM" +
                " exam_plan AS ep" +
                " INNER JOIN grade_student AS gs ON ep.id = gs.exam_plan_id" +
                " WHERE ep.id = "+exam_plan_id+"";
        List<Map<String, Object>> cjfxd = DBHelper.getReader().doQuery(sql3, new Object[0],
                DBHelper.keyAndTypes("yk", STRING, "qk", STRING,
                        "d1", STRING, "d2", STRING,
                        "d3", STRING, "d4", STRING, "d5", STRING, "pjf", STRING));

        String sql4 = " SELECT" +
                " sb.student_number AS student_number1," +
                " sb.stuname AS stuname1," +
                " gs.regular_grade AS regular_grade1," +
                " gs.midterm_grade AS midterm_grade1," +
                " gs.final_exam_grade AS final_exam_grade1," +
                " gs.totel_grade < 60 AS totel_grade1," +
                " gs.exam_state in (5,4)  AS exam_state1" +       //这一项  0-6 分别对应 正常考试, 免修,学分互认,缓考,旷考,舞弊,其它
                " FROM" +
                " exam_plan AS ep" +
                " INNER JOIN grade_student AS gs ON ep.id = gs.exam_plan_id" +
                " INNER JOIN student_basic AS sb ON sb.id = gs.student_id" +
                " WHERE ep.id = "+exam_plan_id+"" +
                " ORDER BY sb.student_number ";
        List<Map<String, Object>> cjdxdbjg = DBHelper.getReader().doQuery(sql4, new Object[0],
                DBHelper.keyAndTypes("student_number1", STRING, "stuname1", STRING,
                        "regular_grade1", STRING, "midterm_grade1", STRING,
                        "final_exam_grade1", STRING, "totel_grade1", STRING, "exam_state1", STRING));



        SXSSFWorkbook workbook = new SXSSFWorkbook(50);
        Sheet sheet = workbook.createSheet("课程成绩单");
        ExcelUtil1 excelUtil = new ExcelUtil1(workbook, sheet);
        //设计单元格样式
        CellStyle bodyStyle = excelUtil.getBodyStyle();
        //合并单元格
        //参数1：起始行 参数2：终止行 参数3：起始列 参数4：终止列
        CellRangeAddress region1 = new CellRangeAddress(0, 0, (short) 0, (short) 8);
        CellRangeAddress region2 = new CellRangeAddress(1, 1, (short) 0, (short) 8);
        CellRangeAddress region3 = new CellRangeAddress(2, 2, (short) 0, (short) 8);
        sheet.addMergedRegion(region1);
        sheet.addMergedRegion(region2);
        sheet.addMergedRegion(region3);

        Cell cell = null;;
        Row row = null;

        // 构建表头第一行
        Row headRow = sheet.createRow(0);
        //标题样式
        // 创建单元格样式
        cell = headRow.createCell(0);
        cell.setCellStyle(excelUtil.getTitle());
        cell.setCellValue("黑龙江司法警官职业学院课程成绩单");

        // 构建表头第二行
        Row bodyRow = sheet.createRow(1);
        cell = bodyRow.createCell(0);
        cell.setCellStyle(excelUtil.getHeadStyle());
        cell.setCellValue("课程编码:"+course_code+" 课程名称:"+course_name+" 任课教师:"+teacher_name+" 上课班级:"+class_name+"");

        // 构建表头第三行
        Row bodyRow2 = sheet.createRow(2);
        cell = bodyRow2.createCell(0);
        cell.setCellStyle(excelUtil.getTitle());
        cell.setCellValue("开课日期:"+semester+" 考核方式:"+assessment_id+" 课程性质:"+course_nature_id+" 课程类别:"+course_system_name+" 学分:"+credits_term+" 学时:"+semester_hours+"");
        //内容 第四行
        Row bodyRow3 = sheet.createRow(3);
        String[] titles={"学生学号", "学生姓名", "平时", "期中", "期末", "总成绩", "标志"};
        for (int j = 0; j < 7; j++) {
            cell = bodyRow3.createCell(j);
            cell.setCellStyle(excelUtil.getBodyStyle());
            cell.setCellValue(titles[j]);
        }

        //内容主体
        int row_total = 0+4;//表行数
        int total = cjd.size();//测试 总数据条数



        for (int i = 0; i < cjd.size(); i++) {
            Map<String, Object> cjdMap = cjd.get(i);
            String student_number = cjdMap.get("student_number").toString();
            String stuname = cjdMap.get("stuname").toString();
            String regular_grade = cjdMap.get("regular_grade").toString();
            String midterm_grade = cjdMap.get("midterm_grade").toString();
            String final_exam_grade = cjdMap.get("final_exam_grade").toString();
            String totel_grade = cjdMap.get("totel_grade").toString();
            String exam_state = cjdMap.get("exam_state").toString();
            switch(Integer.valueOf(exam_state)){
                case 0:
                    exam_state = "正常考试";
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

            row = sheet.createRow(i+4);
            String[] titles1={student_number, stuname, regular_grade, midterm_grade, final_exam_grade, totel_grade, exam_state};//在这里插入数据
            for (int j = 0; j < titles1.length; j++) {
                cell = row.createCell(j);
                cell.setCellStyle(excelUtil.getBodyStyle());
                cell.setCellValue(titles1[j]);
            }
        }
        //内容第四部分
        //合并单元格
        //参数1：起始行 参数2：终止行 参数3：起始列 参数4：终止列
        CellRangeAddress region5 = new CellRangeAddress(total+4+1, total+4+1, (short) 0, (short) 8);
        sheet.addMergedRegion(region5);
        Row bodyRow4 = sheet.createRow(total+4+1);
        cell = bodyRow4.createCell(0);
        cell.setCellValue("各档成绩百分比: 平时成绩占"+regular_per+"%; 期中成绩占"+medium_per+"%; 期末成绩占"+finalexam_per+"%;");

        //插入页脚
        Footer footer = sheet.getFooter();
        footer.setRight("任课教师:_____________ 教研室主任：___________ 系(部)主任:____________ 教务处处长:____________ ");


        //-----------------------sheet2成绩分析单-------------------------------------------------------------


        Sheet sheet2 = workbook.createSheet("成绩分析单");
        ExcelUtil1 excelUtil1 = new ExcelUtil1(workbook, sheet2);
        //设计单元格样式
        CellStyle bodyStyle1 = excelUtil.getBodyStyle();
        //合并单元格
        //参数1：起始行 参数2：终止行 参数3：起始列 参数4：终止列
        CellRangeAddress region21 = new CellRangeAddress(0, 0, (short) 0, (short) 8);
        CellRangeAddress region22 = new CellRangeAddress(1, 1, (short) 0, (short) 8);
        CellRangeAddress region23 = new CellRangeAddress(2, 2, (short) 0, (short) 8);
        CellRangeAddress region24 = new CellRangeAddress(3, 3, (short) 0, (short) 8);
        sheet2.addMergedRegion(region21);
        sheet2.addMergedRegion(region22);
        sheet2.addMergedRegion(region23);
        sheet2.addMergedRegion(region24);

        Cell cell2 = null;
        Row row2 = null;

        // 构建表头第一行
        Row headRow2 = sheet2.createRow(0);
        cell = headRow2.createCell(0);
        cell.setCellStyle(excelUtil.getTitle());
        cell.setCellValue("黑龙江司法警官职业学院成绩分析单");
        // 构建表头第二行
        Row bodyRow21 = sheet2.createRow(1);
        cell = bodyRow21.createCell(0);
        cell.setCellStyle(excelUtil.getHeadStyle());
        cell.setCellValue("课程编码:"+course_code+" 课程名称:"+course_name+" 任课教师:"+teacher_name+" 上课班级:"+class_name+"");

        // 构建表头第三行
        Row bodyRow22 = sheet2.createRow(2);
        cell = bodyRow22.createCell(0);
        cell.setCellStyle(excelUtil.getHeadStyle());
        cell.setCellValue("开课日期:"+semester+" 考核方式:"+assessment_id+" 课程性质:"+course_nature_id+" 课程类别:"+course_system_name+" 学分:"+credits_term+" 学时:"+semester_hours+"");
        // 构建表头第四行
        Row bodyRow23 = sheet2.createRow(3);
        cell = bodyRow23.createCell(0);
        cell.setCellStyle(excelUtil.getHeadStyle());
        cell.setCellValue("一、不及格、舞弊、缺考名单");
        // 构建表头第五行
        Row bodyRow24 = sheet2.createRow(4);
        String[] titles3={"学生学号", "学生姓名", "平时", "期中", "期末", "总成绩", "标志"};
        for (int j = 0; j < 7; j++) {
            cell = bodyRow24.createCell(j);
            cell.setCellStyle(excelUtil.getBodyStyle());
            cell.setCellValue(titles[j]);
        }
        // 构建表头第六行
        int row_total1 = 0+4;//表行数
        int total1 = cjdxdbjg.size();//测试 总数据条数
        for (int i = 0; i < cjdxdbjg.size(); i++) {
            Map<String, Object> cjdxdbjgMap = cjdxdbjg.get(i);
            String student_number1 = cjdxdbjgMap.get("student_number1").toString();
            String stuname1 = cjdxdbjgMap.get("stuname1").toString();
            String regular_grade1 = cjdxdbjgMap.get("regular_grade1").toString();
            String midterm_grade1 = cjdxdbjgMap.get("midterm_grade1").toString();
            String final_exam_grade1 = cjdxdbjgMap.get("final_exam_grade1").toString();
            String totel_grade1 = cjdxdbjgMap.get("totel_grade1").toString();
            String exam_state1 = cjdxdbjgMap.get("exam_state1").toString();
            switch(Integer.valueOf(exam_state1)){
                case 0:
                    exam_state1 = "正常考试";
                    break;
                case 1:
                    exam_state1 = "免修";
                    break;
                case 2:
                    exam_state1 = "缓考";
                    break;
                case 3:
                    exam_state1 = "旷考";
                    break;
                case 4:
                    exam_state1 = "舞弊";
                    break;
                case 5:
                    exam_state1 = "其它";
                    break;
            }

            row = sheet2.createRow(i+4);
            String[] titles1={student_number1, stuname1, regular_grade1, midterm_grade1, final_exam_grade1, totel_grade1, exam_state1};//在这里插入数据
            for (int j = 0; j < titles1.length; j++) {
                cell = row.createCell(j);
                cell.setCellStyle(excelUtil.getBodyStyle());
                cell.setCellValue(titles1[j]);
            }
        }

        //构建表头弟七行
        CellRangeAddress region27 = new CellRangeAddress(total1+6, total1+6, (short) 0, (short) 8);
        sheet2.addMergedRegion(region27);
        Row bodyRow25 = sheet2.createRow(total1+6);
        cell = bodyRow25.createCell(0);
        cell.setCellStyle(excelUtil.getHeadStyle());
        cell.setCellValue("二、成绩计算方法");
        //构建第八行
        CellRangeAddress region28 = new CellRangeAddress(total1+7, total1+7, (short) 0, (short) 8);
        sheet2.addMergedRegion(region28);
        Row bodyRow26 = sheet2.createRow(total1+7);
        cell = bodyRow26.createCell(0);
        cell.setCellStyle(excelUtil.getHeadStyle());
        cell.setCellValue("各档成绩百分比: 平时成绩占100%; 期中成绩占0%; 期末成绩占70%;");
        //构建第九行
        CellRangeAddress region29 = new CellRangeAddress(total1+8, total1+8, (short) 0, (short) 8);
        sheet2.addMergedRegion(region29);
        Row bodyRow27 = sheet2.createRow(total1+8);
        cell = bodyRow27.createCell(0);
        cell.setCellStyle(excelUtil.getHeadStyle());
        cell.setCellValue("三、学生成绩统计");
        //构建第十行
        String[] titles6={"应考人数", "缺考人数", "100-90分", "89-80分", "79-70分", "69-60分", "59分及其以下", "平均分"};
        Map<String, Object> cjfxdMap= cjfxd.get(0);
        String yk = cjfxdMap.get("yk").toString();
        String qk = cjfxdMap.get("qk").toString();
        String d1 = cjfxdMap.get("d1").toString();
        String d2 = cjfxdMap.get("d2").toString();
        String d3 = cjfxdMap.get("d3").toString();
        String d4 = cjfxdMap.get("d4").toString();
        String d5 = cjfxdMap.get("d5").toString();
        String pjf = cjfxdMap.get("pjf").toString();
        String[] titles5={yk, qk, d1, d2, d3, d4, d5, pjf};
        for (int i = 0; i < titles6.length; i++) {
            Row bodyRow28 = sheet2.createRow(total1+9+i);
            cell = bodyRow28.createCell(0);
            cell.setCellStyle(excelUtil.getBodyStyle());
            cell.setCellValue(titles6[i]);

            cell = bodyRow28.createCell(1);
            cell.setCellStyle(excelUtil.getBodyStyle());
            cell.setCellValue(titles5[i]);

            cell = bodyRow28.createCell(2);
            cell.setCellStyle(excelUtil.getBodyStyle());
            cell.setCellValue("0%");
        }

        //构建第十一行
        CellRangeAddress region210 = new CellRangeAddress(total1+17, total1+17, (short) 0, (short) 8);
        sheet2.addMergedRegion(region210);
        Row bodyRow28 = sheet2.createRow(total1+17);
        cell = bodyRow28.createCell(0);
        cell.setCellStyle(excelUtil.getHeadStyle());
        cell.setCellValue("四、对学生成绩情况的评语");
        //构建空格
        CellRangeAddress region211 = new CellRangeAddress(total1+18, total1+22, (short) 0, (short) 8);
        sheet2.addMergedRegion(region211);
        //构建第十二行
        CellRangeAddress region212 = new CellRangeAddress(total1+23, total1+23, (short) 0, (short) 8);
        sheet2.addMergedRegion(region212);
        Row bodyRow29 = sheet2.createRow(total1+23);
        cell = bodyRow29.createCell(0);
        cell.setCellStyle(excelUtil.getHeadStyle());
        cell.setCellValue("五、考试反应的问题及试卷评价");
        //构建空格
        CellRangeAddress region213 = new CellRangeAddress(total1+24, total1+28, (short) 0, (short) 8);
        sheet2.addMergedRegion(region213);
        //构建第十三行
        CellRangeAddress region214 = new CellRangeAddress(total1+29, total1+29, (short) 0, (short) 8);
        sheet2.addMergedRegion(region214);
        Row bodyRow210 = sheet2.createRow(total1+29);
        cell = bodyRow210.createCell(0);
        cell.setCellStyle(excelUtil.getHeadStyle());
        cell.setCellValue("六、今后改进的教学措施");
        //构建空格
        CellRangeAddress region215 = new CellRangeAddress(total1+30, total1+34, (short) 0, (short) 8);
        sheet2.addMergedRegion(region215);
        //最后部分
        CellRangeAddress region216 = new CellRangeAddress(total1+35, total1+35, (short) 0, (short) 8);
        sheet2.addMergedRegion(region216);
        Row bodyRow211 = sheet2.createRow(total+35);
        cell = bodyRow211.createCell(0);
        cell.setCellStyle(excelUtil.getHeadStyle());
        cell.setCellValue("任课教师:         教研室主任:       系(班)主任:         教务处处长:       ");


        //自适应表格大小
        // excelUtil.autoSizeColumnSize(sheet);
        // 写文件
        try {
            FileOutputStream out = new FileOutputStream(new File(address+"课程成绩单.xlsx"));
            out.flush();
            workbook.write(out);
            out.close();
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }
        //读取要下载的文件
        File f = new File(address+"课程成绩单.xlsx");
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
//-------------------------------------------班级成绩表-----------------------------------------------------------------------


    /**
     * 班级成绩表打印
     * @param response
     * @throws IOException
     */
    public void outputExcel1(String semester,int student_class_id, HttpServletResponse response) throws IOException, SQLException {
       String sql1 = " SELECT" +
               " cv.id," +
               " cv.class_name," +
               " sb.student_number," +
               " sb.stuname," +
               " tv.semester," +
               " Count(*) AS ms," +
               " GROUP_CONCAT(course.course_name ORDER BY course.id) a," +
               " GROUP_CONCAT(course.id ORDER BY course.id) b1 ," +
               " GROUP_CONCAT(gs.final_exam_grade ORDER BY course.id) c " +
               " FROM" +
               " teaching_task_latest_view AS tv" +
               " INNER JOIN dict_courses AS course ON tv.course_id = course.id" +
               " INNER JOIN class_grade AS cv ON tv.class_id = cv.id" +
               " INNER JOIN student_basic AS sb ON cv.id = sb.classroomid" +
               " INNER JOIN exam_plan AS ep ON tv.id = ep.teaching_task_id" +
               " INNER JOIN grade_student AS gs ON ep.id = gs.exam_plan_id AND gs.student_id = sb.id" +
               " WHERE" +
               " tv.semester = '"+semester+"' " +
               " AND cv.id = "+student_class_id+"" +
               " GROUP BY" +
               " cv.id," +
               " sb.id," +
               " tv.semester" +
               " ORDER BY" +
               " sb.student_number ASC";
        List<Map<String, Object>> bjcjb = DBHelper.getReader().doQuery(sql1, new Object[0],
                DBHelper.keyAndTypes("id", STRING, "class_name", STRING,
                        "student_number", STRING, "stuname", STRING,
                        "semester",STRING , "ms", STRING, "a", STRING, "b1", STRING, "c", STRING));

        SXSSFWorkbook workbook = new SXSSFWorkbook(50);
        Sheet sheet = workbook.createSheet("班级成绩表");
        ExcelUtil1 excelUtil = new ExcelUtil1(workbook, sheet);
        Cell cell = null;;
        Row row = null;

        // 构建表头第一行
        Row headRow = sheet.createRow(0);
        CellRangeAddress region1 = new CellRangeAddress(0, 0, (short) 0, (short) 8);
        sheet.addMergedRegion(region1);
        //标题样式
        // 创建单元格样式
        cell = headRow.createCell(0);
        cell.setCellStyle(excelUtil.getTitle());
        cell.setCellValue("黑龙江司法警官职业学院课程成绩单");
        row = sheet.createRow(1);
        List titleList = new ArrayList<>();
        //表头数据迭代
       Map<String, Object> bjcjbMap = bjcjb.get(0);

        String a = bjcjbMap.get("a").toString();
        String[] aList = a.split(",");
        String[] titles = new String[aList.length+5];
//        String[] titles={"学号", "学生", "课程门数"};//在这里插入数据
        titles[0] = "学号";
        titles[1] = "学生";
        titles[2] = "课程门数";


        for (int i = 0; i < aList.length; i++) {
            titles[i+3] = aList[i] ;
        }
        titles[titles.length-2] = "不及格";
        titles[titles.length-1] = "所得学分";
        Row bodyRow = sheet.createRow(1);
        for (int i = 0; i < titles.length; i++) {
        cell = bodyRow.createCell(i);
        cell.setCellStyle(excelUtil.getBodyStyle());
        cell.setCellValue(titles[i]);
        }
        //表内数据
        int h = 0;
        for (Map<String, Object> bjcjbMap1 : bjcjb) {
            String student_number = bjcjbMap1.get("student_number").toString();
            String stuname = bjcjbMap1.get("stuname").toString();
            String ms = bjcjbMap1.get("ms").toString();
            String c = bjcjbMap1.get("c").toString();

            for (int j = 0; j < titles.length; j++) {
                cell = row.createCell(j);
                cell.setCellStyle(excelUtil.getBodyStyle());
                cell.setCellValue(titles[j]);
            }
            String[] data = new String[titles.length];
            data[0] = student_number;
            data[1] = stuname;
            data[2] =ms;
            String[] cList = c.split(",");
            int bjg = 0;
            for (int i = 0; i < cList.length; i++) {
                data[i+3] = cList[i];
                if (Integer.valueOf(cList[i]) < 60) {
                    bjg++;
                }
            }
            data[data.length-2] = bjg+"";
            data[data.length-1] = (Integer.valueOf(data[2])- bjg)+"";
            Row bodyRow1 = sheet.createRow(h+2);
            for (int j = 0; j < data.length; j++) {
                cell = bodyRow1.createCell(j);
                cell.setCellStyle(excelUtil.getBodyStyle());
                cell.setCellValue(data[j]);
            }
            h++;
        }

    //自适应表格大小
    // excelUtil.autoSizeColumnSize(sheet);
    // 写文件
    try {
        FileOutputStream out = new FileOutputStream(new File(address+"班级成绩表.xlsx"));
        out.flush();
        workbook.write(out);
        out.close();
    } catch (FileNotFoundException e) {
        e.printStackTrace();
    } catch (IOException e) {
        e.printStackTrace();
    }
    //读取要下载的文件
    File f = new File(address+"班级成绩表.xlsx");
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
    //----------------------------------------------------学生成绩卡----------------------------------------
    /**
     * 学生成绩卡打印
     * @param response
     * @throws IOException
     */
    public void outputExcel2(int student_id, HttpServletResponse response) throws IOException, SQLException {
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
                " LEFT JOIN class_grade cg on cg.classroom_id = sb.classroomid" +
                " WHERE " +
                " sb.id = "+student_id+"";
        String sql1 = " SELECT" +
                " IFnull(tv.semester,'空')," +
                " IFnull(course.course_name,'空')," +
                " IFnull(tv.course_nature_id,'空'),  " +
                " IFnull(tv.semester_hours,'空')," +
                " IFnull(tv.credits_term, 0)," +
                " IFnull(gs.final_exam_grade,'空')," +
                " IFnull(tv.assessment_id, 0)  " +
                " FROM" +
                " teaching_task_latest_view AS tv" +
                " INNER JOIN dict_courses AS course ON tv.course_id = course.id" +
                " INNER JOIN student_basic AS sb " +
                " INNER JOIN exam_plan AS ep ON tv.id = ep.teaching_task_id" +
                " INNER JOIN grade_student AS gs ON ep.id = gs.exam_plan_id AND gs.student_id = sb.id" +
                " WHERE" +
                " sb.id = "+student_id+"";
        List<Map<String, Object>> xscjk = DBHelper.getReader().doQuery(sql, new Object[0],
                DBHelper.keyAndTypes("departments_name", STRING, "major_name", STRING,
                        "class_name", STRING, "student_number", STRING,
                        "stuname",STRING , "sex", STRING, "idcard", STRING, "birth", STRING, "start_date", STRING, "graduation_date", STRING
                        , "number", STRING, "candidate_number",STRING));
        List<Map<String, Object>> xscjkList = DBHelper.getReader().doQuery(sql1, new Object[0],
                DBHelper.keyAndTypes("semester", STRING, "course_name", STRING,
                        "course_nature_id", STRING, "semester_hours", STRING,
                        "credits_term",STRING ,
                        "final_exam_grade",STRING,
                        "assessment_id",STRING));
        Map<String, Object> xscjkMap = xscjk.get(0);
        try {
            POIFSFileSystem fs = new POIFSFileSystem(new FileInputStream(address+"temp.xls"));
            HSSFWorkbook wb = new HSSFWorkbook(fs);
            HSSFSheet sheet = wb.getSheetAt(0);//获取第一个sheet里的内容
            //循环map中的键值对，替换excel中对应的键的值（注意，excel模板中的要替换的值必须跟map中的key值对应，不然替换不成功）
            // if(!ObjectUtils.isNullOrEmpty(map)){
            Map map = new HashMap<String,String>();
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
            try {
                start_date =  dateFormat.format(dateFormat.parse(start_date));
            } catch (ParseException e) {
                e.printStackTrace();
            }
            String graduation_date = xscjkMap.get("graduation_date").toString();
            String number = xscjkMap.get("number").toString();
            String candidate_number = xscjkMap.get("candidate_number").toString();
            map.put("yx",departments_name);
            map.put("zy",major_name);
            map.put("bj",class_name);
            map.put("xh",student_number);
            map.put("xm",stuname);
            map.put("xb",sex);
            map.put("sfzh",idcard);
            map.put("csny",birth);
            map.put("rxsj",start_date);
            map.put("bysj",graduation_date);
            map.put("byzh",number);
            map.put("xwzh",candidate_number);
            map.put("bylw"," ");
            map.put("cj"," ");
            int zxf = 0;
            int bxxf = 0;
            int xxxf = 0;
            for (int i = 0; i <xscjkList.size() ; i++) {
                Map<String, Object> xscjkList1 = xscjkList.get(i);
                int credits_term = Integer.valueOf(xscjkList1.get("credits_term").toString()); //学分
                int course_nature_id = Integer.valueOf(xscjkList1.get("course_nature_id").toString()); ///*1--必修  2--限选 3--任选  4--选修*/
                zxf = zxf+credits_term;
                if (course_nature_id == 1){
                    bxxf = bxxf+credits_term;
                }else if (course_nature_id == 4){
                    xxxf = xxxf+credits_term;
                }

            }
            map.put("zxf",zxf);
            map.put("bxxf",bxxf);
            map.put("xxxf",xxxf);
            for (Object atr : map.keySet()) {
                atr = atr.toString();
                int rowNum = 6;//该sheet页里最多有几行内容
                for (int i = 0; i < rowNum; i++) {//循环每一行
                    HSSFRow row = sheet.getRow(i);
                    int colNum = row.getLastCellNum();//该行存在几列
                    for (int j = 0; j < colNum; j++) {//循环每一列
                        HSSFCell cell = row.getCell((short) j);
                        String str = cell.getStringCellValue();//获取单元格内容  （行列定位）

//                        System.out.println(str);
//                        System.out.println("-------------------------"+str);
                        if (atr.equals(str.trim())) {
                            //写入单元格内容
                            cell.setCellType(HSSFCell.CELL_TYPE_STRING);
                            cell.setCellValue(map.get(atr).toString()); //替换单元格内容
                            System.out.println("str-----"+str+"atr---------"+atr+"");
                        }
                    }
                }
            }

            for (int i = 0; i < xscjkList.size(); i++) {
                Map<String, Object> xscjkListMap = xscjkList.get(i);
                String semester = xscjkListMap.get("semester").toString();
                String course_name = xscjkListMap.get("course_name").toString();
                String course_nature_id = xscjkListMap.get("course_nature_id").toString();
                String semester_hours = xscjkListMap.get("semester_hours").toString();
                String credits_term = xscjkListMap.get("credits_term").toString();
                String final_exam_grade = xscjkListMap.get("final_exam_grade").toString();
                String assessment_id = xscjkListMap.get("assessment_id").toString();
                switch(Integer.valueOf(course_nature_id)){
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

                if (i % 2 != 0) {
                    HSSFRow row1 = sheet.getRow(7+i-1);
                    row1.getLastCellNum();
                    HSSFCell cell6 = row1.getCell(7);
                    cell6.setCellType(HSSFCell.CELL_TYPE_STRING);
                    cell6.setCellValue(semester); //替换单元格内容

                    HSSFCell cell7 = row1.getCell(9);
                    cell7.setCellType(HSSFCell.CELL_TYPE_STRING);
                    cell7.setCellValue(course_name); //替换单元格内容

                    HSSFCell cell8 = row1.getCell(12);
                    cell8.setCellType(HSSFCell.CELL_TYPE_STRING);
                    cell8.setCellValue(course_nature_id); //替换单元格内容

                    HSSFCell cell9 = row1.getCell(13);
                    cell9.setCellType(HSSFCell.CELL_TYPE_STRING);
                    cell9.setCellValue(semester_hours); //替换单元格内容

                    HSSFCell cell10 = row1.getCell(14);
                    cell10.setCellType(HSSFCell.CELL_TYPE_STRING);
                    cell10.setCellValue(credits_term); //替换单元格内容
                 if ("2".equals(assessment_id)){
                     HSSFRow row2 = sheet.getRow(7+i);
                     Integer cj = Integer.valueOf(final_exam_grade);
                     if (cj <60){
                       final_exam_grade = "不及格";
                     }
                     if (cj>=60 && cj >=79){
                        final_exam_grade = "及格";
                     }
                     if (cj>=79 && cj >=80){
                         final_exam_grade = "良好";
                     }
                     if (cj>=90 && cj >=100){
                         final_exam_grade = "优秀";
                     }
                    }
                    HSSFCell cell5 = row1.getCell(15);
                    cell5.setCellType(HSSFCell.CELL_TYPE_STRING);
                    cell5.setCellValue(final_exam_grade); //替换单元格内容

                }else{
                    HSSFRow row1 = sheet.getRow(7+i);
                    HSSFCell cell = row1.getCell(0);
                    cell.setCellType(HSSFCell.CELL_TYPE_STRING);
                    cell.setCellValue(semester); //替换单元格内容

                    HSSFCell cell1 = row1.getCell(1);
                    cell1.setCellType(HSSFCell.CELL_TYPE_STRING);
                    cell1.setCellValue(course_name); //替换单元格内容

                    HSSFCell cell2 = row1.getCell(3);
                    cell2.setCellType(HSSFCell.CELL_TYPE_STRING);
                    cell2.setCellValue(course_nature_id); //替换单元格内容

                    HSSFCell cell3 = row1.getCell(4);
                    cell3.setCellType(HSSFCell.CELL_TYPE_STRING);
                    cell3.setCellValue(semester_hours); //替换单元格内容

                    HSSFCell cell4 = row1.getCell(5);
                    cell4.setCellType(HSSFCell.CELL_TYPE_STRING);
                    cell4.setCellValue(credits_term); //替换单元格内容
                    if ("2".equals(assessment_id)){
                        HSSFRow row2 = sheet.getRow(7+i);
                        Integer cj = Integer.valueOf(final_exam_grade);
                        if (cj <60){
                            final_exam_grade = "不及格";
                        }
                        if (cj>=60 && cj >=79){
                            final_exam_grade = "及格";
                        }
                        if (cj>=79 && cj >=80){
                            final_exam_grade = "良好";
                        }
                        if (cj>=90 && cj >=100){
                            final_exam_grade = "优秀";
                        }
                    }

                    HSSFCell cell5 = row1.getCell(6);
                    cell5.setCellType(HSSFCell.CELL_TYPE_STRING);
                    cell5.setCellValue(final_exam_grade); //替换单元格内容
                    System.out.println("这行总共有多少列"+row1.getLastCellNum());
                }


            }
            // 输出文件
            FileOutputStream out = new FileOutputStream(new File(address+"学生成绩卡.xls"));
            out.flush();
            wb.write(out);
            out.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
        //读取要下载的文件
        File f = new File(address+"学生成绩卡.xls");
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
    /**
     * 不及格门数统计
     * @param response
     * @throws IOException
     */
    public void outputExcel3(HttpServletResponse response) throws IOException, SQLException {
        String sql1 = " SELECT" +
                " sb.id, " +
                " sb.student_number, " +
                " sb.stuname, " +
                " Count(*), " +
                " Sum(tv.credits_term), " +
                " cv.class_name, " +
                " GROUP_CONCAT(course.course_name ORDER BY course.id) " +
                " FROM " +
                " teaching_task_latest_view AS tv " +
                " INNER JOIN dict_courses AS course ON tv.course_id = course.id " +
                " INNER JOIN student_basic AS sb " +
                " INNER JOIN exam_plan AS ep ON tv.id = ep.teaching_task_id " +
                " INNER JOIN grade_student AS gs ON ep.id = gs.exam_plan_id AND gs.student_id = sb.id " +
                " INNER JOIN class_grade AS cv ON sb.classroomid = cv.id " +
                " WHERE gs.final_exam_grade<60 " +
                " GROUP BY sb.id";
        List<Map<String, Object>> bjgtj = DBHelper.getReader().doQuery(sql1, new Object[0],
                DBHelper.keyAndTypes("id", STRING, "student_number", STRING,
                        "stuname", STRING, "ms", STRING,
                        "bjgxf",STRING , "szbj", STRING, "kclb", STRING));

        SXSSFWorkbook workbook = new SXSSFWorkbook(50);
        Sheet sheet = workbook.createSheet("不及格门数统计");
        ExcelUtil1 excelUtil = new ExcelUtil1(workbook, sheet);
        Cell cell = null;;
        Row row = null;

        // 构建表头第一行
        Row headRow = sheet.createRow(0);
        CellRangeAddress region1 = new CellRangeAddress(0, 0, (short) 0, (short) 8);
        sheet.addMergedRegion(region1);
        //标题样式
        // 创建单元格样式
        cell = headRow.createCell(0);
        cell.setCellStyle(excelUtil.getTitle());
        cell.setCellValue("不及格门数统计");
        row = sheet.createRow(1);
        List titleList = new ArrayList<>();
        //表头数据迭代
        String[] titles ={"序号","学号","姓名","不及格门数","不及格学分","所在班级","课程列表"};
        Row bodyRow = sheet.createRow(1);
        for (int i = 0; i < titles.length; i++) {
            cell = bodyRow.createCell(i);
            cell.setCellStyle(excelUtil.getBodyStyle());
            cell.setCellValue(titles[i]);
        }
        //表内数据
        int h = 0;
        for (Map<String, Object> bjgtjMap : bjgtj) {
            String id = bjgtjMap.get("id").toString();
            String student_number = bjgtjMap.get("student_number").toString();
            String stuname = bjgtjMap.get("stuname").toString();
            String ms = bjgtjMap.get("ms").toString();
            String bjgxf = bjgtjMap.get("bjgxf").toString();
            String szbj = bjgtjMap.get("szbj").toString();
            String kclb = bjgtjMap.get("kclb").toString();
            String[] data = {h+"",student_number,stuname,ms,bjgxf,szbj,kclb};
            Row bodyRow1 = sheet.createRow(h+2);
            for (int j = 0; j < data.length; j++) {
                cell = bodyRow1.createCell(j);
                cell.setCellStyle(excelUtil.getBodyStyle());
                cell.setCellValue(data[j]);
            }
            h++;
        }

        //自适应表格大小
        // excelUtil.autoSizeColumnSize(sheet);
        // 写文件
        try {
            FileOutputStream out = new FileOutputStream(new File(address+"不及格门数统计.xlsx"));
            out.flush();
            workbook.write(out);
            out.close();
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }
        //读取要下载的文件
        File f = new File(address+"不及格门数统计.xlsx");
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


    public static void replaceModelNew(String sourceFilePath, int sheetNum, Map<String, String> map, OutputStream out) {
        try {
            POIFSFileSystem fs = new POIFSFileSystem(new FileInputStream(sourceFilePath));
            HSSFWorkbook wb = new HSSFWorkbook(fs);
            HSSFSheet sheet = wb.getSheetAt(sheetNum);//获取第一个sheet里的内容
            //循环map中的键值对，替换excel中对应的键的值（注意，excel模板中的要替换的值必须跟map中的key值对应，不然替换不成功）
            // if(!ObjectUtils.isNullOrEmpty(map)){
            for (String atr : map.keySet()) {
                int rowNum = sheet.getLastRowNum();//该sheet页里最多有几行内容
                for (int i = 0; i < rowNum; i++) {//循环每一行
                    HSSFRow row = sheet.getRow(i);
                    int colNum = row.getLastCellNum();//该行存在几列
                    for (int j = 0; j < colNum; j++) {//循环每一列
                        HSSFCell cell = row.getCell((short) j);
                        String str = cell.getStringCellValue();//获取单元格内容  （行列定位）

                        if (atr.equals(str.trim())) {

                            //写入单元格内容
                            cell.setCellType(HSSFCell.CELL_TYPE_STRING);
                            cell.setCellValue(map.get(atr)); //替换单元格内容
                        }
                    }
                }
            }



            // 输出文件

            wb.write(out);
            out.close();
        } catch (IOException e) {
            e.printStackTrace();
        }


    }

        //原文：https://blog.csdn.net/u014135369/article/details/83181396




    /**
     * 文件压缩
     */

    /**
     * Initialization of the servlet. <br>
     *
     * @throws ServletException if an error occurs
     */
    public void init() throws ServletException {
        // Put your code here
    }
    private static boolean checkInt(JSONObject jsonObject, String fieldName) {
        try {
            int val = jsonObject.getInt(fieldName);
            return val != 0;
        } catch (Exception e) {
        }
        return false;
    }

    private static boolean checkLong(JSONObject jsonObject, String fieldName) {
        try {
            long val = jsonObject.getLong(fieldName);
            return val != 0;
        } catch (Exception e) {
        }
        return false;
    }

    private static boolean checkDouble(JSONObject jsonObject, String fieldName) {
        try {
            Double val = jsonObject.getDouble(fieldName);
            return true;
        } catch (Exception e) {
        }
        return false;
    }


    private static boolean checkString(JSONObject jsonObject, String fieldName) {
        try {
            String val = jsonObject.getString(fieldName);
            return StringUtils.isNotBlank(val);
        } catch (Exception e) {
        }
        return false;
    }

    private static boolean checkBoolean(JSONObject jsonObject,String fieldName){
        try {
            Boolean val = jsonObject.getBoolean(fieldName);
            return BooleanUtils.isTrue(val);
        } catch (Exception e) {
        }
        return false;
    }




}
