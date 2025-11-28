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
package com.struts.managers
{
import com.spring.managers.SpringBeanManager;
import com.struts.WebSite;
import com.struts.data.DataService;
import com.struts.entity.ConfigData;
import com.struts.entity.SystemInfo;
import com.struts.events.AppEvent;
import com.struts.utils.XMLUtil;

import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.IOErrorEvent;
import flash.events.SecurityErrorEvent;
import flash.external.ExternalInterface;
import flash.net.URLRequest;
import flash.net.navigateToURL;

[Event(name="configLoaded", type="com.struts.events.AppEvent")]

/**
 * 系统的主配置
 *
 * The name of the default configuration file is specified in ViewerContainer.mxml.
 */
public class ConfigManager extends EventDispatcher
{

	private var configData : ConfigData;
	
	private var configXML : XML;
	
	private var configFilesList : Array;
	
	
	/**
	 *  配置文件的路径
	 * */
	private var _configFile : String;

	public function set configFile(value:String):void
	{
		_configFile = value;
	}
		
    public function ConfigManager()
    {
        super();

        WebSite.addEventListener(WebSite.CONTAINER_INITIALIZED, init);
    }
	
	//init - start loading the configuration file and parse.
    public function init(event:Event):void
    {
		configData = new ConfigData();
		configXML = new XML("<configuration />"); 
		configFilesList = new Array();
		
		if(_configFile){
			configFilesList = _configFile.split(",");
		}
		
		readConfigToDocument();
    }
	
	
	private function readConfigToDocument() : void
	{
		if (configFilesList.length)
		{
			var filePath : String = configFilesList[0];
			configFilesList.splice(0, 1);
			DataService.http(filePath,addChildNode);
		}
		else
		{
			configResultHandler();
		}	
	}

	private function addChildNode(node : XML) : void	
	{
		var childrenList : XMLList = node.children();
		configXML.appendChild(childrenList);
		
		readConfigToDocument();
	}



    //config result
    public function configResultHandler():void
    {
        try
        {

//			var i:int;
//			var j:int;
			
			var node : XML;
			var nodeList : XMLList;
					
			/**
			 *   加载系统信息配置
			 * 
			 * */
			if(configXML.system)
			{
				var system : SystemInfo = new SystemInfo();
				
				var protypes : XMLList = XML(configXML.system[0]).children();
				for each(var protype : XML in protypes)
				{
					var feild : String = protype.localName();
					if(system.hasOwnProperty(feild)) {
						system[feild] = protype.toString();
					}
				}
				
				WebSite.System = system;
			}
			
			/**
			 *   加载系统布局配置
			 * 
			 * */			
			nodeList = configXML.layouts.protype;
			
			configData.frameworks = getProtypes(nodeList);

			/**
			 *   加载系统登录配置
			 * 
			 * */	
			nodeList = configXML.login;
			
			if(nodeList.length())
			{
				configData.loginWidget = XMLUtil.toAttribute(nodeList);
			}

			/**
			 *   加载系统模块配置
			 * 
			 * */	
			nodeList = configXML.widgets.protype;
			
			configData.widgets = getProtypes(nodeList);
			
			
			
			//================================================
			// WebService : WebService 配置信息
			//================================================
			/**
			 * 
			 *	远程对象访问配置 
			 *  WebService 访问配置 remote-serivce services  services
			 * 
			 * */
			var remoteNodes : XMLList = configXML["remote-services"];
			if(remoteNodes.length())
			{
				DataService.loadRemote(remoteNodes[0]);
			}
			
			var webServices : XMLList = configXML["webService-services"];
			if(webServices.length())
			{
				DataService.loadWebServices(webServices);
			}
	
			var springBeans : XMLList = configXML.bean;
			if(springBeans.length())
			{
				SpringBeanManager.getInstance().load(springBeans);
			}
			
				
			
			WebSite.dispatchEvent(new AppEvent(AppEvent.CONFIG_LOADED, configData));

        }
        catch (error:Error)
        {
			trace(error.getStackTrace());
            WebSite.showError(error.message);
        }
    }
	
	
	public function getProtypes(protypes : XMLList) : Array
	{
		
		var protypeArray : Array = [];
		
		for each(var protype : XML in protypes)
		{ 
			var _data : Object = XMLUtil.toAttribute(protype);
			var _parameter : XMLList = protype.parameter;
			if(_parameter.length())
			{
				_data.parameter = XMLUtil.toAttribute(_parameter[0]);
			}
			protypeArray.push(_data);
		}		
		
		return protypeArray;
	
	}

}

}
