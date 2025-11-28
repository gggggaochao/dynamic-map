package com.missiongroup.metro.servers
{
	import flash.desktop.NativeProcess;
	import flash.desktop.NativeProcessStartupInfo;
	import flash.filesystem.File;
	
	import mx.core.FlexGlobals;
	
	import spark.components.WindowedApplication;

public class ProcessServices extends Services
{
	
	public var process : NativeProcess;
	
	public var nativeProcessStartupInfo : NativeProcessStartupInfo;
	
	public function ProcessServices(cmds : Array)
	{
		super(cmds);
	}
	
	
	public function initProcess(path : String) : void
	{
		if(!NativeProcess.isSupported)
		{
			logger.info("NativeProcess is not supported");
			return;
		}
		
		var exeFile : File = new File(path);
		
		if(exeFile.exists)
		{
			nativeProcessStartupInfo = new NativeProcessStartupInfo();
			nativeProcessStartupInfo.executable = exeFile;
			
			process = new NativeProcess();
			
			logger.info("PC process is created");
		}
		
	}
	
	/**
	 * 
	 * 关闭当前应用程序
	 *  
	 * @return 
	 * 
	 */	
	public function closeWindowedApplication() : Boolean
	{
		var windowApp : WindowedApplication = FlexGlobals.topLevelApplication as WindowedApplication;
		if(windowApp)
		{
			windowApp.close();
			return true;
		}
		return false;
	}
	
}
}