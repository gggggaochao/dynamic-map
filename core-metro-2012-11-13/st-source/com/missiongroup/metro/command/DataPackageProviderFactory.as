package com.missiongroup.metro.command
{
	
import flash.utils.ByteArray;
import flash.utils.IDataInput;

public interface DataPackageProviderFactory
{

	/**
	 *
	 *  初始化数据包 
	 * 
	 */	
	function initDataPacket() : void;

	/**
	 * 
	 * 心跳回复
	 *  
	 * @param heartBeat
	 * @return 
	 * 
	 */	
	function createHeartBeatAlive(heartBeat : uint = 0x01) : ByteArray;
		
	/**
	 *
	 * 读取数据包
	 *  
	 * @param bytes
	 * @return 
	 * 
	 */	
	function readPacket(bytes : IDataInput) : DataPackage;
	
	
	
	/**
	 * 
	 * 处理数据包
	 *  
	 * @param command
	 * 
	 */	
	function handler(dataPackage:DataPackage,address : String,cmd : uint,content : XML) : DataPackage;
	
	
	
	/**
	 * 
	 * 写入数据包
	 *  
	 * @param taskPackage
	 * @return 
	 * 
	 */	
	function writePacket(dataPackage : DataPackage) : ByteArray;
	
}
}