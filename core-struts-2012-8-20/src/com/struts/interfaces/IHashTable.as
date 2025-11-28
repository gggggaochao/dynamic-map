package com.struts.interfaces
{
import flash.events.IEventDispatcher;

public interface IHashTable extends IEventDispatcher
{
	function get(key : String) : String;
	
	
}
}