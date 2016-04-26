var netAjax = new Object();	//����һ��ȫ�ֱ���

// �������� ==> AjaxRequest����
netAjax.AjaxRequest = function(url, onload, onerror, method, params){	//��д���캯��
	this.req = null;
	this.onload = onload;
	this.onerror = (onerror) ? onerror : this.defaultError;
	this.loadData(url, method, params);
}

//��д���ڳ�ʼ��XMLHttpRequest�����ƶ��������������Http����ķ���
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
				// ��loader����ȥ��ΪonReadyState�����е�this
				netAjax.AjaxRequest.onReadyState.call(loader);
			}
			this.req.open(method, url, true);	//�����Է������ĵ���
			if("POST" == method){
				//��������ͷ
				this.req.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
			}
			this.req.send(params);	//��������
		} catch (err) {
			this.onerror.call(err);
		}
	}
}

//�ع��ص�����
netAjax.AjaxRequest.onReadyState = function(){
	var req = this.req;
	var ready = req.readyState;
	if(4 == ready){
		if(200 == req.status){
			// ����������onload������Ϊ200����Ĵ�����
			this.onload.call(this);
		}
		else{
			// ����������onerror����(����defaultError)��Ϊ��200����Ĵ�����
			this.onerror.call(this);
		}
	}
}

//�ع�Ĭ�ϵĴ�������
netAjax.AjaxRequest.prototype.defaultError = function(){
	alert("��������\n\n�ص�״̬: "+this.req.readyState+"\n״̬: "+this.req.status);
}