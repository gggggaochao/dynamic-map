package com.struts.components
{
import com.struts.interfaces.IConfig;

import flash.events.Event;

import mx.events.FlexEvent;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;
import mx.rpc.http.HTTPService;

import spark.components.Group;

[Event(name="configComplete", type="flash.events.Event")]

public class ConfigGroup extends Group implements IConfig
{
	public function ConfigGroup()
	{
		super();
		
		addEventListener(FlexEvent.CREATION_COMPLETE,completeHandler);
	}

	private var _config : XML;

	public function get config():XML
	{
		return _config;
	}

	private var _path : String;
	
	public function set path(value:String):void
	{
		_path = value;
	}
	
	private function completeHandler(event : Event) : void
	{
		configLoad();
	}
	
	private function configLoad() : void
	{
		if (_path)
		{
			var configService:HTTPService = new HTTPService();
			configService.url = _path;
			configService.resultFormat = "e4x";
			configService.addEventListener(ResultEvent.RESULT, configResult);
			configService.send();
		}
		else
		{
			dispatchEvent(new Event("configComplete"));
		}
	}
	
	private function configResult(event:ResultEvent):void
	{
		try
		{
			_config = event.result as XML;
			dispatchEvent(new Event("configComplete"));
		}
		catch (error:Error)
		{
			
		}
	}
}

}






