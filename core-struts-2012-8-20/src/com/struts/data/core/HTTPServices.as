package com.struts.data.core
{
import com.struts.data.imps.IServices;
import com.struts.data.utils.ServiceUtil;

import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;
import mx.rpc.http.HTTPService;

public class HTTPServices extends HTTPService implements IServices 
{
	public function HTTPServices(rootURL:String=null, destination:String=null)
	{
		super(rootURL, destination);
		
		addEventListener(ResultEvent.RESULT,httpSuccsseHandler);
		addEventListener(FaultEvent.FAULT,httpFaultHandler);
	}
	
	private function httpSuccsseHandler(event : ResultEvent) : void
	{
		if(_callback == null)
			return;
		
		var res : Object = ServiceUtil.formatHttpResult(event.result,resultFormat);
		_callback.call(null,res);
		
		if(_completeInvoke == null)
			return;
		
		_completeInvoke.call(null);
	}
	
	private function httpFaultHandler(event : FaultEvent) : void
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

	private var _messageFault : Function;
	
	public function get messageFault():Function
	{
		return _messageFault;
	}
	
	public function set messageFault(value:Function):void
	{
		_messageFault = value;
	}
	
	public function invoke() : void
	{
		this.send();
	}
}
}