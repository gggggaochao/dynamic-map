package com.struts.entity
{
public class LunarElement
{
	public var isToday : Boolean    = false;  
	//瓣句  
	public var sYear : int;   //公元年4位数字  
	public var sMonth : int;  //公元月数字  
	public var sDay : int;    //公元日数字  
	public var week : int;    //星期, 1个中文  
	//农历  
	public var lYear : int;   //公元年4位数字  
	public var lMonth : int;  //农历月数字  
	public var lDay : int;    //农历日数字  
	public var isLeap  : Boolean;  //是否为农历闰月?  
	//八字  
	public var cYear  : String;   //年柱, 2个中文  
	public var cMonth   : String;  //月柱, 2个中文  
	public var cDay  : String;    //日柱, 2个中文  
	
	public var color : String;  
	
	public var lunarYear : String;
	public var lunarDay : String;
	public var lunarMonth : String;
	
	public var lunarFestival : String; //农历节日  
	
	public var solarFestival : String; //公历节日  
	public var solarTerms : String; //节气  
	
	
	
	public function LunarElement(sYear:int,sMonth:int,sDay:int,week:int,
								 lYear:int,lMonth:int,lDay:int,
								 isLeap:Boolean,
								 cYear:String,cMonth:String,cDay:String)
	{
		this.isToday    = false;  
		//瓣句  
		this.sYear      = sYear;   //公元年4位数字  
		this.sMonth     = sMonth;  //公元月数字  
		this.sDay       = sDay;    //公元日数字  
		this.week       = week;    //星期, 1个中文  
		//农历  
		this.lYear      = lYear;   //公元年4位数字  
		this.lMonth     = lMonth;  //农历月数字  
		this.lDay       = lDay;    //农历日数字  
		this.isLeap     = isLeap;  //是否为农历闰月?  
		//八字  
		this.cYear      = cYear;   //年柱, 2个中文  
		this.cMonth     = cMonth;  //月柱, 2个中文  
		this.cDay       = cDay;    //日柱, 2个中文  
		
		this.color      = '';  
		
		this.lunarFestival = ''; //农历节日  
		this.solarFestival = ''; //公历节日  
		this.solarTerms    = ''; //节气  		
	}
}
}






