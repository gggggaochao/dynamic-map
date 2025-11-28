package com.struts.layout
{
	import mx.core.ILayoutElement;
	
	import spark.components.supportClasses.GroupBase;
	import spark.layouts.supportClasses.LayoutBase;
	
	public class TriangleLayout extends LayoutBase
	{
		public function TriangleLayout()
		{
			super();
		}
		
		private var _offsetY : int = 0;
		
		public function get offsetY():int
		{
			return _offsetY;
		}
		
		public function set offsetY(value:int):void
		{
			_offsetY = value;
		}
		
		private var _isStand : Boolean;

		public function get isStand():Boolean
		{
			return _isStand;
		}

		public function set isStand(value:Boolean):void
		{
			_isStand = value;
		}

		
		override public function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{	
			super.updateDisplayList(unscaledWidth,unscaledHeight);

			var layoutTarget : GroupBase = target;
			if(!layoutTarget)
				return;
			
			var count:int = layoutTarget.numElements;
			
			if(count != 3)
				return;
			
			
			
			var layoutElement1 : ILayoutElement = layoutTarget.getElementAt(0);
			var layoutElementWidth1 : Number =  layoutElement1.getLayoutBoundsWidth() || layoutElement1.getMinBoundsWidth();
			var layoutElementHeight1 : Number = layoutElement1.getLayoutBoundsHeight() || layoutElement1.getMinBoundsHeight();
			
			var layoutElement2 : ILayoutElement = layoutTarget.getElementAt(1);
			var layoutElementWidth2 : Number =  layoutElement2.getLayoutBoundsWidth() || layoutElement2.getMinBoundsWidth();
			//var layoutElementHeight2 : Number = layoutElement2.getLayoutBoundsHeight() || layoutElement2.getMinBoundsHeight();
			
			var layoutElement3 : ILayoutElement = layoutTarget.getElementAt(2);
			var layoutElementWidth3 : Number =  layoutElement3.getLayoutBoundsWidth() || layoutElement3.getMinBoundsWidth();
			//var layoutElementHeight3 : Number = layoutElement3.getLayoutBoundsHeight() || layoutElement3.getMinBoundsHeight();
			
			
			var _x : Number = 0;
			var _y : Number = _offsetY;
			if(_isStand)
			{
				_x = (unscaledWidth - layoutElementWidth1) / 2;
				layoutElement1.setLayoutBoundsPosition(_x,_y);
				
				_x = 0;
				_y = layoutElementHeight1 + _offsetY;
				layoutElement2.setLayoutBoundsPosition(_x,_y);
				layoutElement3.setLayoutBoundsPosition(_x + layoutElementWidth2,_y);
			}
			else
			{
				layoutElement1.setLayoutBoundsPosition(_x,_y);
				layoutElement2.setLayoutBoundsPosition(_x + layoutElementWidth1,_y);
				
				_x = (unscaledWidth - layoutElementWidth3) / 2;
				_y = layoutElementHeight1 + _offsetY;
				layoutElement3.setLayoutBoundsPosition(_x,_y);
			}
		}
	}

}