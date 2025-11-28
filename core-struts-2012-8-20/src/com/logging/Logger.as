package com.logging
{
import flash.events.IEventDispatcher;

public interface Logger extends IEventDispatcher
{
	
	function initLogging() : void;
	
	function log(level : String,message : *,...rest) : void;
	
	function info(message : String,...rest) : void;
	
	function fatal(message : String,...rest) : void;
	
	function debug(message : String,...rest) : void;
	
	function error(message : String,...rest) : void;
	
	function warn(message : String,...rest) : void;
	
	function handler(coutent : String) : void;
	
}
}