package com.missiongroup.metro.message
{
import com.spring.core.Message;

public class LocalCmdMessage extends Message
{
	
	/**
	 *  发送指令
	 */	
	public static const LOCAL_CMD : String = "LOCAL_CMD";
	
	
	/**
	 *  接收指令
	 */	
	public static const LOCAL_CMD_RES : String = "LOCAL_CMD_RES";

	
	/**
	 *  连接成功
	 */	
	public static const LOCAL_CONNECT : String = "LOCAL_CONNECT";
	
	public var cmd : String;
	
	public var bt : String;
	
	public var content : String;
	
	public var data : Object;
	
	public function LocalCmdMessage(selector:String)
	{
		super(selector);
	}
}
}