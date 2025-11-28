package com.missiongroup.metro.core
{
	
import com.missiongroup.metro.utils.NetworkUtil;
import com.struts.utils.HashTable;

import flash.net.InterfaceAddress;
import flash.net.NetworkInfo;
import flash.net.NetworkInterface;
import flash.net.dns.AAAARecord;
import flash.system.Capabilities;

import mx.collections.ArrayCollection;

public class Setting
{
	
	public var City : String;
	
	public var IsAutoConnect : Boolean = true;
	
	public var KeepHeartBeatTimes : int;
	
	public var LocalAddress : String = "127.0.0.1";
	
	public var ServiceAddress : String;
	
	public var ServicePort : String;
	
	public var FileLoadUrl : String;

	public var LocalPort : String;
	
	public var StationId : String;
	
	public var LineNum : String;
	
	public var LineDir : String;
	
	public var LineColors : HashTable;
	
	public var DataPath : String;
	
	public var SystemInitUrl : String;
	
	public var idelSecond : Number = 20;

}

}
