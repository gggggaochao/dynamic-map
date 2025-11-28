package com.struts.core
{


import com.struts.entity.SystemInfo;

import flash.display.DisplayObject;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.SecurityErrorEvent;
import flash.utils.setTimeout;

import mx.collections.ArrayCollection;
import mx.core.INavigatorContent;
import mx.core.IUIComponent;
import mx.core.IVisualElement;
import mx.events.FlexEvent;
import mx.modules.Module;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;
import mx.rpc.http.HTTPService;
import mx.states.State;
import com.struts.interfaces.ILayout;


public class LayoutBase extends ModuleBase  implements ILayout
{
	
	
	public function addComponents(child:IVisualElement):void
	{
		
		
	}
	
	private var _isframe : Boolean;

	public function get isframe():Boolean
	{
		return _isframe;
	}

	public function set isframe(value:Boolean):void
	{
		_isframe = value;
	}
	
	private var _layoutName : String;

	public function get layoutName():String
	{
		return _layoutName;
	}

	public function set layoutName(value:String):void
	{
		_layoutName = value;
	}

	
	private var _system : SystemInfo;

	public function get system():SystemInfo
	{
		return _system;
	}

	public function set system(value:SystemInfo):void
	{
		_system = value;
	}

	
}

}
