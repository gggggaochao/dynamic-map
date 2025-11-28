package com.spring.db
{
	
import com.spring.core.IGenericDao;
import com.spring.core.ISpringTag;
import com.spring.core.Message;
import com.struts.utils.HashTable;

import flash.utils.describeType;
import flash.utils.getQualifiedClassName;

public class DataSet
{
	private var tablesHashMap : HashTable;
	
	private var _dao : IGenericDao;

	public function set dao(value:IGenericDao):void
	{
		if(_dao != value)
		{
			_dao = value;
			
			initializeDataSet();
		}
	}

	
	private var _tables : Array;

	public function set tables(value:Array):void
	{
		if(_tables != value)
		{
			_tables = value;
			
			initializeDataSet();
		}
	}
	
	
	public function DataSet()
	{
		this.tablesHashMap = new HashTable();
	}
	
	public function initializeDataSet() : void
	{
		if(_tables && _dao)
		{
			
			this.tablesHashMap.clear();
			
			var _dataTable : DataTable;
			for each(var _model : * in _tables)
			{
				_dataTable = addTable(_model);
				_dao.execute(_dataTable.createSQL);
			}
		}
	}
	
	public function getTable(model : *) : DataTable
	{
		//get
		var qualifiedClassName : String = getQualifiedClassName(model);
		return this.tablesHashMap.find(qualifiedClassName);
	}
	
	public function addTable(model : *) : DataTable
	{
		var qualifiedClassName : String = getQualifiedClassName(model);
		
		var dataTable : DataTable =  tablesHashMap.find(qualifiedClassName);
		
		if(!dataTable)
		{		
			var config : XML = describeType(model);
			
			var enNode : XML = config;
			
			if(config.factory.length() > 0)
				enNode = config.factory[0];
			
			var variables : XMLList = enNode.variable;
			var fieldNode : XML;
			
			var table : String = enNode.metadata.(@name=="Table").arg.(@key=="name").@value;
			
			dataTable = new DataTable(table);
			
			var dataField : DataField;
			
			var fieldCount : int = variables.length();
	
			var insertParams:String = "";
			
			var updateSQL:String = "UPDATE " + table + " SET ";
			var insertSQL:String = "INSERT INTO " + table + " (";
			var createSQL:String = "CREATE TABLE IF NOT EXISTS " + table + " (";
			var clearSQL :String = "DELETE FROM " + table;
			var deleteSQL:String = "DELETE FROM " + table;
			var selectAllSQL:String = "SELECT * FROM " + table;
			var selectSQL:String = "SELECT * FROM " + table;
			
			
			for (var i : int = 0;i<fieldCount;i++)
			{
				fieldNode = variables[i];
				
				if(fieldNode.metadata.(@name=="Lost").length() > 0)
				{
					continue;
				}				
				
				
				dataField = new DataField(fieldNode.@name);
				dataField.type = fieldNode.@type;
				dataTable.fields.push(dataField);
				
				if(fieldNode.metadata.(@name=="Column").length() > 0)
				{
					dataField.column = fieldNode.metadata.(@name=="Column").arg.(@key=="name").@value.toString();
				}
				else
				{
					dataField.column = dataField.field;
				}
	
				if (!dataTable.identity && fieldNode.metadata.(@name=="Id").length()>0)
				{
					createSQL += dataField.column + " INTEGER PRIMARY KEY AUTOINCREMENT,";
					dataTable.identity = dataField;
				}
				else            	
				{
					insertSQL += dataField.column + ",";
					insertParams += ":" + dataField.field + ",";
					updateSQL += dataField.column + "=:" + dataField.field + ",";	
					createSQL += dataField.column + " " + getSQLType(dataField.type) + ",";
				}
			}
			
			
			createSQL = createSQL.substring(0, createSQL.length-1) + ")";
			insertSQL = insertSQL.substring(0, insertSQL.length-1) + ") VALUES (" + insertParams;
			insertSQL = insertSQL.substring(0, insertSQL.length-1) + ")";
			updateSQL = updateSQL.substring(0, updateSQL.length-1);
			
			if(dataTable.identity)
			{
				var conditions : String = " WHERE " + dataTable.identity.column + "=:" + dataTable.identity.field;
				
				updateSQL += conditions;
				deleteSQL += conditions;	
				selectSQL += conditions;
			}
			
			
			dataTable.insertSQL = insertSQL;
			dataTable.createSQL = createSQL;
			dataTable.updateSQL = updateSQL;
			dataTable.deleteSQL = deleteSQL;
			dataTable.selectSQL = selectSQL;
			dataTable.selectAllSQL = selectAllSQL;
			dataTable.clearSQL = clearSQL;
			dataTable.model = model;
			
			tablesHashMap.add(qualifiedClassName,dataTable);
		
		}
		
		return dataTable;
	}
	
	private function getSQLType(asType:String):String
	{
		if (asType == "int" || asType == "uint")
			return "INTEGER";
		else if (asType == "Number")
			return "REAL";
		else
			return "TEXT";				
	}
	
	
	public function save(table : DataTable ,parameter : Object) : Number
	{
		return _dao.execute(table.insertSQL,parameter);
	}
	
	public function update(table : DataTable ,parameter : Object) : Number
	{
		return _dao.execute(table.updateSQL,parameter);
	}
	
	
	public function remove(table : DataTable ,parameter : Object) : Number
	{
		return _dao.execute(table.deleteSQL,parameter);
	}
	
	public function selectAll(table : DataTable) : Array
	{
		return _dao.getQuery(table.selectAllSQL);
	}
	
	public function clear(table : DataTable) : Number
	{
		return _dao.execute(table.clearSQL);
	}
	
	public function transaction(sqls : Array) : Boolean
	{
		return _dao.executeTransaction(sqls);
	}
		
	
	
	
	
}
}


























