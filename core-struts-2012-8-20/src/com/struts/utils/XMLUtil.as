package com.struts.utils
{
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;
	
	public final class XMLUtil
	{
		public function XMLUtil(){	}


		/** =====================================================
		 * 删除指定所有节点
		 * */		
		public static function deleteNodeByIndex(xmlNode:XML,index:Number = -1): void
		{ 
			var children:XMLList = xmlNode.children();
			for(var i:int=0;i<children.length();i++) 
			{
				if(index >= 0)
				{
			        if(i == index) 
			        {
			          delete children[i];
			          break;
			        }
		  		}
		    }
		}

		/** =====================================================
		 * 删除所有节点
		 * */			 
		public static function deleteAllNode(xmlNode:XML): void
		{ 
			var children:XMLList = xmlNode.children();
			for(var i:int=0;i<children.length();) 
			{
		  	    delete children[i];
		    }
		}
				
		public static function getScalarXML(node : XML,
											name : String,
											attribute : String = null,
											value : String = null) : XML
		{
			if(node)
			{
				var nodeList : XMLList = node[name];
				if(attribute && value)
				{
					for each(var item : XML in nodeList)
					{
						if(item.@[attribute] == value)
						   return item;
					}
				}
				else
				{
					if(nodeList.length())
						return nodeList[0];				
				}

			}
			return null;
		}
		
		
		private static function formatNode(target : *) : XML
		{
			var _root : XML;
			
			if(target is XML){
				_root = target as XML 
			}else if(target is XMLList){
				var _rootList : XMLList = target as XMLList;
				_root =  _rootList[0];
			}
			
			return _root;			
		}
		
		
		private static function formatNodeList(target : *) : XMLList
		{
			var _root : XMLList;
			
			if(target is XML){
				_root = (target as XML).children(); 
			}else if(target is XMLList){
				_root = target as XMLList;
			}
			
			return _root;			
		}
		
		public static function toBean(target : *) : Object
		{
			var _root : XML = formatNode(target);
			
			var data :Object = {};
			
			if(_root)
			{
				for each(var val:XML in _root.children())
				{
					data[val.localName()] = val.toString();
				}
			}
			return data;		
		}
		
		public static function toString(target : *) : String
		{
			var _root : XML = formatNode(target);
			
			var data : String = "";
			if(_root)
			{
				data = _root.toString();
			}
			return data;		
		}
		
		
		public static function toAttribute(target : *) : Object
		{
			var _root : XML = formatNode(target);
			
			var data : Object = {};
			if(_root)
			{
				var protypes : XMLList = _root.attributes();
				var childrenNode : XMLList = _root.children();
				for each(var prop : XML in protypes)
				{
					var protype : String = prop.localName();
					var value : String = prop.toString();
					data[protype] = value;
				}  	
				
				if(childrenNode && childrenNode.length())
				{
					data.childrenNode = childrenNode;
				}
			}
			
			return data;
		}		
		
		
		/**
		 *   将XML格式数据转化成JSON格式，该方法只支持二级菜单
		 * 
		 *   @parame target  要转化的XML对象
		 *   @parame protype 赋值都对象的属性
		 *   @parame format  要转化的格式
		 * 
		 * */
		public static function toList(target : *,protype : String = null,format : String = "bean") : Array
		{
			var _array : Array = [];
			
			var _root : XMLList = formatNodeList(target);
			
			var getProtype : Function = function(item : XML,attribute : String) : Object
			{
				var _XMLList : XMLList = item[attribute];
				var _data : Object = {};
				
				if(_XMLList != null)
				{
					_XMLList = item.children();
				}
				
				if(_XMLList)
				{
					_data = format == "bean" ?  
						toAttribute(_XMLList)
						:
						toList(_XMLList);
				}
				
				
				return _data;
			}
			
			if(_root)
			{
				for each(var val:XML in _root)
				{
					var data : Object = toAttribute(val);
					if(protype)
					{
						data[protype] = getProtype(val,protype);
					}
					_array.push(data);
				}
			}
			return _array;		
		}			
		
	}
}








