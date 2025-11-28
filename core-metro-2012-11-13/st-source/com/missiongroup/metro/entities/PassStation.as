package com.missiongroup.metro.entities
{
public class PassStation
{
	
	public var Name : String;
	
	public var Line : String;
	
	public var LineColor : uint;
	
	public var Dir  : String;
	
	public var Type : int;
	
	public var Remark : String;
	
	
	private var _TypeName : String;

	public function get TypeName():String
	{
		if(Type == 1)
			return "起始";
		
		if(Type == 2)
			return "换乘";
		
		if(Type == 3)
			return "终点";
		
		return null;
	}
	
	
	public function PassStation()
	{
	}
}
}