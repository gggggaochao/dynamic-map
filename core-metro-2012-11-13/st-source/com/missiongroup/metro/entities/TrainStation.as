package com.missiongroup.metro.entities
{
	import flash.geom.Point;
	
public class TrainStation
{

	public var StationId : String;
	
	public var Name : String;
	
	public var NameE : String;
	
	public var Spell : String;
	
	public var IsRun : int;
	
	public var IsPass : Boolean;
	
	public var Remark : String;
	
	public var Lines : Array; /** String */	
	
	public var UserLines : Array; /** String */
	
	public var MapX : Number;
	
	public var MapY : Number;
	
	/**
	 *  首末班时刻表 
	 */	
	public var TrainTimes : Array; /** TrainTimes  */
	
	public function TrainStation()
	{
		Lines = new Array();
		UserLines = new Array();
		TrainTimes = new Array();
	}
	
//	public function clone():TrainStation{
//		var newTS:TrainStation = new TrainStation();
//		newTS.StationId = StationId;
//		newTS.Name = Name;
//		newTS.NameE = NameE;
//		newTS.Spell = Spell;
//		newTS.IsRun = IsRun;
//		newTS.IsPass = IsPass;
//		newTS.Remark = Remark;
//		newTS.Lines = Lines ? Lines.concat() : null;
//		newTS.UserLines = UserLines ? UserLines.concat() : null;
//		newTS.MapX = MapX;
//		newTS.MapY = MapY;
//		newTS.TrainTimes = TrainTimes ? TrainTimes.concat() : null;
//		
//		return newTS;
//	}
	
}
}


































