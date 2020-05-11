package v1.grade;

public class GradeImportEntity {
    private String student_id,student_name,student_number,regular_grade,midterm_grade,final_exam_grade,totel_grade,exam_state;

    public String getStudent_id() {
        return student_id;
    }

    public void setStudent_id(String student_id) {
        this.student_id = student_id;
    }

    public String getStudent_name() {
        return student_name;
    }

    public void setStudent_name(String student_name) {
        this.student_name = student_name;
    }

    public String getStudent_number() {
        return student_number;
    }

    public void setStudent_number(String student_number) {
        this.student_number = student_number;
    }

    public String getRegular_grade() {
        return regular_grade;
    }

    public void setRegular_grade(String regular_grade) {
        this.regular_grade = regular_grade;
    }

    public String getMidterm_grade() {
        return midterm_grade;
    }

    public void setMidterm_grade(String midterm_grade) {
        this.midterm_grade = midterm_grade;
    }

    public String getFinal_exam_grade() {
        return final_exam_grade;
    }

    public void setFinal_exam_grade(String final_exam_grade) {
        this.final_exam_grade = final_exam_grade;
    }

    public String getTotel_grade() {
        return totel_grade;
    }

    public void setTotel_grade(String totel_grade) {
        this.totel_grade = totel_grade;
    }

    public String getExam_state() {
        return exam_state;
    }

    public void setExam_state(String exam_state) {
        this.exam_state = exam_state;
    }

    @Override
    public String toString() {
        return student_id + '\t' +
                 student_name + '\t' +
                 student_number + '\t' +
                 regular_grade + '\t' +
                midterm_grade + '\t' +
                 final_exam_grade + '\t' +
                 totel_grade + '\t' +
                exam_state;
    }
}
