package com.missiongroup.car.componets
{
import mx.core.UIComponent;

public class StationSprite extends UIComponent
{
	private var bgFill : uint;
	
	private var centerFill : uint;
	
	private var _fills : Array;
	
	public function set fills(value:Array):void
	{
		if(value)
		{
			_fills = value;
			bgFill = value[0];
			centerFill = value[1];
		}
	}
	
	public function StationSprite()
	{
		super();
	}
	
	public function draw(mode : String,width : Number = 24,height : Number = 24,r : Number = 5,R : Number = 8) : void
	{
		
		var cx : Number = width / 2;
		var cy : Number = height / 2;
		
		this.graphics.clear();
	
		graphics.beginFill(bgFill);
		graphics.drawCircle(cx,cy,width / 2);
		graphics.endFill();
		
		graphics.beginFill(centerFill); //括号里面表示填充圆环的颜色
		graphics.drawCircle(cx,cy,r);//表示在坐标为（300,200）的位置画一个半径为20的圆圈
		graphics.drawCircle(cx,cy,R);//表示在坐标为（300,200）的位置画一个半径为30的圆圈
		graphics.endFill();//表示绘画完毕

	}
}
}


