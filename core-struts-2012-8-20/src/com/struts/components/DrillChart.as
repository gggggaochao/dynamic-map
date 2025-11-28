package com.struts.components
{
import spark.components.Button;
import spark.components.Group;
import spark.components.supportClasses.SkinnableComponent;


/**
 *
 * Drill down Chart
 *  
 * @author ZhouHan
 * 
 */
public class DrillChart extends SkinnableComponent
{
	
	[SkinPart(required="false")]
	public var perDrill : Button;
	
	[SkinPart(required="false")]
	public var nextDrill : Button;
	
	[SkinPart(required="false")]
	public var maxMove : Button;
	
	[SkinPart(required="false")]
	public var minMove : Button;
	
	[SkinPart(required="false")]
	public var trackGroup : Group;
	
	[SkinPart(required="false")]
	public var headGroup : Group;
	
	private var _minnum : Number;

	public function get minnum():Number
	{
		return _minnum;
	}

	public function set minnum(value:Number):void
	{
		_minnum = value;
	}

	
	private var _maxnum : Number;

	public function get maxnum():Number
	{
		return _maxnum;
	}

	public function set maxnum(value:Number):void
	{
		_maxnum = value;
	}
	
	
	private var _minYear : int = 1980;

	
//	/**
//	 * 
//	 *  单位
//	 *  
//	 */	
//	private var _unit : String = "Y";
//
//	public function get unit():String
//	{
//		return _unit;
//	}
//
//	[Inspectable(category="General", enumeration="Y,M,D,HH,MM,SS", defaultValue="Y")]
//	
//	public function set unit(value:String):void
//	{
//		_unit = value;
//	}
	
	private var yearGap : int;
	
	private var monthGap : int;
	
	/**
	 *  时间间隔 
	 */	
	private var _dateGap : int = 3;

	private var _nowYear : int;
	
	public function DrillChart()
	{
		super();
		_nowYear = new Date().fullYear;
	}
	
	override protected function measure():void
	{
		super.measure();
	}
	
	override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
	{
		super.updateDisplayList(unscaledWidth, unscaledHeight);
		
		updateTrackLayout(unscaledWidth,unscaledHeight);
		
	}
	
	
	
	private function updateTrackLayout(cw : Number,ch : Number) : void
	{
		 yearGap = Math.floor(cw / (_nowYear - _minYear));
		
		monthGap = Math.floor(yearGap / 12);
		
		
		
	}
	
	
	
}
}







































