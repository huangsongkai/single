package v1.grade;


import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.xssf.streaming.SXSSFWorkbook;
import service.util.tool.StringUtil;

import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.*;
import java.net.URLEncoder;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import static v1.grade.DBHelper.ResultType.STRING;


public class ClassCjd extends HttpServlet {
    public ClassCjd() {
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
        System.out.println("********************进入班级成绩表打印");
        String path = request.getSession().getServletContext().getRealPath("/");//获取tomcat根目录
        address = path;
        System.out.println("项目路径------------------"+path);
        //根据变量进行入口调整
        String semester = request.getParameter("semester");
        int student_class_id = Integer.parseInt(request.getParameter("student_class_id"));
        try {
            classCjd(semester, student_class_id, response);
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





//-------------------------------------------班级成绩表-----------------------------------------------------------------------


    /**
     * 班级成绩表打印
     * @param response
     * @throws IOException
     */
    public void classCjd(String semester, int student_class_id, HttpServletResponse response) throws IOException, SQLException {
       String sql1 = " SELECT" +
               " class_id," +
               " class_name," +
               " student_number," +
               " stuname," +
               " semester," +
               " Count(*) as course_number," +
               " GROUP_CONCAT(course_name ORDER BY course_id) as a," +
               " GROUP_CONCAT(course_id ORDER BY course_id) as b1," +
               " GROUP_CONCAT(final_exam_grade ORDER BY course_id) as c," +
               " GROUP_CONCAT(exam_times ORDER BY course_id) as d1" +
               " FROM (" +
               " SELECT" +
               " cv.id AS class_id," +
               " cv.class_name as class_name," +
               " sb.id as student_id," +
               " sb.student_number as student_number," +
               " sb.stuname as stuname," +
               " tv.semester as semester," +
               " Count(*) as exam_times," +
               " course.course_name as course_name," +
               " course.id as course_id," +
               " max(gs.final_exam_grade) as final_exam_grade" +
               " FROM" +
               " teaching_task_view AS tv" +
               " INNER JOIN dict_courses AS course ON tv.course_id = course.id" +
               " INNER JOIN class_grade AS cv ON tv.class_id = cv.id" +
               " INNER JOIN student_basic AS sb ON cv.id = sb.classroomid" +
               " INNER JOIN exam_plan AS ep ON tv.id = ep.teaching_task_id" +
               " INNER JOIN grade_student AS gs ON ep.id = gs.exam_plan_id AND gs.student_id = sb.id" +
               " WHERE 1=1   AND ep.check_state = '2'  ";
        String student_class_id_str = String.valueOf(student_class_id);
        if(student_class_id_str != null && student_class_id_str.length() != 0 && semester != null && semester.length() != 0 ){
            sql1+= " and tv.semester = (select academic_year from academic_year where id ='"+semester+"')   " +
                    " AND cv.id = "+student_class_id+"" +
                    " GROUP BY" +
                    " cv.id," +
                    " sb.id," +
                    " tv.semester," +
                    " course.id" +
                    " ) as temp1" +
                    " GROUP BY" +
                    " class_id," +
                    " student_id," +
                    " semester" +
                    " ORDER BY" +
                    " student_number ASC";
        }else {
            sql1+= " GROUP BY" +
                    " cv.id," +
                    " sb.id," +
                    " tv.semester," +
                    " course.id" +
                    " ) as temp1" +
                    " GROUP BY" +
                    " class_id," +
                    " student_id," +
                    " semester" +
                    " ORDER BY" +
                    " student_number ASC";
        }
        System.out.println("-----"+sql1);
        List<Map<String, Object>> bjcjb = DBHelper.getReader().doQuery(sql1, new Object[0],
                DBHelper.keyAndTypes("id", STRING, "class_name", STRING,
                        "student_number", STRING, "stuname", STRING,
                        "semester",STRING , "ms", STRING, "a", STRING, "b1", STRING, "c", STRING, "d1", STRING));

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
        //表头数据迭代
        if (bjcjb.size()!=0){
       Map<String, Object> bjcjbMap = bjcjb.get(0);

        String a = bjcjbMap.get("a").toString();
        String[] aList = a.split(",");
        String[] titles = new String[aList.length+5];
        titles[0] = "学号";
        titles[1] = "学生";
        titles[2] = "课程门数";


        for (int i = 0; i < aList.length; i++) {
            titles[i+3]="";
            if(StringUtil.isNotEmpty(aList[i])){
                titles[i+3] += aList[i]+"" ;
            }
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
                String d1 = bjcjbMap1.get("d1").toString();

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
                String[] cList1 = d1.split(",");
                int bjg = 0;
                for (int i = 0; i < cList.length; i++) {
                    data[i+3]="";
                    if (Double.parseDouble(cList[i]) < 60) {
                        bjg++;
                    }
                    if (Double.parseDouble(cList[i])>=60 && Double.parseDouble(cList1[i])>1){
                        data[i+3] += cList[i].toString()+"*";
                    }else{
                        data[i+3] += cList[i].toString()+"";
                    }
                }
                data[data.length-2] = bjg+"";
                data[data.length-1] = (Double.parseDouble(data[2])- bjg)+"";
                Row bodyRow1 = sheet.createRow(h+2);
                for (int j = 0; j < data.length; j++) {
                    cell = bodyRow1.createCell(j);
                    cell.setCellStyle(excelUtil.getBodyStyle());
                    cell.setCellValue(data[j]);
                }
                h++;
            }
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
}
