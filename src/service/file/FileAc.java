package service.file;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.io.Writer;

/**
 * @category 目录创建于删除   文件读写
 * @author LiGaoSong E-mail: 932246@qq.com
 * @version 创建时间：2016-7-25 下午07:06:34 
 */
public class FileAc {

	/**
	 * @category 目录创建
	 * @param DirName
	 *          目录名
	 * @param del
	 *          如果目录名存在是否删除。0不删除，1删除
	 */

	public String MDir(String DirName, int del) {
		String value = "创建中";
		try {
			File dirName = new File(DirName);
			if (dirName.exists()) {
				if (del == 1) {
					dirName.delete();
					value = DirName + "已经存在，已经删除，重新创建";
				}else{
					value = DirName + "已经存在，不用重创建";
				}
			} else {
				// 建立Test目录
				   // 获得文件对象  
	            File f = new File(DirName);  
	            if (!f.exists()) {  
	                // 如果路径不存在,则创建  
	                f.mkdirs();  
	            }  
	            value = DirName + "目录创建成功";
				
			}
		} catch (Exception e) {
			value = "目录创建失败";
		}

		return value;
	}

	 /**
	   * 删除空目录
	   * @param dir 将要删除的目录路径
	   */
	public static boolean doDeleteEmptyDir(String dir) {
		      boolean success = (new File(dir)).delete();
		      if (success) {
		          System.out.println("Successfully deleted empty directory: " + dir);
		      } else {
		          System.out.println("Failed to delete empty directory: " + dir);
		      }
		      return success;
	 }

  /**
   * 递归删除目录下的所有文件及子目录下所有文件
   * @param dir 将要删除的文件目录
   * @return boolean Returns "true" if all deletions were successful.
   *                 If a deletion fails, the method stops attempting to
   *                 delete and returns "false".
   */
	public static boolean deleteDir(File dir) {
	      if (dir.isDirectory()) {
	          String[] children = dir.list();
	         //递归删除目录中的子目录下
	          for (int i=0; i<children.length; i++) {
	              boolean success = deleteDir(new File(dir, children[i]));
	              if (!success) {
	                  return false;
	              }
	          }
	      }
	      // 目录此时为空，可以删除
	      return dir.delete();
	  }

	/**
	 * @category 写入方法
	 * @param path
	 * @param str
	 * @param filename
	 */

	public String write(String path, String filename, String str) {
		String value = "";

		try {

			OutputStream os2 = new FileOutputStream(path + "/" + filename);
			Writer writer2 = new BufferedWriter(new OutputStreamWriter(os2, "UTF-8"));
			writer2.write(str);
			writer2.close();
			os2.close();
			value = "写入成功";

		} catch (Exception e) {

			value = "文件写入失败";
		}
		return value;
	}

	/**
	 * @category 读取方法
	 * @param path
	 */
	public String read(String path, String filename) {
		String value = "";
		try {
			FileInputStream fs = new FileInputStream(path + filename);
			BufferedReader br = new BufferedReader(new InputStreamReader(fs, "UTF8"));
			String Line = br.readLine();// 从文件读取一行字符串
			// 判断读取到的字符串是否不为空
			String template = "";

			while (Line != null) {
				template = template + Line + "\r\n";
				// 输出从文件中读取的数据
				Line = br.readLine();// 从文件中继续读取一行数据
			}
			br.close();// 关闭BufferedReader对象
			fs.close();// 关闭文件
			value = template;

		} catch (Exception e) {
			value = "文件读取失败";
		}
		return value;
	}

	/**
	 * @category测试方法
	 * 
	 */
	public static void main(String[] args) {
		@SuppressWarnings("unused")
		FileAc fileAc = new FileAc();
		
		//String pathString=System.getProperty("user.dir")+"\\src\\v1\\app\\module\\user\\";
		//String string2 = fileAc.read(pathString,"ModifyUserInfo.java");
		
		// System.out.println(pathString);
		// 写入
		//String string1 = fileAc.write(pathString, "test.txt", string2);
		//System.out.println(string1);

		// 读取
       // String string2 = fileAc.read(pathString, "access_token.key");
		// System.out.println(string2);

//		// 创建目录
//		 String string3 = fileAc.MDir("C:\\song\\MyEclipse8.5\\houseslease\\src\\qqq\\99\\00\\", 0);
//		 System.out.println(string3);
		 
		
		//删除空目录
	   System.out.println(doDeleteEmptyDir("C:\\Users\\Administrator\\Pictures\\work_test\\work_test3_1502095245814_1.jpg"));
	  
		//删除非空目录/或者文件
//	    System.out.println( deleteDir(new File("C:\\Users\\Administrator\\Pictures\\风景\\work_test3_1502095245810_0.jpg")));
		
		
       
	}

}
