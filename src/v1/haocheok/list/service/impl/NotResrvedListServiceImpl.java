package v1.haocheok.list.service.impl;

import java.util.ArrayList;

import net.sf.json.JSONObject;
import service.dao.db.Jdbc;
import service.dao.db.Md5;
import service.dao.db.Page;
import v1.haocheok.commom.entity.InfoEntity;
import v1.haocheok.list.service.NotResrvedListService;

public class NotResrvedListServiceImpl implements NotResrvedListService {

	@Override
	public String getNotResrvedList(String rolecode, InfoEntity info) {
		Jdbc db = new Jdbc();
		Page page = new Page();
		Md5 md5ac = new Md5();
		String responsejson="";
		String classname="APP已接单";
		JSONObject json = new JSONObject();
	    ArrayList list = new ArrayList();
		
		try {
			String sql_baseString = "select * from order_sheet,process_log where order_";
			
			
			
			
		} catch (Exception e) {
			// TODO: handle exception
		}
	    
	    
	    
	    
		
		return null;
	}

}
