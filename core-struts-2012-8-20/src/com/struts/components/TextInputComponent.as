
////////////////////////////////////////////////////////////////////////////////
//
//  MissionGroup Copyright 2012 All Rights Reserved.
//
//  NOTICE: MIT MissionGroup permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////
package com.struts.components
{
	import spark.components.Label;
	import spark.components.RichEditableText;
	import spark.components.supportClasses.SkinnableComponent;
	import spark.core.IDisplayText;
	
	
	
	/**
	 *   背景图片
	 */
	[Style(name="backgroundImage", type="Object", inherit="no")]
	
	
	/**
	 * 具有背景的控件输入框 
	 *
	 * @author Han.Zhou
	 * @email zhouhan102@163.com || zhouhan@missiongroup.com.cn
	 * @date 2012-4-16 下午12:19:56 
	 *
	 */
	
	public class TextInputComponent extends SkinnableComponent
									implements IDisplayText
	{
		//-----------------------------------------------------------------
		//
		// Variables
		//
		//-----------------------------------------------------------------
		
		/**
		 * @private
		 */		
		private var _text:String;
		
		/**
		 * @private
		 */		
		private var _textDirty:Boolean;
		
		
		[SkinPart(required="true")]
		public var textDisplay:RichEditableText;
		
		public function TextInputComponent()
		{
			super();
		}
		
		public function set text(value:String):void
		{
			if(_text == value)
				return;
			
			_text = value;
			_textDirty = true;
			invalidateProperties();
		}
		public function get text():String
		{
			return textDisplay.text;;
		}
		
		
		private var _displayAsPassword : Boolean;

		public function get displayAsPassword():Boolean
		{
			return _displayAsPassword;
		}

		public function set displayAsPassword(value:Boolean):void
		{
			_displayAsPassword = value;
			
			if(textDisplay)
			   textDisplay.displayAsPassword = value;
		}

		protected override function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName, instance);
			
			if(instance == textDisplay)
			{
				textDisplay.displayAsPassword = _displayAsPassword;
			}
		
		}
		override protected function commitProperties():void
		{
			super.commitProperties();

			if(_textDirty)
			{
				_textDirty = false;
				textDisplay.text = _text;
			}
		}
		
		public function get isTruncated():Boolean
		{
			return textDisplay.isTruncated;
		}
		
	}
	
	
}





























