package com.missiongroup.metro.managers
{
	
import com.missiongroup.metro.command.DataPackage;
import com.missiongroup.metro.command.DataPackageProviderFactory;
import com.missiongroup.metro.command.consts.Command;
import com.missiongroup.metro.events.ServicesEvent;
import com.missiongroup.metro.message.AppMessage;
import com.missiongroup.metro.servers.Services;
import com.struts.core.WebApp;
import com.struts.events.AppEvent;

import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.ProgressEvent;
import flash.events.SecurityErrorEvent;
import flash.events.TimerEvent;
import flash.net.Socket;
import flash.utils.ByteArray;
import flash.utils.Endian;
import flash.utils.Timer;
import flash.utils.setTimeout;

public class SocketServicesManager extends ServicesManager
{
	
	protected var commandHandler : DataPackageProviderFactory;
	
	protected var socket : Socket;
	
	protected var timer : Timer;
	
	protected var isAutoConnect : Boolean = true;
	
	protected var keepAliveCount : int;
	
	private static const KEEP_ALIVE_MAX_COUNT : int = 3;
	
	protected var readByteArray : ByteArray;
	
	public function SocketServicesManager(commandHandler : DataPackageProviderFactory)
	{
		if(commandHandler != null)
		{
			super();
			
			
			this.isAutoConnect = setting.IsAutoConnect;
			this.commandHandler = commandHandler;
			
			addEventListener(ServicesEvent.REPLY,servicesReplyHandler);
			WebApp.addEventListener(AppEvent.READY,sysReadyHandler);
		}
		else
		{
			throw new Error("SocketServicesManager is must have ICommandHandler");
		}
	}
	
	override public function run():void
	{
		this.runSocketServer();
		super.run();
	}
	
	
	protected function runSocketServer():void
	{
		timer = new Timer(setting.KeepHeartBeatTimes * 1000);
		timer.addEventListener(TimerEvent.TIMER,keepHeartBeatReply);
		
		readByteArray = new ByteArray();
		readByteArray.endian =  Endian.BIG_ENDIAN;
		
		socket = new Socket();
		socket.endian = Endian.BIG_ENDIAN;
		socket.addEventListener(Event.CONNECT,socketOnConnectSucces);
		socket.addEventListener(Event.CLOSE,socketConnectFailHandler);
		socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR,socketConnectFailHandler);
		socket.addEventListener(IOErrorEvent.IO_ERROR,socketConnectFailHandler);
		socket.addEventListener(ProgressEvent.SOCKET_DATA,socketOnDataGet);			
	}
	
	
	/**
	 * 
	 *  创建Socket 对象
	 * 
	 */	
//	private function createConnect() : void
//	{
//		if(socket == null)
//		{
//			socket = new Socket();
//			socket.endian = Endian.BIG_ENDIAN;
//			socket.addEventListener(Event.CONNECT,socketOnConnectSucces);
//			socket.addEventListener(Event.CLOSE,socketConnectFailHandler);
//			socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR,socketConnectFailHandler);
//			socket.addEventListener(IOErrorEvent.IO_ERROR,socketConnectFailHandler);
//			socket.addEventListener(ProgressEvent.SOCKET_DATA,socketOnDataGet);		
//		}
//	}
	
	/**
	 * 
	 * 系统加载完成
	 *  
	 * @param event
	 * 
	 */	
	private function sysReadyHandler(event : Event) : void
	{
		connectToServer();
	}
	
	/**
	 * 
	 *  与服务器请求连接 
	 * 
	 */	
	protected function connectToServer() : void
	{
		try
		{			
			var address : String = setting.ServiceAddress;
			var port : int = int(setting.ServicePort);
			
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
	
	
	private function socketOnConnectSucces(event : Event) : void
	{
		logger.info("Socket Connect Success");


		dispatcher(new AppMessage(AppMessage.CON_OPEN));
		
		commandHandler.initDataPacket();
		if(isAutoConnect)
		{
			timer.reset();
			timer.start();
			
			keepAliveCount = 0;
			heartBeatReply(Command.Keep_HeartBeat);
		}
	}
	
	private function socketConnectFailHandler(event : Event) : void
	{
		logger.info("Socket Connect Fail");

		dispatcher(new AppMessage(AppMessage.CON_CLOSE));
		
		setTimeout(connectToServer,5 * 1000);
	}
	
	
	
	protected function socketOnDataGet(event : ProgressEvent) : void
	{
		
		var dataPackage : DataPackage = commandHandler.readPacket(socket);
		
		if(dataPackage)
		{
			keepAliveCount = 0;
	
			if(dataPackage.Cmd == Command.Keep_HeartBeat)
			{
				heartBeatReply();				
			}
			else if(dataPackage.Cmd != Command.Keep_HeartBeat_Reply)
			{
				logger.info("CMD:"+dataPackage.Cmd);
				
				commandDataHandler(dataPackage);
			}
		}
	}
	
	/**
	 *
	 * 服务端指令处理
	 *  
	 * @param taskpackage
	 * 
	 */	
	protected function commandDataHandler(dataPackage : DataPackage) : void
	{
		
		//var cmd : uint = dataPackage.Cmd == Command.Other?uint(dataPackage.Content.Cmd):dataPackage.Cmd;
		
		//杭州特殊处理
		var cmd : uint = dataPackage.Cmd == Command.Other?uint(dataPackage.Content.Code):dataPackage.Cmd;
		
		var service : Services = findService(cmd);
		
		logger.info("socket :" + cmd);
		
		if(service)
		{
			service.command = dataPackage;
		}
		
	}
	
	
	/**
	 * 
	 * 根据指令查找对应服务
	 *  
	 * @param cmd
	 * @return 
	 * 
	 */	
	private function findService(cmd : uint) : Services
	{
		for each(var service : Services in servers)
		{
			if(service.handlerCmds && service.handlerCmds.indexOf(cmd) != -1)
			{
				service.cmd = cmd;
				return service;
			}
		}
		
		return null;
	}
	
	
	/**
	 * 
	 *  与服务端保持心跳 
	 * 
	 */	
	protected function keepHeartBeatReply(event : Event) : void
	{
		++keepAliveCount;
		if(keepAliveCount > KEEP_ALIVE_MAX_COUNT)
		{
			if(this.socket)
			{
				if(this.socket.connected)
				   this.socket.close();

				if(!this.socket.connected)
				{
					this.connectToServer();
					keepAliveCount = 0;
				}
			}
		}
	}
	
	/**
	 * 
	 * 心跳回复
	 *  
	 * @param btyes
	 * 
	 */	
	public function heartBeatReply(heartBeat : uint = 0x01) : void
	{
		var bytes : ByteArray = commandHandler.createHeartBeatAlive(heartBeat);
		send(bytes);
	}
	
	
	
	/**
	 * 
	 * 发送数据包到服务端
	 *  
	 * @param btyes
	 * 
	 */	
	public function send(bytes : ByteArray) : void
	{
		if(socket.connected)
		{
			socket.writeBytes(bytes,0,bytes.length);
			socket.flush();
		}	
	}
	
	
	private function servicesReplyHandler(event : ServicesEvent) : void
	{
		var command : DataPackage = event.command;
		var address : String = setting.LocalAddress;
		var cmd : uint = event.cmd;
		var content : XML = event.content;
		
		var commandReplay : DataPackage = commandHandler.handler(command,address,cmd,content);
		
		if(commandReplay) {
			var bytes : ByteArray = commandHandler.writePacket(commandReplay);
			send(bytes);
		}
	}
	
}
}



