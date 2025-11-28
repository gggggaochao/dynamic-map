package com.struts.components.menuTreeClasses
{
import com.struts.events.RecordEvent;
import com.struts.utils.MarkUtil;

import flash.display.DisplayObject;
import flash.events.Event;
import flash.events.MouseEvent;

import mx.collections.ArrayCollection;
import mx.collections.ICollectionView;
import mx.collections.IViewCursor;
import mx.collections.XMLListCollection;
import mx.containers.HBox;
import mx.containers.VBox;
import mx.core.ClassFactory;
import mx.core.IDataRenderer;
import mx.core.IVisualElementContainer;
import mx.core.UIComponent;

import spark.components.Group;
import spark.components.Image;
import spark.components.Label;
import spark.primitives.BitmapImage;

[Event(name="itemClick", type="com.struts.events.TargetEvent")]

[Event(name="itemMouseOver", type="com.struts.events.TargetEvent")]

[Event(name="itemMouseOut", type="com.struts.events.TargetEvent")]

public class MenuTreeGroupItemRender extends Group  implements IDataRenderer
{
	
	
	private var hearder: HBox;
	
	private var itemsBox: VBox;
	
	public function MenuTreeGroupItemRender()
	{
		super();
		
		hearder = new HBox();
		itemsBox = new VBox();
	}

	private var _labelField : String; 
	/**
	 *  公用属性
	 * 
	 * 
	 * */
	public function get labelField():String
	{
		return _labelField;
	}
	
	/**
	 * @private
	 */
	public function set labelField(value:String):void
	{
		_labelField = value;
	}
	
	private var _labelFunction : Function;
	
	public function get labelFunction():Function
	{
		return _labelFunction;
	}
	
	public function set labelFunction(value:Function):void
	{
		_labelFunction = value;
	}
	
	
	private var _iconField : String;
	
	public function get iconField():String
	{
		return _iconField;
	}
	
	public function set iconField(value:String):void
	{
		_iconField = value;
	}
	
	private var _iconFunction : Function;
	
	public function get iconFunction():Function
	{
		return _iconFunction;
	}
	
	public function set iconFunction(value:Function):void
	{
		_iconFunction = value;
	}
	
	private var _data : Object;
	
	private var _rootModel : ICollectionView;

	public function get data():Object
	{
		return _data;
	}

	public function set data(value:Object):void
	{
		_data = value;
		
		
	}
	
	
	/**
	 * 	控件头部样式
	 * 
	 * */
	private var _headStyleName : String = "Gradient";

	public function get headStyleName():String
	{
		return _headStyleName;
	}

	public function set headStyleName(value:String):void
	{
		_headStyleName = value;

		if(hearder && value)
		{
			//hearder.setStyle("borderSkin",Class(GradientBorder));
			hearder.styleName = value;
		}
	}
	
	protected override function createChildren():void
	{
		super.createChildren();
		
		hearder.percentWidth = 100;
		hearder.height = 25;
		hearder.setStyle("paddingLeft",8);
		hearder.setStyle("verticalAlign","middle");
		headStyleName = _headStyleName;
		addElementAt(hearder,0);

		itemsBox.top = hearder.height;
		itemsBox.percentWidth = 100;
		itemsBox.setStyle("verticalGap",0);
		//itemsBox.styleName = "Content";

		
		addElementAt(itemsBox,1);
		
//		var source : String;
//		var text :  String;
		
		rollBack(itemsBox,data);
//		
//		if(data)
//		{
//			var imgSource : String = MarkUtil.itemToLabel(data,iconField,iconFunction);
//			if(imgSource)
//			{
//				var bitmapImage : Image = new Image();
//				bitmapImage.source = imgSource
//				hearder.addElement(bitmapImage);
//			}
//			
//			var textStr : String = MarkUtil.itemToLabel(data,labelField,labelFunction);
//			if(textStr)
//			{
//				var label : Label = new Label();
//				label.text = textStr;
//				hearder.addElement(label);
//			}
//			
//			var _rootModel : ICollectionView;
//			
//			if(data is XML)
//			{
//				var xl:XMLList = XML(data).children();
//				_rootModel = new XMLListCollection(xl);
//			}
//			else if(data is Object)
//			{
//				var arrays : Array = data.children;
//				_rootModel = new ArrayCollection(arrays);
//			}
//			
//			if(_rootModel)
//			{
//				var childcursor : IViewCursor      = _rootModel.createCursor();
//				var itemRender: MenuTreeItemRender = null;
//				while(!childcursor.afterLast)
//				{
//					itemRender = createItemRenderer(childcursor.current);
//					itemsBox.addElement(itemRender);
//					
//					childcursor.moveNext();
//				}				
//			}				
//		}
	}
	
		
	
	public function rollBack(parent : IVisualElementContainer,data : *) : void
	{
		
		if(data)
		{
			var imgSource : String = MarkUtil.itemToLabel(data,iconField,iconFunction);
			if(imgSource)
			{
				var bitmapImage : Image = new Image();
				bitmapImage.source = imgSource
				hearder.addElement(bitmapImage);
			}
			
			var textStr : String = MarkUtil.itemToLabel(data,labelField,labelFunction);
			if(textStr)
			{
				var label : Label = new Label();
				label.text = textStr;
				hearder.addElement(label);
			}
			

			
			
			function setRootModel(item : *) : ICollectionView
			{
				
				if(item is XML)
				{
					var xl:XMLList = XML(item).children();
					return new XMLListCollection(xl);
				}
				else if(item is Object)
				{
					var arrays : Array = item.children;
					return new ArrayCollection(arrays);
				}
				
				return null;
			}
			
			
			var _rootModel : ICollectionView = setRootModel(data);
			
			if(_rootModel)
			{
				var childcursor : IViewCursor      = _rootModel.createCursor();
				var itemRender: MenuTreeItemRender = null;
				var parentRender : MenuTreeGroupItemRender = null;
				var item : Object;
				var childrenRootModel : ICollectionView;
				
				while(!childcursor.afterLast)
				{
					item = childcursor.current;
					
					childrenRootModel = setRootModel(item);
					
					if(childrenRootModel && childrenRootModel.length)
					{
						parentRender = new MenuTreeGroupItemRender();
						parentRender.percentWidth = 100;
						parentRender.labelField = labelField;
						parentRender.labelFunction = labelFunction;
						parentRender.iconField = iconField;
						parentRender.iconFunction = iconFunction;
						parentRender.data = item;
						
						parentRender.itemsBox.setStyle("paddingLeft",8);
						
						parent.addElement(parentRender);
						
						//rollBack(parentRender.itemsBox,childrenRootModel);
					} 
					else
					{
						itemRender = createItemRenderer(item);
						parent.addElement(itemRender);
					}
					
					childcursor.moveNext();
					
				}				
			}				
		}	
	}
	
	public function createItemRenderer(data : Object) : MenuTreeItemRender
	{
		var itemRender: MenuTreeItemRender = new MenuTreeItemRender();
		
		itemRender.percentWidth  = 100;
		itemRender.height        = 25;
		itemRender.labelField    = labelField;
		itemRender.labelFunction = labelFunction;
		itemRender.iconField     = iconField;
		itemRender.iconFunction  = iconFunction;
		itemRender.data          = data;
		itemRender.buttonMode    = true;
		itemRender.useHandCursor = true;
		itemRender.mouseChildren = false;
		
		itemRender.addEventListener(MouseEvent.CLICK,itemClickHandler);
		itemRender.addEventListener(MouseEvent.MOUSE_OVER,mouseOverHandler);
		itemRender.addEventListener(MouseEvent.MOUSE_OUT,mouseOutHandler);
		
		return itemRender;
	}

	private function itemClickHandler(event : Event) : void
	{
		var itemClickEvent : RecordEvent = new RecordEvent("itemClick",event.currentTarget);
		dispatchEvent(itemClickEvent);
	}
	
	private function mouseOverHandler(event : Event) : void
	{
		var itemClickEvent : RecordEvent = new RecordEvent("itemMouseOver",event.currentTarget);
		dispatchEvent(itemClickEvent);
	}
	
	private function mouseOutHandler(event : Event) : void
	{
		var itemClickEvent : RecordEvent = new RecordEvent("itemMouseOut",event.currentTarget);
		dispatchEvent(itemClickEvent);
	}
}
}

















