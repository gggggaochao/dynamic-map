package com.missiongroup.metro.events
{
	
import com.missiongroup.metro.command.DataPackage;
import com.missiongroup.metro.servers.Services;

import flash.events.Event;


/**
 *  
 * @author ZhouHan
 * 
 */
public class ServicesEvent extends Event
{	

	/**
	 *  加载完成
	 */	
	public static const RUN_COMPLETE : String = "runComplete";

	/**
	 *  消息回复时间 
	 */	
	public static const REPLY : String = "reply";
	
	public var content : XML;
	
	public var cmd : uint; 
	
	public var command : DataPackage;
	
	public function ServicesEvent(type : String, 
								  content : XML = null,
								  cmd : uint = 0x01,
								  bubbles:Boolean=false, 
								  cancelable:Boolean=false)
	{
		super(type, bubbles, cancelable);
		
		this.content = content;
		this.cmd = cmd;
		
	}
	
}




}



