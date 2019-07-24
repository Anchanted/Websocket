var arrIcon = [basePath+'/static/image/timg.jpg'];
var num = 0;     //控制头像改变
var iNow = -1;    //用来累加改变左右浮动
var btn = document.getElementById('btn');
var text = document.getElementById('text');
var content = document.getElementsByTagName('ul')[0];
var img = content.getElementsByTagName('img');
var span = content.getElementsByTagName('span');
var userNo = $("#container").attr('name');

var websocket = null;

//判断当前浏览器是否支持WebSocket
if ('WebSocket' in window) {
    // websocket = new WebSocket("ws://localhost:8888/Websocket/websocket/"+userNo);
    websocket = new WebSocket("ws://192.168.2.214:8888/Websocket/websocket/"+userNo);
}
else {
    alert('当前浏览器 Not support websocket')
}

var count = 0;
function rotate() {
  var elem2 = document.getElementById('spinner');
  if(elem2){
	  elem2.style.MozTransform = 'scale(0.5) rotate('+count+'deg)';
	  elem2.style.WebkitTransform = 'scale(0.5) rotate('+count+'deg)';
  }
  if (count==360) { count = 0 }
  count+=45;
  window.setTimeout(rotate, 100);
}
window.setTimeout(rotate, 100);

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
	var data = JSON.parse(event.data);
    if(data.user==0){
    	if(data.message.user!=userNo){
    		content.innerHTML += '<li><img src="'+arrIcon[num]+'"><span>'+data.message.text+'</span></li>';
    		iNow++;
    		img[iNow].className += 'imgleft';
    		span[iNow].className += 'spanleft';
    		$(span[iNow]).attr("style", data.style.font+';'+data.style.color+';');
    		// 内容过多时,将滚动条放置到最底端
    		content.scrollTop=content.scrollHeight;
    	}else{
    		$(span[iNow]).attr("style", data.style.font+';'+data.style.color+';');
    		$(".lds-spinner").each(function(i, e){
    			if ($(e).attr("time") == data.message.time){
    				$(e).remove();
    				return false;
    			}
	        });
    	}
    }else{
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
function send(){
    if(text.value ==''){
        alert('Write something Plz');
    }else {
    	var time = new Date().format("yyyy-MM-dd hh:mm:ss");
        content.innerHTML += '<li><img src="'+arrIcon[num]+'"><span>'+text.value+'</span><div class="lds-spinner" time="'+ time +'"><div></div><div></div><div></div><div></div><div></div><div></div><div></div><div></div></div></li>';
        iNow++;
        img[iNow].className += 'imgright';
        span[iNow].className += 'spanright';
	    websocket.send(JSON.stringify({
        	text: text.value,
        	user: userNo,
        	time: time,
        }));
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



