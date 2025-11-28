package com.missiongroup.car.consts
{
	public class CMD
	{
		
		/** 离站 */
		public static const LeaveStation : uint = 0x02;
		
		public static const LeaveStation_End : uint = 0x03;
		
		
		/** 到站 */
		public static const ArrivedStation : uint = 0x04;

		public static const ArrivedStation_End : uint = 0x05;
	
		/** 线路切换，区间设置 */
		public static const ChangeLine : uint = 0x06;
		
		/** 越站 */
		public static const PassStation : uint = 0x07;

		
		/** 越站恢复 */
		public static const PassStation_ReSet : uint = 0x08;

	}
}