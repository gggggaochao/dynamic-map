package com.spring.core
{
import com.spring.managers.ControllerManager;

import flash.events.EventDispatcher;
import flash.events.IEventDispatcher;

public class Controller extends EventDispatcher
{
	
	private var cm : ControllerManager = ControllerManager.getInstance();
	
	public function Controller(id : String = null)
	{
		super();
		
		cm.addTag(this,id);
		
	}
	
}

}

