package com.missiongroup.car.componets
{
import flash.events.IOErrorEvent;

import mx.core.IVisualElement;

import spark.components.Group;
import spark.components.Label;
import spark.layouts.HorizontalAlign;
import spark.layouts.VerticalAlign;
import spark.layouts.VerticalLayout;
import spark.layouts.supportClasses.LayoutBase;
import spark.primitives.BitmapImage;

public class UserLineGroup extends Group
{
	public static const LINE_URL : String = "assets/images/lines/arrowhead_line";
	
	private var image : BitmapImage;
	
	private var labalDisplay : Label;
	
	//private var staticDisplay : Label;
	
	public var isUp : Boolean;
	
	public var line : String;
	
	public var lineString : String;
	
	private var _fontSize : Number = 11;
	
	private var _fontSizeChanged : Boolean;

	public function get fontSize():Number
	{
		return _fontSize;
	}

	public function set fontSize(value:Number):void
	{
		if(_fontSize == value)
			return;
		
		_fontSize = value;
		_fontSizeChanged = true;
		
		invalidateProperties();
	}

	
	private var _userLines : Array;
	
	private var _userLinesChanged : Boolean;

	public function set userLines(value:Array):void
	{
		if(_userLines != value)
		{
			_userLines = value;
			_userLinesChanged = true;
			
			invalidateProperties()
		}
	}

	private function createLayout() : LayoutBase
	{
		var v : VerticalLayout = new VerticalLayout();
		v.horizontalAlign = HorizontalAlign.CENTER;
		v.verticalAlign = VerticalAlign.MIDDLE;
		v.gap = 0;
		
		return v;
	}
	
	public function UserLineGroup()
	{
		super();

		init();
	}
	
	protected override function commitProperties(): void
	{
		super.commitProperties();
		
		if(_userLinesChanged)
		{
			
			_userLinesChanged = false;
			_userLines = _userLines.sort(
				function(a:*, b:*):Number {
					// 如果两个元素都是数字
					if (!isNaN(Number(a)) && !isNaN(Number(b))) {
						return Number(a) < Number(b) ? -1 : 1;
					}
					// 如果a是数字，b是字符串，a应该排前面
					if (!isNaN(Number(a)) && isNaN(Number(b))) {
						return -1;
					}
					// 如果a是字符串，b是数字，b应该排前面
					if (isNaN(Number(a)) && !isNaN(Number(b))) {
						return 1;
					}
					// 如果两个元素都是字符串，按字母排序
					return a < b ? -1 : 1;
				}
			);
			var s : String = _userLines.join("_");
			var dir : String = isUp ? "01" : "02";
			var imageURL : String = LINE_URL + line + "_" + s + "_" + dir + ".png";
			
			trace('imageURL',line,'|',imageURL);
			
			image.source = imageURL;
			labalDisplay.text  = (_userLines.join("/") + lineString).replace(/jinshan/g,"金山铁路");
			//解决图片无法中文命名，用jinshan替换金山铁路
			
			removeAllElements();
			
			if(isUp)
			{
				y = -60;
				//addElement(staticDisplay);
				addElement(labalDisplay);
				addElement(image);
			}
			else
			{
				addElement(image);	
				//addElement(staticDisplay);
				addElement(labalDisplay);
			}
			
		}
		
		
		
		if(_fontSizeChanged)
		{
			_fontSizeChanged = false;
			
			//staticDisplay.setStyle("fontSize",fontSize);
			labalDisplay.setStyle("fontSize",fontSize);
			
		}
		
		//if()
		
		
	}
	
	private function init() : void
	{
		
		this.layout = createLayout();
		image = new BitmapImage();
		image.addEventListener(IOErrorEvent.IO_ERROR, imageErrorHandler);
		labalDisplay = createLable("-");
		//staticDisplay = createLable();
	}
	
	private function imageErrorHandler(e:IOErrorEvent):void{
		trace('load image ::' + image.source + ' error!');
	}
	
	private function createLable(text : String = null) : Label
	{
		var lable : Label = new Label();
		//lable.setStyle("color",0xffffff);
		//lable.setStyle("fontFamily","font_en");
		lable.styleName = "userLine";
		lable.text = text;
		
		return lable;
	}
}
}
