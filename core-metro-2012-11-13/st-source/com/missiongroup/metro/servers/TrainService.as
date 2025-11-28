package com.missiongroup.metro.servers
{

import com.missiongroup.metro.command.consts.Command;
import com.missiongroup.metro.core.AppCache;
import com.missiongroup.metro.dao.SQLiteDao;
import com.missiongroup.metro.entities.TrainLine;
import com.missiongroup.metro.entities.TrainStation;
import com.missiongroup.metro.utils.AppDataUtils;


/**
 * 
 * MIT_APP SQLite 管理类
 * 
 * 地铁基础数据
 *  
 * @author ZhouHan
 * 
 */
public class TrainService extends Services
{
	
	public function TrainService(cmds : Array)
	{
		super(cmds);
	}
	
	private function isHaveAppLine() : Boolean
	{
		var sql  : String = "select count(0) as count from MIT_App_Line";
		
		var single : Object = dao.getSingle(sql);
		
		return single.count > 0;
		
	}
	
	override public function commandHandler():void
	{
		var content : XML = this.command.Content;
		var sqls : Array = AppDataUtils.getApps(content);
		var isSucces : Boolean = dao.executeTransaction(sqls);
		
		if(isSucces)
		{
			run();
		}
	}
	
	
	override public function run() : void
	{
		var isHave : Boolean = isHaveAppLine();
		
		if(isHave)
		{
			var trainLines : Array = dao.getQuery("SELECT ld.*,l.IsRing,l.Name,l.NameE,l.Company FROM MIT_App_LineDir ld, MIT_App_Line l WHERE ld.ShortNum = l.ShortNum ORDER BY ld.ShortNum;");

			var trainStations : Array = dao.getQuery("SELECT * FROM MIT_App_Station where isRun = 1");
		
			var trainLineStations : Array = dao.getQuery("SELECT * FROM MIT_App_LineStation ls ORDER BY ls.[LineId],ls.[orderid]");
			
			var trainFreeLineStations : Array = dao.getQuery("SELECT ld.LineId,lf.StationId,lf.FreeDir,lf.LinkStationId FROM MIT_App_LineFeeder lf,MIT_App_LineDir ld WHERE lf.Dir = ld.Dir AND lf.ShortNum = ld.ShortNum");
		
			var prices : Array = dao.getQuery("select ra.inStationID,ra.outStationID,ba.rateVal/100 as rateVal from Rate ra, BaseRate ba  where ra.rateclass = ba.rateClass and ba.ticketRateID = 0");
			
			var hzprices : Array = dao.getQuery("select ra.inStationID,ra.outStationID,ra.rateClass as price from Rate ra");
			
			//var hzprices_name : Array = dao.getQuery("");
			
			AppCache.loadTrains(trainLines,trainStations,trainLineStations,trainFreeLineStations,prices, hzprices);		
			AppCache.init(setting);
			//处理宜山路
			AppCache.setUserLine('4_2','up',4,["3","4","9"]);
			AppCache.setUserLine('4_2','down',0,["3","4","9"]);
			AppCache.setUserLine('4_2','down',26,["3","4","9"]);
			
		}
		
		complete();
	}
	
	public function getStationsByLineId(lineId:String):Array{
		var trainStations : Array = dao.getQuery("SELECT b.* FROM MIT_App_LineStation a,MIT_App_Station b where b.isRun = 1 and a.StationId=b.StationId and a.LineId='"+lineId+"' order by a.orderid asc");
		
		if(trainStations == null || trainStations.length < 1) return null;
		
		var trainStation : TrainStation;
		
		var result:Array = [];
		var item:Object;
		
		for each(item in trainStations)
		{
			trainStation = new TrainStation();
			trainStation.StationId = item.StationId;
			trainStation.Remark = item.Remark;
			trainStation.Name = item.Name;
			trainStation.NameE = item.NameE;
			trainStation.IsRun = item.isRun;
			trainStation.Spell = item.Spell;
			trainStation.MapX  = item.MapX ? item.MapX : 0;
			trainStation.MapY  = item.MapY ? item.MapY : 0;
			result.push(trainStation);
		}
		
		return result;
	}
	
	
	private function loadMapinit() : void
	{
		var lineId : String = ("Line_" + setting.LineNum + "_" +setting.LineDir).toUpperCase();
		var stationId : String = setting.StationId;
		
		
//		var map : Mapinit = new Mapinit();
//		map.X = Number(setting.MapX);
//		map.Y = Number(setting.MapY);
//		map.Url = setting.MapPath;
//		
//		var mapObject : Object = dao.getSingle("SELECT MapX,MapY FROM MIT_App_LineStation ls WHERE ls.LineId = '"+lineId+"' AND ls.StationId = '"+stationId+"'");
//			
//		if(mapObject)
//		{
//			if(mapObject.MapX != -1 && mapObject.MapY != -1)
//			{
//				map.X = mapObject.MapX;
//				map.Y = mapObject.MapY;
//			}
//		}
//		
//		AppCache.Map = map;
	}
	
}
}







































