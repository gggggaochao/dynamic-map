package com.struts.utils
{

import flash.external.ExternalInterface;

import mx.controls.Alert;
import mx.utils.URLUtil;

public class UrlUtil
{
	public static function parameter(decodeURL : Boolean = false) : Object
	{
		var startIndex : int = ExternalInterface.call("window.location.href.indexOf","?");
		
		var parameter : Object = new Object();

		if(startIndex > 0)
		{
			startIndex++;
			var strHref : String = ExternalInterface.call("window.location.href.substring",startIndex);
			
			if(strHref)
				return URLUtil.stringToObject(strHref,"&",decodeURL);
		}
		
		return parameter;
	}
}
}