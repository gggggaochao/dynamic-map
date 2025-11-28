package com.missiongroup.car.messages
	
{
	import com.spring.core.Message;
	public class Logtmp extends Message
	{
		public var msg : String;
		
		public function Logtmp(selector:String)
		{
			super(selector);
		}
	}
}