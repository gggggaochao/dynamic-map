package com.missiongroup.metro.servers
{

import com.logging.Logger;
import com.logging.LoggerManager;
import com.missiongroup.metro.command.DataPackage;
import com.missiongroup.metro.command.consts.Command;
import com.missiongroup.metro.core.Setting;
import com.missiongroup.metro.dao.SQLiteDao;
import com.missiongroup.metro.events.ServicesEvent;
import com.spring.managers.ControllerManager;
import com.spring.managers.EntityManager;

//import flash.events.Event;
import flash.events.EventDispatcher;

import mx.utils.StringUtil;


[Event(name="serviceComplete", type="com.missiongroup.ipis.events.ServicesEvent")]


[Event(name="reply", type="com.missiongroup.ipis.events.ServicesEvent")]



public class Services extends EventDispatcher
{	

	public var em : EntityManager;
	
	public var logger : Logger = LoggerManager.getInstance();
	
	public var dispatcher : Function = ControllerManager.getMessageDispatcher();
	
	public var dao : SQLiteDao;
	
	public var setting : Setting;

	public var cmd : uint;
	
	public var handlerCmds : Array = new Array();
	
	public function Services(cmds : Array)
	{
		if(cmds)
		{
			this.handlerCmds = cmds;
		}
	}
	
	


	private var _command : DataPackage;

	public function get command() : DataPackage
	{
		return _command;
	}

	public function set command(value : DataPackage):void
	{
		if(value == null)
			return;
		
		_command = value;
		commandHandler();
	}
	
	
	public function commandHandler():void
	{
		
	}
	
	
	
	public function run() : void
	{
		complete();
	}
	
	
	public function complete() : void
	{
		if(hasEventListener(ServicesEvent.RUN_COMPLETE))
		{
			dispatchEvent(new ServicesEvent(ServicesEvent.RUN_COMPLETE));
		}
	}
	
	
	public function replyToServer(replyContent : String,isSuccess : int = 1) : void
	{
		if(hasEventListener(ServicesEvent.REPLY))
		{
			var content : String = StringUtil.substitute(Command.REPLY_TEMPLETA,isSuccess,replyContent);
			
			var event : ServicesEvent = new ServicesEvent(ServicesEvent.REPLY);
			event.command = _command;
			event.content = new XML(content);
			
			dispatchEvent(event);
			
		}
	}
	
}
}



























