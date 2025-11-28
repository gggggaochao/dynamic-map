package com.struts.components.pageClasses
{
	[Bindable]
	public class PageGroupItem
	{
		public function PageGroupItem(data:Object = null, index:int = 0)
		{
			this.data = data;
			this.index = index;
			if(data is String)
				label = data as String;
		}
		public var data:Object;
		public var index:int;
		public var label:String;
	}
}