package com.struts.data.core
{
	
import com.struts.events.RecordEvent;
import com.struts.utils.SQLUtil;

import flash.events.DataEvent;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.IOErrorEvent;
import flash.events.ProgressEvent;
import flash.events.SecurityErrorEvent;
import flash.net.Socket;
import flash.net.XMLSocket;
import flash.utils.ByteArray;

[Event(name="read", type="com.struts.events.RecordEvent")]

[Event(name="connectSucces", type="flash.events.Event")]

[Event(name="connectFail", type="flash.events.Event")]


public class SocketService extends EventDispatcher
{
		
	public static const READ : String = "read";
	
	public static const CONNECT_SUCCES : String = "connectSucces";
	
	public static const CONNECT_FAIL : String = "connectFail";
	
	
	private var _socket : Socket;
	
	private var _address : String;
	
	private var _port : int;
	
	public function SocketService(address : String,port : int)
	{
		try
		{
			_address = address;
			_port = port;
			
			_socket = new Socket();
			_socket.addEventListener(Event.CONNECT,socketOnConnect);
			_socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR,socketOnSecurityError);
			_socket.addEventListener(IOErrorEvent.IO_ERROR,socketOnError);
			_socket.addEventListener(ProgressEvent.SOCKET_DATA,socketOnDataGet);
		}
		catch(e : Error)
		{
			trace(e);
		}
	}
	
	private function socketOnConnect(event : Event) : void
	{
		trace("connection Succes");
		dispatchEvent(new Event(CONNECT_SUCCES));
	}
	
	private function socketOnError(event : Event) : void
	{
		trace("connection Fail");
		dispatchEvent(new Event(CONNECT_FAIL));
	}
	
	
	private function socketOnSecurityError(event : Event) : void
	{
		trace("connection Security");
	}
	
	
	private function socketOnDataGet(event : ProgressEvent) : void
	{
		trace("Have");
		while(_socket.bytesAvailable)
		{
			
//			_socket.readObject();
//			
//			var msg : String = _socket.readMultiByte(_socket.bytesAvailable,"UTF8");
//			trace(msg);
			
			//var _obj : * = _socket.r
			
			
			//dispatchEvent(new RecordEvent(READ,_obj));
		}
	}
	
	public function close() : void
	{
		if(_socket.connected)
		{
		   _socket.close();
		}
	}
	
	
	public function connect() : void
	{
		if(!_socket.connected)
		{
			_socket.connect(_address,_port);
		}
	}
	
	public function send(msg : String) : void
	{
		if(_socket.connected)
		{
		   _socket.writeUTFBytes(msg);
		   _socket.flush();
		}	
	}
}
}










