
package com.struts.interfaces
{

import com.struts.entity.SystemInfo;

import flash.display.DisplayObject;

import mx.core.IUIComponent;
import mx.core.IVisualElement;

public interface ILayout extends IModuleBase,IWebSite
{

	/**
	 * 模块名称，唯一，可以通过该名称，加载模块
	 *  
	 * @param value 模块配置文件的路径.
	 */		
    function set layoutName(value:String):void;
    function get layoutName():String;
	
}

}



















