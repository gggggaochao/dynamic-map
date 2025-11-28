package com.struts.core
{


import com.struts.data.DataService;
import com.struts.entity.Session;
import com.struts.events.AppEvent;
import com.struts.interfaces.IModuleBase;

import flash.display.DisplayObject;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.SecurityErrorEvent;
import flash.utils.setTimeout;

import mx.collections.ArrayCollection;
import mx.core.ContainerLayout;
import mx.core.ScrollPolicy;
import mx.events.FlexEvent;
import mx.states.State;

import spark.modules.Module;

public class ModuleBase extends Module implements IModuleBase
{
	
	public var configXML:XML;
 	
	[Bindable]
	private var _moduleName : String;
	/**
	 * 模块名称，唯一性
	 *  
	 * @param value 模块图标的相对路径.
	 */		
	public function get moduleName():String
	{
		return _moduleName;
	}

	public function set moduleName(value:String):void
	{
		_moduleName = value;
	}

	
	private var _moduleIcon : String;
	/**
	 * 配置文件路径
	 *  
	 * @param value 模块配置文件的路径.
	 */
	public function get moduleIcon():String
	{
		return _moduleIcon;
	}

	public function set moduleIcon(value:String):void
	{
		_moduleIcon = value;
	}

	
	private var _moduleTitle : String;
	/**
	 * 模块标题
	 *  
	 * @param value 模块标题.
	 */
	public function get moduleTitle():String
	{
		return _moduleTitle;
	}

	public function set moduleTitle(value:String):void
	{
		_moduleTitle = value;
	}

	private var _source : Object;
	/**
	 * 模块参数
	 *
	 * @param value 配置节点的所有参数
	 */	
	public function set source(value:Object) : void
	{
		_source = value;
	}
	public function get source() : Object
	{ 
		return _source;
	}
	
	
	private var _user : Session;
	/**
	 * 用户信息
	 *
	 * @param value 用户客户的配置信息
	 */
	public function get user() : Session
	{
		return _user;
	}

	public function set user(value : Session):void
	{
		_user = value;
	}

	
	private var _widgetConfig : String;
	/**
	 * 配置文件路径
	 *  
	 * @param value 模块配置文件的路径.
	 */	
	public function set config(value:String):void
	{
		_widgetConfig = value;
	}
	
	public function get config():String
	{
		return _widgetConfig;
	}
	
	private var _layoutElement : String;
	/**
	 * 模块父节点ID
	 *  
	 * @param value 父节点名称
	 */		
	public function get layoutElement():String
	{
		return _layoutElement;
	}

	public function set layoutElement(value:String):void
	{
		_layoutElement = value;
	}
	
	
	private var _hasCreationComplete : Boolean = false;

	public function get hasCreationComplete():Boolean
	{
		return _hasCreationComplete;
	}

	
    public function ModuleBase()
    {
        super();
		
        addEventListener(FlexEvent.CREATION_COMPLETE, initWidgetTemplate);
    }
	
//	private function createState() : Array
//	{
//		var states : Array = [];
//		
//		states.push(new State({name : OPEN}));
//		states.push(new State({name : CLOSE}));
//		
//		return states;
//		
//	}

    private function initWidgetTemplate(event:Event):void
    {
		if(!configXML)
		{
			configLoad();
		}

//		var states : Array = this.states;
//		if(states == null)
//		{
//			states = [];
//		}
//		states = states.concat(createState());
//		this.states = states;		
		
    }
	
    /**
     * Set the widget state.
     * @param value the state string defined in BaseWidget.
     */
	
	private var _widgetState : String;
	
    public function setState(value:String):void
    {
        _widgetState = value;
//
//		if(value == OPEN || value == CLOSE)
//		{
//			this.currentState = value;
//			dispatchEvent(new Event(value));
//		}
	}

    private function configLoad() : void
    {
		if(_widgetConfig)
		{
			var conf : * = ModuleConf.confs.find(_widgetConfig);
			if(conf is XML)
			{
				configXML = conf as XML;

				loadComplete();
			}
			else
			{
				DataService.http(_widgetConfig,configResult);
			}
		}
		else
		{
			loadComplete();
		}
		
		
    }

    private function configResult(doc : XML):void
    {
        try
        {
            configXML = doc;
			
			var _moduleConfName : String = this.source.parent || this.source.name;
			ModuleConf.confs.add(_moduleConfName,configXML);
			ModuleConf.confs.add(_widgetConfig,configXML);

			loadComplete();
        }
        catch (error:Error)
        {
            //showError("A problem occurred while parsing the widget configuration file. " + error.message);
        }
    }

    public function setXYPosition(x:Number, y:Number):void
    {
        this.setLayoutBoundsPosition(x, y);
    }

    public function setRelativePosition(left:String, right:String, top:String, bottom:String):void
    {
        if (left)
        {
            this.left = Number(left);
        }
        if (right)
        {
            this.right = Number(right);
        }
        if (top)
        {
            this.top = Number(top);
        }
        if (bottom)
        {
            this.bottom = Number(bottom);
        }
    }
	
	private function loadComplete() : void
	{
		_hasCreationComplete = true;
		
		init();		
		
		//dispatchEvent(new AppEvent(AppEvent.MODULE_CREATION_COMPLETE))
	}
	
	public function init() : void
	{
		
	}
	
    public function open(queryString : *) : void
    {
        if(_hasCreationComplete == false)
			return;
    }
	
	public function close() : void
	{
		
	}

}

}
