package com.missiongroup.metro.entities
{
public class UserTime
{
	public var WaitTime : int;
	
	public var DriveTime : int;
	
	public function get TotalTime():int
	{
		return WaitTime + DriveTime;
	}
	
	public function UserTime()
	{
		WaitTime = 0;
		DriveTime = 0;
	}
}
}