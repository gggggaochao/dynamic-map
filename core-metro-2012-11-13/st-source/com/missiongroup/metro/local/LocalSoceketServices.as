package com.missiongroup.metro.local
{
import com.missiongroup.metro.message.AppMessage;
import com.missiongroup.metro.message.LocalCmdMessage;
import com.missiongroup.metro.servers.Services;
import com.spring.managers.ControllerManager;

import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.ProgressEvent;
import flash.events.SecurityErrorEvent;
import flash.net.Socket;
import flash.utils.ByteArray;
import flash.utils.setTimeout;

import mx.utils.ObjectUtil;
import mx.utils.URLUtil;

public class LocalSoceketServices extends Services
{
	
	private var cm : ControllerManager = ControllerManager.getInstance();
	
	private var socket : Socket;
	
	private var startIndex  : int = -1;
	
	private var endIndex : int = -1;
	
	private var readByte : ByteArray;
	
	public function LocalSoceketServices(cmds:Array)
	{
		super(cmds);
		
		cm.addTag(this,null);
	}
	
	override public function run():void
	{
		
		socket = new Socket();
		socket.addEventListener(Event.CONNECT,socketOnConnectSucces);
		socket.addEventListener(Event.CLOSE,socketConnectFailHandler);
		socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR,socketConnectFailHandler);
		socket.addEventListener(IOErrorEvent.IO_ERROR,socketConnectFailHandler);
		socket.addEventListener(ProgressEvent.SOCKET_DATA,socketOnDataGet);	
		
		super.run();
	}
	
	[MessageHandler(selector="local_socket_close")]
	public function closeServerHandler(msg : AppMessage) : void
	{
		if(socket && socket.connected) {
			socket.close();
		}
	}
	
	[MessageHandler(selector="local_socket_connect")]
	public function connectServerHandler(msg : AppMessage) : void
	{
		if(socket && socket.connected == false) {
			connectToServer();
		}
	}
	
	private function socketOnConnectSucces(event : Event) : void
	{
		logger.info("Local Socket Connect Success");
		
		dispatcher(new LocalCmdMessage(LocalCmdMessage.LOCAL_CONNECT));
	}
	
	private function socketConnectFailHandler(event : Event) : void
	{
		logger.info("Local Socket Connect Fail");
	}
	
	private function socketOnDataGet(event : ProgressEvent) : void
	{
		
		while(socket.bytesAvailable)
		{
			var str : String = socket.readUTFBytes(socket.bytesAvailable);
			
			if(str)
			{
				if(startIndex == -1)
				   startIndex = str.indexOf("[");
				if(endIndex == -1)
				   endIndex = str.indexOf("]");
				
				if(endIndex > (startIndex + 1))
				{
					var pageketstr : String = str.slice(startIndex + 1,endIndex);
					
					pageketHandler(pageketstr);
					
					startIndex = endIndex = -1;
					
					logger.info("Local - > "+pageketstr);
				}
				
			}
			
		}
	}
	
	private function pageketHandler(pageketstr : String) : void
	{
		var data : Object = URLUtil.stringToObject(pageketstr,"&",true);
		
		var cmd : String = data.CMD;
		
		var message : LocalCmdMessage = new LocalCmdMessage(LocalCmdMessage.LOCAL_CMD_RES + "_" + cmd);
		message.data = data;
		
		dispatcher(message);
	
	}
	
	
	public function send(value : String) : void
	{
		if(socket.connected)
		{
			logger.info("连接成功。。。。。。。");
			socket.writeUTFBytes(value);
			socket.flush();
			logger.info("发送的数据：" + value)
		}	
		
	}
	
	
	/**
	 * 
	 *  与服务器请求连接 
	 * 
	 */	
	private function connectToServer() : void
	{
		try
		{			
			var address : String = setting.LocalAddress;
			var port : int = int(setting.LocalPort);
			
			if(address && port)
			{
				socket.connect(address,port);
			}	
		}
		catch(e : Error)
		{
			logger.error(e.message);
		}
	}
	
	
	[MessageHandler(selector="LOCAL_CMD")]
	public function localCmdHandler(message : LocalCmdMessage) : void
	{
		var value : String = "[CMD=" + message.cmd;
		
		if(message.bt)
		{
			value +="&BT=" + message.bt;
		}
		
		if(message.content)
		{
			value +="&CONTENT=" + message.content;
		}
		
		value += "]";
		
		logger.info("Local - > "+value);
		send(value);
		
	}
	
}
}