package com.logging
{
import com.struts.utils.DateUtil;
import com.struts.utils.StringBundleUtil;

import flash.events.EventDispatcher;
import flash.events.IEventDispatcher;

import mx.logging.ILogger;
import mx.logging.Log;
import mx.logging.LogEventLevel;
import mx.logging.targets.TraceTarget;
import mx.utils.ObjectUtil;
import mx.utils.StringUtil;

public class LoggerHandlerAction extends EventDispatcher implements Logger
{
	
	
	public function LoggerHandlerAction()
	{
		super();
	}
	
	
	public function initLogging():void
    {
        var logTarget:TraceTarget = new TraceTarget();

        logTarget.filters = [ "mx.rpc.*", "mx.messaging.*" ];
        logTarget.level = LogEventLevel.FATAL;
        logTarget.includeDate = true;
        logTarget.includeTime = true;
        logTarget.includeCategory = true;
        logTarget.includeLevel = true;

        Log.addTarget(logTarget);
		
    }

	
	public function info(message:String, ...rest):void
	{
		log(LoggerLevel.INFO,message,rest);
	}
	
	public function fatal(message:String, ...rest):void
	{
		log(LoggerLevel.FATAL,message,rest);
	}
	
	public function debug(message:String, ...rest):void
	{
		log(LoggerLevel.DEDUG,message,rest);
	}
	
	public function error(message:String, ...rest):void
	{
		log(LoggerLevel.ERROR,message,rest);
	}
	
	public function warn(message:String, ...rest):void
	{
		log(LoggerLevel.WARN,message,rest);
	}
	
	public function log(level:String, message:*, ...rest):void
	{
		var content : String = new String();
		var count : int;
		var i : int;
		if(message is String)
		{
			content = StringUtil.substitute(message,rest);
		}
		else
		{
			var qNames : Array = ObjectUtil.getClassInfo(message).properties as Array;
			var qName  : QName;
			var properties : String;
			var properitesValue : String;
			count = qNames.length;
			
			for (i = 0;i<count;i++)
			{
				qName = qNames[i];
				properties = qName.localName;
				content += properties + "=" + message[properties] + "#";
			}
			
			var contentLen : int = content.length;
			if(contentLen > 0)
			{
				content = content.substr(0,contentLen - 1);
			}
		}
		
		var newDate : String = DateUtil.dateToString(new Date());
		
		content = StringBundleUtil.replace(content,"\n"," ",true);
		count = Math.ceil(content.length / 750);
		
		var str : String;
		var msg : String;
		
		var startIndex : int = 0;
		for (i = 0 ; i< count;i++)
		{
			str = content.slice(startIndex,startIndex+750);
			msg = newDate + " " + level + " " + str;
			startIndex = startIndex + 750;
			
			handler(msg);
		}
	}
	
	
	public function handler(coutent : String) : void
	{
		trace(coutent);
	}
	
}

}







