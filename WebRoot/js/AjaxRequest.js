var netAjax = new Object();	//定义一个全局变量

// 函数对象 ==> AjaxRequest方法
netAjax.AjaxRequest = function(url, onload, onerror, method, params){	//编写构造函数
	this.req = null;
	this.onload = onload;
	this.onerror = (onerror) ? onerror : this.defaultError;
	this.loadData(url, method, params);
}

//编写用于初始化XMLHttpRequest对象并制定处理函数，最后发送Http请求的方法
netAjax.AjaxRequest.prototype.loadData = function(url, method, params){
	if(!method){
		method = "GET";
	}
	
	if(window.XMLHttpRequest){
		this.req = new XMLHttpRequest();
	}
	else if(window.ActiveXObject){
		this.req = new ActiveXObject("Microsoft.XMLHTTP");
	}
	
	if(this.req){
		try {
			var loader = this;
			this.req.onreadystatechange = function(){
				// 把loader传进去作为onReadyState函数中的this
				netAjax.AjaxRequest.onReadyState.call(loader);
			}
			this.req.open(method, url, true);	//建立对服务器的调用
			if("POST" == method){
				//设置请求头
				this.req.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
			}
			this.req.send(params);	//发送请求
		} catch (err) {
			this.onerror.call(err);
		}
	}
}

//重构回调函数
netAjax.AjaxRequest.onReadyState = function(){
	var req = this.req;
	var ready = req.readyState;
	if(4 == ready){
		if(200 == req.status){
			// 将传进来的onload函数作为200结果的处理函数
			this.onload.call(this);
		}
		else{
			// 见传进来的onerror函数(或者defaultError)作为非200结果的处理函数
			this.onerror.call(this);
		}
	}
}

//重构默认的错误处理函数
netAjax.AjaxRequest.prototype.defaultError = function(){
	alert("错误数据\n\n回调状态: "+this.req.readyState+"\n状态: "+this.req.status);
}