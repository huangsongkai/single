package v1.grade;

import cn.afterturn.easypoi.excel.ExcelExportUtil;
import cn.afterturn.easypoi.excel.entity.ExportParams;
import cn.afterturn.easypoi.excel.entity.TemplateExportParams;
import cn.afterturn.easypoi.excel.entity.enmus.ExcelType;
import cn.afterturn.easypoi.excel.entity.params.ExcelExportEntity;
import cn.afterturn.easypoi.excel.export.ExcelExportService;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.streaming.SXSSFWorkbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.*;

/**
 * Created by hung on 2019/7/5.
 */
public class Test {

    public static void main(String[] args) throws IOException {
        //String path = request.getSession().getServletContext().getRealPath("/");
        //查询数据
//        List<JSONObject> list = IntStream.range(1,11).mapToObj(i->{
//            JSONObject job = new JSONObject();
//            job.put("id",i);
//            job.put("name","name"+i);
//            return job;
//        }).collect(Collectors.toList());
//
//        ExcelUtil.writeOut(Files.newInputStream(Paths.get("/Users/huang/资料/司法警官学院/成绩模块打印相关 2/课程成绩单样表.xls"),StandardOpenOption.READ),
//                Files.newOutputStream(Paths.get("/Users/huang/output.xls"), StandardOpenOption.CREATE),
//                Collections.singletonMap("grades",list));
        TemplateExportParams params = new TemplateExportParams("/Users/huang/资料/司法警官学院/成绩模块打印相关 2/课程成绩分析单样表111.xls");
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("date", "2014-12-25");
        List<Map<String, String>> listMap = new ArrayList<Map<String, String>>();
        for (int i = 0; i < 4; i++) {
            Map<String, String> lm = new HashMap<String, String>();
            lm.put("ids", i + 1 + "");
            lm.put("name", i * 10000 + "");
            lm.put("ps", "A001");
            lm.put("qz", "设计");
            lm.put("qm", "EasyPoi " + i + "期");
            lm.put("zcj", "开源项目");
            lm.put("bz", i * 10000 + "");
            lm.put("id1", i + 1 + "");
            lm.put("name1", i * 10000 + "");
            lm.put("ps1", "A001");
            lm.put("qz1", "设计");
            lm.put("qm1", "EasyPoi " + i + "期");
            lm.put("zcj1", "开源项目");
            lm.put("bz1", i * 10000 + "");
            listMap.add(lm);
        }
        map.put("list", listMap);
        map.put("list1", listMap);


        Workbook workbook = ExcelExportUtil.exportExcel(params, map);
        File savefile = new File("/Users/huang/");
        if (!savefile.exists()) {
            savefile.mkdirs();
        }
        FileOutputStream fos = new FileOutputStream("/Users/huang/啊啊啊啊.xls");
        workbook.write(fos);
        fos.close();






    }
    public static Workbook exportExcel(List<Map<String, Object>> list, ExcelType type) {
        Workbook workbook = getWorkbook(type,0);
        for (Map<String, Object> map : list) {
            ExcelExportService service = new ExcelExportService();
            service.createSheetForMap(workbook, (ExportParams)map.get("title"), (List<ExcelExportEntity>)map.get("entity"), (Collection<?>)map.get("data"));
        }
        return workbook;
    }

    private static Workbook getWorkbook(ExcelType type, int size) {
        if (ExcelType.HSSF.equals(type)) {
            return new HSSFWorkbook();
        } else if (size < 100000) {
            return new XSSFWorkbook();
        } else {
            return new SXSSFWorkbook();
        }
    }

    /**
     * 多sheet导出示例
     * @return
     */
//    public Workbook exportSheets(){
//        // 查询数据,此处省略
//        List<EasyPOIModel> list = new ArrayList<>();
//        int count1 = 0 ;
//        EasyPOIModel easyPOIModel11 = new EasyPOIModel(String.valueOf(count1++),"信科",new User("张三","男",20)) ;
//        EasyPOIModel easyPOIModel12 = new EasyPOIModel(String.valueOf(count1++),"信科",new User("李四","男",17)) ;
//        EasyPOIModel easyPOIModel13 = new EasyPOIModel(String.valueOf(count1++),"信科",new User("淑芬","女",34)) ;
//        EasyPOIModel easyPOIModel14 = new EasyPOIModel(String.valueOf(count1++),"信科",new User("仲达","男",55)) ;
//        list.add(easyPOIModel11) ;
//        easyPOIModel11 = null ;
//        list.add(easyPOIModel12) ;
//        easyPOIModel12 = null ;
//        list.add(easyPOIModel13) ;
//        easyPOIModel13 = null ;
//        list.add(easyPOIModel14) ;
//        easyPOIModel14 = null ;
////        List<EasyPOIModel> list1 = new ArrayList<>();
////        int count2 = 0 ;
////        EasyPOIModel easyPOIModel21 = new EasyPOIModel(String.valueOf(count2++),"软件",new User("德林","男",22)) ;
////        EasyPOIModel easyPOIModel22 = new EasyPOIModel(String.valueOf(count2++),"软件",new User("智勇","男",28)) ;
////        EasyPOIModel easyPOIModel23 = new EasyPOIModel(String.valueOf(count2++),"软件",new User("廉贞","女",17)) ;
//        list1.add(easyPOIModel21) ;
//        easyPOIModel21 = null;
//        list1.add(easyPOIModel22) ;
//        easyPOIModel22 = null;
//        list1.add(easyPOIModel23) ;
//        easyPOIModel23 = null;
//        // 设置导出配置
//        // 获取导出excel指定模版
//        TemplateExportParams params = new TemplateExportParams("d:/项目测试文件夹/easypoiExample.xlsx");
//        Map<Integer, Map<String, Object>> mapMap = new HashMap<>() ;
//        // 创建参数对象（用来设定excel得sheet得内容等信息）
//        ExportParams params1 = new ExportParams() ;
//        // 设置sheet得名称
//        params1.setSheetName("表格1"); ;
//        ExportParams params2 = new ExportParams() ;
//        params2.setSheetName("表格2") ;
//        // 创建sheet1使用得map
//        Map<String,Object> dataMap1 = new HashMap<>();
//        // title的参数为ExportParams类型，目前仅仅在ExportParams中设置了sheetName
//        dataMap1.put("title",params1) ;
//        // 模版导出对应得实体类型
//        dataMap1.put("entity",EasyPOIModel.class) ;
//        // sheet中要填充得数据
//        dataMap1.put("data",list) ;
//        // 创建sheet2使用得map
//        Map<String,Object> dataMap2 = new HashMap<>();
//        dataMap2.put("title",params2) ;
//        dataMap2.put("entity",EasyPOIModel.class) ;
//        dataMap2.put("data",list1) ;
//        // 将sheet1和sheet2使用得map进行包装
//        List<Map<String, Object>> sheetsList = new ArrayList<>() ;
//        sheetsList.add(dataMap1);
//        sheetsList.add(dataMap2);
//        // 执行方法
//        return ExcelExportUtil.exportExcel(sheetsList, ExcelType.HSSF) ;
//    }

}