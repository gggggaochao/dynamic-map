package com.struts.components
{
import com.struts.components.iponeClasses.IPoneItemRender;
import com.struts.events.MenuEvent;

import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Point;
import flash.geom.Rectangle;

import mx.collections.IList;
import mx.core.ClassFactory;
import mx.core.FlexGlobals;
import mx.core.IFactory;
import mx.core.IVisualElement;
import mx.core.UIComponent;
import mx.effects.Effect;
import mx.effects.Parallel;

import spark.components.Group;
import spark.effects.Fade;
import spark.effects.Move;
import spark.effects.Resize;
import spark.utils.LabelUtil;

[Event(name="menuClick", type="com.struts.events.MenuEvent")]


[Style(name="itemRenderSkin", type="Class", inherit="yes")]

[Style(name="downGlowColor", type="uint", format="Color", inherit="yes")]

public class IPoneContainer extends Group
{
	public function IPoneContainer()
	{
		super();
	}
	
	private var targetEffects : Array;
	
	private var isAddTargetEffect : Boolean = false;
	
	private var _viewSize : Rectangle = new Rectangle(2,3,180,40); 
	
	/**
	 *  菜单的范围   
	 *   x 行，y 列
	 *   widht，height 
	 * 
	 * */
	
	public function get viewSize():Rectangle
	{
		return _viewSize;
	}
	
	public function set viewSize(value:Rectangle):void
	{
		_viewSize = value;
	}
	
	private var _target : UIComponent;

	public function get target(): UIComponent
	{
		return _target;
	}

	public function set target(value : UIComponent):void
	{
		_target = value;
		
		if(isAddTargetEffect && value)
		{
			//value.x = viewCenterPoint.x;
			//value.y = viewCenterPoint.y;
			//value.width = _viewWidth;
			//value.height = _viewHeight;
			
			for each(var effect : Effect in targetEffects)	
				effect.target = value;
		}
		
	}
		
		
	private var _playDuration : Number = 400;
	
	public function get playDuration():Number
	{
		return _playDuration;
	}
	
	public function set playDuration(value:Number):void
	{
		_playDuration = value;
	}
	
	
	private var _gap : int = 3;
	
	public function get gap():int
	{
		return _gap;
	}
	
	public function set gap(value:int):void
	{
		_gap = value;
	}
	
	private var _itemRender : IFactory = new ClassFactory(IPoneItemRender);

	public function get itemRender():IFactory
	{
		return _itemRender;
	}

	public function set itemRender(value:IFactory):void
	{
		_itemRender = value;
	}
	
	private var _dataProvider : IList;
	
	private var _dataProviderChange : Boolean = false;
	
	private var _numElementsChange : Boolean = true;

	public function get dataProvider():IList
	{
		return _dataProvider;
	}

	public function set dataProvider(value:IList):void
	{
		if(_dataProvider == value)
			return;
		
		_dataProvider = value;
		_dataProviderChange = true;

		invalidateProperties();
	}

	
	//private var chlidrens  : Array;

	private function initializeMenus() : void
	{
		removeAllElements();
	
		for (var i : int = 0;i<_dataProvider.length;i++)
		{
			var data : Object = _dataProvider.getItemAt(i);
			
			var item : IPoneItemRender = createItemRender(data);
			
			if(item) 
			{
				item.index = i;
				item.addEventListener(MouseEvent.CLICK, menuClickHandler);
				
				addElementAt(item,i);
			}
		}
		
		
		//setChildLocalAndEffect();
	}
	
	private function menuClickHandler(event : Event) : void
	{
		var sender : IPoneItemRender = event.currentTarget as IPoneItemRender;
		
		var data : Object = _dataProvider.getItemAt(sender.index);
		
		dispatchEvent(new MenuEvent(MenuEvent.MENU_CLICK,data));
	}
	
	protected override function createChildren(): void 
	{   
		super.createChildren();
		
		//loadIPoneEffect();
	}
	
	protected override function commitProperties(): void
	{
		super.commitProperties();
		
		if(_dataProviderChange)
		{
			_numElementsChange = true;
			_dataProviderChange = false;
			
			_target.alpha = 0;
			
			initializeMenus();

		}
		
		if(_numElementsChange)
		{
			initializeElementEffect();
			
			_numElementsChange = false;
		}
		
	}
	
	private var _labelField : String; 

	public function get labelField():String
	{
		return _labelField;
	}

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

	
	private var _guidField : String;

	public function get guidField():String
	{
		return _guidField;
	}

	public function set guidField(value:String):void
	{
		_guidField = value;
	}

	
	private var _guidFunction : Function;

	public function get guidFunction():Function
	{
		return _guidFunction;
	}

	public function set guidFunction(value:Function):void
	{
		_guidFunction = value;
	}
	
	
	private function itemToLabel(item : Object) : String
	{
		return LabelUtil.itemToLabel(item,_labelField,_labelFunction);
	}
	
	private function itemToIcon(item : Object) : String
	{
		return LabelUtil.itemToLabel(item,_iconField,_iconFunction);
	}
	
	private function itemToGuid(item : Object) : String
	{
		return LabelUtil.itemToLabel(item,_guidField,_guidFunction);
	}
	
	
	private function createItemRender(data : Object) : IPoneItemRender
	{
		var menuItem : IPoneItemRender = null;
		
		var _itemRenderSkin:Class = Class(getStyle("itemRenderSkin"));
		var _downGlowColor : uint = uint(getStyle("downGlowColor"));
		
		if(_itemRender)
		{
			var en : Object = _itemRender.newInstance();
			if(en is IPoneItemRender) 
			{
				menuItem = en as IPoneItemRender;
				
				menuItem.includeInLayout = false;
				menuItem.buttonMode = true;
				menuItem.useHandCursor = true;
				menuItem.mouseChildren = false;
				menuItem.icon = itemToIcon(data);
				menuItem.title = itemToLabel(data);
				menuItem.guid = itemToGuid(data);
				menuItem.setStyle("downGlowColor",_downGlowColor);
				
				if(_itemRenderSkin)
					menuItem.setStyle("skinClass",_itemRenderSkin);
			}
		}
		
		return menuItem;
	}
		
//		protected override function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void 
//		{
//			super.updateDisplayList(unscaledWidth,unscaledHeight);
//			
//			viewSizeHandler();
//			
//		}
		
	private var viewSizeList : Array;
	
	private var sPoint : Point;
	
	private var viewCenterPoint : Point;
	
	//private var screenRectangle : Rectangle;
	
	private var hideParallel : Parallel;
	
	private var showParallel : Parallel;
	
	
	private var _viewWidth : Number;
	
	private var _viewHeight : Number;
	
	protected override function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
	{
		super.updateDisplayList(unscaledWidth,unscaledHeight);
		
		if(_viewWidth != unscaledWidth || _viewHeight != unscaledHeight )
		{
			_viewWidth = unscaledWidth;
			_viewHeight = unscaledHeight;
						
			initializeElementEffect();
		}
	}
	
	
	private function initializeElementEffect() : void
	{
		if(!_numElementsChange)
			return;
		
		if(!_viewWidth  || !_viewHeight)
			return;
		
		showParallel = new Parallel();
		
		hideParallel = new Parallel();	
		
		viewSizeList = new Array();
		
		
		
		const viewWidth : Number = _viewSize.x * _viewSize.width + (_viewSize.x - 1) * gap;
		const viewHeight : Number = _viewSize.y * _viewSize.height + (_viewSize.y - 1) * gap;
		
		viewCenterPoint = new Point(_viewWidth/2,_viewHeight/2);
		
		//screenRectangle = new Rectangle(0,0,appWidth,appHeight);
		
		sPoint = new Point(viewCenterPoint.x - viewWidth / 2,
								viewCenterPoint.y - viewHeight / 2);
		
		var xAdd : Number = _viewWidth / (_viewSize.x - 1);
		var yAdd : Number = _viewHeight / (_viewSize.y - 1);
		
		for(var row : int = 0;row < _viewSize.y ; row++)
		{
			for (var colnum : int = 0;colnum<_viewSize.x;colnum++)
			{
				var __item : Object = biuldRectangle(colnum,row,xAdd,yAdd);
				viewSizeList.push(__item);
			}
		}
		
		
		var childrennum : int = this.numElements;
		
		for (var i : int = 0;i<childrennum;i++)
		{
			var showPoint : Point = viewSizeList[i].showPoint as Point;
			var hidePoint : Point = viewSizeList[i].hidePoint as Point;
			
			
			var itemElement : IVisualElement = this.getElementAt(i);
			itemElement.x = showPoint.x;
			itemElement.y = showPoint.y;
			itemElement.width = viewSize.width;
			itemElement.height = viewSize.height;	
			
			createEffect(itemElement,showPoint,hidePoint);
		}	
		
		createTargetEffect();
		
		_numElementsChange = false;
	}
		
		
	private function biuldRectangle(colnum : int,row : int,xAdd : Number,yAdd : Number) : Object
	{
		var showPoint : Point = new Point();
		showPoint.x = sPoint.x + (_viewSize.width + gap) * colnum;
		showPoint.y = sPoint.y + (_viewSize.height + gap) * row;
		
		
		var hidePoint : Point = new Point();
		hidePoint.x = colnum * xAdd; 
		hidePoint.y = row * yAdd;
		
		return {
			showPoint : showPoint,
			hidePoint : hidePoint
		};
	}
	
	private function createTargetEffect() : void
	{
		if(isAddTargetEffect == false)
		{
			targetEffects = new Array();
			
			var resizeShowTarget : Resize = new Resize();
			resizeShowTarget.duration = playDuration;
			resizeShowTarget.widthFrom = 0;
			resizeShowTarget.widthTo = _viewWidth;
			resizeShowTarget.heightFrom = 0;
			resizeShowTarget.heightTo = _viewHeight;
			hideParallel.addChild(resizeShowTarget);
			//targetEffects.push(resizeShowTarget);
			
			var moveShowTarget : Move = new Move();
			moveShowTarget.duration = playDuration;
			moveShowTarget.xFrom = viewCenterPoint.x;
			moveShowTarget.yFrom = viewCenterPoint.y;
			moveShowTarget.xTo = 0;
			moveShowTarget.yTo = 0;	
			hideParallel.addChild(moveShowTarget);
			//targetEffects.push(moveShowTarget);
			
			var showFideTarget : Fade = new Fade();
			showFideTarget.duration = playDuration;
			showFideTarget.alphaFrom = 0;
			showFideTarget.alphaTo = 1;
			hideParallel.addChild(showFideTarget);				
			targetEffects.push(showFideTarget);
			
			
			var resizeHideTarget : Resize = new Resize();
			resizeHideTarget.duration = playDuration;
			resizeHideTarget.widthFrom = _viewWidth;
			resizeHideTarget.widthTo = 0;
			resizeHideTarget.heightFrom = _viewHeight;
			resizeHideTarget.heightTo = 0;
			showParallel.addChild(resizeHideTarget);
			//targetEffects.push(resizeHideTarget);
			
			var moveHideTarget : Move = new Move();
			moveHideTarget.duration = playDuration;
			moveHideTarget.xFrom = 0;
			moveHideTarget.yFrom = 0;
			moveHideTarget.xTo = viewCenterPoint.x;
			moveHideTarget.yTo = viewCenterPoint.y;	
			showParallel.addChild(moveHideTarget);
			//targetEffects.push(moveHideTarget);
			
			var hideFideTarget : Fade = new Fade(target);
			hideFideTarget.duration = playDuration;
			hideFideTarget.alphaFrom = 1;
			hideFideTarget.alphaTo = 0;
			showParallel.addChild(hideFideTarget);
			targetEffects.push(hideFideTarget);
			
			isAddTargetEffect = true;
		}
	}
		
		
	private function createEffect(target : Object,
								  showPoint : Point,
								  hidePoint : Point) : void
	{
		var showMove : Move = new Move(target);
		showMove.duration = playDuration;
		showMove.xFrom = hidePoint.x;
		showMove.yFrom = hidePoint.y;
		showMove.xTo = showPoint.x;
		showMove.yTo = showPoint.y;			
		showParallel.addChild(showMove);
		
		var showFide : Fade = new Fade(target);
		showFide.duration = playDuration;
		showFide.alphaFrom = 0;
		showFide.alphaTo = 1;
		showParallel.addChild(showFide);
		
		var hideMove : Move = new Move(target);
		hideMove.duration = playDuration;
		hideMove.xFrom = showPoint.x;
		hideMove.yFrom = showPoint.y;
		hideMove.xTo = hidePoint.x;
		hideMove.yTo = hidePoint.y;			 
		hideParallel.addChild(hideMove);		
		
		var hideFide : Fade = new Fade(target);
		hideFide.duration = playDuration;
		hideFide.alphaFrom = 1;
		hideFide.alphaTo = 0;
		hideParallel.addChild(hideFide);
	}
		
		
	public function playShow() : void
	{
		if(showParallel)
		{
			_target.alpha = 0;
			showParallel.play();
		}
	}
	
	public function playHide() : void
	{
		if(hideParallel)
		{
			_target.alpha = 1;
			hideParallel.play();		
		}
	}
	
	
}
}