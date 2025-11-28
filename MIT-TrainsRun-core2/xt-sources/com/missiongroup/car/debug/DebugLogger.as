package com.missiongroup.car.debug
{
import com.logging.LoggerHandlerAction;

import mx.core.FlexGlobals;
import mx.core.IVisualElementContainer;

public class DebugLogger extends LoggerHandlerAction
{
	
	private var displayLogger : DisplayLogger;
	
	public function DebugLogger()
	{
		super();
		
		displayLogger = new DisplayLogger();
		IVisualElementContainer(FlexGlobals.topLevelApplication).addElement(displayLogger);			
	}
	
	
	
	
	override public function handler(content : String) : void
	{
		super.handler(content);
		displayLogger.setInfo(content);

	}
	
}
}