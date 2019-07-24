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
    <title>User</title>
    <script type="text/javascript" src="<%=basePath %>/static/js/jquery-1.4.2.js"></script>
    <%-- <link rel="stylesheet" type="text/css" href="<%=basePath %>/static/css/chat.css" /> --%>
    <style type="text/css">
    	@font-face {
		    font-family: 'YingHei';
		    src: url('.../../static/css/font/MYingHeiPRC-W4.eot');
			src: url('../../static/css/font/MYingHeiPRC-W4.eot') format('embedded-opentype'),
			     url('../../static/css/font/MYingHeiPRC-W4.woff2') format('woff2'),
			     url('../../static/css/font/MYingHeiPRC-W4.woff') format('woff'),
			     url('../../static/css/font/MYingHeiPRC-W4.ttf') format('truetype'),
			     url('../../static/css/font/MYingHeiPRC-W4.svg') format('svg');
		    font-weight: normal;
		    font-style: normal;
		}
		
		@font-face {
		    font-family: 'YingHei';
		    src: url('.../../static/css/font/MYingHeiPRC-W5.eot');
			src: url('../../static/css/font/MYingHeiPRC-W5.eot') format('embedded-opentype'),
			     url('../../static/css/font/MYingHeiPRC-W5.woff2') format('woff2'),
			     url('../../static/css/font/MYingHeiPRC-W5.woff') format('woff'),
			     url('../../static/css/font/MYingHeiPRC-W5.ttf') format('truetype'),
			     url('../../static/css/font/MYingHeiPRC-W5.svg') format('svg');
		    font-weight: bold;
		}
    
    	* {
    		margin: 0;
    		padding: 0;
    		font-family: YingHei;
    	}
    	
    	html, body {
    		width: 100%;
    		height: 100%;
    		/* background: #eee; */
    	}
    	
    	.message-module-outer 
    	{
    		display: flex;
		  	flex-direction: column;
		  	align-items: center;
    	}
    	
    	.message-module-inner 
    	{
		  width: 90%;
		  height: auto;
		  background: #FFFFFF;
		  box-sizing: border-box;
		  border-radius: 12px;
		  display: flex;
		  flex-direction: column;
		  padding: 15px 14px;
		  overflow: hidden;
		  border: black 1px solid;
		  transform: rotate(180deg);
		}
		
		.message-content 
		{
		  width: 100%;
		  word-wrap: break-word;
		  font-weight: 400;
		  color: #333333;
		  margin-bottom: 4px;
		  white-space: pre-wrap;
		  font-size:34px;
		  line-height:44px;
		}
		
		.message-content p {
			margin-bottom: 16px;
		}
		
		.message-bar{
		  width: 100%; 
		  height: 24px;
		  display: flex;
		  flex-direction: row;
		  align-items: center;
		  justify-content: space-between;
		  margin-top: 10px;
		  font-size: 24px;
		}
		
		.message-info {
		  display: flex;
		  flex-direction: row;
		  align-items: center;
		  word-break: break-all;
		  height: 24px;
		  width: 60%;
		  align-items: center;
		  text-overflow: ellipsis;
		  overflow: visible;
		  white-space: nowrap;
		}
		
		.message-user-name {
		  font-weight: bold;
		  color: #242424;
		  text-overflow: ellipsis;
		  overflow: hidden;
		  white-space: nowrap;
		  margin-right: 7px;
		}
		
		.message-time {
		  /* height: 12px; */
		  color: #484848;
		  /* line-height: 12px; */
		  font-weight: 400;
		}
		
		.message-bar-option {
		  display: inline-flex;
		  justify-content: flex-end;
		  width: 40%;
		}
		
		.message-like-area,
		.message-comment-area {
		  height: 30px;
		  display: flex;
		  flex-direction: row;
		  align-items: center;
		  justify-content: flex-end;
		  box-sizing: border-box;
		}
		
		.message-like-area {
		  /* width: 55%; */
		  padding-right: 15px;
		  box-sizing: border-box;
		  position: relative;
		}
		
		.message-comment-area {
		  width: 33%;
		  overflow: visible;
		}
		
		.message-like-area::before {
		  content: '';
		  position: absolute;
		  top: -5px;
		  right: -5px;
		  bottom: -5px;
		  left: -5px;
		}
		
		.message-option-num {
		  display: flex;
		  align-items: center;
		  height: 30px;
		  margin-right: 4px;
		  color: #484848;
		}
		
		.message-option-icon {
		  width: 20px;
		  height: 30px;
		  overflow: visible;
		  display: flex;
		  align-items: center;
		  justify-content: center;
		}
		
		.message-option-icon img {
		  width: 24px;
		  height: 24px;
		  z-index: 999;
		}
    </style>
</head>
<body>
    <div id="container" class="message-module-outer">
    	<div class="message-module-inner" style="margin-top:20px">
	        <div id="content" class="message-content"></div>
	        <div class="message-bar">
	            <div class="message-info">
	                <span id="gender" class="message-user-name">某同学</span>
	                <span id="time" class="message-time">20分钟前</span>
	            </div>
	            <div class="message-bar-option">
	                <div class="message-like-area">
	                    <div id="like" class="message-option-num">56</div>
	                    <div class="message-option-icon">
	                        <img class="message-bar-icon" src="<%=basePath %>/static/image/xiai.svg"></img>
	                    </div>
	                </div>
	                <div class="message-comment-area">
	                    <div id="comment" class="message-option-num">12</div>
	                	<div class="message-option-icon">
	                        <img class="message-bar-icon" src="<%=basePath %>/static/image/pinglun.svg"></img>
	                    </div>
	                </div>
	            </div>
	        </div>
        </div>
        <div id="text"></div>
    </div>
</body>

<script type="text/javascript">  
    var basePath = '<%=basePath %>';  
	/* var btn = document.getElementById('btn');
	var text = document.getElementById('text');
	var content = document.getElementsByTagName('ul')[0];
	var img = content.getElementsByTagName('img');
	var span = content.getElementsByTagName('span'); */
	
	$('#content').html('<p>在西浦四年，收到过四五封邮件。</p><p>希望大家，每个人，慎重对待自己的生命，不要丧失希望。无论任何情况下，任何，总会，总会有办法的。</p><p>人生起起伏伏，有苦有甜，还没看完这个世界，别放弃。</p>');
	
	var websocket = null;
	
	//判断当前浏览器是否支持WebSocket
	if ('WebSocket' in window) {
	    websocket = new WebSocket("ws://112.74.38.183:8888/Websocket/websocket/1");
	}
	else {
	    alert('当前浏览器 Not support websocket')
	}
	
	//连接发生错误的回调方法
	websocket.onerror = function () {
	    // setMessageInnerHTML("WebSocket连接发生错误");
	    setMessageInnerHTML2("WebSocket连接发生错误，请刷新页面");
	};
	
	
	//连接成功建立的回调方法
	websocket.onopen = function () {
	    // setMessageInnerHTML("WebSocket连接成功");
	};
	
	
	//接收到消息的回调方法
	websocket.onmessage = function (event) {
		// setMessageInnerHTML("WebSocket接收信息"+event.data);
	    
		$.ajax({
			url:"https://api.xjtluwall.com/api/message/"+event.data,
            type:"get",
            contentType: "application/json",
            dataType:"json",
            success: ({ message }) => {
            	console.log(message);
            	let { content, createdAt, likeNum, commentNum, user } = message;
            	content = content.trim('\n')
            	content = '<p>'+content+'</p>'
            	$('#content').html(content.replace('\n','</p><p>'))
            	$('#gender').html('某'+(user.gender === 'male' ? '男' : '女')+'生')
            	$('#time').html(getTime(createdAt))
            	$('#like').html(likeNum)
            	$('#comment').html(commentNum)
				console.log(message);
            }
		});
	};
	
	
	//连接关闭的回调方法
	websocket.onclose = function () {
	    // setMessageInnerHTML("WebSocket连接关闭");
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
	
	const getTime = (time) => {
	  const timeNow = Date.parse(new Date())
	  const language = 'zh'
	  const langMap = {
	    day: { zh: '天前', en: ' days ago' },
	    hour: { zh: '小时', en: ' hrs ago' },
	    minute: { zh: '分钟', en: ' mins ago' },
	    second: { zh: '秒', en: ' secs ago' },
	    recent: { zh: '刚刚', en: 'just now' }
	  }
	  const current = Number(String(timeNow).substr(0, 10))
	  const timeDiff = current - Number(String(Date.parse(time)).substr(0, 10))
	  let timeMsg
	  if (timeDiff > 59) {
	    const minute = Math.floor(timeDiff / 60)
	    if (minute > 59) {
	      const hour = Math.floor(minute / 60)
	      if (hour > 23) {
	        const day = Math.floor(hour / 24)
	        timeMsg = day + langMap.day[language]
	      } else {
	        timeMsg = hour + langMap.hour[language]
	      }
	    } else {
	      timeMsg = minute + langMap.minute[language]
	    }
	  } else {
	    if (timeDiff <= 3) timeMsg = langMap.recent[language]
	    else timeMsg = timeDiff + langMap.second[language]
	  }
	  return timeMsg
	}
	
</script>
</html>
