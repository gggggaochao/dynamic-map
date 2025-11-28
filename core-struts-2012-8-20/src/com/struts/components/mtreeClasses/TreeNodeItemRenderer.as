package com.struts.components.mtreeClasses
{
	
import com.struts.interfaces.ITreeNode;

import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.MouseEvent;

import mx.collections.IList;
import mx.core.UIComponent;

import spark.components.Button;
import spark.components.Group;
import spark.components.Label;
import spark.components.supportClasses.SkinnableComponent;
import spark.primitives.BitmapImage;


[SkinState("up")]

[SkinState("over")]

[SkinState("select")]

[SkinState("disabled")]

public class TreeNodeItemRenderer extends SkinnableComponent implements ITreeNode
{
	[SkinPart(required="false")]
	public var labelDisplay : Label;
	
	[SkinPart(required="false")]
	public var iconDisplay:BitmapImage;
	
	[SkinPart(required="false")]
	public var treeNodeButton : TreeNodeButton;
	
	[SkinPart(require="false")]
	public var treeNodeGroup : Group;
	
	
	
	public function TreeNodeItemRenderer()
	{
		super();

		//mouseChildren = false;
		
		addHandlers();
	}
	
	private var _isTreeNodeChange : Boolean;
	
	private var _parentNode : ITreeNode;

	public function get parentNode():ITreeNode
	{
		return _parentNode;
	}

	public function set parentNode(value:ITreeNode):void
	{
		if(value == _parentNode)
			return;
		
		_parentNode = value;
		
		_isTreeNodeChange = true;
		
		invalidateProperties();
	}

	
	private var _childrenNode : Array;

	public function get childrenNode():Array
	{
		return _childrenNode;
	}

	public function set childrenNode(value:Array):void
	{
		
		if(value == _childrenNode)
			return;
		
		_childrenNode = value;
		
		_isTreeNodeChange = true;
		
		invalidateProperties();
	}

	private var _childrenViewRoot : UIComponent;

	public function get childrenViewRoot():UIComponent
	{
		return _childrenViewRoot;
	}

	public function set childrenViewRoot(value:UIComponent):void
	{
		_childrenViewRoot = value;
	}

	
	private var _data : Object;

	public function get data():Object
	{
		return _data;
	}

	public function set data(value:Object):void
	{
		_data = value;
	}

	

	public function get isRoot():Boolean
	{
		return _parentNode == null;
	}

	public function get isLeaf():Boolean
	{
		return _childrenNode ? _childrenNode.length <= 0 : true;
	}


	private var _isPropertiesChange : Boolean = false;
	
	private var _label : String;
	
	public function get label():String
	{
		return _label;
	}
	
	public function set label(value:String):void
	{
		if(_label === value)
			return;
		
		_label = value;
		_isPropertiesChange = true;
		
		invalidateProperties();
	}
	
	
	private var _icon : Object;
	
	public function get icon():Object
	{
		return _icon;
	}
	
	public function set icon(value:Object):void
	{
		if(_icon === value)
			return;
		
		_icon = value;
		_isPropertiesChange = true;
		
		invalidateProperties();
	}
	
	private var _selected : Boolean;

	public function get selected():Boolean
	{
		return _selected;
	}

	public function set selected(value:Boolean):void
	{
		if(_selected == value)
			return;
		
		_selected = value;

		hovered = false;
		invalidateProperties();
		invalidateSkinState();
	}
	
	
	private var _isOpen : Boolean = true;

	private var _isOpenChange : Boolean;
	
	public function get isOpen():Boolean
	{
		return _isOpen;
	}

	public function set isOpen(value:Boolean):void
	{
		if(_isOpen == value)
			return;
		
		_isOpen = value;
		
		_isOpenChange = true;
		invalidateProperties();

	}
	
	


	protected override function partAdded(partName:String, instance:Object):void
	{
		super.partAdded(partName, instance);
		
		if(instance == iconDisplay)
		{
			iconDisplay.source = icon;
			iconDisplay.addEventListener(IOErrorEvent.IO_ERROR,ioErrorHandler);
    	}
		
		if(instance == treeNodeButton)
		{
			treeNodeButton.isOpen = _isOpen;
			treeNodeButton.addEventListener(MouseEvent.CLICK,openTreeNodeHandler);
		}
		
		if(instance == treeNodeGroup)
		{
			//treeNodeGroup.addEventListener(MouseEvent.ROLL_OVER, mouseEventHandler);
			//treeNodeGroup.addEventListener(MouseEvent.ROLL_OUT, mouseEventHandler);
			//treeNodeGroup.addEventListener(MouseEvent.MOUSE_DOWN, mouseEventHandler);
			//treeNodeGroup.addEventListener(MouseEvent.MOUSE_UP, mouseEventHandler);
		}
		
	}
	
	private function openTreeNodeHandler(event : Event) : void
	{
		event.stopImmediatePropagation();
		
		isOpen = !_isOpen;
	}
	
	private function ioErrorHandler(event : Event) : void
	{
		iconDisplay.visible = iconDisplay.includeInLayout = false;
	}
	
	protected override function commitProperties():void 
	{
		super.commitProperties();
		
		
		/**
		 *  
		 *  属性改变
		 * 
		 * */
		if(_isPropertiesChange)
		{
		   _isPropertiesChange = false;
		   
		   labelDisplay.text = label;
		   
		   iconDisplay.source = icon;
		}
		
		
		/**
		 *  
		 *  打开子节点
		 * 
		 * */
		if(_isOpenChange)
		{
			_isOpenChange = false;
			
			treeNodeButton.isOpen = _isOpen;
			
			if(childrenViewRoot)
				childrenViewRoot.visible = childrenViewRoot.includeInLayout = _isOpen;
		}
		
		/**
		 *  
		 *  节点改变
		 * 
		 * */
		if(_isTreeNodeChange)
		{
			_isTreeNodeChange = false;
			
			treeNodeButton.visible = !isLeaf;
		}
		
	}
	
	protected function addHandlers():void
	{
		addEventListener(MouseEvent.ROLL_OVER, mouseEventHandler);
		addEventListener(MouseEvent.ROLL_OUT, mouseEventHandler);
//		addEventListener(MouseEvent.MOUSE_DOWN, mouseEventHandler);
//		addEventListener(MouseEvent.MOUSE_UP, mouseEventHandler);
		//treeNodeGroup.addEventListener(MouseEvent.CLICK, mouseEventHandler);
	}
	
	private function mouseEventHandler(event : Event) : void
	{
		var mouseEvent : MouseEvent = event as MouseEvent;
		switch (event.type)
		{
			case MouseEvent.ROLL_OVER :
			{
				if(_selected || mouseEvent.buttonDown)
					return;
				
				hovered = true;
				
				break;
			}
			case MouseEvent.ROLL_OUT:
			{
				if(_selected) 
					return;
				
				hovered = false;
				break;
			}
		}
	}
	
	private var _hovered:Boolean = false;    
	
	protected function get hovered():Boolean
	{
		return _hovered;
	}

	/**
	 *  @private
	 */ 
	protected function set hovered(value:Boolean):void
	{
		if (value == _hovered)
			return;
		
		_hovered = value;
		
		invalidateProperties();
		invalidateSkinState();
	}
	
	override protected function getCurrentSkinState():String
	{
		if (!enabled)
			return "disabled";
		
		if(_selected)
			return "select";

		if (hovered)
			return "over";
		
		return "up";
	}
}
}























