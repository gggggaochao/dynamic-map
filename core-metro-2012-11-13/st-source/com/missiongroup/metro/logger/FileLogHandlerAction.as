package com.missiongroup.metro.logger
{
import com.logging.LoggerHandlerAction;
import com.struts.utils.DateUtil;

import flash.filesystem.File;
import flash.filesystem.FileMode;
import flash.filesystem.FileStream;
import flash.system.Capabilities;

public class FileLogHandlerAction extends LoggerHandlerAction
{
	private var fileStream : FileStream;
	
	private var rootLogger : String;
	
	public function FileLogHandlerAction()
	{
		super();
		
		var sys : String = Capabilities.os.toLowerCase();
		if(sys.indexOf("win") != -1) {
			rootLogger = File.applicationDirectory.nativePath + "\\" + "logs";
		}
		else {
			rootLogger = File.applicationStorageDirectory.nativePath+ "\\" + "logs";
		}
	}
	
	
	override public function initLogging():void
	{
		fileStream = new FileStream();
		
		var logFile : File = new File(rootLogger);
		if(!logFile.exists)
		{
			logFile.createDirectory();
		}
	}
	
	
	private var currDate : String;
	
	override public function handler(coutent : String) : void
	{
		super.handler(coutent);
		
		var fileName : String;		
	
		var nowDate : String = DateUtil.dateToString(new Date(),"yyyy.MM.dd");

		var appLogFile : File = new File(rootLogger + "\\app.log");
		var fileMode : String = FileMode.APPEND;
		
		if(!currDate)
			currDate = nowDate;
		
		if(nowDate != currDate)
		{
			if(appLogFile.exists)
			{
				var copyFile : File = new File(rootLogger + "\\app." + currDate + ".log");
				appLogFile.copyTo(copyFile,true);
				fileMode = FileMode.WRITE;
				currDate = nowDate;
			}
		}

		fileStream.open(appLogFile,fileMode);
		fileStream.writeUTFBytes(coutent + "\r\n");
		fileStream.close();
	}
}
}