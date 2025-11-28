package com.struts.interfaces
{
import flash.events.IEventDispatcher;

import mx.collections.IList;
import mx.core.IVisualElement;
import mx.core.IVisualElementContainer;
import mx.core.UIComponent;

public interface ITreeNode extends IEventDispatcher
{
	//function get childrenContainer() : IVisualElementContainer;
	
	function set parentNode(value : ITreeNode) : void
	function get parentNode() : ITreeNode;
	
	function set childrenNode(value : Array) : void
	function get childrenNode() : Array;
	
	function set childrenViewRoot(value : UIComponent) : void;
	function get childrenViewRoot() : UIComponent;
	
	function get data() : Object;
	function set data(value : Object) : void;
	
	function get isRoot() : Boolean;

	function get isLeaf() : Boolean;

	
	function set isOpen(value : Boolean) : void;
	function get isOpen() : Boolean;
	
	
	
	function set label(value : String) : void;
	function get label() : String; 
	
	function set icon(value : Object) : void;
	function get icon() : Object; 
	
	function set selected(value : Boolean) : void;
	function get selected() : Boolean;
	
}
}