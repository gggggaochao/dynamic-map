package com.struts.interfaces
{
import flash.events.IEventDispatcher;

	
public interface IConfig extends IEventDispatcher
{

	/**
	 * 配置文件路径
	 *  
	 * @param value 模块配置文件的路径.
	 */
	function set path(value:String) : void;
	function get config() : XML;
	
}
}










