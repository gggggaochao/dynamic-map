package com.logging
{
	import com.struts.WebSite;
	


public class LoggerManager
{
	
	public static var logger : Logger;
	
	public function LoggerManager()
	{
		throw new Error("LoggerManager is a singleton. Use LoggerManager.getInstance() to obtain an instance of this class.");			
	}
	
	public static function getInstance() : Logger
	{
		return logger;
	}
}
}