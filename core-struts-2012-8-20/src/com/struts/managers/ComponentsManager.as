package com.struts.managers
{
	import com.struts.WebSite;
	import com.struts.core.FrameBase;
	import com.struts.core.WebApp;
	import com.struts.entity.ConfigData;
	import com.struts.events.AppEvent;
	import com.struts.events.FrameEvent;
	import com.struts.interfaces.ILayout;
	import com.struts.interfaces.IModuleBase;
	import com.struts.interfaces.IWebSite;
	import com.struts.utils.HashTable;
	
	import flash.events.Event;
	import flash.system.ApplicationDomain;
	import flash.system.System;
	import flash.utils.setTimeout;
	
	import mx.controls.ToolTip;
	import mx.core.FlexGlobals;
	import mx.core.IBorder;
	import mx.core.IVisualElement;
	import mx.core.IVisualElementContainer;
	import mx.events.FlexEvent;
	import mx.events.ModuleEvent;
	import mx.managers.HistoryManager;
	import mx.managers.ISystemManager;
	import mx.managers.ToolTipManager;
	import mx.modules.IModuleInfo;
	import mx.modules.ModuleManager;
	import mx.utils.ObjectUtil;
	import mx.utils.URLUtil;
	
	import spark.components.Group;
	import spark.components.SkinnableContainer;
	
	[DefaultProperty("viewers")]
	public class ComponentsManager extends SkinnableContainer
	{

		private var allModules : Array = new Array();
		
		public var viewers : Array = new Array();
		
		public var configData:ConfigData;
		
		public var iWebSite : IWebSite;
		
		private var hist:HistoryManager;
		
		private var moduleTable:HashTable = new HashTable();
		
		private var widgetTable:HashTable = new HashTable();
		
		private var layoutTable:HashTable = new HashTable();
		
		private var wgtInfo:IModuleInfo;
		
		private var isLayoutComplete : Boolean = false;
		
		private var preloadArray:Array = [];
		
		private var frameWorks : Array = [];
		
		private var _refX:Number = 0;
		private var _refY:Number = 0;

		public function ComponentsManager()
		{
			super();
			
			this.percentHeight = 100;
			this.percentWidth = 100;
			
			handlerEvents();
		}
		
		
		private function handlerEvents() : void
		{
			/**
			 * 统初始化监听
			 * */
			WebSite.addEventListener(AppEvent.COMPONENTS_INITIALIZED,componentsInitialize);
			
			/**
			 * 配置文件加载完成监听
			 * */
			WebSite.addEventListener(AppEvent.CONFIG_LOADED, configReadyHandler);
			
			/**
			 * 加载模块监听
			 * */
			WebSite.addEventListener(AppEvent.MODULE_RUN,onRunWidget);		
			
			
			/**
			 * 模块卸载监听
			 * */
			WebSite.addEventListener(AppEvent.MODULE_UNLOAD,unloadModuleHandler);
			
			
			/**
			 * 更新当前加载组件
			 * */
			WebSite.addEventListener(AppEvent.MODULE_WIDGET_CHANGE,updateWidgetsHandler);
			

			/**
			 * 更新当前加载组件
			 * */
			//WebSite.addEventListener(AppEvent.OPEN_ALL_MODULE,openAllModuleHandler);
			
			/**
			 * 
			 * 更新皮肤
			 * 
			 * */
			WebSite.addEventListener(AppEvent.MODULE_SKINS_CHANGE,moduleFrameWorkChangeHandler);
		
		}
		
		
		/**
		 *   参数加载完毕后调用方法
		 * 
		 * */
		public function configReadyHandler(event:AppEvent):void
		{
			configData = event.data as ConfigData;
		}
		
		/**
		 *   开始加载初始化组件
		 * 
		 * */			
		public function componentsInitialize(event : Event) : void
		{
			
			destroy();
			
			if(viewers.length)
			{
				for each(var view : IVisualElement in viewers)
				{
					if(view is IWebSite)
					{
						iWebSite = view as IWebSite;	
					}
					
					this.addElement(view);
				}
			}
			
			
			//布局组件加载完毕
			if(configData) 
			{
				preloadLayouts();
			}
		}
		
		/**
		 *  开始加载模块主件
		 * 
		 * */
		private function preloadWidgets():void
		{
			var widgetArray : Array = configData.widgets;
			if(widgetArray.length)
			{
				for each(var widget : Object in widgetArray)
				{
					var preload:String = widget.preload;
					if (preload == "open" || preload == "minimized" || preload == "true")
					{
						preloadArray.push(widget);
					}						
				}
			}
			preloadNextWidget();
		}
		
		private function preloadLayouts() : void
		{
			var layoutsArray : Array = configData.frameworks;
			if(layoutsArray.length)
			{
				for each(var layout : Object in layoutsArray)
				{
					frameWorks.push(layout);							
				}
			}
			
			preloadNextLayout();
		}

		
		private function openAllModuleHandler(event : Event) : void
		{
			
			var widgetArray : Array = configData.widgets;

			for each(var widget : Object in widgetArray)
			{
				allModules.push(widget);					
			}
			
			loadNextModule();
		}
		
		private function loadNextModule() : void
		{
			if (allModules.length > 0)
			{
				var wgt : Object = allModules[0];
				allModules.splice(0, 1);
				
				WebSite.dispatchEvent(new AppEvent(AppEvent.MODULE_UNLOAD,wgt));
				
				loadModule(wgt,widgetAllOpenReadyHandler);
			}
			else
			{
				WebSite.dispatch(AppEvent.OPEN_ALL_MODULE_COMPLETE);
			}	
		}
		
		
		
		private function widgetAllOpenReadyHandler(event:ModuleEvent):void
		{
			var info : IModuleInfo = event.module;
			
			pushToHashTable(info);
			
			loadNextModule();
		}
		
		/**
		 *  加载布局组件，加载完毕后加载模块组件
		 * 
		 * */
		private function preloadNextLayout() : void
		{
			if (frameWorks.length > 0)
			{
				var name : String = frameWorks[0].name;
				frameWorks.splice(0, 1);
				createWidget(name);
			}
			else
			{
				isLayoutComplete = true;
				preloadWidgets();
			}				
			
		}
		
		
		private var isInitialinzdReady : Boolean = false;
		
		private function preloadNextWidget():void
		{
			
			if (preloadArray.length > 0)
			{
				var name : String = preloadArray[0].name;
				preloadArray.splice(0, 1);
				WebSite.dispatchEvent(new AppEvent(AppEvent.MODULE_RUN, name));
			}
			else
			{
				if(isInitialinzdReady == false)
				{
					isInitialinzdReady = true;
					WebSite.dispatchEvent(new AppEvent(AppEvent.READY,iWebSite));
				}
			}
			
		}
		
		//=====================================================================
		// Load widgets
		//=====================================================================
		
		private var widgetAdded : Boolean = false;
		
		
		/**
		 *
		 * 根据  name 查询 Module 配置属性
		 *  
		 * <p>
		 * 	        当 protype 中设置 parent 属性时，该模块将继承指向parent属性的配置，并加载新模块
		 * </p>
		 * 
		 * <p>
		 * 	       但是当 protype 中设置 base 属性时，加载模块为 base 属性指明的模块，
		 *     首先为从缓存中查找对应模块，如果没有则加载新模块，
		 * </p>
		 * 
		 * parent 和 base 属性不同同时存在，同时存在将优先  parent属性
		 * 
		 * 
		 * @param name
		 * @param wgtChild
		 * @return 
		 * 
		 */
		private function findModuleByName(name : String, wgtChild : Object = null) : Object
		{
			function getWidgetsConfig(array : Array) : Object
			{
				if(array)
				{
					for each(var eleObject : Object in array) {
						var _name : String = eleObject.name;
						if (name == _name)
						{
							return eleObject;
						}							
					}
				}
				return null;
			}
			
			var array : Array = isLayoutComplete ? configData.widgets : configData.frameworks;
			var wgt : Object = getWidgetsConfig(array);
			
			if(wgt)
			{
				if(wgt.parent || wgt.base) 
				{
					var parentName : String = wgt.parent || wgt.base;
				    return findModuleByName(parentName,wgt);
				}

				if(wgtChild)
				{
					if(wgtChild.parent)
					{
						/** 将父节点的所有属性复制给子类  */
						for (var protype : String in wgt)
						{
							if(protype != "name" && wgt[protype])
							{
								if(!wgtChild[protype])
									wgtChild[protype] = wgt[protype];
							}
						}
						
						return wgtChild;
					}
					else if(wgtChild.base)
					{
						
						var baseWgt : Object = ObjectUtil.copy(wgt);
						baseWgt.queryString = wgtChild.queryString;
						
						return baseWgt;
					}
				}
				
				return wgt;	
			}
			
			return null;
		}
		
		/**
		 *  根据名称加载模块主件
		 * 
		 *   @parame name 模块名称
		 * 
		 * */
		
		public function createWidget(name: String) : void
		{
			var wgt : Object = findModuleByName(name);
			
			if(wgt == null)
				return;
			
			if(queryString == null)
			   updateQueryString(wgt);
			
			
			WebSite.dispatch(AppEvent.MODULE_OPENING);
			
			createWidgetByConfig(wgt);
		}
		
		/**
		 *  根据配置对象加载模块主件
		 * 
		 *   @parame name 模块配置
		 * 
		 * */			
		private function createWidgetByConfig(wgt : Object) : void
		{
			var url:String = wgt.url;
			var name : String = wgt.name;
			var widget:IModuleBase;
			
			if (widgetTable.containsKey(name))
			{
				widget = widgetTable.find(name) as IModuleBase;
				
				addController(widget);
			}
			else
			{
				if (moduleTable.containsKey(url))
				{
					var info:IModuleInfo = moduleTable.find(url) as IModuleInfo;
	
					widget = setModuleInfo(info,wgt);
					
					addController(widget);
				}
				else
				{
					loadWidget(wgt);
				}
			}					
		}
		
		/**
		 *  根据模块名称加载指定模块
		 * 	 
		 * */	
		
		private var queryString : Object;
		
		private function onRunWidget(event:AppEvent):void
		{
			var name : String = updateQueryString(event.data);
			if(name)
			{
				createWidget(name);
			}
		}
		
		private function updateQueryString(data : Object) : String
		{
			queryString = null;
			
			if(data is String)
			{
				return String(data);
			}
			else if(data is Object)
			{
				if(data.queryString)
				{
					if(data.queryString is String)
						queryString = URLUtil.stringToObject(data.queryString,"&",false);
					else
						queryString = data.queryString;
				}
				if(data.name)
				{
					return data.name;
				}
			}
			
			return null;
		}
		
		
		private function loadWidget(wgt : Object):void
		{
			//this.cursorManager.setBusyCursor();
			
			loadModule(wgt,widgetReadyHandler);
		}
		
		
		
		/**
		 * 
		 * 根据参数 加载Module
		 *  
		 * @param wgt   加载参数
		 * @param readyHandler  加载完成后回调方法
		 * 
		 */		
		private function loadModule(wgt : Object,readyHandler : Function) : void
		{
			var url:String = wgt.url;
			
			if(url)
			{
				wgtInfo = ModuleManager.getModule(url);
				wgtInfo.data = wgt;
				wgtInfo.addEventListener(ModuleEvent.READY, readyHandler);
				wgtInfo.addEventListener(ModuleEvent.ERROR, widgetError);
				wgtInfo.load(null, null, null, moduleFactory);
			}				
		}
		
		
		/**
		 *  
		 * 注销后，模块销毁 
		 * 
		 */		
		public function destroy() : void
		{

			if(this.numElements == 0)
				return;
			
			isLayoutComplete = false;
			isInitialinzdReady = false;
			iWebSite = null;
			wgtInfo = null;
			preloadArray = [];
			frameWorks = [];
			
			var keys : Array = moduleTable.getKeySet();
			var info : IModuleInfo;
			
			for each(var url : String in keys)
			{
				info = moduleTable.find(url) as IModuleInfo;
				info.removeEventListener(ModuleEvent.READY, widgetReadyHandler);
				info.removeEventListener(ModuleEvent.ERROR, widgetError);
				info.unload();
				info.release();
			}
			
			info = null;
			System.gc();
			
			moduleTable.clear();
			widgetTable.clear();
			layoutTable.clear();
			
			this.removeAllElements();

		}
		
		
		private function moduleFrameWorkChangeHandler(event : AppEvent) : void
		{
			if(configData)
			{
				configData.frameworks = event.data as Array;
				
				destroy();
			}
			
			
			
		}
		
		/**
		 * 
		 * 卸载模块
		 *  
		 * @param wgt
		 * 
		 */		
		private function unloadModuleHandler(event : AppEvent) : void
		{
			
			var wgt : Object = event.data;
			var name : String = wgt.name || wgt.Name;
			var url : String = wgt.url || wgt.Url;
			
			if(widgetTable.containsKey(name))
			{
				widgetTable.remove(name);
			}
			
			if(moduleTable.containsKey(url))
			{
				var info : IModuleInfo = moduleTable.find(url) as IModuleInfo;
				info.removeEventListener(ModuleEvent.READY, widgetReadyHandler);
				info.removeEventListener(ModuleEvent.ERROR, widgetError);
				info.unload();
				info.release();
				
				moduleTable.remove(url);
				info = null;
			}
		}
		
		
		/**
		 * 
		 * 重新加载模块配置
		 *  
		 * @param event
		 * 
		 */		
		private function updateWidgetsHandler(event : AppEvent) : void
		{
			if(configData)
			{
			   configData.widgets = event.data as Array;
			}
		}
		
		/**
		 *  模块加载失败后
		 * 
		 * */
		public function widgetError(event:ModuleEvent):void
		{
			//this.cursorManager.removeBusyCursor();
			
			var errorMessage : String = event.errorText ? event.errorText : "The system module loading errors.\n" +
																			 "Please check the configuration.";
			WebApp.tip(errorMessage,true);
		}
		
		/**
		 * 	模块加载成功后
		 * 
		 * */
		private function widgetReadyHandler(event:ModuleEvent):void
		{
			//this.cursorManager.removeBusyCursor();
			
			var info:IModuleInfo = event.module;
			var widget : IModuleBase = pushToHashTable(info);
			
			addController(widget);
		}
		
		
		private function pushToHashTable(info : IModuleInfo) : IModuleBase
		{

			var wgt : Object = info.data;
			var widget : IModuleBase = setModuleInfo(info,wgt);
			widgetTable.add(wgt.name, widget);			

			moduleTable.add(info.url, info);
			
			return widget;
		}
		
		
		/**
		 *  设置模块接口的配置属性
		 *  
		 * */
		public function setModuleInfo(info : IModuleInfo,wgt:Object) : IModuleBase
		{
			//var preload:String = info.data.preload;
			var title:String = wgt.title;
			var icon:String = wgt.icon;
			var config:String = wgt.config;
			var wx:Number = Number(wgt.x);
			var wy:Number = Number(wgt.y);
			var wleft:String = wgt.left;
			var wtop:String = wgt.top;
			var wright:String = wgt.right;
			var wbottom:String = wgt.bottom;
			var layoutElement : String = wgt.layoutElement;
			var handler : Object = wgt.handler;
			var name : String = wgt.name;
			//var runModule : String = wgt.runModule;
			
			var widget : IModuleBase = info.factory.create() as IModuleBase;
			
			widget.moduleName = name;
			widget.moduleTitle = title;
			widget.moduleIcon = icon;
			widget.config = config;
			widget.source = wgt;
			widget.layoutElement = layoutElement;
			//widget.handler = handler;
			//widget.runModule = runModule;
			widget.addEventListener(FlexEvent.CREATION_COMPLETE,completeHandler);
			widget.addEventListener(Event.ADDED_TO_STAGE,module_AddedToStageHanlder);
			widget.addEventListener(Event.REMOVED_FROM_STAGE,module_RemvoeToStageHanlder);
			//widget.addEventListener(AppEvent.MODULE_CREATION_COMPLETE,moduleLoadCompleteHandler);
			
			
			if (wleft || wtop || wright || wbottom)
			{
				widget.setRelativePosition(wleft, wright, wtop, wbottom);
			}
			else if (wx && wy)
			{
				widget.setXYPosition(wx, wy);
			}
			else
			{
				//setAutoXY();
				wx = _refX;
				wy = _refY
				widget.setXYPosition(wx, wy);
			}

			
			return widget;
			
		}
		
		/**
		 *  模块加载完成后，加载下一个组建件
		 * 
		 * */
		private function completeHandler(event : Event) : void
		{
			if(isLayoutComplete)
			{
				preloadNextWidget();
			}
			else
			{
				preloadNextLayout();
			}
		}
		
		private function setAutoXY():void
		{
			var widgetWidget:Number = 300;
			
			var siftUnit:Number = 20;
			
			if (_refX == 0)
			{
				_refX = siftUnit;
			}
			else
			{
				_refX = _refX + widgetWidget + 20;
			}
			
			if (_refY == 0)
			{
				_refY = Math.round(widgetWidget / 2);
			}
			
			if (((_refX + widgetWidget) > this.width))
			{
				_refX = siftUnit
				_refY = _refY + Math.round(widgetWidget + siftUnit) / 2;
			}
			else if ((_refY + widgetWidget) > this.height)
			{
				_refX = siftUnit;
				_refY = Math.round(widgetWidget / 2);
			}
		}
		

		override public function addElement(element:IVisualElement):IVisualElement
		{
			if(element is ILayout)
			{
				layoutTable.add(ILayout(element).layoutName,element);
			}
			
			if(!iWebSite)
			{
				if(element is IWebSite)
				{
					iWebSite = element as IWebSite;
				}
			}

			return super.addElement(element);
			
		}
		/**
		 *   添加组件或模块
		 * 
		 *   @parame wgt 模块参数
		 *   @parame child 加载组件
		 * */
		private function addController(child : IModuleBase) : void
		{
			if(null == child)
				return;

			if(child is IWebSite)
			{
				this.addElement(child as IVisualElement);
			}
			else
			{
				if(iWebSite)
				{
					var componentsLayout : ILayout;
					
					if(child.layoutElement)
						componentsLayout = layoutTable.find(child.layoutElement);

					if(componentsLayout)
					{
						componentsLayout.addComponents(child as IVisualElement);
					}
					else
					{
						iWebSite.addComponents(child as IVisualElement);
					}
				}
				else
				{
					this.addElement(child as IVisualElement);
				}
			}	
		}
		
		
		/**
		 * 
		 * 主Frame 中加载模块后调用 
		 *  
		 * @param event
		 * 
		 */		
		private function module_AddedToStageHanlder(event : Event) : void
		{
			var module : IModuleBase = event.currentTarget as IModuleBase;
		
			if(module.hasCreationComplete)
			{
				if(!queryString)
					queryString = {};
				
				module.open(queryString);
			
				WebSite.dispatchEvent(new AppEvent(AppEvent.MODULE_OPEN,module));	
			}
			
		}
		
		/**
		 * 
		 * Frame 中移除模块后调用 
		 * 
		 * @param event
		 * 
		 */		
		private function module_RemvoeToStageHanlder(event : Event) : void
		{
			var child : IModuleBase = event.currentTarget as IModuleBase;
			
			if(child)
			{
			   child.close();
			}
		}
		
	}
}





