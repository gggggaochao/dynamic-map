package com.spring.core
{
public interface IGenericDao
{
	
	function save(sql : String,parameters : Object = null) : Boolean
		
	function execute(sql : String,parameters : Object = null) : Number
		
	function getQuery(sql : String,parameters : Object = null) : Array
		
	function executeTransaction(sqls : Array,parameters : Array = null) : Boolean;
		
	function getSingle(sql : String,parameters : Object = null) : Object;
	
	function getTables() : Array;
	
}
}