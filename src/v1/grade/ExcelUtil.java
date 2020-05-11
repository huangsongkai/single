package v1.grade;

import cn.afterturn.easypoi.excel.ExcelExportUtil;
import cn.afterturn.easypoi.excel.entity.TemplateExportParams;
import net.sf.json.JSONObject;
import org.apache.commons.beanutils.MethodUtils;
import org.apache.commons.beanutils.PropertyUtils;
import org.apache.commons.lang3.ClassUtils;
import org.apache.poi.openxml4j.exceptions.InvalidFormatException;
import org.apache.poi.ss.usermodel.Workbook;
import org.jxls.area.Area;
import org.jxls.builder.AreaBuilder;
import org.jxls.builder.xls.XlsCommentAreaBuilder;
import org.jxls.common.CellRef;
import org.jxls.common.Context;
import org.jxls.expression.ExpressionEvaluator;
import org.jxls.expression.JexlExpressionEvaluator;
import org.jxls.formula.FastFormulaProcessor;
import org.jxls.reader.ReaderBuilder;
import org.jxls.reader.XLSReadStatus;
import org.jxls.reader.XLSReader;
import org.jxls.transform.TransformationConfig;
import org.jxls.transform.Transformer;
import org.jxls.util.TransformerFactory;
import org.xml.sax.SAXException;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.*;
import java.lang.reflect.InvocationTargetException;
import java.math.BigDecimal;
import java.net.URLEncoder;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import static v1.grade.DBHelper.ResultType.*;

public class ExcelUtil {
    public static void writeOut(InputStream templateStream, OutputStream outputExcelStream, Map<String,Object> dataMap){
        try{
            Context context = new Context();

//	            System.out.println(datasrc);
//	            System.out.println(datalist);
            for (Map.Entry<String, Object> entry : dataMap.entrySet()) {
                context.putVar(entry.getKey(),entry.getValue());
            }

//	        System.out.println(context);

            AreaBuilder areaBuilder = new XlsCommentAreaBuilder();

            Transformer transformer = TransformerFactory.createTransformer(templateStream, outputExcelStream);
            if (transformer==null){
//                System.out.println("Cannot create the Transformer.");
                throw new RuntimeException("无法创建Excel转换器");
            }
            TransformationConfig config = transformer.getTransformationConfig();
            ExpressionEvaluator expressionEvaluator = config.getExpressionEvaluator();
            JexlExpressionEvaluator evaluator = (JexlExpressionEvaluator) expressionEvaluator;
            Map<String, Object> functionMap = new HashMap<String, Object>();
            functionMap.put("my", new MyELFunctionExtend());
            evaluator.getJexlEngine().setFunctions(functionMap);

            areaBuilder.setTransformer(transformer);
            List<Area> xlsAreaList = areaBuilder.build();
            for (Area xlsArea : xlsAreaList) {
                xlsArea.applyAt(
                        new CellRef(xlsArea.getStartCellRef().getCellName()), context);

                setFormulaProcessor(xlsArea);
                xlsArea.processFormulas();
            }
            transformer.write();
            //this.outputName = new String(outputName.getBytes(),"iso8859-1");
        } catch (IOException e1) {
            e1.printStackTrace();
        }
    }

    public static Object readFrom(InputStream templateXML,InputStream excelStream){

            if(templateXML==null){
                throw new RuntimeException("XML配置文件打开失败！！！");
            }
        XLSReader mainReader = null;
        try {
            mainReader = ReaderBuilder.buildFromXML( templateXML );
        } catch (IOException e) {
            e.printStackTrace();
        } catch (SAXException e) {
            e.printStackTrace();
        }
        Map<String, Object> beans = new HashMap<String, Object>();
            beans.put("data",new ArrayList<Object>());
        XLSReadStatus readStatus = null;
        try {
            readStatus = mainReader.read( excelStream, beans);
        } catch (IOException e) {
            e.printStackTrace();
        } catch (InvalidFormatException e) {
            e.printStackTrace();
        }
        if(readStatus.isStatusOK()){
                return beans.get("data");
            }else {
                throw new RuntimeException("Excel读取失败，"+readStatus.getReadMessages());
            }

    }

    private static void setFormulaProcessor(Area xlsArea) {
        xlsArea.setFormulaProcessor(new FastFormulaProcessor());
        // xlsArea.setFormulaProcessor(new StandardFormulaProcessor());
    }

    public static class MyELFunctionExtend{
        private int seq=0;
        private Map<String,List<BigDecimal>> map = new HashMap<String,List<BigDecimal>>();

        public int initSeq(){
            seq=0;
            return seq;
        }

        public int geneSeq(int step){
            seq+=step;
            return seq;
        }

        public double group(String key,BigDecimal val){
            if(!map.containsKey(key)){
                map.put(key, new ArrayList<BigDecimal>());
            }

            map.get(key).add(val);
            val.setScale(2, BigDecimal.ROUND_HALF_UP);

            return Double.parseDouble(String.format("%.2f", val.doubleValue()));
        }

        public double sum(String key){
            BigDecimal sum = BigDecimal.ZERO;
            sum.setScale(4, BigDecimal.ROUND_HALF_UP);

            for (BigDecimal val : map.get(key)) {
                sum = sum.add(val);
            }

            sum.setScale(2, BigDecimal.ROUND_HALF_UP);
            return Double.parseDouble(String.format("%.2f", sum.doubleValue()));
        }

        private Map<String,Object> dict = new HashMap<String,Object>();

        public MyELFunctionExtend mapTo(String key,Object value){
            dict.put(key, value);
            return this;
        }

        public Object mapOf(String key){
            return dict.get(key);
        }

        public Object ifelse(boolean b, Object o1, Object o2) {
            return b ? o1 : o2;
        }

        public String getValueOfJson(String jsonStr,String key){
            JSONObject json = JSONObject.fromObject(jsonStr);
            return json.getString(key);
        }

        private Map<String,Object> keyMap= new HashMap<String,Object>();
        public Object setAsValue(String name,Object setValue,Object showValue){
            keyMap.put(name,setValue);
            return showValue;
        }
        public Object getAsValue(String name){
            return keyMap.get(name);
        }

        /**
         * List映射功能  List<E> -->  List<T>  T = E.propertyPath
         * @param list  原List
         * @param propertyPath 属性路径，可多级  如p1  p1.x 等
         * @return
         */
        public List mapGet(List list,String propertyPath){
            List resultList = new ArrayList();
            for (Object o:list) {

                Object res = null;
                try {
                    res = PropertyUtils.getProperty(o,propertyPath);
                } catch (IllegalAccessException e) {
                    e.printStackTrace();
                } catch (InvocationTargetException e) {
                    e.printStackTrace();
                } catch (NoSuchMethodException e) {
                    e.printStackTrace();
                }
                resultList.add(res);

            }
            return resultList;
        }

        /**
         * 提供Excel导出静态方法调用
         * @param className 类名
         * @param method 函数名
         * @param args 参数列表
         * @param argTypes 参数类型 对于基础数组请自行输出测试 引用类型数组使用 [L类名;
         * 示例：  int[] -- [I    int[][]  --  [[I   String[]  --  [Ljava.lang.String;
         * @return
         */
        public Object staticCall(String className,String method,Object[] args,String[] argTypes){

                Class[] classes = new Class[argTypes.length];
                for (int i = 0; i < argTypes.length ; i++) {
                    if (argTypes[i] == "int"){
                        classes[i] = int.class;
                    }
                    if (argTypes[i] == "long"){
                        classes[i] = long.class;
                    }
                    if (argTypes[i] == "short"){
                        classes[i] = short.class;
                    }
                    if (argTypes[i] == "float"){
                        classes[i] = float.class;
                    }
                    if (argTypes[i] == "double"){
                        classes[i] = double.class;
                    }
                    if (argTypes[i] == "char"){
                        classes[i] = char.class;
                    }
                    if (argTypes[i] == "byte"){
                        classes[i] = byte.class;
                    }
                    if (argTypes[i] == "boolean"){
                        classes[i] = boolean.class;
                    }

                    try {
                        classes[i] = ClassUtils.getClass(argTypes[i]);
                    } catch (ClassNotFoundException e) {
                        e.printStackTrace();
                    }
                    }

            try {
                return MethodUtils.invokeExactStaticMethod(ClassUtils.getClass(className),method,args,classes);
            } catch (NoSuchMethodException e) {
                e.printStackTrace();
            } catch (IllegalAccessException e) {
                e.printStackTrace();
            } catch (InvocationTargetException e) {
                e.printStackTrace();
            } catch (ClassNotFoundException e) {
                e.printStackTrace();
            }

            return null;
        }

    }

    public static void main(String[] args) throws SQLException, FileNotFoundException {
//        testExport();
        InputStream templateXML = ExcelUtil.class.getResourceAsStream("/GradeImport.xml");
        InputStream excelStream = new FileInputStream("D:\\Yu-hsin Wang\\Desktop\\Upan\\excel_test.xls");
        List<GradeImportEntity> list = (List<GradeImportEntity>) readFrom(templateXML,excelStream);
        for (GradeImportEntity entity : list) {
            System.out.println(entity);
        }
    }

    private static void testExport() throws SQLException, FileNotFoundException {
        String sql = "SELECT\n" +
                "gs.exam_plan_id,\n" +
                "gs.student_id,\n" +
                "sb.student_number,\n" +
                "sb.stuname,\n" +
                "gs.regular_grade,\n" +
                "gs.midterm_grade,\n" +
                "gs.final_exam_grade,\n" +
                "gs.totel_grade,\n" +
                "gs.exam_state\n" +
                "FROM\n" +
                "grade_student AS gs\n" +
                "INNER JOIN student_basic AS sb ON gs.student_id = sb.id\n" +
                "WHERE gs.exam_plan_id=5\n";
        List<Map<String, Object>> resultList = DBHelper.getReader().doQuery(
               sql,
                new Object[0], DBHelper.keyAndTypes(
                        "exam_plan_id", INTEGER,
                        "student_id", INTEGER,
                        "student_number", INTEGER,
                        "stuname", STRING,
                        "regular_grade", DOUBLE,
                        "midterm_grade", DOUBLE,
                        "final_exam_grade", DOUBLE,
                        "totel_grade", DOUBLE,
                        "exam_state", INTEGER
                )
        );

        InputStream excelTemplateStream = ExcelUtil.class.getResourceAsStream("/grade_excel_template.xls");
        OutputStream outputExcelStream = new FileOutputStream("D:\\Yu-hsin Wang\\Desktop\\Upan\\excel_test.xls");
        Map<String,Object> dataMap = new HashMap<String,Object>();
        dataMap.put("grades",resultList);
        dataMap.put("status",new String[]{"正常考试", "免修","学分互认","缓考","旷考","舞弊","其它"});
        writeOut(excelTemplateStream,outputExcelStream,dataMap);
    }
    public static void expExcel(Map<String, Object> dataMap1, HttpServletRequest request, HttpServletResponse response) throws IOException {
        // 写文件
        String address = request.getSession().getServletContext().getRealPath("/");//获取tomcat根目录
        TemplateExportParams params = new TemplateExportParams(address + "grade_template.xls");
        Workbook workbook = ExcelExportUtil.exportExcel(params, dataMap1);
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
