package v1.haocheok.login.service;

import v1.haocheok.commom.entity.InfoEntity;



public interface APILoginService {

	/**
	 * 登陆验证并且返回相应内容
	 * @return
	 */
	public String loginVerification(String mobile,String password,InfoEntity info,String claspath);
	
	
	
}
