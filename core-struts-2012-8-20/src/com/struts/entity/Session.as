package com.struts.entity
{
import mx.utils.StringUtil;

public class Session
{
	private var _company : String;
	
	private var _user : String;
	
	private var _userid : Number;
	
	private var _roles : Array;
	
	private var _depart : String;
	
	private var _menu : Array;
	
	private var _password : String;

	public function Session(data : Object)
	{
		if(data)
		{
			if(data.menu)
			{
				this._menu = data.menu;
			}
			
			if(data.user)
			{
				this._user = data.user.username;
				this._userid = data.user.userid;
				this._password = data.user.userloginpwd;
				this._roles = data.user.roles;
				this._depart = data.user.depart.deptname;
			}
		}
	}

	public function get password():String
	{
		return _password;
	}

	public function set password(value:String):void
	{
		_password = value;
	}

	
	public function get menu():Array
	{
		return _menu;
	}

	public function set menu(value:Array):void
	{
		_menu = value;
	}

	public function get depart():String
	{
		return _depart;
	}

	public function set depart(value:String):void
	{
		_depart = value;
	}

	public function get roles():Array
	{
		return _roles;
	}

	public function set roles(value:Array):void
	{
		_roles = value;
	}

	public function get userid():Number
	{
		return _userid;
	}

	public function set userid(value:Number):void
	{
		_userid = value;
	}

	public function get user():String
	{
		return _user;
	}

	public function set user(value:String):void
	{
		_user = value;
	}

	public function get company():String
	{
		return _company;
	}

	public function set company(value:String):void
	{
		_company = value;
	}


}
}


