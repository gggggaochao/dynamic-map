package com.struts.data.services
{
	
import com.struts.data.DataService;
import com.struts.data.imps.IServices;
import com.struts.data.imps.ISynServices;

public class SynchronousServices implements ISynServices
{
	
	private var _servcies  : Array;
	
	public function SynchronousServices()
	{
		_servcies = new Array();
	}


	
	
	public function addRemoteSyn(id:String, method:String, callback:Function, parameters:Array=null, resultFormat:String=null, faultHandler:Function=null):ISynServices
	{
		var servcies : IServices = DataService.createRemoteServices(id,
																	method,
																	callback,
																	parameters,
																	resultFormat,
																	faultHandler);
		
		
		if(servcies)
			_servcies.push(servcies);
		
		return this;
	}
	
	public function addWebServiceSyn(id:String, method:String, callback:Function, parameters:Array=null, resultFormat:String=null, faultHandler:Function=null):ISynServices
	{
		
		var servcies : IServices = DataService.createWebService(id,
																method,
																callback,
																parameters,
																resultFormat,
																faultHandler);
		
		
		if(servcies)
		  _servcies.push(servcies);
		
		return this;
	}
	
	public function addHttpSyn(url:String, callback:Function, resultFormat:String="e4x", faultHandler:Function=null):ISynServices
	{
		var servcies : IServices = DataService.createHttpServices(url,
																  callback,
																  resultFormat,
																  faultHandler);
		
		if(servcies)
		  _servcies.push(servcies);
		
		return this;
	}
	
	private var _completeFunction : Function;
	
	public function invoke(completeHandler : Function = null):void
	{
		_completeFunction = completeHandler;
		
		if(_servcies.length)
		{
			var servcies : IServices = _servcies[0];
			_servcies.splice(0, 1);
			
			servcies.completeInvoke = invokeNext;
			servcies.invoke();
		}
		else
		{
			if(_completeFunction == null)
				return;
			
			  _completeFunction.call(null);
		}
	}
	
	private function invokeNext() : void
	{
		invoke(_completeFunction);
	}
	
	
}
}





