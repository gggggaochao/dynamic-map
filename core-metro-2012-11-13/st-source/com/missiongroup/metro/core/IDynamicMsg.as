package com.missiongroup.metro.core
{
	
public interface IDynamicMsg
{
	/**
	 * 
	 * 发布信息 
	 *  
	 * @param msg    信息内容
	 * @param type   信息类型
	 * 
	 */	
	function release(msg : String,type : int) : void;
	
	
	/**
	 *
	 * 取消信息 
	 * 
	 */	
	function cancel() : void;
	
}

}
