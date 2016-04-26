<%@ page language="java" import="java.util.*" pageEncoding="UTF-8" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <title>找回密码</title>
    <meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">
    <link type="text/css" rel="stylesheet" href="./css/mystyle.css" >
    <script type="text/javascript" src="./js/AjaxRequest.js" ></script>
    <style type="text/css">
    	*{
    		font-family: "Arial","Microsoft YaHei","黑体","宋体",sans-serif;
    		font-size: 18pt;
    	}
    	input {
			height: 28px;
			vertical-align: middle;
		}
    	.prompt {
    		text-align: right;
    		width: 240px;
    	}
    	.inputContent {
    		text-align: left;
    		width: 240px;
    		padding-left: 18px;
    		size: 12;
    	}
    	#content{
    		position: absolute;
    		width: 720px;
    		height: 260px;
    		margin-top: 8%;
    		margin-left: 8%;
    		background-color: #BEE7E9;
    	}
    	.errInfos{
    		width: 240px;
    		position: absolute;
    		color: red;
    		margin-top: 12px;
    		font-size: 16;
    		font-family: "隶书";
    		font-style: italic;
    	}
    	/* 自定义按钮 */
    	.button, .button:visited {
			background: #222 repeat-x;
			display: inline-block;
			padding: 5px 10px 5px;
			color: #fff;
			-moz-border-radius: 6px;
			-webkit-border-radius: 6px;
			-moz-box-shadow: 0 1px 3px rgba(0,0,0,0.6);
			-webkit-box-shadow: 0 1px 3px rgba(0,0,0,0.6);
			text-shadow: 0 -1px 1px rgba(0,0,0,0.25);
			text-decoration: none;
			text-align: center;
			font-size: 15;
			border-bottom: 1px solid rgba(0,0,0,0.25);
			position: relative;
			cursor: pointer;
			height: 32px;
		}
    </style>
    <script type="text/javascript">
    	var cardIdCheck = false;
    	var pwd1Check = false;
    	var pwd2Check = false;
    	var validateCheck = false;
    	
    	/* 定义UID 密码检查正则规则 */
    	var regs = [ new RegExp("^[a-z0-9]{8,14}$", ""), // 数字 字母
    				 new RegExp("^[a-z0-9]{5,14}$", "")];
    	var emptyErrInfos = ["卡号不能为空", "重置密码不能为空", "验证码不能为空"];
    	var regErrInfos = ["卡号为8-14位的字母或数字", "密码为5-14位的字母或数字", "前后密码不一致"];
    	var ajaxErrInfos = ["卡号不存在", "用户不存在", "验证码错误,请重新输入"]; 
    			
    	window.onload = function(){
    		document.getElementsByName("cardId")[0].focus();
    	}
    	
    	function checkCardID(){
    		cardIdCheck = false;
    		var cardId = document.getElementsByName("cardId")[0].value;
			var errspan = document.getElementById("errcardId");
			if(""==cardId){
				errspan.innerHTML = emptyErrInfos[0];
				return;
			}
			
			if(!regs[0].test(document.getElementsByName("cardId")[0].value)){
    			errspan.innerHTML = regErrInfos[0];
    			return;
    		}
			
			var params = "processType=modifyPWD"
						+"&cardId="+cardId;
			var loader = 
   				new netAjax.AjaxRequest("regist.do?nocache="+new Date().getTime(),
				function(){
					var result = this.req.responseText;
					/* 此处将regist返回的标志进行部分修改: 
					 *	ok 表示卡号在卡号系统中同时在网站用户系统中,修改密码用户合法
					 *	notAllow 表示卡号在卡号系统中但不在网站用户系统中,修改密码用户不存在 
					 *	notExist 原本表示卡号不在卡号系统中
					 */
					if("ok" == result.substring(0,2)){
						document.getElementById("errcardId").style.color = "green";
						document.getElementById("errcardId").innerHTML
    						= "<img src='./images/login/ok.jpg' width='18px'/>"
    						  + "用户 " + result.substring(result.indexOf("_")+1); // 用户名在"ok_"之后
    					cardIdCheck = true;
    					return;
					}
					else if("notAllow" == result){
				   		document.getElementById("errcardId").innerHTML
				   			= "<img src='./images/login/error.jpg' width='18px'/>"+ajaxErrInfos[1];
					}
					else if("notExist" == result){
						document.getElementById("errcardId").innerHTML
				   			= "<img src='./images/login/error.jpg' width='18px'/>"+ajaxErrInfos[0];
					}
					document.getElementsByName("cardId")[0].focus();
				}, null, "POST", params);	
    	}
    	
    	function checkResetPwd1(){
    		pwd1Check = false;
    		var pwd1 = document.getElementsByName("resetpwd1")[0];
    		var errpwd1 = document.getElementById("errpwd1");
    		if("" == pwd1.value){
    			errpwd1.innerHTML = emptyErrInfos[1];
    			return;
    		}
    		if(regs[1].test(pwd1.value)){
    			errpwd1.innerHTML
    					= "<img src='./images/login/ok.jpg' width='18px'/>";
    			pwd1Check = true;
    		}
    		else{
    			pwd1.value.innerHTML = regErrInfos[1];
    		}
    	}
    	
    	function checkResetPwd2(){
    		pwd2Check = false;
    		var pwd1 = document.getElementsByName("resetpwd1")[0];
    		var pwd2 = document.getElementsByName("resetpwd2")[0];
    		var errpwd2 = document.getElementById("errpwd2");
    		if((pwd1.value == pwd2.value) && (""!=pwd2.value)){
    			errpwd2.innerHTML
    				= "<img src='./images/login/ok.jpg' width='18px'/>";
    			pwd2Check = true;
    		}
    		else{
    			errpwd2.innerHTML = regErrInfos[2];
    		}
    	}
    	
    	/* 更新验证码 */
    	function changeCode(){
    		//为了使每次生成图片不一致，即不让浏览器读缓存，所以需要加上时间戳
    		var timestamp = (new Date()).valueOf();
    		document.getElementById("validateCode").src = 
    			"./generateCode.do?timestamp="+timestamp;
    	}
    	
    	/* 检查验证码是否输入正确 */
    	function checkValidate(){
    		validateCheck = false;
    		var code = document.getElementsByName("validateCode")[0].value;
			var errspan = document.getElementById("validateErr");
			errspan.style.color = "red";
			if(""==code){
				errspan.innerHTML = 
					"<img src='./images/login/error.jpg' width='18px'/>"+emptyErrInfos[2];
				return;
			}
			var params = "processType=checkValidate"
						+"&code="+code;
			var loader = 
   				new netAjax.AjaxRequest("regist.do?nocache="+new Date().getTime(),
				function(){
					var result = this.req.responseText;
					if(result == "Right"){
						errspan.style.color = "green";
						document.getElementById("validateErr").innerHTML
    						= "<img src='./images/login/ok.jpg' width='18px'/>"+"验证码正确";
    					validateCheck = true;
					}
					else{
				   		document.getElementById("validateErr").innerHTML
				   			= "<img src='./images/login/error.jpg' width='18px'/>"+ajaxErrInfos[2];
						document.getElementsByName("validateCode")[0].focus();
					}
				}, null, "POST", params);	
    	}
    	
    	function modifyPwd(){
    		checkResetPwd1();
    		if(!pwd1Check) return;
    		checkResetPwd2();
    		if(!pwd2Check) return;
    		
			var inputCardId = document.getElementsByName("cardId")[0];
			var errspan = document.getElementById("errcardId");
			if(""==inputCardId.value){
				errspan.innerHTML = emptyErrInfos[0];
				inputCardId.focus();
				return;
			}
			if(!regs[0].test(inputCardId.value)){
    			errspan.innerHTML = regErrInfos[0];
				inputCardId.focus();
    			return;
    		}
    		
    		var inputValidate = document.getElementsByName("validateCode")[0];
			errspan = document.getElementById("validateErr");
			if(""==inputValidate.value){
				errspan.innerHTML = emptyErrInfos[2];
				inputValidate.focus();
				return;
			}
    		
    		if(cardIdCheck && validateCheck){
	    		var cardId = document.getElementsByName("cardId")[0].value;
				var newPWD = document.getElementsByName("resetpwd1")[0].value;
				
				var params = "cardId=" + cardId
							+"&newPWD="+ newPWD;
				var loader = 
	   				new netAjax.AjaxRequest("pwdModify.do?nocache="+new Date().getTime(),
					function(){
						var result = this.req.responseText;
						if("Success" == result){
							alert("修改密码成功,确定返回进行登陆");
							window.location.href = "./login.jsp";
						}
						else{
							alert("修改密码失败,请确认信息后再提交")
						}
					}, null, "POST", params);
    		}
    			
    	}
    	
    	function clearInput(){
    		document.getElementById("form_midifypwd").reset();
    		document.getElementById("errcardId").innerHTML = "";
    		document.getElementById("errpwd1").innerHTML = "";
    		document.getElementById("errpwd2").innerHTML = "";
    		document.getElementById("validateErr").innerHTML = "";
    	}
    </script>
  </head>
  <body bgcolor="#F0F0F0">
  	<div id="content">
  		<form id="form_midifypwd" autocomplete="off" >
		  	<table>
		  		<tr height="45px">
		  			<!-- 返回主界面 -->
		  			<td colspan="2">
		  				<img alt="返回登陆" src="./images/pwdforgetting/return.png" height="30px" 
		  						onclick="location.href = './login.jsp';" style="cursor: pointer;">
	  				</td>
	  			</tr>
		  		<tr>
		  			<td class="prompt">请输入您的卡号:</td>
		  			<td class="inputContent">
		  				<input type="text" name="cardId" size="12" onblur="checkCardID();"/>
		  			</td>
		  			<td id="errcardId" class="errInfos"></td>
		  		</tr>
		  		<tr>
		  			<td class="prompt">重置密码:</td>
		  			<td class="inputContent">
		  				<input type="password" name="resetpwd1" size="12" onblur="checkResetPwd1();"/>
		  			</td>
		  			<td id="errpwd1" class="errInfos"></td>
		  		</tr>
		  		<tr>
		  			<td class="prompt">确认密码:</td>
		  			<td class="inputContent">
		  				<input type="password" name="resetpwd2" size="12" onblur="checkResetPwd2();"/>
		  			</td>
		  			<td id="errpwd2" class="errInfos"></td>
		  		</tr>
		  		<tr>
		  			<td class="prompt">输入验证码:</td>
		  			<td class="inputContent">
		  				<input type="text" name="validateCode" size="4" onblur="checkValidate();"/>
		  				<img id="validateCode" alt="验证码" src="./generateCode.do" style="cursor: pointer; position: absolute; margin-left: 6px;" onclick="changeCode();">
		  			</td>
		  			<td id="validateErr" class="errInfos" ></td>
		  		</tr>
		  		<tr height="20px"></tr>
		  		<tr>
		  			<td colspan="3" align="center">
		  				<input type="button" value="重置密码" class="button" onclick="modifyPwd();"/>
		  				&nbsp;&nbsp;&nbsp;&nbsp;
		  				&nbsp;&nbsp;&nbsp;&nbsp;
		  				&nbsp;&nbsp;
		  				<input type="button" value="清空输入" class="button" onclick="clearInput();"/>
		  			</td>
		  		</tr>
		  	</table>
  		</form>
  	</div>
  </body>
</html>
