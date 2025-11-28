package com.struts.data.core
{

import com.struts.data.imps.IServices;
import com.struts.data.utils.ServiceUtil;

import flash.events.Event;

import mx.rpc.AbstractOperation;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;
import mx.rpc.soap.LoadEvent;
import mx.rpc.soap.Operation;
import mx.rpc.soap.WebService;
	
public class WebServices extends WebService implements IServices 
{
	
	public function WebServices(destination:String=null, rootURL:String=null)
	{
		super(destination, rootURL);
		
		useProxy = false;
		addEventListener(LoadEvent.LOAD,loasWSDLSuccesHandler);
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
	
	/**
	 *  respust name To XML 
	 */	
	private var _operationsStack : Object = new Object();

	public function get operationsStack():Object
	{
		return _operationsStack;
	}

	public function set operationsStack(value:Object):void
	{
		_operationsStack = value;
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

	
	private function soapSuccsseHandler(event : ResultEvent) : void
	{
		if(_callback == null)
			return;
		
		var res : Object = ServiceUtil.formatResult(event.result,_resutlFormat);
		_callback.call(null,res);
		
		if(_completeInvoke == null)
			return;
		
		_completeInvoke.call(null);
	}

	
	private function soapFaultHandler(event : FaultEvent) : void
	{
		if(_messageFault == null)
			return;
		
		_messageFault(event);
	}
	
	
	
	private function loasWSDLSuccesHandler(event : Event) : void
	{
		if(_method)
		{
			invoke();
		}
	}
	
	public function invoke() : void
	{
		if(!ready)
		{
			loadWSDL();
			return;
		}
		
		var operation : AbstractOperation  = this.getOperation(_method);
		
		if(operation is Operation)
		{
			var _parameList : XMLList = _operationsStack[_method] as XMLList;
			
			Operation(operation).request = ServiceUtil.createRequest(_parameList,_arguments);
			operation.addEventListener(ResultEvent.RESULT,soapSuccsseHandler);
			operation.addEventListener(FaultEvent.FAULT,soapFaultHandler);
			operation.send();
		}
	}
}
}















