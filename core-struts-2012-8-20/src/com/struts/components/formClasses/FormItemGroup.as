package com.struts.components.formClasses
{
	import com.struts.utils.ComponentsUtil;
	
	import flash.display.DisplayObject;
	
	import mx.containers.HBox;
	import mx.core.IVisualElement;
	import mx.core.UIComponent;
	
	import spark.components.Group;
	import spark.components.HGroup;
	import spark.components.Label;
	import spark.layouts.HorizontalAlign;
	import spark.layouts.HorizontalLayout;
	import spark.layouts.VerticalAlign;
	
	
	/**
	 *
	 * 
	 *  
	 * @author ZhouHan
	 * 
	 */	
	public class FormItemGroup extends HBox
	{
		public function FormItemGroup()
		{
			super();		
			this.childrens = new Array();
		}
		
		private var lblGroup : HGroup;
		
		private var componentGroup : HGroup;
		
		
		/**
		 *
		 * 封装的对象属性
		 *  
		 */		
		private var _dateField : String;

		public function get dateField():String
		{
			return _dateField;
		}

		public function set dateField(value:String):void
		{
			_dateField = value;
		}

		
		private var _valueField : String;

		public function get valueField():String
		{
			return _valueField;
		}

		/**
		 *
		 * 取得对象的值属性
		 *  
		 * @param value
		 * 
		 */		
		public function set valueField(value:String):void
		{
			_valueField = value;
		}

		
		private var componetConfig : Object;
		
		private var componets : UIComponent;
		
//		private var _label : String;
//
//		public function get label():String
//		{
//			return _label;
//		}
//
//		public function set label(value:String):void
//		{
//			_label = value;
//		}
		
		public var lableWidth : int = 72;
		
		private var isAddChild : Boolean = false;
		
		override protected function childrenCreated():void
		{
			
			super.childrenCreated();
			
			var lbl : Label = new Label();
			lbl.text = label;
			
			lblGroup = new HGroup();
			lblGroup.percentHeight = 100;
			lblGroup.width = lableWidth;
			lblGroup.horizontalAlign = HorizontalAlign.RIGHT;
			lblGroup.verticalAlign = VerticalAlign.MIDDLE;
			lblGroup.clipAndEnableScrolling = true;
			lblGroup.addElement(lbl);
			this.addElementAt(lblGroup,0);

			componentGroup = new HGroup();
			componentGroup.percentHeight = 100;
			componentGroup.percentWidth = 100;
			componentGroup.verticalAlign = VerticalAlign.MIDDLE;
			this.addElementAt(componentGroup,1);


			if(childrens.length && componets == null)
			{
				componets = childrens[0] as UIComponent;
				componetConfig = ComponentsUtil.getComponetConfig(componets);
			}
			
			//getValue();
			
			addChildren();

			isAddChild = true;
		}
		
		private var childrens : Array;
		
		override public function addChild(child:DisplayObject):DisplayObject
		{
			childrens.push(child);
			return child; 
		}
		
		private function addChildren() : void
		{
			for each(var child : IVisualElement in childrens)
				componentGroup.addElement(child);
		}
		
		
		public function getValue() : *
		{
			if(componetConfig)
			{
				return componets[componetConfig.valueField];
			}
		}

	}
}
























