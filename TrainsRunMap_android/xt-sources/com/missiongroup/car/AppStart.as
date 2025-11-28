package com.missiongroup.car
{

import com.missiongroup.car.commands.CommandFactroy;
import com.missiongroup.car.core.AppSetting;
import com.missiongroup.car.managers.SerialportServiceManager;
import com.missiongroup.car.services.CMDServices;
import com.missiongroup.car.utils.HelperUtils;
import com.missiongroup.metro.dao.SQLiteDao;
import com.missiongroup.metro.managers.SocketServicesManager;
import com.struts.WebSite;
import com.struts.events.AppEvent;
import com.struts.managers.Global;

import flash.events.Event;

public class AppStart implements Global
{
	private var setting : AppSetting;
	
	private var dao : SQLiteDao;

	private var sys : SocketServicesManager;	
	
	public function AppStart()
	{
		WebSite.addEventListener(AppEvent.READY,appReadyHandler);
	}
	
	private function appReadyHandler(event : Event) : void {
		HelperUtils.initCacheStation("3");
		HelperUtils.initCacheStation("4");
		HelperUtils.initCacheStation2("4_2","up");
		HelperUtils.initCacheStation2("4_2","down");
	}
	
	public function start():void
	{
		sys = new SerialportServiceManager(new CommandFactroy());
		
//		sys = new SocketServicesManager(new CommandFactroy());	
		sys.addServices(new CMDServices());
		
		sys.run();
		
		//WebSite.initializeComponents();
	}
	
	public function end():void
	{
	}
}
}