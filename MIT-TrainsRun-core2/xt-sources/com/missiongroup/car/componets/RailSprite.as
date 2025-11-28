package com.missiongroup.car.componets
{
import com.struts.utils.DrawUtil;

import flash.display.BitmapData;
import flash.display.GraphicsPathCommand;
import flash.display.Sprite;
import flash.geom.Point;
import flash.net.FileReference;
import flash.utils.ByteArray;

import mx.core.UIComponent;
import mx.graphics.codec.PNGEncoder;

public class RailSprite extends UIComponent
{

	public var rails : Array;
	
	public var isSort : Boolean = false;
	
	private var passFill : uint;
	
	private var currFill : uint;
	
	private var bgFill : uint;
	
	private var _fills : Array;
	
	
	private var _index : Number = -1;

	public function get index():Number
	{
		return _index;
	}

	public function set index(value:Number):void
	{
		value = Math.floor(value);
		if(_index != value)
		{
		  _index = value;
		  draw();
		}
	}


	public function set fills(value:Array):void
	{
		if(value)
		{
			_fills = value;
			passFill = value[0];
			currFill = value[1];
			bgFill = value[2];
		}
	}

	public function RailSprite()
	{
		super();
	}
	
	public function drawPass() : void
	{
		drawFill(rails,passFill);		
	}
	
//	private static var _drawTimes:int = 0;
	public function drawNormal() : void
	{
		graphics.clear();
		drawFill(rails,bgFill);
		
//		if(_drawTimes == 0){
//			_drawTimes = 1;
//			var bd:BitmapData = new BitmapData(this.width , this.height , true , 0);
//			bd.draw(this);
//			var encode:PNGEncoder = new PNGEncoder();
//			var byte:ByteArray = encode.encode(bd);
//			var f:FileReference = new FileReference();
//			f.save(byte,'1.png');
//			trace('save bitmapdata');
//		}
		
	}
	
	public function draw() : void
	{
		var cx : Number = width / 2;
		var cy : Number = height / 2;
		var r : Number = width / 2;

		var narmalArray : Array;
		
		var isFill : Boolean = true;
		this.graphics.clear();
		
		drawNormal();
		
		if(index >= 0 && index < rails.length)
		{
			
			var currRails : Array = rails[index];
			drawPoints(currRails,currFill);
			
			var passArray : Array = isSort ? rails.slice(index) : rails.slice(0,index);
//			
//			narmalArray = isSort ? rails.slice(0,index) :  rails.slice(index);
//			
			drawFill(passArray,passFill);
		}
		
//		if(!narmalArray)
//		{
//			narmalArray = rails;
//			isFill = false;
//		}
//
//		drawFill(narmalArray,bgFill);
	}
	
	private function drawFill(draws : Array,_bgFill : uint) : void
	{
		if(draws && draws.length)
		{
			var points : Array;
			for (var i : int = 0; i<draws.length;i++)
			{
				points = draws[i];
				drawPoints(points,_bgFill)
			}	
		}
	}

	private function drawPoints(points : Array,_bgFill : uint) : void
	{
		if(points && points.length)
		{
			var point : Point = points[0];
			
			graphics.beginFill(_bgFill);
			graphics.moveTo(point.x,point.y);
			for (var i : int = 1; i<points.length;i++)
			{
				point = points[i];
				graphics.lineTo(point.x,point.y);
			}	
			graphics.endFill();
		}
	}
}
}








