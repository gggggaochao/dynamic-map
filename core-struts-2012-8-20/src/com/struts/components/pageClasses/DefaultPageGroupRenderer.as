package com.struts.components.pageClasses
{
	import flash.text.TextField;
	
	import mx.controls.listClasses.IListItemRenderer;
	import mx.core.IDataRenderer;
	import mx.core.IUITextField;
	import mx.core.UIComponent;
	import mx.core.UITextField;
	
	import spark.components.Label;
	import spark.components.supportClasses.ItemRenderer;
	
	public class DefaultPageGroupRenderer extends ItemRenderer implements IListItemRenderer
	{
		public function DefaultPageGroupRenderer()
		{
			super();
		}
		
		override protected function createChildren():void
		{
			super.createChildren();
			labelDisplay = new Label();
			addElement(labelDisplay);
		}
		
		private var _dataDirty:Boolean;
		
		override public function set data(value:Object):void
		{
			super.data = value;
			_dataDirty = true;
			invalidateProperties();
		}
		
		override protected function commitProperties():void
		{
			super.commitProperties();
			if(_dataDirty)
			{
				_dataDirty = false;
				labelDisplay.text = PageGroupItem(data).label;
			}
		}
	}
}