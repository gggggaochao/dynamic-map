package com.spring.tags.view
{
import com.spring.tags.ConfigureTagBase;

import flash.events.IEventDispatcher;

public class ConfigureTag extends ConfigureTagBase
{
	public function ConfigureTag(target:IEventDispatcher=null)
	{
		super(target);
	}
	
	override public function initialized(document:Object, id:String):void
	{
		super.initialized(document,id);
	}
	
}
}