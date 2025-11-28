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

public class LocalSoceketHZServices extends Services
{
	public static const num:int = 0;
	
	private var cm : ControllerManager = ControllerManager.getInstance();
	
	private var socket : Socket;
	
	private var startIndex  : int = -1;
	
	private var endIndex : int = -1;
	
	private var readByte : ByteArray;
	
	public function LocalSoceketHZServices(cmds:Array)
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
			var len:int = socket.readInt();
			logger.info("数据长度：" + len);
			//包头
			socket.readUTFBytes(4);
			
			socket.readUTFBytes(4);
			
			socket.readUTFBytes(8);
		
			socket.readUTFBytes(4);
			
			socket.readUTFBytes(4);
			
			//包体
			//应答码  0成功，其余故障
			var code:int = socket.readInt();
			if(code == 0){
				//票种大类，5,6按次数,4按时间，其余余额
				var Ticketclass:int = socket.readInt();
				
				logger.info("消息应答码：" + code);
				logger.info("票种大类：" + Ticketclass);
				
				var name : String = socket.readMultiByte(40,"gbk");
				logger.info("票种名称" + name);
				socket.readUTFBytes(8);
				
				socket.readUTFBytes(8);
				
				socket.readUTFBytes(8);
				//启用日期
				var enable:String = socket.readByte().toString(16) + changeStr(socket.readByte().toString(16)) + 
					changeStr(socket.readByte().toString(16)) + changeStr(socket.readByte().toString(16));
				//有效日期
				var validity:String = socket.readByte().toString(16) + changeStr(socket.readByte().toString(16)) + 
					changeStr(socket.readByte().toString(16)) + changeStr(socket.readByte().toString(16));
				
				socket.readUTFBytes(4);
				
				var fsNum :int = socket.readInt();
				logger.info("发售金额" + fsNum);
				
				socket.readUTFBytes(40);
				//剩余金额或次数，金额为分
				var sum:int = socket.readInt();
				
				logger.info("剩余金额或次数" + sum);
				
				socket.readUTFBytes(8);
				//本月剩余次数
				var num:int = socket.readInt();
				logger.info("本月剩余次数" + num);
				socket.readUTFBytes(12);
				
				var pageketstr:String = "";
				
				var s : Boolean = localDate >= enable;
				var sz : Boolean = localDate <= validity;
			
			
				if(Ticketclass == 1 || Ticketclass == 2){
					pageketstr = (fsNum/100).toFixed(2) + "元";
				}else if(Ticketclass == 5 ){
					pageketstr = sum + "次";
				}else if(Ticketclass == 6){
					pageketstr = num + "次";
				}else if(Ticketclass == 4){
					var date:Date = new Date();
					var localDate : String = date.fullYear.toString() + changeStr((date.month + 1).toString()) + changeStr(date.date.toString());
					if(localDate >= enable && localDate <= validity){
						pageketstr = "此卡有效期 至 "+validity;
					}else{
						pageketstr = "此卡已过期";
					}
				}else{
					pageketstr = (sum/100).toFixed(2) + "元";
				}
				break;
			}else if(code == 1){
				pageketstr = "读卡器故障";
				break;
			}else{
				pageketstr = "读卡失败";
				break;
			}
		}
		pageketHandler(pageketstr);
		logger.info("Local - > "+pageketstr);
	}
	
	private function changeStr(str:String):String{
		if(str.length < 2){
			return "0"+str;
		}
		return str;
	}
	
	private function pageketHandler(pageketstr : String) : void
	{
		var message : LocalCmdMessage = new LocalCmdMessage("LOCAL_CMD_RES_CARD");
		message.content = pageketstr;
		
		dispatcher(message);
	
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
		if(socket.connected)
		{
			logger.info("连接成功。。。。。。。");
			var byteArray : ByteArray = new ByteArray();
			byteArray.writeByte(0x00);
			byteArray.writeByte(0x00);
			byteArray.writeByte(0xaf);
			byteArray.writeByte(0xc0);
			byteArray.writeByte(0x00);
			byteArray.writeByte(0x00);
			byteArray.writeByte(0x10);
			byteArray.writeByte(0x01);
			
			var sj:Date=new Date(); //获取时间  
			var nf:String=sj.fullYear.toString(); //获取年份  
			var nf1:int = (int)(nf.substr(0,2));
			var nf2:int = (int)(nf.substr(2,2));
			var yf:int=sj.month + 1; //获取月份，返回数字  
			var rq:int=sj.date; //获取日期  
			var h:int=sj.hours; //获取小时  
			var m:int=sj.minutes; //获取分钟  
			var s:int=sj.seconds; //获取秒 
			byteArray.writeByte(changeInt(nf1));
			byteArray.writeByte(changeInt(nf2));
			byteArray.writeByte(changeInt(yf));
			byteArray.writeByte(changeInt(rq));
			byteArray.writeByte(changeInt(h));
			byteArray.writeByte(changeInt(m));
			byteArray.writeByte(changeInt(s));
			byteArray.writeByte(0x00);
			
			byteArray.writeByte(0x00);
			byteArray.writeByte(0x00);
			byteArray.writeByte(0x00);
			byteArray.writeByte(changeInt(num));
			
			//num++;
			
			byteArray.writeByte(0x00);
			byteArray.writeByte(0x00);
			byteArray.writeByte(0x00);
			byteArray.writeByte(0x00);
			
			socket.writeBytes(byteArray);
			socket.flush();
			logger.info("发送的数据：" + byteArray.toString())
		}	
		
	}
	
	private function changeInt(f:int):int{
		return  (int)("0x"+f.toString());
	}
}
}