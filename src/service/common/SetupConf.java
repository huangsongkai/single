package service.common;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

public class SetupConf {
	
    //private static final Logger log = LoggerFactory.getLogger(Env.class);
    private static Properties properties = getProperties();
	
	public static String get(String key) {
		        return properties.getProperty(key);
    }

	private static Properties getProperties() {
    	    int ErrLineNumber=0;
            Properties properties = new Properties();
            
            try {
                File file = new File(SystemPath.aa(), "setup.properties");
                InputStream inputStream = new FileInputStream(file);
                properties.load(inputStream);
                inputStream.close();
            } catch (IOException ex) {
                ex.printStackTrace();
                ErrLineNumber=ex.getStackTrace()[0].getLineNumber();
                System.out.println("ErrLineNumber="+ErrLineNumber);
            }
         	
            return properties;
        }
    
    public static void main(String[] args) { 

    	System.out.println("AppId===="+get("AppId"));
    	System.out.println("IOSAppKey===="+get("IOSAppKey"));
    	System.out.println("androidAppKey===="+get("androidAppKey"));
    	System.out.println("ebAppKe===="+get("ebAppKe"));
    	System.out.println("home_path===="+get("home_path"));
    	System.out.println("img_path===="+get("img_path"));
    	System.out.println("img_URL===="+get("img_URL"));
    	System.out.println("base_path===="+get("base_path"));
    	System.out.println("smtpserver===="+get("smtpserver"));
    	System.out.println("username===="+get("username"));
    	System.out.println("password===="+get("password"));
    	System.out.println("mailtype===="+get("mailtype"));
    	System.out.println("SmsUrl===="+get("SmsUrl"));

     
    }
    
    
}