package com.struts.components.iponeClasses
{
import com.struts.components.MButton;

import spark.components.Label;
import spark.components.supportClasses.SkinnableComponent;
import spark.primitives.BitmapImage;


public class IPoneItemRender extends MButton
{
	public var index : Number;
	
	private var _icon : Object;

	public function get icon():Object
	{
		return _icon;
	}

	public function set icon(value:Object):void
	{
		_icon = value;
		setStyle("backgroundImage",value);
	}

	
	private var _title : String;

	public function get title():String
	{
		return _title;
	}

	public function set title(value:String):void
	{
		_title = value;
		label = value;
	}

	
	public var guid : String;
	
	public var clicks : Number = 0;
	
	public function IPoneItemRender()
	{
		super();
	}
	
	override protected function partAdded(partName:String, instance:Object):void
	{
		super.partAdded(partName, instance);
	}
	
}

}










