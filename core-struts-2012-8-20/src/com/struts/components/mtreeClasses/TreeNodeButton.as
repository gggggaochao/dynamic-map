package com.struts.components.mtreeClasses
{
import spark.components.Button;

[SkinState("upAndOpen")]

[SkinState("overAndOpen")]

[SkinState("downAndOpen")]

[SkinState("disabledAndOpen")]

public class TreeNodeButton extends Button
{
	private var _isOpen : Boolean;

	public function get isOpen():Boolean
	{
		return _isOpen;
	}

	public function set isOpen(value:Boolean):void
	{
		if(value == _isOpen)
			return;
		
		_isOpen = value;
		invalidateSkinState();
	}

	
	public function TreeNodeButton()
	{
		super();
	}
	
	override protected function getCurrentSkinState():String
	{
		
		if(_isOpen)
			return super.getCurrentSkinState() + "AndOpen";
		else
		    return super.getCurrentSkinState();
	}
}
}