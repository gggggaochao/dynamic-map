package com.missiongroup.metro.command
{
public interface DataPackage
{
	function set Cmd(value : uint) : void;
	function get Cmd() : uint;

	function set Content(value : XML) : void;
	function get Content() : XML;
}
}