package service.net;

import java.io.IOException;
import java.io.InputStream;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.Map.Entry;

import net.sf.json.JSONObject;

import org.apache.commons.io.IOUtils;
import org.apache.http.HttpEntity;
import org.apache.http.HttpException;
import org.apache.http.client.config.RequestConfig;
import org.apache.http.client.methods.CloseableHttpResponse;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.client.methods.RequestBuilder;
import org.apache.http.entity.ByteArrayEntity;
import org.apache.http.entity.InputStreamEntity;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClientBuilder;
import org.apache.http.params.HttpParams;
import org.apache.http.util.EntityUtils;

/**
 * @category HTTP客户端,用来演示通过GET或者POST,PUT,DELEL方式发送数据
 * @author 李高颂
 * @version 1.0
 */
 
public class HttpRequest {
	private enum GetMethod {
		GET, PUT, DELETE;
	}

 
	
	private static RequestConfig clientConfig = RequestConfig.custom()
	    .setConnectTimeout(30 * 1000)
	    .setSocketTimeout(30 * 1000).build();
	private static CloseableHttpClient client = HttpClientBuilder.create().setDefaultRequestConfig(clientConfig).build();

	/**
	 * @category post 方法提交
	 * @param url
	 * @param pararm
	 * @throws HttpException
	 * @throws IOException
	 */

	/*
	 * 字符串
	 */
	public static String post(String url, Map<String, String> headers, String data) throws HttpException, IOException {
		return internalPost(url, headers, new StringEntity(data,"UTF-8"));
	}

	/*
	 * 数组
	 */
	public static String post(String url, Map<String, String> headers, byte[] data) throws HttpException, IOException {
		return internalPost(url, headers, new ByteArrayEntity(data));
	}

	/*
	 * 二进制流
	 */
	public static String post(String url, Map<String, String> headers, InputStream data) throws HttpException, IOException {
		return internalPost(url, headers, new InputStreamEntity(data));
	}

	/*
	 * 发送数据
	 */
	private static String internalPost(String url, Map<String, String> headers, HttpEntity data) throws HttpException, IOException {

		HttpPost post = new HttpPost(url);
		if (headers != null) {
			Iterator<Entry<String, String>> it = headers.entrySet().iterator();
			while (it.hasNext()) {
				Entry<String, String> entry = it.next();
				post.setHeader(entry.getKey(), entry.getValue());
			}
		}

		if (data != null) {
			post.setEntity(data);
		}

		CloseableHttpResponse response = client.execute(post);
		try {
			if (response.getStatusLine().getStatusCode() == 200) {
				HttpEntity httpEntity = response.getEntity();
				try {
					String content = IOUtils.toString(httpEntity.getContent());
					return content;
				} finally {
					EntityUtils.consume(httpEntity);
				}
			} else {
				throw new HttpException(response.getStatusLine().toString());
			}
		} finally {
			response.close();
		}
	}

	/**
	 * @category get方法请求
	 * @param url
	 * @param headers
	 * @param parameters
	 * @return
	 * @throws HttpException
	 * @throws IOException
	 */
	public static String get(String url, Map<String, String> headers, Map<String, String> parameters) throws HttpException, IOException {
		return internalGet(GetMethod.GET, url, headers, parameters);
	}

	public static String put(String url, Map<String, String> headers, Map<String, String> parameters) throws HttpException, IOException {
		return internalGet(GetMethod.PUT, url, headers, parameters);
	}

	public static String delete(String url, Map<String, String> headers, Map<String, String> parameters) throws HttpException, IOException {
		return internalGet(GetMethod.DELETE, url, headers, parameters);
	}

	private static String internalGet(GetMethod method, String url, Map<String, String> headers, Map<String, String> parameters) throws HttpException, IOException {

		RequestBuilder get = null;
		switch (method) {
		case GET:
			get = RequestBuilder.get();
			break;
		case PUT:
			get = RequestBuilder.put();
			break;
		case DELETE:
			get = RequestBuilder.delete();
			break;
		}
		get.setUri(url);
		if (headers != null) {
			Iterator<Entry<String, String>> it = headers.entrySet().iterator();
			while (it.hasNext()) {
				Entry<String, String> entry = it.next();

				get.setHeader(entry.getKey(), entry.getValue());
			}
		}
		if (parameters != null) {
			Iterator<Entry<String, String>> it = parameters.entrySet().iterator();
			while (it.hasNext()) {
				Entry<String, String> entry = it.next();
				get.addParameter(entry.getKey(), entry.getValue());
			}
		}

		CloseableHttpResponse response = client.execute(get.build());
		try {
			if (response.getStatusLine().getStatusCode() == 200) {
				HttpEntity httpEntity = response.getEntity();
				try {
					String content = IOUtils.toString(httpEntity.getContent());
					return content;
				} finally {
					EntityUtils.consume(httpEntity);
				}
			} else {
				throw new HttpException(response.getStatusLine().toString());
			}
		} finally {
			response.close();
		}
	}
	
	
 
	
	
	/**
	 * @category 测试类
	 */
	public static void main(String[] args) throws IOException {
	  
		 
		 
	}

	}