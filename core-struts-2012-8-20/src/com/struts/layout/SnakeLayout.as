package com.struts.layout
{
	
import flash.geom.Rectangle;

import mx.core.ILayoutElement;
import mx.core.IVisualElement;
import mx.core.IVisualElementContainer;

import spark.components.supportClasses.GroupBase;
import spark.layouts.supportClasses.LayoutBase;
import spark.primitives.BitmapImage;


/**
 *
 * 蛇形布局
 *  
 * @author ZhouHan
 * 
 */
public class SnakeLayout extends LayoutBase
{
	public function SnakeLayout()
	{
		super();
	}
	
	private var _gap : int = 10;

	public function get gap():int
	{
		return _gap;
	}

	public function set gap(value:int):void
	{
		_gap = value;
	}
	
	private var _snakeRowHeight : int;

	public function get snakeRowHeight():int
	{
		return _snakeRowHeight;
	}

	public function set snakeRowHeight(value:int):void
	{
		_snakeRowHeight = value;
	}
	
	
	private var _offsetY : int = 0;

	public function get offsetY():int
	{
		return _offsetY;
	}

	public function set offsetY(value:int):void
	{
		_offsetY = value;
	}
	
	private var _offsetX : int = 0;

	public function get offsetX():int
	{
		return _offsetX;
	}

	public function set offsetX(value:int):void
	{
		_offsetX = value;
	}
	
	
	private var _snakeGroup : IVisualElementContainer;

	public function set snakeGroup(value:IVisualElementContainer):void
	{
		_snakeGroup = value;
	}

	private var _oddRailImage : Object;

	public function set oddRailImage(value:Object):void
	{
		_oddRailImage = value;
	}

	
	private var _evenRailImage : Object;

	public function set evenRailImage(value:Object):void
	{
		_evenRailImage = value;
	}
	
	private var _lastRailImgae : Object;

	public function set lastRailImgae(value:Object):void
	{
		_lastRailImgae = value;
	}


	/**
	 * 
	 * @param unscaledWidth
	 * @param unscaledHeight
	 * 
	 */
	override public function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
	{
		
		super.updateDisplayList(unscaledWidth,unscaledHeight);
		
		var layoutTarget : GroupBase = target;
		if(!layoutTarget)
			return;

		var count:int = layoutTarget.numElements;
		
		if(count == 0)
			return;

		var nextlayoutElement : ILayoutElement;
		var nextlayoutElementWidth : Number = 0;
		
		var i : int = 0;

		var rows : Number = 1;
		
		/**
		 *  最后个数的计数
		 * */
		var lastElementCount : Number = 0;
		//_gap = (unscaledWidth * rows -  sumLength) / (count - 1 - rows - 1);

		var layoutElement : ILayoutElement = layoutTarget.getElementAt(0);
		var layoutElementWidth : Number = 0;
		var layoutElementHeight : Number =  layoutElement.getLayoutBoundsWidth() || layoutElement.getMinBoundsWidth();
		var startX : Number = -(layoutElementHeight/2);
		var startY : Number = 0;
		var isOdd : Boolean = true;
		for (i = 0 ; i < count; i++)
		{
			if((count - 1) > i)
			{
				nextlayoutElement = layoutTarget.getElementAt(i + 1);
				nextlayoutElementWidth = nextlayoutElement.getLayoutBoundsWidth() || nextlayoutElement.getMinBoundsWidth();
			}
			
			layoutElement = layoutTarget.getElementAt(i);
			layoutElementWidth =  layoutElement.getLayoutBoundsWidth() || layoutElement.getMinBoundsWidth();
			layoutElementHeight = layoutElement.getLayoutBoundsHeight() || layoutElement.getMinBoundsHeight();
			layoutElement.setLayoutBoundsSize(layoutElementWidth,layoutElementHeight);
			
			layoutElement.setLayoutBoundsPosition(startX,startY + _offsetY);
			lastElementCount++;
			
			if(i == (count - 1))
				break;
			
			if(isOdd)
			{
				
				startX = startX + gap + layoutElementWidth;
				
				if(startX > (unscaledWidth - nextlayoutElementWidth))
				{
					rows++;
					isOdd = false;
					lastElementCount = 0;
					startX = unscaledWidth - nextlayoutElementWidth + layoutElementHeight / 2;
					startY = startY + _snakeRowHeight;
				}
			}
			else
			{

				startX = startX - gap - nextlayoutElementWidth;
				
				if(startX < 0)
				{
					rows++;
					isOdd = true;
					lastElementCount = 0;
					startX = - (layoutElementHeight / 2);
					startY = startY + _snakeRowHeight;
				}
			}		
			
		}
		
		
		var lastRtg : Rectangle = new Rectangle();
		if(isOdd)
		{
			lastRtg.x = 0;
			lastRtg.y = startY;
			lastRtg.width = startX + layoutElementWidth / 2;
		}
		else
		{
			lastRtg.x = startX + layoutElementWidth / 2;
			lastRtg.y = startY;
			lastRtg.width = unscaledWidth - lastRtg.x;			
		}
				
		//parentHeight = rows * _snakeRowHeight;
		
		updateSnakeRails(rows,_snakeRowHeight,lastRtg);
//		var ev : SnakeEvent = new SnakeEvent(SnakeEvent.SNAKE_LAYOUT_COMPLETE);
//		ev.rows = rows;
//		ev.rowHeight = _snakeRowHeight;
//		ev.lastRect = lastRtg;
//		layoutTarget.dispatchEvent(ev);
		//layoutTarget.addEventListener("snakeLayouted"
	}

	
	private var lastRailImage : BitmapImage = new BitmapImage();
	
	private function updateSnakeRails(rows : int,rowHeight : Number,lastRtg : Rectangle) : void
	{
		if(_snakeGroup)
		{
			_snakeGroup.removeAllElements();
			
			var isOdd : Boolean;
			var railImage : IVisualElement;
			
			
			for (var i : int = 1;i<rows;i++)
			{
				isOdd = i % 2 != 0;

				railImage = createRail(isOdd,(i - 1));
				railImage.y = rowHeight * (i - 1);
				_snakeGroup.addElement(railImage);
			}

			lastRailImage.x = lastRtg.x;
			lastRailImage.y = lastRtg.y;
			lastRailImage.width = lastRtg.width;
			lastRailImage.smooth = true;
			lastRailImage.source = _lastRailImgae;
			_snakeGroup.addElement(lastRailImage);

		}
	}
	
	private var railStore : Array = new Array();
	
	private function createRail(isOdd : Boolean,index : int) : IVisualElement
	{
		
		var source : Object = isOdd ? _oddRailImage : _evenRailImage;
		
		var img : BitmapImage;
		
		if(railStore.length <= index)
		{
			img = new BitmapImage();
			img.smooth = true;
			railStore.push(img);
		}

		img = railStore[index]; 
		img.source = source;
		
		return img;
	}
	
	
	
}


}










