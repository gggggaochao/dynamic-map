package com.struts.utils
{
	
import flash.events.TimerEvent;
import flash.utils.Timer;

import spark.core.IDisplayText;

public final class TimerUtil
{

	public static function bulidTimer(delay : Number = 1000,
									  timerRuningHandler : Function = null,
									  repeatCount : int = 0,
									  timerCompleteHandler : Function = null) : Timer
	{
		var timer : Timer = new Timer(delay,repeatCount);
		
		if(timerRuningHandler != null)
			timer.addEventListener(TimerEvent.TIMER,timerRuningHandler);
		if(timerCompleteHandler != null)
			timer.addEventListener(TimerEvent.TIMER_COMPLETE,timerCompleteHandler);
		
		return timer;
	}
	
	
	/**
	 *
	 * 分秒倒计时显示  
	 *  
	 * @param dis
	 * @param time  秒数  不能大于 3600
	 * @param timerCompleteHandler  倒计时结束后回调函数
	 * @param delay
	 * 
	 */	
	public static function timeCountDown(dis : IDisplayText,
										 time : int,
										 callBackTimerCompleteHandler : Function = null) : void
	{
		if(time >= 3600 || time <= 0)
			return;
		
		function setTimeDisText(count : Number) : String
		{
			var minutes : Number = Math.floor(count / 60);
			var seconds : Number = count % 60;
			
			return (minutes < 10 ? "0"+minutes : minutes) + ":" + (seconds < 10 ? "0"+seconds : seconds);
		}
		
		function timerRuningHandler(event : TimerEvent) : void
		{
			time--;
			dis.text = setTimeDisText(time);
		}
		
		function timerCompleteHandler(event : TimerEvent) : void
		{
			timer = null;
			if(callBackTimerCompleteHandler != null)
				callBackTimerCompleteHandler();
		}
		
		dis.text = setTimeDisText(time);
		
		var timer : Timer = bulidTimer(1000,timerRuningHandler,time,timerCompleteHandler);
		timer.start();
	}
}
}






















