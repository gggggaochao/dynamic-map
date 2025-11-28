package com.struts.components
{
	import flash.display.DisplayObject;
	
	import mx.core.IVisualElement;
	
	import spark.components.Group;
	import spark.layouts.HorizontalLayout;
	import spark.layouts.VerticalLayout;
	import spark.layouts.supportClasses.LayoutBase;
	import com.struts.components.formClasses.FormItemGroup;
	
	public class FormGroup extends Group
	{
		public function FormGroup()
		{
			super();
			this.childrens = new Array();
		}
		
		
		private var _lay : String = "Vertical";

		[Inspectable(category="General", enumeration="Horizontal,Vertical", defaultValue="Vertical")]
		
		public function set lay(value:String):void
		{
			_lay = value;
		}
		
		private var _gap : int;

		public function set gap(value:int):void
		{
			_gap = value;
		}
		
		
		override protected function childrenCreated():void
		{
			super.childrenCreated();
			
			setLayout();
			
			addChildren();
		}
		
		private function setLayout() : void
		{
			if(_lay == "Horizontal")
			{
				var h : HorizontalLayout =  new HorizontalLayout();
				h.gap = _gap;
				this.layout = h;
			}
			else
			{
				var v : VerticalLayout =  new VerticalLayout();
				v.gap = _gap;
				this.layout = v;				
			}		
		}
		
		public var childrens : Array;

		private var itemsGroup : Array = new Array();
		
		private function addChildren() : void
		{
			var childrenLength : int = this.numElements;
			
			for (var i : int = 0;i<numElements;i++)
			{
				var child : IVisualElement = this.getElementAt(i);
				if(child is FormItemGroup || child is FormGroup)
					childrens.push(child);
			}
			
			rollFormItemGrouop(this,itemsGroup);
			
		}
		
	
		private function rollFormItemGrouop(child : IVisualElement,list : Array) : void
		{
			if(child is FormGroup)
			{
				var childrens : Array = FormGroup(child).childrens;
				
				for each(var item : IVisualElement in childrens)
					rollFormItemGrouop(item,list);
			}
			
			if(child is FormItemGroup)
			{
				list.push(child);
			}

		}
		
		public function createData() : Object
		{

			var date : Object = new Object();
			for each(var item : FormItemGroup in itemsGroup)
			{
				var dateField : String = item.dateField;
				var value : * = item.getValue();
				
				date[dateField] = fromatValue(value,item.valueField);
			}
			return date;
		}
		
		private function fromatValue(value : *,valueField : String = null) : *
		{

			if(value is Number)
			{
				return value;
			}
			else if(value is String)
			{
				return value;
			}
			else if(value is uint)
			{
				return value;
			}
			else if(value is Boolean)
			{
				return value ? 1 : 0;
			}
			else
			{
				if(!value)
					return null;
				
				if(valueField)
				{
					return value[valueField];
				}
			}
		}
		
		
	}
}































