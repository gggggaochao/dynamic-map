package com.struts.components.dataGridClasses
{
	
	import mx.core.ClassFactory;
	
	import spark.components.gridClasses.GridColumn;
	
	public class EditorGridColumn extends GridColumn
	{
		public function EditorGridColumn(columnName:String=null)
		{
			super(columnName);
			this.editable = true;
			this.itemEditor = new ClassFactory(EditorGridItemRender);
			
		}

		private var _editComponent : String = "TextInput";

		[Inspectable(category="General", enumeration="TextInput,DateField,ComboBox,NumericStepper", defaultValue="TextInput")]
		
		public function set editComponent(value:String):void
		{
			_editComponent = value;
		}
		
		public function get editComponent():String
		{
			return _editComponent;
		}
		
		
	
		private var _source : Object;

		public function get source():Object
		{
			return _source;
		}

		/**
		 * 下拉菜单的数据源 
		 */	
		public function set source(value:Object):void
		{
			_source = value;
		}
		
		
	
		private var _labelField : String;

		public function get labelField():String
		{
			return _labelField;
		}

		/**
		 *  下拉列表的显示字段 
		 */	
		public function set labelField(value:String):void
		{
			_labelField = value;
		}


		private var _valueField : String;

		public function get valueField():String
		{
			return _valueField;
		}

		/**
		 *  下拉控件的取值字段 
		 */		
		public function set valueField(value:String):void
		{
			_valueField = value;
		}
		
		/**
		 *  设置控件属性的回调函数 
		 */		
		private var _editorPripertiesFunction : Function;

		public function get editorPripertiesFunction():Function
		{
			return _editorPripertiesFunction;
		}

		public function set editorPripertiesFunction(value:Function):void
		{
			_editorPripertiesFunction = value;
		}

		
	}
}



















