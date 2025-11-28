package com.missiongroup.metro.command.imp
{
import com.missiongroup.metro.command.DataPackage;

public class DefaultDataPackage implements DataPackage
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

	
	public function DefaultDataPackage(cmd : uint,content : XML) : void
	{
		_Cmd = cmd;
		_Content = content;
	}

}
}