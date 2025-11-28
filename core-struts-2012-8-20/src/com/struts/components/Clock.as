package com.struts.components
{
import flash.events.Event;
import flash.events.TimerEvent;
import flash.utils.Timer;

import mx.formatters.DateFormatter;

import spark.components.Group;
import spark.components.Image;
import spark.components.Label;
import spark.components.supportClasses.SkinnableComponent;
import spark.primitives.BitmapImage;
	
[SkinState("analog")]

[SkinState("number")]


[Event(name="timeDateChange", type="flash.events.Event")]

[Event(name="faceChange", type="flash.events.Event")]

[Style(name="backgroundIcon", type="Object", inherit="no")]

[Style(name="hoursIcon", type="Object", inherit="no")]

[Style(name="minutesIcon", type="Object", inherit="no")]

[Style(name="secondsIcon", type="Object", inherit="no")]

[Style(name="hoursOffset", type="Number", format="Length", inherit="no", theme="spark", minValue="0.0")]

[Style(name="minutesOffset", type="Number", format="Length", inherit="no", theme="spark", minValue="0.0")]

[Style(name="secondsOffset", type="Number", format="Length", inherit="no", theme="spark", minValue="0.0")]
/**
 * 时钟
 * @author ZhouHan
 */	
public class Clock extends SkinnableComponent
{
	
	//--------------------------------------------------------------------------
	//
	// Variables
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @private
	 */		
	private var timer:Timer;
	
	//--------------------------------------------------------------------------
	//
	// Constructor
	//
	//--------------------------------------------------------------------------

	
	/**
	 * Constructor
	 */		
	public function Clock()
	{
		super();
		addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
		
		_dateFormatter = new DateFormatter();
		_dateFormatter.formatString = _dateFormatString;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Skin parts 
	//
	//--------------------------------------------------------------------------
	
	/**
	 * 时钟背景表盘
	 */	
	[SkinPart(required="false")]
	public var background : Image;
	
	/**
	 * 时钟的时针
	 */	
	[SkinPart(required="true")]
	public var hourPointer : Group;
	
	/**
	 * 时钟的分针
	 */	
	[SkinPart(required="true")]
	public var minutePointer : Group;
	
	/**
	 * 时钟的秒针
	 */
	[SkinPart(require="true")]
	public var secondPointer : Group;
	
	
	[SkinPart(required="true")]
	public var labelDisplay : Label;
	
	//--------------------------------------------------------------------------
	//
	//  Properties simulate
	//
	//--------------------------------------------------------------------------
	
	public static const ANALOG : String = "analog";
	
	public static const NUMBER : String = "number";
	
	public var normalWidth : Number = 0;
	
	public var normalHeight: Number = 0;
		
	private var _clockMode : String = "analog";

	private var _clockMdoeChange : Boolean = false;
	
	[Inspectable(category="General", enumeration="analog,number", defaultValue="analog")]
	public function get clockMode():String
	{
		return _clockMode;
	}

	public function set clockMode(value:String):void
	{
		if(_clockMode === value)
			return;
		
		_clockMode = value;
		_clockMdoeChange = true;
		invalidateProperties();
	}

	
	private var _dateFormatter : DateFormatter;
	
	private var _dateFormatString : String = "HH:NN:SS";

	[Inspectable(category="General", enumeration="HH:NN:SS,HH:NN", defaultValue="HH:NN:SS")]
	public function get dateFormatString():String
	{
		return _dateFormatString;
	}

	public function set dateFormatString(value:String):void
	{
		_dateFormatString = value;
		_dateFormatter.formatString = value;
	}

	
	//--------------------------------------------------------------------------
	//
	//  Overridden methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @private
	 */		
	override protected function partAdded(partName:String, instance:Object):void
	{
		super.partAdded(partName, instance);
		
		if(instance == background)
		{
			background.addEventListener(Event.COMPLETE,backGroundHandler);
		}
	}
	protected override function commitProperties(): void
	{
		super.commitProperties();
	
		if(_clockMdoeChange)
		{
			_clockMdoeChange = false;
			this.skin.currentState = _clockMode;
			this.skin.invalidateDisplayList();
		}
	}
	
	
	private var currClockFace : *;
	
	override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
	{
		super.updateDisplayList(unscaledWidth, unscaledHeight);
	}
	
	private function backGroundHandler(event : Event) : void
	{
		normalWidth = background.sourceWidth;
		normalHeight = background.sourceHeight;
		
		if(currClockFace != getStyle("backgroundIcon"))
		{
			currClockFace = getStyle("backgroundIcon");
			dispatchEvent(new Event("faceChange"));
		}
	}
	
	//--------------------------------------------------------------------------
	//
	//  Event Handlers
	//
	//--------------------------------------------------------------------------
	
	
	[Bindable(event="timeChange")]
	public function getCurrTime() : Date
	{
		var d:Date = new Date();
		return d;
	}
	
	/**
	 * @private
	 */
	
	private var _day : int = 0;
	
	//private var _currDate : Date;
	
	protected function timerHandler(event:TimerEvent):void
	{
		var _currDate : Date = new Date();
		dispatchEvent(new Event("timeChange"));
		
		if(_day != _currDate.date)
		{
			dispatchEvent(new Event("timeDateChange"));
		}
		_day = _currDate.date;
		
		if(_clockMode == ANALOG)
		{
			if(hourPointer != null && minutePointer != null && secondPointer != null)
			{
				// 秒针角度
				var secondAngle:Number = 360 / 60 * _currDate.seconds;
				// 分针角度
				var minuteAngle:Number = 360 / 60 * _currDate.minutes /* 分针角度*/ + 360 / 60 * _currDate.seconds / 60/* 秒针角度比例*/;
				var hourAngle:Number = 360 / 12 * _currDate.hours /* 时针角度*/ + 360 / 12 * _currDate.minutes / 60;/* 分针角度比例*/
				
				hourPointer.rotation = hourAngle - 90;
				minutePointer.rotation = minuteAngle - 90;
				secondPointer.rotation = secondAngle - 90;
			}
		}
		else
		{
			//labelDisplay.setStyle('color',0xFFFFFF);
			labelDisplay.text = _dateFormatter.format(_currDate) ;
		}

	}
	
	/**
	 * @private
	 */
	private function addedToStageHandler(event:Event):void
	{
		timer = new Timer(1000, 0);
		timer.addEventListener(TimerEvent.TIMER, timerHandler);
		timer.start();
	}
	
	/**
	 * @private
	 */
	private function removedFromStageHandler(event:Event):void
	{
		timer.stop();
	}
}
}