package com.struts.components
{

import mx.core.FlexGlobals;
import mx.core.IVisualElementContainer;

import spark.components.Button;
import spark.core.IDisplayText;
import spark.primitives.BitmapImage;

public class WindowComfirm extends Window
{
	
	private var submitButton : Button;
	
	private var cancelButton : Button;
	
	private var textDisplay : IDisplayText;
	
	private var iconBitmapImage : BitmapImage;
	
	public function WindowComfirm()
	{
		super();
	}
	
	override protected function childrenCreated():void
	{
		super.childrenCreated();
	
		
	
	}
	
	protected override function partAdded(partName:String, instance:Object):void
	{
		super.partAdded(partName, instance);
		
		if(instance == contentGroup)
		{
			contentGroup.bottom = 40;
		}
		
	}
	private var _callbase : Function;

	public function comfirm(msg : String,callbase : Function,icon : Object) : void
	{
		if(callbase == _callbase)
			return;
		
		_callbase = callbase;
		
		var canvas : IVisualElementContainer = FlexGlobals.topLevelApplication as IVisualElementContainer;
	
	
	}
	
}
}