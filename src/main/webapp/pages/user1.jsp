<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%
    String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+request.getContextPath();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<meta name="viewport" content="width=device-width, minimum-scale=1.0, maximum-scale=2.0" />
	<meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate" />
	<meta http-equiv="Pragma" content="no-cache" />
    <title>User 1</title>
    <script type="text/javascript" src="<%=basePath %>/static/js/jquery-1.4.2.js"></script>
    <link rel="stylesheet" type="text/css" href="<%=basePath %>/static/css/chat.css" />
</head>
<body>
<!-- <center>
    Welcome<br/>
    <form action="">
    	<input type="text" name="text"/>
    	<input type="button" value="Send" onclick="send()"/>
    </form>
    <button onclick="closeWebSocket()">关闭WebSocket连接</button>
    <hr/>
    <div id="message"></div>
</center> -->
    <div id="container" name="1">
        <!-- <div class="header">
            <span style="float: left;"></span>
            <span style="float: right;">14:21</span>
        </div> -->
        <ul class="content">

		</ul>
        <div class="footer">
            <!-- <div id="user_face_icon">
                <img src="https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1556053048360&di=f8d7f401d2fe68e38737e2bfec83a2b0&imgtype=0&src=http%3A%2F%2F5b0988e595225.cdn.sohucs.com%2Fq_70%2Cc_zoom%2Cw_640%2Fimages%2F20171018%2F2fc384b257b94755ad9cd14aacd4db18.jpeg" alt="">
            </div> -->
            <input id="text" type="text" placeholder="Type here" onkeydown="if(event.keyCode==13){$('#btn').click();return false}" value="">
            <input id="btn" type="submit" value="Send" onclick="send()"/>
            <!-- <span id="btn">Send</span> -->
        </div>
    </div>
</body>

<script>  
    var basePath = '<%=basePath %>';  
</script> 
<script type="text/javascript" src="<%=basePath %>/static/js/chat.js"></script>
<!-- <script type="text/javascript">
	var arrIcon = ['https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1556053048360&di=f8d7f401d2fe68e38737e2bfec83a2b0&imgtype=0&src=http%3A%2F%2F5b0988e595225.cdn.sohucs.com%2Fq_70%2Cc_zoom%2Cw_640%2Fimages%2F20171018%2F2fc384b257b94755ad9cd14aacd4db18.jpeg'];
	var num = 0;     //控制头像改变
	var iNow = -1;    //用来累加改变左右浮动
	var btn = document.getElementById('btn');
	var text = document.getElementById('text');
	var content = document.getElementsByTagName('ul')[0];
	var img = content.getElementsByTagName('img');
	var span = content.getElementsByTagName('span');
	var userNo = $("#container").attr('name');
	
	var myFont = '2';
	var myColor = '1';
	
	var otherFont = '2';
	var otherColor = '1';
	
	var websocket = null;
	
	//判断当前浏览器是否支持WebSocket
	if ('WebSocket' in window) {
	    websocket = new WebSocket("ws://localhost:8888/Websocket/websocket/"+userNo);
	    // websocket = new WebSocket("ws://172.20.10.4:8888/Websocket/websocket/"+userNo);
	}
	else {
	    alert('当前浏览器 Not support websocket')
	}
	
	//连接发生错误的回调方法
	websocket.onerror = function () {
	    setMessageInnerHTML("WebSocket连接发生错误");
	};
	
	
	//连接成功建立的回调方法
	websocket.onopen = function () {
	    setMessageInnerHTML("WebSocket连接成功");
	};
	
	
	//接收到消息的回调方法
	websocket.onmessage = function (event) {
		var message = JSON.parse(event.data);
	    if(message.user==0){
	    	myFont = message.user1.font;
	    	myColor = message.user1.color;
	    	otherFont = message.user2.font;
	    	otherColor = message.user2.color;
	    }else{
	    	//content.innerHTML += '<li><img src="'+arrIcon[num]+'"><span>'+message.text+'</span></li>';
	        var spanEle = $('<span></span>').text(message.text);
	    	switch(otherFont){
    		case '1':
    			//$(spanEle).attr("style","letter-spacing:-2px;font-size:10px;font-weight:normal");
    			$(spanEle).css("letter-spacing", "-2px");
    			$(spanEle).css("font-size", "10px");
    			$(spanEle).css("font-weight", "normal");
    			break;
    		case '2':
    			$(spanEle).css("letter-spacing", "0px");
    			$(spanEle).css("font-size", "20px");
    			$(spanEle).css("font-weight", "normal"); 
    			break;
    		case '3':
    			$(spanEle).css("letter-spacing", "10px");
    			$(spanEle).css("font-size", "30px");
    			$(spanEle).css("font-weight", "bold"); 
    			break;
    		}
	    	switch(otherColor){
    		case '1':
    			$(spanEle).css("background", "#E1CE40");
    			break;
    		case '2':
    			$(spanEle).css("background", "#C42728");
    			break;
    		case '3':
    			$(spanEle).css("background", "#463692");
    			break;
    		case '4':
    			$(spanEle).css("background", "#285EA1");
    			break;
    		}
	        var imgEle =  $('<img src="'+arrIcon[num]+'">');
	        var liEle = $('<li></li>').append(imgEle, spanEle);
	        $(content).append(liEle);
	    	
	    	iNow++;
	        img[iNow].className += 'imgleft';
	        span[iNow].className += 'spanleft';
		    // 内容过多时,将滚动条放置到最底端
		    content.scrollTop=content.scrollHeight;
	//    	$('#message').append(message.user+" -> "+message.text+" <br/>"+message.time+ "<br/>");
	    }
	};
	
	
	//连接关闭的回调方法
	websocket.onclose = function () {
	    setMessageInnerHTML("WebSocket连接关闭");
	};
	
	
	//监听窗口关闭事件，当窗口关闭时，主动去关闭websocket连接，防止连接还没断开就关闭窗口，server端会抛异常。
	window.onbeforeunload = function () {
	    closeWebSocket();
	};
	
	
	//将消息显示在网页上
	function setMessageInnerHTML(sendMessage) {
	    document.getElementById('text').innerHTML += sendMessage + '<br/>';
	}
	
	
	//关闭WebSocket连接
	function closeWebSocket() {
	    websocket.close();
	}
	
	//btn.onclick = function(){
	btn.onclick = function(){
	    if(text.value ==''){
	        alert('Write something Plz');
	    }else {
	    	var time = new Date().format("yyyy-MM-dd hh:mm:ss");
	        // content.innerHTML += '<li><img src="'+arrIcon[num]+'"><span>'+text.value+'</span></li>';
	    	var spanEle = $('<span></span>').text(text.value);
	    	switch(myFont){
    		case '1':
    			$(spanEle).attr("style","letter-spacing:-2px;font-size:10px;font-weight:normal");
    			/* $(spanEle).css("letter-spacing", "-2px");
    			$(spanEle).css("font-size", "10px");
    			$(spanEle).css("font-weight", "normal"); */
    			break;
    		case '2':
    			$(spanEle).css("letter-spacing", "0px");
    			$(spanEle).css("font-size", "20px");
    			$(spanEle).css("font-weight", "normal");
    			break;
    		case '3':
    			$(spanEle).css("letter-spacing", "10px");
    			$(spanEle).css("font-size", "30px");
    			$(spanEle).css("font-weight", "bold");
    			break;
    		}
	    	switch(myColor){
    		case '1':
    			$(spanEle).css("background", "#E1CE40");
    			break;
    		case '2':
    			$(spanEle).css("background", "#C42728");
    			break;
    		case '3':
    			$(spanEle).css("background", "#463692");
    			break;
    		case '4':
    			$(spanEle).css("background", "#285EA1");
    			break;
    		}
	        var imgEle =  $('<img src="'+arrIcon[num]+'">');
	        var liEle = $('<li></li>').append(imgEle, spanEle);
	    	$(content).append(liEle);
	    	
	        iNow++;
	        img[iNow].className += 'imgright';
	        span[iNow].className += 'spanright';
			var message = {
	        	text: text.value,
	        	user: userNo,
	        	time: time,
	        	font: myFont,
	        	color: myColor,
	        };
		    websocket.send(JSON.stringify(message));
		    text.value = '';
		    // 内容过多时,将滚动条放置到最底端
		    content.scrollTop=content.scrollHeight;
	    }
	};
	
	Date.prototype.format = function(fmt) { 
	    var o = { 
	       "M+" : this.getMonth()+1,                 //月份 
	       "d+" : this.getDate(),                    //日 
	       "h+" : this.getHours(),                   //小时 
	       "m+" : this.getMinutes(),                 //分 
	       "s+" : this.getSeconds(),                 //秒 
	       "q+" : Math.floor((this.getMonth()+3)/3), //季度 
	       "S"  : this.getMilliseconds()             //毫秒 
	   }; 
	   if(/(y+)/.test(fmt)) {
	           fmt=fmt.replace(RegExp.$1, (this.getFullYear()+"").substr(4 - RegExp.$1.length)); 
	   }
	    for(var k in o) {
	       if(new RegExp("("+ k +")").test(fmt)){
	            fmt = fmt.replace(RegExp.$1, (RegExp.$1.length==1) ? (o[k]) : (("00"+ o[k]).substr((""+ o[k]).length)));
	        }
	    }
	   return fmt; 
	};

</script>
 --></html>
