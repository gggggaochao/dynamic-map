package com.struts.utils
{
	import mx.utils.ColorUtil;

public class ColorUtil
{

	public static function RGB(r : int = 255,g : int = 255,b : int = 255) : uint
	{
//		var rs : String = r.toString(16).toUpperCase();
//		var gs : String = g.toString(16).toUpperCase();
//		var bs : String = b.toString(16).toUpperCase();
//		
//		rs = rs.length > 1 ? rs : "0" + rs;
//		gs = gs.length > 1 ? gs : "0" + gs;
//		bs = bs.length > 1 ? bs : "0" + bs;
//		
//		var color : String = "0x" + rs + gs + bs;
		return r << 16 | g << 8 | b << 0;
		//return uint(color);
	}
	
}
}