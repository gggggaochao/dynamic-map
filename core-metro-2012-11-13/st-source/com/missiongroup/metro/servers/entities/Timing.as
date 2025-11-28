package com.missiongroup.metro.servers.entities
{
	
public class Timing
{
	/**
	 * 运行参数
	 */	
	public var parameters : Array;
	
	/**
	 * 运行函数 
	 */	
	public var run : Function;
	
	/**
	 * 是否循环调用 
	 */	
	public var isLoop : Boolean;
	
	/**
	 * 运行日期 
	 */	
	public var date : String;
	
	/**
	 * 是否为农历 
	 */	
	public var isLunar : Boolean;
	
	/**
	 *  周期 
	 */	
	public var cycle : int;
	
	
	public function Timing(date : String,
						   run : Function,
						   isLunar : Boolean = false,
						   parameters : Array = null) : void
	{
		this.date = date;
		this.run = run;
		this.isLunar = isLunar;
		this.parameters = parameters;
	}

}
}