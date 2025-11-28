package com.missiongroup.metro.servers
{

import com.missiongroup.metro.command.consts.Command;

import flash.desktop.NativeProcess;
import flash.desktop.NativeProcessStartupInfo;
import flash.events.ProgressEvent;
import flash.filesystem.File;
import flash.system.Capabilities;

import mx.core.FlexGlobals;

import spark.components.WindowedApplication;

public class NativeProcessService extends ProcessServices
{
	
	public function NativeProcessService(cmds : Array)
	{
		super(cmds);

		init();
	}
	
	/**
	 * 
	 * 通信协议的处理
	 *  
	 * @param data
	 * 
	 */	
	override public function commandHandler() : void
	{
		
		switch(command.Cmd)
		//switch(uint(command.Content.Code))
		{
			case Command.ShutDown : 
			{
			
				shutDown();
				break;
			}
			case Command.ReStart : 
			{
				restart();
				break;
			}
		}
	}
	
	private function init() : void
	{
		var sys : String = Capabilities.os.toLowerCase();
		
		/**
		 * 
		 * 只支持    Window 操作系统
		 * 
		 * */
//		if(sys.indexOf("win") == -1) {
//			throw new Error("this PC is not Windows System");
//		}
		

		initProcess("c://windows//system32//cmd.exe");
		
		if(process && nativeProcessStartupInfo)
			process.start(nativeProcessStartupInfo);
	}
	
	/**
	 * 
	 *  立即重启计算机 
	 * 
	 */	
	private function restart() : void 
	{
		if(process)
		{
		   logger.info("Equipment Restart");
		   replyToServer("Equipment Restart",Command.ReStart);
		   process.standardInput.writeUTFBytes("shutdown /r /t 0" + "\n");
		}
	}
	
	
	/**
	 * 
	 *  关闭计算机 
	 * 
	 */	
	private function shutDown() : void
	{
		if(process)
		{
		   logger.info("Equipment has been closed");
		   replyToServer("Equipment has been closed",Command.ShutDown);
		   process.standardInput.writeUTFBytes("shutdown /s /t 0" + "\n");
		}
	}
	/**
	 * 
	 * 待机
	 * 
	 */	
	private function waiting() : void
	{
		if(process)
		{
		   process.standardInput.writeUTFBytes("rundll32.exe powrprof.dll SetSuspendState" + "\n");
		}
	}
	
	/**
	 * 
	 *  注销当前计算机用户 
	 * 
	 */	
	protected function logout():void
	{
		if(process)
		{
		   process.standardInput.writeUTFBytes("shutdown /l" + "\n");			
		}
	}
	

}
}
















