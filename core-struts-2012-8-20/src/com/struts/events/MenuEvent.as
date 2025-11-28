package com.struts.events
{
public class MenuEvent extends RecordEvent
{
	public static const MENU_CLICK : String = "menuClick";
	
	public function MenuEvent(type:String, data:Object=null, callback:Function=null, bubbles:Boolean=false, cancelable:Boolean=false)
	{
		super(type, data, callback, bubbles, cancelable);
	}
}
}