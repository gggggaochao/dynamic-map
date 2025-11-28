package com.struts.components
{
import com.struts.events.VideoPalyEvent;

import flash.display.MovieClip;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.NetStatusEvent;
import flash.geom.Rectangle;
import flash.media.SoundTransform;
import flash.media.Video;
import flash.net.NetConnection;
import flash.net.NetStream;

import mx.core.UIComponent;
import mx.events.FlexEvent;
import mx.managers.HistoryManager;

[Event(name="playOver", type="com.struts.events.VideoPalyEvent")]

[Event(name="playStart", type="com.struts.events.VideoPalyEvent")]

[Event(name="playStop", type="com.struts.events.VideoPalyEvent")]

public class VideoPlay extends UIComponent
{
	
	private var _video : Video;
	
	private var _videoCon : NetConnection;
	
	private var _videoStream : NetStream;
	
	private var _soundTransform : SoundTransform;
	//private var _playMode : String;
	
	private var _isLoop : Boolean = false;

	public function get isLoop():Boolean
	{
		return _isLoop;
	}

	public function set isLoop(value:Boolean):void
	{
		_isLoop = value;
	}

	private var _source : String;
	
	private var _sourceChange : Boolean = false;

	public function set source(value : String):void
	{
		_source = value;
		
		_sourceChange = true;
		invalidateProperties();
	}

	protected override function commitProperties(): void
	{
		super.commitProperties();
		
		if(_sourceChange)
		{
			_sourceChange = false;
			
			updatePlayBySource(_source);
		}
	}
	
	public function setSize(width : Number,height : Number) : void
	{
		if(_video)
		{
			_video.width = width;
			_video.height = height;
		}		
	}

	public function VideoPlay()
	{
		super();
	}
	
	override protected function createChildren():void
	{
		super.createChildren();

		
		_soundTransform = new SoundTransform();
		_soundTransform.volume = 0;
		
		_video = new Video();
		addChild(_video);		
		
	}
	
	
	
	private function updatePlayBySource(url:String):void
	{
		if(!url)
			return;
		
		clear();

		
		_videoCon = new NetConnection();
		_videoCon.connect(null);
		
		_videoStream = new NetStream(_videoCon);
		_videoStream.play(url);
		_videoStream.client = new Object();
		_videoStream.soundTransform = _soundTransform;
		_videoStream.addEventListener(NetStatusEvent.NET_STATUS, doNetStatus);
		_videoStream.addEventListener(IOErrorEvent.IO_ERROR, doIoError);
		
		_video.attachNetStream(_videoStream);
		
		if(hasEventListener(VideoPalyEvent.PALY_START))
			dispatchEvent(new VideoPalyEvent(VideoPalyEvent.PALY_START,_source));
	}
	
	public function stop() : void
	{
		if(_videoStream)
		{
			_videoStream.pause();
		}
	}
	
	public function restart() : void
	{
		if(_videoStream)
		{
			_videoStream.seek(0);
			_videoStream.play(_source);
		}		
	}
	
	public function sound(value : Number) : void
	{
		if(_videoStream && (value >= 0 && value <=1))
		{
			_soundTransform.volume = value;
			_videoStream.soundTransform = _soundTransform;
		}
	}
	
	public function resume() : void
	{
		if(_videoStream)
		{
			_videoStream.resume();
		}		
	}
	
	public function clear() : void
	{
		if(_videoStream)
		{
			_videoStream.removeEventListener(NetStatusEvent.NET_STATUS, doNetStatus);
			_videoStream.removeEventListener(IOErrorEvent.IO_ERROR, doIoError);
			_videoStream.close();
			_videoStream=null;
		}
		_video.attachNetStream(null);
	}
	
	private function doNetStatus(e:NetStatusEvent):void
	{
		switch (e.info.code) 
		{
			case "NetStream.Play.Stop":
			{
				
				if(_isLoop)
				{
					restart();
				}
				
				if(hasEventListener(VideoPalyEvent.PALY_STOP))
					dispatchEvent(new VideoPalyEvent(VideoPalyEvent.PALY_STOP,_source));
				
				break;
			}
			default:
				break;
		}
	}
	private function doIoError(e:IOErrorEvent):void 
	{
		trace(e.toString());
	}
}
}














