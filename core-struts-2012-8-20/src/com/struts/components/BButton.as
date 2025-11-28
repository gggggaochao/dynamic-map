package com.struts.components
{
import spark.components.Button;

[Style(name="radiusX", type="Number", inherit="no")]

[Style(name="radiusY", type="Number", inherit="no")]

[Style(name="downColor", type="uint", format="Color", inherit="yes")]

[Style(name="overColor", type="uint", format="Color", inherit="yes")]

public class BButton extends Button
{
	public function BButton()
	{
		super();
		
		mouseChildren = false;
		useHandCursor = true;
	}
}
}