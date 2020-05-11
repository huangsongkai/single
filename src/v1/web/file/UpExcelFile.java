package v1.web.file;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONObject;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileItemFactory;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.apache.commons.lang3.StringUtils;

public class UpExcelFile extends HttpServlet {

    public void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        process(request, response);
    }
    public void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        process(request, response);
    }

    private void process(HttpServletRequest request,HttpServletResponse response) throws IOException {
        response.setCharacterEncoding("utf-8");
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        FileItemFactory factory = new DiskFileItemFactory();
        ServletFileUpload upload = new ServletFileUpload(factory);
        upload.setHeaderEncoding(request.getCharacterEncoding());
        
        String table = request.getParameter("table");
        String field = request.getParameter("field");
        String other = request.getParameter("other");
        JSONObject json = new JSONObject();
        ExcelHelper helper = new ExcelHelper();
        try {
            List<FileItem> list = upload.parseRequest(request);
            for (int i = 0; i < list.size(); i++) {
                FileItem item = list.get(i);
                if(item.getName()==null){
                	continue;
                }
                if (item.getName().endsWith("xls")||item.getName().endsWith("xlsx")) {
                    // 说明是文件,不过这里最好限制一下
                    //helper.importXls(item.getInputStream());
                   // json = helper.importXlsx(item.getInputStream(),table,field,fieldnum);
                	//ohter 页面需要定义默认值，参考发放查询，
                	if(StringUtils.isBlank(other)){
                		json = helper.importExcel(item.getInputStream(),table,field);
                	}else{
                		json = helper.importExcel(item.getInputStream(),table,field,other);
                	}
                } else {
                    // 说明文件格式不符合要求
                	json.put("state","faile");
                }
                item.delete();
            }
        } catch (Exception e) {
        	json.put("state", "error");
        	json.put("msg", "录入失败,请检查文件");
            e.printStackTrace();
        }
        
    	out.println(json);
        out.flush();
        out.close();
    }

}