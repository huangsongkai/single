package v1.haocheok.list.service;

import java.util.HashMap;

import v1.haocheok.commom.entity.InfoEntity;

public interface RefuseListService {
	
	public String  getRefuseList(String rolecode, String regionalcode,InfoEntity info,HashMap<String, Object> map,String keyword);

}
