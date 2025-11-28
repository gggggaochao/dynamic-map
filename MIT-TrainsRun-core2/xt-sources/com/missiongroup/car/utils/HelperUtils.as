package com.missiongroup.car.utils
{
	
import com.missiongroup.car.componets.ArrivedStationRenderer;
import com.missiongroup.car.consts.DisplayDir;
import com.missiongroup.car.core.IStation;
import com.missiongroup.car.skins.ArrivedLeftStationRendererSkin;
import com.missiongroup.car.skins.ArrivedRightStationRendererSkin;
import com.missiongroup.car.views.icons.Line;
import com.missiongroup.metro.command.consts.Direction;
import com.missiongroup.metro.core.AppCache;
import com.missiongroup.metro.entities.TrainLine;
import com.missiongroup.metro.entities.TrainStation;
import com.struts.utils.HashTable;

import mx.core.IVisualElement;
import mx.core.UIComponent;

public class HelperUtils
{
	
	private static const cacheStations : HashTable = new HashTable();
	
	/**
	 * 
	 * 缓存当前线路的 Station UI
	 *  
	 * @param _line
	 * 
	 */	
	public static function initCacheStation(_line : String , dir:String = "up") : void 
	{
		var _lineKey : String = ("Line_" + _line + "_" + dir).toUpperCase();
		var _trainLine : TrainLine = AppCache.Lines.find(_lineKey);
		var nums : int = _trainLine.StationList.length;
		var trainStaion : TrainStation;
		for (var i : int = 0;i<nums;i++)
		{
			trainStaion = _trainLine.StationList[i];
			createItemRenderer(trainStaion,_line,"up");
			createItemRenderer(trainStaion,_line,"down");
		}
	}
	
	public static function initCacheStation2(_line : String , dir:String = "up") : void 
	{
		var _lineKey : String = ("Line_" + _line + "_" + dir).toUpperCase();
		var _trainLine : TrainLine = AppCache.Lines.find(_lineKey);
		var nums : int = _trainLine.StationList.length;
		var trainStaion : TrainStation;
		for (var i : int = 0;i<nums;i++)
		{
			trainStaion = _trainLine.StationList[i];
			createItemRenderer(trainStaion,_line,dir);
		}
	}
	
	/**
	 * 根据KEY缓存 Station UI
	 * @param key 对应数据库MIT_App_LineStation.LineId
	 * @param stations 包含TrainStation的数据数组
	 * @param dir 方向，up,dowm
	 * 
	 */
	public static function cacheStationByLineKey(key:String , stations:Array , dir:String = 'up'):void{
		var trainStaion : TrainStation;
		for(var i:int ; i < stations.length ; i++){
			trainStaion = stations[i];
			createItemRenderer(trainStaion , key , dir);
		}
	}
	
	/**
	 *
	 * 获取当前Key 对应的 Station UI
	 *  
	 * @param key
	 * @return 
	 * 
	 */	
	public static function getStationRenderer(key : String) : IStation {
		return cacheStations.find(key);
	}
	
	private static function createItemRenderer(trainStaion : TrainStation,lineNum : String,dir : String) : IStation
	{
		var key : String = lineNum + "_" +trainStaion.StationId + "_" + dir;
		
		var myItemRenderer : IStation = cacheStations.find(key);				
		
		if(myItemRenderer) 
			return myItemRenderer;
		
		if(!myItemRenderer)
			myItemRenderer = new ArrivedStationRenderer();
		
		var line:String = lineNum == '4_2' ? '4' : lineNum;
		
		var trainLine:TrainLine = AppCache.getLine(lineNum,dir);
		
		myItemRenderer.station = trainStaion;
		myItemRenderer.line = line;
//		myItemRenderer.userLines = HelperUtils.getUserLines(trainStaion,lineNum);
		myItemRenderer.userLines = HelperUtils.getUserLines(trainStaion,trainLine);
		//myItemRenderer.dir = dir == Direction.UP ? DisplayDir.Right : DisplayDir.Left;
		myItemRenderer.dir = DisplayDir.Right;
		
		setSkinClass(myItemRenderer);
		
		cacheStations.add(key,myItemRenderer);
		
		return myItemRenderer;
	}	
	
	private static function setSkinClass(renderer : IStation) : void
	{
		var ui : UIComponent = renderer as UIComponent;
		
		
		var skinClass : Class;
		switch(renderer.dir)
		{
			case DisplayDir.Right : 
			{
				renderer.rails = RailUtils.nRightPoints;
				skinClass = Class(com.missiongroup.car.skins.ArrivedRightStationRendererSkin);
				break;
			}
			default :
			{
				renderer.rails = RailUtils.nRightPoints;
				skinClass = Class(com.missiongroup.car.skins.ArrivedLeftStationRendererSkin);
				break;
			}
		}	
		ui.setStyle('skinClass',skinClass);
	}	
	
	/**
	 * 
	 * 获得站点是否有共线
	 * 
	 * */
	public static function getUserLines(trainStaion : TrainStation,line:TrainLine) : Array
	{
		var cacheUserLine:Array = AppCache.getUserLine(trainStaion,line);
		if(cacheUserLine){
			return cacheUserLine;
		}
		
		var count : int = trainStaion.UserLines.length;
		
		if(count > 1)
		{
			var _currLineIndex : int = trainStaion.UserLines.indexOf(line.ShortNum);
			
			var userLines : Array = new Array();
			var i : int = 0;
			for (i = 0;i<count;i++)
			{
				if(i != _currLineIndex)
				{
					userLines.push(trainStaion.UserLines[i]);
				}
			}
			
			return userLines;
			
		}
		
		return null;
	}
	
	
	private static function createIcon(index : int,lineNum : String) : IVisualElement
	{
		var ele : Line= new Line();
		ele.text = lineNum;
		ele.bgColor = AppCache.LineColors.find(lineNum);
		ele.fontColor = lineNum == "3" ? 0: 0xFFFFFF;
		
		return ele;
	}
}
}