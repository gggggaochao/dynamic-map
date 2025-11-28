package com.struts.components.menuTreeClasses
{
	
	import com.struts.utils.MarkUtil;
	
	import mx.containers.VBox;
	
	import spark.components.Image;
	import spark.components.Label;
	import spark.primitives.BitmapImage;
	
	public class MenuTreeItemRender extends VBox
	{
		public function MenuTreeItemRender()
		{
			super();
		}

		
		private var _labelField : String; 
		/**
		 *  公用属性
		 * 
		 * 
		 * */
		public function get labelField():String
		{
			return _labelField;
		}
		
		/**
		 * @private
		 */
		public function set labelField(value:String):void
		{
			_labelField = value;
		}
		
		private var _labelFunction : Function;
		
		public function get labelFunction():Function
		{
			return _labelFunction;
		}
		
		public function set labelFunction(value:Function):void
		{
			_labelFunction = value;
		}
		
		
		private var _iconField : String;
		
		public function get iconField():String
		{
			return _iconField;
		}
		
		public function set iconField(value:String):void
		{
			_iconField = value;
		}
		
		private var _iconFunction : Function;
		
		public function get iconFunction():Function
		{
			return _iconFunction;
		}
		
		public function set iconFunction(value:Function):void
		{
			_iconFunction = value;
		}
		
		
		private var title : String;
		
		private var iconURL : String;
		
	 	override public function set data(value : Object) : void
		{
			super.data = value;
			
			if(value)
			{
				title   = MarkUtil.itemToLabel(value,labelField,labelFunction);
				iconURL = MarkUtil.itemToLabel(value,iconField,iconFunction);
			}
		}

		protected override function createChildren():void
		{
			super.createChildren();
			
			setStyle("paddingLeft",18);
			setStyle("verticalAlign","middle");
			
			if(iconURL)
			{
				var bitmapImage : Image =  new Image();
				bitmapImage.source = iconURL;
				addElement(bitmapImage);
			}
			
			if(title)
			{
				var s : Label = new Label();
				s.percentWidth = 100;
				s.text = title;
				
				addElement(s);
			}
		}		
	}
}
















