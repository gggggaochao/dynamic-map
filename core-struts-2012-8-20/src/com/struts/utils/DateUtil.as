package com.struts.utils
{

import com.struts.entity.LunarElement;

import spark.formatters.DateTimeFormatter;

public class DateUtil
{
	private static const lunarInfo : Array = new Array(  
		0x04bd8,0x04ae0,0x0a570,0x054d5,0x0d260,0x0d950,0x16554,0x056a0,0x09ad0,0x055d2,  
		0x04ae0,0x0a5b6,0x0a4d0,0x0d250,0x1d255,0x0b540,0x0d6a0,0x0ada2,0x095b0,0x14977,  
		0x04970,0x0a4b0,0x0b4b5,0x06a50,0x06d40,0x1ab54,0x02b60,0x09570,0x052f2,0x04970,  
		0x06566,0x0d4a0,0x0ea50,0x06e95,0x05ad0,0x02b60,0x186e3,0x092e0,0x1c8d7,0x0c950,  
		0x0d4a0,0x1d8a6,0x0b550,0x056a0,0x1a5b4,0x025d0,0x092d0,0x0d2b2,0x0a950,0x0b557,  
		0x06ca0,0x0b550,0x15355,0x04da0,0x0a5b0,0x14573,0x052b0,0x0a9a8,0x0e950,0x06aa0,  
		0x0aea6,0x0ab50,0x04b60,0x0aae4,0x0a570,0x05260,0x0f263,0x0d950,0x05b57,0x056a0,  
		0x096d0,0x04dd5,0x04ad0,0x0a4d0,0x0d4d4,0x0d250,0x0d558,0x0b540,0x0b6a0,0x195a6,  
		0x095b0,0x049b0,0x0a974,0x0a4b0,0x0b27a,0x06a50,0x06d40,0x0af46,0x0ab60,0x09570,  
		0x04af5,0x04970,0x064b0,0x074a3,0x0ea50,0x06b58,0x055c0,0x0ab60,0x096d5,0x092e0,  
		0x0c960,0x0d954,0x0d4a0,0x0da50,0x07552,0x056a0,0x0abb7,0x025d0,0x092d0,0x0cab5,  
		0x0a950,0x0b4a0,0x0baa4,0x0ad50,0x055d9,0x04ba0,0x0a5b0,0x15176,0x052b0,0x0a930,  
		0x07954,0x06aa0,0x0ad50,0x05b52,0x04b60,0x0a6e6,0x0a4e0,0x0d260,0x0ea65,0x0d530,  
		0x05aa0,0x076a3,0x096d0,0x04bd7,0x04ad0,0x0a4d0,0x1d0b6,0x0d250,0x0d520,0x0dd45,  
		0x0b5a0,0x056d0,0x055b2,0x049b0,0x0a577,0x0a4b0,0x0aa50,0x1b255,0x06d20,0x0ada0,  
		0x14b63); 
	
	 
	private static const Gan  : Array=new Array("甲","乙","丙","丁","戊","己","庚","辛","壬","癸");  
	private static const Zhi : Array=new Array("子","丑","寅","卯","辰","巳","午","未","申","酉","戌","亥");  
	private static const Animals : Array=new Array("鼠","牛","虎","兔","龙","蛇","马","羊","猴","鸡","狗","猪");  
	private static const solarTerm : Array = new Array("小寒","大寒","立春","雨水","惊蛰","春分","清明","谷雨","立夏","小满","芒种","夏至","小暑","大暑","立秋","处暑","白露","秋分","寒露","霜降","立冬","小雪","大雪","冬至");  
	private static const sTermInfo : Array = new Array(0,21208,42467,63836,85337,107014,128867,150921,173149,195551,218072,240693,263343,285989,308563,331033,353350,375494,397447,419210,440795,462224,483532,504758);  
	private static const nStr1 : Array = new Array('日','一','二','三','四','五','六','七','八','九','十');  
	private static const nStr2 : Array = new Array('初','十','廿','卅','□');  
	private static const monthName : Array = new Array("JAN","FEB","MAR","APR","MAY","JUN","JUL","AUG","SEP","OCT","NOV","DEC");  
	
	public static const MOUTHS : Array = new Array('一月','二月','三月','四月','五月','六月','七月','八月','九月','十月','十一月','十二月');
	public static const WEEKS : Array = new Array("星期日", "星期一", "星期二", "星期三", "星期四", "星期五", "星期六");
	public static const SOLAR_MONTH : Array=new Array(31,28,31,30,31,30,31,31,30,31,30,31); 
	//国历节日 *表示放假日  
	private static const sFtv : Array = new Array(  
		"0101*元旦节",  
		"0202 世界湿地日",  
		"0210 国际气象节",  
		"0214 情人节",  
		"0301 国际海豹日",  
		"0303 全国爱耳日",  
		"0305 学雷锋纪念日",  
		"0308 妇女节",  
		"0312 植树节 孙中山逝世纪念日",  
		"0314 国际警察日",  
		"0315 消费者权益日",  
		"0317 中国国医节 国际航海日",  
		"0321 世界森林日 消除种族歧视国际日 世界儿歌日",  
		"0322 世界水日",  
		"0323 世界气象日",  
		"0324 世界防治结核病日",  
		"0325 全国中小学生安全教育日",  
		"0330 巴勒斯坦国土日",  
		"0401 愚人节 全国爱国卫生运动月(四月) 税收宣传月(四月)",  
		"0407 世界卫生日",  
		"0422 世界地球日",  
		"0423 世界图书和版权日",  
		"0424 亚非新闻工作者日",  
		"0501*劳动节",  
		"0502*劳动节假日",  
		"0503*劳动节假日",  
		"0504 青年节",  
		"0505 碘缺乏病防治日",  
		"0508 世界红十字日",  
		"0512 国际护士节",  
		"0515 国际家庭日",  
		"0517 国际电信日",  
		"0518 国际博物馆日",  
		"0520 全国学生营养日",  
		"0523 国际牛奶日",  
		"0531 世界无烟日",   
		"0601 国际儿童节",  
		"0605 世界环境保护日",  
		"0606 全国爱眼日",  
		"0617 防治荒漠化和干旱日",  
		"0623 国际奥林匹克日",  
		"0625 全国土地日",  
		"0626 国际禁毒日",  
		"0701 香港回归纪念日 中共诞辰 世界建筑日",  
		"0702 国际体育记者日",  
		"0707 抗日战争纪念日",  
		"0711 世界人口日",  
		"0730 非洲妇女日",  
		"0801 建军节",  
		"0808 中国男子节(爸爸节)",  
		"0815 抗日战争胜利纪念",  
		"0908 国际扫盲日 国际新闻工作者日",  
		"0909 毛逝世纪念",  
		"0910 中国教师节",   
		"0914 世界清洁地球日",  
		"0916 国际臭氧层保护日",  
		"0918 九·一八事变纪念日",  
		"0920 国际爱牙日",  
		"0927 世界旅游日",  
		"0928 孔子诞辰",  
		"1001*国庆节 世界音乐日 国际老人节",  
		"1002*国庆节假日 国际和平与民主自由斗争日",  
		"1003*国庆节假日",  
		"1004 世界动物日",  
		"1006 老人节",  
		"1008 全国高血压日 世界视觉日",  
		"1009 世界邮政日 万国邮联日",  
		"1010 辛亥革命纪念日 世界精神卫生日",  
		"1013 世界保健日 国际教师节",  
		"1014 世界标准日",  
		"1015 国际盲人节(白手杖节)",  
		"1016 世界粮食日",  
		"1017 世界消除贫困日",  
		"1022 世界传统医药日",  
		"1024 联合国日",  
		"1031 世界勤俭日",  
		"1107 十月社会主义革命纪念日",  
		"1108 中国记者日",  
		"1109 全国消防安全宣传教育日",  
		"1110 世界青年节",  
		"1111 国际科学与和平周(本日所属的一周)",  
		"1112 孙中山诞辰纪念日",  
		"1114 世界糖尿病日",  
		"1117 国际大学生节 世界学生节",  
		"1120*彝族年",  
		"1121*彝族年 世界问候日 世界电视日",  
		"1122*彝族年",  
		"1129 国际声援巴勒斯坦人民国际日",  
		"1201 世界艾滋病日",  
		"1203 世界残疾人日",  
		"1205 国际经济和社会发展志愿人员日",  
		"1208 国际儿童电视日",  
		"1209 世界足球日",  
		"1210 世界人权日",  
		"1212 西安事变纪念日",  
		"1213 南京大屠杀(1937年)纪念日！紧记血泪史！",  
		"1220 澳门回归纪念",  
		"1221 国际篮球日",  
		"1224 平安夜",  
		"1225 圣诞节",  
		"1226 毛诞辰纪念")  
	
	//农历节日 *表示放假日  
	private static const lFtv : Array = new Array(  
		"0101*春节",  
		"0102*初二",  
		"0103*初三",  
		"0115 元宵节",  
		"0505 端午节",  
		"0707 七夕情人节",  
		"0715 中元节",  
		"0815 中秋节",  
		"0909 重阳节",  
		"1208 腊八节",  
		"1223 小年",  
		"0100 除夕");  
	
	//某月的第几个星期几  
	private static const wFtv : Array = new Array(  
		"0150 世界麻风日", //一月的最后一个星期日（月倒数第一个星期日）  
		"0520 国际母亲节",  
		"0530 全国助残日",  
		"0630 父亲节",  
		"0730 被奴役国家周",  
		"0932 国际和平日",  
		"0940 国际聋人节 世界儿童日",  
		"0950 世界海事日",  
		"1011 国际住房日",  
		"1013 国际减轻自然灾害日(减灾日)",  
		"1144 感恩节"); 	
	
	
	/*****************************************************************************  
	 日期计算  
	 *****************************************************************************/  

	/**
	 * 
	 * 返回农历 y年的总天数  
	 * 
	 * */ 
	private static function lYearDays(y:Number) : Number 
	{  
		var i : int, sum : int = 348;  
		for(i=0x8000; i>0x8; i>>=1) sum += (lunarInfo[y-1900] & i)? 1: 0;  
		return(sum+leapDays(y));  
	}  
	
	/**
	 * 
	 * 返回农历 y年闰月的天数
	 * 
	 * */  
	private static function leapDays(y:Number) : Number 
	{  
		if(leapMonth(y))  return((lunarInfo[y-1900] & 0x10000)? 30: 29);  
		else return(0);  
	}  

	
	/**
	 * 
	 * 返回农历 y年闰哪个月 1-12 , 没闰返回 0 
	 * 
	 * */ 
	private static function leapMonth(y:Number) : Number  
	{  
		return(lunarInfo[y-1900] & 0xf);  
	}  
	
	/**
	 * 
	 * 返回农历 y年m月的总天数  
	 * 
	 * */ 
	private static function monthDays(y:Number,m:Number) : Number  
	{  
		return( (lunarInfo[y-1900] & (0x10000>>m))? 30: 29 );  
	}  	
	
	/**
	 * 
	 * 返回公历 y年某m+1月的天数  
	 * 
	 * */
	public static function solarDays(y : Number,m : Number) : Number {  
		if(m==1)  
			return(((y%4 == 0) && (y%100 != 0) || (y%400 == 0))? 29 : 28);  
		else  
			return(SOLAR_MONTH[m]);  
	}  
	
	/**
	 * 
	 * 传入 offset 返回干支, 0=甲子  
	 * 
	 * */	
	private static function cyclical(num : Number) : String {  
		return(Gan[num%10]+Zhi[num%12]);  
	} 
	
	
	/**
	 * 
	 * 返回当月「节」为几日开始  
	 * 
	 * */
	private static function sTerm(y : Number,n : Number) : Number 
	{  
		var offDate : Date = new Date( ( 31556925974.7*(y-1900) + sTermInfo[n]*60000  ) + Date.UTC(1900,0,6,2,5) );  
		return(offDate.getUTCDate());  
	}  
	
	private static function cDay(d : Number) : String
	{  
		var s : String = "";  
		
		switch (d) {  
			case 10:  
				s = '初十'; break;  
			case 20:  
				s = '二十'; break;   
			case 30:  
				s = '三十'; break;  
			default :  
				s = nStr2[Math.floor(d/10)];  
				s += nStr1[d%10];  
		}  
		return(s);  
	}
	
	private static function cMonth(m : Number) : String
	{
		var s : String = "";
		
		switch (m) {  
			case 1:
				s = "正";break;
			case 11:  
				s = "冬"; break;  
			case 12:  
				s = "腊"; break;  
			default :  
				s = nStr1[m];   
		} 		
		return s;
	}
	
	
	/**
	 *   格式化 公历  为 农历
	 * 
	 * */
	public static function formatLunar(date : Date) : *
	{
		var i:int,leap:int = 0,temp:int = 0;
		
		var offset : Number = (Date.UTC(date.getFullYear(),date.getMonth(),date.getDate()) - Date.UTC(1900,0,31))/86400000;
		
		for(i=1900; i<2050 && offset>0; i++) { temp = lYearDays(i); offset-=temp; }  
		
		if(offset<0) { offset+=temp; i--; } 
		
		var _year : Number = i;
		var _isLeap : Boolean = false;
		
		leap = leapMonth(i); 
		
		for(i=1; i<13 && offset>0; i++) {  
			/** 闰月   */  
			if(leap>0 && i==(leap+1) && _isLeap==false)  
			{ --i; _isLeap = true; temp = leapDays(_year); }  
			else  
			{ temp = monthDays(_year, i); }  

			/** 解除闰月   */
			if(_isLeap == true && i==(leap+1)) _isLeap = false;  
			
			offset -= temp;  
		}  
		
		if(offset==0 && leap>0 && i==leap+1)  
		{
			if(_isLeap)  
			{ _isLeap = false; }  
			else  
			{ _isLeap = true; --i; }  
		}
		
		if(offset<0){ offset += temp; --i; } 
		
		var _month : Number = i;  
		var _day : Number = offset + 1;  
		
		return {
			year : _year,
			month : _month,
			day : _day,
			isLeap : _isLeap
		};
	}
	
	public static function lunarCalendar(y : Number,m : Number) : Array 
	{  
		var results : Array = [];	
		var sDObj : Date, lDObj : Object;
		var lY : Number, lM: Number, lD: Number=1, lL : Boolean, lX : Number =0;
		var tmp1 : Number, tmp2 : Number, tmp3: Number;  
		var cY : String, cM  : String, cD  : String; //年柱,月柱,日柱  
		var lDPOS : Array = new Array(3);  
		var n : Number = 0;  
		var firstLM : Number = 0;  

		var todayDate : Date = new Date();
		
		function pushLunarElement(i:int,ele : LunarElement) : void
		{
			results[i] = ele;
		}
		
		function getLunarElement(i:int) : LunarElement
		{
			return results[i] as LunarElement;
		}

		/**
		 *  当月一日日期  
		 * */
		sDObj = new Date(y,m,1,0,0,0,0);    
		
		var length : Number    = solarDays(y,m);    //公历当月天数  
		var firstWeek : Number = sDObj.getDay();    //公历当月1日星期几  
		var firstNode : Number = sTerm(y,m*2) //返回当月「节」为几日开始  
		/**
		 * 
		 * 年柱 1900年立春后为庚子年(60进制36) 
		 * 
		 * */ 
		if(m<2) 
			cY=cyclical(y-1900+36-1);  
		else 
			cY=cyclical(y-1900+36); 
		
		/**
		 * 立春日期  
		 * */
		var term2 : Number =sTerm(y,2);
		
		/**
		 * 
		 * 月柱 1900年1月小寒以前为 丙子月(60进制12)  
		 * 
		 * */
		cM = cyclical((y-1900)*12+m+12);  
		
		/**
		 * 
		 * 当月一日与 1900/1/1 相差天数  
		 * 1900/1/1与 1970/1/1 相差25567日, 1900/1/1 日柱为甲戌日(60进制10) 
		 * 
		 * */
		var dayCyclical : Number = Date.UTC(y,m,1,0,0,0,0)/86400000+25567+10;  
		var ele : LunarElement;
		
		for(var i : int = 0;i<length;i++) 
		{  
			
			if(lD>lX) 
			{  
				sDObj = new Date(y,m,i+1);    //当月一日日期  
				/** 
				 * 
				 * 格式化公历为农历   
				 * 
				 * */ 
				lDObj = formatLunar(sDObj);  
				lY    = lDObj.year;           
				lM    = lDObj.month;          
				lD    = lDObj.day;              
				lL    = lDObj.isLeap;         
				lX    = lL? leapDays(lY): monthDays(lY,lM); 
				
				if(n==0) firstLM = lM;  
				lDPOS[n++] = i-lD+1;  
			}  
			
			/**
			 * 
			 * 依节气调整二月分的年柱, 以立春为界  
			 * 
			 * */
			if(m==1 && (i+1)==term2) cY=cyclical(y-1900+36);  
			
			/**
			 * 
			 * 依节气月柱, 以「节」为界   
			 * 
			 * */
			if((i+1)==firstNode) cM = cyclical((y-1900)*12+m+13);  
			
			/**
			 * 
			 * 日柱 
			 * 
			 * */
			cD = cyclical(dayCyclical+i); 
			
			var s : String = cY.charAt(1);
			var indexYear : int = Zhi.indexOf(s);
			
			 
			
			/**
			 * 
			 * 创建农历对象
			 * 
			 * */
			ele = new LunarElement(y, m+1, i+1, nStr1[(i+firstWeek)%7],
										lY, lM, lD++, lL,  
											cY ,cM, cD );  
			ele.lunarYear = Animals[indexYear];
			ele.lunarMonth = cMonth(ele.lMonth);
			ele.lunarDay = cDay(ele.lDay);
			
			pushLunarElement(i,ele);
		}  

		/**
		 * 
		 * 节气 
		 * 
		 * */ 
		tmp1=sTerm(y,m*2  )-1;  
		tmp2=sTerm(y,m*2+1)-1;  
		getLunarElement(tmp1).solarTerms = solarTerm[m*2];  
		getLunarElement(tmp2).solarTerms = solarTerm[m*2+1];  
		if(m==3) getLunarElement(tmp1).color = 'red'; //清明颜色  

		var pattern : RegExp = /^(\d{2})(\d{2})([\s\*])(.+)$/;
		var result : Array;
		var str : String;
		
		/**
		 * 
		 * 公历节日  
		 * 
		 * */		
		for each(str in sFtv)  
		{
			if(pattern.test(str))
			{
				result = pattern.exec(str);
				if(Number(result[1])==(m+1)) 
				{  
					getLunarElement(Number(result[2])-1).solarFestival += result[4] + ' ';  
					if(result[3]=='*') getLunarElement(Number(result[2])-1).color = 'red';  
				}  
			}
		}

		/**
		 * 
		 * 月周节日  
		 * 
		 * */
		pattern  = /^(\d{2})(\d)(\d)([\s\*])(.+)$/;
		for each(str in wFtv)  
		{
			if(pattern.test(str))
			{
				result = pattern.exec(str);
				if(Number(result[1])==(m+1)) {  
					tmp1=Number(result[2]); //每月周次 
					tmp2=Number(result[3]); //星期几 
					if(tmp1<5)  
						getLunarElement(((firstWeek>tmp2)?7:0) + 7*(tmp1-1) + tmp2 - firstWeek).solarFestival += result[5] + ' ';  
					else {  
						tmp1 -= 5;  
						tmp3 = (firstWeek+length-1)%7; //当月最后一天星期?  
						getLunarElement(length - tmp3 - 7*tmp1 + tmp2 - (tmp2>tmp3?7:0) - 1 ).solarFestival += result[5] + ' ';  
					}  
				}  
			}
		}
		
		/**
		 * 
		 * 农历节日
		 * 
		 * */  
		pattern  = /^(\d{2})(.{2})([\s\*])(.+)$/;
		for each(str in lFtv)  
		{
			if(pattern.test(str))
			{  
				result = pattern.exec(str);
				tmp1=Number(result[1])-firstLM;  
				if(tmp1==-11) tmp1=1;  
				if(tmp1 >=0 && tmp1<n) {  
					tmp2 = lDPOS[tmp1] + Number(result[2]) -1;  
					if( tmp2 >= 0 && tmp2< length && getLunarElement(tmp2).isLeap!=true) 
					{  
						getLunarElement(tmp2).lunarFestival += result[4] + ' ';  
						if(result[3] =='*') getLunarElement(tmp2).color = 'red';  
					}  
				}  
			}  
		}		
		
		/**
		 * 
		 * 今日
		 * 
		 * */
		if(y == todayDate.getFullYear() && m == todayDate.getMonth())
			getLunarElement(todayDate.getDate()-1).isToday = true; 
		
//		//复活节只出现在3或4月  
//		if(m==2 || m==3) {  
//			var estDay = new easter(y);  
//			if(m == estDay.m)  
//				this[estDay.d-1].solarFestival = this[estDay.d-1].solarFestival+' 复活节 Easter Sunday';  
//		}  
//		
//		
//		if(m==2) this[20].solarFestival = this[20].solarFestival+unescape('%20%u6D35%u8CE2%u751F%u65E5');  
//		
//		//黑色星期五  
//		if((this.firstWeek+12)%7==5)  
//			this[12].solarFestival += '黑色星期五';  
//		
		

		
		return results;
	}  	
	
	
	
	/**==================================================
	 *  格式化时间 String 
	 *  参 数 ： 时间  String
	 *  返 回 ： Date
	 ====================================================*/ 	
	public static function stringToDate(dateString:String):Date 
	{ 
		if ( dateString == null ) { 
			return null; 
		} 
		
		if ( dateString.indexOf("0000-00-00") != -1 ) { 
			return null; 
		} 
		
		dateString = dateString.split("-").join("/"); 
		
		return new Date(Date.parse(dateString)); 
	}
	
	public static  function dateToString(date : Date,format : String = "yyyy-MM-dd HH:mm:ss") : String
	{ 
		var stf : DateTimeFormatter = new DateTimeFormatter();
		stf.dateTimePattern = format; 
		return stf.format(date); 
	}
	
	
	public static function numberToString(number : Number) : String
	{
		if(!isNaN(number))
		{
			var mydate :Date = new Date(number * 1000)
			return dateToString(mydate);
		}
		
		return null;
	}
	
	public static function singleDayToString(number : Number) : String
	{
		if(!isNaN(number))
		{
			var h : int =  number / 3600;
			var m : int = (number % 3600) / 60;
			var s : int = (number % 3600) % 60;
			
			var _d : String = new String();
			
			if(h >= 24)
			{
				var d : int = h / 24;
				h = h % 24;
				_d = d +"D ";
			}
			
			var _h : String = h >= 10 ? h.toString() : "0"+h.toString();
			var _m : String = m >= 10 ? m.toString() : "0"+m.toString();
			var _s : String = s >= 10 ? s.toString() : "0"+s.toString();
			
			return _d + _h + ":" + _m + ":" + _s;
		}
		
		return null;
	}
	
	public static function stringToSingleDay(dateString : String) : Number
	{
		if(dateString)
		{
			var times : Array = dateString.split(":");
			var h : int = 0;
			var m : int = 0;
			var s : int = 0;	
			
			if(times.length == 3) {
				h = Number(times[0]) * 3600;
				m = Number(times[1]) * 60;
				s = Number(times[2]);	
			}
			else if(times.length == 2) {
				h = Number(times[0]) * 3600;
				m = Number(times[1]) * 60;				
			}
			else if(times.length == 1) {
				h = Number(times[0]) * 3600;
			}	
			return  h + m + s;
		}
		
		return 0;
	}
	
	public static function toNumber(dateString : String) : Number
	{
		if(dateString)
		{
			dateString = dateString.split("-").join("/");
			return Date.parse(dateString);
		}
		
		return NaN;
	}
	
	public static function toDate(timevalue : Number) : Date
	{
		
		var Hours:int =timevalue/(1000*60*60);
		var Minutes:int =(timevalue-(1000*60*60)*Hours)/1000*60;
		var Seconds:int =(timevalue-(1000*60*60*Hours)-(1000*60*Minutes))/1000;
		
		var d:Date=new Date();
		
		d.setHours(Number(Hours));
		d.setMinutes(Number(Minutes));
		d.setSeconds(Number(Seconds));
		return d;		
	}
	
	public static function dateRemove(datepart:String = "ss", number:Number = 0, date:Date = null) : Date
	{
		if (date == null) {
			date = new Date();
		}
		
		var returnDate:Date = new Date(date.time);
		var field : String = getDatePart(datepart);
		returnDate[field] -= number;
		return returnDate;
		
	}
	public static function dateAdd(datepart:String = "ss", number:Number = 0, date:Date = null):Date 
	{
		if (date == null) {
			date = new Date();
		}
		
		var returnDate:Date = new Date(date.time);
		var field : String = getDatePart(datepart);
		returnDate[field] += number;
		return returnDate;
	}
	
	private static function getDatePart(part : String = "ss") : String
	{
		switch (part.toUpperCase()) 
		{ 
			case "YY" : return  "fullyear";
			case "MM" : return  "month";
			case "DD" : return  "date";
			case "HH" : return  "hours";
			case "NN" : return  "minutes";
			case "SS" : return  "seconds";
			case "ML" : return  "milliseconds";
		}	
		
		return  "seconds"; 
	}
	
}
}