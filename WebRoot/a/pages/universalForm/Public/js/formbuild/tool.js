//这个方法只是用来做个掩护,没有这个掩护是不行的!  
function mySubmit(flag){  
    return flag;  
}  
 

function judgementNull(a,b){//id  值 

	alert("进入判断方法");
	alert("判断a==="+a);
	alert("判断b==="+b);

    if(b !== null || b !== undefined || b !== ''){
    	// return mySubmit(true);
    }else{
    	alert("请填写属性值");
 		// return mySubmit(false); 
    }

}
