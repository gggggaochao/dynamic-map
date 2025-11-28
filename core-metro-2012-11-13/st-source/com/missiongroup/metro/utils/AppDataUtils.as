package com.missiongroup.metro.utils
{
	
import com.struts.utils.ArrayUtil;
import com.struts.utils.SQLUtil;

import mx.collections.ArrayCollection;
import mx.collections.ICollectionView;
import mx.collections.IViewCursor;
import mx.collections.XMLListCollection;
import mx.utils.StringUtil;

public class AppDataUtils
{
	
	private static var TEMP_DIR : String = "开往{0}方向";
	
	private static var TEMP_DIR_E : String = "To the Direction of {0} Station";
	
	
	/**
	 *
	 *  初始化数据的导入，根据属性名来确定数据类型，规则为
	 * 
	 *  属性名中含有Is、Num为数字类型
	 * 
	 *  
	 * @param doc
	 * 
	 */	
	public static function getApps(doc : XML) : Array
	{
		var dir : String = doc.@Dir;
		var dirE : String = doc.@DirE;
		
		if(dir)
			TEMP_DIR = dir;
		
		if(dirE)
			TEMP_DIR_E = dirE;
		
		
		var metroLineXMLList : XMLList = doc.MetroLine;
		var metroStationXMList : XMLList;
		
		var trainLineCount : int = metroLineXMLList.length();
		var trainStationCount : int;
		
		var i : int = 0;
		var j : int = 0;
		
		var metroLineNode : XML;
		var metroStationNode : XML;
		
		var sqls : Array = new Array();
		var sql : String;
		
		clear(sqls);
		
		
		/**
		 * 
		 *  导入线路和站点
		 * 
		 * */
		
		var stationsList : Array = new Array();
		var stationId : String;
		var isHave : Boolean;
		for (i = 0;i<trainLineCount;i++)
		{
			metroLineNode = metroLineXMLList[i];
			
			sql = SQLUtil.createInsertSQL(metroLineNode,"MIT_App_Line");
			sqls.push(sql);
			
			metroStationXMList = metroLineNode..Station;
			trainStationCount = metroStationXMList.length();
			
			for (j = 0;j<trainStationCount;j++)
			{
				metroStationNode = metroStationXMList[j];
				stationId = metroStationNode.@StationId;
				
				isHave = stationsList.indexOf(stationId) != -1;
				
				if(!isHave)
				{
					stationsList.push(stationId);
					sql = SQLUtil.createInsertSQL(metroStationNode,"MIT_App_Station");
					sqls.push(sql);
				}
			}
			
			impLineDirAndStations(metroLineNode,sqls);
		}
		
		return sqls;
	}
	
	
	private static function clear(sqls : Array) : void
	{
		sqls.push("delete from MIT_App_Line");
		sqls.push("delete from MIT_App_Station");
		sqls.push("delete from MIT_App_LineDir");
		sqls.push("delete from MIT_App_LineFeeder");
		sqls.push("delete from MIT_App_LineStation");
	}
	
	
	private static function impLineDirAndStations(node : XML,sqls : Array) : void
	{
		
		/**
		 *  
		 * 支线 
		 *
		 **/
		var shortNum : String = node.@ShortNum;
		var nodeLine : XML = node.MainLine[0];
		var nodeStations : XMLList = node.MainLine.Station;
		var nodeStationsCount : int = nodeStations.length();
		if(nodeStationsCount < 2)
			return;
		
		var dir : String = nodeLine.@Dir;
		var nodeFreeLines : XMLList = node.FreeLine;
		var freeLineCount : int = nodeFreeLines.length();
		var frees : ICollectionView;
		var lineDir : String;
		if(freeLineCount)
		{
			var freeNode : XML = nodeFreeLines[0];
			var freeStationNodes : XMLList = freeNode.Station;
			var freeDir : String = freeNode.@FreeDir;
			lineDir = freeNode.@Dir;
			
			//var 
			var stationId : String;
			var linkStationId : String = freeNode.@LinkStationId;
			
			frees = new XMLListCollection(freeStationNodes);
			
			if(freeDir == "Down")
			{
				frees = ArrayUtil.reverse(freeStationNodes);
			}
			
			var cursor  : IViewCursor = frees.createCursor();
			var item : Object
			while(!cursor.afterLast)
			{
				item = cursor.current;
				stationId = item.@StationId;
				
				sql = StringUtil.substitute("insert into MIT_App_LineFeeder values ({0},'{1}','{2}','{3}','{4}')",
												shortNum,linkStationId,dir,freeDir,stationId);
				sqls.push(sql);	
				
				cursor.moveNext();
			}			
		}
		
		
		/**
		 *  
		 *   主线
		 * 
		 * */
		var sql : String;
		var stations : Array;
		var lineId : String =  ("Line_" + shortNum + "_" + dir).toUpperCase();
		
		sql = formatLineDirString(nodeStations,frees,lineDir,lineId,dir,shortNum);
		sqls.push(sql);

		foramtLineAndStation(nodeStations,lineId,dir,sqls);

		var reDir : String = dir == "Up" ? "Down" : "Up";
		
		
		lineId = ("Line_" + shortNum + "_" + reDir).toUpperCase();
		
		sql = formatLineDirString(nodeStations,frees,lineDir,lineId,reDir,shortNum);
		sqls.push(sql);
	
		foramtLineAndStation(nodeStations,lineId,reDir,sqls);			
		
	}
	
	
	
	private static function foramtLineAndStation(nodeStations : XMLList,
												 lineId : String,
												 dir : String,
												 sqls : Array) : void
	{

		var list : ICollectionView = new XMLListCollection(nodeStations);
		
		if(dir == "Down")
		{
		   list = ArrayUtil.reverse(nodeStations);
		}
		
		
		var cursor  : IViewCursor = list.createCursor();
		var selectIndex : int = 1;
		var stationId : String;
		
		var time : Object;
		var driveTime : String;
		var waitTime : String; 
		var sTime : String; 
		var eTime : String;
		//var mapX : String; 
		//var mapY : String;
		
		var sql : String;
		while(!cursor.afterLast)
		{
			var item : Object = cursor.current;
			time = item[dir + "Time"];
			
			stationId = item.@StationId;
			sTime = time.@STime;
			eTime = time.@ETime;
			driveTime = time.@DriveTime || "0";
			waitTime = time.@WaitTime || "0";
			//mapX = time.@MapX || "-1";
			//mapY = time.@MapY || "-1";			
			
			sql = StringUtil.substitute("insert into MIT_App_LineStation values ('{0}','{1}',{2},'{3}','{4}',{5},{6})",
				lineId,stationId,selectIndex,sTime,eTime,waitTime,driveTime);
			
			sqls.push(sql);
			
			selectIndex++;
			cursor.moveNext();
		}
	}
	
	
	private static function formatLineDirString(nodeStations : XMLList,
												frees : ICollectionView,
												freeDir : String,
												lineId : String,
												dir : String,
												shortNum  : String) : String
	{
		
		var count : int = nodeStations.length();
		var stationNode : XML = dir == "Up" ? nodeStations[count - 1] : nodeStations[0];
		var sName : String = stationNode.@Name;
		var sNameE :String = stationNode.@NameE;
		
		if(frees && freeDir == dir)
		{
			var cursor  : IViewCursor = frees.createCursor();
			var item : Object = cursor.current;
			sName = sName + "/" + item.@Name;
			sNameE = sNameE +  "/" + item.@NameE;
		}
		
		
		var dirName : String = StringUtil.substitute(TEMP_DIR,sName);
		var dirNameE : String = StringUtil.substitute(TEMP_DIR_E,sNameE);
		
		return StringUtil.substitute("insert into MIT_App_LineDir values ('{0}',{1},'{2}','{3}','{4}')",
			                          lineId,shortNum,dir,dirName,dirNameE);
		
	}
}
}








