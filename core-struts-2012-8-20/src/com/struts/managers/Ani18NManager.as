package com.struts.managers
{
import com.struts.WebSite;
import com.struts.core.StringBundle;
import com.struts.data.DataService;
import com.struts.events.AppEvent;
import com.struts.interfaces.IHashTable;
import com.struts.utils.HashTable;

import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.IEventDispatcher;

public class Ani18NManager extends EventDispatcher implements IHashTable
{
	
	private var _currLanguage : *;
	
	private var _configFiles : Array;
	
	private var _languages : Array;
	
	private var _stringBundlesFactory : HashTable;
	/**
	 *  配置文件的路径
	 * */
	private var _configFile : String;
		
	public function set configFile(value:String):void
	{
		_configFile = value;
	}
	
	
	public function Ani18NManager()
	{
		super();
		
		_configFiles = new Array();
		
		_stringBundles = new Array();
		
		_stringBundlesFactory = new HashTable();
		
		WebSite.addEventListener(AppEvent.LANGUAGE_ADD_STRINGBUNDLE,addStringBundleHandler);
		
		WebSite.addEventListener(AppEvent.LANGUAGE_CUT_COMPLATE,cutlanguageCompleteHanlder);
		
		WebSite.addEventListener(AppEvent.LANGUAGE_CUT,cutlanguageHanlder);

	}
	
	private function cutlanguageCompleteHanlder(event : Event) : void
	{
		if(_stringBundles.length <=0)
			return;
		
		
		for each(var stringBundle : StringBundle in _stringBundles)
		{
			if(stringBundle)
			   stringBundle.cutLanguage();
		}
	}
	
	/**
	 *  
	 * @param event
	 * 
	 */	
	private function cutlanguageHanlder(event : AppEvent) : void
	{
		var languageCode : String = event.data as String;
		changeLanguage(languageCode);
	}
	
	private var _stringBundles : Array
	
	/**
	 *   将框架中 的 StringBundle 对象 加载到 Ani18Manager 中去 
	 * 
	 * */
	private function addStringBundleHandler(event : AppEvent) : void
	{
		var _stringBundle : StringBundle = event.data as StringBundle;
		
		if(_stringBundle)
		{
			_stringBundle.i18N = this;
			_stringBundles.push(_stringBundle);
		}
	}
	
	
	/**
	 *  装配 配置文件 
	 * 
	 */	
	public function load() : void
	{
		if(_configFile)
		{
		   _languages = new Array();
		   
		   _stringBundlesFactory.clear();
		   
		   DataService.http(_configFile,configHandler);
		}
	}
	
	
	private function configHandler(doc : XML) : void
	{
		var languagesConfigfiles : XMLList = doc..configfile;
		
		var languages : XMLList = doc..language;
		
		
		for each(var language : XML in languages)
		{
			_languages.push(language);
		}

		if(_languages.length)
		{
			var selectLanguage : XML = _currLanguage;
		
			if(!selectLanguage)
				selectLanguage = _languages[0];
			
			var folder : String = selectLanguage.@folder; 

			if(folder)
			{
				var _folder : String 
				for each(var configFile : XML in languagesConfigfiles)
				{
					_folder = folder + String(configFile.@name);
					_configFiles.push(_folder);
				}
				
				loabStringBundle();
			}
		}
	}
	
	
	
	private function loabStringBundle() : void
	{
		if(_configFiles.length)
		{
			var _filePath : String = _configFiles[0];
			_configFiles.splice(0, 1);
			DataService.http(_filePath,pushStringHandler);
		}
		else
		{
			WebSite.dispatch(AppEvent.LANGUAGE_CUT_COMPLATE);
		}
	}
	
	
	
	private function pushStringHandler(stringBundle : XML) : void
	{
	
		var stringXML : XMLList = stringBundle.String;
		
		var key : String;
		var value : String;
		for each(var stringNode : XML in stringXML)
		{
			key = stringNode.@id;
			value = stringNode.toString();
			
			_stringBundlesFactory.add(key,value);
		}
		
		loabStringBundle();
	}
	

	public function get(key : String) : String
	{
		return _stringBundlesFactory.find(key) || "";
	}
	
	
	
	/**
	 * 切换语言 
	 * @param code  i18N 语种简码 （以文件中的文件名为准）
	 * 
	 */	
	private function changeLanguage(code : String) : void
	{
		var _code : String;
		
		if(_currLanguage)
			_code = _currLanguage.@code;
		
		if(_code == code)
			return;
		
		
		for (var i:int;i<_languages.length;i++)
		{
			_code = _languages[i].@code;
			
			if(_code == code)
			{
				_currLanguage = _languages[i];
				load();
				break;
			}
		}
	}
	
	
	
	
	
}
}






















