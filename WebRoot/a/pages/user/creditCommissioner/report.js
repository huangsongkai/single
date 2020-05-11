//报件车型为新车时，计算填充缴费明细
			function countFee(){
				var invoice = $('#invoice_price').val() ;//发票价格
				if(invoice==''){
					return false;
				}
				if(!valiNum(invoice)){
					layer.alert("发票价格请输入正数");
					return false;
				}
				var basePath = getBasePath();
				//根据政策类型获取政策计算公式，根据银行id获取a，b
				var policyId = $('#policy_type option:selected').val();
				if(policyId==''){
					layer.alert("请选择政策类型");
					return false;
				}
				var bankId = $("#bank option:selected").val();
				if(bankId==''){
					layer.alert('请选择银行');
					return false;
				}
				//替换计算公式字母
				//获取银行a，b
				var a,b;
				$.ajax({  
			         type : "post",  
			          url : basePath+"/Api/v1/?p=web/get/getBank",  
			          data : { id: bankId},  
			          async : false,  
			          success : function(data){  
			          var datas = eval('(' + data + ')');
		                	if(datas.resultCode=='1000'){
		                	var bank = datas.data[0];
		                	a = bank.a;
		                	b = bank.b;
		                	}else{
		                		layer.alert("查询失败,请稍后再试");
		                	}
			          }  
			     }); 
			     //获取政策类型公式
			     var policyname,x,loanratio,y,w,z,mode,o,p,q,months,warranty,m,f,h,n,s;
			     $.ajax({  
			         type : "post",  
			          async : false, 
			          url : basePath+"/Api/v1/?p=web/get/getPolicy",  
			          data : { id: policyId},  
			          success : function(data){  
			          var datas = eval('(' + data + ')');
		                	if(datas.resultCode=='1000'){
		                	var policy = datas.data[0];
		                	policyname = policy.policyname;
		                	loanratio = policy.loanratio;
		                	x = policy.x;
		                	y = policy.y;
		                	w = policy.w;
		                	z = policy.z; mode = policy.mode; o = policy.o; p = policy.p; q = policy.q; months = policy.months; warranty = policy.warranty;
		                	m = policy.m; f = policy.f; h = policy.h ; n = policy.n; s = policy.s;
		                	}else{
		                		layer.alert("查询失败,请稍后再试");
		                	}
			          }  
			     }); 
			     
			     var invoice = $('#invoice_price').val() ;//发票价格
			     $("input[name='down_payment_ratio']").val(loanratio) ;//首付比例
			  
			     //实际贷款额 为发票价*（1-首付比例）
			    var str=loanratio.replace("%","");
   				 str= str/100;
			     x = invoice*(1-str);
			     $("input[name='actual_loan_amount']").val(reatinNum(x)) ;//实际贷款额
			     if(y!==''){
			     	y = eval(y);
			     	//y = reatinNum(y);
			     $("input[name='amount_of_financing_loans']").val(reatinNum(y)) ;//上融贷款额
			     }
			     if(w!==''){
			     	w = eval(w);
			     	w = reatinNum(w);
			      $("input[name='incom']").val(w) ;//收入
			     }
			      if(z!==''){
			    	  z = eval(z);//月还款系数
			      }
			      if(mode!==''){
			      	mode = eval(mode);//月还款方式
			      $("input[name='monthly_amount']").val(reatinNum(mode)) ;//月还款金额
			      }
			      if(o!==''){
			      	o = eval(o);//担保费
			       $("input[name='guarantee_fee']").val(reatinNum(o)) ;//担保费
			      }
			      if(p!==''){
			      	p = eval(p);//服务费
			       $("input[name='service_charge']").val(reatinNum(p)) ;//服务费
			      }
			      if(s!==''){
			      	s = eval(s);
			       $("input[name='consolidated_service_charge']").val(reatinNum(s)) ;//综合服务费
			      }
			      if(warranty!==''){
			      	warranty= eval(warranty);
			      	  $("input[name='performance_bond']").val(reatinNum(warranty)) ;//履约保证金
			      }
			      
			}
			
			//获取项目路径
			function getBasePath(){
				 var curWwwPath = window.document.location.href;
			    var pathName = window.document.location.pathname;
			    var pos = curWwwPath.indexOf(pathName);
			    var localhostPath = curWwwPath.substring(0, pos);
			    var projectName = pathName.substring(0, pathName.substr(1).indexOf('/') + 1);
			    var basePath=localhostPath+projectName+"/";
			    return basePath;
			}
			
			//校验正数
			function valiNum(num){
				var reg = /^\d+(?=\.{0,1}\d+$|$)/
				  if(reg.test(num)) return true;
				  return false ;  
				}
			
			//保留2位，不四舍五入
			function reatinNum(value) {
				var value=Math.floor(parseFloat(value)*100)/100;
				 var xsd=value.toString().split(".");
				 if(xsd.length==1){
				 value=value.toString()+".00";
				 return value;
				 }
				 if(xsd.length>1){
				 if(xsd[1].length<2){
				  value=value.toString()+"0";
				 }
				 return value;
				 }
			}