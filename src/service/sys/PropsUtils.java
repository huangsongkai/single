package service.sys;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.util.Properties;

import service.common.SystemPath;

/** 
* 类名称 : PropsUtils 
* 类描述 : 用于更新读取*.properties文件, 
* 特别说明：为方便读，请使用getDefaultKeyFromClasspath方法，读取classpath下的res.properties 
*/ 
public class PropsUtils {

    private static Properties properties;
    private static PropsUtils proUtil;
    //static String pathAndName=SystemPath.aa()+"sendCode.properties";
    
    
    static String Interface_Engname ="tool.sendMessage.sendMail.PropsUtils";
    static String Interface_name 	="读取配置文件";
    
    
    static {
        properties = new Properties();
        proUtil = new PropsUtils();
    }

    public PropsUtils() { }


    /**
     * <pre>
     * 从classpath得到Properties中的值
     * @param key  要读取的key
     * @param pathAndName 要读的文件(含路径),
     * eg:getKeyFromClasspath(key,"res.properties")
     * 或getKeyFromClasspath(key,"com/utils/res.properties")
     * @return value
     * </pre>
     
	    public static String getKeyFromClasspath(String key) {
	        String value = null;
	        try {
	            InputStream in = proUtil.getClass().getClassLoader()
	                    .getResourceAsStream(pathAndName);
	            Properties properties = initStream(in);
	            value = properties.getProperty(key);
	        } catch (Exception e) {
	        	String  error="load file error , file---->[" + pathAndName + "]," + " error message: " + e.toString();
	        	Atm.SendErrorMail(Interface_Engname, Interface_name, error, "错误所在行:"+OtherSettings.getLineInfo());
	            e.printStackTrace();
	        }
	
	        return value;
	    }
	*/
    /**
     * 默认从classpath下的res.properties得到Properties中的值
     * 
     * @param key
     *            要读取的key
     * @param pathAndName
     *            要读的文件(含路径)
     * @return value
     
	    public static String getDefaultKeyFromClasspath(String key) {
	        String pathAndName = "res.properties";
	        String value = null;
	        try {
	            InputStream in = proUtil.getClass().getClassLoader()
	                    .getResourceAsStream(pathAndName);
	            Properties properties = initStream(in);
	            value = properties.getProperty(key);
	        } catch (Exception e) {
	            String  error="load file error , file---->[" + pathAndName + "]," + " error message: " + e.toString();
	        	Atm.SendErrorMail(Interface_Engname, Interface_name, error, "错误所在行:"+OtherSettings.getLineInfo());
	            e.printStackTrace();
	        }
	
	        return value;
	    }
     */
    /**
     * <pre>
     * 从文件系统得到Properties中的值
     * @param key  要读取的key
     * @param pathAndName 要读的文件(含路径)
     * eg: getKeyFromFileSystem(key,"d:/res.properties")
     * @return value
     * </pre>
     */
    public static String getKey(String key,String pathAndName) {
        String value = null;
        try {
            InputStream in = new FileInputStream(pathAndName);
            Properties properties = initStream(in);
            value = properties.getProperty(key);
        } catch (Exception e) {
        	String  error="load file error , file---->[" + pathAndName + "]," + " error message: " + e.toString();
            e.printStackTrace();
        }

        return value;
    }

    /**
     * 在classpath改变或添加一个key的值，当key存在于properties文件中时该key的值被value所代替，
     * 当key不存在时，该key的值是value
     * 
     * @param key
     *            要存入的键
     * @param value
     *            要存入的值
     * @param pathAndName
     *            要存的文件(含路径)
     
	    public static boolean setClasspathPropes(String key, String value) {
	    	boolean state=false;
	    	try {
	            InputStream in = proUtil.getClass().getClassLoader()
	                    .getResourceAsStream(pathAndName);
	            Properties properties = initStream(in);
	            in.close();
	            FileOutputStream out = new FileOutputStream("src/" + pathAndName);
	            properties.setProperty(key, value);
	            properties.store(out, "update  " + key + " value");
	            out.close();
	            state=true;
	        } catch (Exception e) {
	        	String  error="load file error , file---->[" + pathAndName + "]," + " error message: " + e.toString();
	        	Atm.SendErrorMail(Interface_Engname, Interface_name, error, "错误所在行:"+OtherSettings.getLineInfo());
	            e.printStackTrace();
	            state=false;
	        }
	        
	        return state;
	    }
	*/
    /**
     * 在文件系统改变或添加一个key的值，当key存在于properties文件中时该key的值被value所代替，
     * 当key不存在时，该key的值是value
     * 
     * @param key
     *            要存入的键
     * @param value
     *            要存入的值
     * @param pathAndName
     *            要存的文件(含路径)
     */
    public static boolean setvalue(String key, String value,String pathAndName) {
        
    	boolean state=false;
    	try {
            InputStream in = new FileInputStream(pathAndName);
            Properties properties = initStream(in);
            in.close();
            FileOutputStream out = new FileOutputStream(pathAndName);
            properties.setProperty(key, value);
            properties.store(out, "update  " + key + " value");
            out.close();
            state=true;
        } catch (Exception e) {
        	String  error="load file error , file---->[" + pathAndName + "]," + " error message: " + e.toString();
            e.printStackTrace();
            state=false;
        }
        

        return state;
    }
    
    
    /**
     * initStream
     * 初始化
     * @return
     */
    public static Properties initStream(InputStream in, String... file)
            throws Exception {
        FileInputStream inputFile;
        if (file != null && file.length == 1) {
            inputFile = new FileInputStream(file[0]);
            properties.load(inputFile);
        } else {
            properties.load(in);
        }
        return properties;
    }
    
    
    /**
     * @author Administrator
     * @date 2017-8-29
     * @file_name main
     * @Remarks   测试方法
     */
    public static void main(String[] args) {
    	//System.out.println(setvalue("time","123123123"));
    	System.out.println(getKey("content",SystemPath.aa()+"sendCode.properties"));
	}
}