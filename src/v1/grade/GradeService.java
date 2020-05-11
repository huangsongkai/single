package v1.grade;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import org.apache.commons.lang3.BooleanUtils;
import org.apache.commons.lang3.StringUtils;

import java.sql.*;
import java.sql.Date;
import java.util.*;

import static v1.grade.DBHelper.ResultType.*;

public class GradeService {

    /**
     * 增添补缓考计划
     *
     * @param jsonString
     */
    public static void addExamPlan(String jsonString) {
        JSONObject jsonObject = JSONObject.fromObject(jsonString);
        int teaching_task_id = jsonObject.getInt("teaching_task_id");
        java.sql.Date exam_date = new java.sql.Date(jsonObject.getLong("exam_date"));
        String exam_place = jsonObject.getString("exam_place");
        int exam_type = jsonObject.getInt("exam_type");
        int check_state = jsonObject.getInt("check_state");
        int regular_per = jsonObject.getInt("regular_per");
        int medium_per = jsonObject.getInt("medium_per");
        int finalexam_per = jsonObject.getInt("finalexam_per");

        String insertSql = "INSERT INTO exam_plan (teaching_task_id,exam_date,exam_place,exam_type,check_state,regular_per,medium_per,finalexam_per) VALUES(?,?,?,?,?,?,?,?)";

        Connection writer = DBHelper.getWriter().connect();


        try {
            writer.setAutoCommit(false);

            PreparedStatement preparedInsert = writer.prepareStatement(insertSql);

            preparedInsert.setInt(1, teaching_task_id);
            preparedInsert.setDate(2, exam_date);
            preparedInsert.setString(3, exam_place);
            preparedInsert.setInt(4, exam_type);
            preparedInsert.setInt(5, check_state);
            preparedInsert.setInt(6, regular_per);
            preparedInsert.setInt(7, medium_per);
            preparedInsert.setInt(8, finalexam_per);

            preparedInsert.execute();

            writer.commit();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    /**
     * 新增 需要补考和缓考的学生 到 GS表中
     */

    public static void addStudentsInGS() {
        JSONObject jobj = new JSONObject();
        jobj.put("flag", 0);
        jobj.put("teacher_name", "");
        jobj.put("class_name", "");
        jobj.put("course_name", "");

        JSONArray jsonArray = new JSONArray();
        jsonArray = queryStudentInNextExam(jobj.toString());

        String addGradeStudentSql = "INSERT INTO grade_student (exam_plan_id,student_id,exam_state)" +
                " VALUES(?,?,?)";

        Connection writer = null;
        PreparedStatement preparedAddGrade = null;

        try{
            writer = DBHelper.getWriter().connect();
            preparedAddGrade = writer.prepareStatement(addGradeStudentSql);
            writer.setAutoCommit(false);
            for (int i = 0; i < jsonArray.size(); i++) {
                JSONObject jsonObject = jsonArray.getJSONObject(i);

                int exam_plan_id = jsonObject.getInt("exam_plan_id");

                int student_id = jsonObject.getInt("student_id");

                preparedAddGrade.setInt(1, exam_plan_id);
                preparedAddGrade.setInt(2, student_id);
                preparedAddGrade.setInt(3, 0);

                preparedAddGrade.addBatch();
            }
            int[] arr = preparedAddGrade.executeBatch();
            writer.commit();
            if(preparedAddGrade!=null)
                preparedAddGrade.close();
            if(writer!=null)
                writer.close();
        } catch (SQLException e) {
            throw new GradeException(theClassName, 24, "成绩录入失败！", e);
        }
    }

    /**
     * 向GT表中增添需要补考的学生
     */

    public static void addStudentInGT() {
        JSONObject jobj = new JSONObject();
        jobj.put("flag", 1);
        jobj.put("teacher_name", "");
        jobj.put("class_name", "");
        jobj.put("course_name", "");

        JSONArray jsonArray = new JSONArray();
        jsonArray = queryStudentInNextExam(jobj.toString());

        String addTreStudentSql = "INSERT INTO grade_transfer (grade_id,charge_state,check_state)" +
                " VALUES(?,?,?)";

        Connection writer = null;
        PreparedStatement preparedAddGrade = null;
        try {
            writer = DBHelper.getWriter().connect();
            preparedAddGrade = writer.prepareStatement(addTreStudentSql);

            writer.setAutoCommit(false);
            for (int i = 0; i < jsonArray.size(); i++) {
                JSONObject jsonObject = jsonArray.getJSONObject(i);

                int gs_id = jsonObject.getInt("gs_id");

                preparedAddGrade.setInt(1, gs_id);
                preparedAddGrade.setInt(2, 0);
                preparedAddGrade.setInt(3, 0);

                preparedAddGrade.addBatch();
            }
            int[] arr = preparedAddGrade.executeBatch();
            writer.commit();

            if(preparedAddGrade!=null)
                preparedAddGrade.close();
            if(writer!=null)
                writer.close();

        } catch (SQLException e) {
            throw new GradeException(theClassName, 24, "成绩录入失败！", e);
        }
    }

    /**
     * 修改GT表中的charge_amount
     *
     * @param jsonString
     */
    public static void chargeInGT(String jsonString) {
        JSONArray jsonArray = JSONArray.fromObject(jsonString);
        String updatesql = "UPDATE grade_transfer SET charge_amount = ? WHERE gs = ?";

        Connection writer = null;
        PreparedStatement preparedAddGrade = null;
        try {
            writer = DBHelper.getWriter().connect();
            preparedAddGrade = writer.prepareStatement(updatesql);
            writer.setAutoCommit(false);
            for (int i = 0; i < jsonArray.size(); i++) {
                JSONObject jsonObject = jsonArray.getJSONObject(i);

                int gs_id = jsonObject.getInt("gs_id");
                double charge_amount = jsonObject.getDouble("charge_amount");

                preparedAddGrade.setDouble(1, charge_amount);
                preparedAddGrade.setInt(2, gs_id);

                preparedAddGrade.addBatch();
            }
            int[] arr = preparedAddGrade.executeBatch();
            writer.commit();

            if(preparedAddGrade!=null)
                preparedAddGrade.close();
            if(writer!=null)
                writer.close();
        } catch (SQLException e) {
            throw new GradeException(theClassName, 24, "成绩录入失败！", e);
        }
    }


    /**
     * 修改GT表中的charge_state
     *
     * @param jsonString
     */
    public static void chargeStateInGT(String jsonString) {
        JSONArray jsonArray = JSONArray.fromObject(jsonString);
        String updatesql = "UPDATE grade_transfer SET charge_state = ? WHERE gs = ?";
        Connection writer = null;
        PreparedStatement preparedAddGrade = null;
        try {
            writer = DBHelper.getWriter().connect();
            preparedAddGrade = writer.prepareStatement(updatesql);
            writer.setAutoCommit(false);
            for (int i = 0; i < jsonArray.size(); i++) {
                JSONObject jsonObject = jsonArray.getJSONObject(i);

                int gs_id = jsonObject.getInt("gs_id");
                int charge_state = jsonObject.getInt("charge_state");

                preparedAddGrade.setInt(1, charge_state);
                preparedAddGrade.setInt(2, gs_id);

                preparedAddGrade.addBatch();
            }
            int[] arr = preparedAddGrade.executeBatch();
            writer.commit();
            if(writer!=null)
                writer.close();
            if(preparedAddGrade!=null)
                preparedAddGrade.close();
        } catch (SQLException e) {
            throw new GradeException(theClassName, 24, "成绩录入失败！", e);
        }
    }


    /***
     * 查询需要补考的同学的具体信息
     * 包括本门课程的名称和学分详情
     * @return
     */
    public static List<Map<String, Object>> queryNextExamStudentInfo(String jsonString) {
        JSONObject jsonObject = JSONObject.fromObject(jsonString);
        try {
            List<String> sqlist = new ArrayList<String>();
            List<Object> params = new ArrayList<Object>();

            sqlist.add("select gs.student_id,sb.stuname,ac.credits,dc.course_name,cg.class_name,gt.charge_state,gt.charge_amount,ac.academic_year,ac.total_classes " +
                    "from grade_transfer gt,grade_student gs,exam_plan ep,teaching_task_view ac,student_basic sb,dict_courses dc,class_grade cg,dict_departments dd,major m,dict_course_nature dcn,dict_course_category dcc " +
                    "where gt.grade_id = gs.id and gs.exam_plan_id = ep.id and ep.teaching_task_id = ac.id and sb.id = gs.student_id and dc.id = ac.course_id and sb.classroomid = cg.id  " +
                    "   and dd.id = sb.faculty and sb.major = m.id and ac.course_nature_id = dcn.id and ac.course_category_id = dcc.id");

            if (checkInt(jsonObject, "academic_year")) {
                sqlist.add("AND ay.id=? ");
                params.add(jsonObject.getInt("academic_year"));
            }

            if (checkInt(jsonObject, "department_id")) {
                sqlist.add("AND ep.dd.id=? ");
                params.add(jsonObject.getInt("department_id"));
            }

            if (checkInt(jsonObject, "majod_id")) {
                sqlist.add("AND m.id = ? ");
                params.add(jsonObject.getInt("majod_id"));
            }
            if (checkInt(jsonObject, "nature_id")) {
                sqlist.add("AND dcn.id = ? ");
                params.add(jsonObject.getInt("nature_id"));
            }
            if (checkInt(jsonObject, "category_id")) {
                sqlist.add("AND dcc.id = ? ");
                params.add(jsonObject.getInt("category_id"));
            }

            if (jsonObject.has("course_name")) {
                sqlist.add("AND dc.course_name  Like ?");
                params.add("%" + jsonObject.getString("course_name") + "%");
            }

            if (jsonObject.has("stu_name")) {
                sqlist.add("AND sb.stuname LIKE ?");
                params.add("%" + jsonObject.get("stu_name") + "%");
            }

            return DBHelper.getReader().doQuery(
                    StringUtils.join(sqlist, " "),
                    params.toArray(), DBHelper.keyAndTypes("departments_name_1", STRING, "course_named", STRING, "teacher_name", STRING, "class_name", STRING, "departments_name_2", STRING, "major_name", STRING, "exam_state", INTEGER, "check_state", INTEGER, "id", INTEGER));
        } catch (Exception e) {
            e.printStackTrace();
        }
        return Collections.emptyList();

    }

    /**
     * 查询需要补考和缓考的学生
     * <p>
     * 也可以根据所教师姓名 课程名字 班级名字查询
     *
     * @param jsonString
     * @return
     */
    public static JSONArray queryStudentInNextExam(String jsonString) {

        List<String> sqlist = new ArrayList<String>();
        List<Object> params = new ArrayList<Object>();

        sqlist.add("select gs.id as gs_id,ep.exam_plan_id,sb.student_number,sb.stuname " +
                "from student_basic sb,teacher_basic tb, teaching_task_view ac ,exam_plan ep,grade_student gs,class_grade cg,dict_courses dc " +
                "where tb.id = ac.teacher_id and ac.id = ep.teaching_task_id and sb.id = gs.student_id and ep.id = gs.exam_plan_id and cg.id = ac.class_id and dc.id = ac.course_id");


        JSONObject jobj = JSONObject.fromObject(jsonString);

        if (checkInt(jobj, "exam_state")) {
            sqlist.add(" and gs.exam_state = ? ");
            params.add(jobj.getInt("exam_state"));
        }

        if (checkString(jobj, "teacher_name")) {
            sqlist.add(" and tb.teacher_name = ? ");
            params.add(jobj.getString("teacher_name"));
        }

        if (checkString(jobj, "class_name")) {
            sqlist.add(" and cg.class_name = ? ");
            params.add(jobj.getString("class_name"));
        }

        if (checkString(jobj, "course_name")) {
            sqlist.add(" and dc.course_name = ? ");
            params.add(jobj.getString("course_name"));
        }

        JSONArray jsonArray = new JSONArray();

        try {
            List<Map<String, Object>> resultList = DBHelper.getReader().doQuery(
                    StringUtils.join(sqlist, " "),
                    params.toArray(),
                    DBHelper.keyAndTypes("gs_id", INTEGER, "exam_plan_id", INTEGER,
                            "student_number", INTEGER, "stuname", STRING)
//                    new String[]{"gs_id","exam_plan_id","student_number", "stuname"}
            );

            return JSONArray.fromObject(resultList);
        } catch (SQLException e) {
            throw new GradeException(theClassName, 24, "查询失败！", e);
        }
    }


    private static final String theClassName = v1.grade.GradeService.class.getName();

    /**
     * 查询成绩控制信息
     */
    public static List<Map<String, Object>> queryGradeControl(String jsonString) throws GradeException {
        String sql = "SELECT ay.`academic_year`,ay.id, gc.`start_date`, gc.`end_date`," +
                " gc.`enable_control`, gc.`enable_check`, gc.`enable_apply`" +
                " FROM `grade_control` gc RIGHT JOIN academic_year ay ON gc.ac_year_id = ay.id ";
        try {
            return DBHelper.getReader().doQuery(sql, new Object[0],
                    DBHelper.keyAndTypes("academic_year", STRING, "ac_year_id", INTEGER,
                            "start_date", DATE_AS_LONG, "end_date", DATE_AS_LONG,
                            "enable_control", BOOLEAN, "enable_check", BOOLEAN, "enable_apply", BOOLEAN));
        } catch (SQLException e) {
            throw new GradeException(theClassName, 24, "成绩控制查询失败！", e);
        }
    }

    /**
     * 成绩控制录入：
     * jsonString传入的内容为包含以下key的（ac_year_id，start_date，end_date，
     * enable_control，enable_check，enable_apply）Json字符串
     * 其中enable_control  enable_check enable_apply 为boolean 值
     */
    public static void addGradeControl(String jsonString) throws GradeException {
        JSONObject jobj = JSONObject.fromObject(jsonString);

        int ac_year_id = jobj.getInt("ac_year_id");
        java.sql.Date start_date = new java.sql.Date(jobj.getLong("start_date"));
        java.sql.Date end_date = new java.sql.Date(jobj.getLong("end_date"));
        boolean enable_control = jobj.getBoolean("enable_control");
        boolean enable_check = jobj.getBoolean("enable_check");
        boolean enable_apply = jobj.getBoolean("enable_apply");

        String selectSql = "SELECT ac_year_id FROM grade_control WHERE ac_year_id = ?";
        String updateSql = "UPDATE grade_control SET start_date = ?,end_date = ? ,enable_control = ? ,enable_check = ? , enable_apply = ? WHERE ac_year_id = ?";
        String insertSql = "INSERT INTO grade_control (ac_year_id,start_date,end_date,enable_control,enable_check,enable_apply) VALUES(?,?,?,?,?,?)";

        Connection reader = null;
        PreparedStatement preparedQuery = null;
        Connection writer = null;
        PreparedStatement preparedUpdate = null;
        PreparedStatement preparedInsert = null;
        try {
            reader = DBHelper.getReader().connect();
            preparedQuery = reader.prepareStatement(selectSql);
            writer = DBHelper.getWriter().connect();
            preparedUpdate = writer.prepareStatement(updateSql);
            preparedInsert = writer.prepareStatement(insertSql);

            writer.setAutoCommit(false);

            preparedQuery.setInt(1, ac_year_id);
            ResultSet resultSet = preparedQuery.executeQuery();

            if (resultSet.next()) {
                preparedUpdate.setDate(1, start_date);
                preparedUpdate.setDate(2, end_date);
                preparedUpdate.setBoolean(3, enable_control);
                preparedUpdate.setBoolean(4, enable_check);
                preparedUpdate.setBoolean(5, enable_apply);
                preparedUpdate.setInt(6, ac_year_id);
                preparedUpdate.execute();
            } else {
                preparedInsert.setInt(1, ac_year_id);
                preparedInsert.setDate(2, start_date);
                preparedInsert.setDate(3, end_date);
                preparedInsert.setBoolean(4, enable_control);
                preparedInsert.setBoolean(5, enable_check);
                preparedInsert.setBoolean(6, enable_apply);

                preparedInsert.execute();
            }

            writer.commit();
            if(preparedQuery!=null)
                preparedQuery.close();
            if(preparedUpdate!=null)
                preparedUpdate.close();
            if(preparedInsert!=null)
                preparedInsert.close();
            if(reader!=null)
                reader.close();
            if(writer!=null)
                writer.close();
        } catch (SQLException e) {
            throw new GradeException(theClassName, 24, "成绩控制录入失败！", e);
        }
    }

    /**
     * 成绩控制批量录入：
     * @param jsonString
     * @throws GradeException
     */
    public static void addGradeControlBatch(String jsonString) throws GradeException {
        JSONArray jarr = JSONArray.fromObject(jsonString);

        String selectSql = "SELECT ac_year_id FROM grade_control WHERE ac_year_id = ?";
        String updateSql = "UPDATE grade_control SET start_date = ?,end_date = ? ,enable_control = ? ,enable_check = ? , enable_apply = ? WHERE ac_year_id = ?";
        String insertSql = "INSERT INTO grade_control (ac_year_id,start_date,end_date,enable_control,enable_check,enable_apply) VALUES(?,?,?,?,?,?)";

        Connection reader = null;
        PreparedStatement preparedQuery = null;
        Connection writer = null;
        PreparedStatement preparedUpdate = null;
        PreparedStatement preparedInsert = null;
        try {
            reader = DBHelper.getReader().connect();
            preparedQuery = reader.prepareStatement(selectSql);
            writer = DBHelper.getWriter().connect();
            preparedUpdate = writer.prepareStatement(updateSql);
            preparedInsert = writer.prepareStatement(insertSql);

            writer.setAutoCommit(false);

            for (int i = 0; i < jarr.size(); i++) {
                JSONObject jobj = jarr.getJSONObject(i);
                int ac_year_id = jobj.getInt("ac_year_id");
                if(ac_year_id==0){
                    System.out.println(jobj);
                    continue;
                }
                java.sql.Date start_date = new java.sql.Date(jobj.getLong("start_date"));
                java.sql.Date end_date = new java.sql.Date(jobj.getLong("end_date"));
                boolean enable_control = jobj.getBoolean("enable_control");
                boolean enable_check = jobj.getBoolean("enable_check");
                boolean enable_apply = jobj.getBoolean("enable_apply");

                preparedQuery.setInt(1, ac_year_id);
                ResultSet resultSet = preparedQuery.executeQuery();

                if (resultSet.next()) {
                    preparedUpdate.setDate(1, start_date);
                    preparedUpdate.setDate(2, end_date);
                    preparedUpdate.setBoolean(3, enable_control);
                    preparedUpdate.setBoolean(4, enable_check);
                    preparedUpdate.setBoolean(5, enable_apply);
                    preparedUpdate.setInt(6, ac_year_id);
                    preparedUpdate.execute();
                } else {
                    preparedInsert.setInt(1, ac_year_id);
                    preparedInsert.setDate(2, start_date);
                    preparedInsert.setDate(3, end_date);
                    preparedInsert.setBoolean(4, enable_control);
                    preparedInsert.setBoolean(5, enable_check);
                    preparedInsert.setBoolean(6, enable_apply);

                    preparedInsert.execute();
                }
            }

            writer.commit();
            if(preparedQuery!=null)
                preparedQuery.close();
            if(preparedUpdate!=null)
                preparedUpdate.close();
            if(preparedInsert!=null)
                preparedInsert.close();
            if(reader!=null)
                reader.close();
            if(writer!=null)
                writer.close();
        } catch (SQLException e) {
            throw new GradeException(theClassName, 24, "成绩控制录入失败！", e);
        }
    }
    /*
       成绩录入：
       jsonString传入的内容为包含以下key的（exam_plan_id,student_id,regular_grade,midterm_grade,
         final_exam_grade,totel_grade）Json字符串
      数据格式与数据库中的格式一致
    */
    @Deprecated
    public static void addGradeStudent(String jsonString) {
        JSONArray jsonArray = JSONArray.fromObject(jsonString);

        String addGradeStudentSql = "INSERT INTO grade_student (exam_plan_id,student_id,regular_grade,midterm_grade,final_exam_grade,totel_grade,exam_state)" +
                " VALUES(?,?,?,?,?,?,?) " +
                "ON DUPLICATE KEY UPDATE regular_grade=values(regular_grade),midterm_grade=values(midterm_grade)," +
                "final_exam_grade=values(final_exam_grade),totel_grade=values(totel_grade),exam_state=values(exam_state)";
        Connection writer = null;
        PreparedStatement preparedAddGrade = null;
        try {
            writer = DBHelper.getWriter().connect();
            preparedAddGrade = writer.prepareStatement(addGradeStudentSql);
            writer.setAutoCommit(false);
            for (int i = 0; i < jsonArray.size(); i++) {
                JSONObject jobj = jsonArray.getJSONObject(i);

                int exam_plan_id = jobj.getInt("exam_plan_id");
                int student_id = jobj.getInt("student_id");
                double regular_grade = jobj.getDouble("regular_grade");
                double midterm_grade = jobj.getDouble("midterm_grade");
                double final_exam_grade = jobj.getDouble("final_exam_grade");
                double totel_grade = jobj.getDouble("totel_grade");

                preparedAddGrade.setInt(1, exam_plan_id);
                preparedAddGrade.setInt(2, student_id);
                preparedAddGrade.setDouble(3, regular_grade);
                preparedAddGrade.setDouble(4, midterm_grade);
                preparedAddGrade.setDouble(5, final_exam_grade);
                preparedAddGrade.setDouble(6, totel_grade);

                if (totel_grade >= 60) {
                    preparedAddGrade.setInt(7, 1);
                } else {
                    preparedAddGrade.setInt(7, 2);
                }

                preparedAddGrade.addBatch();
            }
            int[] arr = preparedAddGrade.executeBatch();
            writer.commit();
        } catch (SQLException e) {
            throw new GradeException(theClassName, 24, "成绩录入失败！", e);
        } finally {
            try {
                if (writer != null)
                    writer.close();
                if (preparedAddGrade != null)
                    preparedAddGrade.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    public static void addGradeStudentWithPercent(String jsonString) {
        JSONObject jsonObject = JSONObject.fromObject(jsonString);
        JSONArray jsonArray = jsonObject.getJSONArray("grades");

        double regular_per = 20;
        double medium_per = 30;
        double finalexam_per = 50;

        if(checkDouble(jsonObject,"regular_per")){
            double _regularPer = jsonObject.getDouble("regular_per");
            regular_per = _regularPer>=0 ? _regularPer : regular_per;
        }

        if(checkDouble(jsonObject,"medium_per")){
            double _medium_per = jsonObject.getDouble("medium_per");
            medium_per = _medium_per>=0 ? _medium_per : medium_per;
        }

        if(checkDouble(jsonObject,"finalexam_per")){
            double _finalexam_per = jsonObject.getDouble("finalexam_per");
            finalexam_per = _finalexam_per>=0 ? _finalexam_per : finalexam_per;
        }

        int exam_plan_id = jsonObject.getInt("exam_plan_id");

        String addGradeStudentSql = "INSERT INTO grade_student (exam_plan_id,student_id,regular_grade,midterm_grade,final_exam_grade,totel_grade,exam_state)" +
                " VALUES(?,?,?,?,?,?,?) " +
                "ON DUPLICATE KEY UPDATE regular_grade=values(regular_grade),midterm_grade=values(midterm_grade)," +
                "final_exam_grade=values(final_exam_grade),totel_grade=values(totel_grade),exam_state=values(exam_state)";
        String updateExampers = "UPDATE `exam_plan` SET `regular_per`=?, `medium_per`=?, `finalexam_per`=? WHERE (`id`=?)";
        String setExamState = "UPDATE exam_plan SET check_state=0 WHERE id=? ";
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

            for (int i = 0; i < jsonArray.size(); i++) {
                JSONObject jobj = jsonArray.getJSONObject(i);

                exam_plan_id = jobj.getInt("exam_plan_id");
                int student_id = jobj.getInt("student_id");
                double regular_grade = jobj.getDouble("regular_grade");
                double midterm_grade = jobj.getDouble("midterm_grade");
                double final_exam_grade = jobj.getDouble("final_exam_grade");
                int exam_state = jobj.getInt("exam_state");

                if(exam_state==3 || exam_state==4 || exam_state==5){
                    continue;
                }

                double totel_grade = regular_grade*regular_per+midterm_grade*medium_per+final_exam_grade*finalexam_per;
                totel_grade *= 0.01;

                preparedAddGrade.setInt(1, exam_plan_id);
                preparedAddGrade.setInt(2, student_id);
                preparedAddGrade.setDouble(3, regular_grade);
                preparedAddGrade.setDouble(4, midterm_grade);
                preparedAddGrade.setDouble(5, final_exam_grade);
                preparedAddGrade.setDouble(6, totel_grade);

                preparedAddGrade.setInt(7,exam_state);

                preparedAddGrade.addBatch();
            }
            int[] arr = preparedAddGrade.executeBatch();

            if(checkInt(jsonObject,"stateTo") && jsonObject.getInt("stateTo")==2){
                preparedExamState.setInt(1,exam_plan_id);
                preparedExamState.executeUpdate();
            }

            writer.commit();
        } catch (SQLException e) {
            throw new GradeException(theClassName, 24, "成绩录入失败！", e);
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

    /**
     * 提交成绩
     * @param jsonString
     */
    public static void checkGradeByCourse0(String jsonString){
        JSONObject jsonObject = JSONObject.fromObject(jsonString);
        int exam_plan = jsonObject.getInt("exam_plan_id");
        try {
            DBHelper.getWriter().doUpdate("update exam_plan set check_state= 0  where id=?  ",
                    exam_plan);
        } catch (Exception e) {
            throw new GradeException(theClassName, 24, "成绩提交失败！", e);
        }
    }
    /**
     * 审核
     */
    public static void checkGradeByCourse(String jsonString) {
        JSONObject jsonObject = JSONObject.fromObject(jsonString);
        int exam_plan = jsonObject.getInt("exam_plan_id");
        boolean passed = jsonObject.getBoolean("passed");
        String remark = jsonObject.getString("remark");
        try {
            DBHelper writer = DBHelper.getWriter();
            writer.doUpdate("update exam_plan set check_state= ? , remark1 = ? where id=?  ",
                    passed ? 1 : -1, remark, exam_plan);
            // writer.doUpdate("update `grade_student` SET `final_exam_grade`=0 where `exam_plan_id`=? ",exam_plan);
        } catch (Exception e) {
            throw new GradeException(theClassName, 24, "审核失败！", e);
        }
    }

    //审批
    public static void checkGradeByCourse2(String jsonString) {
        JSONObject jsonObject = JSONObject.fromObject(jsonString);
        int exam_plan = jsonObject.getInt("exam_plan_id");
        boolean passed = jsonObject.getBoolean("passed");
        String remark = jsonObject.getString("remark");
        try {
            DBHelper.getWriter().doUpdate("update exam_plan set check_state= ? , remark2 = ? where id=?  ",
                    passed ? 2 : -2, remark, exam_plan);
        } catch (Exception e) {
            throw new GradeException(theClassName, 24, "审批失败！", e);
        }
    }


    /*
      查询学生成绩总库
      传过来的东西为查询条件

      查询条件为：开课学期，考试性质，上课院系，上课班级，学生学号，学生姓名，课程性质，课程类别，课程名称
     */
    //TODO SQL 字符串拼接时，应保证行尾有空格！ 后面的很多方法都存在该问题
    public static JSONArray queryTotalGrade(String jsonString) throws SQLException {
        JSONObject jobj_select = JSONObject.fromObject(jsonString);

        String academic_year = jobj_select.getString("academic_year");
        int exam_state = jobj_select.getInt("exam_state");
        String class_name = jobj_select.getString("class_name");

        int student_number = jobj_select.getInt("student_number");

        String nature = jobj_select.getString("nature");
        String category = jobj_select.getString("category");
        String course_name = jobj_select.getString("course_name");

        List<String> sqlist = new ArrayList<String>();
        List<Object> params = new ArrayList<Object>();

        sqlist.add("select ac.academic_year,sb.student_number,sb.stuname,course.course_code,course.course_name,cg.class_name," +
                "gs.totel_grade,ac.credits,ac.total_classes,dcn.nature,dcc.category,gs.exam_state,tb.teacher_name " +
                "from teaching_task_view ac,student_basic sb,dict_courses course,class_grade cg,grade_student gs,dict_course_nature dcn,dict_course_category dcc,teacher_basic tb " +
                "where ac.class_id = sb.classroomid and ac.course_id = course.id and ac.class_id = cg.id " +
                "and sb.id = gs.student_id and ac.course_nature_id = dcn.id and ac.course_category_id = dcc.id " +
                "and tb.id = ac.teacher_id ");

        if (!StringUtils.isBlank(academic_year)) {
            sqlist.add(" and ac.academic_year = ? ");
            params.add(academic_year);
        }

        if (exam_state > -1) {
            sqlist.add(" and gs.exam_state =  ? ");
            params.add(exam_state);
        }

        if (!StringUtils.isBlank(class_name)) {
            sqlist.add(" and cg.class_name =  ? ");
            params.add(class_name);
        }

        if (student_number > 0) {
            sqlist.add(" and sb.student_number =  ? ");
            params.add(student_number);
        }

        if (!StringUtils.isBlank(nature)) {
            sqlist.add(" and dcn.nature = ? ");
            params.add(nature);
        }

        if (!StringUtils.isBlank(category)) {
            sqlist.add(" and dcc.category = ? ");
            params.add(category);
        }

        if (!StringUtils.isBlank(course_name)) {
            sqlist.add(" and course_name = ? ");
            params.add(course_name);
        }

        try {
            List<Map<String, Object>> resultList = DBHelper.getReader().doQuery(
                    StringUtils.join(sqlist, " "),
                    params.toArray(), DBHelper.keyAndTypes("academic_year", STRING,
                            "student_number", INTEGER, "student_name", STRING,
                            "course_code"/*课程编码*/, STRING, "course_name", STRING,
                            "class_name", STRING, "totel_grade", DOUBLE,
                            "credits"/*'总学分'*/, INTEGER, "total_classes"/*总学时*/, INTEGER,
                            "nature"/*课程性质*/, STRING, "category"/*课程类别*/, STRING,
                            "exam_state", INTEGER, "teacher_name", STRING)
//                    new String[]{"academic_year", "student_number", "student_name", "course_code", "course_name", "class_name", "totel_grade", "credits", "total_classes", "nature", "category", "exam_state", "teacher_name"}
            );

            return JSONArray.fromObject(resultList);
//        try (Connection reader = DBHelper.getReader().connect();
//             PreparedStatement preparedQuery=reader.prepareStatement(querySql.toString());
//        ){
//            ResultSet resultSet = preparedQuery.executeQuery();
//            JSONArray jarr = new JSONArray();
//            if (resultSet != null) {
//                while (resultSet.next()){
//                    JSONObject jobj = new JSONObject();
//                    jobj.put("academic_year",resultSet.getString(1));
//                    jobj.put("student_number",resultSet.getInt(2));
//                    jobj.put("student_name", resultSet.getString(3));
//                    jobj.put("course_code", resultSet.getInt(4));
//                    jobj.put("course_name", resultSet.getDouble(5));
//                    jobj.put("class_name", resultSet.getInt(6));
//                    jobj.put("totel_grade", resultSet.getInt(7));
//                    jobj.put("credits", resultSet.getInt(8));
//                    jobj.put("total_classes", resultSet.getInt(9));
//                    jobj.put("nature", resultSet.getString(10));
//                    jobj.put("category", resultSet.getString(11));
//                    jobj.put("exam_state", resultSet.getInt(12));
//                    jobj.put("teacher_name", resultSet.getString(13));
//                    jarr.add(jobj);
//                }
//            }
//            return jarr;
        } catch (SQLException e) {
            throw new GradeException(theClassName, 24, "查询失败！", e);
        }
    }


    /*
      教务处成绩管理员可通过“查看录入情况”，。
     */
    public static JSONArray gradeEnterControl(String jsonString) throws SQLException {
        //TODO 应补充查询条件 exam_state等 （该功能见 “成绩录入控制页面--点击 查看录入情况”）
        //TODO 查询结果应补充 提交标志 和 学生成绩数，需在exam_plan中新增“提交标志”字段
        String gradeEnterControlSql = "SELECT ac.teacher_id,tb.teacher_name,cg.class_name,course.course_name " +
                "FROM grade_student gs,exam_plan ep,teaching_task_view ac,teacher_basic tb,dict_courses course,class_grade cg " +
                "WHERE gs.exam_plan_id=ep.id AND ep.teaching_task_id = ac.id AND tb.id = ac.teacher_id AND ac.course_id = course.id AND ac.class_id = cg.id AND " +
                "gs.exam_state = 0 GROUP BY gs.exam_plan_id HAVING COUNT(*)>0";
        JSONArray jsonArray = new JSONArray();

        Connection reader = null;
        PreparedStatement preparedQuery = null;
        try {
            reader = DBHelper.getReader().connect();
            preparedQuery = reader.prepareStatement(gradeEnterControlSql);
            ResultSet resultSet = preparedQuery.executeQuery();
            if (resultSet != null) {
                while (resultSet.next()) {
                    JSONObject jsonObject = new JSONObject();

                    jsonObject.put("teacher_id", resultSet.getInt("teacher_id"));
                    jsonObject.put("teacher_name", resultSet.getString("teacher_name"));
                    jsonObject.put("classname", resultSet.getString("class_name"));
                    jsonObject.put("coursename", resultSet.getString("course_name"));

                    jsonArray.add(jsonObject);
                }
            }
            return jsonArray;
        } catch (SQLException e) {
            throw new GradeException(theClassName, 24, "查询失败！", e);
        }finally {
            if (preparedQuery!=null){
                preparedQuery.close();
            }
            if(reader!=null){
                reader.close();
            }
        }
    }

    private static long convertDateToLong(java.util.Date date) {
        if (date == null) {
            return 0;
        }
        return date.getTime();
    }

    /**
     * 按照教师姓名录入成绩 返回与教师有关的所有学生学号和姓名
     * 可以给我传教师名称、班级名称、课程名称
     */
    public static JSONArray queryStudentWithInfo(String JsonString) throws SQLException {
        //StringBuilder querySql = new StringBuilder();

        List<String> sqlist = new ArrayList<String>();
        List<Object> params = new ArrayList<Object>();

        sqlist.add("select  " +
                "sb.id,sb.student_number,sb.stuname,gs.regular_grade,gs.midterm_grade,gs.final_exam_grade,gs.totel_grade,gs.exam_state,ep.id,ac.semester,dc.course_code,dc.course_name,cg.class_name,ac.credits,ac.total_classes,cn.nature,tb.teacher_name,gs.reason,ep.`regular_per`, ep.`medium_per`,ep.`finalexam_per`,ep.grade_type,ep.check_state,ep.exam_type,ac.assessment_id   " +
                "from teaching_task_view ac   " +
                "JOIN exam_plan ep ON ep.teaching_task_id = ac.id   " +
                "JOIN grade_student gs ON ep.id = gs.exam_plan_id   " +
                "JOIN student_basic sb ON sb.id = gs.student_id   " +
                "LEFT JOIN teacher_basic tb ON ac.teacher_id=tb.id   " +
                "LEFT JOIN dict_courses dc ON ac.course_id = dc.id   " +
                "LEFT JOIN class_grade cg ON ac.class_id = cg.id   " +
                "LEFT JOIN dict_course_nature cn ON cn.id=ac.course_nature_id  " +
                "LEFT JOIN academic_year ay ON ac.semester = ay.academic_year WHERE 1=1 ");


        JSONObject jobj = JSONObject.fromObject(JsonString);

        if (checkString(jobj, "teacher_name")) {
            String teacher_name = jobj.getString("teacher_name");
            sqlist.add(" and tb.teacher_name LIKE ? ");
            params.add("%" + teacher_name + "%");
        }

        if (checkInt(jobj, "teacher_id")) {
            sqlist.add(" and tb.id = ? ");
            params.add(jobj.getInt("teacher_id"));
        }

        if (checkInt(jobj, "semester_id")) {
            sqlist.add(" and ay.id = ? ");
            params.add(jobj.getInt("semester_id"));
        }

        if (checkInt(jobj, "department_id")) {
            sqlist.add(" and sb.faculty = ? ");
            params.add(jobj.getInt("department_id"));
        }

        if (checkInt(jobj, "major_id")) {
            sqlist.add(" and sb.major = ? ");
            params.add(jobj.getInt("major_id"));
        }

        if (checkString(jobj, "student_name")) {
            String class_name = jobj.getString("student_name");
            sqlist.add(" and sb.stuname LIKE ? ");
            params.add("%" + class_name + "%");
        }

        if (checkInt(jobj, "student_number")) {
            sqlist.add(" and sb.student_number = ? ");
            params.add(jobj.getInt("student_number"));
        }

        //alarm  是警号 神奇的字段名称
        if (checkString(jobj, "alarm")) {
            sqlist.add(" and sb.alarm = ? ");
            params.add(jobj.getString("alarm"));
        }

        if (checkInt(jobj, "check_state")) {
            sqlist.add(" and ep.check_state = ? ");
            params.add(jobj.getInt("check_state") == 10 ? 0 : jobj.getInt("check_state"));
        }

        if (checkInt(jobj, "exam_type")) {
            sqlist.add(" and ep.exam_type = ? ");
            params.add(jobj.getInt("exam_type") - 1);
        }

        if (checkInt(jobj, "exam_state")) {
            sqlist.add(" and gs.exam_state = ? ");
            params.add(jobj.getInt("exam_state") == 10 ? 0 : jobj.getInt("exam_state"));
        }

        final String[] opArray = new String[]{"","=",">",">=","<","<=","!="};
        if (checkInt(jobj, "gradeOperation")) {
            sqlist.add(" and gs.totel_grade "+opArray[jobj.getInt("gradeOperation")]+" ? ");
            params.add(checkInt(jobj,"totalGrade") ? jobj.getInt("totalGrade"):0);
        }

        if (checkInt(jobj, "creditsOperation")) {
            sqlist.add(" and ac.credits "+opArray[jobj.getInt("creditsOperation")]+" ? ");
            params.add(checkInt(jobj,"credits") ? jobj.getInt("credits"):0);
        }

        JSONArray exam_state_range = jobj.optJSONArray("exam_state_range");
        if (exam_state_range!=null&&exam_state_range.size()>0) {
            sqlist.add(" and ("+StringUtils.repeat(" exam_state=? ","or",exam_state_range.size())+") ");
            for (int i = 0; i < exam_state_range.size(); i++) {
                params.add(exam_state_range.getInt(i));
            }
        }

        if (checkString(jobj, "class_name")) {
            String class_name = jobj.getString("class_name");
            sqlist.add(" and cg.class_name LIKE ? ");
            params.add("%" + class_name + "%");
        }

        if (checkInt(jobj, "class_id")) {
            sqlist.add(" and cg.id = ? ");
            params.add(jobj.getInt("class_id"));
        }

        if (checkInt(jobj, "course_id")) {
            sqlist.add(" and dc.id = ? ");
            params.add(jobj.getInt("course_id"));
        }

        if (checkString(jobj, "course_name")) {
            String course_name = jobj.getString("course_name");
            sqlist.add(" and dc.course_name LIKE ? ");
            params.add("%" + course_name + "%");
        }

        if (checkInt(jobj, "teaching_task_id")) {
            sqlist.add(" and ac.id = ? ");
            params.add(jobj.getInt("teaching_task_id"));
        }

        if (checkInt(jobj, "exam_plan_id")) {
            sqlist.add(" and ep.id = ? ");
            params.add(jobj.getInt("exam_plan_id"));
        }

        if (checkInt(jobj,"course_assessment")){
            sqlist.add(" and ac.assessment_id = ? ");
            params.add(jobj.getInt("course_assessment"));
        }

        sqlist.add(" order by sb.student_number ");


        JSONArray jsonArray = new JSONArray();

        try {
            List<Map<String, Object>> resultList = DBHelper.getReader().doQuery(
                    StringUtils.join(sqlist, " "),
                    params.toArray(), DBHelper.keyAndTypes(
                            "student_id", INTEGER,
                            "student_number", INTEGER,
                            "stuname", STRING,
                            "regular_grade", DOUBLE,
                            "midterm_grade", DOUBLE,
                            "final_exam_grade", DOUBLE,
                            "totel_grade", DOUBLE,
                            "exam_state", INTEGER,
                            "exam_plan_id", INTEGER,
                            "semester", STRING,
                            "course_code", STRING,
                            "course_name", STRING,
                            "class_name", STRING,
                            "credits", INTEGER,//学分
                            "total_classes", INTEGER,//学时
                            "course_nature", STRING,
                            "teacher_name", STRING,
                            "reason", STRING,//课程性质
                            "regular_per",DOUBLE,
                            "medium_per",DOUBLE,
                            "finalexam_per",DOUBLE,
                            "grade_type",SHORT,
                            "check_state",INTEGER,
                            "exam_type",INTEGER,
                            "assessment_id",INTEGER
                    )
//                new String[]{"student_number", "stuname"}
            );

            return JSONArray.fromObject(resultList);
        } catch (SQLException e) {
            throw new GradeException(theClassName, 24, "查询失败！", e);
        }
    }

    /**
     * @param jsonString
     * @return
     * @throws SQLException 审核和审批的查找 传需要查找的条目即可
     */
    public static JSONArray queryCheckWithInfo(String jsonString) throws SQLException {
        StringBuilder querySql = new StringBuilder();

        querySql.append("select tb.teacher_name,dc.course_name,cg.class_name,ep.exam_type,ep.check_state,ac.id,COUNT(*) as grade_totel," +
                "dd.departments_name,stu_dd.departments_name,major.major_name,ep.id,ay.id,ay.academic_year,ep.remark1,ep.remark2," +
                "dcc.category,dcn.nature,ass.assessment_name,ac.credits,ep.`regular_per`, ep.`medium_per`,ep.`finalexam_per`,ep.grade_type " +
                "from teaching_task_view ac," +
                "teacher_basic tb,dict_courses dc,class_grade cg,exam_plan ep,grade_student gs,academic_year ay,dict_departments dd,dict_departments AS stu_dd ,major," +
                "dict_course_category dcc,dict_course_nature dcn,dict_assessment ass " +
                "where ac.teacher_id = tb.id and ac.course_id = dc.id and ac.class_id = cg.id and ac.id = ep.teaching_task_id " +
                "and gs.exam_plan_id = ep.id and ay.academic_year = ac.semester and tb.faculty = dd.id AND cg.departments_id = stu_dd.id AND cg.majors_id = major.id " +
                "AND ac.course_category_id=dcc.id AND ac.course_nature_id=dcn.id AND ac.assessment_id=ass.id ");
        JSONObject jsonObject = JSONObject.fromObject(jsonString);

        if (checkInt(jsonObject, "academic_year_id")) {
            querySql.append(" and ay.id = " + jsonObject.getInt("academic_year_id"));
        }

        if (checkInt(jsonObject, "exam_type")) {
            querySql.append(" and ep.exam_type = " + (jsonObject.getInt("exam_type") - 1));
        }

        if (checkInt(jsonObject, "class_id")) {
            querySql.append(" and cg.id =" + jsonObject.getInt("class_id"));
        }

        if (checkInt(jsonObject, "teacher_id")) {
            querySql.append(" and tb.id =" + jsonObject.getInt("teacher_id"));
        }
        if (checkInt(jsonObject, "dict_course_id")) {
            querySql.append(" and dc.id =" + jsonObject.getInt("dict_course_id"));
        }
        if (checkInt(jsonObject, "check_state")) {
            querySql.append(" and ep.check_state=" + (jsonObject.getInt("check_state") == 10 ? 0 : jsonObject.getInt("check_state")));
        }
        if (checkInt(jsonObject, "dict_departments_id")) {
            querySql.append(" and dd.id=" + jsonObject.getInt("dict_departments_id"));
        }

        if (checkInt(jsonObject, "teaching_research_id")) {
            querySql.append(" and tb.teachering_office = " + jsonObject.getInt("teaching_research_id"));
        }

        querySql.append(" GROUP BY ep.id");
        if (checkString(jsonObject, "sort_order")) {
            querySql.append(" ORDER BY " + jsonObject.getString("sort_order"));
        }

        Connection reader = null;
        PreparedStatement preparedQuery = null;
        try {
            reader = DBHelper.getReader().connect();
            preparedQuery = reader.prepareStatement(querySql.toString());
            ResultSet resultSet = preparedQuery.executeQuery();
            JSONArray jsonArray = new JSONArray();
            while (resultSet.next()) {
                JSONObject jobj = new JSONObject();
                jobj.put("teacher_name", resultSet.getString(1));
                jobj.put("course_name", resultSet.getString(2));
                jobj.put("class_name", resultSet.getString(3));
                jobj.put("exam_type", resultSet.getInt(4));
                jobj.put("check_state", resultSet.getInt(5));
                jobj.put("teaching_task_id", resultSet.getInt(6));
                jobj.put("grade_count", resultSet.getLong(7));
                jobj.put("teacher_department_name", resultSet.getString(8));
                jobj.put("student_department_name", resultSet.getString(9));
                jobj.put("major_name", resultSet.getString(10));
                jobj.put("exam_plan_id", resultSet.getInt(11));
                jobj.put("academic_year_id", resultSet.getInt(12));
                jobj.put("academic_year", resultSet.getString(13));
                jobj.put("remark1", resultSet.getString(14));
                jobj.put("remark2", resultSet.getString(15));
                //dcc.category,dcn.nature,ass.assessment_name,ac.credits
                jobj.put("course_category", resultSet.getString(16));
                jobj.put("course_nature", resultSet.getString(17));
                jobj.put("course_assessment", resultSet.getString(18));
                jobj.put("credits", resultSet.getInt(19));
                jobj.put("regular_per", resultSet.getDouble(20));
                jobj.put("medium_per", resultSet.getDouble(21));
                jobj.put("finalexam_per", resultSet.getDouble(22));
                jobj.put("grade_type", resultSet.getShort(23));

                jsonArray.add(jobj);
            }
            return jsonArray;
        } catch (SQLException e) {
            throw new GradeException(theClassName, 24, "查询失败！", e);
        }finally {
            if(preparedQuery!=null)
                preparedQuery.close();
            if(reader!=null)
                reader.close();
        }
    }

    /**
     * @param jsonString
     * @return
     * @throws SQLException 查找需要生成补考重修的考试 传需要查找的条目即可
     */
    public static JSONArray queryMakeUp(String jsonString) throws SQLException {
        StringBuilder querySql = new StringBuilder();

        querySql.append("select tb.teacher_name,dc.course_name,cg.class_name,ep.exam_type,ep.check_state,ac.id,COUNT(*) as grade_totel,dd.departments_name,stu_dd.departments_name,major.major_name,ep.id,ay.id,ay.academic_year,ep.remark1,ep.remark2,dcc.category,dcn.nature,ass.assessment_name,ac.credits,ep.`regular_per`, ep.`medium_per`,ep.`finalexam_per`,ep.grade_type \n" +
                "from teaching_task_view ac,teacher_basic tb,dict_courses dc,class_grade cg,exam_plan ep,grade_student gs,academic_year ay,dict_departments dd,dict_departments AS stu_dd ,major,dict_course_category dcc,dict_course_nature dcn,dict_assessment ass where ac.teacher_id = tb.id and ac.course_id = dc.id and ac.class_id = cg.id and ac.id = ep.teaching_task_id and gs.exam_plan_id = ep.id and ay.academic_year = ac.semester and tb.faculty = dd.id AND cg.departments_id = stu_dd.id AND cg.majors_id = major.id AND ac.course_category_id=dcc.id AND ac.course_nature_id=dcn.id AND ac.assessment_id=ass.id AND ep.check_state=2 AND EXISTS (SELECT 1 FROM grade_student WHERE ep.id=exam_plan_id AND totel_grade<60 )  AND NOT EXISTS (SELECT 1 FROM exam_plan WHERE last_plan_id=ep.id)  ");
        JSONObject jsonObject = JSONObject.fromObject(jsonString);

        if (checkInt(jsonObject, "academic_year_id")) {
            querySql.append(" and ay.id = " + jsonObject.getInt("academic_year_id"));
        }

        if (checkInt(jsonObject, "exam_type")) {
            querySql.append(" and ep.exam_type = " + (jsonObject.getInt("exam_type") - 1));
        }

        if (checkInt(jsonObject, "class_id")) {
            querySql.append(" and cg.id =" + jsonObject.getInt("class_id"));
        }

        if (checkInt(jsonObject, "teacher_id")) {
            querySql.append(" and tb.id =" + jsonObject.getInt("teacher_id"));
        }
        if (checkInt(jsonObject, "dict_course_id")) {
            querySql.append(" and dc.id =" + jsonObject.getInt("dict_course_id"));
        }
        if (checkInt(jsonObject, "check_state")) {
            querySql.append(" and ep.check_state=" + (jsonObject.getInt("check_state") == 10 ? 0 : jsonObject.getInt("check_state")));
        }
        if (checkInt(jsonObject, "dict_departments_id")) {
            querySql.append(" and dd.id=" + jsonObject.getInt("dict_departments_id"));
        }

        if (checkInt(jsonObject, "teaching_research_id")) {
            querySql.append(" and tb.teachering_office = " + jsonObject.getInt("teaching_research_id"));
        }

        querySql.append(" GROUP BY ac.id");
        if (checkString(jsonObject, "sort_order")) {
            querySql.append(" ORDER BY " + jsonObject.getString("sort_order"));
        }

        Connection reader = null;
        PreparedStatement preparedQuery = null;
        try {
            reader = DBHelper.getReader().connect();
            preparedQuery = reader.prepareStatement(querySql.toString());
            ResultSet resultSet = preparedQuery.executeQuery();
            JSONArray jsonArray = new JSONArray();
            while (resultSet.next()) {
                JSONObject jobj = new JSONObject();
                jobj.put("teacher_name", resultSet.getString(1));
                jobj.put("course_name", resultSet.getString(2));
                jobj.put("class_name", resultSet.getString(3));
                jobj.put("exam_type", resultSet.getInt(4));
                jobj.put("check_state", resultSet.getInt(5));
                jobj.put("teaching_task_id", resultSet.getInt(6));
                jobj.put("grade_count", resultSet.getLong(7));
                jobj.put("teacher_department_name", resultSet.getString(8));
                jobj.put("student_department_name", resultSet.getString(9));
                jobj.put("major_name", resultSet.getString(10));
                jobj.put("exam_plan_id", resultSet.getInt(11));
                jobj.put("academic_year_id", resultSet.getInt(12));
                jobj.put("academic_year", resultSet.getString(13));
                jobj.put("remark1", resultSet.getString(14));
                jobj.put("remark2", resultSet.getString(15));
                //dcc.category,dcn.nature,ass.assessment_name,ac.credits
                jobj.put("course_category", resultSet.getString(16));
                jobj.put("course_nature", resultSet.getString(17));
                jobj.put("course_assessment", resultSet.getString(18));
                jobj.put("credits", resultSet.getInt(19));
                jobj.put("regular_per", resultSet.getDouble(20));
                jobj.put("medium_per", resultSet.getDouble(21));
                jobj.put("finalexam_per", resultSet.getDouble(22));
                jobj.put("grade_type", resultSet.getShort(23));

                jsonArray.add(jobj);
            }
            return jsonArray;
        } catch (SQLException e) {
            throw new GradeException(theClassName, 24, "查询失败！", e);
        }finally {
            if(preparedQuery!=null)
                preparedQuery.close();
            if(reader!=null)
                reader.close();
        }
    }


    public static List<Map<String, Object>> queryMakeUp2(String jsonString) throws SQLException{
        List<String> sqlist = new ArrayList<String>();
        List<Object> params = new ArrayList<Object>();
        JSONObject jsonObject = JSONObject.fromObject(jsonString);
        sqlist.add("SELECT tv.id,semester_id,semester,course_id,course_name,major_id,major_name,dict_departments_id,departments_name,teaching_research_number,teaching_research_name,class_id,class_name,student_count,course_nature_id,nature,teacher_id,teacher_name,assessment_id,assessment_name,exam_plan.id,exam_plan.exam_type,COUNT(DISTINCT gs.id) as grade_totel,exam_plan.`regular_per`, exam_plan.`medium_per`,exam_plan.`finalexam_per`,exam_plan.grade_type,exam_plan.check_state,tv.course_category_id,tv.nature,tv.assessment_id,tv.assessment_name,tv.credits,COUNT(ep.id) as eps,ep.id\n" +
                "FROM exam_plan JOIN teaching_task_join_view tv ON tv.id = exam_plan.teaching_task_id\n" +
                "JOIN grade_student gs ON(exam_plan.id = gs.exam_plan_id)\n" +
                " left join exam_plan as ep on (exam_plan.id=ep.last_plan_id) \n" +
                "WHERE \n" +
                "exam_plan.check_state=2 \n" +
                "AND EXISTS (SELECT 1 FROM grade_student WHERE exam_plan.id=exam_plan_id AND totel_grade<60 ) \n" +
                "AND gs.totel_grade<60\n"
        );
        if (checkInt(jsonObject, "academic_year_id")) {
            sqlist.add("AND semester_id=? ");
            params.add(jsonObject.getInt("academic_year_id"));
        }

        if (checkInt(jsonObject, "class_id")) {
            sqlist.add("AND class_id=? ");
            params.add(jsonObject.getInt("class_id"));
        }

        if (checkInt(jsonObject, "teacher_id")) {
            sqlist.add("AND teacher_id=? ");
            params.add(jsonObject.getInt("teacher_id"));
        }
        if (checkInt(jsonObject, "course_id")) {
            sqlist.add("AND course_id=? ");
            params.add(jsonObject.getInt("course_id"));
        }

        if (checkInt(jsonObject, "dict_departments_id")) {
            sqlist.add("AND dict_departments_id=? ");
            params.add(jsonObject.getInt("dict_departments_id"));
        }

        if (checkInt(jsonObject, "teaching_research_id")) {
            sqlist.add("AND teaching_research_number=? ");
            params.add(jsonObject.getInt("teaching_research_id"));
        }

        //筛选出已创建考试的课程
        if(checkBoolean(jsonObject,"plan_maked")){
            sqlist.add("AND exam_plan.id IS NOT NULL ");
        }

        //筛选出班级人数非空的课程
        if(checkBoolean(jsonObject,"class_not_empty")){
            sqlist.add("AND student_count>0 ");
        }

        if (checkInt(jsonObject,"course_assessment")){
            sqlist.add(" and tv.assessment_id = ? ");
            params.add(jsonObject.getInt("course_assessment"));
        }

        sqlist.add(" GROUP BY exam_plan.id");

        System.out.println(sqlist);
        System.out.println(params);
        try {
            return DBHelper.getReader().doQuery(
                    StringUtils.join(sqlist, " "),
                    params.toArray(), DBHelper.keyAndTypes(
                            "id", INTEGER,
                            "semester_id", INTEGER,
                            "semester", STRING,
                            "course_id", INTEGER,
                            "course_name", STRING,
                            "major_id", INTEGER,
                            "major_name", STRING,
                            "dict_departments_id", INTEGER,
                            "departments_name", STRING,
                            "teaching_research_number", INTEGER,
                            "teaching_research_name", STRING,
                            "class_id", INTEGER,
                            "class_name", STRING,
                            "student_count",INTEGER,
                            "course_nature_id", INTEGER,
                            "nature", STRING,
                            "teacher_id", INTEGER,
                            "teacher_name", STRING,
                            "assessment_id", INTEGER,
                            "assessment_name",STRING,
                            "exam_plan_id",INTEGER,
                            "exam_type",INTEGER,
                            "grade_totel",INTEGER,
                            "regular_per",DOUBLE,
                            "medium_per",DOUBLE,
                            "finalexam_per",DOUBLE,
                            "grade_type",SHORT,
                            "check_state",SHORT,
                            "course_category",INTEGER,
                            "course_nature",STRING,
                            "course_assessment",INTEGER,
                            "assessment_name",STRING,
                            "credits",INTEGER,
                            "eps",INTEGER,
                            "new_plan_id",INTEGER
                    ));
        }catch (Exception ex){
            ex.printStackTrace();
            return Collections.emptyList();
        }
    }

    /**
     * @param jsonString
     * @return 缓考的相关查询，补考与这个类似 补考和缓考的 check_state 可以确定 所以可以写在一个函数中
     */
    public static JSONArray queryPostponeExam(String jsonString) throws SQLException {
        StringBuilder querySql = new StringBuilder();

        querySql.append("SELECT ac.academic_year,sb.stuname,dc.course_name,ep.check_state,cg.class_name,ep.exam_type,dcn.nature,ac.credits,ac.total_classes " +
                "from teaching_task_view ac,academic_year ay,exam_plan ep,grade_student gs,dict_course_nature dcn,student_basic sb,dict_courses dc,class_grade cg,dict_course_category dcc,dict_departments dd " +
                "where ac.academic_year = ay.academic_year and ep.teaching_task_id = ac.id and gs.exam_plan_id = ep.id and ac.course_id = dc.id and ac.class_id = cg.id and ac.course_nature_id = dcn.id and dcc.id = ac.course_category_id and ac.dict_departments_id = dd.id");

        JSONObject jsonObject = JSONObject.fromObject(jsonString);

        int academic_year_id = jsonObject.getInt("academic_year_id");
        int class_id = jsonObject.getInt("class_id");
        int dict_departments_id = jsonObject.getInt("dict_departments_id");

        int check_state = jsonObject.getInt("check_state");
        int dict_nature_id = jsonObject.getInt("dict_nature_id");

        int dict_category_id = jsonObject.getInt("dict_category_id");

        int dict_course_id = jsonObject.getInt("dict_course_id");

        int flag = jsonObject.getInt("flag");

        if (academic_year_id >= 0) {
            querySql.append(" and ay.id = " + dict_course_id);
        }

        if (class_id >= 0) {
            querySql.append(" and cg.id = " + class_id);
        }


        if (dict_departments_id >= 0) {
            querySql.append(" and ac.dict_departments_id = " + dict_departments_id);
        }


        if (check_state >= -3) {
            querySql.append(" and ep.check_state=" + check_state);
        }

        if (dict_nature_id >= 0) {
            querySql.append(" and dcn.id = " + dict_nature_id);
        }

        if (dict_category_id >= 0) {
            querySql.append(" and dcc.id = " + dict_category_id);
        }

        if (dict_course_id >= 0) {
            querySql.append(" and dc.id = " + dict_course_id);
        }

        //代表是补考
        if (flag == 1) {
            querySql.append(" and gs.exam_state = 2");
        } else {
            querySql.append(" and gs.exam_state = 3");
        }

        Connection reader = null;
        PreparedStatement preparedQuery = null;
        try{
            reader = DBHelper.getReader().connect();
            preparedQuery = reader.prepareStatement(querySql.toString());
            ResultSet resultSet = preparedQuery.executeQuery();
            JSONArray jsonArray = new JSONArray();

            while (resultSet.next()) {
                JSONObject jobj = new JSONObject();

                jobj.put("academic_year", resultSet.getString(1));
                jobj.put("stuname", resultSet.getString(2));
                jobj.put("course_name", resultSet.getString(3));
                jobj.put("exam_type", resultSet.getInt(6));
                jobj.put("class_name", resultSet.getString(5));
                jobj.put("check_state", resultSet.getInt(4));
                jobj.put("course_nature", resultSet.getString(7));
                jobj.put("credit", resultSet.getInt(8));
                jobj.put("total_classes", resultSet.getInt(9));

                jsonArray.add(jobj);
            }

            return jsonArray;
        } catch (SQLException e) {
            throw new GradeException(theClassName, 24, "查询失败！", e);
        }finally {
            if(preparedQuery!=null)
                preparedQuery.close();
            if(reader!=null)
                reader.close();
        }
    }

    /**
     * 增添缓考的学生
     *
     * @param jsonString
     */
    public static void addExamStateInfo(String jsonString) throws SQLException {
        JSONObject jsonObject = JSONObject.fromObject(jsonString);
        int academic_year_id = jsonObject.getInt("academic_year_id");
        int dict_departments_id = jsonObject.getInt("dict_departments_id");
        int class_id = jsonObject.getInt("class_id");

        String stuname = jsonObject.getString("stuname");

        String sql = "UPDATE grade_student  " +
                "INNER JOIN teaching_task ac,academic_year ay,dict_departments dd,grade_student gs,exam_plan ep,student_basic sb,class_grade cg " +
                "SET grade_student.exam_state = 3 " +
                "WHERE dd.id = ac.dict_departments_id AND ay.academic_year=ac.academic_year AND ac.class_id = cg.id AND gs.exam_plan_id = ep.id AND ep.teaching_task_id = ac.id AND sb.id = gs.student_id " +
                "AND ay.id = ? AND ac.dict_departments_id = ? AND cg.id =? AND sb.stuname = ?";

        Connection writer = null;
        PreparedStatement preparedStatement = null;
        try {
            writer = DBHelper.getWriter().connect();
            preparedStatement = writer.prepareStatement(sql);

            writer.setAutoCommit(false);

            preparedStatement.setInt(1, academic_year_id);
            preparedStatement.setInt(2, dict_departments_id);
            preparedStatement.setInt(3, class_id);
            preparedStatement.setString(4, stuname);
            preparedStatement.execute();

            writer.commit();
        } catch (SQLException e) {
            throw new GradeException(theClassName, 24, "修改失败！", e);
        }finally {
            if(preparedStatement!=null)
                preparedStatement.close();
            if(writer!=null)
                writer.close();
        }
    }

    public static void doMakeUp(String jsonString) throws SQLException{
        JSONObject jsonObject = JSONObject.fromObject(jsonString);
        int exam_plan_id = jsonObject.getInt("exam_plan_id");
        int exam_type = jsonObject.getInt("exam_type");

        Set<Integer> excludeIds = new HashSet<>();
        if (jsonObject.containsKey("exclude")){
            JSONArray excludes = jsonObject.getJSONArray("exclude");
            for (int i = 0; i < excludes.size(); i++) {
                JSONObject ex = excludes.getJSONObject(i);
                if (ex.getBoolean("checked")){
                    excludeIds.add(ex.getInt("id"));
                }
            }
        }

        Connection writer = null;
        PreparedStatement preparedStatement = null;
        PreparedStatement preparedStatement2 = null;

        String sql = "INSERT INTO `exam_plan` (`teaching_task_id`, `last_plan_id`, `exam_date`, `exam_place`, `exam_type`, `check_state`, `remark1`, `remark2`, `regular_per`, `medium_per`, `finalexam_per`, `grade_type`)" +
                " SELECT ep.teaching_task_id,ep.id,?,?,?,5, NULL, NULL, '20.00', '30.00', '50.00', '0' FROM exam_plan ep WHERE ep.id=? ";

        String sql2 = "INSERT INTO `grade_student` (`exam_plan_id`, `student_id`, `regular_grade`, `midterm_grade`, `final_exam_grade`, `totel_grade`, `exam_state`, `reason`) " +
                "SELECT ?,gs.student_id,'0', '0', '0', '0', '0', NULL FROM grade_student gs WHERE gs.exam_plan_id=? " +
                "AND gs.totel_grade<60 ";
        for (Integer excludeId : excludeIds) {
            sql2 += " and gs.exam_state!="+excludeId;
        }
        try {
            writer = DBHelper.getWriter().connect();
            preparedStatement = writer.prepareStatement(sql,Statement.RETURN_GENERATED_KEYS);
            preparedStatement2 = writer.prepareStatement(sql2);
            writer.setAutoCommit(false);

            preparedStatement.setDate(1, new Date(Calendar.getInstance().getTimeInMillis()));
            preparedStatement.setString(2, "未指定");
            preparedStatement.setInt(3, exam_type);
            preparedStatement.setInt(4, exam_plan_id);

            preparedStatement.execute();
            ResultSet rs = preparedStatement.getGeneratedKeys();
            if(rs.next()){
                int ep_id = rs.getInt(1);
                preparedStatement2.setInt(1,ep_id);
                preparedStatement2.setInt(2,exam_plan_id);
                preparedStatement2.executeUpdate();
            }

            writer.commit();
        } catch (SQLException e) {
            throw new GradeException(theClassName, 24, "修改失败！", e);
        }finally {
            if(preparedStatement!=null)
                preparedStatement.close();
            if(writer!=null)
                writer.close();
        }

    }

    /**
     * 批量增添缓考的学生
     *
     * @param jsonString
     */
    public static void addExamStateInfoBatch(String jsonString) throws SQLException {
        JSONArray jsonArray = JSONArray.fromObject(jsonString);

        String sql = "UPDATE grade_student  " +
                "SET grade_student.exam_state = ?,reason=?,regular_grade=0,midterm_grade=0,final_exam_grade=0,totel_grade=0 " +
                "WHERE exam_plan_id=? AND student_id=? ";

        Connection writer = null;
        PreparedStatement preparedStatement = null;
        try {
            writer = DBHelper.getWriter().connect();
            preparedStatement = writer.prepareStatement(sql);

            writer.setAutoCommit(false);

            for (int i = 0; i < jsonArray.size(); i++) {
                JSONObject jsonObject = jsonArray.getJSONObject(i);
                int student_id = jsonObject.getInt("student_id");
                int exam_plan_id = jsonObject.getInt("exam_plan_id");
                int exam_state = jsonObject.getInt("exam_state");

                if(exam_state<3 || exam_state>5){
                    continue;
                }

                String reason = jsonObject.getString("reason");

                preparedStatement.setInt(1, exam_state);
                preparedStatement.setString(2,reason);
                preparedStatement.setInt(3, exam_plan_id);
                preparedStatement.setInt(4, student_id);
                preparedStatement.execute();
            }

            writer.commit();
        } catch (SQLException e) {
            throw new GradeException(theClassName, 24, "修改失败！", e);
        }finally {
            if(preparedStatement!=null)
                preparedStatement.close();
            if(writer!=null)
                writer.close();
        }
    }

    /**
     * 生成正常考试计划
     */
    public static void makeExamPlan(String jsonString) throws SQLException {
        JSONObject jsonObject = JSONObject.fromObject(jsonString);
        final int teaching_task_id = jsonObject.getInt("teaching_task_id");
        final long exam_date;
        final String exam_place;

        double regular_per = 20;
        double medium_per = 30;
        double finalexam_per = 50;

        if(checkString(jsonObject,"exam_place")){
            exam_place = jsonObject.getString("exam_place");
        }else {
            exam_place = "未指定";
        }

        if(checkLong(jsonObject,"exam_date")){
            exam_date = jsonObject.getLong("exam_date");
        }else {
            exam_date = new java.util.Date().getTime();
        }

        if(checkDouble(jsonObject,"regular_per")){
            double _regularPer = jsonObject.getDouble("regular_per");
            regular_per = _regularPer>=0 ? _regularPer : regular_per;
        }

        if(checkDouble(jsonObject,"medium_per")){
            double _medium_per = jsonObject.getDouble("medium_per");
            medium_per = _medium_per>=0 ? _medium_per : medium_per;
        }

        if(checkDouble(jsonObject,"finalexam_per")){
            double _finalexam_per = jsonObject.getDouble("finalexam_per");
            finalexam_per = _finalexam_per>=0 ? _finalexam_per : finalexam_per;
        }

        int grade_type = 0;
        if(checkInt(jsonObject,"grade_type")){
            grade_type = jsonObject.getInt("grade_type");
        }

        final double[] exam_pers = new double[]{regular_per,medium_per,finalexam_per};

        final List<Map<String, Object>> stu_ids = DBHelper.getReader().doQuery("SELECT student_basic.id AS stu " +
                "FROM teaching_task_view AS ac INNER JOIN student_basic ON ac.class_id = student_basic.classroomid " +
                "WHERE ac.id = ? ", new Object[]{teaching_task_id}, DBHelper.keyAndTypes("stu_id", INTEGER));

        final int finalGrade_type = grade_type;

        DBHelper.getWriter().doExecute(new DBHelper.SqlUpdate() {
            @Override
            public void acceptConnection(Connection connection) throws SQLException {
                PreparedStatement insertPlan = null;
                PreparedStatement insertStudentGrade = null;
                try  {
                    insertPlan = connection.prepareStatement(
                            "INSERT INTO exam_plan (teaching_task_id, last_plan_id, exam_date, exam_place" +
                                    ", exam_type, check_state, remark1, remark2, `regular_per`, `medium_per`, `finalexam_per`,`grade_type`) " +
                                    "VALUES (?,NULL ,?,?,0,5,NULL ,NULL ,?,?,?,?)", Statement.RETURN_GENERATED_KEYS);
                    insertStudentGrade = connection.prepareStatement(
                            "INSERT INTO grade_student (exam_plan_id, student_id, regular_grade, " +
                                    "midterm_grade, final_exam_grade, totel_grade, exam_state) " +
                                    "VALUES (?,?,0,0,0,0,0)");
                    insertPlan.setInt(1, teaching_task_id);
                    insertPlan.setDate(2, new java.sql.Date(exam_date));
                    insertPlan.setString(3, exam_place);

                    insertPlan.setDouble(4,exam_pers[0]);
                    insertPlan.setDouble(5,exam_pers[1]);
                    insertPlan.setDouble(6,exam_pers[2]);

                    insertPlan.setShort(7, (short) finalGrade_type);

                    insertPlan.executeUpdate();

                    ResultSet rs = insertPlan.getGeneratedKeys();
                    if (rs.next()) {
                        int exam_plan_id = rs.getInt(1);
                        insertStudentGrade.setInt(1, exam_plan_id);
                        for (Map<String, Object> student : stu_ids) {
                            insertStudentGrade.setInt(2, (Integer) student.get("stu_id"));
                            insertStudentGrade.addBatch();
                        }
                        insertStudentGrade.executeBatch();
                    }
                }finally {
                    if(insertStudentGrade!=null)
                        insertStudentGrade.close();
                    if(insertPlan!=null)
                        insertPlan.close();
                }
            }
        });

    }

    public static void makeExamPlanBatch(String jsonString) throws SQLException {
        JSONArray jsonArray = JSONArray.fromObject(jsonString);
        for (int i=0;i<jsonArray.size();i++){
            makeExamPlan(jsonArray.getJSONObject(i).toString());
        }
    }

    public static void modifyCourseInfo(String jsonString) throws SQLException{
        JSONObject jsonObject = JSONObject.fromObject(jsonString);

        int course_category = jsonObject.getInt("course_category");
        int course_nature = jsonObject.getInt("course_nature");
        int course_assessment = jsonObject.getInt("course_assessment");
        int credits = jsonObject.getInt("credits");
        int teaching_task_id = jsonObject.getInt("teaching_task_id");
        String sql = "UPDATE teaching_task SET course_category_id=?,course_nature_id=?,assessment_id=?,credits=? WHERE id=?";
        Connection writer = null;
        PreparedStatement preparedStatement = null;
        try {
            writer = DBHelper.getWriter().connect();
            preparedStatement = writer.prepareStatement(sql);

            writer.setAutoCommit(false);

            preparedStatement.setInt(1, course_category);
            preparedStatement.setInt(2, course_nature);
            preparedStatement.setInt(3, course_assessment);
            preparedStatement.setInt(4, credits);
            preparedStatement.setInt(5, teaching_task_id);
            preparedStatement.execute();

            writer.commit();
        } catch (SQLException e) {
            throw new GradeException(theClassName, 24, "修改失败！", e);
        }finally {
            if(preparedStatement!=null)
                preparedStatement.close();
            if(writer!=null)
                writer.close();
        }
    }

    /*查询院系列表*/
    public static List<Map<String, Object>> queryDepartment(String jsonString) {
        try {
            return DBHelper.getReader().doQuery(
                    "SELECT id,departments_name FROM dict_departments ",
                    new Object[0], DBHelper.keyAndTypes("id", INTEGER, "name", STRING));
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return Collections.emptyList();
    }

    /**
     * 查询教研室
     */
    public static List<Map<String, Object>> queryResearchPostions(String jsonString) {
        JSONObject jsonObject = JSONObject.fromObject(jsonString);
        try {
            List<String> sqlist = new ArrayList<String>();
            List<Object> params = new ArrayList<Object>();

            sqlist.add("SELECT id,teaching_research_name FROM teaching_research ");
            if (checkInt(jsonObject, "department_id")) {
                sqlist.add("WHERE departments_id=? ");
                params.add(jsonObject.getInt("department_id"));
            }

            return DBHelper.getReader().doQuery(
                    StringUtils.join(sqlist, " "),
                    params.toArray(), DBHelper.keyAndTypes("id", INTEGER, "name", STRING));
        } catch (Exception e) {
            e.printStackTrace();
        }
        return Collections.emptyList();
    }

    /**
     * 查询教研室
     */
    public static List<Map<String, Object>> queryMajor(String jsonString) {
        System.out.println(jsonString);
        JSONObject jsonObject = JSONObject.fromObject(jsonString);
        try {
            List<String> sqlist = new ArrayList<String>();
            List<Object> params = new ArrayList<Object>();

            sqlist.add("SELECT id,major_name FROM major WHERE 1=1 ");
            sqlist.add(" and departments_id=? ");
            if (checkInt(jsonObject, "department_id")) {
                sqlist.add(" and departments_id=? ");
                params.add(jsonObject.getInt("department_id"));
            }

            return DBHelper.getReader().doQuery(
                    StringUtils.join(sqlist, " "),
                    params.toArray(), DBHelper.keyAndTypes("id", INTEGER, "name", STRING));
        } catch (Exception e) {
            e.printStackTrace();
        }
        return Collections.emptyList();
    }


    /**
     * 查询学生
     */
    public static List<Map<String, Object>> queryStudent(String jsonString) {
        System.out.println(jsonString);
        JSONObject jsonObject = JSONObject.fromObject(jsonString);
        try {
            List<String> sqlist = new ArrayList<String>();
            List<Object> params = new ArrayList<Object>();

            sqlist.add("SELECT id,stuname FROM student_basic WHERE 1=1 ");
            if (checkInt(jsonObject, "department_id")) {
                sqlist.add("and faculty=? ");
                params.add(jsonObject.getInt("department_id"));
            }
            if (checkInt(jsonObject, "student_major_id")) {
                sqlist.add("and major=? ");
                params.add(jsonObject.getInt("student_major_id"));
            }
            if (checkInt(jsonObject, "student_class_id")) {
                sqlist.add("and classroomid=? ");
                params.add(jsonObject.getInt("student_class_id"));
            }

            return DBHelper.getReader().doQuery(
                    StringUtils.join(sqlist, " "),
                    params.toArray(), DBHelper.keyAndTypes("id", INTEGER, "name", STRING));
        } catch (Exception e) {
            e.printStackTrace();
        }
        return Collections.emptyList();
    }

    /*查询职称列表*/
    public static List<Map<String, Object>> queryTeacherTitles(String jsonString) {
        try {
            return DBHelper.getReader().doQuery(
                    "SELECT id,teacher_title_name FROM teacher_title ",
                    new Object[0], DBHelper.keyAndTypes("id", INTEGER, "name", STRING));
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return Collections.emptyList();
    }

    /*查询教师列表*/
    public static List<Map<String, Object>> queryTeachers(String jsonString) {
        JSONObject jsonObject = JSONObject.fromObject(jsonString);
        try {
            List<String> sqlist = new ArrayList<String>();
            List<Object> params = new ArrayList<Object>();

            sqlist.add("SELECT id,teacher_name FROM teacher_basic WHERE 1=1 ");
            if (checkInt(jsonObject, "faculty")) {
                sqlist.add("AND faculty=? ");
                params.add(jsonObject.getInt("faculty"));
            }

            if (checkInt(jsonObject, "teachering_office")) {
                sqlist.add("AND teachering_office=? ");
                params.add(jsonObject.getInt("teachering_office"));
            }

            if (checkInt(jsonObject, "technical_title")) {
                sqlist.add("AND technical_title=? ");
                params.add(jsonObject.getInt("technical_title"));
            }

            if (checkInt(jsonObject, "semester_id")) {
                sqlist.add("AND EXISTS (SELECT 1 FROM teaching_task_view,academic_year " +
                        "WHERE teaching_task_view.semester=academic_year.academic_year " +
                        "AND academic_year.id=? AND teaching_task_view.teacher_id=teacher_basic.id)");
                params.add(jsonObject.getInt("semester_id"));
            }

            if (jsonObject.has("teacher_name")) {
                sqlist.add("AND teacher_name LIKE ? ");
                params.add("%" + jsonObject.getString("teacher_name") + "%");
            }

            /**
             * 教师编号
             */
            if (jsonObject.has("teacher_number")) {
                sqlist.add("AND teacher_number LIKE ? ");
                params.add("%" + jsonObject.getString("teacher_number") + "%");
            }

            return DBHelper.getReader().doQuery(
                    StringUtils.join(sqlist, " "),
                    params.toArray(), DBHelper.keyAndTypes("id", INTEGER, "name", STRING));
        } catch (Exception e) {
            e.printStackTrace();
        }
        return Collections.emptyList();
    }

    /*查询学期列表*/
    public static List<Map<String, Object>> querySemester(String jsonString) {
        try {
            return DBHelper.getReader().doQuery(
                    "SELECT id,academic_year FROM academic_year ",
                    new Object[0], DBHelper.keyAndTypes("id", INTEGER, "name", STRING));
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return Collections.emptyList();
    }

    /*查询课程列表*/
    public static List<Map<String, Object>> queryCourses(String jsonString) {
        JSONObject jsonObject = JSONObject.fromObject(jsonString);
        try {
            List<String> sqlist = new ArrayList<String>();
            List<Object> params = new ArrayList<Object>();

            sqlist.add("select dd1.departments_name,dc.course_name,tb.teacher_name,cg.class_name,dd2.departments_name,m.major_name,ep.exam_type,ep.check_state,ac.id " +
                    "from teaching_task_view ac  " +
                    "LEFT JOIN teacher_basic tb ON ac.teacher_id=tb.id  " +
                    "LEFT JOIN dict_courses dc ON ac.course_id = dc.id  " +
                    "LEFT JOIN class_grade cg ON ac.class_id = cg.id  " +
                    "LEFT JOIN exam_plan ep ON ep.teaching_task_id = ac.id " +
                    "LEFT JOIN major m ON cg.majors_id = m.id " +
                    "LEFT JOIN academic_year ay ON ac.semester = ay.academic_year " +
                    "LEFT JOIN dict_departments dd1 ON tb.faculty = dd1.id " +
                    "LEFT JOIN dict_departments dd2 ON cg.departments_id = dd2.id " +
                    "WHERE cg.id IS NOT NULL AND tb.id IS NOT NULL ");

            if (checkInt(jsonObject, "exam_type")) {
                sqlist.add("AND ep.exam_type=? ");
                params.add(jsonObject.getInt("exam_type") - 1);
            }

            if (checkInt(jsonObject, "check_state")) {
                sqlist.add("AND ep.check_state=? ");
                params.add(jsonObject.getInt("check_state") == 10 ? 0 : jsonObject.getInt("check_state"));
            }

            //开课院系
            if (checkInt(jsonObject, "faculty")) {
                sqlist.add("AND tb.faculty=? ");
                params.add(jsonObject.getInt("faculty"));
            }

            //上课院系
            if (checkInt(jsonObject, "departments")) {
                sqlist.add("AND dd2.id=?");
                params.add(jsonObject.getInt("departments"));
            }

            if (checkInt(jsonObject, "majod_id")) {
                sqlist.add("AND m.id = ? ");
                params.add(jsonObject.getInt("majod_id"));
            }
            if (checkInt(jsonObject, "academic_year_id")) {
                sqlist.add("AND ay.id = ? ");
                params.add(jsonObject.getInt("academic_year_id"));
            }

            if (jsonObject.has("course_name")) {
                sqlist.add("AND dc.course_name LIKE ?");
                params.add("%" + jsonObject.getString("course_name") + "%");
            }

            if (jsonObject.has("teacher_name")) {
                sqlist.add("AND tb.teacher_name LIKE ?");
                params.add("%" + jsonObject.get("teacher_name") + "%");
            }

            if (checkInt(jsonObject, "teacher_id")) {
                sqlist.add("AND tb.id = ?");
                params.add(jsonObject.getInt("teacher_id"));
            }

            return DBHelper.getReader().doQuery(
                    StringUtils.join(sqlist, " "),
                    params.toArray(), DBHelper.keyAndTypes(
                            "departments_name_1", STRING,//开课院系
                            "name", STRING,
                            "teacher_name", STRING,
                            "class_name", STRING,
                            "departments_name_2", STRING,//上课院系
                            "major_name", STRING,
                            "exam_state", INTEGER,
                            "check_state", INTEGER,
                            "id", INTEGER)); //排课id
        } catch (Exception e) {
            e.printStackTrace();
        }
        return Collections.emptyList();
    }

    /*查询课程列表--简易版*/
    public static List<Map<String, Object>> queryCourses2(String jsonString) {
        JSONObject jsonObject = JSONObject.fromObject(jsonString);
        try {
            List<String> sqlist = new ArrayList<String>();
            List<Object> params = new ArrayList<Object>();

            sqlist.add("SELECT id,course_name,dict_departments_id,departments_name,teaching_research_id,teaching_research_name FROM course_view WHERE 1=1 ");

            //开课院系
            if (checkInt(jsonObject, "faculty")) {
                sqlist.add("AND dict_departments_id=? ");
                params.add(jsonObject.getInt("faculty"));
            }

            if (checkInt(jsonObject, "teaching_research_id")) {
                sqlist.add("AND teaching_research_id=? ");
                params.add(jsonObject.getInt("teaching_research_id"));
            }

            if (checkInt(jsonObject, "class_id")) {
                sqlist.add("AND EXISTS (SELECT 1 FROM arrage_coursesystem WHERE arrage_coursesystem.course_id=course_view.id and arrage_coursesystem.class_id=?) ");
                params.add(jsonObject.getInt("class_id"));
            }

            if (checkString(jsonObject,"course_name")) {
                sqlist.add("AND course_name LIKE ? ");
                params.add("%" + jsonObject.getString("course_name") + "%");
            }

            return DBHelper.getReader().doQuery(
                    StringUtils.join(sqlist, " "),
                    params.toArray(), DBHelper.keyAndTypes(
                            "id", INTEGER,
                            "name", STRING,
                            "dict_departments_id", INTEGER,
                            "departments_name", STRING,
                            "teaching_research_id", INTEGER,
                            "teaching_research_name", STRING));
        } catch (Exception e) {
            e.printStackTrace();
        }
        return Collections.emptyList();
    }
    /**
     * 查询开课通知单
     */
    public static List<Map<String, Object>> queryTeachingTask(String jsonString){
        JSONObject jsonObject = JSONObject.fromObject(jsonString);
        try {
            List<String> sqlist = new ArrayList<String>();
            List<Object> params = new ArrayList<Object>();

            sqlist.add("SELECT tv.id,semester_id,semester,course_id,course_name,major_id,major_name,dict_departments_id,departments_name,teaching_research_number,teaching_research_name,class_id,class_name,student_count,course_nature_id,nature,teacher_id,teacher_name,assessment_id,assessment_name,exam_plan.id,exam_plan.exam_type \n" +
                    "FROM teaching_task_join_view tv LEFT JOIN exam_plan ON tv.id = exam_plan.teaching_task_id WHERE 1=1 ");

            if (checkInt(jsonObject, "academic_year_id")) {
                sqlist.add("AND semester_id=? ");
                params.add(jsonObject.getInt("academic_year_id"));
            }

            if (checkInt(jsonObject, "class_id")) {
                sqlist.add("AND class_id=? ");
                params.add(jsonObject.getInt("class_id"));
            }

            if (checkInt(jsonObject, "teacher_id")) {
                sqlist.add("AND teacher_id=? ");
                params.add(jsonObject.getInt("teacher_id"));
            }
            if (checkInt(jsonObject, "course_id")) {
                sqlist.add("AND course_id=? ");
                params.add(jsonObject.getInt("course_id"));
            }

            if (checkInt(jsonObject, "exam_type")) {
                sqlist.add(" and exam_type = ? ");
                params.add(jsonObject.getInt("exam_type") - 1);
            }

            if (checkInt(jsonObject, "dict_departments_id")) {
                sqlist.add("AND dict_departments_id=? ");
                params.add(jsonObject.getInt("dict_departments_id"));
            }

            if (checkInt(jsonObject, "teaching_research_id")) {
                sqlist.add("AND teaching_research_number=? ");
                params.add(jsonObject.getInt("teaching_research_id"));
            }

            //筛选出已创建考试的课程
            if(checkBoolean(jsonObject,"plan_maked")){
                sqlist.add("AND exam_plan.id IS NOT NULL ");
            }

            //筛选出班级人数非空的课程
            if(checkBoolean(jsonObject,"class_not_empty")){
                sqlist.add("AND student_count>0 ");
            }

            return DBHelper.getReader().doQuery(
                    StringUtils.join(sqlist, " "),
                    params.toArray(), DBHelper.keyAndTypes(
                            "id", INTEGER,
                            "semester_id", INTEGER,
                            "semester", STRING,
                            "course_id", INTEGER,
                            "course_name", STRING,
                            "major_id", INTEGER,
                            "major_name", STRING,
                            "dict_departments_id", INTEGER,
                            "departments_name", STRING,
                            "teaching_research_number", INTEGER,
                            "teaching_research_name", STRING,
                            "class_id", INTEGER,
                            "class_name", STRING,
                            "student_count",INTEGER,
                            "course_nature_id", INTEGER,
                            "nature", STRING,
                            "teacher_id", INTEGER,
                            "teacher_name", STRING,
                            "assessment_id", INTEGER,
                            "assessment_name",STRING,
                            "exam_plan_id",INTEGER,
                            "exam_type",INTEGER));
        } catch (Exception e) {
            e.printStackTrace();
        }
        return Collections.emptyList();
    }

    public static List<Map<String, Object>> queryStudentClass(String jsonString) {
        JSONObject jsonObject = JSONObject.fromObject(jsonString);
        try {
            List<String> sqlist = new ArrayList<String>();
            List<Object> params = new ArrayList<Object>();

            sqlist.add("SELECT cg.id,cg.class_name " +
                    "from teaching_task_view ac,class_grade cg " +
                    "where ac.class_id = cg.id ");
            if (checkInt(jsonObject, "teaching_task_id")) {
                sqlist.add("AND ac.id=? ");
                params.add(jsonObject.getInt("teaching_task_id"));
            }

            if (checkInt(jsonObject, "course_id")) {
                sqlist.add("AND ac.course_id=? ");
                params.add(jsonObject.getInt("course_id"));
            }

            return DBHelper.getReader().doQuery(
                    StringUtils.join(sqlist, " "),
                    params.toArray(), DBHelper.keyAndTypes("id", INTEGER, "name", STRING));
        } catch (Exception e) {
            e.printStackTrace();
        }
        return Collections.emptyList();
    }

    public static List<Map<String, Object>> queryMakeupMan(String jsonString) {

        JSONObject jsonObject = JSONObject.fromObject(jsonString);
        try {
            List<String> sqlist = new ArrayList<String>();
            List<Object> params = new ArrayList<Object>();

            sqlist.add("select dd.departments_name,count(*) as studnum, sum(gt.charge_amount) as totalmoney " +
                    "from grade_transfer gt,grade_student gs,exam_plan ep, teaching_task_view ac,dict_departments dd " +
                    "where gt.grade_id = gs.id and gs.exam_plan_id = ep.id and ep.teaching_task_id = ac.id and ac.dict_departments_id = dd.id " +
                    "GROUP BY dd.id");
            if (checkInt(jsonObject, "id")) {
                sqlist.add("AND ac.id=? ");
                params.add(jsonObject.getInt("id"));
            }
            return DBHelper.getReader().doQuery(
                    StringUtils.join(sqlist, " "),
                    params.toArray(), DBHelper.keyAndTypes("id", INTEGER, "name", STRING));
        } catch (Exception e) {
            e.printStackTrace();
        }
        return Collections.emptyList();
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
