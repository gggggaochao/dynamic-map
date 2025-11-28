package com.struts.managers
{
	import com.struts.interfaces.IModuleBase;
	import com.struts.WebSite;
	import com.struts.entity.ConfigData;
	import com.struts.events.AppEvent;
	
	import flash.events.Event;
	
	import mx.core.IVisualElement;
	import mx.events.ModuleEvent;
	import mx.modules.IModuleInfo;
	import mx.modules.ModuleManager;
	
	public class ComponentsManagerDock extends ComponentsManager
	{
		private var loginModule : IModuleBase;
		
		private var loginInfo : IModuleInfo;
		
		/**
		 *  是否登录
		 * 
		 * */
		private var isLogin : Boolean = false;
		
		public function ComponentsManagerDock()
		{
			super();
			
			WebSite.addEventListener(AppEvent.USER_LOGIN_SUCCESS,userLoginSuccessHandler);
			
			
			WebSite.addEventListener(AppEvent.USER_LOGOUT,userLogoutHandler);
		}
		
		/**	
		 * 	 
		 * 判断是否加载登录模块，进行用户验证
		 * 
		 * */
		override public function componentsInitialize(event : Event) : void
		{
			if(isLogin)
			{
				super.componentsInitialize(event);
			}
			else
			{
				if(configData.loginWidget)
				{
					loadLoginModule(configData.loginWidget);
				}	
				else
				{
					super.componentsInitialize(event);
				}
			}
		}
		
		private function loadLoginModule(wgt : Object):void
		{
			var url : String = wgt.url;
			var config : String = wgt.config;
			if(url)
			{
				this.cursorManager.setBusyCursor();
				
				loginInfo = ModuleManager.getModule(url);
				loginInfo.data =
				{
					url: url,
					config: config
				};
				loginInfo.addEventListener(ModuleEvent.READY, loginLoadReadyHandler);
				loginInfo.addEventListener(ModuleEvent.ERROR, widgetError);
				loginInfo.load(null, null, null, moduleFactory);
				
			}
		}
		
		private function loginLoadReadyHandler(event:ModuleEvent):void
		{
			this.cursorManager.removeBusyCursor();
			
			var info:IModuleInfo = event.module;
			var config:String = info.data.config as String;
			
			loginModule = info.factory.create() as IModuleBase;
			loginModule.config = config;
			loginModule.setRelativePosition("0", "0", "0", "0");
			
			this.addElement(loginModule as IVisualElement);
		}			
		
		private function userLoginSuccessHandler(event : AppEvent) : void
		{
			if(loginModule)
			{
				isLogin = true;
				this.removeElement(loginModule as IVisualElement);
				WebSite.dispatchEvent(new AppEvent(AppEvent.COMPONENTS_INITIALIZED));
			}
		}
		
		private function userLogoutHandler(event : Event) : void
		{
			if(loginModule)
			{
				isLogin = false;
				
				destroy();
				
				this.addElement(loginModule as IVisualElement);
			}
		}
		
	}
}