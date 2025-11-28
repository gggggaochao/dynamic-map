package com.struts.events
{
import com.struts.interfaces.ITreeNode;

import flash.events.Event;
	
public class MTreeEvent extends Event
{
	
	/**
	 *  
	 */	
	public static const NODE_CLICK : String = "nodeClick";
	
	public static const NODE_OPEN  : String = "nodeOpen";
	
	public static const NODE_CLOSE : String = "nodeClose";
	
	private var _treeNode : ITreeNode;

	public function get treeNode():ITreeNode
	{
		return _treeNode;
	}

	public function set treeNode(value:ITreeNode):void
	{
		_treeNode = value;
	}

	
	public function MTreeEvent(type:String,treeNode : ITreeNode,bubbles:Boolean=false, cancelable:Boolean=false)
	{
		super(type, bubbles, cancelable);
		
		this.treeNode = treeNode;
	}
}
}