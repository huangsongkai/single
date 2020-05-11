package service.dao.db;

import java.security.MessageDigest;

import service.common.user.IdcardValidator;

/**
 * @author LiGaoSong E-mail: 932246@qq.com
 * @version 创建时间：2016-7-25 下午07:06:34 类说明 :MD5加密
 */
public class Md5 {
	IdcardValidator iv = new IdcardValidator();

	public String md5(String s) {
		char hexDigits[] = { '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'a', 'b', 'c', 'd', 'e', 'f' };
		try {
			byte[] strTemp = s.getBytes();
			MessageDigest mdTemp = MessageDigest.getInstance("MD5");
			mdTemp.update(strTemp);
			byte[] md = mdTemp.digest();
			int j = md.length;
			char str[] = new char[j * 2];
			int k = 0;
			for (int i = 0; i < j; i++) {
				byte byte0 = md[i];
				str[k++] = hexDigits[byte0 >>> 4 & 0xf];
				str[k++] = hexDigits[byte0 & 0xf];
			}
			return new String(str);
		} catch (Exception e) {
			return null;
		}
	}
	
	

	public static String get(String s) {
		char hexDigits[] = { '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'a', 'b', 'c', 'd', 'e', 'f' };
		try {
			byte[] strTemp = s.getBytes();
			MessageDigest mdTemp = MessageDigest.getInstance("MD5");
			mdTemp.update(strTemp);
			byte[] md = mdTemp.digest();
			int j = md.length;
			char str[] = new char[j * 2];
			int k = 0;
			for (int i = 0; i < j; i++) {
				byte byte0 = md[i];
				str[k++] = hexDigits[byte0 >>> 4 & 0xf];
				str[k++] = hexDigits[byte0 & 0xf];
			}
			return new String(str);
		} catch (Exception e) {
			return null;
		}
	}

	/**
	 * 
	 * @author Administrator
	 * @date 2017-10-16
	 * @Remarks 加密用户关键信息 身份证
	 */
	public static String encryptedIDcard(String iDcard) {

		StringBuffer buffer = new StringBuffer(iDcard);

		if (iDcard.length() == 15) {// 15位
			buffer.replace(5, 12, "*******");
		} else if (iDcard.length() == 18) {// 18位
			buffer.replace(9, 16, "*******");
		} else {//
			return iDcard;
		}

		return buffer.toString();
	}

	/**
	 * 
	 * @author Administrator
	 * @date 2017-10-16
	 * @Remarks 加密用户关键信息 ，结婚证，
	 */
	public static String encryptedMarriageCard(String MarriageCard) {

		StringBuffer buffer = new StringBuffer(MarriageCard);
		buffer.replace(3, 7, "****");
		buffer.replace((buffer.length() - 5), buffer.length(), "*****");

		return buffer.toString();
	}

	/**
	 * 
	 * @author Administrator
	 * @date 2017-10-16
	 * @Remarks 加密用户关键信息 银行卡号
	 */
	public static String encryptedBankNumber(String BankNumber) {
		StringBuffer buffer = new StringBuffer(BankNumber);
		buffer.replace((buffer.length() - 13), ((buffer.length() - 13) + 8), "********");
		return buffer.toString();
	}

	public static void main(String[] args) {

		// Md5 p1= new Md5();
		// System.out.println(p1.md5("admin"));

		// StringBuffer buffer = new StringBuffer("6212262201023557228");
		StringBuffer buffer = new StringBuffer("J110101-2010-000001");
		System.out.println(buffer.toString());// 输出123456
		System.out.println((buffer.length() - 15));// 输出123456
		buffer.replace(3, 7, "****");
		buffer.replace((buffer.length() - 5), buffer.length(), "*****");

		System.out.println(buffer.toString());// 输出123456

		// Md5.encryptedBankNumber(BankNumber);//加密银行卡号
		// Md5.encryptedIDcard(iDcard);//加密身份证号
		// Md5.encryptedMarriageCard(MarriageCard);//加密结婚证号
	}

}
