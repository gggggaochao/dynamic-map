package com.missiongroup.metro.servers
{

/**
 *
 * 定时服务
 *  
 * @author ZhouHan
 * 
 */
public class TimingService extends Services
{
	public function TimingService(cmds : Array)
	{
		super(cmds);
	}
	
	
	override public function run() : void
	{
		complete();
	}
}
}