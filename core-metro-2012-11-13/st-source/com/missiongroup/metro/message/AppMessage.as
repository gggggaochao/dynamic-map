package com.missiongroup.metro.message
{
	
import com.spring.core.Message;

public class AppMessage extends Message
{
	/**
	 *  连接关闭
	 */	
	public static const CON_CLOSE : String = "ConnectinClose";
	
	
	/**
	 *  连接打开
	 */	
	public static const CON_OPEN : String = "ConnectinOpen";
	
	
	/**
	 *  连接打开
	 */	
	public static const IDLE : String = "idle";
	
	
	/**
	 *  本地连接打开
	 */		
	public static const LOCAL_SOCKET_CONNECT : String = "local_socket_connect";
	
	
	/**
	 *  本地连接关闭
	 */		
	public static const LOCAL_SOCKET_COLOSE : String = "local_socket_close";
	
	
	public function AppMessage(selector:String)
	{
		super(selector);
	}
}
}