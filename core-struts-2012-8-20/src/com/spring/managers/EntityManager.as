package com.spring.managers
{
	
import com.spring.core.IGenericDao;
import com.spring.db.DataField;
import com.spring.db.DataSet;
import com.spring.db.DataTable;
import com.struts.utils.ArrayUtil;

import mx.collections.ICollectionView;
import mx.collections.IList;
import mx.collections.IViewCursor;
import mx.utils.ObjectUtil;

public class EntityManager
{
	
	private static var _instance : EntityManager;		
	
	private static var _lock : Boolean = true;
	
	public var dataSet : DataSet;
	
	public function EntityManager()
	{
		if(_lock)
		{
			throw new Error("EntityManager is a singleton. Use EntityManager.getInstance() to obtain an instance of this class.");
		}
	}
	
	public static function getInstance(dataSet : DataSet) : EntityManager
	{
		if (!_instance)
		{
			_lock = false;
			_instance = new EntityManager();
			_lock = true;
		}
		
		_instance.dataSet = dataSet;
		return _instance;
	}
	
	
	
	/**
	 *
	 * 保存或者编辑数据对象。
	 * 
	 * 当主键为空为保存，否则为编辑
	 *  
	 * @param o
	 * @return 
	 * 
	 */	
	public function saveOrUpdate(o : *) : Boolean
	{
		
		var dataTable : DataTable = dataSet.getTable(o);
		
		if(dataTable)
		{
			
			var paramaters : Object = new Object();
			
			var isUpdate : Boolean = false;
			
			if(dataTable.identity)
			{
				var isNumber : Boolean = !isNaN(o[dataTable.identity.field]);
				isUpdate = isNumber ? o[dataTable.identity.field] > 0 : false;
			}
				
			if(isUpdate)
			{
				return update(o,dataTable) > 0;
			}
			else
			{
				return save(o,dataTable) > 0;
			}

		}
		
		return false;
	}
	
	
	/**
	 *
	 * 保存或者编辑数据对象集合。
	 * 
	 * 当主键为空为保存，否则为编辑
	 *  
	 * @param o
	 * @return 
	 * 
	 */	
	public function saveOrUpdateList(o : *) : Boolean
	{
		var list :ICollectionView = ArrayUtil.format(o);
		var count : Number = list.length;
		var cursor  : IViewCursor = list.createCursor();
		
		var index : Number = 0;
		while(!cursor.afterLast)
		{
			var item : Object = cursor.current;
			
			if(saveOrUpdate(item))
				index++;
			
			cursor.moveNext();
		}	
		
		return count == index;
	}
	
	/**
	 * 
	 * 清空当前表数据
	 *  
	 * @param o
	 * @return 
	 * 
	 */	
	public function clear(o : Object) : Boolean
	{
		try
		{
			var dataTable : DataTable = dataSet.getTable(o);
			if(dataTable)
			{
				dataSet.clear(dataTable);
				return true;
			}
		}
		catch(error : Error)
		{
			return false;
		}
		
		return false;
	}
	
	
	
	/**
	 * 
	 * 查询当前所有对象数据
	 *  
	 * @param o
	 * @return 
	 * 
	 */	
	public function selectAll(o : Object) : Array
	{
		var dataTable : DataTable = dataSet.getTable(o);
		
		if(dataTable)
		{
			var results : Array = dataSet.selectAll(dataTable);
		
			if(results)
			{
				var returnList : Array = new Array();
				for each(var data : Object in results)
				{
					returnList.push(getObject(dataTable,data));
				}
				return returnList;	
			}
		}	
		return null;
	}
	
	
	
	private function getObject(dataTable : DataTable,data : Object):Object
	{
		var model : * = dataTable.model;
		
		var instance : Object;
		
		if(model is Class)
			instance = new model();
		else
			instance = ObjectUtil.copy(model);
		
		var fields : Array = dataTable.fields;
		
		for each(var field : DataField in fields)
		{
			instance[field.field] = data[field.column];	
		}

		return instance;
	}
	
	private function save(o : Object,table : DataTable) : Number
	{
		var sql : String = table.insertSQL;
		
		var parameter : Object = new Object();
		var fields : Array = table.fields;
		for each(var field : DataField in fields)
		{
			if(table.identity && field.field == table.identity.field)
				continue;
			
			parameter[":"+field.field] = o[field.field];
		}
		
		return dataSet.save(table,parameter);	
	}
	
	
	private function update(o : Object,table : DataTable) : Number
	{
		var parameter : Object = new Object();
		var fields : Array = table.fields;
		for each(var field : DataField in fields)
		{
			parameter[":"+field.field] = o[field.field];
		}
		
		return dataSet.update(table,parameter);	
		
	}
}
}









