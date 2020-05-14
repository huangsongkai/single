package v1.grade;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import org.apache.commons.lang3.BooleanUtils;
import org.apache.commons.lang3.StringUtils;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import static v1.grade.DBHelper.ResultType.INTEGER;
import static v1.grade.DBHelper.ResultType.STRING;

public class CjdService {
    /**
     * 不及格门数查询
     * @param jsonString
     * @return
     * @throws Exception
     */
    public static List<Map<String, Object>> queryFail( String jsonString) throws Exception {
        String sql1 = " SELECT student_id , student_number , stuname , COUNT(*) , SUM(credits_term) , class_name , GROUP_CONCAT(course_name ORDER BY course_id) FROM( SELECT sb.id AS student_id , sb.student_number AS student_number , sb.stuname AS stuname , COUNT(*) AS exam_times , tv.credits_term AS credits_term , cv.class_name AS class_name , course.course_name AS course_name , course.id AS course_id , MAX(gs.totel_grade) AS totel_grade , tv.semester AS semester , ep.check_state AS check_state , tv.school_year AS school_year , tv.`dict_departments_id` as dict_departments_id , tv.`major_id` as major_id , tv.`class_id` as class_id , ep.`exam_type` as exam_type , tv.`assessment_id` as assessment_id FROM teaching_task_view AS tv INNER JOIN dict_courses AS course ON tv.course_id = course.id INNER JOIN class_grade AS cv ON tv.class_id = cv.id INNER JOIN student_basic AS sb ON cv.id = sb.classroomid INNER JOIN exam_plan AS ep ON tv.id = ep.teaching_task_id INNER JOIN grade_student AS gs ON ep.id = gs.exam_plan_id AND gs.student_id = sb.id GROUP BY cv.id , sb.id , tv.semester , course.id) AS temp1 WHERE totel_grade < 60 AND check_state = '2'  " ;
        JSONArray jsonObject = JSONArray.fromObject(jsonString);
        HashMap<Object, Object> map = new HashMap<Object, Object>();//前台传过来的值
        for(int i=0;i<jsonObject.size();i++){
            JSONObject job = jsonObject.getJSONObject(i);
            System.out.println(job.get("name")+":"+job.get("value")) ;
            map.put(job.get("name"), job.get("value"));
        }
        String querySemester = map.get("querySemester").toString();
        String queryDepartment = map.get("department_id").toString();
        String queryMajors = map.get("Major_id").toString();
        String StudentClass = map.get("StudentClass_id").toString();
        String studentNum = map.get("studentNum").toString();
        String studentName = map.get("studentName").toString();
        String FailNum = map.get("FailNum").toString();
        String FailNumTex = map.get("FailNumTex").toString();
        String Examination = map.get("Examination").toString();
        String Assessment = map.get("Assessment").toString();
        String school_year = map.get("school_year").toString();

        if( StringUtils.isNotBlank(querySemester)){
            sql1+=" and `semester` ='"+querySemester+"'"+"  ";
        }
        if( StringUtils.isNotBlank(queryDepartment)){
            sql1+=" and `dict_departments_id` ="+queryDepartment+"  ";
        }
        if( StringUtils.isNotBlank(queryMajors)){
            sql1+=" and `major_id` ="+queryMajors+"  ";
        }
        if(StringUtils.isNotBlank(StudentClass)){
            sql1+=" and `class_id` ="+StudentClass+"  ";
        }
        if( StringUtils.isNotBlank(studentNum)){
            sql1+=" and `student_number` ="+studentNum+"  ";
        }
        if( StringUtils.isNotBlank(studentName)){
            sql1+=" and `stuname` ='"+studentName+"' "+"  ";
        }
        if( StringUtils.isNotBlank(Examination)){
            sql1+=" and `exam_type` = "+Examination+"  ";
        }
        if( StringUtils.isNotBlank(Assessment)){
            sql1+="  and `assessment_id` = "+Assessment+""  ;
        }
        if( StringUtils.isNotBlank(school_year)){
            sql1+="  and `school_year` = "+school_year+""  ;
        }
        sql1+="  GROUP BY student_id ";
        if( StringUtils.isNotBlank(FailNum) &&StringUtils.isNotBlank(FailNumTex)){
            sql1+=" having  Count(*) "+FailNum+FailNumTex+"  ";
        }
        System.out.println(sql1);
        List<Map<String, Object>> bjgtj = DBHelper.getReader().doQuery(sql1, new Object[0],
                DBHelper.keyAndTypes("id", INTEGER,"student_number", STRING,
                        "stuname", STRING, "ms", INTEGER,
                        "bjgxf",INTEGER , "szbj", STRING, "kclb", STRING));
        return bjgtj;
    }

    /**
     * 不及格门数详细信息查询
     * @param jsonString
     * @return
     * @throws Exception
     */
    public static List<Map<String, Object>> queryFailDetil( String jsonString) throws Exception {
        JSONObject jsonObject = JSONObject.fromObject(jsonString);
        String sql1 = "SELECT " +
                " tv.semester ," +
                " sb.student_number ," +
                " sb.stuname ," +
                " course.course_name ," +
                " cg.class_name ," +
                " gs.totel_grade ," +
                " tv.credits ," +
                " tv.semester_hours ," +  //学时
                " tv.course_nature_id ," +// 课程性质 必修 选修
                " dcc.category ," + //课程类别
                " ep.exam_type ," +//考试性质 性质 0-3  [正常考试、补考、重修、重考]
                " tv.assessment_id ," + //这一项  0-6 分别对应 正常考试, 免修,学分互认,缓考,旷考,舞弊,其它
                " (" +
                " CASE " +
                " WHEN ep.exam_type != 0 THEN" +
                " ep.exam_date" +
                " ELSE" +
                " ''" +
                " END" +
                " ) " +

                " FROM" +
                " teaching_task_view AS tv" +
                " INNER JOIN dict_courses AS course ON tv.course_id = course.id" +
                " INNER JOIN student_basic AS sb" +
                " INNER JOIN exam_plan AS ep ON tv.id = ep.teaching_task_id" +
                " INNER JOIN grade_student AS gs ON ep.id = gs.exam_plan_id" +
                " AND gs.student_id = sb.id" +
                " LEFT JOIN class_grade cg ON sb.classroomid = cg.id" +
                " LEFT JOIN dict_course_category dcc ON tv.course_category_id = dcc.id" +
                " WHERE 1=1 " +
                " AND  gs.totel_grade<60" +
                " AND ep.check_state = 2";
        if(checkInt(jsonObject, "id")){
            int id = jsonObject.getInt("id");
            sql1+=" AND sb.id = "+id;
        }
        System.out.println(sql1);
        List<Map<String, Object>> bjgtj = DBHelper.getReader().doQuery(sql1, new Object[0],
                DBHelper.keyAndTypes("semester", STRING,"student_number", STRING,
                        "stuname", STRING, "course_name", STRING,
                        "class_name",STRING , "final_exam_grade", STRING, "credits", STRING,
                        "semester_hours", STRING, "course_nature_id", STRING, "category",
                        STRING, "exam_type", STRING, "exam_state", STRING, "exam_date", STRING));
        return bjgtj;
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
