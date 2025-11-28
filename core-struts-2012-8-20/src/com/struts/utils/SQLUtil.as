package com.struts.utils
{
	
import mx.utils.ObjectProxy;
import mx.utils.ObjectUtil;

public class SQLUtil
{
	public static function createInsertSQL(obj : Object,_tablename : String,_primary : String = null) : String
	{
		var sql : String = new String();
		if(_tablename)
		{
			var values : String = new String();
			var fields : String = new String();

			var callback : Function = function(field : String,value : String) : void
			{
				fields += field + ",";
				values += value+ ",";				
			}
			
			saveOrUpdate(obj,callback);
			
			fields = fields.substr(0,fields.length-1);
			values = values.substr(0,values.length-1);
			sql += " insert into  " + _tablename + " ("+fields+") values ("+values+")";
			
			return sql;
		}
		return null;
	}
		
	public static function createUpdateSQL(obj : Object,_tablename : String,_primary : String = null) : String
	{
		var sql : String = new String();
		if(_tablename)
		{
			var updates : String = new String();
			var callback : Function = function(field : String,value : String) : void
			{
				updates += field + "=" + value + ",";				
			}
			
			saveOrUpdate(obj,callback);
			
			updates = updates.substr(0,updates.length-1);
			sql += " update " + _tablename + " set "+updates;
			
			if(_primary)
			{
				sql += " where " + _primary +"="+ formatValue(obj[_primary]);
			}
			
			return sql;	
		}
		
		return null;		
	}
	
	//delete from car_info
	public static function createDeleteSQL(obj : Object,_tablename : String,_primary : String = null) : String
	{
		var sql : String = new String();
		if(_tablename)
		{
			sql += " delete from " + _tablename;
			if(_primary)
			{
				sql += " where " + _primary +"="+ formatValue(obj[_primary]);
			}
			return sql;	
		}
		return null;		
	}
	
	public static function createSelectSQL(_tablename : String,data : Object = null,_primary : String = null) : String
	{
		var sql : String = new String();
		if(_tablename)
		{
			sql = "select * from " + _tablename;
			if(_primary && data)
			{
				sql += " where " + _primary +"="+ formatValue(data[_primary]);
			}
			return sql;
		}
		return null;
	}
	
	
	private static function saveOrUpdate(obj : Object,callback : Function) : void
	{
		if(null == callback)
			return;
		
		var field : String;
		var vlaue : String;
		
		if(obj is XML)
		{
			var protypes : XMLList = XML(obj).attributes();
			for each(var prop : XML in protypes)
			{
				field = prop.localName();
				vlaue = formatValue(prop,field);
				
				callback.call(null,field,vlaue);
			}  			
			
		}
		else
		{
			var objectInfo : Object = ObjectUtil.getClassInfo(obj);
			var classInfoProperties:Array = objectInfo.properties as Array;
			var qName : QName;
			
			for each(qName in classInfoProperties)
			{
				field = qName.localName;
				vlaue = formatValue(obj[field]);
				
				callback.call(null,field,vlaue);
			}
			
		}
	}
	
	
	private static function formatField(field : String) : String
	{
		return field.replace("@","");
	}
	
	private static function formatValue(value : Object,field : String = null) : *
	{
		var isNumber : Boolean = false;
		
		if(field)
		{
			if(value is XML || value is XMLList)
			{
				field = field.toLowerCase();
				isNumber = field.indexOf("is") != -1;
				if(isNumber == false)
				{
					isNumber = field.indexOf("num") != -1;
				}
			}
		}
		
		if(value is Number)
		{
			isNumber = true;
		}
		else if(value is Boolean)
		{
			return value ? 1 : 0;
		}
		
		if(isNumber)
		{
			return String(value);
		}
		
		return "\""+String(value)+"\"";

	}
	
	
}

}













































