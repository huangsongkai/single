package service.sys;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;

import org.apache.log4j.PropertyConfigurator;

public class initLog4j extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Override
	public void init() throws ServletException {
		super.init();
		System.out.println("初始化log4j");
		String prefix = getServletContext().getRealPath("/");
		// Log4J
		String log4jFile = getServletConfig().getInitParameter("log4j");
		String log4jConfigPath = prefix + log4jFile;
		PropertyConfigurator.configure(log4jConfigPath);
	}
}
