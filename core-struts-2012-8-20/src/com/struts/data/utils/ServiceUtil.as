package com.struts.data.utils
{
import mx.collections.ArrayCollection;

	
public final class ServiceUtil
{
	public static function createRequest(paramList : XMLList,parameter : Object) : Object
	{
		var request : Object = {};
		if(paramList && paramList.length())
		{
			var paramters : XML = paramList[0];
			var childrens : XMLList = paramters.children();
			
			for each(var parame : XML in childrens) 
			{
				var paramName : String = parame.localName().toString();
				var isValue : Boolean = parame.@isValue == "true" ? true : false;
				var field : String = parame.toString();
				request[paramName] = isValue ? field : 
					parameter ? parameter[field] : "";
			}
		}
		return request;
	}
	
	
	public static function formatHttpResult(result : Object,resultFormat : String) : Object 
	{
		switch(resultFormat)
		{
			case "e4x" :
			case "xml" :
			{
				return (result as XML);
				break;
			}
			case "string" :
			case "text" :
			{
				return (result as String);
				break;
			}	
			case "object" :
			{
				if(result is String)
				{
					return (JSON.parse(result as String));
					break;
				}
			}	
			case "array" :
			{
				if(result is String)
				{
					return (JSON.parse(result as String) as Array);
					break;
				}
			}		
				
			default : 
			{
				return (result);
			}
		}		
	}
	
	public static function formatResult(result : Object,resultFormat : String = "json") : Object
	{
		if(result is String)
		{
			switch(resultFormat.toLowerCase())
			{
				case "json" :
				{
					
					var json : Object = JSON.parse(result as String);
					if(json is Array)
					{
						return json as Array;
					}
					else
					{
						return json;
					}
					break;
				}
				case "string" :
				case "text" :
				{
					return result as String;
					break;
				}	
				case "xml" :
				case "e4x" :
				{
					return new XML(result as String);
					break;
				}										
				default :
				{
					return result as String;
					break;
				}
			}			
		}
//		else if(result is Boolean)
//		{
//			return result as Boolean;
//		}
//		else if(result is Number)
//		{
//			return Number(result);
//		}
//		else if(result is uint)
//		{
//			return (uint(result));
//		}
//		else if(result is Array)
//		{
//			return (result as Array);
//		}
//		else if(result is ArrayCollection)
//		{
//			return (result as ArrayCollection);
//		}
		else
		{
			return (result);
		}		
	}
	
}


}





