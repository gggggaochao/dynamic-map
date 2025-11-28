package com.spring.managers
{
	
import com.logging.Logger;
import com.logging.LoggerManager;
import com.spring.core.ISpringTag;
import com.spring.tags.model.TagBaseView;
import com.spring.utils.BeanUtils;
import com.struts.core.WebApp;
import com.struts.events.AppEvent;
import com.struts.utils.HashTable;

import flash.display.DisplayObject;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.utils.describeType;
import flash.utils.getDefinitionByName;
import flash.utils.getQualifiedClassName;

public class SpringBeanManager extends EventDispatcher
{

	private static const bringNames : Array = ["Array","HashTable","com.struts.utils::HashTable"];
	
	private static const Beans : HashTable = new HashTable();
	
	private static var _instance : SpringBeanManager;		
	
	private static var _lock:Boolean = true;
	
	private var beansDocument : XMLList;
	
	private var cm : ControllerManager = ControllerManager.getInstance();
	
	
	private var logger : Logger = LoggerManager.getInstance();
	
	public function SpringBeanManager()
	{
		if(_lock)
		{
			throw new Error("SpringBeanManager is a singleton. Use SpringBeanManager.getInstance() to obtain an instance of this class.");
		}
	}
	
	public static function getInstance() : SpringBeanManager
	{
		if (!_instance)
		{
			_lock = false;
			_instance = new SpringBeanManager();
			_lock = true;
		}
		return _instance;
	}
	
	
	public function load(beans : XMLList) : void
	{
		beansDocument = beans;

		for each(var beanNode : XML in beansDocument)
		{
			setBeanNode(beanNode);
		}
		
		WebApp.dispatchEvent(new AppEvent(AppEvent.SPRING_COMPLETE));
	}
	
	private function setBeanNode(beanNode : XML) : *
	{
		var beanId : String = beanNode.@["id"];
		var bean : Object = Beans.find(beanId);
		
		try
		{
			if(!bean)
			{
				var beanClass : String = beanNode.@["class"];
				if(bringNames.indexOf(beanClass) != -1)
				{
					bean = setBringModel(beanClass,beanNode);
				}
				else if(beanClass)
				{
					var clazz : Class = getDefinitionByName(beanClass) as Class;
					if(clazz)
					{
						bean = new clazz() as Object;
						setProperty(bean,beanNode);
					}
				}
				
				if(bean is ISpringTag)
				{
					cm.addTag(bean,beanId)
				}
				
				if(beanId && bean)
				{
					Beans.add(beanId,bean);
					
				}
			}
		}
		catch(error : Error)
		{
			logger.error(error.message);
		}
		
		return bean;
		
	}
	
	
	private function setProperty(target : Object,beanNode : XML) : void
	{
		
		var describeTypeDoc : XML = describeType(target);
		var type : String = describeTypeDoc.@name;
		var variableNode : XML = new XML("<protypes />");
		variableNode.appendChild(describeTypeDoc.accessor);
		variableNode.appendChild(describeTypeDoc.variable);
		
		
		var propertyNodes : XMLList = beanNode.property;
		var proName : String;
		var proValue : String;
		var proRef : String;
		var proNode : XML;
		
		var bean : Object;
		var beanElement : XML;
		
		var protypesAccessor : XMLList;
		var accessorNode : XML;
		

		
		var variableNodes : XMLList = variableNode.children();
		
		for each(proNode in propertyNodes)
		{
			proName = proNode.@["name"];
			proValue = proNode.@["value"];
			proRef = proNode.@["ref"];

			protypesAccessor = variableNodes.(@name == proName);
			
			if(protypesAccessor.length() > 0)
			{
				accessorNode = protypesAccessor[0];

				if(accessorNode.@["access"] == "readonly")
					continue;
				
				type = accessorNode.@["type"];
				
				if(proValue)
				{
					target[proName] = BeanUtils.setPropertyType(proValue,type);
				}				
				else if(proRef)
				{
					bean = Beans.find(proRef);
					if(!bean)
					{
						beanElement = findBeanNode(proRef);
						if(beanElement)
						{
							bean = setBeanNode(beanElement);
						}
					}
					
					if(bean)
					{
						target[proName] = bean;	
					}
				}
				else if(bringNames.indexOf(type) != -1)
				{
					var childrenNode : XMLList = proNode.children();
					
					if(childrenNode.length() >  0)
					{
						target[proName] = setBringModel(type,childrenNode[0]);
					}
				}
			}			
		}
	}
	
	private function setArray(target : Array,beanNode : XML) : void
	{
		var childrenNodes : XMLList = beanNode.children();
		var chlidren : XML
		var type : String;
		var value : String;
		var protype : String;
		
		for each(chlidren in childrenNodes)
		{
			type = chlidren.localName();
			
			if(type == "Object")
			{
				var data : Object = {};
				var protypes : XMLList = chlidren.attributes();
				var childrenNode : XMLList = chlidren.children();
				for each(var prop : XML in protypes)
				{
					protype = prop.localName();
					value   = prop.toString();
					data[protype] = value;
				}
				target.push(data);
			}
			else
			{
				value = chlidren.@["value"];
				if(value)
				{
					target.push(BeanUtils.setPropertyType(value,type));
				}
			}
		}
	}
	
	
	private function setHashTable(target : HashTable,beanNode : XML) : void
	{
		var childrenNodes : XMLList = beanNode.children();
		var chlidren : XML
		var type : String;
		var value : String;		
		var key : String;
		
		for each(chlidren in childrenNodes)
		{
			type = chlidren.localName();
			value = chlidren.@["value"];
			key = chlidren.@["key"];
			
			if(value && key)
			{
				target.add(key,BeanUtils.setPropertyType(value,type))
			}
		}
	}
	
	
	private function setBringModel(type : String,beanNode : XML) : *
	{
		var target : *;
		
		if(type == "Array")
		{
			target = new Array();
			
			setArray(target as Array,beanNode);
		}
		
		else if(type == "com.struts.utils::HashTable" 
			 || type == "HashTable")
		{
			target = new HashTable();
			
			setHashTable(target as HashTable,beanNode);
		}	
		
		return target;
	}
	
	
	
	private function findBeanNode(beanId : String) : XML
	{
		if(beansDocument)
		{
			for each(var beanNode : XML in beansDocument)
				if(beanNode.@id == beanId)
					return beanNode;
		}
		
		return null;
	}
	
	
	
	public static function getBean(id : String) : *
	{
		return Beans.find(id);
	}
	
	public static function setBean(id : String,bean : *) : void
	{
		Beans.add(id,bean);
	}
	
	
}
}























