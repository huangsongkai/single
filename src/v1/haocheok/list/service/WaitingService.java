package v1.haocheok.list.service;

import java.util.HashMap;

import v1.haocheok.commom.entity.InfoEntity;

public interface WaitingService {
	
	public String  getwaitingList(String rolecode,String regionalcode,InfoEntity info,HashMap<String, Object> map,String keyword,String buttoncode);

}
