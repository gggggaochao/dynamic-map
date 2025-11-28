package com.struts.components
{

import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Point;

import mx.core.FlexGlobals;
import mx.core.IVisualElement;
import mx.core.IVisualElementContainer;
import mx.core.UIComponent;
import mx.events.FlexEvent;
import mx.graphics.SolidColor;
import mx.managers.CursorManager;

import spark.components.Button;
import spark.components.Group;
import spark.components.Label;
import spark.components.SkinnableContainer;
import spark.primitives.Rect;
import spark.primitives.supportClasses.GraphicElement;

/**
 *   窗体标题栏的颜色渐变
 */
[Style(name="headerColors", type="Array", arrayType="uint",format="Color", inherit="yes", theme="spark, mobile")]



/**
 *
 *   窗体圆角的度数
 *  
 */
[Style(name="cornerRadius", type="Number", format="Length", inherit="no", theme="spark", minValue="0.0")]

/**
 *
 *   头部高度
 *  
 */
[Style(name="headerHeight", type="Number", format="Length", inherit="no", theme="spark", minValue="0.0")]


/**
 *
 *   边框颜色
 *  
 */
[Style(name="borderColor", type="uint", format="Color", inherit="no", theme="spark")]


/**
 *
 *   边框颜色
 *  
 */
[Style(name="headerFontColor", type="uint", format="Color", inherit="no", theme="spark")]

[Event(name="show",type="flash.events.Event")]

[Event(name="close",type="flash.events.Event")]

public class Window extends SkinnableContainer
{
	
	public static var SHOW : String = "show";
	
	public static var CLOSE : String = "close";
	
	[SkinPart(required="false")]
	public var closeButton : Button;

	[SkinPart(required="false")]
	public var resizeButton : Button;
	
	[SkinPart(required="false")]
	public var titleDisplayLabel: Label;
	
	[SkinPart(required="false")]
	public var headGroup : Group;
	
	[Embed(source="/resources/images/window/w_resizecursor.png")]
	public var resizeCursor:Class;	
	
	
	public var stageDocment : IVisualElementContainer;
	
	private var parentDocment : IVisualElementContainer;
	/** 
	 * 
	 * 窗体标题 
	 * 
	 * */
	private var _title : String;

	public function get title():String
	{
		return _title;
	}

	public function set title(value:String):void
	{
		_title = value;
		
		if(titleDisplayLabel)
		{
			titleDisplayLabel.text = title;
		}
	}
	
	/**
	 *  设置窗体显示或隐藏，不进行删除
	 * 
	 * */
	private var _isHideOrDisplay : Boolean = false;

	public function get isHideOrDisplay():Boolean
	{
		return _isHideOrDisplay;
	}

	public function set isHideOrDisplay(value:Boolean):void
	{
		_isHideOrDisplay = value;
	}

	
	private var _isDrag : Boolean = true;

	public function get isDrag():Boolean
	{
		return _isDrag;
	}

	public function set isDrag(value:Boolean):void
	{
		_isDrag = value;
		
		if(headGroup)
		{
			if(_isDrag)
				headGroup.addEventListener(MouseEvent.MOUSE_DOWN,addDragEventListener);
			else
				headGroup.removeEventListener(MouseEvent.MOUSE_DOWN,addDragEventListener);
		}
	}
	
	
	private var _isResize : Boolean = true;

	public function get isResize():Boolean
	{
		return _isResize;
	}

	public function set isResize(value:Boolean):void
	{
		_isResize = value;
		
		if(resizeButton)
		{
			if(_isResize)
			{
				resizeButton.addEventListener(MouseEvent.MOUSE_OVER, resizeOverHandler);
				resizeButton.addEventListener(MouseEvent.MOUSE_OUT, resizeOutHandler);
				resizeButton.addEventListener(MouseEvent.MOUSE_DOWN,resizeDownHandler);
			}
			else
			{
				resizeButton.removeEventListener(MouseEvent.MOUSE_OVER, resizeOverHandler);
				resizeButton.removeEventListener(MouseEvent.MOUSE_OUT, resizeOutHandler);
				resizeButton.removeEventListener(MouseEvent.MOUSE_DOWN,resizeDownHandler);				
			}
			resizeButton.visible = value;
		}
	}

	public function Window()
	{
		super();
		
		includeInLayout = false;
		stageDocment = FlexGlobals.topLevelApplication as IVisualElementContainer;
		
		addEventListener(MouseEvent.CLICK,setAboveElementIndex);
		addEventListener(FlexEvent.CREATION_COMPLETE,createCompleteHandler);
		//addEventListener(Event.REMOVED_FROM_STAGE,removedFromStageHandler);
		
	}
	
	protected override function commitProperties():void
	{
		super.commitProperties();
		
		
		
		
		
	}
	
	
	protected override function partAdded(partName:String, instance:Object):void
	{
		super.partAdded(partName, instance);
		
		if(instance == closeButton)
		{
			closeButton.addEventListener(MouseEvent.CLICK,closeWindowHandler);
		}

		if(instance == resizeButton)
		{
			if(_isResize)
			{
				resizeButton.addEventListener(MouseEvent.MOUSE_OVER, resizeOverHandler);
				resizeButton.addEventListener(MouseEvent.MOUSE_OUT, resizeOutHandler);
				resizeButton.addEventListener(MouseEvent.MOUSE_DOWN,resizeDownHandler);
			}
			resizeButton.visible = _isResize;
		}
		
		if(instance == headGroup)
		{
			if(_isDrag)
				headGroup.addEventListener(MouseEvent.MOUSE_DOWN,addDragEventListener);
		}
		
		if(instance == titleDisplayLabel)
		{
			titleDisplayLabel.text = title;
		}
	}
	
	private function addDragEventListener(event:MouseEvent):void
	{
		if(_isDrag)
		{
			headGroup.addEventListener(MouseEvent.MOUSE_UP,dragStop);
			headGroup.addEventListener(MouseEvent.MOUSE_MOVE,dragStart);
		}
		
		setAboveElementIndex(event);
	}
	
	private function dragStart(event:MouseEvent):void
	{
		this.startDrag(false);	
	}

	private function dragStop(event:Event) : void
	{
		this.stopDrag();
		headGroup.removeEventListener(MouseEvent.MOUSE_UP,dragStop);
		headGroup.removeEventListener(MouseEvent.MOUSE_MOVE,dragStart);
	}
	
	
	/**
	 *  改变窗体大小
	 * 
	 * */
	
	private var cousornumber : int = 0;
	
	private function resizeOverHandler(event:MouseEvent):void
	{
		cousornumber = CursorManager.setCursor(resizeCursor, 2, -5, -5);
	}
	
	private function resizeOutHandler(event:MouseEvent):void
	{
		CursorManager.removeCursor(cousornumber);
	}
	
	
	private function resizeDownHandler(event:MouseEvent):void
	{
		if(_isResize)
		{
			stage.addEventListener(MouseEvent.MOUSE_MOVE, resizeMoveHandler);
			stage.addEventListener(MouseEvent.MOUSE_UP, resizeUpHandler);		
		}
	}
	
	private function resizeUpHandler(event:MouseEvent):void
	{
		stage.removeEventListener(MouseEvent.MOUSE_MOVE, resizeMoveHandler);
		stage.removeEventListener(MouseEvent.MOUSE_UP, resizeUpHandler);
	}
	
	private function resizeMoveHandler(event:MouseEvent):void
	{

		const minimumResizeWidth:Number = minWidth ? minWidth : 160;
		const minimumResizeHeight:Number = minHeight ? minHeight : 100;
		
		const applicationWidth : Number = UIComponent(parentDocment).width;
		const applicationHeight : Number = UIComponent(parentDocment).height;
		
		const maximumResizeWidth:Number = maxWidth ? maxWidth : applicationWidth;
		const maximumResizeHeight:Number = maxHeight ? maxHeight : applicationHeight;		
		
		if ((stage.mouseX < applicationWidth) && (stage.mouseY < applicationHeight))
		{
			var p : Point = this.localToGlobal(new Point(0,0));
			
			var tempWidth : Number = 0;
			var tempHeight : Number = 0;
			
			tempWidth = stage.mouseX - p.x + 5;
			tempHeight = stage.mouseY - p.y + 5;
			
			if (tempWidth > minimumResizeWidth)
			{
				width = tempWidth > maximumResizeWidth ? maximumResizeWidth : tempWidth;
			}
			if (tempHeight > minimumResizeHeight)
			{
				height = tempHeight > maximumResizeHeight ? maximumResizeHeight : tempHeight;
			}
		}
	}

	/**
	 * 
	 * 设置当前窗体为最上层
	 * 
	 * */
	private function setAboveElementIndex(event : Event) : void
	{
		var parentElement : IVisualElementContainer = this.parent as IVisualElementContainer;
		if(parentElement)
		{
			parentElement.setElementIndex(this,parentElement.numElements - 1);	
			
			//event.stopImmediatePropagation();
		}
	}

	
	private function closeWindowHandler(evnet : Event) : void
	{
		if(isDialog)
		{
			isDialog = false;
			stageDocment.removeElement(showShade);
		}
		
		if(parentDocment)
		{
			if(_isHideOrDisplay)
				this.visible = false;
			else
				parentDocment.removeElement(this);
			
			dispatchEvent(new Event(CLOSE));
		}
	}
	
	private var shadeAlpha : Number = 0.5;
	
	private var shadeColor : uint = 0;
	
	
	private var showShade : IVisualElement;
	
	private function createShadeGroup() : IVisualElement
	{
		var solidColor : SolidColor = new SolidColor(shadeColor,shadeAlpha);
		var shade : Rect = new Rect();
		shade.percentWidth = 100;
		shade.percentHeight = 100;
		shade.fill = solidColor;
		
		var group : Group = new Group();
		group.percentWidth = 100;
		group.percentHeight = 100;
		group.addElement(shade);
		
		return group;
	}
	
	/**
	 *  
	 * @param x
	 * @param y
	 * 
	 */	
	
	private var isDialog : Boolean = false;
	
	public function showDialog() : void
	{
		if(!showShade)
		{
			showShade = createShadeGroup();
		}
		
		isDialog = true;		
		stageDocment.addElement(showShade);

		show();
	}
	/**
	 *  新建窗体
	 * 
	 * */
	public function show() : void
	{
		if(parentDocment == null)
		   parentDocment = stageDocment;

		if(_isHideOrDisplay)
			this.visible = true;
		else
			parentDocment.addElement(this);
		
		dispatchEvent(new Event(SHOW));
		//toCenter();
	}
	
	/**
	 * 
	 *   关闭窗体
	 *  
	 * */
	public function close() : void
	{
		closeWindowHandler(null);
	}
	
	private function createCompleteHandler(event : Event) : void
	{
		if(parentDocment != this.parent)
		   parentDocment = this.parent as IVisualElementContainer;
		
		if(x == 0 && y == 0)
			toCenter();	
	}
	
	private function toCenter() : void
	{
		if(this.parent)
		{
			this.x = (this.parent.width - this.width) / 2;
			this.y = (this.parent.height - this.height) / 2;
		}
	}
}
}





























