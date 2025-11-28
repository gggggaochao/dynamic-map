package com.spring.utils
{
	import com.struts.utils.ArrayUtil;
	
	import flash.utils.describeType;
	import flash.utils.getDefinitionByName;
	
	import mx.collections.ICollectionView;
	import mx.collections.IViewCursor;
	import mx.utils.ObjectUtil;

public class BeanUtils
{
	
	public static function toBean(bean : * , BeanClass : Class) : *
	{
		var en : Object;
		if(bean is String)
			en = JSON.parse(String(bean));	
		else
			en = bean;
		
		if(en)
		{
			var model : Object = new BeanClass();
			var modelConfig : XML = describeType(model);
			var properties : XMLList = modelConfig.variable;
			
			copyBean(model,en,properties);
		}
		
		
	
		return null;
		
	}
	
	
	private static function copyBean(target : Object,source : Object,propertyNodes : XMLList) : void
	{
		var properitesTotal : int = propertyNodes.length();
		
		if(properitesTotal > 0)
		{
			var proNode : XML;
			var propertyName : String;
			var properType : String;
			
			for each(proNode in propertyNodes)
			{
				propertyName = proNode.@["name"];
				properType = proNode.@["type"];
				
				target[propertyName] = setPropertyType(source[propertyName],properType);
			}
		}
		
	}
	
	public static function toList(bean : * , BeanClass : Class) : Array
	{
		var en : Object;
		
		if(bean is String)
			en = JSON.parse(String(bean));	
		else if(bean is XML)
			en = XML(bean).children();
		
		var list : Array = new Array();
		var rootModel :ICollectionView = ArrayUtil.format(en);
		var cursor  : IViewCursor = rootModel.createCursor();
		
		var item : Object;
		var model : Object;
		
		var modelConfig : XML = describeType(BeanClass);
		var properties : XMLList = modelConfig.factory.variable;
		
		while(!cursor.afterLast)
		{
			item = cursor.current;
			model = new BeanClass();
			
			copyBean(model,item,properties);
			
			list.push(model);
			cursor.moveNext();
		}
		
		
		return list;
	}
	
	
	
	/**
	 *
	 * 类型转换
	 * 
	 *  
	 * @param value
	 * @param type
	 * @return 
	 * 
	 */	
	public static function setPropertyType(value : String,type : String) : *
	{
		if(type == "String")
			return value;
		else if(type == "int")
			return int(value);
		else if(type == "uint")
			return uint(value);
		else if(type == "Number")
			return Number(value);	
		else if(type == "Boolean")
			return value == "true";
		else if(type == "Class")
			return refClass(value);
		
		return null;
	}
	
	
	/**
	 * 
	 * 反射对象
	 *  
	 * @param clazz
	 * @return 
	 * 
	 */	
	public static function refClass(clazz : String) : Class
	{
		return getDefinitionByName(clazz) as Class;
	}
	
}
}