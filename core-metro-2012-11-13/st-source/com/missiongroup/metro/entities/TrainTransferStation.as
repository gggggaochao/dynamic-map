package com.missiongroup.metro.entities
{
	
/**
 * 
 * 换乘站点
 *  
 * @author ZhouHan
 * 
 *         
 */	
public class TrainTransferStation
{
	
	public var FStation : TrainStation;
	
	public var TStation : TrainStation;
	
	public var MidStationIDList : Array;
	
	public var LineSegementList : Array;
	
	public var Time : Number;
	
	/**
	 * 乘坐几站 
	 */	
	public var StopsNum : Number;
	
	
	/**
	 * 行驶方向 
	 */	
	public var Diretion : String;
	
	public var DiretionE : String;
	
	
	/**
	 * 
	 * 乘车距离 
	 */	
	public var Length : Number;
	
	
	/**
	 * 上车线路 
	 */	
	public var LineNum : String;
	
	
	/**
	 *  下车步行距离 
	 */	
	public var EndDis : Number;
	
	public function TrainTransferStation()
	{
		Time = 0;
		Length = 0;
		StopsNum = 0;
		MidStationIDList = new Array();
		LineSegementList = new Array();
	}
	
}
}














