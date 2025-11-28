package com.struts.core
{
	
import com.struts.WebSite;
import com.struts.events.AppEvent;
import com.struts.interfaces.IHashTable;

import flash.events.Event;
import flash.events.EventDispatcher;

public class StringBundle extends EventDispatcher
{
	public function StringBundle()
	{
		WebSite.dispatchEvent(new AppEvent(AppEvent.LANGUAGE_ADD_STRINGBUNDLE,this));
	}
	
	private var _i18N : IHashTable;
	
	public function set i18N(value:IHashTable):void
	{
		_i18N = value;
	}

	[Bindable(event="change")]
	public function get(key : String) : String
	{
		if(_i18N)
		{
			return _i18N.get(key);
		}
		
		return "";
	}
	
	public function cutLanguage() : void
	{
		dispatchEvent(new Event("change"));
	}
}
}






