package v1.grade;

import cn.afterturn.easypoi.excel.ExcelExportUtil;
import cn.afterturn.easypoi.excel.entity.TemplateExportParams;
import org.apache.poi.ss.usermodel.Workbook;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.net.URLEncoder;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import static v1.grade.DBHelper.ResultType.*;

public class GradeExcelUtil2 {

    public static void expExcel( int id,HttpServletRequest request, HttpServletResponse response) throws IOException, SQLException {
        String address = request.getSession().getServletContext().getRealPath("/");//获取tomcat根目录
        TemplateExportParams params = new TemplateExportParams(address + "123.xls");
        String sql = "SELECT\n" +
                "gs.exam_plan_id,\n" +
                "gs.student_id,\n" +
                "sb.student_number,\n" +
                "sb.stuname,\n" +
                "gs.regular_grade,\n" +
                "gs.midterm_grade,\n" +
                "gs.final_exam_grade,\n" +
                "gs.totel_grade,\n" +
                " case gs.exam_state when gs.exam_state = 0 then  '正常考试' " +
                "  when gs.exam_state = 1 then  '免修' " +
                "  when gs.exam_state = 2 then  '学分互认' " +
                "  when gs.exam_state = 3 then  '缓考' " +
                "  when gs.exam_state = 4 then  '旷考' " +
                "  when gs.exam_state = 5 then  '舞弊' " +
                "  when gs.exam_state = 6 then  '其他' else gs.exam_state end " +
                "FROM\n" +
                "grade_student AS gs\n" +
                "INNER JOIN student_basic AS sb ON gs.student_id = sb.id\n" +
                "WHERE gs.exam_plan_id=?\n";
        List<Map<String, Object>> resultList = DBHelper.getReader().doQuery(
                sql,
                new Object[]{id}, DBHelper.keyAndTypes(
                        "exam_plan_id", INTEGER,
                        "student_id", INTEGER,
                        "student_number", INTEGER,
                        "stuname", STRING,
                        "regular_grade", DOUBLE,
                        "midterm_grade", DOUBLE,
                        "final_exam_grade", DOUBLE,
                        "totel_grade", DOUBLE,
                        "exam_state", STRING
                )
        );
        Map<String, Object> map = new HashMap<String, Object>();
            map.put("maplist", resultList);

        // 写文件

        Workbook workbook = ExcelExportUtil.exportExcel(params, map);
        File savefile = new File(address);
        if (!savefile.exists()) {
            savefile.mkdirs();
        }
        FileOutputStream fos = new FileOutputStream(address + "成绩导入模版.xls");
        workbook.write(fos);
        fos.close();

        //读取要下载的文件
        File f = new File(address+"成绩导入模版.xls");
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
