<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%
    String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+request.getContextPath();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<meta name="viewport" content="width=device-width, minimum-scale=1.0, maximum-scale=2.0, initial-scale=1.0" />
	<meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate" />
	<meta http-equiv="Pragma" content="no-cache" />
    <title>Admin</title>
    <script type="text/javascript" src="<%=basePath %>/static/js/jquery-1.4.2.js"></script>
    <%-- <link rel="stylesheet" type="text/css" href="<%=basePath %>/static/css/chat.css" /> --%>
    <style type="text/css">
    	@font-face {
		    font-family: 'YingHei';
		    src: url('<%=basePath %>/static/css/font/MYingHeiPRC-W4.ttf') format('truetype'), /* chrome, firefox, opera, Safari, Android, iOS 4.2+*/  
		    font-weight: normal;
		    font-style: normal;
		}
    	
    	* {
    		margin: 0;
    		padding: 0;
    		font-family: YingHei;
    	}
    	
    	html, body {
    		width: 100%;
    		height: 100%;
    		background: #eee;
    	}
    	
    	.message-module-outer 
    	{
    		display: flex;
		  	flex-direction: column;
		  	align-items: center;
    	}
    </style>
</head>
<body>
    <div id="container" class="message-module-outer">
    	<form>
    		<input id="text" style="width: 200px; height: 30px" type="text" />
    		<input style="width: 50px; height: 30px" type="button" value="提交" onClick="send()"/>
    	</form>
        <div id="text"></div>
    </div>
</body>

<script type="text/javascript">  
    var basePath = '<%=basePath %>';  
	
	var websocket = null;
	
	//判断当前浏览器是否支持WebSocket
	if ('WebSocket' in window) {
	    websocket = new WebSocket("ws://localhost:8080/Websocket/websocket/0");
	}
	else {
	    alert('当前浏览器 Not support websocket')
	}
	
	//连接发生错误的回调方法
	websocket.onerror = function () {
	    setMessageInnerHTML("WebSocket连接发生错误");
	    setMessageInnerHTML2("WebSocket连接发生错误，请刷新页面");
	};
	
	
	//连接成功建立的回调方法
	websocket.onopen = function () {
	    setMessageInnerHTML("WebSocket连接成功");
	};
	
	
	//接收到消息的回调方法
	websocket.onmessage = function (event) {
		var message = JSON.parse(event.data);
	    
	};
	
	
	//连接关闭的回调方法
	websocket.onclose = function () {
	    setMessageInnerHTML("WebSocket连接关闭");
	    setMessageInnerHTML2("WebSocket连接关闭，请刷新页面");
	};
	
	
	//监听窗口关闭事件，当窗口关闭时，主动去关闭websocket连接，防止连接还没断开就关闭窗口，server端会抛异常。
	window.onbeforeunload = function () {
	    closeWebSocket();
	};
	
	
	//将消息显示在网页上
	function setMessageInnerHTML(sendMessage) {
	    document.getElementById('text').innerHTML += sendMessage + '<br/>';
	}
	
	function setMessageInnerHTML2(sendMessage) {
		$('#container').empty();
		$('#container').html(sendMessage);
		$('#container').css('color', 'red');
	}
	
	
	//关闭WebSocket连接
	function closeWebSocket() {
	    websocket.close();
	}
	
	function send(){
		console.log($('#text').val())
	    if ($('#text').val()) websocket.send($('#text').val());
	};
	
	
</script>
</html>
