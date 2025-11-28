package com.struts.components
{
import flash.utils.clearTimeout;
import flash.utils.setTimeout;

import mx.core.FlexGlobals;
import mx.core.IVisualElementContainer;

import spark.components.Label;
import spark.components.supportClasses.SkinnableComponent;



public class TipTool extends SkinnableComponent
{
	[SkinPart(required="false")]
	public var tipDisplay : Label;
	
	
	private var clearuint : uint = 0;
	
	public function TipTool()
	{
		super();
	}
	
	private var _offset : Number = 0;

	public function get offset():Number
	{
		return _offset;
	}

	public function set offset(value:Number):void
	{
		_offset = value;
	}
	
	private var _showMode : String;

	[Inspectable(category="General", enumeration="none,top,bottom,center", defaultValue="center")]
	
	public function get showMode():String
	{
		return _showMode;
	}

	public function set showMode(value:String):void
	{
		_showMode = value;
		
		this.verticalCenter = this.horizontalCenter = this.top = this.bottom = "@Clear";
		
		if(value == "none")
			return;
		
		if(this.hasOwnProperty(value))
		{
			this.horizontalCenter = 0;
			this[value] = _offset;
		}
		else
		{
			this.verticalCenter = this.horizontalCenter = 0;
		}
	}
	

	
	
	public function show(msg : String,
						 autoClear : Boolean = true,
						 showMode : String = "center",
						 offset : Number = 0,
						 parent : IVisualElementContainer = null,
						 delay : Number = 3000) : void
	{
		if(!parent)
			parent = FlexGlobals.topLevelApplication as IVisualElementContainer;
		
		this.offset = offset;
		this.showMode = showMode;
		
		if(!this.parent)
			parent.addElement(this);
		
		tipDisplay.text = msg;
	
		if(autoClear)
		{	
			if(clearuint)
				clearTimeout(clearuint);
			
			clearuint = setTimeout(clear,delay);
		}
	}
	
	
	public function clear() : void
	{
		if(this.parent is IVisualElementContainer)
			IVisualElementContainer(this.parent).removeElement(this);
	}
	
}
}





