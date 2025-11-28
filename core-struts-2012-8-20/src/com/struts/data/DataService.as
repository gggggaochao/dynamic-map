package com.struts.data
{
import com.struts.core.WebApp;
import com.struts.data.core.HTTPServices;
import com.struts.data.core.RemoteServices;
import com.struts.data.core.WebServices;
import com.struts.data.imps.IServices;
import com.struts.data.imps.ISynServices;
import com.struts.data.services.SynchronousServices;
import com.struts.data.utils.ServiceUtil;
import com.struts.utils.HashTable;

import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.SecurityErrorEvent;

import mx.messaging.ChannelSet;
import mx.messaging.channels.RTMPChannel;
import mx.rpc.events.FaultEvent;
import mx.rpc.soap.Operation;
import mx.utils.ObjectProxy;
	
public final class DataService
{
	
	private static var _endpoint : String;
	
	private static var _destination : String;
	
	private static var _channelSet : ChannelSet;
	
	private static var _defaultResultFormat : String = "json";
	
	private static var _defaultType : String = "Java";
	
	private static var _faultMessage : String;
	
	private static var webServicesFactory : HashTable = new HashTable();
	
	public static function loadRemote(config : XML) : void
	{
		
		if(config)
		{
			var endpoint : String;
			var uri : String;
			var destination : String;
			var defaultResultFormat : String;
			var defaultType : String;
			var faultMessage : String;
			
			endpoint  = config.endpoint;
			destination = config.destination;
			uri  = config.uri;
			defaultType = config.defaultType;
			defaultResultFormat = config.defaultResultFormat;
			faultMessage = config.faultMessage;
			
			initializeRemote(endpoint,destination,uri,defaultType,defaultResultFormat,faultMessage);
		}
	}
	
	private static function initializeRemote(endpoint : String = null,
											 destination : String = null,
											 uri :String = null,
											 defaultType : String = null,
											 defaultResultFormat : String = null,
											 faultMessage : String = null) : void
	{
		if(endpoint)
		{
			_endpoint = endpoint;
		}
		
		if(destination)
		{
			_destination = destination;
		}
		
		if(defaultResultFormat)
		{
			_defaultResultFormat = defaultResultFormat;
		}
		
		if(defaultType)
		{
			_defaultType = defaultType.toUpperCase();
		}
		
		
		if(faultMessage)
		{
			_faultMessage = faultMessage;
		}
		
		if(uri)
		{
			if(_channelSet == null)
			{
				var _rtmpChannel : RTMPChannel = new RTMPChannel();
				_rtmpChannel.uri = uri;
				
				_channelSet = new ChannelSet();
				_channelSet.addChannel(_rtmpChannel);
			}
		}		
	}
	

	public static function loadWebServices(config : XMLList) : void
	{
		for each(var web : XML in config)
		{
			var id : String = web.@id;
			
			var soap : WebServices = new WebServices();
			
			var _operationList : XMLList = config.operation;
			var _operationsStack : Object = {};
			
			for (var i:Number =0 ; i < _operationList.length(); i++)
			{
				var node : XML = _operationList[i];
				
				var name : String = node.@name;
				var opera : Operation = new Operation(soap,name);
				
				_operationsStack[name] = node.request;
			
			}
			
			soap.wsdl = web.@wsdl;
			soap.operationsStack = _operationsStack;
			
			webServicesFactory.add(id,soap);
			
		}			
	}
	
	
	public static function addRemoteSyn(id:String , 
									    method : String ,
									    callback : Function,
									    parameters : Array = null,
									    resultFormat : String = null,
									    faultHandler : Function = null) : ISynServices
	{
		var server : ISynServices = new SynchronousServices();
		server.addRemoteSyn(id,method,callback,parameters,resultFormat,faultHandler);
		
		return server;
	}
	
	public static function addWebServiceSyn(id:String , 
										    method : String ,
										    callback : Function,
										    parameters : Array = null,
										    resultFormat : String = null,
										    faultHandler : Function = null) : ISynServices
	{
		var server : ISynServices = new SynchronousServices();
		server.addWebServiceSyn(id,method,callback,parameters,resultFormat,faultHandler);
		
		return server;
	}
	
	
	public static function addHttpSyn(url : String,
									  callback : Function,
									  resultFormat : String = "e4x",
									  faultHandler : Function = null) : ISynServices
	{
		var server : ISynServices = new SynchronousServices();
		server.addHttpSyn(url,callback,resultFormat,faultHandler);
		
		return server;
	}
	
	/**
	 * Remote 远程服务方式,用于调用后台 Java 或  Net 服务
	 * 
	 *  
	 * 
	 * @param id            JAVA 为 Spring Bean id，Net  为 class 的命名空间全名
	 * @param method        远程调用的方法名
	 * @param callback      回调函数
	 * @param parameters    方法参数
	 * @param resultFormat  返回结果的枚举类型  json|xml|number|string|Array
	 * 
	 * @param faultHandler  调用失败处理函数
	 * 
	 */	
	
	public static function send(id:String , 
								method : String ,
								callback : Function,
								parameters : Array = null,
								resultFormat : String = null,
								faultHandler : Function = null):void
	{
		
		var servcies : IServices = createRemoteServices(id,
														method,
														callback,
														parameters,
														resultFormat,
														faultHandler);
		
		if(servcies)
		   servcies.invoke();
	}
	
	
	/**
	 * 
	 * @param id
	 * @param method
	 * @param callback
	 * @param parameters
	 * @param resultFormat
	 * @param faultHandler
	 * 
	 */	
	public static function webService(id:String , 
									  method : String ,
									  callback : Function,
									  parameters : Object = null,
									  resultFormat : String = null,
									  faultHandler : Function = null) : void
	{
		var servcies : IServices = createWebService(id,
													method,
													callback,
													parameters,
													resultFormat,
													faultHandler);
		
		if(servcies)
		   servcies.invoke();
	}	
	
	
	/**
	 * Flex for HTTP Service
	 *  
	 * @param url            URL address
	 * @param resultHandler  if Succeed to run function
	 * @param resultFormat   
	 * @param faultHandler   if fault to run function
	 * 
	 */	
	public static function http(url : String,
								callback : Function,
								resultFormat : String = "e4x",
								faultHandler : Function = null) : void
	{
		var servcies : IServices = createHttpServices(url,callback,resultFormat,faultHandler);
		
		if(servcies)
		   servcies.invoke();
	}

	/**
	 * 
	 *  ceate remoteing server Class
	 * 
	 *  
	 * @param id
	 * @param method
	 * @param callback
	 * @param parameters
	 * @param resultFormat
	 * @param faultHandler
	 * @return 
	 * 
	 */	
	public static function createRemoteServices(id:String , 
												 method : String ,
												 callback : Function,
												 parameters : Array = null,
												 resultFormat : String = null,
												 faultHandler : Function = null) : IServices
	{
		
		
		if(id && method && _endpoint)
		{
			var isNetRemote : Boolean = _defaultType ? _defaultType.toLocaleUpperCase() == "NET" : false;
			var remote : RemoteServices = new RemoteServices();
			
			remote.endpoint = _endpoint;
			remote.destination = isNetRemote ? _destination : id;
			remote.source = isNetRemote ? id : null;
			remote.channelSet = isNetRemote ? _channelSet : null;	
			
			remote.callback = callback;
			remote.messageFault = faultHandler || _faultMessageHandler;
			remote.resutlFormat = resultFormat || _defaultResultFormat;
			
			remote.method = method;
			remote.arguments = parameters;
			
			
			return remote;
		}

		return null;
	}
	
	
	public static function createWebService(id:String , 
											 method : String ,
											 callback : Function,
											 parameters : Object = null,
											 resultFormat : String = null,
											 faultHandler : Function = null) : IServices
	{

		if(id && method) 
		{
			var soap : WebServices = webServicesFactory.find(id);
			
			if(soap)
			{
				soap.callback = callback;
				soap.resutlFormat = resultFormat || _defaultResultFormat;
				soap.messageFault = faultHandler || _faultMessageHandler;
				soap.method = method;
				soap.arguments = parameters;
				
				return soap;
			}
		}
		
		return null;
		
	}
	
	
	public static function createHttpServices(url : String,
											   callback : Function,
											   resultFormat : String = "e4x",
											   faultHandler : Function = null) : IServices
	{
	
		if(url) 
		{
			var http : HTTPServices = new HTTPServices();
			http.url = url;
			http.callback = callback;
			http.messageFault = faultHandler || _faultMessageHandler;
			http.resultFormat = resultFormat;	
			
			return http;
		}
		
		return null;
	}
	
	
	
	
	
	private static function _faultMessageHandler(event : FaultEvent) : void
	{

		var sInfo:String = "";
		
		if (event.fault.rootCause is IOErrorEvent)
		{
			var ioe:IOErrorEvent = event.fault.rootCause as IOErrorEvent;
			if (ioe.text.indexOf("2032: Stream Error. URL:") > -1)
			{
				sInfo += "Could not find " + ioe.text.substring(32) + "\n";
			}
			else
			{
				// some other IOError
				sInfo += event.fault.rootCause + "\n";
			}
		}
		
		// config file with crossdomain issue
		if (event.fault.rootCause is SecurityErrorEvent)
		{
			var sec:SecurityErrorEvent = event.fault.rootCause as SecurityErrorEvent;
			if (sec.text.indexOf("Error #2048: ") > -1)
			{
				sInfo += "Possible crossdomain issue:\n" + sec.text + "\n";
			}
			else
			{
				// some other Security error
				sInfo += event.fault.rootCause + "\n";
			}
		}
		
		sInfo += "Fault Code: " + event.fault.faultCode + "\n";
		sInfo += "Fault Info: " + event.fault.faultString + "\n";
		sInfo += "Fault Details: " + event.fault.faultDetail;		
		
		WebApp.tip(sInfo,true,20,"top",null,20000);		
	}
}
}
























