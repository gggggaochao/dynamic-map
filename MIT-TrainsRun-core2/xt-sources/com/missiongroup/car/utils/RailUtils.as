package com.missiongroup.car.utils
{
	import com.struts.utils.ArrayUtil;
	import com.struts.utils.GeometryUtil;
	
	import flash.geom.Point;

public class RailUtils
{
	//这些影响箭头
	private static var rightPoints : Array = [new Point(0,0),new Point(5,0),new Point(10,5),new Point(5,10),new Point(0,10),new Point(5,5)];
	
	private static var leftPoints : Array = [new Point(5,0),new Point(0,5),new Point(5,10),new Point(10,10),new Point(5,5),new Point(10,0)];
	
	private static var downPoints : Array = [new Point(0,0),new Point(0,5),new Point(5,10),new Point(10,5),new Point(10,0),new Point(5,5)];
	
	private static var upPoints : Array = [new Point(5,0),new Point(10,5),new Point(10,10),new Point(5,5),new Point(0,10),new Point(0,5)];
	
	
	private static var _nRightPoints : Array;
	
	private static var _nLeftUpPoints : Array;
	
	private static var _nLeftPoints : Array;
	
	private static var _nDownPoints : Array;

	public static function get nDownPoints():Array
	{
		if(!_nDownPoints)
			_nDownPoints = createArcPoints(downPoints,leftPoints,new Point(0,45));
		
		
//		if(!_nDownPoints)
//			_nDownPoints = createRailPoints(downPoints);
		
		return _nDownPoints;
	}

	
	private static var _nUpPoints : Array;

	public static function get nUpPoints():Array
	{
		if(!_nUpPoints)
		{
			_nUpPoints = createArcPoints(upPoints,rightPoints,new Point(0,45));
			_nUpPoints = ArrayUtil.reverse(_nUpPoints).source;
		}
		
//		if(!_nUpPoints)
//			_nUpPoints = createRailPoints(upPoints);
		
		return _nUpPoints;
	}


	public static function get nLeftPoints():Array
	{
		if(!_nLeftPoints)
			_nLeftPoints = createRailPoints(leftPoints);
		
		return _nLeftPoints;
	}

	
	public static function get nRightPoints():Array
	{
		if(!_nRightPoints)
			_nRightPoints = createRailPoints(rightPoints);
		
		return _nRightPoints;
	}
	
	public static function get nLeftUpPoints():Array{
		if(!_nLeftUpPoints)
			_nLeftUpPoints = createArcPoints(upPoints,rightPoints,new Point(0,45));
		return _nLeftUpPoints;
	}
	
	private static var _leftEndPointCache:Object = {};
	public static function getLeftEndPoints(xOffset:Number = 0):Array{
		var points:Array = _leftEndPointCache[xOffset];
		
		if(!points){
			points = createArcPoints(upPoints,rightPoints,new Point(xOffset,45));
			_leftEndPointCache[xOffset] = points;
		}
		
		return points;
	}
	
	public static function getLeftEndPoints2(offsetH:Point = null , offsetV:Point = null):Array{
		
		var ups:Array = upPoints;
		var rps:Array = rightPoints;
		
		if(offsetH){
			ups = [];
			for each(var p:Point in upPoints){
				ups.push(new Point(p.x - offsetH.x , p.y + offsetH.y));
			}
		}
		
		
		if(offsetV){
			rps = [];
			for each(var p:Point in rightPoints){
				rps.push(new Point(p.x - offsetV.x , p.y + offsetV.y));
			}
		}
		
		var points:Array = createArcPoints(ups,rps,new Point(0,45));
		
		return points;
	}
	
	private static function createRailPoints(rails : Array,gap : int = 12) : Array
	{

		var newRails : Array = [];
		
		for (var n : int = 0;n < 4 ; n++)
		{
			var newPoint : Point;
			var oldPoint : Point;
			var points : Array = [];
			
			for (var i : int = 0;i<rails.length;i++)
			{
				oldPoint = rails[i];
				
				newPoint = new Point(oldPoint.x + (gap * n),oldPoint.y);
				points.push(newPoint);
			}
			
			newRails.push(points);
		}
		
		return newRails;
	}
	
	
	private static function createArcPoints(rails : Array,resortRails : Array,cp : Point,gap : int = 12) : Array
	{
		var newRails : Array = [];
		
		var num : int = 9;
		var gapAngle : Number = Math.ceil(180 / num);
		
		var len : Number = rails.length;
		
		var newPoint : Point;
		var oldPoint : Point;
		var r : Number;
		var angle : Number;
		var points : Array;	
		var n : int,i : int;
		
		
		//newRails.push(rails);

//		for (n = 0;n < num ; n++)
//		{		
//			points = [];	
//			for (i = 0;i<len;i++)
//			{
//				oldPoint = rails[i];
//				
//				
//				angle = GeometryUtil.getAngle(cp,oldPoint);
//				r = GeometryUtil.getDist(oldPoint,cp);
//				angle = angle + gapAngle * n;
//				
//				newPoint = GeometryUtil.getPointByAngle(cp.x,cp.y,r,angle);
//				points.push(newPoint);
//			}
//			
//			newRails.push(points);
//		}

		var offsetX : Number = 32;
		var offsetY : Number = 60;
		for (n = 3;n >= 0 ; n--)
		{
			points = [];
			for (i = 0;i<rails.length;i++)
			{
				oldPoint = rails[i];
				
				newPoint = new Point(oldPoint.x + offsetX,oldPoint.y  - (gap * n) + offsetY);
				points.push(newPoint);
			}
			
			newRails.push(points);
		}
		
		
		offsetX = 8 - cp.x;
		offsetY = cp.y * 2 - 10;
		for (n = 0;n <= 3 ; n++)
		{
			points = [];
			for (i = 0;i<resortRails.length;i++)
			{
				oldPoint = resortRails[i];
				
				newPoint = new Point(oldPoint.x - (gap * n) + offsetX,oldPoint.y  + offsetY);
				points.push(newPoint);
			}
			
			newRails.push(points);
		}
		
		
		return newRails;		
	}
	
}
}









