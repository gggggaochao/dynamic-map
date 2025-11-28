package com.struts.components
{
	
import com.struts.interfaces.ILogin;

import flash.events.Event;
import flash.events.MouseEvent;

import mx.core.UIComponent;

import spark.components.Button;
import spark.components.Label;
import spark.components.TextInput;
import spark.components.supportClasses.SkinnableComponent;

public class LoginGroup extends SkinnableComponent
{
	
	[SkinPart(required="false")]
	public var loginButton : Button;
	
	[SkinPart(required="false")]
	public var resetButton : Button;
	
	[SkinPart(required="false")]
	public var usernameTxt : TextInput;
	
	[SkinPart(required="false")]
	public var passwordTxt : TextInput;
	
	[SkinPart(required="false")]
	public var tipDisplayLabel : Label;
	
	
	private var _service : ILogin;

	public function get service():ILogin
	{
		return _service;
	}

	public function set service(value:ILogin):void
	{
		_service = value;
	}

	
	public function LoginGroup()
	{
		super();
	}
	
	protected override function partAdded(partName:String, instance:Object):void
	{
		super.partAdded(partName, instance);
		
		if(passwordTxt == instance)
		{
			passwordTxt.displayAsPassword = true;
		}
		
		if(loginButton == instance)
		{
		   loginButton.addEventListener(MouseEvent.CLICK,submitHandler);
		}
	}
		
	private function submitHandler(event : Event) : void
	{
		if(_service)
		{
			var username : String = usernameTxt.text;
			var password : String = passwordTxt.text;
			
			_service.login(username,password);
		}
	}
	
	/**
	 * 
	 *  登录协议
	 * 
	 *  $S{}$E
	 * 
	 * */
	private function loginHandler(res : Object) : void
	{
		
	}
	
	
}

}





















































