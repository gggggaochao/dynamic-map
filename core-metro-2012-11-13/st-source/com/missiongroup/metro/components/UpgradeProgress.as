package com.missiongroup.metro.components
{

import com.missiongroup.metro.skins.UpgradeProgressSkin;
import com.struts.utils.DateUtil;

import spark.components.Label;
import spark.components.supportClasses.SkinnableComponent;
import spark.primitives.Rect;


/**
 * 
 * 升级进度提示组件
 *  
 * @author ZhouHan
 * 
 */
public class UpgradeProgress extends SkinnableComponent
{
	
	[SkinPart(required="false")]
	public var progressBar : Rect;
	
	[SkinPart(required="false")]
	public var updateFileDisplay : Label;
	
	[SkinPart(required="false")]
	public var updateFileSizeDisplay : Label;
	
	[SkinPart(required="false")]
	public var progressDisplay : Label;
	
	[SkinPart(required="false")]
	public var zipFileDisplay : Label;
	
	public function UpgradeProgress()
	{
		super();
		percentWidth  = 100;
		percentHeight = 100;
		
		setStyle('skinClass',Class(com.missiongroup.metro.skins.UpgradeProgressSkin));
	}
	
	public function setProgress(val : Number,total : Number,updateFileName : String,updateFileSize : uint) : void
	{
		if(progressBar && progressDisplay && updateFileDisplay)
		{
			var pregressVal : Number = Math.ceil((val / total )* 100);
			updateFileDisplay.text = "更新文件：" +updateFileName;
			updateFileSizeDisplay.text = formatFileSize(updateFileSize);
			progressBar.percentWidth = pregressVal
			if(val && total)
				progressDisplay.text = pregressVal + "%";
		}
	}

	private var _upgradeFileChange : Boolean = false;
	
	private var _upgradeFileSize : uint = 0;

	public function set upgradeFileSize(value: uint):void
	{
		if(_upgradeFileSize == value)
			return;
		
		_upgradeFileSize = value;
		_upgradeFileChange = true;
		
		invalidateProperties();
	}

	
	private var _upgradeFileName : String;

	public function get upgradeFileName():String
	{
		return _upgradeFileName;
	}


	public function set upgradeFileName(value:String):void
	{
		
		if(_upgradeFileName == value)
			return;
		
		_upgradeFileName = value;
		_upgradeFileChange = true;
		
		invalidateProperties();
	}

	private function formatFileSize(size : uint) : String
	{
		var _size : Number = size / 1024;
		
		if(_size < 1024)
			return Math.ceil(_size) + "KB";
		_size = _size / 1024;
		if(_size < 1024)
			return _size.toFixed(2) + "MB";
		_size = _size / 1024;
		if(_size < 1024)
			return _size.toFixed(2) + "GB";		
		
		return null;
	}
	
	override protected function commitProperties():void
	{
		super.commitProperties();
		
		if(_upgradeFileChange)
		{
			_upgradeFileChange = false;
			
			var _upgradTime : String = DateUtil.dateToString(new Date(),"yyyy-MM-dd");
			zipFileDisplay.text = "客服端升级至" + _upgradTime + "版     升级包：" + _upgradeFileName + "(" +　formatFileSize(_upgradeFileSize) + ")";
		}
	}
	
	override protected function partAdded(partName:String, instance:Object):void
	{
		super.partAdded(partName, instance);
	}
	
	
}
}