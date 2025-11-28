package com.struts.events
{
	import flash.events.Event;
	
	/**
	 * 分页分页事件
	 * @author Marco
	 */	
	public class PageEvent extends Event
	{
		
		/**
		 * 上一页
		 */		
		public static const PRE_PAGE:String = "prePage";
		
		/**
		 * 下一页
		 */		
		public static const NEXT_PAGE:String = "nextPage";
		
		/**
		 * 页码改变
		 */		
		public static const CHANGE_PAGE:String = "changePage";
		
		/**
		 * 页面初始化
		 */		
		public static const PAGE_INITED:String = "pageInited";
		
		public function PageEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		/**
		 * 当前面
		 */		
		public var currentPage:int;
		
		/**
		 * 总页数
		 */		
		public var totalPage:int;
		
	}
}