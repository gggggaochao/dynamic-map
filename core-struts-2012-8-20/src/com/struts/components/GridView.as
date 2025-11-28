package com.struts.components
{
import com.struts.events.GridViewEvent;

import mx.containers.Grid;

import spark.components.DataGrid;
import spark.components.gridClasses.GridColumn;
import spark.events.GridItemEditorEvent;

[Event(name="updateStart", type="com.struts.events.GridViewEvent")]

[Event(name="updateEnd", type="com.struts.events.GridViewEvent")]

[Event(name="delete", type="com.struts.events.GridViewEvent")]

[Event(name="save", type="com.struts.events.GridViewEvent")]

public class GridView extends DataGrid
{
	public function GridView()
	{
		super();
	}
	
	protected override function createChildren():void
	{
		super.createChildren();
		
		addGridViewEvent();
	}
	
	private function addGridViewEvent() : void
	{
		if(hasEventListener(GridViewEvent.UPDATE_START))
		{
			addEventListener(GridItemEditorEvent.GRID_ITEM_EDITOR_SESSION_START,openEditorDataHandler);			
		}
		
		if(hasEventListener(GridViewEvent.UPDATE_END))
		{
			addEventListener(GridItemEditorEvent.GRID_ITEM_EDITOR_SESSION_SAVE,saveNewDataHandler);			
		}
		
	}
	
	private var _oldValue : *;
	
	private function openEditorDataHandler(event : GridItemEditorEvent) : void
	{
		var col : GridColumn = this.columns.getItemAt(event.columnIndex) as GridColumn;
		
		_oldValue = this.dataProvider.getItemAt(event.rowIndex);
		
		_oldValue = _oldValue[col.dataField];
		
		var e : GridViewEvent = new GridViewEvent(GridViewEvent.UPDATE_START,_oldValue,null,col.dataField,event.columnIndex,event.rowIndex);
		dispatchEvent(e);
		
	}
	
	private function saveNewDataHandler(event : GridItemEditorEvent) : void
	{
		var data : Object = this.dataProvider.getItemAt(event.rowIndex);

		var col : GridColumn = this.columns.getItemAt(event.columnIndex) as GridColumn;
		
		var _newValue : * = data[col.dataField];
		
		if(_oldValue != _newValue)
		{
			
			var e : GridViewEvent = new GridViewEvent(GridViewEvent.UPDATE_END,data,null,
														col.dataField,event.columnIndex,event.rowIndex);
			dispatchEvent(e);
		}
	}
}


}






































