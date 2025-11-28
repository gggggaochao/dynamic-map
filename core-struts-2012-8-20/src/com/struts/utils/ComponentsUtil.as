package com.struts.utils
{	
	import flash.events.Event;
	import flash.utils.getDefinitionByName;
	
	import mx.collections.ArrayCollection;
	import mx.collections.ICollectionView;
	import mx.collections.IViewCursor;
	import mx.controls.ColorPicker;
	import mx.controls.DateField;
	import mx.controls.listClasses.ListBase;
	import mx.core.ClassFactory;
	import mx.core.FlexGlobals;
	import mx.core.IVisualElementContainer;
	import mx.core.UIComponent;
	import mx.messaging.AbstractProducer;
	import mx.states.SetProperty;
	import mx.states.State;
	
	import spark.components.*;
	
	//import spark.components.*;

	public class ComponentsUtil
	{	
		private static const FLEX_COMPONENTS : Array = 
		[
			
			{classRef : spark.components.DropDownList,valueField : "selectedItem",xtype : "DropDownList",event : "change"},
			{classRef : spark.components.CheckBox,valueField : "selected",xtype : "CheckBox",event : "click"},
			{classRef : spark.components.ComboBox,valueField : "selectedItem",xtype : "ComboBox",event : "change"},
			{classRef : spark.components.TextInput,valueField : "text",xtype : "TextInput",event : "keyUp"},
			{classRef : spark.components.TextArea,valueField : "text",xtype : "TextArea",event : "keyUp"},
			//{classRef : spark.components.VSlider,valueField : "value",xtype : "VSlider",event : "change"},
			//{classRef : spark.components.HSlider,valueField : "value",xtype : "HSlider",event : "change"},
			//{className : spark.components.RadioButton,valueField : "selected",xtype : "RadioButton",event : "click"},
			{classRef : spark.components.NumericStepper,valueField : "value",xtype : "NumericStepper",event : "change"},

			//{className : "mx.controls.CheckBox",valueField : "selected",xtype : "CheckBox3",event : "click"},
			//{className : "mx.controls.ComboBox",valueField : "selectedItem",xtype : "ComboBox3",event : "change"},
			//{className : "mx.controls.TextInput",valueField : "text",xtype : "TextInput3",event : "keyUp"},
			//{className : "mx.controls.TextArea",valueField : "text",xtype : "TextArea3",event : "keyUp"},
			{classRef : mx.controls.VSlider,valueField : "value",xtype : "VSlider",event : "change"},
			{classRef : mx.controls.HSlider,valueField : "value",xtype : "HSlider",event : "change"},
			{classRef : mx.controls.RadioButton,valueField : "selected",xtype : "RadioButton",event : "click"},
			//{className : "mx.controls.NumericStepper",valueField : "value",xtype : "NumericStepper",event : "change"},
			{classRef : mx.controls.ColorPicker,valueField : "selectedColor",xtype : "ColorPicker",event : "change"},
			{classRef : mx.controls.DateField,valueField : "text",xtype : "DateField",event : "change"}
		]
		
		public static const  LEVEL_APPLICATION : IVisualElementContainer = FlexGlobals.topLevelApplication as IVisualElementContainer;
		
		public static function addToApplication(ui : UIComponent) : void
		{
			LEVEL_APPLICATION.addElement(ui);
		}
		
		public static function removeFromApplication(ui : UIComponent) : void
		{
			LEVEL_APPLICATION.removeElement(ui);
		}
		
		public static function get width() : Number
		{
			return UIComponent(LEVEL_APPLICATION).width;
		}
		
		public static function get height() : Number
		{
			return UIComponent(LEVEL_APPLICATION).height;
		}	
		
		public static function setComponetToMiddle(ui : UIComponent) : void
		{
			var parentUI : UIComponent = UIComponent(ui.parent) || UIComponent(LEVEL_APPLICATION);
			
			var x : Number  = (parentUI.width - (ui.width || ui.minWidth) ) / 2;
			var y : Number  = (parentUI.height - (ui.height || ui.minHeight) ) / 2;	
			
			if(!ui.x)
			    ui.x = Number(x.toFixed(0));
			
			if(!ui.y)
				ui.y = Number(y.toFixed(0)); 					
		} 
		
		
		public static function create(name : String,
									   attribute : Object = null,
									   listener : Function = null,
									   style : Object = null,
									   states : Array = null) : UIComponent
		{

			var uiConfig : Object =  getComponetConfig(name);
			
			return createByConfig(uiConfig,createByConfig,listener,style,states);
		}
		
		public static function createByConfig(uiConfig : Object,
											  attribute : Object = null,
											  listener : Function = null,
											  style : Object = null,
											  states : Array = null) : UIComponent
		{
			if(uiConfig)
			{
				var valueField : String = uiConfig.valueField;
				var eventName : String = uiConfig.event;
				var c : Class = uiConfig.classRef;
				//var c : Class = getDefinitionByName(className) as Class;
				//var uiObject : Object = new c();
				var ui : UIComponent = new c();
				
				if(ui)
				{
					var newValue : *;
					var property : String;
					if(style)
					{
						for (property in style)
						{
							newValue = style[property];
							ui.setStyle(property,newValue);
						}				
					}
					
					if(attribute)
					{ 
						for (property in attribute)
						{
							newValue = attribute[property];
							setProperty(ui,property,newValue,states);
						}
					}
					
					if(listener != null)
					{
						function eventHandler(event : Event) : void
						{
							if(valueField)
							{
								var value : * = ui[valueField];
								listener(event,value);
							}
						}
						ui.addEventListener(eventName,eventHandler);						
					}
					
					return ui;
				}
				
				
			}
			
			return null;			
		}
		
		public static function getComponetConfig(ui : *) : Object
		{
			var uiConfig : Object; 
			var classRef : Class;
			var xtype : String;
			for (var i:int = 0;i<FLEX_COMPONENTS.length;i++)
			{
				uiConfig = FLEX_COMPONENTS[i];
				
				if(ui is String)
				{
					xtype = uiConfig.xtype;
					
					if(xtype.indexOf(String(ui)) != -1)
					{
						return uiConfig;
					}
				}
				else
				{
					classRef = uiConfig.classRef;
					
					if(ui is classRef)
					{
						return uiConfig;
					}
				}
			}
			
			return null;
		}
		
		
		private static function setStateProperty(target:Object,name : String,
												protype : String,value : *,
												states : Array = null) : void
		{
			
			function makeSetProp(target:Object, name:String, value:*) : SetProperty
			{
				var sp:SetProperty = new SetProperty();
				sp.target = target;
				sp.name = name;
				sp.value = value;
				return sp;
			}		
			
			if(states)
			{
				for each(var s : State in states)
				{
					if(s.name == name)
					{
						var overrides : Array = s.overrides;
						var propertype : SetProperty = makeSetProp(target,protype,value);
						
						overrides.push(propertype);
						break;
					}
				}
			}		
		
		}
	
		public static function setProperty(target : Object,property : String,value : *,states : Array = null) : void
		{
			var index : int = -1;
			if ((index = property.indexOf(".")) > 0)
			{
				var protype : String = property.substring(0, index);
				var stateName : String = property.substring(index + 1);
				
				
				setStateProperty(target,stateName,protype,value,states);
			}
			else
			{
				if(target[property] is Number)
				{
					target[property] = Number(value);
				}
				else if(target[property] is String)
				{
					target[property] = String(value);
				}
				else if(target[property] is uint)
				{
					target[property] = uint(value);
				}
				else if(target[property] is Boolean)
				{
					var _value : Number = 0;
					if(value is Number)
					{
						_value = Number(value)
					}
					else if(value is String)
					{
						_value = String(value) == "true" ||
							String(value) == "yes" ||
						String(value) == "1" ? 1 : 0;
						
					}
					else if(value is Boolean)
					{
						_value = Boolean(value) ? 1 : 0;
					}
					
					target[property] = Boolean(_value);
				}
				else
				{
					target[property] = Object(value);
				}
			}
		}
//		
//		public static function fromatToProperty(value : *) : DataProperty
//		{
//			var property : DataProperty = new DataProperty();
//			
//			if(value is XML)
//			{
//				var data : XML = value as XML;
//				property.field = data.@field;
//				property.label = data.@label;
//				property.dataField = data.@dataField;
//				
//				var uiList : XMLList = data.ui as XMLList;
//				if(uiList.length())
//				{
//					var ui : XML = uiList[0] as XML;
//					
//					property.className = ui.@className;
//					property.key = ui.@key;
//					property.attribute = XMLUtil.toAttribute(ui.attribute);
//					property.style = XMLUtil.toAttribute(ui.style);
//					
//					var uiDataSourceXMLList : XMLList = ui.dataSource;
//					if(uiDataSourceXMLList.length())
//					{
//						var dataSourceXML : XML = uiDataSourceXMLList[0] as XML;
//						var dataSource : DataSource = new DataSource(dataSourceXML);
//						property.dataSource = dataSource;
//					}
//				}
//			}
//			else
//			{
//				property.field = value.field;
//				property.label = value.label;
//				property.dataField = data.dataField;
//				
//				if(value.items)
//				{
//					var uiData : Object = value.items;
//					if(uiData.ui is UIComponent)
//					{
//						property.ui = uiData.ui as UIComponent;
//						property.valueField = uiData.valueField;
//					}
//					else
//					{
//						property.className = uiData.className;
//					}
//					
//					property.attribute = uiData.attribute;
//					property.style = uiData.style;
//				}
//			}
//			
//			return property;
//		
//		}
//		
//		public static function fromatToUI(data : XML) : Object
//		{
//			var uiData : Object = new Object();
//			uiData.attribute = XMLUtil.toAttribute(data.attribute);
//			uiData.style = XMLUtil.toAttribute(data.style);
//			
//			var uiDataSourceXMLList : XMLList = data.dataSource;
//			if(uiDataSourceXMLList.length())
//			{
//				var dataSourceXML : XML = uiDataSourceXMLList[0] as XML;
//				var dataSource : DataSource = new DataSource(dataSourceXML);
//				uiData.dataSource = dataSource;
//			}
//			
//			return uiData;
//		}
//		
//		public static function selected(dataProvider : Object,value:Object,field:String) : int
//		{
//			var _rootModel:ICollectionView;
//			if(dataProvider)
//			{
//				if(dataProvider is ICollectionView)
//				{
//					_rootModel = ICollectionView(dataProvider);
//				}
//				else if(dataProvider is Array)
//				{
//					_rootModel = new ArrayCollection(dataProvider as Array);
//				}
//			}
//			if(_rootModel)
//			{
//				var cursor:IViewCursor = _rootModel.createCursor();
//				var selectindex : int = 0;
//				var isSame : Boolean = false;
//				while (!cursor.afterLast)
//				{
//					var item:Object = cursor.current;
//					if(String(item[field]) == String(value))
//					{
//						return selectindex;
//					}
//					selectindex++;
//					cursor.moveNext();
//				}
//			}
//			
//			return -1;
//		}
//		
		public static function cearteElement(data : Object,listener : Function = null,states : Array = null) : *
		{
			
//			if(data == null)
//				return;
//			
//			var className : String = data.className;
//			var valueField : String = null;
//			var eveType : String = "change";
//			var ui: UIComponent = data.ui as UIComponent;
//
//			if(ui == null && className)
//			{
//				
//				
//				var uiName : String = className.toLocaleLowerCase();
//				switch(uiName)
//				{
//					case "colorpicker" : 
//					{
//						ui = new ColorPicker();
//						valueField = "selectedColor";
//						
//						break;
//					}
//					case "numericstepper" : 
//					{
//						ui = new NumericStepper();
//						valueField = "value";
//						break;
//					}
//					case "datefield" : 
//					{
//						ui = new DateField();
//						valueField = "text";
//						break;
//					}
//					case "combobox" : 
//					{
//						ui = new ComboBox();
//						valueField = "selectedItem";
//						break;
//					}
//					case "textinput" : 
//					{
//						ui = new TextInput();
//						valueField = "text";
//						eveType="keyUp";
//						break;
//					}
//					case "textarea" : 
//					{
//						ui = new TextArea();
//						valueField = "text";
//						eveType="keyUp";
//						break;
//					}
//					case "hslider" : 
//					{
//						ui = new HSlider();
//						valueField = "value";
//						break;
//					}
//					case "vslider" : 
//					{
//						ui = new VSlider();
//						valueField = "value";
//						break;
//					}
//					case "checkbox" : 
//					{
//						ui = new CheckBox();
//						valueField = "selected";
//						break;
//					}
//					case "radiobutton" : 
//					{
//						ui = new RadioButton();
//						valueField = "selected";
//						break;
//					}
//					case "fontfield" : 
//					{
//						ui = new FontField();
//						valueField = "values";
//						break;
//					}
//					case "image" : 
//					{
//						ui = new Image();
//						valueField = "source";
//						break;
//					}
//					default :
//					{
//						var uiClass : Class = getDefinitionByName(className) as Class;
//						var uiObject : Object = new uiClass() as Object;
//						ui = uiObject as UIComponent;
//					}
//				}
//			}
//			
//			
//
//			if(ui == null)
//				return;
//						
//			var attribute : Object = data.attribute;
//			if(attribute)
//			{
//				var property : String; 
//				var newValue : *;
//				for (property in attribute)
//				{
//					newValue = attribute[property];
//					setProperty(ui,property,newValue,states);
//				}
//			}
//			
//			var style : Object = data.style;
//			if(style)
//			{
//				for (property in style)
//				{
//					newValue = attribute[property];
//					ui.setStyle(property,newValue);
//				}				
//			}
//			
//			
//			if(listener != null)
//			{
//				function eventHandler(event : Event) : void
//				{
//					if(valueField)
//					{
//						var value : * = ui[valueField];
//						listener(event,value);
//					}
//				}
//				
//				ui.addEventListener(eveType,eventHandler);
//			
//			}
////			var events : Array = data.events as Array;
////			
////			function eventHandler(event : Event) : void
////			{
////				if(valueField)
////				{
////					var value : * = ui[valueField];
////					if(listener != null)
////					{
////						listener(event,value);
////					}
////				}
////			}
////			
////			if(events && events.length)
////			{
////				for each(var event : Object in events)
////				{
////					eveType = event.type;
////					if(eveType)
////					{
////						ui.addEventListener(eveType,eventHandler);
////					}
////				}
////			}
////			else
////			{
////				ui.addEventListener(eveType,eventHandler);
////			}
//			
////			if(ui is ListBase)
////			{
////				var dataProvider : Object = data.dataProvider;
////				ListBase(ui).dataProvider = dataProvider;
////			}			
			return null;
			//return {ui : ui,valueField : valueField};

		}
	}
}






























