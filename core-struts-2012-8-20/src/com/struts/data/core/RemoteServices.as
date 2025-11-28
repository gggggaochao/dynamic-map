package com.struts.data.core
{
import com.struts.data.imps.IServices;
import com.struts.data.utils.ServiceUtil;

import flash.events.Event;

import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;
import mx.rpc.remoting.RemoteObject;

public class RemoteServices extends RemoteObject implements IServices 
{
	
	public function RemoteServices(destination:String=null)
	{
		super(destination);
		
		addEventListener(ResultEvent.RESULT,remoteSuccesHanlder);
		addEventListener(FaultEvent.FAULT,remoteFaultHandler);
	}
	
	private function remoteSuccesHanlder(event : ResultEvent) : void
	{
		if(_callback == null)
			return;
		
		var res : Object = ServiceUtil.formatResult(event.result,_resutlFormat);
		_callback.call(null,res);
		
		
		if(_completeInvoke == null)
			return;
		
		_completeInvoke.call(null);
	}
	
	
	private function remoteFaultHandler(event : FaultEvent) : void
	{
		if(_messageFault == null)
			return;
		
		_messageFault(event);
	}
	
	private var _completeInvoke : Function;
	
	public function get completeInvoke():Function
	{
		return _completeInvoke;
	}
	
	public function set completeInvoke(value:Function):void
	{
		_completeInvoke = value;
	}
	
	private var _callback : Function;
	
	public function get callback():Function
	{
		return _callback;
	}
	
	public function set callback(value:Function):void
	{
		_callback = value;
	}
	
	private var _resutlFormat : String = "json";
	
	public function get resutlFormat():String
	{
		return _resutlFormat;
	}
	
	public function set resutlFormat(value:String):void
	{
		_resutlFormat = value;
	}
	
	
	private var _messageFault : Function;
	
	public function get messageFault():Function
	{
		return _messageFault;
	}
	
	public function set messageFault(value:Function):void
	{
		_messageFault = value;
	}
	
	private var _method : String;
	
	public function get method():String
	{
		return _method;
	}
	
	public function set method(value:String):void
	{
		_method = value;
	}
	
	
	private var _arguments : Object;
	
	public function get arguments():Object
	{
		return _arguments;
	}
	
	public function set arguments(value:Object):void
	{
		_arguments = value;
	}
	
	public function invoke() : void
	{
		if(_method)
		{
			
			this.getOperation(_method).arguments = _arguments || [];
			this.getOperation(_method).send();
		}
	}
}
}















