package com.struts.events
{
public class GridViewEvent extends RecordEvent
{
	public static const UPDATE_START : String = "updateStart";
	
	public static const UPDATE_END : String = "updateEnd";
	
	
	public static const DELETE : String = "delete";
	
	public static const SAVE : String = "save";
	
	public var colIndex : Number;
	
	public var rowIndex : Number;
	
	public var protype : String;
	
	public function GridViewEvent(type:String, data:Object=null, callback:Function=null,protype : String = null,colIndex : Number = 0,rowIndex : Number = 0 ,bubbles:Boolean=false, cancelable:Boolean=false)
	{
		super(type, data, callback, bubbles, cancelable);
		
		this.protype = protype;
		this.colIndex = colIndex;
		this.rowIndex = rowIndex;
	}
}
}