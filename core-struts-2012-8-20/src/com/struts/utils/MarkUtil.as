
////////////////////////////////////////////////////////////////////////////////
//
//  MissionGroup Copyright 2012 All Rights Reserved.
//
//  NOTICE: MIT MissionGroup permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////
package com.struts.utils
{
	
	/**
	 * 标注处理类
	 *
	 * @author Han.Zhou
	 * @email  zhouhan102@163.com || zhouhan@missiongroup.com.cn
	 * @date   2012-4-18 上午10:57:26 
	 *
	 */
	
	public class MarkUtil
	{
		public static function itemToLabel(item:Object, labelField:String=null, 
										   labelFunction:Function=null):String
		{
			if (labelFunction != null)
				return labelFunction(item);
			
			// early check for Strings
			if (item is String)
				return String(item);
			
			if (item is XML)
			{
				try
				{
					item = item[labelField].length() != 0 ? item[labelField] : "";
				}
				catch(e:Error)
				{
				}
			}
			else if (item is Object)
			{
				try
				{
					if (item[labelField] != null)
						item = item[labelField];
				}
				catch(e:Error)
				{
				}
			}
			
			// late check for strings if item[labelField] was valid
			if (item is String)
				return String(item);
			
			try
			{
				if (item !== null)
					return item.toString();
			}
			catch(e:Error)
			{
			}
			
			return " ";
		}
	}
}













