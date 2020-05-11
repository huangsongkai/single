package v1.web.file;

import java.io.IOException;
import java.io.InputStream;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.apache.poi.EncryptedDocumentException;
import org.apache.poi.hssf.usermodel.HSSFDateUtil;
import org.apache.poi.openxml4j.exceptions.InvalidFormatException;
import org.apache.poi.openxml4j.opc.OPCPackage;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.DateUtil;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.usermodel.WorkbookFactory;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import net.sf.json.JSONObject;


import service.dao.db.Jdbc;

public class ExcelHelper {

	 private static final Map<String, Integer> dicMap;  
	  static {  
		  dicMap = new HashMap<String,Integer>();
			  dicMap.put("男", 1);
			dicMap.put("女", 2);
	  } 
	  
	 private String getValue(Cell cell) {
	        String result = "";
	        if(cell==null||cell.toString().replaceAll(" ","").equals("")){
	        }else{
	        	switch (cell.getCellType()) {
		        case Cell.CELL_TYPE_BOOLEAN:
		            result = cell.getBooleanCellValue() + "";
		            break;
		        case Cell.CELL_TYPE_STRING:
		            result = cell.getStringCellValue();
		            break;
		        case Cell.CELL_TYPE_FORMULA:
		            result = cell.getCellFormula();
		            break;
		        case Cell.CELL_TYPE_NUMERIC:
		            // 可能是普通数字，也可能是日期
		            if (HSSFDateUtil.isCellDateFormatted(cell)) {
		            	Date date1 = DateUtil.getJavaDate(cell.getNumericCellValue());
		                //result = DateUtil.getJavaDate(cell.getNumericCellValue()).toString();
		                SimpleDateFormat sm = new SimpleDateFormat("yyyy-MM-dd");
		                result = sm.format(date1);
		            } else {
		                result =cell.getNumericCellValue()+"";
		            }
		            break;
		        }
	        }
	        return result;
	    }

	    /***
	     * 这种方法支持03，和07版本的excel读取
	     * 但是对于合并的单元格，除了第一行第一列之外，其他部分读取的值为空
	     * @param is
	     */
	    public void importXlsx(InputStream is) {
	        try {
	            Workbook wb = WorkbookFactory.create(is);
	            // OPCPackage pkg = OPCPackage.open(is);
	            // XSSFWorkbook wb = new XSSFWorkbook(pkg);
	            for (int i = 0, len = wb.getNumberOfSheets(); i < len; i++) {
	                Sheet sheet = wb.getSheetAt(i);
	                for (int j = 0; j <= sheet.getLastRowNum(); j++) {
	                    if (sheet == null) {
	                        return;
	                    }
	                    Row row = sheet.getRow(j);
	                    if(row==null){
	                        return;
	                    }
	                    // 读取每一个单元格
	                    for (int k = 0; k < row.getLastCellNum(); k++) {
	                        Cell cell = row.getCell(k);
	                        if (cell == null) {
	                            return;
	                        }
	                    }
	                }
	            }
	        } catch (Exception e) {
	            e.printStackTrace();
	        }
	    }
	    
	    //导入excel 更新数据
	    public JSONObject importExcel(InputStream is,String table,String field) throws EncryptedDocumentException, InvalidFormatException, IOException {
	    	Jdbc db = new Jdbc();
	    	JSONObject json =new JSONObject();
	    	StringBuffer wrong = new StringBuffer();
	    	Workbook wb = WorkbookFactory.create(is);
	    		 //OPCPackage pkg = OPCPackage.open(is);
	    		// XSSFWorkbook wb = new XSSFWorkbook(pkg);
	    	int updaetNum =0;
	    	int insertNum = 0;
	    		for (int i = 0, len = wb.getNumberOfSheets(); i < len; i++) {
	    			Sheet sheet = wb.getSheetAt(i);
	    			//获取excel表头
	    			Row rowhead = sheet.getRow(0);
	    			int idcardNum =1;
	    			if(null==rowhead){continue;}
	    			Map<String,Integer> headMap = new HashMap<String,Integer>();
	    			for(int r=0;r<rowhead.getLastCellNum();r++){
	    				Cell cell = rowhead.getCell(r);
	    				if(cell.getStringCellValue().replaceAll(" ", "").equals("身份证号")){
	    					idcardNum = r;
	    					headMap.put(cell.getStringCellValue(),r);
	    					break;
	    				}
	    			}
	    			
	    			for (int j = 1; j <= sheet.getLastRowNum(); j++) {
	    				if (sheet == null) {
	    					json.put("msg","没有表格数据");
	    					json.put("state", "success");
	    					return json;
	    				}
	    				Row row = sheet.getRow(j);
	    				if(row==null){
	    					json.put("msg","表格没数据");
	    					json.put("state", "success");
	    					return json;
	    				}
	    				
	    				String values ="'";
	    				boolean update = false;
	    				String[]  filedsp = field.split(",");
	    				//校验添加或者更新
	    				Cell cell1 = row.getCell(idcardNum);
	    				String updateEnd ="";
	    				try {	
	    				if(table.equals("teacher_wages")){//工资查询需要判断发放日期
	    					Cell cell2 = row.getCell(0);
	    					updateEnd =" where id_number='"+getValue(cell1)+"'  and date='"+getValue(cell2)+"'";
	    				}else if(table.equals("wealth_bank")){
	    					Cell cell2 = row.getCell(2);
	    					updateEnd =" where id_number='"+getValue(cell1)+"'  and bankcard='"+getValue(cell2)+"'";
	    				}else if(table.equals("staff_level")){//行政级别需要判断身份证和行政级别
	    					Cell cell2 = row.getCell(2);//行政级别
	    					updateEnd =" where id_number='"+getValue(cell1)+"'  and level='"+getValue(cell2)+"'";
	    				}
	    				else if(table.equals("staff_rank")){
	    					Cell cell5 = row.getCell(4);
	    					Cell cell6 = row.getCell(5);
	    					updateEnd =" where id_number='"+getValue(cell1)+"'  and rank_time='"+getValue(cell6)+"' and rank='"+getValue(cell5)+"'";
	    				}else if(table.equals("teacher_wages_distribution")){
	    					
	    					Cell cell2 = row.getCell(1);//卡号
	    					Cell cell3 = row.getCell(5);//日期
	    					Cell cell4 = row.getCell(4);//摘要
	    					String remark =getValue(cell4);
	    					if(StringUtils.isBlank(remark)){
	    						updateEnd =" where  date='"+getValue(cell3)+"'  and bankcard='"+getValue(cell2)+"'"+" and remark ='"+remark+"'";
	    					}else{
	    						updateEnd =" where  date='"+getValue(cell3)+"'  and bankcard='"+getValue(cell2)+"'"+" and remark ='"+remark+"'";
	    					}
	    				}else if(table.equals("student_basic")){
	    					//处理学生班级 需要判断班级，院系 专业
	    					
	    					String depSql = "SELECT departments_name,id FROM dict_departments  where teach_tag=1";
	    					ResultSet depRs = db.executeQuery(depSql);
								while(depRs.next()){
									String depments = depRs.getString("departments_name");
									int id = depRs.getInt("id");
									dicMap.put(depments, id);
								}if(depRs!=null){depRs.close();}
							//处理专业
							String majorSql ="SELECT major_name,id FROM major  ";
							ResultSet majorRs = db.executeQuery(majorSql);
							while(majorRs.next()){
								String major_name = majorRs.getString("major_name");
								int id = majorRs.getInt("id");
								dicMap.put(major_name, id);
							}if(majorRs!=null){majorRs.close();}
							//处理班级
							String classSql ="SELECT class_name,id FROM class_grade  ";
							ResultSet classRs = db.executeQuery(classSql);
							while(classRs.next()){
								String class_name = classRs.getString("class_name");
								int id = classRs.getInt("id");
								dicMap.put(class_name, id);
							}if(classRs!=null){classRs.close();}
							//处理培养层次
							String graSql ="SELECT name,id FROM jz_culture_level  ";
							ResultSet graRs = db.executeQuery(graSql);
							while(graRs.next()){
								String gra_name = graRs.getString("name");
								int id = graRs.getInt("id");
								dicMap.put(gra_name, id);
							}if(graRs!=null){graRs.close();}
							//处理政治面貌
							String zz_sql = "SELECT typename,id FROM type where typegroupcode='politicsStatus'";
							ResultSet zz_sqlRs = db.executeQuery(zz_sql);
							while(zz_sqlRs.next()){
								String typename = zz_sqlRs.getString("typename");
								int id = zz_sqlRs.getInt("id");
								dicMap.put(typename, id);
							}if(zz_sqlRs!=null){zz_sqlRs.close();}
							updateEnd =" where idcard='"+getValue(cell1)+"'";
	    				}else if(table.equals("teacher_basic")){//教职工
	    					//处理政治面貌
							String zz_sql = "SELECT typename,id FROM type where typegroupcode='administrativeLevel' or typegroupcode='politicsStatus'";
							ResultSet zz_sqlRs = db.executeQuery(zz_sql);
							while(zz_sqlRs.next()){
								String typename = zz_sqlRs.getString("typename");
								int id = zz_sqlRs.getInt("id");
								dicMap.put(typename, id);
							}if(zz_sqlRs!=null){zz_sqlRs.close();}
							// 处理学历
							String xl_sql = "SELECT name,id from jz_educational_info";
							ResultSet xl_sqlRs = db.executeQuery(xl_sql);
							while(xl_sqlRs.next()){
								String typename = xl_sqlRs.getString("name");
								int id = xl_sqlRs.getInt("id");
								dicMap.put(typename, id);
							}if(xl_sqlRs!=null){xl_sqlRs.close();}
							// 处理部门
							String bm_sql = "SELECT departments_name,id from dict_departments";
							ResultSet bm_sqlRs = db.executeQuery(bm_sql);
							while(bm_sqlRs.next()){
								String typename = bm_sqlRs.getString("departments_name");
								int id = bm_sqlRs.getInt("id");
								dicMap.put(typename, id);
							}if(bm_sqlRs!=null){bm_sqlRs.close();}
							//处理职位
							String dut_sql ="select dutiesname,id  from teacher_duties";
							ResultSet dy_sqlRs = db.executeQuery(dut_sql);
							while(dy_sqlRs.next()){
								String typename = dy_sqlRs.getString("dutiesname");
								int id = dy_sqlRs.getInt("id");
								dicMap.put(typename, id);
							}if(dy_sqlRs!=null){dy_sqlRs.close();}
							updateEnd =" where id_number='"+getValue(cell1)+"'";
	    				}
	    				else{
	    					updateEnd =" where id_number='"+getValue(cell1)+"'";
	    				}
	    				} catch (SQLException e) {
							e.printStackTrace();
						}
						String checkSql ="select count(id) row from "+table+ updateEnd;
						if(db.Row(checkSql)>0){
							update =true;
						}
							
						//去除insert时field为空的字段
							String[] fileds = field.split(",");
							String filednew = "";
	    					for(int k =0;k<rowhead.getLastCellNum();k++){
	    							Cell cell = row.getCell(k);
	    							if(StringUtils.isBlank(getValue(cell))){
	    								continue;
	    							}
	    	    					if(!update){	
	    	    						//values = values+getValue(cell)+"','";
	    	    						if(dicMap.containsKey(getValue(cell).replaceAll(" ", ""))){
	    	    							values = values+dicMap.get(getValue(cell))+"','";	
	    	    						}else{
	    	    							values = values+getValue(cell)+"','";	
	    	    						}
	    	    						filednew = filednew +fileds[k]+",";
	    	    					}else{
	    	    						if(dicMap.containsKey(getValue(cell).replaceAll(" ", ""))){
	    	    							//values = values+dicMap.get(getValue(cell))+"','";	
	    	    							values = values +filedsp[k]+" = '"+dicMap.get(getValue(cell))+"',";	
	    	    						}else{
	    	    							values = values +filedsp[k]+" = '"+getValue(cell)+"',";
	    	    						}
	    	    					}
	    				}
	    				values = values.substring(0,values.lastIndexOf(","));
	    				String sql ="";
	    				if(update){
	    					values =values.substring(1);
	    					values = values +" ,add_time=now() ";
	    					sql ="update  "+table+" set "+values +updateEnd;
	    					System.out.println("updateSql "+sql);
	    					if(db.executeUpdate(sql)){
	    						updaetNum++;
	    					}else{
	    						wrong.append(values);
	    					}
	    				}else{
	    						values = values + ",now()";
	    						sql ="insert into  "+table+" ("+filednew +"add_time "+") values " +"("+values+")";
	    						System.out.println("insertSql "+sql);
	    						if(db.executeUpdate(sql)){
	    							insertNum++;
		    					}else{
		    						wrong.append(values);
		    					}
	    				}
	    			}
	    		}
	    		if(db!=null)db.close();
	    		json.put("state", "success");
	    		json.put("updateNum",updaetNum);
	    		json.put("insertNum",insertNum);
	    		json.put("wrong",wrong.toString());
	    		return json;
	    }
	    
	    public JSONObject importExcel(InputStream is,String table,String field,String other) throws EncryptedDocumentException, InvalidFormatException, IOException {
	    	Jdbc db = new Jdbc();
	    	JSONObject json =new JSONObject();
	    	StringBuffer wrong = new StringBuffer();
	    	Workbook wb = WorkbookFactory.create(is);
	    	int updaetNum =0;
	    	int insertNum = 0;
	    		for (int i = 0, len = wb.getNumberOfSheets(); i < len; i++) {
	    			Sheet sheet = wb.getSheetAt(i);
	    			//获取excel表头
	    			Row rowhead = sheet.getRow(0);
	    			int idcardNum =1;
	    			if(null==rowhead){continue;}
	    			Map<String,Integer> headMap = new HashMap<String,Integer>();
	    			for(int r=0;r<rowhead.getLastCellNum();r++){
	    				Cell cell = rowhead.getCell(r);
	    				if(cell.getStringCellValue().replaceAll(" ", "").equals("身份证号")){
	    					idcardNum = r;
	    					headMap.put(cell.getStringCellValue(),r);
	    					break;
	    				}
	    			}
	    			
	    			for (int j = 1; j <= sheet.getLastRowNum(); j++) {
	    				if (sheet == null) {
	    					json.put("msg","没有表格数据");
	    					json.put("state", "success");
	    					return json;
	    				}
	    				Row row = sheet.getRow(j);
	    				if(row==null){
	    					json.put("msg","表格没数据");
	    					json.put("state", "success");
	    					return json;
	    				}
	    				
	    				String values ="'";
	    				boolean update = false;
	    				String[]  filedsp = field.split(",");
	    				//校验添加或者更新
	    				Cell cell1 = row.getCell(idcardNum);
	    				String updateEnd ="";
	    				
	    				if(table.equals("teacher_wages_distribution")){//工资查询需要判断发放日期
	    					Cell cell2 = row.getCell(1);//卡号
	    					Cell cell3 = row.getCell(5);//日期
	    					Cell cell4 = row.getCell(4);//摘要
	    					String remark =getValue(cell4);
	    					if(StringUtils.isBlank(remark)){
	    						remark = other;
	    					}
	    					updateEnd =" where  date='"+getValue(cell3)+"'  and bankcard='"+getValue(cell2)+"'"+" and remark ='"+remark+"'";
	    				}else{
	    					updateEnd =" where id_number='"+getValue(cell1)+"'";
	    				}
	    				
						String checkSql ="select count(id) row from "+table+ updateEnd;
						if(db.Row(checkSql)>0){
							update =true;
						}
						
	    					for(int k =0;k<rowhead.getLastCellNum();k++){
	    							Cell cell = row.getCell(k);
	    	    					if(!update){	
	    	    						//values = values+getValue(cell)+"','";
	    	    						if(dicMap.containsKey(getValue(cell).replaceAll(" ", ""))){
	    	    							values = values+dicMap.get(getValue(cell))+"','";	
	    	    						}else{
	    	    							//如果excel摘要没填，取页面输入默认摘要
	    	    							if(k==4&&StringUtils.isBlank(getValue(cell))){
	    	    								values = values+other+"','";	
	    	    							}else{
	    	    								values = values+getValue(cell)+"','";	
	    	    							}
	    	    						}
	    	    					}else{
	    	    						if(dicMap.containsKey(getValue(cell).replaceAll(" ", ""))){
	    	    							//values = values+dicMap.get(getValue(cell))+"','";	
	    	    							values = values +filedsp[k]+" = '"+dicMap.get(getValue(cell))+"',";	
	    	    						}else{
	    	    							//如果excel摘要没填，取页面输入默认摘要
	    	    							if(k==4&&StringUtils.isBlank(getValue(cell))){
	    	    								values = values +filedsp[k]+" = '"+other+"',";
	    	    							}else{
	    	    								values = values +filedsp[k]+" = '"+getValue(cell)+"',";
	    	    							}
	    	    						}
	    	    					}
	    				}
	    				values = values.substring(0,values.lastIndexOf(","));
	    				String sql ="";
	    				if(update){
	    					values =values.substring(1);
	    					values = values +" ,add_time=now() ";
	    					sql ="update  "+table+" set "+values +updateEnd;
	    					if(db.executeUpdate(sql)){
	    						updaetNum++;
	    					}else{
	    						wrong.append(values);
	    					}
	    				}else{
	    						values = values + ",now()";
	    						sql ="insert into  "+table+" ("+field +",add_time "+") values " +"("+values+")";
	    						if(db.executeUpdate(sql)){
	    							insertNum++;
		    					}else{
		    						wrong.append(values);
		    					}
	    				}
	    			}
	    		}
	    		if(db!=null)db.close();
	    		json.put("state", "success");
	    		json.put("updateNum",updaetNum);
	    		json.put("insertNum",insertNum);
	    		json.put("wrong",wrong.toString());
	    		return json;
	    }
	    //根据excel身份证号更新数据，更新的字段 field 更新的数量filenum
	    public JSONObject importXlsx(InputStream is,String table,String field,String filenum) throws EncryptedDocumentException, InvalidFormatException, IOException {
	    	Jdbc db = new Jdbc();
	    	JSONObject json =new JSONObject();
	    	StringBuffer wrong = new StringBuffer();
	    	Workbook wb = WorkbookFactory.create(is);
	    		// OPCPackage pkg = OPCPackage.open(is);
	    		// XSSFWorkbook wb = new XSSFWorkbook(pkg);
	    	int updaetNum =0;
	    	int insertNum = 0;
	    		for (int i = 0, len = wb.getNumberOfSheets(); i < len; i++) {
	    			Sheet sheet = wb.getSheetAt(i);
	    			//获取excel表头
	    			Row rowhead = sheet.getRow(0);
	    			int idcardNum =1;
	    			if(null==rowhead){continue;}
	    			Map<String,Integer> headMap = new HashMap<String,Integer>();
	    			for(int r=0;r<rowhead.getLastCellNum();r++){
	    				Cell cell = rowhead.getCell(r);
	    				if(cell.getStringCellValue().equals("身份证号")){
	    					idcardNum = r;
	    				}
	    				headMap.put(cell.getStringCellValue(),r);
	    			}
	    			
	    			for(String key : headMap.keySet()){
	    				Integer value = headMap.get(key); 
	    	            System.out.println(key+"  "+value); 
	    			}
	    			
	    			for (int j = 1; j <= sheet.getLastRowNum(); j++) {
	    				if (sheet == null) {
	    					json.put("msg","没有表格数据");
	    					json.put("state", "success");
	    					return json;
	    				}
	    				Row row = sheet.getRow(j);
	    				if(row==null){
	    					json.put("msg","表格没数据");
	    					json.put("state", "success");
	    					return json;
	    				}
	    				
	    				String values ="'";
	    				boolean update = false;
	    				String[]  filedsp = field.split(",");
	    				//校验添加或者更新
	    				Cell cell1 = row.getCell(idcardNum);
	    				System.out.println(cell1.getStringCellValue());
	    				String updateEnd =" where idcard='"+getValue(cell1)+"'";
						String checkSql ="select count(id) row from "+table+ updateEnd;
						if(db.Row(checkSql)>0){
							update =true;
						}
						System.out.println("checkSql---"+checkSql);
						ArrayList<String> b = new ArrayList<String>( ) ;
						Collections.addAll(b, filenum.split(","));  
						System.out.println(b.toString());
	    				//for(int k =0;k<Integer.parseInt(filenum);k++){
	    					for(int k =0;k<b.size();k++){
	    							int l = headMap.get(b.get(k));
	    							Cell cell = row.getCell(l);
	    	    					if(!update){	
	    	    						//values = values+getValue(cell)+"','";
	    	    						values = values+getValue(cell)+"','";
	    	    					}else{
	    	    						values = values +filedsp[k]+" = '"+getValue(cell)+"',";
	    	    					}
	    				}
	    				values = values.substring(0,values.lastIndexOf(","));
	    				String sql ="";
	    				if(update){
	    					values =values.substring(1);
	    					sql ="update  "+table+" set "+values +updateEnd;
	    					if(db.executeUpdate(sql)){
	    						updaetNum++;
	    					}else{
	    						wrong.append(values);
	    					}
	    				}else{
	    						sql ="insert into  "+table+" ("+field+") values " +"("+values+")";
	    						if(db.executeUpdate(sql)){
	    							insertNum++;
		    					}else{
		    						wrong.append(values);
		    					}
	    				}
	    			}
	    		}
	    		if(db!=null)db.close();
	    		json.put("state", "success");
	    		json.put("updateNum",updaetNum);
	    		json.put("insertNum",insertNum);
	    		json.put("wrong",wrong.toString());
	    		return json;
	    }
}
