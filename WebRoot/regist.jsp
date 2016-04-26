<%@ page language="java" import="java.util.*" pageEncoding="UTF-8" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <title>注册</title>
    <meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">
    <link type="text/css" rel="stylesheet" href="./css/mystyle.css" >
    <script type="text/javascript" src="./js/AjaxRequest.js" ></script>
    <style type="text/css">
    	*{
    		font-family: "Arial","Microsoft YaHei","黑体","宋体",sans-serif;
    		font-size: 15pt;
    	}
    	
    	body{
    		background-color: #EEF3F9;
			margin-top: 12px;
			margin-left: 12%;
    	}
    	
    	td input{
    		width: 250px;
    	}
    	
    	.tipSpan{
    		font-size: 16;
    		font-family: "隶书";
    		font-style: italic;
    	}
    	
    	.errorSpan1{
    		position: absolute;
    		width: 300px;
    		color: red;
    		margin-left: 28px;
    		font-size: 16;
    		font-family: "隶书";
    		font-style: italic;
    	}
    	
    	.errorSpan2{
    		position: absolute;
    		width: 240px;
    		
    		font-size: 16;
    		font-family: "隶书";
    		font-style: italic;
    	}
    	
    	.mustFillTag{
    		color: red;
    	}
    	
    	#otherQuestion{
    		size: 25;
    	}
    	
    </style>
    
    <script type="text/javascript">
    	var cardIdCheck = false;
    	var usernameCheck = false;
    	var validateCheck = false;
    	
    	/* 定义UID 用户名 密码检查正则规则 */
    	var regs = [ new RegExp("^[a-z0-9]{8,14}$", ""),
    				 new RegExp("^\[a-zA-Z0-9_]{8,14}$", ""), // 数字 字母 下划线
    				 new RegExp("^[a-z0-9]{5,14}$", "")];
    				 
    	var emptyErrInfos = ["卡号不能为空", "用户名不能为空", "请选择性别", "密码不能为空"];
    				 
    	var regErrInfos = ["卡号为8-14位的字母或数字", "用户名为8-14位的字母、数字或下划线",
    					   "密码为5-14位的字母或数字", "前后密码不一致"];
    	var ajaxErrInfos = ["卡号不存在", "用户已存在,请返回登陆", "用户名已存在", "验证码错误"]; 
    			
    	window.onload = function(){
    		document.getElementsByName("cardId")[0].focus();
    	}
    	
    	/* 进行注册表单提交 */
    	function regist(){
    		/* 1.首先,必须同意相关条款 */
    		if(!(document.getElementsByName("rules")[0].checked)){
    			alert("请同意相关服务条款和隐私政策!");
    			return;
    		}
    		for(var i=1; i<=7; i++){
    			document.getElementById("span"+i).innerHTML = "";
    		}
    		/* 2.必填项检测 */
    			/* 2.1必填项是否未填检测 */
    		if("" == document.getElementsByName("cardId")[0].value){
    			document.getElementsByName("cardId")[0].focus();
    			document.getElementById("span1").innerHTML = emptyErrInfos[0];
    			return;
    		}
    		if("" == document.getElementsByName("username")[0].value){
    			document.getElementsByName("username")[0].focus();
    			document.getElementById("span2").innerHTML = emptyErrInfos[1];
    			return;
    		}
    		if(!document.getElementsByName("sex")[0].checked 
    			&& !document.getElementsByName("sex")[1].checked ){
    			document.getElementById("span3").innerHTML = emptyErrInfos[2];
    			return;
    		}
    		if("" == document.getElementsByName("password")[0].value){
    			document.getElementsByName("password")[0].focus();
    			document.getElementById("span4").innerHTML = emptyErrInfos[3];
    			return;
    		}
    			/* 2.2卡号 用户名 密码合法性正则检测 */
    		if(!regs[0].test(document.getElementsByName("cardId")[0].value)){
    			document.getElementsByName("cardId")[0].focus();
    			document.getElementById("span1").innerHTML = regErrInfos[0];
    			return;
    		}
    		if(!regs[1].test(document.getElementsByName("username")[0].value)){
    			document.getElementsByName("username")[0].focus();
    			document.getElementById("span2").innerHTML = regErrInfos[1];
    			return;
    		}
    		if(!regs[2].test(document.getElementsByName("password")[0].value)){
    			document.getElementsByName("password")[0].focus();
    			document.getElementById("span4").innerHTML = regErrInfos[2];
    			return;
    		}
    			/* 2.3卡号是否存在且是否唯一 前后密码是否一致 */
    		if(document.getElementsByName("password")[0].value
    			!= document.getElementsByName("repassword")[0].value){
    			document.getElementsByName("password")[0].value = "";
    			document.getElementsByName("repassword")[0].value = "";
    			document.getElementsByName("password")[0].focus();
    			document.getElementById("span4").innerHTML = regErrInfos[3];
    			return;
    		}
    		//checkCardID();
    		
    			/* 2.4验证码是否正确检测 */
			checkValidate();
			
    		if(validateCheck && cardIdCheck){
    			document.getElementById("form").submit();
    		}
    	}
    	
    	/* 更新验证码 */
    	function changeCode(){
    		//为了使每次生成图片不一致，即不让浏览器读缓存，所以需要加上时间戳
    		var timestamp = (new Date()).valueOf();
    		document.getElementById("validateCode").src = 
    			"./generateCode.do?timestamp="+timestamp;
    	}
    	
    	function checkCardID(){
    		cardIdCheck = false;
    		
    		var cardId = document.getElementsByName("cardId")[0].value;
			var errspan = document.getElementById("span1");
			if(""==cardId){
				errspan.innerHTML = emptyErrInfos[0];
				document.getElementsByName("cardId")[0].focus();
				return;
			}
			
			if(!regs[0].test(document.getElementsByName("cardId")[0].value)){
    			document.getElementsByName("cardId")[0].focus();
    			document.getElementById("span1").innerHTML = regErrInfos[0];
    			return;
    		}
			
			var params = "processType=checkCardID"
						+"&cardId="+cardId;
			var loader = 
   				new netAjax.AjaxRequest("regist.do?nocache="+new Date().getTime(),
				function(){
					var result = this.req.responseText;
					if("ok" == result){
						document.getElementById("span1").innerHTML
    						= "<img src='./images/login/ok.jpg' width='18px'/>";
    					//document.getElementsByName("username")[0].focus();
    					cardIdCheck = true;
					}
					else if("notAllow" == result){
				   		document.getElementById("span1").innerHTML
				   			= "<img src='./images/login/error.jpg' width='18px'/>"+ajaxErrInfos[1];
					}
					else if("notExist" == result){
						document.getElementById("span1").innerHTML
				   			= "<img src='./images/login/error.jpg' width='18px'/>"+ajaxErrInfos[0];
				   		document.getElementsByName("cardId")[0].focus();
					}
				}, null, "POST", params);	
    	}
    	
    	function checkUsername($obj){
    		if("" == $obj.value){
    			//document.getElementsByName("username")[0].focus();
    			document.getElementById("span2").innerHTML = emptyErrInfos[1];
    			return;
    		}
    		if(regs[1].test($obj.value)){
    			document.getElementById("span2").innerHTML
    						= "<img src='./images/login/ok.jpg' width='18px'/>";
    		}
    		else{
    			document.getElementsByName("username")[0].focus();
    			document.getElementById("span2").innerHTML = regErrInfos[1];
    		}
    	}
    	
    	function checkPassword($obj){
    		if("" == $obj.value){
    			document.getElementsByName("password")[0].focus();
    			document.getElementById("span4").innerHTML = emptyErrInfos[3];
    			return;
    		}
    		if(regs[2].test($obj.value)){
    			document.getElementById("span4").innerHTML
    						= "<img src='./images/login/ok.jpg' width='18px'/>";
    		}
    		else{
    			document.getElementsByName("password")[0].focus();
    			document.getElementById("span4").innerHTML = regErrInfos[1];
    		}
    	}
    	
    	function checkRepassword($obj){
    		if(document.getElementsByName("password")[0].value == $obj.value){
    			document.getElementById("span5").innerHTML
    						= "<img src='./images/login/ok.jpg' width='18px'/>";
    		}
    		else{
    			document.getElementById("span5").innerHTML = regErrInfos[3];
    		}
    	}
    	
    	/* 检查验证码是否输入正确 */
    	function checkValidate(){
    		var code = document.getElementById("inputValidate").value;
			var errspan = document.getElementById("validateErr");
			errspan.style.color = "red";
			if(""==code){
				errspan.innerHTML = "<img src='./images/login/error.jpg' width='18px'/>"+"请输入验证码";
				document.getElementById("inputValidate").focus();
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
				   			= "<img src='./images/login/error.jpg' width='18px'/>"+"验证码错误,请重新输入";
				   		document.getElementById("inputValidate").focus();
					}
				}, null, "POST", params);	
    	}
    	
    	function questionSet($obj){
    		document.getElementById("otherQuestion").style.display = "none";
    		if("other" == $obj.value){
    			document.getElementById("otherQuestion").style.display = "block";
    		}
    	}
    </script>
    <%
    	String username = "";
    	String cardId = "";
    	String step = (String)request.getParameter("step");
    	if(step == null || step.isEmpty()){
    		step = "step" + 1;
    	}
    	else{
    		step = "step" + step;
    	}
    	
    	if("step2".equals(step)){
    		username = (String)request.getAttribute("username");
    		cardId = (String)request.getAttribute("cardId");
    	}
    %>
  </head>
  <body>
  	<div class="regTopper">
  		<img alt="新用户注册" src="./images/register/regTop.jpg">
  		<img alt="返回登陆" src="./images/register/return.png" 
  			height="30px" onclick="location.href = './login.jsp';" style="cursor: pointer;">
  	</div>
  	<% if("step1".equals(step)){ %>
  		<!-- Step 1: fill information  -->
  		<img alt="填写资料" src="./images/register/reg_step1.jpg">
  		<span class="tipSpan"><sup class="mustFillTag">*</sup>为必填项</span>
  		<form id="form" action="./regist.do" method="post">
	  		<table style="margin-left: 10%">
	  			<tr>
	  				<td><sup class="mustFillTag">*</sup>卡号：</td>
	  				<td>
	  					<input type="text" name="cardId" autocomplete="off" onblur="checkCardID(this);"/>
	  					<span id="span1" class="errorSpan1"></span>
	  				</td>
	  			</tr>
	  			<tr>
	  				<td><sup class="mustFillTag">*</sup>用户名：</td>
	  				<td>
	  					<input type="text" name="username" autocomplete="off" onblur="checkUsername(this);"/>
	  					<span id="span2" class="errorSpan1"></span>
	  				</td>
	  			</tr>
	  			<tr>
	  				<td><sup class="mustFillTag">*</sup>性别：</td>
	  				<td >
	  					<input type="radio" name="sex" value="male" style="width: 20px"/>男
	  					&nbsp;&nbsp;&nbsp;&nbsp;
	  					<input type="radio" name="sex" value="female" style="width: 20px"/>女
	  					<span id="span3" class="errorSpan1" style="margin-left: 150px;"></span>
	  				</td>
	  			</tr>
	  			<tr>
	  				<td>邮箱：</td>
	  				<td>
	  					<input type="text" name="email"/>
	  					<span id="span3" class="errorSpan1"></span>
	  				</td>
	  			</tr>
	  			<tr>
	  				<td><sup class="mustFillTag">*</sup>密码：</td>
	  				<td>
	  					<input type="password" name="password" autocomplete="off" onblur="checkPassword(this);"/>
	  					<span id="span4" class="errorSpan1"></span>
	  				</td>
	  			</tr>
	  			<tr>
	  				<td><sup class="mustFillTag">*</sup>确认密码：</td>
	  				<td>
	  					<input type="password" name="repassword" autocomplete="off" onblur="checkRepassword(this);"/>
	  					<span id="span5" class="errorSpan1"></span>
	  				</td>
	  			</tr>
	  			<tr>
	  				<td>密码提醒问题：</td>
	  				<td>
	  					<div style="white-space: nowrap; width: 500px;" >
		  					<select name="question" onclick="questionSet(this);">
		                        <option value="1">你的大学是?</option>
		                        <option value="2">你的家乡在?</option>
		                        <option value="3">你的女朋友是?</option>
		                        <option value="4">你的女朋友家乡在?</option>
		                        <option value="5">你最喜欢的歌手?</option>
		                        <option value="other">其他</option>
		                    </select>
		                    <div style="display: none;" id="otherQuestion">
		                    	<input type="text" name="otherQuestion"/>
		                    	<span style="font-size: 8; font-style: italic; color: #F4606C;">请输入问题</span>
		                    </div>
		                    
	  					</div>
	  					<span id="span6" class="errorSpan1"></span>
	  				</td>
	  			</tr>
	  			<tr>
	  				<td>答案：</td>
	  				<td>
	  					<input type="text" name="CardId"/>
	  					<span id="span7" class="errorSpan1"></span>
	  				</td>
	  			</tr>
	  			<tr>
	  				<td>上传用户个人图片：</td>
	  				<td>
	  					<input type="file" name="personImg" />
	  				</td>
	  			</tr>
	  			<tr>
	  				<td><sup class="mustFillTag">*</sup>验证码：</td>
	  				<td>
	  					<input type="text" id="inputValidate" name="validateCode" style="margin-top: 18px; position: absolute;" onblur="checkValidate();" />
	  					<div style="width: 180px; height: 45px; margin-left: 280px;" >
		  					<img id="validateCode" alt="验证码" src="./generateCode.do" height="40px" style="cursor: pointer; position: absolute;" onclick="changeCode();">
		  					<span style="font-size: 8; font-style: italic; color: #F4606C; position: absolute; margin-top: 40px; cursor: pointer;" onclick="changeCode();">点击更换验证码</span>
	  					</div>
	  					<span id="validateErr" class="errorSpan2"></span>
	  				</td>
	  			</tr>
	  			<tr><td colspan="2" height="20px">&nbsp;</td></tr>
	  			<tr>
	  				<td colspan="2">
	  					<input id="rules" type="checkbox" name="rules" style="width: 28px">我已经阅读并同意
	  					<a href="./about.jsp" >相关服务条款</a>和
	               		<a href="./privace.jsp" >隐私政策</a>
	  				</td>
	  			</tr>
	  			<tr><td colspan="2" height="24px">&nbsp;</td></tr>
	  			<tr>
	  				<td colspan="2" align="center">
	  					<img alt="regist" src="./images/register/registNew.jpg" onclick="regist();">
	  				</td>
	  			</tr>
	  		</table>
  		</form>
  	<% }else { %>
  		<!-- Step 2: register succeeded  -->
  		<img alt="完成注册" src="./images/register/reg_step2.jpg">
  		<script type="text/javascript">alert("注册成功")</script>
  		<p style="margin-left: 10%">系统正在为您跳转，请稍候...</p>
  		
  		<!-- 延时跳转 -->
  		<script type="text/javascript">
  			setTimeout(function(){
  				location.href = "main.jsp?cardId=<%= cardId %>&username=<%= username %>";
  			}, 1500);
		</script>
  	<% } %>
  </body>
</html>
