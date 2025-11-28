package com.struts.components
{
import spark.components.DropDownList;


[Style(name="rowCount", type="Number", format="Length", inherit="no", theme="spark", minValue="8")]

public class CustomDropDownList extends DropDownList
{
	public function CustomDropDownList()
	{
		super();
	}
}

}