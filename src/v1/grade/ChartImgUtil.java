package v1.grade;

import org.jfree.chart.ChartFactory;
import org.jfree.chart.ChartUtilities;
import org.jfree.chart.JFreeChart;
import org.jfree.chart.axis.CategoryAxis;
import org.jfree.chart.axis.CategoryLabelPositions;
import org.jfree.chart.axis.NumberAxis;
import org.jfree.chart.axis.ValueAxis;
import org.jfree.chart.labels.StandardCategoryItemLabelGenerator;
import org.jfree.chart.labels.StandardPieSectionLabelGenerator;
import org.jfree.chart.plot.CategoryPlot;
import org.jfree.chart.plot.PiePlot;
import org.jfree.chart.plot.PlotOrientation;
import org.jfree.chart.renderer.category.LineAndShapeRenderer;
import org.jfree.data.category.CategoryDataset;
import org.jfree.data.category.DefaultCategoryDataset;
import org.jfree.data.general.DefaultPieDataset;
import org.jfree.ui.RectangleInsets;

import java.awt.*;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.text.DecimalFormat;
import java.text.NumberFormat;
import java.util.*;
import java.util.List;

import static java.lang.Integer.parseInt;


public class ChartImgUtil {
    public static void main(String[] args) throws Exception {
        List<Map<String, Object>> dateList = new ArrayList<Map<String, Object>>();

        for (int i = 0; i <10 ; i++) {
            Map<String, Object> map = new HashMap<String, Object>();
            map.put("name","100-"+i+"分");
            map.put("count",i);
            System.out.println("------------"+map.get("name"));
            System.out.println("------------"+map.get("count"));
            dateList.add(map);
        }



        writeLineImg(dateList,"成绩分析","项目","分数","/Users/huang/Desktop/1111.jpeg");

    }

    /**
     * 创建折线图
     *
     * @param dateList
     *            map的key:'name'为x轴值 count为y轴值
     * @param title
     *            标题名
     * @param xName
     *            X轴标题
     * @param yName
     *            Y轴标题
     * @param imgPath
     *            图片存储路径
     * @throws Exception
     */
    public static void writeLineImg(List<Map<String, Object>> dateList, String title, String xName, String yName,
                                    String imgPath) throws Exception {
        DefaultCategoryDataset dataset = getLineDataset(dateList);
        JFreeChart chart = ChartFactory.createLineChart(title, // 标题
                xName, // categoryAxisLabel （category轴，横轴，X轴标签）
                yName, // valueAxisLabel（value轴，纵轴，Y轴的标签）
                dataset, // dataset
                PlotOrientation.VERTICAL, false, // legend
                false, // tooltips
                false); // URLs

        chart.setBackgroundPaint(Color.WHITE);
        chart.setBackgroundPaint(Color.WHITE);
        // 配置字体（解决中文乱码的通用方法）
        Font xfont = new Font("黑体", Font.BOLD, 14); // X轴
        Font yfont = new Font("黑体", Font.BOLD, 14); // Y轴
        Font titleFont = new Font("宋体", Font.BOLD, 20); // 图片标题
        CategoryPlot categoryPlot = chart.getCategoryPlot();
        categoryPlot.getDomainAxis().setLabelFont(xfont);
        categoryPlot.getRangeAxis().setLabelFont(yfont);
        chart.getTitle().setFont(titleFont);
        categoryPlot.setBackgroundPaint(Color.WHITE);
        // x轴 // 分类轴网格是否可见
        categoryPlot.setDomainGridlinesVisible(true);
        // y轴 //数据轴网格是否可见
        categoryPlot.setRangeGridlinesVisible(true);
        // 设置网格竖线颜色
        categoryPlot.setDomainGridlinePaint(Color.LIGHT_GRAY);
        // 设置网格横线颜色
        categoryPlot.setRangeGridlinePaint(Color.LIGHT_GRAY);
        // 没有数据时显示的文字说明
        categoryPlot.setNoDataMessage("没有数据显示");
        // 设置曲线图与xy轴的距离
        categoryPlot.setAxisOffset(new RectangleInsets(0d, 0d, 0d, 0d));
        // 设置面板字体
        Font labelFont = new Font("黑体", Font.BOLD, 14);
        // 取得Y轴
        NumberAxis rangeAxis = (NumberAxis) categoryPlot.getRangeAxis();
        rangeAxis.setStandardTickUnits(NumberAxis.createIntegerTickUnits());
        rangeAxis.setAutoRangeIncludesZero(true);
        rangeAxis.setUpperMargin(0.20);
        rangeAxis.setLabelAngle(Math.PI / 2.0);//注释此行Y轴小标题 垂直显示
        // 取得X轴
        CategoryAxis categoryAxis = (CategoryAxis) categoryPlot.getDomainAxis();
        // 设置X轴坐标上的文字
        categoryAxis.setTickLabelFont(labelFont);
        // 设置X轴的标题文字
        categoryAxis.setLabelFont(labelFont);
        // 横轴上的 Lable 45度倾斜
        categoryAxis.setCategoryLabelPositions(CategoryLabelPositions.UP_45);
        // 设置距离图片左端距离
        categoryAxis.setLowerMargin(0.0);
        // 设置距离图片右端距离
        categoryAxis.setUpperMargin(0.0);
        // 获得renderer 注意这里是下嗍造型到lineandshaperenderer！！
        LineAndShapeRenderer lineandshaperenderer = (LineAndShapeRenderer) categoryPlot.getRenderer();
        // 是否显示折点
        lineandshaperenderer.setBaseShapesVisible(true);
        // 是否显示折线
        lineandshaperenderer.setBaseLinesVisible(true);
        // series 点（即数据点）间有连线可见 显示折点数据
        lineandshaperenderer.setBaseItemLabelGenerator(new StandardCategoryItemLabelGenerator());
        lineandshaperenderer.setBaseItemLabelsVisible(true);
        creatImg(chart, imgPath);
    }

    /**
     * 创建柱形图
     *
     * @param dateList
     *            map的key:'name'为x轴值 count为y轴值
     * @param title
     *            标题名
     * @param xName
     *            X轴标题
     * @param yName
     *            Y轴标题
     * @param imgPath
     *            图片存储路径
     * @throws Exception
     */
    public static void writeBarImg(List<Map<String, Object>> dateList, String title, String xName, String yName,
                                   String imgPath) throws Exception {
        CategoryDataset dataset = getBarDataSet(dateList);
        JFreeChart chart = ChartFactory.createBarChart3D(title, // 图表标题
                xName, // 目录轴的显示标签
                yName, // 数值轴的显示标签
                dataset, // 数据集
                PlotOrientation.VERTICAL, // 图表方向：水平、垂直
                false, // 是否显示图例(对于简单的柱状图必须是false)
                false, // 是否生成工具
                false // 是否生成URL链接
        );

        // 从这里开始
        CategoryPlot plot = chart.getCategoryPlot();// 获取图表区域对象
        CategoryAxis domainAxis = plot.getDomainAxis(); // 水平底部列表
        domainAxis.setLabelFont(new Font("黑体", Font.BOLD, 14)); // 水平底部标题
        domainAxis.setTickLabelFont(new Font("黑体", Font.BOLD, 14)); // 垂直标题
        // 横轴上的 Lable 45度倾斜
        domainAxis.setCategoryLabelPositions(CategoryLabelPositions.UP_45);
        ValueAxis rangeAxis = plot.getRangeAxis();// 获取柱状
        rangeAxis.setLabelFont(new Font("黑体", Font.BOLD, 15));
        // chart.getLegend().setItemFont(new Font("黑体", Font.BOLD, 15));//不显示图例，此行必须注释
        chart.getTitle().setFont(new Font("宋体", Font.BOLD, 20));// 设置标题字体
        rangeAxis.setUpperMargin(0.1);// 设置顶部Y坐标轴间距,防止数据无法显示
        rangeAxis.setLowerMargin(0.1);// 设置底部Y坐标轴间距

        creatImg(chart, imgPath);
    }

    /**
     * 创建饼图
     *
     * @param dateList
     *            map的key:'name'为x轴值 count为y轴值
     * @param title
     *            标题名
     * @param xName
     *            X轴标题
     * @param yName
     *            Y轴标题
     * @param imgPath
     *            图片存储路径
     * @throws Exception
     */
    public static void writePieImg(List<Map<String, Object>> dateList, String title, String xName, String yName,
                                   String imgPath) throws Exception {
        DefaultPieDataset data = getPieDataSet(dateList);
        JFreeChart chart = ChartFactory.createPieChart3D(title, data, false, false, false);
        // 设置百分比
        PiePlot pieplot = (PiePlot) chart.getPlot();
        DecimalFormat df = new DecimalFormat("0.00%");// 获得一个DecimalFormat对象，主要是设置小数问题
        NumberFormat nf = NumberFormat.getNumberInstance();// 获得一个NumberFormat对象
//		StandardPieSectionLabelGenerator sp1 = new StandardPieSectionLabelGenerator("{0}  {2}", nf, df);// 获得StandardPieSectionLabelGenerator对象
        pieplot.setLabelGenerator(new StandardPieSectionLabelGenerator("{0}:{1}({2})", nf, df));// 设置饼图显示百分比

        // 没有数据的时候显示的内容
        pieplot.setNoDataMessage("无数据显示");
        pieplot.setCircular(false);
        pieplot.setLabelGap(0.02D);

        pieplot.setIgnoreNullValues(true);// 设置不显示空值
        pieplot.setIgnoreZeroValues(true);// 设置不显示负值
        chart.getTitle().setFont(new Font("宋体", Font.BOLD, 20));// 设置标题字体
        PiePlot piePlot = (PiePlot) chart.getPlot();// 获取图表区域对象
        piePlot.setLabelFont(new Font("宋体", Font.BOLD, 15));// 解决乱码
        creatImg(chart, imgPath);
    }


    public static void creatImg(JFreeChart chart, String path) throws Exception {
        FileOutputStream out = null;
        File outFile = new File(path);
        out = new FileOutputStream(outFile);
        // 保存为JPEG
        ChartUtilities.writeChartAsJPEG(out, chart, 800, 600);
        // 保存为PNG
        // ChartUtilities.writeChartAsPNG(out, chart, weight, height);
        out.flush();
        if (out != null) {
            try {
                out.close();
            } catch (IOException e) {
                // do nothing
                e.printStackTrace();
            }
        }
    }

    private static DefaultCategoryDataset getLineDataset(List<Map<String, Object>> dateList) {
        DefaultCategoryDataset dataset = new DefaultCategoryDataset();
        for (Map<String, Object> map : dateList) {
            dataset.setValue(parseInt(map.get("count").toString()), "", map.get("name").toString());
        }
        return dataset;
    }

    private static CategoryDataset getBarDataSet(List<Map<String, Object>> dateList) {
        DefaultCategoryDataset dataset = new DefaultCategoryDataset();
        for (Map<String, Object> map : dateList) {
            dataset.addValue(parseInt(map.get("count").toString()), map.get("name").toString(), map.get("name")
                    .toString());
        }
        return dataset;
    }

    private static DefaultPieDataset getPieDataSet(List<Map<String, Object>> dateList) {
        DefaultPieDataset dataset = new DefaultPieDataset();
        for (Map<String, Object> map : dateList) {
            dataset.setValue(map.get("name").toString(), parseInt(map.get("count").toString()));
        }
        return dataset;
    }

}