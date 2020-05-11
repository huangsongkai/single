package v1.haocheok.list.service;

import java.util.HashMap;

import v1.haocheok.commom.entity.InfoEntity;

public interface CompletedListService {
	
	public String  getCompletedList(String rolecode,String regionalcode,InfoEntity info,HashMap<String, Object> map,String keyword);

}
