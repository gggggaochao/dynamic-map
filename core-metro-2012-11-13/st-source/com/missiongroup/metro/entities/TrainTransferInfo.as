package com.missiongroup.metro.entities
{
	
/**
 *
 * 换乘信息
 *  
 * @author ZhouHan
 * 
 */	
public class TrainTransferInfo
{

	public var FormStationName : String;
	
	public var FormStationNameE : String;
	
	public var ToStationName : String;
	
	public var ToStationNameE : String;
	
	
	/**
	 *  票价
	 */	
	public var Price : String;
	
	
	/**
	 *  耗时(分钟)
	 */	
	public var TotalUseTime : Number;
	
	
	/**
	 *  总里程
	 */	
	public var TotalLength : Number;
	
	
	/**
	 *  备注
	 */	
	public var Remark : Number;
	
	
	/**
	 * 经过站点总数 
	 */	
	public var TotalPassStation : int;
	
	
	/**
	 * 换乘点信息 
	 */	
	public var TransferStations : Array /** TrainTransferStation  */;
	
	
	public function TrainTransferInfo()
	{
		TotalUseTime = 0;
		TotalLength = 0.0;
		TotalPassStation = 0;
		TransferStations = new Array();
	}
	
}
}













