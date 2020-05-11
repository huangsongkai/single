package test.data;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Iterator;
import java.util.List;

import org.apache.commons.lang.StringUtils;


public class test {
	public static void main(String[] args) {
       /* List<String> list1 = new ArrayList<String>();
        list1.add("1111");
        list1.add("2222");
        list1.add("3333");

        List<String> list2 = new ArrayList<String>();
        list2.add("3333");
        list2.add("4444");
        list2.add("5555");

        // 并集
        //System.out.println(list1.addAll(list2)); 
        // 交集
         list1.retainAll(list2);
         list2.retainAll(list1);
         System.out.println(list1);
        // 差集
        // list1.removeAll(list2);
        // 无重复并集
        list2.removeAll(list1);
        list1.addAll(list2);

        Iterator<String> it = list1.iterator();
        while (it.hasNext()) {
            //System.out.println(it.next());

        }*/
		saass();
    }
	
	public static void saass(){
		String asString = "5or4or6=1";
		if(asString.indexOf("=")!=-1){
			List<String> list1 = Arrays.asList(asString.split("="));
			System.out.println(list1.get(list1.size()-1));
			/*List<String> list2 = Arrays.asList(list1.get(0).split("and"));
			System.out.println(StringUtils.join(list2, ","));*/
			List<String> list2 = Arrays.asList(list1.get(0).split("or"));
			List<String> list3 = new ArrayList<String>();
			String ss = "";
			for(int i =0;i<list2.size();i++){
				list3.add("nodeid="+list2.get(i));
			}
			System.out.println(StringUtils.join(list3, " or "));
			
			String name="ligaosong",xiaoqu="超白人家";
			String sqlString="UPDATE `【表名】` "
				  +"SET"
				    +"`name`='"+name+"',"
				    +"`xiaoqu`='"+xiaoqu+"'" 
				  +" WHERE " 
				    +"id=注意条件判断小心 ";
			
			System.out.println(sqlString);
			
		}
	}

}
