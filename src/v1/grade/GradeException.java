package v1.grade;

public class GradeException extends RuntimeException {
    protected String module;
    protected int lineNo;
    public GradeException(String module, int lineNo, String message, Throwable cause) {
        super(message,cause);
        this.module = module;
        this.lineNo = lineNo;
    }

    public GradeException(String module, int lineNo, String message) {
        super(message);
        this.module = module;
        this.lineNo = lineNo;
    }
    @Override
    public String getMessage() {
        return String.format("在%s模块第%d行发生错误,%s",module,lineNo,super.getMessage());
    }
}
