package service.sys;
public class B {

	/**
	 * 
	 * @param str
	 */
	public final  void Task(String str) {
		/*
		 * 这里是具体的你的业务代码，比如拨打电话。 下面写的是一个运行10秒的一个模拟业务例子。
		 */
		for (int i = 0; i < 10; i++) {
			System.out.println(str + " 具体业务逻辑代码，故意测试运行需要很多时间 " + i);
			try {
				Thread.sleep(1000);// 暂停1秒
			} catch (InterruptedException e) {
				e.printStackTrace();
			}
		}
		
		
	}

}
