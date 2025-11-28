package com.struts.events
{
import flash.events.DataEvent;
import flash.events.Event;

public class RecordEvent extends Event
{
	private var _data:Object;
	
	private var _callback:Function;
	
	public function get data():Object
	{
		return _data;
	}
	
	public function set data(value:Object):void
	{
		_data = value;
	}
	
	public function get callback():Function
	{
		return _callback;
	}
	
	public function set callback(value:Function):void
	{
		_callback = value;
	}
	
	public function RecordEvent(type:String, data:Object = null, callback:Function = null,
								bubbles:Boolean=false, cancelable:Boolean=false)
	{
		super(type, bubbles, cancelable);
		_data = data;
		_callback = callback;
	}

	public override function clone():Event
	{
		return new RecordEvent(this.type, this.data,this.callback,this.bubbles,this.cancelable);
	}
}

}



















