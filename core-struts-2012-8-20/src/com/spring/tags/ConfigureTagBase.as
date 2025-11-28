package com.spring.tags
{
import com.spring.managers.ControllerManager;
import com.spring.tags.model.TagBaseView;

import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.IEventDispatcher;

import mx.core.IMXMLObject;

public class ConfigureTagBase extends EventDispatcher implements IMXMLObject,
	                                                             IEventDispatcher
{
	private var sbm : ControllerManager = ControllerManager.getInstance();
	
	public function ConfigureTagBase(target:IEventDispatcher=null)
	{
		super(target);
	}
	
	public function initialized(document:Object, id:String):void
	{
		sbm.addTag(document,id);
	}
	

	
}

}







