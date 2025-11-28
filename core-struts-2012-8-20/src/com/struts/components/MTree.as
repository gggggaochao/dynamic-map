package com.struts.components
{
import com.struts.components.mtreeClasses.TreeNodeItemRenderer;
import com.struts.events.MTreeEvent;
import com.struts.interfaces.ITreeNode;
import com.struts.utils.ArrayUtil;
import com.struts.utils.HashTable;

import flash.events.Event;
import flash.events.MouseEvent;

import mx.collections.ArrayCollection;
import mx.collections.ICollectionView;
import mx.collections.IViewCursor;
import mx.collections.XMLListCollection;
import mx.core.ClassFactory;
import mx.core.IFactory;
import mx.core.IVisualElement;
import mx.core.IVisualElementContainer;
import mx.core.UIComponent;

import spark.components.Group;
import spark.components.VGroup;
import spark.components.supportClasses.GroupBase;
import spark.components.supportClasses.SkinnableComponent;
import spark.utils.LabelUtil;



[Event(name="nodeClick", type="com.struts.events.MTreeEvent")]

[Event(name="nodeOpen", type="com.struts.events.MTreeEvent")]

[Event(name="nodeClose", type="com.struts.events.MTreeEvent")]

public class MTree extends SkinnableComponent
{
	
	[Bindable]
	[SkinPart(required="true")]
	public var contentGroup : Group;
	
	public function MTree()
	{
		super();
		
		_treeNodeHashTable = new HashTable();
		_itemRenderer = new ClassFactory(TreeNodeItemRenderer);
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
	
	
	private var _iconField : String = "icon";
	
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
	
	private var _itemRenderer : IFactory;
	
	public function get itemRenderer():IFactory
	{
		return _itemRenderer;
	}
	
	public function set itemRenderer(value:IFactory):void
	{
		_itemRenderer = value;
		
	}
	
	
	private var _itemRendererFunction : Function;
	
	public function get itemRendererFunction():Function
	{
		return _itemRendererFunction;
	}
	
	public function set itemRendererFunction(value:Function):void
	{
		_itemRendererFunction = value;
	}
	
	private var _dataProvider : Object;
	
	private var _hasDataProviderChange : Boolean = false;
	
	private var _rootModel : ICollectionView;
	
	public function get dataProvider():Object
	{
		return _dataProvider;
	}
	
	public function set dataProvider(value:Object):void
	{
		if(_dataProvider == value)
			return;
		
		_dataProvider = value;
		_hasDataProviderChange = true;
		invalidateProperties();
	}
	
	
	override protected function commitProperties():void
	{
		super.commitProperties();
		
		if(_hasDataProviderChange)
		{
		   _hasDataProviderChange = false;
			
		   contentGroup.removeAllElements();
			
		   _rootModel = ArrayUtil.format(_dataProvider);
		   
		   var childcursor : IViewCursor = _rootModel.createCursor();
		   var treeNode : ITreeNode;
		   var node : Object;
		   while(!childcursor.afterLast)
		   {
			   node = childcursor.current;
			   treeNode = createTreeNodeItemRenderer(node);
			   rollback(contentGroup,treeNode);
			   
			   childcursor.moveNext();
		   }
		}
	}
	
	private var _treeNodeHashTable : HashTable;
	
	private function rollback(parentEle : IVisualElementContainer,treeNode : ITreeNode,index : int = 1) : void
	{
		
		
		parentEle.addElement(treeNode as IVisualElement);	
		treeNode.isOpen = true;
		
		var childRootModel : ICollectionView = getChildrenRootModel(treeNode.data);
		if(childRootModel && childRootModel.length)
		{
			var viewCursor : IViewCursor = childRootModel.createCursor();
			var parentItemsEle : IVisualElementContainer = createChildNodesElementContainer(index);
			var childNode : Object;
			var childTreeNode : ITreeNode;
			var chilrenNode : Array = [];
			
			while(!viewCursor.afterLast)
			{
				index++;
				childNode = viewCursor.current;
				childTreeNode = createTreeNodeItemRenderer(childNode);
				childTreeNode.parentNode = treeNode;
				rollback(parentItemsEle,childTreeNode);
				
				chilrenNode.push(childTreeNode);
				
				viewCursor.moveNext();
				
			}
			
			treeNode.childrenViewRoot = parentItemsEle as UIComponent;
			treeNode.childrenNode = chilrenNode;
			_treeNodeHashTable.add(treeNode,parentItemsEle);
			
			parentEle.addElement(parentItemsEle as IVisualElement);
		}	
		
		
	}
	
	
	private function getChildrenRootModel(item : *) : ICollectionView
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
	
	
	private var _indentation : int = 9;

	public function get indentation():int
	{
		return _indentation;
	}

	public function set indentation(value:int):void
	{
		_indentation = value;
	}

	
	private function createChildNodesElementContainer(index : int = 1) : IVisualElementContainer
	{
		var box : VGroup = new VGroup();
		box.paddingLeft = _indentation * index;
		box.clipAndEnableScrolling  = true;
		
		
		
		return box;
	}
	
	
	
	private function createTreeNodeItemRenderer(data : *) : ITreeNode
	{
	
		var myItemRenderer : ITreeNode;
		
		if (itemRendererFunction != null)
		{
			var rendererFactory:IFactory = itemRendererFunction(data);
			
			if (rendererFactory)
				myItemRenderer = rendererFactory.newInstance() as ITreeNode;
		}
		
		if(!myItemRenderer && itemRenderer)
			myItemRenderer = itemRenderer.newInstance() as ITreeNode;
		
		
		if (myItemRenderer)
		{
			myItemRenderer.label = LabelUtil.itemToLabel(data,labelField,labelFunction);
			myItemRenderer.icon = LabelUtil.itemToLabel(data,iconField,iconFunction);
			myItemRenderer.data = data;
			
			myItemRenderer.addEventListener(MouseEvent.CLICK,itemClickHandler);
		}
		
		return myItemRenderer;
	}
	
	
	
	private var _selectedItem : ITreeNode;

	public function get selectedItem():ITreeNode
	{
		return _selectedItem;
	}

	public function set selectedItem(value:ITreeNode):void
	{
		if(value == _selectedItem)
			return;
		
		if(_selectedItem)
		   _selectedItem.selected = false;
		
		_selectedItem = value;
		_selectedItem.selected = true;
	}


	private function itemClickHandler(event : Event) : void
	{
		var treeNode : ITreeNode = event.currentTarget as ITreeNode;
		
		selectedItem = treeNode;
		
		if(hasEventListener(MTreeEvent.NODE_CLICK))
			dispatchEvent(new MTreeEvent(MTreeEvent.NODE_CLICK,treeNode));
		
	}
	
	
}
}
















































