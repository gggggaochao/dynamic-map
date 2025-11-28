package com.struts.utils
{
	import flash.display.DisplayObject;
	
	import mx.filters.IBitmapFilter;
	
	import spark.filters.BevelFilter;
	import spark.filters.ConvolutionFilter;
	import spark.filters.DropShadowFilter;
	import spark.filters.GlowFilter;
	import spark.filters.GradientGlowFilter;

	
	public class FiltersUtil
	{
		//获取BevelFilter滤镜
		public static  function getBevelFilter  (target:DisplayObject  = null,
		                                         distance:Number       = 6,
												 angleInDegrees:Number = 45,
												 highlightColor:Number = 0xFFFFFF,
												 highlightAlpha:Number = 0.6,
												 shadowColor:Number    = 0x000000,
												 shadowAlpha:Number    = 0,
												 blurX:Number          = 5,
												 blurY:Number          = 5,
												 strength:Number       = 0.8,
												 quality:Number        = 1,
												 type:String           = "inner",
												 knockout:Boolean      = false): IBitmapFilter
		{
			var filter:IBitmapFilter = new BevelFilter(distance,
												angleInDegrees,
												highlightColor,
												highlightAlpha,
												shadowColor,
												shadowAlpha,
												blurX,
												blurY,
												strength,
												quality,
												type,
												knockout);
			if(target)
			{
				setFilters(target,filter);								
			}
			return filter;
		}

		//获取DropShadow滤镜
		public static function getDropShadowFilter(  target:DisplayObject = null,
													 distance:Number = 5, 
													 angle:Number = 45, 
													 color:uint = 0,
													 alpha:Number = 0.9, 
													 blurX:Number = 5, 
													 blurY:Number = 5, 
													 strength:Number = 0.9, 
													 quality:int = 1, 
													 inner:Boolean = false, 
													 knockout:Boolean = false, 
													 hideObject:Boolean = false): IBitmapFilter
		{
			var filter:IBitmapFilter = new DropShadowFilter(distance, 
															angle, 
															color, 
															alpha, 
															blurX, 
															blurY, 
															strength, 
															quality, 
															inner, 
															knockout, 
															hideObject);
			if(target)
			{
				setFilters(target,filter);	
			}		
			return filter;
		}
		
		//获取GlowFilter滤镜
		public static function getGlowFilter(target:DisplayObject = null,
											 color:Number = 0x33CCFF, 
											 alpha:Number = 0.8, 
											 blurX:Number = 35, 
											 blurY:Number = 35, 
											 strength:Number = 2, 
											 inner:Boolean = false, 
											 knockout:Boolean = false, 
											 quality:int = 3 ): IBitmapFilter 
		{
			var filter:IBitmapFilter = new GlowFilter(color, 
													  alpha, 
													  blurX, 
													  blurY, 
													  strength, 
													  quality, 
													  inner, 
													  knockout);
			if(target)
			{
				setFilters(target,filter);
			}	
			
			return filter;
		}
		
		private static function setFilters(target:DisplayObject,filter:IBitmapFilter) : void
		{
				var filters : Array = target.filters;
				if(!filters) filters = [];
				filters.push(filter);
				
				target.filters = filters;			
		}
		
	}
	
}


















