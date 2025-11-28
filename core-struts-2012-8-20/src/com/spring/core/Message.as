package com.spring.core
{
	/**
	 * Message base class.
	 */	
	public class Message
	{
		
		//---------------------------------------------------------------------------
		//
		// Variables
		//
		//---------------------------------------------------------------------------

		[Selector]
		public var selector:String;
		
		//---------------------------------------------------------------------------
		//
		// Constructor
		//
		//---------------------------------------------------------------------------	
		public function Message(selector:String)
		{
			this.selector = selector;
		}
	}
}