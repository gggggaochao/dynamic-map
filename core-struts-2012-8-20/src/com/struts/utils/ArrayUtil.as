package com.struts.utils
{
import flash.xml.XMLNode;

import mx.collections.ArrayCollection;
import mx.collections.CursorBookmark;
import mx.collections.Grouping;
import mx.collections.GroupingCollection2;
import mx.collections.GroupingField;
import mx.collections.ICollectionView;
import mx.collections.IList;
import mx.collections.IViewCursor;
import mx.collections.XMLListCollection;

import spark.collections.Sort;
import spark.collections.SortField;

/**
 *   集合处理类
 * 
 * */
public class ArrayUtil
{
	
	/**
	 * sort source
	 *  
	 * @param source
	 * @param feild
	 * @param desc
	 * 
	 */	
	public static function sort(source : *,feilds : Array,desc : String = null) : void
	{
		
		var ds :ICollectionView;
		
		if(feilds)
		{
			var sortFields : Array = [];
			var dataSortField : SortField;
			
			for each(var feild : String in feilds)
			{
				dataSortField = new SortField();
				dataSortField.name = feild;
				dataSortField.numeric = true;
				dataSortField.descending = desc == "desc";
				
				sortFields.push(dataSortField);
			}
			
			if(sortFields.length)
			{
				ds = format(source);
				ds.sort = new Sort();
				ds.sort.fields = sortFields;
				ds.refresh();
			}
		}
	}
	
	
	/**
	 * select Index of source By feild And value
	 *  
	 * @param source
	 * @param feild
	 * @param value
	 * @return 
	 * 
	 */	
	public static function selected(source : *,feild : String,value : Object) : int
	{
		if(source && feild && value)
		{
			var collection :ICollectionView = format(source);
			
			if(!collection)
				return -1;
			
			var cursor  : IViewCursor = collection.createCursor();
			var selectIndex : int = 0;
			while(!cursor.afterLast)
			{
				var item : Object = cursor.current;
				
				if(item is XML)
				{
					if(String(item.@[feild]) == String(value))
						return selectIndex;
				}
				else if(item is Object)
				{
					if(item[feild] == value)
						return selectIndex;
				}
				selectIndex++;
				cursor.moveNext();
			}
		}
		
		return -1;
	}
	

	/**
	 * set data To Group By field
	 * 
	 *  <p>
	 *  GroupLabel or children
	 *  </p>
	 * 
	 * @param data
	 * @param feild
	 * @return 
	 * 
	 */	
	public static function group(source : Object,field : String) : ArrayCollection
	{
		var group:Grouping = new Grouping();
		
		var gf:GroupingField = new GroupingField(field);
		group.fields = [gf];
		
		var arrayCollection :ICollectionView = format(source);
		var myGroupColl:GroupingCollection2 = new GroupingCollection2();
		myGroupColl.source = arrayCollection;
		myGroupColl.grouping = group;
		myGroupColl.refresh();
		
		
		return myGroupColl.getRoot() as ArrayCollection;
	}
	
	
	/**
	 *
	 * 根据 source 数据源分组
	 * 
	 *  
	 * @param source
	 * @param feilds
	 * @return 
	 * 
	 */	
	public static function groups(source : Object,feilds : Array) : ArrayCollection
	{
		function rollback(children : ArrayCollection,feilds : Array,index : Number) : void
		{
			index++;
			for each(var child : Object in children)
			{
				var temp : Object = child.children;
				var childrenList : ArrayCollection = null;
				if(temp is ArrayCollection)
				{
					childrenList = temp as ArrayCollection;
				}
				else if(temp is Array)
				{
					childrenList = new ArrayCollection(temp as Array);
				}
				if(childrenList)
				{
					if(childrenList.length > 0)
					{
						if(index < feilds.length)
						{
							var data : ArrayCollection = group(child,feilds[index]);
							child.children = data;
							
							rollback(data,feilds,index);
						}
					}
				}
			}
			index--;
		}
		
		if(feilds.length > 0)
		{
			var list : ArrayCollection = group(source,feilds[0]);
			rollback(list,feilds,0);
			return list;
		}
		
		return null;			
		
	}
	
	/**
	 * 
	 * 反序
	 *  
	 * @param source
	 * @return 
	 * 
	 */	
	public static function reverse(source : Object,callback : Function = null) : ArrayCollection
	{
		var list :ICollectionView = format(source);
		var reversList : ArrayCollection = new ArrayCollection();
		var cursor  : IViewCursor = list.createCursor();
		cursor.seek(CursorBookmark.LAST);
		while(!cursor.beforeFirst)
		{
			var item : Object = cursor.current;
			reversList.addItem(item);
			cursor.movePrevious();
			
			if(callback != null)
			   callback(item);
			
		}
		
		return reversList;
	}
	
	
	public static function format(value : *) : ICollectionView
	{
		var _rootModel :ICollectionView;

		if (typeof(value)=="string")
			value = new XML(value);
		else if (value is XML)
			value = new XML(XML(value).toString());
		else if (value is XMLList)
			value = new XMLListCollection(value as XMLList);
		
		if (value is XML)
		{
			var xl:XMLList = new XMLList();
			xl += value;
			_rootModel = new XMLListCollection(xl);
		}
		else if (value is ICollectionView)
		{
			_rootModel = ICollectionView(value);
		}
		else if (value is Array)
		{
			_rootModel = new ArrayCollection(value as Array);
		}
		else if (value is Object)
		{
			var tmp:Array = [];
			tmp.push(value);
			_rootModel = new ArrayCollection(tmp);
		}
		else
		{
			_rootModel = new ArrayCollection();
		}	
		
		return _rootModel;
	}
}
}














































