
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
import spark.components.SkinnableContainer;
import spark.core.IDisplayText;

/**
 *   窗体标题栏的颜色渐变
 */
[Style(name="headerColors", type="Array", arrayType="uint",format="Color", inherit="yes", theme="spark, mobile")]


/**
 *   边框颜色
 */
[Style(name="strokeColor", type="uint", format="Color", inherit="yes", theme="spark, mobile")]


/**
 *   边框颜色
 */
[Style(name="strokeVisible", type="Boolean", inherit="no", theme="spark, mobile")]

/**
 *
 *   窗体圆角的度数
 *  
 */
[Style(name="cornerRadius", type="Number", format="Length", inherit="no", theme="spark", minValue="0.0")]

/**
 *
 *   标题栏高度
 *  
 */
[Style(name="headerHeight", type="Number", format="Length", inherit="no", theme="spark", minValue="0.0")]

/**
 * 具有标题的显示容器
 *
 * @author Han.Zhou
 * @email zhouhan102@163.com || zhouhan@missiongroup.com.cn
 * @date 2012-4-15 下午04:32:56 
 *
 */

public class ViewGroup extends SkinnableContainer
{
	[SkinPart(required="false")]
	public var titleDisplay : IDisplayText;
	
	public function ViewGroup()
	{
		super();
	}
	
	
	private var _title : String;
	
	public function get title():String 
	{
		return _title;
	}
	
	/**
	 *  @private
	 */
	public function set title(value:String):void 
	{
		_title = value;
		
		if (titleDisplay)
			titleDisplay.text = title;
	}
	
	/**
	 *  @private
	 */
	override protected function partAdded(partName:String, instance:Object):void
	{
		super.partAdded(partName, instance);
		
		if (instance == titleDisplay)
		{
			titleDisplay.text = title;
		}
	}
}
}




















