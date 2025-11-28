package com.missiongroup.metro.servers
{
import flash.display.BitmapData;
import flash.display.IBitmapDrawable;
import flash.geom.Matrix;
import flash.geom.Rectangle;
import flash.utils.ByteArray;

import mx.core.FlexGlobals;
import mx.core.UIComponent;
import mx.graphics.ImageSnapshot;
import mx.utils.Base64Encoder;


/**
 * 
 * 	截图服务
 * 
 * */
public class ScreenshotsService extends Services
{
	public function ScreenshotsService(cmds:Array)
	{
		super(cmds);
	}
	
	
	override public function commandHandler() : void
	{
		//var cutWidth : int = int(this.command.Content.width);
		//var cutHeight : int = int(this.command.Content.height);
		
		var cutWidth : int = 600;
		var cutHeight : int = 700;
		var sysApp : UIComponent = FlexGlobals.topLevelApplication as UIComponent;
		
		var appWidth : Number = sysApp.width;
		var appHeight: Number = sysApp.height;
		
		var sx : Number =  appWidth / cutWidth;
		var sy : Number = appHeight / cutHeight;
		var scale : Number = Math.min(sx,sy);
		var matrix : Matrix = new Matrix(scale,0,0,scale,0,0);
		
		var bitmapData : BitmapData;
		var sourceByteArray : ByteArray;
		
		bitmapData = ImageSnapshot.captureBitmapData(sysApp as IBitmapDrawable,matrix);
		sourceByteArray = bitmapData.getPixels(new Rectangle(0,0,cutWidth,cutWidth) ); 
		
		var base64Encoder : Base64Encoder = new Base64Encoder();
		base64Encoder.encodeBytes(sourceByteArray);
		
		var base64String : String = base64Encoder.toString();
		var replyContent : String = '<imageData>' + base64String + '</imageData>';
		
		this.replyToServer(replyContent,1);
		this.logger.info("Screenshots success");
	}
	
	
}
}