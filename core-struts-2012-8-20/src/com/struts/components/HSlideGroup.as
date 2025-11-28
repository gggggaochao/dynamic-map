package com.struts.components
{
	
import flash.events.Event;
import flash.events.MouseEvent;

import mx.collections.ArrayCollection;
import mx.core.IVisualElement;
import mx.events.EffectEvent;

import spark.components.Button;
import spark.components.ButtonBar;
import spark.components.HGroup;
import spark.components.SkinnableContainer;
import spark.core.NavigationUnit;
import spark.effects.Animate;
import spark.effects.animation.MotionPath;
import spark.effects.animation.SimpleMotionPath;

[Event(name="change", type="flash.events.Event")]

public class HSlideGroup extends SkinnableContainer
{
	
	[SkinPart(required="false")]
	public var pageBar : ButtonBar;
	
	[SkinPart(required="false")]
	public var preButton : MButton;
	
	[SkinPart(required="false")]
	public var nextButton : MButton;	
	
	private var anmiate : Animate;
	
	private var smp : SimpleMotionPath;
	
	private var _isPlaying : Boolean = false;
	

	
	private var _sumPage : int = 0;

	private var _sumPageChange : Boolean;

	public function get sumPage():int
	{
		return _sumPage;
	}

	public function set sumPage(value:int):void
	{
		if(_sumPage == value)
			return;
		
		_sumPage = value;
		_sumPageChange = true;
		
		invalidateProperties();
	}

	private var _oldPage : int;
	
	private var _currentPage:int = 0;
	
	private var _currentPageChange : Boolean;
	
	public function get currentPage():int
	{
		return _currentPage;
	}

	public function set currentPage(value:int):void
	{
		if(_currentPage == value)
			return;
		
		_oldPage = _currentPage;
		_currentPage = value;
		_currentPageChange = true;
		
		invalidateProperties();

	}
	
	
	public function HSlideGroup()
	{
		init();
		
		addHandlers();
	}
	
	
	private function init() : void
	{
		
		smp = new SimpleMotionPath("horizontalScrollPosition");
		
		var motionPaths : Vector.<MotionPath> = new Vector.<MotionPath>();
		motionPaths.push(smp);
		
		anmiate = new Animate();
		anmiate.motionPaths = motionPaths;	
		anmiate.addEventListener(EffectEvent.EFFECT_END,effectEndHandler);
	}
	
	
	private function addHandlers() : void
	{
		addEventListener(MouseEvent.MOUSE_DOWN,mouseEventHandler);
		addEventListener(MouseEvent.MOUSE_UP,mouseEventHandler);
		addEventListener(MouseEvent.MOUSE_OUT,mouseEventHandler);
	}
	
	
	private var startX : Number;
	
	private var endX : Number;
	
	private var ops : Array = new Array();
	
	private function mouseEventHandler(event : MouseEvent) : void
	{
		if(event.target is Button)
			return;
		
		switch(event.type)
		{
			case MouseEvent.MOUSE_DOWN : 
			{
				startX = mouseX;
				break;
			}
			case MouseEvent.MOUSE_UP : 
			case MouseEvent.MOUSE_OUT :
			{
				var endX : Number = mouseX;
				if ( !isNaN(startX) && Math.abs(startX - endX) > 20)
				{
					if (startX > endX)
						nextPageHandler(event);
					else
						prePageHandler(event);
					
					startX = NaN;
				}
				break;
			}
		}
	}
	
	
	
	/**
	 * 下一页
	 */
	protected function nextPageHandler(event:Event):void
	{
		if(_currentPage >= _sumPage)
			return;

		if(_isPlaying)
		{
			ops.push("Next");
			return;
		}
		
		_isPlaying = true;
		currentPage ++;
	}
	
	/**
	 * 上一页
	 */
	protected function prePageHandler(event:Event):void
	{
		if(_currentPage <=1)
			return;
		
		if(_isPlaying)
		{
			ops.push("Pre");
			return;
		}
		
		_isPlaying = true;
		currentPage--;
	}
	
	private function effectEndHandler(event : Event) : void
	{
		_isPlaying = false;
		
		for each(var op : String in ops)
		{
			ops.splice(0, 1);

			if (op == "Next")
				nextPageHandler(event);
			else
				prePageHandler(event);
		}
	}
	
	protected override function commitProperties(): void
	{
		super.commitProperties();
	
		if(_sumPageChange)
		{
			_sumPageChange = false;
			
			var pages : ArrayCollection = new ArrayCollection();
			for (var i : int = 1 ; i <= _sumPage;i++)
				pages.addItem(i);
			
			
			_currentPage = 1;
			pageBar.selectedIndex = 0;
			pageBar.dataProvider = pages;
		}
	
		if(_currentPageChange)
		{
			_currentPageChange = false;
			
			
			var pageDelta : uint = _currentPage > _oldPage ? NavigationUnit.PAGE_RIGHT : NavigationUnit.PAGE_LEFT;
			
			smp.valueBy = contentGroup.getHorizontalScrollPositionDelta(pageDelta);
			anmiate.play();
			
			if(pageBar)
			{
				pageBar.selectedIndex = _currentPage - 1;
			}
			
			dispatchEvent(new Event("change"));
		}
	}
	
	
	override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
	{
		super.updateDisplayList(unscaledWidth,unscaledHeight);
	
	    var count:int = contentGroup.numElements;
		
		if(count == 0)
			return;
		
		
		sumPage = count;
		
		var viewElement : IVisualElement;
		
		for (var i : int = 0;i<count; i++)
		{
			viewElement = contentGroup.getElementAt(i);
			viewElement.width = unscaledWidth;
			viewElement.height = unscaledHeight;
		}
	
	}	
	
	override protected function partAdded(partName:String, instance:Object):void
	{
		super.partAdded(partName, instance);
		
		if(instance == contentGroup)
		{
			contentGroup.clipAndEnableScrolling = true;
			anmiate.target = contentGroup;
		}
		
		if(instance == preButton)
		{
			preButton.addEventListener(MouseEvent.CLICK,prePageHandler);
		}
		
		if(instance == nextButton)
		{
			nextButton.addEventListener(MouseEvent.CLICK,nextPageHandler);
		}
	}
}
}








