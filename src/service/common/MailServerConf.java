package service.common;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.util.Properties;

public class MailServerConf {
	
	private static Properties properties;
	@SuppressWarnings("unused")
	private static MailServerConf proUtil;
	
	static String pathAndName=SystemPath.aa()+"mailserver.properties";//配置文件路径
	
    static String Interface_Engname ="tool.sendMessage.sendMail.MailServerConf";
    static String Interface_name 	="读取配置文件";
    
    static {
        properties = new Properties();
        proUtil = new MailServerConf();
    }

    public MailServerConf() { }
	
    
    
    /**
     * <pre>
     * 从文件系统得到Properties中的值
     * @param key  要读取的key
     * @param pathAndName 要读的文件(含路径)
     * eg: getKeyFromFileSystem(key,"d:/res.properties")
     * @return value
     * </pre>
     */
    public static String get(String key) {
        String value = null;
        try {
            InputStream in = new FileInputStream(pathAndName);
            Properties properties = initStream(in);
            value = properties.getProperty(key);
        } catch (Exception e) {
        	String  error="load file error , file---->[" + pathAndName + "]," + " error message: " + e.toString();
        	System.out.println(error);
        }

        return value;
    }
    
    
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
    public static boolean set(String key, String value) {
        
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
        	System.out.println(error);
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
    	System.out.println(set("type","2"));
    	System.out.println(get("type"));
	}
    
}