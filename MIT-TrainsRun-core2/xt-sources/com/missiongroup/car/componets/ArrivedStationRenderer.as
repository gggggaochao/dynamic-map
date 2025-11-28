package com.missiongroup.car.componets
{
	
import com.missiongroup.car.consts.ColorsMode;
import com.missiongroup.car.consts.DisplayMode;

public class ArrivedStationRenderer extends StationRenderer
{
	public function ArrivedStationRenderer()
	{
		super();
		
		nextSize = 50;
		normalSize = 50;
		userLinesHeight = 130;
	}
	
	override protected function partAdded(partName:String, instance:Object):void
	{
		super.partAdded(partName, instance);
		
		if(contentGroup == instance)
		{
			contentGroup.gap = 20;
		}
	}
	
	override protected function invalidateSizeList() : void
	{
	
		if(displayMode == DisplayMode.NEXT)
		{
			group.width = group.height = nextSize;
			width = height = isStart ? 80 : 150; 
			if(userLines)
			{
				userLineGroup.height = 160;
			}	
		}
		else if(displayMode == DisplayMode.PASS)
		{
			group.width = group.height = 24;
			//width = height = 160; 
			width = height = isStart ? 40 : 130; 
			if(userLines)
			{
				userLineGroup.height = 100;
			}			
		}
		else
		{
			group.width = group.height = normalSize;
			width = height = isStart ? 60 : 130; 
			if(userLines)
			{
				userLineGroup.height = 130;
			}
		}	
		
		
		railSprite.visible = !isStart;
		railSprite.includeInLayout = !isStart;
		
	}
	
	
	
	override protected function updateDraw() : void
	{
		
		switch(displayMode)
		{
			case DisplayMode.PASS : 
			{
				if(stationSprite)
				{
					stationSprite.fills = ColorsMode.S_PASS;
					stationSprite.draw(DisplayMode.PASS,24,24);
				}
				
				if(railSprite && railSprite.visible)
				{
					railSprite.fills = ColorsMode.R_PASS;
					railSprite.draw();
				}
				
				break;
			}
			case DisplayMode.NEXT : 
			{
				if(stationSprite)
				{
					stationSprite.fills = S_COLORS;
					stationSprite.draw(DisplayMode.NEXT,nextSize,nextSize,15,24);
				}
				
				if(railSprite && railSprite.visible)
				{
				   railSprite.fills = ColorsMode.R_PASS;
				   railSprite.draw();
				}
				
				break;
			}
			default :
			{
				if(stationSprite)
				{
					stationSprite.fills = S_COLORS;
					stationSprite.draw(DisplayMode.NORMAL,normalSize,normalSize,8,14);
				}
				
				if(railSprite && railSprite.visible)
				{
					railSprite.fills = R_COLORS;
					railSprite.draw();
				}
			}
		}		
	}
	
	
	override public function invalidateLableDisplayList() : void
	{
		var addGap : Number = DisplayMode.NEXT == displayMode ? normalSize + 10 : normalSize;
		stationDisplay.verticalCenter    =  isUp ? addGap : - addGap;
		
		if(stationENDisplay)
			stationENDisplay.verticalCenter = isUp ? (addGap + 22) : - (addGap + 22);
		
	}
	
	
	override public function destroy() : void {
		super.destroy();
	
	}
	
	
}
}