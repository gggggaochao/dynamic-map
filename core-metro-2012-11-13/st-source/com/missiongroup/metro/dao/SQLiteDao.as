package com.missiongroup.metro.dao
{
	
import com.spring.core.IGenericDao;
import com.struts.utils.HashTable;

import flash.data.SQLConnection;
import flash.data.SQLMode;
import flash.data.SQLResult;
import flash.data.SQLSchemaResult;
import flash.data.SQLStatement;
import flash.errors.SQLError;
import flash.events.SQLEvent;
import flash.filesystem.File;

import mx.rpc.xml.SchemaTypeRegistry;

public class SQLiteDao implements IGenericDao 
{

	private var readConnection : SQLConnection;
	
	private var updateConnection : SQLConnection;
	
	private var isCreate : Boolean = false;
	
	private var dbFile : File;
	
	private var _path : String;

	public function get path():String
	{
		return _path;
	}

	public function set path(value:String):void
	{
		if(_path != value)
		{
			_path = value;
			dbFile = new File(value);
			getUpdateConnection();
			getReadConnection();	
		}
	}

	
	public function SQLiteDao(path : String = null)
	{
		this.path = path;
	}

	private function getUpdateConnection() : SQLConnection
	{
		try
		{
			if(updateConnection == null)
				updateConnection = new SQLConnection();
			
			if(!updateConnection.connected)
				updateConnection.open(dbFile,SQLMode.UPDATE);
			else
				return updateConnection;
		}
		catch(error : SQLError)
		{
			
		}
		
		return null;
	}
	
	private function getReadConnection() : SQLConnection
	{
		try
		{
			if(readConnection == null)
				readConnection = new SQLConnection();
			
			if(!readConnection.connected)
				readConnection.open(dbFile,SQLMode.READ);
			else
				return readConnection;
			
		}
		catch(error : SQLError)
		{
			
		}
		
		return null;
	}
	
	
	
	private function createSQLStatement(con : SQLConnection,
										sql : String,
										parameters : Object = null) : SQLStatement
	{
		var statement : SQLStatement = new SQLStatement();
		statement.sqlConnection = con;
		statement.text = sql;
	
		if(parameters)
		{
			for (var key : String in parameters)
			{
				statement.parameters[key] = parameters[key];
			}
		}		
		
		return statement;
	}
	
	
	public function save(sql : String,parameters : Object = null) : Boolean
	{
		var con : SQLConnection = getUpdateConnection();
		
		if(con)
		{
			var statement : SQLStatement = createSQLStatement(con,sql,parameters);

			try
			{
				statement.execute();
				
				return statement.getResult().rowsAffected == 1;
			}
			catch(error : SQLError)
			{
				throw error;
			}
			
		}
		
		return false;			
		
		
	}
	
	public function execute(sql : String,parameters : Object = null) : Number
	{
		var con : SQLConnection = getUpdateConnection();
		var priority : Number = 0;
		if(con)
		{
			var statement : SQLStatement = createSQLStatement(con,sql,parameters);
			
			try
			{
			//	statement.addEventListener(SQLEvent.RESULT, priority);
				statement.execute();
				
				return statement.getResult().rowsAffected;
			}
			catch(error : SQLError)
			{
				throw error;
			}
			
		}
		
		return 0;				
	}
	
	public function getQuery(sql : String,parameters : Object = null) : Array
	{
		var con : SQLConnection = getReadConnection();
		if(con)
		{
			var statement : SQLStatement = createSQLStatement(con,sql,parameters);
			
			try
			{
				statement.execute();
				
				return statement.getResult().data;
			}
			catch(error : SQLError)
			{
				throw error;
			}
		}
		return null;
	}

	/**
	 * Add by chenjun 2014-09-12
	 */
	public function hz_updateTrainLine(sql : String, parameters : Array = null) : Boolean
	{
		var con : SQLConnection = getUpdateConnection();
		
		if(con)
		{
			con.begin();
			var statement : SQLStatement;
			try
			{
				statement = new SQLStatement();
				statement.sqlConnection = con;
				statement.text = sql;
				
				statement.parameters[":stime"] = parameters[0];
				statement.parameters[":etime"] = parameters[1];
				statement.parameters[":lineId"] = parameters[2];
				statement.parameters[":orderId"] = parameters[3];
				statement.execute();
				
				con.commit();
				
				return true;
			}
			catch(error : SQLError)
			{
				
				con.rollback();
				
				throw error;
				
				return false;
			}
		}
		
		return false;
	}
	
	public function executeTransaction(sqls : Array,parameters : Array = null) : Boolean
	{

		var con : SQLConnection = getUpdateConnection();
		
		if(con)
		{
			con.begin();
			
			var statement : SQLStatement;
			
			try
			{
				for each(var sql : String in sqls)
				{

					statement = createSQLStatement(con,sql);
					
					statement.execute();
				}	

				
				con.commit();
				
				return true;
			}
			catch(error : SQLError)
			{
				
				con.rollback();
				
				throw error;
				
				return false;
			}
		}
		
		return false;
	}

	
	
	public function getSingle(sql : String,parameters : Object = null) : Object
	{
		var con : SQLConnection = getReadConnection();
		
		var resSingle : Object = new Object();
		
		if(con)
		{
			var statement : SQLStatement = createSQLStatement(con,sql,parameters);
			
			var sqlResults : Array;
			try
			{
				statement.execute();
				
				sqlResults = statement.getResult().data;
				
				if(sqlResults && sqlResults.length)
					resSingle = sqlResults[0];
			}
			catch(error : SQLError)
			{
				throw error;
			}
		}
		
		return resSingle;
	}
	
	public function close() : void
	{
		if(updateConnection && updateConnection.connected)
		   updateConnection.close();
		
		if(readConnection && readConnection.connected)
		   readConnection.close();
	}
	
	public function getTables() : Array
	{
		var con : SQLConnection = getReadConnection();
		
		if(con)
		{
	
			con.loadSchema();
			
			var schemaResult : SQLSchemaResult = con.getSchemaResult();
			
			return schemaResult.tables;
		}
		
		return null;
	}
	

	
}
}























































