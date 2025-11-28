package com.struts.layout
{
import mx.core.ILayoutElement;

import spark.components.supportClasses.GroupBase;
import spark.layouts.supportClasses.LayoutBase;

public class RingLayout extends LayoutBase
{
	public function RingLayout()
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
	
	
	private var _rowNumber : int = 10;

	public function get rowNumber():int
	{
		return _rowNumber;
	}

	public function set rowNumber(value:int):void
	{
		_rowNumber = value;
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
		
		
		//var i : int = 0;
		//var rows : Number = 1;
		/**
		 *  最后个数的计数
		 * */
		var lastElementCount : Number = 0;

		var layoutElement : ILayoutElement = layoutTarget.getElementAt(0);
		var layoutElementWidth : Number = 0;
		var layoutElementHeight : Number =  layoutElement.getLayoutBoundsWidth() || layoutElement.getMinBoundsWidth();
		
		var startX : Number = -(layoutElementHeight/2);
		var startY : Number = 0;
		var isOdd : Boolean = true;
		
		
		var rows : int = Math.ceil(count / _rowNumber);
		
		var index : int = 0;
		for (var row : int = 0; row < rows;row++)
		{
			
			startX = row % 2 == 0 ? 0 : startX - gap - layoutElementWidth + _offsetX;
			startY = startY + _snakeRowHeight * row;
			for (var col : int = 0 ; col <= _rowNumber;col++)
			{
				index = row * _rowNumber + col;
				
				if(index >= count)
					return;
				
				if((count - 1) > index)
				{
					nextlayoutElement = layoutTarget.getElementAt(index + 1);
					nextlayoutElementWidth = nextlayoutElement.getLayoutBoundsWidth() || nextlayoutElement.getMinBoundsWidth();
				}		
				
				layoutElement = layoutTarget.getElementAt(index);	
				layoutElementWidth =  layoutElement.getLayoutBoundsWidth() || layoutElement.getMinBoundsWidth();
				layoutElementHeight = layoutElement.getLayoutBoundsHeight() || layoutElement.getMinBoundsHeight();
				layoutElement.setLayoutBoundsSize(layoutElementWidth,layoutElementHeight);

				layoutElement.setLayoutBoundsPosition(startX,startY + _offsetY);
				
				if(row % 2 == 0)
				{
					startX = startX + gap + layoutElementWidth;
				}
				else
				{
					startX = startX - gap - nextlayoutElementWidth;
				}
			}
		}
	}
}
}















