package com.missiongroup.metro.managers
{
import com.logging.Logger;
import com.logging.LoggerManager;
import com.missiongroup.metro.command.consts.Command;
import com.missiongroup.metro.core.AppCache;
import com.missiongroup.metro.core.Setting;
import com.missiongroup.metro.dao.SQLiteDao;
import com.missiongroup.metro.events.ServicesEvent;
import com.missiongroup.metro.servers.DynamicMsgService;
import com.missiongroup.metro.servers.NativeProcessService;
import com.missiongroup.metro.servers.OnLineUpdateService;
import com.missiongroup.metro.servers.Services;
import com.missiongroup.metro.servers.TrainService;
import com.missiongroup.metro.utils.NetworkUtil;
import com.spring.core.Controller;
import com.spring.managers.ControllerManager;
import com.spring.managers.EntityManager;
import com.struts.WebSite;
import com.struts.events.AppEvent;

import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.SecurityErrorEvent;
import flash.events.TimerEvent;
import flash.net.Socket;
import flash.utils.Endian;
import flash.utils.Timer;


[Event(name="reply", type="com.missiongroup.metro.events.ServicesEvent")]

[Event(name="complete", type="flash.events.Event")]

public class ServicesManager extends Controller
{
	
	[Bean(id="setting")]
	public var setting : Setting;
	
	[Bean(id="dataSource")]
	public var dao : SQLiteDao;
	
	[EntityManager(dataSet="dataSet")]
	public var em : EntityManager;
	
	public static const COMPLETE : String = "complete";
	
	private var doFilters : Array;
	
	public var servers : Array;
	
	public var logger : Logger = LoggerManager.getInstance();
	
	public var dispatcher : Function = ControllerManager.getMessageDispatcher();
	
	public var trainService:TrainService;
	
	public function ServicesManager(id:String=null)
	{

		super();
		
		try
		{

			//setting.LocalAddress = NetworkUtil.address();
			
			servers = new Array();

			/**
			 * 基础数据服务
			 * */
			trainService = new TrainService([Command.Metro_Data]);
			servers.push(trainService);


		}
		catch(error : Error)
		{
			logger.error(error.message);
		}
	}
	
	/**
	 * 
	 * 加载其他服务
	 *  
	 * @param services
	 * 
	 */	
	public function addServices(services : Services) : void
	{
		if(services == null)
			return;
		
		servers.push(services);
	}
	
	public function run() : void
	{	

		try {
			
			/**
			 * 本地进程服务，重启,待机,注销
			 * */
			//servers.push(new NativeProcessService([Command.ReStart,Command.ShutDown]));
			
			/**
			 * 自动升级服务
			 * */
			//servers.push(new OnLineUpdateService([Command.Online_Update]));
			
			doFilters = new Array();
			
			for each(var service : Services in servers)
			{
				service.em = em;
				service.dao = dao;
				service.setting = setting;
				service.addEventListener(ServicesEvent.RUN_COMPLETE,serviceCompleteHandler);
				service.addEventListener(ServicesEvent.REPLY,servicesReplyHandler);
				doFilters.push(service);
			}
			doNextServices();	
		}
		catch(e:TypeError) {
			logger.info("ServicesManager [run]:"+e.message+"->"+e.getStackTrace());			
		}
	
	}
	
	/**
	 *
	 * 服务端指令回复处理
	 *  
	 * @param event
	 * 
	 */
	private function servicesReplyHandler(event : ServicesEvent) : void
	{
		if(hasEventListener(ServicesEvent.REPLY))
		{
			var service : Services = event.currentTarget as Services;
			
			var e : ServicesEvent = new ServicesEvent(ServicesEvent.REPLY);
			e.command = event.command;
			e.content = event.content;
			e.cmd = event.cmd;
			
			dispatchEvent(e);
		}
	}
	
	
	private function serviceCompleteHandler(event : Event) : void
	{
		var service : Services = event.currentTarget as Services;
		service.removeEventListener(ServicesEvent.RUN_COMPLETE,serviceCompleteHandler);
		
		doNextServices();
	}
	
	private function doNextServices() : void
	{
		if (doFilters.length)
		{
			var servers : Services = doFilters.shift();
			servers.run();
			logger.info("ServicesManager [setting]:"+servers.cmd);
		}
		else
		{
			doFilters = null;
			
			if(hasEventListener(COMPLETE))
				dispatchEvent(new Event(COMPLETE));
			
			WebSite.initializeComponents();
		}
	}
	

	
	

}

}


