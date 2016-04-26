<%@page language="java" import="java.util.*" pageEncoding="UTF-8" %>
<%@page import="javax.management.modelmbean.RequiredModelMBean" %>
<%@page import="system.database.RFIDCardDBHelper" %>
<%@page import="system.entity.RFIDCard" %>
<%@page import="system.database.PunchtimeDBHelper"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <title>考勤系统</title>
    <meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">
    <link type="text/css" rel="stylesheet" href="./css/mystyle.css" >
    <script type="text/javascript" src="./js/AjaxRequest.js"></script>
    <style type="text/css">
    	*{
    		font-family: "Microsoft YaHei","黑体","宋体",sans-serif;
    		font-size: 18pt;
    	}
    	#header{
    		border: 2px grey thick;
    		height: 98px;
    		background-image: url("./images/main/main_top.jpg");
    	}
    	#menu{
    		position: absolute;
    		border: 1px;
    		width: 180px;
    		margin-top: 64px;
    	}
    	#content{
    		position: absolute;
    		border: 1px;
    		margin-top: 60px;
    		margin-left: 210px;
    	}
    	
    	#content div {
    		margin: 35px;
    	}
    	td {
			text-align: center;
		}
		.welcome_name{
			background: #222 repeat-x;
			display: inline-block;
			padding: 5px 5px 5px;
			margin-right: 8px;
			color: #F4606C;
			-moz-border-radius: 6px;
			-webkit-border-radius: 6px;
			-moz-box-shadow: 0 1px 3px rgba(0,0,0,0.6);
			-webkit-box-shadow: 0 1px 3px rgba(0,0,0,0.6);
			text-shadow: 0 -1px 1px rgba(0,0,0,0.25);
			text-decoration: none;
			text-align: center;
			font-size: 22;
			border-bottom: 1px solid rgba(0,0,0,0.25);
			position: relative;
		}
		.headerImg{
			background: #BEE7E9 repeat-x;
			display: inline-block;
			padding: 2px 4px 2px;
			margin: 0;
			-moz-border-radius: 6px;
			-webkit-border-radius: 6px;
			-moz-box-shadow: 0 1px 3px rgba(0,0,0,0.6);
			-webkit-box-shadow: 0 1px 3px rgba(0,0,0,0.6);
			border-bottom: 1px solid rgba(0,0,0,0.25);
			position: relative;
			height: 22px;
		}
		.menuBar{
			cursor: pointer;
		}
		
		.nav {
			padding: 3px;
			margin: 3px; 
			text-align: center;
			border-right: #2c2c2c 1px solid; 
			padding-right: 5px; 
			border-top: #2c2c2c 1px solid; 
			padding-left: 5px; 
			background: #2c2c2c; 
			padding-bottom: 2px; 
			border-left: #2c2c2c 1px solid; 
			color: #fff; 
			margin-right: 2px; 
			padding-top: 2px; 
			border-bottom: #2c2c2c 1px solid; 
			text-decoration: none;
		}
		
		.nav:HOVER{
			border-right: #aad83e 1px solid; 
			border-top: #aad83e 1px solid; 
			background: #aad83e; 
			border-left: #aad83e 1px solid; 
			color: #fff; 
			border-bottom: #aad83e 1px solid;
		}
		
		.nav_active{
			padding: 3px;
			margin: 3px; 
			text-align: center;
			border-right: #aad83e 1px solid; 
			padding-right: 5px; 
			border-top: #aad83e 1px solid; 
			padding-left: 5px; 
			background: #aad83e; 
			padding-bottom: 2px; 
			border-left: #aad83e 1px solid; 
			color: #fff; 
			margin-right: 2px; 
			padding-top: 2px; 
			border-bottom: #aad83e 1px solid;
			text-decoration: none;
		}
    </style>
    <script type="text/javascript">
    	var Num = 5;
    	var LogoutIndex = 4;
    	var TimeIndex = 2;
    	var emptyStr = "用户暂无打卡记录...";
    		//"<p align=\"center\" style=\"margin: 0; padding: 0\">用户暂无打卡记录...</p>";
    	var tbHead = ""
    	
    	function menuSelect($obj){
    		var lists = document.getElementsByTagName("li");
    		var current;
    		for(var i=0; i<lists.length; ++i){
    			if(lists[i] == $obj)
    				current = i;
    			lists[i].style.color = "black";
    		}
    		$obj.style.color = "blue";
    		
    		/* 将当前选中模块设置为blcok,其他为none */
    		for(var i=0; i<Num; i++){
    			if(i == current){
    				document.getElementById("block"+current).style.display = "block";
    			}
    			else{
    				document.getElementById("block"+i).style.display = "none";
    			}
    		}
    		/* 注销重定向 */
    		if(current == LogoutIndex){
    			setTimeout(function(){
    				location.href = "./login.jsp";
    			}, 1500);
    		}
    		else if(current == TimeIndex){
    			//alert("getPunchTime(1)");
    			getPunchTime(1);
    		}
    	}
    	
    	function getPunchTime($pageNum){
    		var cardId = document.getElementById("btncardId").value;
    		var params = "mainType=punchTime"
    					+"&cardId="+cardId
						+"&pageNum="+$pageNum;
						
			var loader = 
   				new netAjax.AjaxRequest("main.do?nocache="+new Date().getTime(),
				function(){
					var count = 
						parseInt(this.req.responseXML.getElementsByTagName("Count")[0].firstChild.data);
					//alert("count="+count);
					// 获取节点并清空内容
					var empty_p = document.getElementById("punchTime_empty");
					empty_p.innerHTML = "";
					
					var tb = document.getElementById("punchTime_tb");
					tb.innerHTML = "";
					
					var nav = document.getElementById("punchTime_nav");
					nav.innerHTML = "";
					
					// 对返回结果做处理
					// 1.当前用户打卡记录为空
					if(0 == count){
						tb.border = "0px";
						document.getElementById("punchTime_empty").innerHTML = emptyStr;
					}
					// 2.当前用户打卡记录不为空
					else{
						var pageSize = 
							parseInt(this.req.responseXML.getElementsByTagName("Size")[0].firstChild.data);
						//alert("pageSize="+pageSize);
						var pageNum = 
							parseInt(this.req.responseXML.getElementsByTagName("pageNum")[0].firstChild.data);
						//alert("pageNum="+pageNum);
						// 显示数据
						tb.border = "2px";
						var records = 
							this.req.responseXML.getElementsByTagName("record");
						for(var i=0; i<records.length; i++){
							 var tb_tr = document.createElement("tr");
							 var tb_td = document.createElement("td");
                             tb_td.appendChild(
                             	document.createTextNode(records[i].firstChild.data));
                             tb_tr.appendChild(tb_td);
                             tb.appendChild(tb_tr);
						}
						// 显示导航条
						var navStr = "";
						var pageCount = Math.floor((count+pageSize-1)/pageSize);
						//alert("pageCount="+pageCount);
						// 一次最多显示9条导航
						var first = pageNum - 4;
						if(first <= 1){
							first = 1;
						}
						else{
							navStr += "<a href=\"#\" class=\"nav\" onclick=\"getPunchTime("
										+ 1
										+")\">FIRST</a>";
							navStr += "<a href=\"#\" class=\"nav\" onclick=\"getPunchTime("
										+ (pageNum-1)
										+")\">&lt;&lt;</a>";
						}
						var flag = true;
						var last = pageNum + 4;
						if(last >= pageCount){
							last = pageCount;
							flag = false;
						}
						for(; first <=last; first++){
							if(first == pageNum){
								navStr += "<a href=\"#\" class=\"nav_active\">"
										   + pageNum	
										   + "</a>";
							}
							else{
								navStr += "<a href=\"#\" class=\"nav\" onclick=\"getPunchTime("
											+ first
											+")\">"+first+"</a>";
							}
						}
						
						if(flag){
							navStr += "<a href=\"#\" class=\"nav\" onclick=\"getPunchTime("
										+ (pageNum+1)
										+ ")\">&gt;&gt;</a>";
							navStr += "<a href=\"#\" class=\"nav\" onclick=\"getPunchTime("
										+ pageCount
										+ ")\">LAST</a>";
						}
						nav.innerHTML = navStr;
					}
				}, null, "POST", params);
    	}
    	
    </script>
    <%
    	String username = request.getParameter("username");
    	username = " "+username+" ";
    	String cardId = request.getParameter("cardId");
    	//System.out.println(cardId);
    	RFIDCardDBHelper helper = new RFIDCardDBHelper();
    %>
  </head>
  <body bgcolor="#BEE7E9">
  	<div id="header">
  		<center style="padding-top: 24px; font-size: 28pt; font-weight: bold; color: #19CAAD"> 
  			欢迎来到考勤系统 
  		</center>
  	</div>
  	<span style="float: right; background-color: #BEE7E9; margin: 8px">
	  		<img alt="头像" src="./images/main/header_male.png" class="headerImg"/>
	  		<span style="font-size: 25; color: #F4606C;"><%= username %></span>
  	</span>
  	<div id="menu">
  		<ul id="menu_info">
  			<li class="menuBar" onclick="menuSelect(this);">个人信息</li>
  			<li class="menuBar" onclick="menuSelect(this);">所有用户</li>
  			<li class="menuBar" onclick="menuSelect(this);">刷卡记录</li>
  			<li class="menuBar" onclick="menuSelect(this);">设置</li>
  			<li class="menuBar" onclick="menuSelect(this);">注销</li>
  		</ul>
  	</div>
  	<div id="content">
  		<!-- 1.用户个人信息查看 -->
  		<div id="block0" style="display: none; margin: 48px;">
  			<%
  				RFIDCard personalInfo = helper.SearchRFIDCardByCardId(cardId);
  			%>
  			<table border="2px" cellspacing="0" width="720px" align="center">
  				<tr>
  					<td colspan="2">
  						<span class="welcome_name"><%= username %></span>个人信息
  					</td>
  				</tr>
  				<% if(null == personalInfo){ %>
  					<tr>
	  					<td colspan="2">抱歉, 暂无用户信息...</td>
	  				</tr>
  				<% }else{ %>
	  				<tr>
	  					<td>卡号</td>
	  					<td><%= personalInfo.getCardId() %></td>
	  				</tr>
	  				<tr>
	  					<td>卡类型</td>
	  					<td><%= personalInfo.getType() %></td>
	  				</tr>
	  				<tr>
	  					<td>用户名</td>
	  					<td><%= personalInfo.getUser().getUsername() %></td>
	  				</tr>
	  				<tr>
	  					<td>创建时间</td>
	  					<td><%= personalInfo.getCreateTime() %></td>
	  				</tr>
	  				<tr>
	  					<td>邮箱</td>
	  					<td><%= personalInfo.getUser().getEmail() %></td>
	  				</tr>
  				<% } %>
  			</table>
  		</div>
  		<!-- 2.管理员查看所有账户信息 -->
  		<div id="block1" style="display: none;">
  			<%
  				List<RFIDCard> allInfos = helper.getAllRFIDCards();
  			%>
  			<table border="2px" cellspacing="0" align="center">
  				<tr>
  					<td width="200px">卡号</td>
  					<td width="200px">卡类型</td>
  					<td width="200px">用户名</td>
  					<td width="250px">创建时间</td>
  					<td width="320px">邮箱</td>
  				</tr>
  				<% if(null == allInfos){ %>
  					<tr>
	  					<td colspan="5">抱歉, 暂无用户信息...</td>
	  				</tr>
  				<% } else{ 
  						for(RFIDCard info : allInfos) { %>
  					<tr>
	  					<td><%= info.getCardId() %></td>
	  					<td><%= info.getType() %></td>
	  					<td><%= info.getUser().getUsername() %></td>
	  					<td><%= info.getCreateTime() %></td>
	  					<td><%= info.getUser().getEmail() %></td>
  					</tr>
  				<% 		}
  					} 
  				%>
  			</table>
  		</div>
  		<!-- 3.查看用户打开时间记录 -->
  		<div id="block2" style="display: none;">
  			<input id="btncardId" type="hidden" value="<%= cardId %>" />
  			<p class="welcome_name">卡号: <span><%= cardId %></span></p>
  			<div id="div_punchTime" style="margin: 0; padding: 0">
	  			<!-- 通过JS动态显示 -->
	  			<p id="punchTime_empty" align="center" style="margin: 0; padding: 0"></p>
	  			<table id="punchTime_tb" border="0px" cellspacing="0" align="center" width="500px"></table>
	  			<center id="punchTime_nav" style="margin-top: 48px;"></center>
  			</div>
  		</div>
  		<!-- 4.设置界面 -->
  		<div id="block3" style="display: none;">
  			<jsp:include page="./settings.jsp" flush="false">
  				<jsp:param value="<%= cardId %>" name="cardId"/>
  			</jsp:include>
  		</div>
  		<!-- 5.注销 退回登录界面 -->
  		<div id="block4" style="display: none;">
  			正在退出....
  		</div>
  	</div>
  </body>
</html>
