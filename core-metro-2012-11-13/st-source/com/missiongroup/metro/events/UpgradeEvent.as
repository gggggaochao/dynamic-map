package com.missiongroup.metro.events
{
	
import flash.events.Event;


/**
 *  
 * @author ZhouHan
 * 
 */
public class UpgradeEvent extends Event
{	
	
	
	/**
	 *  正在升级中 
	 */	
	public static const UPDATEING : String = "upgrageing";
	
	
	/**
	 *  升级完成 
	 */	
	public static const UPGRADE_COMPLETE : String = "upgradeComplete";
	
	
	public var data : Object;
	
	public function UpgradeEvent(type : String, 
								 data : Object = null,
								 bubbles:Boolean=false, 
								 cancelable:Boolean=false)
	{
		super(type, bubbles, cancelable);
		
		this.data = data;
		
	}
}
}