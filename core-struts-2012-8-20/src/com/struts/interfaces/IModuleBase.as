package com.struts.interfaces
{

import com.struts.entity.Session;

import flash.display.DisplayObject;
import flash.events.IEventDispatcher;

import mx.core.IUIComponent;

public interface IModuleBase extends IEventDispatcher
{
	/**
	 * 模块名称，唯一，可以通过该名称，加载模块
	 *  
	 * @param value 模块配置文件的路径.
	 */		
    function set moduleName(value:String):void;
    function get moduleName():String;

	/**
	 * 模块图标
	 *  
	 * @param value 模块图标的相对路径.
	 */	
    function set moduleIcon(value:String):void;
    function get moduleIcon():String;
	
	/**
	 * 模块标题
	 *  
	 * @param value 模块标题.
	 */
	function set moduleTitle(value:String):void;
	function get moduleTitle():String;

    /**
     * 配置文件路径
	 *  
     * @param value 模块配置文件的路径.
     */
    function set config(value:String):void;
    function get config():String;

    /**
     * 用户信息
     *
     * @param value 
     */
    function set user(value : Session):void;
    function get user() : Session;
	
	/**
	 * 与控件绑定的数据
	 *
	 * 
	 */
	function set source(value:Object):void;
	function get source():Object;
	
	
	
//	/**
//	 *  处理对象
//	 * 
//	 * */
//	function set handler(value : Object) : void;
//	function get handler() : Object;
	
	
//	function set runModule(value : String) : void;
//	function get runModule() : String;
	
	/**
	 * 
	 * 控件是否加载完毕
	 *  
	 * @return 
	 * 
	 */	
	function get hasCreationComplete() : Boolean;
	/**
	 * 模块父节点ID
	 *  
	 * @param value 父节点名称
	 */		
	function set layoutElement(value:String):void;
	function get layoutElement():String;	

	/**
	 * 设置模块的视图状态
	 *
	 * @param value 视图名称
	 */
    function setState(value:String):void;

	/**
	 * 设置模块的绝对
	 */
    function setXYPosition(x:Number, y:Number):void;

	/**
	 * 设置模块的相对位置
	 */
	function setRelativePosition(left:String, right:String, top:String, bottom:String):void;
    
	
	/**
	 * 
	 * 在初始化完成
	 * 以及配置文件加载完毕后调用 ,
	 * 只调用一次，调用一次后运行 open 方法
	 * 
	 */	
	function init() : void;
	
	/**
	 * 
	 * 模块每次 添加在主框架中调用
	 * 
	 * */
    function open(queryString : *):void;
	
	/**
	 * 
	 * 模块每次被移除后调用
	 * 
	 */	
	function close() : void;
	
}

}



















