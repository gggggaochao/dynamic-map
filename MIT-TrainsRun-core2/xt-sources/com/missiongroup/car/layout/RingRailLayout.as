package com.missiongroup.car.layout
{
import com.missiongroup.car.componets.StationRenderer;
import com.missiongroup.car.consts.DisplayDir;
import com.missiongroup.car.skins.LeftEndStationRenderSkin;
import com.missiongroup.car.utils.RailUtils;

import flash.geom.Point;

import mx.core.ILayoutElement;

import spark.components.supportClasses.GroupBase;
import spark.layouts.supportClasses.LayoutBase;

public class RingRailLayout extends LayoutBase
{
	public function RingRailLayout()
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
	
	private var _evenOffsetX : int = -30;

	public function get evenOffsetX():int
	{
		return _evenOffsetX;
	}

	public function set evenOffsetX(value:int):void
	{
		_evenOffsetX = value;
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
	 * 在这里绘制地铁站点位置！！！
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
		
		var layoutElement : ILayoutElement = layoutTarget.getElementAt(0);
		var layoutElementWidth : Number = 0;
		var layoutElementHeight : Number =  layoutElement.getLayoutBoundsWidth() || layoutElement.getMinBoundsWidth();
		
		var startX : Number = -(layoutElementHeight/2);
		var startY : Number = 0;
		var isOdd : Boolean = true;
		
		
		var rows : int = Math.ceil(count / _rowNumber);
		var rowNums:Array;
		if(rows > 2){
			rows = 2;
			var rowNums:Array = [_rowNumber , count - _rowNumber];
		}else{
			rowNums = [_rowNumber , _rowNumber];
		}
		
		var index : int = 0;
		for (var row : int = 0; row < rows;row++)
		{
			
			startX = row % 2 == 0 ? 0 : startX - gap - layoutElementWidth + _offsetX;
			startY = startY + _snakeRowHeight * row;
			for (var col : int = 0 ; col <= rowNums[row];col++)
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
				
				if(layoutElement is StationRenderer){
					
					if((layoutElement as StationRenderer).dir == DisplayDir.LeftEnd){
						var linebp:String;
						var rails:Array;
						if(startX < -50){
							startX -= 20;
							startY = 0;
							linebp = 'left5-02.png';
							rails = RailUtils.getLeftEndPoints2(new Point(10, 10) , new Point(15, 5));
//							rails = RailUtils.getLeftEndPoints(5);
						}else{
							startX -= 30;
							startY = 0;
							linebp = 'left5-01.png';
							rails = RailUtils.getLeftEndPoints(15);
						}
						
						trace('linebp',linebp);
						
//						if((layoutElement as StationRenderer).getStyle('skinClass') != skinClass){
//							(layoutElement as StationRenderer).setStyle('skinClass',skinClass);
//						}
						
						var skin:LeftEndStationRenderSkin = (layoutElement as StationRenderer).skin as LeftEndStationRenderSkin;
						if(skin){
							skin.changeLineBitmap(linebp);
							(layoutElement as StationRenderer).rails = rails;
						}
						
					}
				}
				
				
				layoutElement.setLayoutBoundsPosition(startX,startY + _offsetY);
				
				if(col == _rowNumber && row % 2 == 0)
				{
					startX = startX + evenOffsetX;
					break;
				}
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