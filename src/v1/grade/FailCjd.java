package v1.grade;


import net.sf.json.JSONObject;
import org.apache.commons.lang3.BooleanUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.poifs.filesystem.POIFSFileSystem;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
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
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import static v1.grade.DBHelper.ResultType.INTEGER;
import static v1.grade.DBHelper.ResultType.STRING;


public class FailCjd extends HttpServlet {
    public FailCjd() {
        super();
    }

    public void destroy() {
        super.destroy(); // Just puts "destroy" string in log

    }

    /**
     * api 接口总入口 接受变量引导
     */
    String address ="/Users/huang/work/ceshi/";

    public void doGet( HttpServletRequest request, HttpServletResponse response) throws IOException {
        String p = request.getParameter("p");
        System.out.println("******进入不及格统计");
        String path = request.getSession().getServletContext().getRealPath("/");//获取tomcat根目录
        address = path;
        System.out.println("项目路径------------------"+path);
        //根据变量进行入口调整

        try {
            failCjd(response);
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


    /**
     * 不及格门数统计
     * @param response
     * @throws IOException
     */
    public void failCjd(HttpServletResponse response) throws IOException, SQLException {
        String sql1 = " SELECT" +
                " sb.id, " +
                " sb.student_number, " +
                " sb.stuname, " +
                " Count(*), " +
                " Sum(tv.credits), " +
                " cv.class_name, " +
                " GROUP_CONCAT(course.course_name ORDER BY course.id) " +
                " FROM " +
                " teaching_task_view AS tv " +
                " INNER JOIN dict_courses AS course ON tv.course_id = course.id " +
                " INNER JOIN student_basic AS sb " +
                " INNER JOIN exam_plan AS ep ON tv.id = ep.teaching_task_id " +
                " INNER JOIN grade_student AS gs ON ep.id = gs.exam_plan_id AND gs.student_id = sb.id " +
                " INNER JOIN class_grade AS cv ON sb.classroomid = cv.id " +
                " WHERE gs.final_exam_grade<60 " +
                " AND ep.check_state = 2"+
                " GROUP BY sb.id";
        System.out.println(sql1);
        List<Map<String, Object>> bjgtj = DBHelper.getReader().doQuery(sql1, new Object[0],
                DBHelper.keyAndTypes("id", STRING,"student_number", STRING,
                        "stuname", STRING, "ms", INTEGER,
                        "bjgxf",INTEGER , "szbj", STRING, "kclb", STRING));



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
