package com.struts.data.imps
{
public interface ISynServices
{
	function invoke(completeHandler : Function = null) : void;
	
	function addRemoteSyn(id:String , method : String ,callback : Function,parameters : Array = null,resultFormat : String = null,faultHandler : Function = null) : ISynServices;

	function addWebServiceSyn(id:String , method : String ,callback : Function,parameters : Array = null,resultFormat : String = null,faultHandler : Function = null) : ISynServices;
	
	function addHttpSyn(url : String,callback : Function,resultFormat : String = "e4x",faultHandler : Function = null) : ISynServices;
	
}
}