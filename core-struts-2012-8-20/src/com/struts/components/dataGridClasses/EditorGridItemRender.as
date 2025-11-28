package com.struts.components.dataGridClasses
{

import com.struts.utils.ArrayUtil;
import com.struts.utils.ComponentsUtil;

import flash.events.Event;

import mx.binding.utils.ChangeWatcher;
import mx.collections.ArrayCollection;
import mx.collections.IList;
import mx.collections.XMLListCollection;
import mx.controls.DateField;
import mx.core.IVisualElement;
import mx.core.UIComponent;
import mx.events.FlexEvent;

import spark.components.DropDownList;
import spark.components.NumericStepper;
import spark.components.TextInput;
import spark.components.gridClasses.GridItemEditor;
import spark.components.supportClasses.ListBase;

public class EditorGridItemRender extends GridItemEditor
{
	
	private var newData : Object;
	
	private var changeWatcher :ChangeWatcher;
	
	private var sign:Boolean = false;
	
	private var editorComponent : UIComponent;
	
	private var componentConfig : Object;
	
	public function EditorGridItemRender()
	{
		super();
	}
	
	public override function set data(value:Object):void
	{
		super.data = value;
		
		if(column is EditorGridColumn)
		{
			newData = value;
			
			componentConfig =  ComponentsUtil.getComponetConfig(EditorGridColumn(column).editComponent);

			editorComponent = ComponentsUtil.createByConfig(componentConfig);
			editorComponent.percentHeight = 100;
			editorComponent.percentWidth = 100;
			addElement(editorComponent);			
			
			
			changeWatcher = ChangeWatcher.watch(editorComponent,componentConfig.valueField,txtChange);
			if(editorComponent is ListBase)
			{
				var dataProvider : IList;
				
				var source : Object = EditorGridColumn(column).source;
				
				if(source is Array)
				{
					dataProvider = new ArrayCollection(source as Array);
				}
				else if(source is ArrayCollection)
				{
					dataProvider = source as ArrayCollection;
				}
				else if(source is XMLListCollection)
				{
					dataProvider = source as XMLListCollection;
				}
				else if(source is XMLList)
				{
					dataProvider = new XMLListCollection(source as XMLList);
				}
			
				var valueColumn : * = newData[column.dataField];
				
				ListBase(editorComponent).selectedIndex = ArrayUtil.selected(source,EditorGridColumn(column).valueField,valueColumn);
				ListBase(editorComponent).labelField = EditorGridColumn(column).labelField;
				ListBase(editorComponent).dataProvider = dataProvider;
				ListBase(editorComponent).requireSelection = true;
				
				editorComponent.addEventListener(FlexEvent.CHANGE_END,valueChangeHandler);
			}
			else
			{
				if(editorComponent is NumericStepper) 
				{
					NumericStepper(editorComponent).maximum = 99999999999;
					editorComponent.addEventListener(Event.CHANGE,valueChangeHandler);
				} 
				else if(editorComponent is DateField)
				{
					DateField(editorComponent).formatString = "YYYY-MM-DD";
				}
				
				//column.labelFunction
				editorComponent[componentConfig.valueField] = newData[column.dataField];
				editorComponent.addEventListener(FlexEvent.VALUE_COMMIT,valueChangeHandler);
			}
			

			var _editorPropertiesFunction : Function = EditorGridColumn(column).editorPripertiesFunction;
			
			if(_editorPropertiesFunction != null)
			   _editorPropertiesFunction(data,editorComponent);
			
			editorComponent.setFocus();
		}
	}
	
	public function set text(value : Object) : void
	{
		newData[column.dataField] = value;
		sign = true;
	}
	
	public function get text() : Object
	{
		return newData[column.dataField];
	}
	
	private function valueChangeHandler(event:Event):void
	{
		if(sign == false) return;//如果标记false则跳出
		newData[column.dataField] = this.value = getValue();
	}
	
	private function txtChange(e:Event):void
	{	
		
		this.text = this.value = getValue();
	}
	
	private function getValue() : Object
	{

		if(editorComponent is ListBase)
		{	
			var selectItem : * = ListBase(editorComponent).selectedItem;
			return selectItem ? selectItem[EditorGridColumn(column).valueField] : "";
		}
		else
		{
			return editorComponent[componentConfig.valueField];
		}
		return "";
	}
	
}


}





