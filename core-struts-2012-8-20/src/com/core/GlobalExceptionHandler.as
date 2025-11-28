package com.core
{
	
import com.logging.Logger;
import com.logging.LoggerManager;

import flash.display.LoaderInfo;
import flash.events.UncaughtErrorEvent;
import flash.utils.getQualifiedClassName;

import mx.managers.ISystemManager;
	
[Mixin]	
public class GlobalExceptionHandler
{
	public var preventDefault:Boolean;
	
	private static var loaderInfo:LoaderInfo;
	
	private static var logger : Logger;
	
	public function GlobalExceptionHandler()
	{
		loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR,uncaughtErrorHandler);
	}
	
	public static function init(sm:ISystemManager):void
	{
		loaderInfo = sm.loaderInfo;
	}
	
	private function uncaughtErrorHandler(event:UncaughtErrorEvent):void
	{
		if (event.error is Error)
		{
			var error:Error = event.error as TypeError;

			if(!logger)
				logger = LoggerManager.getInstance();
			
			var errorMessage : String = Error.getErrorMessage(error.errorID);
			logger.error("GlobalErrorID : "+error.errorID + " " + errorMessage + " " +error.getStackTrace());
		}

		
		if (preventDefault == true)
		{
			event.preventDefault();
		}
	}
}

}



