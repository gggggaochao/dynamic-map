package com.missiongroup.car.componets
{
import com.missiongroup.car.consts.ColorsMode;
import com.missiongroup.car.consts.DisplayDir;
import com.missiongroup.car.consts.DisplayMode;
import com.missiongroup.car.core.IStation;
import com.missiongroup.car.skins.RightStationRendererSkin;
import com.missiongroup.car.utils.RailUtils;
import com.missiongroup.car.views.renderers.TransferLineRenderer;
import com.missiongroup.metro.entities.TrainStation;
import com.struts.layout.TriangleLayout;

import flash.display.Sprite;
import flash.events.Event;
import flash.events.TimerEvent;
import flash.geom.Point;
import flash.utils.Timer;
import flash.utils.clearInterval;
import flash.utils.setInterval;
import flash.utils.setTimeout;

import mx.core.IVisualElement;
import mx.events.FlexEvent;

import spark.components.Group;
import spark.components.HGroup;
import spark.components.Label;
import spark.components.supportClasses.SkinnableComponent;
import spark.layouts.HorizontalAlign;
import spark.layouts.VerticalLayout;
import spark.layouts.supportClasses.LayoutBase;
import spark.primitives.BitmapImage;

import assets.Assets;

[SkinState("normal")]

[SkinState("pass")]

[SkinState("next")]

public class StationRenderer extends SkinnableComponent implements IStation
{
	
	[SkinPart(required="false")]
	public var stationDisplay : Label;

	[SkinPart(required="false")]
	public var stationENDisplay : Label;
	
	
	[SkinPart(required="false")]
	public var stationSprite : StationSprite;

	[SkinPart(required="false")]
	public var railSprite : RailSprite;

	
//	[SkinPart(required="true")]
//	public var arrowIcon : BitmapImage;
//	
//	[SkinPart(required="true")]
//	public var stationIcon : BitmapImage;
//	
//	[SkinPart(required="true")]
//	public var stationLineIcon1 : BitmapImage;
//
//	[SkinPart(required="false")]
//	public var stationLineIcon2 : BitmapImage;

	[SkinPart(required="false")]
	public var userLineGroup : UserLineGroup;
	
	[SkinPart(required="false")]
	public var contentGroup : HGroup;
	
	[SkinPart(required="true")]
	public var group : Group;
	
	private var _transferRenderer : TransferLineRenderer;
	
	public override function set x(v:Number):void{
		super.x = v;
	}
	
	public override function set y(v:Number):void{
		super.y = v;
	}

	public function StationRenderer()
	{
		super();
	}
	
	private var _station : TrainStation;
	
	private var _protypeChange : Boolean;
	
	public function get station():TrainStation
	{
		return _station;
	}
	
	public function set station(value:TrainStation):void
	{
		if(_station != value)
		{
			_station = value;
			_protypeChange = true;
			
			invalidateProperties();
		}
	}
	
	private var _rails : Array;

	/**
	 *  轨道点几何 
	 */
	public function get rails():Array
	{
		return _rails;
	}

	/**
	 * @private
	 */
	public function set rails(value:Array):void
	{
		if(_rails != value){
			trace('rails update');
			_protypeChange = true;
			invalidateProperties();
		}
		_rails = value;
	}


	private var _dir : String = DisplayDir.Right;

	public function get dir():String
	{
		return _dir;
	}

	public function set dir(value:String):void
	{
		_dir = value;
	}


	private var _userLines : Array;
	
	private var _userLinesChanged : Boolean;

	public function get userLines():Array
	{
		return _userLines;
	}

	public function set userLines(value:Array):void
	{
		if(_userLines != value)
		{
			_userLines = value;
			_userLinesChanged = true;
			
			invalidateProperties();
		}
	}


	private var _isEnd : Boolean;

	public function get isEnd():Boolean
	{
		return _isEnd;
	}

	public function set isEnd(value:Boolean):void
	{
		_isEnd = value;
	}


	private var _isStart : Boolean;

	public function get isStart():Boolean
	{
		return _isStart;
	}

	public function set isStart(value:Boolean):void
	{
		_isStart = value;
	}


	private var _isUp : Boolean;

	/**
	 *  标记是否向上 
	 */
	public function get isUp():Boolean
	{
		return _isUp;
	}

	/**
	 * @private
	 */
	public function set isUp(value:Boolean):void
	{
		_isUp = value;
	}
	
	
	private var _displayMode : String;
	
	private var _displayModeChanged : Boolean;
	
	public function get displayMode():String
	{
		return _displayMode;
	}
	
	public function set displayMode(value:String):void
	{
		if(_displayMode != value)
		{
			_displayMode = value;
			_displayModeChanged = true;
			
			invalidateProperties();
			invalidateSkinState();
		}
	}
	
	
	private var _isRing : Boolean;

	public function get isRing():Boolean
	{
		return _isRing;
	}

	public function set isRing(value:Boolean):void
	{
		_isRing = value;
	}

	
	override protected function partAdded(partName:String, instance:Object):void
	{
		super.partAdded(partName, instance);
		
//		if(userLineGroup == instance)
//		{
//
//		   if(userLines)
//		   {
//			   userLineGroup.includeInLayout = false;
//			   userLineGroup.removeAllElements();
//			   
//			   userLineGroup.width = normalSize;
//			   userLineGroup.height = userLinesHeight;
//			   userLineGroup.line = _line;
//			   userLineGroup.isUp = isUp;
//			   userLineGroup.userLines = userLines;
//		   }
//		}
		
		if(stationSprite == instance)
		{
			stationSprite.fills = S_COLORS;
			stationSprite.draw(DisplayMode.NORMAL);
		}
		
		if(railSprite == instance)
		{
			railSprite.rails = rails;
			railSprite.fills = R_COLORS;
			railSprite.drawNormal();
		}
		
		
		if(group == instance)
		{
			group.addEventListener(Event.RESIZE,_groupResizeChangedHandler);
		}
		
		if(contentGroup == instance)
		{
			contentGroup.gap = line ==  "3" ? 4 : 8;
		}
		
	}
	
	private function _groupResizeChangedHandler(event : Event) : void
	{
		if(userLineGroup)
		{
			userLineGroup.width = group.width;
		}
	}
	
	public var normalSize : Number = 28;

	public var userLinesHeight : Number = 80;
	
	public var bigSize : Number = 60;

	public var nextSize : Number = 36;

	
	public var S_COLORS : Array;
	
	public var R_COLORS : Array;

	
	private var _line : String;
	
	public function get line():String
	{
		return _line;
	}

	public function set line(value:String):void
	{
		_line = value;
		
		S_COLORS = _line == "4" ? ColorsMode.S_4_Narmal_Colors : ColorsMode.S_3_Narmal_Colors;
		R_COLORS = _line == "4" ? ColorsMode.R_4_Colors : ColorsMode.R_3_Colors;
	}

//	protected override function commitProperties(): void
//	{
//		
//	}
	
	protected override function commitProperties(): void
	{
		super.commitProperties();
		
		

		if(_protypeChange)
		{
			_protypeChange = false;
			
			/**
			 *  站名坐标
			 * */
			stationDisplay.text = _station.Name;
			
			if(stationENDisplay) 
				stationENDisplay.text = _station.NameE;
			
			if(stationSprite)
			{
				stationSprite.fills = S_COLORS;
				stationSprite.draw(DisplayMode.NORMAL);
			}
			
			if(railSprite)
			{
				railSprite.rails = rails;
				railSprite.fills = R_COLORS;
				railSprite.drawNormal();
			}
		}
		
		
		if(_userLinesChanged)
		{
			_userLinesChanged = false;
			if(userLines)
			{
				if(userLineGroup){
					// 添加不包含"jinshan"的判断逻辑
					userLineGroup.lineString = (this is ArrivedStationRenderer && userLines.indexOf("jinshan") == -1) ? "号线" : "";
					userLineGroup.line = _line;
					userLineGroup.isUp = isUp;
					userLineGroup.userLines = userLines;
				}
			}
		}
		
		
		if(_displayModeChanged)
		{
			_displayModeChanged = false;
			
			invalidateSizeList();
			invalidateLableDisplayList();
			
			
			
			updateDraw();
		}
		
	}
	
	protected function invalidateSizeList() : void
	{

		var normalW : Number = line == "3" ? 77 : 80;
		var nextW : Number = line == "3" ? 88 : 90;
		
		if(displayMode == DisplayMode.NEXT)
		{
			group.width = group.height = nextSize;
			width = isStart ? 32 : nextW; 
			if(userLines)
			{
				if(userLineGroup) userLineGroup.height = 100;
			}	
		}
		else
		{
			group.width = group.height = 24;
			width = isStart ? 22 : normalW; 
			if(userLines && userLineGroup)
			{
				userLineGroup.height = userLinesHeight;
			}	
		}	

	}
	
	
//	private var _railVisible:Boolean = true;
	
	private var _railVisibleTimer:Timer = new Timer(100,5);
	
	/**
	 * 线路是否可见
	 */
	public function setRailVisible(v:Boolean):void{
//		if(_railVisible == v) return;
//		_railVisible = v;
		if(!_railVisibleTimer.hasEventListener(TimerEvent.TIMER)){
			_railVisibleTimer.addEventListener(TimerEvent.TIMER,hideTimeout);
		}
		
		_railVisibleTimer.reset();
		_railVisibleTimer.start();
		
		function hideTimeout(e:TimerEvent):void{
			if(railSprite){
				railSprite.visible = v;
				_railVisibleTimer.stop();
			}
		}
		
	}
	
	protected function updateDraw() : void
	{
		
		switch(_displayMode)
		{
			case DisplayMode.PASS : 
			{
				if(stationSprite)
				{
				   stationSprite.fills = ColorsMode.S_PASS;
				   stationSprite.draw(DisplayMode.PASS,normalSize,normalSize);
				}
				
				if(railSprite && railSprite.visible)
				{
				   railSprite.fills = ColorsMode.R_PASS;
				   railSprite.drawPass();
				}
				
				break;
			}
			case DisplayMode.NEXT : 
			{
				if(stationSprite)
				{
					stationSprite.fills = S_COLORS;
					stationSprite.draw(DisplayMode.NEXT,nextSize,nextSize,8,14);
				}
				
				break;
			}
			default :
			{
				if(stationSprite)
				{
				   stationSprite.fills = S_COLORS;
				   stationSprite.draw(DisplayMode.NORMAL,normalSize,normalSize);
				}
				
				if(railSprite && railSprite.visible)
				{
					
					if(dir == DisplayDir.DownReFix){
						railSprite.fills = ColorsMode.R_PASS;
						railSprite.drawPass();
					}else{
						railSprite.fills = R_COLORS;
						railSprite.drawNormal();
					}
				  
				}
			}
		}		
	}
	
	public function invalidateLableDisplayList() : void
	{
		// 设置中文名字的位置
		// isUp = true: 设置上面线路中文和站点之间的距离（正）
		// isUp = false: 设置下面线路中文和站点之间的距离（负）
		// _displayMode: next 显示下一站中英文信息，站点放大，文字闪烁
		// _displayMode: normal 显示站点中英文信息，站点正常，文字正常
		var addGap : Number = DisplayMode.NEXT == _displayMode ? normalSize + 5 : normalSize;
		stationDisplay.verticalCenter    =  isUp ? addGap + 5 : - addGap;
		
		// 设置英文名字的位置
		// isUp = true: 设置下面线路英文和站点之间的距离（正）
		// isUp = false: 设置上面线路英文和站点之间的距离（负）
		if(stationENDisplay)
			stationENDisplay.verticalCenter = isUp ? (addGap + 20) : - (addGap+20);
		
	}
	

	override protected function getCurrentSkinState():String
	{
		return _displayMode;
	}
	
	
	public function destroy() : void
	{
//		_station = null;
//		_dir = null;
//		_displayMode = null;
		
//		group.removeEventListener(Event.RESIZE,_groupResizeChangedHandler);
		
	}
	
}
}
























