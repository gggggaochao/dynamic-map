
////////////////////////////////////////////////////////////////////////////////
//
//  MissionGroup Copyright 2012 All Rights Reserved.
//
//  NOTICE: MIT MissionGroup permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////
package com.struts.core
{
	import com.struts.components.TipTool;
	
	import flash.events.Event;
	
	import mx.core.IVisualElementContainer;
	
	/**
	 * 全局事件转发类
	 * 单态模式
	 *
	 * @author Han.Zhou
	 * @email zhouhan102@163.com || zhouhan@missiongroup.com.cn
	 * @date 2012-4-18 下午04:47:22 
	 *
	 */
	
	public class WebApp
	{
		private static const tipTool : TipTool = new TipTool();
		
		public static function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void
		{
			EventBus.getInstance().addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		
		public static function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void
		{
			EventBus.getInstance().removeEventListener(type, listener, useCapture);
		}
		
		public static function hasEventListener(type:String) : Boolean
		{
			return EventBus.getInstance().hasEventListener(type)
		}
		
		public static function dispatch(message:String):Boolean
		{
			return EventBus.getInstance().dispatch(message);
		}
		
		public static function dispatchEvent(event:Event):Boolean
		{
			return EventBus.getInstance().dispatchEvent(event);
		}
		
		
		public static function tip(msg : String,
								   autoClear : Boolean = true,
								   offset : Number = 20,
								   showMode : String = "center",
								   parentEle : IVisualElementContainer = null,
								   delay : Number = 9000) : void
		{
			tipTool.show(msg,autoClear,showMode,offset,parentEle,delay);
		}
		
		
		public static function clearTip() : void
		{
			tipTool.clear();
		}
	}
}






