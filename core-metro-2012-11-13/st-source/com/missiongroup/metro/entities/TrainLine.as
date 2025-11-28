package com.missiongroup.metro.entities
{
public class TrainLine
{

	/**
	 *  线路ID 
	 */	
	public var TrainLineID : String;
	
	/**
	 *  线路简称 
	 */	
	public var ShortNum :  String;
	
	/**
	 *   线路名称 
	 */	
	public var Name : String;
	
	
	/**
	 *  线路英文名称 
	 */	
	public var NameE : String;
	
	
	/**
	 *  运营公司 
	 */	
	public var Company : String;
	
	
	/**
	 *  是否环形 
	 */	
	public var IsRing : int;
	

	/**
	 *  线路颜色 
	 */	
	public var Color : uint;
	
	
	/**
	 * 所以站点信息 
	 */	
	public var StationList : Array;  /** TrainStation */
	
	
	/**
	 * 所有有序站点ID信息 
	 */	
	public var StationIDList : Array;  /** String */
	
	
	public var UseTimeList : Array;  /** UserTime */
	
	
	public var UpOrDown : String;
	
	
	public var Diretion  : String;
	
	
	public var DiretionE : String;
	
	/**
	 *  是否有支线 
	 */	
	public var IsFree : int;
	
	public var FreeLinkStationId : String;
	
	public var FreeStationList : Array;
	
	public var FreeStationIDList : Array;
	
	
	public function TrainLine()
	{
		IsFree = 0;
		StationList = new Array();
		StationIDList = new Array();
		UseTimeList = new Array();
		FreeStationList = new Array();	
		FreeStationIDList = new Array();
	
	}
}
}













