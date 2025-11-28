package com.spring.tags.model
{
	
import mx.collections.ArrayCollection;

public class TagBaseView
{

	public var isInjectComplete : Boolean = false;
	
	public var init : Function;
	
	public var destroy : Function; 
	
	public var messageHandlers : Array;
	
	public var view : *;
	
}
}