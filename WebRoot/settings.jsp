<%@ page language="java" import="java.util.*" pageEncoding="UTF-8" %>
<%@page import="system.database.RFIDCardDBHelper"%>
<%@page import="system.entity.RFIDCard"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <title>设置中心</title>
    <meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">
	<link type="text/css" rel="stylesheet" href="./css/mystyle.css" >
	<script type="text/javascript" src="./js/AjaxRequest.js"></script>
    <style type="text/css">
    	*{
    		font-family: "Arial","Microsoft YaHei","黑体","宋体",sans-serif;
    		font-size: 18pt;
    	}
    	
    	.menu {
    		position: absolute;
    		width: 100px;
    		border: 0;
    		font-size: 14pt;
    		font-style: normal; 
			background: #BEE7E9; 
			color: #AAD83E;
    	}
    	
    	#settings_menu{
    		width: 180px;
    	}
    	
    	#settings_content{
    		padding-left: 120px;
    	}
    	.setting_div{
    		display: none;
    	}
    	.setting_field{
    		width: 420px;
    		height: 180px;	
    		border-top: #aad83e 1px solid; 
			border-right: #aad83e 1px solid; 
			border-bottom: #aad83e 1px solid;
			border-left: #aad83e 1px solid;
			padding: 12px;
    	}
    	.errSetting{
    		position: absolute;
    		width: 240px;
    		color: red;
    		font: lighter;
    		font-size: 10pt;
    	}
    </style>
    <% 
    	String cardId = request.getParameter("cardId");
    %>
    <script type="text/javascript">
    	var regs = [new RegExp("^[a-z0-9]{5,14}$", ""),
    				new RegExp("^[a-z0-9]{5,14}[@]$", "")];
    	var emptyErrs = ["密码不能为空", "邮箱不能为空"];
    	var regErrs = ["密码为5-14位的字母或数字",
    					"格式错误,邮箱示例: 1109197209@qq.com或chenshj35@163.com"];
    	
    	function update($id){
    		document.getElementById("updateName").style.display = "none";
    		document.getElementById("updatePWD").style.display = "none";
    		document.getElementById("updateEmail").style.display = "none";
    		
    		document.getElementById($id).style.display = "block";
    	}
    	
    	function checkPassword($obj){
    		
    	}
    	
    	function checkEmail(){
    		var email = document.getElementById("email").value;
    		var errSpan = document.getElementById("errEmail");
    		errSpan.innerHTML = "";
    		alert(email);
    		if("" == email){
    			errSpan.innerHTML = emptyErrs[1];
    		}
    		if(regs[0].test(email)){
    			var params = "mainType=modifyEmail"
						+"&cardId=<%= cardId %>"
						+"&email="+email;
						
			var loader = 
   				new netAjax.AjaxRequest("main.do?nocache="+new Date().getTime(),
				function(){
					var result = this.req.responseText;
					if("Success" == result){
						//alert("邮箱修改成功");
						window.document.reload(); 
					}
					else{
						alert("邮箱修改失败,请确认后再修改");
					}
				}, null, "POST", params);
    		}
    		else{
    			errSpan.innerHTML = regErrs[1];
    		}
    		
    	}
    </script>
  </head>
  <body bgcolor="#BEE7E9" >
  	<div id="settings_menu">
  		<ul>
  			<li><a class="menu" onclick="update('updatePWD')">修改密码</a></li>
  			<li><a class="menu" onclick="update('updateEmail')">修改邮箱</a></li>
  		</ul>
  	</div>
  	
  	<div id="settings_content">
  		<%
  			if(null != cardId){
  				RFIDCardDBHelper helper = new RFIDCardDBHelper();
  				RFIDCard card = helper.SearchRFIDCardByCardId(cardId);
  				String username = card.getUser().getUsername();
  				String email = card.getUser().getEmail();
  		%>
		  	<div id="updateName" class="setting_div">
		  		<fieldset class="setting_field">
		  			<legend>修改用户名</legend>
			  		<table style="margin-left: 48px; margin-top: 16px;">
			  			<tr height="60px">
			  				<td>用户名: </td>
			  				<td>
			  					<input id="username" type="text" class="setInput" 
			  						value="<%= username %>" size="8" style="height: 28px"/>
			  				</td>
			  			</tr>
			  			<tr>
			  				<td><span class="errSetting" id="errUsername"></span></td>
			  			</tr>
			  		</table>
  					<input type="button" value="确认修改" class="button" onclick="checkUsername();"
  							style="font-size: 12pt; margin-top: 24px; float: right;"/>
		  		</fieldset>
		  	</div>
		  	<div id="updatePWD" >
		  		<fieldset class="setting_field">
		  			<legend>修改密码</legend>
			  		<table style="margin-left: 16px; margin-top: 2px;">
			  			<tr height="24px">
			  				<td>当前密码: </td>
			  				<td>
			  					<input id="curpswd" type="password" class="setInput" 
			  						value="" size="8" style="height: 25px"/>
			  					<span class="errSetting" id="errCurpswd"></span>
			  				</td>
			  			</tr>
			  			<tr height="24px" style="margin-top: 20px">
			  				<td>修改密码: </td>
			  				<td>
			  					<input id="pswd" type="password" class="setInput" 
			  						value="" size="8" style="height: 25px"/>
			  					<span class="errSetting" id="errPswd"></span>
			  				</td>
			  			</tr>
			  		</table>
  					<input type="button" value="确认修改" class="button" 
  							style="font-size: 12pt; margin-top: 24px; float: right;"/>
		  		</fieldset>
		  	</div>
		  	<div id="updateEmail" class="setting_div">
		  		<fieldset class="setting_field">
		  			<legend>修改邮箱</legend>
			  		<table style="margin-left: 48px; margin-top: 16px;">
			  			<tr height="60px">
			  				<td>E-mail: </td>
			  				<td>
			  					<input id="email" type="text" class="setInput" 
			  						value="" size="18" style="height: 25px; font-size: 12pt;"/>
			  				</td>
			  			</tr>
			  			<tr>
			  				<td><span class="errSetting" id="errEmail"></span></td>
			  			</tr>
			  		</table>
  					<input type="button" value="确认修改" class="button" onclick="checkEmail();" 
  							style="font-size: 12pt; margin-top: 24px; float: right;"/>
		  		</fieldset>
		  	</div>
	  	<%
	  		} 
	  	%>
  	</div>
  </body>
</html>
