package com.missiongroup.metro.servers
{
	
import com.missiongroup.metro.core.IDynamicMsg;
import com.struts.core.WebApp;
import com.struts.events.AppEvent;

/**
 * 
 * 动态消息发布
 *  
 * @author ZhouHan
 * 
 */
public class DynamicMsgService extends Services
{
	
	private var dynamicMsg : IDynamicMsg;
	
	public function DynamicMsgService(cmds : Array)
	{
		super(cmds);
		
		WebApp.addEventListener(AppEvent.READY,readyHandler);
	}
	
	
	private function readyHandler(event : AppEvent) : void
	{
		var site : Object = event.data;
		if(site is IDynamicMsg)
		{
			dynamicMsg = site as IDynamicMsg;
		}
	}
	
	
	
}
}


















