////////////////////////////////////////////////////////////////////////////////
//
// Copyright (c) 2010 ESRI
//
// All rights reserved under the copyright laws of the United States.
// You may freely redistribute and use this software, with or
// without modification, provided you include the original copyright
// and use restrictions.  See use restrictions in the file:
// <install location>/License.txt
//
////////////////////////////////////////////////////////////////////////////////
package com.struts.events
{

import flash.events.Event;

/** 
	系统主事件，主要用于系统组件之间的传值
*/
public class AppEvent extends Event
{

	/**
	 *   系统错误事件
	 * 
	 * */
    public static const APP_ERROR:String = "appError";
	
	/**
	 *   主配置文件加载指令
	 *   
	 *   在程序主入口执行
	 */		
	public static const CONTAINER_INITIALIZED:String = "containerInitilized";
	
	
	/**
	 *   皮肤配置文件加载指令
	 *   
	 *   在程序主入口执行
	 */		
	public static const SKINS_INITIALIZED:String = "skinsInitilized";
	
	/**
	 *  初始化必备数据完成
	 * 
	 * */
	public static const INIT_CACHEDATA_LOADED : String = "initCacheDataLaoded";
	
    /**
     *  系统主配置文件加载完毕后，抛出事件
     *
     * 	 在ConfigManager 类中抛出
     */
    public static const CONFIG_LOADED:String = "configLoaded";

	/**
	 *  系统皮肤配置文件加载完毕后，抛出事件
	 *
	 * 	 在UIManager 类中抛出
	 */
	public static const SKINS_LOADED:String = "skinsLoaded";

	
	/**
	 *   开始加载模块组件
	 */	
	public static const COMPONENTS_INITIALIZED : String = "systemInit";

	
	/**
	 *   所有系统参数加载完毕后触发，
	 *   其中包括用户信息，和配置文件信息
	 */		
	public static const CONFIGDATA_READY : String = "configDataReady";
	
	
	/**
	 *   全部组件和布局控件加载完毕后触发
	 */	
	public static const READY : String = "webAppReady";
	
	
	/**
	 *   所以控件加载完毕后触发
	 */	
	public static const MODULE_RUN : String = "moduleRun";
		
	
	/**
	 *  切换显示语言完成 
	 */	
	public static const LANGUAGE_CUT_COMPLATE : String = "languageCutComplete";
	
	/**
	 *  添加StringBundle事件
	 */	
	public static const LANGUAGE_ADD_STRINGBUNDLE : String = "languageAddStringBundle";
	
	/**
	 *  切换显示语言
	 */	
	public static const LANGUAGE_CUT : String = "languageCut";
	
	/**
	 *   用户登录事件
	 * */
	public static const USER_LOGIN_SUCCESS : String = "userLoginSuccess";	
	
	/**
	 *   用户注销事件
	 * */
	public static const USER_LOGOUT : String = "userLogout";	
	
	/**
	 *   用户退出系统事件
	 * */
	public static const USER_LEAVE : String = "userLeave";	

	
	/**
	 * 
	 * 模块完成所有初始化工作后调用 
	 * 
	 */	
	//public static const MODULE_CREATION_COMPLETE : String = "moduleCreateComplete";
	
	
	/**
	 * 
	 * 模块open 显示试图完成后调用
	 * 
	 */	
	public static const MODULE_OPEN : String = "moduleOpen";
	
	
	/**
	 * 
	 * 模块卸载事件
	 *  
	 */	
	public static const MODULE_UNLOAD : String = "moduleunload";
	
	
	/**
	 * 
	 * 模块组件更新事件
	 *  
	 */	
	public static const MODULE_WIDGET_CHANGE : String = "moduleWidgetsChange";
	
	
	/**
	 * 
	 * 模块框架更新事件
	 *  
	 */	
	public static const MODULE_SKINS_CHANGE : String = "moduleSkinsChange";
	
	/**
	 * 
	 *  模块正在加载过程中调用 
	 *
	 */	
	public static const MODULE_OPENING : String = "moduleOpenning";
	
	
	
	/**
	 *  加载所有模块 
	 */	
	public static const OPEN_ALL_MODULE : String = "openAllModule";
	
	
	/**
	 *  加载所有模块完成 
	 */		
	public static const OPEN_ALL_MODULE_COMPLETE : String = "openAllModuleComplete";
	
	
	/**
	 *  
	 *   Spring Bean依赖注入完成事件
	 * 
	 * */
	public static const SPRING_COMPLETE : String = "springComplete";
	
	
	
	
	
	
	
    public function AppEvent(type:String, data:Object = null, callback:Function = null)
    {
        super(type, false, false);
        _data = data;
        _callback = callback;
    }

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    private var _data:Object;

    private var _callback:Function;

    /**
     * The data will be passed via the event. It allows the event dispatcher to publish
     * data to event listener(s).
     */
    public function get data():Object
    {
        return _data;
    }

    /**
     * @private
     */
    public function set data(value:Object):void
    {
        _data = value;
    }

    /**
     * The callback function associated with this event.
     */
    public function get callback():Function
    {
        return _callback;
    }

    /**
     * @private
     */
    public function set callback(value:Function):void
    {
        _callback = value;
    }

    public override function clone():Event
    {
        return new AppEvent(this.type, this.data);

    }
}

}
