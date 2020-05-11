package service.util.tool;

import org.apache.log4j.Level;
import org.apache.log4j.Logger;


/**
 * 
 * @company 010jiage
 * @author zhoukai04171019
 * @date:2017-9-20 下午04:33:47
 */
public class LogUtil {
//	private static Logger logger = Logger.getLogger(TestLog4j.class);
	
	protected static Logger getLogger(){
		StackTraceElement stack[] = (new Throwable()).getStackTrace();
		 
        Logger logger = Logger.getLogger(stack[1].getClassName());
        return logger;
	}
	
	/**
	 * 输出debug信息
	 * @param str
	 */
	public static void debug(String str){
		 
        Logger logger = getLogger();
        logger.log(LogUtil.class.getName(), Level.DEBUG, str, null);
	}
	
	/**
	 * 输出info信息
	 * @param str
	 */
	public static void info(String str){
		 
        Logger logger = getLogger();
        logger.log(LogUtil.class.getName(), Level.INFO, str, null);
	}
	
	/**
	 * 输出fatal信息
	 * @param str
	 */
	public static void fatal(String str){
		Logger logger = getLogger();
        logger.log(LogUtil.class.getName(), Level.FATAL, str, null);
	}
	
	
	/**
	 * 输出error信息
	 * @param str
	 */
	public static void error(String str){
		Logger logger = getLogger();
        logger.log(LogUtil.class.getName(), Level.FATAL, str, null);
	}
}
