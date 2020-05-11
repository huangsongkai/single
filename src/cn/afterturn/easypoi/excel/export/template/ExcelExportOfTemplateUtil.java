//
// Source code recreated from a .class file by IntelliJ IDEA
// (powered by Fernflower decompiler)
//

package cn.afterturn.easypoi.excel.export.template;

import cn.afterturn.easypoi.cache.ExcelCache;
import cn.afterturn.easypoi.cache.ImageCache;
import cn.afterturn.easypoi.entity.ImageEntity;
import cn.afterturn.easypoi.excel.annotation.ExcelEntity;
import cn.afterturn.easypoi.excel.annotation.ExcelTarget;
import cn.afterturn.easypoi.excel.entity.TemplateExportParams;
import cn.afterturn.easypoi.excel.entity.enmus.ExcelType;
import cn.afterturn.easypoi.excel.entity.params.ExcelExportEntity;
import cn.afterturn.easypoi.excel.entity.params.ExcelForEachParams;
import cn.afterturn.easypoi.excel.export.base.BaseExportService;
import cn.afterturn.easypoi.excel.export.styler.IExcelExportStyler;
import cn.afterturn.easypoi.excel.export.template.TemplateSumHandler.TemplateSumEntity;
import cn.afterturn.easypoi.excel.html.helper.MergedRegionHelper;
import cn.afterturn.easypoi.exception.excel.ExcelExportException;
import cn.afterturn.easypoi.exception.excel.enums.ExcelExportEnum;
import cn.afterturn.easypoi.util.*;
import org.apache.commons.lang3.StringUtils;
import org.apache.poi.hssf.usermodel.HSSFClientAnchor;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.xssf.usermodel.XSSFClientAnchor;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.lang.reflect.Field;
import java.util.*;

public final class ExcelExportOfTemplateUtil extends BaseExportService {
    private static final Logger LOGGER = LoggerFactory.getLogger(ExcelExportOfTemplateUtil.class);
    private Set<String> tempCreateCellSet = new HashSet();
    private TemplateExportParams teplateParams;
    private MergedRegionHelper mergedRegionHelper;
    private TemplateSumHandler templateSumHandler;

    public ExcelExportOfTemplateUtil() {
    }

    private void addDataToSheet(Class<?> pojoClass, Collection<?> dataSet, Sheet sheet, Workbook workbook) throws Exception {
        Map titlemap = this.getTitleMap(sheet);
        Drawing patriarch = PoiExcelGraphDataUtil.getDrawingPatriarch(sheet);
        Field[] fileds = PoiPublicUtil.getClassFields(pojoClass);
        ExcelTarget etarget = (ExcelTarget)pojoClass.getAnnotation(ExcelTarget.class);
        String targetId = null;
        if(etarget != null) {
            targetId = etarget.value();
        }

        ArrayList excelParams = new ArrayList();
        this.getAllExcelField((String[])null, targetId, fileds, excelParams, pojoClass, (List)null, (ExcelEntity)null);
        this.sortAndFilterExportField(excelParams, titlemap);
        short rowHeight = this.getRowHeight(excelParams);
        int index = this.teplateParams.getHeadingRows() + this.teplateParams.getHeadingStartRow();
        sheet.shiftRows(this.teplateParams.getHeadingRows() + this.teplateParams.getHeadingStartRow(), sheet.getLastRowNum(), this.getShiftRows(dataSet, excelParams), true, true);
        if(excelParams.size() != 0) {
            Object t;
            for(Iterator its = dataSet.iterator(); its.hasNext(); index += this.createCells(patriarch, index, t, excelParams, sheet, workbook, rowHeight)) {
                t = its.next();
            }

            this.mergeCells(sheet, excelParams, index);
        }
    }

    private int getShiftRows(Collection<?> dataSet, List<ExcelExportEntity> excelParams) throws Exception {
        int size = 0;

        Object t;
        for(Iterator its = dataSet.iterator(); its.hasNext(); size += this.getOneObjectSize(t, excelParams)) {
            t = its.next();
        }

        return size;
    }

    public int getOneObjectSize(Object t, List<ExcelExportEntity> excelParams) throws Exception {
        int maxHeight = 1;
        int k = 0;

        for(int paramSize = excelParams.size(); k < paramSize; ++k) {
            ExcelExportEntity entity = (ExcelExportEntity)excelParams.get(k);
            if(entity.getList() != null) {
                Collection list = (Collection)entity.getMethod().invoke(t, new Object[0]);
                if(list != null && list.size() > maxHeight) {
                    maxHeight = list.size();
                }
            }
        }

        return maxHeight;
    }

    public Workbook createExcleByTemplate(TemplateExportParams params, Class<?> pojoClass, Collection<?> dataSet, Map<String, Object> map) {
        if(params != null && map != null && !StringUtils.isEmpty(params.getTemplateUrl())) {
            Workbook wb = null;

            try {
                this.teplateParams = params;
                wb = this.getCloneWorkBook();
                if(wb instanceof XSSFWorkbook) {
                    super.type = ExcelType.XSSF;
                }

                this.setExcelExportStyler((IExcelExportStyler)this.teplateParams.getStyle().getConstructor(new Class[]{Workbook.class}).newInstance(new Object[]{wb}));
                int e = 0;

                for(int le = params.isScanAllsheet()?wb.getNumberOfSheets():params.getSheetNum().length; e < le; ++e) {
                    if(params.getSheetName() != null && params.getSheetName().length > e && StringUtils.isNotEmpty(params.getSheetName()[e])) {
                        wb.setSheetName(e, params.getSheetName()[e]);
                    }

                    this.tempCreateCellSet.clear();
                    this.parseTemplate(wb.getSheetAt(e), map, params.isColForEach());
                }

                if(dataSet != null) {
                    this.dataHandler = params.getDataHandler();
                    if(this.dataHandler != null) {
                        this.needHandlerList = Arrays.asList(this.dataHandler.getNeedHandlerFields());
                    }

                    this.addDataToSheet(pojoClass, dataSet, wb.getSheetAt(params.getDataSheetNum()), wb);
                }

                return wb;
            } catch (Exception var8) {
                LOGGER.error(var8.getMessage(), var8);
                return null;
            }
        } else {
            throw new ExcelExportException(ExcelExportEnum.PARAMETER_ERROR);
        }
    }

    private Workbook getCloneWorkBook() throws Exception {
        return ExcelCache.getWorkbook(this.teplateParams.getTemplateUrl(), this.teplateParams.getSheetNum(), this.teplateParams.isScanAllsheet());
    }

    private Map<String, Integer> getTitleMap(Sheet sheet) {
        Row row = null;
        HashMap titlemap = new HashMap();

        for(int j = 0; j < this.teplateParams.getHeadingRows(); ++j) {
            row = sheet.getRow(j + this.teplateParams.getHeadingStartRow());
            Iterator cellTitle = row.cellIterator();

            for(int i = row.getFirstCellNum(); cellTitle.hasNext(); ++i) {
                Cell cell = (Cell)cellTitle.next();
                String value = cell.getStringCellValue();
                if(!StringUtils.isEmpty(value)) {
                    titlemap.put(value, Integer.valueOf(i));
                }
            }
        }

        return titlemap;
    }

    private void parseTemplate(Sheet sheet, Map<String, Object> map, boolean colForeach) throws Exception {
        this.deleteCell(sheet, map);
        this.mergedRegionHelper = new MergedRegionHelper(sheet);
        this.templateSumHandler = new TemplateSumHandler(sheet);
        if(colForeach) {
            this.colForeach(sheet, map);
        }

        Row row = null;
        int index = 0;

        while(true) {
            do {
                if(index > sheet.getLastRowNum()) {
                    this.hanlderSumCell(sheet);
                    return;
                }

                row = sheet.getRow(index++);
            } while(row == null);

            for(int i = row.getFirstCellNum(); i < row.getLastCellNum(); ++i) {
                if(row.getCell(i) != null && !this.tempCreateCellSet.contains(row.getRowNum() + "_" + row.getCell(i).getColumnIndex())) {
                    this.setValueForCellByMap(row.getCell(i), map);
                }
            }
        }
    }

    private void hanlderSumCell(Sheet sheet) {
        Iterator var2 = this.templateSumHandler.getDataList().iterator();

        while(var2.hasNext()) {
            TemplateSumEntity sumEntity = (TemplateSumEntity)var2.next();
            Cell cell = sheet.getRow(sumEntity.getRow()).getCell(sumEntity.getCol());
            cell.setCellValue(cell.getStringCellValue().replace("sum:(" + sumEntity.getSumKey() + ")", sumEntity.getValue() + ""));
        }

    }

    private void colForeach(Sheet sheet, Map<String, Object> map) throws Exception {
        Row row = null;
        Cell cell = null;
        int index = 0;

        while(true) {
            do {
                if(index > sheet.getLastRowNum()) {
                    return;
                }

                row = sheet.getRow(index++);
            } while(row == null);

            for(int i = row.getFirstCellNum(); i < row.getLastCellNum(); ++i) {
                cell = row.getCell(i);
                if(row.getCell(i) != null && (cell.getCellType() == 1 || cell.getCellType() == 0)) {
                    String text = PoiCellUtil.getCellValue(cell);
                    if(text.contains("#fe:") || text.contains("v_fe:")) {
                        this.foreachCol(cell, map, text);
                    }
                }
            }
        }
    }

    private void foreachCol(Cell cell, Map<String, Object> map, String name) throws Exception {
        boolean isCreate = name.contains("v_fe:");
        name = name.replace("v_fe:", "").replace("#fe:", "").replace("{{", "");
        String[] keys = name.replaceAll("\\s{1,}", " ").trim().split(" ");
        Collection datas = (Collection)PoiPublicUtil.getParamsValue(keys[0], map);
        Object[] columnsInfo = this.getAllDataColumns(cell, name.replace(keys[0], ""), this.mergedRegionHelper);
        if(datas != null) {
            Iterator its = datas.iterator();
            int rowspan = ((Integer)columnsInfo[0]).intValue();
            int colspan = ((Integer)columnsInfo[1]).intValue();

            for(List columns = (List)columnsInfo[2]; its.hasNext(); cell = cell.getRow().getCell(cell.getColumnIndex() + colspan)) {
                Object t = its.next();
                this.setForEeachRowCellValue(true, cell.getRow(), cell.getColumnIndex(), t, columns, map, rowspan, colspan, this.mergedRegionHelper);
                if(cell.getRow().getCell(cell.getColumnIndex() + colspan) == null) {
                    cell.getRow().createCell(cell.getColumnIndex() + colspan);
                }
            }

            if(isCreate) {
                cell = cell.getRow().getCell(cell.getColumnIndex() - 1);
                cell.setCellValue(cell.getStringCellValue() + "}}");
            }

        }
    }

    private void deleteCell(Sheet sheet, Map<String, Object> map) throws Exception {
        Row row = null;
        Cell cell = null;
        int index = 0;

        while(true) {
            do {
                if(index > sheet.getLastRowNum()) {
                    return;
                }

                row = sheet.getRow(index++);
            } while(row == null);

            for(int i = row.getFirstCellNum(); i < row.getLastCellNum(); ++i) {
                cell = row.getCell(i);
                if(row.getCell(i) != null && (cell.getCellType() == 1 || cell.getCellType() == 0)) {
                    cell.setCellType(1);
                    String text = cell.getStringCellValue();
                    if(text.contains("!if:")) {
                        if(Boolean.valueOf(PoiElUtil.eval(text.substring(text.indexOf("{{") + 2, text.indexOf("}}")).trim(), map).toString()).booleanValue()) {
                            PoiSheetUtil.deleteColumn(sheet, i);
                            --i;
                        }

                        cell.setCellValue("");
                    }
                }
            }
        }
    }

    private void setValueForCellByMap(Cell cell, Map<String, Object> map) throws Exception {
        int cellType = cell.getCellType();
        if(cellType == 1 || cellType == 0) {
            cell.setCellType(1);
            String oldString = cell.getStringCellValue();
            if(oldString != null && oldString.indexOf("{{") != -1 && !oldString.contains("fe:")) {
                Object params = null;
                boolean isNumber = false;
                if(this.isNumber(oldString)) {
                    isNumber = true;
                    oldString = oldString.replaceFirst("n:", "");
                }

                Object obj = PoiPublicUtil.getRealValue(oldString, map);
                if(obj instanceof ImageEntity) {
                    ImageEntity img = (ImageEntity)obj;
                    cell.setCellValue("");
                    if(img.getRowspan() > 1 || img.getColspan() > 1) {
                        img.setHeight(0);
                        cell.getSheet().addMergedRegion(new CellRangeAddress(cell.getRowIndex(), cell.getRowIndex() + img.getRowspan() - 1, cell.getColumnIndex(), cell.getColumnIndex() + img.getColspan() - 1));
                    }

                    createImageCell(cell, (double)img.getHeight(), img.getUrl(), img.getData());
                } else if(isNumber && StringUtils.isNotBlank(obj.toString())) {
                    cell.setCellValue(Double.parseDouble(obj.toString()));
                    cell.setCellType(0);
                } else {
                    cell.setCellValue(obj.toString());
                }
            }

            if(oldString != null && oldString.contains("fe:")) {
                this.addListDataToExcel(cell, map, oldString.trim());
            }

        }
    }

    private boolean isNumber(String text) {
        return text.startsWith("n:") || text.contains("{n:") || text.contains(" n:");
    }

    private void addListDataToExcel(Cell cell, Map<String, Object> map, String name) throws Exception {
        boolean isCreate = !name.contains("!fe:");
        boolean isShift = name.contains("$fe:");
        name = name.replace("!fe:", "").replace("$fe:", "").replace("fe:", "").replace("{{", "");
        String[] keys = name.replaceAll("\\s{1,}", " ").trim().split(" ");
        Collection datas = (Collection)PoiPublicUtil.getParamsValue(keys[0], map);
        Object[] columnsInfo = this.getAllDataColumns(cell, name.replace(keys[0], ""), this.mergedRegionHelper);
        if(datas != null) {
            Iterator its = datas.iterator();
            int rowspan = ((Integer)columnsInfo[0]).intValue();
            int colspan = ((Integer)columnsInfo[1]).intValue();
            List columns = (List)columnsInfo[2];
            Row row = null;
            int rowIndex = cell.getRow().getRowNum() + 1;
            Object t;
            if(its.hasNext()) {
                t = its.next();
                this.setForEeachRowCellValue(isCreate, cell.getRow(), cell.getColumnIndex(), t, columns, map, rowspan, colspan, this.mergedRegionHelper);
                rowIndex += rowspan - 1;
            }

            if(isShift && datas.size() * rowspan > 1) {
                this.createRowNoRow(cell.getRowIndex() + rowspan, cell.getRow().getSheet().getLastRowNum(), (datas.size() - 1) * rowspan);
                cell.getRow().getSheet().shiftRows(cell.getRowIndex() + rowspan, cell.getRow().getSheet().getLastRowNum(), (datas.size() - 1) * rowspan, true, true);
                this.templateSumHandler.shiftRows(cell.getRowIndex(), (datas.size() - 1) * rowspan);
            }

            while(its.hasNext()) {
                t = its.next();
                row = this.createRow(rowIndex, cell.getSheet(), isCreate, rowspan);
                this.setForEeachRowCellValue(isCreate, row, cell.getColumnIndex(), t, columns, map, rowspan, colspan, this.mergedRegionHelper);
                rowIndex += rowspan;
            }

        }
    }

    private void createRowNoRow(int startRow, int lastRowNum, int i1) {
    }

    private Row createRow(int rowIndex, Sheet sheet, boolean isCreate, int rows) {
        for(int i = 0; i < rows; ++i) {
            if(isCreate) {
                sheet.createRow(rowIndex++);
            } else if(sheet.getRow(rowIndex++) == null) {
                sheet.createRow(rowIndex - 1);
            }
        }

        return sheet.getRow(rowIndex - rows);
    }

    private void setForEeachRowCellValue(boolean isCreate, Row row, int columnIndex, Object t, List<ExcelForEachParams> columns, Map<String, Object> map, int rowspan, int colspan, MergedRegionHelper mergedRegionHelper) throws Exception {
        int k;
        int ci;
        int i;
        for(int params = 0; params < rowspan; ++params) {
            k = columns.size();
            ci = columnIndex;

            for(i = columnIndex + colspan; ci < i; ++ci) {
                if(row.getCell(ci) == null) {
                    row.createCell(ci);
                    CellStyle isNumber = row.getRowNum() % 2 == 0?this.getStyles(false, k >= ci - columnIndex?null:(ExcelForEachParams)columns.get(ci - columnIndex)):this.getStyles(true, k >= ci - columnIndex?null:(ExcelForEachParams)columns.get(ci - columnIndex));
                    if(isNumber != null) {
                        row.getCell(ci).setCellStyle(isNumber);
                    }
                }
            }

            if(params < rowspan - 1) {
                row = row.getSheet().getRow(row.getRowNum() + 1);
            }
        }

        row = row.getSheet().getRow(row.getRowNum() - rowspan + 1);

        for(k = 0; k < rowspan; ++k) {
            ci = columnIndex;
            row.setHeight(((ExcelForEachParams)columns.get(0 * colspan)).getHeight());

            for(i = 0; i < colspan && i < columns.size(); ++i) {
                boolean var20 = false;
                ExcelForEachParams var19 = (ExcelForEachParams)columns.get(colspan * k + i);
                this.tempCreateCellSet.add(row.getRowNum() + "_" + ci);
                if(var19 != null) {
                    if(StringUtils.isEmpty(var19.getName()) && StringUtils.isEmpty(var19.getConstValue())) {
                        row.getCell(ci).setCellStyle(((ExcelForEachParams)columns.get(i)).getCellStyle());
                        ci += ((ExcelForEachParams)columns.get(i)).getColspan();
                    } else {
                        String val = null;
                        Object obj = null;
                        if(StringUtils.isEmpty(var19.getName())) {
                            val = var19.getConstValue();
                        } else {
                            String e = new String(var19.getName());
                            if(this.isNumber(e)) {
                                var20 = true;
                                e = e.replaceFirst("n:", "");
                            }

                            map.put(this.teplateParams.getTempParams(), t);
                            obj = PoiElUtil.eval(e, map);
                            val = obj.toString();
                        }

                        if(obj != null && obj instanceof ImageEntity) {
                            ImageEntity var21 = (ImageEntity)obj;
                            row.getCell(ci).setCellValue("");
                            createImageCell(row.getCell(ci), (double)var21.getHeight(), var21.getUrl(), var21.getData());
                        } else if(var20 && StringUtils.isNotEmpty(val)) {
                            row.getCell(ci).setCellValue(Double.parseDouble(val));
                            row.getCell(ci).setCellType(0);
                        } else {
                            try {
                                row.getCell(ci).setCellValue(val);
                            } catch (Exception var18) {
                                LOGGER.error(var18.getMessage(), var18);
                            }
                        }

                        row.getCell(ci).setCellStyle(var19.getCellStyle());
                        if(var19.isNeedSum()) {
                            this.templateSumHandler.addValueOfKey(var19.getName(), val);
                        }

                        this.setMergedRegionStyle(row, ci, var19);
                        if((var19.getRowspan() != 1 || var19.getColspan() != 1) && !mergedRegionHelper.isMergedRegion(row.getRowNum() + 1, ci)) {
                            row.getSheet().addMergedRegion(new CellRangeAddress(row.getRowNum(), row.getRowNum() + var19.getRowspan() - 1, ci, ci + var19.getColspan() - 1));
                        }

                        ci += var19.getColspan();
                    }
                }
            }

            row = row.getSheet().getRow(row.getRowNum() + 1);
        }

    }

    private CellStyle getStyles(boolean isSingle, ExcelForEachParams excelForEachParams) {
        return this.excelExportStyler.getTemplateStyles(isSingle, excelForEachParams);
    }

    private void setMergedRegionStyle(Row row, int ci, ExcelForEachParams params) {
        int i;
        for(i = 1; i < params.getColspan(); ++i) {
            row.getCell(ci + i).setCellStyle(params.getCellStyle());
        }

        for(i = 1; i < params.getRowspan(); ++i) {
            for(int j = 0; j < params.getColspan(); ++j) {
                row.getCell(ci + j).setCellStyle(params.getCellStyle());
            }
        }

    }

    private Object[] getAllDataColumns(Cell cell, String name, MergedRegionHelper mergedRegionHelper) {
        ArrayList columns = new ArrayList();
        cell.setCellValue("");
        columns.add(this.getExcelTemplateParams(name.replace("}}", ""), cell, mergedRegionHelper));
        int rowspan = 1;
        int colspan = 1;
        int i;
        if(!name.contains("}}")) {
            i = cell.getColumnIndex();
            int startIndex = cell.getColumnIndex();
            Row row = cell.getRow();

            label73:
            while(true) {
                while(true) {
                    if(i >= row.getLastCellNum()) {
                        break label73;
                    }

                    int colSpan = columns.get(columns.size() - 1) != null?((ExcelForEachParams)columns.get(columns.size() - 1)).getColspan():1;
                    i += colSpan;

                    for(int cellStringString = 1; cellStringString < colSpan; ++cellStringString) {
                        columns.add((Object)null);
                    }

                    cell = row.getCell(i);
                    if(cell == null) {
                        columns.add((Object)null);
                    } else {
                        String var14;
                        try {
                            var14 = cell.getStringCellValue();
                            if(StringUtils.isBlank(var14) && colspan + startIndex <= i) {
                                throw new ExcelExportException("for each 当中存在空字符串,请检查模板");
                            }

                            if(StringUtils.isBlank(var14) && colspan + startIndex > i) {
                                columns.add(new ExcelForEachParams((String)null, cell.getCellStyle(), (short)0));
                                continue;
                            }
                        } catch (Exception var13) {
                            throw new ExcelExportException(ExcelExportEnum.TEMPLATE_ERROR, var13);
                        }

                        cell.setCellValue("");
                        if(var14.contains("}}")) {
                            columns.add(this.getExcelTemplateParams(var14.replace("}}", ""), cell, mergedRegionHelper));
                            break label73;
                        }

                        if(var14.contains("]]")) {
                            columns.add(this.getExcelTemplateParams(var14.replace("]]", ""), cell, mergedRegionHelper));
                            colspan = i - startIndex + 1;
                            i = startIndex - 1;
                            row = row.getSheet().getRow(row.getRowNum() + 1);
                            ++rowspan;
                        } else {
                            columns.add(this.getExcelTemplateParams(var14.replace("]]", ""), cell, mergedRegionHelper));
                        }
                    }
                }
            }
        }

        colspan = 0;

        for(i = 0; i < columns.size(); ++i) {
            colspan += columns.get(i) != null?((ExcelForEachParams)columns.get(i)).getColspan():0;
        }

        colspan /= rowspan;
        return new Object[]{Integer.valueOf(rowspan), Integer.valueOf(colspan), columns};
    }

    private ExcelForEachParams getExcelTemplateParams(String name, Cell cell, MergedRegionHelper mergedRegionHelper) {
        name = name.trim();
        ExcelForEachParams params = new ExcelForEachParams(name, cell.getCellStyle(), cell.getRow().getHeight());
        if(name.startsWith("\'") && name.endsWith("\'")) {
            params.setName((String)null);
            params.setConstValue(name.substring(1, name.length() - 1));
        }

        if("&NULL&".equals(name)) {
            params.setName((String)null);
            params.setConstValue("");
        }

        if(mergedRegionHelper.isMergedRegion(cell.getRowIndex() + 1, cell.getColumnIndex())) {
            Integer[] colAndrow = mergedRegionHelper.getRowAndColSpan(cell.getRowIndex() + 1, cell.getColumnIndex());
            params.setRowspan(colAndrow[0].intValue());
            params.setColspan(colAndrow[1].intValue());
        }

        params.setNeedSum(this.templateSumHandler.isSumKey(params.getName()));
        return params;
    }

    private void sortAndFilterExportField(List<ExcelExportEntity> excelParams, Map<String, Integer> titlemap) {
        for(int i = excelParams.size() - 1; i >= 0; --i) {
            if(((ExcelExportEntity)excelParams.get(i)).getList() != null && ((ExcelExportEntity)excelParams.get(i)).getList().size() > 0) {
                this.sortAndFilterExportField(((ExcelExportEntity)excelParams.get(i)).getList(), titlemap);
                if(((ExcelExportEntity)excelParams.get(i)).getList().size() == 0) {
                    excelParams.remove(i);
                } else {
                    ((ExcelExportEntity)excelParams.get(i)).setOrderNum(i);
                }
            } else if(titlemap.containsKey(((ExcelExportEntity)excelParams.get(i)).getName())) {
                ((ExcelExportEntity)excelParams.get(i)).setOrderNum(i);
            } else {
                excelParams.remove(i);
            }
        }

        this.sortAllParams(excelParams);
    }

    public Workbook createExcleByTemplate(TemplateExportParams params, Map<Integer, Map<String, Object>> map) {
        if(params != null && map != null && !StringUtils.isEmpty(params.getTemplateUrl())) {
            Workbook wb = null;

            try {
                this.teplateParams = params;
                wb = this.getCloneWorkBook();
                int e = 0;

                for(int le = params.isScanAllsheet()?wb.getNumberOfSheets():params.getSheetNum().length; e < le; ++e) {
                    if(params.getSheetName() != null && params.getSheetName().length > e && StringUtils.isNotEmpty(params.getSheetName()[e])) {
                        wb.setSheetName(e, params.getSheetName()[e]);
                    }

                    this.tempCreateCellSet.clear();
                    this.parseTemplate(wb.getSheetAt(e), (Map)map.get(Integer.valueOf(e)), params.isColForEach());
                }

                return wb;
            } catch (Exception var6) {
                LOGGER.error(var6.getMessage(), var6);
                return null;
            }
        } else {
            throw new ExcelExportException(ExcelExportEnum.PARAMETER_ERROR);
        }}
    public void createImageCell(Cell cell, double height, String imagePath, byte[] data) throws Exception {
        if(height > (double)cell.getRow().getHeight()) {
            cell.getRow().setHeight((short)((int)height));
        }
        //获取当前单元格所在的sheet
        Sheet sheet = cell.getRow().getSheet();
        //获取当前sheet页中的所有合并单元格信息
        List<CellRangeAddress> mergedRegions = sheet.getMergedRegions();
        //获取当前单元格的开始列号
        int firstColumn = (short)cell.getColumnIndex();
        //获取当前单元格的开始行号
        int firstRow = cell.getRow().getRowNum();
        //获取当前单元格的结束列号
        int lastColumn = (short)(cell.getColumnIndex());
        //获取当前单元格的结束行号
        int lastRow = cell.getRow().getRowNum();
        for(CellRangeAddress mergedRegion : mergedRegions){
            //判断当前单元格是否包含合并行或和并列 当前单元格的所有行号和列号都包含在合并域内 则认为当前单元格存在合并行或和并列
            if(cell.getColumnIndex()>=mergedRegion.getFirstColumn()
                    && cell.getColumnIndex()<=mergedRegion.getLastColumn()
                    && cell.getRow().getRowNum()>=mergedRegion.getFirstRow()
                    && cell.getRow().getRowNum()<=mergedRegion.getLastRow()){
                //获取合并域的开始行号
                firstRow = mergedRegion.getFirstRow();
                //获取合并域的结束行号
                lastRow = mergedRegion.getLastRow();
                //获取合并域的开始列号
                firstColumn = mergedRegion.getFirstColumn();
                //获取合并域的结束列号
                lastColumn = mergedRegion.getLastColumn();
                break;
            }
        }

        Object anchor;
        if(this.type.equals(ExcelType.HSSF)) {
            anchor = new HSSFClientAnchor(0, 0, 0, 0, (short)firstColumn, firstRow, (short)(lastColumn+1), lastRow+1);
        } else {
            anchor = new XSSFClientAnchor(0, 0, 0, 0, (short)firstColumn, firstRow, (short)(lastColumn+1), lastRow+1);
        }

        if(StringUtils.isNotEmpty(imagePath)) {
            data = ImageCache.getImage(imagePath);
        }

        if(data != null) {
            PoiExcelGraphDataUtil.getDrawingPatriarch(cell.getSheet()).createPicture((ClientAnchor)anchor, cell.getSheet().getWorkbook().addPicture(data, this.getImageType(data)));
        }

    }
    }

