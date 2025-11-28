
////////////////////////////////////////////////////////////////////////////////
//
//  MissionGroup Copyright 2012 All Rights Reserved.
//
//  NOTICE: MIT MissionGroup permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////
package com.struts.events
{
	
/**
 *
 * @author Han.Zhou
 * @email zhouhan102@163.com || zhouhan@missiongroup.com.cn
 * @date 2012-5-5 上午01:18:32 
 *
 **/

public class ColorEvent extends RecordEvent
{
	public static const COLOR_SELECTED : String = "colorSelected";
	
	public static const COLOR_SELECTTING : String = "colorSelectting";
	
	public function ColorEvent(type:String, data:Object=null, callback:Function=null, bubbles:Boolean=false, cancelable:Boolean=false)
	{
		super(type, data, callback, bubbles, cancelable);
	}
}
}
