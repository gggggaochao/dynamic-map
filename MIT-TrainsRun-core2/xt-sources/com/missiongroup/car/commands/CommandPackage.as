package com.missiongroup.car.commands
{
import com.missiongroup.metro.command.DataPackage;

public class CommandPackage implements DataPackage
{
	
	private var _Cmd : uint;

	public function get Cmd():uint
	{
		return _Cmd;
	}

	public function set Cmd(value:uint):void
	{
		_Cmd = value;
	}
	
	private var _Content : XML;	
	
	public function get Content():XML
	{
		return _Content;
	}
	
	public function set Content(value:XML):void
	{
		_Content = value;
	}
	
//	public var LineNum : uint;
//	
//	public var Dir : uint;
//	
//	public var StartStation : uint;
//	
//	public var CurrStation : uint;
//	
//	public var NextStation : uint;
//	
//	public var EndStation : uint;
//	
//	public var DoorDir : uint;
	
}
}