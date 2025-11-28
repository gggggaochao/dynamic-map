
////////////////////////////////////////////////////////////////////////////////
//
//  MissionGroup Copyright 2012 All Rights Reserved.
//
//  NOTICE: MIT MissionGroup permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////
package com.struts.components
{
import com.struts.events.ColorEvent;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Point;
import flash.geom.Rectangle;

import mx.controls.Text;
import mx.graphics.SolidColor;
import mx.utils.ColorUtil;
import mx.utils.NameUtil;

import spark.components.BorderContainer;
import spark.components.Button;
import spark.components.Image;
import spark.components.Label;
import spark.components.TextInput;
import spark.components.supportClasses.SkinnableComponent;


/**
 * todo(用一句话描述Flex 类用途) 
 *
 * @author Han.Zhou
 * @email zhouhan102@163.com || zhouhan@missiongroup.com.cn
 * @date 2012-5-4 下午10:59:16 
 *
 **/

[Event(name="colorSelectting", type="com.struts.events.ColorEvent")]

[Event(name="colorSelected", type="com.struts.events.ColorEvent")]


public class ColorChooser extends SkinnableComponent
{
	[SkinPart(required="false")]
	public var colorImage : Image;
	
	[SkinPart(required="false")]
	public var pickButton : Button;
	
	[SkinPart(required="true")]
	public var colorBox : BorderContainer;

	[SkinPart(required="true")]
	public var labelDisplay : TextInput;
	
	
//	[Embed(source="/resources/images/colors.png")]
//	public  var colorsBackground : Class;
	
	private static const PICKBUTTON_SIZE : Number = 12;
	
	//private var bm : Bitmap;
	
	private var bmd : BitmapData;
	
	private var pickRectangle : Rectangle;

	private var _selectedColor : uint;
	
	private var solidColor : SolidColor;
	
	private var _solidColorChange : Boolean = false;
	
	public function get selectedColor():uint
	{
		return _selectedColor;
	}
	
	public function set selectedColor(value:uint):void
	{
		if(_selectedColor == value)
			return;
		
		_selectedColor = value;
		_solidColorChange = true;
		
		invalidateProperties();
	}
	
	
	
	public function ColorChooser()
	{
		super();
		
		solidColor = new SolidColor(_selectedColor);
	}
	
	/**
	 * 
	 * 
	 */
	override protected function commitProperties():void
	{
		super.commitProperties();
		
		if(_solidColorChange)
		{
			_solidColorChange = false;

			if(bmd)
			{
				
				/**
				 *  RGB 转换成 ARGB
				 * */
				var r : uint = _selectedColor >> 16 & 0xFF;
				var g : uint = _selectedColor >> 8 & 0xFF;
				var b : uint = _selectedColor >> 0 & 0xFF;
	
				var _argb : uint = (0xFF << 24 | r << 16 | g << 8 | b);
				
				var ar : uint = _argb >> 16 & 0xFF;
				var ag : uint = _argb >> 8 & 0xFF;
				var ab : uint = _argb >> 0 & 0xFF;
				
				var mask : uint = _argb >> 24 | ar << 16 | ag << 8 | ab << 0;

				var colorRect : Rectangle = bmd.getColorBoundsRect(mask,_argb);
				
				pickButton.x = colorRect.x - PICKBUTTON_SIZE/2;
				pickButton.y = colorRect.y - PICKBUTTON_SIZE/2;
				
	
				updateColor();
			}
		}
	}
	
	override protected function partAdded(partName:String, instance:Object):void
	{
		super.partAdded(partName, instance);
		
		if(instance == colorImage)
		{
			completeColorImageHandler(null);
		}
		
		if(instance == colorBox)
		{
			colorBox.backgroundFill = solidColor;
		}
		
		if(instance == pickButton)
		{
			pickButton.addEventListener(MouseEvent.MOUSE_DOWN,pickMouseDownHandler);
		}
	}
	
	private function completeColorImageHandler(event:Event) : void
	{
		if(!isNaN(colorImage.sourceWidth) && !isNaN(colorImage.sourceHeight))
		{
			bmd = new BitmapData(colorImage.sourceWidth, colorImage.sourceHeight);
			bmd.draw(colorImage.bitmapData)
					
			pickRectangle = new Rectangle(-PICKBUTTON_SIZE/2,-PICKBUTTON_SIZE/2,colorImage.sourceWidth-4,colorImage.sourceHeight-4);
		}
	}
	
	private function pickMouseDownHandler(event : MouseEvent) : void
	{
		stage.addEventListener(MouseEvent.MOUSE_UP,dragStop);
		stage.addEventListener(MouseEvent.MOUSE_MOVE,dragStart);
	}
	
	private function dragStart(event:MouseEvent):void
	{
		//var plocal : Point = colorImage.globalToLocal(new Point(event.stageX,event.stageY));
		if(pickRectangle)
		{
			var plocal : Point = colorImage.globalToLocal(new Point(event.stageX,event.stageY));
			
			var _x : Number = plocal.x-PICKBUTTON_SIZE/2;
			var _y : Number = plocal.y-PICKBUTTON_SIZE/2;
			
			_x = _x < pickRectangle.x ? pickRectangle.x : _x;
			_y = _y < pickRectangle.y ? pickRectangle.y : _y;
			
			_x = _x > pickRectangle.x + pickRectangle.width ? pickRectangle.x + pickRectangle.width : _x;
			_y = _y > pickRectangle.y + pickRectangle.height? pickRectangle.y + pickRectangle.height : _y;
			
			pickButton.x = _x;
			pickButton.y = _y;
			
			
			_selectedColor = bmd.getPixel(_x+PICKBUTTON_SIZE/2, _y+PICKBUTTON_SIZE/2);
			
			updateColor();
			
			dispatchEvent(new ColorEvent(ColorEvent.COLOR_SELECTTING,selectedColor));
		}
	}
	
	
	private function updateColor() : void
	{
		
		var colorStr:String = "000000" +  _selectedColor.toString(16).toUpperCase();
		
		labelDisplay.text = "0x" + colorStr.substr(colorStr.length - 6);	
		
		solidColor.color = _selectedColor;
		
		pickButton.setStyle("backgroundColor",_selectedColor);
		
	}
	
	
	private function dragStop(event:Event):void
	{
		pickButton.stopDrag();
		stage.removeEventListener(MouseEvent.MOUSE_UP,dragStop);
		stage.removeEventListener(MouseEvent.MOUSE_MOVE,dragStart);
		
		dispatchEvent(new ColorEvent(ColorEvent.COLOR_SELECTED,selectedColor));
	} 
}
}


























