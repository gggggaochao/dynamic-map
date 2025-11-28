package com.spring.utils
{
	
import mx.utils.StringUtil;

public class ExcelXMLUtils
{
	
	public static function converToArray(doc : XML,isFilterFirst : Boolean = true) : Array
	{
		
		namespace sheet = "urn:schemas-microsoft-com:office:spreadsheet";
		use namespace sheet;

		
		var datas : Array = new Array();
		
		var tablesNode : XML = doc.sheet::Worksheet.Table[0];
		
		var rows : XMLList = tablesNode.Row;
		var colCount : Number = Number(tablesNode.@ExpandedColumnCount);
		
		var count : int = rows.length();
		var index : int = isFilterFirst ? 1 : 0;
		
		var dataNode : XML;
		var cellNode : XML;
		var cells : XMLList;
		var parameters : Array;
		
		var sql : String;
		
		var cellIndex : int = 0;
		var currentIndex : int = 0;
		var nullArrays : int;
		var nullIndex : int;
		for (index;index < count;index ++ )
		{
			cells = rows[index].Cell;
			parameters = new Array();
			cellIndex = 0;
			for (var j : int = 0;j < cells.length();j++)
			{
				cellIndex++;
				
				cellNode = cells[j];
				currentIndex = Number(cellNode.@Index) || -1;
				
				if(currentIndex > cellIndex)
				{
					nullArrays = currentIndex - cellIndex;
					
					for (nullIndex = 0;nullIndex<nullArrays;nullIndex++)
						parameters.push(null);
					
				}
				
				dataNode = cellNode.Data[0];
				parameters.push(dataNode.toString())
			}

			var parameterCount : int = parameters.length;

			if(colCount > parameterCount)
			{
				nullArrays = colCount - parameterCount;
				
				for (nullIndex = 0;nullIndex<nullArrays;nullIndex++)
					parameters.push(null);				
			}
			
			datas.push(parameters);
		}
		
		return datas;
		
	}
}
}







