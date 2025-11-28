package com.struts.events
{
public class VideoPalyEvent extends RecordEvent
{
	
	public static const PALY_OVER : String = "playOver";
	
	public static const PALY_STOP : String = "playStop";
	
	public static const PALY_START : String = "playStart";
	
	public function VideoPalyEvent(type:String, data:Object=null, callback:Function=null, bubbles:Boolean=false, cancelable:Boolean=false)
	{
		super(type, data, callback, bubbles, cancelable);
	}
}
}