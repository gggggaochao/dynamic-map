package com.missiongroup.car.core
{
	
import com.missiongroup.metro.entities.TrainStation;

import mx.core.IVisualElement;

public interface IStation extends IVisualElement
{

	function get station() : TrainStation;
	function set station(value : TrainStation) : void;
	
	function get isEnd() : Boolean;
	function set isEnd(value : Boolean) : void;
	
	function get isStart() : Boolean;
	function set isStart(value : Boolean) : void;
	
	/**
	 * 显示的站点名称是否向上 
	 * @return 
	 * 
	 */	
	function get isUp() : Boolean;
	function set isUp(value : Boolean) : void;
	
	function get isRing() : Boolean;
	function set isRing(value : Boolean) : void;
	
	function get dir() : String;
	function set dir(value : String) : void;
	
	function get displayMode():String;
	function set displayMode(value:String):void;
	
	function get userLines() : Array;
	function set userLines(value : Array) : void;
	
	function get rails() : Array;
	function set rails(value : Array) : void;
//
	function get line() : String;
	function set line(value : String) : void;
	
	
	function destroy() : void;
	
	
}
}