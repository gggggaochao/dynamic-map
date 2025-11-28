package com.spring.db
{
public class DataTable
{
	
	public var model : *;
	
	public var table : String;
	
	public var fields : Array;
	
	public var identity : DataField ;
	
	public var createSQL : String;
	
	public var insertSQL : String;
	
	public var updateSQL : String;
	
	public var clearSQL : String;
	
	public var deleteSQL : String;
	
	public var selectSQL : String;
	
	public var selectAllSQL : String;
	
	public function DataTable(table : String)
	{
		this.table = table;
		this.fields = [];
	}
	
}
}