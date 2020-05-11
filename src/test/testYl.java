package test;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.Semaphore;

import net.sf.json.JSONObject;

import service.net.HttpRequest;

public class testYl {
	private static int thread_num = 200;
	private static int client_num = 200;
	private static Map keywordMap = new HashMap();
	static {
		try {
			InputStreamReader isr = new InputStreamReader(new FileInputStream(new File("D:/clicks.txt")), "utf-8");
			BufferedReader buffer = new BufferedReader(isr);
			String line = "";
			while ((line = buffer.readLine()) != null) {
				keywordMap.put(line.substring(0, line.lastIndexOf(":")), "");
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public static void main(String[] args) {
		int size = keywordMap.size();
		// TODO Auto-generated method stub
		ExecutorService exec = Executors.newCachedThreadPool();
		// 50个线程可以同时访问
		final Semaphore semp = new Semaphore(thread_num);
		// 模拟2000个客户端访问
		for (int index = 0; index < client_num; index++) {
			final int NO = index;
			Runnable run = new Runnable() {
				public void run() {
					try {
						// 获取许可
						semp.acquire();
						
						String url = "http://127.0.0.1:5151/hljsfjy/Api/v1/?p=web/info/getClassGrade";
						Map<String, String> headers = new HashMap<String, String>();
						headers.put("X-AppId", "8381b915c90c615d66045e54900feeab");
						headers.put("X-AppKey", "d4df770ef73bd57653b0af59934296ee");
						headers.put("Content-Type", "application/json; charset=utf-8");
						headers.put("Accept", "application/json; charset=utf-8");
						headers.put("Token", "95dbd44f69c3d662c8293dd5190c0292");
						headers.put("X-USERID", "40");
						headers.put("X-UUID", "000000000000000000000000");
						JSONObject data = JSONObject.fromObject("{'major_id':'1'}");
						
						String result = HttpRequest.post(url, headers, data.toString());
						
						
						//String host = "http://10.99.23.42:7001/KMQueryCenter/query.do?";
						PrintWriter out = new PrintWriter((new OutputStreamWriter(new FileOutputStream("D:/clicks.txt",true), "utf-8")));
						out.print(result);
						out.flush();
						out.close();
						// System.out.println(result);
						// Thread.sleep((long) (Math.random()) * 1000);
						// 释放
						System.out.println("第：" + NO + " 个");
						semp.release();
					} catch (Exception e) {
						e.printStackTrace();
					}
				}
			};
			exec.execute(run);
		}
		// 退出线程池
		exec.shutdown();
	}

	private static String getRandomSearchKey(final int no) {
		String ret = "";
		int size = keywordMap.size();
		// int wanna = (int) (Math.random()) * (size - 1);
		ret = (keywordMap.entrySet().toArray())[no].toString();
		ret = ret.substring(0, ret.lastIndexOf("="));
		System.out.println("\t" + ret);
		return ret;
	}
}
