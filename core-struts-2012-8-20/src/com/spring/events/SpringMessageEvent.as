package com.spring.events
{
import flash.events.Event;

public class SpringMessageEvent extends Event
{
	
	public var message : *;
	
	public function SpringMessageEvent(type:String, 
									   message : *,
									   bubbles:Boolean=false, cancelable:Boolean=false)
	{
		super(type, bubbles, cancelable);
		
		this.message = message;
		
	}
}
}