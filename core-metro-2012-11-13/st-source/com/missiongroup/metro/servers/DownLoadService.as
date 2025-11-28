package com.missiongroup.metro.servers
{
	
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.net.URLRequest;
import flash.net.URLStream;
import flash.utils.IDataInput;

public class DownLoadService extends ProcessServices
{
	
	private var request : URLRequest;
	
	private var urlStream : URLStream;
	
	public function DownLoadService(cmds:Array)
	{
		super(cmds);
		
		urlStream = new URLStream();
		urlStream.addEventListener(Event.COMPLETE,downloadCompleteHandler);	
		urlStream.addEventListener(IOErrorEvent.IO_ERROR,ioErrorHandler);
	}
	
	public function downloadFile(url : String) : void
	{
		request = new URLRequest(url);
		urlStream.load(request);
	}

	private function ioErrorHandler(event : IOErrorEvent) : void
	{
		logger.error("download Fail" + event.toString());
		
		downloadError();
	}
	
	private function downloadCompleteHandler(event : Event) : void
	{
		var data : URLStream = URLStream(event.target);
		
		downloadHandler(data);
	}
	
	
	/**abstract*/ public function downloadError() : void
	{
		
	}
	
	
	/**abstract*/ public function downloadHandler(data : IDataInput) : void
	{

	}
	
}
}







