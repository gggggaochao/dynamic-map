package com.struts.core
{

import com.struts.data.DataService;
import com.struts.data.utils.ServiceUtil;
import com.struts.events.AppEvent;
import com.struts.utils.HashTable;

import mx.rpc.events.ResultEvent;
import mx.rpc.http.HTTPService;

public class AppSettings 
{

	private static var has : HashTable = new HashTable();
		
	public static function start(files : Array):void
	{
		initializeShareData(files);
	}
	
	private static function initializeShareData(files : Array) : void
	{
		if (files && files.length)
		{
			var fileObject : Object = files[0];
			var fileKey    : String;
			var filePath   : String
			if(fileObject is String)
			{
				filePath = fileObject as String;
				var sIndex : int = filePath.lastIndexOf("-");
				var eIndex : int = filePath.lastIndexOf(".");
				if(eIndex > (sIndex+1))
				{
					fileKey = filePath.slice(sIndex+1,eIndex);
				}
			}
			else
			{
				fileKey  = fileObject.key;
				filePath = fileObject.path;
			}
			
			

			
			if(fileKey && filePath)
			{
				var addShareHandler : Function = function(data : *) : void
				{
					has.add(fileKey,data);
					initializeShareData(files);
				}
				
				files.splice(0, 1);
				DataService.http(filePath,addShareHandler);
			}
		}
		else
		{
			files = null;
			WebApp.dispatch(AppEvent.INIT_CACHEDATA_LOADED);
		}	
	}
	
	public static function addData(key : String,object : *) : void
	{
		if(!key)
			return;
		
		if (has.containsKey(key))
		{
			has.remove(key);
		}
		has.add(key, object);		
	}

	public static function removeData(key : String) : *
	{
		return has.remove(key);
	}
	
	public static function fetchData(key : String) : *
	{
		return has.find(key);
	}
	
	
	/**
	 *
	 * 子查找
	 *  
	 * @param key
	 * @param field
	 * @return 
	 * 
	 */	
	public static function $(key : String,field : String) : *
	{
		var obj : * = fetchData(key);
		
		if(obj is HashTable)
		{
			return HashTable(obj).find(field)
		}
		else if(obj is Object)
		{
			return obj[field];
		}
		
		return obj;
	}
	
}
}














































































