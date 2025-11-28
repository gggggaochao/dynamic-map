package com.missiongroup.car.managers
{
	import com.mission.serialport.Serialport;
	import com.mission.serialport.SerialportEvent;
	import com.missiongroup.metro.command.DataPackage;
	import com.missiongroup.metro.command.DataPackageProviderFactory;
	import com.missiongroup.metro.command.consts.Command;
	import com.missiongroup.metro.managers.SocketServicesManager;
	import com.struts.utils.HashTable;
	
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	import flash.utils.setTimeout;
	
	public class SerialportServiceManager extends SocketServicesManager
	{
		
		[Bean(id="config")]
		public var config : HashTable;
		
		private var _serialport : Serialport = null;
		
		private var t : Timer;
		
		public function SerialportServiceManager(commandHandler:DataPackageProviderFactory)
		{
			super(commandHandler);
		}
		
		
		override public function run():void
		{
			
			//Serialport.SERIALPORT_PRIMARY;Serialport.SERIALPORT_SECONDARY
			
			/*timer = new Timer(setting.KeepHeartBeatTimes * 1000);
			timer.addEventListener(TimerEvent.TIMER,keepHeartBeatReply);*/
			
			//readByteArray = new ByteArray();
			//readByteArray.endian =  Endian.BIG_ENDIAN;
			
			try {
			
				var _systemType : String = config.find('systemType');
				var systemType : int = _systemType == "M1" ? Serialport.SERIALPORT_PRIMARY : Serialport.SERIALPORT_SECONDARY;
				logger.info(_systemType+" " + systemType);
				
				if(_systemType == "M1") {
					var me : SerialportServiceManager = this;
					setTimeout(function():void{
						me.open(systemType,_systemType);
					},30000);
				}
				else {
					this.open(systemType,_systemType);
				}
				
				super.run();
			}
			catch(e:Error) {
				
				logger.info("SerialportServiceManager[run]:"+e.message+"->"+e.getStackTrace());			
			
			}
		}
		
		override protected function runSocketServer() : void
		{
		}		
		
		
		private function open(systemType:int,_systemType:String) : void
		{	try {

			_serialport=Serialport.getInstance();
				_serialport.addEventListener(SerialportEvent.DATA_RECEIVED,serialportDataReceived);
				_serialport.open(systemType);
				
				if(_systemType == "M1"){
					t = new Timer(5000);
					t.addEventListener(TimerEvent.TIMER,timerHanlder);
					t.start();
				}					
			}
			catch(e:Error) {
				
				logger.info("SerialportServiceManager[open]:"+e.message+"->"+e.getStackTrace());			
				
			}
		
		}
		
		
		
		private function detory() : void
		{
			t.stop();
			t.removeEventListener(TimerEvent.TIMER,timerHanlder);
			t = null;
		}
		
		private function timerHanlder(e:Event) : void
		{
			firstReplay();
		}
		
		override protected function connectToServer() : void
		{
			
		}
		
		private var readDataPacket : ByteArray = new ByteArray();
		
		private static const _start : uint = 0xff;
		
		private static const _end : uint = 0xfe;
		
		private function readPackget(byte : ByteArray) : ByteArray
		{
			var _currentCode : uint;
			var _len : uint;
			while(byte.bytesAvailable) {
				_currentCode = byte.readUnsignedByte();
				if(_currentCode == _start) {
					readDataPacket = new ByteArray();
				}
				else if(_currentCode == _end) {
					return readDataPacket;
				}
				else {
					readDataPacket.writeByte(_currentCode);
				}
			}	
			return null;
		}
		
		protected function serialportDataReceived(event : SerialportEvent) : void {
			var _systemType : String = config.find('systemType');
			
			var byte : ByteArray = event.data;
			
			var packget : ByteArray = readPackget(byte);
			
			if(packget) 
			{
				packget.position = 0;
				
				var dataPackage : DataPackage = commandHandler.readPacket(packget);
				
				if(dataPackage)
				{
					keepAliveCount = 0;
					if(dataPackage.Cmd == Command.Keep_HeartBeat)
					{
						if(_systemType == "M1"){
							heartBeatReply();
						}				
					}
					else if(dataPackage.Cmd != Command.Keep_HeartBeat_Reply)
					{
						commandDataHandler(dataPackage);
						if(dataPackage.Cmd == 0x06)
						{
							if(_systemType == "M1"){
								detory();
							}
						}
					}
					
				}			
			}
		}
		
		/**
		 * 启动确认包
		 */
		public function firstReplay(replay : uint = 0x09) : void{
			//var bytes : ByteArray = commandHandler.createHeartBeatAlive(replay);
			var bytes:ByteArray = new ByteArray();
			bytes.writeByte(0xff);
			bytes.writeByte(0x09);
			bytes.writeByte(0x00);
			bytes.writeByte(0x00);
			bytes.writeByte(0x00);
			bytes.writeByte(0x00);
			bytes.writeByte(0x00);
			bytes.writeByte(0x00);
			bytes.writeByte(0x00);
			bytes.writeByte(0x00);
			bytes.writeByte(0x00);
			bytes.writeByte(0x00);
			bytes.writeByte(0x00);
			bytes.writeByte(0x00);
			bytes.writeByte(0x00);
			bytes.writeByte(0x00);
			bytes.writeByte(0x00);
			bytes.writeByte(0xfe);
			bytes.writeByte(0x3a);
			bytes.writeByte(0x32);
			send(bytes);
		}
		
		/**
		 * 心跳回复
		 */
		override public function heartBeatReply(heartBeat : uint = 0x01) : void
		{
			//var bytes : ByteArray = commandHandler.createHeartBeatAlive(heartBeat);
			var bytes:ByteArray = new ByteArray();
			bytes.writeByte(0xff);
			bytes.writeByte(0x01);
			bytes.writeByte(0x00);
			bytes.writeByte(0x00);
			bytes.writeByte(0x00);
			bytes.writeByte(0x00);
			bytes.writeByte(0x00);
			bytes.writeByte(0x00);
			bytes.writeByte(0x00);
			bytes.writeByte(0x00);
			bytes.writeByte(0x00);
			bytes.writeByte(0x00);
			bytes.writeByte(0x00);
			bytes.writeByte(0x00);
			bytes.writeByte(0x00);
			bytes.writeByte(0x00);
			bytes.writeByte(0x00);
			bytes.writeByte(0xfe);
			bytes.writeByte(0x3f);
			bytes.writeByte(0x30);
			send(bytes);
		}
		
		
		/**
		 * 
		 * 发送数据包到服务端
		 *  
		 * @param btyes
		 * 
		 */	
		override public function send(bytes : ByteArray) : void
		{
			_serialport.write(bytes);
		}
		
	}
}