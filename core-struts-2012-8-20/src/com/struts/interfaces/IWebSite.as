package com.struts.interfaces
{
import flash.events.IEventDispatcher;

import mx.core.IVisualElement;

public interface IWebSite extends IEventDispatcher
{
	/**
	 * 添加组件方法
	 *  
	 * @param value 模块组件.
	 */		
	function addComponents(child : IVisualElement) : void;
}
}