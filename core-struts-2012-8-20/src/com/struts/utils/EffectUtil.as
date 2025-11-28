package com.struts.utils
{
	
import flash.display.Graphics;
import flash.geom.Point;

import mx.core.UIComponent;
import mx.effects.*;
import mx.effects.easing.Quadratic;
import mx.events.EffectEvent;
	
public class EffectUtil
{
	/**
	 * 
	 * 大小和坐标改变动画
	 *  
	 * @param target
	 * @param _x   
	 * @param _y
	 * @param _width
	 * @param _height
	 * @param endFunction
	 * 
	 */	
	public static function playMoveResize(target : UIComponent,_x : Number,_y : Number,_width : Number,_height : Number,
										  endFunction : Function = null) : void
	{
		var sequence : Sequence = new Sequence();
		var parallel : Parallel = new Parallel();
		
		var move : Move = new Move(target);
		move.duration = 200;
		move.xTo = _x;
		move.yTo = _y;
		parallel.addChild(move);
		
		var resize : Resize = new Resize(target);
		resize.duration = 200;
		resize.widthTo  = _width;
		resize.heightTo = _height; 
		parallel.addChild(resize);
		
		sequence.addChild(parallel);
		if(endFunction != null)
		sequence.addEventListener(EffectEvent.EFFECT_END,endFunction);
		sequence.play();			
	}
	
	
	/**
	 *
	 * 隐藏和显示之间的切换，并在之间改变 target 的属性 property 为 value；
	 *  
	 * @param target     作用
	 * @param property   属性值  如：seleceIndex 0
	 * @param value    
	 * @param duration
	 * 
	 */	
	public static function playFadeWidget(target:*, property:String, value:*, duration : Number = 280):void
	{
		var time:Number = duration;
		if (target[property] != value)
		{	    		
			var seqEffect:Sequence = new Sequence();
			var spAction1:SetPropertyAction = new SetPropertyAction(target);
			var pEffect1:Parallel = new Parallel();
			var pEffect2:Parallel = new Parallel();
			var blurEffect1:Fade = new Fade(target);
			var blurEffect2:Fade = new Fade(target);
			
			
			
			pEffect1.duration = time;
			
			
			blurEffect1.duration = time;
			blurEffect1.alphaFrom = 1;
			blurEffect1.alphaTo = 0;
			
			
			pEffect1.addChild(blurEffect1);
			
			spAction1.name = property;
			spAction1.value = value;
			
			pEffect2.duration = time;
			
			
			
			blurEffect2.duration = time;
			blurEffect2.alphaFrom = 0;
			blurEffect2.alphaTo = 1;
			
			pEffect2.addChild(blurEffect2);
			
			
			seqEffect.addChild(pEffect1);
			seqEffect.addChild(spAction1);
			seqEffect.addChild(pEffect2);
			
			seqEffect.play();
		}
	}		
	
	
	
	/**
	 * 
	 * 两点之间绘制线段时的动画 
	 * 
	 *  
	 * @param graphics
	 * @param sP
	 * @param eP
	 * @param duration
	 * @param thickness
	 * @param color
	 * @param alpha
	 * 
	 */	
	public static function playDrawLine(graphics : Graphics,sp : Point,ep : Point,duration : Number = 800,
										thickness : Number = 1,color : Number = 0x000000,alpha : Number = 1) : void
	{
		
		var angle : Number = GeometryUtil.getAngle(sp,ep);
		var dist : Number = GeometryUtil.getDist(sp,ep);
		
		var startValue : Number = 0;
		var endValue : Number = dist;
		
		function onTweenUpdateFunction(val : Object) : void
		{
			startValue = val as Number;
			graphics.clear();
			DrawUtil.drawSectorLine(graphics,sp.x,sp.y,0,startValue,angle,thickness,color,alpha);
		}
		
		function onTweenEndFunction(val : Object) : void
		{
			DrawUtil.drawLine(graphics,sp,ep,thickness,color,alpha);
		}
		
		playTween(startValue,endValue,duration,onTweenUpdateFunction,onTweenEndFunction);	
			
		
	}
	
	
	public static function playDrawPolyline(graphics : Graphics,ps : Array,
											linethickness : Number = 1,
											linecolor : Number = 0xEAEAEA,
											linealpha : Number = 1) : void
	{
		
	}
	
	
	/**
	 *
	 * 补间动画
	 *  
	 * @param startValue  开始值
	 * @param endValue   结束值
	 * @param tweenTime  动画时间
	 * @param onTweenUpdateFunction  间隔期间调用的函数
	 * @param onTweenEndFunction   动画结束后调用的函数
	 * 
	 */	
	public static function playTween(startValue : Object,
									 endValue : Object ,
									 duration:Number,
									 onTweenUpdateFunction : Function,
	                                 onTweenEndFunction : Function = null):void 
	{ 
		
		if(onTweenEndFunction == null)
		   onTweenEndFunction = function(val:Object):void { };
		
		
		var listener:Object = {}; 
		listener.onTweenUpdate = onTweenUpdateFunction;
		listener.onTweenEnd = onTweenEndFunction 
			
		var tween : Tween = new Tween(listener, startValue, endValue, duration); 
		tween.easingFunction = Quadratic.easeInOut; 
	} 
}

}










































