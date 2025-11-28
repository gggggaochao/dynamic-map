package com.missiongroup.car.commands
{
import com.logging.Logger;
import com.logging.LoggerManager;
import com.missiongroup.metro.command.DataPackage;
import com.missiongroup.metro.command.DataPackageProviderFactory;

import flash.utils.ByteArray;
import flash.utils.IDataInput;

public class CommandFactroy implements DataPackageProviderFactory
{
	private var logger : Logger = LoggerManager.getInstance();
	
	public function createHeartBeatAlive(heartBeat:uint=1):ByteArray
	{
		var _package : ByteArray = new ByteArray();
		_package.writeByte(heartBeat);
		return _package;
	}
	
	public function initDataPacket():void
	{
		// TODO Auto Generated method stub
		
	}
	
	
	public function readPacket(bytes : IDataInput):DataPackage
	{

		var byteLength : uint = bytes.bytesAvailable;
		
		var content : XML = new XML("<content />");
		var cmd : uint = 0;
		if(byteLength >= 13)
		{
			var readDataPacket : ByteArray = new ByteArray();
			
			bytes.readBytes(readDataPacket,0,14);
			
			
			// 指令
			cmd = readDataPacket.readUnsignedByte();
			
			// 读取信号
			
			// 线路号
			content.@LineNum = readDataPacket.readUnsignedByte();
			
			// 上下行
			content.@Dir = readDataPacket.readUnsignedByte();
			
			// 起始站
			content.@StartStation = readDataPacket.readUnsignedByte();
			
			// 当前站
			content.@CurrStation = readDataPacket.readUnsignedByte();
			
			// 下一站
			content.@NextStation = readDataPacket.readUnsignedByte();
			
			// 终点站
			content.@EndStation = readDataPacket.readUnsignedByte();
			
			// 开门侧
			content.@DoorDir = readDataPacket.readUnsignedByte();
			
			// 是否环线（0：本线非环线	1：本线环线）
			content.@isRing = readDataPacket.readUnsignedByte();
			
			// 越站设置
			content.@isPass = readDataPacket.readUnsignedByte();
			
			// 越站恢复
			content.@isPassReset = readDataPacket.readUnsignedByte();
			
			// 钥匙信号
			content.@keyCode = readDataPacket.readUnsignedByte();	
			
			// 车厢号是否反向
			content.@isReverse = readDataPacket.readUnsignedByte();
			
			// 4号线是否最后一圈
			content.@line4Flag = readDataPacket.readUnsignedByte();
			
			logger.info("factory:" + cmd + " "+ content.@LineNum + " "+ content.@Dir
				+ " "+ content.@StartStation+ " "+content.@CurrStation + " "+ content.@NextStation
				+ " "+ content.@EndStation+ " "+content.@DoorDir
				+ " "+ content.@isRing+ " "+ content.@isPass+ " "+content.@isPassReset
				+ " "+ content.@keyCode+ " "+ content.@isReverse + " " + content.@line4Flag);
			
		}
		
		var commandPackage : CommandPackage = new CommandPackage();
		commandPackage.Cmd = cmd;
		commandPackage.Content = content;
		
		return commandPackage;
	}
	
	public function handler(command:DataPackage,
							address : String,cmd : uint,content : XML):DataPackage
	{
		
//		var taskpackage : TaskPackage = command as TaskPackage;
//		var addressTree : XML = taskpackage.AddressTree;
//		addressTree.dr = SendDirection.UP;
//		addressTree.src = address;		
//		
//		
//		var taskPackage : TaskPackage = new TaskPackage();
//		taskPackage.MessageID = taskpackage.MessageID;
//		taskPackage.Cmd = cmd;
//		taskPackage.MessageReply = MessageReply.No;
//		taskPackage.AddressTree = addressTree;
//		taskPackage.Content = content;
		
		return null;
	}
	
	
	
	public function writePacket(command:DataPackage):ByteArray
	{
//		var taskPackage : TaskPackage = command as TaskPackage;
//		
//		var content : String = taskPackage.Content.toString();
//		var addressTree : String = taskPackage.AddressTree.toString();
//		
//		var bytes : ByteArray = new ByteArray();
//		bytes.writeUTFBytes(content);
//		
//		
//		var _package : ByteArray = new ByteArray();
//		_package.writeMultiByte(taskPackage.MessageID,"ASCII");
//		_package.writeByte(taskPackage.Cmd);
//		_package.writeByte(taskPackage.MessageReply);
//		_package.writeInt(addressTree.length);
//		_package.writeMultiByte(addressTree,"UTF8");		
//		_package.writeInt(bytes.length);
//		_package.writeBytes(bytes,0,bytes.length);	
//		
//		return _package;
		
		return null;
	}
	
}
}
















