package com.struts.components
{

import com.struts.skins.spark.PagerNetSkin;
import com.struts.skins.spark.pagers.PagerNextSkin;
import com.struts.utils.ArrayUtil;

import flash.events.Event;
import flash.events.MouseEvent;

import mx.collections.ArrayCollection;
import mx.collections.ICollectionView;
import mx.collections.IList;
import mx.collections.IViewCursor;
import mx.collections.ListCollectionView;
import mx.collections.XMLListCollection;
import mx.events.ListEvent;

import spark.components.Button;
import spark.components.ButtonBar;
import spark.components.DataGroup;
import spark.components.Group;
import spark.components.HGroup;
import spark.components.Label;
import spark.components.SkinnableContainer;
import spark.components.TextInput;
import spark.layouts.HorizontalAlign;
import spark.layouts.VerticalAlign;
import spark.primitives.Rect;
import spark.skins.spark.ButtonSkin;

/**
 *   窗体标题栏的颜色渐变
 */
[Style(name="headerColors", type="Array", arrayType="uint",format="Color", inherit="yes", theme="spark, mobile")]



/**
 *   窗体圆角的度数 
 */
[Style(name="cornerRadius", type="Number", format="Length", inherit="no", theme="spark", minValue="0.0")]


public class PagerNet extends SkinnableContainer
{
	
	[SkinPart(required="false")]
	public var fill : Rect;
	
	[SkinPart(required="false")]
	public var pagerGroup : Group;
	
	[SkinPart(required="false")]
	public var header:Group;
	
	[SkinPart(required="false")]
	public var nextButton: Button;
	
	[SkinPart(required="false")]
	public var parButton : Button;
	
	[SkinPart(required="false")]
	public var sumDisplayLabel: Label;
	
	[SkinPart(required="false")]
	public var pageDisplayLabel: Label;
	
	[SkinPart(required="false")]
	public var pageNumTextInput: TextInput;
	
	[SkinPart(required="false")]
	public var pageButtonBar: ButtonBar;
	
	public function PagerNet()
	{
		super();
	}
	
	private var _dataProvider : Object;
	
	private var _dataProviderChange : Boolean = false;
	
	public function get dataProvider():Object
	{
		return _dataProvider;
	}
	
	public function set dataProvider(value:Object):void
	{
		if(_dataProvider == value)
			return;
		
		_dataProvider = value;
		_dataProviderChange = true;
		
		//this.invalidateProperties();
		formatDataProvider(value);
	}
	
	
	
	private var _currPage : Number = 1;
	
	/**
	 *  当前页数
	 * */
	public function get currPage():Number
	{
		return _currPage;
	}
	
	/**
	 * @private
	 */
	public function set currPage(value:Number):void
	{
		_currPage = value;
		
		setPageDisplayLabel();

	}
	
	/**
	 *  总记录数
	 * 
	 * */
	private var _count : Number = 0;

	public function get count():Number
	{
		return _count;
	}

	public function set count(value:Number):void
	{
		_count = value;
		
		setPageDisplayLabel();

	}
	private var _showPageNum : Number = 10;

	/**
	 *  每页可显示的页码数
	 * */
	public function get showPageNum():Number
	{
		return _showPageNum;
	}

	/**
	 * @private
	 */
	public function set showPageNum(value:Number):void
	{
		_showPageNum = value;

	}

	private var pageNumData : Array;
	
	private var _sumPage : Number;
	
	/**
	 * 	总页数
	 * */
	public function get sumPage():Number
	{
		return _sumPage;
	}
	
	/**
	 * @private
	 */
	public function set sumPage(value:Number):void
	{
		_sumPage = value;
		
		setPageDisplayLabel();
	}
	
	
	private var _pageSize : Number = 15;

	/**
	 *  每页数据数
	 * 
	 * */
	public function get pageSize():Number
	{
		return _pageSize;
	}

	/**
	 * @private
	 */
	public function set pageSize(value:Number):void
	{
		_pageSize = value;

	}
	
	
	private var _bindComponents : Object;
	
	public function get bindComponents():Object
	{
		return _bindComponents;
	}
	
	public function set bindComponents(value:Object):void
	{
		_bindComponents = value;
		
		
		//dataSource = value["dataProvider"];
	}
	
	private var collection : ICollectionView;
	
	private function formatDataProvider(value : Object) : void
	{
		collection = ArrayUtil.format(value);
		
		if(!collection)
			return;
		
		count = collection.length;
		currPage = 1;
		refrushPage();
		
		this.invalidateProperties();
	}
	
	private function refrushPage() : void
	{
		try
		{
			if(bindComponents)
			{
				var currCollection : ICollectionView;
				if(collection is XMLListCollection)
				{
					currCollection = new XMLListCollection();
				}
				else if(collection is ArrayCollection)
				{
					currCollection = new ArrayCollection();
				}
				
				if(!currCollection)
					return;
				
				var viewCursor : IViewCursor = currCollection.createCursor(); 
				
				var dataCursor : IViewCursor = collection.createCursor();
				
				var i : Number = 0;
				
				

				while(!dataCursor.afterLast)
				{
					if ((currPage * pageSize - 1) >= i && ((currPage - 1) * pageSize <= i))
					{
						viewCursor.insert(dataCursor.current);
					}
					i++;
					dataCursor.moveNext();
				}
				
				bindComponents["dataProvider"] = currCollection;
			}
		}
		catch(error : Error)
		{
			trace("PagerNet:"+error.toString())
		}

	}
	
	
	/**
	 *  下页数据 
	 * 
	 * */
	private function setNextPage(event : Event) : void
	{
		if(currPage >= sumPage) return;
		currPage++;						
		selectedCurrPageNum();
		refrushPage();
	}
	
	private function setCurrPage(event : Event) : void
	{
		currPage = pageButtonBar.selectedItem as Number;
		refrushPage();
	}
	
	private function setParPage(event : Event) : void
	{
		if(currPage <= 1) return;
		currPage--;		
		selectedCurrPageNum();
		refrushPage();
	}	
	
	
	private function setPageDisplayLabel() : void
	{
		
		if(pageDisplayLabel)
		{
			pageDisplayLabel.text = _currPage + "/"+ _sumPage + "页";
		}			
		
		if(sumDisplayLabel)
		{
			sumDisplayLabel.text = "共" + _count + "条";
		}
	}
	
	/**
	 *  选中当前页码编号
	 * 
	 * */
	
	private var pageCurrNum : Number = 0;
	
	private function selectedCurrPageNum() : void
	{
		
		if(pageButtonBar)
		{
			var pagesNum : Number = Math.floor(currPage / showPageNum);;
			if(currPage % showPageNum != 0)
			{
				if(pageCurrNum != pagesNum)
				{
					pageCurrNum = pagesNum;
					pageButtonBar.dataProvider = new ArrayCollection(pageNumList[pageCurrNum]);	
				}
			}
			else
			{
				pageCurrNum = pagesNum > 0 ? pagesNum - 1 : pagesNum;
				pageButtonBar.dataProvider = new ArrayCollection(pageNumList[pageCurrNum]);	
			}

			var selectedIndex : Number = currPage % showPageNum != 0 ? 
										 currPage % showPageNum : showPageNum;
			pageButtonBar.selectedIndex = selectedIndex - 1;
		}
	}
	
	private var pageNumList : Array;
	
	protected override function commitProperties():void
	{
		super.commitProperties();

		if(_dataProviderChange)
		{
			_dataProviderChange = false;
			
			sumPage = count % _pageSize == 0 ? 
					  Math.floor(count / _pageSize) 
					  : 
					  Math.floor(count / _pageSize ) + 1;
		
			if(pageButtonBar)
			{
				pageNumList = [];
	
				var numPages : Number = _sumPage % showPageNum == 0 ? 
												Math.floor(_sumPage / showPageNum) 
												: 
												Math.floor(_sumPage / showPageNum ) + 1;
				
				for (var i:int=0;i<numPages;i++)
				{
					var countPage : int = i!=numPages-1 ? showPageNum : _sumPage % showPageNum;
					var pageNumData : Array = [];
					for (var j:int = 1; j<= countPage; j++)
					{
						var num : Number = i * showPageNum + j;
						pageNumData.push(num);		
					}
					pageNumList.push(pageNumData);
				}
				
				pageButtonBar.dataProvider = new ArrayCollection(pageNumList[pageCurrNum]);	
				pageButtonBar.selectedIndex = 0;
			}
		}
	}
	
	protected override function partAdded(partName:String, instance:Object):void
	{
		super.partAdded(partName, instance);
		
		if(instance == nextButton)
		{
			nextButton.addEventListener(MouseEvent.CLICK,setNextPage);
		}
		
		if(instance == parButton)
		{
			parButton.addEventListener(MouseEvent.CLICK,setParPage);
		}
		
		if(instance == pageButtonBar)
		{
			pageButtonBar.addEventListener(ListEvent.CHANGE,setCurrPage);
		}
		
	}

	
}
}