package com.struts.events
{

import flash.events.Event;

import mx.core.IVisualElement;

public class FrameEvent extends Event
{
	
	/**
	 * 
	 * 当模块加载完毕后，并在FrameBase AddElement后调用 
	 * 
	 */	
	public static const MODULE_ADD_FRAME : String = "moduleAddToFrame";
	
	/**
	 * 
	 * 当模块从  FrameBase 移除后调用
	 * 
	 */	
	public static const MODULE_REMOVE_FRAME : String = "moduleRemoveToFrame";
	
	
	public function FrameEvent(type:String, module : IVisualElement)
	{
		super(type, false, false);
		
		_module = module;
		
	}
	
	private var _module : IVisualElement;
	
	public function get module():IVisualElement
	{
		return _module;
	}
	
	public function set module(value:IVisualElement):void
	{
		_module = value;
	}
	
}
}