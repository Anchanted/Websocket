/**
 * Project Name:Websocket
 * File Name:WebsocketZhitiao.java
 * Package Name:cn.java.websocket
 * Date:2019年7月22日下午6:18:34
 * Copyright (c) 2019, All Rights Reserved.
 *
*/

package cn.java.websocket;

import java.io.IOException;
import java.util.concurrent.ConcurrentHashMap;

import javax.websocket.EndpointConfig;
import javax.websocket.OnClose;
import javax.websocket.OnError;
import javax.websocket.OnMessage;
import javax.websocket.OnOpen;
import javax.websocket.Session;
import javax.websocket.server.PathParam;
import javax.websocket.server.ServerEndpoint;

/**
 * Description: <br/>
 * Date: 2019年7月22日 下午6:18:34 <br/>
 * 
 * @author asus
 * @version
 * @see
 */
@ServerEndpoint("/websocket/{userno}")
public class WebsocketZhitiao {
    // 静态变量，用来记录当前在线连接数。应该把它设计成线程安全的。
    private static int onlineCount = 0;

    // concurrent包的线程安全Set，用来存放每个客户端对应的MyWebSocket对象。若要实现服务端与单一客户端通信的话，可以使用Map来存放，其中Key可以为用户标识
    private static ConcurrentHashMap<String, WebsocketZhitiao> webSocketSet = new ConcurrentHashMap<String, WebsocketZhitiao>();

    // 与某个客户端的连接会话，需要通过它来给客户端发送数据
    private Session WebSocketsession;

    // 当前发消息的人员编号
    private String userno = "";

    private boolean duplicated = false;

    @OnOpen
    public void onOpen(@PathParam(value = "userno") String param, Session WebSocketsession, EndpointConfig config)
            throws IOException {
        System.out.println(param);
        userno = param;// 接收到发送消息的人员编号
        this.WebSocketsession = WebSocketsession;
        if (webSocketSet.get(param) == null) {
            webSocketSet.put(param, this);// 加入map中
            addOnlineCount(); // 在线数加1
            System.out.println("有新连接加入！当前在线人数为" + getOnlineCount());
        } else {
            duplicated = true;
            WebSocketsession.close();
            System.out.println("连接已存在");
        }
    }

    @OnError
    public void onError(Session session, Throwable error) {
        System.out.println("发生错误");
        // error.printStackTrace();
    }

    @OnClose
    public void onClose() throws Exception {
        if (!userno.equals("") && !duplicated) {
            webSocketSet.remove(userno); // 从set中删除
            subOnlineCount(); // 在线数减1
            System.out.println("有一连接关闭！当前在线人数为" + getOnlineCount());
        }
    }

    /**
     * 收到客户端消息后调用的方法
     *
     * @param message 客户端发送过来的消息
     * @param session 可选的参数
     * @throws IOException
     */
    @OnMessage
    public void onMessage(String message, Session session) throws IOException {
        System.out.println(message);

        if ("0".equals(userno)) {
            webSocketSet.get("1").sendMessage(message);
        }
    }

    public void sendMessage(String message) throws IOException {
        this.WebSocketsession.getBasicRemote().sendText(message);
    }

    public static synchronized int getOnlineCount() {
        return onlineCount;
    }

    public static synchronized void addOnlineCount() {
        WebsocketZhitiao.onlineCount++;
    }

    public static synchronized void subOnlineCount() {
        WebsocketZhitiao.onlineCount--;
    }

}
