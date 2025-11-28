package com.struts.components
{
	import com.struts.components.pageClasses.PageGroupItem;
	import com.struts.components.pageClasses.DefaultPageGroupRenderer;
	
	import com.struts.events.PageEvent;
	
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	import flash.net.navigateToURL;
	
	import flashx.textLayout.formats.Direction;
	
	import mx.collections.ArrayCollection;
	import mx.controls.listClasses.IListItemRenderer;
	import mx.core.ClassFactory;
	import mx.core.IDataRenderer;
	import mx.core.IFactory;
	import mx.core.IVisualElement;
	import mx.core.LayoutDirection;
	import mx.core.UIComponent;
	import mx.events.CollectionEvent;
	import mx.events.ItemClickEvent;
	
	import org.osmf.layout.LayoutMode;
	
	import spark.components.Group;
	import spark.components.TileGroup;
	import spark.core.NavigationUnit;
	import spark.effects.Animate;
	import spark.effects.animation.MotionPath;
	import spark.effects.animation.SimpleMotionPath;
	
	/**
	 * 点击渲染器事件
	 */	
	[Event(name="itemClick", type="mx.events.ItemClickEvent")]
	
	/**
	 * 改变页码时的派发
	 */	
	[Event(name="changePage", type="com.struts.events.PageEvent")]
	
	/**
	 * 页面初始化
	 */	
	[Event(name="pageInited", type="com.struts.events.PageEvent")]
	
	/**
	 * 
	 * @author zhouHan
	 */	
	public class PageTileGroup extends TileGroup
	{
		
		//----------------------------------------------
		//
		// Variables
		//
		//----------------------------------------------
		
		/**
		 * @private 
		 * 组件所要渲染器
		 */
		private var _itemRender:IFactory;
		private var _itemRenderDirty:Boolean;
		
		/**
		 * @private
		 * 组件所需要的数据源
		 */
		private var _dataProvider:ArrayCollection;
		private var _dataProviderDirty:Boolean;
		
		/**
		 * @private
		 * 分页动画要设置的属性
		 */		
		private var _property:String = "horizontalScrollPosition";
		
		/**
		 * @private
		 */		
		private var _propertyDirty:Boolean;
		
		/**
		 * @private
		 */		
		private var _autoFill:Boolean;
		
		/**
		 * @private
		 */		
		private var _autoFillDirty:Boolean;
		
		/**
		 * 分页方向
		 */		
		private var _direction:String = LayoutMode.HORIZONTAL;
		
		/**
		 * @private
		 */		
		private var _directionDirty:Boolean;
		
		/**
		 * @private
		 */		
		private var _duration:int = 500;
		
		/**
		 * @private
		 */		
		private var _durationDirty:Boolean;
		
		/**
		 * @private
		 */		
		private var _currentPage:int = 1;
		
		/**
		 * @private
		 */		
		private var _totalPage:int = 1;
		
		/**
		 * 组件内部真正使用的数据
		 */		
		protected var useData:ArrayCollection;
		
		/**
		 * @private
		 */		
		private var _requestedColumnCount:int = 4;
		
		/**
		 * @private
		 */		
		private var _requestedRowCount:int = 4;
		
		/**
		 * @private
		 */
		private var _columnWidth:Number;
		
		/**
		 * @private
		 */
		private var _rowHeight:Number;
		
		/**
		 * @private
		 */
		private var _horizontalGap:Number;
		
		/**
		 * @private
		 */
		private var _verticalGap:Number;
		
		/**
		 * @private
		 */		
		private var _displayDirty:Boolean;
		
		/**
		 * 动画控制
		 */
		protected var animate:Animate;
		protected var motionPath:SimpleMotionPath;
		
		protected var renderers:Array = [];
		
		//----------------------------------------------
		//
		// Constructor
		//
		//----------------------------------------------
		
		public function PageTileGroup()
		{
			super();
			clipAndEnableScrolling = true;
			orientation = "columns";
			_itemRender = new ClassFactory(DefaultPageGroupRenderer);
			_dataProvider = new ArrayCollection();
			useData = new ArrayCollection();
		}
		
		//----------------------------------------------
		//
		// Properties
		//
		//----------------------------------------------
		
//		/**
//		 * 列数
//		 * @param value
//		 */		
//		public function set requestedColumnCount(value:int):void
//		{
//			if (_requestedColumnCount == value)
//				return;
//			_requestedColumnCount = value;
//			_displayDirty = true;
//			invalidateDisplayList();
//		}
//		public function get requestedColumnCount():int
//		{
//			return _requestedColumnCount;
//		}
//		
//		/**
//		 * 行数 
//		 * @param value
//		 */		
//		public function set requestedRowCount(value:int):void
//		{
//			if (_requestedRowCount == value)
//				return;
//			
//			_requestedRowCount = value;
//			_displayDirty = true;
//			invalidateDisplayList();
//		}
//		public function get requestedRowCount():int
//		{
//			return _requestedRowCount;
//		}
//		
//		/**
//		 * 列宽
//		 * @param value
//		 */		
//		public function set columnWidth(value:Number):void
//		{
//			if (_columnWidth == value)
//				return;
//			_columnWidth = value;
//			_displayDirty = true;
//			invalidateDisplayList();
//		}
//		public function get columnWidth():Number
//		{
//			return _columnWidth;
//		}
//		
//		/**
//		 * 行高
//		 * @param value
//		 */		
//		public function set rowHeight(value:Number):void
//		{
//			if (_rowHeight == value)
//				return;
//			_rowHeight = value;
//			_displayDirty = true;
//			invalidateDisplayList();
//		}
//		public function get rowHeight():Number
//		{
//			return _rowHeight;
//		}
//		
//		/**
//		 * 横向间距
//		 * @param value
//		 */		
//		public function set horizontalGap(value:Number):void
//		{
//			if (_horizontalGap == value)
//				return;
//			_horizontalGap = value;
//			_displayDirty = true;
//			invalidateDisplayList();
//		}
//		public function get horizontalGap():Number
//		{
//			return _horizontalGap;
//		}
//		
//		/**
//		 * 纵向间距
//		 * @param value
//		 */		
//		public function set verticalGap(value:Number):void
//		{
//			if (_verticalGap == value)
//				return;
//			_verticalGap = value;
//			_displayDirty = true;
//			invalidateDisplayList();
//		}
//		public function get verticalGap():Number
//		{
//			return _verticalGap;
//		}
		
		/**
		 * 组件所要渲染器
		 * @param value
		 */		
		public function set itemRenderer( value:IFactory ):void
		{
			_itemRender = value;
			_itemRenderDirty = true;
			invalidateProperties();
			invalidateDisplayList();
		}
		public function get itemRenderer():IFactory
		{
			return _itemRender;
		}
		
		/**
		 * 返回当面页
		 * @return 
		 */		
		public function get currentPage():int
		{
			return _currentPage;
		}
		
		/**
		 * 返回总页数
		 * @return 
		 */		
		public function get totalPage():int
		{
			return _totalPage;
		}
		
		/**
		 * @private
		 * 组件所需要的数据源
		 */
		public function set dataProvider( value:ArrayCollection ):void
		{
			if(value == null)
				_dataProvider = new ArrayCollection();
			else
				_dataProvider = value;
			
			if (_dataProvider)
				_dataProvider.addEventListener(CollectionEvent.COLLECTION_CHANGE, dataProvider_collectionChangeHandler, false, 0, true);
			
			
			_dataProviderDirty = true;
			invalidateProperties();
			invalidateDisplayList();
		}
		public function get dataProvider():ArrayCollection
		{
			return _dataProvider;
		}
		
		protected function dataProvider_collectionChangeHandler(event:CollectionEvent):void
		{			
			_dataProviderDirty = true;
			invalidateProperties();
			invalidateDisplayList();
		}
		
		/**
		 * 分页动画要设置的属性
		 */
		public function set property(value:String):void
		{
			if(_property != value)
			{
				_property = value;
				_propertyDirty = true;
				invalidateProperties();
			}
		}
		public function get property():String
		{
			return _property;
		}
		
		/**
		 * 是否自动填充空数据，以达到容器完整显示
		 * @param value
		 */		
		public function set autoFill(value:Boolean):void
		{
			if(_autoFill != value)
			{
				_autoFill = value;
				_autoFillDirty = true;
				invalidateProperties();
			}
		}
		public function get autoFill():Boolean
		{
			return _autoFill;
		}
		
		/**
		 * 分页方向
		 * @param value
		 */		
		[Inspectable(category="General", enumeration="horizontal,vertical", defaultValue="horizontal")]
		public function set direction(value:String):void
		{
			if(_direction != value)
			{
				_direction = value;
				_directionDirty = true;
				invalidateProperties();
			}
		}
		public function get direction():String
		{
			return _direction;
		}
		
		/**
		 * 动画持续时间
		 */
		public function set duration(value:int):void
		{
			if( _duration != value )
			{
				_duration = value;
				_durationDirty = true;
				invalidateProperties();
			}
		}
		public function get duration():int
		{
			return _duration;
		}
		
		//----------------------------------------------
		//
		// Overridens
		//
		//----------------------------------------------
		
		/**
		 * 初始化控件子集
		 */		
		override protected function createChildren():void
		{
			super.createChildren();
			animate = new Animate(this);
			motionPath = new SimpleMotionPath(property);
			var vecotr:Vector.<MotionPath> = new Vector.<MotionPath>();
			vecotr.push(motionPath);
			animate.motionPaths = vecotr;
		}
		
		/**
		 * 属性的更新
		 */		
		override protected function commitProperties():void
		{
			super.commitProperties();
			if(_propertyDirty)
			{
				_propertyDirty = false;
				motionPath.property = _property;
			}
			if(_itemRenderDirty)
			{
				_itemRenderDirty = false;
				initRenderers();
			}
			if(_dataProviderDirty)
			{				
				_dataProviderDirty = false;
				fillNativeData();
				returnToInit();
				applyRendererData();				
			}
			if(_directionDirty)
			{
				_directionDirty = false;
				orientation = _direction == LayoutMode.VERTICAL ? "rows" : "columns";
			}
			if(_durationDirty)
			{
				_durationDirty = false;
				animate.duration = _duration;
			}
		}
		
		/**
		 * @private
		 */		
//		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
//		{
//			super.updateDisplayList(unscaledWidth, unscaledHeight);
//			var len:int = useData.length;
//			var i:int = 0;
//			var cX:Number = 0;
//			var cY:Number = 0;
//			for (i=0; i < len; i++)
//			{
//				var renderer:UIComponent = renderers[i];
//				renderer.width = columnWidth;
//				renderer.height= rowHeight;
//				var rangeWidth:Number = requestedColumnCount * columnWidth + (requestedColumnCount - 1) * horizontalGap;
//				
//				if (i > 0 && i % requestedColumnCount == 0)
//				{
//					cX = 0;
//					cY += rowHeight + verticalGap;
//				}
//				else
//				{
//					
//				}
//			}
//		}
		
		//----------------------------------------------
		//
		// Methods
		//
		//----------------------------------------------
		
		/**
		 * 第一页
		 */		
		public function firstPage():void
		{
			_currentPage = 1;
			scrollToThere(NavigationUnit.HOME);
		}
		
		/**
		 * 最后一页
		 */		
		public function lastPage():void
		{
			_currentPage++;
			scrollToThere(NavigationUnit.END);
		}
		
		/**
		 * 下一页
		 */		
		public function nextPage():void
		{
			if( _currentPage < _totalPage )
				_currentPage ++;
			scrollToThere(LayoutMode.VERTICAL == direction ? NavigationUnit.PAGE_DOWN : NavigationUnit.PAGE_RIGHT);
		}
		
		/**
		 * 上一页
		 */		
		public function prePage():void
		{
			if( _currentPage > 1)
				_currentPage--;
			scrollToThere(LayoutMode.VERTICAL == direction ? NavigationUnit.PAGE_UP : NavigationUnit.PAGE_LEFT);
		}
		
		/**
		 * 返回当前页的渲染器,并删除内容为空的渲染器
		 */
		public function getCurrentPageRenderers():Array
		{
			var pageSize:int = requestedColumnCount * requestedRowCount;
			var start:int = (_currentPage - 1) * pageSize;
			var end:int = start + pageSize;
			var r:Array = renderers.slice(start, end);
			for(var i:int = r.length - 1; i >= 0; i--)
			{
				var renderer:IDataRenderer = r[i] as IDataRenderer;
				if(renderer.data.data == null)
					r.splice(i, 1);
			}
			return r;
		}
		
		/**
		 * 滚动条滚动到指定位置
		 */		
		protected function scrollToThere(dir:uint):void
		{
			var value:Number = LayoutMode.VERTICAL == direction ? getVerticalScrollPositionDelta(dir) : getHorizontalScrollPositionDelta(dir);
			if (value != 0) {
				motionPath.valueBy = value;
				animate.play();
			}
			var event:PageEvent = new PageEvent(PageEvent.CHANGE_PAGE);
			event.currentPage = currentPage;
			event.totalPage = totalPage;
			dispatchEvent(event);
		}
		
		/**
		 * 把内部使用的数据源自动填充为满页
		 */		
		protected function fillNativeData():void
		{
			useData.removeAll();
			
			var i:int;
			var originCount:int = _dataProvider.length;
			var pageCount:int = requestedColumnCount * requestedRowCount;
			
			// 原始数据添加至内部使用的数据
//			if(_direction == "rows")
//			{
//				for (i = 0; i < originCount; i++)
//				{
//					
//				}
//			}
//			else
//			{
				useData.addAll(_dataProvider);
//			}
			
			if(_autoFill )
			{
				var addCount:int = (originCount % pageCount != 0 || originCount == 0 ) ? pageCount - originCount % pageCount : 0;
				for( i = 0; i < addCount; i++)
				{
					useData.addItem(null);
				}
			}
			
			_totalPage = (useData.length - 1) / pageCount + 1;
			_currentPage = 1;
			
			dispatchEvent(new PageEvent(PageEvent.PAGE_INITED));
		}
		
		/**
		 * 滚动条回到初始顶端
		 */		
		protected function returnToInit():void
		{			
			var dir:uint = NavigationUnit.HOME; 
			if(LayoutMode.VERTICAL == direction)
				verticalScrollPosition += getVerticalScrollPositionDelta(dir);
			else
				horizontalScrollPosition += getHorizontalScrollPositionDelta(dir);
		}
		
		/**
		 * 重新初始化渲染器
		 */
		private function initRenderers():void
		{
			removeListeners();
			removeAllElements();
			renderers.length = 0;
			createRenderer(useData.length);
		}
		
		/**
		 * 创建指定长度的渲染对象
		 * @param len
		 */		
		private function createRenderer(len:int):void
		{
			for(var i:int = 0; i < len; i++)
			{
				renderers.push(_itemRender.newInstance());
			}
		}
		
		/**
		 * 将数据应该到渲染器中
		 */		
		private function applyRendererData():void
		{
			var len:int = useData.length;
			if(len > renderers.length)
				createRenderer(useData.length - renderers.length);
			else if(renderers.length > len)
			{
				var num:int = renderers.length - len;
				var elements:int = this.numElements;
				for(var i:int = elements - 1; i >= elements - num && i >= 0; i--)
				{
					if(renderers[i].hasEventListener(MouseEvent.CLICK))
						renderers[i].removeEventListener(MouseEvent.CLICK, itemClickHandler);
					removeElementAt(i);
				}
			}
			
			for( i = 0; i < len; i++)
			{
				var dataItem:Object = useData.getItemAt(i);
				var renderer:IDataRenderer = IDataRenderer( renderers[i] );
				renderer.data = new PageGroupItem(dataItem, i);
				addElement(renderer as IVisualElement);
				
				if(IEventDispatcher(renderer).hasEventListener(MouseEvent.CLICK))
					IEventDispatcher(renderer).removeEventListener(MouseEvent.CLICK, itemClickHandler);				
				if(dataItem != null)
					IEventDispatcher(renderer).addEventListener(MouseEvent.CLICK, itemClickHandler);					
			}
		}
		
		/**
		 * 删除事件监听
		 */		
		private function removeListeners():void
		{
			for each( var e:IEventDispatcher in renderers)
			{
				e.removeEventListener(MouseEvent.CLICK, itemClickHandler);
			}
		}
		
		/**
		 * 派发点击事件
		 * @param event
		 */		
		private function itemClickHandler(event:MouseEvent):void
		{
			var ev:ItemClickEvent = new ItemClickEvent(ItemClickEvent.ITEM_CLICK, true, false, null, -1, null, event.currentTarget);
			//var ev:ListEvent = new ListEvent(ListEvent.ITEM_CLICK, true, false, -1, -1, null, event.currentTarget as IListItemRenderer);
			dispatchEvent( ev );
		}
	}
}