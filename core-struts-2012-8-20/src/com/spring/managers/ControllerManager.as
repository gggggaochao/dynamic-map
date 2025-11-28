package com.spring.managers
{
	
import com.spring.db.DataSet;
import com.spring.events.SpringMessageEvent;
import com.spring.tags.model.TagBaseView;
import com.struts.utils.HashTable;

import flash.display.DisplayObject;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.IEventDispatcher;
import flash.utils.describeType;

import mx.collections.ArrayCollection;
import mx.core.UIComponent;

public class ControllerManager extends EventDispatcher
{
	
	private static var _instance : ControllerManager;		
	
	private static var _lock:Boolean = true;
	
	private var eventsHashTable : HashTable;
	
	
	private var tagsHashTable : HashTable;
	
	public function ControllerManager()
	{
		if(_lock)
		{
		   throw new Error("SpringControllerManager is a singleton. Use SpringControllerManager.getInstance() to obtain an instance of this class.");
		}
	}
	
	public static function getInstance() : ControllerManager
	{
		if (!_instance)
		{
			_lock = false;
			_instance = new ControllerManager();
			_instance.init();
			_lock = true;
		}
		
		return _instance;
	}
	
	public static function getMessageDispatcher() : Function
	{
		return getInstance().messageDispatcher;
	}
	
	
	
	private function init() : void
	{
		eventsHashTable = new HashTable();
		tagsHashTable = new HashTable();
	}
	
	
	public function addTag(view : *,id : String) : TagBaseView
	{
		
		var config : XML = describeType(view);
		
		var tag : TagBaseView = createTag(view,config);
		tagsHashTable.add(view,tag);
		

		if(view is DisplayObject)
		{	
			if(DisplayObject(view).parent != null)
			{
				setSpringBean(view,config);
				tag.isInjectComplete = true;
			}
			
			if(tag.init != null)
			{
				DisplayObject(view).addEventListener(Event.ADDED_TO_STAGE,addedToStage);
			}
		}
		else
		{
			setSpringBean(view,config);
			tag.isInjectComplete = true;

			if(tag.init != null)
			{
				tag.init();
			}
		}
		
		
		
		if(tag.destroy != null && view is DisplayObject)
		{
			DisplayObject(view).addEventListener(Event.REMOVED_FROM_STAGE,remvoedFromStage);
		}
		
		
		
		return tag;
	}
	
	private function remvoedFromStage(event : Event) : void
	{
		var view : * = event.currentTarget;
		
		var tag : TagBaseView = tagsHashTable.find(view);
		
		if(tag)
		{
			tag.destroy();
		}
	}
	
	private function addedToStage(event : Event) : void
	{
		var view : * = event.currentTarget;
		
		var tag : TagBaseView = tagsHashTable.find(view);
		
		if(tag)
		{
			if(tag.isInjectComplete == false)
			{
				var config : XML = describeType(view);
				setSpringBean(view,config);
				tag.isInjectComplete = true;
			}
			
			tag.init();
		}
	}
	/**
	 * 
	 * @param view
	 * @return 
	 * 
	 */
	private function createTag(view : *,config : XML) : TagBaseView
	{
		
		
		
		/**
		 *    Method
		 *    [MessageHandler(selector="")]
		 * 
		 * */
		
		var tag : TagBaseView = new TagBaseView();
		
		setEntityManager(view,config);
		
		setHandlerMethod(view,config,tag);
		
		setMessageDispatcher(view,config);
		
		return tag;
		
	}
	
	private function setMessageDispatcher(view : *,config : XML) : void
	{
		var varMessageDispatcherMetadatas : XMLList = config.variable.metadata.(@name=="MessageDispatcher"); 
		
		var messageDispatcherTotal : int = varMessageDispatcherMetadatas.length();
		
		if(messageDispatcherTotal > 0)
		{
			var variableNode : XML = varMessageDispatcherMetadatas[0].parent();
			var variableName : String = variableNode.@name;
			var variableType : String = variableNode.@type;
			
			if(variableType == "Function")
			{
				view[variableName] = messageDispatcher;
			}
			else
			{
				throw new Error("MessageDispatcher must is Function ");
			}
		}		
	}

	private function setSpringBean(view : *,config : XML) : void
	{
		var beansMetadatas : XMLList = config.variable.metadata.(@name=="Bean"); 
		var beanTotal : int = beansMetadatas.length();
		
		if(beanTotal > 0)
		{
			var beanNode : XML;
			var beanName : String;
			var beanId : String;
			
			var parentNode : XML;
			var argNodes : XMLList;
			
			for each(beanNode in beansMetadatas)
			{
				beanId = null;
				parentNode = beanNode.parent();
				argNodes = beanNode.arg.(@key=="id");
				
				if(argNodes.length() > 0)
				   beanId = argNodes[0].@value;
				
				if(!beanId)
					beanId = parentNode.@name;
				
				beanName = parentNode.@name;
				
				if(beanId)
				{
					view[beanName] = SpringBeanManager.getBean(beanId);
				}
			}
		}		
	}
	
	
	private function setEntityManager(view : *,config : XML) : void
	{
		var emMetadatas : XMLList = config.variable.metadata.(@name=="EntityManager"); 
		var emTotal : int = emMetadatas.length();	
		
		if(emTotal > 0)
		{
			var enNode : XML;
			var enName : String;
			var enDataSet : String;
			
			var dataSet : DataSet;
			for each(enNode in emMetadatas)
			{
				enDataSet = enNode.arg.(@key=="dataSet").@value;
				dataSet = SpringBeanManager.getBean(enDataSet);
				
				if(dataSet)
				{
					enName = enNode.parent().@name;
					view[enName] = EntityManager.getInstance(dataSet);;
				}
			}			
		}
	}
	
	
	
	
	private function setHandlerMethod(view : *,config : XML,tag : TagBaseView) : void
	{
		
		var metadatas: XMLList  = config.method.metadata.(@name== "MessageHandler" 
			                                           || @name== "CommandHandler" 
													   || @name== "Init" 
													   || @name== "Destroy");
		
		if(metadatas.length() == 0)
			return;
		
		
		var methodNode : XML;
		var methodName : String;
		var handler : Function;
		var selector : String;
		var tagName : String;
		for each(methodNode in metadatas)
		{
			tagName = methodNode.@name;
			
			methodName = methodNode.parent().@name;
			
			if(tag.init == null && tagName == "Init")
			{
				tag.init = view[methodName] as Function
			}

			else if(tag.destroy == null && tagName == "Destroy")
			{
				tag.destroy = view[methodName] as Function
			}

			
			selector = methodNode.arg.(@key=="selector").@value;
			if(selector)
			{
				handler = view[methodName] as Function;
				//messageHandlers.push(handler);
				addEvents(selector,handler);
			}
		}		
	}
	
	
	private function messageDispatcher(message : *) : void
	{
		var config : XML = describeType(message);
		
		var varSelectorMetadatas : XMLList = config.variable.metadata.(@name=="Selector");
		var selectorTotal : int = varSelectorMetadatas.length();

		if(selectorTotal > 0)
		{
			var variableNode : XML    = varSelectorMetadatas[0].parent();
			var variableName : String = variableNode.@name;
			var variableType : String = variableNode.@type;
			
			if(variableType == "String")
			{
				var type : String = message[variableName] as String;
				
				var e : SpringMessageEvent = new SpringMessageEvent(type,message);
				
				getInstance().dispatchEvent(e);
			}
			
		}
		else
		{
			throw new Error("Message Selector is not Null ");
		}
		
		
		//getInstance().dispatchEvent(
	}
	
	private function addEvents(type : String,handler : Function) : void
	{
		var handlers : Array = eventsHashTable.find(type);
		
		if(!handlers)
		{
			handlers = new Array();
			eventsHashTable.add(type,handlers);
		}
		
		handlers.push(handler);
		
		getInstance().addEventListener(type,messageHandler);
	}
	
	
	private function messageHandler(event : SpringMessageEvent) : void
	{
		var type : String = event.type;
		var message : *   = event.message;
		var handlers : Array = eventsHashTable.find(type);
		
		if(handlers && handlers.length > 0)
		{
			for each(var hander : Function in handlers)
			{
				hander(message);
			}
		}
		
	}
	
}

}








