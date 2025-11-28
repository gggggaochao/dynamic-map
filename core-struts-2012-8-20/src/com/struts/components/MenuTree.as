package com.struts.components
{
	import com.struts.components.menuTreeClasses.MenuTreeGroupItemRender;
	import com.struts.events.RecordEvent;
	import com.struts.utils.XMLUtil;
	
	import flash.events.Event;
	import flash.xml.XMLNode;
	
	import mx.collections.ArrayCollection;
	import mx.collections.ICollectionView;
	import mx.collections.IViewCursor;
	import mx.collections.XMLListCollection;
	import mx.core.IDataRenderer;
	import mx.core.UIComponent;
	
	import spark.components.VGroup;
	
	[Event(name="itemClick", type="com.struts.events.RecordEvent")]
	
	public class MenuTree extends VGroup
	{
		public function MenuTree()
		{
			super();
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
		
		
		private var _dataProvider : Object;

		public function get dataProvider():Object
		{
			return _dataProvider;
		}

		public function set dataProvider(value:Object):void
		{
			_dataProvider = value;
			
			dataProviderToCollection(value);

			invalidateProperties();
		}
		
		private var _rootModel : ICollectionView;
		
		private var _hasRoot : Boolean;
		
		private function  dataProviderToCollection(value : Object) : void
		{
			if (typeof(value)=="string")
				value = new XML(value);
			else if (value is XMLNode)
				value = new XML(XMLNode(value).toString());
			else if (value is XMLList)
				value = new XMLListCollection(value as XMLList);
			
			if (value is XML)
			{
				_hasRoot = true;
				var xl:XMLList = new XMLList();
				xl += value;
				_rootModel = new XMLListCollection(xl);
			}
			else if (value is ICollectionView)
			{
				_rootModel = ICollectionView(value);
				if (_rootModel.length == 1)
					_hasRoot = true;
			}
			else if (value is Array)
			{
				_rootModel = new ArrayCollection(value as Array);
			}
			else if (value is Object)
			{
				_hasRoot = true;
				var tmp:Array = [];
				tmp.push(value);
				_rootModel = new ArrayCollection(tmp);
			}
			else
			{
				_rootModel = new ArrayCollection();
			}		
		}
		
		private var _currItem : Object;

		public function get currItem():Object
		{
			return _currItem;
		}

		public function set currItem(value:Object):void
		{
			if(_currItem)
			{
				UIComponent(_currItem).styleName = "";
			}
			
			_currItem = value;	
			UIComponent(value).styleName = "ItemOverStyle";
		}
		
		protected override function commitProperties():void
		{
			super.commitProperties();
			
			this.removeAllElements();
			
			if(_rootModel)
			{
				var childcursor : IViewCursor            = _rootModel.createCursor();
				var itemRender : MenuTreeGroupItemRender = null;
				while(!childcursor.afterLast)
				{
					itemRender = createItemRender(childcursor.current);
					addElement(itemRender);
					
					childcursor.moveNext();
				}
//				for each(var groupData : Object in _dataList)
//				{
//					var groupBox : MenuTreeGroupItemRender = createItemRender(groupData);
//					addElement(groupBox);
//				}
			}			
		}
		
		public function createItemRender(data : Object) : MenuTreeGroupItemRender
		{
			var itemRender : MenuTreeGroupItemRender = new MenuTreeGroupItemRender();
			itemRender.percentWidth = 100;
			itemRender.labelField = labelField;
			itemRender.labelFunction = labelFunction;
			itemRender.iconField = iconField;
			itemRender.iconFunction = iconFunction;
			itemRender.data = data;
			
			itemRender.addEventListener("itemClick",itemClickHandler);
			itemRender.addEventListener("itemMouseOut",itemMouseOutHandler);
			itemRender.addEventListener("itemMouseOver",itemMouseOverHandler);	
			
			return itemRender;
		}
		
//		protected override function createChildren():void
//		{
//			
//			super.createChildren();
//			
//			if(_dataList)
//			{
//				for each(var groupData : Object in _dataList)
//				{
//					var groupBox : MenuTreeGroupItemRender = new MenuTreeGroupItemRender();
//					groupBox.percentWidth = 100;
//					groupBox.data = groupData;
//					
//					groupBox.addEventListener("itemClick",itemClickHandler);
//					groupBox.addEventListener("itemMouseOut",itemMouseOutHandler);
//					groupBox.addEventListener("itemMouseOver",itemMouseOverHandler);
//					addElement(groupBox);
//				}
//			
//			}
//		
//		}
		
		private function itemClickHandler(event:RecordEvent):void
		{
			currItem = event.data;
			if(currItem is IDataRenderer)
			{
				var itemData : Object = IDataRenderer(currItem).data;
				var dataEvent : RecordEvent = new RecordEvent("itemClick",itemData);
				dispatchEvent(dataEvent);
			}
		}
		
		
		private function itemMouseOverHandler(event : RecordEvent) : void
		{
			var currTarget : Object = event.data;
			if(currItem == currTarget)
				return;
			
			UIComponent(currTarget).styleName = "ItemOverStyle";
		}
		
		private function itemMouseOutHandler(event : RecordEvent) : void
		{
			var currTarget : Object = event.data;
			if(currItem == currTarget)
				return;
			
			UIComponent(currTarget).styleName = "";
		}		
	}
}












