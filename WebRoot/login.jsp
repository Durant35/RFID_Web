<%@ page language="java" import="java.util.*" pageEncoding="UTF-8" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <title>考勤系统登陆</title>
    <meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">
    <link type="text/css" rel="stylesheet" href="./css/mystyle.css" >
    <script type="text/javascript" src="./js/AjaxRequest.js"></script>
    <style type="text/css">
    	*{
    		font-family: "Arial","Microsoft YaHei","黑体","宋体",sans-serif;
    	}
    	
    	body {
    		background-image: url("./images/login/background.jpg");
    	}
    	
    	table{
    		height: 300px;
    		border: 0;
    		cellspacing: 0;
    		cellpadding: 8px;
    		background: url("./images/login/bg.jpg") repeat-x scroll center bottom #fff;
			display: inline-block;
			padding: 5px 10px 6px;
			-moz-border-radius: 6px;
			-webkit-border-radius: 6px;
			-moz-box-shadow: 0 1px 3px rgba(0,0,0,0.6);
			-webkit-box-shadow: 0 1px 3px rgba(0,0,0,0.6);
			border-bottom: 1px solid rgba(0,0,0,0.25);
			position: relative;
    	}
    	
    	.content{
    		margin-left: 24%;
    		margin-top: 12%;
    	}
    	
    	.tooltip{
    		font-size: 18pt;
    	}
    	
    	/* 错误提示信息span */
    	.errSpan{
    		position: absolute;
    		margin-left: 38px;
    		width: 280px;
    		font-family: "Microsoft YaHei";
    		font-size: 10pt;
    		font-weight: bolder;
    		color: #333333;
    		text-align: left;
    	}
    	
    	#input1, #input2, #input3{
    		size: 28;
    	}
    	/* 自定义按钮 */
    	.button, .button:visited {
			background: #72CA6D repeat-x;
			display: inline-block;
			padding: 0 0 2;
			color: green;
			-moz-border-radius: 6px;
			-webkit-border-radius: 6px;
			-moz-box-shadow: 0 1px 3px rgba(0,0,0,0.6);
			-webkit-box-shadow: 0 1px 3px rgba(0,0,0,0.6);
			position: relative;
			cursor: pointer;
			width: 88px; 
		}
    </style>
    
    <script type="text/javascript">
    	/* 定义UID 用户名 密码检查正则规则 */
    	var regs = [ new RegExp("^[a-z0-9]{8,14}$", ""),
    				 new RegExp("^\[a-zA-Z0-9_]{8,14}$", ""), // 数字 字母 下划线
    				 new RegExp("^[a-z0-9]{5,14}$", "")];
    	
    	var emptyErrInfos = ["请输入卡号", "请输入用户名", "请输入密码"];
    	var regErrInfos = ["卡号为8-14位的字母或数字", 
    			"用户名为8-14位的字母、数字或下划线", "密码为8-14位的字母或数字"];
    	var legalInfos = ["合法卡号","用户名正确","密码正确"];
    			
    	var isCheck = false;
    	
   		window.onload = function(){
   			document.getElementById("input1").focus();
   		};
    	
    	/* 注册图片点击跳转 */
    	function register(){
    		location.href = "./regist.jsp";
    	}
    	
    	/* 登陆按钮点击提交表单 */
    	function login(){
    		if(isCheck){
    			document.getElementById("form_login").submit();
    		}
    	}
    	
    	/* 重置按钮点击重置表单 */
    	function reset(){
    		document.getElementById("span1").innerHTML = emptyErrInfos[0];
    		document.getElementById("span2").innerHTML = emptyErrInfos[1];
    		document.getElementById("span3").innerHTML = emptyErrInfos[2];
    		document.getElementById("form_login").reset();
    		document.getElementById("input1").focus();
    	}
    	
    	/* 输入框划过检查 包括正则检查与Ajax检查 */
    	function check($index){
    		isCheck = false;
    		for(var i=1; i<=3; i++){
    			document.getElementById("span"+i).innerHTML = "";
    		}
    		for(var i=1; i<=3; i++){
    			//alert(i+"");
    			if(""==document.getElementById("input"+i).value){
    				document.getElementById("span"+i).innerHTML = emptyErrInfos[i-1];
    			}
    		}
    		/* 1.是否输入检查 */
    		for(var i=1; i<=$index; i++){
    			if(""==document.getElementById("input"+i).value){
    				document.getElementById("span"+i).innerHTML = 
							"<img src='./images/login/error.jpg' width='18px'/>"+emptyErrInfos[i-1];
					document.getElementById("input"+i).focus();
					return;
    			}
    		}
    		/* 2.输入正则检查 */
    		for(var i=1; i<=$index; i++){
    			if(!regs[i-1].test(document.getElementById("input"+i).value)){
    				document.getElementById("span"+i).innerHTML = 
							"<img src='./images/login/error.jpg' width='18px'/>"+regErrInfos[i-1];
					document.getElementById("input"+i).focus();
					return;
    			}
    		}
    		/* 3.输入合法性Ajax检查 */
    		var cardId, username, password;
			cardId = document.getElementById("input1").value;
			username = document.getElementById("input2").value;
			password = document.getElementById("input3").value;
			var params = "cardId="+cardId
						+"&username="+username
						+"&password="+password
						+"&login=false";
						
			var loader = 
   				new netAjax.AjaxRequest("login.do?nocache="+new Date().getTime(),
				function(i){
					var errCode = 
						this.req.responseXML.getElementsByTagName("code")[0].firstChild.data;
					var errDesc = 
						this.req.responseXML.getElementsByTagName("description")[0].firstChild.data;
				
					if(-1 == errCode){
						document.getElementById("span1").innerHTML = 
							"<img src='./images/login/error.jpg' width='18px'/>"+errDesc;
						document.getElementById("input1").focus();
					}
					else if(-2 == errCode){
						document.getElementById("span1").innerHTML = 
							"<img src='./images/login/ok.jpg' width='18px'/>"+legalInfos[0];
					 	document.getElementById("span2").innerHTML = 
							"<img src='./images/login/error.jpg' width='18px'/>"+errDesc;
						document.getElementById("input2").focus();
					}
					else if(-3 == errCode){
						document.getElementById("span1").innerHTML = 
							"<img src='./images/login/ok.jpg' width='18px'/>"+legalInfos[0];
					 	document.getElementById("span2").innerHTML = 
							"<img src='./images/login/ok.jpg' width='18px'/>"+legalInfos[1];
						document.getElementById("span3").innerHTML = 
							"<img src='./images/login/error.jpg' width='18px'/>"+errDesc;
						document.getElementById("input3").focus();
					}
					else if(0 == errCode){
						document.getElementById("span1").innerHTML = 
							"<img src='./images/login/ok.jpg' width='18px'/>"+legalInfos[0];
						document.getElementById("span2").innerHTML = 
							"<img src='./images/login/ok.jpg' width='18px'/>"+legalInfos[1];
						document.getElementById("span3").innerHTML = 
							"<img src='./images/login/ok.jpg' width='18px'/>"+legalInfos[2];
						isCheck = true;
					}
				}, null, "POST", params);
    	}
    </script>
  </head>
  <body bgcolor="#BEE7E9" >
  	<div class="content">
  		<form id="form_login" action="./login.do?login=true" method="post" autocomplete="off" >
	  		<table>
	  			<tr>
	  				<td colspan="3" >
	  					<center>
	  						<h1 style="font-size: 28pt; margin: 5px">考勤系统登陆</h1>
	  					</center>
	  				</td>
	  			</tr>
	  			<!-- 输入卡号 -->
	  			<tr>
	  				<td align="right" width="168px" class="tooltip">卡号:</td>
	  				<td rowspan="2" align="left" width="280px" style="padding-left: 12px;">
	  					<input id="input1" type="text" name="cardId" onblur="check(1);" autocomplete="off"/>
	  					<br/>
	  					<span id="span1" class="errSpan">请输入卡号</span>
	  				</td>
	  				<td align="left"; width="148px"></td>
	  			</tr>
	  			
	  			<tr> </tr>
	  			<!-- 输入用户名 -->
	  			<tr>
	  				<td align="right" class="tooltip">用户名:</td>
	  				<td rowspan="2" align="left" style="padding-left: 12px;">
	  					<input id="input2" type="text" name="username" onblur="check(2);" autocomplete="off"/>
	  					<br/>
	  					<span id="span2" class="errSpan">请输入用户名</span>
	  				</td>
	  				<td align="center">
	  					<img alt="注册会员" src="./images/login/regist.jpg" 
 									style="cursor: pointer;" width="72px"; onclick="register();" /> 
	  				</td>
	  			</tr>
	  			
	  			<tr ></tr>
	  			<!-- 输入密码 -->
	  			<tr>
	  				<td align="right" class="tooltip">密码:</td>
	  				<td rowspan="2" align="left" style="padding-left: 12px;"> 
	  					<input id="input3" type="password" name="password" onblur="check(3);" autocomplete="off"/>
	  					<br/>
	  					<span id="span3" class="errSpan">请输入密码</span>
	  				</td>
	  				<td align="center">
	  					<a href="./pwdforgetting.jsp" style="cursor: pointer;">忘记密码?</a>
	  				</td>
	  			</tr>
	  			
	  			<tr></tr>
	  			<!-- 登陆 重置按钮 -->
	  			<tr>
	  				<td colspan="3" align="center" style="padding-top: 12px;">
	  					<img alt="login" src="./images/login/login.png" 
	  										class="button" onclick="login();"/>
	  					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	  					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	  					<img alt="reset" src="./images/login/reset.png" width="88px"
						 					class="button" onclick="reset();"/>
	  				</td>
	  			</tr>
	  			<tr height="2px"></tr>
	  		</table>
  		</form>
  	</div>
  </body>
</html>
