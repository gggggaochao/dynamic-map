package com.missiongroup.metro.utils
{
import com.struts.components.PageTileGroup;
import com.struts.utils.ComponentsUtil;
import com.struts.utils.XMLUtil;

import flash.utils.getDefinitionByName;

import flashx.textLayout.conversion.TextConverter;
import flashx.textLayout.elements.FlowElement;
import flashx.textLayout.elements.FlowGroupElement;
import flashx.textLayout.elements.SpanElement;
import flashx.textLayout.elements.TextFlow;

import mx.core.IVisualElement;
import mx.core.IVisualElementContainer;
import mx.core.UIComponent;

import spark.components.RichText;
import spark.components.supportClasses.GroupBase;
import spark.layouts.supportClasses.LayoutBase;

public class ControlUtils
{
	
	private var pageTileGroup : PageTileGroup;
	
	public static function produceViews(views : XML,parent : *) : void
	{
	
		var viewsChildrenXMLList : XMLList = views.component;
		var clazz : String;
		
		var uiObject  : *;
		
		
		var viewElement : IVisualElement;
		
		for each(var child : XML in viewsChildrenXMLList)
		{
			clazz = child.@clazz;
		
			viewElement = null;
			uiObject = bulidComponet(clazz);
			
			updateComponentStyleAndProtype(child,uiObject);
			updateLayout(child,uiObject);
			
			if(uiObject is IVisualElement)
			{
				viewElement = IVisualElement(uiObject);
			}
			
			if(uiObject is RichText)
			{
				updateRichText(child,RichText(uiObject));
			}
			
			
			if(parent is IVisualElementContainer && viewElement)
			{
				IVisualElementContainer(parent).addElement(viewElement);
			}
			
			produceViews(child,uiObject);
		}
	}
	
	/**
	 *
	 * 更新 RichText
	 *  
	 * @param node
	 * @param richText
	 * 
	 */	
	private static function updateRichText(node : XML,richText : RichText) : void
	{
		var html : XMLList = formatNode(node.html).children();
		
		var htmlStr : String = html.toXMLString();
		
		var textFlow:TextFlow = TextConverter.importToFlow(htmlStr, TextConverter.TEXT_FIELD_HTML_FORMAT);
		
		richText.content = textFlow;		
	}
	
	/**
	 *  更新 Component 属性和样式
	 * @param config
	 * @param target
	 * 
	 */	
	private static function updateComponentStyleAndProtype(config : XML,target : Object) : void
	{
		var _style : XML = formatNode(config.style);
		var _properties : XML = formatNode(config.properties);
		
		var propertiesName : String;
		var propertiesValue : String;
		var prop : XML;
		
		if(_properties)
		{
			var protypes : XMLList = _properties.attributes();
			for each(prop in protypes)
			{
				propertiesName = prop.localName();
				propertiesValue = prop.toString();
				
				ComponentsUtil.setProperty(target,propertiesName,propertiesValue);
			}  
		}

		if(_style)
		{
			protypes = _style.attributes();
			for each(prop in protypes)
			{
				propertiesName = prop.localName();
				propertiesValue = prop.toString();
				
				target.setStyle(propertiesName,propertiesValue);
			}	
		}
	}
	
	/**
	 *  更新 Component 布局
	 * @param config
	 * @param target
	 * 
	 */	
	private static function updateLayout(doc : XML,target : Object) : void
	{
		
		if(target is GroupBase)
		{
			var layout : LayoutBase;
			
			
			var _style : XML = formatNode(doc.layout);
			
			if(_style && _style.@type)
			{
				layout = bulidComponet(_style.@type) as LayoutBase;
				
				if(layout)
				{
					var _properties : XML = formatNode(_style.properties);
					var protypes : XMLList = _properties.attributes();
					var propertiesName : String;
					var propertiesValue : String;
					for each(var prop : XML in protypes)
					{
						propertiesName = prop.localName();
						propertiesValue = prop.toString();
						
						ComponentsUtil.setProperty(layout,propertiesName,propertiesValue);
					} 
					
					GroupBase(target).layout = layout;
				}
			}
			
			

		}
		
	}
	
	private static function formatNode(target : *) : XML
	{
		var _root : XML;
		
		if(target is XML){
			_root = target as XML 
		}else if(target is XMLList){
			var _rootList : XMLList = target as XMLList;
			_root =  _rootList[0];
		}
		
		return _root;			
	}
	
	
	/**
	 * 
	 * 反射对象
	 *  
	 * @param clazz
	 * @return 
	 * 
	 */	
	private static function bulidComponet(clazz : String) : Object
	{
		var eleClazz : Class = getDefinitionByName(clazz) as Class;
		return new eleClazz() as Object;
	}
}
}