package com.struts.managers
{


import com.struts.WebSite;
import com.struts.data.DataService;
import com.struts.events.AppEvent;
import com.struts.utils.HashMap;
import com.struts.utils.HashTable;

import flash.events.Event;
import flash.events.EventDispatcher;
import flash.utils.setTimeout;

import mx.containers.Accordion;
import mx.containers.TabNavigator;
import mx.controls.AdvancedDataGrid;
import mx.controls.ColorPicker;
import mx.controls.DateChooser;
import mx.controls.DateField;
import mx.controls.ProgressBar;
import mx.controls.Tree;
import mx.core.FlexGlobals;
import mx.core.UIComponent;
import mx.rpc.events.ResultEvent;
import mx.styles.CSSStyleDeclaration;
import mx.styles.IStyleManager2;

import spark.components.Button;
import spark.components.CheckBox;
import spark.components.ComboBox;
import spark.components.DataGrid;
import spark.components.Form;
import spark.components.FormItem;
import spark.components.HSlider;
import spark.components.Image;
import spark.components.NumericStepper;
import spark.components.RadioButton;
import spark.components.TextArea;
import spark.components.TextInput;
import spark.components.VSlider;
import spark.primitives.BitmapImage;

public class UIManager extends EventDispatcher
{
    private var faceConfig : XML;
	
	private var data : Object;
	
	private var topLevelStyleManager:IStyleManager2;

	/**
	 *  皮肤配置文件
	 * 
	 * */
	private var _skinsFile : String;

	public function get skinsFile():String
	{
		return _skinsFile;
	}

	public function set skinsFile(value:String):void
	{
		_skinsFile = value;
	}

	
	private var _faceFile : String;

	public function get faceFile():String
	{
		return _faceFile;
	}

	public function set faceFile(value:String):void
	{
		_faceFile = value;
	}

	
    public function UIManager()
    {
        super();
		
        WebSite.addEventListener(AppEvent.SKINS_INITIALIZED, init);
    }

    private function init(event:Event):void
    {
		if(_skinsFile)
		{
			DataService.http(_skinsFile,configFace);
		}
		else
		{
			skinsLoadComplete();
		}
    }
	
	private function configFace(_faceConfig : XML) : void
	{
		faceConfig = _faceConfig;
		setViewerStyle();
	}

    private function setViewerStyle():void
    {
        topLevelStyleManager = FlexGlobals.topLevelApplication.styleManager;
		
		var dataXMLList : XMLList = faceConfig.data;
		var dataXML : XML = dataXMLList[0];
		data = {};
		
		var createData : Function = function(val:String,type:String) : Object 
		{
			var value : Object;
			if(type == "string")
				value = val;
			else if(type == "number")
				value = Number(val);
			else
				value = uint(val);	
			
			return value;
		}
		for each(var val : XML  in dataXML.children())
		{
			var type : String = val.@type;
			var datatype : String = val.@data;
			if(datatype == "array")
			{
				var temps : Array = val.toString().split(",");
				var t : Array = [];
				for each( var v : String in temps)
				{
					t.push(createData(v,type));
				}
				data[val.localName()] = t;
			}
			else
			{
				data[val.localName()] = createData(val.toString(),type);
			}
		}	
		
		if(_faceFile)
		{
			DataService.http(_faceFile,configSkins);
		}

	}
	
	private function configSkins(config : XML) : void
	{
		var itemsXMLList : XMLList = config.css.item;
		for (var i : Number = 0; i < itemsXMLList.length(); i++)
		{
			var isCreate : Boolean = String(itemsXMLList[i].@isCreate) == "true";
			var update : Boolean = String(itemsXMLList[i].@update) == "true";
			var selector : String = itemsXMLList[i].@selector;
			var stylelist : XMLList = itemsXMLList[i].style;
			var style : XML;
			if(stylelist.length())
			{
				style = stylelist[0];
				setStyle(selector,style,isCreate,update);
			}
		}
		
		setTimeout(skinsLoadComplete,2000);
	}
	
	private function setStyle(selector : String , style : XML,isCreate : Boolean = false,update : Boolean = false) : void
	{
		var cssStyleDeclaration:CSSStyleDeclaration =
				isCreate ?
				new CSSStyleDeclaration()
				:
				topLevelStyleManager.getStyleDeclaration(selector);
		if(cssStyleDeclaration)
		{
			var styleProps : XMLList = style.attributes();
			
			for each(var styleProp : XML in styleProps)
			{
				var prop : String = styleProp.localName();
				var value : String = styleProp.toString();
				
				var newValue : Object = data[value];
				cssStyleDeclaration.setStyle(prop,newValue);
	
			}
			
			topLevelStyleManager.setStyleDeclaration(selector, cssStyleDeclaration, update);
		}
		
	}
	
	
	private function skinsLoadComplete() : void
	{
		WebSite.dispatchEvent(new AppEvent(AppEvent.SKINS_LOADED, null));	
	}
}


























}






















