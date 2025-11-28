package com.missiongroup.car.logger
{
import com.logging.LoggerHandlerAction;

public class TextLogger extends LoggerHandlerAction
{
	
	public function TextLogger()
	{
		super();
	}
	
	override public function handler(coutent : String) : void
	{
		super.handler(coutent);
		
	  /*if(!_debug) {
			_debug = new SerialportDebug();
			_debug.right = 0;
			IVisualElementContainer(FlexGlobals.topLevelApplication).addElement(_debug);		
	   }
		_debug.setInfo(coutent + "\n");*/

	}
	
}
}