<%@ page import="net.sf.json.JSONObject"%>
<%@ page import="org.apache.commons.fileupload.FileItem"%>
<%@ page import="v1.grade.DBHelper"%>
<%@ page import="v1.grade.ExcelUtil"%>
<%@ page import="v1.grade.GradeImportEntity"%>
<%@ page import="java.io.InputStream"%><%@ page import="java.sql.Connection"%>
<%@ page import="java.sql.PreparedStatement"%><%@ page import="java.sql.SQLException"%><%@ page import="java.util.List"%><%@ page import="java.util.Arrays"%><%@ page import="java.util.Collections"%>
<%@ page contentType="application/json;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<jsp:include page="file_upload.jsp"></jsp:include>
<%!
final List<String> stateMap = Arrays.asList("正常考试", "免修","学分互认","缓考","旷考","舞弊","其它");
%>
<%
JSONObject resultJson = new JSONObject();
Exception exception = (Exception) request.getAttribute("error");
if (exception!=null){
    resultJson.put("state",false);
    resultJson.put("msg",exception.getMessage());
}else {
    String exam_plan_id_string = (String) request.getAttribute("exam_plan_id");
    int exam_plan_id = Integer.parseInt(exam_plan_id_string);
    String regular_per_string = (String) request.getAttribute("regular_per");
    int regular_per = Integer.parseInt(regular_per_string);
    int medium_per = Integer.parseInt((String) request.getAttribute("medium_per"));
    int finalexam_per = Integer.parseInt((String) request.getAttribute("finalexam_per"));
    int stateTo = Integer.parseInt((String) request.getAttribute("stateTo"));

    FileItem item = (FileItem) request.getAttribute("file");

    InputStream templateXML = ExcelUtil.class.getResourceAsStream("/GradeImport.xml");
    InputStream excelStream = item.getInputStream();
    List<GradeImportEntity> list = (List<GradeImportEntity>) ExcelUtil.readFrom(templateXML,excelStream);

    String addGradeStudentSql = "INSERT INTO grade_student (exam_plan_id,student_id,regular_grade,midterm_grade,final_exam_grade,totel_grade,exam_state)" +
                " VALUES(?,?,?,?,?,?,?) " +
                "ON DUPLICATE KEY UPDATE regular_grade=values(regular_grade),midterm_grade=values(midterm_grade)," +
                "final_exam_grade=values(final_exam_grade),totel_grade=values(totel_grade),exam_state=values(exam_state)";
        String updateExampers = "UPDATE `exam_plan` SET `regular_per`=?, `medium_per`=?, `finalexam_per`=? WHERE (`id`=?)";
        String setExamState = "UPDATE exam_plan SET check_state=? WHERE id=? ";
        Connection writer = null;
        PreparedStatement preparedExamper = null;
        PreparedStatement preparedExamState = null;
        PreparedStatement preparedAddGrade = null;
        try {
            writer = DBHelper.getWriter().connect();
            preparedExamper = writer.prepareStatement(updateExampers);
            preparedExamState = writer.prepareStatement(setExamState);
            preparedAddGrade = writer.prepareStatement(addGradeStudentSql);
            writer.setAutoCommit(false);

            preparedExamper.setDouble(1,regular_per);
            preparedExamper.setDouble(2,medium_per);
            preparedExamper.setDouble(3,finalexam_per);
            preparedExamper.setInt(4,exam_plan_id);

            preparedExamper.executeUpdate();

            for (GradeImportEntity entity:list) {
                int student_id = Integer.parseInt(entity.getStudent_id());
                double regular_grade = Double.parseDouble(entity.getRegular_grade());
                double midterm_grade = Double.parseDouble(entity.getMidterm_grade());
                double final_exam_grade = Double.parseDouble(entity.getFinal_exam_grade());
                String exam_state = entity.getExam_state().trim();

                double totel_grade = regular_grade*regular_per+midterm_grade*medium_per+final_exam_grade*finalexam_per;
                totel_grade *= 0.01;

                preparedAddGrade.setInt(1, exam_plan_id);
                preparedAddGrade.setInt(2, student_id);
                preparedAddGrade.setDouble(3, regular_grade);
                preparedAddGrade.setDouble(4, midterm_grade);
                preparedAddGrade.setDouble(5, final_exam_grade);
                preparedAddGrade.setDouble(6, totel_grade);

                preparedAddGrade.setInt(7,stateMap.indexOf(exam_state));

                preparedAddGrade.addBatch();
            }
            int[] arr = preparedAddGrade.executeBatch();

//            if(checkInt(jsonObject,"stateTo") && jsonObject.getInt("stateTo")==2){
                preparedExamState.setInt(1,stateTo);
                preparedExamState.setInt(2,exam_plan_id);
                preparedExamState.executeUpdate();
//            }

            writer.commit();

            resultJson.put("state",true);
            resultJson.put("msg","导入成功！");
        } catch (SQLException e) {
            e.printStackTrace();
            resultJson.put("state",false);
            resultJson.put("msg",e.getMessage());
        } finally {
            try {
                if (writer != null)
                    writer.close();
                if(preparedExamper!=null){
                    preparedExamper.close();
                }
                if (preparedAddGrade != null)
                    preparedAddGrade.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
}
%>
<%=resultJson.toString()%>
