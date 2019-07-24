/**
 * Project Name:Websocket
 * File Name:WebsocketTest.java
 * Package Name:cn.java.websocket
 * Date:2019年4月23日下午11:02:51
 * Copyright (c) 2019, All Rights Reserved.
 *
*/

package cn.java.websocket;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.Calendar;
import java.util.Date;
import java.util.concurrent.ConcurrentHashMap;

/**
 * Description:	   <br/>
 * Date:     2019年4月23日 下午11:02:51 <br/>
 * @author   asus
 * @version  
 * @see 	 
 */
import javax.websocket.EndpointConfig;
import javax.websocket.OnClose;
import javax.websocket.OnError;
import javax.websocket.OnMessage;
import javax.websocket.OnOpen;
import javax.websocket.Session;
import javax.websocket.server.PathParam;

import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.RichTextString;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.xssf.streaming.SXSSFWorkbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.json.JSONObject;

/**
 * @ServerEndpoint 注解是一个类层次的注解，它的功能主要是将目前的类定义成一个websocket服务器端,
 *                 注解的值将被用于监听用户连接的终端访问URL地址,客户端可以通过这个URL来连接到WebSocket服务器端
 * @ServerEndpoint 可以把当前类变成websocket服务类
 */
// @ServerEndpoint("/websocket/{userno}")
public class Websocket {
    // 静态变量，用来记录当前在线连接数。应该把它设计成线程安全的。
    private static int onlineCount = 0;

    // concurrent包的线程安全Set，用来存放每个客户端对应的MyWebSocket对象。若要实现服务端与单一客户端通信的话，可以使用Map来存放，其中Key可以为用户标识
    private static ConcurrentHashMap<String, Websocket> webSocketSet = new ConcurrentHashMap<String, Websocket>();

    // 与某个客户端的连接会话，需要通过它来给客户端发送数据
    private Session WebSocketsession;

    // 当前发消息的人员编号
    private String userno = "";

    private static SXSSFWorkbook workbook = new SXSSFWorkbook(new XSSFWorkbook(), 1000);

    private static File file;

    private static Sheet sheet;

    private int rowNo = 0;

    @OnOpen
    public void onOpen(@PathParam(value = "userno") String param, Session WebSocketsession, EndpointConfig config) {
        System.out.println(param);
        userno = param;// 接收到发送消息的人员编号
        this.WebSocketsession = WebSocketsession;
        webSocketSet.put(param, this);// 加入map中
        addOnlineCount(); // 在线数加1
        System.out.println("有新连接加入！当前在线人数为" + getOnlineCount());
        if ("0".equals(userno)) {
            // 生成标题
            file = new File("E:\\ChatRecord.xlsx");
            sheet = workbook.getSheet("sheet1");
            // if (sheet == null) {
            // sheet = workbook.createSheet("sheet2");
            // }
            if (sheet == null) {
                sheet = workbook.createSheet("sheet1");
            }
            Row row = sheet.createRow(rowNo);
            int k = -1;
            row.createCell(++k).setCellValue("User");
            row.createCell(++k).setCellValue("Content");
            row.createCell(++k).setCellValue("Time");
            row.createCell(++k).setCellValue("Font");
            row.createCell(++k).setCellValue("Color");
            rowNo++;
        }
    }

    @OnError
    public void onError(Session session, Throwable error) {
        System.out.println("发生错误");
        error.printStackTrace();
    }

    @OnClose
    public void onClose() throws Exception {
        if (!userno.equals("")) {
            webSocketSet.remove(userno); // 从set中删除
            subOnlineCount(); // 在线数减1
            System.out.println("有一连接关闭！当前在线人数为" + getOnlineCount());
            if ("0".equals(userno)) {
                FileOutputStream out = new FileOutputStream(file);
                workbook.write(out);
                out.close();
                workbook.dispose();
                workbook.close();
            }
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
        JSONObject messageJson = new JSONObject(message);
        System.out.println(userno + " received");
        // if (messageJson.get("user").equals(userno)) {
        // // 遍历HashMap
        // for (String key : webSocketSet.keySet()) {
        // try {
        // // 判断接收用户是否是当前发消息的用户
        // if (!userno.equals(key)) {
        // webSocketSet.get(key).sendMessage(message);
        // // System.out.println(key + " gets message");
        // }
        // } catch (IOException e) {
        // e.printStackTrace();
        // }
        // }
        // }

        if ((messageJson.get("user")).equals(userno)) {
            // onmessage to users
            if (!"0".equals(userno)) {
                // user receives own message
                webSocketSet.get("0").sendMessage(message);
            } else {
                // user receives message from admin
                for (String key : webSocketSet.keySet())
                    if (!"0".equals(key))
                        webSocketSet.get(key).sendMessage(message);
                System.out.println(messageJson.toString());
                if ("0".equals((String) messageJson.get("user"))) {
                    Row row = sheet.createRow(rowNo);
                    int k = -1;
                    JSONObject messageObject = (JSONObject) messageJson.get("message");
                    JSONObject styleObject = (JSONObject) messageJson.get("style");
                    createCell(row, ++k, messageObject.get("user"));
                    createCell(row, ++k, messageObject.get("text"));
                    createCell(row, ++k, messageObject.get("time"));
                    if (styleObject.has("font")) {
                        String fontType = "";
                        switch ((String) styleObject.get("font")) {
                        case "font-size:30px":
                            fontType = "Big";
                            break;
                        case "font-size:10px":
                            fontType = "Small";
                            break;
                        case "letter-spacing:10px":
                            fontType = "Wide";
                            break;
                        case "letter-spacing:-2px":
                            fontType = "Narrow";
                            break;
                        case "font-weight:normal":
                            fontType = "Regular";
                            break;
                        case "font-weight:bold":
                            fontType = "Bold";
                            break;
                        }
                        createCell(row, ++k, fontType);
                        // createCell(row, ++k, styleObject.has("font") ?
                        // styleObject.get("font") : "NaN");
                    } else {
                        ++k;
                    }
                    if (styleObject.has("color")) {
                        String colorType = "";
                        switch ((String) styleObject.get("color")) {
                        case "background:#E1CE40":
                            colorType = "Happiness";
                            break;
                        case "background:#C42728":
                            colorType = "Anger";
                            break;
                        case "background:#463692":
                            colorType = "Fear";
                            break;
                        case "background:#285EA1":
                            colorType = "Sadness";
                            break;
                        }
                        createCell(row, ++k, colorType);
                        // createCell(row, ++k, styleObject.has("font") ?
                        // styleObject.get("font") : "NaN");
                    } else {
                        ++k;
                    }
                    // row.createCell(++k).setCellValue((String)
                    // messageJson.get("user"));
                    // row.createCell(++k).setCellValue((String)
                    // messageJson.get("text"));
                    // row.createCell(++k).setCellValue((String)
                    // messageJson.get("time"));
                    // row.createCell(++k).setCellValue((String)
                    // messageJson.get("font"));
                    // row.createCell(++k).setCellValue((String)
                    // messageJson.get("color"));
                    rowNo++;
                }
            }
        } else {
            // // onmessage to admin
            // if (!"0".equals(userno)) {
            // // admin receives user message and intercept
            // } else
            // // user receives own message and sent to all users
            // for (String key : webSocketSet.keySet())
            // if (!"0".equals(key))
            // webSocketSet.get(key).sendMessage(message);

        }

    }

    public void sendMessage(String message) throws IOException {
        this.WebSocketsession.getBasicRemote().sendText(message);
    }

    public static synchronized int getOnlineCount() {
        return onlineCount;
    }

    public static synchronized void addOnlineCount() {
        Websocket.onlineCount++;
    }

    public static synchronized void subOnlineCount() {
        Websocket.onlineCount--;
    }

    public static void createCell(Row row, int cellNum, Object value) {
        Cell cell = row.createCell(cellNum);
        generateValue(value, cell);
    }

    private static void generateValue(Object value, Cell cell) {
        if (value instanceof String) {
            cell.setCellValue((String) value);
        } else if (value instanceof Boolean) {
            cell.setCellValue((Boolean) value);
        } else if (value instanceof Double) {
            cell.setCellValue((Double) value);
        } else if (value instanceof Date) {
            cell.setCellValue((Date) value);
        } else if (value instanceof Calendar) {
            cell.setCellValue((Calendar) value);
        } else if (value instanceof RichTextString) {
            cell.setCellValue((RichTextString) value);
        }
    }

}
