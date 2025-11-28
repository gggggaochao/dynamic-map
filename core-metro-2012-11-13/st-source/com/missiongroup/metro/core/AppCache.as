package com.missiongroup.metro.core
{
	
import com.missiongroup.metro.entities.Prices;
import com.missiongroup.metro.entities.TrainLine;
import com.missiongroup.metro.entities.TrainStation;
import com.missiongroup.metro.entities.TrainTimes;
import com.missiongroup.metro.entities.UserTime;
import com.struts.utils.ArrayUtil;
import com.struts.utils.HashTable;

import mx.collections.ArrayCollection;
	
/**
 * 
 * SQLite 数据缓存类
 * 
 * 缓存  MIT_APP 数据
 *  
 * @author ZhouHan
 * 
 */
public class AppCache
{

	public static const Lines : HashTable = new HashTable();
	
	public static const Stations : HashTable = new HashTable();
	
	public static var LineColors : HashTable = new HashTable();
	
	public static var PricesVal : HashTable = new HashTable();
	
	public static var HzPricesVal : HashTable = new HashTable();
	
	public static var City : String;
	
	public static var Station : TrainStation;
	
	public static var Line : TrainLine;
	
	public static var UserLines : ArrayCollection = new ArrayCollection();
	
	private static var _userLineCache:Object = {};
	
	/**
	 *
	 * 加载所有地铁线路和站点 数据，该数据为整个系统共享。
	 *  
	 * @param lines
	 * @param staions
	 * @param stationLines
	 * @param stationFreeLines
	 * 
	 */	
	public static function loadTrains(lines : Array,
									  staions : Array,
									  stationLines : Array,
									  stationFreeLines : Array,
									  prices : Array,
									  hzprices : Array) : void
	{
		
		Lines.clear();
		Stations.clear();
		UserLines = new ArrayCollection();
		
		var allTrainLines:Vector.<TrainLine> = new Vector.<TrainLine>();
		
		var trainLine : TrainLine;
		var item : Object;
		for each(item in lines)
		{
			trainLine = new TrainLine();
			trainLine.TrainLineID = item.LineId;
			trainLine.UpOrDown = item.Dir;
			trainLine.Diretion = item.DirName;
			trainLine.DiretionE = item.DirNameE;
			trainLine.IsRing = item.IsRing;
			trainLine.ShortNum = item.ShortNum;
			trainLine.Name = item.Name;
			trainLine.NameE = item.NameE;
			trainLine.Company = item.Company;
			
			Lines.add(item.LineId,trainLine);
			
			allTrainLines.push(trainLine);
			
			if(!UserLines.contains(item.ShortNum))
			    UserLines.addItem(item.ShortNum);
		}
		
		
		var trainStation : TrainStation;
		for each(item in staions)
		{
			trainStation = new TrainStation();
			trainStation.StationId = item.StationId;
			trainStation.Remark = item.Remark;
			trainStation.Name = item.Name;
			trainStation.NameE = item.NameE;
			trainStation.IsRun = item.isRun;
			trainStation.Spell = item.Spell;
			trainStation.MapX  = item.MapX || 0;
			trainStation.MapY  = item.MapY || 0;
			
			Stations.add(item.StationId,trainStation);
		}

		
		var LineId : String;
		var StationId : String;
		var isHave : Boolean;
		
		var trainTimes : TrainTimes;
		var userTime : UserTime;
		for each(item in stationLines)
		{
			LineId = item.LineId;
			StationId = item.StationId;
			
			trainLine = Lines.find(LineId);
			trainStation = Stations.find(StationId);
			if(trainLine && trainStation)
			{

				trainTimes = new TrainTimes();
				trainTimes.LineShortNum = trainLine.ShortNum;
				trainTimes.Dir = trainLine.UpOrDown;
				trainTimes.Direction = trainLine.Diretion;
				trainTimes.DirectionE = trainLine.DiretionE;
				trainTimes.STime = item.STime;
				trainTimes.ETime = item.ETime;
				trainStation.TrainTimes.push(trainTimes);
				
				userTime = new UserTime();
				userTime.WaitTime = item.WaitTime;
				userTime.DriveTime = item.DriveTime;
				
				trainLine.UseTimeList.push(userTime);
				trainLine.StationList.push(trainStation);
				trainLine.StationIDList.push(trainStation.StationId);
				
				isHave = trainStation.Lines.indexOf(trainLine.TrainLineID) != -1;
				if(!isHave)
				{
					trainStation.Lines.push(trainLine.TrainLineID);
				}
				
				isHave = trainStation.UserLines.indexOf(trainLine.ShortNum) != -1;
				if(!isHave)
				{
					trainStation.UserLines.push(trainLine.ShortNum);
				}
				
				// 换乘特殊处理 *********************************************************************************************
//				specialChangeLine(trainLine, trainStation);
				
			}
		}
		
		
		for each(item in stationFreeLines)
		{
			LineId = item.LineId;
			StationId = item.StationId;
			
			trainLine = Lines.find(LineId);	
			trainStation = Stations.find(StationId);
			
			if(trainLine && trainStation)
			{
				trainLine.IsFree = 1;
				trainLine.FreeLinkStationId = item.LinkStationId;
				
				trainLine.FreeStationIDList.push(StationId);
				trainLine.FreeStationList.push(trainStation);
			}
		}
		
		for each(item in prices){
			PricesVal.add(item.inStationID + item.outStationID,item.rateVal);
		}
		
		for each(item in hzprices){
			HzPricesVal.add(item.inStationID + item.outStationID,item.price);
		}
		
		//var ls : Array = Lines.toArray();
		
		
		/** 换乘特殊处理    *********************************************************************************************/
		for each(var l:TrainLine in allTrainLines){
			for each(var s:TrainStation in l.StationList){
				specialChangeLine(l, s);
			}
		}
		
	}
	
	/**
	 * 换乘站的特殊处理
	 */
	private static function specialChangeLine(trainLine:TrainLine, trainStation:TrainStation):void{
		/*******************************************************************/
		/****         3号线             *******************************************/
		/*******************************************************************/
		if(trainLine.ShortNum == "3"){
			// 上海南站、石龙路、龙潭路、漕溪路、宜山路 去除4号线的换乘
			var changeRemoves:Array = ["上海南站","石龙路","龙漕路","漕溪路","长江南路"];
			
			if(changeRemoves.indexOf(trainStation.Name) != -1){
				var index:int = trainStation.UserLines.indexOf("4");
				if(index != -1){
					trace("------------------    "+trainStation.Name + "- remove line 4");
					trainStation.UserLines.splice(index, 1);
				}
			}
			
			
			// 上海南站增加换乘15号线 ;  2021.1.9
			if(trainStation.Name == "上海南站"){ 
				if(trainStation.UserLines.indexOf("15") == -1) trainStation.UserLines.push("15");
			}
			
			// 上海南站增加换乘金山铁路 ;  2024.12.9
			if(trainStation.Name == "上海南站"){ 
				if(trainStation.UserLines.indexOf("jinshan") == -1) trainStation.UserLines.push("jinshan");
			}

			if(trainStation.Name == "曹杨路"){ 
				if(trainStation.UserLines.indexOf("14") == -1) trainStation.UserLines.push("14");
			}

			if(trainStation.Name == "长江南路"){ 
				if(trainStation.UserLines.indexOf("18") == -1) trainStation.UserLines.push("18");
			}
			
		}
		// 浦东大道 去除3号线的换乘
		if(trainLine.ShortNum == "4"){
			
			var changeRemoves:Array = ["浦东大道"];
			
			if(changeRemoves.indexOf(trainStation.Name) != -1){
				var index:int = trainStation.UserLines.indexOf("3");
				if(index != -1){
					trace("------------------    "+trainStation.Name + "- remove line 3");
					trainStation.UserLines.splice(index, 1);
				}
			}

			if(trainStation.Name == "浦东大道"){ 
				if(trainStation.UserLines.indexOf("14") == -1) trainStation.UserLines.push("14");
			}
			

		}
	}
	
	
	/**
	 * 设置换乘站 
	 * @param line 线路号
	 * @param dir 方向
	 * @param index 第几站
	 * @param userLine 换乘数据，注意需要加上自身的线路号
	 */
	public static function setUserLine(line:String , dir:String , index:int , userLine:Array):void{
		var tline:TrainLine = getLine(line , dir);
		var cacheKey:String = (tline.TrainLineID+'_'+index).toUpperCase();
		_userLineCache[cacheKey] = userLine; 
		
//		var lineKey : String = ("Line_" + line + "_" +dir).toUpperCase();
//		var trainLine:TrainLine = Lines.find(lineKey);
//		if(!trainLine) return;
//		var t:TrainStation = trainLine.StationList[index];
//		if(!t) return;
		
		//为防止影响他们的线路，克隆站点
//		var clone:TrainStation = t.clone();
//		trainLine.StationList[index] = clone;
		
//		clone.UserLines = userLine;
	}
	
	public static function getLine(lineNum:String , dir:String):TrainLine{
		var lineKey : String = ("Line_" + lineNum + "_" +dir).toUpperCase();
		return Lines.find(lineKey);
	}
	
	public static function getUserLine(station:TrainStation , line:TrainLine):Array{
		var index:int = line.StationList.indexOf(station);
		var cacheKey:String = (line.TrainLineID+'_'+index).toUpperCase();
		if(_userLineCache[cacheKey]){
			return _userLineCache[cacheKey];
		}
		return null
	}
	
	
	public static function init(setting : Setting) : void
	{
		var lineKey : String = ("Line_" + setting.LineNum + "_" +setting.LineDir).toUpperCase();
		LineColors = setting.LineColors;
		City = setting.City;
		Station = AppCache.Stations.find(setting.StationId);
		Line = AppCache.Lines.find(lineKey);
		
		var color : uint;
		var line : String;
		for (var i : int = 0;i<UserLines.length;i++)
		{
			line = UserLines.getItemAt(i).toString();
			color = setting.LineColors.find(line);
			if(color)
			{
				UserLines.setItemAt({line : line,color : color},i);
			}
		}
	}
	
}
}



















































