package com.struts.components
{
import spark.components.Button;


[Style(name="backgroundImage", type="Object", inherit="no")]

[Style(name="downGlowColor", type="uint", format="Color", inherit="yes")]

[Style(name="overGlowColor", type="uint", format="Color", inherit="yes")]

public class MButton extends Button
{
	
	public function MButton()
	{
		super();
		
		mouseChildren = false;
		useHandCursor = true;
	}
}
}