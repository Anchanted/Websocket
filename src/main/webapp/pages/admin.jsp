<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%
    String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+request.getContextPath();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Admin</title>
    <script type="text/javascript" src="<%=basePath %>/static/js/jquery-1.4.2.js"></script>
    <link rel="stylesheet" type="text/css" href="<%=basePath %>/static/css/chat.css" />
</head>
<body>
<center>
    <form action="">
		Font:
		<lable><input type="radio" id="font-size:30px" name="radio1" value=""/>Big</lable>
		<lable><input type="radio" id="font-size:10px" name="radio1" value=""/>Small</lable><br />
		<lable><input type="radio" id="letter-spacing:10px" name="radio1" value=""/>Wide</lable>
		<lable><input type="radio" id="letter-spacing:-2px" name="radio1" value=""/>Narrow</lable><br />
		<lable><input type="radio" id="font-weight:normal" name="radio1" value=""/>Regular</lable>
		<lable><input type="radio" id="font-weight:bold" name="radio1" value=""/>Bold</lable><br />
	    Color:
		<lable><input type="radio" id="background:#E1CE40" name="radio2" value=""/>Happiness</lable>
		<lable><input type="radio" id="background:#C42728" name="radio2" value=""/>Anger</lable>
		<lable><input type="radio" id="background:#463692" name="radio2" value=""/>Fear</lable>
		<lable><input type="radio" id="background:#285EA1" name="radio2" value=""/>Sadness</lable>
	   	<br />
    	<!-- <input type="text" name="text"/> -->
    	<input type="reset" value="重置" onclick="$('#chat').children().removeAttr('style')"></input>
    </form>
    <button onclick="closeWebSocket()">关闭WebSocket连接</button>
    <hr/>
    <ul class="content" style="height:100px">
		<!-- <li id="chat1"><span>Hello, this is user 1.</span></li> -->
		<li id="chat"><span>你好我是用户</span></li>
		<!-- <li id="chat2"><span>你好我是用户2</span></li> -->
	</ul>
	<hr />
    <div id="message"></div>
</center>
</body>


<script type="text/javascript">
    var websocket = null;
    var messageArr = [];
    
    //判断当前浏览器是否支持WebSocket
    if ('WebSocket' in window) {
        // websocket = new WebSocket("ws://localhost:8888/Websocket/websocket/0");
        websocket = new WebSocket("ws://192.168.2.214:8888/Websocket/websocket/0");
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
    }


    //接收到消息的回调方法
    websocket.onmessage = function (event) {
    	var message = JSON.parse(event.data);
    	messageArr.push(message);
        if(message.user=='0'){
        	// $('#message').append(message.user+" --> "+message.text+" <br/>"+message.time+ "<br/>");
        }else{
        	$('#message').append("<div style='border-style:solid;width:600px;height:60px;'>"+message.user+" --> "+message.text+"<br/>"+message.time+ "<br/><input type='button' value='发送' onclick='send(this)' time='"+message.time+"'/></div>");
        	// websocket.send(JSON.stringify(message));
        }
    }


    //连接关闭的回调方法
    websocket.onclose = function () {
        setMessageInnerHTML("WebSocket连接关闭");
    }


    //监听窗口关闭事件，当窗口关闭时，主动去关闭websocket连接，防止连接还没断开就关闭窗口，server端会抛异常。
    window.onbeforeunload = function () {
        closeWebSocket();
    }


    //将消息显示在网页上
    function setMessageInnerHTML(sendMessage) {
        document.getElementById('message').innerHTML += sendMessage + '<br/>';
    }


    //关闭WebSocket连接
    function closeWebSocket() {
        websocket.close();
    }

    //发送消息
    function send(button) {
        //document.getElementById('message').style.color="red";
        //var ToSendUserno=document.getElementById('usernoto').value;
        var message;
        for(i = 0, len = messageArr.length; i < len; i++) {
    		if(messageArr[i].time==$(button).attr("time")){
    			message = messageArr[i];
    			break;
    		}
    	}
        var info = {
        	user: '0',
        	message: message,
        	style: {
            	font: $("input[name='radio1']:checked").attr("id"),
            	color: $("input[name='radio2']:checked").attr("id"),
            },
        };
        websocket.send(JSON.stringify(info));
        $(button).replaceWith('已发送');
    }
    
    $("input[type=radio][name=radio1]").change(function(){
    	var color = $("#chat").children().css("background-color");
    	$("#chat").children().attr("style", $(this).attr("id")+";background-color:"+color);
    });
    

    $("input[type=radio][name=radio2]").change(function(){
 		$("#chat").children().css("background-color", $(this).attr("id").substr(11));
    });
    
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
   }        
</script>
</html>
