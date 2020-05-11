package v1.grade;

/**
 * Created by huang on 2019/6/24.
 */
import org.apache.poi.ss.usermodel.*;

public class ExcelUtil1 {

    private Workbook wb = null;

    private Sheet sheet = null;

    public ExcelUtil1(Workbook wb, Sheet sheet) {
        super();
        this.wb = wb;
        this.sheet = sheet;
    }
    /**
     * 设置表标题样式
     *
     * @return
     */
    public CellStyle getTitle() {
        // 创建单元格样式
        CellStyle cellStyle = wb.createCellStyle();
        // 设置单元格的背景颜色为淡蓝色
//        cellStyle.setFillForegroundColor(HSSFColorPredefined.LIGHT_YELLOW.getIndex());
//        cellStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);
        // 设置单元格居中对齐
        cellStyle.setAlignment(HorizontalAlignment.CENTER);
        // 设置单元格垂直居中对齐
        cellStyle.setVerticalAlignment(VerticalAlignment.CENTER);
        // 创建单元格内容显示不下时自动换行
        //  cellStyle.setWrapText(true);
        // 设置单元格字体样式
        Font font = wb.createFont();
        // 设置字体加粗
        font.setBold(true);
        font.setFontName("宋体");
        font.setFontHeight((short) 240);
        cellStyle.setFont(font);
        // 设置单元格边框为细线条
//        cellStyle.setBorderLeft(BorderStyle.THIN);
//        cellStyle.setBorderBottom(BorderStyle.THIN);
//        cellStyle.setBorderRight(BorderStyle.THIN);
//        cellStyle.setBorderTop(BorderStyle.THIN);
        return cellStyle;
    }
    /**
     * 设置表头样式
     *
     * @return
     */
    public CellStyle getHeadStyle() {
        // 创建单元格样式
        CellStyle cellStyle = wb.createCellStyle();
        // 设置单元格的背景颜色为淡蓝色
//        cellStyle.setFillForegroundColor(HSSFColorPredefined.LIGHT_YELLOW.getIndex());
//        cellStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);
        // 设置单元格居中对齐
        cellStyle.setAlignment(HorizontalAlignment.LEFT);
        // 设置单元格垂直居中对齐
        cellStyle.setVerticalAlignment(VerticalAlignment.CENTER);
        // 创建单元格内容显示不下时自动换行
      //  cellStyle.setWrapText(true);
        // 设置单元格字体样式
        Font font = wb.createFont();
        // 设置字体加粗
        font.setBold(true);
        font.setFontName("宋体");
        font.setFontHeight((short) 240);
        cellStyle.setFont(font);
        // 设置单元格边框为细线条
//        cellStyle.setBorderLeft(BorderStyle.THIN);
//        cellStyle.setBorderBottom(BorderStyle.THIN);
//        cellStyle.setBorderRight(BorderStyle.THIN);
//        cellStyle.setBorderTop(BorderStyle.THIN);
        return cellStyle;
    }

    public void buildTitle(Sheet sheet, String[] titles) {
        Row headRow = sheet.createRow(0);
        Cell cell = null;
        for (int i = 0; i < titles.length; i++) {
            cell = headRow.createCell(i);
            cell.setCellStyle(getHeadStyle());
            cell.setCellValue(titles[i]);
        }
    }

    /**
     * 设置表体的单元格样式
     *
     * @return
     */
    public CellStyle getBodyStyle() {
        // 创建单元格样式
        CellStyle cellStyle = wb.createCellStyle();
        // 设置单元格居中对齐
        cellStyle.setAlignment(HorizontalAlignment.CENTER);
        // 设置单元格垂直居中对齐
        cellStyle.setVerticalAlignment(VerticalAlignment.CENTER);
        // 创建单元格内容显示不下时自动换行
        cellStyle.setWrapText(true);
        // 设置单元格字体样式
        Font font = wb.createFont();
        // 设置字体加粗
        font.setBold(true);
        font.setFontName("宋体");
        font.setFontHeight((short) 200);
        cellStyle.setFont(font);
        // 设置单元格边框为细线条
        cellStyle.setBorderLeft(BorderStyle.THIN);
        cellStyle.setBorderBottom(BorderStyle.THIN);
        cellStyle.setBorderRight(BorderStyle.THIN);
        cellStyle.setBorderTop(BorderStyle.THIN);
        return cellStyle;
    }

    public void autoSizeColumnSize(Sheet sheet) {
        if (sheet == null) {
            return;
        }
        if (sheet.getRow(0) == null) {
            return;
        }
        int colCount = sheet.getRow(0).getPhysicalNumberOfCells();
        for (int column = 0; column < colCount; column++) {
            int columnWidth = sheet.getColumnWidth(column) / 256;
            for (int rowNum = 1; rowNum <= sheet.getLastRowNum(); rowNum++) {
                Row currentRow;
                if (sheet.getRow(rowNum) == null) {
                    currentRow = sheet.createRow(rowNum);
                } else {
                    currentRow = sheet.getRow(rowNum);
                }
                if (currentRow.getCell(column) != null) {
                    Cell currentCell = currentRow.getCell(column);
                    int length = currentCell.toString().length();
                    if (columnWidth < length) {
                        columnWidth = length;
                    }
                }
            }
            sheet.setColumnWidth(column, (columnWidth * 2) * 256);
        }
    }


}
